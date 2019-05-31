Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports System
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports log4net

Public Class CustomReportRows
	Inherits BaseEidssPage

    Private ReadOnly customReportAPIClient As CustomReportRowsServiceClient
    Private ReadOnly baseReferenceAPIClient As BaseReferenceClient
    Private ReadOnly crossCuttingAPIClient As CrossCuttingServiceClient
    Private ReadOnly diagnosisAPIClient As DiagnosisServiceClient
    Private ReadOnly reportDiagnosisGroupAPIClient As ReportDiagnosisGroupServiceClient
    Private language As String
    Private log As ILog = LogManager.GetLogger(GetType(CustomReportRows))

    Sub New()
		language = GetCurrentLanguage()
		crossCuttingAPIClient = New CrossCuttingServiceClient()
        customReportAPIClient = New CustomReportRowsServiceClient()
        diagnosisAPIClient = New DiagnosisServiceClient()
        baseReferenceAPIClient = New BaseReferenceClient()
        reportDiagnosisGroupAPIClient = New ReportDiagnosisGroupServiceClient()
    End Sub

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		Try
			If Not IsPostBack() Then
				log.Info("CustomReportRows page load begins")
				populationDropdowns()
				PopulateGrid()
				log.Info("CustomReportRows page load complete")
			End If
		Catch ex As Exception
			log.Error("CustomReportRows page load error", ex)
			lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading_Page.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

#Region "dropdown"

	Protected Sub ddlidfsCustomReportType_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlidfsCustomReportType.SelectedIndexChanged
		Try
			log.Info("Loading custom reports begins")
			PopulateGrid()
			log.Info("Loading custom reports complete")
		Catch ex As Exception
			log.Error("Error loading custom reports:", ex)
			lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading_Custom_Reports.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
		End Try
	End Sub

	Protected Sub ddlidfsDiagnosisOrReportDiseaseGroup_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsDiagnosisOrReportDiseaseGroup.SelectedIndexChanged
		If ddlidfsDiagnosisOrReportDiseaseGroup.SelectedValue = "19000019" Then
            bindDropdown(ddlidfsDiagnosis, crossCuttingAPIClient.GetBaseReferenceList(language, "Diagnosis", HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        Else
            bindDropdown(ddlidfsDiagnosis, crossCuttingAPIClient.GetBaseReferenceList(language, "Report Diagnosis Group", HACodeList.NoneHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        End If

		ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addCustomReportRow');});", True)
	End Sub

#End Region

#Region "buttons"

#Region "submit"

    Protected Sub btnSubmitCustomReportRow_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitCustomReportRow.ServerClick
        Try
            log.Info("Custom Report Row creation begins")
            hdfCRRValidationError.Value = True

            If (ddlidfsCustomReportType.SelectedIndex < 1) Then
                log.Info("Custom Report Type is required. Custom report exits")
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Custom_Report_Type_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (ddlidfsDiagnosisOrReportDiseaseGroup.SelectedIndex < 1) Then
                log.Info("Disease or Disease Group is required. Custom report exits")
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Disease_or_Group_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (ddlidfsDiagnosis.SelectedIndex < 1) Then
                log.Info("Disease name is required. Custom report exits")
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Disease_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else
                Dim confCustomReportRowParams As CustomReportSetParams = New CustomReportSetParams()

                confCustomReportRowParams.idfReportRows = Nothing
                confCustomReportRowParams.idfsCustomReportType = Convert.ToInt64(ddlidfsCustomReportType.SelectedValue)
                confCustomReportRowParams.idfsDiagnosisOrReportDiagnosisGroup = Convert.ToInt64(ddlidfsDiagnosis.SelectedValue)

                If ddlidfsReportAdditionalText.SelectedIndex > 0 Then
                    confCustomReportRowParams.idfsReportAdditionalText = Convert.ToInt64(ddlidfsReportAdditionalText.SelectedValue)
                Else
                    confCustomReportRowParams.idfsReportAdditionalText = Nothing
                End If

                If ddlidfsICDReportAdditionalText.SelectedIndex > 0 Then
                    confCustomReportRowParams.idfsIcdReportAdditionalText = Convert.ToInt64(ddlidfsICDReportAdditionalText.SelectedValue)
                Else
                    confCustomReportRowParams.idfsIcdReportAdditionalText = Nothing
                End If

                Dim results As List(Of ConfCustomreportSetModel) = customReportAPIClient.SetConfCustomreport(confCustomReportRowParams).Result

                If results.Count > 0 Then
                    PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    log.Info("Custom Report Row creation complete")
                Else
                    Throw New Exception()
                End If
            End If
        Catch ex As Exception
            log.Error("Custom Report Row creation error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnSubmitDisease_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitDisease.ServerClick
        Try
            log.Info("Disease Reference creation begins")
            hdfCDValidationError.Value = True

            If (String.IsNullOrEmpty(txtCDstrDefault.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtCDstrName.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else

                Dim HaCode As Integer = 0
                For Each li As ListItem In lstCDHACode.Items
                    If li.Selected Then
                        HaCode = HaCode + Convert.ToInt16(li.Value)
                    End If
                Next

                If HaCode = 0 Then
                    hdfCDValidationError.Value = True
                    lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Accessory_Code_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                    Exit Sub
                Else

                    Dim diagnosisParams As ReferenceDiagnosisSetParams = New ReferenceDiagnosisSetParams()
                    diagnosisParams.idfsDiagnosis = Nothing
                    diagnosisParams.langId = language
                    diagnosisParams.strDefault = txtCDstrDefault.Text.Trim()
                    diagnosisParams.strName = txtCDstrName.Text.Trim()
                    diagnosisParams.strOieCode = txtCDstrOIECode.Text.Trim()
                    diagnosisParams.intHaCode = HaCode
                    diagnosisParams.idfsUsingType = Convert.ToInt64(ddlCDidfsUsingType.SelectedValue)
                    diagnosisParams.blnZoonotic = chkCDblnZoonotic.Checked
                    diagnosisParams.blnSyndrome = chkCDblnSyndrome.Checked
                    diagnosisParams.strPensideTest = Nothing
                    diagnosisParams.strSampleType = Nothing
                    diagnosisParams.strLabTest = Nothing

                    Dim results As String = diagnosisAPIClient.RefDiagnosisreferenceSet(diagnosisParams).Result(0).ReturnMessage

                    If results = "SUCCESS" Then
                        RepopulateDDropdown()
                        lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                        log.Info("Disease Reference creation complete")
                    Else
                        lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_Disease.InnerText") & txtCDstrName.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                        log.Info("Disease Reference already exists")
                    End If
                End If
            End If
        Catch ex As Exception
            log.Error("Disease Reference creation error:", ex)
            hdfCDValidationError.Value = False
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Create.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnSubmitReportAdditionalText_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitReportAdditionalText.ServerClick
        Try
            log.Info("Report Additional Text reference creation begins")
            hdfRATValidationError.Value = True

            If (String.IsNullOrEmpty(txtRATstrDefault.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtRATstrName.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else

                Dim baseRefParams As AdminBaseReferenceSetParams = New AdminBaseReferenceSetParams()
                baseRefParams.idfsBaseReference = Nothing
                baseRefParams.idfsReferenceType = 19000132
                baseRefParams.languageId = language
                baseRefParams.strDefault = txtRATstrDefault.Text.Trim()
                baseRefParams.strName = txtRATstrName.Text.Trim()
                baseRefParams.intHACode = 0

                If Not String.IsNullOrEmpty(txtRATintOrder.Text) Then
                    baseRefParams.intOrder = Convert.ToInt32(txtRATintOrder.Text)
                Else
                    baseRefParams.intOrder = 0
                End If

                Dim results As String = baseReferenceAPIClient.BaseReferneceSet(baseRefParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    RepopulateRATDropdown()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_ICD.InnerText") & txtRATstrDefault.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                End If
            End If
            log.Info("Report Additional Text reference creation complete")
        Catch ex As Exception
            log.Error("Report Additional Text reference creation error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnSubmitReportDiagnosisGroup_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitReportDiagnosisGroup.ServerClick
        Try
            log.Info("Report Diagnosis Group reference creation begins")
            hdfRDValidationError.Value = True

            If (String.IsNullOrEmpty(txtRDstrDefault.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtRDstrName.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else

                Dim rdgParams As RefReporDiagnosisTypeSetParams = New RefReporDiagnosisTypeSetParams()

                rdgParams.languageId = language
                rdgParams.idfsReportDiagnosisGroup = Nothing
                rdgParams.strDefault = txtRDstrDefault.Text.Trim()
                rdgParams.strCode = txtRDstrCode.Text.Trim()
                rdgParams.strName = txtRDstrName.Text.Trim()

                Dim results As String = reportDiagnosisGroupAPIClient.RefReportDiagnosisGroupSet(rdgParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    RepopulateRDDropdown()
                    hdfRDValidationError.Value = False
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_Report_Diagnosis_Group.InnerText") & txtRDstrName.Text.Trim() & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                End If
                log.Info("Report Diagnosis Group reference creation complete")
            End If
        Catch ex As Exception
            log.Error("Report Diagnosis Group reference creation error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnSubmitICD_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitICD.ServerClick
        Try
            log.Info("ICD reference creation begins")
            hdfRATValidationError.Value = True

            If (String.IsNullOrEmpty(txtICDstrDefault.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtICDstrName.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else

                Dim baseRefParams As AdminBaseReferenceSetParams = New AdminBaseReferenceSetParams()
                baseRefParams.idfsBaseReference = Nothing
                baseRefParams.idfsReferenceType = 19000132
                baseRefParams.languageId = language
                baseRefParams.strDefault = txtICDstrDefault.Text.Trim()
                baseRefParams.strName = txtICDstrName.Text.Trim()
                baseRefParams.intHACode = 0

                If Not String.IsNullOrEmpty(txtICDintOrder.Text) Then
                    baseRefParams.intOrder = Convert.ToInt32(txtICDintOrder.Text)
                Else
                    baseRefParams.intOrder = 0
                End If

                Dim results As String = baseReferenceAPIClient.BaseReferneceSet(baseRefParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    RepopulateICDDropdown()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_ICD.InnerText") & txtICDstrDefault.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                End If
            End If
            log.Info("ICD reference creation complete")
        Catch ex As Exception
            log.Error("ICD reference creation error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnSubmitCustomReportType_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitCustomReportType.ServerClick
        Try
            log.Info("Custom Report Type reference creation begins")
            hdfCRTValidationError.Value = True

            If (String.IsNullOrEmpty(txtCRTstrDefault.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                log.Info("Custom Report Type reference creation failed. English Value required.")
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtCRTstrName.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                log.Info("Custom Report Type reference creation failed. Translated Value required.")
                Exit Sub
            Else

                Dim baseRefParams As AdminBaseReferenceSetParams = New AdminBaseReferenceSetParams()
                baseRefParams.idfsBaseReference = Nothing
                baseRefParams.idfsReferenceType = 19000129
                baseRefParams.languageId = language
                baseRefParams.strDefault = txtCRTstrDefault.Text.Trim()
                baseRefParams.strName = txtCRTstrName.Text.Trim()
                baseRefParams.intHACode = 0

                If Not String.IsNullOrEmpty(txtCRTintOrder.Text) Then
                    baseRefParams.intOrder = Convert.ToInt32(txtCRTintOrder.Text)
                Else
                    baseRefParams.intOrder = 0
                End If

                Dim results As String = baseReferenceAPIClient.BaseReferneceSet(baseRefParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    RepopulateCRTDropdown()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    log.Info("Custom Report Type reference creation complete")
                Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_Custom_Report_Type.InnerText") & txtCRTstrDefault.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                    log.Info("Custom Report Type reference creation failed. Already existed.")
                End If
            End If
        Catch ex As Exception
            log.Error("ICD reference creation error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "add"
    Protected Sub btnAddCustomReportRows_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddCustomReportRows.Click, btnCancelNo.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addCustomReportRow');});", True)
    End Sub

    Protected Sub bbtnAddCustomReportType_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddCustomReportType.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addCustomReportType');});", True)
    End Sub

    Protected Sub btnAddDiseaseorReportDiseaseGroup_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddDiseaseorReportDiseaseGroup.ServerClick
        If ddlidfsDiagnosisOrReportDiseaseGroup.SelectedValue = "19000019" Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        ElseIf ddlidfsDiagnosisOrReportDiseaseGroup.SelectedValue = "19000130" Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addReportDiagnosisGroup');});", True)
        End If
    End Sub

    Protected Sub btnAddICD10_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddICD10.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addICD10');});", True)
    End Sub

    Protected Sub btnAddReportAdditionalText_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnReportAdditionalText.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addReportAdditionalText');});", True)
    End Sub

#End Region

#Region "ok"

    Protected Sub btnSuccessOK_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSuccessOK.ServerClick
        If hdfCRTValidationError.Value = True Or hdfCDValidationError.Value = True Or hdfRATValidationError.Value = True Or hdfICDValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addCustomReportRow');});", True)
            clearCRTForm()
            clearCDForm()
            clearRATForm()
            clearICDForm()
        ElseIf hdfCRRValidationError.Value = True Then
            clearCRRForm()
        End If
    End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        log.Info("Custom Report Row delete anyway complete")
        If hdfCDValidationError.Value = True Or hdfRATValidationError.Value = True Or hdfICDValidationError.Value = True Or hdfRDValidationError.Value Then
            clearICDForm()
            clearRATForm()
            clearCDForm()
            clearRDForm()
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addCustomReportRow');});", True)
        ElseIf hdfCRRValidationError.Value Then
            clearCRRForm()
        End If
        log.Info("Custom Report Row delete anyway complete")
    End Sub

#End Region

#Region "cancel"

    Protected Sub btnCancelDiseaseGroupDisease_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelCustomReportRow.ServerClick
        Try
            log.Info("Custom Report Row cancel begins")
            lbl_Cancel.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelModal');});", True)
            log.Info("Custom Report Row cancel complete")
        Catch ex As Exception
            log.Error("Custom Report Row cancel error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnCancelReference_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelDisease.ServerClick, btnCancelReportAdditionalText.ServerClick, btnCancelCustomReportType.ServerClick, btnCancelICD.ServerClick
        lbl_Cancel_Reference.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelReference');});", True)
    End Sub

    Protected Sub btnCancelReferenceYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceYes.ServerClick
        If hdfCDValidationError.Value = True Then
            clearCDForm()
        ElseIf hdfRATValidationError.Value = True Then
            clearRATForm()
        ElseIf hdfICDValidationError.Value = True Then
            clearICDForm()
        ElseIf hdfCRTValidationError.Value = True Then
            clearCRTForm()
        End If
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addCustomReportRow');});", True)
    End Sub

    Protected Sub btnCancelReferenceNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick
        If hdfCRTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addCustomReportType');});", True)
        ElseIf hdfCDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        ElseIf hdfRATValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addReportAdditionalTest');});", True)
        ElseIf hdfICDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addICD10');});", True)
        ElseIf hdfRDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addReportDiagnosisGroup');});", True)
        End If
    End Sub

#End Region

#Region "correction"

    Protected Sub btnContinueRequiredYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnContinueRequiredYes.ServerClick, btnAlreadyExistsYes.ServerClick
        If hdfCRRValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addCustomReportRow');});", True)
        ElseIf hdfCRTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addCustomReportType');});", True)
        ElseIf hdfCDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        ElseIf hdfRATValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addReportAdditionalTest');});", True)
        ElseIf hdfICDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addICD10');});", True)
        ElseIf hdfRDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addReportDiagnosisGroup');});", True)
        End If
    End Sub

    Protected Sub btnContinueRequiredNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnContinueRequiredNo.ServerClick, btnAlreadyExistsNo.ServerClick
        If hdfCRRValidationError.Value Then
            clearCRRForm()
        ElseIf hdfCDValidationError.Value Then
            clearCDForm()
        ElseIf hdfRATValidationError.Value Then
            clearRATForm()
        ElseIf hdfICDValidationError.Value Then
            clearICDForm()
        ElseIf hdfRDValidationError.Value Then
            clearRDForm()
        End If
    End Sub

#End Region

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Custom Report Row delete anyway begins")
            Dim CRRId = Convert.ToInt64(hdfCRRidfReportRows.Value)
            Dim returnMessage As String = customReportAPIClient.DelConfCustomreport(CRRId, True).Result(0).returnMsg
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("Custom Report Row delete anyway complete")
        Catch ex As Exception
            log.Error("Custom Report Row delete anyway error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "grid view"
    Protected Sub gvCustomReportRows_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvCustomReportRows.PageIndexChanging
		Try
			log.Info("Custom Report Row pagination begin")
			gvCustomReportRows.PageIndex = e.NewPageIndex
			PopulateGrid()
			log.Info("Custom Report Row pagination complete")
		Catch ex As Exception
			log.Error("Custom Report Row record pagination error: " & ex.Message)
			lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

	Private Sub gvCustomReportRows_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvCustomReportRows.RowDeleting
		Try
			log.Info("Custom Report Row delete information gathering begins")
			Dim id As Int64 = Convert.ToInt64(gvCustomReportRows.DataKeys(e.RowIndex)(0))
			hdfCRRidfReportRows.Value = id
			lbl_Delete.InnerText = GetLocalResourceObject("lbl_Question_Delete.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
			log.Info("Custom Report Row delete information gathering complete")
		Catch ex As Exception
			log.Error("Custom Report Row delete information gathering error: " & ex.Message)
			lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

#End Region

#Region "private"

#Region "Populate"

    Private Sub PopulateGrid()
		Dim customReportRows As List(Of ConfCustomreportGetlistModel) = customReportAPIClient.GetConfCustomreportsList(language, Convert.ToInt64(ddlidfsCustomReportType.SelectedValue)).Result
		gvCustomReportRows.DataSource = customReportRows
		gvCustomReportRows.DataBind()
	End Sub

    Private Sub populationDropdowns()
        bindDropdown(ddlidfsCustomReportType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.CustomReportType, HACodeList.NoneHACode).Result, "name", "idfsBaseReference", True, String.Empty)

        ddlidfsDiagnosisOrReportDiseaseGroup.Items.Add(New ListItem(String.Empty, "0"))
        ddlidfsDiagnosisOrReportDiseaseGroup.Items.Add(New ListItem(GetLocalResourceObject("lbl_Disease.InnerText"), "19000019"))
        ddlidfsDiagnosisOrReportDiseaseGroup.Items.Add(New ListItem(GetLocalResourceObject("lbl_Report_Disease_Group.InnerText"), "19000130"))

        If ddlidfsDiagnosisOrReportDiseaseGroup.SelectedValue = "19000019" Then
            bindDropdown(ddlidfsDiagnosis, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        Else
            bindDropdown(ddlidfsDiagnosis, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.ReportDiagnosisGroup, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        End If

        bindDropdown(ddlidfsReportAdditionalText, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.ReportAdditionalText, HACodeList.NoneHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlidfsICDReportAdditionalText, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.ReportAdditionalText, HACodeList.NoneHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlCDidfsUsingType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.DiagnosisUsingType, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
    End Sub

    Private Sub bindDropdown(ByRef ddl As DropDownList, ByVal dl As Object, ByVal tf As String, ByVal vf As String, ByVal addBlank As Boolean, Optional ByVal blankText As String = "")
        ddl.Items.Clear()
        If addBlank Then
            ddl.Items.Add(New ListItem(blankText, "0"))
        End If
        ddl.DataSource = dl
        ddl.DataTextField = tf
        ddl.DataValueField = vf
        ddl.DataBind()
    End Sub

#Region "Repopulate"

    Private Sub RepopulateDDropdown()
        ddlidfsDiagnosis.Items.Clear()
        bindDropdown(ddlidfsDiagnosis, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsDiagnosis.Items.FindByText(txtCDstrName.Text).Selected = True
    End Sub

    Private Sub RepopulateRDDropdown()
        ddlidfsDiagnosis.Items.Clear()
        bindDropdown(ddlidfsDiagnosis, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.ReportDiagnosisGroup, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsDiagnosis.Items.FindByText(txtRDstrName.Text).Selected = True
    End Sub

    Private Sub RepopulateRATDropdown()
        ddlidfsReportAdditionalText.Items.Clear()
        bindDropdown(ddlidfsReportAdditionalText, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.ReportAdditionalText, HACodeList.NoneHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsReportAdditionalText.Items.FindByText(txtRATstrName.Text).Selected = True
    End Sub

    Private Sub RepopulateICDDropdown()
        ddlidfsICDReportAdditionalText.Items.Clear()
        bindDropdown(ddlidfsICDReportAdditionalText, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.ReportAdditionalText, HACodeList.NoneHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsICDReportAdditionalText.Items.FindByText(txtICDstrName.Text).Selected = True
    End Sub

    Private Sub RepopulateCRTDropdown()
        ddlidfsCustomReportType.Items.Clear()
        bindDropdown(ddlidfsCustomReportType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.CustomReportType, HACodeList.NoneHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsCustomReportType.Items.FindByText(txtCRTstrName.Text).Selected = True
    End Sub

#End Region

#End Region

#Region "clear"
    Private Sub clearCRRForm()
        hdfCRRidfReportRows.Value = "NULL"
        hdfCRRValidationError.Value = False
        ddlidfsDiagnosis.SelectedIndex = -1
        ddlidfsReportAdditionalText.SelectedIndex = -1
        ddlidfsICDReportAdditionalText.SelectedIndex = -1
        ddlidfsDiagnosisOrReportDiseaseGroup.SelectedIndex = -1
    End Sub

    Private Sub clearCDForm()
        hdfCDidfsDiagnosis.Value = "NULL"
        txtCDstrName.Text = String.Empty
        txtCDstrDefault.Text = String.Empty
        txtCDintOrder.Text = String.Empty
        txtCDstrIDC10.Text = String.Empty
        txtCDstrOIECode.Text = String.Empty
        ddlCDidfsUsingType.SelectedIndex = -1
    End Sub

    Private Sub clearRDForm()
        hdfRDValidationError.Value = "NULL"
        txtRDstrName.Text = String.Empty
        txtRDstrDefault.Text = String.Empty
        txtRDstrCode.Text = String.Empty
    End Sub

    Private Sub clearCRTForm()
        txtCRTintOrder.Text = String.Empty
        txtCRTstrDefault.Text = String.Empty
        txtCRTstrName.Text = String.Empty
        hdfCRTValidationError.Value = False
    End Sub

    Private Sub clearRATForm()
        txtRATintOrder.Text = String.Empty
        txtRATstrDefault.Text = String.Empty
        txtRATstrName.Text = String.Empty
        hdfRATValidationError.Value = False
    End Sub

    Private Sub clearICDForm()
        txtICDintOrder.Text = String.Empty
        txtICDstrDefault.Text = String.Empty
        txtICDstrName.Text = String.Empty
        hdfICDValidationError.Value = False
    End Sub

#End Region

#End Region

End Class