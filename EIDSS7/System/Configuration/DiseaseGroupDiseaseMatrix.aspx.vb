Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports System
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports log4net

Public Class DiseaseGroupDiseaseMatrix
	Inherits BaseEidssPage

	Private ReadOnly diseaseGroupDiseaseAPIClient As DiseaseGroupDiseaseServiceClient
    Private ReadOnly crossCuttingAPIClient As CrossCuttingServiceClient
    Private ReadOnly baseReferenceAPIClient As BaseReferenceClient
    Private ReadOnly globalAPIClient As GlobalServiceClient
    Private ReadOnly diagnosisAPIClient As DiagnosisServiceClient
    Private language As String
	Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(DiseaseGroupDiseaseMatrix))

	Sub New()
		language = GetCurrentLanguage()
		crossCuttingAPIClient = New CrossCuttingServiceClient()
		diseaseGroupDiseaseAPIClient = New DiseaseGroupDiseaseServiceClient()
	End Sub

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		Try
			If Not IsPostBack() Then
				log.Info("DiseaseGroupDiseaseMatrix page load begins")
				populationDropdowns()
				PopulateGrid()
				log.Info("DiseaseGroupDiseaseMatrix page load complete")
			End If
		Catch ex As Exception
			log.Error("DiseaseGroupDiseaseMatrix page load error", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

	Protected Sub ddlidfsDiagnosisGroup_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlidfsDiagnosisGroup.SelectedIndexChanged
		Try
			log.Info("Diseases for DiseaseGroup load begin")
			PopulateGrid()
			log.Info("Diseases for DiseaseGroup load complete")
		Catch ex As Exception
			log.Error("DiseaseGroupDiseaseMatrix page load error", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

#Region "buttons"

	Protected Sub btnSubmitDiseaseGroupDiseaseMatrix_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitDiseaseGroupDiseaseMatrix.ServerClick
		Try
			log.Info("Disease Group - Disease Matrix creation begins")
			hdfDGDValidationError.Value = True

			If (ddlidfsDiagnosisGroup.SelectedIndex < 1) Then
				lbl_Error.InnerText = GetLocalResourceObject("lbl_Disease_Group_Required.InnerText")
				ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
				Exit Sub
			ElseIf (ddlidfsDiagnosis.SelectedIndex < 1) Then
				lbl_Error.InnerText = GetLocalResourceObject("lbl_Disease_Required.InnerText")
				ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
				Exit Sub
			Else

				Dim DGDParams As DiseaseGroupDiseaseMatrixSetParams = New DiseaseGroupDiseaseMatrixSetParams()

				DGDParams.idfDiagnosisToDiagnosisGroup = Nothing
				DGDParams.idfsDiagnosis = Convert.ToInt64(ddlidfsDiagnosis.SelectedValue)
				DGDParams.idfsDiagnosisGroup = Convert.ToInt64(ddlidfsDiagnosisGroup.SelectedValue)

				Dim results As String = diseaseGroupDiseaseAPIClient.ConfDiseasegroupdiseasematrixSet(DGDParams).Result(0).ReturnMessage

				If results = "SUCCESS" Then
					PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    clearDGDForm()
                Else
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Not_Possible.InnerText") & ddlidfsDiagnosis.SelectedItem.Text & GetLocalResourceObject("lbl_Dash.InnerText") & ddlidfsDiagnosisGroup.SelectedItem.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
				End If
			End If
			log.Info("Disease Group - Disease Matrix creation complete")
		Catch ex As Exception
			log.Error("Disease Group - Disease Matrix creation error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

    Protected Sub btnAddDiseaseGroupDiseaseMatrix_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddDiseaseGroupDiseaseMatrix.Click, btnCancelNo.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseGroupDisease');});", True)
    End Sub

    Protected Sub btnAddDiseaseGroup_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddDiseaseGroup.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseGroup');});", True)
    End Sub

    Protected Sub btnAddDisease_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddDisease.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
    End Sub

    Protected Sub btnCancelDiseaseGroupDisease_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelDiseaseGroupDisease.ServerClick
        Try
            log.Info("Disease Group - Disease Matrix cancel begins")
            lbl_Cancel.InnerText = GetLocalResourceObject("lbl_Cancel_Disease_Group_Disease_Matrix.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelModal');});", True)
            log.Info("Disease Group - Disease Matrix cancel complete")
        Catch ex As Exception
            log.Error("Disease Group - Disease Matrix cancel error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnCancelReferenceYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceYes.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseGroupDisease');});", True)
    End Sub

    Protected Sub btnCancelReferenceNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick
        If hdfDGValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseGroup');});", True)
        ElseIf hdfCDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        End If
    End Sub

    Protected Sub btnCancelDiseaseGroupDisease_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelDiseaseGroupDisease.ServerClick
        log.Info("Disease Group - Disease Matrix cancel begin")
        clearDGDForm()
        log.Info("Disease Group - Disease Matrix cancel complete")
    End Sub

#Region "ok"

    Protected Sub btnSuccessOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSuccessOK.ServerClick
        If hdfDGValidationError.Value = True Or hdfCDValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseGroupDisease');});", True)
            clearDGForm()
            clearCDForm()
        ElseIf hdfDGDValidationError.Value = True Then
            clearDGDForm()
        End If
    End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        log.Info("Disease Group - Disease Matrix delete anyway complete")
        If hdfDGDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseGroupDisease');});", True)
        End If
        log.Info("Disease Group - Disease Matrix delete anyway complete")
    End Sub
#End Region

#Region "correct"

    Protected Sub btnContinueRequiredYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnContinueRequiredYes.ServerClick, btnAlreadyExistsYes.ServerClick
        If hdfDGDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseGroup');});", True)
        ElseIf hdfDGValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addAgeGroup');});", True)
        ElseIf hdfCDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseGroup');});", True)
        End If
    End Sub

    Protected Sub btnContinueRequiredNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick, btnAlreadyExistsNo.ServerClick, btnContinueRequiredNo.ServerClick
        If hdfDGDValidationError.Value Then
            clearDGDForm()
        ElseIf hdfDGValidationError.Value Then
            clearDGForm()
        ElseIf hdfCDValidationError.Value Then
            clearCDForm()
        End If
    End Sub

#End Region

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Disease Group - Disease Matrix delete anyway begins")
            Dim DGDId = Convert.ToInt64(hdfDGDidfDiagnosisToDiagnosisGroup.Value)
            Dim returnMessage As String = diseaseGroupDiseaseAPIClient.ConfDiseasegroupdiseasematrixDel(DGDId, True).Result(0).ReturnMessage
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("Disease Group - Disease Matrix delete anyway complete")
        Catch ex As Exception
            log.Error("Disease Group - Disease Matrix delete anyway error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "grid view"
    Protected Sub gvDiseasePensideTest_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvDiseaseGroupDiseaseMatrix.PageIndexChanging
		Try
			log.Info("Disease Group - Disease Matrix pagination begin")
			gvDiseaseGroupDiseaseMatrix.PageIndex = e.NewPageIndex
			PopulateGrid()
			log.Info("Disease Group - Disease Matrix pagination complete")
		Catch ex As Exception
			log.Error("Disease Group - Disease Matrix record pagination error: " & ex.Message)
			lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

	Private Sub gvDiseaseGroupDiseaseMatrix_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvDiseaseGroupDiseaseMatrix.RowDeleting
		Try
			log.Info("Disease Group - Disease Matrix delete information gathering begins")
			Dim id As Int64 = Convert.ToInt64(gvDiseaseGroupDiseaseMatrix.DataKeys(e.RowIndex)(0))
			hdfDGDidfDiagnosisToDiagnosisGroup.Value = id

            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Question_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
			log.Info("Disease Group - Disease Matrix delete information gathering complete")
		Catch ex As Exception
			log.Error("Disease Group - Disease Matrix delete information gathering error: " & ex.Message)
			lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

#End Region

    Private Sub fillHACode(ByRef ddl As ListBox)
        ddl.DataSource = globalAPIClient.GetHaCodes(GetCurrentLanguage(), HACodeList.AllHACode).Result
        ddl.DataValueField = "intHACode"
        ddl.DataTextField = "CodeName"
        ddl.DataBind()
    End Sub

    Private Sub PopulateGrid()
		Dim diseaseAgeGroup As List(Of ConfDiseasegroupdiseasematrixGetlistModel) = diseaseGroupDiseaseAPIClient.ConfDiseasegroupdiseasematrixGetlist(language, Convert.ToInt64(ddlidfsDiagnosisGroup.SelectedValue)).Result
		gvDiseaseGroupDiseaseMatrix.DataSource = diseaseAgeGroup
		gvDiseaseGroupDiseaseMatrix.DataBind()
	End Sub

    Private Sub populationDropdowns()
        bindDropdown(ddlidfsDiagnosis, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlidfsDiagnosisGroup, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.DiagnosesGroups, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlCDidfsUsingType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.DiagnosisUsingType, HACodeList.NoneHACode).Result, "name", "idfsBaseReference", True, String.Empty)
    End Sub

    Private Sub clearDGDForm()
        hdfDGDidfDiagnosisToDiagnosisGroup.Value = "NULL"
        hdfDGDstrName.Value = "NULL"
        hdfDGDValidationError.Value = False
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

    Private Sub clearDGForm()
        txtDGstrDefault.Text = String.Empty
        txtDGstrName.Text = String.Empty
        txtDGintOrder.Text = False
        lstDGHACode.SelectedIndex = -1
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

End Class