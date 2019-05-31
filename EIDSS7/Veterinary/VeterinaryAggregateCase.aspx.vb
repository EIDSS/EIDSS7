Imports EIDSS.EIDSS
Imports System.Reflection
Imports System.Drawing
Imports EIDSS.Client.API_Clients
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts


Public Class VeterinaryAggregate
    Inherits BaseEidssPage

    Dim oAgg As clsAggregate = New clsAggregate()

    'Constants for Sections/Panels on the form
    Private Const CSEARCHRESULTS As String = "searchResults"
    Private Const CALWAYSSHOWN As String = "alwaysShown"
    Private Const CSEARCH As String = "searchForm"
    Private Shared Log = log4net.LogManager.GetLogger(GetType(VeterinaryAggregate))

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

    Private Const CVeterinaryAGGR As String = "VeterinaryAggregate"
    Private Const SEARCH_FILE_PREFIX As String = "_VA"
    Private Const SEARCH_SP As String = "VeterinaryGetList"
    Private Const VETAGG_DATASET As String = "dsVAggregate"
    Private Const VETERINARY_DISEASE_REPORT_DATASET As String = "dsVeterinaryDiseaseReports"
    Private Const SectionVetAggReview As String = "Veterinary Aggregate Review"

    Private ReadOnly DiagnosisID As Long = 70023994201
    Private ReadOnly FormType As Long = 10034021

    Private ReadOnly HumanServiceClientAPIClient As HumanServiceClient
    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private FlexibleFormService As FlexibleFormServiceClient

    Public Structure AggregateSettingsConfig
        Public Shared StatisticalPeriodType As String = ""
        Public Shared StatisticalAreaType As String = ""
    End Structure


#Region "Initialize"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            If Not IsPostBack Then
                PopulateSearchDropDowns()
                gvVAC.DataSource = New List(Of Object)
                gvVAC.DataBind()
                InitializePage()
            Else
                If Not HttpContext.Current.Session("loadMatxrixTable") Is Nothing Then
                    Dim loadMatxrixTable As Table = HttpContext.Current.Session("loadMatxrixTable")
                    pnlCaseClassification.Controls.Add(loadMatxrixTable)
                End If

                Dim target As String = TryCast(Request("__EVENTTARGET"), String)
                Dim setName As String = "ctl00$EIDSSBodyCPH$sLI$ddlsLIidfsSettlement"
                Dim searchRegName As String = "ctl00$EIDSSBodyCPH$lucVeterinaryAggregate$ddllucVeterinaryAggregateidfsRegion"
                Dim searchRayName As String = "ctl00$EIDSSBodyCPH$lucVeterinaryAggregate$ddllucVeterinaryAggregateidfsRayon"

                If target.EqualsAny({searchRegName, searchRayName}) Then
                    searchResults.Visible = False
                    searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
                    btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")
                    btnShowSearchCriteria.Visible = False
                End If
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' This functon needs to be moved to a common object, since it will be used by 
    ''' Vet Aggregate Disease Report, Action Report, Human Disease - Asim (ToDo)
    ''' 
    ''' Get StatisticalPeriodType & StatisticAreaType from AggregateSettings Connfiguration;
    ''' </summary>

    Private Function LoadAggregateSettings()

        Dim ConfigurationAPIClient = New ConfigurationServiceClient()
        Dim globalSiteDetails = New GblSiteGetDetailModel
        Dim CrossCuttingAPIClient = New CrossCuttingServiceClient()
        Dim Table1 As Table = New Table

        Dim userId = Session(UserConstants.idfUserID)
        Dim userSite = Session(UserConstants.UserSite)
        If String.IsNullOrEmpty(userId) = False And String.IsNullOrEmpty(userSite) = False Then
            Log.Info(String.Format("Getting UserId and SiteId Variables from Session: UserId ={0} SiteId={1}", userId.ToString(), userSite.ToString()))
            globalSiteDetails = CrossCuttingAPIClient.GetGlobalSiteDetails(userSite, userId).Result(0)
            If globalSiteDetails Is Nothing Or globalSiteDetails.idfCustomizationPackage = 0 Then
                Response.Redirect("~/Login.aspx")
            End If
        End If

        'For reference:      
        'Select * from [dbo].[fnReference] ('en',19000102) ===> where 'en' is langID; 19000102 is CaseTypes;
        'USP_CONF_AggregateSetting_GetList (51577430000000) ===> 51577430000000 is idfCustomizationPackage

        Dim savedSettings = ConfigurationAPIClient.GetAggregateSettings(globalSiteDetails.idfCustomizationPackage)

        Try
            Log.Info("Starting VeterinaryAggregateCase.LoadAggregateSettings")
            If savedSettings.Count() > 0 Then
                For row = 1 To savedSettings.Count()

                    Dim aggrCaseType As String = savedSettings.Item(row - 1).idfsAggrCaseType.ToString()
                    If aggrCaseType = AggregateValue.Veterinary Then

                        'Get adminLevel value
                        AggregateSettingsConfig.StatisticalAreaType = savedSettings(row - 1).idfsStatisticAreaType
                        'Get minTimeInterval value
                        AggregateSettingsConfig.StatisticalPeriodType = savedSettings(row - 1).idfsStatisticPeriodType

                        Exit For
                    End If
                Next
            End If
            Log.Info("Finished VeterinaryAggregateCase.LoadAggregateSettings")

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Function

    Private Sub InitializePage()
        Try
            ' searchResults.Visible = False
            ToggleVisibility(CSEARCH)
            hdfidfsAggrCaseType.Value = AggregateValue.Veterinary
            hdfLangID.Value = getConfigValue("DefaultLanguage")

            btnPrint.Visible = False

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
#End Region
#Region "Common"
    Private Sub PopulateSearchDropDowns()

        Try
            BaseReferenceLookUp(ddlifdsSearchAdministrativeLevel, BaseReferenceConstants.AdministrativeLevel, blnBlankRow:=False)
            FillOrganizationList(ddlidfsOrganzation, Nothing, Nothing, True)

            'Bug # 2499 - Organization is enabled - (Begin) - Asim
            If lucSearch.LocationRegionID = 0 Then
                ddlidfsOrganzation.Enabled = False
            End If
            'Bug # 2499 - Organization is enabled - (End) - Asim

            BaseReferenceLookUp(ddlidfsTimeInterval, BaseReferenceConstants.StatisticalPeriodType, HACodeList.NoneHACode, blnBlankRow:=False)
            GetSearchFields()
            InitializeSearchFields()

        Catch ae As ArgumentOutOfRangeException
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub InitializeSearchFields()

        Try
            'set defaults on these, per use case (This is the value displayed on the SearchPage "Time Interval" dropdown)
            ddlidfsTimeInterval.SelectedIndex = TimeIntervalMONTH

            ddlifdsSearchAdministrativeLevel.SelectedIndex = AdministrativeLevelRAYON
            ClearAdministrativeUnitControl()

        Catch ae As ArgumentOutOfRangeException

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub


    Private Sub PopulateEditDropDowns()

        Try
            'time-based values
            FillUpToCurrentYear()

            'need to have year ddl populated before
            'display based on AggregateSettings
            ToggleEditTimeDdls(ddlidfsTimeInterval)

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

            'Fill hidden fields with the INT values of the above
            hdfidfEnteredByPerson.Value = Session("UserID").ToString()
            hdfidfEnteredByOffice.Value = Session("Institution").ToString()
            txtdatEnteredByDate1.Text = DateTime.Today.ToShortDateString()

            Dim txtSite = Session("UserSite").ToString()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub GetInitialLocation()

        'get location region, and rayon


    End Sub


    Private Sub SetDefaultsAndLimits()

        Try
            'set limits on calendars, etc
            txtdatSentbyDate.MaxDate = DateTime.Today.ToShortDateString()
            txtdatReceivedByDate.MaxDate = DateTime.Today.ToShortDateString()

            'hdfidfAggrCase.Value = "0" 'int value to cause an insert as opposed to update Removed Arnold
            hdfidfsAggrCaseType.Value = AggregateValue.Veterinary
            txtstrCaseID.Text = "(new)"  'IS this done somewhere else?? Remove if so Arnold

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub SetupForAddOrUpate()

        Try
            FillCountry()  ' Get country value

            ' Using AdministrativeUnit to populate rayons, regions, settlement set to default country value
            hdfidfsAdministrativeUnit.Value = hdfidfsCountry.Value

            PopulateEditDropDowns()
            SetDefaultsAndLimits()
            ToggleEditAdminDdls(ddlifdsSearchAdministrativeLevel)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub SetNotifyDateMin()

        Try
            txtdatReceivedByDate.MinDate = txtdatSentbyDate.Text

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    'Protected Sub gvVAC_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gvVAC.SelectedIndexChanged

    '    Dim idx As Integer = gvVAC.SelectedIndex
    '    Session("hdfstrCaseID") = gvVAC.DataKeys(idx).Values(0).ToString() 'gives the id of the Veter Agg Case
    '    Session("CallerKey") = gvVAC.DataKeys(idx).Values(1).ToString()   'gives the id of the Human
    '    '       Session("Caller") = CallerPages.VeterinaryAggregateCase
    '    '       Response.Redirect(CallerPages.HumanDiseaseReportURL, True)
    'End Sub

    'Protected Sub gvVAC_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvVAC.PageIndexChanging
    '    gvVAC.PageIndex = e.NewPageIndex
    '    FillAggregateGrid(sGetDataFor:="PAGE", bRefresh:="True")
    'End Sub



    Private Sub FillAggregateGrid(Optional sGetDataFor As String = "GRIDROWS",
                                        Optional bRefresh As Boolean = False)

        Try
            SaveSearchFields()
            FillCountry() ' Get COuntry value store in hdfidfsCountry.Value

            'SaveAdminFromDDL(adminAreaSearch)
            'Get Search value for Region, rayon. Settlement if selected

            Dim ddlList As New List(Of Control)
            Dim oCom As clsCommon = New clsCommon()
            For Each ddl As EIDSSControlLibrary.DropDownList In oCom.FindCtrl(ddlList, lucVeterinaryAggregate, GetType(EIDSSControlLibrary.DropDownList))
                If ddl.SelectedIndex > 0 Then 'check for country code - need check on this value it may change
                    If ddl.SelectedValue.ToString() <> hdfidfsCountry.Value Then
                        hdfidfsAdministrativeUnit.Value = ddl.SelectedValue.ToString()
                    End If
                End If
            Next

            'NullingTextBoxes()
            Dim dsVAggregate As DataSet

            'Save the data set in view state to re-use
            If bRefresh Then ViewState("dsVAggregate") = Nothing

            'If IsNothing(ViewState("dsVAggregate")) Then
            If bRefresh = True Then
                Dim oCommon As New clsCommon()
                Dim oDis As clsAggregate = New clsAggregate()
                Dim oService As NG.EIDSSService = oCommon.GetService()

                Dim aSP As String() = oService.getSPList("AggregateGetList")
                Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, aSP(0), 3, True)
                'searchForm
                strParams &= "|" & oCommon.Gather(searchForm, aSP(0), 3, True)
                ' Need to Display only the newly created Aggregate

                dsVAggregate = oDis.ListAll({strParams})
            Else
                dsVAggregate = CType(ViewState("dsVAggregate"), DataSet)
            End If

            gvVAC.DataSource = Nothing

            Dim resultsHasErrors As Boolean = dsVAggregate.Tables(0).HasErrors  ' Check here if no data is return and no errors Begin, end Search dates

            If dsVAggregate.CheckDataSet() Or Not resultsHasErrors Then
                ViewState("dsVAggregate") = dsVAggregate
                gvVAC.DataSource = dsVAggregate.Tables(0)
                gvVAC.DataBind()
                Dim rowCount As Integer = dsVAggregate.Tables(0).Rows.Count 'Bug 1897 no line describing how many objects/records are retrieved VAUC07 page 12

                searchResultsQty.InnerText = rowCount.ToString()
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub AddOrUpdateAgg()

        'verify that the minimum of time period and admin have been populated
        'confirm with user. if blank, then set defaults per use case

        Dim oCom As clsCommon = New clsCommon()
        Dim oService As NG.EIDSSService = oCom.GetService()
        Dim aSP As String() = Nothing

        Try
            aSP = oService.getSPList("AggregateSave")
            If hdfidfsSite.Value = "NULL" Then
                hdfidfsSite.Value = Session("UserSite")
            End If

            If hdfidfEnteredByPerson.Value = "NULL" Then
                hdfidfEnteredByPerson.Value = Session("Person")
            End If

            ' get a known value for Enteredbyperson
            hdfidfEnteredByPerson.Value = Session("Person")

            'detrmine the idfsPeriodType, strPeriodName Should not need 
            'Dim Now = DateTime.Now
            'Dim first = New DateTime(Now.Year, Now.Month, 1)
            'Dim last = first.AddMonths(1).AddDays(-1)

            'hdfdatStartDate.Value = first.ToString("MM/dd/yyyy")
            'hdfdatFinishDate.Value = last.ToString("MM/dd/yyyy")
            'hdfdatFinishDate.Value = first.ToString("MM/dd/yyyy")

            SaveAdminFromDDL(adminSearch) 'save a single admin area value

            'If organization is set then set idfsAdministrativeUnit value ???

            Dim hidnValues As String = oCom.Gather(divHiddenFieldsSection, aSP(0).ToString(), 3, True)
            Dim dataValues = oCom.Gather(VeterinaryAggregate, aSP(0).ToString(), 3, True)

            If hdfidfAggrCase.Value = "" Then
                hdfidfAggrCase.Value = -1
            End If

            'If hdfidfVersion.Value = "" Then
            '    hdfidfVersion.Value = -1
            'End If

            Dim VetAggValues As String = dataValues + "|" + hidnValues
            Dim oVetAgg As clsAggregate = New clsAggregate
            Dim oReturnValues As Object() = Nothing
            ' If editing then resultCaseID is determined differently
            Dim resultCaseID As String = oVetAgg.AddOrUpdate(VetAggValues)
            'Save results
            hdfstrCaseID.Value = resultCaseID
            lblCASEID.Text = "CASE ID: " & resultCaseID

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Function ValidateForSearch() As Boolean

        Dim blnValidated As Boolean = False
        Dim oCom As clsCommon = New clsCommon()
        'searchForm
        Dim allCtrl As New List(Of Control)

        Try
            allCtrl.Clear()
            For Each txt As WebControls.TextBox In oCom.FindCtrl(allCtrl, searchForm, GetType(WebControls.TextBox))
                If Not blnValidated Then blnValidated = (Not txt.Text.ToString().IsValueNullOrEmpty())
            Next

            If Not blnValidated Then
                allCtrl.Clear()
                For Each ddl As WebControls.DropDownList In oCom.FindCtrl(allCtrl, searchForm, GetType(WebControls.DropDownList))
                    If Not blnValidated Then blnValidated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            'Do have to search because Country, Region, Rayon, etc
            If Not blnValidated Then
                allCtrl.Clear()
                For Each ddl As EIDSSControlLibrary.DropDownList In oCom.FindCtrl(allCtrl, searchForm, GetType(EIDSSControlLibrary.DropDownList))
                    'If ddl.ClientID.Contains("ddllucSearchidfsCountry") = False Then
                    If ddl.ClientID.Contains("ddllucVeterinaryAggregateidfsCountry") = False Then
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
                For Each txt As EIDSSControlLibrary.CalendarInput In oCom.FindCtrl(allCtrl, searchForm, GetType(EIDSSControlLibrary.CalendarInput))
                    If Not blnValidated Then blnValidated = (Not txt.Text.ToString().IsValueNullOrEmpty())
                Next
            End If

            If blnValidated And (txtdatSearchStartDate.Text.Length > 0 Or txtdatSearchEndDate.Text.Length > 0) Then
                blnValidated = oCom.ValidateFromToDates(txtdatSearchStartDate.Text, txtdatSearchEndDate.Text)
                If Not blnValidated Then
                    'show message, search criteria dates are not valid.
                    ' Needs to do a if then else Msg  - VAUC07 Page 7 The system shall provide a warning message to the user: “You did not specify the “End Date”. Do you want to use current date as the End Date?” 

                    ASPNETMsgBox(GetLocalResourceObject("Msg_Dates_Are_Invalid")) ' needs to be converted to javascript
                    txtdatSearchStartDate.Focus()
                End If
            Else
                If Not blnValidated Then
                    ASPNETMsgBox(GetLocalResourceObject("Msg_One_Search_Parameter"))
                    txtstrSearchCaseID.Focus()
                End If
            End If

            searchResults.Visible = blnValidated
            Return blnValidated

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            Return blnValidated
        End Try

    End Function
    Public Function ValidateFromToDatesNotFuture(ByVal sFrom As String, ByVal sTo As String) As Boolean

        'If (sFrom.Length = 0 And sTo.Length > 0) Or (sFrom.Length > 0 And sTo.Length = 0) Then
        Dim startDate = CType(sFrom, DateTime)
        Dim endDate = CType(sTo, DateTime)

        Try
            If startDate > DateTime.Now Or endDate > DateTime.Now Then      'if sFrom <= sTo then return isValid=true
                Return False                                                'if sFrom > sTo then return isValid=false

            Else
                Return True
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            Return False
        End Try

    End Function


    Private Sub PopulateAggregateForEditing()

        'PopulateAggregateForEditing() is only called during gridrow_edit mode (Asim)
        Try
            If Not IsNothing(ViewState("aggCase")) Then
                Dim ds As DataSet = oAgg.SelectOneCase(ViewState("aggCase").ToString())
                'need idfaggrcase value for update, not sure if need idfaggrversion

                If ds.CheckDataSet() Then
                    SetupForAddOrUpate()    'SetupForAddOrUpate function calls FillCountry() - (Asim)

                    Dim oCom As clsCommon = New clsCommon()
                    oCom.Scatter(VeterinaryAggregate, New DataTableReader(ds.Tables(0)))
                    oCom.Scatter(divHiddenFieldsSection, New DataTableReader(ds.Tables(0)))
                    FillCountry()   'FillCountry() being called 2nd time - (Asim)
                    SetLocationByAdminUnit(ds)

                    btnTryDelete.Visible = True
                    btnCancelDelete.Visible = False

                    btnVACCancel.Visible = True
                    'btnNewSearch.Visible = False
                    'ToggleVisibility(CVeterinaryAGGR)
                    search.Visible = False
                    VeterinaryAggregate.Visible = True

                    Dim delCaseID As String = ds.Tables(0).Rows(0)(AggregateValue.StrSearchCaseID).ToString() ' Case ID to be deleted or edited
                    lblCASEIDDel.Text = "Delete CASE ID: " & delCaseID
                    DetermineDateRangeDroDown(ds.Tables(0).Rows(0)("idfsPeriodType").ToString(), ds.Tables(0).Rows(0)("datStartDate").ToString(), ds.Tables(0).Rows(0)("datFinishDate").ToString())

                    If ds.Tables(0).Rows(0)("idfCaseObservation").ToString() = "" Then
                        Saveobservation()
                    Else
                        hdfidfCaseObservation.Value = ds.Tables(0).Rows(0)("idfCaseObservation").ToString()
                        If Not LoadTemplates() Is Nothing Then
                            hdfidfsCaseObservationFormTemplate.Value = LoadTemplates().FirstOrDefault().idfsFormTemplate
                        End If
                    End If

                End If
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub DeleteAgg()

        Try
            If Not IsNothing(ViewState("aggCase")) Then
                oAgg.Delete(Double.Parse(hdfidfAggrCase.Value))

                VeterinaryAggregate.Visible = False

                search.Visible = True
                btnShowSearchCriteria.Visible = True
                showSearchCriteria(False)
                showClearandSearchButtons(False)
                GetSearchFields()
                ClearAdministrativeUnitControl()
                FillAggregateGrid("Page", True) 'When this is set true, page does not display properly
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
        Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub ToggleVisibility(ByVal section As String)

        Try
            searchForm.Visible = section.EqualsAny({CSEARCH})
            searchResults.Visible = section.EqualsAny({CSEARCHRESULTS})
            VeterinaryAggregate.Visible = section.EqualsAny({CVeterinaryAGGR})
            'alwaysShown.Visible = section.EqualsAny({CALWAYSSHOWN})  Create a Review section to display
            'Need to add headings for clarity - see usecase
            'divVetAggReviewContainer.Visible = section.EqualsAny({SectionVetAggReview})
            EnableSearchControls(section.EqualsAny({CSEARCH}))

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
        Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub NullingTextBoxes()

        Try
            If String.IsNullOrEmpty(txtdatSearchEndDate.Text) Then txtdatSearchEndDate.Text = "null"
            If String.IsNullOrEmpty(txtdatSearchStartDate.Text) Then txtdatSearchStartDate.Text = "null"
            If String.IsNullOrEmpty(txtstrSearchCaseID.Text) Then txtstrSearchCaseID.Text = "null"

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub EnableSearchControls(ByVal enabled As Boolean)

        Try
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
                    Dim ddlRegion As DropDownList = lc.FindControl("ddllucVeterinaryAggregateidfsRegion")
                    If Not IsNothing(ddlRegion) Then
                        ddlRegion.Enabled = enabled
                    End If
                    '2nd location control in edit page
                    Dim ddlRegionEdit As DropDownList = lc.FindControl("ddllsearchFormidfsRegion")
                    If Not IsNothing(ddlRegion) Then
                        ddlRegionEdit.Enabled = enabled
                    End If

                    'Dim ddlRayon As DropDownList = lc.FindControl("ddlRayon")
                    Dim ddlRayon As DropDownList = lc.FindControl("ddllucVeterinaryAggregateidfsRayon")
                    If Not IsNothing(ddlRayon) Then
                        ddlRayon.Enabled = enabled
                    End If
                    '2nd location control in edit page
                    Dim ddlRayonEdit As DropDownList = lc.FindControl("ddllsearchFormidfsRayon")
                    If Not IsNothing(ddlRegion) Then
                        ddlRayonEdit.Enabled = enabled
                    End If

                    'Dim townorsettlement As DropDownList = lc.FindControl("ddlRayon")
                    Dim ddlSettlement As DropDownList = lc.FindControl("ddllucVeterinaryAggregateidfsSettlement")
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

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
        Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub EnableControls(ByRef divTag As HtmlGenericControl, ByVal enabled As Boolean)

        Try
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

                'Enable or Disable Location Control

                'Dim ddlList As New List(Of Control)
                'Dim oCom As clsCommon = New clsCommon()
                'For Each ddl As EIDSSControlLibrary.DropDownList In oCom.FindCtrl(ddlList, adminSearch, GetType(EIDSSControlLibrary.DropDownList))
                '    If ddl.SelectedIndex > 0 Then
                '        ddl.Enabled = enabled
                '    End If
                'Next

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

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
        Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub EnableLocationControls(ByRef divTagID As HtmlGenericControl, ByVal enabled As Boolean)

        'Enable or Disable Location Control
        Dim ddlList As New List(Of Control)
        Dim oCom As clsCommon = New clsCommon()

        Try
            For Each ddl As EIDSSControlLibrary.DropDownList In oCom.FindCtrl(ddlList, divTagID, GetType(EIDSSControlLibrary.DropDownList))
                If ddl.SelectedIndex > 0 Then
                    ddl.Enabled = enabled
                End If
            Next

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub



    Private Sub ClearControl(ByRef sectionName As Web.UI.Control)

        Dim oCom As clsCommon = New clsCommon()
        Try
            oCom.ResetForm(sectionName)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub ClearAdministrativeUnitControl()

        Try
            'Clears region, rayon, settlement

            'Dim lc As LocationUserControl

            hdfidfsAdministrativeUnit.Value = "NULL"  'null administrative values 

            'Dim ddlRegion As DropDownList = lc.FindControl("ddllucVeterinaryAggregateidfsRegion")
            'If Not IsNothing(ddlRegion) Then
            '    ddlRegion.Enabled = True
            '    ddlRegion.Items.Clear()
            'End If

            'Dim ddlRayon As DropDownList = lc.FindControl("ddllucVeterinaryAggregateidfsRayon")
            'If Not IsNothing(ddlRayon) Then
            '    ddlRayon.Enabled = False
            '    ddlRayon.Items.Clear()
            'End If

            'Dim ddlSettlement As DropDownList = lc.FindControl("ddllucVeterinaryAggregateidfsSettlement")
            'If Not IsNothing(ddlSettlement) Then
            '    ddlSettlement.Enabled = False
            '    ddlSettlement.Items.Clear()
            'End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub



#End Region
#Region "Period Setups"
    Private Sub FillUpToCurrentYear()

        Try
            'Range of years to be 1900 to current year, descending
            For y = DateTime.Today.Year To 1900 Step -1
                Dim li As ListItem = New ListItem(y.ToString(), y.ToString())
                ddlintYear.Items.Add(li)
            Next

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub ResetQuarters()

        Try
            If ddlintQuarter.Visible Then
                ddlintQuarter.DataSource = oAgg.FillQuarterList(CType(ddlintYear.SelectedValue, Integer))
                oAgg.FillPeriod(ddlintQuarter, True)
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub ResetMonths()

        Try
            If ddlintMonth.Visible Then
                ddlintMonth.DataSource = oAgg.FillMonthList(CType(ddlintYear.SelectedValue, Integer))

                If Not IsValueNullOrEmpty(Session("PageMode")) And Session("PageMode") = "VetAggEdit" Then
                    'if VetAggReport is in Edit Mode, then ddlMonth should not have a blank value (blank value throws an error)
                    oAgg.FillPeriod(ddlintMonth, False)
                Else
                    oAgg.FillPeriod(ddlintMonth, True)
                End If
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub ResetWeeks()

        Try
            If ddlintWeek.Visible Then
                ddlintWeek.DataSource = oAgg.FillWeekList(CType(ddlintYear.SelectedValue, Integer))
                oAgg.FillPeriod(ddlintWeek, True)
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub ToggleSearchAdminDdls(ddl As DropDownList)

        Dim indx As String = ddl.SelectedIndex.ToString()
        Dim ddlAdminValue As String = ddl.SelectedValue.ToString()

        Try
            'searchOrg.Visible = indx.EqualsAny({"5", "4"})

            'lucVeterinaryAggregate.ShowTownOrVillage = indx.EqualsAny({"5", "4", "3"})
            'lucVeterinaryAggregate.ShowRayon = indx.EqualsAny({"4", "3", "2"})
            'lucVeterinaryAggregate.ShowRegion = indx.EqualsAny({"4", "3", "2", "1"})

            If (lucVeterinaryAggregate.ShowRegion = indx.EqualsAny({"3"})) Then
                lucVeterinaryAggregate.ShowRayon = True
                lucVeterinaryAggregate.ShowTownOrVillage = True
                searchOrg.Visible = True
            ElseIf (lucVeterinaryAggregate.ShowRayon = indx.EqualsAny({"2"})) Then
                lucVeterinaryAggregate.ShowTownOrVillage = True
                searchOrg.Visible = True

            ElseIf (lucVeterinaryAggregate.ShowRayon = indx.EqualsAny({"1"})) Then
                lucVeterinaryAggregate.ShowTownOrVillage = True 'Organization
                searchOrg.Visible = True

            ElseIf (lucVeterinaryAggregate.ShowTownOrVillage = indx.EqualsAny({"5", "4"})) Then
                lucVeterinaryAggregate.ShowRayon = True
                lucVeterinaryAggregate.ShowRegion = True 'need to also disable
                lucVeterinaryAggregate.ShowTownOrVillage = True
                searchOrg.Visible = True
            End If

            If ddlAdminValue = 10003001 Then 'Country
                'VAUC07 => If “Country” value is selected, the system shall disable “Rayon”, “Settlement”, and “Organization” fields.
                ddlidfsOrganzation.Enabled = False

            ElseIf ddlAdminValue = 10003003 Then 'Region
                'VAUC07 => If “Region” value is selected, the system shall disable “Rayon”, “Settlement”, and “Organization” fields.
                ddlidfsOrganzation.Enabled = False

            ElseIf ddlAdminValue = 10003002 Then 'Rayon
                'VAUC07 => If “Rayon” (default) value is selected, the system shall disable “Settlement” and “Organization” field.
                ddlidfsOrganzation.Enabled = False

            ElseIf ddlAdminValue = 10003005 Then 'Settlement
                'VAUC07 => If “Settlement” value is selected, fields “Region”, “Rayon”, and “Settlement” are enabled, and “Organization” field shall be disabled. 
                ddlidfsOrganzation.Enabled = False

            ElseIf ddlAdminValue = 10003006 Then 'Organization
                'VAUC07 => If “Organization” value is selected, all fields “Region”, “Rayon”, “Settlement”, and “Organization” are enabled.
                ddlidfsOrganzation.Enabled = True

            ElseIf ddlAdminValue = 10003004 Then 'Town
            End If
            lucVeterinaryAggregate.ToggleLUC(ddlAdminValue)

            adminAreaSearch.FindControl(lucVeterinaryAggregate.SelectedRayonText)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub ToggleEditAdminDdls(ddl As DropDownList)

        Dim indx As String = ddl.SelectedIndex.ToString()

        'lucVeterinaryAggregate.ShowTownOrVillage = indx.EqualsAny({"4", "3"})
        'lucVeterinaryAggregate.ShowRayon = indx.EqualsAny({"4", "3", "2"})
        'lucVeterinaryAggregate.ShowRegion = indx.EqualsAny({"4", "3", "2", "1"})

        'lucSearch.ShowTownOrVillage = indx.EqualsAny({"4", "3"})
        'lucSearch.ShowRayon = indx.EqualsAny({"4", "3", "2"})
        'lucSearch.ShowRegion = indx.EqualsAny({"4", "3", "2", "1"})

        Try
            'Get SessionValue;
            If Not IsValueNullOrEmpty(Session("PageMode")) And Session("PageMode") = "VetAggAdd" Then
                LoadAggregateSettings()
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub


    Private Sub ToggleEditTimeDdls(d As DropDownList)

        'based on index of the time period dropdown, set the visibility of the time range dropdowns
        Dim indx As String = d.SelectedIndex.ToString()

        Try
            'Asim ToDo ==> review & optimize
            'Asim ToDo ==> read StaticalPeriod value here;
            quarter.Visible = indx.Equals("1")
            month.Visible = indx.Equals("2")
            week.Visible = indx.Equals("3")
            singleDay.Visible = indx.Equals("4")

            quarter.Visible = False
            month.Visible = False
            week.Visible = False
            singleDay.Visible = False
            'year.Visible = False

            'Public Structure StatisticPeriodType
            '    Public Const Month = "10091001"
            '    Public Const Day = "10091002"
            '    Public Const Quarter = "10091003"
            '    Public Const Week = "10091004"
            '    Public Const Year = "10091005"
            'End Structure

            Select Case AggregateSettingsConfig.StatisticalPeriodType
                'Case "10091005" '"Year"
                 '   year.Visible = True (Year is alwys visible)
                Case "10091003" '"Quarter"
                    quarter.Visible = True
                Case "10091001" '"Month"
                    month.Visible = True
                Case "10091004" '"Week"
                    week.Visible = True
                Case "10091002" '"Day"
                    singleDay.Visible = True
            End Select

            ResetTimes()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub ResetTimes()

        Try
            'based on new value of year, adjust the more granular time frames
            ResetQuarters()
            ResetMonths()
            ResetWeeks()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub FindSettingDetail()
        'To be used once we get data from c6.1 of configured settings
        Dim ds As DataSet = oAgg.GetSettingMins()

        Try
            If ds.CheckDataSet() Then
                'These values are not being utilized anywhere;
                Dim areaType = ds.Tables(0).Rows(0)(StatisticTypes.StatAreaType)
                Dim timeType = ds.Tables(0).Rows(0)(StatisticTypes.StatPeriodType)
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

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

                    'Case "ddlintQuarter", "ddlintWeek"
                Case "ddlintQuarter"
                    Dim dRange As String() = (ddl.SelectedItem.ToString()).Split("-")

                    'ToDo : Optimize - Asim
                    'Per requirements of VAUC05, the Quarter dropdown contents includes Quarter # + DateRange - Asim 
                    If ddl.ID.ToString() = "ddlintQuarter" And dRange.Length = 3 Then
                        FillHiddenDates(dRange(1).Trim(), dRange(2).Trim())
                    Else
                        FillHiddenDates(dRange(0).Trim(), dRange(1).Trim())
                    End If

                Case "ddlintWeek"

                    'If Session("PageMode") = "VetAggAdd" Then


                    'Per VAUC05, week dropdown contents should be week #, not an actual date; - Asim
                    Dim dt As DataTable
                    dt = oAgg.FillWeekList(CType(ddlintYear.SelectedValue, Integer))
                    Dim result() As DataRow = dt.Select("PeriodNumber = " & ddlintWeek.SelectedItem.ToString())

                    If Not IsNothing(result(0)) Then
                        sDate = result(0).ItemArray(1)
                        eDate = result(0).ItemArray(2)
                        Dim sPeriodName = result(0).ItemArray(3).ToString()
                        FillHiddenDates(sDate.ToShortDateString(), eDate.ToShortDateString())
                    End If

                    'Else
                    'sDate = New DateTime(Now.Year, Now.Month, 1)
                    'eDate = sDate.AddMonths(1).AddDays(-25)
                    'FillHiddenDates(sDate.ToShortDateString(), eDate.ToShortDateString())
                    'End If

                Case "ddlintDay" ' needs some work AK

                    'Dim Now = DateTime.Now
                    'Dim first = New DateTime(Now.Year, Now.Month, 1)
                    'Dim last = first.AddMonths(1).AddDays(-1)

                    sDate = New DateTime(Now.Year, Now.Month, 1)
                    eDate = sDate.AddMonths(1).AddDays(-1)
                    FillHiddenDates(sDate.ToShortDateString(), sDate.ToShortDateString())
            End Select

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Protected Sub SaveTimeIntervalRangeFromDDL(sender As Object, e As EventArgs)

        Dim ddl As DropDownList = CType(sender, DropDownList)
        Dim sDate As DateTime = Nothing
        Dim eDate As DateTime = Nothing

        'detrmine the idfsPeriodType, strPeriodName Should not need 
        'Dim Now = DateTime.Now
        'Dim first = New DateTime(Now.Year, Now.Month, 1)
        'Dim last = first.AddMonths(1).AddDays(-1)

        'hdfdatStartDate.Value = first.ToString("MM/dd/yyyy")
        'hdfdatFinishDate.Value = last.ToString("MM/dd/yyyy")
        'hdfdatFinishDate.Value = first.ToString("MM/dd/yyyy")

        Try
            Dim casevar As String = ddl.ID.ToString()
            Dim ddlValue As String = ddl.SelectedItem.ToString()

            Select Case ddlValue
                Case "Year"
                    sDate = New DateTime(ToInt16(ddlintYear.SelectedItem.ToString()), 1, 1)
                    eDate = sDate.AddYears(1).AddDays(-1)
                    FillHiddenDates(sDate.ToShortDateString(), eDate.ToShortDateString())
                Case "Month"
                    sDate = New DateTime(ToInt16(ddlintYear.SelectedItem.ToString()), ddl.SelectedIndex, 1)
                    eDate = sDate.AddMonths(1).AddDays(-1)
                    FillHiddenDates(sDate.ToShortDateString(), eDate.ToShortDateString())
                Case "Quarter"
                    Dim dRange As String() = (ddl.SelectedItem.ToString()).Split("-")
                    FillHiddenDates(dRange(0).Trim(), dRange(1).Trim())
                Case "Week" 'needs some work AK


                    sDate = New DateTime(Now.Year, Now.Month, 1)
                    eDate = sDate.AddMonths(1).AddDays(-25)
                    FillHiddenDates(sDate.ToShortDateString(), eDate.ToShortDateString())
                Case "Day" ' needs some work AK

                    'Dim Now = DateTime.Now
                    'Dim first = New DateTime(Now.Year, Now.Month, 1)
                    'Dim last = first.AddMonths(1).AddDays(-1)

                    sDate = New DateTime(Now.Year, Now.Month, 1)
                    eDate = sDate.AddMonths(1).AddDays(-1)
                    FillHiddenDates(sDate.ToShortDateString(), sDate.ToShortDateString())
            End Select
            resetSearch()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub


    Protected Sub SaveDateRange(sender As Object, e As EventArgs)

        Dim spaceInd As Integer = 0
        Dim datDate As String

        Try
            If txtdatDate.Text.Contains(" ") Then spaceInd = txtdatDate.Text.IndexOf(" ")

            'hdfdatStartDate.Value = first.ToString("MM/dd/yyyy")
            'hdfdatFinishDate.Value = last.ToString("MM/dd/yyyy")
            'hdfdatFinishDate.Value = first.ToString("MM/dd/yyyy")

            FillHiddenDates(txtdatDate.Text.Substring(0, spaceInd), txtdatDate.Text.Substring(0, spaceInd))
            datDate = txtdatDate.Text
            '            FillHiddenDates(txtdatDate.ToString, txtdatDate.ToString) 'dOES nOT WORK  
            FillHiddenDates(datDate, datDate)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub FillHiddenDates(start As String, endD As String)

        Try
            'populate hidden fields 
            hdfdatStartDate.Value = start
            hdfdatFinishDate.Value = endD

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub DetermineDateRangeDroDown(period As String, sDate As String, eDate As String)

        'DetermineDateRangeDroDown() is only called during gridrow_edit mode (Asim)
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
            '    'Case diff < 1
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

            'ddlintYear.SelectedValue in ResetMonths() returns only January to current month (April) of current year (2019) 
            'However, when performing "search", if a record has a month of October, an exception 
            'is thrown because "10" month does not exisit in the ddlMonth; - Asim (2019-04-16 - Begin)

            If ddlintMonth.Visible And (stDate.Year.ToString() = DateTime.Today.Year.ToString()) Then
                ddlintMonth.SelectedIndex = stDate.Month
            ElseIf ddlintMonth.Visible And (stDate.Year.ToString() <> DateTime.Today.Year.ToString()) Then
                'Add months to ddlintMonth based on ddlintYear;
                ResetMonths()
                ddlintMonth.SelectedIndex = stDate.Month
            End If
            'Asim (End)

            If ddlintQuarter.Visible Then ddlintQuarter.SelectedValue = oAgg.GetQuarterValue(stDate.Year, stDate.Month)
            If ddlintWeek.Visible Then ddlintWeek.SelectedValue = oAgg.GetWeekValue(stDate)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
#End Region
#Region "AdminArea"
    Private Sub FillCountry()

        Try
            'Set default country name and save country ID in hidden field
            txtstrCountry.Text = getConfigValue("DefaultCountry").ToString()
            Dim oC As clsCountry = New clsCountry()
            Dim dsCountry = oC.SelectOne(0)

            If dsCountry.CheckDataSet() Then
                hdfidfsCountry.Value = dsCountry.Tables(0).Rows(0)(CountryConstants.CountryID).ToString()
                Session("CountryID") = hdfidfsCountry.Value
                Session("Country") = txtstrCountry.Text
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub SaveAdminFromDDL(ByRef divTag As HtmlGenericControl)

        Dim ddlList As New List(Of Control)
        Dim oCom As clsCommon = New clsCommon()

        Try
            For Each ddl As EIDSSControlLibrary.DropDownList In oCom.FindCtrl(ddlList, divTag, GetType(EIDSSControlLibrary.DropDownList))
                If ddl.SelectedIndex > 0 Then
                    hdfidfsAdministrativeUnit.Value = ddl.SelectedValue.ToString()

                    'Need to save  //*[@id="EIDSSBodyCPH_lucSearch_ddllucSearchidfsRegion"] or/and #EIDSSBodyCPH_lucSearch_ddllucSearchidfsRayon or/and #EIDSSBodyCPH_lucSearch_ddllucSearchidfsSettlement
                End If
            Next

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    'Private Sub SaveAdminFromDDL()

    '    Dim ddlList As New List(Of Control)
    '    Dim oCom As clsCommon = New clsCommon()
    '    For Each ddl As EIDSSControlLibrary.DropDownList In oCom.FindCtrl(ddlList, adminSearch, GetType(EIDSSControlLibrary.DropDownList))
    '        If ddl.SelectedIndex > 0 Then
    '            hdfidfsAdministrativeUnit.Value = ddl.SelectedValue.ToString()
    '        End If
    '    Next

    'End Sub



    Private Sub SetLocationByAdminUnit(ByRef ds As DataSet)

        Try
            'lucVeterinaryAggregate.LocationData = ds.Tables(0)
            'lucVeterinaryAggregate.DataBind()
            If ds.Tables(0).Rows(0)(CountryConstants.CountryID).ToString = "" Then
                lucSearch.LocationCountryID = Nothing
            Else
                lucSearch.LocationCountryID = CType(ds.Tables(0).Rows(0)(CountryConstants.CountryID), Long)
            End If

            If ds.Tables(0).Rows(0)(RegionConstants.RegionID).ToString = "" Then
                lucSearch.LocationRegionID = Nothing
            Else
                lucSearch.LocationRegionID = CType(ds.Tables(0).Rows(0)(RegionConstants.RegionID), Long)
            End If

            If ds.Tables(0).Rows(0)(RayonConstants.RayonID).ToString = "" Then
                lucSearch.LocationRayonID = Nothing
            Else
                lucSearch.LocationRayonID = CType(ds.Tables(0).Rows(0)(RayonConstants.RayonID), Long)
            End If

            If ds.Tables(0).Rows(0)(SettlementConstants.idfsSettlement).ToString = "" Then
                lucSearch.LocationSettlementID = Nothing
            Else
                lucSearch.LocationSettlementID = CType(ds.Tables(0).Rows(0)(SettlementConstants.idfsSettlement), Long)
            End If
            lucSearch.DataBind()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
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

        Try
            If ds.CheckDataSet() Then
                If ds.Tables(0).Rows.Count > 0 Then
                    OfficeNameFromID = ds.Tables(0).Rows(0)(OrganizationConstants.OrgName).ToString()
                End If
            End If

            Return OfficeNameFromID

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            Return OfficeNameFromID
        End Try

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
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub ResetEmployee(officer As DropDownList, inst As DropDownList)

        Try
            'filtering the list of officers based on institute
            FillDropDown(officer, GetType(clsOrgPerson), {inst.SelectedValue}, PersonConstants.idfPerson, OrganizationConstants.OrgFullName, Nothing, Nothing, True)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
#End Region
#Region "Search Criteria"
    Private Sub SaveSearchFields()

        Dim oCom As New clsCommon

        Try
            oCom.SaveSearchFields({searchForm}, SEARCH_SP, oCom.CreateTempFile(SEARCH_FILE_PREFIX))

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub GetSearchFields()

        Dim oCom As clsCommon = New clsCommon()

        Try
            oCom.GetSearchFields({searchForm}, oCom.CreateTempFile(SEARCH_FILE_PREFIX))

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub ClearSearch()

        Dim oCom As New clsCommon()

        Try
            oCom.DeleteTempFiles(GetSFileName())
            oCom.ResetForm(searchForm)
            'Reset Location Control

            oCom.ResetForm(lucVeterinaryAggregate)

            btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
            btnShowSearchCriteria.Visible = False
            searchResults.Visible = False
            'btnPrint.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none") REM Issue 2498

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub showSearchCriteria(ByVal show As Boolean)
        Try
            If show Then
                searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
                btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")
            Else
                searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
                btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub resetSearch()
        Try
            searchResults.Visible = False
            searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
            btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
            btnShowSearchCriteria.Visible = False

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub showClearandSearchButtons(ByVal show As Boolean)

        Try
            btnSearch.Attributes.CssStyle.Remove(HtmlTextWriterStyle.Display)
            btnClear.Attributes.CssStyle.Remove(HtmlTextWriterStyle.Display)

            'btnPrint.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline") REM Issue 2498

            If show Then
                btnSearch.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
                btnClear.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "inline")
            Else
                btnSearch.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
                btnClear.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region
#Region "Sorting"
    Private Sub Sorting(e As GridViewSortEventArgs)

        Dim oDS As DataSet = ViewState("AggregateList")
        Dim dt As DataTable = oDS.Tables(0)

        Try
            If Not IsNothing(dt) Then
                dt.DefaultView.Sort = e.SortExpression + " " + GetSortDirection(e.SortExpression)
                gvVAC.DataSource = CType(ViewState("AggregateList"), DataSet)
                gvVAC.DataBind()
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Function GetSortDirection(ByVal column As String) As String

        Dim sortDirection = "ASC"

        ' Retrieve the last column that was sorted.
        Dim sortExpression = TryCast(ViewState("SortExpression"), String)

        Try
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
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            Return sortDirection

        End Try

    End Function
    Protected Sub gvVAC_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvVAC.PageIndexChanging

        Try
            gvVAC.PageIndex = e.NewPageIndex
            'FillAggregateGrid(sGetDataFor:="PAGE", bRefresh:="True")
            FillAggregateGrid(sGetDataFor:="PAGE")

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub FillVetAggReview()

        Try
            Dim oVetAgg As New clsAggregate
            ' Not implemented Arnold
            Dim dsVetAgg As DataSet = oVetAgg.SelectOne(hdfstrCaseID.Value)

            '           If dsVetAgg.CheckDataSet() Then
            '    Dim oCommon As New clsCommon

            ToggleVisibility(CSEARCHRESULTS)

        Catch ae As ArgumentOutOfRangeException

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub PreFillLocation()

        Try


        Catch ae As ArgumentOutOfRangeException

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region
#Region "Events"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub btnReturnToVetAggRecord_Click(sender As Object, e As EventArgs)

        Try
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & divSuccessModalContainer.ClientID & "').modal('hide');});", True)
            showClearandSearchButtons(True)
            btnCancelDelete.Visible = False
            '        FillVetAggReview()
            GetSearchFields() ' Next search Maybe better than Populate from the beginning
            '       PopulateSearchDropDowns()
            txtstrSearchCaseID.Text = hdfstrCaseID.Value

            FillVetAggReview()

            ToggleVisibility(CSEARCHRESULTS)

            'ToggleVisibility(SectionVetAggReview) 'Need to implement Arnold

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnDelAgg_Click(sender As Object, e As EventArgs) Handles delYes.ServerClick

        Try
            DeleteAgg()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Protected Sub btnClear_Click(sender As Object, e As EventArgs)

        Try
            ClearSearch()
            InitializeSearchFields()
            resetSearch()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
        Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Protected Sub btnSearch_Click(sender As Object, e As EventArgs)

        Try
            If (txtdatSearchStartDate.Text.Length > 0 Or txtdatSearchEndDate.Text.Length > 0) Then
                Dim blnValidated As Boolean = False
                Dim oCom As clsCommon = New clsCommon()
                If oCom.ValidateFromToDates(txtdatSearchStartDate.Text, txtdatSearchEndDate.Text) Then
                    Dim sd As DateTime
                    Dim ed As DateTime

                    sd = CType(txtdatSearchStartDate.Text, DateTime)

                    'If user has not entered an EndDate, set ed to Today, to avoid exception;
                    If txtdatSearchEndDate.Text.Length = 0 Then
                        ed = CType(DateTime.Today, DateTime)
                    Else
                        ed = CType(txtdatSearchEndDate.Text, DateTime)
                    End If

                    If sd > DateTime.Today Or ed > DateTime.Today Then
                        ASPNETMsgBox(GetLocalResourceObject("Msg_Dates_Are_Invalid_Future")) ' needs to be converted to javascript
                        txtdatSearchStartDate.Focus()
                        Return
                    End If
                Else
                    ASPNETMsgBox(GetLocalResourceObject("Msg_Dates_Are_Invalid")) ' needs to be converted to javascript
                    txtdatSearchStartDate.Focus()
                    Return
                End If
            End If

            'If ValidateForSearch() Then
            'Need back button functiona;ity for now we will swap buttons
            btnCancelAgg.Visible = False
            btnCancelSearch.Visible = True

            'Display btnPrint for Search Results - Bug 3858 (Asim)
            btnPrint.Visible = True

            FillAggregateGrid(bRefresh:=True)
            btnShowSearchCriteria.Visible = True
            showSearchCriteria(False)
            searchResults.Visible = True
            showClearandSearchButtons(False)
            'End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub


    Protected Sub btnNo_Click(sender As Object, e As EventArgs)
        ViewState("EmptyObject").Focus()
    End Sub
    Protected Sub btnYes_Click(sender As Object, e As EventArgs)
        txtdatSearchStartDate.Text = DateTime.Today.AddYears(-1)
    End Sub

    Protected Sub btnReturnToVetAggSearchResult_Click(sender As Object, e As EventArgs) Handles btnReturnToVetAggSearchResult.ServerClick

        Try
            'Replace the search - Should return to Calling page - but for now return to Search form
            btnCancelAgg.Visible = False
            btnCancelSearch.Visible = True

            VeterinaryAggregate.Visible = False
            EnableControls(search, True)
            EnableControls(VeterinaryAggregate, True)

            search.Visible = True
            'ToggleVisibility(CSEARCH) Does not toggle

            btnShowSearchCriteria.Visible = True
            showSearchCriteria(True)
            showClearandSearchButtons(True)

            'txtSearchStartDateTo.Text = hdftxtSearchStartDateTo.Value

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub


    Protected Sub btnReturnToVetAgg_Click(sender As Object, e As EventArgs) Handles btnReturnToVetAgg.ServerClick

        Try
            btnCancelAgg.Visible = True
            btnCancelSearch.Visible = False

            ToggleVisibility(CSEARCH)
            showClearandSearchButtons(True)

            btnShowSearchCriteria.Visible = True
            showSearchCriteria(True)
            'Clear Search Data to start new search Need to Check USeCase for details directions
            ClearSearch()
            InitializeSearchFields()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
        Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnNewSearch_Click(sender As Object, e As EventArgs)

        Try
            hdfidfsAdministrativeUnit.Value = "NULL"  'null administrative values rmove to initializesearch
            VeterinaryAggregate.Visible = False
            InitializeSearchFields()
            search.Visible = True

            'ToggleVisibility(CSEARCH)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnNewVAC_Click(sender As Object, e As EventArgs)

        Try
            Session("PageMode") = "VetAggAdd"

            VeterinaryAggregate.Visible = True
            search.Visible = False
            gvDiagnosis.DataSource = New List(Of Object)
            gvDiagnosis.DataBind()
            ClearControl(VeterinaryAggregate)

            txtdatEnteredByDate.Enabled = False

            txtstrEnteredByOffice.Enabled = False
            txtstrEnteredByPerson.Enabled = False
            btnTryDelete.Visible = False
            btnCancelDelete.Visible = False

            btnVACCancel.Visible = False
            btnNotSubmit.Visible = True

            '1909 Fix
            txtdatEnteredByDate.Text = String.Empty
            txtdatEnteredByDate.Text = DateTime.Today

            'Values in FindSettingDetail are not being utilized anywhere;
            FindSettingDetail()

            SetupForAddOrUpate()
            'lucSearch.AggregateSettingsConfig = AggregateSettingsConfig.StatisticalAreaType

            'Bug # 1909 pre-populated fields Region and Rayon (Begin)
            If IsValueNullOrEmpty(Session("LocationCountryID")) = False Then
                lucSearch.LocationCountryID = Session("LocationCountryID")
                lucSearch.LocationRegionID = Session("LocationRegionID")
                lucSearch.LocationRayonID = Session("LocationRayonID")
                'lucSearch.LocationSettlementID = Session("LocationRayonID")
                lucSearch.DataBind()

                'if Region is pre-populated with a value, then ddlOrganization is enabled;
                ddlidfsOrganzation.Enabled = True
                lucSearch.DisplayPrePopulatedRegionRayon = False
            End If
            'Bug # 1909 pre-populated fields Region and Rayon (End)

            If Not LoadTemplates() Is Nothing Then
                Saveobservation()
                LoadFlexFormMatrix(LoadTemplates().FirstOrDefault.idfsFormTemplate)
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Protected Sub ddlintYear_SelectedIndexChanged(sender As Object, e As EventArgs)
        Try
            ResetTimes()
            SaveDateRangeFromDDL(sender, e)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Protected Sub ddlifdsSearchAdministrativeLevel_SelectedIndexChanged(sender As Object, e As EventArgs)
        Try
            ToggleSearchAdminDdls(sender)
            resetSearch()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Protected Sub btnCancel_Click(sender As Object, e As EventArgs)

        Try
            If VeterinaryAggregate.Visible = True Then
                Response.Redirect("~/Dashboard.aspx")
            Else
                search.Visible = True
                VeterinaryAggregate.Visible = False
                showSearchCriteria(False)
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnVACCancel_Click(sender As Object, e As EventArgs)

        Try
            search.Visible = True
            VeterinaryAggregate.Visible = False
            showSearchCriteria(False)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Protected Sub btnCancelDelete_Click(sender As Object, e As EventArgs)
        VeterinaryAggregate.Visible = False
        search.Visible = True
    End Sub
    Protected Sub btnNext_Click(sender As Object, e As EventArgs)

        Try
            'Need to Add a Validate Datefields to 
            'verify Notification Date Sent Is later than Date Received 

            If (txtdatReceivedByDate.Text.Length > 0 Or txtdatSentbyDate.Text.Length > 0) Then
                Dim blnValidated As Boolean = False
                Dim oCom As clsCommon = New clsCommon()

                'If oCom.ValidateFromToDates(txtdatReceivedByDate.Text, txtdatSentbyDate.Text) Then
                '--------------------------ByVal sFrom As String, ByVal sTo As String

                'Function ValidateFromToDates sets ReceivedByDate as From & SentbyDate as To (which is incorrect)
                'Bug 3829
                If oCom.ValidateFromToDates(txtdatSentbyDate.Text, txtdatReceivedByDate.Text) Then
                    'Dim sd As DateTime
                    'Dim ed As DateTime
                    Dim sentDate As DateTime
                    Dim rcvdDate As DateTime

                    sentDate = CType(txtdatSentbyDate.Text, DateTime)

                    'If user has not entered an EndDate, set ed to Today, to avoid exception;
                    If txtdatReceivedByDate.Text.Length = 0 Then
                        rcvdDate = CType(DateTime.Today, DateTime)
                    Else
                        rcvdDate = CType(txtdatReceivedByDate.Text, DateTime)
                    End If

                    If sentDate > DateTime.Today Or rcvdDate > DateTime.Today Then
                        ASPNETMsgBox(GetLocalResourceObject("Msg_Dates_Are_Invalid_Future"))
                        txtdatSentbyDate.Focus()
                        Return
                    End If
                Else
                    ASPNETMsgBox(GetLocalResourceObject("Msg_Dates_Are_Invalid_Future"))
                    txtdatSentbyDate.Focus()
                    Return
                End If
            End If

            EnableControls(alwaysShown, False)  ' These controls are no longer available so should not need
            EnableControls(veterinaryAggregate, False)
            EnableLocationControls(adminSearch, False)
            btnNext.Visible = False
            'btnPrint.Visible = False REM Issue 2498
            btnPrintNewAgg.Visible = False
            btnVACCancel.Visible = False
            btnNotSubmit.Visible = True  'Added due to edit
            btnSubmit.Visible = True

            SaveActualData()
            HttpContext.Current.Session("loadMatxrixTable") = Nothing

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)

        Try
            btnNotSubmit.Visible = False
            btnPrintNewAgg.Visible = False     ' May not be needed here need to verify
            btnTryDelete.Visible = False
            btnVACCancel.Visible = False 'Should be able to cancel if they want to submit another edit

            EnableControls(searchForm, True)  ' added since controls no longer exist in always shown
            EnableControls(veterinaryAggregate, True)
            EnableLocationControls(adminSearch, True)

            AddOrUpdateAgg()
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & divSuccessModalContainer.ClientID & "').modal('show');});", True)

            btnSubmit.Visible = False
            btnNewVAC.Visible = True
            btnSearch.Visible = True

            veterinaryAggregate.Visible = False
            veterinaryAggregate.Visible = True  ' Add this during debugging

            'editSearch.Visible = False
            searchResults.Visible = True

            'txtdatEnteredByDate.Enabled = False
            'txtstrEnteredByOffice.Enabled = False
            'txtstrEnteredByPerson.Enabled = False
            'txtdatEnteredByDate.Text = String.Empty

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try


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
    Protected Sub gvVAC_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvVAC.Sorting
        SortGrid(e, CType(sender, GridView), "dsVAggregate")
    End Sub
    Private Sub SortGrid(ByVal e As GridViewSortEventArgs, ByRef gv As GridView, ByVal vsDS As String)

        Try
            Dim sortedView As DataView = New DataView(CType(ViewState(vsDS), DataSet).Tables(0))
            Dim sortDir As String = SetSortDirection(e)

            Try
                sortedView.Sort = e.SortExpression + " " + sortDir
            Catch ex As IndexOutOfRangeException
            End Try

            gv.DataSource = sortedView
            gv.DataBind()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Function SetSortDirection(ByVal e As GridViewSortEventArgs) As String

        Dim dir As String = String.Empty
        Dim lastCol As String = String.Empty

        Try
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

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            Return dir
        End Try

    End Function

    Private Function GetSFileName() As String

        'Try
        Return Server.MapPath("\") & "App_Data\" & Session("UserID").ToString() & "_PS.xml"

        'Catch ex As Exception
        '    Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
        '    Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        'End Try

    End Function
    Private Sub gvVAC_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvVAC.RowEditing

        Try
            Session("PageMode") = "VetAggEdit"
            e.Cancel = True
            PopulateAggregateForEditing()

            Dim templates = LoadTemplates()
            If Not templates Is Nothing Then
                LoadFlexFormMatrix(templates.FirstOrDefault.idfsFormTemplate)
                LoadActualData()
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub gvVAC_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvVAC.RowCommand

        Try
            If e.CommandName.ToUpper().EqualsAny("SELECT,EDIT".Split(",")) Then
                If IsNumeric(e.CommandArgument) Then 'if user clicked "edit" icon
                    Dim idx As Integer = Convert.ToInt32(e.CommandArgument)
                    Dim row As GridViewRow = gvVAC.Rows(idx)
                    ViewState("aggCase") = gvVAC.DataKeys(idx).Values("strCaseID")
                Else  'else user clicked "CaseID" hyperlink
                    ViewState("aggCase") = e.CommandArgument
                End If
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnAggrReviewReturnToSearchResults_Click(sender As Object, e As EventArgs)

        Try
            ToggleVisibility(CSEARCHRESULTS)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnAggrReviewNewSearch_Click(sender As Object, e As EventArgs)

        Try
            ClearSearch()
            ToggleVisibility(CSEARCH)
            EnableSearchControls(True)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' user clicks "Return to Vet Aggregate Disease Record"
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub btnReturnToAggrRecord_Click(sender As Object, e As EventArgs)

        Try
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & divSuccessModalContainer.ClientID & "').modal('hide');});", True)
            GetSearchFields()
            ' Make SearccaseID = hidden case ID
            'strSearchCaseID
            txtstrSearchCaseID.Text = hdfstrCaseID.Value
            FillAggregateGrid(sGetDataFor:="PAGE", bRefresh:=True)
            'searchForm.Visible = False

            'Bug 3773 - User is returned to the Search page instead of the Disease Report - (Asim)
            VeterinaryAggregate.Visible = True

            'ToggleVisibility(CSEARCHRESULTS)

            'Bug 3773 - User is returned to the Search page instead of the Disease Report - (Asim)
            search.Visible = False
            'Bug 3773 - User is returned to the Search page instead of the Disease Report - (Asim)
            searchResults.Visible = False

            'If user has been redirected to Add Vet Agg Report, then clear out ddlInstitution
            ddlidfSentByOffice.SelectedValue = "null"
            ddlidfSentByPerson.SelectedValue = "null"
            txtdatSentbyDate.Text = ""
            btnCancelDelete.Visible = False

            If txtdatDate.Visible Then txtdatDate.Text = ""
            If ddlintMonth.Visible Then ddlintMonth.SelectedValue = "null"
            If ddlintQuarter.Visible Then ddlintQuarter.SelectedValue = "null"
            If ddlintWeek.Visible Then ddlintWeek.SelectedValue = "null"

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub searchCriteria_Changed(sender As Object, e As EventArgs) Handles txtstrSearchCaseID.TextChanged, ddlidfsOrganzation.SelectedIndexChanged
        resetSearch()
    End Sub

#End Region
#Region "Error"
    Private Sub VeterinaryAggregate_Error(Sender As Object, e As EventArgs) Handles Me.[Error]
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
                        .ID = "tblVeterinaryAggerCaseClassification",
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
                Dim DataTypeAndID As String = txt.ID.Remove(txt.ID.IndexOf("txtString"), "txtString".Length)
                Dim DataType As String = DataTypeAndID.Replace(idfsParameterRetreived.ToString(), "")

                Dim ActivityParamValue As String

                'Whether empty or not, it should be updated, what if the user deleted data and wants to update it. 
                'If txt.Text <> "" Then
                ActivityParamValue = txt.Text
                If FlexibleFormService Is Nothing Then
                    FlexibleFormService = New FlexibleFormServiceClient()
                End If

                Dim parameters As AdminFfSetActivityParameters = New AdminFfSetActivityParameters With {
                    .idfsParameter = idfsParameterRetreived,
                    .idfObservation = hdfidfCaseObservation.Value,
                    .idfsFormTemplate = hdfidfsCaseObservationFormTemplate.Value,
                    .varValue = ActivityParamValue,
                    .isDynamicParameter = False,
                    .idfRow = Nothing,
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

                Dim ActivityParamValue As Boolean

                'Whether empty or not, it should be updated, what if the user deleted data and wants to update it. 
                'If txt.Text <> "" Then
                ActivityParamValue = chk.Checked
                If FlexibleFormService Is Nothing Then
                    FlexibleFormService = New FlexibleFormServiceClient()
                End If

                Dim parameters As AdminFfSetActivityParameters = New AdminFfSetActivityParameters With {
                    .idfsParameter = idfsParameterRetreived,
                    .idfObservation = hdfidfCaseObservation.Value,
                    .idfsFormTemplate = hdfidfsCaseObservationFormTemplate.Value,
                    .varValue = Convert.ToString(ActivityParamValue),
                    .isDynamicParameter = False,
                    .idfRow = Nothing,
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

                Dim ActivityParamValue As String
                'Whether empty or not, it should be updated, what if the user deleted data and wants to update it. 
                ActivityParamValue = ddl.SelectedValue.ToString()
                If FlexibleFormService Is Nothing Then
                    FlexibleFormService = New FlexibleFormServiceClient()
                End If

                Dim parameters As AdminFfSetActivityParameters = New AdminFfSetActivityParameters With {
                    .idfsParameter = idfsParameterRetreived,
                    .idfObservation = hdfidfCaseObservation.Value,
                    .idfsFormTemplate = hdfidfsCaseObservationFormTemplate.Value,
                    .varValue = Convert.ToString(ActivityParamValue),
                    .isDynamicParameter = False,
                    .idfRow = Nothing,
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

                Dim ActivityParamValue As String
                'Whether empty or not, it should be updated, what if the user deleted data and wants to update it. 
                ActivityParamValue = txtDT.Text
                If FlexibleFormService Is Nothing Then
                    FlexibleFormService = New FlexibleFormServiceClient()
                End If

                Dim parameters As AdminFfSetActivityParameters = New AdminFfSetActivityParameters With {
                    .idfsParameter = idfsParameterRetreived,
                    .idfObservation = hdfidfCaseObservation.Value,
                    .idfsFormTemplate = hdfidfsCaseObservationFormTemplate.Value,
                    .varValue = Convert.ToString(ActivityParamValue),
                    .isDynamicParameter = False,
                    .idfRow = Nothing,
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
        Dim collection As MatchCollection = Regex.Matches(value, "\d+")
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

                If activityParameter.idfsParameter = idfsParameterRetreived Then
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

                If activityParameter.idfsParameter = idfsParameterRetreived Then
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

                If activityParameter.idfsParameter = idfsParameterRetreived Then
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

                If activityParameter.idfsParameter = idfsParameterRetreived Then
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

                        preStublist = preStublist.Where(Function(x) x.idfsParameter.ToString() <> "239010000000").ToList()
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