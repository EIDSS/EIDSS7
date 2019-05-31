Imports System.Data.SqlClient
Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class ParameterTypeEditor
    Inherits BaseEidssPage

    Private oCommon As clsCommon = New clsCommon()
    Private CrossCuttingAppService As CrossCuttingServiceClient
    Private FlexibleFormServiceClient As FlexibleFormServiceClient
    Private Shared Log As log4net.ILog

    Public Property SortDirection() As SortDirection
        Get
            If ViewState("SortDirection") Is Nothing Then
                ViewState("SortDirection") = SortDirection.Ascending
            End If
            Return DirectCast(ViewState("SortDirection"), SortDirection)
        End Get
        Set(ByVal value As SortDirection)
            ViewState("SortDirection") = value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        hdfLangID.Value = PageLanguage
        If Not Page.IsPostBack Then
            'Load Reference Type List
            FillBaseReferenceList()
        End If
    End Sub

    Private Sub FillBaseReferenceList(Optional ByVal sortExpression As String = Nothing)
        Try
            Dim list As List(Of FfGetParameterReferenceTypeModel) = New List(Of FfGetParameterReferenceTypeModel)()

            If IsNothing(Session(CallerPages.FlexibleFormParameterReferenceType)) Then
                list = GetFlexibleParameterReferenceTypeList(Nothing, False)
            Else
                list = CType(Session(CallerPages.FlexibleFormParameterReferenceType), List(Of FfGetParameterReferenceTypeModel))
            End If

            If (Not (sortExpression) Is Nothing) Then
                If SortDirection = SortConstants.Ascending Then
                    list = list.OrderBy(Function(x) x.GetType().GetProperty(sortExpression).GetValue(x)).ToList()
                Else
                    list = list.OrderByDescending(Function(x) x.GetType().GetProperty(sortExpression).GetValue(x)).ToList()
                End If
            End If

            Session(CallerPages.FlexibleFormParameterReferenceType) = list
            'Populate grid with base reference values for selected base reference type
            gvAgeGroup.DataSource = list
            gvAgeGroup.DataBind()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Sub FillBaseReferenceList(ByVal searchString As String, Optional ByVal sortExpression As String = Nothing)
        Try

            If CrossCuttingAppService Is Nothing Then
                CrossCuttingAppService = New CrossCuttingServiceClient()
            End If
            Dim list As List(Of AdminFfParameterTypesFilterModel) = CrossCuttingAppService.GetFlexibleFormParamterTypeSearchAsync(GetCurrentLanguage(), searchString).Result

            If (Not (sortExpression) Is Nothing) Then
                If SortDirection = SortConstants.Ascending Then
                    list = list.OrderBy(Function(x) x.GetType().GetProperty(sortExpression).GetValue(x)).ToList()
                Else
                    list = list.OrderByDescending(Function(x) x.GetType().GetProperty(sortExpression).GetValue(x)).ToList()
                End If
            End If

            'Populate grid with base reference values for selected base reference type
            'gvAgeGroup.DataSource = Nothing
            'gvAgeGroup.DataBind()

            gvAgeGroup.DataSource = list
            gvAgeGroup.DataBind()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Sub FillFixedPresetValues(ByVal idfsParameterType As Long, Optional ByVal sortExpression As String = Nothing)

        Try
            Dim list As List(Of FfGetParameterFixedPresetValueModel) = New List(Of FfGetParameterFixedPresetValueModel)()

            Try
                If CrossCuttingAppService Is Nothing Then
                    CrossCuttingAppService = New CrossCuttingServiceClient()
                End If
                list = CrossCuttingAppService.GetFlexibleFormsParameterFixedPresetValueAsync(GetCurrentLanguage(), idfsParameterType).Result
            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Throw
            Finally
            End Try

            If (Not (sortExpression) Is Nothing) Then
                If SortDirection = SortConstants.Ascending Then
                    list = list.OrderBy(Function(x) x.GetType().GetProperty(sortExpression).GetValue(x)).ToList()
                Else
                    list = list.OrderByDescending(Function(x) x.GetType().GetProperty(sortExpression).GetValue(x)).ToList()
                End If
            End If

            grdChild.DataSource = list
            grdChild.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub SortRecords(ByVal sender As Object, ByVal e As GridViewSortEventArgs) Handles gvAgeGroup.Sorted
        FillBaseReferenceList(e.SortExpression)
    End Sub

    Protected Sub SortingRecords(sender As Object, e As GridViewSortEventArgs) Handles gvAgeGroup.Sorting
        Try
            SortDirection = IIf(SortDirection = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            FillBaseReferenceList(e.SortExpression)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub gvAgeGroup_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvAgeGroup.PageIndexChanging
        gvAgeGroup.PageIndex = e.NewPageIndex
        FillBaseReferenceList()
    End Sub

    Private Sub gvAgeGroup_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvAgeGroup.RowEditing
        gvAgeGroup.EditIndex = e.NewEditIndex
        FillBaseReferenceList()
    End Sub

    Private Sub gvAgeGroup_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvAgeGroup.RowCancelingEdit
        gvAgeGroup.EditIndex = -1
        FillBaseReferenceList()
    End Sub

    Protected Sub gvAgeGroup_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs) Handles gvAgeGroup.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim ddlType As DropDownList = (TryCast(e.Row.FindControl("ddlSelectionType"), DropDownList))
            ddlType.SelectedValue = DataBinder.Eval(e.Row.DataItem, "System").ToString()
        End If
    End Sub

    Protected Sub gvAgeGroup_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvAgeGroup.RowCommand
        If e.CommandName = "NewParameterTypeRow" Then
            gvAgeGroup.FooterRow.Visible = True
        End If

        If e.CommandName = "AddParameterTypeRow" Then
            Try
                Dim idfsParameterType As String = "-1"

                Dim defaultName As String = (CType(CType(sender, GridView).FooterRow.FindControl("txtstrAgeGroupName_new"), TextBox).Text.ToString())
                Dim NationalName As String = (CType(CType(sender, GridView).FooterRow.FindControl("txtstrAgeGroupNameTranslated_new"), TextBox).Text.ToString())

                ''Hardcoded to 1 and 19000069, then can always comeback and edit. 
                'Warning message to user saying, click on save then you can update the child table with values. 
                Dim systemVal As String = 1
                Dim idfsReferenceType As String = "19000069"

                'Replace this method with API.
                'TODO: Replace this method with API replacement - Commenting for now to avoid errors. 
                'UpdateParameterTypeRow(paramType:=idfsParameterType, defaultName:=defaultName, nationalName:=NationalName, idfsReferenceType:=idfsReferenceType)
                If FlexibleFormServiceClient Is Nothing Then
                    FlexibleFormServiceClient = New FlexibleFormServiceClient()
                End If

                Dim adminFfParameterTypesSetParams As New AdminFfParameterTypesSetParams()
                adminFfParameterTypesSetParams.defaultName = defaultName
                adminFfParameterTypesSetParams.nationalName = NationalName
                adminFfParameterTypesSetParams.idfsReferenceType = If(idfsReferenceType.IsValueNullOrEmpty, Nothing, idfsReferenceType)

                Dim list As List(Of AdminFfParameterTypesSetModel) = FlexibleFormServiceClient.CreateOrUpdateFlexibleFormParameterType(adminFfParameterTypesSetParams).Result
                    
                gvAgeGroup.EditIndex = -1
                FillBaseReferenceList()
            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try
        End If

        If e.CommandName = "UpdateParameterTypeRow" Then
            Try

                'To bring all the values in the text boxes and the also the dropdown selection and if it is reference value 
                ' make sure it is updated whne the dropdown is highlighted in the panel modal popup. 
                Dim rowIndex As Integer = (CType((CType(e.CommandSource, LinkButton)).NamingContainer, GridViewRow)).RowIndex
                Dim idfsParameterType As Int64 = (CType(sender, GridView).DataKeys(rowIndex)("idfsParameterType"))
                Dim defaultName As String = (CType(CType(sender, GridView).Rows(rowIndex).FindControl("txtstrAgeGroupName"), TextBox).Text.ToString())
                Dim NationalName As String = (CType(CType(sender, GridView).Rows(rowIndex).FindControl("txtstrAgeGroupNameTranslated"), TextBox).Text.ToString())
                Dim systemVal As String = (CType(CType(sender, GridView).Rows(rowIndex).FindControl("ddlSelectionType"), DropDownList).SelectedValue.ToString())
                Dim idfsReferenceType As String
                If systemVal = "1" Then
                    'Reference is selected. 
                    idfsReferenceType = ddlReferenceList.SelectedValue
                Else
                    idfsReferenceType = "19000069"
                End If

                'Replace this method with API.
                'TODO: Replace this method with API replacement - Commenting for now to avoid errors. 
                'UpdateParameterTypeRow(paramType:=idfsParameterType, defaultName:=defaultName, nationalName:=NationalName, idfsReferenceType:=idfsReferenceType)
                If FlexibleFormServiceClient Is Nothing Then
                    FlexibleFormServiceClient = New FlexibleFormServiceClient()
                End If

                Dim adminFfParameterTypesSetParams As New AdminFfParameterTypesSetParams()
                adminFfParameterTypesSetParams.langId = hdfLangID.Value
                adminFfParameterTypesSetParams.defaultName = defaultName
                adminFfParameterTypesSetParams.nationalName = NationalName
                adminFfParameterTypesSetParams.idfsReferenceType = If(idfsReferenceType.IsValueNullOrEmpty, Nothing, idfsReferenceType)

                Dim list As List(Of AdminFfParameterTypesSetModel) = FlexibleFormServiceClient.CreateOrUpdateFlexibleFormParameterType(adminFfParameterTypesSetParams).Result

                gvAgeGroup.EditIndex = -1
                FillBaseReferenceList()
            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try
        End If

        If e.CommandName = "DeleteParameterTypeRow" Then
            Try
                If FlexibleFormServiceClient Is Nothing Then
                    FlexibleFormServiceClient = New FlexibleFormServiceClient()
                End If

                Dim rowIndex As Integer = (CType((CType(e.CommandSource, LinkButton)).NamingContainer, GridViewRow)).RowIndex
                Dim idfsParameterType As Int64 = (CType(sender, GridView).DataKeys(rowIndex)("idfsParameterType"))
                Dim list As List(Of AdminFfParameterTypesDelModel) = FlexibleFormServiceClient.DeleteFlexibleFormParameterTypeDelete(idfsParameterType).Result
                'ASPNETMsgBox(list.FirstOrDefault().ReturnMessage)
            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try
        End If
    End Sub
    Protected Sub ddlSelectionType_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim ddlSelectionType As DropDownList = CType(sender, DropDownList)
        Dim row As GridViewRow = CType(ddlSelectionType.NamingContainer, GridViewRow)
        Dim id As Label = CType(row.FindControl("lblId"), Label)
        Dim hfReferenceType As HiddenField = CType(row.FindControl("hfidfsReferenceType"), HiddenField)
        Session(CallerPages.FlexibleFormParameterTypeID) = (CType(row.NamingContainer, GridView).DataKeys(row.RowIndex)("idfsParameterType"))

        If ddlSelectionType.SelectedValue = "0" Then
            FillFixedPresetValues(Session(CallerPages.FlexibleFormParameterTypeID))
            mpe.Show()
        ElseIf ddlSelectionType.SelectedValue = "1" Then
            Try
                Dim list As List(Of FfGetReferenceTypesModel) = FillReferenceTypeDropdown()
                ddlReferenceList.DataSource = list
                ddlReferenceList.DataTextField = "DefaultName"
                ddlReferenceList.DataValueField = "idfsReferenceType"
                ddlReferenceList.DataBind()
                ddlReferenceList.SelectedValue = hfReferenceType.Value

                Dim detailedlist As List(Of FfGetReferenceTypesListModel) = FillReferenceTypeGrid(hfReferenceType.Value)

                gvReferenceList.DataSource = detailedlist
                gvReferenceList.DataBind()
                'TODO: To add Reference display
                mpe1.Show()

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

        Else
        End If
    End Sub

    Private Function FillReferenceTypeDropdown() As List(Of FfGetReferenceTypesModel)
        Try
            If CrossCuttingAppService Is Nothing Then
                CrossCuttingAppService = New CrossCuttingServiceClient()
            End If
            Dim list As List(Of FfGetReferenceTypesModel) = CrossCuttingAppService.GetFlexibleFormsReferenceTypesAsync(GetCurrentLanguage()).Result
            Return list
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        Finally
        End Try
    End Function

    Private Function FillReferenceTypeGrid(hfReferenceType As String) As List(Of FfGetReferenceTypesListModel)
        Dim detailedlist As List(Of FfGetReferenceTypesListModel) = New List(Of FfGetReferenceTypesListModel)()
        Try
            If CrossCuttingAppService Is Nothing Then
                CrossCuttingAppService = New CrossCuttingServiceClient()
            End If
            detailedlist = CrossCuttingAppService.GetFlexibleFormsReferenceTypesListAsync(GetCurrentLanguage(), hfReferenceType).Result
            Return detailedlist
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Function

    Protected Sub btnSaveReferenceSelection_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSaveReferenceSelection.Click
        Dim ddlReferenceList As DropDownList = CType(Page.FindControl("ddlReferenceList"), DropDownList)

        'ddlReferenceList.SelectedValue
        'Need to call API to save the ddlReferenceList.SelectedValue to a table.

        ASPNETMsgBox("Selection Saved")
        mpe1.Show()
    End Sub

    Protected Sub ddlReferenceList_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlReferenceList.SelectedIndexChanged
        Dim detailedlist As List(Of FfGetReferenceTypesListModel) = FillReferenceTypeGrid(ddlReferenceList.SelectedValue)
        gvReferenceList.DataSource = detailedlist
        gvReferenceList.DataBind()
        mpe1.Show()
    End Sub

    Protected Sub btnCancelAdd_Click(sender As Object, e As EventArgs)
        Dim lnkButton As LinkButton = CType(sender, LinkButton)
        Dim row As GridViewRow = CType(lnkButton.NamingContainer, GridViewRow)
        Dim gridView As GridView = CType(row.NamingContainer, GridView)
        gridView.FooterRow.Visible = False
    End Sub

    Protected Sub btnCancelAddFixedPreset_Click(sender As Object, e As EventArgs)
        Dim lnkButton As LinkButton = CType(sender, LinkButton)
        Dim row As GridViewRow = CType(lnkButton.NamingContainer, GridViewRow)
        Dim gridView As GridView = CType(row.NamingContainer, GridView)
        gridView.FooterRow.Visible = False
    End Sub

    Protected Sub btnCancelSearch_Click(sender As Object, e As EventArgs) Handles btnClearSearch.Click
        txtSearchBox.Text = String.Empty
        gvAgeGroup.EditIndex = -1
        FillBaseReferenceList()
    End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        FillBaseReferenceList(txtSearchBox.Text, Nothing)
    End Sub

    Protected Sub lnkShowCurrentSelectionPopup_Click(sender As Object, e As EventArgs)
        Dim lnkButton As LinkButton = CType(sender, LinkButton)
        Dim row As GridViewRow = CType(lnkButton.NamingContainer, GridViewRow)
        Session(CallerPages.FlexibleFormParameterTypeID) = (CType(row.NamingContainer, GridView).DataKeys(row.RowIndex)("idfsParameterType"))
        Dim hfReferenceType As HiddenField = CType(row.FindControl("hfidfsReferenceType"), HiddenField)

        Try
            Dim ddlSelectionType As DropDownList = TryCast(row.FindControl("ddlSelectionType"), DropDownList)
            If ddlSelectionType.SelectedValue = "0" Then
                FillFixedPresetValues(Session(CallerPages.FlexibleFormParameterTypeID))
                mpe.Show()
            ElseIf ddlSelectionType.SelectedValue = "1" Then
                Dim list As List(Of FfGetReferenceTypesModel) = FillReferenceTypeDropdown()
                ddlReferenceList.DataSource = list
                ddlReferenceList.DataTextField = "DefaultName"
                ddlReferenceList.DataValueField = "idfsReferenceType"
                ddlReferenceList.DataBind()
                ddlReferenceList.SelectedValue = hfReferenceType.Value
                Dim detailedlist As List(Of FfGetReferenceTypesListModel) = FillReferenceTypeGrid(hfReferenceType.Value)
                gvReferenceList.DataSource = detailedlist
                gvReferenceList.DataBind()
                mpe1.Show()
            Else
            End If

        Catch ex As Exception
            Dim ddlSelectionType As DropDownList = TryCast(row.FindControl("ddlSelectionType_new"), DropDownList)
            If ddlSelectionType.SelectedValue = "0" Then
                FillFixedPresetValues(Session(CallerPages.FlexibleFormParameterTypeID))
                mpe.Show()
            ElseIf ddlSelectionType.SelectedValue = "1" Then

                Dim list As List(Of FfGetReferenceTypesModel) = FillReferenceTypeDropdown()
                ddlReferenceList.DataSource = list
                ddlReferenceList.DataTextField = "DefaultName"
                ddlReferenceList.DataValueField = "idfsReferenceType"
                ddlReferenceList.DataBind()
                ddlReferenceList.SelectedValue = hfReferenceType.Value
                Dim detailedlist As List(Of FfGetReferenceTypesListModel) = FillReferenceTypeGrid(hfReferenceType.Value)
                gvReferenceList.DataSource = detailedlist
                gvReferenceList.DataBind()
                mpe1.Show()
            End If
        End Try
    End Sub

    Protected Sub lnkShowCurrentSelectionDisabled_Click(sender As Object, e As EventArgs)
        ASPNETMsgBox("Please save the record before creating child records.")
    End Sub


    Protected Sub GrdChild_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles grdChild.RowCommand
        'Make sure to display mpe.Show() in all outs of If's

        If e.CommandName = "ShowNewFixedPresetValueRow" Then
            grdChild.FooterRow.Visible = True
        End If

        If e.CommandName = "AddFixedPresetValueRow" Then
            'Dim FirstName As TextBox = CType(grdChild.FooterRow.FindControl("txtNewFirstName"), TextBox)
            'Dim LastName As TextBox = CType(grdChild.FooterRow.FindControl("txtNewLastName"), TextBox)
            Try

                If FlexibleFormServiceClient Is Nothing Then
                    FlexibleFormServiceClient = New FlexibleFormServiceClient()
                End If
                Dim defaultName As String = (CType(CType(sender, GridView).FooterRow.FindControl("txtNewDefaultName"), TextBox).Text.ToString())
                Dim NationalName As String = (CType(CType(sender, GridView).FooterRow.FindControl("txtNewNationalName"), TextBox).Text.ToString())
                Dim order As Int32 = (CType(CType(sender, GridView).FooterRow.FindControl("txtNewOrder"), TextBox).Text.ToString())

                Dim rowIndex As Integer = (CType((CType(e.CommandSource, LinkButton)).NamingContainer, GridViewRow)).RowIndex

                Dim adminFfParameterFixedPresetValueSetParams As New AdminFfParameterFixedPresetValueSet()
                adminFfParameterFixedPresetValueSetParams.defaultName = defaultName
                adminFfParameterFixedPresetValueSetParams.nationalName = NationalName
                adminFfParameterFixedPresetValueSetParams.intOrder = order
                adminFfParameterFixedPresetValueSetParams.langId = hdfLangID.Value

                Dim list As List(Of AdminFfParameterFixedPresetValueSetModel) = FlexibleFormServiceClient.CreateOrUpdateFfParameterFixedPresetValue(adminFfParameterFixedPresetValueSetParams).Result
                'Removed to repoint to API. Pending development
                grdChild.EditIndex = -1
                FillFixedPresetValues(Session(CallerPages.FlexibleFormParameterTypeID))
            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try
        End If

        If e.CommandName = "UpdateFixedPresetValueRow" Then
            'Removed to repoint to API. Pending development
            Try
                If FlexibleFormServiceClient Is Nothing Then
                    FlexibleFormServiceClient = New FlexibleFormServiceClient()
                End If

                Dim rowIndex As Integer = (CType((CType(e.CommandSource, LinkButton)).NamingContainer, GridViewRow)).RowIndex
                Dim idfsParameterType As Int64 = (CType(sender, GridView).DataKeys(rowIndex)("idfsParameterType"))
                Dim defaultName As String = (CType(CType(sender, GridView).Rows(rowIndex).FindControl("txtDefaultName"), TextBox).Text.ToString())
                Dim NationalName As String = (CType(CType(sender, GridView).Rows(rowIndex).FindControl("txtNationalName"), TextBox).Text.ToString())
                Dim Order As Int32 = (CType(CType(sender, GridView).Rows(rowIndex).FindControl("txtOrder"), TextBox).Text.ToString())
                Dim idfsParameterFixedPresetValue As Int64 = (CType(CType(sender, GridView).Rows(rowIndex).FindControl("hfEditidfsParameterFixedPresetValue"), HiddenField).Value.ToString())

                Dim adminFfParameterFixedPresetValueSetParams As New AdminFfParameterFixedPresetValueSet()
                adminFfParameterFixedPresetValueSetParams.idfsParameterType = If(idfsParameterType.ToString().IsValueNullOrEmpty, Nothing, idfsParameterType)
                adminFfParameterFixedPresetValueSetParams.defaultName = defaultName
                adminFfParameterFixedPresetValueSetParams.nationalName = NationalName
                adminFfParameterFixedPresetValueSetParams.langId = hdfLangID.Value
                adminFfParameterFixedPresetValueSetParams.intOrder = If(Order.ToString().IsValueNullOrEmpty, Nothing, Order)
                adminFfParameterFixedPresetValueSetParams.idfsParameterFixedPresetValue = If(idfsParameterFixedPresetValue.ToString().IsValueNullOrEmpty, Nothing, idfsParameterFixedPresetValue)

                Dim list As List(Of AdminFfParameterFixedPresetValueSetModel) = FlexibleFormServiceClient.CreateOrUpdateFfParameterFixedPresetValue(adminFfParameterFixedPresetValueSetParams).Result

                grdChild.EditIndex = -1
                FillFixedPresetValues(Session(CallerPages.FlexibleFormParameterTypeID))
            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try
        End If

        If e.CommandName = "DeleteFixedPresetValueRow" Then
            'Removed to repoint to API. Pending development
            Try
                If FlexibleFormServiceClient Is Nothing Then
                    FlexibleFormServiceClient = New FlexibleFormServiceClient()
                End If

                Dim rowIndex As Integer = (CType((CType(e.CommandSource, LinkButton)).NamingContainer, GridViewRow)).RowIndex
                Dim idfsParameterFixedPresetValue As Int64 = (CType(CType(sender, GridView).Rows(rowIndex).FindControl("hfidfsParameterFixedPresetValue"), HiddenField).Value.ToString())
                Dim list As List(Of AdminFfParameterFixedPresetValueDelModel) = FlexibleFormServiceClient.DeleteFlexibleFormParameterFixedPresetValue(idfsParameterFixedPresetValue).Result

                FillBaseReferenceList()
            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try
        End If
        mpe.Show()
    End Sub

    Protected Sub grdChild_RowEditing(ByVal sender As Object, ByVal e As GridViewEditEventArgs) Handles grdChild.RowEditing
        grdChild.EditIndex = e.NewEditIndex
        FillFixedPresetValues(Session(CallerPages.FlexibleFormParameterTypeID))
        mpe.Show()
    End Sub

    Protected Sub grdChild_RowCancelingEdit(ByVal sender As Object, ByVal e As GridViewCancelEditEventArgs) Handles grdChild.RowCancelingEdit
        grdChild.EditIndex = -1
        FillFixedPresetValues(Session(CallerPages.FlexibleFormParameterTypeID))
        mpe.Show()
    End Sub

    'Private Sub gvReferenceList_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvReferenceList.PageIndexChanging
    '    gvReferenceList.PageIndex = e.NewPageIndex
    '    Dim detailedlist As List(Of FfGetReferenceTypesListModel) = FillReferenceTypeGrid(ddlReferenceList.SelectedValue)

    '    gvReferenceList.DataSource = detailedlist
    '    gvReferenceList.DataBind()
    'End Sub
    ''' <summary>
    ''' Returns the main list. 
    ''' </summary>
    ''' <param name="idfsParameterType"></param>
    ''' <param name="onlyLists"></param>
    ''' <returns></returns>
    Public Function GetFlexibleParameterReferenceTypeList(idfsParameterType As Long?, onlyLists As Boolean?) As List(Of FfGetParameterReferenceTypeModel)

        Try
            If CrossCuttingAppService Is Nothing Then
                CrossCuttingAppService = New CrossCuttingServiceClient()
            End If
            Dim list As List(Of FfGetParameterReferenceTypeModel) = CrossCuttingAppService.GetFlexibleParameterReferenceTypeAsync(GetCurrentLanguage(), idfsParameterType, onlyLists).Result
            Return list
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        Finally
        End Try

    End Function

End Class