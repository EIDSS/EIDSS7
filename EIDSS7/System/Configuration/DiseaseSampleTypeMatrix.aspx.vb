Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports System
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports log4net
Public Class DiseaseSampleTypeMatrix
    Inherits BaseEidssPage

    Private ReadOnly diseaseSampleTypeMatrixAPIClient As DiseaseSampleTypeServiceClient
    Private ReadOnly diagnosisAPIClient As DiagnosisServiceClient
    Private ReadOnly baseReferenceAPIClient As BaseReferenceClient
    Private ReadOnly sampleTypeAPIClient As SampleTypeServiceClient
    Private ReadOnly crossCuttingAPIClient As CrossCuttingServiceClient
    Private ReadOnly globalAPIClient As GlobalServiceClient
    Private language As String
    Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(DiseaseSampleTypeMatrix))

    Sub New()
        language = GetCurrentLanguage()
        diseaseSampleTypeMatrixAPIClient = New DiseaseSampleTypeServiceClient()
        diagnosisAPIClient = New DiagnosisServiceClient()
        sampleTypeAPIClient = New SampleTypeServiceClient()
        baseReferenceAPIClient = New BaseReferenceClient()
        crossCuttingAPIClient = New CrossCuttingServiceClient()
        globalAPIClient = New GlobalServiceClient()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not IsPostBack() Then
                log.Info("DiseaseSampleTypeMatrix page load begins")
                populationDropdowns()
                PopulateGrid()
                log.Info("DiseaseSampleTypeMatrix page load complete")
            End If
        Catch ex As Exception
            log.Error("DiseaseSampleTypeMatrix page load error", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#Region "buttons"

#Region "submit"

    Protected Sub btnSubmitDiseaseSampleType_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitDiseaseSampleType.ServerClick
        Try
            log.Info("Disease Sample Type Matrix creation begins")
            hdfDSTValidationError.Value = True

            If (ddlidfsDiagnosis.SelectedIndex < 1) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Disease_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (ddlidfsSampleType.SelectedIndex < 1) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Sample_Type_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else

                Dim dstParams As ConfDiseasesampletypematrixSetParams = New ConfDiseasesampletypematrixSetParams()

                dstParams.idfMaterialForDisease = Nothing
                dstParams.idfsDiagnosis = Convert.ToInt64(ddlidfsDiagnosis.SelectedValue)
                dstParams.idfsSampleType = Convert.ToInt64(ddlidfsSampleType.SelectedValue)

                Dim results As String = diseaseSampleTypeMatrixAPIClient.SetConfDiseasesampletypematrix(dstParams).Result(0).returnMessage

                If results = "SUCCESS" Then
                    PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
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
                    lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Select_Accessory_Code.InnerText")
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
                lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtSTstrName.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
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
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Select_Accessory_Code.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
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
                    RepopulateSTDropdown()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                Else
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Not_Possible_SampleType.InnerText") & txtCDstrName.Text & txtSTstrDefault.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
                End If
            End If
            log.Info("Sample Type reference creation complete")
        Catch ex As Exception
            log.Error("Sample Type reference creation error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

#End Region

#Region "add"

    Protected Sub btnAddDiseaseSampleTypeMatrix_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddDiseaseSampleTypeMatrix.Click
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseSampleType');});", True)
        hdfDSTValidationError.Value = True
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
        If hdfCDValidationError.Value = True Or hdfSTValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseSampleType');});", True)
            clearCDForm()
            clearSTForm()
        ElseIf hdfDSTValidationError.Value = True Then
            clearDSTForm()
        End If
    End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnErrorOK.ServerClick
        If hdfCDValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        ElseIf hdfSTValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleType');});", True)
        ElseIf hdfDSTValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseSampleType');});", True)
        End If
    End Sub

#End Region

#Region "cancel"

    Protected Sub btnCancelDiseaseSampleType_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelDiseaseSampleType.ServerClick
        Try
            log.Info("Disease - Sample Type cancel begins")
            lbl_Cancel.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelModal');});", True)
            log.Info("Disease - Sample Type cancel complete")
        Catch ex As Exception
            log.Error("Disease - Sample Type cancel error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnCancelReference_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelDisease.ServerClick, btnCancelSampleType.ServerClick
        lbl_Cancel_Reference.InnerText = GetLocalResourceObject("lbl_Cancel.Text")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelReference');});", True)
    End Sub

    Protected Sub btnCancelReferenceYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceYes.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseSampleType');});", True)
    End Sub

    Protected Sub btnCancelReferenceNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick
        If hdfSTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleType');});", True)
        ElseIf hdfCDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        End If
    End Sub

    Protected Sub btnCancelYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelYes.ServerClick
        clearDSTForm()
    End Sub

    Protected Sub btnCancelNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelNo.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDiseaseSampleType');});", True)
    End Sub

#End Region

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Disease - Sample Type Matrix delete anyway begins")
            Dim DSTId = Convert.ToInt64(hdfDSTidfMaterialforDisease.Value)
            Dim returnMessage As String = diseaseSampleTypeMatrixAPIClient.DelConfDiseaseSampleTypeMatrix(DSTId, True).Result(0).returnMessage
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("Disease - Sample Type Matrix delete anyway complete")
        Catch ex As Exception
            log.Error("Disease - Sample Type Matrix delete anyway error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub
#End Region

#Region "grid view"
    Protected Sub gvDiseaseSampleTypeMatrix_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvDiseaseSampleTypeMatrix.PageIndexChanging
        Try
            log.Info("Disease Sample Type Matrix pagination begin")
            gvDiseaseSampleTypeMatrix.PageIndex = e.NewPageIndex
            PopulateGrid()
            log.Info("Disease Sample Type Matrix pagination complete")
        Catch ex As Exception
            log.Error("Disease Sample Type Matrix record pagination error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Private Sub gvDiseaseSampleTypeMatrix_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvDiseaseSampleTypeMatrix.RowDeleting
        Try
            log.Info("Disease Sample Type Matrix delete information gathering begins")
            Dim id As Int64 = Convert.ToInt64(gvDiseaseSampleTypeMatrix.DataKeys(e.RowIndex)(0))
            hdfDSTidfMaterialforDisease.Value = id

            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Question_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
            log.Info("Disease Sample Type Matrix delete information gathering complete")
        Catch ex As Exception
            log.Error("Disease Sample Type Matrix delete information gathering error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "private"

#Region "populate"

    Private Sub fillHACode(ByRef ddl As ListBox)
        ddl.DataSource = globalAPIClient.GetHaCodes(GetCurrentLanguage(), HACodeList.AllHACode).Result
        ddl.DataValueField = "intHACode"
        ddl.DataTextField = "CodeName"
        ddl.DataBind()
    End Sub

    Private Sub PopulateGrid()
        Dim diseaseSampleTypes As List(Of ConfDiseasesampletypematrixGetlistModel) = diseaseSampleTypeMatrixAPIClient.GetConfDiseasesampletypematrices(language).Result
        gvDiseaseSampleTypeMatrix.DataSource = diseaseSampleTypes
        gvDiseaseSampleTypeMatrix.DataBind()
    End Sub

    Private Sub populationDropdowns()
        bindDropdown(ddlidfsDiagnosis, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, GetLocalResourceObject("lbl_Select_A_Disease.InnerText"))
        bindDropdown(ddlidfsSampleType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.SampleType, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, GetLocalResourceObject("lbl_Select_A_Sample_Type.InnerText"))
        bindDropdown(ddlCDidfsUsingType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.DiagnosisUsingType, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, GetLocalResourceObject("lbl_Select_A_Sample_Type.InnerText"))
        fillHACode(lstCDHACode)
        fillHACode(lstSTHACode)
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

    Private Sub RepopulateDDropdown()
        ddlidfsDiagnosis.Items.Clear()
        bindDropdown(ddlidfsDiagnosis, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, GetLocalResourceObject("lbl_Select_An_Age_Group"))
        ddlidfsDiagnosis.Items.FindByText(txtCDstrName.Text).Selected = True
    End Sub

    Private Sub RepopulateSTDropdown()
        ddlidfsSampleType.Items.Clear()
        bindDropdown(ddlidfsSampleType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.SampleType, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, GetLocalResourceObject("lbl_Select_A_Statistical_Age_Group.InnerText"))
        ddlidfsSampleType.Items.FindByText(txtSTstrName.Text).Selected = True
    End Sub
#End Region

#End Region

#Region "clear"
    Private Sub clearCDForm()
        hdfCDidfsDiagnosis.Value = "NULL"
        txtCDstrName.Text = String.Empty
        txtCDstrDefault.Text = String.Empty
        txtCDintOrder.Text = String.Empty
        txtCDstrIDC10.Text = String.Empty
        txtCDstrOIECode.Text = String.Empty
        ddlCDidfsUsingType.SelectedIndex = -1
    End Sub

    Private Sub clearDSTForm()
        hdfDSTidfMaterialforDisease.Value = "NULL"
        hdfDSTValidationError.Value = False
        ddlidfsDiagnosis.SelectedIndex = -1
        ddlidfsSampleType.SelectedIndex = -1
    End Sub

    Private Sub clearSTForm()
        txtSTstrDefault.Text = String.Empty
        txtSTstrName.Text = String.Empty
        txtSTstrSampleCode.Text = False
    End Sub
#End Region

#End Region
End Class