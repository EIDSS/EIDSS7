Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Public Class VectorSubType
    Inherits BaseEidssPage

    Private ReadOnly crossCuttingClient As CrossCuttingServiceClient
    Private ReadOnly vectorSubTypeAPIClient As VectorSubTypeServiceClient
    Private ReadOnly language As String
    Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(Dashboard))
    Private gridViewSortDirection As SortDirection

    Sub New()
        crossCuttingClient = New CrossCuttingServiceClient()
        vectorSubTypeAPIClient = New VectorSubTypeServiceClient()
        language = GetCurrentLanguage()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not Page.IsPostBack Then
                log.Info("Vector Species Type Reference Editor page load begins")
                PopulateVectorTypeDropDown()
                PopulateGrid()
                log.Info("Vector Species Type Reference Editor page load complete")
            End If
        Catch ex As Exception
            log.Error("Vector Species Type Reference Editor page error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading_Vector_Species_Type_Page.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

#Region "buttons"

    Protected Sub btnAddReference_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddReference.Click
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorSubType');});", True)
    End Sub

    Protected Sub btnSaveVectorSubType_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSaveVectorSubType.ServerClick
        Try
            log.Info("Vector Species Type reference creation begins.")
            hdfVSValidationError.Value = True

            If (String.IsNullOrEmpty(txtVSstrDefault.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtVSstrName.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                Exit Sub
            Else
                Dim VSParams As ReferenceVectorSubTypeSetParams = New ReferenceVectorSubTypeSetParams()

                VSParams.idfsVectorSubType = Nothing
                VSParams.idfsVectorType = Convert.ToInt64(ddlVectorType.SelectedValue)
                VSParams.languageId = language
                VSParams.strDefault = txtVSstrDefault.Text.Trim()
                VSParams.strName = txtVSstrName.Text.Trim()
                VSParams.strCode = txtVSstrCode.Text.Trim()

                If String.IsNullOrEmpty(txtVSintOrder.Text) Then
                    VSParams.intOrder = 0
                Else
                    VSParams.intOrder = Convert.ToInt32(txtVSintOrder.Text)
                End If

                Dim results As String = vectorSubTypeAPIClient.RefVectorSubTypeSet(VSParams).Result(0).ReturnMessage

                If results <> "DOES EXIST" Then
                    PopulateGrid()
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Successful_Vector_Species_Type.InnerText") & " " & txtVSstrName.Text & GetLocalResourceObject("lbl_Period.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    clearVSForm()
                    log.Info("Vector Species Type reference creation complete.")
                Else
                    hdfVSValidationError.Value = True
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_The_Vector_Species_Type.InnerText") & " " & txtVSstrName.Text.Trim() & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    log.Info("Vector Species Type reference already exists.")
                End If
            End If
        Catch ex As Exception
            log.Error("Vector Species Type reference creation error:", ex)
            hdfVSValidationError.Value = False
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Create.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Vector Species Type reference deletion begins.")
            Dim id As Int64 = Convert.ToInt64(hdfVSidfsVectorSubType.Value)
            Dim results As String = vectorSubTypeAPIClient.RefVectorSubTypeDel(id, False).Result(0).ReturnMessage
            If results = "IN USE" Then
                lbl_Delete_Anyway.InnerText = GetLocalResourceObject("lbl_The_Vector_Species_Type.InnerText") & " " & hdfVSstrName.Value & " " & GetLocalResourceObject("lbl_In_Use.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('currentlyInUseModal');});", True)
                Exit Sub
            Else
                PopulateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Vector_Species_Type.InnerText") & " " & hdfVSstrName.Value
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                Exit Sub
            End If
            log.Info("Vector Species Type reference deletion complete.")
        Catch ex As Exception
            log.Error("Vector Species Type reference deletion error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnDeleteAnywayYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteAnywayYes.ServerClick
        Try
            log.Info("Vector Species Type reference delete anyway begins.")
            Dim id As Int64 = Convert.ToInt64(hdfVSidfsVectorSubType.Value)
            vectorSubTypeAPIClient.RefVectorSubTypeDel(id, True)
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Vector_Species_Type.InnerText") & " " & hdfVSstrName.Value
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
            log.Info("Vector Species Type reference delete anyway complete.")
        Catch ex As Exception
            log.Error("Vector Species Type reference delete anyway error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub
    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        log.Info("Vector Species Type creator modal opener begins")
        If hdfVSValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorSubType');});", True)
        End If
        log.Info("Vector Species Type creator modal opener complete")
    End Sub

    Protected Sub btnCancelVectorType_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelVectorSubType.ServerClick
        clearVSForm()
    End Sub
#End Region

#Region "grid view"
    Protected Sub gvVectorSubType_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvVectorSubType.PageIndexChanging
        Try
            log.Info("Vector Species Type Reference Editor record paging begins.")
            gvVectorSubType.PageIndex = e.NewPageIndex
            PopulateGrid()
            log.Info("Vector Species Type Reference Editor record paging complete.")
        Catch ex As Exception
            log.Error("Vector Species Type Reference Editor record paging error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub gvVectorSubType_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvVectorSubType.Sorting
        Try
            log.Info("Vector Species Type Reference Editor record sort begins.")
            sorting(e.SortExpression, e.SortDirection)
            log.Info("Vector Species Type Reference Editor record sort complete.")
        Catch ex As Exception
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Sorting.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvVectorSubType_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvVectorSubType.RowCancelingEdit
        Try
            log.Info("Vector Species Type Reference Editor return to regular mode begins.")
            gvVectorSubType.EditIndex = -1
            PopulateGrid()
            log.Info("Vector Species Type Reference Editor return to regular mode complete.")
        Catch ex As Exception
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel_Edit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvVectorSubType_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvVectorSubType.RowEditing
        Try
            log.Info("Vector Species Type Reference Editor convert to edit mode begins.")
            gvVectorSubType.EditIndex = e.NewEditIndex
            PopulateGrid()
            log.Info("Vector Species Type Reference Editor convert to edit mode complete.")
        Catch ex As Exception
            log.Error("Error convert to edit mode Vector Species Type Reference Editor records: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Edit_Mode.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvVectorSubType_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvVectorSubType.RowUpdating
        Try
            log.Info("Vector Species Type Reference Editor update begins.")
            hdfVSValidationError.Value = False
            Dim gvr As GridViewRow = gvVectorSubType.Rows(e.RowIndex)
            Dim VTParams As ReferenceVectorSubTypeSetParams = New ReferenceVectorSubTypeSetParams()

            VTParams.idfsVectorSubType = Convert.ToInt64(gvVectorSubType.DataKeys(e.RowIndex).Values("idfsVectorSubType"))
            VTParams.idfsVectorType = Convert.ToInt64(gvVectorSubType.DataKeys(e.RowIndex).Values("idfsVectorType"))

            Dim txtstrDefault As TextBox = gvr.FindControl("txtstrDefault")
            If Not IsNothing(txtstrDefault) Then
                If String.IsNullOrEmpty(txtstrDefault.Text) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    Exit Sub
                Else
                    VTParams.strDefault = txtstrDefault.Text.Trim()
                End If
            End If

            Dim txtstrName As TextBox = gvr.FindControl("txtstrName")
            If Not IsNothing(txtstrName) Then
                If String.IsNullOrEmpty(txtstrName.Text) Then
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    Exit Sub
                Else
                    VTParams.strName = txtstrName.Text
                End If
            End If

            Dim txtintOrder As EIDSSControlLibrary.NumericSpinner = gvr.FindControl("txtintOrder")
            If Not IsNothing(txtintOrder) Then
                If String.IsNullOrEmpty(txtintOrder.Text) Then
                    VTParams.intOrder = 0
                Else
                    VTParams.intOrder = Convert.ToInt32(txtintOrder.Text)
                End If
            End If

            Dim txtstrCode As TextBox = gvr.FindControl("txtstrCode")
            If Not IsNothing(txtstrCode) Then
                VTParams.strCode = txtstrCode.Text.Trim()
            End If

            If vectorSubTypeAPIClient.RefVectorSubTypeSet(VTParams).Result(0).ReturnMessage = "SUCCESS" Then
                gvVectorSubType.EditIndex = -1
                PopulateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Vector_Species_Type.InnerText") & " " & txtstrName.Text & "."
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                hdfVSValidationError.Value = False
            End If
        Catch ex As Exception
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Save.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvVectorSubType_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvVectorSubType.RowDeleting
        Try
            Dim id As Double = gvVectorSubType.DataKeys(e.RowIndex)("idfsVectorSubType")
            hdfVSidfsVectorSubType.Value = id

            Dim lblstrName As Label = gvVectorSubType.Rows(e.RowIndex).FindControl("lblstrName")
            If Not IsNothing(lblstrName) Then
                hdfVSstrName.Value = lblstrName.Text
            End If

            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Vector_Species_Type_Question_Delete.InnerText") & " " & hdfVSstrName.Value & GetLocalResourceObject("lbl_Question_Mark.InnerText") & " " & GetLocalResourceObject("lbl_Cannot_Be_Undone.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
        Catch ex As Exception
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

#End Region

    Private Sub ddlVectorType_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlVectorType.SelectedIndexChanged
        PopulateGrid()
    End Sub

    Private Sub PopulateVectorTypeDropDown()
        ddlVectorType.DataSource = crossCuttingClient.GetBaseReferenceList(language, "Vector Type", HACodeList.VectorHACode).Result
        ddlVectorType.DataTextField = "strDefault"
        ddlVectorType.DataValueField = "idfsBaseReference"
        ddlVectorType.DataBind()
    End Sub

    Private Sub PopulateGrid()
        gvVectorSubType.DataSource = vectorSubTypeAPIClient.RefVectorSubTypeGetList(language, Convert.ToInt64(ddlVectorType.SelectedValue)).Result
        gvVectorSubType.DataBind()
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
        Dim ds As List(Of RefVectorSubTypeGetListModel) = vectorSubTypeAPIClient.RefVectorSubTypeGetList(language, Convert.ToInt64(ddlVectorType.SelectedValue)).Result.ToList()
        If sortDirection = SortDirection.Ascending Then
            If sortField = "strDefault" Then
                gvVectorSubType.DataSource = (From d In ds
                                              Order By d.strDefault).ToList()
            ElseIf sortField = "strName" Then
                gvVectorSubType.DataSource = (From d In ds
                                              Order By d.strName).ToList()
            ElseIf sortField = "intOrder" Then
                gvVectorSubType.DataSource = (From d In ds
                                              Order By d.intOrder).ToList()
            End If
        Else
            If sortField = "strDefault" Then
                gvVectorSubType.DataSource = (From d In ds
                                              Order By d.strDefault Descending).ToList()
            ElseIf sortField = "strName" Then
                gvVectorSubType.DataSource = (From d In ds
                                              Order By d.strName Descending).ToList()
            ElseIf sortField = "intOrder" Then
                gvVectorSubType.DataSource = (From d In ds
                                              Order By d.intOrder Descending).ToList()
            End If
        End If

        If sortFieldChanged Then
            gvVectorSubType.PageIndex = 0
        End If
        gvVectorSubType.DataBind()
    End Sub

    Private Sub clearVSForm()
        hdfVSidfsVectorSubType.Value = "NULL"
        hdfVSValidationError.Value = False
        hdfVSstrName.Value = "NULL"
        txtVSstrName.Text = String.Empty
        txtVSstrDefault.Text = String.Empty
        txtVSintOrder.Text = String.Empty
        txtVSstrCode.Text = String.Empty
    End Sub

End Class