Imports System.Reflection
Imports EIDSS
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports Newtonsoft.Json
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class Freezers
    Inherits BaseEidssPage

#Region "Global Values"

    Private LaboratoryAPIService As LaboratoryServiceClient

    Private Shared Log As log4net.ILog

    Protected AdvancedSearchPostBackItem As String

    'CSS Constants
    Private Const CSS_BOX_LOCATION As String = "boxLocation"
    Private Const CSS_DISABLED_BOX_LOCATION As String = "disabledBoxLocation"

    Private Const SESSION_FREEZERS_LIST As String = "gvFreezers_List"
    Private Const SESSION_FREEZER_SUBDIVISIONS_LIST As String = "treFreezerSubvidisions_List"
    Private Const FREEZERS_SORT_DIRECTION As String = "gvFreezers_SortDirection"
    Private Const FREEZERS_SORT_EXPRESSION As String = "gvFreezers_SortExpression"
    Private Const FREEZERS_PAGINATION_SET_NUMBER As String = "gvFreezers_PaginationSet"

    Private Const MODAL_KEY As String = "Modal"
    Private Const MODAL_ON_MODAL_KEY As String = "ModalOnModal"
    Private Const PAGE_KEY As String = "Page"
    Private Const SET_BACKDROP_SCRIPT As String = "setBackdrop();"
    Private Const SHOW_MODAL_HANDLER_SCRIPT As String = "showModalHandler('{0}');"
    Private Const HIDE_MODAL_SCRIPT As String = "hideModal('{0}');"

    Private treeViewList As New List(Of TreeViewItem)
    Private BoxSection As String = "Box"

#End Region

#Region "Initialize Methods"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        Try
            Log = log4net.LogManager.GetLogger(GetType(Laboratory))

            If (Not IsPostBack) Then
                'Assign defaults from current user data.
                hdfUserID.Value = Session("UserID")
                hdfSiteID.Value = Session("UserSite")
                hdfPersonID.Value = Session("Person")

                FillBaseReferenceDropDownList(ddlStorageTypeID, BaseReferenceConstants.StorageType, HACodeList.NoneHACode, True)
                FillBaseReferenceDropDownList(ddlBoxSizeTypeID, BaseReferenceConstants.FreezerBoxSize, HACodeList.HALVHACode, True)
                FillBaseReferenceDropDownList(ddlSubdivisionTypeID, BaseReferenceConstants.FreezerSubdivisionType, HACodeList.HALVHACode, True)

                EnableForm(divStorageSchema, False)

                divBoxConfigurationActions.Visible = False
                divSubdivisionAttributes.Visible = False

                If LaboratoryAPIService Is Nothing Then
                    LaboratoryAPIService = New LaboratoryServiceClient()
                End If
                Dim parameters = New LaboratoryFreezerGetListParams With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .OrganizationID = hdfSiteID.Value, .SearchString = Nothing}
                Dim freezersCount = LaboratoryAPIService.LaboratoryFreezerGetListCountAsync(parameters).Result
                hdfFreezersCount.Value = freezersCount(0).RecordCount
                FillFreezersList(pageIndex:=1, paginationSetNumber:=1, siteID:=hdfSiteID.Value, searchString:=Nothing)
                BindFreezersGridView(reOrder:=False)

                SetPostBackEvents()

                btnCopyFreezer.Enabled = False
            Else
                Dim eventArg As Object = Request("__EVENTARGUMENT")
                Dim eventSource As String = Request.Form("__EVENTTARGET")
                If Not eventArg.ToString.IsValueNullOrEmpty() Then
                    If eventSource.Contains(ID) Then
                        ShowAdvancedSearch()
                    End If
                End If

                SetPostBackEvents()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub SetPostBackEvents()

        AdvancedSearchPostBackItem = Page.ClientScript.GetPostBackEventReference(Me, LaboratoryModuleActions.AdvancedSearch.ToString())

    End Sub

#End Region

#Region "Common Methods"

    Private Sub ToggleVisibility(section As String)

        divBoxSize.Visible = section.Equals(BoxSection)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    Private Sub ShowSuccessMessage(messageType As MessageType, message As String)

        upSuccessModal.Update()

        Select Case messageType
            Case MessageType.DeleteSuccess
                lblSuccessMessage.InnerText = GetLocalResourceObject("Lbl_Message_Delete_Success")
            Case MessageType.AddUpdateSuccess
                lblSuccessMessage.InnerText = message
        End Select

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSuccessModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    ''' <param name="message"></param>
    Private Sub ShowWarningMessage(messageType As MessageType, isConfirm As Boolean, Optional message As String = Nothing)

        hdgWarning.InnerText = Resources.WarningMessages.Warning_Message_Alert

        Select Case messageType
            Case MessageType.CannotAddUpdate
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_Cannot_Save_Body_Text")
            Case MessageType.CannotDelete
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_Has_Samples_Body_Text")
            Case MessageType.CannotDeleteSubdivision
                divWarningBody.InnerHtml = message
            Case MessageType.CancelConfirm
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_Cancel_Confirm")
            Case MessageType.CancelSearchConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Search_Confirm
            Case MessageType.ConfirmDelete
                divWarningBody.InnerHtml = GetLocalResourceObject("Warning_Message_Confirm_Delete_Text")
            Case MessageType.ConfirmDeleteFreezerSubdivision
                divWarningBody.InnerHtml = Resources.WarningMessages.Confirm_Delete_Message
            Case MessageType.UnhandledException
                divWarningBody.InnerText = GetLocalResourceObject("Warning_Message_Unhandled_Exception_Body_Text")
        End Select

        If isConfirm Then
            divWarningYesNo.Visible = True
            divWarningOK.Visible = False
        Else
            divWarningOK.Visible = True
            divWarningYesNo.Visible = False
        End If

        upWarningModal.Update()

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divWarningModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub WarningModalYes_Click(sender As Object, e As EventArgs) Handles btnWarningModalYes.Click

        Try
            Select Case hdfCurrentModuleAction.Value
                Case ucAdvancedSearch.ID
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchFreezerModal"), True)
                Case MessageType.ConfirmDeleteFreezerSubdivision.ToString()
                    Dim freezerSubdivisions = CType(Session(SESSION_FREEZER_SUBDIVISIONS_LIST), List(Of LabFreezerSubdivisionGetListModel))
                    freezerSubdivisions.Where(Function(x) x.SubdivisionID = hdfFreezerSubdivisionID.Value).FirstOrDefault().RowStatus = RecordConstants.InactiveRowStatus
                    Dim parameters As LaboratoryFreezerSetParams = New LaboratoryFreezerSetParams With {
                        .LanguageID = GetCurrentLanguage(),
                        .FreezerID = hdfFreezerID.Value,
                        .OrganizationID = hdfSiteID.Value,
                        .FreezerSubdivisions = BuildFreezerSubdivisionParameters(freezerSubdivisions)
                    }

                    Gather(divFreezerAttributes, parameters, 3)

                    SaveFreezer(freezerParameters:=parameters)
                Case MessageType.ConfirmDeleteFreezer.ToString()
                    Dim parameters As LaboratoryFreezerSetParams = New LaboratoryFreezerSetParams With {
                        .LanguageID = GetCurrentLanguage(),
                        .FreezerID = hdfFreezerID.Value,
                        .OrganizationID = hdfSiteID.Value,
                        .RowStatus = RecordConstants.InactiveRowStatus,
                        .FreezerSubdivisions = BuildFreezerSubdivisionParameters(CType(Session(SESSION_FREEZER_SUBDIVISIONS_LIST), List(Of LabFreezerSubdivisionGetListModel)))
                    }

                    Gather(divFreezerAttributes, parameters, 3)

                    SaveFreezer(freezerParameters:=parameters)
            End Select

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divWarningModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Search Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ShowAdvancedSearch()

        Try
            ucAdvancedSearch.Setup()

            ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, SET_BACKDROP_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    Protected Sub AdvancedSearch_ShowWarningModal(messageType As MessageType, isConfirm As Boolean) Handles ucAdvancedSearch.ShowWarningModal

        upFreezers.Update()
        hdfCurrentModuleAction.Value = ucAdvancedSearch.ID
        ShowWarningMessage(messageType, isConfirm)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillFreezersList(pageIndex As Integer, paginationSetNumber As Integer, siteID As Long?, searchString As String)

        Try
            Dim parameters = New LaboratoryFreezerGetListParams With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = paginationSetNumber, .OrganizationID = siteID, .SearchString = searchString}
            Session(SESSION_FREEZERS_LIST) = LaboratoryAPIService.LaboratoryFreezerGetListAsync(parameters).Result
            FillFreezersPager(hdfFreezersCount.Value, pageIndex)
            ViewState(FREEZERS_PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="reOrder"></param>
    Private Sub BindFreezersGridView(Optional reOrder As Boolean = False)

        Dim list As List(Of LabFreezerGetListModel) = CType(Session(SESSION_FREEZERS_LIST), List(Of LabFreezerGetListModel))

        If reOrder = True Then
            list.OrderByDescending(Function(x) x.RowAction).ToList()
        End If

        lblFreezersPageNumber.Text = "1"
        gvFreezers.DataSource = list
        gvFreezers.DataBind()
        gvFreezers.PageIndex = 0

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Freezers_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvFreezers.RowCommand

        Try
            e.Handled = True
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    Dim freezer = CType(Session(SESSION_FREEZERS_LIST), List(Of LabFreezerGetListModel)).Where(Function(x) x.FreezerID = e.CommandArgument).FirstOrDefault()
                    Scatter(divStorageSchema, freezer, 3)

                    If LaboratoryAPIService Is Nothing Then
                        LaboratoryAPIService = New LaboratoryServiceClient()
                    End If
                    Dim freezerSubdivisions = LaboratoryAPIService.LaboratoryFreezerSubdivisionGetListAsync(GetCurrentLanguage(), freezer.FreezerID, Nothing).Result

                    Session(SESSION_FREEZER_SUBDIVISIONS_LIST) = freezerSubdivisions

                    DeleteFreezer(e.CommandArgument)
                Case GridViewCommandConstants.EditCommand
                    btnCopyFreezer.Enabled = True
                    divFreezerAttributes.Visible = True
                    divSubdivisionAttributes.Visible = False
                    divBoxConfigurationActions.Visible = True
                    EnableForm(divStorageSchema, True)
                    btnAddSubdivision.Enabled = False
                    btnCopySubdivision.Enabled = False
                    btnDeleteSubdivision.Enabled = False
                    Dim freezer = CType(Session(SESSION_FREEZERS_LIST), List(Of LabFreezerGetListModel)).Where(Function(x) x.FreezerID = e.CommandArgument).FirstOrDefault()
                    Scatter(divStorageSchema, freezer, 3)

                    If LaboratoryAPIService Is Nothing Then
                        LaboratoryAPIService = New LaboratoryServiceClient()
                    End If
                    Dim freezerSubdivisions = LaboratoryAPIService.LaboratoryFreezerSubdivisionGetListAsync(GetCurrentLanguage(), freezer.FreezerID, Nothing).Result

                    treSubdivisions.Nodes.Clear()

                    treeViewList.Add(New TreeViewItem() With {.ParentID = 0, .ID = freezer.FreezerID, .Text = GetGlobalResourceObject("Labels", "Lbl_Freezer_Text") & " " & freezer.FreezerName})

                    For Each freezerSubdivision In freezerSubdivisions
                        If freezerSubdivision.ParentSubdivisionID Is Nothing Then
                            freezerSubdivision.ParentSubdivisionID = freezer.FreezerID
                        End If

                        Select Case freezerSubdivision.SubdivisionTypeID
                            Case SubdivisionTypes.Shelf
                                treeViewList.Add(New TreeViewItem() With {.ParentID = freezerSubdivision.ParentSubdivisionID, .ID = freezerSubdivision.SubdivisionID, .Text = GetGlobalResourceObject("Labels", "Lbl_Shelf_Text") & " " & freezerSubdivision.SubdivisionName})
                            Case SubdivisionTypes.Rack
                                treeViewList.Add(New TreeViewItem() With {.ParentID = freezerSubdivision.ParentSubdivisionID, .ID = freezerSubdivision.SubdivisionID, .Text = GetGlobalResourceObject("Labels", "Lbl_Rack_Text") & " " & freezerSubdivision.SubdivisionName})
                            Case SubdivisionTypes.Box
                                treeViewList.Add(New TreeViewItem() With {.ParentID = freezerSubdivision.ParentSubdivisionID, .ID = freezerSubdivision.SubdivisionID, .Text = GetGlobalResourceObject("Labels", "Lbl_Box_Text") & " " & freezerSubdivision.SubdivisionName})
                        End Select
                    Next

                    Dim binding = New TreeNodeBinding()
                    binding.TextField = "Text"
                    binding.ValueField = "ID"
                    treSubdivisions.DataBindings.Add(binding)

                    PopulateTreeView(0, Nothing)

                    treSubdivisions.ExpandAll()

                    Session(SESSION_FREEZER_SUBDIVISIONS_LIST) = freezerSubdivisions

                    upFreezers.Update()
                    upStorageSchema.Update()
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="parentID"></param>
    ''' <param name="parentNode"></param>
    Private Sub PopulateTreeView(ByVal parentID As Long, ByVal parentNode As TreeNode)

        Try
            Dim childNode As TreeNode

            For Each item As TreeViewItem In treeViewList.Where(Function(x) x.ParentID = parentID)
                Dim t As TreeNode = New TreeNode()
                t.Text = item.Text
                t.Value = item.ID

                If parentNode Is Nothing Then
                    treSubdivisions.Nodes.Add(t)
                    childNode = t
                Else
                    parentNode.ChildNodes.Add(t)
                    childNode = t
                End If

                If Not parentID = childNode.Value Then
                    PopulateTreeView(item.ID, childNode)
                End If
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillFreezersPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Try
            Dim pages As New List(Of ListItem)()
            Dim startIndex As Integer, endIndex As Integer
            Dim pagerSpan As Integer = 5

            If recordCount > 0 Then
                divPager.Visible = True

                'Calculate the start and end index of pages to be displayed.
                Dim dblPageCount As Double = recordCount / Convert.ToDecimal(10)
                Dim pageCount As Integer = Math.Ceiling(dblPageCount)
                startIndex = If(currentPage > 1 AndAlso currentPage + pagerSpan - 1 < pagerSpan, currentPage, 1)
                endIndex = If(pageCount > pagerSpan, pagerSpan, pageCount)
                If currentPage > pagerSpan Mod 2 Then
                    If currentPage = 2 Then
                        endIndex = 5
                    Else
                        endIndex = currentPage + 2
                    End If
                Else
                    endIndex = (pagerSpan - currentPage) + 1
                End If

                If endIndex - (pagerSpan - 1) > startIndex Then
                    startIndex = endIndex - (pagerSpan - 1)
                End If

                If endIndex > pageCount Then
                    endIndex = pageCount
                    startIndex = If(((endIndex - pagerSpan) + 1) > 0, (endIndex - pagerSpan) + 1, 1)
                End If

                'Add the First Page Button.
                If currentPage > 1 Then
                    pages.Add(New ListItem(PagingConstants.FirstButtonText, "1"))
                End If

                'Add the Previous Button.
                If currentPage > 1 Then
                    pages.Add(New ListItem(PagingConstants.PreviousButtonText, (currentPage - 1).ToString()))
                End If

                Dim paginationSetNumber As Integer = 1,
                    pageCounter As Integer = 1

                For i As Integer = startIndex To endIndex
                    pages.Add(New ListItem(i.ToString(), i.ToString(), i <> currentPage))
                Next

                'Add the Next Button.
                If currentPage < pageCount Then
                    pages.Add(New ListItem(PagingConstants.NextButtonText, (currentPage + 1).ToString()))
                End If

                'Add the Last Button.
                If currentPage <> pageCount Then
                    pages.Add(New ListItem(PagingConstants.LastButtonText, pageCount.ToString()))
                End If
                rptFreezersPager.DataSource = pages
                rptFreezersPager.DataBind()
                divPager.Visible = True
            Else
                divPager.Visible = False
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub FreezersPage_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)

            Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvFreezers.PageSize)

            If Not ViewState(FREEZERS_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvFreezers.PageIndex = gvFreezers.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvFreezers.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvFreezers.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvFreezers.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvFreezers.PageIndex = gvFreezers.PageSize - 1
                        Else
                            gvFreezers.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                If txtSearchString.Text.IsValueNullOrEmpty = False Then
                    FillFreezersList(pageIndex, paginationSetNumber:=paginationSetNumber, siteID:=hdfSiteID.Value, searchString:=Nothing)
                Else
                    FillFreezersList(pageIndex, paginationSetNumber:=paginationSetNumber, siteID:=Nothing, searchString:=txtSearchString.Text)
                End If
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvFreezers.PageIndex = gvFreezers.PageSize - 1
                Else
                    gvFreezers.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
                BindFreezersGridView(reOrder:=False)
                FillFreezersPager(hdfFreezersCount.Value, pageIndex)
            End If

            lblFreezersPageNumber.Text = pageIndex.ToString()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub AdvancedSearch_CloseModal() Handles ucAdvancedSearch.CloseModal

        Try
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchFreezerModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Search_Click(sender As Object, e As EventArgs) Handles btnSearch.Click

        Try
            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If
            Dim parameters = New LaboratoryFreezerGetListParams With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .SearchString = txtSearchString.Text}
            Dim freezersCount = LaboratoryAPIService.LaboratoryFreezerGetListCountAsync(parameters).Result
            hdfFreezersCount.Value = freezersCount(0).RecordCount
            FillFreezersList(pageIndex:=1, paginationSetNumber:=1, siteID:=Nothing, searchString:=txtSearchString.Text)
            BindFreezersGridView(reOrder:=False)
            upFreezers.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="freezers"></param>
    ''' <param name="resultCount"></param>
    Protected Sub AdvancedSearch_UpdateSearchResults(freezers As List(Of LabFreezerGetListModel), resultCount As String) Handles ucAdvancedSearch.UpdateSearchResults

        Try
            Session(SESSION_FREEZERS_LIST) = freezers

            hdfFreezersCount.Value = resultCount

            BindFreezersGridView(reOrder:=False)

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchFreezerModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Add/Update Freezer Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Save_Click(sender As Object, e As EventArgs) Handles btnSave.Click

        Try
            Dim freezerSubdivisions = CType(Session(SESSION_FREEZER_SUBDIVISIONS_LIST), List(Of LabFreezerSubdivisionGetListModel))
            Dim freezerSubdivision As LabFreezerSubdivisionGetListModel

            If freezerSubdivisions Is Nothing Then
                freezerSubdivisions = New List(Of LabFreezerSubdivisionGetListModel)()
            End If

            If hdfFreezerSubdivisionID.Value.IsValueNullOrEmpty = False Then
                freezerSubdivision = freezerSubdivisions.Where(Function(x) x.SubdivisionID = hdfFreezerSubdivisionID.Value).FirstOrDefault()

                Gather(divStorageSchema, freezerSubdivision, 3)

                If freezerSubdivision.SubdivisionTypeID = SubdivisionTypes.Box Then
                    If freezerSubdivision.RowAction = RecordConstants.Read Then
                        freezerSubdivision.RowAction = RecordConstants.Update
                    End If
                    hdfFreezerSubdivisionID.Value = String.Empty
                    upStorageSchema.Update()
                End If

                Dim i As Integer = freezerSubdivisions.IndexOf(freezerSubdivision)

                freezerSubdivisions(i) = freezerSubdivision

                Session(SESSION_FREEZER_SUBDIVISIONS_LIST) = freezerSubdivisions
            End If

            Validate("AddUpdateFreezer")

            If (Page.IsValid) Then
                Dim parameters As LaboratoryFreezerSetParams = New LaboratoryFreezerSetParams With {
                    .LanguageID = GetCurrentLanguage(),
                    .OrganizationID = hdfSiteID.Value,
                    .FreezerSubdivisions = BuildFreezerSubdivisionParameters(CType(Session(SESSION_FREEZER_SUBDIVISIONS_LIST), List(Of LabFreezerSubdivisionGetListModel)))
                }

                Gather(divFreezerAttributes, parameters, 3)

                SaveFreezer(parameters)
            Else
                DisplayValidationErrors()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="freezerParameters"></param>
    Private Sub SaveFreezer(ByVal freezerParameters As LaboratoryFreezerSetParams)

        Try
            If LaboratoryAPIService Is Nothing Then
                LaboratoryAPIService = New LaboratoryServiceClient()
            End If

            Dim result As List(Of LabFreezerSetModel) = LaboratoryAPIService.SaveLaboratoryFreezerAsync(freezerParameters).Result

            If result.FirstOrDefault().ReturnCode = 0 Then
                If freezerParameters.FreezerID < 0 Then
                    If result.FirstOrDefault().EIDSSFreezerID Is Nothing Then
                        ShowSuccessMessage(MessageType.AddUpdateSuccess, GetLocalResourceObject("Lbl_Create_Success") & " " & result.FirstOrDefault().FreezerID.ToString() & ".")
                    Else
                        ShowSuccessMessage(MessageType.AddUpdateSuccess, GetLocalResourceObject("Lbl_Create_Success") & " " & result.FirstOrDefault().EIDSSFreezerID.ToString() & ".")
                    End If
                Else
                    ShowSuccessMessage(MessageType.AddUpdateSuccess, GetLocalResourceObject("Lbl_Update_Success"))
                End If
            Else
                ShowWarningMessage(messageType:=MessageType.CannotAddUpdate, isConfirm:=False)
            End If

            FillFreezersList(paginationSetNumber:=1, pageIndex:=0, siteID:=hdfSiteID.Value, searchString:=Nothing)
            BindFreezersGridView(reOrder:=False)

            treSubdivisions.Nodes.Clear()
            ResetForm(divStorageSchema)
            EnableForm(divStorageSchema, False)
            btnAddSubdivision.Enabled = False
            btnCopySubdivision.Enabled = False
            btnDeleteSubdivision.Enabled = False

            'VerifyUserPermissions(False)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
        Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub DisplayValidationErrors()

        'TODO: Display Validation Error Messages

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="subdivisions"></param>
    ''' <returns></returns>
    Private Function BuildFreezerSubdivisionParameters(subdivisions As List(Of LabFreezerSubdivisionGetListModel)) As List(Of FreezerSubdivisionParameters)

        Dim freezerSubdivisionParameters As List(Of FreezerSubdivisionParameters) = New List(Of FreezerSubdivisionParameters)()
        Dim freezerSubdivisionParameter As FreezerSubdivisionParameters

        If Not subdivisions Is Nothing Then
            For Each subdivisionModel In subdivisions
                freezerSubdivisionParameter = New FreezerSubdivisionParameters()
                With freezerSubdivisionParameter
                    .BoxPlaceAvailability = subdivisionModel.BoxPlaceAvailability
                    .BoxSizeTypeID = subdivisionModel.BoxSizeTypeID
                    .EIDSSFreezerSubdivisionID = subdivisionModel.EIDSSSubdivisionID
                    .FreezerID = subdivisionModel.FreezerID
                    .FreezerSubdivisionID = subdivisionModel.SubdivisionID
                    .FreezerSubdivisionName = subdivisionModel.SubdivisionName
                    .SubdivisionNote = subdivisionModel.SubdivisionNote
                    .NumberOfLocations = subdivisionModel.NumberOfLocations
                    .OrganizationID = subdivisionModel.OrganizationID
                    If subdivisionModel.ParentSubdivisionID = subdivisionModel.FreezerID Then
                        .ParentFreezerSubdivisionID = Nothing
                    Else
                        .ParentFreezerSubdivisionID = subdivisionModel.ParentSubdivisionID
                    End If
                    .RowAction = subdivisionModel.RowAction
                    .RowStatus = subdivisionModel.RowStatus
                    .SubdivisionTypeID = subdivisionModel.SubdivisionTypeID
                End With

                freezerSubdivisionParameters.Add(freezerSubdivisionParameter)
            Next
        End If

        Return freezerSubdivisionParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="columns"></param>
    ''' <param name="rows"></param>
    Private Function BuildBoxConfiguration(columns As Integer, rows As Integer, boxConfiguration As List(Of FreezerSubdivisionBoxLocationAvailability)) As String

        Try
            Dim tr As TableRow = New TableRow()
            Dim boxConfigurationTemp = New List(Of FreezerSubdivisionBoxLocationAvailability)()

            For c As Integer = 0 To columns
                Dim tc As TableCell = New TableCell()
                tc.ID = "tc_" & c.ToString() & "_0"
                If c > 0 Then
                    tc.Text = c.ToString()
                End If
                tr.Cells.Add(tc)
            Next
            tblBoxConfiguration.Rows.Add(tr)

            For r As Integer = 1 To rows
                tr = New TableRow()

                For c As Integer = 0 To columns
                    Dim tc As TableCell = New TableCell With {.ID = "tc_" & c.ToString() & "_" & r.ToString()}

                    If c = 0 Then
                        tc.Text = GetLetter(r)
                    Else
                        Dim rad As RadioButton = New RadioButton With {.Checked = False, .ClientIDMode = ClientIDMode.Static, .ID = "rad_" & GetLetter(r) & "_" & c.ToString(), .ToolTip = GetLetter(r) & "-" & c.ToString()}

                        If boxConfiguration.Count > 0 Then
                            If boxConfiguration.Where(Function(x) x.BoxLocation = rad.ToolTip And x.AvailabilityIndicator = True).Count() = 1 Then
                                rad.CssClass = CSS_BOX_LOCATION

                                boxConfigurationTemp.Add(New FreezerSubdivisionBoxLocationAvailability With {.AvailabilityIndicator = True, .BoxLocation = rad.ToolTip})
                            Else
                                rad.CssClass = CSS_DISABLED_BOX_LOCATION

                                boxConfigurationTemp.Add(New FreezerSubdivisionBoxLocationAvailability With {.AvailabilityIndicator = False, .BoxLocation = rad.ToolTip})
                            End If
                        Else
                            rad.Enabled = False
                            rad.CssClass = CSS_BOX_LOCATION

                            boxConfigurationTemp.Add(New FreezerSubdivisionBoxLocationAvailability With {.AvailabilityIndicator = True, .BoxLocation = rad.ToolTip})
                        End If

                        tc.Controls.Add(rad)
                    End If

                    tr.Cells.Add(tc)
                Next

                tblBoxConfiguration.Rows.Add(tr)
            Next

            Return JsonConvert.SerializeObject(boxConfigurationTemp)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

        Return String.Empty

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="number"></param>
    ''' <returns></returns>
    Friend Function GetLetter(ByVal number As Integer) As String

        Select Case number
            Case 1 : Return "A"
            Case 2 : Return "B"
            Case 3 : Return "C"
            Case 4 : Return "D"
            Case 5 : Return "E"
            Case 6 : Return "F"
            Case 7 : Return "G"
            Case 8 : Return "H"
            Case 9 : Return "I"
            Case 10 : Return "J"
            Case 11 : Return "K"
            Case 12 : Return "L"
            Case 13 : Return "M"
            Case 14 : Return "N"
            Case 15 : Return "O"
            Case 16 : Return "P"
            Case 17 : Return "Q"
            Case 18 : Return "R"
            Case 19 : Return "S"
            Case 20 : Return "T"
            Case 21 : Return "U"
            Case 22 : Return "V"
            Case 23 : Return "W"
            Case 24 : Return "X"
            Case 25 : Return "Y"
            Case 26 : Return "Z"
            Case Else : Return ""
        End Select

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Subdivisions_SelectedNodeChanged(sender As Object, e As EventArgs) Handles treSubdivisions.SelectedNodeChanged

        Try
            Dim freezerSubdivision As LabFreezerSubdivisionGetListModel

            Dim freezerSubdivisions = CType(Session(SESSION_FREEZER_SUBDIVISIONS_LIST), List(Of LabFreezerSubdivisionGetListModel))

            If Not freezerSubdivisions Is Nothing Then
                If hdfFreezerSubdivisionID.Value.IsValueNullOrEmpty = False Then
                    freezerSubdivision = freezerSubdivisions.Where(Function(x) x.SubdivisionID = hdfFreezerSubdivisionID.Value).FirstOrDefault()

                    Gather(divStorageSchema, freezerSubdivision, 3)

                    If freezerSubdivision.SubdivisionTypeID = SubdivisionTypes.Box Then
                        If freezerSubdivision.RowAction = RecordConstants.Read Then
                            freezerSubdivision.RowAction = RecordConstants.Update
                        End If
                        hdfFreezerSubdivisionID.Value = String.Empty
                        upStorageSchema.Update()
                    End If

                    Dim i As Integer = freezerSubdivisions.IndexOf(freezerSubdivision)

                    freezerSubdivisions(i) = freezerSubdivision

                    Session(SESSION_FREEZER_SUBDIVISIONS_LIST) = freezerSubdivisions
                End If

                freezerSubdivision = freezerSubdivisions.Where(Function(x) x.SubdivisionID = treSubdivisions.SelectedNode.Value).FirstOrDefault()

                If freezerSubdivision Is Nothing Then
                    divFreezerAttributes.Visible = True
                    divSubdivisionAttributes.Visible = False
                    hdfFreezerSubdivisionID.Value = String.Empty
                    btnAddSubdivision.Enabled = True
                    btnCopySubdivision.Enabled = False
                Else
                    Select Case freezerSubdivision.SubdivisionTypeID
                        Case SubdivisionTypes.Shelf
                            btnAddSubdivision.Enabled = True
                            btnCopySubdivision.Enabled = True
                            btnDeleteSubdivision.Enabled = True
                            txtNumberOfLocations.Enabled = True
                            txtNumberOfLocations.MinValue = freezerSubdivisions.Where(Function(x) x.ParentSubdivisionID = treSubdivisions.SelectedValue).Sum(Function(y) y.SampleCount)
                        Case SubdivisionTypes.Rack
                            btnAddSubdivision.Enabled = True
                            btnCopySubdivision.Enabled = True
                            btnDeleteSubdivision.Enabled = True
                            txtNumberOfLocations.Enabled = True
                            txtNumberOfLocations.Enabled = True
                            txtNumberOfLocations.MinValue = freezerSubdivisions.Where(Function(x) x.ParentSubdivisionID = treSubdivisions.SelectedValue).Sum(Function(y) y.SampleCount)
                        Case SubdivisionTypes.Box
                            btnAddSubdivision.Enabled = False
                            btnCopySubdivision.Enabled = True
                            btnDeleteSubdivision.Enabled = True
                            txtNumberOfLocations.Enabled = False
                    End Select

                    If freezerSubdivision.ParentSubdivisionID Is Nothing Then
                        divFreezerAttributes.Visible = True
                        divSubdivisionAttributes.Visible = False
                        hdfFreezerSubdivisionID.Value = String.Empty
                    Else
                        Scatter(divSubdivisionAttributes, freezerSubdivision, 3)
                        divFreezerAttributes.Visible = False
                        divSubdivisionAttributes.Visible = True

                        If freezerSubdivision.SubdivisionTypeID = SubdivisionTypes.Box Then
                            If Not freezerSubdivision.BoxSizeTypeID Is Nothing Then
                                Dim boxSize As String() = freezerSubdivision.BoxSizeTypeName.Split("X")
                                hdfRows.Value = boxSize(0)
                                hdfColumns.Value = boxSize(1)

                                txtNumberOfLocations.Text = boxSize(0) * boxSize(1)

                                If freezerSubdivision.BoxPlaceAvailability Is Nothing Then
                                    freezerSubdivision.BoxPlaceAvailability = BuildBoxConfiguration(boxSize(0), boxSize(1), New List(Of FreezerSubdivisionBoxLocationAvailability)())
                                Else
                                    freezerSubdivision.BoxPlaceAvailability = BuildBoxConfiguration(boxSize(0), boxSize(1), JsonConvert.DeserializeObject(Of List(Of FreezerSubdivisionBoxLocationAvailability))(freezerSubdivision.BoxPlaceAvailability))
                                End If
                                tblBoxConfiguration.Visible = True
                            Else
                                tblBoxConfiguration.Visible = False
                            End If
                        Else
                            tblBoxConfiguration.Visible = False
                        End If

                        hdfFreezerSubdivisionID.Value = freezerSubdivision.SubdivisionID
                    End If
                End If
            End If

            upStorageSchema.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddSubdivision_Click(sender As Object, e As EventArgs) Handles btnAddSubdivision.Click

        Try
            Dim freezerSubdivisions = CType(Session(SESSION_FREEZER_SUBDIVISIONS_LIST), List(Of LabFreezerSubdivisionGetListModel))
            Dim freezerSubdivision As LabFreezerSubdivisionGetListModel

            If freezerSubdivisions Is Nothing Then
                freezerSubdivisions = New List(Of LabFreezerSubdivisionGetListModel)()
            End If

            hdfFreezerSubdivisionIdentity.Value = hdfFreezerSubdivisionIdentity.Value + 1
            Dim identity As Integer = (hdfFreezerSubdivisionIdentity.Value * -1)

            If hdfFreezerSubdivisionID.Value.IsValueNullOrEmpty = False Then
                freezerSubdivision = freezerSubdivisions.Where(Function(x) x.SubdivisionID = hdfFreezerSubdivisionID.Value).FirstOrDefault()

                Gather(divStorageSchema, freezerSubdivision, 3)

                If freezerSubdivision.SubdivisionTypeID = SubdivisionTypes.Box Then
                    If freezerSubdivision.RowAction = RecordConstants.Read Then
                        freezerSubdivision.RowAction = RecordConstants.Update
                    End If
                    hdfFreezerSubdivisionID.Value = String.Empty
                    upStorageSchema.Update()
                End If

                Dim i As Integer = freezerSubdivisions.IndexOf(freezerSubdivision)

                freezerSubdivisions(i) = freezerSubdivision

                Session(SESSION_FREEZER_SUBDIVISIONS_LIST) = freezerSubdivisions

                For Each shelf As TreeNode In treSubdivisions.Nodes
                    If shelf.ChildNodes.Count > 0 Then
                        For Each rack As TreeNode In shelf.ChildNodes
                            If rack.ChildNodes.Count > 0 Then
                                For Each box As TreeNode In rack.ChildNodes
                                    If box.Value.ToString() = freezerSubdivision.SubdivisionID.ToString() Then
                                        box.Selected = True
                                    End If
                                Next
                            Else
                                If rack.Value.ToString() = freezerSubdivision.SubdivisionID.ToString() Then
                                    rack.Selected = True
                                End If
                            End If
                        Next
                    ElseIf shelf.Value.ToString() = freezerSubdivision.SubdivisionID.ToString() Then
                        shelf.Selected = True
                    ElseIf shelf.Parent Is Nothing Then
                        shelf.Selected = True 'Set to freezer
                    End If
                Next
            Else
                treSubdivisions.Nodes(0).Selected = True 'Set to freezer
            End If

            hdfFreezerSubdivisionID.Value = identity

            If Session(SESSION_FREEZER_SUBDIVISIONS_LIST) Is Nothing Then
                freezerSubdivision = New LabFreezerSubdivisionGetListModel With {
                    .FreezerID = hdfFreezerID.Value,
                    .SubdivisionID = identity,
                    .ParentSubdivisionID = hdfFreezerID.Value,
                    .SubdivisionTypeID = SubdivisionTypes.Shelf,
                    .SubdivisionName = GetGlobalResourceObject("Labels", "Lbl_New_Shelf_Text"),
                    .RowAction = RecordConstants.Insert,
                    .RowStatus = RecordConstants.ActiveRowStatus
                }
            Else
                freezerSubdivisions = CType(Session(SESSION_FREEZER_SUBDIVISIONS_LIST), List(Of LabFreezerSubdivisionGetListModel))

                If freezerSubdivisions.Count = 0 Then
                    freezerSubdivision = New LabFreezerSubdivisionGetListModel With {
                        .FreezerID = hdfFreezerID.Value,
                        .SubdivisionID = identity,
                        .ParentSubdivisionID = hdfFreezerID.Value,
                        .SubdivisionTypeID = SubdivisionTypes.Shelf,
                        .SubdivisionName = GetGlobalResourceObject("Labels", "Lbl_New_Shelf_Text"),
                        .RowAction = RecordConstants.Insert,
                        .RowStatus = RecordConstants.ActiveRowStatus
                    }
                Else
                    freezerSubdivision = freezerSubdivisions.Where(Function(x) x.SubdivisionID = treSubdivisions.SelectedValue).FirstOrDefault()

                    If freezerSubdivision.SubdivisionTypeID = SubdivisionTypes.Shelf Then
                        freezerSubdivision = New LabFreezerSubdivisionGetListModel With {
                            .FreezerID = hdfFreezerID.Value,
                            .ParentSubdivisionID = freezerSubdivision.SubdivisionID,
                            .SubdivisionID = identity,
                            .SubdivisionTypeID = SubdivisionTypes.Rack,
                            .SubdivisionName = GetGlobalResourceObject("Labels", "Lbl_New_Rack_Text"),
                            .RowAction = RecordConstants.Insert,
                            .RowStatus = RecordConstants.ActiveRowStatus
                        }
                    Else
                        freezerSubdivision = New LabFreezerSubdivisionGetListModel With {
                            .FreezerID = hdfFreezerID.Value,
                            .ParentSubdivisionID = freezerSubdivision.SubdivisionID,
                            .SubdivisionID = identity,
                            .SubdivisionTypeID = SubdivisionTypes.Box,
                            .SubdivisionName = GetGlobalResourceObject("Labels", "Lbl_New_Box_Text"),
                            .RowAction = RecordConstants.Insert,
                            .RowStatus = RecordConstants.ActiveRowStatus
                        }
                        txtNumberOfLocations.Enabled = False
                    End If
                End If
            End If

            divFreezerAttributes.Visible = False
            divSubdivisionAttributes.Visible = True

            freezerSubdivision.OrganizationID = hdfSiteID.Value

            Scatter(divSubdivisionAttributes, freezerSubdivision, 3)

            freezerSubdivisions.Add(freezerSubdivision)

            Session(SESSION_FREEZER_SUBDIVISIONS_LIST) = freezerSubdivisions

            treSubdivisions.Nodes.Clear()

            upStorageSchema.Update()

            treeViewList.Add(New TreeViewItem() With {.ParentID = 0, .ID = hdfFreezerID.Value, .Text = GetGlobalResourceObject("Labels", "Lbl_Freezer_Text") & " " & txtFreezerName.Text})

            For Each freezerSubdivision In freezerSubdivisions
                If freezerSubdivision.ParentSubdivisionID Is Nothing Then
                    freezerSubdivision.ParentSubdivisionID = hdfFreezerID.Value
                End If

                Select Case freezerSubdivision.SubdivisionTypeID
                    Case SubdivisionTypes.Shelf
                        treeViewList.Add(New TreeViewItem() With {.ParentID = freezerSubdivision.ParentSubdivisionID, .ID = freezerSubdivision.SubdivisionID, .Text = GetGlobalResourceObject("Labels", "Lbl_Shelf_Text") & " " & freezerSubdivision.SubdivisionName})
                    Case SubdivisionTypes.Rack
                        treeViewList.Add(New TreeViewItem() With {.ParentID = freezerSubdivision.ParentSubdivisionID, .ID = freezerSubdivision.SubdivisionID, .Text = GetGlobalResourceObject("Labels", "Lbl_Rack_Text") & " " & freezerSubdivision.SubdivisionName})
                    Case SubdivisionTypes.Box
                        treeViewList.Add(New TreeViewItem() With {.ParentID = freezerSubdivision.ParentSubdivisionID, .ID = freezerSubdivision.SubdivisionID, .Text = GetGlobalResourceObject("Labels", "Lbl_Box_Text") & " " & freezerSubdivision.SubdivisionName})
                End Select
            Next

            Dim binding = New TreeNodeBinding With {.TextField = "Text", .ValueField = "ID"}
            treSubdivisions.DataBindings.Add(binding)

            PopulateTreeView(0, Nothing)

            treSubdivisions.ExpandAll()

            upStorageSchema.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddFreezer_Click(sender As Object, e As EventArgs) Handles btnAddFreezer.Click

        Try
            ResetForm(divStorageSchema)
            EnableForm(divStorageSchema, True)
            btnAddSubdivision.Enabled = False
            btnCopySubdivision.Enabled = False
            btnDeleteSubdivision.Enabled = False

            treSubdivisions.Nodes.Clear()

            upStorageSchema.Update()

            hdfIdentity.Value = hdfIdentity.Value + 1
            Dim identity As Integer = (hdfIdentity.Value * -1)
            treeViewList.Add(New TreeViewItem() With {.ParentID = 0, .ID = hdfIdentity.Value, .Text = GetGlobalResourceObject("Labels", "Lbl_Freezer_Text") & " " & GetLocalResourceObject("Lbl_New_Freezer_Text")})

            Dim binding = New TreeNodeBinding With {.TextField = "Text", .ValueField = "ID"}
            treSubdivisions.DataBindings.Add(binding)

            PopulateTreeView(0, Nothing)

            treSubdivisions.ExpandAll()

            upStorageSchema.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub CopyFreezer_Click(sender As Object, e As EventArgs) Handles btnCopyFreezer.Click

        Try
            CopyFreezer()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub CopyFreezer()

        Try
            Dim freezerSubdivisions = New List(Of LabFreezerSubdivisionGetListModel)()
            Dim freezerSubdivision As LabFreezerSubdivisionGetListModel
            Dim shelfSubdivisionID As Integer,
                rackSubdivisionID As Integer

            txtFreezerName.Text = txtFreezerName.Text & " " & GetGlobalResourceObject("Labels", "Lbl_Copy_Placeholder_Text")
            txtEIDSSFreezerID.Text = String.Empty

            treSubdivisions.Nodes.Clear()
            hdfIdentity.Value = hdfIdentity.Value + 1
            Dim identity As Integer = (hdfIdentity.Value * -1)
            hdfFreezerID.Value = identity

            treeViewList.Add(New TreeViewItem() With {.ParentID = 0, .ID = identity, .Text = GetGlobalResourceObject("Labels", "Lbl_Freezer_Text") & " " & txtFreezerName.Text})

            If Not Session(SESSION_FREEZER_SUBDIVISIONS_LIST) Is Nothing Then
                freezerSubdivisions = CType(Session(SESSION_FREEZER_SUBDIVISIONS_LIST), List(Of LabFreezerSubdivisionGetListModel))
            End If

            For Each freezerSubdivision In freezerSubdivisions
                hdfIdentity.Value = hdfIdentity.Value + 1
                identity = (hdfIdentity.Value * -1)
                hdfFreezerSubdivisionIdentity.Value = identity

                freezerSubdivision.FreezerID = hdfFreezerID.Value
                freezerSubdivision.SubdivisionID = identity
                freezerSubdivision.EIDSSSubdivisionID = Nothing
                freezerSubdivision.RowAction = RecordConstants.Insert

                Select Case freezerSubdivision.SubdivisionTypeID
                    Case SubdivisionTypes.Shelf
                        freezerSubdivision.ParentSubdivisionID = hdfFreezerID.Value
                        shelfSubdivisionID = freezerSubdivision.SubdivisionID
                        treeViewList.Add(New TreeViewItem() With {.ParentID = freezerSubdivision.ParentSubdivisionID, .ID = freezerSubdivision.SubdivisionID, .Text = GetGlobalResourceObject("Labels", "Lbl_Shelf_Text") & " " & freezerSubdivision.SubdivisionName})
                    Case SubdivisionTypes.Rack
                        freezerSubdivision.ParentSubdivisionID = shelfSubdivisionID
                        rackSubdivisionID = freezerSubdivision.SubdivisionID
                        treeViewList.Add(New TreeViewItem() With {.ParentID = freezerSubdivision.ParentSubdivisionID, .ID = freezerSubdivision.SubdivisionID, .Text = GetGlobalResourceObject("Labels", "Lbl_Rack_Text") & " " & freezerSubdivision.SubdivisionName})
                    Case SubdivisionTypes.Box
                        freezerSubdivision.ParentSubdivisionID = rackSubdivisionID
                        Dim boxSize As String() = freezerSubdivision.BoxSizeTypeName.Split("X")
                        freezerSubdivision.BoxPlaceAvailability = BuildBoxConfiguration(boxSize(0), boxSize(1), New List(Of FreezerSubdivisionBoxLocationAvailability)())
                        treeViewList.Add(New TreeViewItem() With {.ParentID = freezerSubdivision.ParentSubdivisionID, .ID = freezerSubdivision.SubdivisionID, .Text = GetGlobalResourceObject("Labels", "Lbl_Box_Text") & " " & freezerSubdivision.SubdivisionName})
                End Select
            Next

            Dim binding = New TreeNodeBinding With {
                .TextField = "Text",
                .ValueField = "ID"
            }
            treSubdivisions.DataBindings.Add(binding)

            PopulateTreeView(0, Nothing)

            treSubdivisions.ExpandAll()

            Session(SESSION_FREEZER_SUBDIVISIONS_LIST) = freezerSubdivisions

            upStorageSchema.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub BoxSizeTypeID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlBoxSizeTypeID.SelectedIndexChanged

        Try
            If Not ddlBoxSizeTypeID.SelectedItem Is Nothing Then
                Dim boxSize As String() = ddlBoxSizeTypeID.SelectedItem.Text.Split("X")

                txtNumberOfLocations.Text = boxSize(0) * boxSize(1)

                txtNumberOfLocations.Enabled = False
            End If

            upStorageSchema.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub SubdivisionTypeID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlSubdivisionTypeID.SelectedIndexChanged

        Try
            If ddlSubdivisionTypeID.SelectedValue = SubdivisionTypes.Box Then
                txtNumberOfLocations.Enabled = False
                ToggleVisibility(BoxSection)
            Else
                txtNumberOfLocations.Enabled = True
                ToggleVisibility("")
            End If

            upStorageSchema.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddBoxSize_Click(sender As Object, e As EventArgs) Handles btnAddBoxSize.Click

        Try
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divBaseReferenceEditorModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub CopySubdivision_Click(sender As Object, e As EventArgs) Handles btnCopySubdivision.Click

        Try
            If treSubdivisions.SelectedValue = hdfFreezerID.Value Then
                CopyFreezer()
            Else
                If Not Session(SESSION_FREEZER_SUBDIVISIONS_LIST) Is Nothing Then
                    Dim freezerSubdivisions = CType(Session(SESSION_FREEZER_SUBDIVISIONS_LIST), List(Of LabFreezerSubdivisionGetListModel))
                    Dim childSubdivisions = freezerSubdivisions.Where(Function(x) x.ParentSubdivisionID = treSubdivisions.SelectedValue)

                    Dim identity As Integer = 0

                    For Each freezerSubdivision In childSubdivisions
                        hdfIdentity.Value = hdfIdentity.Value + 1
                        identity = (hdfIdentity.Value * -1)

                        freezerSubdivision.SubdivisionID = identity
                        freezerSubdivision.EIDSSSubdivisionID = String.Empty
                        freezerSubdivision.RowAction = RecordConstants.Insert
                        freezerSubdivision.RowStatus = RecordConstants.ActiveRowStatus

                        freezerSubdivisions.Add(freezerSubdivision)
                    Next

                    divFreezerAttributes.Visible = False
                    divSubdivisionAttributes.Visible = True

                    Session(SESSION_FREEZER_SUBDIVISIONS_LIST) = freezerSubdivisions

                    treSubdivisions.Nodes.Clear()

                    upStorageSchema.Update()

                    treeViewList.Add(New TreeViewItem() With {.ParentID = 0, .ID = hdfFreezerID.Value, .Text = GetGlobalResourceObject("Labels", "Lbl_Freezer_Text") & " " & txtFreezerName.Text})

                    For Each freezerSubdivision In freezerSubdivisions
                        If freezerSubdivision.ParentSubdivisionID Is Nothing Then
                            freezerSubdivision.ParentSubdivisionID = hdfFreezerID.Value
                        End If

                        Select Case freezerSubdivision.SubdivisionTypeID
                            Case SubdivisionTypes.Shelf
                                treeViewList.Add(New TreeViewItem() With {.ParentID = freezerSubdivision.ParentSubdivisionID, .ID = freezerSubdivision.SubdivisionID, .Text = GetGlobalResourceObject("Labels", "Lbl_Shelf_Text") & " " & freezerSubdivision.SubdivisionName})
                            Case SubdivisionTypes.Rack
                                treeViewList.Add(New TreeViewItem() With {.ParentID = freezerSubdivision.ParentSubdivisionID, .ID = freezerSubdivision.SubdivisionID, .Text = GetGlobalResourceObject("Labels", "Lbl_Rack_Text") & " " & freezerSubdivision.SubdivisionName})
                            Case SubdivisionTypes.Box
                                treeViewList.Add(New TreeViewItem() With {.ParentID = freezerSubdivision.ParentSubdivisionID, .ID = freezerSubdivision.SubdivisionID, .Text = GetGlobalResourceObject("Labels", "Lbl_Box_Text") & " " & freezerSubdivision.SubdivisionName})
                        End Select
                    Next

                    Dim binding = New TreeNodeBinding()
                    binding.TextField = "Text"
                    binding.ValueField = "ID"
                    treSubdivisions.DataBindings.Add(binding)

                    PopulateTreeView(0, Nothing)

                    treSubdivisions.ExpandAll()

                    upStorageSchema.Update()
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="freezerID"></param>
    Private Sub DeleteFreezer(ByVal freezerID As Long)

        Try
            upFreezers.Update()

            Dim freezers = CType(Session(SESSION_FREEZERS_LIST), List(Of LabFreezerGetListModel))
            Dim freezerSubdivisions = CType(Session(SESSION_FREEZER_SUBDIVISIONS_LIST), List(Of LabFreezerSubdivisionGetListModel))
            Dim freezer = freezers.Where(Function(x) x.FreezerID = freezerID).FirstOrDefault()
            Dim canDeleteFreezerIndicator = True

            For Each freezerSubdivision In freezerSubdivisions.Where(Function(x) x.FreezerID = freezerID)
                If CanDeleteSubdivision(freezerSubdivision:=freezerSubdivision) = False Then
                    canDeleteFreezerIndicator = False
                    Exit For
                End If
            Next

            If canDeleteFreezerIndicator = True Then
                hdfCurrentModuleAction.Value = MessageType.ConfirmDeleteFreezer.ToString()
                ShowWarningMessage(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=GetLocalResourceObject("Warning_Message_Confirm_Delete_Text"))
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub DeleteSubdivision_Click(sender As Object, e As EventArgs) Handles btnDeleteSubdivision.Click

        Try
            Dim freezerSubdivisions = CType(Session(SESSION_FREEZER_SUBDIVISIONS_LIST), List(Of LabFreezerSubdivisionGetListModel))
            Dim freezerSubdivision = freezerSubdivisions.Where(Function(x) x.SubdivisionID = treSubdivisions.SelectedNode.Value).FirstOrDefault()

            If CanDeleteSubdivision(freezerSubdivision) = True Then
                hdfCurrentModuleAction.Value = MessageType.ConfirmDeleteFreezerSubdivision.ToString()
                freezerSubdivision.RowAction = RecordConstants.Update
                freezerSubdivision.RowStatus = RecordConstants.InactiveRowStatus
                Session(SESSION_FREEZER_SUBDIVISIONS_LIST) = freezerSubdivisions
                ShowWarningMessage(messageType:=MessageType.ConfirmDeleteFreezerSubdivision, isConfirm:=True, message:=Nothing)

                upFreezers.Update()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="freezerSubdivision"></param>
    Private Function CanDeleteSubdivision(ByVal freezerSubdivision As LabFreezerSubdivisionGetListModel) As Boolean

        Dim freezerSubdivisions = CType(Session(SESSION_FREEZER_SUBDIVISIONS_LIST), List(Of LabFreezerSubdivisionGetListModel))
        Dim boxLocationAvailability = New List(Of FreezerSubdivisionBoxLocationAvailability)()
        If Not freezerSubdivision.BoxPlaceAvailability Is Nothing Then
            boxLocationAvailability = JsonConvert.DeserializeObject(Of List(Of FreezerSubdivisionBoxLocationAvailability))(freezerSubdivision.BoxPlaceAvailability)
        End If

        If freezerSubdivisions Is Nothing Then
            freezerSubdivisions = New List(Of LabFreezerSubdivisionGetListModel)()
        End If

        If freezerSubdivisions.Where(Function(x) x.ParentSubdivisionID = freezerSubdivision.SubdivisionID And x.ParentSubdivisionID IsNot Nothing).Count > 0 Then
            ShowWarningMessage(messageType:=MessageType.CannotDeleteSubdivision, isConfirm:=False, message:=GetLocalResourceObject("Warning_Message_Unable_To_Delete_Subdivision_Text"))
        Else
            If boxLocationAvailability.Count > 0 Then
                If boxLocationAvailability.Where(Function(x) x.AvailabilityIndicator = False).Count > 0 Then
                    ShowWarningMessage(messageType:=MessageType.CannotDeleteSubdivision, isConfirm:=False, message:=GetLocalResourceObject("Warning_Message_Has_Samples_Body_Text"))
                Else
                    Return True
                End If
            Else
                Return True
            End If
        End If

        Return False

    End Function

#End Region

End Class