Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports System
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports log4net

Public Class VectorTypeCollectionMethodMatrix
	Inherits BaseEidssPage

	Private ReadOnly vectorTypeCollectionMethodAPIClient As VectorTypeCollectionMethodMatrixServiceClient
	Private ReadOnly crossCuttingAPIClient As CrossCuttingServiceClient
    Private ReadOnly globalClient As GlobalServiceClient
    Private ReadOnly vectorTypeAPIClient As VectorTypeServiceClient
    Private ReadOnly baseReferenceAPIClient As BaseReferenceClient
    Private language As String
    Private log As ILog = LogManager.GetLogger(GetType(VectorTypeCollectionMethodMatrix))

    Sub New()
		language = GetCurrentLanguage()
		vectorTypeCollectionMethodAPIClient = New VectorTypeCollectionMethodMatrixServiceClient()
        crossCuttingAPIClient = New CrossCuttingServiceClient()
        vectorTypeAPIClient = New VectorTypeServiceClient()
        baseReferenceAPIClient = New BaseReferenceClient()
    End Sub

	Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
		Try
			If Not IsPostBack() Then
				log.Info("VectorTypeCollectionMethodMatrix page load begins")
				populationDropdowns()
				PopulateGrid()
				log.Info("VectorTypeCollectionMethodMatrix page load complete")
			End If
		Catch ex As Exception
			log.Error("VectorTypeCollectionMethodMatrix page load error", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

	Private Sub ddlidfsVectorType_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsVectorType.SelectedIndexChanged
		Try
            log.Info("Load new collection methods after vector type change begins")
            populationDropdowns()
            PopulateGrid()
			log.Info("Load new collection methods after vector type change complete")
		Catch ex As Exception
			log.Error("Load new collection methods after vector type change error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

#Region "buttons"

#Region "submit"
    Protected Sub btnSubmitVectorTypeCollectionMethod_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitVectorTypeCollectionMethod.ServerClick
        Try
            log.Info("Vector Type - Collection Method Matrix creation begins")
            hdfVTCMValidationError.Value = True

            If (ddlidfsCollectionMethod.SelectedIndex < 1) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Collection_Method_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
                Exit Sub
            Else

                Dim vtcmParams As VectorTyeCollectionMatrixSetParams = New VectorTyeCollectionMatrixSetParams()

                vtcmParams.idfCollectionMethodForVectorType = Nothing
                vtcmParams.idfsVectorType = Convert.ToInt64(ddlidfsVectorType.SelectedValue)
                vtcmParams.idfsCollectionMethod = Convert.ToInt64(ddlidfsCollectionMethod.SelectedValue)

                Dim results As String = vectorTypeCollectionMethodAPIClient.SetConfVectorTypeCollectionMethodMatrix(vtcmParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    log.Info("Vector Type - Collection Method Matrix creation complete")
                Else
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Not_Possible.InnerText") & ddlidfsVectorType.SelectedItem.Text & GetLocalResourceObject("lbl_Dash.InnerText") & ddlidfsCollectionMethod.SelectedItem.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
                    log.Info("Vector Type - Collection Method Matrix exists")
                End If
            End If
        Catch ex As Exception
            log.Error("Vector Type - Collection Method Matrix creation error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

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
                    RepopulateVTDropdown()
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    log.Info("Vector Type reference creation complete.")
                Else
                    hdfVTValidationError.Value = True
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_Vector_Type.InnerText") & txtVTstrName.Text.Trim() & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                    log.Info("Vector Type reference already exists.")
                End If
            End If
        Catch ex As Exception
            log.Error("Vector Type reference creation error:", ex)
            hdfVTValidationError.Value = False
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Create.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnSubmitCollectionMethod_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmitCollectionMethod.ServerClick
        Try
            log.Info("Custom Report Type reference creation begins")
            hdfCMValidationError.Value = True

            If (String.IsNullOrEmpty(txtCMstrDefault.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                log.Info("Custom Report Type reference creation failed. English Value required.")
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtCMstrName.Text.Trim())) Then
                lbl_Continue_Required.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('continueRequired');});", True)
                log.Info("Custom Report Type reference creation failed. Translated Value required.")
                Exit Sub
            Else

                Dim baseRefParams As AdminBaseReferenceSetParams = New AdminBaseReferenceSetParams()
                baseRefParams.idfsBaseReference = Nothing
                baseRefParams.idfsReferenceType = 19000135
                baseRefParams.languageId = language
                baseRefParams.strDefault = txtCMstrDefault.Text.Trim()
                baseRefParams.strName = txtCMstrName.Text.Trim()
                baseRefParams.intHACode = 0

                If Not String.IsNullOrEmpty(txtCMintOrder.Text) Then
                    baseRefParams.intOrder = Convert.ToInt32(txtCMintOrder.Text)
                Else
                    baseRefParams.intOrder = 0
                End If

                Dim results As String = baseReferenceAPIClient.BaseReferneceSet(baseRefParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    RepopulateCMDropdown()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    log.Info("Collection method reference creation complete")
                Else
                    lbl_Already_Exists.InnerText = GetLocalResourceObject("lbl_Not_Possible_Collection_Method.InnerText") & txtCMstrDefault.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('alreadyExists');});", True)
                    log.Info("Collection method reference creation failed. Already existed.")
                End If
            End If
        Catch ex As Exception
            log.Error("ICD reference creation error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "add"

    Protected Sub btnAddVectorTypeCollectionMatrix_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddVectorTypeCollectionMatrix.Click, btnCancelNo.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorTypeCollectionMethod');});", True)
    End Sub

    Protected Sub btnAddVectorType_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddVectorType.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorType');});", True)
    End Sub

    Protected Sub btnAddCollectionMethod_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddCollectionMethod.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addCollectionMethod');});", True)
    End Sub

#End Region

#Region "ok"

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        log.Info("Vector Type - Collection Method Matrix delete anyway complete")
        If hdfVTCMValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorTypeCollectionMethod');});", True)
        End If
        log.Info("Vector Type - Collection Method Matrix delete anyway complete")
    End Sub

    Protected Sub btnSuccessOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSuccessOK.ServerClick
        If hdfCMValidationError.Value = True Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorTypeCollectionMethod');});", True)
            clearCMForm()
        ElseIf hdfVTValidationError.Value = True Then
            clearVTForm()
        ElseIf hdfVTCMValidationError.Value = True Then
            clearVTCMForm()
        End If
    End Sub

#End Region

#Region "cancel"

    Protected Sub btnCancelVectorTypeCollectionMethod_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelVectorTypeCollectionMethod.ServerClick
        Try
            log.Info("Vector Type - Collection Method Matrix cancel begins")
            lbl_Cancel.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelModal');});", True)
            log.Info("Vector Type - Collection Method Matrix cancel complete")
        Catch ex As Exception
            log.Error("Vector Type - Collection Method Matrix delete anyway error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Protected Sub btnCancelReference_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelVectorType.ServerClick, btnCancelCollectionMethod.ServerClick
        lbl_Cancel_Reference.InnerText = GetLocalResourceObject("lbl_Cancel.InnerText")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelReference');});", True)
    End Sub

    Protected Sub btnCancelReferenceYes_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceYes.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorTypeCollectionMethod');});", True)
    End Sub

    Protected Sub btnCancelReferenceNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelReferenceNo.ServerClick
        If hdfVTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorType');});", True)
        ElseIf hdfCMValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addCollectionMethod');});", True)
        End If
    End Sub

    Protected Sub btnCancelYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelYes.ServerClick
        log.Info("Report Disease Group Disease cancel begin")
        clearVTCMForm()
        log.Info("Report Disease Group Disease cancel complete")
    End Sub

    Protected Sub btnCancelNo_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelNo.ServerClick
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorTypeCollectionMethod');});", True)
    End Sub

#End Region

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Vector Type - Collection Method Matrix delete anyway begins")
            Dim vtcmId = Convert.ToInt64(hdfVTCMidfsCollectionMethodforVectorType.Value)
            Dim returnMessage As String = vectorTypeCollectionMethodAPIClient.DelConfVectorTypeCollectionMethodMatrix(vtcmId).Result(0).ReturnMessage
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("Vector Type - Collection Method Matrix delete anyway complete")
        Catch ex As Exception
            log.Error("Vector Type - Collection Method Matrix delete anyway error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Submit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

#End Region

#Region "grid view"
    Protected Sub gvVectorTypeCollectionMethod_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvVectorTypeCollectionMethod.PageIndexChanging
        Try
            log.Info("Vector Type - Collection Method Matrix pagination begin")
            gvVectorTypeCollectionMethod.PageIndex = e.NewPageIndex
            PopulateGrid()
            log.Info("Vector Type - Collection Method Matrix pagination complete")
        Catch ex As Exception
            log.Error("Vector Type - Collection Method Matrix record pagination error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
        End Try
    End Sub

    Private Sub gvVectorTypeCollectionMethod_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvVectorTypeCollectionMethod.RowDeleting
		Try
			log.Info("Vector Type - Collection Method Matrix delete information gathering begins")
			Dim id As Int64 = Convert.ToInt64(gvVectorTypeCollectionMethod.DataKeys(e.RowIndex)(0))
            hdfVTCMidfsCollectionMethodforVectorType.Value = id

            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Question_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
            log.Info("Vector Type - Collection Method Matrix delete information gathering complete")
		Catch ex As Exception
			log.Error("Vector Type - Collection Method Matrix delete information gathering error: " & ex.Message)
			lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
			ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorModal');});", True)
		End Try
	End Sub

#End Region

#Region "private"

#Region "populate"

    Private Sub PopulateGrid()
		Dim vectorTypeCollectionMethod As List(Of ConfVectortypecollectionmethodmatrixGetlistModel) = vectorTypeCollectionMethodAPIClient.GetConfVectorTypeCollectionMethodMatrices(language, Convert.ToInt64(ddlidfsVectorType.SelectedValue)).Result
		gvVectorTypeCollectionMethod.DataSource = vectorTypeCollectionMethod
		gvVectorTypeCollectionMethod.DataBind()
	End Sub

    Private Sub populationDropdowns()
        bindDropdown(ddlidfsVectorType, crossCuttingAPIClient.GetBaseReferenceList(language, "Vector Type", HACodeList.VectorHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        bindDropdown(ddlidfsCollectionMethod, crossCuttingAPIClient.GetBaseReferenceList(language, "Collection Method", HACodeList.VectorHACode).Result, "name", "idfsBaseReference", True, String.Empty)
    End Sub

    Private Sub bindDropdown(ByRef ddl As DropDownList, ByVal dl As Object, ByVal tf As String, ByVal vf As String, ByVal addBlank As Boolean, Optional ByVal blankText As String = "")
        If addBlank Then
            ddl.Items.Add(New ListItem(blankText, "NULL"))
        End If
        ddl.DataSource = dl
        ddl.DataTextField = tf
        ddl.DataValueField = vf
        ddl.DataBind()
    End Sub

#Region "repopulate"

    Private Sub RepopulateCMDropdown()
        ddlidfsCollectionMethod.Items.Clear()
        bindDropdown(ddlidfsCollectionMethod, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.Collectionmethod, HACodeList.VectorHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsCollectionMethod.Items.FindByText(txtCMstrName.Text).Selected = True
    End Sub

    Private Sub RepopulateVTDropdown()
        ddlidfsVectorType.Items.Clear()
        bindDropdown(ddlidfsVectorType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.VectorType, HACodeList.VectorHACode).Result, "name", "idfsBaseReference", True, String.Empty)
        ddlidfsVectorType.Items.FindByText(txtCMstrName.Text).Selected = True
    End Sub

#End Region

#End Region

#Region "clear"

    Private Sub clearVTCMForm()
        hdfVTCMidfsCollectionMethodforVectorType.Value = "NULL"
        hdfVTCMValidationError.Value = False
        ddlidfsCollectionMethod.SelectedIndex = -1
    End Sub

    Private Sub clearVTForm()
        hdfVTValidationError.Value = False
        txtVTstrName.Text = String.Empty
        txtVTstrDefault.Text = String.Empty
        txtVTintOrder.Text = String.Empty
        txtVTstrCode.Text = String.Empty
        chkVTbitCollectionByPool.Checked = False
    End Sub

    Private Sub clearCMForm()
        txtCMintOrder.Text = String.Empty
        txtCMstrDefault.Text = String.Empty
        txtCMstrName.Text = String.Empty
        hdfCMValidationError.Value = False
    End Sub

#End Region

#End Region
End Class