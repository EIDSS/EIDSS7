Imports EIDSS.EIDSS
Public Class VeterinaryAggregate
    Inherits System.Web.UI.Page

    Dim oAgg As clsAggregate = New clsAggregate()
    'Constants for Sections/Panels on the form
    Private Const CSEARCHRESULTS As String = "searchResults"
    Private Const CSEARCH As String = "search"
    Private Const CHUMANAGGR As String = "vetAggregate"
    Private Const SEARCH_FILE_PREFIX As String = "_VA"
    Private Const SEARCH_SP As String = "HumanGetList"

#Region "Initialize"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            PopulateSearchDropDowns()
            gvVAC.DataSource = New List(Of Object)
            gvVAC.DataBind()
            hdnidfsAggrCaseType.Value = BaseReferenceConstants.VeterinaryAggregateValue
            hdnLangID.Value = getConfigValue("DefaultLanguage")
        End If
    End Sub
#End Region
#Region "Common"
    Private Sub PopulateSearchDropDowns()

        BaseReferenceLookUp(ddlifdsSearchAdministrativeLevel, BaseReferenceConstants.AdministrativeLevel, blnBlankRow:=True)
        FillOrganizationList(ddlidfsOrganzation, Nothing, Nothing, True)
        'FillOrganizationList(ddlstrOperatorNotiSentByDate, Nothing, Nothing, True)
        'FillOrganizationList(ddlidfsOrgEntered, Nothing, Nothing, True)
        BaseReferenceLookUp(ddlidfsTimeInterval, BaseReferenceConstants.StatisticalPeriodType, HACodeList.NoneHACode, True)
        Try
            GetSearchFields()
            'set defaults on these, per use case
            If ddlidfsTimeInterval.SelectedIndex < 1 Then ddlidfsTimeInterval.SelectedIndex = 3
            If ddlifdsSearchAdministrativeLevel.SelectedIndex < 1 Then ddlifdsSearchAdministrativeLevel.SelectedIndex = 2
        Catch ex As ArgumentOutOfRangeException

        End Try

    End Sub
    Private Sub PopulateEditDropDowns()

        'time-based values
        FillUpToCurrentYear()
        'need to have year ddl populated before 
        ToggleEditTimeDdls(ddlidfsTimeInterval)

        'People and Institutions
        FillOrganizationList(ddlidfReceivedByOffice, Nothing, Nothing, True)
        FillOrganizationList(ddlidfSentByOffice, Nothing, Nothing, True)
        FillDropDown(ddlidfReceivedByPerson, GetType(clsOrgPerson), Nothing, PersonConstants.idfPerson, OrganizationConstants.OrgFullName, Nothing, Nothing, True)
        FillDropDown(ddlidfSentByPerson, GetType(clsOrgPerson), Nothing, PersonConstants.idfPerson, OrganizationConstants.OrgFullName, Nothing, Nothing, True)

        'also populate read only textboxes
        txtstrEnteredByPerson.Text = Session("UserName").ToString()
        txtstrEnteredByOffice.Text = Session("Organization").ToString()
        txtdatEnteredByDate.Text = DateTime.Today.ToShortDateString()

        'Fill hidden fields with the INT values of the above
        hdnidfEnteredByPerson.Value = Session("UserID").ToString()
        hdnidfEnteredByOffice.Value = Session("Institution").ToString()

    End Sub
    Private Sub SetDefaultsAndLimits()

        'set limits on calendars, etc
        txtdatSentbyDate.maxDate = DateTime.Today.ToShortDateString()
        txtdatReceivedByDate.maxDate = DateTime.Today.ToShortDateString()

        hdnidfAggrCase.Value = "0" 'int value to cause an insert as opposed to update
        hdnidfsAggrCaseType.Value = BaseReferenceConstants.HumanAggregateValue
        txtstrCaseID.Text = "(new)"

    End Sub
    Private Sub SetupForAddOrUpate()

        PopulateEditDropDowns()
        SetDefaultsAndLimits()
        ToggleEditAdminDdls(ddlifdsSearchAdministrativeLevel)

    End Sub
    Private Sub SetNotifyDateMin()
        txtdatReceivedByDate.minDate = txtdatSentbyDate.Text
    End Sub
    Private Sub FillAggregateGrid(Optional sGetDataFor As String = "GRIDROWS",
                                        Optional bRefresh As Boolean = False)

        SaveSearchFields()
        SaveAdminFromDDL()
        NullingTextBoxes()

        Dim dsAgg As DataSet = Nothing
        Try
            If IsNothing(ViewState("AggList")) Or bRefresh Then
                Dim oCom As New clsCommon()
                Dim oService As NG.EIDSSService = oCom.getService()
                Dim aSP As String() = oService.getSPList("AggregateGetList")
                Dim searchFields As String = oCom.Gather(search, aSP(0), 3, True)
                searchFields = oCom.Gather(divHiddenFieldsSection, aSP(0), 3, True) + "|" + searchFields
                searchFields = oCom.Gather(alwaysShown, aSP(0), 3, True) + "|" + searchFields
                dsAgg = oAgg.ListAll({searchFields})
                ViewState("AggList") = dsAgg
            Else
                dsAgg = ViewState("AggList")
            End If


            If Not dsAgg.CheckDataSet() Then
                dsAgg = Nothing
            End If
            EnableControls(search, False)
            ToggleVisibility(CSEARCHRESULTS)

            With gvVAC
                .DataSource = dsAgg.Tables(0)
                .DataBind()
            End With

        Catch e As Exception
            gvVAC.DataSource = Nothing
            ToggleVisibility(CSEARCHRESULTS)
            gvVAC.DataBind()
        End Try

    End Sub
    Private Sub AddOrUpdateAgg()

        'verify that the minimum of time period and admin have been populated
        'confirm with user. if blank, then set defaults per use case

        Dim oCom As clsCommon = New clsCommon()
        Dim oService As NG.EIDSSService = oCom.getService()
        Dim aSP() As String = Nothing

        aSP = oService.getSPList("AggregateSave")
        SaveAdminFromDDL() 'save a single admin area value
        Dim hidnValues As String = oCom.Gather(divHiddenFieldsSection, aSP(0).ToString(), 3, True)
        Dim dataValues = oCom.Gather(VetAggregate, aSP(0).ToString(), 3, True)
        Dim aggID As Integer = oAgg.AddOrUpdate(dataValues + "|" + hidnValues)
    End Sub
    Private Function ValidateForSearch() As Boolean

        ValidateForSearch = False

        Dim oCom As clsCommon = New clsCommon()

        'if ID is entered, perform the search. Otherwise, check other fields
        ValidateForSearch = Not txtstrSearchCaseID.Text.IsValueNullOrEmpty()

        If Not ValidateForSearch Then

            Dim allCtrl As New List(Of Control)

            allCtrl.Clear()
            For Each txt As WebControls.TextBox In oCom.FindCtrl(allCtrl, search, GetType(WebControls.TextBox))
                If Not ValidateForSearch Then ValidateForSearch = (Not txt.Text.ToString().IsValueNullOrEmpty())
            Next
            If Not ValidateForSearch Then
                allCtrl.Clear()
                For Each ddl As WebControls.DropDownList In oCom.FindCtrl(allCtrl, search, GetType(WebControls.DropDownList))
                    If Not ValidateForSearch Then ValidateForSearch = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not ValidateForSearch Then
                allCtrl.Clear()
                For Each ddl As EIDSSControlLibrary.DropDownList In oCom.FindCtrl(allCtrl, search, GetType(EIDSSControlLibrary.DropDownList))
                    If Not ValidateForSearch Then ValidateForSearch = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not ValidateForSearch Then
                allCtrl.Clear()
                For Each txt As EIDSSControlLibrary.CalendarInput In oCom.FindCtrl(allCtrl, search, GetType(EIDSSControlLibrary.CalendarInput))
                    If Not ValidateForSearch Then ValidateForSearch = (Not txt.Text.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not ValidateForSearch Then
                ASPNETMsgBox(GetLocalResourceObject("Please enter at least one search parameter"))
                txtstrSearchCaseID.Focus()
            End If
        End If

        Return ValidateForSearch
    End Function
    Private Sub PopulateAggregateForEditing()
        If Not IsNothing(ViewState("aggCase")) Then
            Dim ds As DataSet = oAgg.SelectOneCase(ViewState("aggCase").ToString())

            If ds.CheckDataSet() Then
                SetupForAddOrUpate()

                Dim oCom As clsCommon = New clsCommon()
                oCom.Scatter(VetAggregate, New DataTableReader(ds.Tables(0)))
                oCom.Scatter(divHiddenFieldsSection, New DataTableReader(ds.Tables(0)))
                FillCountry()
                SetLocationByAdminUnit(ds)
                btnTryDelete.Visible = True
                ToggleVisibility(CHUMANAGGR)
                DetermineDateRangeDroDown(ds.Tables(0).Rows(0)("idfsPeriodType").ToString(), ds.Tables(0).Rows(0)("datStartDate").ToString(), ds.Tables(0).Rows(0)("datFinishDate").ToString())

            End If
        End If
    End Sub
    Private Sub DeleteAgg()
        If Not IsNothing(ViewState("aggCase")) Then
            oAgg.Delete(Double.Parse(hdnidfAggrCase.Value))
            ToggleVisibility(CSEARCH)
        End If
    End Sub
    Private Sub ToggleVisibility(ByVal section As String)

        search.Visible = section.EqualsAny({CSEARCH})
        searchResults.Visible = section.EqualsAny({CSEARCHRESULTS})
        VetAggregate.Visible = section.EqualsAny({CHUMANAGGR})
    End Sub
    Private Sub NullingTextBoxes()

        If String.IsNullOrEmpty(txtdatSearchEndDate.Text) Then txtdatSearchEndDate.Text = "null"
        If String.IsNullOrEmpty(txtdatSearchStartDate.Text) Then txtdatSearchStartDate.Text = "null"
        If String.IsNullOrEmpty(txtstrSearchCaseID.Text) Then txtstrSearchCaseID.Text = "null"

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

            Dim radioButton As RadioButton = TryCast(control, RadioButton)
            If Not IsNothing(radioButton) Then
                radioButton.Enabled = enabled
                Continue For
            End If

            Dim checkBox As CheckBox = TryCast(control, CheckBox)
            If Not IsNothing(checkBox) Then
                checkBox.Enabled = enabled
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

                    Dim rdb As RadioButton = TryCast(control, RadioButton)
                    If Not IsNothing(rdb) Then
                        rdb.Enabled = enabled
                        Continue For
                    End If

                    Dim chb As CheckBox = TryCast(control, CheckBox)
                    If Not IsNothing(chb) Then
                        chb.Enabled = enabled
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
    Private Sub ClearControl(ByRef sectionName As Web.UI.Control)

        Dim oCom As clsCommon = New clsCommon()
        oCom.ResetForm(sectionName)

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
    Private Sub ResetQuarters()

        If ddlintQuarter.Visible Then
            ddlintQuarter.DataSource = oAgg.FillQuarterList(CType(ddlintYear.SelectedValue, Integer))
            oAgg.FillPeriod(ddlintQuarter, True)
        End If

    End Sub
    Private Sub ResetMonths()

        If ddlintMonth.Visible Then
            ddlintMonth.DataSource = oAgg.FillMonthList(CType(ddlintYear.SelectedValue, Integer))
            oAgg.FillPeriod(ddlintMonth, True)
        End If

    End Sub
    Private Sub ResetWeeks()

        If ddlintWeek.Visible Then
            ddlintWeek.DataSource = oAgg.FillWeekList(CType(ddlintYear.SelectedValue, Integer))
            oAgg.FillPeriod(ddlintWeek, True)
        End If

    End Sub
    Private Sub ToggleSearchAdminDdls(ddl As DropDownList)

        Dim indx As String = ddl.SelectedIndex.ToString()
        searchOrg.Visible = indx.EqualsAny({"4"})
        lucSearch.ShowTownOrVillage = indx.EqualsAny({"4", "3"})
        lucSearch.ShowRayon = indx.EqualsAny({"4", "3", "2"})
        lucSearch.ShowRegion = indx.EqualsAny({"4", "3", "2", "1"})

    End Sub
    Private Sub ToggleEditAdminDdls(ddl As DropDownList)

        Dim indx As String = ddl.SelectedIndex.ToString()
        lucVetAggregate.ShowTownOrVillage = indx.EqualsAny({"4", "3"})
        lucVetAggregate.ShowRayon = indx.EqualsAny({"4", "3", "2"})
        lucVetAggregate.ShowRegion = indx.EqualsAny({"4", "3", "2", "1"})

    End Sub
    Private Sub ToggleEditTimeDdls(d As DropDownList)

        'based on index of the time period dropdown, set the visibility of the time range dropdowns
        Dim indx As String = d.SelectedIndex.ToString()
        quarter.Visible = indx.Equals("2")
        month.Visible = indx.Equals("3")
        week.Visible = indx.Equals("4")
        singleDay.Visible = indx.Equals("5")

        ResetTimes()

    End Sub
    Private Sub ResetTimes()

        'based on new value of year, adjust the more granular time frames
        ResetQuarters()
        ResetMonths()
        ResetWeeks()

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
        End Select

    End Sub
    Protected Sub SaveDateRange(sender As Object, e As EventArgs)

        Dim spaceInd As Integer = 0
        If txtdatDate.Text.Contains(" ") Then spaceInd = txtdatDate.Text.IndexOf(" ")
        FillHiddenDates(txtdatDate.Text.Substring(0, spaceInd), txtdatDate.Text.Substring(0, spaceInd))

    End Sub
    Private Sub FillHiddenDates(start As String, endD As String)
        'populate hidden fields 
        hdndatStartDate.Value = start
        hdndatFinishDate.Value = endD

    End Sub
    Private Sub DetermineDateRangeDroDown(period As String, sDate As String, eDate As String)

        'based on periodType, we know which contrrol to make visible
        ddlintMonth.Visible = (period = "10091001")
        ddlintQuarter.Visible = (period = "10091003")
        ddlintWeek.Visible = (period = "10091004")

        txtdatDate.Visible = (period = "10091002")

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
        If ddlintMonth.Visible Then ddlintMonth.SelectedIndex = stDate.Month
        If ddlintQuarter.Visible Then ddlintQuarter.SelectedValue = oAgg.GetQuarterValue(stDate.Year, stDate.Month)
        If ddlintWeek.Visible Then ddlintWeek.SelectedValue = oAgg.GetWeekValue(stDate)




    End Sub
#End Region
#Region "AdminArea"
    Private Sub FillCountry()

        'Set default country name and save country ID in hidden field
        txtstrCountry.Text = getConfigValue("DefaultCountry").ToString()
        Dim oC As clsCountry = New clsCountry()
        Dim dsCountry = oC.SelectOne(0)
        If dsCountry.CheckDataSet() Then
            hdnidfsCountry.Value = dsCountry.Tables(0).Rows(0)(CountryConstants.CountryID).ToString()
        End If

    End Sub
    Private Sub SaveAdminFromDDL()

        Dim ddlList As New List(Of Control)
        Dim oCom As clsCommon = New clsCommon()
        For Each ddl As EIDSSControlLibrary.DropDownList In oCom.FindCtrl(ddlList, adminSearch, GetType(EIDSSControlLibrary.DropDownList))
            If ddl.SelectedIndex > 0 Then
                hdnidfsAdministrativeUnit.Value = ddl.SelectedValue.ToString()
            End If
        Next

    End Sub
    Private Sub SetLocationByAdminUnit(ByRef ds As DataSet)
        Try

            lucVetAggregate.LocationData = ds.Tables(0)
            lucVetAggregate.DataBind()

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
        oCom.SaveSearchFields({search}, SEARCH_SP, oCom.CreateTempFile(SEARCH_FILE_PREFIX))

    End Sub
    Private Sub GetSearchFields()

        Dim oCom As clsCommon = New clsCommon()
        oCom.GetSearchFields({search}, oCom.CreateTempFile(SEARCH_FILE_PREFIX))

    End Sub
    Private Sub ClearSearch()

        Dim oCom As New clsCommon()
        oCom.DeleteTempFiles(oCom.CreateTempFile(SEARCH_FILE_PREFIX))
        oCom.ResetForm(search)

    End Sub
#End Region
#Region "Sorting"
    Private Sub Sorting(e As GridViewSortEventArgs)

        Dim oDS As DataSet = ViewState("AggregateList")

        Dim dt As DataTable = oDS.Tables(0)

        If Not IsNothing(dt) Then
            dt.DefaultView.Sort = e.SortExpression + " " + GetSortDirection(e.SortExpression)
            gvVAC.DataSource = CType(ViewState("AggregateList"), DataSet)
            gvVAC.DataBind()
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
#End Region
#Region "Events"
    Protected Sub btnDelAgg_Click(sender As Object, e As EventArgs) Handles delYes.ServerClick
        DeleteAgg()
    End Sub
    Protected Sub btnClear_Click(sender As Object, e As EventArgs)
        ClearSearch()
    End Sub
    Protected Sub btnSearch_Click(sender As Object, e As EventArgs)
        If ValidateForSearch() Then
            FillAggregateGrid()
        End If
    End Sub
    Protected Sub btnNo_Click(sender As Object, e As EventArgs)
        ViewState("EmptyObject").Focus()
    End Sub
    Protected Sub btnYes_Click(sender As Object, e As EventArgs)
        txtdatSearchStartDate.Text = DateTime.Today.AddYears(-1)
    End Sub
    Protected Sub btnEditSearch_Click(sender As Object, e As EventArgs) Handles btnEditSearch.ServerClick
        ToggleVisibility(CSEARCH)
        EnableControls(search, True)
    End Sub
    Protected Sub newSearch_Click(sender As Object, e As EventArgs)

        ClearControl(search)
        ViewState("AggList") = Nothing
        PopulateSearchDropDowns()
        EnableControls(search, True)
        ToggleVisibility(CSEARCH)

    End Sub
    Protected Sub newVAC_Click(sender As Object, e As EventArgs)
        ToggleVisibility(CHUMANAGGR)
        gvDiagnosis.DataSource = New List(Of Object)
        gvDiagnosis.DataBind()
        ClearControl(VetAggregate)
        txtstrCountry.Enabled = False
        txtdatEnteredByDate.Enabled = False
        txtstrEnteredByOffice.Enabled = False
        txtstrEnteredByPerson.Enabled = False
        btnTryDelete.Visible = False
        txtdatEnteredByDate.Text = String.Empty
        txtdatEnteredByDate.Text = DateTime.Today
        FindSettingDetail()
        SetupForAddOrUpate()
    End Sub
    Protected Sub ddlintYear_SelectedIndexChanged(sender As Object, e As EventArgs)
        ResetTimes()
        SaveDateRangeFromDDL(sender, e)
    End Sub
    Protected Sub ddlifdsSearchAdministrativeLevel_SelectedIndexChanged(sender As Object, e As EventArgs)
        ToggleSearchAdminDdls(sender)
    End Sub
    Protected Sub btnCancel_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Dashboard.aspx")
    End Sub
    Protected Sub btnVACCancel_Click(sender As Object, e As EventArgs)
        search.Visible = False
        vetAggregate.Visible = False
        searchResults.Visible = True
    End Sub
    Protected Sub btnNext_Click(sender As Object, e As EventArgs)
        EnableControls(vetAggregate, False)
        btnNext.Visible = False
        btnTryDelete.Visible = False
        btnSubmit.Visible = True
    End Sub
    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)
        AddOrUpdateAgg()
        EnableControls(VetAggregate, True)
        vetAggregate.Visible = False
        EnableControls(search, True)
        editSearch.Visible = False
        searchResults.Visible = True
        txtstrCountry.Enabled = False
        txtdatEnteredByDate.Enabled = False
        txtstrEnteredByOffice.Enabled = False
        txtstrEnteredByPerson.Enabled = False
        txtdatEnteredByDate.Text = String.Empty
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
    Protected Sub gvVAC_Sorting(sender As Object, e As GridViewSortEventArgs)
        Sorting(e)
    End Sub
    Private Sub gvVAC_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvVAC.RowEditing
        e.Cancel = True
        PopulateAggregateForEditing()
    End Sub
    Private Sub gvVAC_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvVAC.RowCommand
        If e.CommandName.ToUpper().EqualsAny("SELECT,EDIT".Split(",")) Then

            Dim idx As Integer = Convert.ToInt32(e.CommandArgument)
            Dim row As GridViewRow = gvVAC.Rows(idx)
            ViewState("aggCase") = gvVAC.DataKeys(idx).Values("strCaseID")

        End If
    End Sub
#End Region
#Region "Error"
    Private Sub HumanAggregate_Error(Sender As Object, e As EventArgs) Handles Me.[Error]
        Dim exc As Exception = Server.GetLastError()

        If (TypeOf exc Is HttpUnhandledException) Then

            ASPNETMsgBox("An error occurred on this page. Please verify your information to resolve the issue.")

        Else
            'Pass the error on to the error page.
            Dim delimiter As Char = "/"
            Dim sHandler As String() = Request.ServerVariables("SCRIPT_NAME").Split(delimiter)
            Server.Transfer("~" & Request.ApplicationPath & "GeneralError.aspx?handler=" & sHandler.Last.ToString().Replace(".aspx", "") & "_Error%20-%20Default.aspx&aspxerrorpath=" & Me.GetType.Name, True)
        End If

        'Clear the error from the server.
        Server.ClearError()
    End Sub
#End Region

End Class