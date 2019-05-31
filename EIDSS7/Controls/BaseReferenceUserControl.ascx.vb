Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports EIDSS.Client.API_Clients
Imports Newtonsoft.Json
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts


Public Class BaseReferenceUserControl
    Inherits System.Web.UI.UserControl
    Private ReadOnly crossCuttingAPIClient As CrossCuttingServiceClient
    Private ReadOnly globalAPIClient As GlobalServiceClient
    Private ReadOnly baseRefAPIClient As BaseReferenceClient
    Private language As String
    Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(BaseReference))
    Private gridViewSortDirection As SortDirection

    Sub New()
        crossCuttingAPIClient = New CrossCuttingServiceClient()
        globalAPIClient = New GlobalServiceClient()
        baseRefAPIClient = New BaseReferenceClient()
        language = GetCurrentLanguage()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            If Not IsPostBack() Then
                log.Info("Base Reference Editor page load begins")
                loadDropdowns()
                populateGrid()
                log.Info("Base Reference Editor page load complete")
            End If
        Catch ex As Exception
            log.Error("Base Reference Editor page: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading_Age_Group_Page.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub ddlReferenceType_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlReferenceType.SelectedIndexChanged
        Try
            log.Info("Reference type change and base reference load begins")
            populateGrid()
            log.Info("Reference type change and base reference load begins")
        Catch ex As Exception
            log.Error("Base Reference delete error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading_Base_Reference.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

#Region "Buttons"

    Protected Sub btnDeleteYes_ServerClick(sender As Object, e As EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Base Reference delete begins")
            hdfBRValidationError.Value = False
            Dim idfsBaseReference As Int64 = Convert.ToInt64(hdfidfBaseReference.Value)
            Dim results As String = baseRefAPIClient.BaseReferenceDel(idfsBaseReference).Result(0).ReturnMessage
            populateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("Base Reference delete complete")
        Catch ex As Exception
            log.Error("Base Reference delete error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete_Reference.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnAddItem_ServerClick(sender As Object, e As EventArgs) Handles btnAddItem.ServerClick
        log.Info("Base reference modal creator upload begins")
        'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addBaseReference');});", True)
        MultiView1.ActiveViewIndex = 1
        log.Info("Base reference modal creator upload complete")
    End Sub

    Private Sub btnSaveReference_ServerClick(sender As Object, e As EventArgs) Handles btnSaveBaseReference.Click
        Try
            log.Info("base reference creation begins")
            hdfBRValidationError.Value = True
            If String.IsNullOrWhiteSpace(txtstrDefault.Text) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                log.Info("base reference creation failed: English Value is required")
                Exit Sub
            ElseIf String.IsNullOrWhiteSpace(txtstrName.Text) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                log.Info("base reference creation failed: Translated Value is required")
                Exit Sub
            Else
                Dim baseRefSetParams As AdminBaseReferenceSetParams = New AdminBaseReferenceSetParams()
                baseRefSetParams.idfsBaseReference = Nothing
                baseRefSetParams.idfsReferenceType = Convert.ToInt64(ddlReferenceType.SelectedValue)
                baseRefSetParams.strDefault = txtstrDefault.Text.Trim()
                baseRefSetParams.strName = txtstrName.Text.Trim()
                baseRefSetParams.blnSystem = False

                If Not String.IsNullOrEmpty(txtOrder.Text.Trim()) Then
                    baseRefSetParams.intOrder = Convert.ToInt32(txtOrder.Text)
                Else
                    baseRefSetParams.intOrder = 0
                End If

                If lstHACode.SelectedIndex < 0 Then
                    baseRefSetParams.intHACode = Nothing
                Else
                    Dim HACode As Integer = 0

                    For Each li As ListItem In lstHACode.Items
                        If li.Selected Then
                            HACode = HACode + Convert.ToInt32(li.Value)
                        End If
                    Next
                    baseRefSetParams.intHACode = HACode
                End If

                Dim results As String = baseRefAPIClient.BaseReferneceSet(baseRefSetParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    populateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Base_Reference.InnerText") & " " & txtstrName.Text & GetLocalResourceObject("lbl_Period.InnerText")
                    'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    clearBRForm()
                    log.Info("Base reference creation complete")
                ElseIf results = "DOES EXIST" Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_The_Base_Reference.InnerText") & " " & txtstrName.Text.Trim() & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    log.Info("Base reference currently exists")
                End If
            End If
        Catch ex As Exception
            log.Error("Base reference creation error", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Create.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnErrorOk_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        If hdfBRValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addBaseReference');});", True)
        End If
    End Sub

    Protected Sub btnCancelBaseReference_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelBaseReference.ServerClick
        clearBRForm()
    End Sub

#End Region

#Region "Gridview"

    Private Sub gvBaseReference_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvBaseReference.PageIndexChanging
        Try
            gvBaseReference.PageIndex = e.NewPageIndex
            populateGrid()
        Catch
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvBaseReference_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvBaseReference.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then

            Dim lstHACode As ListBox = e.Row.FindControl("lstHACode")

            If Not (lstHACode Is Nothing) Then
                lstHACode.DataSource = globalAPIClient.GetHaCodes(language, HACodeList.AllHACode).Result
                lstHACode.DataTextField = "CodeName"
                lstHACode.DataValueField = "intHACode"
                lstHACode.DataBind()

                'Select the HACode in List
                If (e.Row.RowIndex >= 0) Then
                    Dim sHACode As String = gvBaseReference.DataKeys(e.Row.RowIndex).Values("strHACode").ToString()
                    Dim aHACodeList = sHACode.Split(",")
                    For Each itm In aHACodeList
                        lstHACode.Items.FindByValue(itm).Selected = True
                    Next
                End If
            End If
        End If
    End Sub

    Private Sub gvBaseReference_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvBaseReference.RowEditing
        Try
            log.Info("Base reference convert to edit mode complete")
            gvBaseReference.EditIndex = e.NewEditIndex
            populateGrid()
            log.Info("Base reference convert to edit mode complete")
        Catch ex As Exception
            log.Error("Base reference convert to edit mode error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Row_Edit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvBaseReference_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvBaseReference.RowCancelingEdit
        Try
            log.Info("Base reference return to regular mode begin")
            gvBaseReference.EditIndex = -1
            populateGrid()
            log.Info("Base reference return to regular mode complete")
        Catch ex As Exception
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel_Edit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvBaseReference_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvBaseReference.RowUpdating
        Try
            log.Info("Base Reference update begin")
            hdfBRValidationError.Value = False
            Dim gvr As GridViewRow = gvBaseReference.Rows(e.RowIndex)
            Dim baseReferenceParams As AdminBaseReferenceSetParams = New AdminBaseReferenceSetParams()

            baseReferenceParams.idfsBaseReference = Convert.ToInt64(gvBaseReference.DataKeys(e.RowIndex).Values("idfsBaseReference"))
            baseReferenceParams.idfsReferenceType = Convert.ToInt64(gvBaseReference.DataKeys(e.RowIndex).Values("idfsReferenceType"))
            baseReferenceParams.languageId = language

            Dim txtstrDefault As TextBox = gvr.FindControl("txtstrDefault")
            If Not IsNothing(txtstrDefault) Then
                If String.IsNullOrEmpty(txtstrDefault.Text.Trim()) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    log.Info("Base Reference update fails. English value is required")
                    Exit Sub
                Else
                    baseReferenceParams.strDefault = txtstrDefault.Text.Trim()
                End If
            End If

            Dim txtstrName As TextBox = gvr.FindControl("txtstrName")
            If Not IsNothing(txtstrName) Then
                If String.IsNullOrWhiteSpace(txtstrName.Text.Trim()) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    log.Info("Base Reference update fails. Translated value is required")
                    Exit Sub
                Else
                    baseReferenceParams.strName = txtstrName.Text.Trim()
                End If
            End If

            Dim txtintOrder As EIDSSControlLibrary.NumericSpinner = gvr.FindControl("txtOrder")
            If Not IsNothing(txtintOrder) Then
                If String.IsNullOrWhiteSpace(txtintOrder.Text) Then
                    baseReferenceParams.intOrder = 0
                Else
                    baseReferenceParams.intOrder = Convert.ToInt32(txtintOrder.Text)
                End If
            End If

            Dim lstRowHACode As ListBox = gvr.FindControl("lstHACode")
            If Not IsNothing(lstRowHACode) Then
                Dim HaCode As Integer = 0
                For Each li As ListItem In lstRowHACode.Items
                    If li.Selected Then
                        HaCode = HaCode + Convert.ToInt16(li.Value)
                    End If
                Next
                baseReferenceParams.intHACode = HaCode
            Else
                baseReferenceParams.intHACode = Nothing
            End If

            baseReferenceParams.blnSystem = False

            Dim results As String = baseRefAPIClient.BaseReferneceSet(baseReferenceParams).Result(0).ReturnMessage

            If results = "SUCCESS" Then
                gvBaseReference.EditIndex = -1
                populateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Base_Reference.InnerText") & " " & txtstrName.Text & GetLocalResourceObject("lbl_Period.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                clearBRForm()
                log.Info("Base Reference update complete")
            Else
                lbl_Error.InnerText = GetLocalResourceObject("lbl_The_Base_Reference.InnerText") & " " & txtstrName.Text & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                log.Info("Base Reference exists elsewhere")
            End If
        Catch ex As Exception
            log.Error("Base reference update error", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Save.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub gvBaseReference_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvBaseReference.RowDeleting
        Try
            log.Info("Base reference delete information gathering begin")
            hdfidfBaseReference.Value = gvBaseReference.DataKeys(e.RowIndex).Values("idfsBaseReference")

            Dim lblstrName As Label = gvBaseReference.Rows(e.RowIndex).FindControl("lblstrName")
            If Not IsNothing(lblstrName) Then
                hdfstrName.Value = lblstrName.Text
            End If
            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Question_Delete_Base_Reference.InnerText") & " " & hdfstrName.Value & GetLocalResourceObject("lbl_Question_Mark.InnerText") & " " & GetLocalResourceObject("lbl_Cannot_Be_Undone.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteBaseReference');});", True)
            log.Info("Base reference delete information gathering complete")
        Catch ex As Exception
            log.Error("Base Reference delete information gathering error", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete_Reference.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

#End Region

    Private Sub loadDropdowns()
        ddlReferenceType.DataSource = crossCuttingAPIClient.GetBaseReferenceList(language, "Reference Type Name", 0).Result
        ddlReferenceType.DataValueField = "idfsBaseReference"
        ddlReferenceType.DataTextField = "strDefault"
        ddlReferenceType.DataBind()

        lstHACode.DataSource = globalAPIClient.GetHaCodes(language, HACodeList.AllHACode).Result
        lstHACode.DataValueField = "intHACode"
        lstHACode.DataTextField = "CodeName"
        lstHACode.DataBind()
    End Sub

    Private Sub populateGrid()
        Dim refs As List(Of RefBasereferenceGetListModel) = baseRefAPIClient.GetBaseReferences(Convert.ToInt64(ddlReferenceType.SelectedValue), language).Result
        gvBaseReference.DataSource = refs
        gvBaseReference.DataBind()
    End Sub

    Private Sub clearBRForm()
        txtOrder.Text = String.Empty
        txtstrDefault.Text = String.Empty
        txtstrName.Text = String.Empty
        lstHACode.SelectedIndex = -1
        hdfidfBaseReference.Value = "NULL"
        hdfstrName.Value = "NULL"
        hdfReferenceType.Value = "NULL"
        hdfBRValidationError.Value = False
        MultiView1.ActiveViewIndex = 0
    End Sub


End Class