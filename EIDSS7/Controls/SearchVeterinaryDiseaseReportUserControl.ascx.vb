Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.Client.Enumerations
Imports EIDSS.Client.Responses
Imports EIDSS.EIDSS
Imports EIDSSControlLibrary
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class SearchVeterinaryDiseaseReportUsercontrol
    Inherits UserControl

#Region "Global Values"

    Private userSettingsFile As String
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"

    Private Const SectionSearchCriteria As String = "Search Criteria"
    Private Const SectionSearchResults As String = "Search Results"
    Private Const PAGE_KEY As String = "Page"
    Private Const SESSION_VETERINARY_DISEASE_REPORT_LIST As String = "gvVeterinaryDiseaseReportsDiseaseReports_List"
    Private Const SORT_DIRECTION As String = "gvVeterinaryDiseaseReportsDiseaseReports_SortDirection"
    Private Const SORT_EXPRESSION As String = "gvVeterinaryDiseaseReportsDiseaseReports_SortExpression"
    Private Const PAGINATION_SET_NUMBER As String = "gvVeterinaryDiseaseReportsDiseaseReports_PaginationSet"

    Public Event ShowWarningModal(messageType As MessageType, isConfirm As Boolean)
    Public Event SelectVeterinaryDiseaseReport(veterinaryDiseaseReportID As Long, eidssReportID As String, diseaseID As Long, farmOwnerID As Long?, farmOwnerName As String)
    Public Event CreateAvianDiseaseReport()
    Public Event CreateLivestockDiseaseReport()
    Public Event CancelVeterinaryDiseaseReport()
    Public Event ViewVeterinaryDiseaseReport(veterinaryDiseaseReportID As Long)
    Public Event EditVeterinaryDiseaseReport(veterinaryDiseaseReportID As Long)

    Private VeterinaryAPIService As VeterinaryServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(SearchVeterinaryDiseaseReportUsercontrol))

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
    ''' <param name="farmType"></param>
    Public Sub Setup(selectMode As SelectModes, Optional farmType As String = "")

        Try
            upSearchVeterinaryDiseaseReport.Update()

            Reset()

            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If

            ucLocation.Setup(CrossCuttingAPIService)

            ExtractViewStateSession()

            FillForm()

            hdfSelectMode.Value = selectMode

            TogglePermissions()

            'Changing visibility of some functions, depending on situation
            'Leaving this case open for future expansion...if necessary.
            Select Case selectMode
                Case SelectModes.Selection
                Case Else
            End Select

            hdfFarmType.Value = farmType

            ddlSpeciesTypeID.ClearSelection()

            Dim parameters = New VeterinaryDiseaseReportGetListParameters()
            Scatter(Me, ReadSearchCriteriaJSON(parameters, CreateTempFile(EIDSSAuthenticatedUser.EIDSSUserId.ToString(), ID)), 3)

            'Overwrite farm type set from JSON file above.  Farm type is controlled by page user selects (avian or livestock).
            Select Case farmType
                Case FarmTypes.AvianFarmType
                    ddlSpeciesTypeID.SelectedValue = ReportSessionTypes.Avian
                    ddlSpeciesTypeID.Enabled = False
                    FillDropDowns(HACodeList.AvianHACode)
                Case FarmTypes.LivestockFarmType
                    ddlSpeciesTypeID.SelectedValue = ReportSessionTypes.Livestock
                    ddlSpeciesTypeID.Enabled = False
                    FillDropDowns(HACodeList.LivestockHACode)
                Case Else
                    FillDropDowns(HACodeList.AllHACode.ToString())
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Public Sub Reset()

        ResetForm(pnlSearchForm)
        ResetForm(ucLocation)

        mvVeterinaryDiseaseReportSearch.ActiveViewIndex = 0

        ViewState(SORT_DIRECTION) = SortConstants.Descending
        ViewState(SORT_EXPRESSION) = "EIDSSReportID"
        ViewState(PAGINATION_SET_NUMBER) = 1

        ToggleVisibility(SectionSearchCriteria)

        'Restore search filters
        userSettingsFile = CreateTempFile(EIDSSAuthenticatedUser.EIDSSUserId.ToString(), CallerPages.VeterinaryDiseaseReportPrefix)

        txtDateEnteredFrom.Text = Date.Now.AddDays(-14)
        txtDateEnteredTo.Text = Date.Now

        txtEIDSSReportID.Focus()

        gvVeterinaryDiseaseReports.PageSize = ConfigurationManager.AppSettings("PageSize")

    End Sub

#End Region

#Region "Common Methods"

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

        btnClear.Visible = section.EqualsAny({SectionSearchCriteria, SectionSearchResults})
        btnCancel.Visible = section.EqualsAny({SectionSearchCriteria, SectionSearchResults})

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub TogglePermissions()

        If EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.Epizootologist) Or EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.ChiefEpizootologist) Or EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.Administrator) Then
            hdfCanEdit.Value = "1"
        Else
            hdfCanEdit.Value = "0"
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Private Function ValidateSearch() As Boolean

        Dim validated As Boolean = False

        'Check if the from and to data entry dates are both entered.
        'If Yes then ignore rest of the search fields
        'If No, check if any other search criteria is entered, if not, raise error.
        validated = (Not txtDateEnteredFrom.Text.IsValueNullOrEmpty() And Not txtDateEnteredTo.Text.IsValueNullOrEmpty())

        If Not validated Then
            Dim controls As New List(Of Control)

            controls.Clear()
            For Each txt As TextBox In FindControlList(controls, Me, GetType(TextBox))
                If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
            Next

            If Not validated Then
                controls.Clear()
                For Each rdb As RadioButton In FindControlList(controls, Me, GetType(RadioButton))
                    If Not validated Then validated = (rdb.Checked)
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each ddl As WebControls.DropDownList In FindControlList(controls, Me, GetType(WebControls.DropDownList))
                    If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each ddl As DropDownList In FindControlList(controls, Me, GetType(DropDownList))
                    If ddl.ClientID.Contains("ddlucLocationidfsCountry") = False Then
                        If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                    End If
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each txt As CalendarInput In FindControlList(controls, Me, GetType(CalendarInput))
                    If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
                Next
            End If

            If validated Then
                ToggleVisibility(SectionSearchResults)
            Else
                RaiseEvent ShowWarningModal(MessageType.SearchCriteriaRequired, False)
                txtDateEnteredFrom.Focus()
            End If
        End If

        Return validated

    End Function

    Protected Sub GridViewSelection_OnDataBinding(sender As Object, e As EventArgs)

        Dim bHide As Boolean = True
        Dim sm As SelectModes = hdfSelectMode.Value

        Select Case sender.Id.ToString()
            Case "btnEdit"
            Case "btnDelete"
            Case Else
                bHide = False
        End Select

        If (bHide And sm = SelectModes.Selection) Then
            Dim lb As LinkButton = CType(sender, LinkButton)
            lb.Visible = False
        End If

    End Sub

#End Region

#Region "Search Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub VeterinaryDiseaseReports_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvVeterinaryDiseaseReports.Sorting

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
    Protected Sub Search_Click(sender As Object, e As EventArgs) Handles btnSearch.Click

        Try
            If ValidateSearch() Then
                Dim parameters As New VeterinaryDiseaseReportGetListParameters With {.LanguageID = GetCurrentLanguage()}
                Dim controls As New List(Of Control)
                controls.Clear()
                For Each ddl As DropDownList In FindControlList(controls, ucLocation, GetType(DropDownList))
                    If ddl.ClientID.Contains("ddlucLocationidfsRegion") = True Then
                        If Not ddl.SelectedValue = "null" Then
                            parameters.RegionID = CType(ddl.SelectedValue, Long)
                        End If
                    End If

                    If ddl.ClientID.Contains("ddlucLocationidfsRayon") = True Then
                        If Not ddl.SelectedValue = "null" And Not ddl.SelectedValue = "" Then
                            parameters.RayonID = CType(ddl.SelectedValue, Long)
                        End If
                    End If
                Next

                If VeterinaryAPIService Is Nothing Then
                    VeterinaryAPIService = New VeterinaryServiceClient()
                End If

                Dim list = VeterinaryAPIService.GetVeterinaryDiseaseReportListCountAsync(Gather(Me, parameters, 3)).Result
                hdfSearchCount.Value = list.FirstOrDefault().RecordCount
                If list.FirstOrDefault().RecordCount = 1 Then
                    lblRecordCount.Text = list.FirstOrDefault().RecordCount & " " & Resources.Labels.Lbl_Record_Found_Text & list.FirstOrDefault().TotalCount & " " & Resources.Labels.Lbl_Total_Records_Text
                Else
                    lblRecordCount.Text = list.FirstOrDefault().RecordCount & " " & Resources.Labels.Lbl_Records_Found_Text & list.FirstOrDefault().TotalCount & " " & Resources.Labels.Lbl_Total_Records_Text
                End If

                lblPageNumber.Text = "1"
                FillVeterinaryDiseaseReportList(pageIndex:=1, paginationSetNumber:=1)
                gvVeterinaryDiseaseReports.PageIndex = 0
                SaveSearchCriteriaJSON(parameters, CreateTempFile(ID))
                mvVeterinaryDiseaseReportSearch.ActiveViewIndex = 1
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
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Clear_Click(sender As Object, e As EventArgs) Handles btnClear.Click

        Try
            Reset()

            ddlSpeciesTypeID.ClearSelection()

            Select Case hdfFarmType.Value
                Case FarmTypes.AvianFarmType
                    ddlSpeciesTypeID.SelectedValue = ReportSessionTypes.Avian
                    ddlSpeciesTypeID.Enabled = False
                    FillDropDowns(HACodeList.AvianHACode)
                Case FarmTypes.LivestockFarmType
                    ddlSpeciesTypeID.SelectedValue = ReportSessionTypes.Livestock
                    ddlSpeciesTypeID.Enabled = False
                    FillDropDowns(HACodeList.LivestockHACode)
                Case Else
                    FillDropDowns(HACodeList.AllHACode.ToString())
            End Select
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
            Dim sm As SelectModes = hdfSelectMode.Value

            If (sm = Global.EIDSS.EIDSS.SelectModes.Selection) Then
                RaiseEvent CancelVeterinaryDiseaseReport()
            End If

            SaveEIDSSViewState(ViewState)

            RaiseEvent ShowWarningModal(MessageType.CancelSearchVeterinaryDiseaseReportConfirm, True)
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
    Protected Sub SpeciesTypeID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlSpeciesTypeID.SelectedIndexChanged

        Try
            If ddlSpeciesTypeID.SelectedValue.IsValueNullOrEmpty Then
                FillDropDowns(HACodeList.AllHACode.ToString())
            ElseIf ddlSpeciesTypeID.SelectedValue = ReportSessionTypes.Avian Then
                FillDropDowns(HACodeList.AvianHACode.ToString())
            ElseIf ddlSpeciesTypeID.SelectedValue = ReportSessionTypes.Livestock Then
                FillDropDowns(HACodeList.LivestockHACode.ToString())
            Else
                FillDropDowns(HACodeList.AllHACode.ToString())
            End If

            upSearchVeterinaryDiseaseReport.Update()
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
    Protected Sub VeterinaryDiseaseReports_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvVeterinaryDiseaseReports.RowCommand

        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.ViewCommand
                        RaiseEvent ViewVeterinaryDiseaseReport(e.CommandArgument)
                    Case GridViewCommandConstants.EditCommand
                        RaiseEvent EditVeterinaryDiseaseReport(e.CommandArgument)
                    Case GridViewCommandConstants.SelectCommand
                        Dim commandArguments As String() = e.CommandArgument.ToString().Split(",")
                        RaiseEvent SelectVeterinaryDiseaseReport(commandArguments(0), commandArguments(1), commandArguments(2), If(commandArguments(3) = "", Nothing, commandArguments(3)), commandArguments(4))
                    Case GridViewCommandConstants.SelectFarm
                        SelectFarm(e.CommandArgument)
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
    Private Sub FillForm()

        Dim ddl As DropDownList = New DropDownList

        FillBaseReferenceDropDownList(ddlReportStatusTypeID, BaseReferenceConstants.CaseStatus, HACodeList.AvianHACode, True) 'TODO: Avian and livestock currently return the same values.  Future change would be to compare and remove any differences.
        FillBaseReferenceDropDownList(ddlClassificationTypeID, BaseReferenceConstants.CaseClassification, HACodeList.AvianHACode, True) 'TODO: Avian and livestock currently return the same values.  Future change would be to compare and remove any differences.
        FillBaseReferenceDropDownList(ddlReportTypeID, BaseReferenceConstants.CaseReportType, HACodeList.AvianHACode, True) 'TODO: Avian and livestock currently return the same values.  Future change would be to compare and remove any differences.
        FillBaseReferenceDropDownList(ddl, BaseReferenceConstants.CaseType, HACodeList.AvianHACode, True)
        ddlSpeciesTypeID.Items.AddRange(ddl.Items.Cast(Of ListItem).ToArray())
        FillBaseReferenceDropDownList(ddl, BaseReferenceConstants.CaseType, HACodeList.LivestockHACode, False)
        ddl.SelectedIndex = -1
        ddlSpeciesTypeID.Items.AddRange(ddl.Items.Cast(Of ListItem).ToArray())

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="accessoryCode"></param>
    Private Sub FillDropDowns(ByVal accessoryCode As String)

        ddlDiseaseID.Items.Clear()

        If accessoryCode = HACodeList.AvianHACode.ToString() Then
            FillBaseReferenceDropDownList(ddlDiseaseID, BaseReferenceConstants.Diagnosis, HACodeList.AvianHACode, True)
        ElseIf accessoryCode = HACodeList.LivestockHACode.ToString() Then
            FillBaseReferenceDropDownList(ddlDiseaseID, BaseReferenceConstants.Diagnosis, HACodeList.LivestockHACode, True)
        Else
            Dim ddl As DropDownList = New DropDownList

            FillBaseReferenceDropDownList(ddl, BaseReferenceConstants.Diagnosis, HACodeList.AvianHACode, True)
            ddlDiseaseID.Items.AddRange(ddl.Items.Cast(Of ListItem).ToArray())
            FillBaseReferenceDropDownList(ddl, BaseReferenceConstants.Diagnosis, HACodeList.LivestockHACode, False)
            ddl.SelectedIndex = -1
            ddlDiseaseID.Items.AddRange(ddl.Items.Cast(Of ListItem).ToArray())
        End If

        ddlDiseaseID = SortDropDownList(ddlDiseaseID)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    Private Sub FillVeterinaryDiseaseReportList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            Dim list = New List(Of VetDiseaseReportGetListModel)()

            Dim parameters = New VeterinaryDiseaseReportGetListParameters()
            parameters = Gather(Me, parameters, 3)
            parameters.LanguageID = GetCurrentLanguage()
            parameters.PaginationSetNumber = paginationSetNumber
            Dim controls As New List(Of Control)
            controls.Clear()
            For Each ddl As DropDownList In FindControlList(controls, ucLocation, GetType(DropDownList))
                If ddl.ClientID.Contains("ddlucLocationidfsRegion") = True Then
                    If Not ddl.SelectedValue = GlobalConstants.NullValue Then
                        parameters.RegionID = CType(ddl.SelectedValue, Long)
                    End If
                End If

                If ddl.ClientID.Contains("ddlucLocationidfsRayon") = True Then
                    If Not ddl.SelectedValue = GlobalConstants.NullValue And Not ddl.SelectedValue = "" Then
                        parameters.RayonID = CType(ddl.SelectedValue, Long)
                    End If
                End If
            Next
            If VeterinaryAPIService Is Nothing Then
                VeterinaryAPIService = New VeterinaryServiceClient()
            End If
            list = VeterinaryAPIService.GetVeterinaryDiseaseReportListAsync(parameters).Result
            Session(SESSION_VETERINARY_DISEASE_REPORT_LIST) = list
            BindGridView()
            FillPager(hdfSearchCount.Value, pageIndex)
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

        If recordCount > 0 Then
            rptPager.Visible = True

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
        Else
            rptPager.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)

            lblPageNumber.Text = pageIndex.ToString()

            Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvVeterinaryDiseaseReports.PageSize)

            If Not ViewState(PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvVeterinaryDiseaseReports.PageIndex = gvVeterinaryDiseaseReports.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvVeterinaryDiseaseReports.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvVeterinaryDiseaseReports.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvVeterinaryDiseaseReports.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvVeterinaryDiseaseReports.PageIndex = gvVeterinaryDiseaseReports.PageSize - 1
                        Else
                            gvVeterinaryDiseaseReports.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillVeterinaryDiseaseReportList(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvVeterinaryDiseaseReports.PageIndex = gvVeterinaryDiseaseReports.PageSize - 1
                Else
                    gvVeterinaryDiseaseReports.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
                BindGridView()
                FillPager(hdfSearchCount.Value, pageIndex)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindGridView()

        Dim list = CType(Session(SESSION_VETERINARY_DISEASE_REPORT_LIST), List(Of VetDiseaseReportGetListModel))

        If (Not ViewState(SORT_EXPRESSION) Is Nothing) Then
            If ViewState(SORT_DIRECTION) = SortConstants.Ascending Then
                list = list.OrderBy(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            Else
                list = list.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            End If
        End If

        gvVeterinaryDiseaseReports.DataSource = list
        gvVeterinaryDiseaseReports.DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="farmID"></param>
    Private Sub SelectFarm(farmID As Long)

        Try
            ViewState(CALLER_KEY) = farmID.ToString()
            ViewState(CALLER) = CallerPages.SearchVeterinaryDiseaseReport
            SaveEIDSSViewState(ViewState)

            Response.Redirect(GetURL(CallerPages.FarmURL))
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

End Class