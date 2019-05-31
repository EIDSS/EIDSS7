Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

''' <summary>
''' Use Case: SAUC03 - Search for an Employee
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
Public Class SearchEmployeeUserControl
    Inherits UserControl

#Region "Global Values"

    Private userSettingsFile As String

    Private Const SectionSearchCriteria As String = "Search Criteria"
    Private Const SectionSearchResults As String = "Search Results"
    Private Const PAGE_KEY As String = "Page"
    Private Const HIDE_SEARCH_CRITERIA_SCRIPT As String = "hideEmployeeSearchCriteria();"
    Private Const SHOW_SEARCH_CRITERIA_SCRIPT As String = "showEmployeeSearchCriteria();"
    Private Const SESSION_PERSON_LIST As String = "gvPeople_List"
    Private Const SORT_DIRECTION As String = "gvPeople_SortDirection"
    Private Const SORT_EXPRESSION As String = "gvPeople_SortExpression"
    Private Const PAGINATION_SET_NUMBER As String = "gvPeople_PaginationSet"

    Public Event ShowWarningModal(messageType As MessageType, isConfirm As Boolean)
    Public Event SelectEmployee(employeeID As Long, employeeName As String)
    Public Event CreateEmployee()
    Public Event DeleteEmployee(employeeID As Long)
    Public Event ViewEmployee(employeeID As Long)
    Public Event EditEmployee(employeeID As Long)
    Public Event ShowCreatePersonModal()

    Private HumanAPIService As HumanServiceClient
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
            GetUserProfile()

            Reset()

            FillDropDowns()

            ExtractViewStateSession()

            hdfSelectMode.Value = selectMode

            Dim parameters = New HumanGetListParams()
            Scatter(divPersonSearchUserControlCriteria, ReadSearchCriteriaJSON(parameters, CreateTempFile(hdfidfUserID.Value.ToString(), ID)), 3)

            upSearchPerson.Update()
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

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub GetUserProfile()

        'Assign defaults from current user data.
        userSettingsFile = CreateTempFile(GlobalConstants.UserSettingsFilePrefix)
        Dim dsUserSettings As DataSet = ReadSearchCriteriaXML(userSettingsFile)
        If dsUserSettings.CheckDataSet() Then
            hdfidfUserID.Value = dsUserSettings.Tables(0).Rows(0).Item("hdfidfUserID") & ""
            hdfidfInstitution.Value = dsUserSettings.Tables(0).Rows(0).Item("hdfidfInstitution") & ""
        End If

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
                Dim parameters As New HumanGetListParams With {.LanguageID = GetCurrentLanguage(), .ExactDateOfBirth = Nothing}

                If HumanAPIService Is Nothing Then
                    HumanAPIService = New HumanServiceClient()
                End If
                Dim list

                list = HumanAPIService.GetHumanMasterListCountAsync(Gather(divPersonSearchUserControlCriteria, parameters, 3)).Result
                    gvHumanMaster.PageIndex = 0
                    gvHuman.Visible = False
                    gvHumanMaster.Visible = True
                lblNumberOfRecords.Text = list.Item(0).RecordCount
                lblPageNumber.Text = "1"
                FillPersonList(pageIndex:=1, paginationSetNumber:=1, regionID:=parameters.RegionID, rayonID:=parameters.RayonID)
                SaveSearchCriteriaJSON(parameters, CreateTempFile(hdfidfUserID.Value.ToString(), ID))
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
    Protected Sub PersonalIDType_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlPersonalIDType.SelectedIndexChanged

        upSearchPerson.Update()
        txtPersonalID.Enabled = (ddlPersonalIDType.SelectedIndex > -1)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddPerson_Click(sender As Object, e As EventArgs) Handles btnAddPerson.Click

        Try
            RaiseEvent CreateEmployee()
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
            If hdfidfUserID.Value.IsValueNullOrEmpty = True Then
                GetUserProfile()
            End If

            DeleteTempFiles(HttpContext.Current.Request.PhysicalApplicationPath & "App_Data\" & ID & hdfidfUserID.Value & ".xml")

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

            RaiseEvent ShowWarningModal(MessageType.CancelSearchConfirm, True)
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

            Session(SESSION_PERSON_LIST) = HumanAPIService.GetHumanMasterListAsync(Gather(divPersonSearchUserControlCriteria, parameters, 3)).Result
            gvHumanMaster.DataSource = Nothing

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

    End Sub

    Private Sub FillPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        If recordCount > 0 Then
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

        paginationSetNumber = Math.Ceiling(pageIndex / gvHumanMaster.PageSize)

        If Not ViewState(PAGINATION_SET_NUMBER) = paginationSetNumber Then
            Select Case CType(sender, LinkButton).Text
                Case PagingConstants.PreviousButtonText
                    gvHumanMaster.PageIndex = gvHumanMaster.PageSize - 1
                Case PagingConstants.NextButtonText
                    gvHumanMaster.PageIndex = 0
                Case PagingConstants.FirstButtonText
                    gvHumanMaster.PageIndex = 0
                Case PagingConstants.LastButtonText
                    gvHumanMaster.PageIndex = 0
                Case Else
                    If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                        gvHumanMaster.PageIndex = gvHumanMaster.PageSize - 1
                    Else
                        gvHumanMaster.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                    End If
            End Select

            FillPersonList(pageIndex, paginationSetNumber:=paginationSetNumber, regionID:=regionID, rayonID:=rayonID)
        Else
            If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                gvHumanMaster.PageIndex = gvHumanMaster.PageSize - 1
            Else
                gvHumanMaster.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
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
                    Case GridViewCommandConstants.DeleteCommand
                        RaiseEvent DeleteEmployee(e.CommandArgument)
                    Case GridViewCommandConstants.EditCommand
                        RaiseEvent EditEmployee(e.CommandArgument)
                    Case GridViewCommandConstants.SelectCommand
                        Dim commandArguments As String() = e.CommandArgument.ToString().Split(",")
                        RaiseEvent SelectEmployee(commandArguments(0), commandArguments(2))
                    Case GridViewCommandConstants.ViewCommand
                        RaiseEvent ViewEmployee(e.CommandArgument)
                End Select
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

End Class