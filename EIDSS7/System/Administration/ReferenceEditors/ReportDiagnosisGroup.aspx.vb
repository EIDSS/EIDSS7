Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Public Class ReportDiagnosisGroup
    Inherits System.Web.UI.Page

    Private ReadOnly reportDiagnosisGroupClient As ReportDiagnosisGroupServiceClient
    Private language As String
    Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(Dashboard))
    Private gridViewSortDirection As SortDirection

    Sub New()
        reportDiagnosisGroupClient = New ReportDiagnosisGroupServiceClient()
        language = GetCurrentLanguage()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not IsPostBack Then
                log.Info("Report diagnosis group reference editor page load begins")
                PopulateGrid()
                log.Info("Report diagnosis group reference page editor load complete")
            End If
        Catch ex As Exception
            log.Error("Report diagnosis group reference page: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading_Report_Diagnosis_Group_Page.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

#Region "buttons"

    Protected Sub btnAddReference_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddReference.Click
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addReportDiagnosisGroup');});", True)
    End Sub

    Protected Sub btnSaveReportDiagnosisGroup_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSaveReportDiagnosisGroup.ServerClick
        Try
            log.Info("Report Diagnosis Group reference creation begins")
            hdfRDValidationError.Value = True

            If (String.IsNullOrEmpty(txtRDstrDefault.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtRDstrName.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                Exit Sub
            Else

                Dim rdgParams As RefReporDiagnosisTypeSetParams = New RefReporDiagnosisTypeSetParams()

                rdgParams.languageId = language
                rdgParams.idfsReportDiagnosisGroup = Nothing
                rdgParams.strDefault = txtRDstrDefault.Text.Trim()
                rdgParams.strCode = txtRDstrCode.Text.Trim()
                rdgParams.strName = txtRDstrName.Text.Trim()

                Dim results As String = reportDiagnosisGroupClient.RefReportDiagnosisGroupSet(rdgParams).Result(0).ReturnMessage

                If results = "SUCCESS" Then
                    PopulateGrid()
                    clearRDForm()
                    hdfRDValidationError.Value = False
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Report_Dianosis_Group.InnerText") & " " & txtRDstrName.Text & GetLocalResourceObject("lbl_Period_Type.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                Else
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_The_Report_Diagnosis_Group.InnerText") & " " & txtRDstrName.Text.Trim() & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                End If
                log.Info("Report Diagnosis Group reference creation complete")
            End If
        Catch ex As Exception
            log.Error("Report Diagnosis Group reference creation error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Save.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Report Diagnosis Group reference deletion begins")

            Dim id As Int64 = Convert.ToInt64(hdfRDidfsReportDiagnosisGroup.Value)
            Dim returnMsg As String = reportDiagnosisGroupClient.RefReportDiagnosisGroupDel(id, False).Result(0).ReturnMessage

            If returnMsg = "IN USE" Then
                lbl_Delete_Anyway.InnerText = GetLocalResourceObject("lbl_Report_Diagnosis_Group.InnerText") & " " & hdfRDstrName.Value & " " & GetLocalResourceObject("lbl_In_Use.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('currentlyInUseModal');});", True)
            Else
                PopulateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Report_Diagnosis_Group.InnerText") & " " & hdfRDstrName.Value & txtRDstrName.Text & GetLocalResourceObject("lbl_Period_Type.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                hdfRDValidationError.Value = False
                hdfRDidfsReportDiagnosisGroup.Value = "NULL"
                hdfRDstrName.Value = "NULL"
            End If
            log.Info("Report Diagnosis Group reference deletion complete")
        Catch ex As Exception
            log.Error("Report Diagnosis Group reference deletion error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnDeleteAnywayYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteAnywayYes.ServerClick
        Try
            log.Info("Report Diagnosis Group reference delete anyway begins")
            Dim id As Double = Convert.ToInt64(hdfRDidfsReportDiagnosisGroup.Value)
            reportDiagnosisGroupClient.RefReportDiagnosisGroupDel(id, True)
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Report_Diagnosis_Group.InnerText") & " " & hdfRDstrName.Value
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            hdfRDValidationError.Value = False
            hdfRDidfsReportDiagnosisGroup.Value = "NULL"
            hdfRDstrName.Value = "NULL"
            log.Info("Report Diagnosis Group reference delete anyway complete")
        Catch ex As Exception
            log.Error("Report Diagnosis Group reference delete anyway error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        If hdfRDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addReportDiagnosisGroup');});", True)
        End If
    End Sub

    Protected Sub btnCancelReportDiagnosisGroup_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelReportDiagnosisGroup.ServerClick
        clearRDForm()
    End Sub
#End Region

#Region "grid view"
    Protected Sub gvReportDiagnosisGroup_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvReportDiagnosisGroup.PageIndexChanging
        Try
            log.Info("Report diagnosis group reference record paging begins.")
            gvReportDiagnosisGroup.PageIndex = e.NewPageIndex
            PopulateGrid()
            log.Info("Report diagnosis group reference record paging begins.")
        Catch ex As Exception
            log.Error("Report diagnosis group reference record paging error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub gvReportDiagnosisGroup_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvReportDiagnosisGroup.Sorting
        Try
            log.Info("Report diagnosis group reference record sort begins.")
            sorting(e.SortExpression, e.SortDirection)
            log.Info("Report diagnosis group reference record sort complete.")
        Catch ex As Exception
            log.Error("Error sorting Report diagnosis group reference records: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Sorting.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvReportDiagnosisGroup_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvReportDiagnosisGroup.RowCancelingEdit
        Try
            log.Info("Report diagnosis group reference return to regular mode begins.")
            gvReportDiagnosisGroup.EditIndex = -1
            PopulateGrid()
            log.Info("Report diagnosis group reference return to regular mode complete.")
        Catch ex As Exception
            log.Error("Error returning to regular mode Report diagnosis group reference records: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel_Edit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvReportDiagnosisGroup_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvReportDiagnosisGroup.RowEditing
        Try
            log.Info("Report diagnosis group reference convert to edit mode begins.")
            gvReportDiagnosisGroup.EditIndex = e.NewEditIndex
            PopulateGrid()
            log.Info("Report diagnosis group reference convert to edit mode begins.")
        Catch ex As Exception
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Edit_Mode.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvReportDiagnosisGroup_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvReportDiagnosisGroup.RowUpdating
        Try
            log.Info("Report diagnosis group reference record update begins.")
            hdfRDValidationError.Value = False
            Dim gvr As GridViewRow = gvReportDiagnosisGroup.Rows(e.RowIndex)
            Dim rdgParams As RefReporDiagnosisTypeSetParams = New RefReporDiagnosisTypeSetParams()

            rdgParams.languageId = language
            rdgParams.idfsReportDiagnosisGroup = Convert.ToInt64(gvReportDiagnosisGroup.DataKeys(e.RowIndex).Values("idfsReportDiagnosisGroup"))

            Dim txtstrDefault As TextBox = gvr.FindControl("txtstrDefault")
            If Not IsNothing(txtstrDefault) Then
                If String.IsNullOrEmpty(txtstrDefault.Text.Trim()) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    Exit Sub
                Else
                    rdgParams.strDefault = txtstrDefault.Text.Trim()
                End If
            End If

            Dim txtstrName As TextBox = gvr.FindControl("txtstrName")
            If Not IsNothing(txtstrName) Then
                If String.IsNullOrEmpty(txtstrName.Text) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    Exit Sub
                Else
                    rdgParams.strName = txtstrName.Text.Trim()
                End If
            End If

            Dim txtstrICD10Codes As TextBox = gvr.FindControl("txtstrICD10Codes")
            If Not IsNothing(txtstrICD10Codes) Then
                If Not String.IsNullOrEmpty(txtstrICD10Codes.Text) Then
                    rdgParams.strCode = txtstrICD10Codes.Text.Trim()
                End If
            End If

            Dim results As String = reportDiagnosisGroupClient.RefReportDiagnosisGroupSet(rdgParams).Result(0).ReturnMessage

            If results = "SUCCESS" Then
                gvReportDiagnosisGroup.EditIndex = -1
                PopulateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Report_Dianosis_Group.InnerText") & " " & txtstrName.Text & GetLocalResourceObject("lbl_Period.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                clearRDForm()
            ElseIf results = "DOES EXIST" Then
                hdfRDValidationError.Value = False
                lbl_Error.InnerText = GetLocalResourceObject("lbl_The_Report_Diagnosis_Group.InnerText") & " " & txtstrName.Text.Trim() & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                clearRDForm()
            End If
            log.Info("Report diagnosis group reference record update complete.")
        Catch ex As Exception
            log.Error("Error updating Report diagnosis group reference record: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Save.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvReportDiagnosisGroup_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvReportDiagnosisGroup.RowDeleting
        Try
            log.Info("Report diagnosis group reference delete information gathering begins.")
            Dim id As Double = gvReportDiagnosisGroup.DataKeys(e.RowIndex)("idfsReportDiagnosisGroup")
            hdfRDidfsReportDiagnosisGroup.Value = id
            Dim lblstrName As Label = gvReportDiagnosisGroup.Rows(e.RowIndex).FindControl("lblstrName")

            If Not IsNothing(lblstrName) Then
                hdfRDstrName.Value = lblstrName.Text
            End If

            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Report Diagnosis_Group_Question_Delete.InnerText") & " " & hdfRDstrName.Value & GetLocalResourceObject("lbl_Question_Mark.InnerText") & " " & GetLocalResourceObject("lbl_Cannot_Be_Undone.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
            log.Info("Report diagnosis group reference delete information gathering complete.")
        Catch ex As Exception
            log.Error("Error gathering Report diagnosis group reference delete information: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub
#End Region

    Private Sub PopulateGrid()
        Dim reportDiagnosisGroupRefList As List(Of RefReportDiagnosisGroupGetListModel) = reportDiagnosisGroupClient.RefReportDiagnosisGroupGetList(language).Result
        gvReportDiagnosisGroup.DataSource = reportDiagnosisGroupRefList
        gvReportDiagnosisGroup.DataBind()
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
        Dim ds As List(Of RefReportDiagnosisGroupGetListModel) = reportDiagnosisGroupClient.RefReportDiagnosisGroupGetList(language).Result
        If sortDirection = SortDirection.Ascending Then
            If sortField = "strDefault" Then
                gvReportDiagnosisGroup.DataSource = (From d In ds
                                                     Order By d.strDefault).ToList()
            ElseIf sortField = "strName" Then
                gvReportDiagnosisGroup.DataSource = (From d In ds
                                                     Order By d.strName).ToList()
            End If
        Else
            If sortField = "strDefault" Then
                gvReportDiagnosisGroup.DataSource = (From d In ds
                                                     Order By d.strDefault Descending).ToList()
            ElseIf sortField = "strName" Then
                gvReportDiagnosisGroup.DataSource = (From d In ds
                                                     Order By d.strName Descending).ToList()
            End If
        End If

        If sortFieldChanged Then
            gvReportDiagnosisGroup.PageIndex = 0
        End If
        gvReportDiagnosisGroup.DataBind()
    End Sub

    Private Sub clearRDForm()
        hdfRDValidationError.Value = False
        hdfRDidfsReportDiagnosisGroup.Value = "NULL"
        hdfRDstrName.Value = "NULL"
        txtRDstrName.Text = String.Empty
        txtRDstrDefault.Text = String.Empty
        txtRDstrCode.Text = String.Empty
    End Sub

End Class