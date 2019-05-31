Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports System
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports log4net

Public Class VectorTypeSampleTypeMatrix
	Inherits BaseEidssPage

	Private ReadOnly vectorTypeSampeTypeAPIClient As VectorTypeSampleTypeServiceClient
	Private ReadOnly sampleTypeAPIClient As SampleTypeServiceClient
	Private ReadOnly vectorTypeAPIClient As VectorTypeServiceClient
	Private ReadOnly crossCuttingAPIClient As CrossCuttingServiceClient
	Private ReadOnly globalAPIClient As GlobalServiceClient
	Private language As String
	Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(VectorTypeSampleTypeMatrix))

	Sub New()
		language = GetCurrentLanguage()
		vectorTypeSampeTypeAPIClient = New VectorTypeSampleTypeServiceClient()
		vectorTypeAPIClient = New VectorTypeServiceClient()
		sampleTypeAPIClient = New SampleTypeServiceClient()
		crossCuttingAPIClient = New CrossCuttingServiceClient()
		globalAPIClient = New GlobalServiceClient()
	End Sub

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		Try
			If Not IsPostBack() Then
				log.Info("VectorTypeSampleTypeMatrix page load begins")
				populationDropdowns()
				PopulateGrid()
				log.Info("VectorTypeSampleTypeMatrix page load complete")
			End If
		Catch ex As Exception
			log.Error("VectorTypeSampleTypeMatrix page load error", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

	Private Sub ddlidfsVectorType_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsVectorType.SelectedIndexChanged
		Try
			log.Info("Load new sample type after vector type change begins")
            PopulateGrid()
            log.Info("Load new sample type after vector type change complete")
		Catch ex As Exception
			log.Error("Load new sample type after vector type change error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

#Region "button"

#Region "submit"

    Protected Sub btnSubmitVectorType_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitVectorType.ServerClick
		Try
			log.Info("Vector Type reference creation begins.")
			hdfVTValidationError.Value = True

			If (String.IsNullOrEmpty(txtVTstrDefault.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
			ElseIf (String.IsNullOrEmpty(txtVTstrName.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
			Else
				Dim VTParams As RefVectorTypeSetParams = New RefVectorTypeSetParams()

				VTParams.idfsVectorType = Nothing
				VTParams.languageId = language
				VTParams.strDefault = txtVTstrDefault.Text.Trim()
				VTParams.strName = txtVTstrName.Text.Trim()
				VTParams.strCode = txtVTstrCode.Text.Trim()
				VTParams.bitCollectionByPool = chkVTbitCollectionByPool.Checked

				If String.IsNullOrEmpty(txtVTintOrder.Text) Then
					VTParams.intOrder = 0
				Else
					VTParams.intOrder = Convert.ToInt32(txtVTintOrder.Text)
				End If

				Dim results As String = vectorTypeAPIClient.RefVectorTypeSet(VTParams).Result(0).ReturnMessage

				If results = "SUCCESS" Then
					PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Success.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    RepopulateVTDropdown()
                    log.Info("Vector Type reference creation complete.")
				Else
					hdfVTValidationError.Value = True
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_Vector_Type.InnerText") & txtSTstrDefault.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                    log.Info("Vector Type reference already exists.")
				End If
			End If
		Catch ex As Exception
			log.Error("Vector Type reference creation error:", ex)
			hdfVTValidationError.Value = False
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
	End Sub

	Protected Sub btnSampleType_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnAddSample.ServerClick
		Try
			log.Info("Sample Type reference creation begins")
			hdfSTValidationError.Value = True

			If (String.IsNullOrEmpty(txtSTstrDefault.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
			ElseIf (String.IsNullOrEmpty(txtSTstrName.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
			Else

				Dim sampleTypeRefParams As AdminSampleReferenceTypeSet = New AdminSampleReferenceTypeSet()
				sampleTypeRefParams.idfsSampleType = Nothing
				sampleTypeRefParams.laguageId = language
				sampleTypeRefParams.strDefault = txtSTstrDefault.Text.Trim()
				sampleTypeRefParams.strName = txtSTstrName.Text.Trim()

				Dim HaCode As Integer = 0

				For Each li As ListItem In lstSTHACode.Items
					If li.Selected Then
						HaCode = HaCode + Convert.ToInt16(li.Value)
					End If
				Next

				If HaCode = 0 Then
                    lbl_Continue_Required.InnerText = GetLocalResourceObject("Accessory_Code_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                    Exit Sub
				Else
					sampleTypeRefParams.intHaCode = HaCode
				End If

				If Not String.IsNullOrEmpty(txtintOrder.Text) Then
					sampleTypeRefParams.intOrder = Convert.ToInt32(txtintOrder.Text)
				Else
					sampleTypeRefParams.intOrder = 0
				End If

				sampleTypeRefParams.strSampleCode = txtSTstrSampleCode.Text.Trim()

				Dim results As String = sampleTypeAPIClient.SampleTypeSet(sampleTypeRefParams).Result(0).ReturnMessage

				If results = "SUCCESS" Then
					PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
					RepopulateSTDropdown()
				Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_Sample_Type.InnerText") & txtSTstrDefault.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
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

	Protected Sub btnSubmitVectorTypeSampleTypeMatrix_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitVectorTypeSampleTypeMatrix.ServerClick
		Try
			log.Info("Vector Type - Sample Type matrix creation begins")
			hdfVTSTValidationError.Value = True


			If (ddlidfsVectorType.SelectedIndex < 1) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Vector_Type_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
			ElseIf (ddlidfsSampleType.SelectedIndex < 1) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Sample_Type_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
			Else

				Dim VTSTParams As ConfVectortypesampletypematrixSetParams = New ConfVectortypesampletypematrixSetParams()

				VTSTParams.idfSampleTypeForVectorType = Nothing
				VTSTParams.idfsVectorType = Convert.ToInt64(ddlidfsVectorType.SelectedValue)
				VTSTParams.idfsSampleType = Convert.ToInt64(ddlidfsSampleType.SelectedValue)

				Dim results As String = vectorTypeSampeTypeAPIClient.SetConfVectorTypeSampleTypeMatrix(VTSTParams).Result(0).ReturnMessage

				If results = "SUCCESS" Then
					PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
					clearVTSTForm()
				Else
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Not_Possible.InnerText") & ddlidfsVectorType.SelectedItem.Text & GetLocalResourceObject("lbl_Dash.InnerText") & ddlidfsSampleType.SelectedItem.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
				End If
			End If
			log.Info("Vector Type - Sample Type matrix creation creation complete")
		Catch ex As Exception
			log.Error("Vector Type - Sample Type matrix creation error: " & ex.Message)
			lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Create.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

#End Region

#Region "add"

    Protected Sub btnAddVectorTypeSampleTypeMatrix_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddVectorTypeSampleTypeMatrix.Click
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorTypeSampleType');});", True)
        hdfVTSTValidationError.Value = True
    End Sub

    Protected Sub btnAddSampleType_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddSampleType.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleType');});", True)
        hdfSTValidationError.Value = True
    End Sub

    Protected Sub btnAddVectorType_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddVectorType.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorType');});", True)
        hdfVTValidationError.Value = True
    End Sub


#End Region

#Region "ok"

    Protected Sub btnSuccessOK_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSuccessOK.ServerClick
        If hdfSTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorTypeSampleType');});", True)
            clearSTForm()
            Exit Sub
        ElseIf hdfVTValidationError.Value Then
            clearVTForm()
        Else
            clearVTSTForm()
        End If
	End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        log.Info("Vector Type - Sample Type Matrix error begin")
        If hdfSTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleType');});", True)
            Exit Sub
        End If
        If hdfVTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorType');});", True)
            Exit Sub
        End If
        If hdfVTSTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorTypeSampleType');});", True)
            Exit Sub
        End If
        log.Info("Vector Type - Sample Type Matrix error complete")
    End Sub

#End Region

#Region "cancel"

    Protected Sub btnCancelVectorTypeSampleType_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelVectorTypeSampleType.ServerClick
        Try
            log.Info("Vector Type - Sample Type cancel begins")
            lbl_Cancel.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelModal');});", True)
            log.Info("Vector Type - Sample Type cancel complete")
        Catch ex As Exception
            log.Error("Vector Type - Sample Type cancel error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnCancelYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelYes.ServerClick
        log.Info("Report Disease Group Disease cancel begin")
        clearVTSTForm()
        log.Info("Report Disease Group Disease cancel complete")
    End Sub

    Protected Sub btnCancelNo_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelNo.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorTypeSampleType');});", True)
    End Sub

    Protected Sub btnCancelReference_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelSample.ServerClick, btnCancelVectorType.ServerClick
        log.Info("Cancel Reference begins")
        lbl_Cancel_Reference.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelReference');});", True)
        log.Info("Cancel Reference cancel complete")
    End Sub

    Protected Sub btnCancelReferenceNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick
        If hdfVTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorType');});", True)
        ElseIf hdfSTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleType');});", True)
        End If
    End Sub

    Protected Sub btnCancelReferenceYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceYes.ServerClick
        If hdfSTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorTypeSampleType');});", True)
        End If
    End Sub

#End Region

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Vector Type - Sample Type Matrix delete anyway begins")
            Dim VTSTId = Convert.ToInt64(hdfVTSTidfSampleTypeForVectorType.Value)
            Dim returnMessage As String = vectorTypeSampeTypeAPIClient.DelConfVectorTypeSampleTypematrix(VTSTId, True).Result(0).ReturnMessage
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Disease_Group_Disease_Matrix.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("Vector Type - Sample Type Matrix delete anyway complete")
        Catch ex As Exception
            log.Error("Vector Type - Sample Type Matrix delete anyway error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "grid view"

    Protected Sub gvVectorTypeSampleTypeMatrix_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvVectorTypeSampleTypeMatrix.PageIndexChanging
		Try
			log.Info("Vector Type - Sample Type Matrix pagination begin")
			gvVectorTypeSampleTypeMatrix.PageIndex = e.NewPageIndex
			PopulateGrid()
			log.Info("Vector Type - Sample Type Matrix pagination complete")
		Catch ex As Exception
			log.Error("Vector Type - Sample Type Matrix record pagination error: " & ex.Message)
			lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

	Private Sub gvVectorTypeSampleTypeMatrix_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvVectorTypeSampleTypeMatrix.RowDeleting
		Try
			log.Info("Vector Type - Sample Type Matrix delete information gathering begins")
			Dim id As Int64 = Convert.ToInt64(gvVectorTypeSampleTypeMatrix.DataKeys(e.RowIndex)(0))
			hdfVTSTidfSampleTypeForVectorType.Value = id

            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Question_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
			log.Info("Vector Type - Sample Type Matrix delete information gathering complete")
		Catch ex As Exception
			log.Error("Vector Type - Sample Type Matrix delete information gathering error: " & ex.Message)
			lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

#End Region

	Private Sub clearVTForm()
		hdfVTValidationError.Value = False
		txtVTstrName.Text = String.Empty
		txtVTstrDefault.Text = String.Empty
		txtVTintOrder.Text = String.Empty
		txtVTstrCode.Text = String.Empty
		chkVTbitCollectionByPool.Checked = False
	End Sub

	Private Sub clearSTForm()
		hdfSTValidationError.Value = False
		txtSTstrDefault.Text = String.Empty
		txtSTstrName.Text = String.Empty
		txtSTstrSampleCode.Text = String.Empty
		txtintOrder.Text = String.Empty
		lstSTHACode.SelectedIndex = -1
	End Sub

	Private Sub clearVTSTForm()
		clearVTForm()
		clearSTForm()
		hdfVTSTValidationError.Value = False
		hdfVTSTidfSampleTypeForVectorType.Value = "NULL"
		ddlidfsSampleType.SelectedIndex = -1
		ddlidfsVectorType.SelectedIndex = -1
	End Sub

	Private Sub fillSTHACode()
		lstSTHACode.DataSource = globalAPIClient.GetHaCodes(GetCurrentLanguage(), HACodeList.HALVHACode).Result
		lstSTHACode.DataValueField = "intHACode"
		lstSTHACode.DataTextField = "CodeName"
		lstSTHACode.DataBind()
	End Sub

	Private Sub PopulateGrid()
		Dim vectorTypeSampleTypes As List(Of ConfVectortypesampletypematrixGetlistModel) = vectorTypeSampeTypeAPIClient.GetConfVectorTypeSampleTypeMatrices(language, Convert.ToInt64(ddlidfsVectorType.SelectedValue)).Result
		gvVectorTypeSampleTypeMatrix.DataSource = vectorTypeSampleTypes
		gvVectorTypeSampleTypeMatrix.DataBind()
	End Sub

	Private Sub populationDropdowns()
        bindDropdown(ddlidfsVectorType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.VectorType, HACodeList.VectorHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlidfsSampleType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.SampleType, HACodeList.VectorHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        fillSTHACode()
	End Sub

	Private Sub RepopulateVTDropdown()
		ddlidfsVectorType.Items.Clear()
        bindDropdown(ddlidfsVectorType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.VectorType, HACodeList.VectorHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsVectorType.Items.FindByText(txtVTstrName.Text).Selected = True
	End Sub

	Private Sub RepopulateSTDropdown()
		ddlidfsSampleType.Items.Clear()
        bindDropdown(ddlidfsSampleType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.SampleType, HACodeList.VectorHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsSampleType.Items.FindByText(txtSTstrName.Text).Selected = True
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