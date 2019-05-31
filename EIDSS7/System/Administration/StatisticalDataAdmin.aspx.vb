Imports EIDSS.EIDSS
Imports System.IO
Imports System.Xml.Serialization
Imports System.Data
Imports EIDSS.NG
Imports System.Web.UI
Imports System
Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports EIDSS.Client.Responses
Imports EIDSS.Client.Enumerations
Imports Newtonsoft.Json

Public Class StatisticalDataAdmin
    Inherits BaseEidssPage

    Dim sFile As String
    Dim oEIDSSDS As DataSet = Nothing
    Private oComm As clsCommon = New clsCommon()
    Private StatisticDataTypeServiceClient As StatisticDataTypeServiceClient


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        hdfLangID.Value = PageLanguage

        If Not Page.IsPostBack() Then

            'Stores the data set
            ViewState(CallerPages.StatDataAdmin) = Nothing

            'Get User defaults
            Dim sUserSettingsFile As String = oComm.CreateTempFile(GlobalConstants.UserSettingsFilePrefix)
            oEIDSSDS = oComm.ReadEIDSSXML(sUserSettingsFile)
            If oEIDSSDS.CheckDataSet() Then
                hdfidfUserID.Value = oEIDSSDS.Tables(0).Rows(0).Item("hdfidfUserID") & ""
            End If

            'Populate Statisitic Type
            FillDropDown(ddlidfsStatisticalDataType, GetType(clsStatisticType),
                         Nothing,
                         "idfsStatisticDataType",
                         "strName",
                         Nothing,
                         Nothing,
                         True)

            'Get search filters
            sFile = oComm.CreateTempFile(hdfidfUserID.Value.ToString(), CallerPages.StatDataAdminPrefix)
            oComm.GetSearchFields({SearchUpdatePanel}, sFile)

            'Populate the grid
            FillStatisticalDataList(True)

        End If

    End Sub

#Region "Methods"

    Private Sub FillStatisticalDataList(Optional bRefresh As Boolean = False)

        Dim oStatDataAdmin As clsStatisticalData = Nothing
        Dim oDS As New DataSet

        Try

            If (ViewState(CallerPages.StatDataAdmin) Is Nothing) OrElse (bRefresh) Then

                AssignArea()

                hdfStatisticalDataType.Value = If(String.IsNullOrEmpty(ddlidfsStatisticalDataType.Text), "null", ddlidfsStatisticalDataType.Text)
                hdfStatisticalStartDateFrom.Value = If(Not String.IsNullOrEmpty(txtdatStatisticStartDateFrom.Text), txtdatStatisticStartDateFrom.Text, "null")
                hdfStatisticalStartDateTo.Value = If(Not String.IsNullOrEmpty(txtdatStatisticStartDateTo.Text), txtdatStatisticStartDateTo.Text, "null")

                If StatisticDataTypeServiceClient Is Nothing Then
                    StatisticDataTypeServiceClient = New StatisticDataTypeServiceClient()
                End If

                Dim list As List(Of AdminStatGetListModel) = Nothing

                If hdfidfsArea.Value = "null" Then

                    If hdfStatisticalStartDateFrom.Value = "null" Then
                        If hdfStatisticalDataType.Value = "null" Then
                            list = StatisticDataTypeServiceClient.StatGetList(GetCurrentLanguage(), Nothing, Nothing, Nothing, Nothing).Result
                        Else
                            list = StatisticDataTypeServiceClient.StatGetList(GetCurrentLanguage(), Int64.Parse(hdfStatisticalDataType.Value), Nothing, Nothing, Nothing).Result

                        End If
                    Else
                        hdfStatisticalStartDateTo.Value = If(Not hdfStatisticalStartDateTo.Value = "null", hdfStatisticalStartDateTo.Value, DateTime.Now.ToShortDateString)
                        If hdfStatisticalDataType.Value = "null" Then
                            list = StatisticDataTypeServiceClient.StatGetList(GetCurrentLanguage(), Nothing, If(hdfStatisticalDataType.Value = "null", Nothing, Int64.Parse(hdfStatisticalDataType.Value)), DateTime.Parse(hdfStatisticalStartDateFrom.Value), DateTime.Parse(hdfStatisticalStartDateTo.Value)).Result

                        Else
                            list = StatisticDataTypeServiceClient.StatGetList(GetCurrentLanguage(), Int64.Parse(hdfStatisticalDataType.Value), If(hdfStatisticalDataType.Value = "null", Nothing, Int64.Parse(hdfStatisticalDataType.Value)), DateTime.Parse(hdfStatisticalStartDateFrom.Value), DateTime.Parse(hdfStatisticalStartDateTo.Value)).Result

                        End If
                    End If

                Else

                    If hdfStatisticalStartDateFrom.Value = "null" Then
                        If hdfStatisticalDataType.Value = "null" Then
                            list = StatisticDataTypeServiceClient.StatGetList(GetCurrentLanguage(), Nothing, Int64.Parse(hdfidfsArea.Value), Nothing, Nothing).Result
                        Else
                            list = StatisticDataTypeServiceClient.StatGetList(GetCurrentLanguage(), Int64.Parse(hdfStatisticalDataType.Value), Int64.Parse(hdfidfsArea.Value), Nothing, Nothing).Result
                        End If

                    Else
                        hdfStatisticalStartDateTo.Value = If(Not hdfStatisticalStartDateTo.Value = "null", hdfStatisticalStartDateTo.Value, DateTime.Now.ToShortDateString)
                        If hdfStatisticalDataType.Value = "null" Then
                            list = StatisticDataTypeServiceClient.StatGetList(GetCurrentLanguage(), Nothing, Int64.Parse(hdfidfsArea.Value), DateTime.Parse(hdfStatisticalStartDateFrom.Value), DateTime.Parse(hdfStatisticalStartDateTo.Value)).Result
                        Else
                            list = StatisticDataTypeServiceClient.StatGetList(GetCurrentLanguage(), Int64.Parse(hdfStatisticalDataType.Value), Int64.Parse(hdfidfsArea.Value), DateTime.Parse(hdfStatisticalStartDateFrom.Value), DateTime.Parse(hdfStatisticalStartDateTo.Value)).Result
                        End If

                    End If

                End If
                oDS.Tables.Add(ConvertListToDataTable(list))


            Else
                oDS = ViewState(CallerPages.StatDataAdmin)
            End If

            oDS.CheckDataSet()

            ViewState(CallerPages.StatDataAdmin) = oDS

            With gvStatisticalDataList
                .DataSource = oDS.Tables(0)
                .DataBind()
                .SelectedIndex = -1
            End With

        Catch ex As Exception

            Throw

        Finally

            'Clean objects
            oStatDataAdmin = Nothing
            oDS = Nothing

        End Try

    End Sub


    Private Sub AssignArea()

        'initialize
        hdfidfsArea.Value = "null"

        If Not IsValueNullOrEmpty(LocationUserControl.SelectedCountryValue) And Not LocationUserControl.SelectedCountryValue = "-1" Then
            hdfidfsArea.Value = LocationUserControl.SelectedCountryValue
        End If

        If Not IsValueNullOrEmpty(LocationUserControl.SelectedRegionValue) And Not LocationUserControl.SelectedRegionValue = "-1" Then
            hdfidfsArea.Value = LocationUserControl.SelectedRegionValue
        End If

        If Not IsValueNullOrEmpty(LocationUserControl.SelectedRayonValue) And Not LocationUserControl.SelectedRayonValue = "-1" Then
            hdfidfsArea.Value = LocationUserControl.SelectedRayonValue
        End If

        If Not IsValueNullOrEmpty(LocationUserControl.SelectedSettlementValue) And Not LocationUserControl.SelectedSettlementValue = "-1" Then
            hdfidfsArea.Value = LocationUserControl.SelectedSettlementValue
        End If

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

    Private Sub CallStatisticalDetails()

        oComm.SaveSearchFields({divHiddenFieldsSection}, CallerPages.StatDataAdmin, "")
        Response.Redirect(GetURL(CallerPages.StatDataDetailsURL), True)

    End Sub

#End Region

#Region "Grid Events"

    Private Sub gvStatisticalDataList_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvStatisticalDataList.PageIndexChanging

        gvStatisticalDataList.PageIndex = e.NewPageIndex
        FillStatisticalDataList()

    End Sub

    Private Sub gvStatisticalDataList_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvStatisticalDataList.RowCommand

        If e.CommandName.ToUpper().EqualsAny("SELECT,EDIT,DELETE".Split(",")) Then

            Dim idx As Integer = Convert.ToInt32(e.CommandArgument)
            Dim row As GridViewRow = gvStatisticalDataList.Rows(idx)

            'Set the values of selected row in hidden fields
            With gvStatisticalDataList.DataKeys(idx)
                hdfidfStatistic.Value = .Values(StatisticTypes.idfStatisticData)
                hdfStatisticalDataType.Value = .Values(StatisticTypes.idfsStatTypeData)
                hdfStatisticalStartDate.Value = .Values(StatisticTypes.StatStartDate)
            End With
        End If

    End Sub

    Private Sub gvStatisticalDataList_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvStatisticalDataList.RowEditing

        e.Cancel = True
        CallStatisticalDetails()

    End Sub

    Private Sub gvStatisticalDataList_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvStatisticalDataList.RowDeleting

        If Not IsNothing(hdfidfStatistic.Value) Then
            Dim oStat = New clsStatisticalData
            oStat.Delete(Double.Parse(hdfidfStatistic.Value))
            FillStatisticalDataList(True)

            oStat = Nothing
        End If

    End Sub

    Protected Sub gvStatisticalDataList_Sorting(sender As Object, e As GridViewSortEventArgs)
        Dim oDS As DataSet
        oDS = ViewState("StatisticalDataList")

        Dim dt As DataTable = oDS.Tables(0)

        If Not IsNothing(dt) Then
            Dim sortDir As String = GetSortDirection(e.SortExpression)
            dt.DefaultView.Sort = e.SortExpression + " " + sortDir
            gvStatisticalDataList.DataSource = ViewState("StatisticalDataList")
            gvStatisticalDataList.DataBind()
        End If
    End Sub

#End Region

#Region "Control Click Events"

    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSearch.Click

        sFile = oComm.CreateTempFile(hdfidfUserID.Value.ToString(), CallerPages.StatDataAdminPrefix)
        'Save search fields
        oComm.SaveSearchFields({SearchUpdatePanel}, CallerPages.StatDataAdmin, sFile)

        FillStatisticalDataList(True)

    End Sub

    Protected Sub btnNew_ServerClick(sender As Object, e As EventArgs) Handles btnNew.ServerClick

        hdfidfStatistic.Value = -1
        CallStatisticalDetails()

    End Sub

    Private Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click

        sFile = oComm.CreateTempFile(hdfidfUserID.Value.ToString(), CallerPages.StatDataAdminPrefix)
        oComm.DeleteTempFiles(sFile)
        oComm.ResetForm(SearchUpdatePanel)

        FillStatisticalDataList(True)

    End Sub

#End Region

    Private Sub StatisticalDataAdmin_Error(sender As Object, e As EventArgs) Handles Me.[Error]

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