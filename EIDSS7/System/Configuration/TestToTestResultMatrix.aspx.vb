Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports System
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports log4net

Public Class TestToTestResultMatrix
    Inherits BaseEidssPage

    Private ReadOnly testTestResultAPIClient As TestTestResultServiceClient
    Private ReadOnly crossCuttingAPIClient As CrossCuttingServiceClient
    Private ReadOnly globalAPIClient As GlobalServiceClient
    Private ReadOnly baseReferenceAPIClient As BaseReferenceClient
    Private language As String
    Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(TestToTestResultMatrix))

    Sub New()
        language = GetCurrentLanguage()
        crossCuttingAPIClient = New CrossCuttingServiceClient()
        testTestResultAPIClient = New TestTestResultServiceClient()
        baseReferenceAPIClient = New BaseReferenceClient()
        globalAPIClient = New GlobalServiceClient()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not IsPostBack() Then
                log.Info("test to test result page load begins")
                populateTestResultRelations()
                log.Info("test to test result page load complete")
            End If
        Catch ex As Exception
            log.Error("test to test result page load error", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#Region "selection changed"

    Protected Sub rblTestResultsRelations_SelectedIndexChanged(sender As Object, e As EventArgs) Handles rblTestResultsRelations.SelectedIndexChanged
        populateDropdowns()
    End Sub

    Private Sub ddlidfsTestName_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsTestName.SelectedIndexChanged
        Try
            log.Info("Load new age groups after disease change begins")
            PopulateGrid()
            log.Info("Load new age groups after disease change complete")
        Catch ex As Exception
            log.Error("Load new age groups after disease change error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading_Page.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "buttons"

#Region "submit"
    Protected Sub btnSubmitTestTestResult_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitTestTestResult.ServerClick
        Try
            log.Info("test to test result Matrix creation begins")
            hdfTTRValidationError.Value = True

            If ddlidfsTestName.SelectedIndex < 1 Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Test_Name_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf ddlidfsTestResult.SelectedIndex < 1 Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Test_Result_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else

                Dim ttrParams As ConfTesttotestresultmatrixSetParams = New ConfTesttotestresultmatrixSetParams()
                ttrParams.idfsTestName = Convert.ToInt64(ddlidfsTestName.SelectedValue)
                ttrParams.blnIndicative = chkblnIndicative.Checked
                ttrParams.idfsTestResultRelation = Convert.ToInt64(rblTestResultsRelations.SelectedValue)
                ttrParams.idfsTestResult = Convert.ToInt64(ddlidfsTestResult.SelectedValue)

                Dim results As String = testTestResultAPIClient.SetConfTesttoTestResultMatrix(ttrParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                Else

                End If
            End If
            log.Info("test to test result Matrix creation complete")
        Catch ex As Exception
            log.Error("test to test result Matrix creation error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Create.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
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

                If rblTestResultsRelations.SelectedValue = "19000097" Then
                    baseRefParams.idfsReferenceType = 19000097
                Else
                    baseRefParams.idfsReferenceType = 19000104
                End If

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

    Protected Sub btnSubmitTestResult_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitTestResult.ServerClick
        Try
            log.Info("Test Result reference creation begins")
            hdfTRValidationError.Value = True

            If (String.IsNullOrEmpty(txtTRstrDefault.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtTRstrName.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else

                Dim baseRefParams As AdminBaseReferenceSetParams = New AdminBaseReferenceSetParams()
                baseRefParams.idfsBaseReference = Nothing
                If rblTestResultsRelations.SelectedValue = "19000097" Then
                    baseRefParams.idfsReferenceType = 19000096
                Else
                    baseRefParams.idfsReferenceType = 19000105
                End If
                baseRefParams.languageId = language
                baseRefParams.strDefault = txtTRstrDefault.Text.Trim()
                baseRefParams.strName = txtTRstrName.Text.Trim()

                Dim HaCode As Integer = 0

                For Each li As ListItem In lstTRHACode.Items
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

                If Not String.IsNullOrEmpty(txtTRintOrder.Text) Then
                    baseRefParams.intOrder = Convert.ToInt32(txtTRintOrder.Text)
                Else
                    baseRefParams.intOrder = 0
                End If

                Dim results As String = baseReferenceAPIClient.BaseReferneceSet(baseRefParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    RepopulateTRDropdown()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_Test_Result.InnerText") & txtTRstrDefault.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
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
    Protected Sub btnAddTestTestResult_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddTestTestResult.Click, btnCancelNo.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestTestResult');});", True)
    End Sub

    Protected Sub btnAddTestName_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddTestName.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestName');});", True)
    End Sub

    Protected Sub btnAddTestResult_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddTestResult.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestResult');});", True)
    End Sub
#End Region

#Region "cancel"
    Protected Sub btnCancelTestTestResult_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelTestTestResult.ServerClick
        log.Info("test to test result Matrix cancel begins")
        lbl_Cancel.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelModal');});", True)
        log.Info("test to test result Matrix cancel complete")
    End Sub

    Protected Sub btnCancelReference_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelTestResult.ServerClick, btnCancelTestName.ServerClick
        log.Info("Cancel Reference begins")
        lbl_Cancel_Reference.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelReference');});", True)
        log.Info("Cancel Reference cancel complete")
    End Sub

    Protected Sub btnCancelReferenceNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick
        If hdfTNValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestName');});", True)
        ElseIf hdfTRValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestResult');});", True)
        End If
    End Sub

    Protected Sub btnCancelReferenceYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceYes.ServerClick
        If hdfTTRValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestTestResult');});", True)
        ElseIf hdfTRValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestResult');});", True)
        ElseIf hdfTNValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestName');});", True)
        End If
    End Sub

    Protected Sub btnCancelYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelYes.ServerClick
        log.Info("Report Disease Group Disease cancel begin")
        clearTTRForm()
        log.Info("Report Disease Group Disease cancel complete")
    End Sub
#End Region

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("test to test result Matrix delete anyway begins")
            Dim TRRId = Convert.ToInt64(rblTestResultsRelations.SelectedValue)
            Dim TNId = Convert.ToInt64(hdfTTRidfsTestName.Value)
            Dim TRId = Convert.ToInt64(hdfTTRidfsTestResult.Value)
            Dim returnMessage As String = testTestResultAPIClient.DelConfTesttoTestResultMatrix(TRRId, TNId, TRId, False).Result(0).ReturnMessage
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("test to test result Matrix delete anyway complete")
        Catch ex As Exception
            log.Error("test to test result Matrix delete anyway error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnSuccessOK_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSuccessOK.ServerClick
        If hdfTRValidationError.Value Then
            clearTRForm()
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestTestResult');});", True)
        ElseIf hdfTNValidationError.Value Then
            clearTNForm()
        Else
            clearTTRForm()
        End If
    End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        log.Info("test to test result Matrix delete anyway complete")
        If hdfTTRValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestTestResult');});", True)
        ElseIf hdfTRValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestResult');});", True)
        ElseIf hdfTNValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestName');});", True)
        End If
        log.Info("test to test result Matrix delete anyway complete")
    End Sub

    Protected Sub btnContinueRequiredYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnContinueRequiredYes.ServerClick, btnAlreadyExistsYes.ServerClick
        If hdfTTRValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestTestResult');});", True)
        ElseIf hdfTRValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestResult');});", True)
        ElseIf hdfTNValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addTestName');});", True)
        End If
    End Sub

    Protected Sub btnContinueRequiredNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick, btnAlreadyExistsNo.ServerClick
        If hdfTTRValidationError.Value Then
            clearTTRForm()
        ElseIf hdfTNValidationError.Value Then
            clearTNForm()
        ElseIf hdfTRValidationError.Value Then
            clearTRForm()
        End If
    End Sub
#End Region

#Region "grid view"
    Protected Sub gvDiseasePensideTest_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvTestToTestResultMatrix.PageIndexChanging
        Try
            log.Info("test to test result Matrix pagination begin")
            gvTestToTestResultMatrix.PageIndex = e.NewPageIndex
            PopulateGrid()
            log.Info("test to test result Matrix pagination complete")
        Catch ex As Exception
            log.Error("test to test result Matrix record pagination error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Private Sub gvTestToTestResultMatrix_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvTestToTestResultMatrix.RowDeleting
        Try
            log.Info("test to test result Matrix delete information gathering begins")
            Dim idfsTestName As Int64 = Convert.ToInt64(gvTestToTestResultMatrix.DataKeys(e.RowIndex)(0))
            Dim idfsTestResult As Int64 = Convert.ToInt64(gvTestToTestResultMatrix.DataKeys(e.RowIndex)(1))
            hdfTTRidfsTestName.Value = Convert.ToInt64(idfsTestName)
            hdfTTRidfsTestResult.Value = Convert.ToInt64(idfsTestResult)

            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Question_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
            log.Info("test to test result Matrix delete information gathering complete")
        Catch ex As Exception
            log.Error("test to test result Matrix delete information gathering error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

    Private Sub PopulateGrid()
        Dim testtoTestResult As List(Of ConfTesttotestresultmatrixGetlistModel) = testTestResultAPIClient.GetConfTesttotestresultmatrices(language, Convert.ToInt64(rblTestResultsRelations.SelectedValue), Convert.ToInt64(ddlidfsTestName.SelectedValue)).Result
        gvTestToTestResultMatrix.DataSource = testtoTestResult
        gvTestToTestResultMatrix.DataBind()
    End Sub

    Private Sub populateTestResultRelations()
        rblTestResultsRelations.Items.Add(New ListItem(GetLocalResourceObject("lbl_Lab_Test.InnerText"), 19000097))
        rblTestResultsRelations.Items.Add(New ListItem(GetLocalResourceObject("lbl_Penside_Test.InnerText"), 19000104))
        rblTestResultsRelations.Items(0).Selected = True
        bindDropdown(ddlidfsTestName, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.TestName, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlidfsTestResult, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.TestResult, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        fillHACode(lstTNHACode)
        fillHACode(lstTRHACode)
        PopulateGrid()
    End Sub

    Private Sub populateDropdowns()
        ddlidfsTestName.Items.Clear()
        ddlidfsTestResult.Items.Clear()
        If rblTestResultsRelations.SelectedValue = "19000097" Then
            bindDropdown(ddlidfsTestName, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.TestName, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
            bindDropdown(ddlidfsTestResult, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.TestResult, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        Else
            bindDropdown(ddlidfsTestName, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.PensideTestName, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
            bindDropdown(ddlidfsTestResult, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.PensideTestResult, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        End If
        PopulateGrid()
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

    Private Sub RepopulateTNDropdown()
        ddlidfsTestName.Items.Clear()
        If rblTestResultsRelations.SelectedValue = "19000097" Then
            bindDropdown(ddlidfsTestName, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.TestName, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        Else
            bindDropdown(ddlidfsTestName, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.PensideTestName, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        End If
        Dim selectedListItem As ListItem = ddlidfsTestName.Items.FindByText(txtTNstrName.Text)

        ddlidfsTestName.Items.FindByText(txtTNstrName.Text).Selected = True
    End Sub

    Private Sub RepopulateTRDropdown()
        ddlidfsTestResult.Items.Clear()
        If rblTestResultsRelations.SelectedValue = "19000097" Then
            bindDropdown(ddlidfsTestResult, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.TestResult, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        Else
            bindDropdown(ddlidfsTestResult, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.PensideTestResult, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        End If

        ddlidfsTestResult.Items.FindByText(txtTRstrName.Text).Selected = True
    End Sub

    Private Sub clearTTRForm()
        hdfTTRValidationError.Value = False
        ddlidfsTestResult.SelectedIndex = -1
        chkblnIndicative.Checked = False
    End Sub

    Private Sub clearTNForm()
        hdfTNValidationError.Value = False
        txtTNstrDefault.Text = String.Empty
        txtTNstrName.Text = String.Empty
        txtTNintOrder.Text = String.Empty
        lstTNHACode.SelectedIndex = -1
    End Sub

    Private Sub clearTRForm()
        hdfTRValidationError.Value = False
        txtTRstrDefault.Text = String.Empty
        txtTRstrName.Text = String.Empty
        txtTRintOrder.Text = String.Empty
        lstTRHACode.SelectedIndex = -1
    End Sub

    Private Sub fillHACode(ByRef ddl As ListBox)
        ddl.DataSource = globalAPIClient.GetHaCodes(GetCurrentLanguage(), HACodeList.AllHACode).Result
        ddl.DataValueField = "intHACode"
        ddl.DataTextField = "CodeName"
        ddl.DataBind()
    End Sub


End Class