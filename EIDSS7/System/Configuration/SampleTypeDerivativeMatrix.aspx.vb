Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports System
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports log4net

Public Class SampleTypeDerivativeMatrix
    Inherits BaseEidssPage

    Private ReadOnly sampleTypeAPIClient As SampleTypeServiceClient
    Private ReadOnly baseReferenceAPIClient As BaseReferenceClient
    Private ReadOnly crossCuttingAPIClient As CrossCuttingServiceClient
    Private ReadOnly globalAPIClient As GlobalServiceClient
    Private ReadOnly sampleTypeDerivativeAPIClient As SampleTypeDerivativeServiceClient
    Private language As String
    Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(SampleTypeDerivativeMatrix))

    Sub New()
        language = GetCurrentLanguage()
        sampleTypeAPIClient = New SampleTypeServiceClient()
        baseReferenceAPIClient = New BaseReferenceClient()
        crossCuttingAPIClient = New CrossCuttingServiceClient()
        globalAPIClient = New GlobalServiceClient()
        sampleTypeDerivativeAPIClient = New SampleTypeDerivativeServiceClient()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not IsPostBack() Then
                log.Info("SampleTypeDerivativeMatrix page load begins")
                populationDropdowns()
                PopulateGrid()
                log.Info("SampleTypeDerivativeMatrix page load complete")
            End If
        Catch ex As Exception
            log.Error("SampleTypeDerivativeMatrix page load error", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#Region "buttons"

#Region "submit"
    Protected Sub btnSubmitSampleTypeDerivative_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitSampleTypeDerivative.ServerClick
        Try
            log.Info(" Sample Type Derivative Matrix creation begins")
            hdfSTDValidationError.Value = True

            If (ddlidfsSampleType.SelectedIndex < 1) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Sample_Type_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (ddlidfsDerivative.SelectedIndex < 1) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Derivative_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else

                Dim sampleTypeDerivativeParams As ConfSampleTypDerivativeSetParams = New ConfSampleTypDerivativeSetParams()

                sampleTypeDerivativeParams.idfDerivativeForSampleType = Nothing
                sampleTypeDerivativeParams.idfsSampleType = Convert.ToInt64(ddlidfsSampleType.SelectedValue)
                sampleTypeDerivativeParams.idfsDerivativeType = Convert.ToInt64(ddlidfsDerivative.SelectedValue)

                Dim results As String = sampleTypeDerivativeAPIClient.SetConfSampleTypeDerivativeMatrix(sampleTypeDerivativeParams).Result(0).returnMessage

                If results = "SUCCESS" Then
                    PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    log.Info(" Sample Type Derivative Matrix creation complete")
                Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible.InnerText") & ddlidfsSampleType.SelectedItem.Text & "-" & ddlidfsDerivative.SelectedItem.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                    log.Info(" Sample Type Derivative Matrix already exists")
                    Exit Sub
                End If
            End If
        Catch ex As Exception
            log.Error(" Sample Type Derivative Matrix creation error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
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
                Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_Sample_Type.InnerText") & txtSTstrDefault.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                End If
            End If
            log.Info("Sample Type reference creation complete")
        Catch ex As Exception
            log.Error("Sample Type reference creation error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Create.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnSubmitDerivative_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitDerivative.ServerClick
        Try
            log.Info("Derivative type reference creation begins")
            hdfSTValidationError.Value = True

            If (String.IsNullOrEmpty(txtDstrDefault.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtDstrName.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else

                Dim sampleTypeRefParams As AdminSampleReferenceTypeSet = New AdminSampleReferenceTypeSet()
                sampleTypeRefParams.idfsSampleType = Nothing
                sampleTypeRefParams.laguageId = language
                sampleTypeRefParams.strDefault = txtDstrDefault.Text.Trim()
                sampleTypeRefParams.strName = txtDstrName.Text.Trim()

                Dim HaCode As Integer = 0

                For Each li As ListItem In lstDHACode.Items
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

                If Not String.IsNullOrEmpty(txtDintOrder.Text) Then
                    sampleTypeRefParams.intOrder = Convert.ToInt32(txtDintOrder.Text)
                Else
                    sampleTypeRefParams.intOrder = 0
                End If

                sampleTypeRefParams.strSampleCode = txtDstrCode.Text.Trim()

                Dim results As String = sampleTypeAPIClient.SampleTypeSet(sampleTypeRefParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    RepopulateDDropdown()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)

                Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_Derivative_Type.InnerText") & txtSTstrDefault.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                End If
            End If
            log.Info("Derivative Type reference creation complete")
        Catch ex As Exception
            log.Error("Derivative Type reference creation error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Create.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub
#End Region

#Region "add"

    Protected Sub btnAddSampleTypeDerivativeMatrix_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddSampleTypeDerivativeMatrix.Click, btnCancelNo.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleTypeDerivative');});", True)
        hdfSTDValidationError.Value = True
    End Sub

    Protected Sub btnAddDerivative_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddDerivative.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDerivative');});", True)
        hdfDValidationError.Value = True
    End Sub

    Protected Sub btnAddSampleType_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddSampleType.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleType');});", True)
        hdfSTValidationError.Value = True
    End Sub

#End Region

#Region "cancel"

    Protected Sub btnCancelSampleTypeDerivative_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelSampleTypeDerivative.ServerClick
        Try
            log.Info("Sample Type Derivative cancel begins")
            lbl_Cancel.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelModal');});", True)
            log.Info("Sample Type Derivative cancel complete")
        Catch ex As Exception
            log.Error("Sample Type Derivative cancel error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnCancelReference_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelSampleType.ServerClick, btnCancelDerivative.ServerClick
        lbl_Cancel_Reference = GetLocalResourceObject("lbl_Cancel.InnerText")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelReference');});", True)
    End Sub

    Protected Sub btnCancelReferenceYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceYes.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleTypeDerivative');});", True)
    End Sub

    Protected Sub btnCancelReferenceNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick
        If hdfSTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleType');});", True)
        ElseIf hdfDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDerivative');});", True)
        End If
    End Sub

    Protected Sub btnCancelYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelYes.ServerClick
        log.Info("Clearing Sample Type Derivative Matrix info begins")
        clearSTDForm()
        log.Info("Clearing Sample Type Derivative Matrix info complete")
    End Sub

    Protected Sub btnCancelNo_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelNo.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleTypeDerivative');});", True)
    End Sub

#End Region

#Region "ok"

    Protected Sub btnSuccessOK_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSuccessOK.ServerClick
        If hdfSTValidationError.Value = True Or hdfDValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleTypeDerivative');});", True)
            clearDForm()
            clearSTForm()
        ElseIf hdfSTDValidationError.Value = True Then
            clearSTDForm()
        End If
    End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnErrorOK.ServerClick
        If hdfSTValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleType');});", True)
        ElseIf hdfDValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDerivative');});", True)
        ElseIf hdfSTDValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleTypeDerivative');});", True)
        End If
    End Sub

#End Region

#Region "Correct"
    Protected Sub btnContinueRequiredYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnContinueRequiredYes.ServerClick, btnAlreadyExistsYes.ServerClick
        If hdfDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDerivativeType');});", True)
        ElseIf hdfSTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleType');});", True)
        ElseIf hdfSTDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleTypeDerivative');});", True)
        End If
    End Sub

    Protected Sub btnContinueRequiredNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick, btnAlreadyExistsNo.ServerClick
        If hdfDValidationError.Value Then
            clearDForm()
        ElseIf hdfSTValidationError.Value Then
            clearSTForm()
        ElseIf hdfSTDValidationError.Value Then
            clearSTDForm()
        End If
    End Sub

#End Region

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Sample Type Derivative Matrix delete anyway begins")
            Dim STDId = Convert.ToInt64(hdfSTDidfSampleTypeForDerivative.Value)
            Dim returnMessage As String = sampleTypeDerivativeAPIClient.DelConfSampleTypeDerivativeMatrix(STDId, True).Result(0).returnMessage
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("Sample Type Derivative Matrix delete anyway complete")
        Catch ex As Exception
            log.Error("Sample Type Derivative Matrix delete anyway error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub
#End Region

#Region "grid view"
    Protected Sub gvSampleTypeDerivativeMatrix_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvSampleTypeDerivativeMatrix.PageIndexChanging
        Try
            log.Info("Sample Type Derivative pagination begin")
            gvSampleTypeDerivativeMatrix.PageIndex = e.NewPageIndex
            PopulateGrid()
                log.Info("Sample Type Derivative pagination complete")
        Catch ex As Exception
            log.Error("Sample Type Derivative record pagination error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Private Sub gvSampleTypeDerivativeMatrix_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvSampleTypeDerivativeMatrix.RowDeleting
        Try
            log.Info("Sample Type Derivative delete information gathering begins")
            Dim id As Int64 = Convert.ToInt64(gvSampleTypeDerivativeMatrix.DataKeys(e.RowIndex)(0))
            hdfSTDidfSampleTypeForDerivative.Value = id

            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Question_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
            log.Info("Sample Type Derivative delete information gathering complete")
        Catch ex As Exception
            log.Error("Sample Type Derivative delete information gathering error: " & ex.Message)
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
        Dim sampleTypeDerivatives As List(Of ConfSampletypederivativematrixGetlistModel) = sampleTypeDerivativeAPIClient.GetConfSampleTypeDerivativeMatrices(language).Result
        gvSampleTypeDerivativeMatrix.DataSource = sampleTypeDerivatives
        gvSampleTypeDerivativeMatrix.DataBind()
    End Sub

    Private Sub populationDropdowns()
        bindDropdown(ddlidfsSampleType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.SampleType, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlidfsDerivative, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.SampleType, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        fillHACode(lstSTHACode)
        fillHACode(lstDHACode)
    End Sub

#End Region
#Region "repopulate"

    Private Sub RepopulateSTDropdown()
        ddlidfsSampleType.Items.Clear()
        bindDropdown(ddlidfsSampleType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.SampleType, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsSampleType.Items.FindByText(txtSTstrName.Text).Selected = True
    End Sub

    Private Sub RepopulateDDropdown()
        ddlidfsDerivative.Items.Clear()
        bindDropdown(ddlidfsDerivative, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.SampleType, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, GetLocalResourceObject("lbl_Select_A_Derivative.InnerText"))
        ddlidfsDerivative.Items.FindByText(txtDstrName.Text).Selected = True
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
#End Region
#Region "clear"
    Private Sub clearSTForm()
        hdfSTValidationError.Value = False
        txtSTstrName.Text = String.Empty
        txtSTstrDefault.Text = String.Empty
        txtSTintOrder.Text = String.Empty
        lstSTHACode.SelectedIndex = -1
    End Sub

    Private Sub clearSTDForm()
        hdfSTDidfSampleTypeForDerivative.Value = "NULL"
        hdfSTDValidationError.Value = False
        ddlidfsSampleType.SelectedIndex = -1
        ddlidfsDerivative.SelectedIndex = -1
    End Sub

    Private Sub clearDForm()
        hdfDValidationError.Value = False
        txtDstrDefault.Text = String.Empty
        txtDstrName.Text = String.Empty
        lstDHACode.SelectedIndex = -1
        txtDintOrder.Text = String.Empty
    End Sub
#End Region
#End Region
End Class