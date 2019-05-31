Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports System
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports log4net

Public Class AgeGroupStatisticalAgeGroupMatrix
	Inherits BaseEidssPage

	Private ReadOnly ageGroupStatisticalAgeGroupAPIClient As AgeGroupStatisticalAgeGroupServiceClient
	Private ReadOnly baseReferenceAPIClient As BaseReferenceClient
	Private ReadOnly ageGroupAPIClient As AgeGroupServiceClient
	Private ReadOnly crossCuttingAPIClient As CrossCuttingServiceClient
	Private ReadOnly globalAPIClient As GlobalServiceClient
	Private language As String
	Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(AgeGroupStatisticalAgeGroupMatrix))

	Sub New()
		language = GetCurrentLanguage()
		ageGroupStatisticalAgeGroupAPIClient = New AgeGroupStatisticalAgeGroupServiceClient()
		ageGroupAPIClient = New AgeGroupServiceClient()
		baseReferenceAPIClient = New BaseReferenceClient()
		crossCuttingAPIClient = New CrossCuttingServiceClient()
		globalAPIClient = New GlobalServiceClient()
	End Sub

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		Try
			If Not IsPostBack() Then
				log.Info("AgeGroupStatisticalAgeGroupMatrix page load begins")
				populationDropdowns()
				PopulateGrid()
				log.Info("AgeGroupStatisticalAgeGroupMatrix page load complete")
			End If
		Catch ex As Exception
			log.Error("AgeGroupStatisticalAgeGroupMatrix page load error", ex)
			lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading_Page.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

    Private Sub ddlidfsDiagnosisAgeGroup_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsDiagnosisAgeGroup.SelectedIndexChanged
        Try
            log.Info("Load new statistical age group after age group change begins")
            PopulateGrid()
            If ddlidfsDiagnosisAgeGroup.SelectedIndex < 1 Then
                btnAgeGroupStatisticalAgeGroup.Enabled = False
            Else
                btnAgeGroupStatisticalAgeGroup.Enabled = True
            End If
            log.Info("Load new statistical age group after age group change complete")
        Catch ex As Exception
            log.Error("Load new statistical age group after age group change error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading_Sample_Types.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#Region "button"

    Protected Sub btnSubmitAgeGroupStatisticalAgeGroupMatrix_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitAgeGroupStatisticalAgeGroupMatrix.ServerClick
        Try
            log.Info("Age Group - Statistical Age Group matrix creation begins")
            hdfAGSAGValidationError.Value = True

            If (ddlidfsDiagnosisAgeGroup.SelectedIndex < 1) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Age_Group_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (ddlidfsStatisticalAgeGroup.SelectedIndex < 1) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Statistical_Age_Group_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else

                Dim AGSAGParams As ConfAgegroupstatisticalagegroupmatrixSetParams = New ConfAgegroupstatisticalagegroupmatrixSetParams()

                AGSAGParams.idfDiagnosisAgeGroupToStatisticalAgeGroup = Nothing
                AGSAGParams.idfsDiagnosisAgeGroup = Convert.ToInt64(ddlidfsDiagnosisAgeGroup.SelectedValue)
                AGSAGParams.idfsStatisticalAgeGroup = Convert.ToInt64(ddlidfsStatisticalAgeGroup.SelectedValue)

                Dim results As String = ageGroupStatisticalAgeGroupAPIClient.SetConfAgegroupstatisticalagegroupmatrix(AGSAGParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Success_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    clearAGSAGForm()
                Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible.InnerText") & ddlAGidfsAgeType.SelectedItem.Text & "-" & ddlidfsStatisticalAgeGroup.SelectedItem.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                End If
            End If
            log.Info("Age Group - Statistical Age Group matrix creation creation complete")
        Catch ex As Exception
            log.Error("Age Group - Statistical Age Group matrix creation error: " & ex.Message)
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
                    PopulateGrid()
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

    Protected Sub btnSubmitStatisticalAgeGroup_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitStatisticalAgeGroup.ServerClick
        Try
            log.Info("Sample Type reference creation begins")
            hdfSAGValidationError.Value = True

            If (String.IsNullOrEmpty(txtSAGstrDefault.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtSAGstrName.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else

                Dim baseRefParams As AdminBaseReferenceSetParams = New AdminBaseReferenceSetParams()
                baseRefParams.idfsBaseReference = Nothing
                baseRefParams.idfsReferenceType = 19000145
                baseRefParams.languageId = language
                baseRefParams.strDefault = txtSAGstrDefault.Text.Trim()
                baseRefParams.strName = txtSAGstrName.Text.Trim()
                baseRefParams.intOrder = 0

                Dim results As String = baseReferenceAPIClient.BaseReferneceSet(baseRefParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    RepopulateSAGDropdown()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_Statistical_Age_Group.InnerText") & txtSAGstrDefault.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                End If
            End If
            log.Info("Sample Type reference creation complete")
        Catch ex As Exception
            log.Error("Sample Type reference creation error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnAgeGroupStatisticalAgeGroup_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAgeGroupStatisticalAgeGroup.Click, btnCancelNo.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addAgeGroupStatisticalAgeGroup');});", True)
    End Sub

    Protected Sub btnAddStatisticalAgeGroup_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddStatisticalAgeGroup.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addStatisticalAgeGroup');});", True)
    End Sub

    Protected Sub btnSuccessOK_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSuccessOK.ServerClick
        If hdfSAGValidationError.Value = True Or hdfAGValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addAgeGroupStatisticalAgeGroup');});", True)
            clearSAGForm()
            clearAGForm()
        Else
            clearAGSAGForm()
        End If
    End Sub

    Protected Sub btnCancelAgeGroupStatisticalAgeGroup_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelAgeGroupStatisticalAgeGroup.ServerClick
        Try
            log.Info("Age Group - Statistical Age Group cancel begins")
            lbl_Cancel.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelModal');});", True)
            log.Info("Age Group - Statistical Age Group cancel complete")
        Catch ex As Exception
            log.Error("Age Group - Statistical Age Group cancel error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnCancelAgeGroup_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelAgeGroup.ServerClick, btnCancelStatisticalAgeGroup.ServerClick
        lbl_Cancel_Reference.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelReference');});", True)
    End Sub

    Protected Sub btnCancelAgeGroupStatisticalAgeGroup_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelAgeGroupStatisticalAgeGroup.ServerClick
        log.Info("Vector Type Sample Type cancel begin")
        clearAGSAGForm()
        log.Info("Vector Type Sample Type cancel complete")
    End Sub

    Protected Sub btnCancelReferenceYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceYes.ServerClick
        If hdfAGValidationError.Value = True Then
            clearAGForm()
        ElseIf hdfSAGValidationError.Value = True Then
            clearSAGForm()
        End If
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSpeciesTypeAnimalAge');});", True)
    End Sub

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Age Group - Statistical Age Group Matrix delete anyway begins")
            Dim AGSAGId = Convert.ToInt64(hdfAGSAGidfDiagnosisAgeGroupToStatisticalAgeGroup.Value)
            Dim returnMessage As String = ageGroupStatisticalAgeGroupAPIClient.DelConfAgegroupstatisticalagegroupmatrix(AGSAGId, True).Result(0).ReturnMessage
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Success_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("Age Group - Statistical Age Group Matrix delete anyway complete")
        Catch ex As Exception
            log.Error("Age Group - Statistical Age Group Matrix delete anyway error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        log.Info("Age Group - Statistical Age Group Matrix error begin")
        If hdfSAGValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addPensideTestName');});", True)
        End If
        If hdfAGValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addAgeGroup');});", True)
        End If
        If hdfAGSAGValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addAgeGroupStatisticalAgeGroup');});", True)
        End If
        log.Info("Age Group - Statistical Age Group Matrix error complete")
    End Sub

    Protected Sub btnContinueRequiredYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnContinueRequiredYes.ServerClick, btnAlreadyExistsYes.ServerClick
        If hdfAGValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addAgeGroup');});", True)
        ElseIf hdfSAGValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addStatisticalAgeGroup');});", True)
        ElseIf hdfAGSAGValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addAgeGroupStatisticalAgeGroup');});", True)
        End If
    End Sub

    Protected Sub btnContinueRequiredNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick, btnAlreadyExistsNo.ServerClick
        If hdfAGValidationError.Value Then
            clearAGForm()
        ElseIf hdfSAGValidationError.Value Then
            clearSAGForm()
        ElseIf hdfAGSAGValidationError.Value Then
            clearAGSAGForm()
        End If
    End Sub


#End Region

#Region "grid view"

    Protected Sub gvAgeGroupStatisticalAgeGroupMatrix_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvAgeGroupStatisticalAgeGroupMatrix.PageIndexChanging
		Try
			log.Info("Age Group - Statistical Age Group Matrix pagination begin")
			gvAgeGroupStatisticalAgeGroupMatrix.PageIndex = e.NewPageIndex
			PopulateGrid()
			log.Info("Age Group - Statistical Age Group Matrix pagination complete")
		Catch ex As Exception
			log.Error("Age Group - Statistical Age Group Matrix record pagination error: " & ex.Message)
			lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

	Private Sub gvAgeGroupStatisticalAgeGroupMatrix_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvAgeGroupStatisticalAgeGroupMatrix.RowDeleting
		Try
			log.Info("Age Group - Statistical Age Group Matrix delete information gathering begins")
			Dim id As Int64 = Convert.ToInt64(gvAgeGroupStatisticalAgeGroupMatrix.DataKeys(e.RowIndex)(0))
            hdfAGSAGidfDiagnosisAgeGroupToStatisticalAgeGroup.Value = id

            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Question_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
			log.Info("Age Group - Statistical Age Group Matrix delete information gathering complete")
		Catch ex As Exception
			log.Error("Age Group - Statistical Age Group Matrix delete information gathering error: " & ex.Message)
			lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

#End Region

    Private Sub PopulateGrid()
		Dim ageGroupStatisticalAgeGroups As List(Of ConfAgegroupstatisticalagegroupmatrixGetlistModel) = ageGroupStatisticalAgeGroupAPIClient.GetConfAgegroupstatisticalagegroupmatrices(language, Convert.ToInt64(ddlidfsDiagnosisAgeGroup.SelectedValue)).Result
		gvAgeGroupStatisticalAgeGroupMatrix.DataSource = ageGroupStatisticalAgeGroups
		gvAgeGroupStatisticalAgeGroupMatrix.DataBind()
	End Sub

	Private Sub populationDropdowns()
        bindDropdown(ddlidfsDiagnosisAgeGroup, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.AgeGroups, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlidfsStatisticalAgeGroup, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.StatisticalAgeGroups, HACodeList.NoneHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlAGidfsAgeType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.HumanAgeType, HACodeList.NoneHACode).Result, "name", "idfsBaseReference", True, String.Empty)
    End Sub

    Private Sub RepopulateAGDropdown()
        ddlidfsDiagnosisAgeGroup.Items.Clear()
        bindDropdown(ddlidfsDiagnosisAgeGroup, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.VectorType, HACodeList.VectorHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsDiagnosisAgeGroup.Items.FindByText(txtAGstrName.Text).Selected = True
    End Sub

    Private Sub RepopulateSAGDropdown()
		ddlidfsStatisticalAgeGroup.Items.Clear()
        bindDropdown(ddlidfsStatisticalAgeGroup, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.StatisticalAgeGroups, HACodeList.Human).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsStatisticalAgeGroup.Items.FindByText(txtSAGstrName.Text).Selected = True
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

    Private Sub clearAGSAGForm()
        hdfAGSAGidfDiagnosisAgeGroupToStatisticalAgeGroup.Value = "NULL"
        hdfAGSAGValidationError.Value = False
        ddlidfsStatisticalAgeGroup.SelectedIndex = -1
    End Sub

    Private Sub clearSAGForm()
        txtSAGintOrder.Text = String.Empty
        txtSAGstrDefault.Text = String.Empty
        txtSAGstrName.Text = String.Empty
        hdfSAGValidationError.Value = False
    End Sub

End Class