Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports log4net
Public Class SampleType
    Inherits BaseEidssPage

    Private ReadOnly sampleTypeAPIClient As SampleTypeServiceClient
    Private ReadOnly globalClient As GlobalServiceClient
    Private language As String
    Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(Dashboard))
    Private gridViewSortDirection As SortDirection

    Sub New()
        globalClient = New GlobalServiceClient()
        sampleTypeAPIClient = New SampleTypeServiceClient()
        language = GetCurrentLanguage()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            log.Info("Sample Type Reference Editor page load begins")
            If Not IsPostBack Then
                fillSTHACode()
                PopulateGrid()
            End If
            log.Info("Sample Type Reference Editor page load complete")
        Catch ex As Exception
            log.Error("Sample Type Reference Editor page: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading_Sample_Type_Page.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub


#Region "buttons"

    Protected Sub btnSampleType_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnAddSample.ServerClick
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
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Select_Accessory_Codes.InnerText")
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
                    PopulateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Sample_Type.InnerText") & " " & txtSTstrName.Text.Trim() & GetLocalResourceObject("lbl_Period.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    clearForm()
                Else
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_The_Sample_Type.InnerText") & " " & txtSTstrName.Text & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                End If
            End If
            log.Info("Sample Type reference creation complete")
        Catch ex As Exception
            log.Error("Sample Type reference creation error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Create.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnAddReference_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddReference.Click
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleType');});", True)
    End Sub


    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Sample Type reference delete anyway begins")
            Dim returnMessage As String = sampleTypeAPIClient.RefSampleTypeDel(Convert.ToInt64(hdfSTidfsSampleType.Value), False).Result(0).ReturnMessage
            If returnMessage = "DOES EXIST" Then
                lbl_Delete_Anyway.InnerText = GetLocalResourceObject("lbl_The_Sample_Type.InnerText") & " " & hdfSTstrName.Value & " " & GetLocalResourceObject("lbl_In_Use.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('currentlyInUseModal');});", True)
            Else
                PopulateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Sample_Type.InnerText") & " " & hdfSTstrName.Value & " " & GetLocalResourceObject("lbl_Period.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            End If
            log.Info("Sample Type reference delete anyway complete")
        Catch ex As Exception
            log.Error("Sample Type reference delete anyway error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete_Reference.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnDeleteAnywayYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteAnywayYes.ServerClick
        Try
            log.Info("Sample Type reference delete anyway begins")
            sampleTypeAPIClient.RefSampleTypeDel(Convert.ToInt64(hdfSTidfsSampleType.Value), True)
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Sample_Type.InnerText") & " " & hdfSTstrName.Value & " " & GetLocalResourceObject("lbl_Period.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("Sample Type reference delete anyway complete")
        Catch ex As Exception
            log.Error("Sample Type reference delete anyway error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete_Reference.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        log.Info("Sample Type reference delete anyway complete")
        If hdfSTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addSampleType');});", True)
        End If
        log.Info("Sample Type reference delete anyway complete")
    End Sub

    Protected Sub btnCancelSample_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelSample.ServerClick
        log.Info("Sample Type reference delete anyway complete")
        clearForm()
        log.Info("Sample Type reference delete anyway complete")
    End Sub
#End Region

#Region "grid view"
    Protected Sub grvSampleType_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles grvSampleType.PageIndexChanging
        Try
            log.Info("Sample Type reference pagination begin")
            grvSampleType.PageIndex = e.NewPageIndex
            If Not IsNothing(ViewState("SortDirection")) And Not IsNothing(ViewState("SortField")) Then
                sorting(ViewState("SortField"), ViewState("SortDirection"))
            Else
                PopulateGrid()
            End If
            log.Info("Sample Type reference pagination complete")
        Catch ex As Exception
            log.Error("Sample Type reference record pagination error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub grvSampleType_Sorting(sender As Object, e As GridViewSortEventArgs) Handles grvSampleType.Sorting
        Try
            log.Info("Sample Type reference record sorting begins.")
            sorting(e.SortExpression, e.SortDirection)
            log.Info("Sample Type reference record sorting complete.")
        Catch ex As Exception
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Sorting.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub grvSampleType_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles grvSampleType.RowCancelingEdit
        Try
            log.Info("Sample Type reference record returning to regular mode begins.")
            grvSampleType.EditIndex = -1
            PopulateGrid()
            log.Info("Sample Type reference record returning to regular mode complete.")
        Catch ex As Exception
            log.Error("Sample Type reference record pagination error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel_Edit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub grvSampleType_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles grvSampleType.RowEditing
        Try
            log.Info("Sample Type reference converting record to edit mode begins.")
            grvSampleType.EditIndex = e.NewEditIndex
            PopulateGrid()
            log.Info("Sample Type reference converting record to edit mode begins.")
        Catch ex As Exception
            log.Error("Sample Type reference converting record to edit mode error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Edit_Mode.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub grvSampleType_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles grvSampleType.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then

            Dim lvCtrl As ListBox = e.Row.FindControl("lstHACode")

            If Not (lvCtrl Is Nothing) Then
                lvCtrl.DataSource = globalClient.GetHaCodes(GetCurrentLanguage(), HACodeList.HALVHACode).Result
                lvCtrl.DataTextField = "CodeName"
                lvCtrl.DataValueField = "intHACode"
                lvCtrl.DataBind()

                'Select the HACode in List
                If (e.Row.DataItemIndex >= 0) And Not IsNothing(grvSampleType.DataKeys(e.Row.RowIndex).Values("strHACode")) Then
                    Dim sHACode As String = grvSampleType.DataKeys(e.Row.RowIndex).Values("strHACode").ToString()
                    Dim aHACodeList = sHACode.Split(",")
                    For Each itm In aHACodeList
                        lvCtrl.Items.FindByValue(itm).Selected = True
                    Next
                End If
            End If
        End If

    End Sub

    Private Sub grvSampleType_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles grvSampleType.RowUpdating
        Try
            log.Info("Sample Type reference record update begins")
            Dim grvr As GridViewRow = grvSampleType.Rows(e.RowIndex)
            Dim sampleTypeRefParams As AdminSampleReferenceTypeSet = New AdminSampleReferenceTypeSet()

            sampleTypeRefParams.laguageId = language
            sampleTypeRefParams.idfsSampleType = Convert.ToInt64(grvSampleType.DataKeys(e.RowIndex).Values(0))

            Dim txtstrDefault As TextBox = grvr.FindControl("txtstrDefault")
            If Not IsNothing(txtstrDefault) Then
                If String.IsNullOrEmpty(txtstrDefault.Text.Trim()) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    Exit Sub
                Else
                    sampleTypeRefParams.strDefault = txtstrDefault.Text.Trim()
                End If
            End If

            Dim txtstrName As TextBox = grvr.FindControl("txtstrName")
            If Not IsNothing(txtstrName) Then
                If String.IsNullOrEmpty(txtstrName.Text.Trim()) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    Exit Sub
                Else
                    sampleTypeRefParams.strName = txtstrName.Text.Trim()
                End If
            End If

            Dim txtintOrder As EIDSSControlLibrary.NumericSpinner = grvr.FindControl("txtOrder")
            If Not IsNothing(txtintOrder) Then
                If String.IsNullOrEmpty(txtintOrder.Text) Then
                    sampleTypeRefParams.intOrder = 0
                Else
                    sampleTypeRefParams.intOrder = Convert.ToInt32(txtintOrder.Text)
                End If
            End If

            Dim lstRowHACode As ListBox = grvr.FindControl("lstHACode")
            Dim HaCode As Integer = 0
            If Not IsNothing(lstRowHACode) Then
                For Each li As ListItem In lstRowHACode.Items
                    If li.Selected Then
                        HaCode = HaCode + Convert.ToInt16(li.Value)
                    End If
                Next
            End If

            If HaCode = 0 Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Select_Accessory_Codes.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                Exit Sub
            Else
                sampleTypeRefParams.intHaCode = HaCode
            End If

            Dim txtCode As TextBox = grvr.FindControl("txtCode")
            If Not IsNothing(txtCode) Then
                If Not String.IsNullOrEmpty(txtCode.Text) Then
                    sampleTypeRefParams.strSampleCode = txtCode.Text
                Else
                    sampleTypeRefParams.strSampleCode = Nothing
                End If
            End If

            Dim results As String = sampleTypeAPIClient.SampleTypeSet(sampleTypeRefParams).Result(0).ReturnMessage

            If results = "SUCCESS" Then
                grvSampleType.EditIndex = -1
                PopulateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Sample_Type.InnerText") & " " & txtstrName.Text & GetLocalResourceObject("lbl_Period.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            Else
                lbl_Error.InnerText = GetLocalResourceObject("lbl_The_Sample_Type.InnerText") & " " & txtstrDefault.Text & " " & GetLocalResourceObject("lbl_Or.InnerText") & " " & txtstrName.Text & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
            End If
            log.Info("Sample Type reference record update complete")
        Catch ex As Exception
            log.Error("Sample Type reference record converting to edit mode error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Save.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub grvSampleType_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles grvSampleType.RowDeleting
        Try
            log.Info("Sample Type reference delete information gathering begins")
            Dim id As Double = grvSampleType.DataKeys(e.RowIndex)("idfsSampleType")
            hdfSTidfsSampleType.Value = id

            Dim grvr As GridViewRow = grvSampleType.Rows(e.RowIndex)

            Dim lblstrName As Label = grvr.FindControl("lblstrName")
            If Not IsNothing(lblstrName) Then
                hdfSTstrName.Value = lblstrName.Text
            End If

            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Sample_Type_Question_Delete.InnerText") & " " & hdfSTstrName.Value & GetLocalResourceObject("lbl_Question_Mark.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
            log.Info("Sample Type reference delete information gathering complete")
        Catch ex As Exception
            log.Error("Sample Type reference delete information gathering error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

#End Region

#Region "Dropdown"

    Private Sub fillSTHACode()
        lstSTHACode.DataSource = globalClient.GetHaCodes(GetCurrentLanguage(), HACodeList.HALVHACode).Result
        lstSTHACode.DataValueField = "intHACode"
        lstSTHACode.DataTextField = "CodeName"
        lstSTHACode.DataBind()
    End Sub
#End Region

    Private Sub PopulateGrid()
        Dim sampleTypeRefList As List(Of RefSampleTypeReferenceGetListModel) = sampleTypeAPIClient.GetRefSampleType(language).Result.ToList()
        grvSampleType.DataSource = sampleTypeRefList
        grvSampleType.DataBind()
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
        Dim ds As List(Of RefSampleTypeReferenceGetListModel) = sampleTypeAPIClient.GetRefSampleType(language).Result.ToList()
        If sortDirection = SortDirection.Ascending Then
            If sortField = "strDefault" Then
                grvSampleType.DataSource = (From d In ds
                                            Order By d.strDefault).ToList()
            ElseIf sortField = "name" Then
                grvSampleType.DataSource = (From d In ds
                                            Order By d.name).ToList()
            ElseIf sortField = "intOrder" Then
                grvSampleType.DataSource = (From d In ds
                                            Order By d.intOrder).ToList()
            ElseIf sortField = "strHACodeNames" Then
                grvSampleType.DataSource = (From d In ds
                                            Order By d.strHACodeNames).ToList()
            End If
        Else
            If sortField = "strDefault" Then
                grvSampleType.DataSource = (From d In ds
                                            Order By d.strDefault Descending).ToList()
            ElseIf sortField = "name" Then
                grvSampleType.DataSource = (From d In ds
                                            Order By d.name Descending).ToList()
            ElseIf sortField = "intOrder" Then
                grvSampleType.DataSource = (From d In ds
                                            Order By d.intOrder Descending).ToList()
            ElseIf sortField = "strHACodeNames" Then
                grvSampleType.DataSource = (From d In ds
                                            Order By d.strHACodeNames Descending).ToList()
            End If
        End If

        If sortFieldChanged Then
            grvSampleType.PageIndex = 0
        End If
        grvSampleType.DataBind()
    End Sub

    Private Sub clearForm()
        hdfSTidfsSampleType.Value = "NULL"
        hdfSTstrName.Value = "NULL"
        hdfSTValidationError.Value = False
        txtSTstrDefault.Text = String.Empty
        txtSTstrName.Text = String.Empty
        txtSTstrSampleCode.Text = String.Empty
        txtintOrder.Text = String.Empty
        lstSTHACode.SelectedIndex = -1
    End Sub

End Class