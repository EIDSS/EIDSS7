Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports System
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports log4net

Public Class VectorTypeFieldTestMatrix
	Inherits BaseEidssPage

	Private ReadOnly vectorTypeFieldTestAPIClient As VectorTypeFieldTestServiceClient
	Private ReadOnly baseReferenceAPIClient As BaseReferenceClient
	Private ReadOnly vectorTypeAPIClient As VectorTypeServiceClient
	Private ReadOnly crossCuttingAPIClient As CrossCuttingServiceClient
	Private ReadOnly globalAPIClient As GlobalServiceClient
	Private language As String
	Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(VectorTypeFieldTestMatrix))

	Sub New()
		language = GetCurrentLanguage()
		vectorTypeFieldTestAPIClient = New VectorTypeFieldTestServiceClient()
		vectorTypeAPIClient = New VectorTypeServiceClient()
		baseReferenceAPIClient = New BaseReferenceClient()
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
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    RepopulateVTDropdown()
                    clearVTForm()
                    log.Info("Vector Type reference creation complete.")
                Else
                    hdfVTValidationError.Value = True
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_Vector_Type.InnerText") & txtVTstrDefault.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
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

    Protected Sub btnAddPensideTest_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnAddPensideTest.ServerClick
        Try
            log.Info("Sample Type reference creation begins")
            hdfPTNValidationError.Value = True

            If (String.IsNullOrEmpty(txtPTNstrDefault.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtPTNstrName.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else

                Dim baseRefParams As AdminBaseReferenceSetParams = New AdminBaseReferenceSetParams()
                baseRefParams.idfsBaseReference = Nothing
                baseRefParams.idfsReferenceType = 19000104
                baseRefParams.languageId = language
                baseRefParams.strDefault = txtPTNstrDefault.Text.Trim()
                baseRefParams.strName = txtPTNstrName.Text.Trim()

                Dim HaCode As Integer = 0

                For Each li As ListItem In lstPTNHACode.Items
                    If li.Selected Then
                        HaCode = HaCode + Convert.ToInt16(li.Value)
                    End If
                Next

                If HaCode = 0 Then
                    lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Accessory_Code_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                    Exit Sub
                Else
                    baseRefParams.intHACode = HaCode
                End If

                If Not String.IsNullOrEmpty(txtPTNintOrder.Text) Then
                    baseRefParams.intOrder = Convert.ToInt32(txtPTNintOrder.Text)
                Else
                    baseRefParams.intOrder = 0
                End If

                Dim results As String = baseReferenceAPIClient.BaseReferneceSet(baseRefParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    RepopulatePTNDropdown()
                Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_Test_Name") & txtPTNstrDefault.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
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

    Protected Sub btnSubmitVectorTypeSampleTypeMatrix_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitVectorTypeFieldTestMatrix.ServerClick
        Try
            log.Info("Vector Type - Sample Type matrix creation begins")
            hdfVTFTValidationError.Value = True


            If (ddlidfsVectorType.SelectedIndex < 1) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Vector_Type_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (ddlidfsPensideTestName.SelectedIndex < 1) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Test_Name_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else

                Dim VTFTParams As ConfVectortypefieldtestmatrixSetParams = New ConfVectortypefieldtestmatrixSetParams()

                VTFTParams.idfPensideTestTypeForVectorType = Nothing
                VTFTParams.idfsVectorType = Convert.ToInt64(ddlidfsVectorType.SelectedValue)
                VTFTParams.idfsPensideTestName = Convert.ToInt64(ddlidfsPensideTestName.SelectedValue)

                Dim results As String = vectorTypeFieldTestAPIClient.SetConfVectorTypeFieldTestMatrix(VTFTParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                Else
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Not_Possible.InnerText") & ddlidfsVectorType.SelectedItem.Text & "-" & ddlidfsPensideTestName.SelectedItem.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
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

    Protected Sub btnAddVectorTypeFieldTest_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddVectorTypeFieldTest.Click, btnCancelNo.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorTypeFieldTest');});", True)
        hdfVTFTValidationError.Value = True
    End Sub

    Protected Sub btnAddPensideTestName_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddPensideTestName.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addPensideTestName');});", True)
        hdfPTNValidationError.Value = True
    End Sub

    Protected Sub btnAddVector_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddVectorType.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('btnAddVectorType');});", True)
        hdfVTValidationError.Value = True
    End Sub

#End Region

#Region "ok"

    Protected Sub btnSuccessOK_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSuccessOK.ServerClick
        If hdfPTNValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorTypeFieldTest');});", True)
            clearPTNForm()
        ElseIf hdfVTFTValidationError.Value Then
            clearVTForm()
        Else
            clearVTFTForm()
        End If
    End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        log.Info("Vector Type - Field Test Matrix error begin")
        If hdfPTNValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addPensideTestName');});", True)
            Exit Sub
        End If
        If hdfVTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorType');});", True)
            Exit Sub
        End If
        If hdfVTFTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorTypeFieldTest');});", True)
            Exit Sub
        End If
        log.Info("Vector Type - Field Test Matrix error complete")
    End Sub

#End Region

#Region "cancel"
    Protected Sub btnCancelVectorTypeFieldTest_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelVectorTypeFieldTest.ServerClick
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

    Protected Sub btnCancelReference_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelVectorType.ServerClick, btnCancelPensideTest.ServerClick
        lbl_Cancel_Reference.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelReference');});", True)
    End Sub

    Protected Sub btnCancelReferenceYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceYes.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorTypeFieldTest');});", True)
    End Sub

    Protected Sub btnCancelReferenceNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick
        If hdfVTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorType');});", True)
        ElseIf hdfPTNValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addPensideTestName');});", True)
        End If
    End Sub

    Protected Sub btnCancelYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelYes.ServerClick
        log.Info("Report Disease Group Disease cancel begin")
        clearVTFTForm()
        log.Info("Report Disease Group Disease cancel complete")
    End Sub

    Protected Sub btnCancelNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelNo.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorTypeFieldTest');});", True)
    End Sub

#End Region

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Vector Type - Sample Type Matrix delete anyway begins")
            Dim VTPTNId = Convert.ToInt64(hdfVTFTidfPensideTestTypeForVectorType.Value)
            Dim returnMessage As String = vectorTypeFieldTestAPIClient.DelConfVectorTypeFieldTestMatrix(VTPTNId, True).Result(0).ReturnMessage
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

    Protected Sub gvVectorTypeFieldTestMatrix_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvVectorTypeFieldTestMatrix.PageIndexChanging
		Try
			log.Info("Vector Type - Sample Type Matrix pagination begin")
			gvVectorTypeFieldTestMatrix.PageIndex = e.NewPageIndex
			PopulateGrid()
			log.Info("Vector Type - Sample Type Matrix pagination complete")
		Catch ex As Exception
			log.Error("Vector Type - Sample Type Matrix record pagination error: " & ex.Message)
			lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

	Private Sub gvVectorTypeFieldTestMatrix_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvVectorTypeFieldTestMatrix.RowDeleting
		Try
			log.Info("Vector Type - Sample Type Matrix delete information gathering begins")
			Dim id As Int64 = Convert.ToInt64(gvVectorTypeFieldTestMatrix.DataKeys(e.RowIndex)(0))
            hdfVTFTidfPensideTestTypeForVectorType.Value = id
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

#Region "private"

#Region "clear"

    Private Sub clearVTForm()
		hdfVTValidationError.Value = False
		txtVTstrName.Text = String.Empty
		txtVTstrDefault.Text = String.Empty
		txtVTintOrder.Text = String.Empty
		txtVTstrCode.Text = String.Empty
		chkVTbitCollectionByPool.Checked = False
	End Sub

    Private Sub clearPTNForm()
        hdfPTNValidationError.Value = False
        txtPTNstrDefault.Text = String.Empty
        txtPTNstrName.Text = String.Empty
        txtPTNintOrder.Text = String.Empty
        lstPTNHACode.SelectedIndex = -1
    End Sub

    Private Sub clearVTFTForm()
        hdfVTFTValidationError.Value = False
        hdfVTFTidfPensideTestTypeForVectorType.Value = "NULL"
        ddlidfsPensideTestName.SelectedIndex = -1
        ddlidfsVectorType.SelectedIndex = -1
    End Sub

#End Region

#Region "populate"

    Private Sub fillSTHACode()
		lstPTNHACode.DataSource = globalAPIClient.GetHaCodes(GetCurrentLanguage(), HACodeList.HALVHACode).Result
		lstPTNHACode.DataValueField = "intHACode"
		lstPTNHACode.DataTextField = "CodeName"
		lstPTNHACode.DataBind()
	End Sub

	Private Sub PopulateGrid()
		Dim vectorTypeSampleTypes As List(Of ConfVectortypefieldtestmatrixGetlistModel) = vectorTypeFieldTestAPIClient.GetConfVectorTypeFieldTestMatrices(language, Convert.ToInt64(ddlidfsVectorType.SelectedValue)).Result
		gvVectorTypeFieldTestMatrix.DataSource = vectorTypeSampleTypes
		gvVectorTypeFieldTestMatrix.DataBind()
	End Sub

	Private Sub populationDropdowns()
        bindDropdown(ddlidfsVectorType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.VectorType, HACodeList.VectorHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlidfsPensideTestName, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.PensideTestName, HACodeList.VectorHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        fillSTHACode()
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

    Private Sub RepopulateVTDropdown()
		ddlidfsVectorType.Items.Clear()
        bindDropdown(ddlidfsVectorType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.VectorType, HACodeList.VectorHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsVectorType.Items.FindByText(txtVTstrName.Text).Selected = True
	End Sub

	Private Sub RepopulatePTNDropdown()
		ddlidfsPensideTestName.Items.Clear()
        bindDropdown(ddlidfsPensideTestName, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.PensideTestName, HACodeList.VectorHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsPensideTestName.Items.FindByText(txtPTNstrName.Text).Selected = True
	End Sub

#End Region


#End Region

#End Region

End Class