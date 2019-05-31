Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports System
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports log4net

Public Class DiseasePensideTestMatrix
    Inherits BaseEidssPage

    Private ReadOnly diseasePensideTestAPIClient As DiseasePensideTestMatrixServiceClient
    Private ReadOnly crossCuttingAPIClient As CrossCuttingServiceClient
    Private ReadOnly globalAPIClient As GlobalServiceClient
    Private ReadOnly diagnosisAPIClient As DiagnosisServiceClient
    Private ReadOnly baseReferenceAPIClient As BaseReferenceClient
    Private language As String
    Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(DiseasePensideTestMatrix))

    Sub New()
        language = GetCurrentLanguage()
        diseasePensideTestAPIClient = New DiseasePensideTestMatrixServiceClient()
        crossCuttingAPIClient = New CrossCuttingServiceClient()
        diagnosisAPIClient = New DiagnosisServiceClient()
        baseReferenceAPIClient = New BaseReferenceClient()
        globalAPIClient = New GlobalServiceClient()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not Page.IsPostBack Then
                log.Info("Disease Penside Test Matrix page load begin")
                populationDropdowns()
                PopulateGrid()
                log.Info("Disease Penside Test Matrix page load begin")
            End If
        Catch ex As Exception
            log.Error("Disease Penside Test Matrix page load error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#Region "buttons"

#Region "submit"


    Protected Sub btnSubmitDiseasePensideTest_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitDiseasePensideTest.ServerClick
        Try
            log.Info("Disease Penside Test Matrix creation begins")
            hdfDPTValidationError.Value = True

            If (ddlidfsDiagnosis.SelectedIndex < 1) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Disease_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (ddlidfsPensideTestName.SelectedIndex < 1) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Test_Name_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else

                Dim dptParams As ConfDiseasePendisideSetParams = New ConfDiseasePendisideSetParams()

                dptParams.idfPensideTestForDisease = Nothing
                dptParams.idfsDiagnosis = Convert.ToInt64(ddlidfsDiagnosis.SelectedValue)
                dptParams.idfsPensideTestName = Convert.ToInt64(ddlidfsPensideTestName.SelectedValue)

                Dim results As String = diseasePensideTestAPIClient.SetConfDiseasePensideTestMatrix(dptParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                Else
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Not_Possible.InnerText") & ddlidfsDiagnosis.SelectedItem.Text & "-" & ddlidfsDiagnosis.SelectedItem.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
                End If
            End If
            log.Info("Disease Penside Test Matrix creation complete")
        Catch ex As Exception
            log.Error("Disease Penside Test Matrix creation error: " & ex.Message)
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
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnSubmitTestName_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitTestName.ServerClick
        Try
            log.Info("Test Name reference creation begins")
            hdfTNValidationError.Value = True

            If (String.IsNullOrEmpty(txtTNstrDefault.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtTNstrName.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else

                Dim baseRefParams As AdminBaseReferenceSetParams = New AdminBaseReferenceSetParams()
                baseRefParams.idfsBaseReference = Nothing
                baseRefParams.idfsReferenceType = 19000104
                baseRefParams.languageId = language
                baseRefParams.strDefault = txtTNstrDefault.Text.Trim()
                baseRefParams.strName = txtTNstrName.Text.Trim()

                Dim HaCode As Integer = 0

                For Each li As ListItem In lstTNHACode.Items
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

                If Not String.IsNullOrEmpty(txtTNintOrder.Text) Then
                    baseRefParams.intOrder = Convert.ToInt32(txtTNintOrder.Text)
                Else
                    baseRefParams.intOrder = 0
                End If

                Dim results As String = baseReferenceAPIClient.BaseReferneceSet(baseRefParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    RepopulateTNDropdown()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
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

    Protected Sub btnAddDiseasePensideTestMatrix_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddDiseasePensideTestMatrix.Click
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseasePensideTest');});", True)
        hdfDPTValidationError.Value = True
    End Sub

    Protected Sub btnAddDisease_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddDisease.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        hdfCDValidationError.Value = True
    End Sub

    Protected Sub btnAddTesName_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddTestName.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestName');});", True)
        hdfTNValidationError.Value = True
    End Sub

#End Region

#Region "cancel"

    Protected Sub btnCancelDiseasePensideTest_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelDiseasePensideTest.ServerClick
        Try
            log.Info("Disease Penside Test Matrix cancel begins")
            lbl_Cancel.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelModal');});", True)
            log.Info("Disease Penside Test Matrix cancel complete")
        Catch ex As Exception
            log.Error("Disease Penside Test Matrix delete anyway error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)

        End Try

    End Sub

    Protected Sub btnCancelReference_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelDisease.ServerClick, btnCancelTestName.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelReference');});", True)
    End Sub

    Protected Sub btnCancelYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelYes.ServerClick
        log.Info("Disease Penside Test Matrix delete anyway complete")
        clearDPTForm()
        log.Info("Disease Penside Test Matrix delete anyway complete")
    End Sub

    Protected Sub btnCancelNo_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelNo.ServerClick
        log.Info("Disease Penside Test Matrix cancel no complete")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseasePensideTest');});", True)
        log.Info("Disease Penside Test Matrix delete cancel no complete")
    End Sub

    Protected Sub btnContinueRequiredYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnContinueRequiredYes.ServerClick, btnAlreadyExistsYes.ServerClick
        If hdfDPTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseasePensideTest');});", True)
        ElseIf hdfCDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        ElseIf hdfTNValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestName');});", True)
        End If
    End Sub

    Protected Sub btnContinueRequiredNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick, btnAlreadyExistsNo.ServerClick
        If hdfDPTValidationError.Value Then
            clearDPTForm()
        ElseIf hdfCDValidationError.Value Then
            clearCDForm()
        ElseIf hdfTNValidationError.Value Then
            clearTNForm()
        End If
    End Sub

#End Region

#Region "ok"
    Protected Sub btnSuccessOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSuccessOK.ServerClick
        log.Info("Disease Penside Test Matrix delete anyway complete")
        If hdfDPTValidationError.Value Then
            clearDPTForm()
        ElseIf hdfTNValidationError.Value Or hdfCDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseasePensideTest');});", True)
            clearTNForm()
            clearCDForm()
        End If
        log.Info("Disease Penside Test Matrix delete anyway complete")
    End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        log.Info("Disease Penside Test Matrix delete anyway complete")
        If hdfDPTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseasePensideTest');});", True)
        ElseIf hdfCDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        ElseIf hdfTNValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestName');});", True)
        End If
        log.Info("Disease Penside Test Matrix delete anyway complete")
    End Sub
#End Region

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Disease Penside Test Matrix delete anyway begins")
            Dim dptId = Convert.ToInt64(hdfDPTidfsPensideTestforDisease.Value)
            Dim returnMessage As String = diseasePensideTestAPIClient.DelConfDiseasePensideTestMatrix(dptId).Result(0).ReturnMessage
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("Disease Penside Test Matrix delete anyway complete")
        Catch ex As Exception
            log.Error("Disease Penside Test Matrix delete anyway error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "grid view"
    Protected Sub gvDiseasePensideTest_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvDiseasePensideTest.PageIndexChanging
        Try
            log.Info("Disease Penside Test Matrix pagination begin")
            gvDiseasePensideTest.PageIndex = e.NewPageIndex
            PopulateGrid()
            log.Info("Disease Penside Test Matrix pagination complete")
        Catch ex As Exception
            log.Error("Disease Penside Test Matrix record pagination error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Private Sub gvDiseasePensideTest_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvDiseasePensideTest.RowDeleting
        Try
            log.Info("Disease Penside Test Matrix delete information gathering begins")
            Dim id As Int64 = Convert.ToInt64(gvDiseasePensideTest.DataKeys(e.RowIndex)(0))
            hdfDPTidfsPensideTestforDisease.Value = id
            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Question_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
            log.Info("Disease Penside Test Matrix delete information gathering complete")
        Catch ex As Exception
            log.Error("Disease Penside Test Matrix delete information gathering error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "private"

#Region "populate"

    Private Sub PopulateGrid()
        Dim diseasePensideTestList As List(Of ConfDiseasepensidetestmatrixGetListModel) = diseasePensideTestAPIClient.GetConfDiseasePensideTestMatrixList(language).Result
        gvDiseasePensideTest.DataSource = diseasePensideTestList
        gvDiseasePensideTest.DataBind()
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

    Private Sub fillHACode(ByRef ddl As ListBox)
        ddl.DataSource = globalAPIClient.GetHaCodes(GetCurrentLanguage(), HACodeList.AllHACode).Result
        ddl.DataValueField = "intHACode"
        ddl.DataTextField = "CodeName"
        ddl.DataBind()
    End Sub

    Private Sub populationDropdowns()
        bindDropdown(ddlidfsDiagnosis, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlidfsPensideTestName, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.PensideTestName, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlCDidfsUsingType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.DiagnosisUsingType, HACodeList.NoneHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        fillHACode(lstCDHACode)
        fillHACode(lstTNHACode)
    End Sub

#Region "repopulate"

    Private Sub RepopulateDDropdown()
        ddlidfsDiagnosis.Items.Clear()
        bindDropdown(ddlidfsDiagnosis, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsDiagnosis.Items.FindByText(txtCDstrName.Text).Selected = True
    End Sub

    Private Sub RepopulateTNDropdown()
        ddlidfsPensideTestName.Items.Clear()
        bindDropdown(ddlidfsPensideTestName, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.PensideTestName, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsPensideTestName.Items.FindByText(txtTNstrName.Text).Selected = True
    End Sub

#End Region

#End Region

#Region "clear"

    Private Sub clearDPTForm()
        hdfDPTidfsPensideTestforDisease.Value = "NULL"
        hdfDPTValidationError.Value = False
        ddlidfsPensideTestName.SelectedIndex = -1
        ddlidfsDiagnosis.SelectedIndex = -1
    End Sub

    Private Sub clearCDForm()
        hdfCDValidationError.Value = False
        ddlCDidfsUsingType.SelectedIndex = -1
        lstCDHACode.SelectedIndex = -1
        txtCDintOrder.Text = String.Empty
        txtCDstrDefault.Text = String.Empty
        txtCDstrName.Text = String.Empty
        txtCDstrIDC10.Text = String.Empty
        txtCDstrOIECode.Text = String.Empty
        chkCDblnSyndrome.Checked = False
        chkCDblnZoonotic.Checked = False
    End Sub

    Private Sub clearTNForm()
        hdfTNValidationError.Value = False
        txtTNstrDefault.Text = String.Empty
        txtTNstrName.Text = String.Empty
        txtTNintOrder.Text = String.Empty
        lstTNHACode.SelectedIndex = -1
    End Sub

#End Region

#End Region

End Class