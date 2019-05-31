Imports EIDSS.EIDSS
Imports System.Reflection

Public Class VeterinaryAggregateAction

    Inherits BaseEidssPage

    Dim oAgg As clsAggregate = New clsAggregate()

    'Constants for Sections/Panels on the form
    Private Const CSEARCHRESULTS As String = "searchResults"
    Private Const CALWAYSSHOWN As String = "alwaysShown"
    Private Const CSEARCH As String = "searchForm"
    Private Shared Log = log4net.LogManager.GetLogger(GetType(LocationUserControl))

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

#Region "Initialize"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            If Not IsPostBack Then
                PopulateSearchDropDowns()
                gvVAC.DataSource = New List(Of Object)
                gvVAC.DataBind()
                InitializePage()
            Else
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

    Private Sub InitializePage()
        Try
            ' searchResults.Visible = False
            ToggleVisibility(CSEARCH)
            hdfidfsAggrCaseType.Value = AggregateValue.Veterinary
            hdfLangID.Value = getConfigValue("DefaultLanguage")

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
            'set defaults on these, per use case
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

            If hdfidfVersion.Value = "" Then
                hdfidfVersion.Value = -1
            End If

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

                If Not IsValueNullOrEmpty(Session("PageMode")).ToString() = "VetAggEdit" Then
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
        Try
            lucSearch.ShowTownOrVillage = indx.EqualsAny({"4", "3"})
            lucSearch.ShowRayon = indx.EqualsAny({"4", "3", "2"})
            lucSearch.ShowRegion = indx.EqualsAny({"4", "3", "2", "1"})

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
    Private Sub ToggleEditTimeDdls(d As DropDownList)

        'based on index of the time period dropdown, set the visibility of the time range dropdowns
        Dim indx As String = d.SelectedIndex.ToString()

        Try
            quarter.Visible = indx.Equals("1")
            month.Visible = indx.Equals("2")
            week.Visible = indx.Equals("3")
            singleDay.Visible = indx.Equals("4")

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
                Case "ddlintQuarter", "ddlintWeek"
                    Dim dRange As String() = (ddl.SelectedItem.ToString()).Split("-")
                    FillHiddenDates(dRange(0).Trim(), dRange(1).Trim())
                Case "ddlintWeek"
                    sDate = New DateTime(Now.Year, Now.Month, 1)
                    eDate = sDate.AddMonths(1).AddDays(-25)
                    FillHiddenDates(sDate.ToShortDateString(), eDate.ToShortDateString())
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

            '       ToggleVisibility(SectionVetAggReview) 'Need to implement Arnold
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

                    'If user has not entered a StartDate, set sd to 01/01/1900, to avoid exception;
                    If txtdatSearchStartDate.Text.Length = 0 Then
                        sd = CType("01/01/1900", DateTime)
                    Else
                        sd = CType(txtdatSearchStartDate.Text, DateTime)
                    End If

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
            FindSettingDetail()
            SetupForAddOrUpate()

            'Bug # 1909 pre-populated fields Region and Rayon (Begin) - Asim
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
            'Bug # 1909 pre-populated fields Region and Rayon (End) - Asim
            If Session("PageMode").ToString() = "VetAggAdd" Then Session("PageMode") = ""

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
            EnableControls(VeterinaryAggregate, False)
            EnableLocationControls(adminSearch, False)
            btnNext.Visible = False
            'btnPrint.Visible = False REM Issue 2498
            btnPrintNewAgg.Visible = False
            btnVACCancel.Visible = False
            btnNotSubmit.Visible = True  'Added due to edit
            btnSubmit.Visible = True

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
            EnableControls(VeterinaryAggregate, True)
            EnableLocationControls(adminSearch, True)

            AddOrUpdateAgg()
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & divSuccessModalContainer.ClientID & "').modal('show');});", True)

            btnSubmit.Visible = False
            btnNewVAC.Visible = True
            btnSearch.Visible = True

            VeterinaryAggregate.Visible = False
            VeterinaryAggregate.Visible = True  ' Add this during debugging

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

        Try
            Return Server.MapPath("\") & "App_Data\" & Session("UserID").ToString() & "_PS.xml"

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Function
    Private Sub gvVAC_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvVAC.RowEditing

        Try
            Session("PageMode") = "VetAggEdit"
            e.Cancel = True
            PopulateAggregateForEditing()
            If Session("PageMode").ToString() = "VetAggEdit" Then Session("PageMode") = ""

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

    Protected Sub btnReturnToAggrRecord_Click(sender As Object, e As EventArgs)

        Try
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & divSuccessModalContainer.ClientID & "').modal('hide');});", True)
            GetSearchFields()
            ' Make SearccaseID = hidden case ID
            'strSearchCaseID
            txtstrSearchCaseID.Text = hdfstrCaseID.Value
            FillAggregateGrid(sGetDataFor:="PAGE", bRefresh:=True)
            'searchForm.Visible = False
            VeterinaryAggregate.Visible = False

            'ToggleVisibility(CSEARCHRESULTS)

            search.Visible = True
            searchResults.Visible = True

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

End Class