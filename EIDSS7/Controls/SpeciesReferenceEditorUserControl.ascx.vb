Imports System.Threading
Imports System.Globalization
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Public Class SpeciesReferenceEditorUserControl
    Inherits System.Web.UI.UserControl

#Region "Global Values"

    Private ReadOnly speciesTypeAPIClient As SpeciesTypeClient
    Private ReadOnly globalClient As GlobalServiceClient
    Private language As String
    Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(Dashboard))
    Private gridViewSortDirection As SortDirection

#End Region

    Sub New()
        speciesTypeAPIClient = New SpeciesTypeClient()
        globalClient = New GlobalServiceClient()
        language = GetCurrentLanguage()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            log.Info("Species Type Reference Editor Page Load begins.")
            If Not IsPostBack Then
                PopulateGrid()
                fillSPHACode()
            End If
            log.Info("Species Type Reference Editor Page Load complete.")
        Catch ex As Exception
            log.Error("Species Type Reference Editor Page Load error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading_Species_Type_Page.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesErrorReference');});", True)
        End Try
    End Sub


#Region "buttons"

    Protected Sub btnAddReference_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddReference.Click
        MultiView1.ActiveViewIndex = 1
        ' ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSpeciesType');});", True)
    End Sub

    Protected Sub btnSaveSpeciesType_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSaveSpeciesType.Click
        Try
            log.Info("Species Type Reference Create begins.")
            hdfSPValidationError.Value = True

            If (String.IsNullOrEmpty(txtSPstrDefault.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesErrorReference');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtSPstrName.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesErrorReference');});", True)
                Exit Sub
            Else
                Dim speciesTypeRefParams As RefSpeciesTypeReferenceSetParams = New RefSpeciesTypeReferenceSetParams()

                speciesTypeRefParams.idfsSpeciesType = Nothing
                speciesTypeRefParams.strDefault = txtSPstrDefault.Text.Trim()
                speciesTypeRefParams.strName = txtSPstrName.Text.Trim()
                speciesTypeRefParams.strCode = txtSPstrCode.Text.Trim()


                If (String.IsNullOrEmpty(txtSPintOrder.Text)) Then
                    speciesTypeRefParams.intOrder = 0
                Else
                    speciesTypeRefParams.intOrder = Convert.ToInt32(txtSPintOrder.Text)
                End If

                speciesTypeRefParams.intHaCode = Convert.ToInt32(ddlSPintHACode.SelectedValue)
                speciesTypeRefParams.languageId = language

                Dim results = speciesTypeAPIClient.RefSpeciesTypeSet(speciesTypeRefParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Species_Type.InnerText") & " " & txtSPstrName.Text & GetLocalResourceObject("lbl_Period.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesSuccessModal');});", True)
                    clearForm()
                Else
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_The_Species_Type.InnerText") & " " & txtSPstrName.Text & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesSuccessModal');});", True)
                End If
            End If
            ' log.Info("Species Type Reference Create complete.")
        Catch ex As Exception
            log.Error("Species Type Reference Create error. ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Save.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesErrorReference');});", True)
        End Try
    End Sub







    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        If hdfSPValidationError.Value Then
            '  ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSpeciesType');});", True)
            MultiView1.ActiveViewIndex = 0
        End If
    End Sub

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.Click
        Try
            log.Info("Species Type reference delete anyway begins")
            Dim returnMessage As String = speciesTypeAPIClient.RefSpeciesTypeDel(Convert.ToInt64(hdfSPidfsSpeciesType.Value), False).Result(0).ReturnMsg
            If returnMessage = "IN USE" Then
                lbl_Delete_Anyway.InnerText = GetLocalResourceObject("lbl_The_Species_Type.InnerText") & " " & hdfSPstrName.Value & " " & GetLocalResourceObject("lbl_In_Use.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesCurrentlyInUseModal');});", True)
                log.Info("Species Type reference in use")
            Else
                PopulateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Species_Type.InnerText") & " " & hdfSPstrName.Value & " " & GetLocalResourceObject("lbl_Period.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesSuccessModal');});", True)
                log.Info("Species Type reference delete complete")
            End If
        Catch ex As Exception
            log.Error("Species Type reference delete error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete_Reference.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesErrorReference');});", True)
        End Try
    End Sub

    Protected Sub btnDeleteAnywayYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteAnywayYes.ServerClick
        Try
            log.Info("Species Type reference delete anyway begins")
            speciesTypeAPIClient.RefSpeciesTypeDel(Convert.ToInt64(hdfSPidfsSpeciesType.Value), True)
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Species_Type.InnerText") & " " & hdfSPstrName.Value & " " & GetLocalResourceObject("lbl_Period.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesSuccessModal');});", True)
            log.Info("Species Type reference delete anyway complete")
        Catch ex As Exception
            log.Error("Species Type reference delete anyway error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete_Reference.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesErrorReference');});", True)
        End Try
    End Sub

    Protected Sub btnCancelSpeciesType_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelSpeciesType.ServerClick
        clearForm()
        MultiView1.ActiveViewIndex = 0
    End Sub
#End Region

#Region "grid view"
    Protected Sub gvSpeciesType_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvSpeciesType.PageIndexChanging
        Try
            log.Info("Species Type Reference retrieving next set of records begin.")
            gvSpeciesType.PageIndex = e.NewPageIndex
            If Not IsNothing(ViewState("SortDirection")) And Not IsNothing(ViewState("SortField")) Then
                sorting(ViewState("SortField"), ViewState("SortDirection"))
            Else
                PopulateGrid()
            End If
            log.Info("Species Type Reference retrieving next set of records complete.")
        Catch ex As Exception
            log.Error("Species Type Reference retrieving next set of records error. " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesErrorReference');});", True)
        End Try
    End Sub

    Protected Sub gvSpeciesType_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvSpeciesType.Sorting
        Try
            log.Info("Species Type Reference record sorting begins.")
            sorting(e.SortExpression, e.SortDirection)
            log.Info("Species Type Reference record sorting complete.")
        Catch ex As Exception
            log.Error("Species Type Reference record sorting error. " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Sorting.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesErrorReference');});", True)
        End Try
    End Sub

    Private Sub gvSpeciesType_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvSpeciesType.RowCancelingEdit
        Try
            log.Info("Species Type Reference record return to regular mode begins.")
            gvSpeciesType.EditIndex = -1
            PopulateGrid()
            log.Info("Species Type Reference record return to regular mode complete.")
        Catch ex As Exception
            log.Error("Species Type Reference record return to regular mode error. " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel_Edit_Error.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesErrorReference');});", True)
        End Try
    End Sub

    Private Sub gvSpeciesType_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvSpeciesType.RowEditing
        Try
            log.Info("Species Type Reference record paging begins.")
            gvSpeciesType.EditIndex = e.NewEditIndex
            PopulateGrid()
            log.Info("Species Type Reference record paging begins.")
        Catch ex As Exception
            log.Error("Species Type Reference converting record to edit mode error. ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Edit_Mode_Error.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesErrorReference');});", True)
        End Try
    End Sub

    Private Sub gvSpeciesType_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvSpeciesType.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim ddlHACode As DropDownList = e.Row.FindControl("ddlintHACode")
            If Not IsNothing(ddlHACode) Then
                ddlHACode.DataSource = globalClient.GetHaCodes(language, HACodeList.LiveStockAndAvian).Result.ToList()
                ddlHACode.DataValueField = "intHACode"
                ddlHACode.DataTextField = "CodeName"
                ddlHACode.DataBind()
                ddlHACode.SelectedValue = gvSpeciesType.DataKeys(e.Row.RowIndex)("intHACode").ToString()
            End If
        End If
    End Sub

    Private Sub gvSpeciesType_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvSpeciesType.RowUpdating
        Try
            log.Info("Species Type Reference record updating begins.")
            Dim speciesTypeSetParams As RefSpeciesTypeReferenceSetParams = New RefSpeciesTypeReferenceSetParams()

            hdfSPValidationError.Value = False
            Dim gvr As GridViewRow = gvSpeciesType.Rows(e.RowIndex)

            speciesTypeSetParams.idfsSpeciesType = Convert.ToInt64(gvSpeciesType.DataKeys(e.RowIndex).Values("idfsSpeciesType"))

            Dim txtstrDefault As TextBox = gvr.FindControl("txtstrDefault")
            If Not IsNothing(txtstrDefault) Then
                If String.IsNullOrEmpty(txtstrDefault.Text.Trim()) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesErrorReference');});", True)
                    Exit Sub
                Else
                    speciesTypeSetParams.strDefault = txtstrDefault.Text.Trim()
                End If
            End If

            Dim txtstrName As TextBox = gvr.FindControl("txtstrName")
            If Not IsNothing(txtstrName) Then
                If String.IsNullOrEmpty(txtstrName.Text.Trim()) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesErrorReference');});", True)
                    Exit Sub
                Else
                    speciesTypeSetParams.strName = txtstrName.Text.Trim()
                End If
            End If

            Dim txtintOrder As EIDSSControlLibrary.NumericSpinner = gvr.FindControl("txtintOrder")
            If Not IsNothing(txtintOrder) Then
                If String.IsNullOrEmpty(txtintOrder.Text) Then
                    speciesTypeSetParams.intOrder = 0
                Else
                    speciesTypeSetParams.intOrder = Convert.ToInt32(txtintOrder.Text)
                End If
            End If

            Dim txtstrCode As TextBox = gvr.FindControl("txtstrCode")
            If Not IsNothing(txtstrCode) Then
                speciesTypeSetParams.strCode = txtstrCode.Text.Trim()
            End If

            Dim ddlintHACode As DropDownList = gvr.FindControl("ddlintHACode")
            If Not IsNothing(ddlintHACode) Then
                speciesTypeSetParams.intHaCode = Convert.ToInt32(ddlintHACode.SelectedValue)
            End If

            speciesTypeSetParams.languageId = GetCurrentLanguage()
            Dim results As String = speciesTypeAPIClient.RefSpeciesTypeSet(speciesTypeSetParams).Result(0).ReturnMessage

            If results = "SUCCESS" Then
                gvSpeciesType.EditIndex = -1
                PopulateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Species_Type.InnerText") & " " & txtstrName.Text & GetLocalResourceObject("lbl_Period.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesSuccessModal');});", True)
                clearForm()
                log.Info("Species Type Reference record updating complete.")
            ElseIf results = "DOES EXIST" Then
                lblSuccess.InnerText = GetLocalResourceObject("lbl_The_Species_Type.InnerText") & " " & txtstrDefault.Text & " " & GetLocalResourceObject("lbl_Or.InnerText") & " " & txtstrName.Text & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesSuccessModal');});", True)
            End If
        Catch ex As Exception
            log.Error("Species Type Reference record updating error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Save.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesErrorReference');});", True)
        End Try
    End Sub

    Private Sub gvSpeciesType_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvSpeciesType.RowDeleting
        Try
            log.Info("Species Type Reference delete information gathering begins.")
            Dim id As Double = gvSpeciesType.DataKeys(e.RowIndex)("idfsSpeciesType")
            hdfSPidfsSpeciesType.Value = id

            Dim grvr As GridViewRow = gvSpeciesType.Rows(e.RowIndex)

            Dim lblstrName As Label = grvr.FindControl("lblstrName")
            If Not IsNothing(lblstrName) Then
                hdfSPstrName.Value = lblstrName.Text
            End If

            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Species_Type_Question_Delete.InnerText") & " " & hdfSPstrName.Value & GetLocalResourceObject("lbl_Question_Mark.InnerText") & " " & GetLocalResourceObject("lbl_Cannot_Be_Undone.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesDeleteModal');});", True)
            log.Info("Species Type Reference delete information gathering error.")
        Catch ex As Exception
            log.Error("Species Type Reference delete information gathering error:" & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('speciesErrorReference');});", True)
        End Try
    End Sub
#End Region

#Region "dropdown"
    Private Sub fillSPHACode()
        ddlSPintHACode.DataSource = globalClient.GetHaCodes(language, 96).Result
        ddlSPintHACode.DataValueField = "intHACode"
        ddlSPintHACode.DataTextField = "CodeName"
        ddlSPintHACode.DataBind()
    End Sub
#End Region

    Private Sub PopulateGrid()

        Dim speciesTypeRefList As List(Of RefSpeciestypeGetListModel) = speciesTypeAPIClient.RefSpeciesTypeGetList(language).Result.ToList()
        gvSpeciesType.DataSource = speciesTypeRefList
        gvSpeciesType.DataBind()

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
        Dim ds As List(Of RefSpeciestypeGetListModel) = speciesTypeAPIClient.RefSpeciesTypeGetList(language).Result.ToList()
        If sortDirection = SortDirection.Ascending Then
            If sortField = "strDefault" Then
                gvSpeciesType.DataSource = (From d In ds
                                            Order By d.strDefault).ToList()
            ElseIf sortField = "strName" Then
                gvSpeciesType.DataSource = (From d In ds
                                            Order By d.strName).ToList()
            ElseIf sortField = "intOrder" Then
                gvSpeciesType.DataSource = (From d In ds
                                            Order By d.intOrder).ToList()
            ElseIf sortField = "strHACodeNames" Then
                gvSpeciesType.DataSource = (From d In ds
                                            Order By d.strHACodeNames).ToList()
            End If
        Else
            If sortField = "strDefault" Then
                gvSpeciesType.DataSource = (From d In ds
                                            Order By d.strDefault Descending).ToList()
            ElseIf sortField = "strName" Then
                gvSpeciesType.DataSource = (From d In ds
                                            Order By d.strName Descending).ToList()
            ElseIf sortField = "intOrder" Then
                gvSpeciesType.DataSource = (From d In ds
                                            Order By d.intOrder Descending).ToList()
            ElseIf sortField = "strHACodeNames" Then
                gvSpeciesType.DataSource = (From d In ds
                                            Order By d.strHACodeNames Descending).ToList()
            End If
        End If

        If sortFieldChanged Then
            gvSpeciesType.PageIndex = 0
        End If
        gvSpeciesType.DataBind()
    End Sub

    Private Sub clearForm()
        txtSPintOrder.Text = String.Empty
        txtSPstrCode.Text = String.Empty
        txtSPstrDefault.Text = String.Empty
        txtSPstrName.Text = String.Empty
        ddlSPintHACode.SelectedIndex = -1
        hdfSPidfsSpeciesType.Value = "NULL"
        hdfSPValidationError.Value = False
        hdfSPstrName.Value = "NULL"
        MultiView1.ActiveViewIndex = 0

    End Sub

End Class