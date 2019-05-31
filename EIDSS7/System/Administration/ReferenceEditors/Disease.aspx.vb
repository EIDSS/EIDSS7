Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports EIDSS.Client.API_Clients
Imports Newtonsoft.Json
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class Disease
    Inherits BaseEidssPage

    Private ReadOnly diagnosisAPIClient As DiagnosisServiceClient
    Private ReadOnly crossCuttingAPIClient As CrossCuttingServiceClient
    Private ReadOnly globalAPIClient As GlobalServiceClient
    Private language As String
    Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(Disease))
    Private gridViewSortDirection As SortDirection

    Sub New()
        diagnosisAPIClient = New DiagnosisServiceClient()
        crossCuttingAPIClient = New CrossCuttingServiceClient()
        globalAPIClient = New GlobalServiceClient()
        language = GetCurrentLanguage()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not Page.IsPostBack Then
                log.Info("Disease Reference Editor Page Load begins")
                LoadDropdowns()
                PopulateGrid()
                log.Info("Disease Reference Editor Page Load complete")
            End If
        Catch ex As Exception
            log.Error("Disease Reference Editor Page Load Error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Create.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

#Region "buttons"


    Protected Sub btnSaveDiagnosis_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSaveDiagnosis.ServerClick
        Try
            log.Info("Disease Reference creation begins")
            hdfCDValidationError.Value = True

            If (String.IsNullOrEmpty(txtCDstrDefault.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtCDstrName.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
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
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Select_Accessory_Code.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
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

                    If lstCDPensideTest.SelectedIndex <> 0 Then
                        Dim pensideTests As String = Nothing
                        For Each li As ListItem In lstCDPensideTest.Items
                            If li.Selected Then
                                pensideTests = pensideTests & li.Value & ","
                            End If
                        Next

                        If Not IsNothing(pensideTests) Then
                            diagnosisParams.strPensideTest = pensideTests.Substring(0, pensideTests.Length - 1)
                        End If
                    End If

                    If lstCDSampleType.SelectedIndex <> 0 Then
                        Dim sampleTypes As String = Nothing
                        For Each li As ListItem In lstCDSampleType.Items
                            If li.Selected Then
                                sampleTypes = sampleTypes & li.Value & ","
                            End If
                        Next

                        If Not IsNothing(sampleTypes) > 0 Then
                            diagnosisParams.strSampleType = sampleTypes.Substring(0, sampleTypes.Length - 1)
                        End If
                    End If

                    If lstCDLabTest.SelectedIndex <> 0 Then
                        Dim labTest As String = Nothing
                        For Each li As ListItem In lstCDLabTest.Items
                            If li.Selected Then
                                labTest = labTest & li.Value & ","
                            End If
                        Next

                        If Not IsNothing(labTest) > 0 Then
                            diagnosisParams.strLabTest = labTest.Substring(0, labTest.Length - 1)
                        End If
                    End If

                    Dim results As String = diagnosisAPIClient.RefDiagnosisreferenceSet(diagnosisParams).Result(0).ReturnMessage

                    If results <> "DOES EXIST" Then
                        PopulateGrid()
                        lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Disease.InnerText") & " " & txtCDstrName.Text & GetLocalResourceObject("lbl_Period.InnerText")
                        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                        clearCDForm()
                        log.Info("Disease Reference creation complete")
                    Else
                        lbl_Error.InnerText = GetLocalResourceObject("lbl_The_Disease.InnerText") & " " & txtCDstrName.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
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

    Protected Sub btnAddReference_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddReference.Click
        log.Info("Diagnosis reference modal creator upload begins")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        log.Info("Diagnosis reference modal creator upload complete")
    End Sub

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Diagnosis reference deletion begins")
            Dim id As Int64 = Convert.ToInt64(hdfCDidfsDiagnosis.Value)
            Dim returnMsg As String = diagnosisAPIClient.RefDiagnosisreferenceDel(id, False).Result(0).ReturnMessage

            If returnMsg = "IN USE" Then
                lbl_Delete_Anyway.InnerText = GetLocalResourceObject("lbl_The_Disease.InnerText") & " " & hdfCDstrName.Value & " " & GetLocalResourceObject("lbl_In_Use.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('currentlyInUseModal');});", True)
            Else
                PopulateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Disease.InnerText") & " " & hdfCDstrName.Value & GetLocalResourceObject("lbl_Period.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            End If
            log.Info("Diagnosis reference deletion complete")
        Catch ex As Exception
            log.Error("Diagnosis reference deletion error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnDeleteAnywayYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteAnywayYes.ServerClick
        Try
            log.Info("Diagnosis reference delete anyway begins")
            Dim id As Double = Convert.ToInt64(hdfCDidfsDiagnosis.Value)
            diagnosisAPIClient.RefDiagnosisreferenceDel(id, True)
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Disease.InnerText") & " " & hdfCDstrName.Value
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("Diagnosis reference delete anyway complete")
        Catch ex As Exception
            log.Error("Diagnosis reference delete anyway error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnCancelAdd_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelAdd.ServerClick
        clearCDForm()
    End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        If hdfCDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addDisease');});", True)
        End If
    End Sub
#End Region

#Region "grid view"
    Protected Sub gvDisease_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvDiseases.PageIndexChanging
        Try
            log.Info("Diagnosis reference page index begins")
            gvDiseases.PageIndex = e.NewPageIndex
            PopulateGrid()
            log.Info("Diagnosis reference page index complete")
        Catch ex As Exception
            log.Error("Diagnosis reference page index error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub gvDiseases_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvDiseases.Sorting
        Try
            log.Info("Diagnosis reference sorting begins")
            sorting(e.SortExpression, e.SortDirection)
            log.Info("Diagnosis reference sorting complete")
        Catch ex As Exception
            log.Error("Diagnosis reference sorting error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Sorting.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvDiseases_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvDiseases.RowCancelingEdit
        Try
            log.Info("Diagnosis reference return to regular mode begins")
            gvDiseases.EditIndex = -1
            PopulateGrid()
            log.Info("Diagnosis reference return to regular mode complete")
        Catch ex As Exception
            log.Error("Diagnosis reference return to regular mode error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Cancel_Edit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvDiseases_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvDiseases.RowEditing
        Try
            log.Info("Diagnosis reference convert to edit mode begins")
            gvDiseases.EditIndex = e.NewEditIndex
            PopulateGrid()
            log.Info("Diagnosis reference convert to edit mode complete")
        Catch ex As Exception
            log.Error("Diagnosis reference convert to edit mode error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Edit_Mode_Error.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvDiseases_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvDiseases.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then

            Dim lstHACode As ListBox = e.Row.FindControl("lstHACode")
            If Not (lstHACode Is Nothing) Then
                BindListBox(lstHACode, globalAPIClient.GetHaCodes(language, HACodeList.AllHACode).Result, "intHACode", "CodeName", False)
                If (e.Row.RowIndex >= 0) Then
                    Dim sHACode As String = gvDiseases.DataKeys(e.Row.RowIndex).Values("strHACode").ToString()
                    If Not IsNothing(sHACode) Then
                        Dim aHACodeList = sHACode.Split(",")
                        For Each itm In aHACodeList
                            lstHACode.Items.FindByValue(itm).Selected = True
                        Next
                    End If
                End If
            End If

            Dim lstSampleType As ListBox = e.Row.FindControl("lstSampleType")
            If Not (lstSampleType Is Nothing) Then
                BindListBox(lstSampleType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.SampleType, HACodeList.AllHACode).Result, "idfsBaseReference", "name", True, GetLocalResourceObject("lbl_No_Samples_Available.InnerText"))
                If (e.Row.RowIndex >= 0) Then
                    Dim sSampleType As String = gvDiseases.DataKeys(e.Row.RowIndex).Values("strSampleType")
                    If Not IsNothing(sSampleType) Then
                        Dim sSampleTypeList As String() = sSampleType.Split(",")
                        For Each itm As String In sSampleTypeList
                            lstSampleType.Items.FindByValue(itm).Selected = True
                        Next
                    End If
                End If
            End If

            Dim lstLabTest As ListBox = e.Row.FindControl("lstLabTest")
            If Not (lstLabTest Is Nothing) Then
                BindListBox(lstLabTest, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.TestName, HACodeList.AllHACode).Result, "idfsBaseReference", "name", True, GetLocalResourceObject("lbl_No_Tests_Available.InnerText"))
                If (e.Row.RowIndex >= 0) Then
                    Dim sLabTest As String = gvDiseases.DataKeys(e.Row.RowIndex).Values("strLabTest")
                    If Not IsNothing(sLabTest) Then
                        Dim sLabTestList As String() = sLabTest.Split(",")
                        For Each itm As String In sLabTestList
                            lstLabTest.Items.FindByValue(itm).Selected = True
                        Next
                    End If
                End If
            End If

            Dim lstPensideTest As ListBox = e.Row.FindControl("lstPensideTest")
            If Not (lstPensideTest Is Nothing) Then
                BindListBox(lstPensideTest, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.PensideTestName, HACodeList.AllHACode).Result, "idfsBaseReference", "name", True, GetLocalResourceObject("lbl_No_Tests_Available.InnerText"))
                If (e.Row.RowIndex >= 0) Then
                    Dim sPensideTest As String = gvDiseases.DataKeys(e.Row.RowIndex).Values("strPensideTest")
                    If Not IsNothing(sPensideTest) Then
                        Dim sPensideTestList As String() = sPensideTest.Split(",")
                        For Each itm As String In sPensideTestList
                            lstPensideTest.Items.FindByValue(itm).Selected = True
                        Next
                    End If
                End If
            End If

            Dim ddlidfsUsingType As DropDownList = e.Row.FindControl("ddlidfsUsingType")
            If Not IsNothing(ddlidfsUsingType) Then
                BindDropdown(ddlidfsUsingType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.DiagnosisUsingType, HACodeList.AllHACode).Result, "idfsBaseReference", "name", False)
                ddlidfsUsingType.SelectedValue = gvDiseases.DataKeys(e.Row.RowIndex).Values("idfsUsingType").ToString()
            End If
        End If
    End Sub

    Private Sub gvDiseases_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvDiseases.RowUpdating
        Try
            log.Info("Diagnosis reference update begins")
            hdfCDValidationError.Value = False
            Dim gvr As GridViewRow = gvDiseases.Rows(e.RowIndex)
            Dim diagnosisParams As ReferenceDiagnosisSetParams = New ReferenceDiagnosisSetParams()

            diagnosisParams.langId = language
            diagnosisParams.idfsDiagnosis = Convert.ToInt64(gvDiseases.DataKeys(e.RowIndex).Values("idfsDiagnosis"))

            Dim txtstrDefault As TextBox = gvr.FindControl("txtstrDefault")
            If Not IsNothing(txtstrDefault) Then
                If String.IsNullOrEmpty(txtstrDefault.Text) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    Exit Sub
                Else
                    diagnosisParams.strDefault = txtstrDefault.Text
                End If
            End If

            Dim txtstrName As TextBox = gvr.FindControl("txtstrName")
            If Not IsNothing(txtstrName) Then
                If String.IsNullOrEmpty(txtstrName.Text) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Name_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    Exit Sub
                Else
                    diagnosisParams.strName = txtstrName.Text
                End If
            End If

            Dim txtintOrder As EIDSSControlLibrary.NumericSpinner = gvr.FindControl("txtOrder")
            If Not IsNothing(txtintOrder) Then
                If String.IsNullOrEmpty(txtintOrder.Text) Then
                    diagnosisParams.intOrder = 0
                Else
                    diagnosisParams.intOrder = Convert.ToInt32(txtintOrder.Text)
                End If
            End If

            Dim lstHACode As ListBox = gvr.FindControl("lstHACode")
            If Not IsNothing(lstHACode) Then
                Dim HaCode As Integer = 0
                For Each li As ListItem In lstHACode.Items
                    If li.Selected Then
                        HaCode = HaCode + Convert.ToInt16(li.Value)
                    End If
                Next
                diagnosisParams.intHaCode = HaCode
            Else
                diagnosisParams.intHaCode = 0
            End If

            Dim txtstrOIECode As TextBox = gvr.FindControl("txtstrOIECode")
            If Not IsNothing(txtstrOIECode) Then
                If Not String.IsNullOrEmpty(txtstrOIECode.Text) Then
                    diagnosisParams.strOieCode = txtstrOIECode.Text
                End If
            End If

            Dim txtstrIDC10 As TextBox = gvr.FindControl("txtstrIDC10")
            If Not IsNothing(txtstrIDC10) Then
                If Not String.IsNullOrEmpty(txtstrIDC10.Text) Then
                    diagnosisParams.strIdc10 = txtstrIDC10.Text
                End If
            End If

            Dim ddlidfsUsingType As DropDownList = gvr.FindControl("ddlidfsUsingType")
            If Not IsNothing(ddlidfsUsingType) Then
                diagnosisParams.idfsUsingType = Convert.ToInt64(ddlidfsUsingType.SelectedValue)
            End If

            Dim chkblnZoonotic As CheckBox = gvr.FindControl("chkblnZoonotic")
            If Not IsNothing(chkblnZoonotic) Then
                diagnosisParams.blnZoonotic = chkblnZoonotic.Checked
            End If

            Dim chkblnSyndrome As CheckBox = gvr.FindControl("chkblnSyndrome")
            If Not IsNothing(chkblnSyndrome) Then
                diagnosisParams.blnSyndrome = chkblnSyndrome.Checked
            End If

            Dim lstPensideTest As ListBox = gvDiseases.Rows(e.RowIndex).FindControl("lstPensideTest")
            If Not IsNothing(lstPensideTest) Then
                If lstPensideTest.SelectedIndex <> 0 Then
                    Dim pensideTests As String = Nothing
                    For Each li As ListItem In lstPensideTest.Items
                        If li.Selected Then
                            pensideTests = pensideTests & li.Value & ","
                        End If
                    Next

                    If Not IsNothing(pensideTests) Then
                        diagnosisParams.strPensideTest = pensideTests.Substring(0, pensideTests.Length - 1)
                    End If
                End If
            End If

            Dim lstSampleType As ListBox = gvDiseases.Rows(e.RowIndex).FindControl("lstSampleType")
            If Not IsNothing(lstSampleType) Then
                If lstSampleType.SelectedIndex <> 0 Then
                    Dim sampleTypes As String = Nothing
                    For Each li As ListItem In lstSampleType.Items
                        If li.Selected Then
                            sampleTypes = sampleTypes & li.Value & ","
                        End If
                    Next

                    If Not IsNothing(sampleTypes) Then
                        diagnosisParams.strSampleType = sampleTypes.Substring(0, sampleTypes.Length - 1)
                    End If
                End If
            End If

            Dim lstLabTest As ListBox = gvDiseases.Rows(e.RowIndex).FindControl("lstLabTest")
            If Not IsNothing(lstLabTest) Then
                If lstLabTest.SelectedIndex <> 0 Then
                    Dim labTest As String = Nothing
                    For Each li As ListItem In lstLabTest.Items
                        If li.Selected Then
                            labTest = labTest & li.Value & ","
                        End If
                    Next

                    If Not IsNothing(labTest) Then
                        diagnosisParams.strLabTest = labTest.Substring(0, labTest.Length - 1)
                    End If
                End If
            End If

            Dim results As String = diagnosisAPIClient.RefDiagnosisreferenceSet(diagnosisParams).Result(0).ReturnMessage

            If results = "SUCCESS" Then
                gvDiseases.EditIndex = -1
                PopulateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Disease.InnerText") & " " & txtstrName.Text & GetLocalResourceObject("lbl_Period.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                hdfCDValidationError.Value = False
            Else
                lbl_Error.InnerText = GetLocalResourceObject("lbl_The_Disease.InnerText") & " " & txtstrName.Text & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                log.Info("Disease Reference already exists")
            End If
            log.Info("Diagnosis reference update complete")
        Catch ex As Exception
            log.Error("Diagnosis reference update error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Save.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvDiseases_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvDiseases.RowDeleting
        Try
            log.Info("Diagnosis reference delete information gathering begins")
            hdfCDidfsDiagnosis.Value = Convert.ToInt64(gvDiseases.DataKeys(e.RowIndex)("idfsDiagnosis"))

            Dim lblstrName As Label = gvDiseases.Rows(e.RowIndex).FindControl("lblstrName")
            If Not IsNothing(lblstrName) Then
                hdfCDstrName.Value = lblstrName.Text
            End If

            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Disease_Question_Delete.InnerText") & " " & hdfCDstrName.Value & GetLocalResourceObject("lbl_Question_Mark.InnerText") & " " & GetLocalResourceObject("lbl_Cannot_Be_Undone.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
            log.Info("Diagnosis reference delete information gathering complete")
        Catch ex As Exception
            log.Error("Diagnosis reference delete information gathering error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

#End Region

    Private Sub PopulateGrid()

        Dim diseaseList As List(Of RefDiagnosisreferenceGetListModel) = diagnosisAPIClient.RefDiagnosisreferenceGetList(language).Result
        gvDiseases.DataSource = diseaseList
        gvDiseases.DataBind()
    End Sub

    Private Sub LoadDropdowns()
        BindListBox(lstCDHACode, globalAPIClient.GetHaCodes(language, HACodeList.AllHACode).Result.ToList, "intHACode", "CodeName", False)
        BindListBox(lstCDPensideTest, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.PensideTestName, HACodeList.AllHACode).Result.ToList, "idfsBaseReference", "name", True, GetLocalResourceObject("lbl_No_Penside_Test_Available.InnerText"))
        BindListBox(lstCDLabTest, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.TestName, HACodeList.AllHACode).Result.ToList, "idfsBaseReference", "name", True, GetLocalResourceObject("lbl_No_Tests_Available.InnerText"))
        BindListBox(lstCDSampleType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.SampleType, HACodeList.AllHACode).Result.ToList, "idfsBaseReference", "name", True, GetLocalResourceObject("lbl_No_Samples_Available.InnerText"))
        BindDropdown(ddlCDidfsUsingType, crossCuttingAPIClient.GetBaseReferenceList(language, BaseReferenceConstants.DiagnosisUsingType, HACodeList.AllHACode).Result.ToList, "idfsBaseReference", "name", False)
    End Sub

    Private Sub sorting(expression As String, direction As SortDirection)
        Dim sortExpression As String = expression

        If ViewState("SortField") = expression Then
            If ViewState("SortDirection") = SortDirection.Ascending Then
                orderGrid(sortExpression, SortDirection.Descending, False)
                ViewState("SortDirection") = SortDirection.Descending
            Else
                orderGrid(sortExpression, SortDirection.Ascending, False)
                ViewState("SortDirection") = SortDirection.Ascending
            End If
        Else
            orderGrid(sortExpression, direction, True)
            ViewState("SortDirection") = SortDirection.Ascending
        End If

        ViewState("SortField") = sortExpression
    End Sub

    Private Sub orderGrid(sortField As String, sortDirection As SortDirection, sortFieldChanged As Boolean)
        Dim ds As List(Of RefDiagnosisreferenceGetListModel) = diagnosisAPIClient.RefDiagnosisreferenceGetList(language).Result
        If sortDirection = SortDirection.Ascending Then
            If sortField = "strDefault" Then
                gvDiseases.DataSource = (From d In ds
                                         Order By d.strDefault).ToList()
            ElseIf sortField = "strName" Then
                gvDiseases.DataSource = (From d In ds
                                         Order By d.strName).ToList()
            ElseIf sortField = "intOrder" Then
                gvDiseases.DataSource = (From d In ds
                                         Order By d.intOrder).ToList()
            End If
        Else
            If sortField = "strDefault" Then
                gvDiseases.DataSource = (From d In ds
                                         Order By d.strDefault Descending).ToList()
            ElseIf sortField = "strName" Then
                gvDiseases.DataSource = (From d In ds
                                         Order By d.strName Descending).ToList()
            ElseIf sortField = "intOrder" Then
                gvDiseases.DataSource = (From d In ds
                                         Order By d.intOrder Descending).ToList()
            End If
        End If

        If sortFieldChanged Then
            gvDiseases.PageIndex = 0
        End If
        gvDiseases.DataBind()
    End Sub

    Private Sub clearCDForm()
        hdfCDidfsDiagnosis.Value = "NULL"
        hdfCDstrName.Value = "NULL"
        hdfCDValidationError.Value = False
        txtCDstrName.Text = String.Empty
        txtCDstrDefault.Text = String.Empty
        txtCDintOrder.Text = String.Empty
        txtCDstrIDC10.Text = String.Empty
        txtCDstrOIECode.Text = String.Empty
        lstCDHACode.SelectedIndex = -1
        lstCDLabTest.SelectedIndex = -1
        lstCDSampleType.SelectedIndex = -1
        lstCDHACode.SelectedIndex = -1
        ddlCDidfsUsingType.SelectedIndex = -1
        chkCDblnSyndrome.Checked = False
        chkCDblnZoonotic.Checked = False
    End Sub

    Private Sub BindDropdown(ByRef ddl As DropDownList, ByVal dataList As Object, ByVal vf As String, ByVal tf As String, ByVal blankField As Boolean, Optional ByVal blankFieldText As String = "")
        If blankField Then
            Dim blankItem As ListItem = New ListItem(blankFieldText, "NULL")
            ddl.Items.Add(blankItem)
        End If
        ddl.DataSource = dataList
        ddl.DataTextField = tf
        ddl.DataValueField = vf
        ddl.DataBind()
    End Sub

    Private Sub BindListBox(ByRef lst As ListBox, ByVal dataList As Object, ByVal vf As String, ByVal tf As String, ByVal blankField As Boolean, Optional ByVal blankFieldText As String = "")
        If blankField Then
            Dim blankItem As ListItem = New ListItem(blankFieldText, "NULL")
            lst.Items.Add(blankItem)
        End If
        lst.DataSource = dataList
        lst.DataTextField = tf
        lst.DataValueField = vf
        lst.DataBind()
    End Sub

End Class