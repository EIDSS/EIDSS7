Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports EIDSSControlLibrary
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class SearchHumanDiseaseReportUserControl
    Inherits UserControl

#Region "Global Values"

    Private userSettingsFile As String

    Private Const SectionSearchCriteria As String = "Search Criteria"
    Private Const SectionSearchResults As String = "Search Results"
    Private Const PAGE_KEY As String = "Page"
    Private Const HIDE_SEARCH_CRITERIA_SCRIPT As String = "hideHumanDiseaseReportSearchCriteria();"
    Private Const SHOW_SEARCH_CRITERIA_SCRIPT As String = "showHumanDiseaseReportSearchCriteria();"
    Private Const SESSION_HUMAN_DISEASE_REPORT_LIST As String = "gvHumanDiseaseReports_List"
    Private Const SORT_DIRECTION As String = "gvHumanDiseaseReports_SortDirection"
    Private Const SORT_EXPRESSION As String = "gvHumanDiseaseReports_SortExpression"
    Private Const PAGINATION_SET_NUMBER As String = "gvHumanDiseaseReports_PaginationSet"

    Public Event ValidatePage()
    Public Event ShowWarningModal(messageType As MessageType, isConfirm As Boolean)
    Public Event CreateHumanDiseaseReport()
    Public Event CancelHumanDiseaseReport()
    Public Event DeleteHumanDiseaseReport(humanDiseaseReportID As Long)
    Public Event EditHumanDiseaseReport(humanDiseaseReportID As Long)
    Public Event SelectHumanDiseaseReport(humanDiseaseReportID As Long, eidssReportID As String, diseaseID As Long?, patientID As Long?, patientName As String)

    Private HumanAPIService As HumanServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(SearchHumanDiseaseReportUserControl))

#End Region

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        Try
            If (Not IsPostBack) Then
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="selectMode"></param>
    Public Sub Setup(Optional selectMode As SelectModes = SelectModes.Label)

        Try
            'Assign defaults from current user data.
            hdfidfUserID.Value = Session("UserID")
            hdfidfInstitution.Value = Session("Institution")

            'ucLocation.Setup()

            Reset()

            ExtractViewStateSession()

            FillForm()

            hdfSelectMode.Value = selectMode

            'Changing visibility of some functions, depending on situation
            'Leaving this case open for future expansion...if necessary.
            Select Case selectMode
                Case SelectModes.Selection
                    btnAddHumanDiseaseReport.Visible = False
                Case Else
            End Select

            Dim parameters = New HumanDiseaseGetListParams()
            Scatter(divHumanDiseaseReportSearchUserControlCriteria, ReadSearchCriteriaJSON(parameters, CreateTempFile(ID)), 3)

            upSearchHumanDiseaseReport.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
        Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub Reset()

        ResetForm(divHumanDiseaseReportSearchUserControlCriteria)
        ResetForm(ucLocation)

        ViewState(SORT_DIRECTION) = SortConstants.Descending
        ViewState(SORT_EXPRESSION) = "EIDSSReportID"
        ViewState(PAGINATION_SET_NUMBER) = 1

        ToggleVisibility(SectionSearchCriteria)

        'Restore search filters
        userSettingsFile = CreateTempFile(hdfidfUserID.Value.ToString(), ID)

        txtEIDSSReportID.Focus()

        gvHumanDiseaseReports.PageSize = ConfigurationManager.AppSettings("PageSize")

    End Sub

#End Region

#Region "Common Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ExtractViewStateSession()

        Try
            Dim nvcViewState As NameValueCollection = GetViewState(True)

            If Not nvcViewState Is Nothing Then
                For Each key As String In nvcViewState.Keys
                    ViewState(key) = nvcViewState.Item(key)
                Next
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="section"></param>
    Private Sub ToggleVisibility(ByVal section As String)

        divHumanDiseaseReportSearchResults.Visible = section.Equals(SectionSearchResults)
        toggleIcon.Visible = section.Equals(SectionSearchResults)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillForm()

        FillBaseReferenceDropDownList(ddlDiseaseID, BaseReferenceConstants.Diagnosis, HACodeList.HumanHACode, True)
        FillBaseReferenceDropDownList(ddlReportStatusTypeID, BaseReferenceConstants.CaseStatus, HACodeList.HumanHACode, True)
        FillBaseReferenceDropDownList(ddlClassificationTypeID, BaseReferenceConstants.CaseClassification, HACodeList.HumanHACode, True)
        FillBaseReferenceDropDownList(ddlHospitalizationStatusTypeId, BaseReferenceConstants.PatientLocationType, HACodeList.HumanHACode, True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Private Function ValidateForSearch() As Boolean

        Dim validated As Boolean = False

        validated = (Not txtEIDSSReportID.Text.IsValueNullOrEmpty())

        If Not validated Then
            Dim controls As New List(Of Control)

            controls.Clear()
            For Each txt As TextBox In FindControlList(controls, divHumanDiseaseReportSearchUserControlCriteria, GetType(TextBox))
                If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
            Next

            If Not validated Then
                controls.Clear()
                For Each ddl As WebControls.DropDownList In FindControlList(controls, divHumanDiseaseReportSearchUserControlCriteria, GetType(WebControls.DropDownList))
                    If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each ddl As DropDownList In FindControlList(controls, divHumanDiseaseReportSearchUserControlCriteria, GetType(DropDownList))
                    If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each txt As CalendarInput In FindControlList(controls, divHumanDiseaseReportSearchUserControlCriteria, GetType(CalendarInput))
                    If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
                Next
            End If

            If validated And (txtHumanDiseaseReportDateEnteredFrom.Text.Length > 0 Or txtHumanDiseaseReportDateEnteredTo.Text.Length > 0) Then
                validated = ValidateFromToDates(txtHumanDiseaseReportDateEnteredFrom.Text, txtHumanDiseaseReportDateEnteredTo.Text)
                If Not validated Then
                    ASPNETMsgBox(GetLocalResourceObject("Msg_Dates_Are_Invalid"))
                    txtHumanDiseaseReportDateEnteredFrom.Focus()
                End If
            End If
        End If

        If validated Then
            ToggleVisibility(SectionSearchResults)
        Else
            RaiseEvent ShowWarningModal(MessageType.SearchCriteriaRequired, False)
            txtEIDSSReportID.Focus()
        End If

        Return validated

    End Function

#End Region

#Region "Search Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Search_Click(sender As Object, e As EventArgs) Handles btnSearch.Click

        Try
            If ValidateForSearch() Then
                Dim parameters As New HumanDiseaseReportGetListParams With {.LanguageID = GetCurrentLanguage()}
                Dim controls As New List(Of Control)
                controls.Clear()
                'For Each ddl As DropDownList In FindControlList(controls, ucLocation, GetType(DropDownList))
                '    If ddl.ClientID.Contains("ddlucLocationidfsRegion") = True Then
                '        If Not ddl.SelectedValue = "null" Then
                '            parameters.RegionID = CType(ddl.SelectedValue, Long)
                '        End If
                '    End If

                '    If ddl.ClientID.Contains("ddlucLocationidfsRayon") = True Then
                '        If Not ddl.SelectedValue = "null" And Not ddl.SelectedValue = "" Then
                '            parameters.RayonID = CType(ddl.SelectedValue, Long)
                '        End If
                '    End If
                'Next
                If HumanAPIService Is Nothing Then
                    HumanAPIService = New HumanServiceClient()
                End If
                Dim list = HumanAPIService.GetHumanDiseaseReportListCountAsync(Gather(divHumanDiseaseReportSearchUserControlCriteria, parameters, 3)).Result
                lblNumberOfRecords.Text = list.Item(0).RecordCount
                lblPageNumber.Text = "1"
                FillHumanDiseaseReportList(pageIndex:=1, paginationSetNumber:=1)
                gvHumanDiseaseReports.PageIndex = 0
                SaveSearchCriteriaJSON(parameters, CreateTempFile(ID))
                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, HIDE_SEARCH_CRITERIA_SCRIPT, True)
                ToggleVisibility(SectionSearchResults)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub AddHumanDiseaseReport_Click() Handles btnAddHumanDiseaseReport.Click

        Try
            RaiseEvent CreateHumanDiseaseReport()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub HumanDiseaseReports_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvHumanDiseaseReports.Sorting

        Try
            ViewState(SORT_DIRECTION) = IIf(ViewState(SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(SORT_EXPRESSION) = e.SortExpression

            BindGridView()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Clear_Click(sender As Object, e As EventArgs) Handles btnClear.Click

        Try
            Reset()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Cancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click

        Try

            Dim sm As SelectModes = CType(hdfSelectMode.Value, SelectModes)

            If (sm = SelectModes.Selection) Then
                RaiseEvent CancelHumanDiseaseReport()
            End If

            SaveEIDSSViewState(ViewState)

            RaiseEvent ShowWarningModal(MessageType.CancelSearchConfirm, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub HumanDiseaseReports_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvHumanDiseaseReports.RowCommand

        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.DeleteCommand
                        RaiseEvent DeleteHumanDiseaseReport(e.CommandArgument)
                    Case GridViewCommandConstants.EditCommand
                        RaiseEvent EditHumanDiseaseReport(e.CommandArgument)
                    Case GridViewCommandConstants.SelectCommand
                        Dim commandArguments As String() = e.CommandArgument.ToString().Split(",")
                        RaiseEvent SelectHumanDiseaseReport(commandArguments(0), commandArguments(1), commandArguments(2), commandArguments(3), commandArguments(4))
                End Select
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    Private Sub FillHumanDiseaseReportList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            Dim list = New List(Of HumDiseaseReportGetListModel)()

            Dim parameters As HumanDiseaseReportGetListParams
            parameters = New HumanDiseaseReportGetListParams()
            Dim controls As New List(Of Control)
            controls.Clear()
            'For Each ddl As DropDownList In FindControlList(controls, ucLocation, GetType(DropDownList))
            '    If ddl.ClientID.Contains("ddlucLocationidfsRegion") = True Then
            '        If Not ddl.SelectedValue = GlobalConstants.NullValue Then
            '            parameters.RegionID = CType(ddl.SelectedValue, Long)
            '        End If
            '    End If

            '    If ddl.ClientID.Contains("ddlucLocationidfsRayon") = True Then
            '        If Not ddl.SelectedValue = GlobalConstants.NullValue And Not ddl.SelectedValue = "" Then
            '            parameters.RayonID = CType(ddl.SelectedValue, Long)
            '        End If
            '    End If
            'Next
            parameters = Gather(Me, parameters, 3)
            parameters.PaginationSetNumber = paginationSetNumber
            parameters.LanguageID = GetCurrentLanguage()

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If
            list = HumanAPIService.GetHumanDiseaseReportListAsync(parameters).Result
            Session(SESSION_HUMAN_DISEASE_REPORT_LIST) = list
            BindGridView()
            FillPager(lblNumberOfRecords.Text, pageIndex)
            ViewState(PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        'Calculate the start and end index of pages to be displayed.
        Dim dblPageCount As Double = recordCount / Convert.ToDecimal(10)
        Dim pageCount As Integer = Math.Ceiling(dblPageCount)
        startIndex = If(currentPage > 1 AndAlso currentPage + pagerSpan - 1 < pagerSpan, currentPage, 1)
        endIndex = If(pageCount > pagerSpan, pagerSpan, pageCount)
        If currentPage > pagerSpan Mod 2 Then
            If currentPage = 2 Then
                endIndex = 5
            Else
                endIndex = currentPage + 2
            End If
        Else
            endIndex = (pagerSpan - currentPage) + 1
        End If

        If endIndex - (pagerSpan - 1) > startIndex Then
            startIndex = endIndex - (pagerSpan - 1)
        End If

        If endIndex > pageCount Then
            endIndex = pageCount
            startIndex = If(((endIndex - pagerSpan) + 1) > 0, (endIndex - pagerSpan) + 1, 1)
        End If

        'Add the First Page Button.
        If currentPage > 1 Then
            pages.Add(New ListItem(PagingConstants.FirstButtonText, "1"))
        End If

        'Add the Previous Button.
        If currentPage > 1 Then
            pages.Add(New ListItem(PagingConstants.PreviousButtonText, (currentPage - 1).ToString()))
        End If

        Dim paginationSetNumber As Integer = 1,
            pageCounter As Integer = 1

        For i As Integer = startIndex To endIndex
            pages.Add(New ListItem(i.ToString(), i.ToString(), i <> currentPage))
        Next

        'Add the Next Button.
        If currentPage < pageCount Then
            pages.Add(New ListItem(PagingConstants.NextButtonText, (currentPage + 1).ToString()))
        End If

        'Add the Last Button.
        If currentPage <> pageCount Then
            pages.Add(New ListItem(PagingConstants.LastButtonText, pageCount.ToString()))
        End If
        rptPager.DataSource = pages
        rptPager.DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)

        lblPageNumber.Text = pageIndex.ToString()

        Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvHumanDiseaseReports.PageSize)

        If Not ViewState(PAGINATION_SET_NUMBER) = paginationSetNumber Then
            Select Case CType(sender, LinkButton).Text
                Case PagingConstants.PreviousButtonText
                    gvHumanDiseaseReports.PageIndex = gvHumanDiseaseReports.PageSize - 1
                Case PagingConstants.NextButtonText
                    gvHumanDiseaseReports.PageIndex = 0
                Case PagingConstants.FirstButtonText
                    gvHumanDiseaseReports.PageIndex = 0
                Case PagingConstants.LastButtonText
                    gvHumanDiseaseReports.PageIndex = 0
                Case Else
                    If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                        gvHumanDiseaseReports.PageIndex = gvHumanDiseaseReports.PageSize - 1
                    Else
                        gvHumanDiseaseReports.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                    End If
            End Select

            FillHumanDiseaseReportList(pageIndex, paginationSetNumber:=paginationSetNumber)
        Else
            If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                gvHumanDiseaseReports.PageIndex = gvHumanDiseaseReports.PageSize - 1
            Else
                gvHumanDiseaseReports.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
            End If
            BindGridView()
            FillPager(lblNumberOfRecords.Text, pageIndex)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindGridView()

        Dim list = CType(Session(SESSION_HUMAN_DISEASE_REPORT_LIST), List(Of HumDiseaseReportGetListModel))

        If (Not ViewState(SORT_EXPRESSION) Is Nothing) Then
            If ViewState(SORT_DIRECTION) = SortConstants.Ascending Then
                list = list.OrderBy(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            Else
                list = list.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            End If
        End If

        gvHumanDiseaseReports.DataSource = list
        gvHumanDiseaseReports.DataBind()

    End Sub

    Protected Sub GridViewSelection_OnDataBinding(sender As Object, e As EventArgs)

        Dim bHide As Boolean = True
        Dim sm As SelectModes = CType(hdfSelectMode.Value, SelectModes)

        Select Case sender.Id.ToString()
            Case "btnEdit"
            Case Else
                bHide = False
        End Select

        If (bHide And sm = SelectModes.Selection) Then
            Dim lb As LinkButton = CType(sender, LinkButton)
            lb.Visible = False
        End If

    End Sub

#End Region

End Class