Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports System
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports log4net
Public Class DiseaseLabTestMatrix
    Inherits BaseEidssPage

    Private ReadOnly diseaseLabTestMatrixAPIClient As DiseaseLabTestServiceClient
    Private ReadOnly diagnosisAPIClient As DiagnosisServiceClient
    Private ReadOnly baseReferenceAPIClient As BaseReferenceClient
    Private ReadOnly sampleTypeAPIClient As SampleTypeServiceClient
    Private ReadOnly crossCuttingAPIClient As CrossCuttingServiceClient
    Private ReadOnly globalAPIClient As GlobalServiceClient
    Private language As String
    Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(DiseaseLabTestMatrix))

    Sub New()
        language = GetCurrentLanguage()
        diseaseLabTestMatrixAPIClient = New DiseaseLabTestServiceClient()
        diagnosisAPIClient = New DiagnosisServiceClient()
        sampleTypeAPIClient = New SampleTypeServiceClient()
        baseReferenceAPIClient = New BaseReferenceClient()
        crossCuttingAPIClient = New CrossCuttingServiceClient()
        globalAPIClient = New GlobalServiceClient()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not IsPostBack() Then
                log.Info("DiseaseLabTestMatrix page load begins")
                populationDropdowns()
                PopulateGrid()
                log.Info("DiseaseLabTestMatrix page load complete")
            End If
        Catch ex As Exception
            log.Error("DiseaseLabTestMatrix page load error", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading_Page.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#Region "buttons"

#Region "submit"

    Protected Sub btnSubmitDiseaseLabTest_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitDiseaseLabTest.ServerClick
        Try
            log.Info("Disease Sample Type Matrix creation begins")
            hdfDLTValidationError.Value = True

            If (ddlidfsDiagnosis.SelectedIndex < 1) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Disease_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (ddlidfsSampleType.SelectedIndex < 1) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Sample_Type_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (ddlidfsTestName.SelectedIndex < 1) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Test_Name_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (ddlidfsTestCategory.SelectedIndex < 1) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Test_Category_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else

                Dim dstParams As ConfDiseaselabtestmatrixSetParams = New ConfDiseaselabtestmatrixSetParams()

                dstParams.idfTestForDisease = Nothing
                dstParams.idfsDiagnosis = Convert.ToInt64(ddlidfsDiagnosis.SelectedValue)
                dstParams.idfsSampleType = Convert.ToInt64(ddlidfsSampleType.SelectedValue)
                dstParams.idfsTestCategory = Convert.ToInt64(ddlidfsTestCategory.SelectedValue)
                dstParams.idfsTestName = Convert.ToInt64(ddlidfsTestName.SelectedValue)

                Dim results As String = diseaseLabTestMatrixAPIClient.SetConfDiseaseLabTestMatrix(dstParams).Result(0).returnMessage

                If results = "SUCCESS" Then
                    PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    clearDLTForm()
                Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                End If
            End If
            log.Info("Disease Sample Type Matrix creation complete")
        Catch ex As Exception
            log.Error("Disease Sample Type Matrix creation error: " & ex.Message)
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

    Protected Sub btnSubmitSampleType_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitSampleType.ServerClick
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
                    lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Accessory_Code_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                    Exit Sub
                Else
                    sampleTypeRefParams.intHaCode = HaCode
                End If

                If Not String.IsNullOrEmpty(txtSTintOrder.Text) Then
                    sampleTypeRefParams.intOrder = Convert.ToInt32(txtSTintOrder.Text)
                Else
                    sampleTypeRefParams.intOrder = 0
                End If

                sampleTypeRefParams.strSampleCode = txtSTstrSampleCode.Text.Trim()

                Dim results As String = sampleTypeAPIClient.SampleTypeSet(sampleTypeRefParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    RepopulateSTDropdown()
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
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnSubmitTestCategory_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitTestCategory.ServerClick
        Try
            log.Info("Test Category reference creation begins")
            hdfTCValidationError.Value = True

            If (String.IsNullOrEmpty(txtTCstrDefault.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtTCstrName.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                Exit Sub
            Else

                Dim baseRefParams As AdminBaseReferenceSetParams = New AdminBaseReferenceSetParams()
                baseRefParams.idfsBaseReference = Nothing
                baseRefParams.idfsReferenceType = 19000104
                baseRefParams.languageId = language
                baseRefParams.strDefault = txtTCstrDefault.Text.Trim()
                baseRefParams.strName = txtTCstrName.Text.Trim()

                baseRefParams.intHACode = 0

                If Not String.IsNullOrEmpty(txtTCintOrder.Text) Then
                    baseRefParams.intOrder = Convert.ToInt32(txtTCintOrder.Text)
                Else
                    baseRefParams.intOrder = 0
                End If

                Dim results As String = baseReferenceAPIClient.BaseReferneceSet(baseRefParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    RepopulateTCDropdown()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    RepopulateTCDropdown()
                Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_Test_Category.InnerText") & txtTCstrDefault.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                End If
            End If
            log.Info("Test Category reference creation complete")
        Catch ex As Exception
            log.Error("Test Category reference creation error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnSubmitTestName_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitTestName.ServerClick
        Try
            log.Info("Test Name reference creation begins")
            hdfTCValidationError.Value = True

            If (String.IsNullOrEmpty(txtTCstrDefault.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtTCstrName.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else

                Dim baseRefParams As AdminBaseReferenceSetParams = New AdminBaseReferenceSetParams()
                baseRefParams.idfsBaseReference = Nothing
                baseRefParams.idfsReferenceType = 19000104
                baseRefParams.languageId = language
                baseRefParams.strDefault = txtTCstrDefault.Text.Trim()
                baseRefParams.strName = txtTCstrName.Text.Trim()

                baseRefParams.intHACode = 0

                If Not String.IsNullOrEmpty(txtTCintOrder.Text) Then
                    baseRefParams.intOrder = Convert.ToInt32(txtTCintOrder.Text)
                Else
                    baseRefParams.intOrder = 0
                End If

                Dim results As String = baseReferenceAPIClient.BaseReferneceSet(baseRefParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    RepopulateTNDropdown()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    RepopulateTCDropdown()
                Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_Test_Name.InnerText") & txtTNstrDefault.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                End If
            End If
            log.Info("Test Name reference creation complete")
        Catch ex As Exception
            log.Error("Test Name reference creation error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "add"

    Protected Sub btnAddDiseaseSampleTypeMatrix_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddDiseaseLabTestMatrix.Click, btnCancelNo.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseLabTest');});", True)
        hdfDLTValidationError.Value = True
    End Sub

    Protected Sub btnAddTestName_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddTestName.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestName');});", True)
        hdfTNValidationError.Value = True
    End Sub

    Protected Sub btnAddTestCategory_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddTestCategory.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestCategory');});", True)
        hdfTCValidationError.Value = True
    End Sub

    Protected Sub btnAddDisease_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddDisease.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        hdfCDValidationError.Value = True
    End Sub

    Protected Sub btnAddSampleType_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddSampleType.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleType');});", True)
        hdfSTValidationError.Value = True
    End Sub

#End Region

#Region "ok"

    Protected Sub btnSuccessOK_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSuccessOK.ServerClick
        If hdfCDValidationError.Value = True Or hdfSTValidationError.Value = True Or hdfTCValidationError.Value = True Or hdfTNValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseLabTest');});", True)
            clearCDForm()
            clearSTForm()
            clearTCForm()
            clearTNForm()
        ElseIf hdfDLTValidationError.Value = True Then
            clearDLTForm()
        End If
    End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnErrorOK.ServerClick
        If hdfDLTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseLabTest');});", True)
        ElseIf hdfCDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        ElseIf hdfSTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleType');});", True)
        ElseIf hdfTNValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestName');});", True)
        ElseIf hdfTCValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestCategory');});", True)
        End If
    End Sub

#End Region

#Region "cancel"

    Protected Sub btnCancelDiseaseLabTest_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelDiseaseLabTest.ServerClick
        Try
            log.Info("Disease - Lab Test cancel begins")
            lbl_Cancel.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelModal');});", True)
            log.Info("Disease - Lab Test cancel complete")
        Catch ex As Exception
            log.Error("Disease - Lab Test cancel error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnCancelYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelYes.ServerClick
        log.Info("Disease Lab Test cancel yes begin")
        clearDLTForm()
        log.Info("Disease Lab Test cancel yes complete")
    End Sub

    Protected Sub btnCancelNo_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelNo.ServerClick
        log.Info("Disease Lab Test Matrix cancel no complete")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseLabTest');});", True)
        log.Info("Disease Lab Test Matrix delete cancel no complete")
    End Sub

    Protected Sub btnCancelReference_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelDisease.ServerClick, btnCancelSampleType.ServerClick
        lbl_Cancel_Reference.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelReference');});", True)
    End Sub

    Protected Sub btnCancelReferenceYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceYes.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseLabTest');});", True)
    End Sub

    Protected Sub btnCancelReferenceNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick
        If hdfSTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleType');});", True)
        ElseIf hdfCDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        ElseIf hdfTNValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestName');});", True)
        ElseIf hdfTCValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestCategory');});", True)
        End If
    End Sub


#End Region

#Region "correct"

    Protected Sub btnContinueRequiredYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnContinueRequiredYes.ServerClick, btnAlreadyExistsYes.ServerClick
        If hdfDLTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseLabTest');});", True)
        ElseIf hdfSTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleType');});", True)
        ElseIf hdfTCValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestCategory');});", True)
        ElseIf hdfTNValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestName');});", True)
        End If
    End Sub

    Protected Sub btnContinueRequiredNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick, btnAlreadyExistsNo.ServerClick
        If hdfDLTValidationError.Value Then
            clearDLTForm()
        ElseIf hdfSTValidationError.Value Then
            clearSTForm()
        ElseIf hdfTCValidationError.Value Then
            clearTCForm()
        ElseIf hdfTNValidationError.Value Then
            clearTNForm()
        End If
    End Sub

#End Region

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Disease - Lab Test Matrix delete anyway begins")
            Dim DLTId = Convert.ToInt64(hdfDLTidfTestforDisease.Value)
            Dim returnMessage As String = diseaseLabTestMatrixAPIClient.DelConfDiseaseLabTestMatrix(DLTId, True).Result(0).returnMessage
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("Disease - Lab Test Matrix delete anyway complete")
        Catch ex As Exception
            log.Error("Disease - Lab Test Matrix delete anyway error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "grid view"
    Protected Sub gvDiseaseLabTestMatrix_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvDiseaseLabTestMatrix.PageIndexChanging
        Try
            log.Info("Disease Lab Test Matrix pagination begin")
            gvDiseaseLabTestMatrix.PageIndex = e.NewPageIndex
            PopulateGrid()
            log.Info("Disease Lab Test Matrix pagination complete")
        Catch ex As Exception
            log.Error("Disease Lab Test Matrix record pagination error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Private Sub gvDiseaseLabTestMatrix_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvDiseaseLabTestMatrix.RowDeleting
        Try
            log.Info("Disease Lab Test Matrix delete information gathering begins")
            Dim id As Int64 = Convert.ToInt64(gvDiseaseLabTestMatrix.DataKeys(e.RowIndex)(0))
            hdfDLTidfTestforDisease.Value = id

            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Question_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
            log.Info("Disease Lab Test Matrix delete information gathering complete")
        Catch ex As Exception
            log.Error("Disease Lab Test Matrix delete information gathering error: " & ex.Message)
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
        Dim diseaseLabTests As List(Of ConfDiseaselabtestmatrixGetlistModel) = diseaseLabTestMatrixAPIClient.GetConfDiseaselabtestmatrices(language).Result
        gvDiseaseLabTestMatrix.DataSource = diseaseLabTests
        gvDiseaseLabTestMatrix.DataBind()
    End Sub

    Private Sub populationDropdowns()
        bindDropdown(ddlidfsDiagnosis, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlidfsSampleType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.SampleType, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlidfsTestName, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.TestName, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlidfsTestCategory, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.TestCategory, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlCDidfsUsingType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.DiagnosisUsingType, HACodeList.NoneHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        fillHACode(lstCDHACode)
        fillHACode(lstSTHACode)
        fillHACode(lstTNHACode)
    End Sub

    Private Sub RepopulateDDropdown()
        ddlidfsDiagnosis.Items.Clear()
        bindDropdown(ddlidfsDiagnosis, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsDiagnosis.Items.FindByText(txtCDstrName.Text).Selected = True
    End Sub

    Private Sub RepopulateSTDropdown()
        ddlidfsSampleType.Items.Clear()
        bindDropdown(ddlidfsSampleType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.SampleType, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsSampleType.Items.FindByText(txtSTstrName.Text).Selected = True
    End Sub

    Private Sub RepopulateTNDropdown()
        ddlidfsTestName.Items.Clear()
        bindDropdown(ddlidfsTestName, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.TestName, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsTestName.Items.FindByText(txtTNstrName.Text).Selected = True
    End Sub

    Private Sub RepopulateTCDropdown()
        ddlidfsTestCategory.Items.Clear()
        bindDropdown(ddlidfsTestCategory, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.TestCategory, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsTestCategory.Items.FindByText(txtTCstrName.Text).Selected = True
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

    Private Sub clearCDForm()
        hdfCDidfsDiagnosis.Value = "NULL"
        txtCDstrName.Text = String.Empty
        txtCDstrDefault.Text = String.Empty
        txtCDintOrder.Text = String.Empty
        txtCDstrIDC10.Text = String.Empty
        txtCDstrOIECode.Text = String.Empty
        ddlCDidfsUsingType.SelectedIndex = -1
    End Sub

    Private Sub clearDLTForm()
        hdfDLTidfTestforDisease.Value = "NULL"
        hdfDLTValidationError.Value = False
        ddlidfsDiagnosis.SelectedIndex = -1
        ddlidfsSampleType.SelectedIndex = -1
        ddlidfsTestName.SelectedIndex = -1
        ddlidfsTestCategory.SelectedIndex = -1
    End Sub

    Private Sub clearSTForm()
        txtSTstrDefault.Text = String.Empty
        txtSTstrName.Text = String.Empty
        txtSTstrSampleCode.Text = False
        txtSTintOrder.Text = String.Empty
        lstSTHACode.SelectedIndex = -1
    End Sub

    Private Sub clearTNForm()
        txtTNstrDefault.Text = String.Empty
        txtTNstrName.Text = String.Empty
        txtTNintOrder.Text = False
        lstTNHACode.SelectedIndex = -1
    End Sub

    Private Sub clearTCForm()
        txtTCstrDefault.Text = String.Empty
        txtTCstrName.Text = String.Empty
        txtTCintOrder.Text = False
    End Sub

End Class