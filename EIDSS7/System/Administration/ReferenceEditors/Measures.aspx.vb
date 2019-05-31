Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class Measures
    Inherits BaseEidssPage

    Private ReadOnly crossCuttingAPIClient As CrossCuttingServiceClient
    Private ReadOnly measuresAPIClient As MeasureReferenceServiceClient
    Private ReadOnly baseReferenceLookupClient As BaseReferenceClient
    Private ReadOnly globalAPIClient As GlobalServiceClient
    Private language As String
    Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(Measures))
    Private gridViewSortDirection As SortDirection

    Sub New()
        language = GetCurrentLanguage()
        crossCuttingAPIClient = New CrossCuttingServiceClient()
        measuresAPIClient = New MeasureReferenceServiceClient()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            log.Info("Measures reference editor page load begins.")
            If Not Page.IsPostBack() Then
                loadMeasuresReferenceTypes()
                populateGrid()
            End If
            log.Info("Measures reference editor page load complete.")
        Catch ex As Exception
            log.Error("Measures reference editor page load error", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading_Measure_Page.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub


#Region "buttons"

    Protected Sub btnAddReference_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddReference.Click
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addMeasure');});", True)
    End Sub

    Protected Sub btnSaveMeasures_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSaveMeasure.ServerClick
        Try
            log.Info("Measures reference creation begins.")
            hdfMEValidationError.Value = True
            If (String.IsNullOrWhiteSpace(txtMEstrDefault.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                log.Info("Measures reference is missing English value.")
                Exit Sub
            ElseIf (String.IsNullOrWhiteSpace(txtMEstrName.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                log.Info("Measures reference is missing translated value.")
                Exit Sub
            Else
                Dim measuresParams As RefMeasureReferenceSetParams = New RefMeasureReferenceSetParams()
                measuresParams.idfsBaseReference = Nothing
                measuresParams.idfsReferenceType = Convert.ToInt64(ddlMeasures.SelectedValue)
                measuresParams.languageId = language
                measuresParams.strDefault = txtMEstrDefault.Text.Trim()
                measuresParams.strName = txtMEstrName.Text.Trim()

                If String.IsNullOrEmpty(txtMEintOrder.Text.Trim()) Then
                    measuresParams.intOrder = 0
                Else
                    measuresParams.intOrder = Convert.ToInt32(txtMEintOrder.Text)
                End If

                measuresParams.strActionCode = txtMEstrActionCode.Text.Trim()

                Dim results As String = measuresAPIClient.RefMeasureReferenceSet(measuresParams).Result(0).ReturnMessage

                If results <> "DOES EXIST" Then
                    populateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Measure.InnerText") & " " & txtMEstrName.Text & "."
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    clearMEForm()
                    log.Info("Measures reference creation complete.")
                Else
                    hdfMEValidationError.Value = True
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_The_Measure.InnerText") & " " & txtMEstrName.Text.Trim() & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    log.Info("Measures reference already exists.")
                End If
            End If
        Catch ex As Exception
            log.Error("Measures reference creation error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Save.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        If hdfMEValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addMeasure');});", True)
        End If
    End Sub

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Measure reference delete begins")
            Dim returnMessage As String = measuresAPIClient.RefMeasureRefefenceDel(Convert.ToInt64(hdfMEidfsBaseReference.Value), Convert.ToInt64(ddlMeasures.SelectedValue), True).Result(0).ReturnMessage
            If returnMessage = "IN USE" Then
                lbl_Delete_Anyway.InnerText = GetLocalResourceObject("lbl_The_Measure.InnerText") & " " & hdfMEstrName.Value & " " & GetLocalResourceObject("lbl_In_Use.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('currentlyInUseModal');});", True)
                log.Info("Measure reference in use")
            Else
                populateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Measure.InnerText") & " " & hdfMEstrName.Value & " " & GetLocalResourceObject("lbl_Period.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                log.Info("Measures reference delete complete")
            End If
        Catch ex As Exception
            log.Error("Measure reference delete error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnDeleteAnywayYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteAnywayYes.ServerClick
        Try
            log.Info("Measures reference delete anyway begins")
            measuresAPIClient.RefMeasureRefefenceDel(Convert.ToInt64(hdfMEidfsBaseReference.Value), Convert.ToInt64(ddlMeasures.SelectedValue), True)
            populateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Measure.InnerText") & " " & hdfMEstrName.Value & " " & GetLocalResourceObject("lbl_Period.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)

            log.Info("Measures reference delete anyway complete")
        Catch ex As Exception
            log.Error("Measures reference delete anyway error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnCanceMeasures_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelMeasures.ServerClick
        clearMEForm()
    End Sub
#End Region

#Region "grid view"
    Protected Sub gvMeasures_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvMeasures.PageIndexChanging
        Try
            log.Info("Measures reference page indexing begins.")
            gvMeasures.PageIndex = e.NewPageIndex
            populateGrid()
            log.Info("Measures reference page index complete.")
        Catch ex As Exception
            log.Error("Measures reference page index error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvMeasures_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvMeasures.RowCancelingEdit
        Try
            log.Info("Measures reference records return to regular mode begins.")
            gvMeasures.EditIndex = -1
            populateGrid()
            ddlMeasures.Enabled = True
            log.Info("Measures reference records return to regular mode complete.")
        Catch ex As Exception
            log.Error("Measures reference records return to regular mode error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel_Edit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvMeasures_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvMeasures.RowEditing
        Try
            log.Info("Measures reference records convert to edit mode begins.")
            gvMeasures.EditIndex = e.NewEditIndex
            populateGrid()
            ddlMeasures.Enabled = False
            log.Info("Measures reference records convert to edit mode begins.")
        Catch ex As Exception
            log.Error("Measures reference records convert to edit mode error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Row_Edit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvMeasures_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvMeasures.RowUpdating
        Try
            log.Info("Measures reference update begins.")
            hdfMEValidationError.Value = False
            Dim gvr As GridViewRow = gvMeasures.Rows(e.RowIndex)
            Dim measuresParams As RefMeasureReferenceSetParams = New RefMeasureReferenceSetParams()

            measuresParams.idfsBaseReference = Convert.ToInt64(gvMeasures.DataKeys(e.RowIndex).Values("idfsAction"))
            measuresParams.idfsReferenceType = Convert.ToInt64(ddlMeasures.SelectedValue)
            measuresParams.languageId = language

            Dim txtstrDefault As TextBox = gvr.FindControl("txtstrDefault")
            If Not IsNothing(txtstrDefault) Then
                If String.IsNullOrEmpty(txtstrDefault.Text.Trim()) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    Exit Sub
                Else
                    measuresParams.strDefault = txtstrDefault.Text.Trim()
                End If
            End If

            Dim txtstrName As TextBox = gvr.FindControl("txtstrName")
            If Not IsNothing(txtstrName) Then
                If String.IsNullOrWhiteSpace(txtstrName.Text.Trim()) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    Exit Sub
                Else
                    measuresParams.strName = txtstrName.Text.Trim()
                End If
            End If

            Dim txtstrActionCode As TextBox = gvr.FindControl("txtstrActionCode")
            If Not IsNothing(txtstrActionCode) Then
                If Not String.IsNullOrEmpty(txtstrActionCode.Text.Trim()) Then
                    measuresParams.strActionCode = txtstrActionCode.Text.Trim()
                End If
            End If

            Dim txtintOrder As TextBox = gvr.FindControl("txtintOrder")
            If Not IsNothing(txtintOrder) Then
                If Not IsNothing(txtintOrder.Text) Then
                    measuresParams.intOrder = Convert.ToInt32(txtintOrder.Text)
                Else
                    measuresParams.intOrder = 0
                End If
            End If

            Dim results As String = measuresAPIClient.RefMeasureReferenceSet(measuresParams).Result(0).ReturnMessage
            If results = "SUCCESS" Then
                gvMeasures.EditIndex = -1
                populateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Measure.InnerText") & " " & txtstrName.Text & GetLocalResourceObject("lbl_Period.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                hdfMEValidationError.Value = False
                ddlMeasures.Enabled = True
                log.Info("Measures reference records convert to edit mode complete.")
            ElseIf results = "DOES EXIST" Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_The_Measure.InnerText") & " " & txtMEstrName.Text.Trim() & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                log.Info("Measures reference already exists.")
            End If
        Catch ex As Exception
            log.Error("Measures reference update error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Save.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub gvMeasures_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvMeasures.RowDeleting
        Try
            log.Info("Measures reference delete information gathering begins.")
            hdfMEidfsBaseReference.Value = gvMeasures.DataKeys(e.RowIndex).Values("idfsAction")
            Dim lblstrName As Label = gvMeasures.Rows(e.RowIndex).FindControl("lblstrName")
            If Not IsNothing(lblstrName) Then
                hdfMEstrName.Value = lblstrName.Text.Trim()
            End If
            lblDeleteReference.InnerText = GetLocalResourceObject("lbl_Measure_Question_Delete.InnerText") & " " & hdfMEstrName.Value & GetLocalResourceObject("lbl_Question_Mark.InnerText") & " " & GetLocalResourceObject("lbl_Cannot_Be_Undone.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteReference');});", True)
            log.Info("Measures reference delete information gathering complete.")
        Catch ex As Exception
            log.Error("Measures reference delete information gathering error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete_Reference.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub
#End Region

    Private Sub ddlMeasures_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlMeasures.SelectedIndexChanged
        populateGrid()
    End Sub

    Private Sub loadMeasuresReferenceTypes()
        ddlMeasures.DataSource = measuresAPIClient.RefMeasureTypeGetList(language).Result
        ddlMeasures.DataValueField = "idfsReferenceType"
        ddlMeasures.DataTextField = "strReferenceTypeName"
        ddlMeasures.DataBind()
    End Sub

    Private Sub populateGrid()
        gvMeasures.DataSource = measuresAPIClient.RefMeasureReferenceGetList(language, Convert.ToInt64(ddlMeasures.SelectedValue)).Result
        gvMeasures.DataBind()
    End Sub

    Private Sub clearMEForm()
        hdfMEidfsBaseReference.Value = "NULL"
        hdfMEstrName.Value = "NULL"
        hdfMEValidationError.Value = False
        txtMEintOrder.Text = String.Empty
        txtMEstrDefault.Text = String.Empty
        txtMEstrName.Text = String.Empty
    End Sub
End Class