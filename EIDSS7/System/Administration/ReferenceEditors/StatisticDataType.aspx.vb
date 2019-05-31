Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class StatisticDataType
    Inherits BaseEidssPage

    Private ReadOnly statDataTypeClient As StatisticDataTypeServiceClient
    Private ReadOnly baseRefClient As BaseReferenceClient
    Private ReadOnly crossCuttingClient As CrossCuttingServiceClient
    Private ReadOnly language As String
    Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(Dashboard))
    Private gridViewSortDirection As SortDirection

    Sub New()
        language = GetCurrentLanguage()
        statDataTypeClient = New StatisticDataTypeServiceClient()
        baseRefClient = New BaseReferenceClient()
        crossCuttingClient = New CrossCuttingServiceClient()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not IsPostBack Then
                log.Info("Generic Statistical Type Reference Editor Page Load begins")
                populateGrid()
                fillSDDropdowns()
                log.Info("Generic Statistical Type Reference Editor Page Load complete")
            End If
        Catch ex As Exception
            log.Error("Generic Statistical Type Reference Editor page error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading_Age_Group_Page.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

#Region "buttons"

    Protected Sub btnAddReference_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddReference.Click
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addStatisticalDataType');});", True)
    End Sub

    Protected Sub btnSaveStatisticDataType_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSaveStatisticDataType.ServerClick
        Try
            log.Info("Generic Statistical Type reference creation begins.")
            hdfSDValidationError.Value = True

            If (String.IsNullOrEmpty(txtSDstrDefault.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtSDstrName.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                Exit Sub
            Else
                Dim SDParams As ReferenceStatDataTypeSetParams = New ReferenceStatDataTypeSetParams()

                SDParams.idfsStatisticDataType = Nothing
                SDParams.languageId = language
                SDParams.strDefault = txtSDstrDefault.Text.Trim()
                SDParams.strName = txtSDstrName.Text.Trim()
                SDParams.idfsReferenceType = Convert.ToInt64(ddlSDidfsReferenceType.SelectedValue)

                If ddlSDidfsStatisticAreaType.SelectedIndex > 0 Then
                    SDParams.idfsStatisticAreaType = Convert.ToInt64(ddlSDidfsStatisticAreaType.SelectedValue)
                End If

                SDParams.idfsStatisticPeriodType = Convert.ToInt64(ddlSDidfsStatisticPeriodType.SelectedValue)
                SDParams.blnRelatedWithAgeGroup = chkSDblnRelatedWithAgeGroup.Checked

                Dim results As String = statDataTypeClient.RefStatisticDataTypeSet(SDParams).Result(0).ReturnMessage

                If results <> "DOES EXIST" Then
                    populateGrid()
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Generic_Statistical_Type.InnerText") & " " & txtSDstrName.Text & GetLocalResourceObject("lbl_Period.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    clearSDForm()
                    log.Info("Generic Statistical Type reference creation complete.")
                Else
                    hdfSDValidationError.Value = True
                    lblSuccess.InnerText = GetLocalResourceObject("lbl_The_Generic_Statistical_Type.InnerText") & " " & txtSDstrName.Text.Trim() & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                    log.Info("Generic Statistical Type reference already exists.")
                End If
            End If
        Catch ex As Exception
            log.Error("Generic Statistical Type reference creation error:", ex)
            hdfSDValidationError.Value = False
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Create.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Generic Statistical Type reference deletion begins.")
            Dim id As Int64 = Convert.ToInt64(hdfSDidfsStatisticDataType.Value)
            Dim results As String = statDataTypeClient.RefStatisticalDataTypeDel(id, False).Result(0).ReturnMessage
            If results = "IN USE" Then
                lbl_Delete_Anyway.InnerText = GetLocalResourceObject("lbl_The_Generic_Statistical_Type.InnerText") & " " & hdfSDstrName.Value & " " & GetLocalResourceObject("lbl_In_Use.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('currentlyInUseModal');});", True)
                Exit Sub
            Else
                populateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_General_Statistical_Type.InnerText") & " " & hdfSDstrName.Value
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                Exit Sub
            End If
            log.Info("Generic Statistical Type reference deletion complete.")
        Catch ex As Exception
            log.Error("Generic Statistical Type reference deletion error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete_Reference.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnDeleteAnywayYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteAnywayYes.ServerClick
        Try
            log.Info("Generic Statistical Type reference delete anyway begins.")
            Dim id As Int64 = Convert.ToInt64(hdfSDidfsStatisticDataType.Value)
            statDataTypeClient.RefStatisticalDataTypeDel(id, True)
            populateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_General_Statistical_Type.InnerText") & " " & hdfSDstrName.Value
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("Generic Statistical Type reference delete anyway complete.")
        Catch ex As Exception
            log.Error("Generic Statistical Type reference delete anyway error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete_Reference.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        log.Info("Generic Statistical Type creator modal opener begins")
        If hdfSDValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addStatisticalDataType');});", True)
        End If
        log.Info("Generic Statistical Type creator modal opener complete")
    End Sub

    Protected Sub btnCancelStatisticalDataType_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelStatisticDataType.ServerClick
        clearSDForm()
    End Sub

#End Region

#Region "grid view"
    Protected Sub gvStatisticalDataType_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvStatisticalDataType.PageIndexChanging
        Try
            log.Info("Generic Statistical Type page index begins")
            gvStatisticalDataType.PageIndex = e.NewPageIndex
            populateGrid()
            log.Info("Generic Statistical Type page index complete")
        Catch ex As Exception
            log.Error("Generic Statistical Type page index error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub gvStatisticalDataType_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvStatisticalDataType.Sorting
        Try
            log.Info("Generic Statistical Type sorting begins")
            sorting(e.SortExpression, e.SortDirection)
            log.Info("Generic Statistical Type sorting complete")
        Catch ex As Exception
            log.Error("Generic Statistical Type sorting error: ", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Sorting.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvStatisticalDataType_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvStatisticalDataType.RowCancelingEdit
        Try
            log.Info("Generic Statistical Type return to regular mode begins")
            gvStatisticalDataType.EditIndex = -1
            populateGrid()
            log.Info("Generic Statistical Type return to regular mode complete")
        Catch ex As Exception
            log.Error("Generic Statistical Type return to regular mode error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel_Edit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvStatisticalDataType_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvStatisticalDataType.RowEditing
        Try
            log.Info("Generic Statistical Type convert to edit mode begin")
            gvStatisticalDataType.EditIndex = e.NewEditIndex
            populateGrid()
            log.Info("Generic Statistical Type convert to edit mode complete")
        Catch ex As Exception
            log.Error("Generic Statistical Type convert to edit mode error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Save.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvStatisticalDataType_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvStatisticalDataType.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim ddlidfsReferenceType As DropDownList = e.Row.FindControl("ddlidfsReferenceType")
            If Not IsNothing(ddlidfsReferenceType) Then
                ddlidfsReferenceType.DataSource = crossCuttingClient.GetBaseReferenceList(language, "Reference Type Name", 0).Result
                ddlidfsReferenceType.DataValueField = "idfsBaseReference"
                ddlidfsReferenceType.DataTextField = "name"
                ddlidfsReferenceType.DataBind()
                ddlidfsReferenceType.SelectedValue = gvStatisticalDataType.DataKeys(e.Row.RowIndex)("idfsReferenceType")
            End If

            Dim ddlidfsAreaType As DropDownList = e.Row.FindControl("ddlidfsAreaType")
            If Not IsNothing(ddlidfsAreaType) Then
                ddlidfsAreaType.Items.Add(New ListItem("", ""))
                ddlidfsAreaType.DataSource = crossCuttingClient.GetBaseReferenceList(language, "Statistical Area Type", 0).Result
                ddlidfsAreaType.DataValueField = "idfsBaseReference"
                ddlidfsAreaType.DataTextField = "name"
                ddlidfsAreaType.DataBind()
                ddlidfsAreaType.SelectedValue = gvStatisticalDataType.DataKeys(e.Row.RowIndex)("idfsStatisticAreaType")
            End If

            Dim ddlidfsPeriodType As DropDownList = e.Row.FindControl("ddlidfsPeriodType")
            If Not IsNothing(ddlidfsPeriodType) Then
                ddlidfsPeriodType.DataSource = crossCuttingClient.GetBaseReferenceList(language, "Statistical Period Type", 0).Result
                ddlidfsPeriodType.DataValueField = "idfsBaseReference"
                ddlidfsPeriodType.DataTextField = "name"
                ddlidfsPeriodType.DataBind()
                ddlidfsPeriodType.SelectedValue = gvStatisticalDataType.DataKeys(e.Row.RowIndex)("idfsStatisticPeriodType")
            End If

            Dim chkblnStatisticalAgeGroup As CheckBox = e.Row.FindControl("chkblnStatisticalAgeGroup")
            If Not IsNothing(chkblnStatisticalAgeGroup) Then
                Dim blnStatisticalAgeGroup As Boolean = Convert.ToBoolean(gvStatisticalDataType.DataKeys(e.Row.RowIndex)("blnStatisticalAgeGroup"))
                If blnStatisticalAgeGroup Then
                    chkblnStatisticalAgeGroup.Checked = True
                End If
            End If
        End If
    End Sub

    Private Sub gvStatisticalDataType_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvStatisticalDataType.RowUpdating
        Try
            log.Info("Generic Statistical Type reference update begin")
            hdfSDValidationError.Value = False
            Dim gvr As GridViewRow = gvStatisticalDataType.Rows(e.RowIndex)
            Dim sdtSetParams As ReferenceStatDataTypeSetParams = New ReferenceStatDataTypeSetParams()
            sdtSetParams.languageId = language

            sdtSetParams.idfsStatisticDataType = Convert.ToInt64(gvStatisticalDataType.DataKeys(e.RowIndex).Values("idfsStatisticDataType"))

            Dim txtstrDefault As TextBox = gvr.FindControl("txtstrDefault")
            If Not IsNothing(txtstrDefault) Then
                If String.IsNullOrEmpty(txtstrDefault.Text.Trim()) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    Exit Sub
                Else
                    sdtSetParams.strDefault = txtstrDefault.Text.Trim()
                End If
            End If

            Dim txtstrName As TextBox = gvr.FindControl("txtstrName")
            If Not IsNothing(txtstrName) Then
                If String.IsNullOrEmpty(txtstrName.Text.Trim()) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    Exit Sub
                Else
                    sdtSetParams.strName = txtstrName.Text.Trim()
                End If
            End If

            Dim chkblnStatisticalAgeGroup As CheckBox = gvr.FindControl("chkblnStatisticalAgeGroup")
            If Not IsNothing(chkblnStatisticalAgeGroup) Then
                sdtSetParams.blnRelatedWithAgeGroup = chkblnStatisticalAgeGroup.Checked
            End If

            Dim ddlidfsReferenceType As DropDownList = gvr.FindControl("ddlidfsReferenceType")
            If Not IsNothing(ddlidfsReferenceType) Then
                sdtSetParams.idfsReferenceType = Convert.ToInt64(ddlidfsReferenceType.SelectedValue)
            Else
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Parameter_Type_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                Exit Sub
            End If

            Dim ddlidfsPeriodType As DropDownList = gvr.FindControl("ddlidfsPeriodType")
            If Not IsNothing(ddlidfsPeriodType) Then
                sdtSetParams.idfsStatisticPeriodType = Convert.ToInt64(ddlidfsPeriodType.SelectedValue.ToString())
            End If

            Dim ddlidfsAreaType As DropDownList = gvr.FindControl("ddlidfsAreaType")
            If Not IsNothing(ddlidfsAreaType) Then
                If ddlidfsAreaType.SelectedIndex > 0 Then
                    sdtSetParams.idfsStatisticAreaType = Convert.ToInt64(ddlidfsAreaType.SelectedValue)
                End If
            End If

            Dim results As String = statDataTypeClient.RefStatisticDataTypeSet(sdtSetParams).Result(0).ReturnMessage

            If results = "SUCCESS" Then
                gvStatisticalDataType.EditIndex = -1
                populateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Generic_Statistical_Type.InnerText") & " " & txtstrName.Text & GetLocalResourceObject("lbl_Period.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                hdfSDValidationError.Value = False
                log.Info("Generic Statistical Type reference update complete")
            ElseIf results = "DOES EXIST" Then
                lblSuccess.InnerText = GetLocalResourceObject("lbl_The_Generic_Statistical_Type.InnerText") & " " & txtstrDefault.Text.Trim() & " " & GetLocalResourceObject("lbl_Or.InnerText") & " " & txtstrName.Text.Trim() & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                log.Info("Generic Statistical Type reference already exists.")
            End If
        Catch ex As Exception
            log.Error("Generic Statistical Type reference update error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Save.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvStatisticalDataType_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvStatisticalDataType.RowDeleting
        Try
            log.Info("Generic Statistical Type delete information gathering begins")
            Dim id As Double = gvStatisticalDataType.DataKeys(e.RowIndex)("idfsStatisticDataType")
            hdfSDidfsStatisticDataType.Value = id
            Dim lblstrName As Label = gvStatisticalDataType.Rows(e.RowIndex).FindControl("lblstrName")
            If Not IsNothing(lblstrName) Then
                hdfSDstrName.Value = lblstrName.Text
            End If
            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Generic_Statistical_Type_Question_Delete.InnerText") & " " & hdfSDstrName.Value & GetLocalResourceObject("lbl_Question_Mark.InnerText") & " " & GetLocalResourceObject("lbl_Cannot_Be_Undone.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
            log.Info("Generic Statistical Type delete information gathering complete")
        Catch ex As Exception
            log.Error("Generic Statistical Type reference delete information gathering error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub
#End Region

    Private Sub populateGrid()
        gvStatisticalDataType.DataSource = statDataTypeClient.RefStatisticDataTypeGetList(language).Result
        gvStatisticalDataType.DataBind()
    End Sub

    Private Sub fillSDDropdowns()
        ddlSDidfsStatisticAreaType.Items.Add(New ListItem("", ""))
        ddlSDidfsStatisticAreaType.DataSource = crossCuttingClient.GetBaseReferenceList(language, "Statistical Area Type", 0).Result
        ddlSDidfsStatisticAreaType.DataValueField = "idfsBaseReference"
        ddlSDidfsStatisticAreaType.DataTextField = "name"
        ddlSDidfsStatisticAreaType.DataBind()

        ddlSDidfsStatisticPeriodType.DataSource = crossCuttingClient.GetBaseReferenceList(language, "Statistical Period Type", 0).Result
        ddlSDidfsStatisticPeriodType.DataValueField = "idfsBaseReference"
        ddlSDidfsStatisticPeriodType.DataTextField = "strDefault"
        ddlSDidfsStatisticPeriodType.DataBind()

        ddlSDidfsReferenceType.DataSource = crossCuttingClient.GetBaseReferenceList(language, "Reference Type Name", 0).Result
        ddlSDidfsReferenceType.DataValueField = "idfsBaseReference"
        ddlSDidfsReferenceType.DataTextField = "strDefault"
        ddlSDidfsReferenceType.DataBind()
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
        Dim ds As List(Of RefStatisticdatatypeGetListModel) = statDataTypeClient.RefStatisticDataTypeGetList(language).Result.ToList()
        If sortDirection = SortDirection.Ascending Then
            If sortField = "strDefault" Then
                gvStatisticalDataType.DataSource = (From d In ds
                                                    Order By d.strDefault).ToList()
            ElseIf sortField = "strName" Then
                gvStatisticalDataType.DataSource = (From d In ds
                                                    Order By d.strName).ToList()
            End If
        Else
            If sortField = "strDefault" Then
                gvStatisticalDataType.DataSource = (From d In ds
                                                    Order By d.strDefault Descending).ToList()
            ElseIf sortField = "strName" Then
                gvStatisticalDataType.DataSource = (From d In ds
                                                    Order By d.strName Descending).ToList()
            End If
        End If

        If sortFieldChanged Then
            gvStatisticalDataType.PageIndex = 0
        End If
        gvStatisticalDataType.DataBind()
    End Sub

    Private Sub clearSDForm()
        hdfSDidfsStatisticDataType.Value = "NULL"
        hdfSDValidationError.Value = False
        hdfSDstrName.Value = "NULL"
        txtSDstrName.Text = String.Empty
        txtSDstrDefault.Text = String.Empty
        chkSDblnRelatedWithAgeGroup.Checked = False
        ddlSDidfsReferenceType.SelectedIndex = -1
        ddlSDidfsStatisticPeriodType.SelectedIndex = -1
        ddlSDidfsStatisticAreaType.SelectedIndex = -1
    End Sub

End Class