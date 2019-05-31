Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports System
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports log4net

Public Class DiseaseAgeGroupMatrix
	Inherits BaseEidssPage

	Private ReadOnly diseaseAgeGroupAPIClient As DiseaseAgeGroupServiceMatrixClient
    Private ReadOnly crossCuttingAPIClient As CrossCuttingServiceClient
    Private ReadOnly diagnosisAPIClient As DiagnosisServiceClient
    Private ReadOnly ageGroupAPIClient As AgeGroupServiceClient
    Private ReadOnly globalAPIClient As GlobalServiceClient
    Private language As String
	Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(DiseaseAgeGroupMatrix))

	Sub New()
		language = GetCurrentLanguage()
		diseaseAgeGroupAPIClient = New DiseaseAgeGroupServiceMatrixClient()
        crossCuttingAPIClient = New CrossCuttingServiceClient()
        diagnosisAPIClient = New DiagnosisServiceClient()
        ageGroupAPIClient = New AgeGroupServiceClient()
        globalAPIClient = New GlobalServiceClient()
    End Sub

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		Try
			If Not IsPostBack() Then
				log.Info("DiseaseAgeGroupMatrix page load begins")
				populationDropdowns()
				PopulateGrid()
				log.Info("DiseaseAgeGroupMatrix page load complete")
			End If
		Catch ex As Exception
			log.Error("DiseaseAgeGroupMatrix page load error", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

	Private Sub ddlidfsDiagnosis_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsDiagnosis.SelectedIndexChanged
		Try
			log.Info("Load new age groups after disease change begins")
			PopulateGrid()
			log.Info("Load new age groups after disease change complete")
		Catch ex As Exception
			log.Error("Load new age groups after disease change error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

#Region "buttons"

#Region "submit"

    Protected Sub btnSubmitDiseaseAgeGroup_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitDiseaseAgeGroup.ServerClick
        Try
            log.Info("disease - age group Matrix creation begins")
            hdfDAGValidationError.Value = True

            If (ddlidfsDiagnosis.SelectedIndex < 1) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Disease_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (ddlidfsDiagnosisAgeGroup.SelectedIndex < 1) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Age_Group_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else

                Dim DAGParams As ConfDiseaseagegroupmatrixSetParams = New ConfDiseaseagegroupmatrixSetParams()

                DAGParams.idfDiagnosisAgeGroupToDiagnosis = Nothing
                DAGParams.idfsDiagnosis = Convert.ToInt64(ddlidfsDiagnosis.SelectedValue)
                DAGParams.idfsDiagnosisAgeGroup = Convert.ToInt64(ddlidfsDiagnosisAgeGroup.SelectedValue)

                Dim results As String = diseaseAgeGroupAPIClient.SetConfDiseaseAgeGroupMatrix(DAGParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    clearDAGForm()
                Else
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Not_Possible.InnerText") & ddlidfsDiagnosis.SelectedItem.Text & GetLocalResourceObject("lbl_Dash.InnerText") & ddlidfsDiagnosisAgeGroup.SelectedItem.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
                End If
            End If
            log.Info("disease - age group Matrix creation complete")
        Catch ex As Exception
            log.Error("disease - age group Matrix creation error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnSubmitAgeGroup_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitAgeGroup.ServerClick
        Try
            log.Info("Age Group reference creation begins")
            hdfAGValidationError.Value = True
            If (String.IsNullOrEmpty(txtAGstrDefault.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtAGstrName.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf ddlAGidfsAgeType.SelectedIndex < 0 Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Interval_Type_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
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
                    lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Bad_Boundaries.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                    Exit Sub
                End If

                Dim results As String = ageGroupAPIClient.RefAgegroupSet(agsp).Result(0).ReturnMessage

                If (results = "SUCCESS") Then
                    RepopulateAGDropdown()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    log.Info("Age Group reference creation complete")
                Else
                    log.Info("Age Group reference currently exists")
                    hdfAGValidationError.Value = True
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_Age_Group.InnerText") & txtAGstrName.Text.Trim() & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                End If
            End If
        Catch ex As Exception
            log.Error("Age Group reference creation error:", ex)
            hdfAGValidationError.Value = False
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
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
            ElseIf (String.IsNullOrEmpty(ddlCDidfsUsingType.Text.Trim())) Then
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
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

#End Region

#Region "add"

    Protected Sub btnAddDiseaseAgeGroupMatrix_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddDiseaseAgeGroupMatrix.Click, btnCancelNo.ServerClick
		ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseAgeGroup');});", True)
	End Sub

    Protected Sub btnAddDisease_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddDisease.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        hdfCDValidationError.Value = True
    End Sub

    Protected Sub btnAddAgeGroup_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddAgeGroup.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addAgeGroup');});", True)
        hdfAGValidationError.Value = True
    End Sub

#End Region

#Region "ok"

    Protected Sub btnSuccessOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSuccessOK.ServerClick
        If hdfCDValidationError.Value = True Then
            clearCDForm()
        ElseIf hdfAGValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseAgeGroup');});", True)
            clearAGForm()
        Else
            clearDAGForm()
        End If
    End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        log.Info("disease - age group Matrix delete anyway complete")
        If hdfDAGValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseAgeGroup');});", True)
        End If
        log.Info("disease - age group Matrix delete anyway complete")
    End Sub

#End Region

#Region "cancel"

    Protected Sub btnCancelDiseaseAgeGroup_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelDiseaseAgeGroup.ServerClick
        Try
            log.Info("disease - age group Matrix cancel begins")
            lbl_Cancel.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelModal');});", True)
            log.Info("disease - age group Matrix cancel complete")
        Catch ex As Exception
            log.Error("disease - age group Matrix delete anyway error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnCancelReference_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelDisease.ServerClick, btnCancelAgeGroup.ServerClick
        lbl_Cancel_Reference.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelReference');});", True)
    End Sub

    Protected Sub btnCancelReferenceYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceYes.ServerClick
        If hdfCDValidationError.Value = True Then
            clearCDForm()
        ElseIf hdfAGValidationError.Value = True Then
            clearAGForm()
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseAgeGroup');});", True)
        End If
    End Sub

    Protected Sub btnCancelReferenceNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick
        If hdfCDValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        ElseIf hdfAGValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addAgeGroup');});", True)
        End If
    End Sub

    Protected Sub btnCancelYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelYes.ServerClick
        log.Info("disease - age group Matrix cancel begin")
        clearDAGForm()
        log.Info("disease - age group Matrix cancel complete")
    End Sub

    Protected Sub btnCancelNo_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelNo.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseAgeGroup');});", True)
    End Sub

#End Region

#Region "correct"

    Protected Sub btnContinueRequiredYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnContinueRequiredYes.ServerClick, btnAlreadyExistsYes.ServerClick
        If hdfDAGValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseAgeGroup');});", True)
        ElseIf hdfAGValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addAgeGroup');});", True)
        ElseIf hdfCDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        End If
    End Sub

    Protected Sub btnContinueRequiredNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick, btnAlreadyExistsNo.ServerClick
        If hdfDAGValidationError.Value Then
            clearDAGForm()
        ElseIf hdfAGValidationError.Value Then
            clearAGForm()
        ElseIf hdfCDValidationError.Value Then
            clearCDForm()
        End If
    End Sub

#End Region

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("disease - age group Matrix delete anyway begins")
            Dim DAGId = Convert.ToInt64(hdfDAGidfDiagnosisAgeGroupToDiagnosis.Value)
            Dim returnMessage As String = diseaseAgeGroupAPIClient.DelConfDiseaseAgeGroupMatrix(DAGId).Result(0).ReturnMessage
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("disease - age group Matrix delete anyway complete")
        Catch ex As Exception
            log.Error("disease - age group Matrix delete anyway error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "grid view"
    Protected Sub gvDiseasePensideTest_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvDiseaseAgeGroupMatrix.PageIndexChanging
		Try
			log.Info("disease - age group Matrix pagination begin")
			gvDiseaseAgeGroupMatrix.PageIndex = e.NewPageIndex
			PopulateGrid()
			log.Info("disease - age group Matrix pagination complete")
		Catch ex As Exception
			log.Error("disease - age group Matrix record pagination error: " & ex.Message)
			lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

	Private Sub gvDiseaseAgeGroupMatrix_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvDiseaseAgeGroupMatrix.RowDeleting
		Try
			log.Info("disease - age group Matrix delete information gathering begins")
			Dim id As Int64 = Convert.ToInt64(gvDiseaseAgeGroupMatrix.DataKeys(e.RowIndex)(0))
            hdfDAGidfDiagnosisAgeGroupToDiagnosis.Value = id

            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Question_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
			log.Info("disease - age group Matrix delete information gathering complete")
		Catch ex As Exception
			log.Error("disease - age group Matrix delete information gathering error: " & ex.Message)
			lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

#End Region

#Region "private"

#Region "populate"

    Private Sub fillHACode()
        lstCDHACode.DataSource = globalAPIClient.GetHaCodes(GetCurrentLanguage(), HACodeList.AllHACode).Result
        lstCDHACode.DataValueField = "intHACode"
        lstCDHACode.DataTextField = "CodeName"
        lstCDHACode.DataBind()
    End Sub

    Private Sub PopulateGrid()
		Dim diseaseAgeGroup As List(Of ConfDiseaseagegroupmatrixGetlistModel) = diseaseAgeGroupAPIClient.GetConfDiseaseAgeGroupMatrixList(language, Convert.ToInt64(ddlidfsDiagnosis.SelectedValue)).Result
		gvDiseaseAgeGroupMatrix.DataSource = diseaseAgeGroup
		gvDiseaseAgeGroupMatrix.DataBind()
	End Sub

    Private Sub populationDropdowns()
        bindDropdown(ddlidfsDiagnosis, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlidfsDiagnosisAgeGroup, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.AgeGroups, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlCDidfsUsingType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.DiagnosisUsingType, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlAGidfsAgeType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.HumanAgeType, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        fillHACode()
    End Sub

    Private Sub bindDropdown(ByRef ddl As DropDownList, ByVal dl As Object, ByVal tf As String, ByVal vf As String, ByVal addBlank As Boolean, Optional ByVal blankText As String = "")
        If addBlank Then
            ddl.Items.Add(New ListItem(blankText, "0"))
        End If
        ddl.DataSource = dl
        ddl.DataTextField = tf
        ddl.DataValueField = vf
        ddl.DataBind()
    End Sub

#Region "repopulate"

    Private Sub RepopulateCDDropdown()
        ddlidfsDiagnosis.Items.Clear()
        bindDropdown(ddlidfsDiagnosis, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsDiagnosis.Items.FindByText(txtCDstrName.Text).Selected = True
    End Sub

    Private Sub RepopulateAGDropdown()
        ddlidfsDiagnosisAgeGroup.Items.Clear()
        bindDropdown(ddlidfsDiagnosisAgeGroup, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.AgeGroups, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsDiagnosisAgeGroup.Items.FindByText(txtAGstrName.Text).Selected = True
    End Sub

#End Region

#End Region

#Region "clear"

    Private Sub clearDAGForm()
        hdfDAGidfDiagnosisAgeGroupToDiagnosis.Value = "NULL"
        hdfDAGValidationError.Value = False
        ddlidfsDiagnosisAgeGroup.SelectedIndex = -1
    End Sub

    Private Sub clearCDForm()
        hdfCDValidationError.Value = False
        hdfCDidfsDiagnosis.Value = "NULL"
        txtCDstrName.Text = String.Empty
        txtCDstrDefault.Text = String.Empty
        txtCDintOrder.Text = String.Empty
        txtCDstrIDC10.Text = String.Empty
        txtCDstrOIECode.Text = String.Empty
        ddlCDidfsUsingType.SelectedIndex = -1
    End Sub

    Private Sub clearAGForm()
        hdfAGValidationError.Value = False
        txtAGstrName.Text = String.Empty
        txtAGstrDefault.Text = String.Empty
        txtAGintOrder.Text = String.Empty
        txtAGintUpperBoundary.Text = String.Empty
        txtAGintLowerBoundary.Text = String.Empty
        ddlAGidfsAgeType.SelectedIndex = -1
    End Sub

#End Region

#End Region

End Class