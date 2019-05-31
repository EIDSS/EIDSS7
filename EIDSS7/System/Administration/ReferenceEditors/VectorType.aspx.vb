Imports EIDSS.EIDSS
Imports System.Threading
Imports System.Globalization
Imports EIDSS.Client.API_Clients
Imports Newtonsoft
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class VectorType
    Inherits BaseEidssPage

    Private ReadOnly vectorTypeAPIClient As VectorTypeServiceClient
    Private ReadOnly language As String
    Private log As log4net.ILog = log4net.LogManager.GetLogger(GetType(Dashboard))
    Private gridViewSortDirection As SortDirection

    Sub New()
        language = GetCurrentLanguage()
        vectorTypeAPIClient = New VectorTypeServiceClient()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not Page.IsPostBack Then
                log.Info("Vector Type Reference Editor page load begins")
                PopulateGrid()
                log.Info("Vector Reference Editor page load complete")
            End If
        Catch ex As Exception
            log.Error("Vector Type Reference Editor page error: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Loading_Vector_Type_Page.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub


#Region "buttons"

    Protected Sub btnAddReference_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnAddReference.Click
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorType');});", True)
    End Sub

    Protected Sub btnSaveCaseClass_ServerClick(ByVal sender As Object, ByVal e As EventArgs) Handles btnSaveVectorType.ServerClick
        Try
            log.Info("Vector Type reference creation begins.")
            hdfVTValidationError.Value = True

            If (String.IsNullOrEmpty(txtVTstrDefault.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_English_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                Exit Sub
            ElseIf (String.IsNullOrEmpty(txtVTstrName.Text.Trim())) Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_Translated_Value_Required.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
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

                If results <> "DOES EXIST" Then
                    PopulateGrid()
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Successful_Vector_Type.InnerText") & " " & txtVTstrName.Text & GetLocalResourceObject("lbl_Period.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                    clearVTForm()
                    log.Info("Vector Type reference creation complete.")
                Else
                    hdfVTValidationError.Value = True
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_The_Vector_Type.InnerText") & " " & txtVTstrName.Text.Trim() & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
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

    Protected Sub btnDeleteYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteYes.ServerClick
        Try
            log.Info("Vector Type reference deletion begins.")
            Dim id As Int64 = Convert.ToInt64(hdfVTidfsVectorType.Value)
            Dim results As String = vectorTypeAPIClient.RefVectorTypeDel(id, False).Result(0).ReturnMessage
            If results = "IN USE" Then
                lbl_Delete_Anyway.InnerText = GetLocalResourceObject("lbl_The_Vector_Type.InnerText") & " " & hdfVTstrName.Value & " " & GetLocalResourceObject("lbl_In_Use.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('currentlyInUseModal');});", True)
                Exit Sub
            Else
                PopulateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Vector_Type.InnerText") & " " & hdfVTstrName.Value & GetLocalResourceObject("lbl_Period.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                Exit Sub
            End If
            log.Info("Vector Type reference deletion complete.")
        Catch ex As Exception
            log.Error("Vector Type reference deletion error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub btnDeleteAnywayYes_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDeleteAnywayYes.ServerClick
        Try
            log.Info("Vector Type reference delete anyway begins.")
            Dim id As Int64 = Convert.ToInt64(hdfVTidfsVectorType.Value)
            'vectorTypeAPIClient.RefCaseClassificationDel(id, True)
            PopulateGrid()
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Delete_Vector_Type.InnerText") & " " & hdfVTstrName.Value
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('suVTessModal');});", True)
            log.Info("Vector Type reference delete anyway complete.")
        Catch ex As Exception
            log.Error("Vector Type reference delete anyway error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub
    Protected Sub btnErrorOK_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnErrorOK.ServerClick
        log.Info("Vector Type creator modal opener begins")
        If hdfVTValidationError.Value Then
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('addVectorType');});", True)
        End If
        log.Info("Vector Type creator modal opener complete")
    End Sub

    Protected Sub btnCancelVectorType_ServerClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnCancelVectorType.ServerClick
        clearVTForm()
    End Sub
#End Region


#Region "grid view"
    Protected Sub gvVectorTypes_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvVectorTypes.PageIndexChanging
        Try
            log.Info("Vector Type reference editor record paging begins.")
            gvVectorTypes.PageIndex = e.NewPageIndex
            PopulateGrid()
            log.Info("Vector Type reference editor record paging complete.")
        Catch ex As Exception
            log.Error("Vector Type reference editor record paging error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Page_Index_Change.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Protected Sub gvVectorTypes_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvVectorTypes.Sorting
        Try
            log.Info("Vector Type reference editor record sort begins.")
            sorting(e.SortExpression, e.SortDirection)
            log.Info("Vector Type reference editor record sort complete.")
        Catch ex As Exception
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Sorting.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvVectorTypes_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvVectorTypes.RowCancelingEdit
        Try
            log.Info("Vector Type reference editor return to regular mode begins.")
            gvVectorTypes.EditIndex = -1
            PopulateGrid()
            log.Info("Vector Type reference editor return to regular mode complete.")
        Catch ex As Exception
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Cancel_Edit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvVectorTypes_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvVectorTypes.RowEditing
        Try
            log.Info("Vector Type reference editor convert to edit mode begins.")
            gvVectorTypes.EditIndex = e.NewEditIndex
            PopulateGrid()
            log.Info("Vector Type reference editor convert to edit mode complete.")
        Catch ex As Exception
            log.Error("Error convert to edit mode Vector Type reference editor records: " & ex.Message)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Edit_Mode.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvVectorTypes_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvVectorTypes.RowUpdating
        Try
            log.Info("Vector Type reference editor update begins.")
            hdfVTValidationError.Value = False
            Dim gvr As GridViewRow = gvVectorTypes.Rows(e.RowIndex)
            Dim VTParams As RefVectorTypeSetParams = New RefVectorTypeSetParams()

            Dim idfsBaseReference As Int64 = Convert.ToInt64(gvVectorTypes.DataKeys(e.RowIndex).Values("idfsVectorType"))
            VTParams.idfsVectorType = idfsBaseReference

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

            Dim chkbitCollectionByPool As CheckBox = gvr.FindControl("chkbitCollectionByPool")
            If Not IsNothing(chkbitCollectionByPool) Then
                VTParams.bitCollectionByPool = chkbitCollectionByPool.Checked
            Else
                VTParams.bitCollectionByPool = False
            End If

            Dim results As String = vectorTypeAPIClient.RefVectorTypeSet(VTParams).Result(0).ReturnMessage

            If results = "SUCCESS" Then
                gvVectorTypes.EditIndex = -1
                PopulateGrid()
                lblSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Vector_Type.InnerText") & " " & txtstrName.Text & "."
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successModal');});", True)
                clearVTForm()
                log.Info("Vector Type reference editor update complete.")
            ElseIf results = "DOES EXIST" Then
                lbl_Error.InnerText = GetLocalResourceObject("lbl_The_Vector_Type.InnerText") & " " & txtstrDefault.Text.Trim() & " " & GetLocalResourceObject("lbl_Or.InnerText") & " " & txtstrName.Text.Trim() & " " & GetLocalResourceObject("lbl_Already_Exists.InnerText")
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
                log.Info("Vector Type reference already exists.")
            End If
        Catch ex As Exception
            log.Error("Vector Type reference editor update error", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Save.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

    Private Sub gvVectorTypes_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvVectorTypes.RowDeleting
        Try
            log.Info("Vector Type reference editor delete information gathering begins.")
            Dim id As Double = gvVectorTypes.DataKeys(e.RowIndex)("idfsVectorType")
            hdfVTidfsVectorType.Value = id
            Dim lblstrName As Label = gvVectorTypes.Rows(e.RowIndex).FindControl("lblstrName")

            If Not IsNothing(lblstrName) Then
                hdfVTstrName.Value = lblstrName.Text
            End If

            lbl_Delete.InnerText = GetLocalResourceObject("lbl_Vector_Type_Question_Delete.InnerText") & " " & hdfVTstrName.Value & GetLocalResourceObject("lbl_Question_Mark.InnerText") & " " & GetLocalResourceObject("lbl_Cannot_Be_Undone,InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('deleteModal');});", True)
            log.Info("Vector Type reference editor delete information gathering complete.")
        Catch ex As Exception
            log.Error("Vector Type reference editor delete information gathering error", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Retrieving_Delete_Information.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try
    End Sub

#End Region


    Private Sub PopulateGrid()
        gvVectorTypes.DataSource = vectorTypeAPIClient.RefVectorTypeGetList(language).Result
        gvVectorTypes.DataBind()
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
        Dim ds As List(Of RefVectortypereferenceGetListModel) = vectorTypeAPIClient.RefVectorTypeGetList(language).Result.ToList()
        If sortDirection = SortDirection.Ascending Then
            If sortField = "strDefault" Then
                gvVectorTypes.DataSource = (From d In ds
                                            Order By d.strDefault).ToList()
            ElseIf sortField = "strName" Then
                gvVectorTypes.DataSource = (From d In ds
                                            Order By d.strName).ToList()
            ElseIf sortField = "intOrder" Then
                gvVectorTypes.DataSource = (From d In ds
                                            Order By d.intOrder).ToList()
            End If
        Else
            If sortField = "strDefault" Then
                gvVectorTypes.DataSource = (From d In ds
                                            Order By d.strDefault Descending).ToList()
            ElseIf sortField = "strName" Then
                gvVectorTypes.DataSource = (From d In ds
                                            Order By d.strName Descending).ToList()
            ElseIf sortField = "intOrder" Then
                gvVectorTypes.DataSource = (From d In ds
                                            Order By d.intOrder Descending).ToList()
            End If
        End If

        If sortFieldChanged Then
            gvVectorTypes.PageIndex = 0
        End If
        gvVectorTypes.DataBind()
    End Sub

    Private Sub clearVTForm()
        hdfVTidfsVectorType.Value = "NULL"
        hdfVTValidationError.Value = False
        hdfVTstrName.Value = "NULL"
        txtVTstrName.Text = String.Empty
        txtVTstrDefault.Text = String.Empty
        txtVTintOrder.Text = String.Empty
        txtVTstrCode.Text = String.Empty
        chkVTbitCollectionByPool.Checked = False
    End Sub
End Class