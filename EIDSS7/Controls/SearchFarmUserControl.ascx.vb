Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.Client.Responses
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class SearchFarmUserControl
    Inherits UserControl

#Region "Global Values"

    Private userSettingsFile As String

    Private Const SectionSearchCriteria As String = "Search Criteria"
    Private Const SectionSearchResults As String = "Search Results"

    Private Const SESSION_FARM_LIST As String = "gvFarm_List"
    Private Const SORT_DIRECTION As String = "gvFarm_SortDirection"
    Private Const SORT_EXPRESSION As String = "gvFarm_SortExpression"
    Private Const PAGINATION_SET_NUMBER As String = "gvFarm_PaginationSet"

    Private Const MODAL_KEY As String = "Modal"
    Private Const PAGE_KEY As String = "Page"
    Private Const HIDE_SEARCH_CRITERIA_SCRIPT As String = "hideFarmSearchCriteria();"
    Private Const SHOW_SEARCH_CRITERIA_SCRIPT As String = "showFarmSearchCriteria();"
    Private Const SHOW_MODAL_HANDLER_SCRIPT As String = "showModalHandler('{0}');"
    Private Const HIDE_MODAL_SCRIPT As String = "hideModal('{0}');"

    Public Event ShowWarningModal(messageType As MessageType, isConfirm As Boolean, message As String)
    Public Event SelectFarmWithWarningModal(messageType As MessageType, isConfirm As Boolean, farm As VetFarmMasterGetListModel)
    Public Event SelectFarm(farmID As Long, eidssFarmID As String, farmName As String)
    Public Event CreateFarm()
    Public Event ViewFarm(farmID As Long)
    Public Event EditFarm(farmID As Long)
    Public Event ShowCreateFarmModal()

    Private FarmAPIService As FarmServiceClient

    Private Shared Log = log4net.LogManager.GetLogger(GetType(SearchFarmUserControl))

    Public Property SelectedFarmID As Long

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
    ''' <param name="enableFarmType">Determines if the farm type should be enabled or not depending on the calling page.  Disabled when called from a disease report or potentially a monitoring session.</param>
    ''' <param name="selectMode"></param>
    ''' <param name="farmType">Defaults the farm type to the calling page's requested farm type.</param>
    ''' <param name="countryID">Defaults the country to the monitoring session's location when called from the monitoring session.</param>
    ''' <param name="regionID">Defaults the region to the monitoring session's location when called from the monitoring session.</param>
    ''' <param name="rayonID">Defaults the rayon to the monitoring session's location when called from the monitoring session.</param>
    ''' <param name="settlementID">Defaults the settlement to the monitoring session's location when called from the monitoring session.</param>
    Public Sub Setup(enableFarmType As Boolean, Optional selectMode As SelectModes = SelectModes.Selection, Optional farmType As String = Nothing, Optional countryID As Long? = Nothing, Optional regionID As Long? = Nothing, Optional rayonID As Long? = Nothing,
                     Optional settlementID As Long? = Nothing)

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If

            Reset()

            upSearchCriteria.Update()
            upSearchResults.Update()

            FillDropDowns()

            hdfSearchFarmType.Value = farmType
            hdfSearchCountryID.Value = If(countryID Is Nothing, String.Empty, countryID)
            hdfSearchRegionID.Value = If(regionID Is Nothing, String.Empty, regionID)
            hdfSearchRayonID.Value = If(rayonID Is Nothing, String.Empty, rayonID)
            hdfSearchSettlementID.Value = If(settlementID Is Nothing, String.Empty, settlementID)

            ucLocation.LocationCountryID = countryID
            ucLocation.LocationRegionID = regionID
            ucLocation.LocationRayonID = rayonID
            ucLocation.LocationSettlementID = settlementID
            ucLocation.Setup(CrossCuttingAPIService)

            ExtractViewStateSession()

            hdfSelectMode.Value = selectMode

            SelectAvianLivestockButton(farmType:=farmType, enabled:=enableFarmType)

            Dim parameters = New FarmGetListParameters()
            Scatter(divFarmSearchUserControlCriteria, ReadSearchCriteriaJSON(parameters, CreateTempFile(EIDSSAuthenticatedUser.EIDSSUserId.ToString(), ID)), 3)
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
    ''' <param name="farmType"></param>
    ''' <param name="enabled"></param>
    Private Sub SelectAvianLivestockButton(farmType As String, Optional enabled As Boolean = False)

        If (farmType.EqualsAny({FarmTypes.AvianFarmTypeName})) Then
            cbxFarmTypeID.SelectedValue = FarmTypes.AvianFarmType
        ElseIf (farmType.EqualsAny({FarmTypes.LivestockFarmTypeName})) Then
            cbxFarmTypeID.SelectedValue = FarmTypes.LivestockFarmType
        End If

        cbxFarmTypeID.Enabled = enabled

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub Reset()

        ResetForm(divFarmSearchUserControlCriteria)
        ResetForm(ucLocation)

        txtEIDSSFarmID.Text = String.Empty
        ViewState(SORT_DIRECTION) = SortConstants.Ascending
        ViewState(SORT_EXPRESSION) = "EIDSSFarmID"
        ViewState(PAGINATION_SET_NUMBER) = 1

        ToggleVisibility(SectionSearchCriteria)

        gvFarms.PageSize = ConfigurationManager.AppSettings("PageSize")

        txtEIDSSFarmID.Focus()

    End Sub

#End Region

#Region "Common Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillDropDowns()

        'Farm Types
        Dim li As ListItem
        li = New ListItem With {.Value = FarmTypes.AvianFarmType, .Text = Resources.Labels.Lbl_Avian_Text}
        cbxFarmTypeID.Items.Add(li)
        li = New ListItem With {.Value = FarmTypes.LivestockFarmType, .Text = Resources.Labels.Lbl_Livestock_Text}
        cbxFarmTypeID.Items.Add(li)

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

        divFarmSearchResults.Visible = section.Equals(SectionSearchResults)
        toggleIcon.Visible = section.Equals(SectionSearchResults)
        btnAddFarm.Visible = section.Equals(SectionSearchResults)
        btnPrintSearchResults.Visible = section.Equals(SectionSearchResults)
        btnCancelSearchResults.Visible = section.Equals(SectionSearchResults)

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
                SearchFarms()
            Else
                txtEIDSSFarmID.Focus()
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
    Public Sub SearchFarms()

        Try
            Dim parameters As New FarmGetListParameters With {.LanguageID = GetCurrentLanguage()}
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

            If FarmAPIService Is Nothing Then
                FarmAPIService = New FarmServiceClient()
            End If

            Gather(divFarmSearchUserControlCriteria, parameters, 3)
            Dim count As Integer = 0
            For Each li As ListItem In cbxFarmTypeID.Items
                If li.Selected Then
                    count += 1
                End If
            Next
            'All farm types selected, so set farm type ID to nothing to bring back all farm types within other selected criteria.
            If count = cbxFarmTypeID.Items.Count Then
                parameters.FarmTypeID = Nothing
            End If

            Dim list As List(Of VetFarmMasterGetCountModel)
            list = FarmAPIService.FarmMasterGetListCountAsync(parameters).Result
            gvFarms.PageIndex = 0
            gvFarms.Visible = True
            hdfSearchCount.Value = list.FirstOrDefault().SearchCount

            If list.FirstOrDefault().SearchCount = 1 Then
                lblRecordCount.Text = list.FirstOrDefault().SearchCount & " " & Resources.Labels.Lbl_Record_Found_Text & list.FirstOrDefault().TotalCount & " " & Resources.Labels.Lbl_Total_Records_Text
            Else
                lblRecordCount.Text = list.FirstOrDefault().SearchCount & " " & Resources.Labels.Lbl_Records_Found_Text & list.FirstOrDefault().TotalCount & " " & Resources.Labels.Lbl_Total_Records_Text
            End If

            lblPageNumber.Text = "1"
            FillFarmList(pageIndex:=1, paginationSetNumber:=1, regionID:=parameters.RegionID, rayonID:=parameters.RayonID)
            SaveSearchCriteriaJSON(parameters, CreateTempFile(EIDSSAuthenticatedUser.EIDSSUserId.ToString(), ID))
            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, HIDE_SEARCH_CRITERIA_SCRIPT, True)
            ToggleVisibility(SectionSearchResults)
            upSearchResultsCommands.Update()
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

        Page.Validate("SearchFarm")

        'Check if EIDSS ID is entered. If Yes, then ignore rest of the serach fields, otherwise, check if any other search criteria was entered.
        'If Not, raise an error to the user.
        validated = (Not txtEIDSSFarmID.Text.IsValueNullOrEmpty())

        If Not validated Then
            Dim controls As New List(Of Control)

            controls.Clear()
            For Each txt As TextBox In FindControlList(controls, divFarmSearchUserControlCriteria, GetType(TextBox))
                If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
            Next

            If Not validated Then
                controls.Clear()
                For Each ddl As DropDownList In FindControlList(controls, divFarmSearchUserControlCriteria, GetType(DropDownList))
                    If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each ddl As EIDSSControlLibrary.DropDownList In FindControlList(controls, divFarmSearchUserControlCriteria, GetType(EIDSSControlLibrary.DropDownList))
                    If ddl.ID.Contains("Country") = False Then 'Country set to default on location control for appropriate regions/rayons/settlements so skip it as part of the criteria entered.
                        If Not validated Then validated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                    End If
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each cbx As CheckBoxList In FindControlList(controls, divFarmSearchUserControlCriteria, GetType(CheckBoxList))
                    If Not validated Then validated = (Not cbx.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not validated Then
                controls.Clear()
                For Each txt As EIDSSControlLibrary.CalendarInput In FindControlList(controls, divFarmSearchUserControlCriteria, GetType(EIDSSControlLibrary.CalendarInput))
                    If Not validated Then validated = (Not txt.Text.ToString().IsValueNullOrEmpty())
                Next
            End If

            If validated Then
                ToggleVisibility(SectionSearchResults)
            Else
                RaiseEvent ShowWarningModal(MessageType.SearchCriteriaRequired, False, Nothing)
            End If
        End If

        Return validated

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    ''' <param name="regionID"></param>
    ''' <param name="rayonID"></param>
    Private Sub FillFarmList(pageIndex As Integer, paginationSetNumber As Integer, regionID As Long?, rayonID As Long?)

        Try
            Dim parameters As New FarmGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = paginationSetNumber, .RegionID = regionID, .RayonID = rayonID}

            Gather(divFarmSearchUserControlCriteria, parameters, 3)

            Dim count As Integer = 0
            For Each li As ListItem In cbxFarmTypeID.Items
                If li.Selected Then
                    count += 1
                End If
            Next
            'All farm types selected, so set farm type ID to nothing to bring back all farm types within other selected criteria.
            If count = cbxFarmTypeID.Items.Count Then
                parameters.FarmTypeID = Nothing
            End If

            If FarmAPIService Is Nothing Then
                FarmAPIService = New FarmServiceClient()
            End If

            Session(SESSION_FARM_LIST) = FarmAPIService.FarmMasterGetListAsync(parameters).Result
            gvFarms.DataSource = Nothing

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
    Private Sub BindGridView()

        Dim farms = CType(Session(SESSION_FARM_LIST), List(Of VetFarmMasterGetListModel))

        If (Not ViewState(SORT_EXPRESSION) Is Nothing) Then
            If ViewState(SORT_DIRECTION) = SortConstants.Ascending Then
                farms = farms.OrderBy(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            Else
                farms = farms.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            End If
        End If

        gvFarms.DataSource = farms
        gvFarms.DataBind()

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

        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)
            Dim regionID As Long?,
            rayonID As Long?

            lblPageNumber.Text = pageIndex.ToString()

            Dim paginationSetNumber As Integer
            paginationSetNumber = Math.Ceiling(pageIndex / gvFarms.PageSize)

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
                        gvFarms.PageIndex = gvFarms.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvFarms.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvFarms.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvFarms.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvFarms.PageIndex = gvFarms.PageSize - 1
                        Else
                            gvFarms.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillFarmList(pageIndex, paginationSetNumber:=paginationSetNumber, regionID:=regionID, rayonID:=rayonID)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvFarms.PageIndex = gvFarms.PageSize - 1
                Else
                    gvFarms.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
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
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Farms_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvFarms.Sorting

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
    Protected Sub Farms_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvFarms.RowCommand

        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.EditCommand
                        RaiseEvent EditFarm(e.CommandArgument)
                    Case GridViewCommandConstants.SelectCommand
                        Dim commandArguments As String() = e.CommandArgument.ToString().Split(",")

                        Dim farms = TryCast(Session(SESSION_FARM_LIST), List(Of VetFarmMasterGetListModel))
                        If farms Is Nothing Then
                            farms = New List(Of VetFarmMasterGetListModel)()
                        End If

                        Dim farm = farms.Where(Function(x) x.FarmMasterID = commandArguments(0)).FirstOrDefault()

                        If hdfSearchRegionID.Value.IsValueNullOrEmpty() = False Then
                            If Not farm.RegionID = hdfSearchRegionID.Value Then
                                RaiseEvent SelectFarmWithWarningModal(messageType:=MessageType.ConfirmFarmToMonitoringSessionAddressMismatch, isConfirm:=True, farm:=farm)
                            ElseIf Not farm.RayonID = hdfSearchRayonID.Value Then
                                RaiseEvent SelectFarmWithWarningModal(messageType:=MessageType.ConfirmFarmToMonitoringSessionAddressMismatch, isConfirm:=True, farm:=farm)
                            ElseIf Not farm.SettlementID = hdfSearchSettlementID.Value Then
                                RaiseEvent SelectFarmWithWarningModal(messageType:=MessageType.ConfirmFarmToMonitoringSessionAddressMismatch, isConfirm:=True, farm:=farm)
                            Else
                                RaiseEvent SelectFarm(commandArguments(0), commandArguments(1), commandArguments(2))
                            End If
                        Else
                            RaiseEvent SelectFarm(commandArguments(0), commandArguments(1), commandArguments(2))
                        End If
                    Case GridViewCommandConstants.ViewCommand
                        RaiseEvent ViewFarm(e.CommandArgument)
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
    Protected Sub AddFarm_Click(sender As Object, e As EventArgs) Handles btnAddFarm.Click

        Try
            RaiseEvent CreateFarm()
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

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, SHOW_SEARCH_CRITERIA_SCRIPT, True)

            Reset()

            'Limit to a specific farm type as this search was initiated by a disease report or monitoring session with a specific species type.
            If hdfSearchFarmType.Value.IsValueNullOrEmpty() = False Then
                SelectAvianLivestockButton(hdfSearchFarmType.Value, False)
            End If

            upSearchResults.Update()
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
    Protected Sub Cancel_Click(sender As Object, e As EventArgs) Handles btnCancelSearchCriteria.Click, btnCancelSearchResults.Click

        Try
            SaveEIDSSViewState(ViewState)

            RaiseEvent ShowWarningModal(MessageType.CancelSearchFarmConfirm, True, Nothing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="farmID"></param>
    Private Sub EditRecord(farmID As Long)

        RaiseEvent EditFarm(farmID)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="farmID"></param>
    ''' <param name="eidssFarmID"></param>
    ''' <param name="farmName"></param>
    Private Sub SelectRecord(farmID As Long, eidssFarmID As String, farmName As String)

        RaiseEvent SelectFarm(farmID, eidssFarmID, farmName)

    End Sub

#End Region

End Class