Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports System
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports log4net

Public Class ReportDiseaseGroupDiseaseMatrix
	Inherits BaseEidssPage

	Private ReadOnly reportDiseaseGroupDiseaseAPIClent As ReportDiseaseGroupDiseaseServiceClient
    Private ReadOnly crossCuttingAPIClient As CrossCuttingServiceClient
    Private ReadOnly diagnosisAPIClient As DiagnosisServiceClient
    Private ReadOnly baseReferenceAPIClient As BaseReferenceClient
    Private ReadOnly reportDiagnosisGroupAPIClient As ReportDiagnosisGroupServiceClient
    Private ReadOnly globalAPIClient As GlobalServiceClient
    Private language As String
	Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(ReportDiseaseGroupDiseaseMatrix))

	Sub New()
		language = GetCurrentLanguage()
        crossCuttingAPIClient = New CrossCuttingServiceClient()
        diagnosisAPIClient = New DiagnosisServiceClient()
        baseReferenceAPIClient = New BaseReferenceClient()
        reportDiseaseGroupDiseaseAPIClent = New ReportDiseaseGroupDiseaseServiceClient()
        reportDiagnosisGroupAPIClient = New ReportDiagnosisGroupServiceClient()
        globalAPIClient = New GlobalServiceClient()
    End Sub

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		Try
			If Not IsPostBack() Then
				log.Info("ReportDiseaseGroupDiseaseMatrix page load begins")
				populationDropdowns()
				PopulateGrid()
				log.Info("ReportDiseaseGroupDiseaseMatrix page load complete")
			End If
		Catch ex As Exception
			log.Error("ReportDiseaseGroupDiseaseMatrix page load error", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
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
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
		End Try
	End Sub

	Protected Sub ddlidsfReportDiagnosisGroup_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidsfReportDiagnosisGroup.SelectedIndexChanged
		Try
			log.Info("Loading custom reports begins")
			PopulateGrid()
			log.Info("Loading custom reports complete")
		Catch ex As Exception
			log.Error("Error loading custom reports:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
		End Try
	End Sub

#End Region

#Region "buttons"

#Region "submit"

    Protected Sub btnSubmitDiseaseGroupDiseaseMatrix_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitReportDiseaseGroupDisease.ServerClick
		Try
			log.Info("Report Disease Group Disease creation begins")
            hdfRDGDValidationError.Value = True
            If (ddlidfsCustomReportType.SelectedIndex < 1) Then
                log.Info("Custom report type is required. Report Disease Group Disease creation exits")
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Custom_Report_Type_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (ddlidsfReportDiagnosisGroup.SelectedIndex < 1) Then
                log.Info("Report Disease Group is required. Report Disease Group Disease creation exits")
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Report_Disease_Group_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (ddlidfsDiagnosis.SelectedIndex < 1) Then
                log.Info("Disease is required. Report Disease Group Disease creation exits")
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Report_Disease_Group_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
                Exit Sub
            Else
                Dim reportdiseasegroupdiseasematrixSetParams As ConfReportdiseasegroupdiseasematrixSetParams = New ConfReportdiseasegroupdiseasematrixSetParams
                reportdiseasegroupdiseasematrixSetParams.idfDiagnosisToGroupForReportType = Nothing
                reportdiseasegroupdiseasematrixSetParams.idfsCustomReportType = Convert.ToInt64(ddlidfsCustomReportType.SelectedValue)
                reportdiseasegroupdiseasematrixSetParams.idfsDiagnosis = Convert.ToInt64(ddlidfsDiagnosis.SelectedValue)
                reportdiseasegroupdiseasematrixSetParams.idfsReportDiagnosisGroup = Convert.ToInt64(ddlidsfReportDiagnosisGroup.SelectedValue)

                Dim results As String = reportDiseaseGroupDiseaseAPIClent.SetConfReportdiseasegroupdisease(reportdiseasegroupdiseasematrixSetParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    log.Info("Report Disease Group Disease creation complete")
                ElseIf results = "DOES EXIST" Then
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible.InnerText") & ddlidsfReportDiagnosisGroup.SelectedItem.Text & "-" & ddlidfsDiagnosis.SelectedItem.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                    log.Info("Report Disease Group Disease exists")
                End If
            End If
        Catch ex As Exception
			log.Error("Report Disease Group Disease creation error: " & ex.Message)
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
            ElseIf ddlCDidfsUsingType.SelectedIndex < 1 Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Using_Type_Required.InnerText")
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
                        RepopulateCDDropdown()
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
                    log.Info("ICD reference creation complete")
                Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_ICD.InnerText") & txtCRTstrDefault.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
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

#End Region

#Region "add"

    Protected Sub btnAddReportDiseaseGroupDisease_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddReportDiseaseGroupDisease.Click, btnCancelNo.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addReportDiseaseGroupDisease');});", True)
        hdfRDGDValidationError.Value = True
    End Sub

    Protected Sub bbtnAddCustomReportType_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddCustomReportType.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addCustomReportType');});", True)
        hdfCRTValidationError.Value = True
    End Sub

    Protected Sub btnAddReportDiagnosisGroup_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddReportDiagnosisGroup.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addReportDiagnosisGroup');});", True)
        hdfRDValidationError.Value = True
    End Sub

    Protected Sub btnAddDisease_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddDisease.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        hdfCDValidationError.Value = True
    End Sub

#End Region

#Region "ok"

    Protected Sub btnSuccessOK_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSuccessOK.ServerClick
        If hdfCRTValidationError.Value = True Or hdfRDValidationError.Value = True Then
            clearCRTForm()
            clearRDForm()
            PopulateGrid()
        ElseIf hdfCDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addReportDiseaseGroupDisease');});", True)
            clearCDForm()
        ElseIf hdfRDGDValidationError.Value = True Then
            clearRDGDForm()
        End If
    End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        log.Info("Report Disease Group Disease delete anyway complete")
        If hdfRDGDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addReportDiseaseGroupDisease');});", True)
        End If
        log.Info("Report Disease Group Disease delete anyway complete")
    End Sub

#End Region

#Region "cancel"

    Protected Sub btnCancelDiseaseGroupDisease_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReportDiseaseGroupDisease.ServerClick
        Try
            log.Info("Report Disease Group Disease cancel begins")
            lbl_Cancel.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelModal');});", True)
            log.Info("Report Disease Group Disease cancel complete")
        Catch ex As Exception
            log.Error("Report Disease Group Disease cancel error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnCancelReference_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelDisease.ServerClick, btnCancelCustomReportType.ServerClick, btnCancelReportDiagnosisGroup.ServerClick
        lbl_Cancel_Reference.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelReference');});", True)
    End Sub

    Protected Sub btnCancelReferenceYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceYes.ServerClick
        If hdfCDValidationError.Value = True Then
            clearCDForm()
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseAgeGroup');});", True)
        ElseIf hdfCRTValidationError.Value = True Then
            clearCRTForm()
        ElseIf hdfRDValidationError.Value = True Then
            clearRDForm()
        End If
    End Sub

    Protected Sub btnCancelReferenceNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick
        If hdfCDValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        ElseIf hdfCRTValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addCustomRowType');});", True)
        ElseIf hdfRDValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addReportDiseaseGroup');});", True)
        End If
    End Sub

    Protected Sub btnCancelYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelYes.ServerClick
        log.Info("Report Disease Group Disease cancel begin")
        clearRDGDForm()
        log.Info("Report Disease Group Disease cancel complete")
    End Sub

    Protected Sub btnCancelNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelNo.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addReportDiseseseGroupDisease');});", True)
    End Sub

#End Region

#Region "correct"

    Protected Sub btnContinueRequiredYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnContinueRequiredYes.ServerClick, btnAlreadyExistsYes.ServerClick
        If hdfCRTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addCustomReportType');});", True)
        ElseIf hdfCDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        ElseIf hdfRDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addReportDiagnosisGroup');});", True)
        ElseIf hdfRDGDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addReportDiseseseGroupDisease');});", True)
        End If
    End Sub

    Protected Sub btnContinueRequiredNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnContinueRequiredNo.ServerClick, btnAlreadyExistsNo.ServerClick
        If hdfRDGDValidationError.Value Then
            clearRDGDForm()
        ElseIf hdfCDValidationError.Value Then
            clearCDForm()
        ElseIf hdfCRTValidationError.Value Then
            clearCRTForm()
        ElseIf hdfRDValidationError.Value Then
            clearRDForm()
        End If
    End Sub

#End Region

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Report Disease Group Disease delete begins")
            Dim RDGRId = Convert.ToInt64(hdfRDGDidfDiagnosisToGroupForReportType.Value)
            Dim returnMessage As String = reportDiseaseGroupDiseaseAPIClent.DelConfReportdiseasegroupdisease(RDGRId, True).Result(0).returnMsg
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("Report Disease Group Disease delete complete")
        Catch ex As Exception
            log.Error("Report Disease Group Disease delete error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "grid view"

    Protected Sub gvCustomReportRows_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvReportDiseaseGroupDiseaseMatrix.PageIndexChanging
		Try
			log.Info("Report Disease Group Disease pagination begin")
			gvReportDiseaseGroupDiseaseMatrix.PageIndex = e.NewPageIndex
			PopulateGrid()
			log.Info("Report Disease Group Disease pagination complete")
		Catch ex As Exception
			log.Error("Report Disease Group Disease record pagination error: " & ex.Message)
			lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

	Private Sub gvCustomReportRows_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvReportDiseaseGroupDiseaseMatrix.RowDeleting
		Try
			log.Info("Report Disease Group Disease delete information gathering begins")
			Dim id As Int64 = Convert.ToInt64(gvReportDiseaseGroupDiseaseMatrix.DataKeys(e.RowIndex)(0))
            hdfRDGDidfDiagnosisToGroupForReportType.Value = id
            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Question_Delete.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
			log.Info("Report Disease Group Disease delete information gathering complete")
		Catch ex As Exception
			log.Error("Report Disease Group Disease delete information gathering error: " & ex.Message)
			lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

#End Region

#Region "private"

#Region "populate"

    Private Sub PopulateGrid()
		Dim customReportRows As List(Of ConfReportdiseasegroupdiseasematrixGetlistModel) = reportDiseaseGroupDiseaseAPIClent.GetConfReportdiseasegroupdiseaseList(language, Convert.ToInt64(ddlidfsCustomReportType.SelectedValue), Convert.ToInt64(ddlidsfReportDiagnosisGroup.SelectedValue)).Result
		gvReportDiseaseGroupDiseaseMatrix.DataSource = customReportRows
		gvReportDiseaseGroupDiseaseMatrix.DataBind()
	End Sub

    Private Sub populationDropdowns()
        bindDropdown(ddlidfsCustomReportType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.CustomReportType, HACodeList.NoneHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlidsfReportDiagnosisGroup, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.ReportDiagnosisGroup, HACodeList.NoneHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlidfsDiagnosis, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlCDidfsUsingType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.DiagnosisUsingType, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        fillHACode(lstCDHACode)
    End Sub

    Private Sub fillHACode(ByRef ddl As ListBox)
        ddl.DataSource = globalAPIClient.GetHaCodes(GetCurrentLanguage(), HACodeList.AllHACode).Result
        ddl.DataValueField = "intHACode"
        ddl.DataTextField = "CodeName"
        ddl.DataBind()
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

#Region "repopulate"

    Private Sub RepopulateCRTDropdown()
        ddlidfsCustomReportType.Items.Clear()
        bindDropdown(ddlidfsCustomReportType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.CustomReportType, HACodeList.NoneHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsCustomReportType.Items.FindByText(txtCRTstrName.Text).Selected = True
    End Sub

    Private Sub RepopulateCDDropdown()
        ddlidfsDiagnosis.Items.Clear()
        bindDropdown(ddlidfsDiagnosis, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsDiagnosis.Items.FindByText(txtCDstrName.Text).Selected = True
    End Sub

    Private Sub RepopulateRDDropdown()
        ddlidsfReportDiagnosisGroup.Items.Clear()
        bindDropdown(ddlidsfReportDiagnosisGroup, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.ReportDiagnosisGroup, HACodeList.NoneHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidsfReportDiagnosisGroup.Items.FindByText(txtRDstrName.Text).Selected = True
    End Sub

#End Region

#End Region

#Region "clear"

    Private Sub clearRDGDForm()
        hdfRDGDidfDiagnosisToGroupForReportType.Value = "NULL"
        hdfRDGDValidationError.Value = False
        ddlidfsDiagnosis.SelectedIndex = -1
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
        hdfRDValidationError.Value = False
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

#End Region

#End Region

End Class