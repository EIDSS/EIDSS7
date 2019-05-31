Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports System
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports log4net

Public Class SpeciesTypeAnimalAgeMatrix
    Inherits BaseEidssPage

    Private ReadOnly speciesTypeAPIClient As SpeciesTypeClient
    Private ReadOnly speciesTypeAnimalAgeAPIClient As SpeciesTypeAnimalAgeServiceClient
    Private ReadOnly baseReferenceAPIClient As BaseReferenceClient
    Private ReadOnly crossCuttingAPIClient As CrossCuttingServiceClient
    Private ReadOnly globalAPIClient As GlobalServiceClient
    Private language As String
    Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(SpeciesTypeAnimalAgeMatrix))

    Sub New()
        language = GetCurrentLanguage()
        speciesTypeAPIClient = New SpeciesTypeClient()
        baseReferenceAPIClient = New BaseReferenceClient()
        crossCuttingAPIClient = New CrossCuttingServiceClient()
        globalAPIClient = New GlobalServiceClient()
        speciesTypeAnimalAgeAPIClient = New SpeciesTypeAnimalAgeServiceClient()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not IsPostBack() Then
                log.Info("SpeciesTypeAnimalAgeMatrix page load begins")
                populationDropdowns()
                PopulateGrid()
                log.Info("SpeciesTypeAnimalAgeMatrix page load complete")
            End If
        Catch ex As Exception
            log.Error("SpeciesTypeAnimalAgeMatrix page load error", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#Region "buttons"

#Region "submit"

    Protected Sub btnSubmitSpeciesTypeAnimalAge_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitSpeciesTypeAnimalAge.ServerClick
        Try
            log.Info("Species Type  Animal Age Matrix creation begins")
            hdfSPAAValidationError.Value = True

            If (ddlidfsAnimalAge.SelectedIndex < 1) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Animal_Age_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (ddlidfsSpeciesType.SelectedIndex < 1) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Species_Type_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else
                Dim speciesTypeAnimalAgeParams As ConfSpeciestypeanimalagematrixSetParams = New ConfSpeciestypeanimalagematrixSetParams()

                speciesTypeAnimalAgeParams.idfSpeciesTypeToAnimalAge = Nothing
                speciesTypeAnimalAgeParams.idfsSpeciesType = Convert.ToInt64(ddlidfsSpeciesType.SelectedValue)
                speciesTypeAnimalAgeParams.idfsAnimalAge = Convert.ToInt64(ddlidfsAnimalAge.SelectedValue)

                Dim results As String = speciesTypeAnimalAgeAPIClient.SetConfSpeciesTypeAnimalAgeMatrix(speciesTypeAnimalAgeParams).Result(0).returnMessage

                If results = "SUCCESS" Then
                    PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    log.Info("Species Type  Animal Age Matrix creation complete")
                Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Impossible.InnerText") & ddlidfsSpeciesType.SelectedItem.Text & "-" & ddlidfsAnimalAge.SelectedItem.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                    log.Info("Species Type  Animal Age Matrix already exists")
                    Exit Sub
                End If
            End If
        Catch ex As Exception
            log.Error("Species Type  Animal Age Matrix creation error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Private Sub btnSubmitAnimalAge_ServerClick(sender As Object, e As EventArgs) Handles btnSubmitAnimalAge.ServerClick
        Try
            log.Info("animal age creation begins")
            hdfAAValidationError.Value = True
            If String.IsNullOrWhiteSpace(txtAAstrDefault.Text) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                log.Info("animal age creation failed: English Value is required")
                Exit Sub
            ElseIf String.IsNullOrWhiteSpace(txtAAstrName.Text) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                log.Info("animal age creation failed: Translated Value is required")
                Exit Sub
            Else
                Dim baseRefSetParams As AdminBaseReferenceSetParams = New AdminBaseReferenceSetParams()
                baseRefSetParams.idfsBaseReference = Nothing
                baseRefSetParams.idfsReferenceType = 19000005
                baseRefSetParams.strDefault = txtAAstrDefault.Text.Trim()
                baseRefSetParams.strName = txtAAstrName.Text.Trim()
                baseRefSetParams.blnSystem = False

                If Not String.IsNullOrEmpty(txtAAintOrder.Text.Trim()) Then
                    baseRefSetParams.intOrder = Convert.ToInt32(txtAAintOrder.Text)
                Else
                    baseRefSetParams.intOrder = 0
                End If

                baseRefSetParams.intHACode = 0

                Dim results As String = baseReferenceAPIClient.BaseReferneceSet(baseRefSetParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    RepopulateAADropdown()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    log.Info("Animal age creation complete")
                ElseIf results = "DOES EXIST" Then
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible.InnerText") & txtAAstrName.Text.Trim() & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                    log.Info("Animal age currently exists")
                End If
            End If
        Catch ex As Exception
            log.Error("Animal age creation error", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnSubmitSpeciesType_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitSpeciesType.ServerClick
        Try
            log.Info("Species Type Reference Create begins.")
            hdfSPValidationError.Value = True

            If (String.IsNullOrEmpty(txtSPstrDefault.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtSPstrName.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                Exit Sub
            Else
                Dim speciesTypeRefParams As RefSpeciesTypeReferenceSetParams = New RefSpeciesTypeReferenceSetParams()

                speciesTypeRefParams.idfsSpeciesType = Nothing
                speciesTypeRefParams.strDefault = txtSPstrDefault.Text.Trim()
                speciesTypeRefParams.strName = txtSPstrName.Text.Trim()
                speciesTypeRefParams.strCode = txtSPstrCode.Text.Trim()


                If (String.IsNullOrEmpty(txtSPintOrder.Text)) Then
                    speciesTypeRefParams.intOrder = 0
                Else
                    speciesTypeRefParams.intOrder = Convert.ToInt32(txtSPintOrder.Text)
                End If

                speciesTypeRefParams.intHaCode = Convert.ToInt32(ddlSPintHACode.SelectedValue)
                speciesTypeRefParams.languageId = language

                Dim results = speciesTypeAPIClient.RefSpeciesTypeSet(speciesTypeRefParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    RepopulateSPDropdown()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    log.Info("Species Type Reference Create complete.")
                Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible.InnerText") & txtAAstrName.Text.Trim() & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                    log.Info("Species Type currently exists")
                End If
            End If
        Catch ex As Exception
            log.Error("Species Type Reference Create error. ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

#End Region

#Region "add"

    Protected Sub btnAddSpeciesTypeAnimalAgeMatrix_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddSpeciesTypeAnimalAgeMatrix.Click, btnCancelNo.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSpeciesTypeAnimalAge');});", True)
        hdfSPAAValidationError.Value = True
    End Sub

    Protected Sub btnAddDisease_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddAnimalAge.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addAnimalAge');});", True)
        hdfAAValidationError.Value = True
    End Sub

    Protected Sub btnAddSampleType_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddSpeciesType.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSpeciesType');});", True)
        hdfSPValidationError.Value = True
    End Sub

#End Region

#Region "cancel"

    Protected Sub btnCancelSpeciesTypeAnimalAge_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelSpeciesTypeAnimalAge.ServerClick
        Try
            log.Info("Species Type Animal Age Matrix cancel begins")
            lbl_Cancel.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelModal');});", True)
            log.Info("Species Type Animal Age Matrix cancel complete")
        Catch ex As Exception
            log.Error("Species Type Animal Age Matrix delete anyway error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnCancelReference_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelSpeciesType.ServerClick, btnCancelAnimalAge.ServerClick
        lbl_Cancel_Reference.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelReference');});", True)
    End Sub

    Protected Sub btnCancelReferenceYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceYes.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSpeciesTypeAnimalAge');});", True)
    End Sub

    Protected Sub btnCancelReferenceNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick
        If hdfSPValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSpeciesType');});", True)
        ElseIf hdfAAValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addAnimalAge');});", True)
        End If
    End Sub

    Protected Sub btnCancelYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelYes.ServerClick
        log.Info("Clearing Species Type Animal Age Matrix info begins")
        clearSPAAForm()
        log.Info("Clearing Species Type Animal Age Matrix info complete")
    End Sub

    Protected Sub btnCancelNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelNo.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSpeciesTypeAnimalAge');});", True)
    End Sub
#End Region

#Region "ok"
    Protected Sub btnSuccessOK_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSuccessOK.ServerClick
        If hdfAAValidationError.Value = True Or hdfSPValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSpeciesTypeAnimalAge');});", True)
            clearAAForm()
            clearSPForm()
        ElseIf hdfSPAAValidationError.Value = True Then
            clearSPAAForm()
        End If
    End Sub

    Protected Sub btnErrorOK_ServerClic(ByVal sender As Object, ByVal e As EventArgs) Handles btnErrorOK.ServerClick
        If hdfSPValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSpeciesType');});", True)
        ElseIf hdfAAValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addAnimalAge');});", True)
        ElseIf hdfSPAAValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSpeciesTypeAnimalAge');});", True)
        End If
    End Sub
#End Region

#Region "correct"
    Protected Sub btnContinueRequiredYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnContinueRequiredYes.ServerClick, btnAlreadyExistsYes.ServerClick
        If hdfAAValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addAnimalAge');});", True)
        ElseIf hdfSPValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSpeciesType');});", True)
        ElseIf hdfSPAAValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSpeciesTypeAnimalAge');});", True)
        End If
    End Sub

    Protected Sub btnContinueRequiredNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick, btnAlreadyExistsNo.ServerClick
        If hdfAAValidationError.Value Then
            clearAAForm()
        ElseIf hdfSPValidationError.Value Then
            clearSPForm()
        ElseIf hdfSPAAValidationError.Value Then
            clearSPAAForm()
        End If
    End Sub
#End Region

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Species Type - Animal Age Matrix delete anyway begins")
            Dim SPAAId = Convert.ToInt64(hdfSPAAidfSpeciesTypeForAnimalAge.Value)
            Dim returnMessage As String = speciesTypeAnimalAgeAPIClient.DelConfSpeciesTypeAnimalAgeMatrix(SPAAId, True).Result(0).returnMessage
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("Species Type - Animal Age Matrix delete anyway complete")
        Catch ex As Exception
            log.Error("Species Type - Animal Age Matrix delete anyway error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "grid view"
    Protected Sub gvSpeciesTypeAnimalAgeMatrix_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvSpeciesTypeAnimalAgeMatrix.PageIndexChanging
        Try
            log.Info("Species Type Animal Age pagination begin")
            gvSpeciesTypeAnimalAgeMatrix.PageIndex = e.NewPageIndex

            If IsNothing(ViewState("SPAA")) Then
                PopulateGrid()
            Else
                gvSpeciesTypeAnimalAgeMatrix.DataSource = ViewState("SPAA")
                gvSpeciesTypeAnimalAgeMatrix.DataBind()
            End If
            log.Info("Species Type Animal Age pagination complete")
        Catch ex As Exception
            log.Error("Species Type Animal Age record pagination error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub gvSpeciesTypeAnimalAgeMatrix_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvSpeciesTypeAnimalAgeMatrix.RowDataBound
        Dim gvr As GridViewRow = e.Row

        If gvr.RowType = DataControlRowType.DataRow Then
            Dim ddlAnimalAge As DropDownList = gvr.FindControl("ddlAnimalAge")
            If Not IsNothing(ddlAnimalAge) Then
                If IsNothing(ViewState("AnimalAge")) Then
                    ViewState("AnimalAge") = crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.AnimalAge, HACodeList.AllHACode).Result
                End If
                bindDropdown(ddlidfsAnimalAge, ViewState("AnimalAge"), "name", "idfsBaseReference", True, GetLocalResourceObject("lbl_Select_An_Animal_Age.InnerText"))
                ddlAnimalAge.SelectedValue = gvSpeciesTypeAnimalAgeMatrix.DataKeys(gvr.RowIndex)(2)
            End If
            Dim ddlSpeciesType As DropDownList = gvr.FindControl("ddlSpeciesType")
            If Not IsNothing(ddlSpeciesType) Then
                If IsNothing(ViewState("SpeciesType")) Then
                    ViewState("SpeciesType") = crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.SpeciesList, HACodeList.AllHACode).Result
                End If
                bindDropdown(ddlSpeciesType, ViewState("SpeciesType"), "name", "idfsBaseReference", True, GetLocalResourceObject("lbl_Select_A_Species_Type.InnerText"))
                ddlSpeciesType.SelectedValue = gvSpeciesTypeAnimalAgeMatrix.DataKeys(gvr.RowIndex)(1)
            End If
        End If
    End Sub

    Private Sub gvSpeciesTypeAnimalAgeMatrix_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvSpeciesTypeAnimalAgeMatrix.RowDeleting
        Try
            log.Info("Species Type Animal Age delete information gathering begins")
            Dim id As Int64 = Convert.ToInt64(gvSpeciesTypeAnimalAgeMatrix.DataKeys(e.RowIndex)(0))
            hdfSPAAidfSpeciesTypeForAnimalAge.Value = id

            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Question_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
            log.Info("Species Type Animal Age delete information gathering complete")
        Catch ex As Exception
            log.Error("Species Type Animal Age delete information gathering error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "private"

#Region "populate"
    Private Sub PopulateGrid()
        Dim specieTypeAnimalAges As List(Of ConfSpeciestypeanimalagematrixGetlistModel) = speciesTypeAnimalAgeAPIClient.GetConfSpeciestypeanimalagematrices(language).Result
        gvSpeciesTypeAnimalAgeMatrix.DataSource = specieTypeAnimalAges
        gvSpeciesTypeAnimalAgeMatrix.DataBind()
        'ViewState("SPAA") = specieTypeAnimalAges
    End Sub

    Private Sub populationDropdowns()
        bindDropdown(ddlidfsSpeciesType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.SpeciesList, HACodeList.LiveStockAndAvian).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlidfsAnimalAge, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.AnimalAge, HACodeList.LiveStockAndAvian).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlSPintHACode, globalAPIClient.GetHaCodes(GetCurrentLanguage(), HACodeList.LiveStockAndAvian).Result, "CodeName", "intHACode", True, String.Empty)
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
    Private Sub RepopulateSPDropdown()
        ddlidfsSpeciesType.Items.Clear()
        bindDropdown(ddlidfsSpeciesType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.SpeciesList, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsSpeciesType.Items.FindByText(txtSPstrName.Text).Selected = True
    End Sub

    Private Sub RepopulateAADropdown()
        ddlidfsAnimalAge.Items.Clear()
        bindDropdown(ddlidfsAnimalAge, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.AnimalAge, HACodeList.AllHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsAnimalAge.Items.FindByText(txtAAstrName.Text).Selected = True
    End Sub
#End Region

#End Region

#Region "clear"
    Private Sub clearSPForm()
        hdfSPValidationError.Value = False
        txtSPstrName.Text = String.Empty
        txtSPstrDefault.Text = String.Empty
        txtSPintOrder.Text = String.Empty
        ddlSPintHACode.SelectedIndex = -1
    End Sub

    Private Sub clearSPAAForm()
        hdfSPAAidfSpeciesTypeForAnimalAge.Value = "NULL"
        hdfSPAAValidationError.Value = False
        ddlidfsSpeciesType.SelectedIndex = -1
        ddlidfsAnimalAge.SelectedIndex = -1
    End Sub

    Private Sub clearAAForm()
        hdfAAValidationError.Value = False
        txtAAstrDefault.Text = String.Empty
        txtAAstrName.Text = String.Empty
        txtAAintOrder.Text = String.Empty
    End Sub
#End Region

#End Region
End Class