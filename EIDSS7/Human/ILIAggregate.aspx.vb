Imports EIDSS.EIDSS
Imports EIDSS.Client.API_Clients
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports System.Reflection

Public Class ILIAggregate
    Inherits BaseEidssPage


    Private Const SESSION_SEARCH_LIST As String = "gvILIAggs_List"
    Private Const SORT_DIRECTION As String = "gvILIAggs_SortDirection"
    Private Const SORT_EXPRESSION As String = "gvILIAggs_SortExpression"
    Private Const PAGINATION_SET_NUMBER As String = "gvILIAggs_PaginationSet"
    Private ReadOnly Log As log4net.ILog

    Dim oAgg As clsAggregate = New clsAggregate() 'Need to remove
    'Constants for Sections/Panels on the form
    Private Const CSEARCHRESULTS As String = "divILIAggSearchResults"
    Private Const CSEARCH As String = "divILIAggSearchCriteria"
    Private Const CILIAGGR As String = "divILIAggregateAddEdit"
    Private Const SEARCH_FILE_PREFIX As String = "_IA"
    Private Const SEARCH_SP As String = "ILIGetList"

    Private editting As Boolean = False
    Private ReadOnly HumanServiceClientAPIClient As HumanServiceClient
    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private yearIntForEdit As Integer = 0
    Dim ddlYear As String = "2019" ' Current year
    Dim WeeksList As List(Of WeekPeriod) = New List(Of WeekPeriod)

#Region "Initialize Methods"
    Sub New()
        Try
            Log = log4net.LogManager.GetLogger(GetType(AggregateSettings))
            Log.Info("Loading Contructor Classes AggregateSettings.aspx")
            HumanServiceClientAPIClient = New HumanServiceClient()
            CrossCuttingAPIService = New CrossCuttingServiceClient()

        Catch ex As Exception
            Log.Error("Error Loading Contructor Classes ILIAggregate" & ex.Message)
            Throw ex
        End Try
    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            '    CheckCallerHandler()
            Log.Info("ILIAggregate is called")
            PopulateSearchDropDowns()
            gvILIAggs.DataSource = New List(Of Object)
            gvILIAggs.DataBind()
            '            FillCountry()
            InitializeSearchPage()
        End If

    End Sub
    Private Sub InitializeSearchPage()

        ToggleVisibility(CSEARCH)
        hdfLangID.Value = getConfigValue("DefaultLanguage")
        txtSearchformILIAggCode.Text = ""
        txtdatSearchWeeksFromDate.Text = "01/07/2019" 'Need changes here
        txtdatSearchWeeksToDate.Text = Date.Now.ToShortDateString()

    End Sub
    Private Sub FillCountry()

        'Set default country name and save country ID in hidden field
        Dim oC As clsCountry = New clsCountry()
        Dim dsCountry = oC.SelectOne(0)
        If dsCountry.CheckDataSet() Then
            hdfidfsCountry.Value = dsCountry.Tables(0).Rows(0)(CountryConstants.CountryID).ToString()

        End If

    End Sub
#End Region

#Region "Common Methods"


    Private Sub ToggleVisibility(ByVal sSection As String)

        'ucSearchILIAgg.Visible = sSection.Equals(SectionSearch)
        'ucAddUpdateILIAgg.Visible = sSection.EqualsAny({SectionILIAgg, SectionPerson})

    End Sub

    Private Sub ShowWarningMessage(messageType As MessageType, isConfirm As Boolean, Optional message As String = Nothing)

        warningHeading.InnerText = Resources.WarningMessages.Warning_Message_Alert
        warningSubTitle.InnerText = String.Empty

        Select Case messageType
            Case messageType.CannotAddUpdate
                warningBody.InnerText = Resources.WarningMessages.Cannot_Save
            Case messageType.CannotGetValidatorSection
                warningBody.InnerText = Resources.WarningMessages.Validator_Section
            Case messageType.UnhandledException
                warningBody.InnerText = Resources.WarningMessages.Unhandled_Exception
            Case messageType.SearchCriteriaRequired
                warningBody.InnerText = Resources.WarningMessages.Search_Criteria_Required
            Case messageType.InvalidDateOfBirth
                warningBody.InnerText = Resources.WarningMessages.Invalid_DOB
        End Select

        If isConfirm Then
            divWarningYesNoContainer.Visible = True
            divWarningOKContainer.Visible = False
        Else
            divWarningOKContainer.Visible = True
            divWarningYesNoContainer.Visible = False
        End If

        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & divWarningModal.ClientID & "').modal('show');});", True)

    End Sub

    Private Sub ShowSuccessMessage(messageType As MessageType, Optional message As String = Nothing)

        Select Case messageType
            Case messageType.DeleteSuccess
                lblSuccessMessage.InnerText = GetLocalResourceObject("Lbl_Message_Delete_Success")
            Case messageType.AddUpdateSuccess
                lblSuccessMessage.InnerText = message
        End Select

        'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & divSuccessModal.ClientID & "').modal('show');});", True) ak

    End Sub

    Private Sub ILIAgg_Error(Sender As Object, e As EventArgs) Handles Me.[Error]

        Dim exc As Exception = Server.GetLastError()

        If (TypeOf exc Is HttpUnhandledException) Then
            ShowWarningMessage(messageType:=MessageType.UnhandledException, isConfirm:=False)
        Else
            'Pass the error on to the error page.
            Dim delimiter As Char = "/"
            Dim sHandler As String() = Request.ServerVariables("SCRIPT_NAME").Split(delimiter)
            Server.Transfer("~/GeneralError.aspx?handler=" & sHandler.Last.ToString().Replace(".aspx", "") & "_Error%20-%20Default.aspx&aspxerrorpath=" & Me.GetType.Name, True)
        End If

        'Clear the error from the server.
        Server.ClearError()

    End Sub

#End Region

#Region "Search Methods"
    Private Sub PopulateSearchDropDowns()

        'FillDropDown(ddlidfILIAggHospitalName _
        '                , GetType(clsOrganization) _
        '                , {"@OrganizationTypeID:" & "10504002", "@intHACode:" & HACodeList.HumanHACode} _
        '                , OrganizationConstants.idfInstitution _
        '                , OrganizationConstants.OrgName _
        '                , Nothing _
        '                , Nothing _
        '                , True)

        'FillDropDown(ddlidfILIAggDataSite _
        '                , GetType(clsOrganization) _
        '                , {"@OrganizationTypeID:" & "10504002", "@intHACode:" & HACodeList.HumanHACode} _
        '                , OrganizationConstants.idfInstitution _
        '                , OrganizationConstants.OrgName _
        '                , Nothing _
        '                , Nothing _
        '                , True)

        Dim list As List(Of GblOrganizationByTypeGetListModel) = CrossCuttingAPIService.OrganizationByTypeGetListAsync(GetCurrentLanguage(), OrganizationTypes.Laboratory).Result

        'Hospital is [dbo].[tlbOffice] ([idfOffice])
        'FillDropDown(ddlidfILIAggDataSite, GetType(clsOrganization), Nothing, OrganizationConstants.idfOrganization, OrganizationConstants.OrgFullName, Nothing, Nothing, False)
        FillDropDown(ddlidfILIAggHospitalName, GetType(clsOrganization), Nothing, OrganizationConstants.idfInstitution, OrganizationConstants.OrgFullName, Nothing, Nothing, True)



        FillOrganizationList(ddlidfILIAggDataSite, Nothing, Nothing, True)  ' Site is Organization
        Try
            '           GetSearchFields()
            '           InitializeSearchFields()
        Catch ex As Exception
            Throw
        End Try

    End Sub
    Protected Sub btnDelAgg_Click(sender As Object, e As EventArgs) Handles delYes.ServerClick




        Dim Index As Int32 = CType(hdfDeleteIndex.Value, Int32)

        Dim strformID As Label = gvILIAggs.Rows(index).FindControl("lblstrFormID")
        Dim AggregateHeaderId As Label = gvILIAggs.Rows(index).FindControl("AggregateHeaderId")

        hdfAggregateHeaderId.Value = AggregateHeaderId.Text
        hdfstrFormIDEdit.Value = strformID.Text
        editting = True  ' Hack to get fix indexing bug need better solution 



        DeleteAggregateApi()



        '      DeleteAggApi()
    End Sub

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs)

        Log.Info("ILIAggregate Search Started")
        If ValidateForSearch() Then


            btnCancelSearch.Visible = True


            FillAggregateGrid(bRefresh:=True)
            btnShowSearchCriteria.Visible = True
            showSearchCriteria(False)
            btnCancelSearch.Visible = True
            btnNewILIAgg.Visible = True

            divILIAggSearchResults.Visible = True
            showClearandSearchButtons(False)

            Log.Info("ILIAggregate Search End")

        End If
    End Sub
    Private Sub showSearchCriteria(ByVal show As Boolean)
        If show Then
            divILIAggSearchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
            btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")
        Else
            divILIAggSearchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
            btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
        End If
    End Sub
    Private Sub showClearandSearchButtons(ByVal show As Boolean)
        btnSearch.Attributes.CssStyle.Remove(HtmlTextWriterStyle.Display)
        btnClear.Attributes.CssStyle.Remove(HtmlTextWriterStyle.Display)

        btnPrint.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")

        If show Then
            btnSearch.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
            btnClear.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
        Else
            btnSearch.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
            btnClear.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
        End If
    End Sub

    Private Function ValidateForSearch() As Boolean

        Try

            Dim blnValidated As Boolean = False


            'searchForm
            Dim allCtrl As New List(Of Control)

            allCtrl.Clear()
            For Each txt As WebControls.TextBox In FindControlList(allCtrl, divILIAggSearchCriteria, GetType(WebControls.TextBox))
                If Not blnValidated Then blnValidated = (Not txt.Text.ToString().IsValueNullOrEmpty())
            Next

            If Not blnValidated Then
                allCtrl.Clear()
                For Each ddl As WebControls.DropDownList In FindControlList(allCtrl, divILIAggSearchCriteria, GetType(WebControls.DropDownList))
                    If Not blnValidated Then blnValidated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If



            blnValidated = Not (txtSearchformILIAggCode.Text.IsValueNullOrEmpty())
            If blnValidated Then
                divILIAggSearchResults.Visible = blnValidated
            End If

            If Not blnValidated Then
                allCtrl.Clear()
                For Each txt As EIDSSControlLibrary.CalendarInput In FindControlList(allCtrl, divILIAggSearchCriteria, GetType(EIDSSControlLibrary.CalendarInput))
                    If Not blnValidated Then blnValidated = (Not txt.Text.ToString().IsValueNullOrEmpty())
                Next
            End If

            If blnValidated And (txtdatSearchWeeksFromDate.Text.Length > 0 Or txtdatSearchWeeksToDate.Text.Length > 0) Then
                blnValidated = ValidateFromToDates(txtdatSearchWeeksFromDate.Text, txtdatSearchWeeksToDate.Text)
                If Not blnValidated Then

                    'show message, search criteria dates are not valid.
                    ' Needs to do a if then else Msg  - VAUC07 Page 7 The system shall provide a warning message to the user: “You did not specify the “End Date”. Do you want to use current date as the End Date?” 

                    ASPNETMsgBox(GetLocalResourceObject("Msg_Dates_Are_Invalid")) ' needs to be converted to javascript
                    txtdatSearchWeeksFromDate.Focus()
                    Return blnValidated
                    'This would be better  but need testing  searchResults.Visible = blnValidated
                End If
            End If

            'Need new logic here Arnold
            blnValidated = True ' Since invalid search results are handled in this function, when we exit we want to see the search results
            divILIAggSearchResults.Visible = blnValidated
            Return blnValidated

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Function

    Private Sub FillAggregateGrid(Optional sGetDataFor As String = "GRIDROWS",
                                        Optional bRefresh As Boolean = False)

        'Parametrs
        Dim strformid As String = "null"
        Dim AggHeader As Long = 0
        Dim Site As Long = 0

        Dim HospitalName As Long = 0
        Dim startdate As DateTime = String.Format("{0:MM/dd/yyyy}", DateTime.Today.Date)
        Dim finishdate As DateTime = String.Format("{0:MM/dd/yyyy}", DateTime.Today.Date)

        Try
            SaveSearchFields()



            If Not txtSearchformILIAggCode.Text.IsValueNullOrEmpty Then
                hdfSearchFormID.Value = txtSearchformILIAggCode.Text
                strformid = txtSearchformILIAggCode.Text
                '               GetAggregateHeader(hdfSearchFormID.Value) ' Convert string - not needed
                hdfidfAggregateHeader.Value = "0"

            End If


            If Not txtdatSearchWeeksToDate.Text.IsValueNullOrEmpty Then
                hdfdatFinishDate.Value = txtdatSearchWeeksToDate.Text
                finishdate = txtdatSearchWeeksToDate.Text
            End If

            If Not txtdatSearchWeeksFromDate.Text.IsValueNullOrEmpty Then
                hdfdatStartDate.Value = txtdatSearchWeeksFromDate.Text
                startdate = txtdatSearchWeeksFromDate.Text
            End If

            If (Not ddlidfILIAggHospitalName.SelectedValue.IsValueNullOrEmpty AndAlso ddlidfILIAggHospitalName.SelectedValue <> "-1") Then
                hdfidfSearchHospital.Value = ddlidfILIAggHospitalName.SelectedValue
                HospitalName = hdfidfSearchHospital.Value.ToInt64

            End If

            If (Not ddlidfILIAggDataSite.SelectedValue.IsValueNullOrEmpty AndAlso ddlidfILIAggDataSite.SelectedValue <> "-1") Then
                hdfidfSearchSite.Value = ddlidfILIAggDataSite.SelectedValue
                Site = hdfidfSearchSite.Value.ToInt64

            End If

            Dim langId = GetCurrentLanguage()





            '           Dim list = HumanServiceClientAPIClient.ILIAggCaseGetlistAsync(langId, strformid, AggHeader, Site, HospitalName, startdate, finishdate).Result
            Dim list = HumanServiceClientAPIClient.ILIAggCaseGetlistAsync(langId, strformid, 0, Site, HospitalName, startdate, finishdate).Result


            gvILIAggs.DataSource = Nothing
            gvILIAggs.DataSource = list




            lblNumberOfRecords.Text = list.Count
            lblPageNumber.Text = "1"

            'FillAggSearchList(pageIndex:=1, paginationSetNumber:=1)




            Session(SESSION_SEARCH_LIST) = list

            'gvILIAggs.DataSource = Nothing
            BindGridView()
            FillPager(lblNumberOfRecords.Text, 1)
            ViewState(PAGINATION_SET_NUMBER) = 1








            gvILIAggs.PageIndex = 0

        Catch ex As Exception
            'Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub
    Private Sub GetAggregateHeader(sformID As String)

        Dim length = sformID.Length
        Dim numchar = ""
        Try
            Select Case length
                Case 14
                    numchar = Right(sformID, 1) 'strip off last digit

                Case 15
                    numchar = Right(sformID, 2)'strip off last two digit
                Case 16
                    numchar = Right(sformID, 3)'strip off last three digit
                Case 17
                    numchar = Right(sformID, 4)'strip off last four digit
                Case 18
                    numchar = Right(sformID, 5)'strip off last five digit
                Case 19
                    numchar = Right(sformID, 6)'strip off last six digit
                Case 207
                    numchar = Right(sformID, 7) 'strip off last seven digit
                Case Else
                    numchar = "0" 'no strip
            End Select
            hdfidfAggregateHeader.Value = numchar
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub


    Private Sub SaveSearchFields()

        Dim oCom As New clsCommon
        'oCom.SaveSearchFields({searchForm}, SEARCH_SP, oCom.CreateTempFile(SEARCH_FILE_PREFIX))

    End Sub

    Protected Sub Page_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)

        lblPageNumber.Text = pageIndex.ToString()

        Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvILIAggs.PageSize)

        If Not ViewState(PAGINATION_SET_NUMBER) = paginationSetNumber Then
            Dim controls As New List(Of Control)
            controls.Clear()

            Select Case CType(sender, LinkButton).Text
                Case PagingConstants.PreviousButtonText
                    gvILIAggs.PageIndex = gvILIAggs.PageSize - 1
                Case PagingConstants.NextButtonText
                    gvILIAggs.PageIndex = 0
                Case PagingConstants.FirstButtonText
                    gvILIAggs.PageIndex = 0
                Case PagingConstants.LastButtonText
                    gvILIAggs.PageIndex = 0
                Case Else
                    If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                        gvILIAggs.PageIndex = gvILIAggs.PageSize - 1
                    Else
                        gvILIAggs.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                    End If
            End Select

            FillAggSearchList(pageIndex, paginationSetNumber:=paginationSetNumber)
        Else
            If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                gvILIAggs.PageIndex = gvILIAggs.PageSize - 1
            Else
                gvILIAggs.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
            End If
            BindGridView()
            'FillPager(lblSearchResultsItems.Text, pageIndex)
            FillPager(lblNumberOfRecords.Text, pageIndex)

        End If

    End Sub
    Private Sub FillAggSearchList(pageIndex As Integer, paginationSetNumber As Integer)

        Try


            Dim langId = GetCurrentLanguage()


            Session(SESSION_SEARCH_LIST) = HumanServiceClientAPIClient.ILIAggCaseGetlistAsync(langId, hdfSearchFormID.Value, hdfidfAggregateHeader.Value.ToInt64, hdfidfSearchSite.Value.ToInt64, hdfidfSearchHospital.Value.ToInt64, hdfdatStartDate.Value, hdfdatFinishDate.Value).Result


            gvILIAggs.DataSource = Nothing
            BindGridView()
            FillPager(lblNumberOfRecords.Text, pageIndex)
            ViewState(PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            'Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    Private Sub BindGridView()

        Dim list As List(Of IliAggregateGetListModel) = CType(Session(SESSION_SEARCH_LIST), List(Of IliAggregateGetListModel))

        If (Not ViewState(SORT_EXPRESSION) Is Nothing) Then
            If ViewState(SORT_DIRECTION) = SortConstants.Ascending Then
                list = list.OrderBy(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            Else
                list = list.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            End If
        End If

        gvILIAggs.DataSource = list
        gvILIAggs.DataBind()

    End Sub

    Private Sub FillPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5


        Try
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
                pages.Add(New ListItem("<<", "1"))
            End If

            'Add the Previous Button.
            If currentPage > 1 Then
                pages.Add(New ListItem("<", (currentPage - 1).ToString()))
            End If

            Dim paginationSetNumber As Integer = 1,
                pageCounter As Integer = 1

            For i As Integer = startIndex To endIndex
                pages.Add(New ListItem(i.ToString(), i.ToString(), i <> currentPage))
            Next

            'Add the Next Button.
            If currentPage < pageCount Then
                pages.Add(New ListItem(">", (currentPage + 1).ToString()))
            End If

            'Add the Last Button.
            If currentPage <> pageCount Then
                pages.Add(New ListItem(">>", pageCount.ToString()))
            End If

            rptPager.DataSource = pages
            rptPager.DataBind()

        Catch ex As Exception
            'Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

#Region "Add/Update ILIAgg Methods"

    Private Sub AddOrUpdateAggApi(Addyear As Int32, Addweek As Int32)

        'verify that the minimum of time period and admin have been populated
        'confirm with user. if blank, then set defaults per use case

        Try
            Dim ILIAggModelSetParams As New ILIAggregateSetParams()


            If hdfSiteID.Value = "NULL" Or hdfSiteID.Value = "" Then
                hdfSiteID.Value = Session("UserSite")
            End If


            If hdfidfEnteredByPerson.Value = "NULL" Or hdfidfEnteredByPerson.Value = "" Then  ' Must have a user
                hdfidfEnteredByPerson.Value = Session("Person").ToString()
            End If


            hdfidfEnteredByPerson.Value = Session("Person").ToString()
            ILIAggModelSetParams.idfEnteredBy = hdfidfEnteredByPerson.Value 'Not in the Person Table 55541630000000


            If Not editting Then
                hdfFormID.Value = "" 'After delete, fix problem  creating agregate
            End If


            Dim hidnValues = Gather(divHiddenFieldsSection, ILIAggModelSetParams, 3)


            If hdfFormID.Value = "" Or hdfFormID.Value.ToInt32 = 0 Or hdfFormID.Value.IsValueNullOrEmpty Then
                hdfFormID.Value = -1
            End If

            If hdfidfAggregateHeader.Value = "" Or hdfidfAggregateHeader.Value.ToInt32 = 0 Or hdfidfAggregateHeader.Value.IsValueNullOrEmpty Then
                hdfidfAggregateHeader.Value = -1
            End If




            '          Dim dataValues = Gather(divILIAggregateAddEdit, ILIAggModelSetParams, 3)


            If Not txtstrEnteredBy.Text.IsValueNullOrEmpty Then
                ILIAggModelSetParams.idfsSite = hdfSiteID.Value


            End If



            'If Not hidnValues.datFinishDate.HasValue Then
            '    ILIAggModelSetParams.datFinishDate = hidnValues.datFinishDate.Value
            'End If

            'If Not hidnValues.datStartDate.HasValue Then
            '    ILIAggModelSetParams.datStartDate = hidnValues.datStartDate.Value
            'End If





            ILIAggModelSetParams.intWeek = Addweek
            ILIAggModelSetParams.intYear = Addyear


            ConvertDateRangeFromDDL(Addyear, Addweek)




            If (Not hdfdatStartDate.Value.IsValueNullOrEmpty) Then
                ILIAggModelSetParams.datStartDate = hdfdatStartDate.Value
            Else
                ILIAggModelSetParams.datStartDate = DateAndTime.Now
            End If





            If (Not hdfdatFinishDate.Value.IsValueNullOrEmpty) Then
                ILIAggModelSetParams.datFinishDate = hdfdatFinishDate.Value
            Else
                ILIAggModelSetParams.datFinishDate = DateAndTime.Now
            End If




            If (Not ddlILIAddHospitalName.SelectedValue.IsValueNullOrEmpty AndAlso ddlILIAddHospitalName.SelectedValue <> "-1") Then
                ILIAggModelSetParams.idfHospital = ddlILIAddHospitalName.SelectedValue.ToInt64
                hdfstrHospitalName.Value = ddlILIAddHospitalName.SelectedItem.ToString

            End If

            If (Not hdfint0to4.Value.IsValueNullOrEmpty) Then
                ILIAggModelSetParams.intAge0_4 = hdfint0to4.Value.ToInt32()
            Else
                ILIAggModelSetParams.intAge0_4 = 0
            End If

            If (Not hdfint5to14.Value.IsValueNullOrEmpty) Then
                ILIAggModelSetParams.intAge5_14 = hdfint5to14.Value.ToInt32()
            Else
                ILIAggModelSetParams.intAge5_14 = 0
            End If

            If (Not hdfint15to29.Value.IsValueNullOrEmpty) Then
                ILIAggModelSetParams.intAge15_29 = hdfint15to29.Value.ToInt32()
            Else
                ILIAggModelSetParams.intAge15_29 = 0
            End If

            If (Not hdfint30to64.Value.IsValueNullOrEmpty) Then
                ILIAggModelSetParams.intAge30_64 = hdfint30to64.Value.ToInt32()
            Else
                ILIAggModelSetParams.intAge30_64 = 0
            End If

            If (Not hdfint65toUp.Value.IsValueNullOrEmpty) Then
                ILIAggModelSetParams.intAge65 = hdfint65toUp.Value.ToInt32()
            Else
                ILIAggModelSetParams.intAge65 = 0
            End If

            If (Not hdfintILITotal.Value.IsValueNullOrEmpty) Then
                ILIAggModelSetParams.inTotalIli = hdfintILITotal.Value.ToInt32()
            Else
                ILIAggModelSetParams.inTotalIli = 0
            End If

            If (Not hdfintILITotalAdmiss.Value.IsValueNullOrEmpty) Then
                ILIAggModelSetParams.intTotalAdmissions = hdfintILITotalAdmiss.Value.ToInt32()
            Else
                ILIAggModelSetParams.intTotalAdmissions = 0
            End If

            If (Not hdfintILITotalSamples.Value.IsValueNullOrEmpty) Then
                ILIAggModelSetParams.intIliSamples = hdfintILITotalSamples.Value.ToInt32()
            Else
                ILIAggModelSetParams.intIliSamples = 0

            End If




            Dim returnResults = HumanServiceClientAPIClient.ILIAggCaseSetAsync(ILIAggModelSetParams).Result

            If returnResults.FirstOrDefault().ReturnCode = 0 Then
                ' lblFORMID.Text = GetLocalResourceObject("Hdg_Add_Update_Success_Message.Text").ToString() + returnResults.FirstOrDefault().strFormID.ToString()
                lblFORMID.Text = GetLocalResourceObject("Hdg_Add_Update_Success_Message.Text").ToString() + returnResults.FirstOrDefault().strFormID
                '              hdfFormID.Value = returnResults.FirstOrDefault().strFormID.ToString()
                hdfFormID.Value = returnResults.FirstOrDefault.strFormID

            Else
                lblFORMID.Text = GetLocalResourceObject("Warning_Message_Cannot_Save_SubHeading.Text").ToString()
            End If


        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw ex
        End Try

    End Sub
    Protected Sub btnNewILI_Click(sender As Object, e As EventArgs)

        divILIAggSearchCriteria.Visible = False
        divILIAggSearchResults.Visible = False

        ClearControl(divILIAggregateAddEdit)
        DisplayBtnsForAddAgg()

        SetupForAddOrUpate()




        divILIAggregateAddEdit.Visible = True
        gvILITable.DataSource = New List(Of Object)
        gvILITable.DataBind()

        btnAddNext.Visible = False





    End Sub
    Private Sub SetDefaultsAndLimits()
        Try
            'set limits on calendars, etc
            '            ddlintYear.SelectedValue = DateTime.Now.Year
            Dim strYear = DateTime.Now.Year

            Dim intCurrentYear = CType(strYear, Int32)
            ResetWeeks(intCurrentYear)
            txtdatSearchWeeksToDate.Text = String.Format("{0:MM/dd/yyyy}", DateTime.Today.Date)
            txtdatSearchWeeksFromDate.Text = String.Format("{0:MM/dd/yyyy}", DateTime.Today.Date)
            'txtdatDateEnteredDate.Text = DateTime.Today.ToShortDateString()
            txtdatEnteredDate.Text = String.Format("{0:MM/dd/yyyy}", DateTime.Today.Date)

            txtdatLastSaveDate.Text = DateTime.Today.ToShortDateString() 'should equal value when submit is selected
            txtdatLastSaveDate.Enabled = False

            'txtstrEnteredBy.Text = Session("UserName").ToString()
            txtstrEnteredBy.Text = Session("FirstName") & " " & Session("FamilyName")

            'txtstrSite.Text = Session("Institution").ToString()
            txtstrSite.Text = Session("Organization")

            txtstrFormId.Text = ""

            txtdatSearchWeeksFromDate.Text = ""


            hdfidfEnteredByPerson.Value = Session("Person").ToString() 'This is needed by database


            txtSearchformILIAggCode.Text = "(new)"
        Catch ex As Exception
            Log.Error("ILI Aggregate set defaults  error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_ILIAggregate_Defaults.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorILIAgg.ClientID & "');});", True)
        End Try
    End Sub
    Private Sub SetupForAddOrUpate()

        SetDefaultsAndLimits()
        PopulateEditDropDowns()


    End Sub
    Private Sub PopulateEditDropDowns()
        Try
            FillUpToCurrentYear()
            Dim list As List(Of GblOrganizationByTypeGetListModel) = CrossCuttingAPIService.OrganizationByTypeGetListAsync(GetCurrentLanguage(), OrganizationTypes.Hospital).Result
            FillDropDownList(ddlidfILIAggDataSite, list, {GlobalConstants.NullValue}, OrganizationConstants.OrganizationID, OrganizationConstants.OrganizationName, Nothing, Nothing, True)

            list = CrossCuttingAPIService.OrganizationByTypeGetListAsync(GetCurrentLanguage(), OrganizationTypes.Laboratory).Result
            'FillDropDownList(ddlidfILIAggHospitalName, list, {GlobalConstants.NullValue}, OrganizationConstants.OrganizationID, OrganizationConstants.OrganizationName, Nothing, Nothing, True)
            'FillDropDownList(ddlILIAddHospitalName, list, {GlobalConstants.NullValue}, OrganizationConstants.OrganizationID, OrganizationConstants.OrganizationName, Nothing, Nothing, True)

            'FillDropDownList(ddlidfILIAggHospitalName, list, {GlobalConstants.NullValue}, OrganizationConstants.idfInstitution, OrganizationConstants.OrganizationName, Nothing, Nothing, True)
            'FillDropDownList(ddlILIAddHospitalName, list, {GlobalConstants.NullValue}, OrganizationConstants.idfInstitution, OrganizationConstants.OrganizationName, Nothing, Nothing, True)


            'This replaces above dropdowns

            FillDropDown(ddlidfILIAggHospitalName, GetType(clsOrganization), Nothing, OrganizationConstants.idfInstitution, OrganizationConstants.OrgFullName, Nothing, Nothing, True)
            FillDropDown(ddlILIAddHospitalName, GetType(clsOrganization), Nothing, OrganizationConstants.idfInstitution, OrganizationConstants.OrgFullName, Nothing, Nothing, False)



        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub
    Private Sub ClearControl(ByRef sectionName As Web.UI.Control)

        ResetForm(sectionName)

    End Sub
    Private Sub DisplayBtnsForAddAgg()

        btnCancelDelete.Visible = False

        btnILICancel.Visible = False
        btnNewILIAgg.Visible = False  ' Not sure if needed - investigate

        btnCancelSearch.Visible = False

        btnSubmit.Visible = True
        btnCancelAdd.Visible = True
        btnPrint.Visible = True




        btnPrint.Visible = False     ' May not be needed here need to verify
    End Sub
    Private Sub DisplayBtnsForEditAgg()

        btnCancelDelete.Visible = False

        btnILICancel.Visible = False
        btnNewILIAgg.Visible = False  ' Not sure if needed - investigate

        btnCancelSearch.Visible = False

        btnSubmit.Visible = True
        btnCancelAdd.Visible = True
        btnPrint.Visible = True




        btnPrint.Visible = False     ' May not be needed here need to verify
    End Sub
    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)

        Log.Info("ILIAggregate Create Submit is called")
        Dim Addyear As Int32 = 0
        '        btnDelete.Visible = False
        btnILICancel.Visible = False 'Should be able to cancel if they want to submit another edit -- no cancel already displayed
        If Not editting Then
            Addyear = 2019 ' Need to be debugged
        Else
            Addyear = yearIntForEdit
        End If
        ' Get the weeks and Year

        If Not (ddlintYear.SelectedValue.IsValueNullOrEmpty) Then
            Addyear = ddlintYear.SelectedValue
        End If
        Dim Addweek As Int32 = 1



        If (Not ddlintWeek.SelectedValue.IsValueNullOrEmpty AndAlso ddlintWeek.SelectedValue <> "-1") Then
            Dim strWeek = ddlintWeek.SelectedItem.Value
            Dim subStringWeek As String = ""
            If strWeek.Length = 7 Then

                subStringWeek = Right(strWeek, 2)
            Else
                subStringWeek = Right(strWeek, 1)
            End If
            Addweek = subStringWeek.ToInt32()

        End If




        AddOrUpdateAggApi(Addyear, Addweek)
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & divSuccessModalContainer.ClientID & "').modal('show');});", True)


        ddlintYear.Enabled = True
        ddlintWeek.Enabled = True

        btnSubmit.Visible = False
        btnAddILIAgg.Visible = True
        btnSearch.Visible = True
        btnAddNext.Visible = True

        divILIAggregateAddEdit.Visible = True  ' Add this during debugging

        'editSearch.Visible = False
        divILIAggSearchResults.Visible = True
        Log.Info("ILIAggregate Create End")

    End Sub
    Protected Sub btnClear_Click(sender As Object, e As EventArgs)
        PopulateSearchDropDowns()
        ClearSearch()

    End Sub
    Protected Sub btnClearAdd_Click(sender As Object, e As EventArgs)
        SetDefaultsAndLimits()

    End Sub
    Protected Sub btnCancelDelete_Click(sender As Object, e As EventArgs)
        divILIAggregateAddEdit.Visible = False
        divILIAggSearchCriteria.Visible = True
    End Sub
    Protected Sub btnILICancel_Click(sender As Object, e As EventArgs)
        divILIAggSearchCriteria.Visible = True  'NOt working -- Need to investigate
        divILIAggSearchResults.Visible = True
        divILIAggregateAddEdit.Visible = False

    End Sub

    Protected Sub btnReturnToILIAggRecord_Click(sender As Object, e As EventArgs) Handles btnReturnToILIAggRecord.Click

        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & divSuccessModal.ClientID & "').modal('hide');});", True)

        'ucAddUpdateILIAgg.Setup(initialPanelID:=0, sUserAction:=UserAction.Update, ILIAggID:=ViewState(CALLER_KEY))

    End Sub

    Protected Sub btnReturnToAggrRecord_Click(sender As Object, e As EventArgs)

        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & divSuccessModalContainer.ClientID & "').modal('hide');});", True)

        '       GetSearchFields()
        txtSearchformILIAggCode.Text = hdfFormID.Value

        txtstrFormId.Text = hdfFormID.Value ' Put value that was createdd in add page when return to agg after create


        '
        divILIAggSearchResults.Visible = False
        'btnILICancel.Visible = False
        btnRTClear.Visible = True
        btnAddNext.Visible = True



    End Sub
    Protected Sub ddlidfILIAggHospitalName_SelectedIndexChanged(sender As Object, e As EventArgs)
        '        resetSearch()
    End Sub
    Protected Sub ddlidfILIAggHospitalName1_SelectedIndexChanged(sender As Object, e As EventArgs)
        '        resetSearch()
    End Sub

    Protected Sub ddlidfILIAggDataSite_SelectedIndexChanged(sender As Object, e As EventArgs)
        '        resetSearch()
    End Sub

    Private Sub ClearSearch()

        InitializeSearchPage()


    End Sub

    Protected Sub txtdatLastSaveDate_TextChanged(sender As Object, e As EventArgs)
        ' SetNotifyDateMin()
    End Sub

    Protected Sub ddlintYear_SelectedIndexChanged(sender As Object, e As EventArgs)
        ResetTimes()
        SaveDateRangeFromDDL(sender, e)
    End Sub

#End Region

#Region "Period Setups"
    Private Sub ResetTimes()
        Try
            'based on new value of year, adjust the more granular time frames

            Dim year As String = ddlintYear.SelectedValue ' if in edit mode then year is value of year in start date

            If editting Then
                year = yearIntForEdit

            End If


            ResetWeeks(year)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Private Sub FillUpToCurrentYear()
        Try
            'Range of years to be 1900 to current year, descending
            For y = DateTime.Today.Year To 1900 Step -1
                Dim li As ListItem = New ListItem(y.ToString(), y.ToString())
                ddlintYear.Items.Add(li)
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub
    Private Sub ResetWeeks(ByVal year As Integer)
        Try

            ddlintWeek.DataSource = oAgg.FillWeekList(year)
                oAgg.FillPeriod(ddlintWeek, True)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Private Shared Function CreatePeriodTable() As DataTable

        Dim dt As New DataTable
        dt.Columns.Add(New DataColumn("PeriodNumber", GetType(Integer)))
        dt.Columns.Add(New DataColumn("StartDay", GetType(DateTime)))
        dt.Columns.Add(New DataColumn("FinishDay", GetType(DateTime)))
        dt.Columns.Add(New DataColumn("PeriodName", GetType(String)))
        dt.Columns.Add(New DataColumn("PeriodID", GetType(String)))
        dt.PrimaryKey = New DataColumn() {dt.Columns("PeriodNumber")}
        Return dt

    End Function


    Protected Sub ConvertDateRangeFromDDL(syear As Int32, sweek As Int32)


        Try
            Dim sDateYear As DateTime = Nothing
            sDateYear = New DateTime(syear.ToString)

            Dim m_WeekList As DataTable = New DataTable()
            Dim WeeksList As List(Of WeekPeriod) = New List(Of WeekPeriod)

            'ddlintWeek.DataSource = oAgg.FillWeekList(year)
            'oAgg.FillPeriod(ddlintWeek, True)



            m_WeekList.Clear()
            m_WeekList = CreatePeriodTable()



            For Each wp As WeekPeriod In GetWeeksList(syear)
                If (wp.weekStartDate.Year = DateTime.Today.Year AndAlso wp.weekStartDate > DateTime.Today) Then
                    Exit For
                End If
                Dim weekRow As DataRow = m_WeekList.NewRow

                weekRow("PeriodNumber") = wp.weekNumber
                weekRow("StartDay") = wp.weekStartDate
                weekRow("PeriodID") = year.ToString() + "_" + wp.weekNumber.ToString()
                weekRow("FinishDay") = wp.weekEndDate
                weekRow("PeriodName") = String.Format("{0:d} - {1:d}", weekRow("StartDay"), weekRow("FinishDay"))
                m_WeekList.Rows.Add(weekRow)
                If wp.weekNumber = sweek Then
                    Dim beginweekdate As DateTime = weekRow("StartDay")
                    Dim endweekdate As DateTime = weekRow("FinishDay")
                    FillHiddenDates(beginweekdate.ToShortDateString(), endweekdate.ToShortDateString())
                    Exit For
                End If
            Next






        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    Private Function GetWeeksList(year As Integer) As List(Of WeekPeriod)

        Dim wStartDate As DateTime = New DateTime(year, 1, 1)
        Dim lastDayOfYear As DateTime = wStartDate.AddYears(1).AddDays(-1)
        Dim weekNum As Int16 = 1

        Try
            'if year selected is current year, set last date to today
            If lastDayOfYear > DateTime.Today Then lastDayOfYear = DateTime.Today

            'in the loop, each week starts 7 days after the previous start date
            While wStartDate < lastDayOfYear
                Dim wPer = New WeekPeriod()
                wPer.year = year
                wPer.weekNumber = weekNum
                wPer.weekStartDate = wStartDate
                wPer.weekEndDate = wStartDate.AddDays(6)
                WeeksList.Add(wPer)

                weekNum = weekNum + 1
                wStartDate = wStartDate.AddDays(7)
            End While

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

        Return WeeksList

    End Function
    Protected Sub SaveDateRangeFromDDL(sender As Object, e As EventArgs)

        Dim ddl As DropDownList = CType(sender, DropDownList)
        Dim sDate As DateTime = Nothing
        Dim eDate As DateTime = Nothing

        Try


            Select Case ddl.ID.ToString()
                Case "ddlintYear"
                    sDate = New DateTime(ToInt16(ddlintYear.SelectedItem.ToString()), 1, 1)
                    eDate = sDate.AddYears(1).AddDays(-1)
                    FillHiddenDates(sDate.ToShortDateString(), eDate.ToShortDateString())
                Case "ddlintWeek"
                    sDate = New DateTime(Now.Year, Now.Month, 1)
                    eDate = sDate.AddMonths(1).AddDays(-25)
                    FillHiddenDates(sDate.ToShortDateString(), eDate.ToShortDateString())
            End Select

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    Private Sub FillHiddenDates(start As String, endD As String)
        'populate hidden fields 
        hdfdatStartDate.Value = start
        hdfdatFinishDate.Value = endD

    End Sub

#End Region


#Region "ILIAggSearchResultgridview"

    Protected Sub gvILIAggs_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvILIAggs.RowCancelingEdit
        'Do not remove. Cancel Row Update will Not Work Properly
    End Sub

    Protected Sub gvILIAggs_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvILIAggs.RowCommand
        Try
            Log.Info("ILI Aggregate convert to edit mode begins")


            Dim index As Integer = Convert.ToInt32(e.CommandArgument)
            hdfDeleteIndex.Value = index.ToString()
            '           Dim strFormIndex As String = gvILIAggs.DataKeys(e.Row.RowIndex).Values("strFormID").ToString()


            Select Case e.CommandName
                Case "delete"
                    Try
                        gvILIAggs.EditIndex = index
                        gvILIAggs.Rows(index).RowState = DataControlRowState.Edit
                        Dim strformID As Label = gvILIAggs.Rows(index).FindControl("lblstrFormID")
                        Dim AggregateHeaderId As Label = gvILIAggs.Rows(index).FindControl("AggregateHeaderId")

                        hdfAggregateHeaderId.Value = AggregateHeaderId.Text
                        hdfstrFormIDEdit.Value = strformID.Text
                        lblCASEIDDel.Text = GetLocalResourceObject("lbl_DelCase.InnerText") & hdfstrFormIDEdit.Value

                        editting = True  ' Hack to get fix indexing bug need better solution 


                        'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('usrConfirmDelete');});", True)

                        '                       DeleteAggregateApi()


                    Catch ex As Exception
                        lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_ILIAggregate_Delete.InnerText")
                        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorILIAgg.ClientID & "');});", True)
                    End Try
                Case "edit"
                    Try
                        gvILIAggs.EditIndex = index
                        gvILIAggs.Rows(index).RowState = DataControlRowState.Edit
                        Dim strformID As Label = gvILIAggs.Rows(index).FindControl("lblstrFormID")
                        hdfstrFormIDEdit.Value = strformID.Text
                        '                  e.Cancel = True
                        editting = True  ' Hack to get fix indexing bug need better solution 
                        '                   PopulateAggregateForEditing()

                        PopulateAggregateForEditingApi()


                        btnCancelDelete.Visible = False
                        btnNewILIAgg.Visible = False
                        btnCancelSearch.Visible = False
                        btnSubmit.Visible = True


                        divILIAggSearchCriteria.Visible = False
                        divILIAggSearchResults.Visible = False
                        divILIAggregateAddEdit.Visible = True





                        yearIntForEdit = CType(hdfintYearEdit.Value, Int32)
                        FillUpToCurrentYear()  ' COuld populate edit dropdown
                        ddlintYear.SelectedValue = yearIntForEdit


                        txtstrEnteredBy.Text = hdfUserNameEdit.Value
                        txtstrFormId.Text = hdfstrFormIDEdit.Value
                        txtstrSite.Text = hdfOrganizationEdit.Value
                        txtdatEnteredDate.Text = hdfdatEntered.Value
                        '                        txtdatLastSaveDate.Text = hdfdatLastSaved.Value
                        txtdatLastSaveDate.Text = DateAndTime.Now.ToShortDateString()
                        txtdatLastSaveDate.Enabled = False  'Can't change this date
                        'Add ILI Table values to Edit




                        Dim list1 As List(Of GblOrganizationByTypeGetListModel) = CrossCuttingAPIService.OrganizationByTypeGetListAsync(GetCurrentLanguage(), OrganizationTypes.Hospital).Result
                        FillDropDownList(ddlidfILIAggDataSite, list1, {GlobalConstants.NullValue}, OrganizationConstants.OrganizationID, OrganizationConstants.OrganizationName, Nothing, Nothing, True)

                        'list1 = CrossCuttingAPIService.OrganizationByTypeGetListAsync(GetCurrentLanguage(), OrganizationTypes.Laboratory).Result
                        'FillDropDownList(ddlILIAddHospitalName, list1, {GlobalConstants.NullValue}, OrganizationConstants.OrganizationID, OrganizationConstants.OrganizationName, Nothing, Nothing, True)
                        FillDropDown(ddlILIAddHospitalName, GetType(clsOrganization), Nothing, OrganizationConstants.idfInstitution, OrganizationConstants.OrgFullName, Nothing, Nothing, False)

                        '                       btnDelete.Visible = False



                        ResetTimes() 'Calls reset weeks and genneratingan error


                        editting = False

        Catch ex As Exception
        Log.Error("ILI Aggregate convert to edit mode  error:", ex)
        lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_ILIAggregate_Edit.InnerText")
                        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorILIAgg.ClientID & "');});", True)
                    End Try
        Case "update"
        Try

        Catch ex As Exception
                        '                  lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_SampleType_Update.InnerText")
                        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorILIAgg.ClientID & "');});", True)
                    End Try
        Case "cancel"
        Try
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelSampleType');});", True)
        Catch ex As Exception
                        '                   lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_SampleType_Cancel.InnerText")
                        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorILIAgg.ClientID & "');});", True)
                    End Try
        Case "insert"
        Try

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Adding_ILI.InnerText")
                        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorILIAgg.ClientID & "');});", True)
                    End Try
        End Select
        Log.Info("ILI Aggregate convert to edit mode ends")

        Catch ex As Exception
        Log.Error("ILI Aggregate convert to edit mode  error:", ex)
        lbl_Error.InnerText = GetLocalResourceObject("lbl_Edit_Mode_Error.InnerText")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('errorReference');});", True)
        End Try

    End Sub

    Protected Sub gvILIAggs_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvILIAggs.RowDataBound

    End Sub

    Protected Sub gvILIAggs_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvILIAggs.RowEditing
        'Do not remove. Edit Row Will Not Work Properly
    End Sub

    Protected Sub gvILIAggs_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvILIAggs.RowUpdating
        'Do not remove. Update Row will Not Work Properly
    End Sub

    Protected Sub gvILIAggs_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        'Do not remove. Delete Row will Not Work Properly


        Log.Info("ILI Aggregate delete mode begins")


        Dim index As Integer = Convert.ToInt32(e.RowIndex)
        hdfDeleteIndex.Value = index.ToString()
        hdfstrFormIDEdit.Value = e.Keys.Item(0).ToString()
        lblCASEIDDel.Text = GetLocalResourceObject("lbl_DelCase.InnerText") & hdfstrFormIDEdit.Value

        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('usrConfirmDelete');});", True)




    End Sub










    Private Sub DeleteAggregateApi()
        'If Not IsNothing(ViewState("aggCase")) Then


        Try



            Dim strformid As String = hdfstrFormIDEdit.Value
            Dim detailID As Long = 0
            Dim headerID As Long = (CType(hdfAggregateHeaderId.Value, Long)) ' PUT IN THE HEADER ID THAT WE NEED TO GET THE DATA OF FOR EDIT

            Dim langId = GetCurrentLanguage()


            Dim returnValue = HumanServiceClientAPIClient.ILIAggregateCaseDeleteAsync(detailID, headerID).Result


            'USe this instead of below -- Need testing


            If ValidateForSearch() Then


                btnCancelSearch.Visible = True


                FillAggregateGrid(bRefresh:=True)
                btnShowSearchCriteria.Visible = True
                showSearchCriteria(False)
                btnCancelSearch.Visible = True
                btnNewILIAgg.Visible = True

                divILIAggSearchResults.Visible = True
                showClearandSearchButtons(False)

                Log.Info("ILIAggregate Search End")

            End If













            'divILIAggregateAddEdit.Visible = False

            'divILIAggSearchResults.Visible = True
            'btnShowSearchCriteria.Visible = True
            'showSearchCriteria(False)
            'showClearandSearchButtons(False)
            'GetSearchFields()

            'FillAggregateGrid("Page", True) 'When this is set true, page does not display properly
            'If Not editting Then
            '    hdfidfAggrCase.Value = "" 'After delete, fix problem  creating agregate
            'End If

        Catch ex As Exception
            Log.Error("ILI Aggregate populating aggregate  error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_ILIAggregate_Edit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorILIAgg.ClientID & "');});", True)
        End Try

    End Sub

    Private Sub PopulateAggregateForEditingApi()
        'If Not IsNothing(ViewState("aggCase")) Then


        Try

            Dim strformid As String = hdfstrFormIDEdit.Value
            Dim headerID As Int16 = 0  ' PUT IN THE HEADER ID THAT WE NEED TO GET THE DATA OF FOR EDIT
            Dim langId = GetCurrentLanguage()


            Dim listOfOneAgg As List(Of IliAggregateGetListModel) = HumanServiceClientAPIClient.ILIAggCaseGetlistAsync(langId, strformid, headerID, hdfidfSearchSite.Value.ToInt64, hdfidfSearchHospital.Value.ToInt64, hdfdatStartDate.Value, hdfdatFinishDate.Value).Result



            gvILITable.DataSource = Nothing
            gvILITable.DataSource = listOfOneAgg

            gvILITable.DataBind()

            Dim numRows = gvILITable.Rows.Count


            hdfintYearEdit.Value = listOfOneAgg(0).intYear.ToString
            hdfintWeekEdit.Value = listOfOneAgg(0).intWeek.ToString
            hdfstrHospitalEdit.Value = listOfOneAgg(0).HospitalName
            hdfidfHospitalEdit.Value = listOfOneAgg(0).idfHospital.ToString

            hdfUserNameEdit.Value = listOfOneAgg(0).UserName
            hdfOrganizationEdit.Value = listOfOneAgg(0).Organization
            hdfdatEntered.Value = listOfOneAgg(0).datDateEntered

            hdfint0to4Edit.Value = listOfOneAgg(0).intAge0_4.ToString
            hdfint5to14Edit.Value = listOfOneAgg(0).intAge5_14.ToString
            hdfint15to29Edit.Value = listOfOneAgg(0).intAge15_29.ToString
            hdfint30to64Edit.Value = listOfOneAgg(0).intAge30_64.ToString
            hdfint65toUpEdit.Value = listOfOneAgg(0).intAge65.ToString
            hdfintILITotalEdit.Value = listOfOneAgg(0).inTotalILI.ToString
            hdfintILITotalAdmissEdit.Value = listOfOneAgg(0).intTotalAdmissions.ToString
            hdfintILITotalSamplesEdit.Value = listOfOneAgg(0).intILISamples.ToString

            '            tb_TotalILI.Text = listOfOneAgg(0).inTotalILI.ToString

            hdfintILITotalEdit.Value = listOfOneAgg(0).inTotalILI.ToString



        Catch ex As Exception
            Log.Error("ILI Aggregate populating aggregate  error:", ex)
            lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_ILIAggregate_Edit.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorILIAgg.ClientID & "');});", True)
        End Try

    End Sub
    Private Sub SetupForAddOrUpateEdit()


        'FillCountry()  ' Get country value

        'PopulateEditDropDowns()
        ''SetDefaultsAndLimits()
        'If Not hdfstrCaseID.Value.IsValueNullOrEmpty Then
        '    txtstrCaseID.Text = hdfstrCaseID.Value
        'End If
        'ToggleEditAdminDdls(ddlifdsSearchAdministrativeLevel)

    End Sub
    Private Sub DeleteAgg()
        'If Not IsNothing(ViewState("aggCase")) Then


        '    oAgg.Delete(Double.Parse(hdfidfAggrCase.Value))


        '    HumanAggregate.Visible = False

        '    search.Visible = True
        '    btnShowSearchCriteria.Visible = True
        '    showSearchCriteria(False)
        '    showClearandSearchButtons(False)
        '    GetSearchFields()

        '    FillAggregateGrid("Page", True) 'When this is set true, page does not display properly

        'End If
    End Sub
    Private Sub DeleteAggApi()
        Try
            'If Not IsNothing(ViewState("aggCase")) Then


            '    'oAgg.Delete(Double.Parse(hdfidfAggrCase.Value))

            '    If Not hdfidfAggrCase.Value.IsValueNullOrEmpty Then

            '        Dim parameters As Long = CType(hdfidfAggrCase.Value, Long)
            '        '                   parameters = CInt(hdfidfAggrCase.Value)
            '        Dim returnValue = HumanServiceClientAPIClient.HumanAggregateCaseDeleteAsync(parameters).Result
            '    End If


            '    HumanAggregate.Visible = False

            '    search.Visible = True
            '    btnShowSearchCriteria.Visible = True
            '    showSearchCriteria(False)
            '    showClearandSearchButtons(False)
            '    GetSearchFields()

            '    FillAggregateGrid("Page", True) 'When this is set true, page does not display properly
            '    If Not editting Then
            '        hdfidfAggrCase.Value = "" 'After delete, fix problem  creating agregate
            '    End If

            'End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

#End Region







#Region "Modal Button"

    'Protected Sub btnDeleteYes_Click(sender As Object, e As EventArgs) Handles btnDeleteYes.ServerClick
    '    Try
    '        oCommon = New clsCommon()
    '        oService = oCommon.GetService()
    '        Dim oHASC As clsHumanActiveSurveillance = New clsHumanActiveSurveillance()
    '        Dim id As Double = Convert.ToInt64(hdfidfCampaign.Value)

    '        oDS = oHASC.SelectOne(id)

    '        If (oDS.CheckDataSet) Then
    '            If oDS.Tables(2).Rows.Count() = 0 Then
    '                oHASC.Delete(id)

    '                searchForm.Visible = True
    '                campaignInformation.Visible = False
    '                btnShowSearchCriteria.Visible = True

    '                If hdfDeleteCampaignFromSearchResults.Value Then
    '                    searchResults.Visible = True

    '                    Dim dt As DataTable = ViewState(results)
    '                    Dim dr As DataRow() = dt.Select(ActiveSurveillanceCampaignConstants.Campaign & "=" & hdfidfCampaign.Value)

    '                    If (dr.Count() > 0) Then
    '                        For i As Integer = 0 To dr.Count() - 1
    '                            dt.Rows.Remove(dr(i))
    '                        Next
    '                    End If

    '                    gvSearchResults.DataSource = dt
    '                    gvSearchResults.DataBind()

    '                    ViewState(results) = dt
    '                Else
    '                    showClearandSearchButtons(True)
    '                End If


    '                hdfDeleteCampaignFromSearchResults.Value = False
    '                hdfCampaignIndex.Value = "NULL"

    '                lblCampaignSuccess.InnerText = GetLocalResourceObject("lbl_Successful_Deletion.InnerText")
    '                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('successDeleteCampaign');});", True)
    '            Else
    '                If hdfDeleteCampaignFromSearchResults.Value = False Then
    '                    hdnPanelController.Value = 2
    '                    showHideSectionsandSidebarItems()
    '                End If

    '                lbl_Error.InnerText = GetLocalResourceObject("lbl_Cannot_Delete_Campaign.InnerText")
    '                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
    '            End If
    '        End If
    '    Catch
    '        lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Delete_Campaign.InnerText")
    '        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
    '    End Try
    'End Sub

    'Protected Sub btnReturnToSearch_Click(sender As Object, e As EventArgs) Handles btnReturnToSearch.ServerClick, btnRTS.ServerClick
    '    hdfidfCampaign.Value = "NULL"
    '    ViewState(campaign) = Nothing
    '    ViewState(campaignSamples) = Nothing
    '    ViewState(campaignSessions) = Nothing

    '    clearCampaign()
    '    hdfidfCampaign.Value = "NULL"

    '    'btnCancelCampaignRTD.Visible = False
    '    'btnCancelCampaignSearch.Visible = True

    '    showClearandSearchButtons(False)
    '    showSearchCriteria(False)
    '    campaignInformation.Visible = False

    '    searchForm.Visible = True
    '    btnShowSearchCriteria.Visible = True
    '    searchResults.Visible = True
    '    FillCampaignGV(True)
    'End Sub

    'Protected Sub btnDeleteSampleType_Click(sender As Object, e As EventArgs) Handles btnDeleteSampleType.ServerClick
    '    Try
    '        Dim dt As DataTable = ViewState(campaignSamples)

    '        Dim oHASC As clsHumanActiveSurveillance = New clsHumanActiveSurveillance()
    '        Dim results As Object = Nothing

    '        If hdfCampaignToSampleTypeID.Value <> "NULL" And hdfCampaignToSampleTypeID.Value <> "" Then
    '            oHASC.DeleteSample(Convert.ToDouble(hdfCampaignToSampleTypeID.Value), results)
    '        End If

    '        dt.Rows.RemoveAt(hdfCampaignToSampleTypeIndex.Value)
    '        gvSamples.DeleteRow(hdfCampaignToSampleTypeIndex.Value)
    '        gvSamples.DataSource = dt
    '        gvSamples.DataBind()

    '        ViewState(campaignSamples) = dt
    '        hdfCampaignToSampleTypeID.Value = "NULL"
    '        hdfCampaignToSampleTypeIndex.Value = "NULL"

    '        showHideSectionsandSidebarItems()
    '        hdnPanelController.Value = "1"

    '        populateSampleTypeAdd()
    '    Catch ex As Exception
    '        lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_SampleType_Delete.InnerText")
    '        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorCampaign.ClientID & "');});", True)
    '    End Try
    'End Sub

#End Region



#Region "ILITable"


    Protected Sub gvILITable_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim SelectRow As GridViewRow = gvILITable.SelectedRow
        Dim HospitalName As String = SelectRow.Cells(7).Text


    End Sub

    Protected Sub gvILITable_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs) Handles gvILITable.RowCancelingEdit
        'Do not remove. Cancel Row Update will Not Work Properly
    End Sub

    Protected Sub gvILITable_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvILITable.RowCommand

        ' gvILITable.FooterRow.Visible = True

        Dim index As Integer = Convert.ToInt32(e.CommandArgument)
        hdfILITableTypeIndex.Value = index.ToString()

        Dim ddlHospital As DropDownList = (CType(CType(sender, GridView).HeaderRow.FindControl("ddlILIAddHospitalName1"), DropDownList))
        FillDropDown(ddlHospital, GetType(clsOrganization), Nothing, OrganizationConstants.idfInstitution, OrganizationConstants.OrgFullName, Nothing, Nothing, False)



        Select Case e.CommandName
            Case "delete"
                Try

                Catch ex As Exception
                    Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_ILIAggregate_Delete.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorILIAgg.ClientID & "');});", True)
                End Try
            Case "edit"
                Try
                    Dim idx As Integer = Convert.ToInt32(e.CommandArgument)
                    Dim row As GridViewRow = gvILITable.Rows(idx)
                    gvILITable.EditIndex = index
                    gvILITable.Rows(index).RowState = DataControlRowState.Edit

                    'Can take lbls and store them in the spinner here???
                    '                 Dim lblint0to4 As EIDSSControlLibrary.NumericSpinner = gvILITable.HeaderRow.FindControl("lbl_0_to_4") 'problem is not header row
                    'Dim lblint0to4 As EIDSSControlLibrary.NumericSpinner = gvILITable.HeaderRow.FindControl("lbl_0_to_4") 'problem is not header row


                    ' Make lbl_0_4 and others disappear or disabled on the edit mode forcing entry  
                    'Dim txtlbl0to4 = lblint0to4.ToString

                    'try this
                    '                    Dim columnlblint0to4Value As String = e..FindControl("lblName").Text


                Catch ex As Exception
                    Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_ILIAggregate_Edit.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorILIAgg.ClientID & "');});", True)
                End Try
            Case "update"
                Try
                    'For update it is not putting data in the header it is in the body

                    'Dim txtEdint0to4 As EIDSSControlLibrary.NumericSpinner = gvILITable.Columns.Contains("lbl_0_to_4")


                    Dim txtint0to4 As EIDSSControlLibrary.NumericSpinner = gvILITable.HeaderRow.FindControl("txtint0to4")
                    Dim txtint5to14Rate As EIDSSControlLibrary.NumericSpinner = gvILITable.HeaderRow.FindControl("txtint5to14Rate")
                    Dim txtint15to29Rate As EIDSSControlLibrary.NumericSpinner = gvILITable.HeaderRow.FindControl("txtint15to29Rate")
                    Dim txtint30to64Rate As EIDSSControlLibrary.NumericSpinner = gvILITable.HeaderRow.FindControl("txtint30to64Rate")
                    Dim txtint65toUp As EIDSSControlLibrary.NumericSpinner = gvILITable.HeaderRow.FindControl("txtint65toUp")
                    Dim txtTotalAdmiss As EIDSSControlLibrary.NumericSpinner = gvILITable.HeaderRow.FindControl("txtTotalAdmiss")
                    Dim txtTotalSamples As EIDSSControlLibrary.NumericSpinner = gvILITable.HeaderRow.FindControl("txtTotalSamples")

                    Dim TotalSamples As Integer
                    Dim TotalAdmiss As Integer
                    Dim int65toUp As Integer
                    Dim int30to64 As Integer
                    Dim int15to29 As Integer
                    Dim int5to14 As Integer
                    Dim int0to4 As Integer


                    'If Not IsNothing(ddlILIAddHospitalName) Or Not (IsNothing(txtint0to4) Or IsNothing(txtint5to14Rate) Or IsNothing(txtint15to29Rate) Or IsNothing(txtint30to64Rate) Or IsNothing(txtint65toUp)) Then
                    If Not IsNothing(ddlILIAddHospitalName) Then


                        If Not IsNothing(txtint0to4) Then
                            int0to4 = Convert.ToInt32(txtint0to4.Text)
                            hdfint0to4.Value = txtint0to4.Text
                        End If

                        If Not IsNothing(txtint5to14Rate) Then
                            int5to14 = Convert.ToInt32(txtint5to14Rate.Text)
                            hdfint5to14.Value = txtint5to14Rate.Text
                        End If
                        If Not IsNothing(txtint15to29Rate) Then
                            int15to29 = Convert.ToInt32(txtint15to29Rate.Text)
                            hdfint15to29.Value = txtint15to29Rate.Text
                        End If
                        If Not IsNothing(txtint30to64Rate) Then
                            int30to64 = Convert.ToInt32(txtint30to64Rate.Text)
                            hdfint30to64.Value = txtint30to64Rate.Text
                        End If
                        If Not IsNothing(txtint65toUp) Then
                            int65toUp = Convert.ToInt32(txtint65toUp.Text)
                            hdfint65toUp.Value = txtint65toUp.Text
                        End If

                        If Not IsNothing(txtTotalAdmiss) Then
                            TotalAdmiss = Convert.ToInt32(txtTotalAdmiss.Text)
                            hdfintILITotalAdmiss.Value = txtTotalAdmiss.Text
                        End If

                        If Not IsNothing(txtTotalSamples) Then
                            TotalSamples = Convert.ToInt32(txtTotalSamples.Text)
                            hdfintILITotalSamples.Value = txtTotalSamples.Text
                        End If

                        If (int0to4 < 0) Or (int5to14 < 0) Or (int15to29 < 0) Or (int30to64 < 0) Or (int65toUp < 0) Or (TotalAdmiss < 0) Or (TotalSamples < 0) Then
                                lbl_Error.InnerText = GetLocalResourceObject("lbl_Positive_ILIAggDetails_Number.InnerText")
                            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorILIAgg.ClientID & "');});", True)
                            Exit Sub
                            End If

                            Dim intILITotal As Integer = int0to4 + int5to14 + int15to29 + int30to64 + int65toUp

                            Dim txtintILITotal = intILITotal.ToString()
                            hdfintILITotal.Value = txtintILITotal

                            Dim row As Integer = 0

                            '                            CType(gvILITable.DataSource, DataTable).Rows(gvILITable.SelectedRow.RowIndex).SetField(Of String)("inTotalILI", txtintILITotal)


                            Dim txtTotalILI As TextBox = gvILIAggs.Rows(0).FindControl("tb_TotalILI")
                        Dim txtTotalILI1 As TextBox = gvILITable.Rows(0).FindControl("txt_TotalILI")


                        txtTotalILI.Text = txtintILITotal


                        End If
                Catch ex As Exception
                    Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_ILIAgg_Update.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorILIAgg.ClientID & "');});", True)
                End Try
            Case "cancel"
                Try
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('cancelSampleType');});", True)
                Catch
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_ILIAgg_Cancel.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorILIAgg.ClientID & "');});", True)
                End Try
            Case "insert"
                Try





                    Dim txtint0to4 As EIDSSControlLibrary.NumericSpinner = gvILITable.HeaderRow.FindControl("txtint0to4")
                    If String.IsNullOrEmpty(txtint0to4.Text) Then
                        txtint0to4.Text = "0"
                    End If

                    Dim txtint5to14Rate As EIDSSControlLibrary.NumericSpinner = gvILITable.HeaderRow.FindControl("txtint5to14Rate")
                    If String.IsNullOrEmpty(txtint5to14Rate.Text) Then
                        txtint5to14Rate.Text = "0"
                    End If

                    Dim txtint15to29Rate As EIDSSControlLibrary.NumericSpinner = gvILITable.HeaderRow.FindControl("txtint15to29Rate")
                    If String.IsNullOrEmpty(txtint15to29Rate.Text) Then
                        txtint15to29Rate.Text = "0"
                    End If

                    Dim txtint30to64Rate As EIDSSControlLibrary.NumericSpinner = gvILITable.HeaderRow.FindControl("txtint30to64Rate")
                    If String.IsNullOrEmpty(txtint30to64Rate.Text) Then
                        txtint30to64Rate.Text = "0"
                    End If

                    Dim txtint65toUp As EIDSSControlLibrary.NumericSpinner = gvILITable.HeaderRow.FindControl("txtint65toUp")
                    If String.IsNullOrEmpty(txtint65toUp.Text) Then
                        txtint65toUp.Text = "0"
                    End If

                    Dim txtTotalAdmiss As EIDSSControlLibrary.NumericSpinner = gvILITable.HeaderRow.FindControl("txtTotalAdmiss")
                    If String.IsNullOrEmpty(txtTotalAdmiss.Text) Then
                        txtTotalAdmiss.Text = "0"
                    End If

                    Dim txtTotalSamples As EIDSSControlLibrary.NumericSpinner = gvILITable.HeaderRow.FindControl("txtTotalSamples")
                    If String.IsNullOrEmpty(txtTotalSamples.Text) Then
                        txtTotalSamples.Text = "0"
                    End If




                    '                   If Not IsNothing(ddlILIAddHospitalName) And Not (IsNothing(txtint0to4) Or IsNothing(txtint5to14Rate) Or IsNothing(txtint15to29Rate) Or IsNothing(txtint30to64Rate) Or IsNothing(txtint65toUp)) Then
                    If Not IsNothing(ddlILIAddHospitalName) Then

                        Dim int0to4 As Integer = Convert.ToInt32(txtint0to4.Text)
                        hdfint0to4.Value = txtint0to4.Text
                        Dim int5to14 As Integer = Convert.ToInt32(txtint5to14Rate.Text)
                        hdfint5to14.Value = txtint5to14Rate.Text
                        Dim int15to29 As Integer = Convert.ToInt32(txtint15to29Rate.Text)
                        hdfint15to29.Value = txtint15to29Rate.Text
                        Dim int30to64 As Integer = Convert.ToInt32(txtint30to64Rate.Text)
                        hdfint30to64.Value = txtint30to64Rate.Text
                        Dim int65toUp As Integer = Convert.ToInt32(txtint65toUp.Text)
                        hdfint65toUp.Value = txtint65toUp.Text
                        Dim TotalAdmiss As Integer = Convert.ToInt32(txtTotalAdmiss.Text)
                        hdfintILITotalAdmiss.Value = txtTotalAdmiss.Text
                        Dim TotalSamples As Integer = Convert.ToInt32(txtTotalSamples.Text)
                        hdfintILITotalSamples.Value = txtTotalSamples.Text


                        If (int0to4 < 0) Or (int5to14 < 0) Or (int15to29 < 0) Or (int30to64 < 0) Or (int65toUp < 0) Or (TotalAdmiss < 0) Or (TotalSamples < 0) Then
                            lbl_Error.InnerText = GetLocalResourceObject("lbl_Positive_ILIAggDetails_Number.InnerText")
                            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorILIAgg.ClientID & "');});", True)
                            Exit Sub
                        End If

                        Dim intILITotal As Integer = int0to4 + int5to14 + int15to29 + int30to64 + int65toUp

                        Dim txtintILITotal = intILITotal.ToString()
                        hdfintILITotal.Value = txtintILITotal
                        '                       tb_TotalILI.Text = intILITotal.ToString()
                        Dim TotalILIName As String = intILITotal.ToString()


                        Dim TotalILIYears As Label = (CType(CType(sender, GridView).HeaderRow.FindControl("label_TotalILI"), Label))
                        TotalILIYears.Text = intILITotal.ToString()



                        'Dim row As GridViewRow = gvILITable.Rows(gvILITable.EditIndex)
                        ' Retrieve the textbox control from the row.
                        'gridview rowcommand indexDim list As TextBox = CType(row.FindControl("txt_TotalILI"), TextBox)

                        ' Add the selected value of the DropDownList control to 
                        ' the NewValues collection. The NewValues collection is
                        ' passed to the data source control, which then updates the 
                        ' data source.
                        '       e.NewValues("state") = list.Text




                        'gvILITable.DataSource = New List(Of Object)
                        'CType(gvILITable.DataSource, DataTable).Rows(gvILITable.SelectedRow.RowIndex).SetField(Of String)("inTotalILI", gvILITable..DataItem(tb1_TotalILI))
                        'gvILITable.DataBind()





                    End If
                Catch ex As Exception
                    Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                    lbl_Error.InnerText = GetLocalResourceObject("lbl_Error_Adding_ILI.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ showModal('" & errorILIAgg.ClientID & "');});", True)
                End Try
        End Select

    End Sub

    Protected Sub gvILITable_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvILITable.RowDataBound
        'Add dropdown values here to HospitalName ofr sure but first lets try some things


        'Dim ddlHospitalType As DropDownList = e.Row.FindControl("ddlILIAddHospitalName1")

        If e.Row.RowState = DataControlRowState.Edit Then

            ' Preselect the DropDownList control with the state value
            ' for the current row.

            ' Retrieve the underlying data item. In this example
            ' the underlying data item is a DataRowView object. 
            Dim rowView As DataRowView = CType(e.Row.DataItem, DataRowView)

            ' Retrieve the state value for the current row. 
            Dim totlalnum As String = rowView("totalnum").ToString()

            ' Retrieve the DropDownList control from the current row. 
            Dim listNum As TextBox = CType(e.Row.FindControl("tb1_TotalILI"), TextBox)

            ' Find the ListItem object in the DropDownList control with the 
            ' state value and select the item.
            'Dim item As ListItem = list.Items.FindByText(state)
            listNum.Text = hdfintILITotal.Value

        End If



        'If e.Row.RowType = DataControlRowType.DataRow Then

        '    Dim ddlSampleType As DropDownList = e.Row.FindControl("ddlSampleType")
        '    If Not IsNothing(ddlSampleType) Then
        '        Dim dr As DataRowView = TryCast(e.Row.DataItem, DataRowView)
        '        FillDropDown(ddlSampleType, GetType(clsSampleDisease), {ddlidfsDiagnosis.SelectedValue}, SampleTypeConstants.SampleTypeID, SampleTypeConstants.SampleTypeName, dr(SampleTypeConstants.SampleTypeID).ToString(), Nothing, True)
        '        disableEditSelectedSampleTypes(ddlSampleType)
        '        ddlSampleType.ToolTip = dr("sampleType")
        '    End If
        'ElseIf e.Row.RowType = DataControlRowType.Header Then
        '    populateSampleTypeAdd()
        'End If
    End Sub

    Protected Sub gvILITable_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvILITable.RowEditing
        'Do not remove. Edit Row Will Not Work Properly
    End Sub

    Protected Sub gvILITable_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles gvILITable.RowUpdating
        'Do not remove. Update Row will Not Work Properly
        Dim row As GridViewRow = gvILITable.Rows(gvILITable.EditIndex)
        ' Retrieve the textbox control from the row.
        Dim list As TextBox = CType(row.FindControl("txt_TotalILI"), TextBox)

        ' Add the selected value of the DropDownList control to 
        ' the NewValues collection. The NewValues collection is
        ' passed to the data source control, which then updates the 
        ' data source.
        '       e.NewValues("state") = list.Text
        e.NewValues("totalnum") = hdfintILITotal.Value

    End Sub

    Protected Sub gvILITable_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        'Do not remove. Delete Row will Not Work Properly




    End Sub

#End Region




    Class WeekPeriod
        Private _year As Int16
        Private _weekNumber As Int16
        Private _weekStartDate As DateTime
        Private _weekEndDate As DateTime

        Public Property year As Int16
            Get
                Return _year
            End Get
            Set(value As Int16)
                _year = value
            End Set
        End Property

        Public Property weekNumber As Int16
            Get
                Return _weekNumber
            End Get
            Set(value As Int16)
                _weekNumber = value
            End Set
        End Property

        Public Property weekStartDate As DateTime
            Get
                Return _weekStartDate
            End Get
            Set(value As DateTime)
                _weekStartDate = value
            End Set
        End Property

        Public Property weekEndDate As DateTime
            Get
                Return _weekEndDate
            End Get
            Set(value As DateTime)
                _weekEndDate = value
            End Set
        End Property
    End Class



End Class