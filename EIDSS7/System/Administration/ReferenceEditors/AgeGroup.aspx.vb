Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class AgeGroup
    Inherits BaseEidssPage

    Private ReadOnly ageGroupAPIClient As AgeGroupServiceClient
    Private ReadOnly baseReferenceLookupClient As BaseReferenceClient
    Private language As String
    Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(AgeGroup))
    Private gridViewSortDirection As SortDirection

    Sub New()
        ageGroupAPIClient = New AgeGroupServiceClient()
        baseReferenceLookupClient = New BaseReferenceClient()
        language = GetCurrentLanguage()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            log.Info("Age Group Reference Editor page load begins")
            If Not IsPostBack Then
                PopulateGrid()

                ddlAGidfsAgeType.DataSource = baseReferenceLookupClient.GetBaseReferneceTypes(19000042)
                ddlAGidfsAgeType.DataValueField = "idfsBaseReference"
                ddlAGidfsAgeType.DataTextField = "strDefault"
                ddlAGidfsAgeType.DataBind()
            End If
            log.Info("Age Group Reference Editor page load complete")
        Catch ex As Exception
            log.Error("Age Group Reference Editor page: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading_Age_Group_Page.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

#Region "buttons"

    Protected Sub btnAddReference_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddReference.Click
        log.Info("Age Group reference modal creator upload begins")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addAgeGroup');});", True)
        log.Info("Age Group reference modal creator upload complete")
    End Sub

    Protected Sub btnAgeGroup_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSaveAgeGroup.ServerClick
        Try
            log.Info("Age Group reference creation begins")
            hdfAGValidationError.Value = True
            If (String.IsNullOrEmpty(txtAGstrDefault.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtAGstrName.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                Exit Sub
            Else

                Dim agsp As AdminReferenceAgeGroupSetParams = New AdminReferenceAgeGroupSetParams()
                agsp.idfsAgeGroup = Nothing
                agsp.strDefault = txtAGstrDefault.Text.Trim()
                agsp.strName = txtAGstrName.Text.Trim()

                If Not String.IsNullOrEmpty(txtAGintOrder.Text) Then
                    agsp.intOrder = Convert.ToInt32(txtAGintOrder.Text)
                Else
                    agsp.intOrder = 0
                End If

                agsp.idfsAgeType = Convert.ToInt64(ddlAGidfsAgeType.SelectedValue)

                If Not String.IsNullOrEmpty(txtAGintLowerBoundary.Text) And Not String.IsNullOrEmpty(txtAGintUpperBoundary.Text) Then
                    agsp.intLowerBoundary = Convert.ToInt32(txtAGintLowerBoundary.Text)
                    agsp.intUpperBoundary = Convert.ToInt32(txtAGintUpperBoundary.Text)
                Else
                    agsp.intLowerBoundary = 0
                    agsp.intUpperBoundary = 1
                End If

                agsp.languageId = language

                    If agsp.intLowerBoundary >= agsp.intUpperBoundary Then
                        lbl_Error.InnerText = GetLocalResourceObject("lbl_Bad_Boundaries.InnerText")
                        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                        Exit Sub
                    End If

                    Dim results As String = ageGroupAPIClient.RefAgegroupSet(agsp).Result(0).ReturnMessage

                    If (results <> "DOES EXIST") Then
                        PopulateGrid()
                        lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Age_Group.InnerText") & " " & txtAGstrName.Text & GetLocalResourceObject("lbl_Period.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    clearAGForm()
                        log.Info("Age Group reference creation complete")
                    Else
                        log.Info("Age Group reference currently exists")
                        hdfAGValidationError.Value = True
                        lbl_Error.InnerText = GetLocalResourceObject("lbl_The_Age_Group.InnerText") & " " & txtAGstrName.Text.Trim() & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    End If
                End If
        Catch ex As Exception
            log.Error("Age Group reference creation error:", ex)
            hdfAGValidationError.Value = False
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Save.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnCancel_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelAgeGroup.ServerClick
        clearAGForm()
    End Sub

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Age Group reference deletion begins")
            Dim id As Int64 = Convert.ToInt64(hdfAGidfsAgeGroup.Value)
            Dim returnMsg As Integer = ageGroupAPIClient.RefAgegroupDel(id, False).Result(0).ReturnCode
            If returnMsg = -1 Then
                lbl_Delete_Anyway.InnerText = GetLocalResourceObject("lbl_Age_Group.InnerText") & " " & hdfAGstrName.Value & " " & GetLocalResourceObject("lbl_In_Use.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('currentlyInUseModal');});", True)
            Else
                PopulateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Age_Group.InnerText") & " " & hdfAGstrName.Value
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            End If
            log.Info("Age Group reference deletion complete")
        Catch ex As Exception
            log.Error("Age Group reference deletion error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnDeleteAnywayYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteAnywayYes.ServerClick
        Try
            log.Info("Age Group reference delete anyway begins")
            Dim id As Double = Convert.ToInt64(hdfAGidfsAgeGroup.Value)
            ageGroupAPIClient.RefAgegroupDel(id, True)
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Age_Group.InnerText") & " " & hdfAGstrName.Value
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("Age Group reference delete anyway complete")
        Catch ex As Exception
            log.Error("Age Group reference delete anyway error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        If hdfAGValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addAgeGroup');});", True)
        End If
    End Sub
#End Region

#Region "grid view"
    Protected Sub gvAgeGroups_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvAgeGroups.PageIndexChanging
        Try
            log.Info("Age Group Reference Editor record paging begins.")
            gvAgeGroups.PageIndex = e.NewPageIndex
            If Not IsNothing(ViewState("SortDirection")) And Not IsNothing(ViewState("SortField")) Then
                sorting(ViewState("SortField"), ViewState("SortDirection"))
            Else
                PopulateGrid()
            End If
            log.Info("Age Group Reference Editor record paging begins.")
        Catch ex As Exception
            log.Error("Age Group Reference Editor record paging error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub gvAgeGroups_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvAgeGroups.Sorting
        Try
            log.Info("Age Group Reference Editor record sort begins.")
            sorting(e.SortExpression, e.SortDirection)
            log.Info("Age Group Reference Editor record sort complete.")
        Catch ex As Exception
            log.Error("Error sorting Age Group Reference Editor records: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Sorting.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvAgeGroups_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvAgeGroups.RowCancelingEdit
        Try
            log.Info("Age Group Reference Editor return to regular mode begins.")
            gvAgeGroups.EditIndex = -1
            PopulateGrid()
            log.Info("Age Group Reference Editor return to regular mode complete.")
        Catch ex As Exception
            log.Error("Error returning to regular mode Age Group Reference Editor records: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel_Edit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvAgeGroups_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvAgeGroups.RowEditing
        Try
            log.Info("Age Group Reference Editor convert to edit mode begins.")
            gvAgeGroups.EditIndex = e.NewEditIndex
            PopulateGrid()
            log.Info("Age Group Reference Editor convert to edit mode begins.")
        Catch ex As Exception
            log.Error("Error convert to edit mode Age Group Reference Editor records: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Edit_Mode.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
            Exit Sub
        End Try
    End Sub

    Private Sub gvAgeGroups_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvAgeGroups.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then

            Dim ddlidsfAgeType As DropDownList = e.Row.FindControl("ddlidsfAgeType")
            If Not IsNothing(ddlidsfAgeType) Then
                ddlidsfAgeType.DataSource = baseReferenceLookupClient.GetBaseReferneceTypes(19000042)
                ddlidsfAgeType.DataValueField = "idfsBaseReference"
                ddlidsfAgeType.DataTextField = "strDefault"
                ddlidsfAgeType.DataBind()
                ddlidsfAgeType.SelectedValue = gvAgeGroups.DataKeys(e.Row.RowIndex)("idfsAgeType")
            End If
        End If
    End Sub

    Private Sub gvAgeGroups_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvAgeGroups.RowUpdating
        Try
            log.Info("Age Group Reference Editor record update begins.")
            Dim gvr As GridViewRow = gvAgeGroups.Rows(e.RowIndex)
            Dim agsp As AdminReferenceAgeGroupSetParams = New AdminReferenceAgeGroupSetParams()

            agsp.idfsAgeGroup = gvAgeGroups.DataKeys(e.RowIndex).Values(0)

            Dim txtstrDefault As TextBox = gvr.FindControl("txtstrDefault")
            If Not IsNothing(txtstrDefault) Then
                If String.IsNullOrEmpty(txtstrDefault.Text.Trim()) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    Exit Sub
                Else
                    agsp.strDefault = txtstrDefault.Text
                End If
            End If

            Dim txtstrName As TextBox = gvr.FindControl("txtstrName")
            If Not IsNothing(txtstrName) Then
                If String.IsNullOrEmpty(txtstrName.Text.Trim()) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    Exit Sub
                Else
                    agsp.strName = txtstrName.Text
                End If
            End If

            Dim txtintOrder As EIDSSControlLibrary.NumericSpinner = gvr.FindControl("txtOrder")
            If Not IsNothing(txtintOrder) Then
                If String.IsNullOrEmpty(txtintOrder.Text) Then
                    agsp.intOrder = 0
                Else
                    agsp.intOrder = Convert.ToInt32(txtintOrder.Text)
                End If
            End If

            Dim txtintLowerBoundary As EIDSSControlLibrary.NumericSpinner = gvr.FindControl("txtintLowerBoundary")
            Dim txtintUpperBoundary As EIDSSControlLibrary.NumericSpinner = gvr.FindControl("txtintUpperBoundary")

            If Not IsNothing(txtintLowerBoundary) And Not IsNothing(txtintUpperBoundary) Then
                If Not String.IsNullOrEmpty(txtintLowerBoundary.Text) And Not String.IsNullOrEmpty(txtintUpperBoundary.Text) Then
                    Dim lowBound As Int32 = Convert.ToInt32(txtintLowerBoundary.Text)
                    Dim uppBound As Int32 = Convert.ToInt32(txtintUpperBoundary.Text)

                    If lowBound > uppBound Then
                        lbl_Error.InnerText = GetLocalResourceObject("lbl_Bad_Boundaries.InnerText")
                        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                        Exit Sub
                    Else
                        If Not String.IsNullOrEmpty(txtintLowerBoundary.Text) Then
                            agsp.intLowerBoundary = Convert.ToInt32(txtintLowerBoundary.Text)
                        End If

                        If Not String.IsNullOrEmpty(txtintUpperBoundary.Text) Then
                            agsp.intUpperBoundary = Convert.ToInt32(txtintUpperBoundary.Text)
                        End If
                    End If
                Else
                    agsp.intLowerBoundary = 0
                    agsp.intUpperBoundary = 1
                End If
            End If

            Dim ddlidsfAgeType As DropDownList = gvr.FindControl("ddlidsfAgeType")
            If Not IsNothing(ddlidsfAgeType) Then
                agsp.idfsAgeType = Convert.ToInt64(ddlidsfAgeType.SelectedValue)
            End If
            agsp.languageId = language

            Dim results As String = ageGroupAPIClient.RefAgegroupSet(agsp).Result(0).ReturnMessage

            If (results = "SUCCESS") Then
                gvAgeGroups.EditIndex = -1
                PopulateGrid()
                log.Info("Age Group Reference Editor record update complete.")
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Age_Group.InnerText") & " " & txtstrName.Text & "."
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            ElseIf (results = "DOES EXIST") Then
                log.Info("Age Group reference currently exists")
                hdfAGValidationError.Value = False
                lbl_Error.InnerText = GetLocalResourceObject("lbl_The_Age_Group.InnerText") & " " & txtstrName.Text.Trim() & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
            End If
        Catch ex As Exception
            log.Error("Error updating Age Group Reference Editor record: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Save.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvAgeGroups_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvAgeGroups.RowDeleting
        Try
            log.Info("Age Group Reference Editor delete information gathering begins.")
            Dim id As Double = gvAgeGroups.DataKeys(e.RowIndex)("idfsAgeGroup")
            hdfAGidfsAgeGroup.Value = id
            Dim gvr As GridViewRow = gvAgeGroups.Rows(e.RowIndex)
            Dim lblstrName As Label = gvr.FindControl("lblstrName")
            If Not IsNothing(lblstrName) Then
                hdfAGstrName.Value = lblstrName.Text
            End If
            log.Info("Age Group Reference Editor delete information gathering complete.")
            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Age_Group_Question_Delete.InnerText") & " " & hdfAGstrName.Value & GetLocalResourceObject("lbl_Question_Mark.InnerText") & " " & GetLocalResourceObject("lbl_Cannot_Be_Undone.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
        Catch ex As Exception
            log.Error("Error gathering Age Group Reference Editor delete information: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

#End Region
    Private Sub PopulateGrid()

        Dim ageGroupRefList As List(Of RefAgegroupGetListModel) = ageGroupAPIClient.RefAgegroupGetList(language).Result
        gvAgeGroups.DataSource = ageGroupRefList
        gvAgeGroups.DataBind()
    End Sub

    Private Sub sorting(expression As String, direction As SortDirection)
        Dim sortExpression As String = expression

        If ViewState("SortField") = expression Then
            If ViewState("SortDirection") = SortDirection.Ascending Then
                orderGrid(sortExpression, SortDirection.Descending, False)
                ViewState("SortDirection") = SortDirection.Descending
            Else
                orderGrid(sortExpression, SortDirection.Ascending, False)
                ViewState("SortDirection") = SortDirection.Ascending
            End If
        Else
            orderGrid(sortExpression, direction, True)
            ViewState("SortDirection") = SortDirection.Ascending
        End If

        ViewState("SortField") = sortExpression
    End Sub

    Private Sub orderGrid(sortField As String, sortDirection As SortDirection, sortFieldChanged As Boolean)
        Dim ds As List(Of RefAgegroupGetListModel) = ageGroupAPIClient.RefAgegroupGetList(language).Result.ToList()
        If sortDirection = SortDirection.Ascending Then
            If sortField = "strDefault" Then
                gvAgeGroups.DataSource = (From d In ds
                                          Order By d.strDefault).ToList()
            ElseIf sortField = "strName" Then
                gvAgeGroups.DataSource = (From d In ds
                                          Order By d.strName).ToList()
            ElseIf sortField = "intOrder" Then
                gvAgeGroups.DataSource = (From d In ds
                                          Order By d.intOrder).ToList()
            ElseIf sortField = "intLowerBoundary" Then
                gvAgeGroups.DataSource = (From d In ds
                                          Order By d.intUpperBoundary).ToList()
            ElseIf sortField = "intUpperBoundary" Then
                gvAgeGroups.DataSource = (From d In ds
                                          Order By d.intUpperBoundary).ToList()
            ElseIf sortField = "ageTypeName" Then
                gvAgeGroups.DataSource = (From d In ds
                                          Order By d.AgeTypeName).ToList()
            End If
        Else
            If sortField = "strDefault" Then
                gvAgeGroups.DataSource = (From d In ds
                                          Order By d.strDefault Descending).ToList()
            ElseIf sortField = "strName" Then
                gvAgeGroups.DataSource = (From d In ds
                                          Order By d.strName Descending).ToList()
            ElseIf sortField = "intOrder" Then
                gvAgeGroups.DataSource = (From d In ds
                                          Order By d.intOrder Descending).ToList()
            ElseIf sortField = "intLowerBoundary" Then
                gvAgeGroups.DataSource = (From d In ds
                                          Order By d.intUpperBoundary Descending).ToList()
            ElseIf sortField = "intUpperBoundary" Then
                gvAgeGroups.DataSource = (From d In ds
                                          Order By d.intUpperBoundary Descending).ToList()
            ElseIf sortField = "ageTypeName" Then
                gvAgeGroups.DataSource = (From d In ds
                                          Order By d.AgeTypeName Descending).ToList()
            End If
        End If

        If sortFieldChanged Then
            gvAgeGroups.PageIndex = 0
        End If
        gvAgeGroups.DataBind()
    End Sub

    Private Sub clearAGForm()
        hdfAGidfsAgeGroup.Value = "NULL"
        hdfAGValidationError.Value = False
        txtAGstrName.Text = String.Empty
        txtAGstrDefault.Text = String.Empty
        txtAGintOrder.Text = String.Empty
        txtAGintUpperBoundary.Text = String.Empty
        txtAGintLowerBoundary.Text = String.Empty
        ddlAGidfsAgeType.SelectedIndex = -1
    End Sub

End Class