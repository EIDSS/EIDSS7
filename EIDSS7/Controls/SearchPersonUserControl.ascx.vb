Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.Client.Responses
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

''' <summary>
''' Use Case: HUC01 - Search for a Person
''' 
''' The objective of the Search for Person Record Use Case Specification is to define the functional requirements 
''' for user to locate a person record in the EIDSS database. The functional requirements, or functionality 
''' that must be provided to users, are described in terms of use cases.
'''
''' The Search for Person Record Use Case Specification defines the functional requirements to give the user 
''' the ability to locate a particular person record in order to add a new Disease Report.
''' 
''' This is used in other use cases/modules as well.
''' 
''' </summary>
Public Class SearchPersonUserControl
    Inherits UserControl

#Region "Global Values"

    Private userSettingsFile As String

    Private Const SectionSearchCriteria As String = "Search Criteria"
    Private Const SectionSearchResults As String = "Search Results"
    Private Const PAGE_KEY As String = "Page"
    Private Const HIDE_SEARCH_CRITERIA_SCRIPT As String = "hidePersonSearchCriteria();"
    Private Const SHOW_SEARCH_CRITERIA_SCRIPT As String = "showPersonSearchCriteria();"
    Private Const SESSION_PERSON_LIST As String = "gvPeople_List"
    Private Const SORT_DIRECTION As String = "gvPeople_SortDirection"
    Private Const SORT_EXPRESSION As String = "gvPeople_SortExpression"
    Private Const PAGINATION_SET_NUMBER As String = "gvPeople_PaginationSet"
    Private Const HIDE_CANCEL_ADD_BUTTONS As String = "hideCancelAndAddPersonButtons();"

    Public Event ShowWarningModal(messageType As MessageType, isConfirm As Boolean)
    Public Event SelectPerson(humanID As Long, eidssPersonID As String, fullName As String, firstName As String, lastName As String)
    Public Event CreatePerson()
    Public Event DeletePerson(humanID As Long)
    Public Event ViewPerson(humanID As Long)
    Public Event EditPerson(humanID As Long)
    Public Event ShowCreatePersonModal()

    Private HumanAPIService As HumanServiceClient
    Private PersonAPICLient As PersonServiceClient
    Private Shared Log = log4net.LogManager.GetLogger(GetType(SearchPersonUserControl))

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
                cvFutureBirthDateFrom.ValueToCompare = Date.Now.ToShortDateString()
                cvFutureBirthDateTo.ValueToCompare = Date.Now.ToShortDateString()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="useHumanMasterIndicator"></param>
    ''' <param name="selectMode"></param>
    Public Sub Setup(useHumanMasterIndicator As Boolean, Optional selectMode As SelectModes = SelectModes.Selection)

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If

            Reset()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, SHOW_SEARCH_CRITERIA_SCRIPT, True)

            upSearchPerson.Update()
            upSearchResults.Update()

            FillDropDowns()

            ucLocation.Setup(CrossCuttingAPIService)

            ExtractViewStateSession()

            hdfSelectMode.Value = selectMode
            hdfUseHumanMasterIndicator.Value = useHumanMasterIndicator

            Dim parameters = New HumanGetListParams()
            Scatter(divPersonSearchUserControlCriteria, ReadSearchCriteriaJSON(parameters, CreateTempFile(EIDSSAuthenticatedUser.EIDSSUserId.ToString(), ID)), 3)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

    End Sub

    Public Sub GetPersonRecord(HumanMasterId As Long)
        PersonAPICLient = New PersonServiceClient()
        Try

            RaiseEvent EditPerson(HumanMasterId)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub Reset()

        ResetForm(divPersonSearchUserControlCriteria)
        ResetForm(ucLocation)

        txtEIDSSPersonID.Text = String.Empty
        ViewState(SORT_DIRECTION) = SortConstants.Ascending
        ViewState(SORT_EXPRESSION) = "EIDSSPersonID"
        ViewState(PAGINATION_SET_NUMBER) = 1

        ToggleVisibility(SectionSearchCriteria)

        gvHuman.PageSize = ConfigurationManager.AppSettings("PageSize")
        gvHumanMaster.PageSize = ConfigurationManager.AppSettings("PageSize")

        txtEIDSSPersonID.Focus()

    End Sub

#End Region

#Region "Common Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillDropDowns()

        FillBaseReferenceDropDownList(ddlPersonalIDType, BaseReferenceConstants.PersonalIDType, HACodeList.NoneHACode, True)
        FillBaseReferenceDropDownList(ddlGenderTypeID, BaseReferenceConstants.HumanGender, HACodeList.AllHACode, True)

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

        divPersonSearchResults.Visible = section.Equals(SectionSearchResults)
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
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            If ValidateSearch() Then
                Dim parameters As New HumanGetListParams With {.LanguageID = GetCurrentLanguage(), .ExactDateOfBirth = Nothing}
                Dim controls As New List(Of Control)
                controls.Clear()
                For Each ddl As EIDSSControlLibrary.DropDownList In FindControlList(controls, ucLocation, GetType(EIDSSControlLibrary.DropDownList))
                    If ddl.ClientID.Contains("ddlidfsRegion") = True Then
                        If Not ddl.SelectedValue = "null" Then
                            parameters.RegionID = CType(ddl.SelectedValue, Long)
                        End If
                    End If

                    If ddl.ClientID.Contains("ddlidfsRayon") = True Then
                        If Not ddl.SelectedValue = "null" And Not ddl.SelectedValue = "" Then
                            parameters.RayonID = CType(ddl.SelectedValue, Long)
                        End If
                    End If
                Next

                If HumanAPIService Is Nothing Then
                    HumanAPIService = New HumanServiceClient()
                End If
                Dim list
                If hdfUseHumanMasterIndicator.Value = False Then
                    list = HumanAPIService.GetHumanListCountAsync(Gather(divPersonSearchUserControlCriteria, parameters, 3)).Result
                    gvHuman.PageIndex = 0
                    gvHuman.Visible = True
                    gvHumanMaster.Visible = False
                Else
                    list = HumanAPIService.GetHumanMasterListCountAsync(Gather(divPersonSearchUserControlCriteria, parameters, 3)).Result
                    gvHumanMaster.PageIndex = 0
                    gvHuman.Visible = False
                    gvHumanMaster.Visible = True
                End If
                lblNumberOfRecords.Text = list.Item(0).RecordCount
                lblPageNumber.Text = "1"
                FillPersonList(pageIndex:=1, paginationSetNumber:=1, regionID:=parameters.RegionID, rayonID:=parameters.RayonID)
                SaveSearchCriteriaJSON(parameters, CreateTempFile(EIDSSAuthenticatedUser.EIDSSUserId.ToString(), ID))
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, HIDE_SEARCH_CRITERIA_SCRIPT, True)
                ToggleVisibility(SectionSearchResults)
            Else
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, HIDE_CANCEL_ADD_BUTTONS, True)
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
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub PersonalIDType_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlPersonalIDType.SelectedIndexChanged

        Try
            txtPersonalID.Enabled = (ddlPersonalIDType.SelectedIndex > 0)
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
    Protected Sub AddPerson_Click(sender As Object, e As EventArgs) Handles btnAddPerson.Click

        Try
            RaiseEvent CreatePerson()
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
            DeleteTempFiles(HttpContext.Current.Request.PhysicalApplicationPath & "App_Data\" & ID & EIDSSAuthenticatedUser.EIDSSUserId.ToString() & ".xml")
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, HIDE_CANCEL_ADD_BUTTONS, True)
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

            RaiseEvent ShowWarningModal(MessageType.CancelSearchPersonConfirm, True)
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

        Page.Validate("SearchPerson")

        'Check if EIDSS ID is entered. If Yes, then ignore rest of the serach fields, otherwise, check if any other search criteria was entered.
        'If Not, raise an error to the user.
        validated = (Not txtEIDSSPersonID.Text.IsValueNullOrEmpty())

        If Not validated Then
            Dim controls As New List(Of Control)

            controls.Clear()
            For Each txt As TextBox In FindControlList(controls, divPersonSearchUserControlCriteria, GetType(TextBox))
                If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
            Next

            If Not validated Then
                controls.Clear()
                For Each ddl As DropDownList In FindControlList(controls, divPersonSearchUserControlCriteria, GetType(DropDownList))
                    If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each ddl As EIDSSControlLibrary.DropDownList In FindControlList(controls, divPersonSearchUserControlCriteria, GetType(EIDSSControlLibrary.DropDownList))
                    If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each txt As EIDSSControlLibrary.CalendarInput In FindControlList(controls, divPersonSearchUserControlCriteria, GetType(EIDSSControlLibrary.CalendarInput))
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
                validated = ValidateDateOfBirth(txtDateOfBirthFrom.Text)
                If Not validated Then
                    RaiseEvent ShowWarningModal(MessageType.InvalidDateOfBirth, False)
                    txtDateOfBirthFrom.Focus()
                End If
            End If

            If validated Then
                validated = ValidateDateOfBirth(txtDateOfBirthTo.Text)
                If Not validated Then
                    RaiseEvent ShowWarningModal(MessageType.InvalidDateOfBirth, False)
                    txtDateOfBirthTo.Focus()
                End If
            End If

            If validated Then
                ToggleVisibility(SectionSearchResults)
            Else
                RaiseEvent ShowWarningModal(MessageType.SearchCriteriaRequired, False)
                txtEIDSSPersonID.Focus()
            End If
        End If

        Return validated

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillPersonList(pageIndex As Integer, paginationSetNumber As Integer, regionID As Long?, rayonID As Long?)

        Try
            Dim parameters As New HumanGetListParams With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = paginationSetNumber, .RegionID = regionID, .RayonID = rayonID}

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            If hdfUseHumanMasterIndicator.Value = False Then
                Session(SESSION_PERSON_LIST) = HumanAPIService.GetHumanListAsync(Gather(divPersonSearchUserControlCriteria, parameters, 3)).Result
                gvHuman.DataSource = Nothing
            Else
                Session(SESSION_PERSON_LIST) = HumanAPIService.GetHumanMasterListAsync(Gather(divPersonSearchUserControlCriteria, parameters, 3)).Result
                gvHumanMaster.DataSource = Nothing
            End If

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

        If hdfUseHumanMasterIndicator.Value = False Then
            Dim list = CType(Session(SESSION_PERSON_LIST), List(Of HumHumanGetListModel))

            If (Not ViewState(SORT_EXPRESSION) Is Nothing) Then
                If ViewState(SORT_DIRECTION) = SortConstants.Ascending Then
                    list = list.OrderBy(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
                Else
                    list = list.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
                End If
            End If

            gvHuman.DataSource = list
            gvHuman.DataBind()
        Else
            Dim list = CType(Session(SESSION_PERSON_LIST), List(Of HumHumanMasterGetListModel))

            If (Not ViewState(SORT_EXPRESSION) Is Nothing) Then
                If ViewState(SORT_DIRECTION) = SortConstants.Ascending Then
                    list = list.OrderBy(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
                Else
                    list = list.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
                End If
            End If

            gvHumanMaster.DataSource = list
            gvHumanMaster.DataBind()
        End If

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
            divPager.Visible = True

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
            divPager.Visible = True
        Else
            divPager.Visible = False
        End If

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

        Dim paginationSetNumber As Integer
        If hdfUseHumanMasterIndicator.Value = False Then
            paginationSetNumber = Math.Ceiling(pageIndex / gvHuman.PageSize)
        Else
            paginationSetNumber = Math.Ceiling(pageIndex / gvHumanMaster.PageSize)
        End If

        If Not ViewState(PAGINATION_SET_NUMBER) = paginationSetNumber Then
            Dim controls As New List(Of Control)
            controls.Clear()
            For Each ddl As EIDSSControlLibrary.DropDownList In FindControlList(controls, ucLocation, GetType(EIDSSControlLibrary.DropDownList))
                If ddl.ClientID.Contains("ddlidfsRegion") = True Then
                    If Not ddl.SelectedValue = GlobalConstants.NullValue Then
                        regionID = CType(ddl.SelectedValue, Long)
                    End If
                End If

                If ddl.ClientID.Contains("ddlidfsRayon") = True Then
                    If Not ddl.SelectedValue = GlobalConstants.NullValue And Not ddl.SelectedValue = "" Then
                        rayonID = CType(ddl.SelectedValue, Long)
                    End If
                End If
            Next

            Select Case CType(sender, LinkButton).Text
                Case PagingConstants.PreviousButtonText
                    If hdfUseHumanMasterIndicator.Value = False Then
                        gvHuman.PageIndex = gvHuman.PageSize - 1
                    Else
                        gvHumanMaster.PageIndex = gvHumanMaster.PageSize - 1
                    End If
                Case PagingConstants.NextButtonText
                    If hdfUseHumanMasterIndicator.Value = False Then
                        gvHuman.PageIndex = 0
                    Else
                        gvHumanMaster.PageIndex = 0
                    End If
                Case PagingConstants.FirstButtonText
                    If hdfUseHumanMasterIndicator.Value = False Then
                        gvHuman.PageIndex = 0
                    Else
                        gvHumanMaster.PageIndex = 0
                    End If
                Case PagingConstants.LastButtonText
                    If hdfUseHumanMasterIndicator.Value = False Then
                        gvHuman.PageIndex = 0
                    Else
                        gvHumanMaster.PageIndex = 0
                    End If
                Case Else
                    If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                        If hdfUseHumanMasterIndicator.Value = False Then
                            gvHuman.PageIndex = gvHuman.PageSize - 1
                        Else
                            gvHumanMaster.PageIndex = gvHumanMaster.PageSize - 1
                        End If
                    Else
                        If hdfUseHumanMasterIndicator.Value = False Then
                            gvHuman.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        Else
                            gvHumanMaster.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                    End If
            End Select

            FillPersonList(pageIndex, paginationSetNumber:=paginationSetNumber, regionID:=regionID, rayonID:=rayonID)
        Else
            If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                If hdfUseHumanMasterIndicator.Value = False Then
                    gvHuman.PageIndex = gvHuman.PageSize - 1
                Else
                    gvHumanMaster.PageIndex = gvHumanMaster.PageSize - 1
                End If
            Else
                If hdfUseHumanMasterIndicator.Value = False Then
                    gvHuman.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                Else
                    gvHumanMaster.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
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
    Protected Sub People_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvHuman.Sorting, gvHumanMaster.Sorting

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
    Protected Sub People_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvHuman.RowCommand, gvHumanMaster.RowCommand

        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.EditCommand
                        RaiseEvent EditPerson(e.CommandArgument)
                    Case GridViewCommandConstants.SelectCommand
                        Dim commandArguments As String() = e.CommandArgument.ToString().Split("|")
                        RaiseEvent SelectPerson(commandArguments(0), commandArguments(1), commandArguments(2), commandArguments(3), commandArguments(4))
                    Case GridViewCommandConstants.ViewCommand
                        RaiseEvent ViewPerson(e.CommandArgument)
                End Select
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

End Class