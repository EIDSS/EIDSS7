Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class SearchOrganizationUserControl
    Inherits UserControl

#Region "Global Values"

    Private userSettingsFile As String

    Private Const SectionSearchCriteria As String = "Search Criteria"
    Private Const SectionSearchResults As String = "Search Results"
    Private Const PAGE_KEY As String = "Page"
    Private Const HIDE_SEARCH_CRITERIA_SCRIPT As String = "hideOrganizationSearchCriteria();"
    Private Const SHOW_SEARCH_CRITERIA_SCRIPT As String = "showOrganizationSearchCriteria();"
    Private Const SESSION_ORGANIZATION_LIST As String = "gvOrganizations_List"
    Private Const SORT_DIRECTION As String = "gvOrganizations_SortDirection"
    Private Const SORT_EXPRESSION As String = "gvOrganizations_SortExpression"
    Private Const PAGINATION_SET_NUMBER As String = "gvOrganizations_PaginationSet"

    Public Event ShowWarningModal(messageType As MessageType, isConfirm As Boolean, message As String)
    Public Event SelectOrganizationRecord(organizationID As Long, organizationName As String)
    Public Event CreateOrganizationRecord()
    Public Event ViewOrganizationRecord(organizationID As Long)
    Public Event EditOrganizationRecord(organizationID As Long)
    Public Event ShowCreateOrganizationModal()

    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(SearchOrganizationUserControl))

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
    ''' <param name="moduleType"></param>
    Public Sub Setup(selectMode As SelectModes, Optional moduleType As ModuleTypes = Nothing)

        Try
            'Assign defaults from current user data.
            hdfidfUserID.Value = Session("UserID")
            hdfidfInstitution.Value = Session("Institution")

            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If
            ucLocation.Setup(CrossCuttingAPIService)

            Reset()

            FillDropDowns()

            ExtractViewStateSession()

            Select Case moduleType
                Case ModuleTypes.Laboratory
                    ddlOrganizationTypeID.Enabled = False
                    ddlOrganizationTypeID.SelectedValue = OrganizationTypes.Laboratory
                Case Else
                    ddlOrganizationTypeID.Enabled = True
                    ddlOrganizationTypeID.SelectedIndex = -1
            End Select

            hdfRecordMode.Value = selectMode

            Dim parameters = New OrganizationGetListParams()
            Scatter(divOrganizationSearchUserControlCriteria, ReadSearchCriteriaJSON(parameters, CreateTempFile(ID)), 3)

            upSearchOrganization.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub Reset()

        ResetForm(divOrganizationSearchUserControlCriteria)
        ResetForm(ucLocation)

        ViewState(SORT_DIRECTION) = SortConstants.Ascending
        ViewState(SORT_EXPRESSION) = "OrganizationFullName"
        ViewState(PAGINATION_SET_NUMBER) = 1

        ToggleVisibility(SectionSearchCriteria)

        txtOrganizationID.Text = String.Empty

        'Restore search filters
        userSettingsFile = CreateTempFile(hdfidfUserID.Value.ToString(), CallerPages.OrganizationAdminPrefix)

        gvOrganizations.PageSize = ConfigurationManager.AppSettings("PageSize")

    End Sub

#End Region

#Region "Common Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillDropDowns()

        FillBaseReferenceDropDownList(ddlOrganizationTypeID, BaseReferenceConstants.OrganizationType, HACodeList.AllHACode, True)
        FillBaseReferenceDropDownList(ddlAccessoryCode, BaseReferenceConstants.AccessoryList, HACodeList.NoneHACode, True)

    End Sub

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

        divOrganizationSearchResults.Visible = section.Equals(SectionSearchResults)
        toggleIcon.Visible = section.Equals(SectionSearchResults)

    End Sub

#End Region

#Region "Search Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Search_Click(sender As Object, e As EventArgs) Handles btnSearch.Click

        Try
            If ValidateSearch() Then
                Dim parameters As New OrganizationGetListParams With {.LanguageID = GetCurrentLanguage()}
                Dim controls As New List(Of Control)
                controls.Clear()
                For Each ddl As EIDSSControlLibrary.DropDownList In FindControlList(controls, ucLocation, GetType(EIDSSControlLibrary.DropDownList))
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

                If CrossCuttingAPIService Is Nothing Then
                    CrossCuttingAPIService = New CrossCuttingServiceClient()
                End If
                Dim list = CrossCuttingAPIService.GetOrganizationListCountAsync(Gather(divOrganizationSearchUserControlCriteria, parameters, 3)).Result
                lblNumberOfRecords.Text = list.Item(0).RecordCount
                lblPageNumber.Text = "1"
                FillOrganizationList(pageIndex:=1, paginationSetNumber:=1, regionID:=parameters.RegionID, rayonID:=parameters.RayonID)
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
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddOrganization_Click(sender As Object, e As EventArgs) Handles btnAddOrganization.Click

        Try
            RaiseEvent CreateOrganizationRecord()
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
            SaveEIDSSViewState(ViewState)

            RaiseEvent ShowWarningModal(messageType:=MessageType.CancelSearchConfirm, isConfirm:=True, message:=Nothing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Private Function ValidateSearch() As Boolean

        Dim validated As Boolean = False

        'Check if EIDSS ID is entered. If Yes, then ignore rest of the serach fields, otherwise, check if any other search criteria was entered.
        'If Not, raise an error to the user.
        validated = (Not txtOrganizationID.Text.IsValueNullOrEmpty())

        If Not validated Then
            Dim controls As New List(Of Control)

            controls.Clear()
            For Each txt As TextBox In FindControlList(controls, divOrganizationSearchUserControlCriteria, GetType(TextBox))
                If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
            Next

            If Not validated Then
                controls.Clear()
                For Each ddl As DropDownList In FindControlList(controls, divOrganizationSearchUserControlCriteria, GetType(DropDownList))
                    If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each ddl As EIDSSControlLibrary.DropDownList In FindControlList(controls, divOrganizationSearchUserControlCriteria, GetType(EIDSSControlLibrary.DropDownList))
                    If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each txt As EIDSSControlLibrary.CalendarInput In FindControlList(controls, divOrganizationSearchUserControlCriteria, GetType(EIDSSControlLibrary.CalendarInput))
                    If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
                Next
            End If

            controls.Clear()
            For Each txt As TextBox In FindControlList(controls, ucLocation, GetType(TextBox))
                If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
            Next

            If Not validated Then
                controls.Clear()
                For Each ddl As DropDownList In FindControlList(controls, ucLocation, GetType(DropDownList))
                    If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each ddl As EIDSSControlLibrary.DropDownList In FindControlList(controls, ucLocation, GetType(EIDSSControlLibrary.DropDownList))
                    If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each txt As EIDSSControlLibrary.CalendarInput In FindControlList(controls, ucLocation, GetType(EIDSSControlLibrary.CalendarInput))
                    If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
                Next
            End If

            If validated Then
                ToggleVisibility(SectionSearchResults)
            Else
                RaiseEvent ShowWarningModal(MessageType.SearchCriteriaRequired, False, Nothing)
                txtOrganizationID.Focus()
            End If
        End If

        Return validated

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillOrganizationList(pageIndex As Integer, paginationSetNumber As Integer, regionID As Long?, rayonID As Long?)

        Try
            Dim parameters As New OrganizationGetListParams With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = paginationSetNumber, .RegionID = regionID, .RayonID = rayonID}
            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If
            Session(SESSION_ORGANIZATION_LIST) = CrossCuttingAPIService.GetOrganizationListAsync(Gather(divOrganizationSearchUserControlCriteria, parameters, 3)).Result
            gvOrganizations.DataSource = Nothing
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
    Private Sub BindGridView()

        Dim list As List(Of GblOrganizationGetListModel) = CType(Session(SESSION_ORGANIZATION_LIST), List(Of GblOrganizationGetListModel))

        If list Is Nothing Then
            list = New List(Of GblOrganizationGetListModel)()
        End If

        If (Not ViewState(SORT_EXPRESSION) Is Nothing) Then
            If ViewState(SORT_DIRECTION) = SortConstants.Ascending Then
                list = list.OrderBy(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            Else
                list = list.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            End If
        End If

        gvOrganizations.DataSource = list
        gvOrganizations.DataBind()

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
        Dim regionID As Long?,
            rayonID As Long?

        lblPageNumber.Text = pageIndex.ToString()

        Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvOrganizations.PageSize)

        If Not ViewState(PAGINATION_SET_NUMBER) = paginationSetNumber Then
            Dim controls As New List(Of Control)
            controls.Clear()
            For Each ddl As EIDSSControlLibrary.DropDownList In FindControlList(controls, ucLocation, GetType(EIDSSControlLibrary.DropDownList))
                If ddl.ClientID.Contains("ddlucLocationidfsRegion") = True Then
                    If Not ddl.SelectedValue = GlobalConstants.NullValue Then
                        regionID = CType(ddl.SelectedValue, Long)
                    End If
                End If

                If ddl.ClientID.Contains("ddlucLocationidfsRayon") = True Then
                    If Not ddl.SelectedValue = GlobalConstants.NullValue And Not ddl.SelectedValue = "" Then
                        rayonID = CType(ddl.SelectedValue, Long)
                    End If
                End If
            Next

            Select Case CType(sender, LinkButton).Text
                Case PagingConstants.PreviousButtonText
                    gvOrganizations.PageIndex = gvOrganizations.PageSize - 1
                Case PagingConstants.NextButtonText
                    gvOrganizations.PageIndex = 0
                Case PagingConstants.FirstButtonText
                    gvOrganizations.PageIndex = 0
                Case PagingConstants.LastButtonText
                    gvOrganizations.PageIndex = 0
                Case Else
                    If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                        gvOrganizations.PageIndex = gvOrganizations.PageSize - 1
                    Else
                        gvOrganizations.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                    End If
            End Select

            FillOrganizationList(pageIndex, paginationSetNumber:=paginationSetNumber, regionID:=regionID, rayonID:=rayonID)
        Else
            If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                gvOrganizations.PageIndex = gvOrganizations.PageSize - 1
            Else
                gvOrganizations.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
            End If
            BindGridView()
            FillPager(lblNumberOfRecords.Text, pageIndex)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Organizations_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvOrganizations.Sorting

        Try
            ViewState(SORT_DIRECTION) = IIf(ViewState(SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
            ViewState(SORT_EXPRESSION) = e.SortExpression

            BindGridView()
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
    Protected Sub Organizations_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvOrganizations.RowCommand

        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.EditCommand
                        RaiseEvent EditOrganizationRecord(e.CommandArgument)
                    Case GridViewCommandConstants.SelectCommand
                        Dim commandArguments As String() = e.CommandArgument.ToString().Split(",")

                        RaiseEvent SelectOrganizationRecord(commandArguments(0), commandArguments(2))
                    Case GridViewCommandConstants.ViewCommand
                        RaiseEvent ViewOrganizationRecord(e.CommandArgument)
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
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub ShowForeignOrganization_CheckedChanged(sender As Object, e As EventArgs) Handles chkShowForeignOrganization.CheckedChanged

        Try
            If chkShowForeignOrganization.Checked = True Then
                ViewState(SORT_DIRECTION) = IIf(ViewState(SORT_DIRECTION) = SortConstants.Ascending, SortConstants.Descending, SortConstants.Ascending)
                ViewState(SORT_EXPRESSION) = "OrderNumber"
            Else
                ViewState(SORT_DIRECTION) = SortConstants.Ascending
                ViewState(SORT_EXPRESSION) = "OrganizationFullName"
            End If

            BindGridView()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

End Class