Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.Client.Responses
Imports EIDSS.EIDSS
Imports EIDSSControlLibrary
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class SearchVeterinaryCampaignUserControl
    Inherits UserControl

#Region "Global Values"

    Public fileName As String

    Private userSettingsFile As String

    Private Const SectionSearchCriteria As String = "Search Criteria"
    Private Const SectionSearchResults As String = "Search Results"
    Private Const PAGE_KEY As String = "Page"
    Private Const HIDE_SEARCH_CRITERIA_SCRIPT As String = "hideVeterinaryCampaignSearchCriteria();"
    Private Const SHOW_SEARCH_CRITERIA_SCRIPT As String = "showVeterinaryCampaignSearchCriteria();"
    Private Const SESSION_CAMPAIGNS As String = "gvCampaigns_List"
    Private Const SORT_DIRECTION As String = "gvCampaigns_SortDirection"
    Private Const SORT_EXPRESSION As String = "gvCampaigns_SortExpression"
    Private Const PAGINATION_SET_NUMBER As String = "gvCampaigns_PaginationSet"

    Public Event ValidatePage()
    Public Event ShowWarningModal(messageType As MessageType, isConfirm As Boolean)
    Public Event CreateVeterinaryCampaignRecord()
    Public Event CancelVeterinaryCampaignRecord()
    Public Event ViewVeterinaryCampaignRecord(veterinaryCampaignID As Long)
    Public Event EditVeterinaryCampaignRecord(veterinaryCampaignID As Long)
    Public Event DeleteVeterinaryCampaignRecord(veterinaryCampaignID As Long)
    Public Event SelectVeterinaryCampaignRecord(veterinaryCampaignID As Long, eidssCampaignID As String, diseaseID As Long)
    Public Event SelectVeterinaryCampaignData(campaign As VctCampaignGetListModel)

    Private VeterinaryAPIService As VeterinaryServiceClient
    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(SearchVeterinaryCampaignUserControl))

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
                Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="selectMode"></param>
    Public Sub Setup(Optional selectMode As SelectModes = SelectModes.View)

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            Reset()

            upSearchCriteria.Update()
            upSearchResults.Update()

            FillForm()

            ExtractViewStateSession()

            hdfSelectMode.Value = selectMode

            'Changing visibility of some functions, depending on situation
            'Leaving this case open for future expansion...if necessary.
            Select Case selectMode
                Case SelectModes.Selection
                    btnAddCampaign.Visible = False
                Case Else
            End Select

            Dim parameters = New CampaignGetListParameters()
            Scatter(divVeterinaryCampaignSearchUserControlCriteria, ReadSearchCriteriaJSON(parameters, CreateTempFile(EIDSSAuthenticatedUser.EIDSSUserId.ToString(), ID)), 3)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Public Sub Reset()

        ResetForm(divVeterinaryCampaignSearchUserControlCriteria)

        ViewState(SORT_DIRECTION) = SortConstants.Descending
        ViewState(SORT_EXPRESSION) = "EIDSSCampaignID"
        ViewState(PAGINATION_SET_NUMBER) = 1

        ToggleVisibility(SectionSearchCriteria)

        'Restore search filters
        userSettingsFile = CreateTempFile(EIDSSAuthenticatedUser.EIDSSUserId.ToString(), ID)

        txtSearchEIDSSCampaignID.Focus()

        gvCampaigns.PageSize = ConfigurationManager.AppSettings("PageSize")

    End Sub

#End Region

#Region "Common Methods"

    ''' <summary>
    ''' Retrieves and saves VieState file.
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

        divVeterinaryCampaignSearchResults.Visible = section.Equals(SectionSearchResults)
        toggleIcon.Visible = section.Equals(SectionSearchResults)
        btnAddCampaign.Visible = section.Equals(SectionSearchResults)
        btnPrintSearchResults.Visible = section.Equals(SectionSearchResults)
        btnCancelSearchResults.Visible = section.Equals(SectionSearchResults)

    End Sub

#End Region

#Region "Search Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillForm()

        FillBaseReferenceDropDownList(ddlSearchCampaignStatusTypeID, BaseReferenceConstants.ASCampaignStatus, HACodeList.ASHACode, True)

        If (ddlSearchCampaignStatusTypeID.Items.Count > 0 AndAlso ddlSearchCampaignStatusTypeID.Items.Contains(ddlSearchCampaignStatusTypeID.Items.FindByText("Open"))) Then
            ddlSearchCampaignStatusTypeID.SelectedValue = ddlSearchCampaignStatusTypeID.Items.FindByText("Open").Value
        End If

        FillBaseReferenceDropDownList(ddlSearchCampaignTypeID, BaseReferenceConstants.ASCampaignType, HACodeList.ASHACode, True)
        FillBaseReferenceDropDownList(ddlSearchDiseaseID, BaseReferenceConstants.Diagnosis, HACodeList.LivestockHACode, True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Search_Click(sender As Object, e As EventArgs) Handles btnSearch.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            If ValidateSearch() Then
                Dim parameters As New CampaignGetListParameters With {.LanguageID = GetCurrentLanguage()}

                If VeterinaryAPIService Is Nothing Then
                    VeterinaryAPIService = New VeterinaryServiceClient()
                End If

                Dim list As List(Of VctCampaignGetCountModel)
                Gather(divVeterinaryCampaignSearchUserControlCriteria, parameters, 9)
                list = VeterinaryAPIService.GetCampaignCountAsync(parameters).Result
                gvCampaigns.PageIndex = 0
                gvCampaigns.Visible = True
                hdfSearchCount.Value = list.FirstOrDefault().RecordCount

                If list.FirstOrDefault().RecordCount = 1 Then
                    lblCampaignsRecordCount.Text = list.FirstOrDefault().RecordCount & " " & Resources.Labels.Lbl_Record_Found_Text & list.FirstOrDefault().TotalCount & " " & Resources.Labels.Lbl_Total_Records_Text
                Else
                    lblCampaignsRecordCount.Text = list.FirstOrDefault().RecordCount & " " & Resources.Labels.Lbl_Records_Found_Text & list.FirstOrDefault().TotalCount & " " & Resources.Labels.Lbl_Total_Records_Text
                End If

                lblCampaignsPageNumber.Text = "1"
                FillCampaigns(pageIndex:=1, paginationSetNumber:=1)
                SaveSearchCriteriaJSON(parameters, CreateTempFile(EIDSSAuthenticatedUser.EIDSSUserId, ID))
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, HIDE_SEARCH_CRITERIA_SCRIPT, True)
                ToggleVisibility(SectionSearchResults)

                upSearchCriteria.Update()
                upSearchResults.Update()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Private Function ValidateSearch() As Boolean

        Dim validated As Boolean = False

        Page.Validate("SearchCampaign")

        'Check if EIDSS ID is entered. If Yes, then ignore rest of the serach fields, otherwise, check if any other search criteria was entered.
        'If Not, raise an error to the user.
        validated = (Not txtSearchEIDSSCampaignID.Text.IsValueNullOrEmpty())

        If Not validated Then
            Dim controls As New List(Of Control)

            controls.Clear()
            For Each txt As TextBox In FindControlList(controls, divVeterinaryCampaignSearchUserControlCriteria, GetType(TextBox))
                If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
            Next

            If Not validated Then
                controls.Clear()
                For Each ddl As DropDownList In FindControlList(controls, divVeterinaryCampaignSearchUserControlCriteria, GetType(DropDownList))
                    If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each ddl As DropDownList In FindControlList(controls, divVeterinaryCampaignSearchUserControlCriteria, GetType(WebControls.DropDownList))
                    If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each txt As CalendarInput In FindControlList(controls, divVeterinaryCampaignSearchUserControlCriteria, GetType(CalendarInput))
                    If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                validated = ValidateFromToDates(txtSearchStartDateFrom.Text, txtSearchStartDateTo.Text)
                If Not validated Then
                    RaiseEvent ShowWarningModal(MessageType.InvalidDateOfBirth, False)
                    txtSearchStartDateFrom.Focus()
                End If
            End If

            If validated Then
                ToggleVisibility(SectionSearchResults)
            Else
                RaiseEvent ShowWarningModal(MessageType.SearchCriteriaRequired, False)
                txtSearchEIDSSCampaignID.Focus()
            End If
        End If

        Return validated

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Clear_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnClear.Click

        Try
            ResetForm(divVeterinaryCampaignSearchUserControlCriteria)

            DeleteTempFiles(HttpContext.Current.Request.PhysicalApplicationPath & "App_Data\" & ID & EIDSSAuthenticatedUser.EIDSSUserId.ToString() & ".xml")
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub CancelSearch_Click(sender As Object, e As EventArgs) Handles btnCancelSearchCriteria.Click, btnCancelSearchResults.Click

        Try
            RaiseEvent ShowWarningModal(MessageType.CancelSearchConfirm, isConfirm:=True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Campaigns_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvCampaigns.RowCommand

        Try
            e.Handled = True

            Select Case e.CommandName
                Case GridViewCommandConstants.EditCommand
                    RaiseEvent EditVeterinaryCampaignRecord(e.CommandArgument)
                Case GridViewCommandConstants.SelectCommand
                    Dim commandArguments As String() = e.CommandArgument.ToString().Split(",")
                    RaiseEvent SelectVeterinaryCampaignRecord(commandArguments(0), commandArguments(1), commandArguments(2))
                Case GridViewCommandConstants.SelectRecordCommand
                    Dim campaigns = TryCast(Session(SESSION_CAMPAIGNS), List(Of VctCampaignGetListModel))
                    Dim campaign = campaigns.Where(Function(x) x.CampaignID = e.CommandArgument).FirstOrDefault()
                    RaiseEvent SelectVeterinaryCampaignData(campaign)
            End Select

            upSearchCriteria.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    Private Sub FillCampaigns(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            Dim parameters As New CampaignGetListParameters With {.LanguageID = GetCurrentLanguage(), .paginationSetNumber = paginationSetNumber}

            If VeterinaryAPIService Is Nothing Then
                VeterinaryAPIService = New VeterinaryServiceClient()
            End If

            Gather(divVeterinaryCampaignSearchUserControlCriteria, parameters, 9)
            Session(SESSION_CAMPAIGNS) = VeterinaryAPIService.GetCampaignListAsync(parameters).Result
            BindCampaignsGridView()
            FillCampaignsPager(hdfSearchCount.Value, pageIndex)
            ViewState(PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindCampaignsGridView()

        Dim list = CType(Session(SESSION_CAMPAIGNS), List(Of VctCampaignGetListModel))

        If (Not ViewState(SORT_EXPRESSION) Is Nothing) Then
            If ViewState(SORT_DIRECTION) = SortConstants.Ascending Then
                list = list.OrderBy(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            Else
                list = list.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            End If
        End If

        gvCampaigns.DataSource = Nothing
        gvCampaigns.DataSource = list
        gvCampaigns.DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillCampaignsPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        If recordCount > 0 Then
            divCampaignsPager.Visible = True

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
            rptCampaignsPager.DataSource = pages
            rptCampaignsPager.DataBind()
            divCampaignsPager.Visible = True
        Else
            divCampaignsPager.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub CampaignsPage_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)
            lblCampaignsPageNumber.Text = pageIndex.ToString()

            Dim paginationSetNumber As Integer
            paginationSetNumber = Math.Ceiling(pageIndex / gvCampaigns.PageSize)

            If Not ViewState(PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvCampaigns.PageIndex = gvCampaigns.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvCampaigns.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvCampaigns.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvCampaigns.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvCampaigns.PageIndex = gvCampaigns.PageSize - 1
                        Else
                            gvCampaigns.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillCampaigns(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvCampaigns.PageIndex = gvCampaigns.PageSize - 1
                Else
                    gvCampaigns.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
                BindCampaignsGridView()
                FillCampaignsPager(hdfSearchCount.Value, pageIndex)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Campaigns_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvCampaigns.Sorting

        Try
            upSearchResults.Update()

            ViewState(SORT_DIRECTION) = IIf(ViewState(SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(SORT_EXPRESSION) = e.SortExpression

            SaveEIDSSViewState(ViewState)

            BindCampaignsGridView()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub SearchCriteria_Changed(sender As Object, e As EventArgs) Handles txtSearchCampaignName.TextChanged, txtSearchEIDSSCampaignID.TextChanged, ddlSearchCampaignTypeID.SelectedIndexChanged, ddlSearchDiseaseID.SelectedIndexChanged, ddlSearchCampaignStatusTypeID.SelectedIndexChanged

        divVeterinaryCampaignSearchResults.Visible = False
        divVeterinaryCampaignSearchUserControlCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")

    End Sub

#End Region

End Class