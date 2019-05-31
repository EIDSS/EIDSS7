Imports System.Drawing
Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Public Class HumanAggregate
    Inherits BaseEidssPage

    Dim oAgg As clsAggregate = New clsAggregate()

    Private ReadOnly Log As log4net.ILog

    'Constants for Sections/Panels on the form
    Private Const CSEARCHRESULTS As String = "searchResults"
    Private Const CSEARCH As String = "search"
    Private Const CHUMANAGGR As String = "humanAggregate"
    Private Const SEARCH_FILE_PREFIX As String = "_HA"
    Private Const SEARCH_SP As String = "HumanGetList"
    'ddl TimeInterval
    Private Const TimeIntervalYEAR As Integer = 1
    Private Const TimeIntervalMONTH As Integer = 2
    Private Const TimeIntervalWEEK As Integer = 3

    'ddl AdministrativeLevel
    Private Const AdministrativeLevelCOUNTRY As Integer = 0
    Private Const AdministrativeLevelOrg As Integer = 1
    Private Const AdministrativeLevelRAYON As Integer = 2
    Private Const AdministrativeLevelREGION As Integer = 3
    Private Const AdministrativeLevelSETTLEMENT As Integer = 4
    Private Const AdministrativeLevelTOWN As Integer = 5




    Private Const HUMANAGG_DATASET As String = "dsHAggregate"
    Private Const HUMAN_DISEASE_REPORT_DATASET As String = "dsHumanDiseaseReports"
    Private Const SectionHumanAggReview As String = "Human Aggregate Review"
    Private Const SESSION_SEARCH_LIST As String = "gvHAC_List"
    Private Const SORT_DIRECTION As String = "gvHAC_SortDirection"
    Private Const SORT_EXPRESSION As String = "gvHAC_SortExpression"
    Private Const PAGINATION_SET_NUMBER As String = "gvHAC_PaginationSet"
    Private yearIntForEdit As Integer = 0
    Private editting As Boolean = False
    Dim ddlYear As String = "2019" ' Current year

    Private ReadOnly DiagnosisID As Long = 70023994201
    Private ReadOnly FormType As Long = 10034012

    Private ReadOnly HumanServiceClientAPIClient As HumanServiceClient
    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private FlexibleFormService As FlexibleFormServiceClient


#Region "Initialize"

    Sub New()
        Try
            Log = log4net.LogManager.GetLogger(GetType(AggregateSettings))
            Log.Info("Loading Contructor Classes AggregateSettings.aspx")
            HumanServiceClientAPIClient = New HumanServiceClient()
            CrossCuttingAPIService = New CrossCuttingServiceClient()

        Catch ex As Exception
            Log.Error("Error Loading Contructor Classes" & ex.Message)
            Throw ex
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            PopulateSearchDropDowns()
            gvHAC.DataSource = New List(Of Object)
            gvHAC.DataBind()
            FillCountry()
            InitializePage()


        Else

            If Not HttpContext.Current.Session("loadMatxrixTable") Is Nothing Then
                Dim loadMatxrixTable As Table = HttpContext.Current.Session("loadMatxrixTable")
                pnlCaseClassification.Controls.Add(loadMatxrixTable)
            End If

            Dim target As String = TryCast(Request("__EVENTTARGET"), String)
            Dim setName As String = "ctl00$EIDSSBodyCPH$sLI$ddlsLIidfsSettlement"
            Dim searchRegName As String = "ctl00$EIDSSBodyCPH$lucHumanAggregate$ddllucHumanAggregateidfsRegion"
            Dim searchRayName As String = "ctl00$EIDSSBodyCPH$lucHumanAggregate$ddllucHumanAggregateidfsRayon"

            If target.EqualsAny({searchRegName, searchRayName}) Then
                searchResults.Visible = False
                searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
                btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")
                btnShowSearchCriteria.Visible = False
            End If
        End If
    End Sub

    Private Sub InitializePage()
        ' searchResults.Visible = False
        ToggleVisibility(CSEARCH)
        hdfidfsAggrCaseType.Value = AggregateValue.Human
        hdfLangID.Value = getConfigValue("DefaultLanguage")
        txtstrSearchCaseID.Text = ""

    End Sub
#End Region
#Region "Common"
    Private Sub PopulateSearchDropDowns()


        BaseReferenceLookUp(ddlifdsSearchAdministrativeLevel, BaseReferenceConstants.AdministrativeLevel, blnBlankRow:=False)

        FillOrganizationList(ddlidfsOrganzation, Nothing, Nothing, True)

        BaseReferenceLookUp(ddlidfsTimeInterval, BaseReferenceConstants.StatisticalPeriodType, HACodeList.NoneHACode, blnBlankRow:=False)

        Try
            GetSearchFields()
            InitializeSearchFields()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub
    Private Sub InitializeSearchFields()

        Try
            'set defaults on these, per use case
            ddlidfsTimeInterval.SelectedIndex = TimeIntervalMONTH
            ddlifdsSearchAdministrativeLevel.SelectedIndex = AdministrativeLevelRAYON
            ClearAdministrativeUnitControl()


        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    Private Sub PopulateEditDropDowns()
        Try
            'time-based values
            FillUpToCurrentYear()
            'need to have year ddl populated before 
            ToggleEditTimeDdls(ddlidfsTimeInterval)
            'ToggleEditTimeDdlsApi(ddlidfsTimeInterval)
            If editting = True Then
                ddlintYear.SelectedValue = yearIntForEdit
            End If

            'People and Institutions
            FillOrganizationList(ddlidfReceivedByOffice, Nothing, Nothing, True)
            ddlidfReceivedByOffice.DataSource = SortDropDownList(ddlidfReceivedByOffice).Items

            FillOrganizationList(ddlidfSentByOffice, Nothing, Nothing, True)
            ddlidfSentByOffice.DataSource = SortDropDownList(ddlidfSentByOffice).Items



            FillDropDown(ddlidfReceivedByPerson, GetType(clsOrgPerson), Nothing, PersonConstants.idfPerson, OrganizationConstants.OrgFullName, Nothing, Nothing, True)
            FillDropDown(ddlidfSentByPerson, GetType(clsOrgPerson), Nothing, PersonConstants.idfPerson, OrganizationConstants.OrgFullName, Nothing, Nothing, True)

            'also populate read only textboxes
            txtstrEnteredByPerson.Text = Session("UserName").ToString()
            txtstrEnteredByOffice.Text = Session("Organization").ToString()
            txtdatEnteredByDate.Text = DateTime.Today.ToShortDateString()

            txtdatEnteredByDate1.Text = DateTime.Today.ToShortDateString()
            'Fill hidden fields with the INT values of the above
            hdfidfEnteredByPerson.Value = Session("UserID").ToString()
            hdfidfEnteredByOffice.Value = Session("Institution").ToString()
            'Dim txtSite = Session("UserSite").ToString()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub
    Private Sub GetInitialLocation()

        'get location region, and rayon


    End Sub


    Private Sub SetDefaultsAndLimits()

        'set limits on calendars, etc
        txtdatSentbyDate.MaxDate = DateTime.Today.ToShortDateString()
        txtdatReceivedByDate.MaxDate = DateTime.Today.ToShortDateString()

        hdfidfsAggrCaseType.Value = AggregateValue.Human
        '        txtstrCaseID.Text = "(new)" moved to button submit
        txtstrCaseID.Text = ""

    End Sub
    Private Sub SetupForAddOrUpate()


        FillCountry()  ' Get country value

        ' Using AdministrativeUnit to populate rayons, regions, settlement set to default country value
        hdfidfsAdministrativeUnit.Value = hdfidfsCountry.Value

        PopulateEditDropDowns()
        SetDefaultsAndLimits()
        ToggleEditAdminDdls(ddlifdsSearchAdministrativeLevel)

    End Sub
    Private Sub SetupForAddOrUpateEdit()


        FillCountry()  ' Get country value

        ' Using AdministrativeUnit to populate rayons, regions, settlement set to default country value
        hdfidfsAdministrativeUnit.Value = hdfidfsCountry.Value

        PopulateEditDropDowns()
        'SetDefaultsAndLimits()
        If Not hdfstrCaseID.Value.IsValueNullOrEmpty Then
            txtstrCaseID.Text = hdfstrCaseID.Value
        End If
        ToggleEditAdminDdls(ddlifdsSearchAdministrativeLevel)

    End Sub
    Private Sub SetNotifyDateMin()
        txtdatReceivedByDate.MinDate = txtdatSentbyDate.Text
    End Sub

    Private Sub FillAggregateGrid(Optional sGetDataFor As String = "GRIDROWS",
                                        Optional bRefresh As Boolean = False)


        Try
            SaveSearchFields()
            FillCountry() ' Get COuntry value store in hdfidfsCountry.Value


            Dim ddlList As New List(Of Control)
            For Each ddl As EIDSSControlLibrary.DropDownList In FindControlList(ddlList, lucHumanAggregate, GetType(EIDSSControlLibrary.DropDownList))

                If ddl.SelectedIndex > 0 Then 'check for country code - need check on this value it may change
                    If ddl.SelectedValue.ToString() <> hdfidfsCountry.Value Then
                        hdfidfsAdministrativeUnit.Value = ddl.SelectedValue.ToString()
                    End If

                End If
            Next






            Dim humanAggGetParameters = New AggCaseGetListParams() With {.langId = GetCurrentLanguage(), .idfsAggrCaseType = AggregateValue.Human}


            If Not txtstrSearchCaseID.Text.IsValueNullOrEmpty Then
                humanAggGetParameters.strSearchCaseId = txtstrSearchCaseID.Text

            End If


            If Not txtdatSearchStartDate.Text.IsValueNullOrEmpty Then
                humanAggGetParameters.datSearchStartDate = txtdatSearchStartDate.Text
            End If

            If Not txtdatSearchEndDate.Text.IsValueNullOrEmpty Then
                humanAggGetParameters.datSearchEndDate = txtdatSearchEndDate.Text
            End If

            If (Not ddlidfsTimeInterval.SelectedValue.IsValueNullOrEmpty AndAlso ddlidfsTimeInterval.SelectedValue <> "-1") Then
                humanAggGetParameters.idfsTimeInterval = ddlidfsTimeInterval.SelectedValue.ToInt32

            End If

            Dim adminUnit As Long = Nothing

            Dim ddlSelectedRegion As DropDownList = lucHumanAggregate.FindControl("ddllucHumanAggregateidfsRegion")
            If Not IsNothing(ddlSelectedRegion) Then
                adminUnit = ddlSelectedRegion.SelectedValue.ToInt32
            End If

            Dim ddlSeletedRayon As DropDownList = lucHumanAggregate.FindControl("ddllucHumanAggregateidfsRayon")
            If Not IsNothing(ddlSeletedRayon) Then
                adminUnit = ddlSeletedRayon.SelectedValue.ToInt32
            End If

            Dim ddlSeletedSettlement As DropDownList = lucHumanAggregate.FindControl("ddllucHumanAggregateidfsSettlement")
            If Not IsNothing(ddlSeletedSettlement) Then
                adminUnit = ddlSeletedSettlement.SelectedValue.ToInt32
            End If

            If (adminUnit <> Nothing) Then
                humanAggGetParameters.idfsAdministrativeUnit = adminUnit
            End If

            Dim ddlSeletedOrganization As DropDownList = lucHumanAggregate.FindControl("ddlidfsOrganzation")
            If Not IsNothing(ddlSeletedOrganization) Then
                Dim organizationUnit As Long = ddlSeletedOrganization.SelectedValue.ToInt32
            End If

            'humanAggGetParameters.idfsAdministrativeUnit = Make And CaseClassificationServiceClient statement And take the lowest value

            If (Not ddlifdsSearchAdministrativeLevel.SelectedValue.IsValueNullOrEmpty AndAlso ddlifdsSearchAdministrativeLevel.SelectedValue <> "-1") Then
                Dim SearchAdminLevel As String = ddlifdsSearchAdministrativeLevel.SelectedValue.ToString 'not in search

            End If


            '           Dim list = HumanServiceClientAPIClient.AggCaseGetlistAsync(Gather(search, humanAggGetParameters, 3)).Result Gather returns too much data
            Dim list = HumanServiceClientAPIClient.AggCaseGetlistAsync(humanAggGetParameters).Result



            gvHAC.DataSource = Nothing

            'Dim resultsHasErrors As Boolean = dsHAggregate.Tables(0).HasErrors  ' Check here if no data is return and no errors Begin, end Search dates

            'If dsHAggregate.CheckDataSet() Or Not resultsHasErrors Then
            '    ViewState("dsHAggregate") = dsHAggregate
            '    gvHAC.DataSource = dsHAggregate.Tables(0)
            '    gvHAC.DataBind()
            '    Dim rowCount As Integer = dsHAggregate.Tables(0).Rows.Count

            '    searchResultsQty.InnerText = rowCount.ToString()

            'End If

            lblNumberOfRecords.Text = list.Count
            lblPageNumber.Text = "1"

            FillAggSearchList(pageIndex:=1, paginationSetNumber:=1)

            gvHAC.PageIndex = 0

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub


    Private Sub FillAggSearchList(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            Dim humanActiveGetParameters = New HumanActiveSurveillanceGetListParams()

            ' Make this into a function



            Dim humanAggGetParameters = New AggCaseGetListParams() With {.langId = GetCurrentLanguage(), .idfsAggrCaseType = AggregateValue.Human}


            If Not txtstrSearchCaseID.Text.IsValueNullOrEmpty Then
                humanAggGetParameters.strSearchCaseId = txtstrSearchCaseID.Text

            End If


            If Not txtdatSearchStartDate.Text.IsValueNullOrEmpty Then
                humanAggGetParameters.datSearchStartDate = txtdatSearchStartDate.Text
            End If

            If Not txtdatSearchEndDate.Text.IsValueNullOrEmpty Then
                humanAggGetParameters.datSearchEndDate = txtdatSearchEndDate.Text
            End If

            If (Not ddlidfsTimeInterval.SelectedValue.IsValueNullOrEmpty AndAlso ddlidfsTimeInterval.SelectedValue <> "-1") Then
                humanAggGetParameters.idfsTimeInterval = ddlidfsTimeInterval.SelectedValue.ToInt32

            End If

            Dim adminUnit As Long = Nothing

            Dim ddlSelectedRegion As DropDownList = lucHumanAggregate.FindControl("ddllucHumanAggregateidfsRegion")
            If Not IsNothing(ddlSelectedRegion) Then
                adminUnit = ddlSelectedRegion.SelectedValue.ToInt32
            End If

            Dim ddlSeletedRayon As DropDownList = lucHumanAggregate.FindControl("ddllucHumanAggregateidfsRayon")
            If Not IsNothing(ddlSeletedRayon) Then
                adminUnit = ddlSeletedRayon.SelectedValue.ToInt32
            End If

            Dim ddlSeletedSettlement As DropDownList = lucHumanAggregate.FindControl("ddllucHumanAggregateidfsSettlement")
            If Not IsNothing(ddlSeletedSettlement) Then
                adminUnit = ddlSeletedSettlement.SelectedValue.ToInt32
            End If

            If (adminUnit <> Nothing) Then
                humanAggGetParameters.idfsAdministrativeUnit = adminUnit
            End If




            Session(SESSION_SEARCH_LIST) = HumanServiceClientAPIClient.AggCaseGetlistAsync(humanAggGetParameters).Result
            gvHAC.DataSource = Nothing
            BindGridView()
            FillPager(lblNumberOfRecords.Text, pageIndex)
            ViewState(PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    Private Sub BindGridView()

        Dim list As List(Of AggCaseGetlistModel) = CType(Session(SESSION_SEARCH_LIST), List(Of AggCaseGetlistModel))

        If (Not ViewState(SORT_EXPRESSION) Is Nothing) Then
            If ViewState(SORT_DIRECTION) = SortConstants.Ascending Then
                list = list.OrderBy(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            Else
                list = list.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(SORT_EXPRESSION)).GetValue(x)).ToList()
            End If
        End If

        gvHAC.DataSource = list
        gvHAC.DataBind()

    End Sub

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

    End Sub







    'Private Sub AddOrUpdateAgg()

    '    'verify that the minimum of time period and admin have been populated
    '    'confirm with user. if blank, then set defaults per use case

    '    Dim oCom As clsCommon = New clsCommon()
    '    Dim oService As NG.EIDSSService = oCom.GetService()
    '    Dim aSP As String() = Nothing

    '    aSP = oService.getSPList("AggregateSave")


    '    If hdfidfsSite.Value = "NULL" Then
    '        hdfidfsSite.Value = Session("UserSite")
    '    End If


    '    If hdfidfEnteredByPerson.Value = "NULL" Then
    '        hdfidfEnteredByPerson.Value = Session("Person")
    '    End If

    '    ' get a known value for Enteredbyperson
    '    hdfidfEnteredByPerson.Value = Session("Person")

    '    hdfidfAggrCase.Value = "" 'After delete, fix problem  creating agregate

    '    SaveAdminFromDDL(adminSearch) 'save a single admin area value

    '    Dim hidnValues As String = oCom.Gather(divHiddenFieldsSection, aSP(0).ToString(), 3, True)



    '    Dim dataValues = oCom.Gather(HumanAggregate, aSP(0).ToString(), 3, True)



    '    If hdfidfAggrCase.Value = "" Then
    '        hdfidfAggrCase.Value = -1
    '    End If

    '    If hdfidfVersion.Value = "" Then
    '        hdfidfVersion.Value = -1
    '    End If



    '    Dim HumanAggValues As String = dataValues + "|" + hidnValues


    '    Dim oHumanAgg As clsAggregate = New clsAggregate

    '    Dim oReturnValues As Object() = Nothing



    '    ' If editing then resultCaseID is determined differently

    '    Dim resultCaseID As String = oHumanAgg.AddOrUpdate(HumanAggValues)
    '    'Save results
    '    hdfstrCaseID.Value = resultCaseID
    '    lblCASEID.Text = "CASE ID: " & resultCaseID

    'End Sub

    Private Sub AddOrUpdateAggApi()

        'verify that the minimum of time period and admin have been populated
        'confirm with user. if blank, then set defaults per use case

        Try
            Dim humanAggModelSetParams As New AggCaseSetParams()


            If hdfidfsSite.Value = "NULL" Then
                hdfidfsSite.Value = Session("UserSite")
            End If


            If hdfidfEnteredByPerson.Value = "NULL" Then
                hdfidfEnteredByPerson.Value = Session("Person")
            End If

            ' get a known value for Enteredbyperson
            hdfidfEnteredByPerson.Value = Session("Person")

            'If Not editting Then
            '    hdfidfAggrCase.Value = "" 'After delete, fix problem  creating agregate
            'End If

            SaveAdminFromDDL(adminSearch) 'save a single admin area value

            Dim hidnValues = Gather(divHiddenFieldsSection, humanAggModelSetParams, 3)



            Dim dataValues = Gather(HumanAggregate, humanAggModelSetParams, 3)



            If hdfidfAggrCase.Value = "" Then
                hdfidfAggrCase.Value = -1
            End If

            If hdfidfVersion.Value = "" Then
                hdfidfVersion.Value = -1
            End If



            dataValues.idfCaseObservation = Convert.ToInt64(hdfidfCaseObservation.Value)
            dataValues.idfsCaseObservationFormTemplate = Convert.ToInt64(hdfidfsCaseObservationFormTemplate.Value)
            Dim returnResults As List(Of AggCaseSetModel) = HumanServiceClientAPIClient.AggCaseSetAsync(humanAggModelSetParams).Result

            If returnResults.FirstOrDefault().ReturnCode = 0 Then
                '          lblCASEID.Text = "Create Human Aggregate:  " + returnResults.FirstOrDefault().strCaseID.ToString() 
                lblCASEID.Text = GetLocalResourceObject("Hdg_Add_Update_Success_Message.Text").ToString() + returnResults.FirstOrDefault().strCaseID.ToString() ' 
                hdfstrCaseID.Value = returnResults.FirstOrDefault().strCaseID.ToString()
            Else
                lblCASEID.Text = GetLocalResourceObject("Warning_Message_Cannot_Save_SubHeading.Text").ToString()
            End If


        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub
    Private Function ValidateForSearch() As Boolean

        Try

            Dim blnValidated As Boolean = False
            'Dim oCom As clsCommon = New clsCommon()



            'searchForm
            Dim allCtrl As New List(Of Control)

            allCtrl.Clear()
            For Each txt As WebControls.TextBox In FindControlList(allCtrl, searchForm, GetType(WebControls.TextBox))
                If Not blnValidated Then blnValidated = (Not txt.Text.ToString().IsValueNullOrEmpty())
            Next

            If Not blnValidated Then
                allCtrl.Clear()
                For Each ddl As WebControls.DropDownList In FindControlList(allCtrl, searchForm, GetType(WebControls.DropDownList))
                    If Not blnValidated Then blnValidated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            'Do have to search because Country, Region, Rayon, etc
            If Not blnValidated Then
                allCtrl.Clear()
                For Each ddl As EIDSSControlLibrary.DropDownList In FindControlList(allCtrl, searchForm, GetType(EIDSSControlLibrary.DropDownList))
                    'If ddl.ClientID.Contains("ddllucSearchidfsCountry") = False Then
                    If ddl.ClientID.Contains("ddllucHumanAggregateidfsCountry") = False Then
                        If Not blnValidated Then blnValidated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                    End If
                Next
            End If

            blnValidated = Not (txtstrSearchCaseID.Text.IsValueNullOrEmpty())
            If blnValidated Then
                searchResults.Visible = blnValidated
            End If

            If Not blnValidated Then
                allCtrl.Clear()
                For Each txt As EIDSSControlLibrary.CalendarInput In FindControlList(allCtrl, searchForm, GetType(EIDSSControlLibrary.CalendarInput))
                    If Not blnValidated Then blnValidated = (Not txt.Text.ToString().IsValueNullOrEmpty())
                Next
            End If

            If blnValidated And (txtdatSearchStartDate.Text.Length > 0 Or txtdatSearchEndDate.Text.Length > 0) Then
                blnValidated = ValidateFromToDates(txtdatSearchStartDate.Text, txtdatSearchEndDate.Text)
                If Not blnValidated Then

                    'show message, search criteria dates are not valid.
                    ' Needs to do a if then else Msg  - VAUC07 Page 7 The system shall provide a warning message to the user: “You did not specify the “End Date”. Do you want to use current date as the End Date?” 

                    ASPNETMsgBox(GetLocalResourceObject("Msg_Dates_Are_Invalid")) ' needs to be converted to javascript
                    txtdatSearchStartDate.Focus()
                    Return blnValidated
                    'This would be better  but need testing  searchResults.Visible = blnValidated
                End If
            End If

            'Need new logic here Arnold
            blnValidated = True ' Since invalid search results are handled in this function, when we exit we want to see the search results
            searchResults.Visible = blnValidated
            Return blnValidated

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Function
    Public Function ValidateFromToDatesNotFuture(ByVal sFrom As String, ByVal sTo As String) As Boolean

        Dim startDate = CType(sFrom, DateTime)
        Dim endDate = CType(sTo, DateTime)
        If startDate > DateTime.Now Or endDate > DateTime.Now Then      'if sFrom <= sTo then return isValid=true
            Return False                                                'if sFrom > sTo then return isValid=false

        Else
            Return True

        End If

    End Function


    Private Sub PopulateAggregateForEditing()
        Try
            If Not IsNothing(ViewState("aggCase")) Then
                Dim ds As DataSet = oAgg.SelectOneCase(ViewState("aggCase").ToString())
                Dim strCase As String = ViewState("aggCase").ToString()
                SetYearByEdit(ds)

                If ds.CheckDataSet() Then
                    'SetupForAddOrUpate()

                    Dim delCaseID As String = ds.Tables(0).Rows(0)(AggregateValue.StrSearchCaseID).ToString() ' Case ID to be deleted or edited
                    hdfstrCaseID.Value = delCaseID
                    hdfidfAggrCase.Value = ds.Tables(0).Rows(0)(AggregateValue.CaseID).ToString()

                    lblCASEIDDel.Text = "Delete CASE ID: " & delCaseID


                    If ds.Tables(0).Rows(0)("idfCaseObservation").ToString() = "" Then
                        Saveobservation()
                    Else
                        hdfidfCaseObservation.Value = ds.Tables(0).Rows(0)("idfCaseObservation").ToString()
                        If Not LoadTemplates() Is Nothing Then
                            hdfidfsCaseObservationFormTemplate.Value = LoadTemplates().FirstOrDefault().idfsFormTemplate
                        End If
                    End If


                    SetupForAddOrUpateEdit()
                    Dim oCom As clsCommon = New clsCommon()
                    oCom.Scatter(HumanAggregate, New DataTableReader(ds.Tables(0)))
                    oCom.Scatter(divHiddenFieldsSection, New DataTableReader(ds.Tables(0)))
                    FillCountry()
                    SetLocationByAdminUnit(ds)



                    btnTryDelete.Visible = True

                    btnCancelDelete.Visible = False

                    btnNewSearch.Visible = False


                    'ToggleVisibility(CHumanAGGR)
                    search.Visible = False
                    HumanAggregate.Visible = True

                    'Dim delCaseID As String = ds.Tables(0).Rows(0)(AggregateValue.StrSearchCaseID).ToString() ' Case ID to be deleted or edited
                    'hdfstrCaseID.Value = delCaseID

                    'lblCASEIDDel.Text = "Delete CASE ID: " & delCaseID



                    DetermineDateRangeDroDown(ds.Tables(0).Rows(0)("idfsPeriodType").ToString(), ds.Tables(0).Rows(0)("datStartDate").ToString(), ds.Tables(0).Rows(0)("datFinishDate").ToString())

                End If
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub
    Private Sub PopulateAggregateForEditingApi()
        If Not IsNothing(ViewState("aggCase")) Then
            Dim strCase As String = ViewState("aggCase").ToString()

            Dim humanAggGetParameters = New AggCaseGetListParams() With {.langId = GetCurrentLanguage(), .idfsAggrCaseType = AggregateValue.Human, .strSearchCaseId = strCase}
            Dim listOfOneAgg As List(Of AggCaseGetlistModel) = HumanServiceClientAPIClient.AggCaseGetlistAsync(humanAggGetParameters).Result

            SetYearByEditApi(listOfOneAgg)

            hdfstrCaseID.Value = strCase
            hdfidfAggrCase.Value = listOfOneAgg(0).idfAggrCase
            lblCASEIDDel.Text = "Delete CASE ID: " & strCase


            SetupForAddOrUpateEdit()

            Scatter(HumanAggregate, listOfOneAgg(0), 3)
            Scatter(divHiddenFieldsSection, listOfOneAgg(0), 3)
            FillCountry()
            SetLocationByAdminUnitApi(listOfOneAgg)

            btnTryDelete.Visible = True

            btnCancelDelete.Visible = False
            search.Visible = False
            HumanAggregate.Visible = True

        End If
    End Sub
    Private Sub DeleteAgg()
        If Not IsNothing(ViewState("aggCase")) Then


            oAgg.Delete(Double.Parse(hdfidfAggrCase.Value))


            HumanAggregate.Visible = False

            search.Visible = True
            btnShowSearchCriteria.Visible = True
            showSearchCriteria(False)
            showClearandSearchButtons(False)
            GetSearchFields()

            FillAggregateGrid("Page", True) 'When this is set true, page does not display properly

        End If
    End Sub
    Private Sub DeleteAggApi()
        Try
            If Not IsNothing(ViewState("aggCase")) Then


                'oAgg.Delete(Double.Parse(hdfidfAggrCase.Value))

                If Not hdfidfAggrCase.Value.IsValueNullOrEmpty Then

                    Dim parameters As Long = CType(hdfidfAggrCase.Value, Long)
                    '                   parameters = CInt(hdfidfAggrCase.Value)
                    Dim returnValue = HumanServiceClientAPIClient.HumanAggregateCaseDeleteAsync(parameters).Result
                End If


                HumanAggregate.Visible = False

                search.Visible = True
                btnShowSearchCriteria.Visible = True
                showSearchCriteria(False)
                showClearandSearchButtons(False)
                GetSearchFields()

                FillAggregateGrid("Page", True) 'When this is set true, page does not display properly
                If Not editting Then
                    hdfidfAggrCase.Value = "" 'After delete, fix problem  creating agregate
                End If

            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Private Sub ToggleVisibility(ByVal section As String)

        searchForm.Visible = section.EqualsAny({CSEARCH})
        searchResults.Visible = section.EqualsAny({CSEARCHRESULTS})
        HumanAggregate.Visible = section.EqualsAny({CHUMANAGGR})


        EnableSearchControls(section.EqualsAny({CSEARCH}))



    End Sub
    Private Sub NullingTextBoxes()

        If String.IsNullOrEmpty(txtdatSearchEndDate.Text) Then txtdatSearchEndDate.Text = "null"
        If String.IsNullOrEmpty(txtdatSearchStartDate.Text) Then txtdatSearchStartDate.Text = "null"
        If String.IsNullOrEmpty(txtstrSearchCaseID.Text) Then txtstrSearchCaseID.Text = "null"

    End Sub
    Private Sub EnableSearchControls(ByVal enabled As Boolean)

        For Each control As Control In searchForm.Controls
            Dim textBox As TextBox = TryCast(control, TextBox)
            If Not IsNothing(textBox) Then
                textBox.Enabled = enabled
                Continue For
            End If

            Dim dropDown As DropDownList = TryCast(control, DropDownList)
            If Not IsNothing(dropDown) Then
                dropDown.Enabled = enabled
                Continue For
            End If

            Dim lc As LocationUserControl = TryCast(control, LocationUserControl)
            If Not IsNothing(lc) Then
                Dim ddlCountry As DropDownList = lc.FindControl("ddlCountry")
                If Not IsNothing(ddlCountry) Then
                    ddlCountry.Enabled = enabled
                End If

                'Dim ddlRegion As DropDownList = lc.FindControl("ddllsearchFormidfsRegion")
                Dim ddlRegion As DropDownList = lc.FindControl("ddllucHumanAggregateidfsRegion")
                If Not IsNothing(ddlRegion) Then
                    ddlRegion.Enabled = enabled
                End If
                '2nd location control in edit page
                Dim ddlRegionEdit As DropDownList = lc.FindControl("ddllsearchFormidfsRegion")
                If Not IsNothing(ddlRegion) Then
                    ddlRegionEdit.Enabled = enabled
                End If

                'Dim ddlRayon As DropDownList = lc.FindControl("ddlRayon")
                Dim ddlRayon As DropDownList = lc.FindControl("ddllucHumanAggregateidfsRayon")
                If Not IsNothing(ddlRayon) Then
                    ddlRayon.Enabled = enabled
                End If
                '2nd location control in edit page
                Dim ddlRayonEdit As DropDownList = lc.FindControl("ddllsearchFormidfsRayon")
                If Not IsNothing(ddlRegion) Then
                    ddlRayonEdit.Enabled = enabled
                End If

                'Dim townorsettlement As DropDownList = lc.FindControl("ddlRayon")
                Dim ddlSettlement As DropDownList = lc.FindControl("ddllucHumanAggregateidfsSettlement")
                If Not IsNothing(ddlSettlement) Then
                    ddlSettlement.Enabled = enabled
                End If
                '2nd location control in edit page
                Dim ddlSettlementEdit As DropDownList = lc.FindControl("ddllsearchFormidfsSettlement")
                If Not IsNothing(ddlRegion) Then
                    ddlSettlementEdit.Enabled = enabled
                End If



            End If

            Dim div As HtmlContainerControl = TryCast(control, HtmlContainerControl)
            If Not IsNothing(div) Then
                For Each c As Control In div.Controls

                    Dim tb As TextBox = TryCast(c, TextBox)
                    If Not IsNothing(tb) Then
                        tb.Enabled = enabled
                        Continue For
                    End If

                    Dim ddl As DropDownList = TryCast(c, DropDownList)
                    If Not IsNothing(ddl) Then
                        ddl.Enabled = enabled
                        Continue For
                    End If

                    Dim but As Button = TryCast(c, Button)
                    If Not IsNothing(but) Then
                        but.Enabled = enabled
                        Continue For
                    End If
                Next
            End If
        Next

        txtstrSearchCaseID.Focus()
    End Sub

    Private Sub EnableControls(ByRef divTag As HtmlGenericControl, ByVal enabled As Boolean)

        For Each control As Control In divTag.Controls
            Dim textBox As TextBox = TryCast(control, TextBox)
            If Not IsNothing(textBox) Then
                textBox.Enabled = enabled
                Continue For
            End If

            Dim dropDown As DropDownList = TryCast(control, DropDownList)
            If Not IsNothing(dropDown) Then
                dropDown.Enabled = enabled
                Continue For
            End If

            Dim button As Button = TryCast(control, Button)
            If Not IsNothing(button) Then
                button.Visible = enabled
                Continue For
            End If


            Dim div As HtmlContainerControl = TryCast(control, HtmlContainerControl)
            If Not IsNothing(div) Then
                For Each c As Control In div.Controls

                    Dim tb As TextBox = TryCast(c, TextBox)
                    If Not IsNothing(tb) Then
                        tb.Enabled = enabled
                        Continue For
                    End If

                    Dim ddl As DropDownList = TryCast(c, DropDownList)
                    If Not IsNothing(ddl) Then
                        ddl.Enabled = enabled
                        Continue For
                    End If

                    Dim but As Button = TryCast(c, Button)
                    If Not IsNothing(but) Then
                        but.Enabled = enabled
                        Continue For
                    End If

                Next
            End If

            Dim htmlAnchor As HtmlAnchor = TryCast(control, HtmlAnchor)
            If Not IsNothing(htmlAnchor) Then
                If enabled Then
                    htmlAnchor.Visible = True
                Else
                    htmlAnchor.Visible = False
                End If
            End If

        Next
    End Sub

    Private Sub EnableLocationControls(ByRef divTagID As HtmlGenericControl, ByVal enabled As Boolean)

        'Enable or Disable year, interval Control
        ddlintYear.Enabled = enabled

        'Enable or Disable Location Control

        Dim ddlList As New List(Of Control)
        Dim oCom As clsCommon = New clsCommon()
        For Each ddl As EIDSSControlLibrary.DropDownList In oCom.FindCtrl(ddlList, divTagID, GetType(EIDSSControlLibrary.DropDownList))
            If ddl.SelectedIndex > 0 Then
                ddl.Enabled = enabled
            End If
        Next

    End Sub

    Private Sub EnableTimeIntervalControls(ByRef ddltype As DropDownList, ByVal enabled As Boolean)

        'Enable or Disable year, interval Control
        ddlintYear.Enabled = enabled

        Select Case ddltype.ID.ToString()
            Case "ddlintQuarter"
                ddlintQuarter.Enabled = enabled
            Case "ddlintMonth"
                ddlintMonth.Enabled = enabled
            Case "ddlintWeek"
                ddlintWeek.Enabled = enabled
            Case "ddlintDay" ' needs some work AK
                '                singleDay.Enabled = enabled
        End Select



    End Sub

    Private Sub ClearAdministrativeUnitControl()
        'Clears region, rayon, settlement
        hdfidfsAdministrativeUnit.Value = "NULL"

    End Sub

    Private Sub ClearControl(ByRef sectionName As Web.UI.Control)

        ResetForm(sectionName)

    End Sub
#End Region
#Region "Period Setups"
    Private Sub FillUpToCurrentYear()

        'Range of years to be 1900 to current year, descending
        For y = DateTime.Today.Year To 1900 Step -1
            Dim li As ListItem = New ListItem(y.ToString(), y.ToString())
            ddlintYear.Items.Add(li)
        Next

    End Sub
    Private Sub ResetQuarters(ByVal year As Integer)

        If ddlintQuarter.Visible Then
            ddlintQuarter.DataSource = oAgg.FillQuarterList(year)
            oAgg.FillPeriod(ddlintQuarter, True)
        End If

    End Sub
    'Private Sub ResetMonths()

    '    If ddlintMonth.Visible Then
    '        ddlintMonth.DataSource = oAgg.FillMonthList(CType(ddlintYear.SelectedValue, Integer))
    '        oAgg.FillPeriod(ddlintMonth, True)
    '    End If

    'End Sub
    Private Sub ResetMonths(ByVal year As Integer)

        If ddlintMonth.Visible Then
            ddlintMonth.DataSource = oAgg.FillMonthList(year)
            oAgg.FillPeriod(ddlintMonth, True)
        End If

    End Sub
    Private Sub ResetWeeks(ByVal year As Integer)

        If ddlintWeek.Visible Then
            ddlintWeek.DataSource = oAgg.FillWeekList(year)
            oAgg.FillPeriod(ddlintWeek, True)
        End If

    End Sub
    Private Sub ToggleSearchAdminDdls(ddl As DropDownList)

        Dim indx As String = ddl.SelectedIndex.ToString()



        'searchOrg.Visible = indx.EqualsAny({"5", "4"})

        If (lucHumanAggregate.ShowRegion = indx.EqualsAny({"3"})) Then
            lucHumanAggregate.ShowRayon = True
            lucHumanAggregate.ShowTownOrVillage = True
            searchOrg.Visible = True

            'lucHumanAggregate.


        ElseIf (lucHumanAggregate.ShowRayon = indx.EqualsAny({"2"})) Then
            lucHumanAggregate.ShowTownOrVillage = True
            searchOrg.Visible = True

        ElseIf (lucHumanAggregate.ShowRayon = indx.EqualsAny({"1"})) Then
            lucHumanAggregate.ShowTownOrVillage = True 'Organization
            searchOrg.Visible = True

        ElseIf (lucHumanAggregate.ShowTownOrVillage = indx.EqualsAny({"5", "4"})) Then
            lucHumanAggregate.ShowRayon = True
            lucHumanAggregate.ShowRegion = True 'need to also disable
            lucHumanAggregate.ShowTownOrVillage = True
            searchOrg.Visible = True

        End If


        adminAreaSearch.FindControl(lucHumanAggregate.SelectedRayonText)

    End Sub
    Private Sub ToggleEditAdminDdls(ddl As DropDownList)

        Dim indx As String = ddl.SelectedIndex.ToString()

        lucSearch.ShowTownOrVillage = indx.EqualsAny({"4", "3"})
        lucSearch.ShowRayon = indx.EqualsAny({"4", "3", "2"})
        lucSearch.ShowRegion = indx.EqualsAny({"4", "3", "2", "1"})


    End Sub
    Private Sub ToggleEditTimeDdls(d As DropDownList)


        'based on index of the time period dropdown, set the visibility of the time range dropdowns
        Dim indx As String = d.SelectedIndex.ToString()

        quarter.Visible = indx.Equals("1")
        month.Visible = indx.Equals("2")
        week.Visible = indx.Equals("3")
        singleDay.Visible = indx.Equals("4")
        ResetTimes()

    End Sub

    Private Sub ToggleEditTimeDdlsApi(d As DropDownList)

        'Only one time Interval is visible
        quarter.InnerHtml = <div id="quarter" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" resourcekey="dis_Quarter" visible="False">
                            </div>
        month.InnerHtml = <div id="month" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" resourcekey="dis_Month" visible="False">
                          </div>
        week.InnerHtml = <div id="week" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" resourcekey="dis_Week" visible="False">
                         </div>
        singleDay.InnerHtml = <div id="singleDay" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" resourcekey="dis_Day" visible="False">
                                  <span class="glyphicon glyphicon-asterisk text-danger" runat="server" resourcekey="req_Day"></span>
                                  <label runat="server" resourcekey="lbl_Day"></label>
                              </div>
        'based on index of the time period dropdown, set the visibility of the time range dropdowns
        Dim indx As String = d.SelectedIndex.ToString()

        'quarter.Visible = indx.Equals("1")
        'month.Visible = indx.Equals("2")
        'week.Visible = indx.Equals("3")
        'singleDay.Visible = indx.Equals("4")

        Select Case indx
            Case "1"
                quarter.InnerHtml = <div id="quarter" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" resourcekey="dis_Quarter" visible="True">
                                        <span class="glyphicon glyphicon-asterisk text-danger" runat="server" resourcekey="req_Quarterly"></span>
                                        <label resourcekey="lbl_Quarter" runat="server"></label>
                                    </div>
                ddlintQuarter.Visible = True
            Case "2"
                month.InnerHtml = <div id="month" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" resourcekey="dis_Month" runat="server" visible="True">
                '                      <span class="glyphicon glyphicon-asterisk text-danger" resourcekey="req_Month" runat="server"></span>
                '                      <label resourcekey="lbl_Month" runat="server"></label>
                '                  </div>

                'month.Visible = True
                'month.InnerHtml = <div id="month" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" resourcekey="dis_Month" runat="server" visible="True">
                '                      <span class="glyphicon glyphicon-asterisk text-danger" resourcekey="req_Month" runat="server"></span>
                '                      <label resourcekey="lbl_Month" runat="server"></label>
                '                  </div>
                ddlintMonth.Visible = True

                ddlintQuarter.Visible = False
                ddlintWeek.Visible = False
                singleDay.Visible = False
            Case "3"
                week.InnerHtml = <div id="week" class="col-lg-3 col-md-3 col-sm-3 col-xs-12" runat="server" resourcekey="dis_Week" visible="True">
                                     <span class="glyphicon glyphicon-asterisk text-danger" runat="server" resourcekey="req_Week"></span>
                                     <label runat="server" resourcekey="lbl_Week"></label>
                                 </div>
                ddlintWeek.Visible = True
            Case "4"
                'singleDay.Visible = True
                txtdatDate.Visible = True
        End Select



        ResetTimes()

    End Sub


    Private Sub ResetTimes()
        Try
            'based on new value of year, adjust the more granular time frames

            Dim year As String = ddlintYear.SelectedValue ' if in edit mode then year is value of year in start date

            If editting Then
                year = yearIntForEdit

            End If


            ResetQuarters(year)
            ResetMonths(year)
            ResetWeeks(year)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub
    Private Sub FindSettingDetail()
        'To be used once we get data from c6.1 of configured settings
        Dim ds As DataSet = oAgg.GetSettingMins()

        If ds.CheckDataSet() Then
            Dim areaType = ds.Tables(0).Rows(0)(StatisticTypes.StatAreaType)
            Dim timeType = ds.Tables(0).Rows(0)(StatisticTypes.StatPeriodType)
        End If

    End Sub
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
                Case "ddlintMonth"
                    sDate = New DateTime(ToInt16(ddlintYear.SelectedItem.ToString()), ddl.SelectedIndex, 1)
                    eDate = sDate.AddMonths(1).AddDays(-1)
                    FillHiddenDates(sDate.ToShortDateString(), eDate.ToShortDateString())
                Case "ddlintQuarter", "ddlintWeek"
                    Dim dRange As String() = (ddl.SelectedItem.ToString()).Split("-")
                    FillHiddenDates(dRange(0).Trim(), dRange(1).Trim())
                Case "ddlintWeek"
                    sDate = New DateTime(Now.Year, Now.Month, 1)
                    eDate = sDate.AddMonths(1).AddDays(-25)
                    FillHiddenDates(sDate.ToShortDateString(), eDate.ToShortDateString())
                Case "ddlintDay" ' needs some work AK


                    sDate = New DateTime(Now.Year, Now.Month, 1)
                    eDate = sDate.AddMonths(1).AddDays(-1)
                    FillHiddenDates(sDate.ToShortDateString(), sDate.ToShortDateString())
            End Select

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub
    Protected Sub SaveTimeIntervalRangeFromDDL(sender As Object, e As EventArgs)

        Dim ddl As DropDownList = CType(sender, DropDownList)
        Dim sDate As DateTime = Nothing
        Dim eDate As DateTime = Nothing


        Try
            Dim casevar As String = ddl.ID.ToString()
            Dim ddlValue As String = ddl.SelectedItem.ToString()


            If Not IsNothing(ddlintYear.SelectedItem) Then

                ddlYear = ddlintYear.SelectedItem.ToString()
            End If

            Select Case ddlValue
                Case "Year"

                    'sDate = New DateTime(ToInt16(ddlintYear.SelectedItem.ToString()), 1, 1)
                    sDate = New DateTime(ToInt16(ddlYear), 1, 1)
                    'sDate = New DateTime(DateTime.Now.Year, 1, 1)
                    eDate = sDate.AddYears(1).AddDays(-1)
                    FillHiddenDates(sDate.ToShortDateString(), eDate.ToShortDateString())
                Case "Month"
                    'sDate = New DateTime(ToInt16(ddlintYear.SelectedItem.ToString()), ddl.SelectedIndex, 1)
                    sDate = New DateTime(ToInt16(ddlYear), ddl.SelectedIndex, 1)
                    'sDate = New DateTime(DateTime.Now.Year, ddl.SelectedIndex, 1)
                    eDate = sDate.AddMonths(1).AddDays(-1)
                    FillHiddenDates(sDate.ToShortDateString(), eDate.ToShortDateString())
                Case "Quarter"
                    sDate = New DateTime(ToInt16(ddlYear), ddl.SelectedIndex, 1)
                    eDate = sDate.AddMonths(3).AddDays(-1)
                    'DetermineQuarter(sDate,eDate ) Quarter 1, 2,3, or 4
                    'Dim dRange As String() = (ddl.SelectedItem.ToString()).Split("-")
                    'FillHiddenDates(dRange(0).Trim(), dRange(1).Trim())
                    FillHiddenDates(sDate, eDate)

                Case "Week" 'needs some work AK


                    sDate = New DateTime(Now.Year, Now.Month, 1)
                    eDate = sDate.AddMonths(1).AddDays(-25)
                    FillHiddenDates(sDate.ToShortDateString(), eDate.ToShortDateString())
                Case "Day" ' needs some work AK

                    sDate = New DateTime(Now.Year, Now.Month, 1)
                    eDate = sDate.AddMonths(1).AddDays(-1)
                    FillHiddenDates(sDate.ToShortDateString(), sDate.ToShortDateString())
            End Select
            resetSearch()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub


    Protected Sub SaveDateRange(sender As Object, e As EventArgs)


        Dim spaceInd As Integer = 0
        Dim datDate As String

        Try
            If txtdatDate.Text.Contains(" ") Then spaceInd = txtdatDate.Text.IndexOf(" ")


            FillHiddenDates(txtdatDate.Text.Substring(0, spaceInd), txtdatDate.Text.Substring(0, spaceInd))

            datDate = txtdatDate.Text

            FillHiddenDates(datDate, datDate)


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
    Private Sub DetermineDateRangeDroDown(period As String, sDate As String, eDate As String)
        Try
            'based on periodType, we know which contrrol to make visible
            ddlintMonth.Visible = (period = "10091001")
            ddlintQuarter.Visible = (period = "10091003")
            ddlintWeek.Visible = (period = "10091004")

            txtdatDate.Visible = (period = "10091002") ' this is day according to strPeriodName, strPeriodType

            ResetTimes()

            Dim stDate As DateTime = DateTime.Parse(sDate)
            Dim enDate As DateTime = DateTime.Parse(eDate)

            'based on the difference between the two dates, we can determine range and its ddl
            'Dim ddl As DropDownList = New DropDownList
            'Dim diff As Integer = enDate.Subtract(stDate).Days

            'Select Case diff
            '    'Case diff <1
            '    Case diff = 6
            '        ddl = ddlintWeek
            '    Case diff > 27 And diff < 32
            '        ddl = ddlintMonth
            '    Case diff > 60 And diff < 100
            '        ddl = ddlintQuarter
            '    Case diff > 360
            '        ddl = ddlintYear
            'End Select

            'ddl.Visible = True
            'ResetTimes()
            'except for year, the textValue of the dropdown is the dates
            ddlintYear.SelectedValue = stDate.Year.ToString()
            If ddlintMonth.Visible Then ddlintMonth.SelectedIndex = stDate.Month
            If ddlintQuarter.Visible Then ddlintQuarter.SelectedValue = oAgg.GetQuarterValue(stDate.Year, stDate.Month)
            If ddlintWeek.Visible Then ddlintWeek.SelectedValue = oAgg.GetWeekValue(stDate)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try



    End Sub
#End Region
#Region "AdminArea"
    Private Sub FillCountry()

        'Set default country name and save country ID in hidden field
        txtstrCountry.Text = getConfigValue("DefaultCountry").ToString()
        Dim oC As clsCountry = New clsCountry()
        Dim dsCountry = oC.SelectOne(0)
        If dsCountry.CheckDataSet() Then
            hdfidfsCountry.Value = dsCountry.Tables(0).Rows(0)(CountryConstants.CountryID).ToString()

        End If

    End Sub
    Private Sub SaveAdminFromDDL(ByRef divTag As HtmlGenericControl)

        Dim ddlList As New List(Of Control)
        Dim oCom As clsCommon = New clsCommon()
        For Each ddl As EIDSSControlLibrary.DropDownList In oCom.FindCtrl(ddlList, divTag, GetType(EIDSSControlLibrary.DropDownList))
            If ddl.SelectedIndex > 0 Then
                hdfidfsAdministrativeUnit.Value = ddl.SelectedValue.ToString()

                'Need to save  //*[@id="EIDSSBodyCPH_lucSearch_ddllucSearchidfsRegion"] or/and #EIDSSBodyCPH_lucSearch_ddllucSearchidfsRayon or/and #EIDSSBodyCPH_lucSearch_ddllucSearchidfsSettlement
            End If
        Next

    End Sub

    Private Sub SetLocationByAdminUnit(ByRef ds As DataSet)
        Try

            If ds.Tables(0).Rows(0)(CountryConstants.CountryID).ToString = "" Then
                lucSearch.LocationCountryID = Nothing
            Else
                lucSearch.LocationCountryID = CType(ds.Tables(0).Rows(0)(CountryConstants.CountryID), Long)
            End If

            If ds.Tables(0).Rows(0)(RegionConstants.RegionID).ToString = "" Or ds.Tables(0).Rows(0)(RegionConstants.RegionID).ToString = "0" Then
                lucSearch.LocationRegionID = Nothing
            Else
                lucSearch.LocationRegionID = CType(ds.Tables(0).Rows(0)(RegionConstants.RegionID), Long)
            End If

            If ds.Tables(0).Rows(0)(RayonConstants.RayonID).ToString = "" Or ds.Tables(0).Rows(0)(RayonConstants.RayonID).ToString = "0" Then
                lucSearch.LocationRayonID = Nothing
            Else
                lucSearch.LocationRayonID = CType(ds.Tables(0).Rows(0)(RayonConstants.RayonID), Long)
            End If

            If ds.Tables(0).Rows(0)(SettlementConstants.idfsSettlement).ToString = "" Or ds.Tables(0).Rows(0)(SettlementConstants.idfsSettlement).ToString = "0" Then
                lucSearch.LocationSettlementID = Nothing
            Else
                lucSearch.LocationSettlementID = CType(ds.Tables(0).Rows(0)(SettlementConstants.idfsSettlement), Long)
            End If
            lucSearch.DataBind()
        Catch ex As Exception
            Throw
        End Try
    End Sub
    Private Sub SetLocationByAdminUnitApi(ByRef selectedAgg As List(Of AggCaseGetlistModel))
        Try

            'If selectedAgg(CountryConstants.CountryID).ToString = "" Then
            If selectedAgg(0).idfsCountry.ToString = "" Then
                lucSearch.LocationCountryID = Nothing
            Else
                lucSearch.LocationCountryID = CType(selectedAgg(0).idfsCountry.ToString(), Long)
            End If

            If selectedAgg(0).idfsRegion.ToString = "" Or selectedAgg(0).idfsRegion.ToString = "0" Then
                lucSearch.LocationRegionID = Nothing
            Else
                lucSearch.LocationRegionID = CType(selectedAgg(0).idfsRegion.ToString(), Long)
            End If

            If selectedAgg(0).idfsRayon.ToString = "" Or selectedAgg(0).idfsRayon.ToString = "0" Then
                lucSearch.LocationRayonID = Nothing
            Else
                lucSearch.LocationRayonID = CType(selectedAgg(0).idfsRayon.ToString(), Long)
            End If

            If selectedAgg(0).idfsSettlement.ToString = "" Or selectedAgg(0).idfsSettlement.ToString = "0" Then
                lucSearch.LocationSettlementID = Nothing
            Else
                lucSearch.LocationSettlementID = CType(selectedAgg(0).idfsSettlement.ToString(), Long)
            End If
            lucSearch.DataBind()
        Catch ex As Exception
            Throw
        End Try
    End Sub

    Private Sub SetYearByEdit(ByRef ds As DataSet)
        Try

            'Need year of edit to determine number of months located in startdate

            If ds.Tables(0).Rows.Count > 0 Then
                Dim startDate As String = ds.Tables(0).Rows(0)("datStartDate").ToString()
                Dim yearString As String = startDate.Substring(6)
                yearIntForEdit = CInt(yearString)
            Else
                'TODO: Arnold, i was getting an error at times when the ds.Tables(0). Rows.Count = 0 so added this If else condition to avoid the throw block. 
                yearIntForEdit = 2016

            End If


        Catch ex As Exception
            Throw
        End Try
    End Sub

    Private Sub SetYearByEditApi(ByRef selectedAgg As List(Of AggCaseGetlistModel))
        Try

            'Need year of edit to determine number of months located in startdate

            Dim startDate As String = selectedAgg(0).datStartDate.ToString()
            Dim yearString As String = startDate.Substring(6)
            yearIntForEdit = CInt(yearString)


        Catch ex As Exception
            Throw
        End Try
    End Sub

#End Region
#Region "Office/Institute & Officer"
    Private Function OfficeNameFromID(offID As Double) As String

        'Given an Office ID, find Office Name 
        OfficeNameFromID = Nothing
        Dim oOrg As clsOrganization = New clsOrganization()
        Dim ds As DataSet = oOrg.SelectOne(offID)
        If ds.CheckDataSet() Then
            If ds.Tables(0).Rows.Count > 0 Then
                OfficeNameFromID = ds.Tables(0).Rows(0)(OrganizationConstants.OrgName).ToString()
            End If
        End If

        Return OfficeNameFromID

    End Function
    Private Sub ResetInstitute(inst As DropDownList, officer As DropDownList)
        'if the Institution has not been selected and an officer is selected, then set the institute to the one the officer works for
        Try

            If String.IsNullOrEmpty(inst.SelectedValue) Or inst.SelectedValue = "null" Then
                Dim oAgr As clsAggregate = New clsAggregate()
                Dim idOfficer As Double = CType(officer.SelectedValue, Double)
                Dim ds As DataSet = oAgr.GetOrgByEmp(idOfficer)
                If ds.CheckDataSet() Then
                    inst.DataSource = ds
                    inst.DataValueField = OrganizationConstants.idOffice
                    inst.DataTextField = OrganizationConstants.OrgFullName
                    inst.DataBind()
                End If
            End If
        Catch ex As Exception
        End Try

    End Sub
    Private Sub ResetEmployee(officer As DropDownList, inst As DropDownList)

        'filtering the list of officers based on institute
        FillDropDown(officer, GetType(clsOrgPerson), {inst.SelectedValue}, PersonConstants.idfPerson, OrganizationConstants.OrgFullName, Nothing, Nothing, True)

    End Sub
#End Region
#Region "Search Criteria"
    Private Sub SaveSearchFields()

        Dim oCom As New clsCommon
        oCom.SaveSearchFields({searchForm}, SEARCH_SP, oCom.CreateTempFile(SEARCH_FILE_PREFIX))

    End Sub
    Private Sub GetSearchFields()

        Dim oCom As clsCommon = New clsCommon()
        oCom.GetSearchFields({searchForm}, oCom.CreateTempFile(SEARCH_FILE_PREFIX))

    End Sub
    Private Sub ClearSearch()

        Dim oCom As New clsCommon()
        oCom.DeleteTempFiles(GetSFileName())
        oCom.ResetForm(searchForm)
        'Reset Location Control

        oCom.ResetForm(lucHumanAggregate)

        btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
        btnShowSearchCriteria.Visible = False
        searchResults.Visible = False
        btnPrint.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")

    End Sub

    Private Sub showSearchCriteria(ByVal show As Boolean)
        If show Then
            searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
            btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")
        Else
            searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
            btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
        End If
    End Sub

    Private Sub resetSearch()
        searchResults.Visible = False
        searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
        btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
        btnShowSearchCriteria.Visible = False
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

#End Region
#Region "Sorting"
    Private Sub Sorting(e As GridViewSortEventArgs)

        Dim oDS As DataSet = ViewState("AggregateList")

        Dim dt As DataTable = oDS.Tables(0)

        If Not IsNothing(dt) Then
            dt.DefaultView.Sort = e.SortExpression + " " + GetSortDirection(e.SortExpression)
            gvHAC.DataSource = CType(ViewState("AggregateList"), DataSet)
            gvHAC.DataBind()
        End If

    End Sub
    Private Function GetSortDirection(ByVal column As String) As String

        Dim sortDirection = "ASC"

        ' Retrieve the last column that was sorted.
        Dim sortExpression = TryCast(ViewState("SortExpression"), String)

        If sortExpression IsNot Nothing Then
            ' Check if the same column is being resorted. Otherwise, the default value can be returned.
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
    Protected Sub gvHAC_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvHAC.PageIndexChanging
        gvHAC.PageIndex = e.NewPageIndex
        FillAggregateGrid(sGetDataFor:="PAGE")
    End Sub

    Protected Sub Page_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)

        lblPageNumber.Text = pageIndex.ToString()

        Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvHAC.PageSize)

        If Not ViewState(PAGINATION_SET_NUMBER) = paginationSetNumber Then
            Dim controls As New List(Of Control)
            controls.Clear()

            Select Case CType(sender, LinkButton).Text
                Case PagingConstants.PreviousButtonText
                    gvHAC.PageIndex = gvHAC.PageSize - 1
                Case PagingConstants.NextButtonText
                    gvHAC.PageIndex = 0
                Case PagingConstants.FirstButtonText
                    gvHAC.PageIndex = 0
                Case PagingConstants.LastButtonText
                    gvHAC.PageIndex = 0
                Case Else
                    If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                        gvHAC.PageIndex = gvHAC.PageSize - 1
                    Else
                        gvHAC.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                    End If
            End Select

            FillAggSearchList(pageIndex, paginationSetNumber:=paginationSetNumber)
        Else
            If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                gvHAC.PageIndex = gvHAC.PageSize - 1
            Else
                gvHAC.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
            End If
            BindGridView()
            'FillPager(lblSearchResultsItems.Text, pageIndex)
            FillPager(lblNumberOfRecords.Text, pageIndex)

        End If

    End Sub


    Private Sub FillHumanAggReview()

        Try
            Dim oHumanAgg As New clsAggregate
            Dim dsHumanAgg As DataSet = oHumanAgg.SelectOne(hdfstrCaseID.Value)


            ToggleVisibility(CSEARCHRESULTS)

        Catch ae As ArgumentOutOfRangeException

        End Try

    End Sub

    Private Sub PreFillLocation()

        Try


        Catch ae As ArgumentOutOfRangeException

        End Try

    End Sub
    Private Sub DisplayBtnsForAddAgg()

        btnTryDelete.Visible = False
        btnCancelDelete.Visible = False

        btnHACCancel.Visible = False

        btnCancelSearch.Visible = False
        btnSubmit.Visible = False
        btnCancelAdd.Visible = True
        btnNext.Visible = True
        btnPrint.Visible = True


    End Sub

#End Region
#Region "Events"
    'Protected Sub btnReturnToHumanAggAdd_Click(sender As Object, e As EventArgs) Handles btnReturnToHumanAggAdd.ServerClick

    '    ' for now do same as human agg search
    '    btnCancelAgg.Visible = True
    '    btnCancelSearch.Visible = False

    '    ToggleVisibility(CSEARCH)

    '    showClearandSearchButtons(True)

    '    btnShowSearchCriteria.Visible = True
    '    showSearchCriteria(True)
    '    'Clear Search Data to start new search Need to Check USeCase for details directions
    '    ClearSearch()
    '    InitializeSearchFields()

    'End Sub

    Protected Sub btnReturnToHumanAggRecord_Click(sender As Object, e As EventArgs)

        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & divSuccessModalContainer.ClientID & "').modal('hide');});", True)
        showClearandSearchButtons(True)
        btnCancelDelete.Visible = False
        GetSearchFields()
        FillHumanAggReview()
        txtstrSearchCaseID.Text = hdfstrCaseID.Value
        FillHumanAggReview()
        ToggleVisibility(CSEARCHRESULTS)
        '       ToggleVisibility(SectionHumanAggReview) 'Need to implement Arnold

    End Sub

    Protected Sub btnDelAgg_Click(sender As Object, e As EventArgs) Handles delYes.ServerClick
        'DeleteAgg()
        DeleteAggApi()
    End Sub
    Protected Sub btnClear_Click(sender As Object, e As EventArgs)
        ClearSearch()
        InitializeSearchFields()
        resetSearch()
    End Sub
    Protected Sub btnSearch_Click(sender As Object, e As EventArgs)

        If ValidateForSearch() Then

            'Need back button functionality for now we will swap buttons
            btnCancelAgg.Visible = False
            btnCancelSearch.Visible = True


            FillAggregateGrid(bRefresh:=True)
            btnShowSearchCriteria.Visible = True
            showSearchCriteria(False)
            searchResults.Visible = True
            showClearandSearchButtons(False)
        End If
    End Sub


    Protected Sub btnNo_Click(sender As Object, e As EventArgs)
        ViewState("EmptyObject").Focus()
    End Sub
    Protected Sub btnYes_Click(sender As Object, e As EventArgs)
        txtdatSearchStartDate.Text = DateTime.Today.AddYears(-1)
    End Sub

    Protected Sub btnReturnToHumanAgg_Click(sender As Object, e As EventArgs) Handles btnReturnToHumanAgg.ServerClick




        btnCancelAgg.Visible = False
        btnCancelSearch.Visible = False

        ToggleVisibility(CSEARCH)

        showClearandSearchButtons(True)

        btnShowSearchCriteria.Visible = True
        showSearchCriteria(True)
        'Clear Search Data to start new search Need to Check USeCase for details directions
        ClearSearch()
        InitializeSearchFields()

    End Sub

    Protected Sub btnNewSearch_Click(sender As Object, e As EventArgs)

        btnNewSearch.Visible = False
        HumanAggregate.Visible = False
        InitializeSearchFields()
        search.Visible = True

        'ToggleVisibility(CSEARCH)
    End Sub

    Protected Sub btnNewHAC_Click(sender As Object, e As EventArgs)
        'If HumanServiceClientAPIClient Is Nothing Then
        '    HumanServiceClientAPIClient = New HumanServiceClient()
        'End If
        Try
            txtstrCaseID.Text = ""
            HumanAggregate.Visible = True
            search.Visible = False

            'Dim diseases = HumanServiceClientAPIClient.HumanAggCaseGetMTXlistAsync(ReferenceEditorType.Disease, 2, "en").Result

            'gvDiagnosis.DataSource = diseases
            'gvDiagnosis.DataBind()

            'TODO: Arnold please check this code below - is this where we want to load the flex form data/controls.
            ' I need Human Case ID, Diagnosis ID and Form Type ID    
            'HumanAggregateFlexForm.HumanCaseID = 1000001 'Test Value 
            'HumanAggregateFlexForm.DiagnosisID = 70023994201 'Test Value

            ClearControl(HumanAggregate)

            txtdatEnteredByDate.Enabled = False
            txtstrEnteredByOffice.Enabled = False

            DisplayBtnsForAddAgg()

            '1909 Fix

            txtdatEnteredByDate.Text = String.Empty
            txtdatEnteredByDate.Text = DateTime.Today
            FindSettingDetail()
            SetupForAddOrUpate()
            If Not LoadTemplates() Is Nothing Then
                Saveobservation()
                LoadFlexFormMatrix(LoadTemplates().FirstOrDefault.idfsFormTemplate)
            End If
        Catch ex As Exception
            Throw ex
        End Try
    End Sub
    Protected Sub ddlintYear_SelectedIndexChanged(sender As Object, e As EventArgs)
        ResetTimes()
        SaveDateRangeFromDDL(sender, e)
    End Sub
    Protected Sub ddlifdsSearchAdministrativeLevel_SelectedIndexChanged(sender As Object, e As EventArgs)
        ToggleSearchAdminDdls(sender)
        resetSearch()
    End Sub
    Protected Sub btnCancel_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Dashboard.aspx")
    End Sub
    Protected Sub btnHACCancel_Click(sender As Object, e As EventArgs)
        btnNewSearch.Visible = False
        showSearchCriteria(True)
        search.Visible = True
        HumanAggregate.Visible = False

    End Sub
    Protected Sub btnCancelDelete_Click(sender As Object, e As EventArgs)
        HumanAggregate.Visible = False
        search.Visible = True
    End Sub
    Protected Sub btnNext_Click(sender As Object, e As EventArgs)

        ' Need to Add a Validate Datefields to 
        'verify Notification Date Sent Is later than Date Received 

        EnableControls(alwaysShown, False)  ' These controls are no longer available so should not need
        EnableControls(HumanAggregate, False)
        EnableLocationControls(adminSearch, False)


        If ddlintMonth.Visible = True Then
            EnableTimeIntervalControls(ddlintMonth, False)
        End If
        If ddlintQuarter.Visible = True Then
            EnableTimeIntervalControls(ddlintQuarter, False)
        End If
        If ddlintWeek.Visible = True Then
            EnableTimeIntervalControls(ddlintWeek, False)
        End If


        btnNext.Visible = False
        btnCancelAdd.Visible = False

        btnPrint.Visible = False
        btnPrintNewAgg.Visible = False

        btnHACCancel.Visible = False

        btnNotSubmit.Visible = True  'Added due to edit
        btnSubmit.Visible = True


        SaveActualData()

    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)


        btnNotSubmit.Visible = False
        btnPrintNewAgg.Visible = False     ' May not be needed here need to verify
        btnTryDelete.Visible = False
        btnHACCancel.Visible = True 'Should be able to cancel if they want to submit another edit

        EnableControls(alwaysShown, True)  ' these controls are no longer avaialble so should not need
        EnableControls(searchForm, True)  ' added since controls no longer exist in always shown
        EnableControls(HumanAggregate, True)
        EnableLocationControls(adminSearch, True)

        If ddlintMonth.Visible = True Then
            EnableTimeIntervalControls(ddlintMonth, True)
        End If
        If ddlintQuarter.Visible = True Then
            EnableTimeIntervalControls(ddlintQuarter, True)
        End If
        If ddlintWeek.Visible = True Then
            EnableTimeIntervalControls(ddlintWeek, True)
        End If

        txtstrCaseID.Text = "(new)"
        Dim allCtrl As New List(Of Control)

        'AddOrUpdateAgg()
        AddOrUpdateAggApi()
        HttpContext.Current.Session("loadMatxrixTable") = Nothing

        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & divSuccessModalContainer.ClientID & "').modal('show');});", True)



        btnSubmit.Visible = False
        btnNewHAC.Visible = True
        btnSearch.Visible = True

        HumanAggregate.Visible = True  ' Add this during debugging

        'editSearch.Visible = False
        searchResults.Visible = True

    End Sub

    Protected Sub ddlidfsReceivedByPerson_SelectedIndexChanged(sender As Object, e As EventArgs)
        ResetInstitute(ddlidfReceivedByOffice, ddlidfReceivedByPerson)
    End Sub
    Protected Sub ddlidfsReceivedByOffice_SelectedIndexChanged(sender As Object, e As EventArgs)
        ResetEmployee(ddlidfReceivedByPerson, ddlidfReceivedByOffice)
    End Sub
    Protected Sub ddlidfsSentByPerson_SelectedIndexChanged(sender As Object, e As EventArgs)
        ResetInstitute(ddlidfSentByOffice, ddlidfSentByPerson)
    End Sub
    Protected Sub ddlidfsSentByOffice_SelectedIndexChanged(sender As Object, e As EventArgs)
        ResetEmployee(ddlidfSentByPerson, ddlidfSentByOffice)
    End Sub
    Protected Sub txtdatSentByDate_TextChanged(sender As Object, e As EventArgs)
        SetNotifyDateMin()
    End Sub
    Protected Sub gvHAC_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvHAC.Sorting
        SortGrid(e, CType(sender, GridView), "dsVAggregate")
    End Sub
    Private Sub SortGrid(ByVal e As GridViewSortEventArgs, ByRef gv As GridView, ByVal vsDS As String)

        Dim sortedView As DataView = New DataView(CType(ViewState(vsDS), DataSet).Tables(0))
        Dim sortDir As String = SetSortDirection(e)

        Try
            sortedView.Sort = e.SortExpression + " " + sortDir
        Catch ex As IndexOutOfRangeException
        End Try

        gv.DataSource = sortedView
        gv.DataBind()

    End Sub
    Private Function SetSortDirection(ByVal e As GridViewSortEventArgs) As String

        Dim dir As String
        Dim lastCol As String = String.Empty
        If Not IsNothing(ViewState("aggrCol")) Then lastCol = ViewState("peoCol").ToString()

        If lastCol = e.SortExpression Then
            If ViewState("aggrDir") = "0" Then
                dir = "DESC"
                ViewState("aggrDir") = SortDirection.Descending
            Else
                dir = "ASC"
                ViewState("aggrDir") = SortDirection.Ascending
            End If
        Else
            dir = "ASC"
            ViewState("aggrDir") = SortDirection.Ascending
        End If
        ViewState("aggrCol") = e.SortExpression

        Return dir

    End Function

    Private Function GetSFileName() As String

        Return Server.MapPath("\") & "App_Data\" & Session("UserID").ToString() & "_PS.xml"

    End Function
    Private Sub gvVAC_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvHAC.RowEditing
        e.Cancel = True
        editting = True  ' Hack to get fix indexing bug need better solution 
        PopulateAggregateForEditing()

        'If Not LoadTemplates() Is Nothing Then
        '    LoadFlexFormMatrix(LoadTemplates().FirstOrDefault.idfsFormTemplate)
        'End If
        'Dim diseases = HumanServiceClientAPIClient.HumanAggCaseGetMTXlistAsync(ReferenceEditorType.Disease, 2, "en").Result

        'gvDiagnosis.DataSource = diseases
        'gvDiagnosis.DataBind()
        'PopulateAggregateForEditingApi()

        Dim templates = LoadTemplates()
        If Not templates Is Nothing Then
            LoadFlexFormMatrix(templates.FirstOrDefault.idfsFormTemplate)
            LoadActualData()
        End If

        editting = False
    End Sub
    Private Sub gvHAC_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvHAC.RowCommand
        If e.CommandName.ToUpper().EqualsAny("SELECT,EDIT".Split(",")) Then

            Dim idx As Integer = Convert.ToInt32(e.CommandArgument)
            Dim row As GridViewRow = gvHAC.Rows(idx)
            ViewState("aggCase") = gvHAC.DataKeys(idx).Values("strCaseID")

        End If
    End Sub

    Protected Sub btnAggrReviewReturnToSearchResults_Click(sender As Object, e As EventArgs)

        ToggleVisibility(CSEARCHRESULTS)

    End Sub

    Protected Sub btnAggrReviewNewSearch_Click(sender As Object, e As EventArgs)

        ClearSearch()

        ToggleVisibility(CSEARCH)


        EnableSearchControls(True)

    End Sub

    Protected Sub btnReturnToAggrRecord_Click(sender As Object, e As EventArgs)

        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & divSuccessModalContainer.ClientID & "').modal('hide');});", True)

        ' GetSearchFields()
        'txtstrSearchCaseID.Text = hdfstrCaseID.Value
        txtstrCaseID.Text = hdfstrCaseID.Value


        'FillAggregateGrid(sGetDataFor:="PAGE", bRefresh:=True)
        'searchForm.Visible = False
        HumanAggregate.Visible = True

        search.Visible = False
        searchResults.Visible = False
        btnCancelSearch.Visible = False ' Since Search results are being displayed
        btnNewSearch.Visible = True ' Allow user to go to search screen

    End Sub

    Protected Sub searchCriteria_Changed(sender As Object, e As EventArgs) Handles txtstrSearchCaseID.TextChanged, ddlidfsOrganzation.SelectedIndexChanged
        resetSearch()
    End Sub
#End Region
#Region "Error"
    Private Sub HumanAggregate_Error(Sender As Object, e As EventArgs) Handles Me.[Error]
        Dim exc As Exception = Server.GetLastError()

        HttpContext.Current.Session("loadMatxrixTable") = Nothing

        If (TypeOf exc Is HttpUnhandledException) Then

            ASPNETMsgBox("Msg_Error_On_Page")

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

#Region "FlexForm - Matrix"

    Private Sub Saveobservation()
        If FlexibleFormService Is Nothing Then
            FlexibleFormService = New FlexibleFormServiceClient()
        End If

        If CrossCuttingAPIService Is Nothing Then
            CrossCuttingAPIService = New CrossCuttingServiceClient()
        End If

        Dim templateList As List(Of AdminFfFormTemplateGetModel) = CrossCuttingAPIService.GET_FF_TEMPLATE(DiagnosisID, FormType).Result

        hdfidfsCaseObservationFormTemplate.Value = templateList.FirstOrDefault().idfsFormTemplate

        Dim gblObservationSetParams As New GblObservationSetParams With {
            .idfObservation = Nothing,
            .idfsFormTemplate = templateList.FirstOrDefault().idfsFormTemplate,
            .idfsSite = 1,
            .intRowStatus = 0
            }

        Dim setTemplatelist As List(Of GblObservationSetModel) = FlexibleFormService.SET_FF_GBLOBSERVATION(gblObservationSetParams).Result

        hdfidfCaseObservation.Value = setTemplatelist.FirstOrDefault().idfObservation

        'Dim list As List(Of AdminFfObservationsGetModel) = FlexibleFormService.GET_FF_Observation(GenrateObservationId.ToString()).Result

    End Sub

    Private Function LoadTemplates() As List(Of AdminFfFormTemplateGetModel)
        Try

            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If

            Dim list As List(Of AdminFfFormTemplateGetModel) = CrossCuttingAPIService.GET_FF_TEMPLATE(DiagnosisID, FormType).Result
            Return list
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Function

    Private Sub LoadFlexFormMatrix(formTemplate As Long)
        Try
            LoadidfVersion()
            LoadFromTemplate(formTemplate)

            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            'Retrieve the actual template and load that into the DIV tag (running at server). 
            Dim list As List(Of AdminFfParameterTemplateGetModel) = FlexibleFormService.GET_FF_ParameterTemplates(Nothing, formTemplate, GetCurrentLanguage()).Result

            Dim loadMatxrixTable As New Table With {
                        .ID = "tblHumanAggerCaseClassification",
                        .Width = New Unit("100%"),
                        .CellSpacing = 3,
                        .CellPadding = 2,
                        .HorizontalAlign = HorizontalAlign.Center
                    }

            Dim sectionRow As New TableRow With {
                .Height = New Unit(30),
                .BorderStyle = BorderStyle.Solid,
                .BorderWidth = 1,
                .BackColor = Drawing.Color.White
            }

            Dim parameteRrow As New TableRow With {
                        .Height = New Unit(30),
                        .BorderStyle = BorderStyle.Solid,
                        .BorderWidth = 1,
                        .BackColor = Drawing.Color.White
                    }
            Dim parameterControlRow As New TableRow With {
                        .Height = New Unit(30),
                        .BorderStyle = BorderStyle.Solid,
                        .BorderWidth = 1,
                        .BackColor = Drawing.Color.White
                    }

            AddStaticColumn(sectionRow, loadMatxrixTable)
            AddStaticBlankRow(parameteRrow, loadMatxrixTable)

            'Iterate through the data elements to add them to the display DIV tag's inner html
            For Each parameterTemplateRecord As AdminFfParameterTemplateGetModel In list

                ''Parameter Type will be parsed to get the list of different objects we need to rely on. 
                If Not parameterTemplateRecord.idfsSection Is Nothing Then

                    'Need a border and Section Name around the field. 
                    MatrixParseSection(parameterTemplateRecord, sectionRow, loadMatxrixTable)
                    Dim tblSectionRetrieved As TableCell = CType(pnlCaseClassification.FindControl("cellSection" + parameterTemplateRecord.idfsSection.ToString()), TableCell)
                    If Not tblSectionRetrieved Is Nothing Then
                        CreateSectionParameterColumn(parameterTemplateRecord, parameteRrow, loadMatxrixTable)
                    Else
                        CreateOnlyparameterColumn(parameterTemplateRecord, sectionRow, parameteRrow, loadMatxrixTable)
                    End If
                Else

                End If
            Next
            If list.Count > 0 Then
                AddStaticColumnControl(list.Count, parameterControlRow, loadMatxrixTable)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Sub MatrixParseSection(item As AdminFfParameterTemplateGetModel, sectionRow As TableRow, loadMatxrixTable As Table)
        Try
            Dim sectionCollection As List(Of AdminFfParentSectionsGetModel) = FlexibleFormService.GET_FF_ParentSections(GetCurrentLanguage(), item.idfsSection).Result

            'Iterate through the data elements to add them to the display DIV tag's inner html
            Dim iterationCount As Integer = 0
            Dim verifTable As String = Nothing

            For Each sectionRecord As AdminFfParentSectionsGetModel In sectionCollection
                'Now we are within each iteration row record.
                'First record should always be inserted if not already preset on the page. 
                If iterationCount = 0 Then
                    ' We are at the first record, so store the Verif table ID for the subsequent inserts for the sections. 
                    'Changing iterationCount to 1 so it doesn't go into the loop anymore. 
                    iterationCount = 1

                    verifTable = "cellSection" + sectionRecord.SectionID.ToString()
                Else
                    'The main section exists already, Now need to insert the child sections. 
                    If MatrixValidateSection(sectionRecord.SectionID, sectionRow) Then
                        'InsertSection(sectionRecord.SectionID, sectionRecord.SectionName, verifTable)
                        CreateSeactionColumn(sectionRecord.SectionID, sectionRecord.SectionName, sectionRow, loadMatxrixTable, verifTable)
                    End If
                    verifTable = "cellSection" + sectionRecord.SectionID.ToString()
                End If
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Function MatrixValidateSection(sectionID As Long, sectionRow As TableRow) As Boolean
        Dim convertedTable As TableCell = CType(sectionRow.FindControl("cellSection" + sectionID.ToString()), TableCell)
        If convertedTable Is Nothing Then
            Return True
        Else
            Return False
        End If
    End Function

    Public Sub CreateSeactionColumn(sectionID As Long, sectionName As String, sectionRow As TableRow, loadMatxrixTable As Table, Optional verifTableID As String = Nothing)
        Try
            Dim FindCell = sectionRow.FindControl("cellSection" + sectionID.ToString())

            Dim countParameter = FlexibleFormService.GET_FF_Parameters(GetCurrentLanguage(), sectionID, Nothing).Result.Count

            'Dim Color As Color = CType(ColorConverter.ConvertFromString("#FFDFD991"), Color)

            If FindCell Is Nothing Then
                Dim cell1 As New TableHeaderCell With
                {
                    .ID = "cellSection" + sectionID.ToString(),
                    .BorderWidth = 1,
                    .BorderStyle = BorderStyle.Solid,
                    .BorderColor = Color.Gray,
                    .ColumnSpan = countParameter,
                    .HorizontalAlign = HorizontalAlign.Center,
                    .Width = New Unit("100%"),
                    .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12 sectioncenter",
                    .BackColor = ColorTranslator.FromHtml("#2d5b83"),
                    .ForeColor = Color.White
                }


                Dim headerLabel As New Label With {
            .ID = "lblHeader" + sectionID.ToString(),
            .Text = sectionName
        }
                cell1.Controls.Add(headerLabel)
                sectionRow.Cells.Add(cell1)
                loadMatxrixTable.Rows.Add(sectionRow)
                pnlCaseClassification.Controls.Add(loadMatxrixTable)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Public Sub CreateOnlyparameterColumn(item As AdminFfParameterTemplateGetModel, sectionRow As TableRow, parameterRow As TableRow, loadMatxrixTable As Table)
        Try
            Dim cell1 As New TableHeaderCell With
            {
                .ID = "cellSection" + item.idfsParameter.ToString(),
                .BorderWidth = 1,
                .BorderStyle = BorderStyle.Solid,
                .BorderColor = Drawing.Color.Gray,
                .ColumnSpan = 1,
                .HorizontalAlign = HorizontalAlign.Center,
                .Width = New Unit("100%"),
                .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12 sectioncenter",
                .BackColor = ColorTranslator.FromHtml("#2d5b83"),
                .ForeColor = Drawing.Color.White
            }
            Dim headerLabel As New Label With {
            .ID = "lblHeader" + item.idfsParameter.ToString(),
            .Text = item.DefaultName
        }


            Dim cell2 As New TableHeaderCell With
            {
                .BorderWidth = 1,
                .BorderStyle = BorderStyle.Solid,
                .BorderColor = Drawing.Color.Gray,
                .ColumnSpan = 1,
                .HorizontalAlign = HorizontalAlign.Center,
                .Width = New Unit("100%"),
                .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12"
            }
            Dim headerLabel1 As New Label With {
            .Text = "            "
        }

            cell1.Controls.Add(headerLabel)
            sectionRow.Cells.Add(cell1)
            loadMatxrixTable.Rows.Add(sectionRow)

            cell2.Controls.Add(headerLabel1)
            parameterRow.Cells.Add(cell2)
            loadMatxrixTable.Rows.Add(parameterRow)

            pnlCaseClassification.Controls.Add(loadMatxrixTable)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Public Sub CreateSectionParameterColumn(item As AdminFfParameterTemplateGetModel, parameterRow As TableRow, loadMatxrixTable As Table)
        Try
            Dim FindCell = parameterRow.FindControl("cellSection" + item.idfsParameter.ToString())

            If FindCell Is Nothing Then
                Dim cell1 As New TableHeaderCell With
                {
                    .ID = "cellSection" + item.idfsParameter.ToString(),
                    .BorderWidth = 1,
                    .BorderStyle = BorderStyle.Solid,
                    .BorderColor = Drawing.Color.Gray,
                    .HorizontalAlign = HorizontalAlign.Center,
                    .Width = New Unit("100%"),
                    .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12 sectioncenter",
                    .ColumnSpan = 1
                }

                Dim headerLabel As New Label With {
            .ID = "lblHeader" + item.idfsParameter.ToString(),
            .Text = item.DefaultName
        }
                cell1.Controls.Add(headerLabel)
                parameterRow.Cells.Add(cell1)
                loadMatxrixTable.Rows.Add(parameterRow)
                pnlCaseClassification.Controls.Add(loadMatxrixTable)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Public Sub CreateParameterColumn(item As AdminFfParameterTemplateGetModel, parameterControlRow As TableRow, loadMatxrixTable As Table)
        Try

            Dim ParameterList As List(Of AdminFfParametersGetModel) = FlexibleFormService.GET_FF_Parameters(GetCurrentLanguage(), item.idfsSection, item.idfsFormType).Result

            Dim parameterType As String = String.Empty
            For Each parameterItem As AdminFfParametersGetModel In ParameterList
                If parameterItem.idfsParameter = item.idfsParameter Then
                    parameterType = parameterItem.ParameterTypeName
                    'Exit For
                End If
            Next
            Dim cell2 As New TableCell With
            {
                    .Width = New Unit("60%"),
                    .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12",
                    .BorderWidth = 1,
                    .BorderStyle = BorderStyle.Solid,
                    .BorderColor = Drawing.Color.Gray,
                    .HorizontalAlign = HorizontalAlign.Center,
                    .ColumnSpan = 1,
                    .RowSpan = 1
            }

            Select Case parameterType
                Case "Numeric Natural"
                    Dim textNumber As New TextBox With {
                    .ID = "txtNumberNatural" + item.idfsParameter.ToString(),
                    .Width = 200,
                    .CssClass = "form-control"
                }
                    cell2.Controls.Add(textNumber)

                Case "Y_N_Unk"

                    Dim childDropDownList As New DropDownList With {
                   .ID = "ddlYNU" + item.idfsParameter.ToString(),
                   .Width = 250,
                    .CssClass = "form-control"
                }

                    'Call the API to load the Dropdown list. 
                    Dim dropDownList As List(Of AdminFfParameterSelectListGetModel) = FlexibleFormService.GET_FF_ParametersSelectList(GetCurrentLanguage(), item.idfsParameter, item.idfsParameterType, Nothing).Result
                    childDropDownList.DataSource = dropDownList
                    childDropDownList.DataTextField = "strValueCaption"
                    childDropDownList.DataValueField = "idfsValue"
                    childDropDownList.DataBind()
                    childDropDownList.Items.Insert(0, "")
                    cell2.Controls.Add(childDropDownList)

                Case "Boolean"

                    Dim chkBoxItem As New CheckBox With {
                    .ID = "chk" + item.idfsParameter.ToString(),
                    .CssClass = "form-control"
                }
                    cell2.Controls.Add(chkBoxItem)

                Case "String"

                    Dim textString As New TextBox With {
                    .ID = "txtString" + item.idfsParameter.ToString(),
                    .Width = 200,
                    .CssClass = "form-control"
                }
                    cell2.Controls.Add(textString)

                Case "Numeric Positive"

                    Dim textNumber As New TextBox With {
                    .ID = "txtNumberPositive" + item.idfsParameter.ToString(),
                    .Width = 200,
                    .CssClass = "form-control"
                }
                    cell2.Controls.Add(textNumber)

                Case "Date"

                    Dim textDate As New EIDSSControlLibrary.CalendarInput With {
                        .ID = "txtDate" + item.idfsParameter.ToString(),
                        .ContainerCssClass = "input-group datepicker",
                        .CssClass = "form-control"
                    }
                    '<eidss:CalendarInput ContainerCssClass = "input-group datepicker" ID="txtdatNotificationDate" runat="server" CssClass="form-control"></eidss: CalendarInput>
                    cell2.Controls.Add(textDate)

                Case Else
                    Dim childDropDownList As New DropDownList With {
                    .ID = "ddlParam" + item.idfsParameter.ToString(),
                    .Width = 250,
                    .CssClass = "form-control"
                }

                    '' Here is where we link teh dropdowns with the Parameter FIxed pre-set / Reference type values. 
                    'Call the API to load the Dropdown list. 
                    Dim dropDownList As List(Of AdminFfParameterSelectListGetModel) = FlexibleFormService.GET_FF_ParametersSelectList(GetCurrentLanguage(), item.idfsParameter, item.idfsParameterType, Nothing).Result
                    childDropDownList.DataSource = dropDownList
                    childDropDownList.DataTextField = "strValueCaption"
                    childDropDownList.DataValueField = "idfsValue"
                    childDropDownList.DataBind()
                    childDropDownList.Items.Insert(0, "")
                    cell2.Controls.Add(childDropDownList)
            End Select

            parameterControlRow.Cells.Add(cell2)
            loadMatxrixTable.Rows.Add(parameterControlRow)
            pnlCaseClassification.Controls.Add(loadMatxrixTable)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub AddStaticColumn(sectionRow As TableRow, loadMatxrixTable As Table)
        Dim cell1 As New TableHeaderCell With
                {
                    .BorderWidth = 1,
                    .BorderStyle = BorderStyle.Solid,
                    .BorderColor = Color.Gray,
                    .ColumnSpan = 1,
                    .HorizontalAlign = HorizontalAlign.Center,
                    .Width = New Unit("100%"),
                    .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12 sectioncenter",
                    .BackColor = ColorTranslator.FromHtml("#2d5b83"),
                    .ForeColor = Color.White
                }


        Dim headerLabel As New Label With
        {
          .Text = "Diagnosis"
        }
        cell1.Controls.Add(headerLabel)
        sectionRow.Cells.Add(cell1)



        Dim cell2 As New TableHeaderCell With
        {
            .BorderWidth = 1,
            .BorderStyle = BorderStyle.Solid,
            .BorderColor = Drawing.Color.Gray,
            .HorizontalAlign = HorizontalAlign.Center,
            .Width = New Unit("100%"),
            .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12 sectioncenter",
            .ColumnSpan = 1,
            .BackColor = ColorTranslator.FromHtml("#2d5b83"),
            .ForeColor = Color.White
        }

        Dim headerLabel2 As New Label With
        {
            .Text = "ICD-10 Code"
        }

        cell2.Controls.Add(headerLabel2)
        sectionRow.Cells.Add(cell2)
        loadMatxrixTable.Rows.Add(sectionRow)


        pnlCaseClassification.Controls.Add(loadMatxrixTable)
    End Sub

    Protected Sub AddStaticBlankRow(parameterRow As TableRow, loadMatxrixTable As Table)
        Dim cell1 As New TableHeaderCell With
                {
                    .BorderWidth = 1,
                    .BorderStyle = BorderStyle.Solid,
                    .BorderColor = Color.Gray,
                    .HorizontalAlign = HorizontalAlign.Center,
                    .Width = New Unit("100%"),
                    .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12 sectioncenter"
                }


        Dim headerLabel As New Label With
        {
          .Text = "     "
        }
        cell1.Controls.Add(headerLabel)
        parameterRow.Cells.Add(cell1)



        Dim cell2 As New TableHeaderCell With
        {
            .BorderWidth = 1,
            .BorderStyle = BorderStyle.Solid,
            .BorderColor = Drawing.Color.Gray,
            .HorizontalAlign = HorizontalAlign.Center,
            .Width = New Unit("100%"),
            .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12 sectioncenter"
        }

        Dim headerLabel2 As New Label With
        {
            .Text = "     "
        }

        cell2.Controls.Add(headerLabel2)
        parameterRow.Cells.Add(cell2)
        loadMatxrixTable.Rows.Add(parameterRow)


        pnlCaseClassification.Controls.Add(loadMatxrixTable)
    End Sub

    Protected Sub LoadidfVersion()
        Try
            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            'Dim formTypeCollection As List(Of AdminFfFormTypesGetModel) = FlexibleFormService.GET_FF_FormType(GetCurrentLanguage(), FormType).Result
            If Not LoadFormType() Is Nothing Then
                If Not LoadFormType().FirstOrDefault().idfsMatrixType Is Nothing Then
                    Dim matrixlist As List(Of AdminFfAggregateMatrixVersionGetListModel) = FlexibleFormService.GET_FF_AGGREGATEMATRIX(GetCurrentLanguage(), LoadFormType().FirstOrDefault().idfsMatrixType).Result

                    If matrixlist.Count > 0 Then
                        ddlidfVersion.DataSource = matrixlist
                        ddlidfVersion.DataTextField = "MatrixName"
                        ddlidfVersion.DataValueField = "idfVersion"
                        ddlidfVersion.DataBind()
                    Else

                    End If
                End If
            End If




        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Protected Function LoadFormType() As List(Of AdminFfFormTypesGetModel)
        Try
            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            Dim formTypeCollection As List(Of AdminFfFormTypesGetModel) = FlexibleFormService.GET_FF_FormType(GetCurrentLanguage(), FormType).Result
            Return formTypeCollection
        Catch ex As Exception
            Throw ex
        End Try
    End Function

    Protected Sub LoadFromTemplate(idfsFormTemplate As Long?)
        Try
            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            Dim templateCollection As List(Of AdminFfTemplatesGetModel) = FlexibleFormService.GET_FF_Templates(GetCurrentLanguage(), idfsFormTemplate, Nothing).Result

            If templateCollection.Count > 0 Then
                ddlTemplate.DataSource = templateCollection
                ddlTemplate.DataTextField = "DefaultName"
                ddlTemplate.DataValueField = "idfsFormTemplate"
                ddlTemplate.DataBind()
            Else

            End If

        Catch ex As Exception
            Throw ex
        End Try
    End Sub

    Public Sub SaveActualData()
        ' Handle your Button clicks here
        Try
            Dim allCtrl As New List(Of Control)

            allCtrl.Clear()
            Dim cls As New clsCommon
            'Iterate through all text boxes. 


            For Each txt As WebControls.TextBox In cls.FindCtrl(allCtrl, pnlCaseClassification, GetType(WebControls.TextBox))

                'ParseParameter
                Dim idfsParameterRetreived As Long = ExtractParameterID(txt.ID.ToString())
                Dim DataTypeAndID As String = txt.ID.Remove(txt.ID.IndexOf("txt"), "txt".Length)
                Dim DataType As String = DataTypeAndID.Replace(idfsParameterRetreived.ToString(), "")
                Dim idfsRow As Long = ExtractRowID(txt.ID.ToString())
                Dim ActivityParamValue As String

                'Whether empty or not, it should be updated, what if the user deleted data and wants to update it. 
                'If txt.Text <> "" Then
                ActivityParamValue = txt.Text
                If FlexibleFormService Is Nothing Then
                    FlexibleFormService = New FlexibleFormServiceClient()
                End If

                Dim parameters As AdminFfSetActivityParameters = New AdminFfSetActivityParameters With {
                .idfsParameter = idfsParameterRetreived,
                .idfObservation = CType(hdfidfCaseObservation.Value, Long),
                .idfsFormTemplate = CType(hdfidfsCaseObservationFormTemplate.Value, Long),
                .varValue = ActivityParamValue,
                .isDynamicParameter = False,
                .idfRow = idfsRow,
                .idfActivityParameters = Nothing
                }

                Dim listSave As List(Of AdminFfActivityParametersSetModel) = FlexibleFormService.SET_FF_ActivityParameters(parameters).Result
            Next

            allCtrl.Clear()
            'Iterate through all check Boxes. 
            For Each chk As WebControls.CheckBox In cls.FindCtrl(allCtrl, pnlCaseClassification, GetType(WebControls.CheckBox))

                'ParseParameter
                Dim idfsParameterRetreived As Long = ExtractParameterID(chk.ID.ToString())
                Dim DataTypeAndID As String = chk.ID.Remove(chk.ID.IndexOf("chk"), "chk".Length)
                Dim DataType As String = DataTypeAndID.Replace(idfsParameterRetreived.ToString(), "")
                Dim idfsRow As Long = ExtractRowID(chk.ID.ToString())

                Dim ActivityParamValue As Boolean

                'Whether empty or not, it should be updated, what if the user deleted data and wants to update it. 
                'If txt.Text <> "" Then
                ActivityParamValue = chk.Checked
                If FlexibleFormService Is Nothing Then
                    FlexibleFormService = New FlexibleFormServiceClient()
                End If

                Dim parameters As AdminFfSetActivityParameters = New AdminFfSetActivityParameters With {
                    .idfsParameter = idfsParameterRetreived,
                    .idfObservation = CType(hdfidfCaseObservation.Value, Long),
                    .idfsFormTemplate = CType(hdfidfsCaseObservationFormTemplate.Value, Long),
                    .varValue = Convert.ToString(ActivityParamValue),
                    .isDynamicParameter = False,
                    .idfRow = idfsRow,
                    .idfActivityParameters = Nothing
                    }

                Dim listSave As List(Of AdminFfActivityParametersSetModel) = FlexibleFormService.SET_FF_ActivityParameters(parameters).Result
                'Dim listSave As List(Of AdminFfActivityParametersSetModel) = FlexibleFormAppService.SET_FF_ActivityParameters(idfsParameterRetreived, ObservationID, FormTemplateID, Convert.ToString(ActivityParamValue), False, Nothing, Nothing).Result

            Next

            allCtrl.Clear()
            'Iterate through all DropdownLists. 
            For Each ddl As WebControls.DropDownList In cls.FindCtrl(allCtrl, pnlCaseClassification, GetType(WebControls.DropDownList))

                'ParseParameter
                Dim idfsParameterRetreived As Long = ExtractParameterID(ddl.ID.ToString())
                Dim DataTypeAndID As String = ddl.ID.Remove(ddl.ID.IndexOf("ddl"), "ddl".Length)
                Dim DataType As String = DataTypeAndID.Replace(idfsParameterRetreived.ToString(), "")
                Dim idfsRow As Long = ExtractRowID(ddl.ID.ToString())

                Dim ActivityParamValue As String
                'Whether empty or not, it should be updated, what if the user deleted data and wants to update it. 
                ActivityParamValue = ddl.SelectedValue.ToString()
                If FlexibleFormService Is Nothing Then
                    FlexibleFormService = New FlexibleFormServiceClient()
                End If

                Dim parameters As AdminFfSetActivityParameters = New AdminFfSetActivityParameters With {
                    .idfsParameter = idfsParameterRetreived,
                    .idfObservation = CType(hdfidfCaseObservation.Value, Long),
                    .idfsFormTemplate = CType(hdfidfsCaseObservationFormTemplate.Value, Long),
                    .varValue = Convert.ToString(ActivityParamValue),
                    .isDynamicParameter = False,
                    .idfRow = idfsRow,
                    .idfActivityParameters = Nothing
                    }

                Dim listSave As List(Of AdminFfActivityParametersSetModel) = FlexibleFormService.SET_FF_ActivityParameters(parameters).Result
                'Dim listSave As List(Of AdminFfActivityParametersSetModel) = FlexibleFormAppService.SET_FF_ActivityParameters(idfsParameterRetreived, ObservationID, FormTemplateID, ActivityParamValue, False, Nothing, Nothing).Result
            Next

            allCtrl.Clear()
            'Iterate through all Date controls. 
            For Each txtDT As EIDSSControlLibrary.CalendarInput In cls.FindCtrl(allCtrl, pnlCaseClassification, GetType(EIDSSControlLibrary.CalendarInput))

                'ParseParameter
                Dim idfsParameterRetreived As Long = ExtractParameterID(txtDT.ID.ToString())
                Dim DataTypeAndID As String = txtDT.ID.Remove(txtDT.ID.IndexOf("txt"), "txt".Length)
                Dim DataType As String = DataTypeAndID.Replace(idfsParameterRetreived.ToString(), "")
                Dim idfsRow As Long = ExtractRowID(txtDT.ID.ToString())

                Dim ActivityParamValue As String
                'Whether empty or not, it should be updated, what if the user deleted data and wants to update it. 
                ActivityParamValue = txtDT.Text
                If FlexibleFormService Is Nothing Then
                    FlexibleFormService = New FlexibleFormServiceClient()
                End If

                Dim parameters As AdminFfSetActivityParameters = New AdminFfSetActivityParameters With {
                    .idfsParameter = idfsParameterRetreived,
                    .idfObservation = CType(hdfidfCaseObservation.Value, Long),
                    .idfsFormTemplate = CType(hdfidfsCaseObservationFormTemplate.Value, Long),
                    .varValue = Convert.ToString(ActivityParamValue),
                    .isDynamicParameter = False,
                    .idfRow = idfsRow,
                    .idfActivityParameters = Nothing
                    }

                Dim listSave As List(Of AdminFfActivityParametersSetModel) = FlexibleFormService.SET_FF_ActivityParameters(parameters).Result
                'Dim listSave As List(Of AdminFfActivityParametersSetModel) = FlexibleFormAppService.SET_FF_ActivityParameters(idfsParameterRetreived, ObservationID, FormTemplateID, ActivityParamValue, False, Nothing, Nothing).Result
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Shared Function ExtractParameterID(ByVal value As String) As Long
        Dim returnVal As String = String.Empty
        Dim splittedValues As String() = value.Split(New Char() {"_"c})
        Dim collection As MatchCollection = Regex.Matches(splittedValues(0), "\d+")
        For Each m As Match In collection
            returnVal += m.ToString()
        Next
        Return Long.Parse(returnVal)
    End Function

    Private Shared Function ExtractRowID(ByVal value As String) As Long
        Dim returnVal As String = String.Empty
        Dim splittedValues As String() = value.Split(New Char() {"_"c})
        Dim collection As MatchCollection = Regex.Matches(splittedValues(1), "\d+")
        For Each m As Match In collection
            returnVal += m.ToString()
        Next
        Return Long.Parse(returnVal)
    End Function


    Public Sub EnableControls(value As Boolean)
        Dim cls As New clsCommon
        Dim allCtrl As New List(Of Control)
        allCtrl.Clear()
        'Iterate through all DropdownLists. 
        For Each ddl As WebControls.DropDownList In cls.FindCtrl(allCtrl, pnlCaseClassification, GetType(WebControls.DropDownList))
            ddl.Enabled = value
        Next
        allCtrl.Clear()
        'Iterate through all Date controls. 
        For Each txtDT As EIDSSControlLibrary.CalendarInput In cls.FindCtrl(allCtrl, pnlCaseClassification, GetType(EIDSSControlLibrary.CalendarInput))
            txtDT.Enabled = value
        Next

        allCtrl.Clear()
        'Iterate through all check Boxes. 
        For Each chk As WebControls.CheckBox In cls.FindCtrl(allCtrl, pnlCaseClassification, GetType(WebControls.CheckBox))
            chk.Enabled = value
        Next

        allCtrl.Clear()
        'Iterate through all text boxes. 
        For Each txt As WebControls.TextBox In cls.FindCtrl(allCtrl, pnlCaseClassification, GetType(WebControls.TextBox))
            txt.Enabled = value
        Next

    End Sub

    Private Sub LoadActualData()

        Dim cls As New clsCommon
        Dim allCtrl As New List(Of Control)
        allCtrl.Clear()

        If FlexibleFormService Is Nothing Then
            FlexibleFormService = New FlexibleFormServiceClient()
        End If

        Dim listGet As List(Of AdminFfActivityParametersGetModel) = FlexibleFormService.GET_FF_ActivityParameters(Convert.ToString(hdfidfCaseObservation.Value), GetCurrentLanguage()).Result

        For Each activityParameter As AdminFfActivityParametersGetModel In listGet
            For Each txt As WebControls.TextBox In cls.FindCtrl(allCtrl, pnlCaseClassification, GetType(WebControls.TextBox))

                'ParseParameter
                Dim idfsParameterRetreived As Long = ExtractParameterID(txt.ID.ToString())
                Dim DataTypeAndID As String = txt.ID.Remove(txt.ID.IndexOf("txt"), "txt".Length)
                Dim DataType As String = DataTypeAndID.Replace(idfsParameterRetreived.ToString(), "")
                Dim idfsRow As Long = ExtractRowID(txt.ID.ToString())

                If activityParameter.idfsParameter = idfsParameterRetreived And activityParameter.idfRow = idfsRow Then
                    txt.Text = activityParameter.varValue
                    Exit For
                End If
            Next

            allCtrl.Clear()
            'Iterate through all DropdownLists. 
            For Each ddl As WebControls.DropDownList In cls.FindCtrl(allCtrl, pnlCaseClassification, GetType(WebControls.DropDownList))
                'ParseParameter
                Dim idfsParameterRetreived As Long = ExtractParameterID(ddl.ID.ToString())
                Dim DataTypeAndID As String = ddl.ID.Remove(ddl.ID.IndexOf("ddl"), "ddl".Length)
                Dim DataType As String = DataTypeAndID.Replace(idfsParameterRetreived.ToString(), "")
                Dim idfsRow As Long = ExtractRowID(ddl.ID.ToString())

                If activityParameter.idfsParameter = idfsParameterRetreived And activityParameter.idfRow = idfsRow Then
                    ddl.SelectedValue = activityParameter.varValue
                    Exit For
                End If
            Next

            allCtrl.Clear()
            'Iterate through all Date controls. 
            For Each txtDT As EIDSSControlLibrary.CalendarInput In cls.FindCtrl(allCtrl, pnlCaseClassification, GetType(EIDSSControlLibrary.CalendarInput))
                'ParseParameter
                Dim idfsParameterRetreived As Long = ExtractParameterID(txtDT.ID.ToString())
                Dim DataTypeAndID As String = txtDT.ID.Remove(txtDT.ID.IndexOf("txt"), "txt".Length)
                Dim DataType As String = DataTypeAndID.Replace(idfsParameterRetreived.ToString(), "")
                Dim idfsRow As Long = ExtractRowID(txtDT.ID.ToString())

                If activityParameter.idfsParameter = idfsParameterRetreived And activityParameter.idfRow = idfsRow Then
                    txtDT.Text = activityParameter.varValue
                    Exit For
                End If
            Next

            allCtrl.Clear()
            'Iterate through all check Boxes. 
            For Each chk As WebControls.CheckBox In cls.FindCtrl(allCtrl, pnlCaseClassification, GetType(WebControls.CheckBox))
                'ParseParameter
                Dim idfsParameterRetreived As Long = ExtractParameterID(chk.ID.ToString())
                Dim DataTypeAndID As String = chk.ID.Remove(chk.ID.IndexOf("chk"), "chk".Length)
                Dim DataType As String = DataTypeAndID.Replace(idfsParameterRetreived.ToString(), "")
                Dim idfsRow As Long = ExtractRowID(chk.ID.ToString())

                If activityParameter.idfsParameter = idfsParameterRetreived And activityParameter.idfRow = idfsRow Then
                    chk.Checked = Boolean.Parse(activityParameter.varValue)
                    Exit For
                End If
            Next
        Next
    End Sub

    Protected Sub AddStaticColumnControl(parameterCount As Int16, parameterControlRow As TableRow, loadMatxrixTable As Table)
        Try

            HttpContext.Current.Session("loadMatxrixTable") = Nothing

            If FlexibleFormService Is Nothing Then
                FlexibleFormService = New FlexibleFormServiceClient()
            End If

            If Not LoadFormType() Is Nothing Then
                If Not LoadFormType().FirstOrDefault().idfsMatrixType Is Nothing Then
                    If Not LoadTemplates() Is Nothing Then
                        Dim preStublist As List(Of AdminFfPredefinedStubGetModel) = FlexibleFormService.GET_FF_PREDEFINEDSTUB(LoadFormType().FirstOrDefault().idfsMatrixType, ddlidfVersion.SelectedValue, GetCurrentLanguage(), LoadTemplates().FirstOrDefault().idfsFormTemplate).Result

                        For index = 1 To preStublist.Count - 1
                            If preStublist(index).idfRow = preStublist(index - 1).idfRow Then
                                parameterControlRow = New TableRow()
                                Dim cell1 As New TableCell With
                                {
                                    .BorderWidth = 1,
                                    .BorderStyle = BorderStyle.Solid,
                                    .BorderColor = Color.Gray,
                                    .ColumnSpan = 1,
                                    .HorizontalAlign = HorizontalAlign.Left,
                                    .Width = New Unit("100%"),
                                    .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12 Diagnosis"
                                }

                                Dim headerLabel As New Label With
                                {
                                  .Text = preStublist(index - 1).strNameValue
                                }

                                cell1.Controls.Add(headerLabel)
                                parameterControlRow.Cells.Add(cell1)


                                Dim cell2 As New TableCell With
                                {
                                    .BorderWidth = 1,
                                    .BorderStyle = BorderStyle.Solid,
                                    .BorderColor = Color.Gray,
                                    .ColumnSpan = 1,
                                    .HorizontalAlign = HorizontalAlign.Left,
                                    .Width = New Unit("100%"),
                                    .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12 Diagnosis"
                                }

                                Dim headerLabel2 As New Label With
                                {
                                    .Text = preStublist(index).idfsParameterValue,
                                    .Width = New Unit("100%")
                                }

                                cell2.Controls.Add(headerLabel2)
                                parameterControlRow.Cells.Add(cell2)

                                For controIndex = 1 To parameterCount
                                    Dim cell3 As New TableCell With
                                {
                                    .BorderWidth = 1,
                                    .BorderStyle = BorderStyle.Solid,
                                    .BorderColor = Drawing.Color.Gray,
                                    .HorizontalAlign = HorizontalAlign.Center,
                                    .Width = New Unit("100%"),
                                    .CssClass = "col-lg-4 col-md-4 col-sm-6 col-xs-12 sectioncenter",
                                    .ColumnSpan = 1
                                }

                                    Dim cellTextBox As New TextBox With
                                    {
                                        .ID = "txtString" + preStublist(index).idfRow.ToString() + "_" + controIndex.ToString(),
                                        .Text = "",
                                        .CssClass = "form-control",
                                        .Width = 150
                                    }

                                    cell3.Controls.Add(cellTextBox)
                                    parameterControlRow.Cells.Add(cell3)
                                Next
                                loadMatxrixTable.Rows.Add(parameterControlRow)
                            End If
                        Next
                    End If
                End If
            End If
            pnlCaseClassification.Controls.Add(loadMatxrixTable)
            HttpContext.Current.Session("loadMatxrixTable") = loadMatxrixTable
        Catch ex As Exception
            Throw ex
        End Try
    End Sub

#End Region
End Class