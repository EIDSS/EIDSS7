Imports System.IO
Imports System.Xml.Serialization
Imports EIDSS.EIDSS

Public Class SettlementAdmin
    Inherits BaseEidssPage

    Public sFile As String
    Dim oEIDSSDS As DataSet = Nothing
    Private oComm As clsCommon = New clsCommon()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        hdfLangID.Value = PageLanguage

        If Not Page.IsPostBack() Then

            'Stores the data set
            ViewState(CallerPages.SettlementAdmin) = Nothing

            'Assign defaults from current user data
            Dim sUserSettingsFile As String = oComm.CreateTempFile(GlobalConstants.UserSettingsFilePrefix)
            oEIDSSDS = oComm.ReadEIDSSXML(sUserSettingsFile)
            If oEIDSSDS.CheckDataSet() Then
                hdfidfUserID.Value = oEIDSSDS.Tables(0).Rows(0).Item("hdfidfUserID") & ""
            End If

            'Get search filters
            sFile = oComm.CreateTempFile(hdfidfUserID.Value.ToString(), CallerPages.SettlementAdminPrefix)
            oComm.GetSearchFields({searchUpdatePanel}, sFile)

            Dim oSType As clsSettlementType = New clsSettlementType()
            Dim oDS As DataSet = oSType.ListAll()
            If oDS.CheckDataSet() Then
                ddlSettlementType.Populate(oDS.Tables(0), "name", "idfsReference", True)
            End If


            FillSettlementGrid(True)

        End If

    End Sub

#Region "Methods"

    Private Sub AssignGeoValues()

        'initialize to NULL
        hdfidfsRegion.Value = "NULL"
        hdfidfsRayon.Value = "NULL"
        hdfidfsRegion.Value = IIf(Not IsValueNullOrEmpty(LUCSettlement.SelectedRegionValue) And LUCSettlement.SelectedRegionValue <> "-1", LUCSettlement.SelectedRegionValue, "NULL")
        hdfidfsRayon.Value = IIf(Not IsValueNullOrEmpty(LUCSettlement.SelectedRayonValue) And LUCSettlement.SelectedRayonValue <> "-1", LUCSettlement.SelectedRayonValue, "NULL")

    End Sub

    Private Sub FillSettlementGrid(Optional bRefresh As Boolean = False)

        Dim oSettlementAdmin As clsSettlement = Nothing
        Dim oDS As DataSet

        Try
            If IsNothing(ViewState(CallerPages.SettlementAdmin)) OrElse bRefresh Then

                'store int values for Region & Rayon
                AssignGeoValues()

                Dim aSP As String()
                Dim formValues As String = ""

                aSP = oComm.GetSPList(EIDSSModules.Settlement)
                formValues = oComm.Gather(searchUpdatePanel, aSP(SPType.SPGetList).ToString(), 3, True)

                oSettlementAdmin = New clsSettlement()
                oDS = oSettlementAdmin.ListData({formValues})
            Else
                oDS = ViewState(CallerPages.SettlementAdmin)
            End If

            oDS.CheckDataSet()

            ViewState(CallerPages.SettlementAdmin) = oDS

            With gvSettlementList
                .DataSource = oDS.Tables(0)
                .DataBind()
                .SelectedIndex = -1
            End With

        Catch ex As Exception

            Throw

        Finally

            'Clean objects
            oSettlementAdmin = Nothing
            oDS = Nothing

        End Try

    End Sub

    Private Sub CallSettlementDetails()

        oComm.SaveSearchFields({divHiddenFieldsSection}, CallerPages.SettlementAdmin, "")
        Response.Redirect(GetURL(CallerPages.SettlementDetailsURL), True)

    End Sub

    Private Function GetSortDirection(ByVal column As String) As String

        ' By default, set the sort direction to ascending.
        Dim sortDirection = "ASC"

        ' Retrieve the last column that was sorted.
        Dim sortExpression = TryCast(ViewState("SortExpression"), String)

        If sortExpression IsNot Nothing Then
            ' Check if the same column is being sorted.
            ' Otherwise, the default value can be returned.
            If sortExpression = column Then
                Dim lastDirection = TryCast(ViewState("SortDirection"), String)
                If lastDirection IsNot Nothing _
                  AndAlso lastDirection = "ASC" Then

                    sortDirection = "DESC"

                End If
            End If
        End If

        ' Save new values in ViewState.
        ViewState("SortDirection") = sortDirection
        ViewState("SortExpression") = column

        Return sortDirection

    End Function

#End Region

#Region "Grid Events"

    Private Sub gvSettlementList_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvSettlementList.PageIndexChanging

        gvSettlementList.PageIndex = e.NewPageIndex
        FillSettlementGrid()

    End Sub

    Protected Sub gvSettlementList_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSettlementList.RowCommand

        If e.CommandName.ToUpper().EqualsAny("SELECT,EDIT,DELETE".Split(",")) Then

            Dim idx As Integer = Convert.ToInt32(e.CommandArgument)
            Dim row As GridViewRow = gvSettlementList.Rows(idx)

            With gvSettlementList.DataKeys(idx)
                hdfidfsSettlement.Value = .Values(SettlementConstants.idfsSettlement)

                hdfUniqueCodeID.Value = .Values(SettlementConstants.idfsSettlementID)
                hdfSettlementName.Value = .Values(SettlementConstants.SettlementName)
                hdfNationalName.Value = .Values(SettlementConstants.NationalSettlement)   ' Need to add NAtional Name to 

            End With
        End If

    End Sub

    Private Sub gvSettlementList_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvSettlementList.RowDeleting

        If Not IsNothing(ViewState(CallerPages.SettlementAdmin)) Then
            Dim oSettlement = New clsSettlement
            oSettlement.Delete(Double.Parse(hdfidfsSettlement.Value))
            FillSettlementGrid(True)
        End If

    End Sub

    Private Sub gvSettlementList_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvSettlementList.RowEditing

        e.Cancel = True
        CallSettlementDetails()

    End Sub

    Protected Sub gvSettlementList_Sorting(sender As Object, e As GridViewSortEventArgs)

        Dim oDS As DataSet
        oDS = ViewState("SettlementList")

        Dim dt As DataTable = oDS.Tables(0)

        If Not IsNothing(dt) Then
            dt.DefaultView.Sort = e.SortExpression + " " + GetSortDirection(e.SortExpression)
            gvSettlementList.DataSource = ViewState("SettlementList")
            gvSettlementList.DataBind()
        End If

    End Sub

#End Region

#Region "Button Click Events"

    'Protected Sub btnNew_Click(sender As Object, e As EventArgs)

    '    hdfidfsSettlement.Value = 0 '
    '    Response.Redirect(GetURL(CallerPages.SettlementDetailsURL), True)

    'End Sub

    Protected Sub btnNew_ServerClick(sender As Object, e As EventArgs) Handles btnNew.ServerClick

        hdfidfsSettlement.Value = -1

        CallSettlementDetails()

    End Sub

    Private Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click

        sFile = oComm.CreateTempFile(hdfidfUserID.Value.ToString(), CallerPages.SettlementAdminPrefix)

        oComm.DeleteTempFiles(sFile)
        oComm.ResetForm(searchUpdatePanel)

        FillSettlementGrid(True)

    End Sub

    Private Sub ddlSettlementType_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlSettlementType.SelectedIndexChanged

        If ddlSettlementType.SelectedIndex > 0 Then hdfidfsSettlementType.Value = ddlSettlementType.SelectedValue

    End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs)

        sFile = oComm.CreateTempFile(hdfidfUserID.Value.ToString(), CallerPages.SettlementAdminPrefix)
        'Save search fields
        oComm.SaveSearchFields({searchUpdatePanel}, CallerPages.SettlementAdmin, sFile)

        FillSettlementGrid(True)

    End Sub

#End Region

    Private Sub SettlementAdmin_Error(sender As Object, e As EventArgs) Handles Me.[Error]

        Dim exc As Exception = Server.GetLastError()

        If (TypeOf exc Is HttpUnhandledException) Then

            ASPNETMsgBox("An error occurred on this page. Please verify your information to resolve the issue.")

        Else
            'Pass the error on to the error page.
            Dim delimiter As Char = "/"
            Dim sHandler As String() = Request.ServerVariables("SCRIPT_NAME").Split(delimiter)
            Server.Transfer("~/GeneralError.aspx?handler=" & sHandler.Last.ToString().Replace(".aspx", "") & "_Error%20-%20Default.aspx&aspxerrorpath=" & Me.GetType.Name, True)
        End If

        'Clear the error from the server.
        Server.ClearError()

    End Sub

End Class