Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.EIDSS
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports System.Drawing

Public Class SearchDiseaseReports
    Inherits BaseEidssPage

    'Constants for Sections/Panels on the form
    Private Const SectionSearch As String = "Search"
    Private Const SectionSearchResults As String = "Search Results"
    Private Const SectionSearchFilterSummary As String = "Search Filter Summary"

    Private Const SectionPerson As String = "Person"
    Private Const SectionEditPerson As String = "Edit Person"
    Private Const SectionPersonReview As String = "Person Review"
    Private Const PeopleGridViewSelectColumn As Int16 = 0

    Private Const CALLER_INFO As String = "CallerInfo"
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"
    Private Const USERDISEASEREPORTPERMISSIONS As String = "UserDiseaseReportPermissions"
    Private Const USERDISEASEREPORTPERMISSIONSEDIT As String = "Edit"
    Private Const USERDISEASEREPORTPERMISSIONSVIEW As String = "View"
    Private Const HDR_DISEASEDEDUPLICATIONLIST_GvList As String = "DiseaseDeduplicationListGVList"

    Dim oCommon As clsCommon = New clsCommon()
    Private HumanAPIService As HumanServiceClient







    Private Shared Log = log4net.LogManager.GetLogger(GetType(SearchPersonUserControl))
    'For Advanced Search
    Private ReadOnly BaseReferenceAPIClient As BaseReferenceClient
    Private ReadOnly ConfigurationAPIClient As ConfigurationServiceClient
    Private ReadOnly CrossCuttingAPIClient As CrossCuttingServiceClient
    Private caseTypes As New List(Of AdminBaserefGetListModel)
    Private adminLevels As New List(Of AdminBaserefGetListModel)
    Private minimumTimeIntervalUnit As New List(Of AdminBaserefGetListModel)
    Private viewStateKeys As New List(Of String)
    Private globalSiteDetails As GblSiteGetDetailModel





    Sub New()
        Try
            Log = log4net.LogManager.GetLogger(GetType(SearchDiseaseReports))
            Log.Info("Loading Contructor SearchDiseasReports.aspx")
            CrossCuttingAPIClient = New CrossCuttingServiceClient()
            BaseReferenceAPIClient = New BaseReferenceClient()
            ConfigurationAPIClient = New ConfigurationServiceClient()
            globalSiteDetails = New GblSiteGetDetailModel()

        Catch ex As Exception
            Log.Error("Error Loading Contructor Classes" & ex.Message)
            Throw ex
        End Try
    End Sub










    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim userId = Session(UserConstants.idfUserID)
        Dim userSite = Session(UserConstants.UserSite)
        Dim Log = log4net.LogManager.GetLogger(GetType(SearchDiseaseReports))
        Log.Info("Loading Page Load")
        Try
            If userId Is Nothing Then
                Response.Redirect("~/Login.aspx")

            End If
            If Not Page.IsPostBack Then
                globalSiteDetails = CrossCuttingAPIClient.GetGlobalSiteDetails(userSite, userId).Result(0)
                If globalSiteDetails Is Nothing Or globalSiteDetails.idfCustomizationPackage = 0 Or userId Is Nothing Then
                End If
                PopulateAdvancedSearchControls(globalSiteDetails.idfsCountry, globalSiteDetails.idfsRegion, globalSiteDetails.idfsRayon)

            End If

            If Not Page.IsPostBack Then
                hdfCurrentDate.Value = DateTime.Today.ToString("d")
                PopulateSearchDropdowns()
                ExtractViewStateSession()

                'Set default user role Disease Report permissions
                ViewState(USERDISEASEREPORTPERMISSIONS) = USERDISEASEREPORTPERMISSIONSEDIT

                'Check user role Disease Report permissions
                If ViewState(CALLER) = CallerPages.HumanDiseaseReportDetail Then
                    FillDiseaseList(bRefresh:=True)
                    showSearchCriteria(False)
                    searchResults.Visible = True
                ElseIf ViewState(CALLER) = CallerPages.Person Then
                    If ValidateForSearch() Then
                        FillDiseaseList(bRefresh:=True)
                        showSearchCriteria(False)
                        searchResults.Visible = True
                        'ToggleVisibility(SectionSearchResults)
                    End If
                ElseIf Request.Params("DeduplicationFlag") = 1 Then
                    '  SetInitialVisibility()
                    ViewState(CALLER) = CallerPages.HumanDiseaseReportDeduplication
                    gvDisease.Visible = False
                Else
                    SetInitialVisibility()
                End If

                If ViewState(USERDISEASEREPORTPERMISSIONS) = USERDISEASEREPORTPERMISSIONSVIEW Then
                    gvDisease.Columns(8).Visible = False
                End If

            Else
                Dim target As String = TryCast(Request("__EVENTTARGET"), String)
                Dim searchRegName As String = "ctl00$EIDSSBodyCPH$lsearchForm$ddllsearchFormidfsRegion"
                Dim searchRayName As String = "ctl00$EIDSSBodyCPH$lsearchForm$ddllsearchFormidfsRayon"
                If target.EqualsAny({searchRegName, searchRayName}) Then
                    searchResults.Visible = False
                    searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
                    btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")
                End If
            End If
            If Page.IsPostBack Then
                ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "accordionHide", "$('#collapseOne').collapse('hide');$('#collapseTwo').collapse('hide');$('#collapseThree').collapse('show');", True)
            End If

        Catch ex As Exception
            Log.Error("Error" & " " & ex.Message, ex)
        End Try



    End Sub

    Private Sub SetInitialVisibility()
        searchForm.Visible = True
        btnClear.Visible = True
        btnSearch.Visible = True
        btnPrint.Visible = False
        btnCancelSearchResults.Visible = False
        btnShowSearchCriteria.Visible = False
        'btnEditSearch.Visible = False
        searchFilterSummary.Visible = False
        searchResults.Visible = False
        'btnNewSearch.Visible = False
        instructionTextUseTheFollowing.Visible = True
        instructionTextSelectARow.Visible = False
    End Sub

    Private Sub PopulateSearchDropdowns()
        BaseReferenceLookUp(ddlSearchDiagnosis, BaseReferenceConstants.Diagnosis, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlSearchReportStatus, BaseReferenceConstants.CaseStatus, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlSearchCaseClassification, BaseReferenceConstants.CaseClassification, HACodeList.HumanHACode, True)
        BaseReferenceLookUp(ddlSearchIdfsHospitalizationStatus, BaseReferenceConstants.PatientLocationType, HACodeList.HumanHACode, True)

        '' Re-label Search Hospitalization Status
        Dim test As String = ddlSearchIdfsHospitalizationStatus.Items(1).Text = GetLocalResourceObject("lbl_Yes")

        For x As Integer = 0 To ddlSearchIdfsHospitalizationStatus.Items.Count - 1

            '' Other
            If ddlSearchIdfsHospitalizationStatus.Items(x).Value = "5360000000" Then
                ddlSearchIdfsHospitalizationStatus.Items(x).Text = GetLocalResourceObject("lbl_No")

            End If

            '' Hospital
            If ddlSearchIdfsHospitalizationStatus.Items(x).Value = "5350000000" Then
                ddlSearchIdfsHospitalizationStatus.Items(x).Text = GetLocalResourceObject("lbl_Yes")

            End If

            ''Unknown - No label change 

        Next

        '' Remove Current Address from Search Hospitalization Status
        For x As Integer = 0 To ddlSearchIdfsHospitalizationStatus.Items.Count - 1

            If ddlSearchIdfsHospitalizationStatus.Items(x).Value = "5340000000" Then
                ddlSearchIdfsHospitalizationStatus.Items.RemoveAt(x)
                Exit For
            End If

        Next


    End Sub

    Private Sub PopulateAdvancedSearchControls(countryId As Long, regionId As Long, rayonId As Long)

        Dim regionList = CrossCuttingAPIClient.GetRegionListAsync(GetCurrentLanguage(), countryId, regionId).Result
        Dim rayonList = CrossCuttingAPIClient.GetRayonList(GetCurrentLanguage(), regionId, Nothing).Result
        Dim parameters As New OrganizationGetListParams With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1, .RegionID = regionId, .RayonID = Nothing}
        Dim organizationList = CrossCuttingAPIClient.GetOrganizationListAsync(parameters).Result



        RayonDD.DataSource = rayonList
        RayonDD.DataTextField = "strRayonName"
        RayonDD.DataValueField = "idfsRayon"

        RegionDD.DataSource = regionList
        RegionDD.DataTextField = "strRegionName"
        RegionDD.DataValueField = "idfsRegion"



        LocationOfExposureRayonDD.DataSource = rayonList
        LocationOfExposureRayonDD.DataTextField = "strRayonName"
        LocationOfExposureRayonDD.DataValueField = "idfsRayon"

        LocationOfExposureRegionDD.DataSource = regionList
        LocationOfExposureRegionDD.DataTextField = "strRegionName"
        LocationOfExposureRegionDD.DataValueField = "idfsRegion"


        SentByFacilityDD.DataSource = organizationList
        SentByFacilityDD.DataTextField = "OrganizationFullName"
        SentByFacilityDD.DataValueField = "OrganizationID"


        RecievedByFacilityDD.DataSource = organizationList
        RecievedByFacilityDD.DataTextField = "OrganizationFullName"
        RecievedByFacilityDD.DataValueField = "OrganizationID"

        RegionDD.DataBind()
        RayonDD.DataBind()
        SentByFacilityDD.DataBind()
        RecievedByFacilityDD.DataBind()
        LocationOfExposureRayonDD.DataBind()
        LocationOfExposureRegionDD.DataBind()
    End Sub

    Private Function ValidateForSearch() As Boolean
        Dim blnValidated As Boolean = False
        Dim oCom As clsCommon = New clsCommon()

        ''check if Report ID is entered
        ''If Yes then ignore rest of the serach fields
        ''If No, check if any other search criteria is entered, if not, raise error

        blnValidated = (Not txtSearchStrCaseId.Text.IsValueNullOrEmpty())

        If Not blnValidated Then
            'searchForm
            Dim allCtrl As New List(Of Control)

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

            If Not blnValidated Then
                allCtrl.Clear()
                For Each ddl As EIDSSControlLibrary.DropDownList In oCom.FindCtrl(allCtrl, searchForm, GetType(EIDSSControlLibrary.DropDownList))
                    If Not blnValidated Then blnValidated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not blnValidated Then
                allCtrl.Clear()
                For Each txt As EIDSSControlLibrary.CalendarInput In oCom.FindCtrl(allCtrl, searchForm, GetType(EIDSSControlLibrary.CalendarInput))
                    If Not blnValidated Then blnValidated = (Not txt.Text.ToString().IsValueNullOrEmpty())
                Next
            End If

            If blnValidated And (txtSearchHDRDateEnteredFrom.Text.Length > 0 Or txtSearchHDRDateEnteredTo.Text.Length > 0) Then
                blnValidated = oCom.ValidateFromToDates(txtSearchHDRDateEnteredFrom.Text, txtSearchHDRDateEnteredTo.Text)
                If Not blnValidated Then
                    'show message, search criteria dates are not valid.
                    'ASPNETMsgBox(GetLocalResourceObject("Msg_Dates_Are_Invalid"))
                    'Exits search with bad date error message
                    lblErr.InnerText = GetLocalResourceObject("Msg_Dates_Are_Invalid.InnerText")
                    ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(Function(){ $('#errorVSS').modal('show');});", True)
                    'txtSearchHDRDateEnteredFrom.Focus()
                End If
            Else
                If Not blnValidated Then
                    blnValidated = True
                    'ASPNETMsgBox(GetLocalResourceObject("Msg_At_Least_One_Field_Needs_Value"))
                    'txtSearchStrCaseId.Focus()
                End If
            End If
        End If

        searchResults.Visible = blnValidated
        'btnEditSearch.Visible = blnValidated
        Return blnValidated
    End Function

#Region "Common"

    Private Sub ExtractViewStateSession()

        Try
            Dim nvcViewState As NameValueCollection = oCommon.GetViewState(True)

            If Not nvcViewState Is Nothing Then
                For Each key As String In nvcViewState.Keys
                    ViewState(key) = nvcViewState.Item(key)
                Next
            End If
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

        PrepViewStates()

    End Sub

    Private Sub PrepViewStates()

        'Used to correct any "nothing" values for known Viewstate variables
        Dim lKeys As List(Of String) = New List(Of String)

        'Add your new View State variables here
        lKeys.Add(CALLER)
        lKeys.Add(CALLER_KEY)

        For Each sKey As String In lKeys
            If (ViewState(sKey) Is Nothing) Then
                ViewState(sKey) = String.Empty
            End If
        Next

    End Sub

    Private Sub ToggleVisibility(ByVal sSection As String)

        btnClear.Visible = sSection.EqualsAny({SectionSearch})
        btnSearch.Visible = sSection.EqualsAny({SectionSearch})
        instructionTextUseTheFollowing.Visible = sSection.EqualsAny({SectionSearch})
        searchResults.Visible = sSection.EqualsAny({SectionSearchFilterSummary, SectionSearchResults})
        'btnNewSearch.Visible = sSection.EqualsAny({SectionSearchFilterSummary, SectionSearchResults})
        instructionTextSelectARow.Visible = sSection.EqualsAny({SectionSearchFilterSummary, SectionSearchResults})
        Dim oComm As clsCommon = New clsCommon()
        oComm.EnableForm(searchForm, sSection.EqualsAny({SectionSearch}))
        'EnableSearchControls(sSection.EqualsAny({SectionSearch}))

    End Sub

#End Region

    Protected Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click

        If ValidateForSearch() Then
            'hdgSearch.Visible = True
            'hdgSearchCriteria.Visible = True
            FillDiseaseList(bRefresh:=True)
            ' btnShowSearchCriteria.Visible = True
            showSearchCriteria(True)
            searchResults.Visible = True
            btnPrint.Visible = True
            btnCancelSearchResults.Visible = True
            btnCancelSearch.Visible = False
            'ToggleVisibility(SectionSearchResults)
            MultiView1.ActiveViewIndex = 1
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "accordionHide", "$('#collapseOne').collapse('hide');$('#collapseTwo').collapse('hide');", True)
            uppPersonSearch.Update()
        End If

    End Sub

    Protected Sub btnAddNewClick()

        ViewState(CALLER) = CallerPages.Dashboard
        oCommon.SaveViewState(ViewState)

        Response.Redirect(GetURL(CallerPages.HumanDiseaseReportURL), True)

    End Sub








    Private Sub gvDisease_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvDisease.Sorting

        SortGrid(e, CType(sender, GridView), "dsDisease")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "accordionHide", "$('#collapseOne').collapse('hide');$('#collapseTwo').collapse('hide');$('#collapseThree').collapse('show');", True)
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
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "accordionHide", "$('#collapseOne').collapse('hide');$('#collapseTwo').collapse('hide');", True)
    End Sub

    Private Function SetSortDirection(ByVal e As GridViewSortEventArgs) As String

        Dim dir As String
        Dim lastCol As String = String.Empty
        If Not IsNothing(ViewState("peoCol")) Then lastCol = ViewState("peoCol").ToString()

        If lastCol = e.SortExpression Then
            If ViewState("peoDir") = "0" Then
                dir = "DESC"
                ViewState("peoDir") = SortDirection.Descending
            Else
                dir = "ASC"
                ViewState("peoDir") = SortDirection.Ascending
            End If
        Else
            dir = "ASC"
            ViewState("peoDir") = SortDirection.Ascending
        End If
        ViewState("peoCol") = e.SortExpression
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "accordionHide", "$('#collapseOne').collapse('hide');$('#collapseTwo').collapse('hide');$('#collapseThree').collapse('show');", True)
        Return dir

    End Function




    Protected Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click
        Dim clsComm As New clsCommon()
        clsComm.ResetForm(searchForm)
        Dim allTxt As New List(Of Control)
        Dim allDD As New List(Of Control)
        For Each txt As TextBox In FindControlRecursive(allTxt, Me, GetType(TextBox))
            txt.Text = ""
        Next
        For Each dd As DropDownList In FindControlRecursive(allDD, Me, GetType(DropDownList))
            dd.SelectedIndex = 0
        Next
        DateOfSymptomsOnsetTxt.Text = ""
        DateOfFinalCaseClassificationTxt.Text = ""
        DiagnosisDateFromTxt.Text = ""
        DiagnosisDateToTxt.Text = ""
        NotificationDateTxt.Text = ""
        uppPersonSearch.Update()
    End Sub



    Public Shared Function FindControlRecursive(ByVal list As List(Of Control), ByVal parent As Control, ByVal ctrlType As System.Type) As List(Of Control)
        If parent Is Nothing Then Return list
        If parent.GetType Is ctrlType Then
            list.Add(parent)
        End If
        For Each child As Control In parent.Controls
            FindControlRecursive(list, child, ctrlType)
        Next
        Return list
    End Function




    'Protected Sub btnEditSearch_Click(sender As Object, e As EventArgs) Handles btnEditSearch.Click
    '    EnableSearchControls(True)
    '    ToggleVisibility(SectionSearch)
    '    btnEditSearch.Visible = False
    'End Sub

    'Protected Sub btnNewSearch_Click(sender As Object, e As EventArgs) Handles btnNewSearch.Click
    '    ClearSearch()
    '    EnableSearchControls(True)
    '    ToggleVisibility(SectionSearch)
    '    btnEditSearch.Visible = False
    'End Sub

    Protected Sub searchCriteria_Changed(sender As Object, e As EventArgs) Handles txtSearchStrCaseId.TextChanged, ddlSearchIdfsHospitalizationStatus.SelectedIndexChanged, ddlSearchCaseClassification.SelectedIndexChanged, ddlSearchDiagnosis.SelectedIndexChanged, ddlSearchReportStatus.SelectedIndexChanged

        searchResults.Visible = False
        'hdgSearch.Visible = True
        'hdgSearchCriteria.Visible = False
        searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
        btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
        btnShowSearchCriteria.Visible = False

    End Sub

    Protected Sub btnDeleteHDR_Click(sender As Object, e As EventArgs) Handles btnDeleteHDR.ServerClick
        Try
            Dim list = New List(Of HumHumanDiseaseDelModel)()

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            list = HumanAPIService.DeleteHumanDisease(GetCurrentLanguage(), Long.Parse(hdfidfHumanCase.Value.ToString)).Result

            'Dim oHDR As clsDisease = New clsDisease()
            'oHDR.DeleteDisease(hdfidfHumanCase.Value, String.Empty)
            FillDiseaseList(bRefresh:=True)
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Human_Disease_Report_Deleted_Successfully.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ $('#successVSS').modal('show');});", True)
        Catch ex As Exception
            lblErr.InnerText = GetLocalResourceObject("lbl_Page_Error.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ $('#errorVSS').modal('show');});", True)
        End Try
    End Sub

    Protected Sub deleteHumanDisease()
        Try
            Dim list = New List(Of HumHumanDiseaseDelModel)()

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            list = HumanAPIService.DeleteHumanDisease(GetCurrentLanguage(), Long.Parse(hdfidfHumanCase.Value.ToString)).Result

            'Dim oHDR As clsDisease = New clsDisease()
            'oHDR.DeleteDisease(hdfidfHumanCase.Value, String.Empty)
            FillDiseaseList(bRefresh:=True)
            lblSuccess.InnerText = GetLocalResourceObject("lbl_Human_Disease_Report_Deleted_Successfully.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ $('#successVSS').modal('show');});", True)
        Catch ex As Exception
            lblErr.InnerText = GetLocalResourceObject("lbl_Page_Error.InnerText")
            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ $('#errorVSS').modal('show');});", True)
        End Try
    End Sub

#Region "Gridview"

    Protected Sub populateGridView()

        'Dim idx As Integer = gvPeople.SelectedIndex

        'hdfidfHumanActual.Value = gvPeople.DataKeys(idx).Value.ToString()

        FillDiseaseList()
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "accordionHide", "$('#collapseOne').collapse('hide');$('#collapseTwo').collapse('hide');", True)
        gridUpdatePanel.Update()
    End Sub


    Protected Sub gvDisease_SelectedIndexChanged(sender As Object, e As EventArgs) Handles gvDisease.SelectedIndexChanged

        Dim idx As Integer = gvDisease.SelectedIndex

        'ucSearchPerson.GetPersonRecord(idx)

        Session("idfHumanCase") = gvDisease.DataKeys(idx).Values(0).ToString() 'gives the id of the Human Case
            ViewState(CALLER_KEY) = gvDisease.DataKeys(idx).Values(1).ToString()   'gives the id of the Human
            Session("hdfidfHumanActual") = gvDisease.DataKeys(idx).Values(2).ToString()   'gives the id of the HumanActual
            ViewState(CALLER) = CallerPages.SearchDiseaseReports
            oCommon.SaveViewState(ViewState)

        'Response.Redirect(GetURL(CallerPages.HumanDiseaseReportURL), True)
        Response.Redirect(GetURL(CallerPages.HumanDiseaseReportPreviewURL), True)
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "resultgridShow", "ShowResults();", True)
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "accordionHide", "$('#collapseOne').collapse('hide');$('#collapseTwo').collapse('hide');", True)
        gridUpdatePanel.Update()
    End Sub


    Protected Sub gvDisease_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvDisease.PageIndexChanging
        gvDisease.PageIndex = e.NewPageIndex
        FillDiseaseList(sGetDataFor:="PAGE", bRefresh:="True")
        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "resultgridShow", "ShowResults();", True)
        gridUpdatePanel.Update()
    End Sub

    Protected Sub gvDisease_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvDisease.RowCommand
        Try

            If e.CommandName.ToString = "selectPerson" Then
                Dim idx As Integer = e.CommandArgument

                Session("HumanMasterID") = gvDisease.DataKeys(idx).Values(0).ToString() 'gives the idfHumanActual of the Person
                ViewState(CALLER_KEY) = gvDisease.DataKeys(idx).Values(2).ToString() 'gives the idfHumanActual of the Person
                ViewState(CALLER) = CallerPages.SearchDiseaseReports_SelectPerson
                oCommon.SaveViewState(ViewState)

                Response.Redirect(GetURL(CallerPages.PersonURL), True)

            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
        gridUpdatePanel.Update()
    End Sub
    Protected Sub gvDisease_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvDisease.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim btnSelect As LinkButton = e.Row.FindControl("btnSelect")
            Dim btnSelectPerson As LinkButton = e.Row.FindControl("btnSelectPerson")
            Dim lblstrCaseID As Label = e.Row.FindControl("lblstrCaseID")
            Dim lblLegacyCaseID As Label = e.Row.FindControl("lblLegacyCaseID")
            If Not IsNothing(btnSelect) And Not IsNothing(lblstrCaseID) Then
                If ViewState(CALLER) <> CallerPages.Dashboard Then
                    btnSelect.Visible = True
                    lblstrCaseID.Visible = False
                Else
                    btnSelect.Visible = False
                    lblstrCaseID.Visible = True
                End If
            End If

            If Not IsNothing(lblLegacyCaseID) Then
                lblLegacyCaseID.Visible = True

            Else
                lblLegacyCaseID.Visible = False
            End If

            If divSearchLegacyCaseID.Visible = False Then
                gvDisease.Columns(1).Visible = False
            End If
        End If
        gridUpdatePanel.Update()
    End Sub

    Protected Sub gvDisease_RowEditing(sender As Object, e As GridViewEditEventArgs) Handles gvDisease.RowEditing

        e.Cancel = True
        Dim idx As Integer = e.NewEditIndex
        Session("idfHumanCase") = gvDisease.DataKeys(idx).Values(0).ToString() 'gives the id of the Human Case
        ViewState(CALLER_KEY) = gvDisease.DataKeys(idx).Values(1).ToString()   'gives the id of the Human
        Session("hdfidfHumanActual") = gvDisease.DataKeys(idx).Values(2).ToString()   'gives the id of the HumanActual
        ViewState(CALLER) = CallerPages.SearchDiseaseReports
        oCommon.SaveViewState(ViewState)

        Response.Redirect(GetURL(CallerPages.HumanDiseaseReportURL), True)

    End Sub

    Protected Sub gvDisease_RowDeleting(sender As Object, e As GridViewDeleteEventArgs) Handles gvDisease.RowDeleting
        hdfDeleteSessionFromSearchResults.Value = True
        hdfidfHumanCase.Value = gvDisease.DataKeys(e.RowIndex).Values(0).ToString()
        hdfidfHuman.Value = gvDisease.DataKeys(e.RowIndex).Values(1).ToString()
        hdfidfHumanActual.Value = gvDisease.DataKeys(e.RowIndex).Values(2).ToString()
        deleteHumanDisease()
        'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "DeleteModalScript", "$(function(){ $('#" & deleteHDR.ClientID & "').modal('show');});", True)
        'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(function(){ $('#deleteHDR').modal('show');});", True)
        gridUpdatePanel.Update()
    End Sub

    Private Sub FillDiseaseList(Optional sGetDataFor As String = "GRIDROWS", Optional bRefresh As Boolean = False)

        Try
            Dim dsDisease As DataSet
            'Dim list = New List(Of HumDiseaseReportGetListModel)()
            Dim advancedList = New List(Of HumDiseaseAdvanceSearchReportGetListModel)()
            Dim parameters As New HumanDiseaseReportGetListParams() With {.LanguageID = GetCurrentLanguage()}
            Dim advancedSearchParameters As New HumanDiseaseAdvanceSearchParams() With {.languageId = GetCurrentLanguage()}

            'Save the data set in view state to re-use
            If bRefresh Then ViewState("dsDisease") = Nothing

            'If IsNothing(ViewState("dsDisease")) Then
            If bRefresh = True Then

                If HumanAPIService Is Nothing Then
                    HumanAPIService = New HumanServiceClient()
                End If

                If DateOfSymptomsOnsetTxt.Text = "" Then
                    advancedSearchParameters.dateOfSymptomsOnset = Nothing
                Else
                    advancedSearchParameters.dateOfSymptomsOnset = Convert.ToDateTime(DateOfSymptomsOnsetTxt.Text)
                End If

                If DateOfFinalCaseClassificationTxt.Text = "" Then
                    advancedSearchParameters.dateOfFinalCaseClassification = Nothing
                Else
                    advancedSearchParameters.dateOfFinalCaseClassification = Convert.ToDateTime(DateOfFinalCaseClassificationTxt.Text)

                End If
                If NotificationDateTxt.Text = "" Then
                    advancedSearchParameters.notificationDate = Nothing
                Else
                    advancedSearchParameters.notificationDate = Convert.ToDateTime(NotificationDateTxt.Text)
                End If

                If DiagnosisDateFromTxt.Text = "" Then
                    advancedSearchParameters.diagnosisDateFrom = Nothing
                Else
                    advancedSearchParameters.diagnosisDateFrom = Convert.ToDateTime(DiagnosisDateFromTxt.Text)
                End If

                If DiagnosisDateToTxt.Text = "" Then
                    advancedSearchParameters.diagnosisDatTo = Nothing
                Else
                    advancedSearchParameters.diagnosisDatTo = Convert.ToDateTime(DiagnosisDateToTxt.Text)
                End If







                If LocalSampleIdTxt.Text = "" Then
                    advancedSearchParameters.localSampleId = Nothing
                Else
                    advancedSearchParameters.localSampleId = LocalSampleIdTxt.Text
                End If

                If LocationOfExposureRayonDD.SelectedIndex > 0 Then
                    advancedSearchParameters.locationOfExposureRayon = If(String.IsNullOrEmpty(LocationOfExposureRayonDD.SelectedValue), Nothing, LocationOfExposureRayonDD.SelectedValue)
                Else
                    advancedSearchParameters.locationOfExposureRayon = Nothing

                End If
                If LocationOfExposureRegionDD.SelectedIndex > 0 Then
                    advancedSearchParameters.locationOfExposureRegion = If(String.IsNullOrEmpty(LocationOfExposureRegionDD.SelectedValue), Nothing, LocationOfExposureRegionDD.SelectedValue)
                Else
                    advancedSearchParameters.locationOfExposureRegion = Nothing

                End If



                If RayonDD.SelectedIndex > 0 Then
                    advancedSearchParameters.rayonId = If(String.IsNullOrEmpty(RayonDD.SelectedValue), Nothing, RayonDD.SelectedValue)
                Else
                    advancedSearchParameters.rayonId = Nothing

                End If
                If LocationOfExposureRegionDD.SelectedIndex > 0 Then
                    advancedSearchParameters.regionId = If(String.IsNullOrEmpty(RegionDD.SelectedValue), Nothing, RegionDD.SelectedValue)
                Else
                    advancedSearchParameters.regionId = Nothing

                End If













                If SentByFacilityDD.SelectedIndex > 0 Then
                    advancedSearchParameters.sentByFacility = If(String.IsNullOrEmpty(SentByFacilityDD.SelectedValue), Nothing, SentByFacilityDD.SelectedValue)
                Else
                    advancedSearchParameters.sentByFacility = Nothing
                End If

                If RecievedByFacilityDD.SelectedIndex > 0 Then
                    advancedSearchParameters.receivedByFacility = If(String.IsNullOrEmpty(RecievedByFacilityDD.SelectedValue), Nothing, RecievedByFacilityDD.SelectedValue)
                Else
                    advancedSearchParameters.receivedByFacility = Nothing
                End If




                advancedSearchParameters.eidssReportId = If(String.IsNullOrEmpty(txtSearchStrCaseId.Text), Nothing, txtSearchStrCaseId.Text)
                advancedSearchParameters.legacyId = If(String.IsNullOrEmpty(txtSearchLegacyCaseID.Text), Nothing, txtSearchLegacyCaseID.Text)

                If ddlSearchDiagnosis.SelectedIndex > 0 Then
                    advancedSearchParameters.diseaseId = If(String.IsNullOrEmpty(ddlSearchDiagnosis.SelectedValue), Nothing, ddlSearchDiagnosis.SelectedValue)
                Else
                    advancedSearchParameters.diseaseId = Nothing

                End If

                If ddlSearchReportStatus.SelectedIndex > 0 Then
                    advancedSearchParameters.reportStatusTypeId = ddlSearchReportStatus.SelectedValue
                Else
                    advancedSearchParameters.reportStatusTypeId = Nothing
                End If

                advancedSearchParameters.patientFirstOrGivenName = If(String.IsNullOrEmpty(txtSearchStrPersonFirstName.Text), Nothing, txtSearchStrPersonFirstName.Text)
                advancedSearchParameters.patientMiddleName = If(String.IsNullOrEmpty(txtSearchStrPersonMiddleName.Text), Nothing, txtSearchStrPersonMiddleName.Text)
                advancedSearchParameters.patientLastOrSurname = If(String.IsNullOrEmpty(txtSearchStrPersonLastName.Text), Nothing, txtSearchStrPersonLastName.Text)

                If Not String.IsNullOrEmpty(txtSearchHDRDateEnteredFrom.Text) Then
                    advancedSearchParameters.dateEnteredFrom = If(String.IsNullOrEmpty(txtSearchHDRDateEnteredFrom.Text), Nothing, Convert.ToDateTime(txtSearchHDRDateEnteredFrom.Text))
                End If

                If Not String.IsNullOrEmpty(txtSearchHDRDateEnteredTo.Text) Then
                    parameters.HumanDiseaseReportDateEnteredTo = If(String.IsNullOrEmpty(txtSearchHDRDateEnteredTo.Text), Nothing, Convert.ToDateTime(txtSearchHDRDateEnteredTo.Text))
                End If

                If ddlSearchCaseClassification.SelectedIndex > 0 Then
                    advancedSearchParameters.classificationTypeId = If(String.IsNullOrEmpty(ddlSearchCaseClassification.SelectedValue), Nothing, ddlSearchCaseClassification.SelectedValue)
                Else
                    advancedSearchParameters.classificationTypeId = Nothing
                End If

                If ddlSearchIdfsHospitalizationStatus.SelectedIndex > 0 Then
                    advancedSearchParameters.hospitalizationStatusTypeId = ddlSearchIdfsHospitalizationStatus.SelectedValue
                Else
                    advancedSearchParameters.hospitalizationStatusTypeId = Nothing

                End If


                Dim controls As New List(Of Control)
                controls.Clear()


                parameters.PaginationSetNumber = 1 'needs to account for additonal pagination sets; recommend user control in place.

                advancedSearchParameters.paginationSet = 1
                advancedSearchParameters.pageSize = 10
                advancedSearchParameters.maxPagesPerFetch = 1000

                Dim savedterms = String.Empty
                If ViewState("terms") IsNot Nothing Then

                    savedterms = CType(ViewState("terms"), String)



                End If
                Dim terms = Newtonsoft.Json.JsonConvert.SerializeObject(advancedSearchParameters)
                If savedterms = terms Then
                    If ViewState("resultSet") IsNot Nothing Then

                        Dim serializedResultSet = CType(ViewState("resultSet"), String)
                        advancedList = Newtonsoft.Json.JsonConvert.DeserializeObject(Of List(Of HumDiseaseAdvanceSearchReportGetListModel))(serializedResultSet)
                    End If
                Else
                    gvDisease.DataSource = Nothing
                    advancedList = HumanAPIService.GetHumanDiseaseAdvanceSearchReportListAsync(advancedSearchParameters).Result
                    ViewState.Add("resultSet", Newtonsoft.Json.JsonConvert.SerializeObject(advancedList))
                    ViewState.Add("terms", terms)
                End If







            Else
                dsDisease = CType(ViewState("dsDisease"), DataSet)
            End If




            gvDisease.DataSource = advancedList
            gvDisease.DataBind()



            ' End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub



#End Region




    Private Sub DisplayPersonValidationErrors()

        'Paint all SideBarItems as Passed Validation and then correct those that failed
        'sidebaritem_personInfo.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid
        'sidebaritem_PersonAddress.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsValid

        'Dim oValidator As IValidator
        'For Each oValidator In Validators
        '    If oValidator.IsValid = False Then

        '        Dim failedValidator As RequiredFieldValidator = oValidator
        '        Dim ctrl As Control = failedValidator
        '        Dim section As HtmlGenericControl = Nothing

        '        While (section Is Nothing)

        '            ctrl = ctrl.Parent
        '            section = TryCast(ctrl, HtmlGenericControl)
        '            Try
        '                Select Case section.ID
        '                    Case "personInformation"
        '                        sidebaritem_personInfo.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
        '                        sidebaritem_personInfo.CssClass = "glyphicon glyphicon-remove"
        '                    Case "personalAddress"
        '                        sidebaritem_PersonAddress.ItemStatus = EIDSSControlLibrary.SideBarStatus.IsInvalid
        '                        sidebaritem_PersonAddress.CssClass = "glyphicon glyphicon-remove"
        '                    Case Else
        '                        section = Nothing
        '                End Select
        '            Catch e As Exception
        '            End Try

        '        End While
        '    End If
        'Next

    End Sub

    Private Sub showSearchCriteria(ByVal show As Boolean)
        If show Then
            '  searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
            '  btnSearch.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "block")
            btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-top header-button")
        Else
            ' searchCriteria.Attributes.CssStyle.Add(HtmlTextWriterStyle.Display, "none")
            ' btnShowSearchCriteria.Attributes.Add("class", "glyphicon glyphicon-triangle-bottom header-button")
        End If
    End Sub

    Protected Sub CancelModelSearchBtn_Click(sender As Object, e As EventArgs)
        MultiView1.ActiveViewIndex = 0
        uppPersonSearch.Update()
    End Sub
End Class