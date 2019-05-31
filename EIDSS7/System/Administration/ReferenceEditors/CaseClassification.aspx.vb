Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class CaseClassification
    Inherits BaseEidssPage

    Private ReadOnly crossCuttingAPIClient As CrossCuttingServiceClient
    Private ReadOnly caseClassAPIClient As CaseClassificationServiceClient
    Private ReadOnly baseReferenceLookupClient As BaseReferenceClient
    Private ReadOnly globalAPIClient As GlobalServiceClient
    Private language As String
    Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(CaseClassification))
    Private gridViewSortDirection As SortDirection

    Sub New()
        caseClassAPIClient = New CaseClassificationServiceClient()
        crossCuttingAPIClient = New CrossCuttingServiceClient()
        baseReferenceLookupClient = New BaseReferenceClient()
        globalAPIClient = New GlobalServiceClient()
        language = GetCurrentLanguage()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            log.Info("Case Classification Reference Page Load begins.")
            If Not IsPostBack Then
                fillCCHACode()
                PopulateGrid()
            End If
            log.Info("Case Classification Reference Page Load complete.")
        Catch ex As Exception
            log.Error("Case Classification Reference Editor Page Load error: " & ex.Message)
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Error_Loading_Case_Classification_Page.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
        End Try
    End Sub


#Region "buttons"

    Protected Sub btnAddReference_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddReference.Click
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addCaseClass');});", True)
    End Sub

    Protected Sub btnSaveCaseClass_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSaveCaseClass.ServerClick
        Try
            log.Info("Case Classification reference creation begins.")
            hdfCCValidationError.Value = True

            If (String.IsNullOrEmpty(txtCCstrDefault.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtCCstrName.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                Exit Sub
            Else
                Dim ccParams As AdminCaseClassificationSetParams = New AdminCaseClassificationSetParams()

                ccParams.idfsCaseClassification = Nothing
                ccParams.languageId = GetCurrentLanguage()
                ccParams.strDefault = txtCCstrDefault.Text.Trim()
                ccParams.strName = txtCCstrName.Text.Trim()
                ccParams.blnFinalHumanCaseClassification = chkCCblnFinalHumanCaseClassification.Checked
                ccParams.blnInitialHumanCaseClassification = chkCCblnInitialHumanCaseClassification.Checked

                Dim HaCode As Integer = 0
                For Each li As ListItem In lstCCHACode.Items
                    If li.Selected Then
                        HaCode = HaCode + Convert.ToInt16(li.Value)
                    End If
                Next

                If HaCode = 0 Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Select_Accessory_Codes.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    Exit Sub
                Else
                    ccParams.intHaCode = HaCode
                End If


                If String.IsNullOrEmpty(txtCCintOrder.Text) Then
                    ccParams.intOrder = 0
                Else
                    ccParams.intOrder = txtCCintOrder.Text
                End If

                Dim results As String = caseClassAPIClient.CaseClassificationSet(ccParams).Result(0).ReturnMessage

                If results <> "DOES EXIST" Then
                    PopulateGrid()
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Successful_Case_Classification.InnerText") & " " & txtCCstrName.Text & GetLocalResourceObject("lbl_Period.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    clearCCForm()
                    log.Info("Case Classification reference creation complete.")
                Else
                    hdfCCValidationError.Value = True
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_The_Case_Classification.InnerText") & " " & txtCCstrName.Text.Trim() & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    log.Info("Case Classification reference already exists.")
                End If
            End If
        Catch ex As Exception
            log.Error("Case Classification reference creation error:", ex)
            hdfCCValidationError.Value = False
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Create.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnCancelCaseClass_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelCaseClass.ServerClick
        clearCCForm()
    End Sub

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Case Classification reference deletion begins.")
            Dim id As Int64 = Convert.ToInt64(hdfCCidfsCaseClassification.Value)
            Dim results As String = caseClassAPIClient.RefCaseClassificationDel(id, False).Result(0).ReturnMessage
            If results = "IN USE" Then
                lbl_Delete_Anyway.InnerText = GetLocalResourceObject("lbl_The_Case_Classification.InnerText") & " " & hdfCCstrName.Value & " " & GetLocalResourceObject("lbl_In_Use.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('currentlyInUseModal');});", True)
                Exit Sub
            Else
                PopulateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Case_Classification.InnerText") & " " & hdfCCstrName.Value
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                Exit Sub
            End If
        Catch ex As Exception
            log.Error("Case Classification reference deletion error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnDeleteAnywayYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteAnywayYes.ServerClick
        Try
            log.Info("Case Classification reference delete anyway begins.")
            Dim id As Int64 = Convert.ToInt64(hdfCCidfsCaseClassification.Value)
            caseClassAPIClient.RefCaseClassificationDel(id, True)
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Case_Classification.InnerText") & " " & hdfCCstrName.Value
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("Case Classification reference delete anyway complete.")
        Catch ex As Exception
            log.Error("Case Classification reference delete anyway error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        If hdfCCValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addCaseClass');});", True)
        End If
    End Sub
#End Region

#Region "grid view"
    Protected Sub gvCaseClass_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvCaseClass.PageIndexChanging
        Try
            log.Info("Case Classification reference records paging begins.")
            gvCaseClass.PageIndex = e.NewPageIndex
            PopulateGrid()
            log.Info("Case Classification reference records paging complete.")
        Catch ex As Exception
            log.Error("Case Classification reference records paging begins.", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub gvCaseClass_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvCaseClass.Sorting
        Try
            log.Info("Case Classification reference record sorting begins.")
            sorting(e.SortExpression, e.SortDirection)
            log.Info("Case Classification reference record sorting complete.")
        Catch ex As Exception
            log.Error("Case Classification reference record sorting error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Sorting.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvCaseClass_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvCaseClass.RowCancelingEdit
        Try
            log.Info("Case Classification reference record return to regular mode begins.")
            gvCaseClass.EditIndex = -1
            If Not IsNothing(ViewState("SortDirection")) And Not IsNothing(ViewState("SortField")) Then
                sorting(ViewState("SortField"), ViewState("SortDirection"))
            Else
                PopulateGrid()
            End If
            log.Info("Case Classification reference record return to regular mode complete.")
        Catch ex As Exception
            log.Error("Case Classification reference record return to regular mode error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel_Edit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvCaseClass_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvCaseClass.RowEditing
        Try
            log.Info("Case Classification reference record converting to edit mode begins.")
            gvCaseClass.EditIndex = e.NewEditIndex
            PopulateGrid()
            log.Info("Case Classification reference record convert to edit mode complete.")
        Catch ex As Exception
            log.Error("Error convert to edit mode Case Classification Reference Editor records: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Edit_Mode.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
            Exit Sub
        End Try
    End Sub

    Private Sub gvCaseClass_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvCaseClass.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then

            Dim lvCtrl As ListBox = e.Row.FindControl("lstHACode")

            If Not (lvCtrl Is Nothing) Then

                lvCtrl.DataSource = globalAPIClient.GetHaCodes(language, 98).Result
                lvCtrl.DataTextField = "CodeName"
                lvCtrl.DataValueField = "intHACode"
                lvCtrl.DataBind()

                'Select the HACode in List
                If (e.Row.RowIndex >= 0) Then
                    Dim sHACode As String = gvCaseClass.DataKeys(e.Row.RowIndex).Values("strHACode").ToString()
                    If Not String.IsNullOrEmpty(sHACode) Then
                        Dim aHACodeList = sHACode.Split(",")
                        For Each itm In aHACodeList
                            lvCtrl.Items.FindByValue(itm).Selected = True
                        Next
                    End If
                End If
            End If
        End If

    End Sub

    Private Sub gvCaseClass_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvCaseClass.RowUpdating
        Try
            log.Info("Case Classification reference record update begins.")
            hdfCCValidationError.Value = False
            Dim gvr As GridViewRow = gvCaseClass.Rows(e.RowIndex)
            Dim caseClassSetParams As AdminCaseClassificationSetParams = New AdminCaseClassificationSetParams()
            caseClassSetParams.languageId = language
            caseClassSetParams.idfsCaseClassification = Convert.ToInt64(gvCaseClass.DataKeys(e.RowIndex).Values(0))

            Dim idfsReferenceType As Double = gvCaseClass.DataKeys(e.RowIndex).Values(1)

            Dim txtstrDefault As TextBox = gvr.FindControl("txtstrDefault")
            If Not IsNothing(txtstrDefault) Then
                If String.IsNullOrEmpty(txtstrDefault.Text.Trim()) Then
                    hdfCCValidationError.Value = False
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    Exit Sub
                Else
                    caseClassSetParams.strDefault = txtstrDefault.Text.Trim()
                End If
            End If

            Dim txtstrName As TextBox = gvr.FindControl("txtstrName")
            If Not IsNothing(txtstrName) Then
                If String.IsNullOrEmpty(txtstrName.Text.Trim()) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    Exit Sub
                Else
                    caseClassSetParams.strName = txtstrName.Text.Trim()
                End If
            End If

            Dim txtintOrder As EIDSSControlLibrary.NumericSpinner = gvr.FindControl("txtOrder")
            If Not IsNothing(txtintOrder) Then
                If String.IsNullOrEmpty(txtintOrder.Text) Then
                    caseClassSetParams.intOrder = 0
                Else
                    caseClassSetParams.intOrder = Convert.ToInt32(txtintOrder.Text)
                End If
            End If

            Dim lstRowHACode As ListBox = gvr.FindControl("lstHACode")
            If Not IsNothing(lstRowHACode) Then
                Dim HaCode As Integer = 0
                For Each li As ListItem In lstRowHACode.Items
                    If li.Selected Then
                        HaCode = HaCode + Convert.ToInt16(li.Value)
                    End If
                Next
                If HaCode = 0 Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Select_Accessory_Codes.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    Exit Sub
                Else
                    caseClassSetParams.intHaCode = HaCode
                End If
            Else
                caseClassSetParams.intHaCode = 2
            End If

            Dim chkblnInitialHumanCaseClassification As CheckBox = gvr.FindControl("chkblnInitialHumanCaseClassification")
            If Not IsNothing(chkblnInitialHumanCaseClassification) Then
                caseClassSetParams.blnInitialHumanCaseClassification = chkblnInitialHumanCaseClassification.Checked
            Else
                caseClassSetParams.blnInitialHumanCaseClassification = False
            End If

            Dim chkblnFinalHumanCaseClassification As CheckBox = gvr.FindControl("chkblnFinalHumanCaseClassification")
            If Not IsNothing(chkblnFinalHumanCaseClassification) Then
                caseClassSetParams.blnFinalHumanCaseClassification = chkblnFinalHumanCaseClassification.Checked
            Else
                caseClassSetParams.blnFinalHumanCaseClassification = False
            End If

            Dim results As String = caseClassAPIClient.CaseClassificationSet(caseClassSetParams).Result(0).ReturnMessage

            If results = "SUCCESS" Then
                gvCaseClass.EditIndex = -1
                PopulateGrid()
                clearCCForm()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Case_Classification.InnerText") & " " & txtstrName.Text & GetLocalResourceObject("lbl_Period.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            ElseIf results = "DOES EXIST" Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_The_Case_Classification.InnerText") & " " & txtstrName.Text.Trim() & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                log.Info("Case Classification reference already exists.")
            End If
            log.Info("Case Classification Reference Editor record update complete.")
        Catch ex As Exception
            log.Error("Case Classification Reference Editor record update error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Save.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvCaseClass_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvCaseClass.RowDeleting
        Try
            log.Info("Case Classification Reference Editor delete information gathering begins.")
            Dim id As Double = gvCaseClass.DataKeys(e.RowIndex)("idfsCaseClassification")
            hdfCCidfsCaseClassification.Value = id
            Dim gvr As GridViewRow = gvCaseClass.Rows(e.RowIndex)
            Dim lblstrName As Label = gvr.FindControl("lblstrName")
            If Not IsNothing(lblstrName) Then
                hdfCCstrName.Value = lblstrName.Text
            End If
            log.Info("Case Classification Reference Editor delete information gathering complete.")
            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Case_Classification_Question_Delete.InnerText") & " " & hdfCCstrName.Value & " " & GetLocalResourceObject("lbl_Cannot_Be_Undone.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
        Catch ex As Exception
            log.Error("Error gathering Case Classification Reference Editor delete information error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

#End Region

#Region "dropdown"

    Private Sub fillCCHACode()
        lstCCHACode.DataSource = globalAPIClient.GetHaCodes(language, 98).Result
        lstCCHACode.DataTextField = "CodeName"
        lstCCHACode.DataValueField = "intHACode"
        lstCCHACode.DataBind()
    End Sub

#End Region

    Private Sub PopulateGrid()
        Dim caseClassRefList As List(Of RefCaseclassificationGetListModel) = caseClassAPIClient.GetRefCaseClassification(language).Result.ToList()
        gvCaseClass.DataSource = caseClassRefList
        gvCaseClass.DataBind()
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
        Dim ds As List(Of RefCaseclassificationGetListModel) = caseClassAPIClient.GetRefCaseClassification(language).Result.ToList()
        If sortDirection = SortDirection.Ascending Then
            If sortField = "strDefault" Then
                gvCaseClass.DataSource = (From d In ds
                                          Order By d.strDefault).ToList()
            ElseIf sortField = "strName" Then
                gvCaseClass.DataSource = (From d In ds
                                          Order By d.strName).ToList()
            ElseIf sortField = "intOrder" Then
                gvCaseClass.DataSource = (From d In ds
                                          Order By d.intOrder).ToList()
            End If
        Else
            If sortField = "strDefault" Then
                gvCaseClass.DataSource = (From d In ds
                                          Order By d.strDefault Descending).ToList()
            ElseIf sortField = "strName" Then
                gvCaseClass.DataSource = (From d In ds
                                          Order By d.strName Descending).ToList()
            ElseIf sortField = "intOrder" Then
                gvCaseClass.DataSource = (From d In ds
                                          Order By d.intOrder Descending).ToList()
            End If
        End If

        If sortFieldChanged Then
            gvCaseClass.PageIndex = 0
        End If
        gvCaseClass.DataBind()
    End Sub

    Private Sub clearCCForm()
        hdfCCstrName.Value = "NULL"
        hdfCCidfsCaseClassification.Value = "NULL"
        hdfCCValidationError.Value = False
        txtCCintOrder.Text = String.Empty
        txtCCstrDefault.Text = String.Empty
        txtCCstrName.Text = String.Empty
        lstCCHACode.SelectedIndex = -1
    End Sub

End Class