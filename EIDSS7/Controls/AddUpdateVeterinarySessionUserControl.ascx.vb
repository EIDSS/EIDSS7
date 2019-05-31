Imports EIDSS.EIDSS
Imports EIDSS.NG
Imports EIDSSControlLibrary

Public Class AddUpdateVeterinarySessionUserControl
    Inherits System.Web.UI.UserControl

    Public sFile As String

    Private Const SESSION_INFO_PREFIX As String = "_CInfo"
    Private Const SESSION_TABLE_PREFIX As String = "_CTable"
    Private Const FARM_SEARCH_PREFIX As String = "_FRM"

    Private Const SORT_COL As String = "vsCol"
    Private Const SORT_DIR As String = "vsDir"

    Private Const CALLER_INFO As String = "CallerInfo"
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"
    Private Const RETURN_KEY As String = "ReturnKey"
    Private Const SEARCH_FARM_TYPE As String = "SearchFarmType"

    Private Const SectionSessionInformation As String = "Session Information"
    Private Const SectionSpeciesAndSample As String = "Species and Sample"
    Private Const SectionFarmHerdSpecies As String = "Farm-Herd/Flock-Species"
    Private Const SectionDetailedAnimalsAndSamples As String = "Detailed Animals and Samples"
    Private Const SectionDetailedAnimalAndSample As String = "Detailed Animal and Sample"
    Private Const SectionTestsResultSummaries As String = "Tests/Result Summaries"
    Private Const SectionTest As String = "Test"
    Private Const SectionResultSummary As String = "Result Summary"
    Private Const SectionActions As String = "Actions"
    Private Const SectionAction As String = "Action"
    Private Const SectionAggregateInfos As String = "Aggregate Infos"
    Private Const SectionAggregateInfo As String = "Aggregate Info"
    Private Const SectionDiseaseReports As String = "Disease Reports"
    Private Const SectionDeleteSession As String = "Delete Session"

    Private Const SESSION_DATASET As String = "dsSessions"
    Private Const DISEASE_TO_SPECIES_DATASET As String = "dsDiseaseToSpecies"
    Private Const SPECIES_AND_SAMPLES_DATASET As String = "dsSpeciesAndSamples"
    Private Const HERD_SPECIES_DATASET As String = "dsFarmHerdsSpecies"
    Private Const ANIMAL_DATASET As String = "dsAnimals"
    Private Const SAMPLE_DATASET As String = "dsSamples"
    Private Const TEST_DATASET As String = "dsTests"
    Private Const INTERPRETATION_DATASET As String = "dsInterpretations"
    Private Const ACTION_DATASET As String = "dsActions"
    Private Const AGGREGATE_INFO_DATASET As String = "dsAggregateInfo"
    Private Const VETERINARY_DISEASE_REPORT_DATASET As String = "dsVeterinaryDiseaseReports"
    Private Const MONITORING_SESSION_DATATABLE As String = "dtMonitoringSession"

    Private Const CAMPAIGN_OBJECT As String = "CampaignObject"

    Private Const FARM_HERD_SPECIES_GET_LIST_SP As String = "FarmHerdSpeciesGetList"
    Private Const ANIMAL_GET_LIST_SP As String = "AnimalGetList"
    Private Const SURVEILLANCE_SESSION_GET_LIST_SP As String = "VetActiveSurvMonitoringSessionGetList"
    Private Const SURVEILLANCE_SESSION_GET_DETAIL_SP As String = "VetActiveSurvMonitoringSessionGetDetail"
    Private Const SURVEILLANCE_SESSION_SET_SP As String = "VetActiveSurvMonitoringSessionSet"
    Private Const SURVEILLANCE_SESSION_TO_SAMPLE_TYPE_GET_LIST_SP As String = "VetActiveSurvMonitoringSessionToSampleTypeGetList"
    Private Const SURVEILLANCE_SESSION_DEL_SP As String = "VetActiveSurvMonitoringSessionDelete"
    Private Const SAMPLE_GET_LIST_SP As String = "SampleGetList"
    Private Const TEST_GET_LIST_SP As String = "TestingGetList"
    Private Const INTERPRETATION_GET_LIST_SP As String = "TestValidationGetList"
    Private Const ACTION_GET_LIST_SP As String = "VetActiveSurvMonitoringSessionActionGetList"
    Private Const AGGREGATE_INFO_GET_LIST_SP As String = "VetActiveSurvMonitoringSessionSummaryGetList"
    Private Const VETERINARY_DISEASE_REPORT_GET_LIST_SP As String = "VetDiseaseGetList"
    Private Const BASE_REFERENCE_LOOKUP_GET_LIST_SP As String = "BaseReferenceLookup"
    Private Const DISEASE_TYPE_GET_LOOKUP_SP As String = "DiseaseTypeLookup"

    Private Const MODAL_KEY As String = "Modal"
    Private Const MODAL_ON_MODAL_KEY As String = "ModalOnModal"

    Private Const SHOW_SPECIES_AND_SAMPLE_MODAL As String = "showSpeciesAndSampleModal();"
    Private Const HIDE_SPECIES_AND_SAMPLE_MODAL As String = "hideSpeciesAndSampleModal();"
    Private Const SHOW_SAMPLE_MODAL As String = "showSampleModal();"
    Private Const HIDE_SAMPLE_MODAL As String = "hideSampleModal();"
    Private Const SHOW_TEST_MODAL As String = "showTestModal();"
    Private Const HIDE_TEST_MODAL As String = "hideTestModal();"
    Private Const SHOW_RESULT_SUMMARY_MODAL As String = "showResultSummaryModal();"
    Private Const HIDE_RESULT_SUMMARY_MODAL As String = "hideResultSummaryModal();"
    Private Const SHOW_ACTION_MODAL As String = "showActionModal();"
    Private Const HIDE_ACTION_MODAL As String = "hideActionModal();"
    Private Const SHOW_AGGREGATE_INFO_MODAL As String = "showAggregateInfoModal();"
    Private Const HIDE_AGGREGATE_INFO_MODAL As String = "hideAggregateInfoModal();"
    Private Const SHOW_ADD_UPDATE_FARM_MODAL As String = "showAddUpdateFarmModal();"
    Private Const HIDE_ADD_UPDATE_FARM_MODAL As String = "hideAddUpdateFarmModal();"
    Private Const SHOW_SEARCH_PERSON_MODAL As String = "showSearchPersonModal();"
    Private Const HIDE_SEARCH_PERSON_MODAL As String = "hideSearchPersonModal();"
    Private Const HIDE_SEARCH_PERSON_SHOW_ADD_UPDATE_PERSON_MODALS As String = "hideSearchPersonModalShowAddUpdatePersonModal();"
    Private Const SHOW_ADD_UPDATE_PERSON_MODAL As String = "showAddUpdatePersonModal();"
    Private Const HIDE_ADD_UPDATE_PERSON_MODAL As String = "hideAddUpdatePersonModal();"

    Private CampaignObject As clsVASCampaign = New clsVASCampaign

    Public Event ShowWarningModal(messageType As MessageType, isConfirm As Boolean, message As String)
    Public Event CreateVeterinarySessionRecord(veterinarySessionID As Long, sessionCode As String, message As String)
    Public Event UpdateVeterinarySessionRecord(veterinarySessionID As Long, sessionCode As String, message As String)
    Public Event EditVeterinarySessionRecord(veterinarySessionID As Long)

    Private oCommon As clsCommon = New clsCommon()

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        txtTestdatConcludedDate.MaxDate = DateTime.Today
        txtSampledatFieldCollectionDate.MaxDate = DateTime.Today

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            If (Not IsPostBack) Then
                divVeterinaryActiveSurveillanceSessionForm.Visible = True
                Dim allCtrl As New List(Of Control)
                allCtrl.Clear()
                For Each ddl As EIDSSControlLibrary.DropDownList In oCommon.FindCtrl(allCtrl, MonitoringSessionAddress, GetType(EIDSSControlLibrary.DropDownList))
                    If ddl.ClientID.Contains("ddlMonitoringSessionAddressidfsRegion") = True Or
                        ddl.ClientID.Contains("ddlMonitoringSessionAddressidfsRayon") = True Or
                        ddl.ClientID.Contains("ddlMonitoringSessionAddressidfsSettlement") = True Then
                        ScriptManager.GetCurrent(Page).RegisterAsyncPostBackControl(ddl)
                    End If
                Next
                divVeterinaryActiveSurveillanceSessionForm.Visible = False
                txtstrMonitoringSessionID.Enabled = False
                ddlidfsMonitoringSessionStatus.Enabled = False
                txtdatEnteredDate.Enabled = False
                txtPersonEnteredByName.Enabled = False
                txtSiteName.Enabled = False
                txtstrCampaignName.Enabled = False
                ddlidfsCampaignType.Enabled = False
                btnAddSpeciesAndSample.Disabled = False
                txtstrCampaignID.Enabled = False
            End If

            If (hdfidfMonitoringSession.Value = -1) Then
                VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Remove(sbiFarmHerdSpecies)
                VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Remove(sbiDetailedAnimalsAndSamples)
                VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Remove(sbiTestInformation)
                VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Remove(sbiActions)
                VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Remove(sbiAggregateInfo)
                VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Remove(sbiDiseaseReports)
            End If
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub MonitoringSessionAddress_Load() Handles MonitoringSessionAddress.Load

        Try
            'The location user control has not completed loading with the page load, so some logic is called again
            'to account for its controls.
            Dim ddl As System.Web.UI.WebControls.DropDownList = CType(Me.MonitoringSessionAddress.FindControl("ddlMonitoringSessionAddressidfsRegion"), System.Web.UI.WebControls.DropDownList)
            ddl.Enabled = False
            ddl = CType(Me.MonitoringSessionAddress.FindControl("ddlMonitoringSessionAddressidfsRayon"), System.Web.UI.WebControls.DropDownList)
            ddl.Enabled = False
            ddl = CType(Me.MonitoringSessionAddress.FindControl("ddlMonitoringSessionAddressidfsSettlement"), System.Web.UI.WebControls.DropDownList)
            ddl.Enabled = False
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Public Sub Setup(initialPanelID As Integer, Optional selectedUserAction As String = UserAction.Insert, Optional sessionID As Long = Nothing, Optional campaignID As Long = Nothing)

        Reset()

        Select Case selectedUserAction
            Case UserAction.Insert
                'btnAddSelectablePreviewHumanDiseaseReport.Visible = False
                divVeterinaryActiveSurveillanceSessionForm.Visible = False
                hdfidfMonitoringSession.Value = -1
                txtdatEnteredDate.Text = DateTime.Today.ToShortDateString()
                txtPersonEnteredByName.Text = hdfstrUserName.Value
                txtSiteName.Text = hdfstrLoginOrganization.Value
                txtstrMonitoringSessionID.Text = "(new)"
                FillForm(edit:=True)
                ToggleVisibility(SectionSessionInformation)
                hdfidfMonitoringSession.Value = "-1"
                hdfMonitoringSessionidfsCountry.Value = ConfigurationManager.AppSettings("CountryID")
            Case UserAction.Read
                FillForm(edit:=False)
                btnSubmit.Visible = False
                VeterinaryActiveSurveillanceSessionSideBarPanel.Visible = False
            Case UserAction.Update
                FillDropDowns()
                FillForm(edit:=True)
                ToggleVisibility(SectionSessionInformation)
                txtstrMonitoringSessionID.Enabled = False
                txtdatEnteredDate.Enabled = False
                txtPersonEnteredByName.Enabled = False
                txtSiteName.Enabled = False
                txtstrCampaignID.Enabled = False
                ddlidfsCampaignType.Enabled = False

                btnAddSpeciesAndSample.Disabled = False

                If hdfidfCampaign.Value <> String.Empty Then
                    oCommon.EnableForm(ddlidfsDiagnosis, False)
                    oCommon.EnableForm(btnAddSpeciesAndSample, True)
                    'If Session is tied to a Campaign, then Country should not be enabled to prevent editing.
                    If (hdfidfCampaign.Value <> "-1") Then
                        Dim dCountry As DropDownList = MonitoringSessionAddress.FindControl("ddlMonitoringSessionAddressidfsCountry")
                        If Not dCountry Is Nothing Then
                            dCountry.Enabled = False
                        End If
                    End If
                End If

                btnAddSpeciesAndSample.Disabled = False

                If hdfMonitoringSessionidfsCountry.Value.IsValueNullOrEmpty = True Then
                    hdfMonitoringSessionidfsCountry.Value = ConfigurationManager.AppSettings("CountryID")
                End If
            Case UserAction.Delete
                FillDropDowns()
                ToggleVisibility(SectionDeleteSession)
                oCommon.EnableForm(divVeterinaryActiveSurveillanceSessionForm, False)
                FillForm(edit:=False)
                oCommon.EnableForm(btnDelete, True)
                oCommon.EnableForm(btnCancel, True)
        End Select

    End Sub

    Private Sub Reset()

        ExtractViewStateSession()

        FillDropDowns()

        oCommon.ResetForm(divVeterinaryActiveSurveillanceSessionForm)

    End Sub

#Region "Common Methods"

    'Used to retrieve saved viewstate file
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

        'Containers
        divVeterinaryActiveSurveillanceSessionForm.Visible = sSection.EqualsAny({SectionSessionInformation, SectionDeleteSession, SectionSpeciesAndSample, SectionFarmHerdSpecies, SectionDetailedAnimalsAndSamples, SectionDetailedAnimalAndSample, SectionTestsResultSummaries, SectionTest, SectionResultSummary, SectionActions, SectionAction, SectionAggregateInfos, SectionAggregateInfo, SectionDiseaseReports})
        divSpeciesAndSampleForm.Visible = sSection.Equals(SectionSpeciesAndSample)
        divSampleForm.Visible = sSection.Equals(SectionDetailedAnimalAndSample)
        divTestForm.Visible = sSection.Equals(SectionTest)
        divResultSummaryForm.Visible = sSection.Equals(SectionResultSummary)
        divActionForm.Visible = sSection.Equals(SectionAction)
        divAggregateInfoForm.Visible = sSection.Equals(SectionAggregateInfo)

        If hdfidfMonitoringSession.Value = -1 Then
            VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Remove(sbiFarmHerdSpecies)
            VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Remove(sbiDetailedAnimalsAndSamples)
            VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Remove(sbiTestInformation)
            VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Remove(sbiActions)
            VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Remove(sbiAggregateInfo)
            VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Remove(sbiDiseaseReports)

            FarmHerdSpecies.Visible = False
            DetailedAnimalsAndSamples.Visible = False
            TestsResultSummaries.Visible = False
            Actions.Visible = False
            AggregateInfo.Visible = False
            DiseaseReports.Visible = False
        Else
            If VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Count = 2 Then
                VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Remove(sbiReview)
                VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Add(sbiFarmHerdSpecies)
                VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Add(sbiDetailedAnimalsAndSamples)
                VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Add(sbiTestInformation)
                VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Add(sbiActions)
                VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Add(sbiAggregateInfo)
                VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Add(sbiDiseaseReports)
                VeterinaryActiveSurveillanceSessionSideBarPanel.MenuItems.Add(sbiReview)

                FarmHerdSpecies.Visible = True
                DetailedAnimalsAndSamples.Visible = True
                TestsResultSummaries.Visible = True
                Actions.Visible = True
                AggregateInfo.Visible = True
                DiseaseReports.Visible = True
            End If
        End If

        'Buttons
        btnDelete.Visible = sSection.Equals(SectionDeleteSession)

        'Set focus to correct panel
        Select Case sSection
            Case SectionSessionInformation, SectionSpeciesAndSample
                hdfVeterinaryActiveSurveillanceSessionPanelController.Value = 0
            Case SectionFarmHerdSpecies
                hdfVeterinaryActiveSurveillanceSessionPanelController.Value = 1
            Case SectionDetailedAnimalsAndSamples, SectionDetailedAnimalAndSample
                hdfVeterinaryActiveSurveillanceSessionPanelController.Value = 2
            Case SectionTestsResultSummaries, SectionTest, SectionResultSummary
                hdfVeterinaryActiveSurveillanceSessionPanelController.Value = 3
            Case SectionActions, SectionAction
                hdfVeterinaryActiveSurveillanceSessionPanelController.Value = 4
            Case SectionAggregateInfos, SectionAggregateInfo
                hdfVeterinaryActiveSurveillanceSessionPanelController.Value = 5
            Case SectionDiseaseReports
                hdfVeterinaryActiveSurveillanceSessionPanelController.Value = 6
        End Select

    End Sub

    Private Function SetSortDirection(ByVal e As GridViewSortEventArgs) As String

        Dim dir As String
        Dim lastCol As String = String.Empty

        If Not IsNothing(ViewState(SORT_COL)) Then lastCol = ViewState(SORT_COL).ToString()

        If lastCol = e.SortExpression Then
            If ViewState(SORT_DIR) = "0" Then
                dir = SortConstants.Descending
                ViewState(SORT_DIR) = SortDirection.Descending
            Else
                dir = SortConstants.Ascending
                ViewState(SORT_DIR) = SortDirection.Ascending
            End If
        Else
            dir = SortConstants.Ascending
            ViewState(SORT_DIR) = SortDirection.Ascending
        End If
        ViewState(SORT_DIR) = e.SortExpression

        Return dir

    End Function

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

#End Region

#Region "Monitoring Session Methods"

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        Try
            Page.Validate()

            If (Page.IsValid) Then
                AddUpdateSession()

                FillForm(edit:=True)
                ToggleVisibility(SectionSessionInformation)
            Else
                DisplaySessionValidationErrors()
            End If
        Catch ae As System.Threading.ThreadAbortException
            'Response.End = True throws abort exception within Try/Catch.
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub lnbSearchCampaign_Click(sender As Object, e As EventArgs) Handles lnbSearchCampaign.Click

        Try
            oCommon.SaveSearchFields({divVeterinaryActiveSurveillanceSessionForm, divHiddenFieldsSection}, SURVEILLANCE_SESSION_GET_DETAIL_SP, oCommon.CreateTempFile(SESSION_INFO_PREFIX))

            ViewState(CALLER) = CallerPages.VeterinaryActiveSurveillanceMonitoringSession
            ViewState(CALLER_KEY) = hdfidfMonitoringSession.Value

            oCommon.SaveViewState(ViewState)

            Response.Redirect(GetURL(CallerPages.VeterinaryActiveSurveillanceCampaignURL), True)
        Catch ae As System.Threading.ThreadAbortException
            'Response.End = True throws abort exception within Try/Catch.
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click

        'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), MODAL_KEY, "$(function(){ $('#" & divCancelModalContainer.ClientID & "').modal('show');});", True)

    End Sub

    Private Sub ShowEditSessionWithNewFarm()

        'This subroutine is always called after the selection, or creation of a new farm. A view state was stored, so we need to pick it back up so that we can appened the new farm to any existing farms already added to the session
        'This helps with unsaved farms, on the session page.
        Try
            ViewState(HERD_SPECIES_DATASET) = oCommon.GetViewState(True, HERD_SPECIES_DATASET)
        Catch ex As Exception
            'Extraction from file failed, probably because it is coming from dashboard...when viewstate doesn't exist anymore.
        End Try

        'Populate disease with avian and livestock to determine the species and samples based on disease.
        Dim dsDiseaseToSpecies As DataSet = Nothing
        BaseReferenceLookUp(ddlidfsDiagnosis, BaseReferenceConstants.Diagnosis, (HACodeList.LivestockHACode + HACodeList.AvianHACode), True, dsDiseaseToSpecies)
        ViewState(DISEASE_TO_SPECIES_DATASET) = dsDiseaseToSpecies

        oCommon.GetSearchFields({divHiddenFieldsSection, divVeterinaryActiveSurveillanceSessionForm}, oCommon.CreateTempFile(SESSION_INFO_PREFIX))

        If ViewState(MONITORING_SESSION_DATATABLE).Rows(0)(CountryConstants.CountryID).ToString = "" Then
            MonitoringSessionAddress.LocationCountryID = Nothing
        Else
            MonitoringSessionAddress.LocationCountryID = CType(ViewState(MONITORING_SESSION_DATATABLE).Rows(0)(CountryConstants.CountryID), Long)
        End If

        If ViewState(MONITORING_SESSION_DATATABLE).Rows(0)(RegionConstants.RegionID).ToString = "" Then
            MonitoringSessionAddress.LocationRegionID = Nothing
        Else
            MonitoringSessionAddress.LocationRegionID = CType(ViewState(MONITORING_SESSION_DATATABLE).Rows(0)(RegionConstants.RegionID), Long)
        End If

        If ViewState(MONITORING_SESSION_DATATABLE).Rows(0)(RayonConstants.RayonID).ToString = "" Then
            MonitoringSessionAddress.LocationRayonID = Nothing
        Else
            MonitoringSessionAddress.LocationRayonID = CType(ViewState(MONITORING_SESSION_DATATABLE).Rows(0)(RayonConstants.RayonID), Long)
        End If

        If ViewState(MONITORING_SESSION_DATATABLE).Rows(0)(SettlementConstants.idfsSettlement).ToString = "" Then
            MonitoringSessionAddress.LocationSettlementID = Nothing
        Else
            MonitoringSessionAddress.LocationSettlementID = CType(ViewState(MONITORING_SESSION_DATATABLE).Rows(0)(SettlementConstants.idfsSettlement), Long)
        End If
        MonitoringSessionAddress.DataBind()

        FillDropDowns()
        FillForm(edit:=True)
        FillActions(refresh:=False)
        FillAggregateInfo(refresh:=False)
        FillResultSummaries(refresh:=False)
        FillSamples(refresh:=False)
        FillSpeciesAndSamples(refresh:=False)
        FillTests(refresh:=False)
        FillVeterinaryDiseaseReportsList(refresh:=False)

        hdfidfFarmActual.Value = ViewState(RETURN_KEY)
        hdfIdentity.Value = Session(RecordConstants.RecordID)
        Session.Remove(RecordConstants.RecordID)

        hdfAvianOrLivestock.Value = Session("LivestockOrAvian")
        Session.Remove("LivestockOrAvian")
        AddFarm()

        If (hdfidfFarmActual.Value = "-1") Then
            FillFarmHerdSpecies(refresh:=True, isRootFarm:=False)
        Else
            FillFarmHerdSpecies(refresh:=False, isRootFarm:=False)
        End If

        PopulateAvianLiveStock()
        ddlidfsDiagnosis_SelectedIndexChanged(Nothing, Nothing)
        ddlidfsDiagnosis.Enabled = False

        hdfVeterinaryActiveSurveillanceSessionPanelController.Value = 1

        ToggleVisibility(SectionFarmHerdSpecies)

    End Sub

    Protected Sub btnDelete_Click(sender As Object, e As EventArgs) Handles btnDelete.Click

        ViewState("Action") = "DeleteSession"
        RaiseEvent ShowWarningModal(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Nothing)

    End Sub

    Private Sub AddUpdateSession()

        Dim dsFarmHerdSpecies As DataSet = TryCast(ViewState(HERD_SPECIES_DATASET), DataSet)
        Dim dsAnimals As DataSet = TryCast(ViewState(ANIMAL_DATASET), DataSet)
        Dim dsSpeciesAndSamples As DataSet = TryCast(ViewState(SPECIES_AND_SAMPLES_DATASET), DataSet)
        Dim dsSamples As DataSet = TryCast(ViewState(SAMPLE_DATASET), DataSet)
        Dim dsActions As DataSet = TryCast(ViewState(ACTION_DATASET), DataSet)
        Dim dsTests As DataSet = TryCast(ViewState(TEST_DATASET), DataSet)
        Dim dsInterpretations As DataSet = TryCast(ViewState(INTERPRETATION_DATASET), DataSet)
        Dim dsAggregateInfos As DataSet = TryCast(ViewState(AGGREGATE_INFO_DATASET), DataSet)

        If hdfidfMonitoringSession.Value = -1 Then
            txtstrMonitoringSessionID.Text = "(new)"
        End If

        Dim parameters As String = oCommon.Gather(divVeterinaryActiveSurveillanceSessionForm, oCommon.GetSPList(SURVEILLANCE_SESSION_SET_SP)(0).ToString(), 3, True)
        parameters &= "|" & oCommon.Gather(divHiddenFieldsSection, oCommon.GetSPList(SURVEILLANCE_SESSION_SET_SP)(0).ToString(), 3, True)

        Dim dtFarm As DataTable = New DataTable
        If (dsFarmHerdSpecies.Tables(0).Rows.Count = 0) Then
            dtFarm = dsFarmHerdSpecies.Tables(0).Clone
        Else
            If (dsFarmHerdSpecies.Tables(0).Select(RecordConstants.RecordType & " = '" & HerdSpeciesConstants.Farm & "'").Length > 0) Then
                dtFarm = dsFarmHerdSpecies.Tables(0).Select(RecordConstants.RecordType & " = '" & HerdSpeciesConstants.Farm & "'").CopyToDataTable
            Else
                dtFarm = dsFarmHerdSpecies.Tables(0).Clone
            End If
        End If
        dtFarm.TableName = ActiveSurveillanceSessionConstants.Farms

        Dim dtHerd As DataTable = New DataTable
        If (dsFarmHerdSpecies.Tables(0).Rows.Count = 0) Then
            dtHerd = dsFarmHerdSpecies.Tables(0).Clone
        Else
            If (dsFarmHerdSpecies.Tables(0).Select(RecordConstants.RecordType & " = '" & HerdSpeciesConstants.Herd & "'").Length > 0) Then
                dtHerd = dsFarmHerdSpecies.Tables(0).Select(RecordConstants.RecordType & " = '" & HerdSpeciesConstants.Herd & "'").CopyToDataTable
            Else
                dtHerd = dsFarmHerdSpecies.Tables(0).Clone
            End If
        End If
        dtHerd.TableName = ActiveSurveillanceSessionConstants.Herds

        Dim dtSpecies As DataTable = New DataTable
        If (dsFarmHerdSpecies.Tables(0).Rows.Count = 0) Then
            dtSpecies = dsFarmHerdSpecies.Tables(0).Clone()
        Else
            If (dsFarmHerdSpecies.Tables(0).Select(RecordConstants.RecordType & " = '" & HerdSpeciesConstants.Species & "'").Length > 0) Then
                dtSpecies = dsFarmHerdSpecies.Tables(0).Select(RecordConstants.RecordType & " = '" & HerdSpeciesConstants.Species & "'").CopyToDataTable
            Else
                dtSpecies = dsFarmHerdSpecies.Tables(0).Clone
            End If
        End If
        dtSpecies.TableName = ActiveSurveillanceSessionConstants.Species

        Dim dtAnimal As DataTable = dsAnimals.Tables(0).Copy
        dtAnimal.TableName = ActiveSurveillanceSessionConstants.Animals
        Dim dtSpeciesAndSample As DataTable = dsSpeciesAndSamples.Tables(0).Copy
        dtSpeciesAndSample.TableName = ActiveSurveillanceSessionConstants.SpeciesAndSamples
        Dim dtSample As DataTable = dsSamples.Tables(0).Copy
        dtSample.TableName = ActiveSurveillanceSessionConstants.Samples
        Dim dtTest As DataTable = dsTests.Tables(0).Copy
        dtTest.TableName = ActiveSurveillanceSessionConstants.Tests
        Dim dtInterpretation As DataTable = dsInterpretations.Tables(0).Copy
        dtInterpretation.TableName = VeterinaryDiseaseReportConstants.Interpretations
        Dim dtAction As DataTable = dsActions.Tables(0).Copy
        dtAction.TableName = ActiveSurveillanceSessionConstants.Actions
        Dim dtAggregateInfo As DataTable = dsAggregateInfos.Tables(0).Copy
        dtAggregateInfo.TableName = ActiveSurveillanceSessionConstants.Summaries

        Dim oSession As New clsVeterinaryActiveSurveillanceMonitoringSession()
        Dim returnValues As Object() = Nothing
        Dim result = oSession.AddUpdateActiveSurveillanceMonitoringSession({parameters}, dtFarm, dtHerd, dtSpecies, dtAnimal, dtSpeciesAndSample, dtSample, dtTest, dtInterpretation, dtAction, dtAggregateInfo, returnValues)

        If hdfidfMonitoringSession.Value = "-1" Then
            RaiseEvent CreateVeterinarySessionRecord(returnValues(0).ToString(), returnValues(1).ToString(), GetLocalResourceObject("Lbl_Create_Success"))

            hdfidfMonitoringSession.Value = returnValues(0).ToString()
        Else
            RaiseEvent UpdateVeterinarySessionRecord(returnValues(0).ToString(), txtstrMonitoringSessionID.Text, GetLocalResourceObject("Lbl_Update_Success"))
        End If

        hdfidfMonitoringSession.Value = returnValues(0).ToString()

    End Sub

    Private Sub DisplaySessionValidationErrors()

        'Paint all SideBarItems as passed validation and then correct those that failed.
        sbiActions.ItemStatus = SideBarStatus.IsValid
        sbiAggregateInfo.ItemStatus = SideBarStatus.IsValid
        sbiDetailedAnimalsAndSamples.ItemStatus = SideBarStatus.IsValid
        sbiDiseaseReports.ItemStatus = SideBarStatus.IsValid
        sbiSessionInformation.ItemStatus = SideBarStatus.IsValid
        sbiTestInformation.ItemStatus = SideBarStatus.IsValid

        Dim oValidator As IValidator
        For Each oValidator In Page.Validators
            If oValidator.IsValid = False Then
                Dim failedValidator As RequiredFieldValidator = oValidator
                Dim section As HtmlGenericControl = TryCast(failedValidator.Parent.Parent, HtmlGenericControl)

                If section Is Nothing Then
                    'Validator's parent could not be determined, set the review section as invalid and report the issue to the user.
                    sbiReview.ItemStatus = SideBarStatus.IsInvalid
                    sbiReview.CssClass = "glyphicon glyphicon-remove"
                    RaiseEvent ShowWarningModal(messageType:=MessageType.CannotGetValidatorSection, isConfirm:=False, message:=Nothing)
                Else
                    Select Case section.ID
                        Case "Actions"
                            sbiActions.ItemStatus = SideBarStatus.IsInvalid
                            sbiActions.CssClass = "glyphicon glyphicon-remove"
                        Case "AggregateInfo"
                            sbiAggregateInfo.ItemStatus = SideBarStatus.IsInvalid
                            sbiAggregateInfo.CssClass = "glyphicon glyphicon-remove"
                        Case "FarmHerdSpecies"
                            sbiFarmHerdSpecies.ItemStatus = SideBarStatus.IsInvalid
                            sbiFarmHerdSpecies.CssClass = "glyphicon glyphicon-remove"
                        Case "DetailedAnimalsAndSamples"
                            sbiDetailedAnimalsAndSamples.ItemStatus = SideBarStatus.IsInvalid
                            sbiDetailedAnimalsAndSamples.CssClass = "glyphicon glyphicon-remove"
                        Case "DiseaseReports"
                            sbiDiseaseReports.ItemStatus = SideBarStatus.IsInvalid
                            sbiDiseaseReports.CssClass = "glyphicon glyphicon-remove"
                        Case "SessionInformation"
                            sbiSessionInformation.ItemStatus = SideBarStatus.IsInvalid
                            sbiSessionInformation.CssClass = "glyphicon glyphicon-remove"
                        Case "TestsResultSummaries"
                            sbiTestInformation.ItemStatus = SideBarStatus.IsInvalid
                            sbiTestInformation.CssClass = "glyphicon glyphicon-remove"
                    End Select
                End If
            End If
        Next

    End Sub

    'Protected Sub btnWarningModalYes_Click(sender As Object, e As EventArgs) Handles btnWarningModalYes.Click

    '    Select Case ViewState("Action")
    '        Case "DeleteSession" 'Main Monitoring Session to Delete
    '            Try

    '                Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, oCommon.GetSPList(SURVEILLANCE_SESSION_DEL_SP)(0), 3, True)
    '                Dim oVeterinaryActiveSurveillanceMonitoringSession = New clsVeterinaryActiveSurveillanceMonitoringSession()
    '                Dim strWarningMessage As String = Nothing
    '                Dim result = oVeterinaryActiveSurveillanceMonitoringSession.DeleteSurveillanceSession({strParams}, strWarningMessage, ViewState)

    '                If result = -1 Then
    '                    RaiseEvent ShowWarningModal(messageType:=MessageType.CannotDelete, isConfirm:=False, message:=Nothing)
    '                Else
    '                    ShowSuccessMessage(MessageType.DeleteSuccess)

    '                    'Needed a way to return back to a campaign, in the event that a user decides to delete from that side
    '                    If (ViewState(CALLER) = CallerPages.VeterinaryActiveSurveillanceCampaignDeleteMonitoringSession) Then
    '                        ViewState(CALLER_KEY) = hdfidfCampaign.Value
    '                        oCommon.SaveViewState(ViewState)
    '                        Response.Redirect(CallerPages.VeterinaryActiveSurveillanceCampaignURL, False)
    '                    End If
    '                End If
    '            Catch ex As Exception
    '                Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
    '            End Try
    '        Case "DeleteSpeciesAndSample" 'Species and Samples deletion from 1st screen of Session
    '            Dim monitoringSessionToSampleTypeID As Int16 = ViewState("monitoringSessionToSampleTypeID")

    '            Dim dsSpeciesAndSamples As DataSet = CType(ViewState(SPECIES_AND_SAMPLES_DATASET), DataSet)
    '            Dim dr = dsSpeciesAndSamples.Tables(0).Select(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SessionToSampleType & " = " & monitoringSessionToSampleTypeID).First

    '            If dr(RecordConstants.RecordAction) = RecordConstants.Insert Then
    '                dr.Delete()
    '            Else
    '                dr(RecordConstants.RecordAction) = RecordConstants.Delete
    '                dr(RecordConstants.RowStatus) = RecordConstants.InactiveRowStatus
    '            End If

    '            dr.AcceptChanges()
    '            dsSpeciesAndSamples.AcceptChanges()

    '            If dsSpeciesAndSamples.CheckDataSet() Then
    '                ViewState(SPECIES_AND_SAMPLES_DATASET) = dsSpeciesAndSamples

    '                Dim dv As DataView = New DataView(dsSpeciesAndSamples.Tables(0), RecordConstants.RowStatus & " = '" & RecordConstants.ActiveRowStatus & "'", ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SpeciesTypeName, DataViewRowState.CurrentRows)
    '                gvSpeciesAndSamples.DataSource = dv
    '                gvSpeciesAndSamples.DataBind()
    '            End If
    '        Case "DeleteFarm" 'Farm deletion from 2nd screen of Session
    '            Dim dsFarmHerdSpecies As DataSet = CType(ViewState(HERD_SPECIES_DATASET), DataSet)
    '            Dim dr = dsFarmHerdSpecies.Tables(0).Select(FarmConstants.FarmActualID & " = '" & ViewState("recordID") & "'").First()

    '            If CanDeleteFarm(dr(FarmConstants.FarmCode)) Then
    '                If dr(RecordConstants.RecordAction) = RecordConstants.Insert Then
    '                    For Each drHerdSpecies As DataRow In dsFarmHerdSpecies.Tables(0).Rows
    '                        If drHerdSpecies(FarmConstants.FarmCode) = dr(FarmConstants.FarmCode) And Not drHerdSpecies(RecordConstants.RecordType) = RecordTypeConstants.Farm Then
    '                            drHerdSpecies.Delete()
    '                        End If
    '                    Next

    '                    dr.Delete()
    '                Else
    '                    For Each drHerdSpecies As DataRow In dsFarmHerdSpecies.Tables(0).Rows
    '                        If drHerdSpecies(FarmConstants.FarmCode) = dr(FarmConstants.FarmCode) And Not drHerdSpecies(RecordConstants.RecordType) = RecordTypeConstants.Farm Then
    '                            drHerdSpecies(RecordConstants.RecordAction) = RecordConstants.Delete
    '                            drHerdSpecies(RecordConstants.RowStatus) = RecordConstants.InactiveRowStatus
    '                        End If
    '                    Next

    '                    dr(RecordConstants.RecordAction) = RecordConstants.Delete
    '                    dr(RecordConstants.RowStatus) = RecordConstants.InactiveRowStatus
    '                End If

    '                dr.AcceptChanges()
    '                dsFarmHerdSpecies.AcceptChanges()

    '                If dsFarmHerdSpecies.CheckDataSet() Then
    '                    ViewState(HERD_SPECIES_DATASET) = dsFarmHerdSpecies

    '                    Dim dv As DataView = New DataView(dsFarmHerdSpecies.Tables(0), RecordConstants.RowStatus & " = '" & RecordConstants.ActiveRowStatus & "'", HerdSpeciesConstants.HerdCode, DataViewRowState.CurrentRows)
    '                    gvFarmHerdSpecies.DataSource = dv
    '                    gvFarmHerdSpecies.DataBind()

    '                    'Populate species filtered down to the species on the samples to species type section, and the associated farms.
    '                    Dim li As ListItem = New ListItem
    '                    Dim dsSpeciesAndSamples As DataSet = TryCast(ViewState(SPECIES_AND_SAMPLES_DATASET), DataSet)
    '                    ddlSampleidfFarm.Items.Clear()
    '                    If ddlSampleidfFarm.Items.Count = 0 Then
    '                        li.Value = ""
    '                        li.Text = ""
    '                        li.Selected = False
    '                    End If

    '                    ddlAggregateInfoidfFarm.Items.Clear()
    '                    If ddlAggregateInfoidfFarm.Items.Count = 0 Then
    '                        li.Value = ""
    '                        li.Text = ""
    '                        li.Selected = False
    '                    End If

    '                    For Each drFarmSpecies As DataRow In dsFarmHerdSpecies.Tables(0).Rows
    '                        If drFarmSpecies(RecordConstants.RecordType).ToString() = RecordTypeConstants.Farm Then
    '                            li = New ListItem
    '                            li.Value = If(drFarmSpecies(FarmConstants.FarmID).ToString() = "", drFarmSpecies(FarmConstants.FarmActualID), drFarmSpecies(FarmConstants.FarmID))
    '                            li.Text = drFarmSpecies(FarmConstants.FarmCode)
    '                            li.Selected = False
    '                            ddlSampleidfFarm.Items.Add(li)
    '                            ddlAggregateInfoidfFarm.Items.Add(li)
    '                        End If
    '                    Next
    '                    ddlSampleidfFarm = SortDropDownList(ddlSampleidfFarm)
    '                    ddlAggregateInfoidfFarm = SortDropDownList(ddlAggregateInfoidfFarm)

    '                End If
    '            Else
    '                RaiseEvent ShowWarningModal(messageType:=MessageType.AssociatedLabTestRecords, isConfirm:=False, message:=Nothing)
    '            End If
    '        Case "DeleteSample" 'Samples deletion from 3rd screen of Session
    '            Dim dsSamples As DataSet = CType(ViewState(SAMPLE_DATASET), DataSet)
    '            Dim dr = dsSamples.Tables(0).Select(SampleConstants.SampleID & " = " & ViewState("sampleID")).First

    '            If CanDeleteSample(dr(SampleConstants.SampleID)) Then
    '                If dr(RecordConstants.RecordAction) = RecordConstants.Insert Then
    '                    dr.Delete()
    '                Else
    '                    dr(RecordConstants.RecordAction) = RecordConstants.Delete
    '                    dr(RecordConstants.RowStatus) = RecordConstants.InactiveRowStatus
    '                End If

    '                If IsValueNullOrEmpty(dr(AnimalConstants.AnimalID)) Then
    '                    DeleteAnimal(dr(AnimalConstants.AnimalID))
    '                End If

    '                dsSamples.AcceptChanges()

    '                If dsSamples.CheckDataSet() Then
    '                    ViewState(SAMPLE_DATASET) = dsSamples
    '                    Dim dv As DataView = New DataView(dsSamples.Tables(0), RecordConstants.RowStatus & " = '" & RecordConstants.ActiveRowStatus & "'", SampleConstants.SampleCode, DataViewRowState.CurrentRows)
    '                    gvSamples.DataSource = dv
    '                    gvSamples.DataBind()

    '                    FillDropDown(ddlTestidfMaterial,
    '                                 GetType(clsSample),
    '                                 Nothing,
    '                                 SampleConstants.SampleID,
    '                                 SampleConstants.SampleCode,
    '                                 String.Empty,
    '                                 Nothing,
    '                                 True,
    '                                 dsSamples)
    '                End If
    '            Else
    '                RaiseEvent ShowWarningModal(messageType:=MessageType.AssociatedLabTestRecords, isConfirm:=False, message:=Nothing)
    '            End If
    '        Case "DeleteTest" 'Test deletion from 4th screen of Session
    '            Dim dsTests As DataSet = CType(ViewState(TEST_DATASET), DataSet)
    '            Dim dr = dsTests.Tables(0).Select(LabTestConstants.LabTestID & " = " & ViewState("labTestID")).First

    '            If CanDeleteTest(dr(LabTestConstants.LabTestID)) Then
    '                If dr(RecordConstants.RecordAction) = RecordConstants.Insert Then
    '                    dr.Delete()
    '                Else
    '                    dr(RecordConstants.RecordAction) = RecordConstants.Delete
    '                    dr(RecordConstants.RowStatus) = RecordConstants.InactiveRowStatus
    '                End If

    '                dsTests.AcceptChanges()

    '                If dsTests.CheckDataSet() Then
    '                    ViewState(TEST_DATASET) = dsTests
    '                    Dim dv As DataView = New DataView(dsTests.Tables(0), RecordConstants.RowStatus & " = '" & RecordConstants.ActiveRowStatus & "'", LabTestConstants.LabTestCode, DataViewRowState.CurrentRows)
    '                    gvTests.DataSource = dv
    '                    gvTests.DataBind()
    '                End If
    '            Else
    '                RaiseEvent ShowWarningModal(messageType:=MessageType.AssociatedInterpretationRecords, isConfirm:=False, message:=Nothing)
    '            End If
    '        Case "DeleteAction" 'Action deletion from 5th screen of Session
    '            Dim dsActions As DataSet = CType(ViewState(ACTION_DATASET), DataSet)
    '            Dim dr = dsActions.Tables(0).Select(MonitoringSessionActionConstants.MonitoringSessionActionID & " = " & ViewState("monitoringSessionActionID")).First

    '            If dr(RecordConstants.RecordAction) = RecordConstants.Insert Then
    '                dr.Delete()
    '            Else
    '                dr(RecordConstants.RecordAction) = RecordConstants.Delete
    '                dr(RecordConstants.RowStatus) = RecordConstants.InactiveRowStatus
    '            End If

    '            dsActions.AcceptChanges()

    '            If dsActions.CheckDataSet() Then
    '                ViewState(ACTION_DATASET) = dsActions
    '                Dim dv As DataView = New DataView(dsActions.Tables(0), RecordConstants.RowStatus & " = '" & RecordConstants.ActiveRowStatus & "'", MonitoringSessionActionConstants.MonitoringSessionActionID, DataViewRowState.CurrentRows)
    '                gvActions.DataSource = dv
    '                gvActions.DataBind()
    '            End If
    '        Case "DeleteAggregateInfo" 'Aggregate information deletion from 6th screen of Session
    '            Dim dsAggregateInfo As DataSet = CType(ViewState(AGGREGATE_INFO_DATASET), DataSet)
    '            Dim dr = dsAggregateInfo.Tables(0).Select(MonitoringSessionSummaryConstants.MonitoringSessionSummaryID & " = " & ViewState("monitoringSessionSummaryID")).First

    '            If dr(RecordConstants.RecordAction) = RecordConstants.Insert Then
    '                dr.Delete()
    '            Else
    '                dr(RecordConstants.RecordAction) = RecordConstants.Delete
    '                dr(RecordConstants.RowStatus) = RecordConstants.InactiveRowStatus
    '            End If

    '            dsAggregateInfo.AcceptChanges()

    '            If dsAggregateInfo.CheckDataSet() Then
    '                ViewState(AGGREGATE_INFO_DATASET) = dsAggregateInfo
    '                Dim dv As DataView = New DataView(dsAggregateInfo.Tables(0), RecordConstants.RowStatus & " = '" & RecordConstants.ActiveRowStatus & "'", MonitoringSessionSummaryConstants.MonitoringSessionSummaryID, DataViewRowState.CurrentRows)
    '                gvAggregateInfos.DataSource = dv
    '                gvAggregateInfos.DataBind()
    '            End If
    '        Case "DeleteResultSummary"
    '            Dim dsInterpretations As DataSet = CType(ViewState(INTERPRETATION_DATASET), DataSet)
    '            Dim dr = dsInterpretations.Tables(0).Select(InterpretationConstants.InterpretationID & " = " & ViewState("interpretationID")).First

    '            If dr(RecordConstants.RecordAction) = RecordConstants.Insert Then
    '                dr.Delete()
    '            Else
    '                dr(RecordConstants.RecordAction) = RecordConstants.Delete
    '                dr(RecordConstants.RowStatus) = RecordConstants.InactiveRowStatus
    '            End If

    '            dsInterpretations.AcceptChanges()

    '            If dsInterpretations.CheckDataSet() Then
    '                ViewState(INTERPRETATION_DATASET) = dsInterpretations
    '                Dim dv As DataView = New DataView(dsInterpretations.Tables(0), RecordConstants.RowStatus & " = '" & RecordConstants.ActiveRowStatus & "'", InterpretationConstants.InterpretationID, DataViewRowState.CurrentRows)
    '                gvResultSummaries.DataSource = dv
    '                gvResultSummaries.DataBind()
    '            End If
    '    End Select

    '    'Added to prevent future actions from repeating and causing errors
    '    ViewState("Action") = Nothing

    'End Sub

    Private Sub FillForm(edit As Boolean)

        BaseReferenceLookUp(ddlidfsMonitoringSessionStatus, BaseReferenceConstants.ASSessionStatus, (HACodeList.LivestockHACode + HACodeList.AvianHACode), False)
        If ((ddlidfsMonitoringSessionStatus.Items.Count > 0) AndAlso (ddlidfsMonitoringSessionStatus.Items.Contains(ddlidfsMonitoringSessionStatus.Items.FindByText("Open")))) Then
            ddlidfsMonitoringSessionStatus.Items.FindByText("Open").Selected = True
        End If

        'Populate disease with avian and livestock to determine the species and samples based on disease.
        Dim dsDiseaseToSpecies As DataSet = Nothing
        BaseReferenceLookUp(ddlidfsDiagnosis, BaseReferenceConstants.Diagnosis, (HACodeList.LivestockHACode + HACodeList.AvianHACode), True, dsDiseaseToSpecies)
        ViewState(DISEASE_TO_SPECIES_DATASET) = dsDiseaseToSpecies

        PopulateAvianLiveStock()

        BaseReferenceLookUp(ddlAggregateInfoidfsDiagnosis, BaseReferenceConstants.Diagnosis, (HACodeList.LivestockHACode + HACodeList.AvianHACode), True)
        BaseReferenceLookUp(ddlidfsCampaignType, BaseReferenceConstants.ASCampaignType, HACodeList.ASHACode, True)

        If Not hdfidfMonitoringSession.Value = -1 Then 'editing the session record
            Dim dsSession As DataSet = Nothing
            Dim oActiveSurveillanceSession As clsVeterinaryActiveSurveillanceMonitoringSession = New clsVeterinaryActiveSurveillanceMonitoringSession()
            dsSession = oActiveSurveillanceSession.SelectOne(hdfidfMonitoringSession.Value)

            If dsSession.CheckDataSet() Then
                If dsSession.Tables(0).Rows(0)(CountryConstants.CountryID).ToString = "" Then
                    MonitoringSessionAddress.LocationCountryID = Nothing
                Else
                    MonitoringSessionAddress.LocationCountryID = CType(dsSession.Tables(0).Rows(0)(CountryConstants.CountryID), Long)
                End If

                If dsSession.Tables(0).Rows(0)(RegionConstants.RegionID).ToString = "" Then
                    MonitoringSessionAddress.LocationRegionID = Nothing
                Else
                    MonitoringSessionAddress.LocationRegionID = CType(dsSession.Tables(0).Rows(0)(RegionConstants.RegionID), Long)
                End If

                If dsSession.Tables(0).Rows(0)(RayonConstants.RayonID).ToString = "" Then
                    MonitoringSessionAddress.LocationRayonID = Nothing
                Else
                    MonitoringSessionAddress.LocationRayonID = CType(dsSession.Tables(0).Rows(0)(RayonConstants.RayonID), Long)
                End If

                If dsSession.Tables(0).Rows(0)(SettlementConstants.idfsSettlement).ToString = "" Then
                    MonitoringSessionAddress.LocationSettlementID = Nothing
                Else
                    MonitoringSessionAddress.LocationSettlementID = CType(dsSession.Tables(0).Rows(0)(SettlementConstants.idfsSettlement), Long)
                End If
                MonitoringSessionAddress.DataBind()

                ViewState(MONITORING_SESSION_DATATABLE) = dsSession.Tables(0)
                oCommon.Scatter(divVeterinaryActiveSurveillanceSessionForm, New DataTableReader(dsSession.Tables(0)))
                oCommon.Scatter(divHiddenFieldsSection, New DataTableReader(dsSession.Tables(0)))

                'Fill the species/samples based on campaign associated with sessions
                If hdfidfCampaign.Value <> String.Empty Then
                    CampaignObject = GetCampaignSpecifications(hdfidfCampaign.Value)
                    ddlidfsDiagnosis.Enabled = False
                End If

                FillSpeciesAndSamples(refresh:=True)
                FillFarmHerdSpecies(refresh:=False, isRootFarm:=False)
                FillBlankAnimals(refresh:=True)
                FillSamples(refresh:=True)
                FillTests(refresh:=True)
                FillResultSummaries(refresh:=True)
                FillActions(refresh:=True)
                FillAggregateInfo(refresh:=True)
                FillVeterinaryDiseaseReportsList(refresh:=True)
            End If

            ddlidfsDiagnosis_SelectedIndexChanged(Nothing, Nothing)
            ddlidfsDiagnosis.Enabled = False
        Else
            Session.Remove(CAMPAIGN_OBJECT)

            FillFarmHerdSpecies(refresh:=True, isRootFarm:=False)
            FillSpeciesAndSamples(refresh:=True)

            If hdfidfCampaign.Value <> String.Empty Then
                CampaignObject = GetCampaignSpecifications(hdfidfCampaign.Value)
                ddlidfsDiagnosis.Enabled = False
            End If

            FillBlankAnimals(refresh:=True)
            FillSamples(refresh:=True)
            FillTests(refresh:=True)
            FillResultSummaries(refresh:=True)
            FillActions(refresh:=True)
            FillAggregateInfo(refresh:=True)
        End If

    End Sub

    Private Sub FillDropDowns()

        BaseReferenceLookUp(ddlActionidfsMonitoringSessionActionStatus, BaseReferenceConstants.ASSessionActionStatus, HACodeList.LivestockHACode, True)
        Dim ddlActionType As System.Web.UI.WebControls.DropDownList = CType(Me.ddlActionidfsMonitoringSessionActionType.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
        BaseReferenceLookUp(ddlActionType, BaseReferenceConstants.ASSessionActionType, HACodeList.LivestockHACode, True)
        ddlActionType.DataSource = SortDropDownList(ddlActionType).Items

        BaseReferenceLookUp(ddlidfsMonitoringSessionStatus, BaseReferenceConstants.ASSessionStatus, (HACodeList.LivestockHACode + HACodeList.AvianHACode), False)
        If ((ddlidfsMonitoringSessionStatus.Items.Count > 0) AndAlso (ddlidfsMonitoringSessionStatus.Items.Contains(ddlidfsMonitoringSessionStatus.Items.FindByText("Open")))) Then
            ddlidfsMonitoringSessionStatus.Items.FindByText("Open").Selected = True
        End If

        BaseReferenceLookUp(ddlAggregateInfoidfsDiagnosis, BaseReferenceConstants.Diagnosis, (HACodeList.LivestockHACode + HACodeList.AvianHACode), True)

        FillDropDown(ddlActionidfPersonEnteredBy, GetType(clsOrgPerson), Nothing, PersonConstants.idfPerson, OrganizationConstants.OrgFullName, String.Empty, Nothing, True)
        ddlActionidfPersonEnteredBy = SortDropDownList(ddlActionidfPersonEnteredBy)

    End Sub

    Private Function GetCampaignSpecifications(Optional campaignID As String = "") As clsVASCampaign

        Dim objCampaign As clsVASCampaign = New clsVASCampaign
        Dim dsCampaign As DataSet
        Dim strItemName As String = String.Empty
        Dim strItemId As String = String.Empty
        Dim oCampaign As clsVeterinaryActiveSurveillanceCampaign = New clsVeterinaryActiveSurveillanceCampaign()
        dsCampaign = oCampaign.SelectOne(campaignID)

        If dsCampaign.CheckDataSet() Then
            oCommon.Scatter(divVeterinaryActiveSurveillanceSessionForm, New DataTableReader(dsCampaign.Tables(0)))
            For Each rw In dsCampaign.Tables(1).Rows
                objCampaign.Species.Add(New Item With {.Name = rw.Item("SpeciesType").ToString(), .ID = rw.Item("idfsSpeciesType").ToString()})
                objCampaign.Samples.Add(New Item With {.Name = rw.Item("SampleType").ToString(), .ID = rw.Item("idfsSampleType").ToString()})
                strItemName = rw.Item("SpeciesType").ToString() & ", " & rw.Item("SampleType").ToString()
                strItemId = rw.Item("idfsSpeciesType").ToString() & ", " & rw.Item("idfsSampleType").ToString()
                objCampaign.SpeciesAndSamples.Add(New Item With {.Name = strItemName, .ID = strItemId})

                If hdfidfMonitoringSession.Value = "-1" Then
                    AddUpdateSpeciesAndSampleRow(RecordConstants.Insert, 0, hdfidfMonitoringSession.Value, rw.Item("idfsSampleType"), rw.Item("SampleType"), rw.Item("idfsSpeciesType"), rw.Item("SpeciesType"))
                End If
            Next
        End If

        Return objCampaign

    End Function

#End Region

#Region "Species and Samples Methods"

    Private Sub FillSpeciesAndSamples(ByVal refresh As Boolean)

        Try
            Dim dsSpeciesAndSamples As DataSet

            'Save the data set in view state to re-use
            If refresh Then ViewState(SPECIES_AND_SAMPLES_DATASET) = Nothing

            If IsNothing(ViewState(SPECIES_AND_SAMPLES_DATASET)) Then
                Dim oVetActiveSurvSession As clsVeterinaryActiveSurveillanceMonitoringSession = New clsVeterinaryActiveSurveillanceMonitoringSession()
                Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, oCommon.GetSPList(SURVEILLANCE_SESSION_TO_SAMPLE_TYPE_GET_LIST_SP)(0), 3, True)
                dsSpeciesAndSamples = oVetActiveSurvSession.ListAllMonitoringSessionToSampleType({strParams})
            Else
                dsSpeciesAndSamples = CType(ViewState(SPECIES_AND_SAMPLES_DATASET), DataSet)
            End If

            gvSpeciesAndSamples.DataSource = Nothing
            If dsSpeciesAndSamples.CheckDataSet() Then
                Dim keys(1) As DataColumn
                keys(0) = dsSpeciesAndSamples.Tables(0).Columns(0)
                'Temp fix until I find a better way to remove
                keys.RemoveAt(1)
                dsSpeciesAndSamples.Tables(0).PrimaryKey = keys
                ViewState(SPECIES_AND_SAMPLES_DATASET) = dsSpeciesAndSamples
                gvSpeciesAndSamples.DataSource = dsSpeciesAndSamples.Tables(0)
                gvSpeciesAndSamples.DataBind()
            End If
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnAddSpeciesAndSample_ServerClick(sender As Object, e As EventArgs) Handles btnAddSpeciesAndSample.ServerClick

        Try
            ResetSpeciesAndSample()

            hdfRecordAction.Value = RecordConstants.Insert

            ToggleVisibility(SectionSpeciesAndSample)

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, SHOW_SPECIES_AND_SAMPLE_MODAL, True)
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub ResetSpeciesAndSample()

        ddlSpeciesAndSamplesidfsSpeciesType.SelectedIndex = -1
        ddlSpeciesAndSamplesidfsSampleType.SelectedIndex = -1
        hdfRecordID.Value = "0"
        hdfRecordAction.Value = ""

    End Sub

    Protected Sub btnSpeciesAndSampleOK_Click(sender As Object, e As EventArgs) Handles btnSpeciesAndSampleOK.Click

        Try
            AddUpdateSpeciesAndSampleRow(hdfRecordAction.Value,
                                         hdfRecordID.Value,
                                         hdfidfMonitoringSession.Value,
                                         If(ddlSpeciesAndSamplesidfsSampleType.SelectedValue = "null", DBNull.Value, ddlSpeciesAndSamplesidfsSampleType.SelectedValue),
                                         If(ddlSpeciesAndSamplesidfsSampleType.SelectedValue = "null", DBNull.Value, ddlSpeciesAndSamplesidfsSampleType.SelectedItem.Text),
                                         If(ddlSpeciesAndSamplesidfsSpeciesType.SelectedValue = "null", DBNull.Value, ddlSpeciesAndSamplesidfsSpeciesType.SelectedValue),
                                         If(ddlSpeciesAndSamplesidfsSpeciesType.SelectedValue = "null", DBNull.Value, ddlSpeciesAndSamplesidfsSpeciesType.SelectedItem.Text))

            ResetSpeciesAndSample()

            PopulateDetailsSpeciesAndSamples() 'Forces pre-population of the drop down list on the 3rd screen of the session.
            ToggleVisibility(SectionSessionInformation)

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, HIDE_SPECIES_AND_SAMPLE_MODAL, True)
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub AddUpdateSpeciesAndSampleRow(ByVal recordAction As String,
                                             ByVal recordID As Integer,
                                             ByVal monitoringSessionID As Long,
                                             ByVal sampleTypeID As Long,
                                             ByVal sampleTypeName As String,
                                             ByVal speciesTypeID As Long,
                                             ByVal speciesTypeName As String)

        Dim dsSpeciesAndSamples As DataSet = TryCast(ViewState(SPECIES_AND_SAMPLES_DATASET), DataSet)
        Dim dr As DataRow

        If recordAction = RecordConstants.Read Or Not recordID = "0" Then
            dr = dsSpeciesAndSamples.Tables(0).Select(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SessionToSampleType & " = " & recordID).First
        Else
            dr = dsSpeciesAndSamples.Tables(0).NewRow()
        End If

        dr(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.MonitoringSession) = monitoringSessionID
        dr(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SampleTypeID) = sampleTypeID
        dr(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SampleTypeName) = sampleTypeName
        dr(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SpeciesTypeID) = speciesTypeID
        dr(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SpeciesTypeName) = speciesTypeName

        If recordAction = RecordConstants.Read Or Not recordID = "0" Then
            If dr(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SessionToSampleType) > 0 Then
                dr(RecordConstants.RecordAction) = RecordConstants.Update
            End If
        Else
            hdfIdentity.Value += 1
            Dim identity As Integer = (hdfIdentity.Value * -1)
            dr(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SessionToSampleType) = identity
            dr(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.Order) = dsSpeciesAndSamples.Tables(0).Rows.Count + 1
            dr(RecordConstants.RowStatus) = RecordConstants.ActiveRowStatus
            dr(RecordConstants.RecordAction) = RecordConstants.Insert
            dsSpeciesAndSamples.Tables(0).Rows.Add(dr)
        End If

        dsSpeciesAndSamples.AcceptChanges()

        gvSpeciesAndSamples.DataSource = Nothing
        If dsSpeciesAndSamples.CheckDataSet() Then
            ViewState(SPECIES_AND_SAMPLES_DATASET) = dsSpeciesAndSamples
            Dim dv As DataView = New DataView(dsSpeciesAndSamples.Tables(0), RecordConstants.RowStatus & " = '" & RecordConstants.ActiveRowStatus & "'", ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SpeciesTypeName, DataViewRowState.CurrentRows)
            gvSpeciesAndSamples.DataSource = dv
            gvSpeciesAndSamples.DataBind()
        End If

    End Sub

    Protected Sub gvSpeciesAndSamples_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSpeciesAndSamples.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    DeleteSpeciesAndSample(CType(e.CommandArgument, Long))
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditSpeciesAndSample(CType(e.CommandArgument, Long))
            End Select
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub EditSpeciesAndSample(monitoringSessionToSampleTypeID As Long)

        Dim dsSpeciesAndSamples As DataSet = CType(ViewState(SPECIES_AND_SAMPLES_DATASET), DataSet)
        Dim dr = dsSpeciesAndSamples.Tables(0).Select(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SessionToSampleType & " = " & monitoringSessionToSampleTypeID).First

        If Not dr Is Nothing Then
            ddlSpeciesAndSamplesidfsSpeciesType.SelectedValue = If(dr(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SpeciesTypeID).ToString = "", "null", dr(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SpeciesTypeID))
            ddlSpeciesAndSamplesidfsSampleType.SelectedValue = If(dr(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SampleTypeID).ToString = "", "null", dr(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SampleTypeID))
            hdfRecordID.Value = dr(ActiveSurveillanceMonitoringSessionToSampleTypeConstants.SessionToSampleType)
            hdfRecordAction.Value = dr(RecordConstants.RecordAction).ToString

            ToggleVisibility(SectionSpeciesAndSample)

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, SHOW_SPECIES_AND_SAMPLE_MODAL, True)
        End If

    End Sub

    Private Sub DeleteSpeciesAndSample(monitoringSessionToSampleTypeID As Long)

        ViewState("Action") = "DeleteSpeciesAndSample"
        ViewState("monitoringSessionToSampleTypeID") = monitoringSessionToSampleTypeID
        RaiseEvent ShowWarningModal(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Nothing)

    End Sub

    Protected Sub ddlidfsDiagnosis_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlidfsDiagnosis.SelectedIndexChanged

        ' Determine avian/livestock selection based on disease selection to populate species and samples based on the selection.
        If Not ddlidfsDiagnosis.SelectedValue = "null" Then
            Dim ds As DataSet = ViewState(DISEASE_TO_SPECIES_DATASET)
            Dim dt As DataTable = ds.Tables(0).DefaultView.ToTable
            Dim diagnosisVal As String = ddlidfsDiagnosis.SelectedValue
            Dim oBaseReference As clsBaseReference = New clsBaseReference()
            Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, oCommon.GetSPList(BASE_REFERENCE_LOOKUP_GET_LIST_SP)(0), 3, True)
            Dim dsDiagnosisGroups = oBaseReference.ListAll({strParams})

            If dsDiagnosisGroups.Tables(0).Select("idfsBaseReference = " & ddlidfsDiagnosis.SelectedValue).Count > 0 Then
                'TODO: Load up aggregate info diagnosis with additional diseases and enable.
            End If

            Dim foundRow As DataRow = dt.Select("idfsBaseReference = '" & ddlidfsDiagnosis.SelectedValue & "'").FirstOrDefault()
            If Not foundRow Is Nothing Then
                If (foundRow.Item("intHACode") > (HACodeList.AvianHACode + HACodeList.LivestockHACode)) Then
                    If hdfidfMonitoringSession.Value = "-1" Then
                        divAvianLiveStock.Visible = True
                    Else
                        If hdfAvianOrLivestock.Value = HACodeList.Avian Then
                            rblAvianLivestock.SelectedIndex = 0
                        Else
                            rblAvianLivestock.SelectedIndex = 1
                        End If

                        rblAvianLivestock_SelectedIndexChanged(Nothing, Nothing)
                    End If
                Else
                    btnAddSpeciesAndSample.Disabled = False
                    divAvianLiveStock.Visible = False

                    rblAvianLivestock.Items(0).Selected = (foundRow.Item("intHACode") = HACodeList.AvianHACode)
                    rblAvianLivestock.Items(1).Selected = (foundRow.Item("intHACode") = HACodeList.LivestockHACode)
                    rblAvianLivestock_SelectedIndexChanged(Nothing, Nothing)
                End If
            End If
        End If

    End Sub

    Private Sub PopulateAvianLiveStock()

        rblAvianLivestock.SelectedValue = Nothing
        rblAvianLivestock.Items.Clear()

        Dim items As List(Of ListItem) = New List(Of ListItem)
        items.Add(New ListItem With {.Text = HACodeList.Avian, .Value = HACodeList.AvianHACode})
        items.Add(New ListItem With {.Text = HACodeList.Livestock, .Value = HACodeList.LivestockHACode})

        rblAvianLivestock.DataTextField = "Text"
        rblAvianLivestock.DataValueField = "Value"
        rblAvianLivestock.DataSource = items
        rblAvianLivestock.DataBind()
        rblAvianLivestock.SelectedIndex = -1

    End Sub

    Protected Sub rblAvianLivestock_SelectedIndexChanged(sender As Object, e As EventArgs) Handles rblAvianLivestock.SelectedIndexChanged

        Dim li As ListItem = New ListItem

        ddlAggregateInfoidfsSampleType.Items.Clear()
        li.Value = ""
        li.Text = ""
        li.Selected = False
        ddlAggregateInfoidfsSampleType.Items.Add(li)

        If (rblAvianLivestock.SelectedValue = HACodeList.AvianHACode.ToString()) Then
            hdfAvianOrLivestock.Value = HACodeList.Avian
            FillBlankAnimals(refresh:=True)
            BaseReferenceLookUp(ddlSpeciesAndSamplesidfsSpeciesType, BaseReferenceConstants.SpeciesList, HACodeList.AvianHACode, True)

            PopulateDetailsSpeciesAndSamples()

            divAggregateInfoAnimalContainer.Visible = False

            Dim ddlTestCategory As System.Web.UI.WebControls.DropDownList = CType(Me.ddlTestidfsTestCategory.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
            BaseReferenceLookUp(ddlTestCategory, BaseReferenceConstants.TestCategory, HACodeList.AvianHACode, True)
            ddlTestCategory.DataSource = SortDropDownList(ddlTestCategory).Items

            Dim ddlTestName As System.Web.UI.WebControls.DropDownList = CType(Me.ddlTestidfsTestName.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
            BaseReferenceLookUp(ddlTestName, BaseReferenceConstants.TestName, HACodeList.AvianHACode, True)
            ddlTestidfsTestName.DataSource = SortDropDownList(ddlTestName).Items

            Dim ddlTestResult As System.Web.UI.WebControls.DropDownList = CType(Me.ddlTestidfsTestResult.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
            BaseReferenceLookUp(ddlTestResult, BaseReferenceConstants.TestResult, HACodeList.AvianHACode, True)
            ddlTestidfsTestResult.DataSource = SortDropDownList(ddlTestResult).Items

            BaseReferenceLookUp(ddlResultSummaryidfsInterpretedStatus, BaseReferenceConstants.RuleInValueforTestValidation, HACodeList.AvianHACode, True)
        Else
            hdfAvianOrLivestock.Value = HACodeList.Livestock
            FillAnimals(refresh:=True)
            BaseReferenceLookUp(ddlSpeciesAndSamplesidfsSpeciesType, BaseReferenceConstants.SpeciesList, HACodeList.LivestockHACode, True)

            PopulateDetailsSpeciesAndSamples()

            BaseReferenceLookUp(ddlSampleidfsAnimalAge, BaseReferenceConstants.AnimalAge, HACodeList.LivestockHACode, True)
            ddlSampleidfsAnimalAge = SortDropDownList(ddlSampleidfsAnimalAge)
            BaseReferenceLookUp(ddlSampleidfsAnimalGender, BaseReferenceConstants.AnimalSex, HACodeList.LivestockHACode, True)
            ddlSampleidfsAnimalGender = SortDropDownList(ddlSampleidfsAnimalGender)

            BaseReferenceLookUp(ddlAggregateInfoidfsAnimalSex, BaseReferenceConstants.AnimalSex, HACodeList.LivestockHACode, True)
            ddlAggregateInfoidfsAnimalSex = SortDropDownList(ddlAggregateInfoidfsAnimalSex)

            divAggregateInfoAnimalContainer.Visible = True

            Dim ddlTestCategory As System.Web.UI.WebControls.DropDownList = CType(Me.ddlTestidfsTestCategory.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
            BaseReferenceLookUp(ddlTestCategory, BaseReferenceConstants.TestCategory, HACodeList.LivestockHACode, True)
            ddlTestCategory.DataSource = SortDropDownList(ddlTestCategory).Items

            Dim ddlTestName As System.Web.UI.WebControls.DropDownList = CType(Me.ddlTestidfsTestName.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
            BaseReferenceLookUp(ddlTestName, BaseReferenceConstants.TestName, HACodeList.LivestockHACode, True)
            ddlTestidfsTestName.DataSource = SortDropDownList(ddlTestName).Items

            Dim ddlTestResult As System.Web.UI.WebControls.DropDownList = CType(Me.ddlTestidfsTestResult.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
            BaseReferenceLookUp(ddlTestResult, BaseReferenceConstants.TestResult, HACodeList.LivestockHACode, True)
            ddlTestidfsTestResult.DataSource = SortDropDownList(ddlTestResult).Items

            BaseReferenceLookUp(ddlResultSummaryidfsInterpretedStatus, BaseReferenceConstants.RuleInValueforTestValidation, HACodeList.LivestockHACode, True)
        End If

        btnAddSpeciesAndSample.Disabled = False

    End Sub

    Private Sub PopulateDetailsSpeciesAndSamples()

        Dim dsSampleTypes As DataSet = Nothing
        Dim dsSpecies As DataSet = Nothing

        Dim li As ListItem = New ListItem
        Dim dsSpeciesAndSamples As DataSet = TryCast(ViewState(SPECIES_AND_SAMPLES_DATASET), DataSet)

        ddlSampleidfsSampleType.Items.Clear()
        li.Value = "null"
        li.Text = ""
        li.Selected = False
        ddlSampleidfsSampleType.Items.Add(li)

        Select Case (hdfAvianOrLivestock.Value)
            Case HACodeList.Livestock
                BaseReferenceLookUp(ddlSpeciesAndSamplesidfsSampleType, BaseReferenceConstants.SampleType, HACodeList.LivestockHACode, True, dsSampleTypes)
                BaseReferenceLookUp(ddlSpeciesAndSamplesidfsSpeciesType, BaseReferenceConstants.SpeciesList, HACodeList.LivestockHACode, True, dsSpecies)
            Case HACodeList.Avian
                BaseReferenceLookUp(ddlSpeciesAndSamplesidfsSampleType, BaseReferenceConstants.SampleType, HACodeList.AvianHACode, True, dsSampleTypes)
                BaseReferenceLookUp(ddlSpeciesAndSamplesidfsSpeciesType, BaseReferenceConstants.SpeciesList, HACodeList.AvianHACode, True, dsSpecies)
        End Select

        If Not dsSpeciesAndSamples Is Nothing Then
            For Each dr As DataRow In dsSampleTypes.Tables(0).Rows
                If dsSpeciesAndSamples.Tables(0).Select(SampleTypeConstants.SampleTypeID & " = " & dr(BaseReferenceConstants.idfsBaseReference).ToString()).Count > 0 Then
                    li = New ListItem
                    li.Value = dr(BaseReferenceConstants.idfsBaseReference)
                    li.Text = dr(BaseReferenceConstants.Name)
                    li.Selected = False
                    ddlSampleidfsSampleType.Items.Add(li)
                    ddlAggregateInfoidfsSampleType.Items.Add(li)
                End If
            Next
            ddlSampleidfsSampleType = SortDropDownList(ddlSampleidfsSampleType)
            ddlAggregateInfoidfsSampleType = SortDropDownList(ddlAggregateInfoidfsSampleType)
        End If

        If Not dsSpeciesAndSamples Is Nothing Then
            For Each dr As DataRow In dsSpecies.Tables(0).Rows
                If dsSpeciesAndSamples.Tables(0).Select(HerdSpeciesConstants.SpeciesTypeID & " = " & dr(BaseReferenceConstants.idfsBaseReference).ToString()).Count > 0 Then
                    li = New ListItem
                    li.Value = dr(BaseReferenceConstants.idfsBaseReference)
                    li.Text = dr(BaseReferenceConstants.Name)
                    li.Selected = False
                    ddlSampleidfAnimal.Items.Add(li)
                    'ddlAggregateInfoidfsSampleType.Items.Add(li)
                End If
            Next
            ddlSampleidfsSampleType = SortDropDownList(ddlSampleidfsSampleType)
            ddlAggregateInfoidfsSampleType = SortDropDownList(ddlAggregateInfoidfsSampleType)
        End If

    End Sub
    Private Sub gvSpeciesAndSamples_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvSpeciesAndSamples.Sorting

        SortGrid(e, CType(sender, GridView), SPECIES_AND_SAMPLES_DATASET)

    End Sub

    Protected Sub gvSpeciesAndSamples_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvSpeciesAndSamples.PageIndexChanging

        gvSpeciesAndSamples.PageIndex = e.NewPageIndex

        FillSpeciesAndSamples(refresh:=False)

    End Sub

#End Region

#Region "Farm, Flock/Herd and Species Methods"

    Private Sub FillFarmHerdSpecies(ByVal refresh As Boolean, ByVal isRootFarm As Boolean)

        Try
            Dim dsFarmHerdSpecies As DataSet

            'Save the data set in view state to re-use
            If refresh Then ViewState(HERD_SPECIES_DATASET) = Nothing

            Dim dsHSD As DataSet = ViewState(HERD_SPECIES_DATASET)

            If IsNothing(ViewState(HERD_SPECIES_DATASET)) Then
                Dim oFarm As clsFarm = New clsFarm()
                Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, oCommon.GetSPList(FARM_HERD_SPECIES_GET_LIST_SP)(0), 3, True)
                dsFarmHerdSpecies = oFarm.ListAllFarmHerdSpecies({strParams})
            ElseIf (dsHSD.Tables(0).Rows.Count = 0) Then
                Dim oFarm As clsFarm = New clsFarm()
                Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, oCommon.GetSPList(FARM_HERD_SPECIES_GET_LIST_SP)(0), 3, True)
                dsFarmHerdSpecies = oFarm.ListAllFarmHerdSpecies({strParams})
            Else
                dsFarmHerdSpecies = CType(ViewState(HERD_SPECIES_DATASET), DataSet)
            End If

            gvFarmHerdSpecies.DataSource = Nothing
            If dsFarmHerdSpecies.CheckDataSet() Then
                Dim keys(1) As DataColumn
                keys(0) = dsFarmHerdSpecies.Tables(0).Columns(0)
                dsFarmHerdSpecies.Tables(0).PrimaryKey = keys
                'dsFarmHerdSpecies.Tables(0).DefaultView.Sort = HerdSpeciesConstants.HerdCode & " " & SortConstants.Ascending & ", " & HerdSpeciesConstants.SpeciesTypeName & " " & SortConstants.Ascending
                ViewState(HERD_SPECIES_DATASET) = dsFarmHerdSpecies

                gvFarmHerdSpecies.DataSource = dsFarmHerdSpecies
                gvFarmHerdSpecies.DataBind()

                'Populate species filtered down to the species on the samples to species type section, and the associated farms.
                Dim li As ListItem = New ListItem
                Dim dsSpeciesAndSamples As DataSet = TryCast(ViewState(SPECIES_AND_SAMPLES_DATASET), DataSet)
                ddlSampleidfFarm.Items.Clear()
                If ddlSampleidfFarm.Items.Count = 0 Then
                    li.Value = "null"
                    li.Text = ""
                    li.Selected = False
                    ddlSampleidfFarm.Items.Add(li)
                End If

                ddlAggregateInfoidfFarm.Items.Clear()
                If ddlAggregateInfoidfFarm.Items.Count = 0 Then
                    li.Value = ""
                    li.Text = ""
                    li.Selected = False
                    ddlAggregateInfoidfFarm.Items.Add(li)
                End If

                For Each dr As DataRow In dsFarmHerdSpecies.Tables(0).Rows
                    If dr(RecordConstants.RecordType).ToString() = RecordTypeConstants.Farm Then
                        li = New ListItem
                        li.Value = If(dr(FarmConstants.FarmID).ToString() = "", dr(FarmConstants.FarmActualID), dr(FarmConstants.FarmID))
                        li.Text = If(dr(FarmConstants.FarmCode).ToString() = "", "N/A", dr(FarmConstants.FarmCode))
                        li.Selected = False
                        ddlSampleidfFarm.Items.Add(li)
                        ddlAggregateInfoidfFarm.Items.Add(li)
                    End If
                Next
                ddlSampleidfFarm = SortDropDownList(ddlSampleidfFarm)
                ddlAggregateInfoidfFarm = SortDropDownList(ddlAggregateInfoidfFarm)
            End If
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub gvFarmHerdSpecies_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvFarmHerdSpecies.RowDataBound

        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim dr As DataRowView = TryCast(e.Row.DataItem, DataRowView)
            If Not dr Is Nothing Then
                Dim dsFarmHerdSpecies As DataSet = TryCast(ViewState(HERD_SPECIES_DATASET), DataSet)
                Dim sFHSId = "trFHS" & dsFarmHerdSpecies.Tables(0).Rows(e.Row.RowIndex).Item("idfFarmActual")
                Dim deleteButton As LinkButton = CType(e.Row.FindControl("btnDeleteFarm"), LinkButton)
                Dim expandButton As HtmlAnchor = CType(e.Row.FindControl("btnExpandFarm"), HtmlAnchor)

                deleteButton.Visible = False
                expandButton.Visible = False

                If dr(RecordConstants.RecordType) = RecordTypeConstants.Farm Then
                    e.Row.Enabled = True

                    deleteButton.Visible = True
                    deleteButton.Enabled = True
                    expandButton.Visible = True
                    expandButton.Attributes.Add("onclick", "toggleFarmDetails(Event, '" & sFHSId & "')")
                ElseIf dr(RecordConstants.RecordType) = RecordTypeConstants.Herd Then
                    e.Row.Enabled = False
                    'Herd should be indented, in relationship to Farm 
                    e.Row.Cells(0).Attributes.Add("style", "padding-left:30px")
                    'Identifying these rows for colaspable subgrid
                    e.Row.Attributes.Add("fhs", sFHSId)
                    e.Row.Attributes.Add("style", "display:none")
                ElseIf dr(RecordConstants.RecordType) = RecordTypeConstants.Species Then
                    e.Row.Enabled = False
                    'For superficial reasons, the Herd statement will be removed so that the header category of "Species" will indicate the avian/livestock
                    e.Row.Cells(0).Text = ""
                    'Identifying these rows for colaspable subgrid
                    e.Row.Attributes.Add("fhs", sFHSId)
                    e.Row.Attributes.Add("style", "display:none")
                End If
            End If
        End If

    End Sub

    Protected Sub gvFarmHerdSpecies_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvFarmHerdSpecies.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    DeleteFarm(CType(e.CommandArgument, Long))
            End Select
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub DeleteFarm(recordID As Long)

        ViewState("Action") = "DeleteFarm"
        ViewState("recordID") = recordID
        RaiseEvent ShowWarningModal(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Nothing)

    End Sub

    Public Function CanDeleteFarm(ByVal farmCode As String) As Boolean

        Dim dsSamples As DataSet = TryCast(ViewState(SAMPLE_DATASET), DataSet)

        If dsSamples.Tables(0).Select(FarmConstants.FarmCode & " = '" & farmCode & "'").Count = 0 Then
            Return True
        Else
            Return False
        End If

        Dim dsAggregateInfos As DataSet = TryCast(ViewState(AGGREGATE_INFO_DATASET), DataSet)

        If dsAggregateInfos.Tables(0).Select(FarmConstants.FarmCode & " = '" & farmCode & "'").Count = 0 Then
            Return True
        Else
            Return False
        End If

    End Function

    Protected Sub btnAddFarm_ServerClick(sender As Object, e As EventArgs) Handles btnAddFarm.ServerClick

        Dim sFileInfo As String = String.Empty

        If (ViewState(CALLER) = CallerPages.VeterinaryActiveSurveillanceCampaignSelectMonitoringSession) Then
            ViewState(CALLER) = CallerPages.VeterinaryActiveSurveillanceCampaignSelectMonitoringSessionAddFarm
        Else
            ViewState(CALLER) = CallerPages.VeterinaryActiveSurveillanceMonitoringSessionAddFarm
        End If

        ViewState(CALLER_KEY) = hdfidfMonitoringSession.Value

        oCommon.SaveSearchFields({divVeterinaryActiveSurveillanceSessionForm, divHiddenFieldsSection}, SURVEILLANCE_SESSION_GET_DETAIL_SP, oCommon.CreateTempFile(SESSION_INFO_PREFIX))

        If hdfAvianOrLivestock.Value = HACodeList.Avian Then
            hdfSearchFarmType.Value = FarmTypes.AvianFarmType
        Else
            hdfSearchFarmType.Value = FarmTypes.LivestockFarmType
        End If

        ViewState(SEARCH_FARM_TYPE) = hdfSearchFarmType.Value

        hdfsearchFormidfsRegion.Value = MonitoringSessionAddress.SelectedRegionValue
        hdfsearchFormidfsRayon.Value = MonitoringSessionAddress.SelectedRayonValue
        hdfsearchFormidfsSettlement.Value = MonitoringSessionAddress.SelectedSettlementValue
        oCommon.SaveSearchFields({divFarmSearchContainer}, SURVEILLANCE_SESSION_GET_DETAIL_SP, oCommon.CreateTempFile(FARM_SEARCH_PREFIX))

        Session(RecordConstants.RecordID) = hdfIdentity.Value
        Session("LivestockOrAvian") = hdfAvianOrLivestock.Value

        oCommon.SaveViewState(ViewState)

        Response.Redirect(GetURL(CallerPages.FarmURL), True)

    End Sub

    Private Sub AddFarm()

        'Changed the previous procedure, to just updating the pull of data for the entire set of farms retrieved.
        'Will mark only farms, herds, and species with "I" to denote inserting for use with current session
        If Not hdfidfFarmActual.Value = "-1" Then
            Dim oFarm As New clsFarm
            Dim dsFarm As DataSet
            Dim dsFarmHerdsSpecies As DataSet = TryCast(ViewState(HERD_SPECIES_DATASET), DataSet)
            Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, oCommon.GetSPList(FARM_HERD_SPECIES_GET_LIST_SP)(0), 3, True)
            Dim iRecordID = dsFarmHerdsSpecies.Tables(0).Rows.Count

            For Each dr As DataRow In dsFarmHerdsSpecies.Tables(0).Rows
                If (Not dr Is Nothing) Then
                    If (dr.Item("idfFarmActual").ToString() = "-1" Or dr.Item("idfFarm").ToString() = "-1") Then
                        dr.Delete()
                    End If
                End If
            Next

            dsFarmHerdsSpecies.AcceptChanges()

            dsFarm = oFarm.ListAllFarmHerdSpecies({strParams})

            For Each dr As DataRow In dsFarm.Tables(0).Rows
                iRecordID += 1
                If (hdfidfFarmActual.Value = dr.Item("idfFarmActual")) Then
                    dr(RecordConstants.RecordAction) = RecordConstants.Insert
                    dr(RecordConstants.RecordID) = iRecordID
                    If dr(RecordConstants.RecordType) = RecordTypeConstants.Herd Then
                        dr(HerdSpeciesConstants.HerdID) = iRecordID
                    ElseIf dr(RecordConstants.RecordType) = RecordTypeConstants.Species Then
                        dr(HerdSpeciesConstants.SpeciesID) = iRecordID
                        dr(HerdSpeciesConstants.HerdID) = dsFarm.Tables(0).Select(RecordConstants.RecordType & " = '" & HerdSpeciesConstants.Herd & "' AND " & HerdSpeciesConstants.HerdActualID & " = " & dr(HerdSpeciesConstants.HerdActualID)).First()(HerdSpeciesConstants.HerdID)
                    End If
                    dsFarmHerdsSpecies.Tables(0).ImportRow(dr)
                End If
            Next

            ViewState(HERD_SPECIES_DATASET) = dsFarmHerdsSpecies
        End If

    End Sub

#End Region

#Region "Animal Methods"

    Private Sub FillAnimals(ByVal refresh As Boolean)

        Try
            Dim dsAnimals As DataSet

            'Save the data set in view state to re-use
            If refresh Then ViewState(ANIMAL_DATASET) = Nothing

            If IsNothing(ViewState(ANIMAL_DATASET)) Then
                Dim oAnimal As clsAnimal = New clsAnimal()
                Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, oCommon.GetSPList(ANIMAL_GET_LIST_SP)(0), 3, True)
                dsAnimals = oAnimal.ListAll({strParams})
            Else
                dsAnimals = CType(ViewState(ANIMAL_GET_LIST_SP), DataSet)
            End If

            Dim primaryKey(0) As DataColumn
            primaryKey(0) = dsAnimals.Tables(0).Columns(AnimalConstants.AnimalID)
            dsAnimals.Tables(0).PrimaryKey = primaryKey

            If dsAnimals.CheckDataSet() Then
                Dim keys(1) As DataColumn
                keys(0) = dsAnimals.Tables(0).Columns(0)
                dsAnimals.Tables(0).PrimaryKey = keys
                ViewState(ANIMAL_DATASET) = dsAnimals

                FillDropDown(ddlSampleidfAnimal, GetType(clsAnimal), Nothing, AnimalConstants.AnimalID, AnimalConstants.AnimalCode, String.Empty, Nothing, True, dsAnimals)
            End If
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub FillBlankAnimals(ByVal refresh As Boolean)

        Try
            Dim dsAnimals As DataSet = New DataSet()

            'Save the data set in view state to re-use
            If refresh Then ViewState(ANIMAL_DATASET) = Nothing

            If IsNothing(ViewState(ANIMAL_DATASET)) Then
                Dim oAnimal As clsAnimal = New clsAnimal()
                Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, oCommon.GetSPList(ANIMAL_GET_LIST_SP)(0), 3, True)
                dsAnimals = oAnimal.ListAll({strParams})
            End If

            Dim primaryKey(0) As DataColumn
            primaryKey(0) = dsAnimals.Tables(0).Columns(AnimalConstants.AnimalID)
            dsAnimals.Tables(0).PrimaryKey = primaryKey

            If dsAnimals.CheckDataSet() Then
                Dim keys(1) As DataColumn
                keys(0) = dsAnimals.Tables(0).Columns(0)
                dsAnimals.Tables(0).PrimaryKey = keys
                ViewState(ANIMAL_DATASET) = dsAnimals
            End If
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Function AddUpdateAnimal(ByVal recordAction As String, ByVal recordID As Long, ByRef animalCode As String) As Long

        Dim dsAnimals As DataSet = TryCast(ViewState(ANIMAL_DATASET), DataSet)
        Dim dr As DataRow

        If recordAction = RecordConstants.Read Or Not recordID = 0 Then
            dr = dsAnimals.Tables(0).Select(AnimalConstants.AnimalID & " = " & recordID).First
        Else
            dr = dsAnimals.Tables(0).NewRow()
        End If

        dr(AnimalConstants.AnimalAgeTypeID) = If(ddlSampleidfsAnimalAge.SelectedValue = "null", DBNull.Value, ddlSampleidfsAnimalAge.SelectedValue)
        dr(AnimalConstants.AnimalAgeTypeName) = If(ddlSampleidfsAnimalAge.SelectedValue = "null", DBNull.Value, ddlSampleidfsAnimalAge.SelectedItem.Text)
        dr(AnimalConstants.AnimalGenderTypeID) = If(ddlSampleidfsAnimalGender.SelectedValue = "null", DBNull.Value, ddlSampleidfsAnimalGender.SelectedValue)
        dr(AnimalConstants.AnimalGenderTypeName) = If(ddlSampleidfsAnimalGender.SelectedValue = "null", DBNull.Value, ddlSampleidfsAnimalGender.SelectedItem.Text)
        dr(AnimalConstants.AnimalName) = If(txtSamplestrName.Text = "", DBNull.Value, txtSamplestrName.Text)
        dr(AnimalConstants.SpeciesID) = If(ddlSampleidfSpecies.SelectedValue = "", DBNull.Value, ddlSampleidfSpecies.SelectedValue)
        dr(AnimalConstants.SpeciesTypeName) = If(ddlSampleidfSpecies.SelectedValue = "", DBNull.Value, ddlSampleidfSpecies.SelectedItem.Text)
        dr(AnimalConstants.Color) = If(txtSamplestrColor.Text = "", DBNull.Value, txtSamplestrColor.Text)

        If recordAction = RecordConstants.Read Or Not recordID = 0 Then
            If dr(AnimalConstants.AnimalID) > 0 Then
                dr(RecordConstants.RecordAction) = RecordConstants.Update
            End If

            UpdateAnimalDependentGrids(TEST_DATASET, CType(ViewState(TEST_DATASET), DataSet), gvTests, dr(AnimalConstants.AnimalID), dr(AnimalConstants.AnimalCode))
            UpdateAnimalDependentGrids(INTERPRETATION_DATASET, CType(ViewState(INTERPRETATION_DATASET), DataSet), gvResultSummaries, dr(AnimalConstants.AnimalID), dr(AnimalConstants.AnimalCode))
        Else
            hdfIdentity.Value += 1
            Dim identity As Integer = (hdfIdentity.Value * -1)
            dr(AnimalConstants.AnimalID) = identity
            dr(AnimalConstants.AnimalCode) = AnimalConstants.Animal & " " & (dsAnimals.Tables(0).Rows.Count).ToString()
            dr(RecordConstants.RowStatus) = RecordConstants.ActiveRowStatus
            dr(RecordConstants.RecordAction) = RecordConstants.Insert
            dsAnimals.Tables(0).Rows.Add(dr)
        End If

        animalCode = dr(AnimalConstants.AnimalCode)

        dsAnimals.AcceptChanges()

        If dsAnimals.CheckDataSet() Then
            ViewState(ANIMAL_DATASET) = dsAnimals

            FillDropDown(ddlSampleidfAnimal, GetType(clsAnimal), Nothing, AnimalConstants.AnimalID, AnimalConstants.AnimalCode, String.Empty, Nothing, True, dsAnimals)
        End If

        Return dr(AnimalConstants.AnimalID)

    End Function

    Private Sub UpdateAnimalDependentGrids(ByVal dataSetName As String, ByVal dataSet As DataSet, ByVal gridView As EIDSSControlLibrary.GridView, ByVal animalID As String, ByVal animalCode As String)

        For Each dr As DataRow In dataSet.Tables(0).Rows
            If dr(AnimalConstants.AnimalID).ToString = animalID Then
                dr(AnimalConstants.AnimalCode) = animalCode
            End If
        Next

        dataSet.AcceptChanges()

        gridView.DataSource = Nothing
        If dataSet.CheckDataSet() Then
            ViewState(dataSetName) = dataSet
            gridView.DataSource = dataSet.Tables(0)
            gridView.DataBind()
        End If

    End Sub

    Private Sub DeleteAnimal(ByVal animalID As Long)

        Dim dsAnimals As DataSet = CType(ViewState(ANIMAL_DATASET), DataSet)
        Dim dr = dsAnimals.Tables(0).Select(AnimalConstants.AnimalID & " = " & animalID).First

        If CanDeleteAnimal(dr(AnimalConstants.AnimalID)) Then
            If dr(RecordConstants.RecordAction) = RecordConstants.Insert Then
                dr.Delete()
            Else
                dr(RecordConstants.RecordAction) = RecordConstants.Delete
                dr(RecordConstants.RowStatus) = RecordConstants.InactiveRowStatus
            End If

            dsAnimals.AcceptChanges()

            If dsAnimals.CheckDataSet() Then
                ViewState(TEST_DATASET) = dsAnimals
                Dim dv As DataView = New DataView(dsAnimals.Tables(0), RecordConstants.RowStatus & " = '" & RecordConstants.ActiveRowStatus & "'", LabTestConstants.LabTestCode, DataViewRowState.CurrentRows)
                Dim filteredDs As DataSet = New DataSet()
                Dim dt As DataTable = dv.ToTable()
                filteredDs.Tables.Add(dt)
                FillDropDown(ddlSampleidfAnimal, GetType(clsAnimal), Nothing, AnimalConstants.AnimalID, AnimalConstants.AnimalCode, String.Empty, Nothing, True, filteredDs)
            End If
        Else
            RaiseEvent ShowWarningModal(messageType:=MessageType.AssociatedInterpretationRecords, isConfirm:=False, message:=Nothing)
        End If

    End Sub

    Public Function CanDeleteAnimal(ByVal animalID As Long) As Boolean

        Dim dsTests As DataSet = TryCast(ViewState(TEST_DATASET), DataSet)

        If dsTests.Tables(0).Select(AnimalConstants.AnimalID & " = " & animalID).Count = 0 Then
            Return True
        Else
            Return False
        End If

        Dim dsInterpretations As DataSet = TryCast(ViewState(INTERPRETATION_DATASET), DataSet)

        If dsInterpretations.Tables(0).Select(AnimalConstants.AnimalID & " = " & animalID).Count = 0 Then
            Return True
        Else
            Return False
        End If

    End Function

#End Region

#Region "Detailed Animal and Sample Methods"

    Private Sub FillSamples(ByVal refresh As Boolean)

        Try
            Dim dsSamples As DataSet

            'Save the data set in view state to re-use
            If refresh Then ViewState(SAMPLE_DATASET) = Nothing

            If IsNothing(ViewState(SAMPLE_DATASET)) Then
                Dim oSample As clsSample = New clsSample()
                Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, oCommon.GetSPList(SAMPLE_GET_LIST_SP)(0), 3, True)
                dsSamples = oSample.ListAll({strParams})
            Else
                dsSamples = CType(ViewState(SAMPLE_DATASET), DataSet)
            End If

            gvSamples.DataSource = Nothing
            If dsSamples.CheckDataSet() Then
                Dim keys(1) As DataColumn
                keys(0) = dsSamples.Tables(0).Columns(0)
                'TODO:Temp fix until I find a better way
                keys.RemoveAt(1)
                dsSamples.Tables(0).PrimaryKey = keys
                ViewState(SAMPLE_DATASET) = dsSamples
                gvSamples.DataSource = dsSamples.Tables(0)
                gvSamples.DataBind()

                If dsSamples.Tables(0).Rows.Count > 0 Then
                    FillDropDown(ddlTestidfMaterial, GetType(clsSample), Nothing, SampleConstants.SampleID, SampleConstants.SampleCode, String.Empty, Nothing, True, dsSamples)
                End If
            End If
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnAddSample_ServerClick(sender As Object, e As EventArgs) Handles btnAddSample.ServerClick

        Try
            ResetSample()

            hdfRecordAction.Value = RecordConstants.Insert

            PopulateSampleDefaults()

            ToggleVisibility(SectionDetailedAnimalAndSample)
            If hdfAvianOrLivestock.Value = HACodeList.Avian Then
                divSampleAnimalContainer1.Visible = False
                divSampleAnimalContainer2.Visible = False
            Else
                divSampleAnimalContainer1.Visible = True
                divSampleAnimalContainer2.Visible = True
            End If

            lblNumberToCopy.Visible = False
            btnCopySample.Visible = False
            txtNumberToCopy.Visible = False
            ddlSampleidfSpecies.Enabled = False

            rvSampleCollectionDate.MinimumValue = txtdatCampaignDateStart.Text
            rvSampleCollectionDate.MaximumValue = txtdatCampaignDateEND.Text

            'Not sure if this is needed...modal screen prevent the touching of this button anyway. keeping for now, until I get a better idea.
            'btnSubmitSession.Enabled = False

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, SHOW_SAMPLE_MODAL, True)
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub ResetSample()

        ddlSampleidfsSampleType.SelectedIndex = -1
        ddlSampleidfFarm.SelectedIndex = -1
        ddlSampleidfSpecies.SelectedIndex = -1
        ddlSampleidfAnimal.SelectedIndex = -1
        ddlSampleidfsAnimalAge.SelectedIndex = -1
        ddlSampleidfsAnimalGender.SelectedIndex = -1
        Dim ddl As System.Web.UI.WebControls.DropDownList = CType(Me.ddlSampleidfsSendToOffice.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
        ddl.SelectedIndex = -1
        ddlSampleidfSpecies.SelectedIndex = -1
        txtSamplestrColor.Text = ""
        txtSampledatFieldCollectionDate.Text = ""
        txtSamplestrCondition.Text = ""
        txtSamplestrFieldBarCode.Text = ""
        txtSamplestrNote.Text = ""
        hdfRecordID.Value = "0"
        hdfRecordAction.Value = ""

    End Sub

    Private Sub PopulateSampleDefaults()

        Dim dsSamples As DataSet = TryCast(ViewState(SAMPLE_DATASET), DataSet)

        If dsSamples.Tables(0).Rows.Count > 0 Then
            Dim ddl As System.Web.UI.WebControls.DropDownList = CType(Me.ddlSampleidfsSendToOffice.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
            If (Not ddl Is Nothing) Then
                If ddl.Items.Count > 1 Then
                    ddl.SelectedValue = dsSamples.Tables(0).Rows(dsSamples.Tables(0).Rows.Count)(SampleConstants.SendToOfficeID)
                End If
            End If
        End If

    End Sub

    Protected Sub btnSampleOK_Click(sender As Object, e As EventArgs) Handles btnSampleOK.Click

        Try
            Dim dsSamples As DataSet = TryCast(ViewState(SAMPLE_DATASET), DataSet)
            Dim dr As DataRow

            If hdfRecordAction.Value = RecordConstants.Read Or Not hdfRecordID.Value = "0" Then
                dr = dsSamples.Tables(0).Select(SampleConstants.SampleID & " = " & hdfRecordID.Value).First
            Else
                dr = dsSamples.Tables(0).NewRow()
            End If

            If (Not IsValueNullOrEmpty(ddlSampleidfsSampleType.SelectedValue)) Then

                dr(SampleTypeConstants.SampleTypeID) = If(ddlSampleidfsSampleType.SelectedValue.Replace("null", "") = "", DBNull.Value, ddlSampleidfsSampleType.SelectedValue)
                dr(SampleTypeConstants.SampleTypeName) = If(ddlSampleidfsSampleType.SelectedValue.Replace("null", "") = "", DBNull.Value, ddlSampleidfsSampleType.SelectedItem.Text)
                dr(SampleConstants.SampleCode) = If(txtSamplestrFieldBarCode.Text = "", DBNull.Value, txtSamplestrFieldBarCode.Text)
                dr(FarmConstants.FarmID) = If(ddlSampleidfFarm.SelectedValue = "", DBNull.Value, ddlSampleidfFarm.SelectedValue)
                dr(FarmConstants.FarmCode) = If(ddlSampleidfFarm.SelectedValue = "", DBNull.Value, ddlSampleidfFarm.SelectedItem.Text)
                dr(HerdSpeciesConstants.SpeciesID) = If(ddlSampleidfSpecies.SelectedValue.Replace("null", "") = "", DBNull.Value, ddlSampleidfSpecies.SelectedValue)
                dr(HerdSpeciesConstants.SpeciesTypeName) = If(ddlSampleidfSpecies.SelectedValue.Replace("null", "") = "", DBNull.Value, ddlSampleidfSpecies.SelectedItem.Text)

                Dim animalCode As String = ""
                If hdfAvianOrLivestock.Value = HACodeList.Livestock Then
                    If ddlSampleidfAnimal.SelectedValue = "null" Then
                        dr(AnimalConstants.AnimalID) = AddUpdateAnimal(RecordConstants.Insert, 0, animalCode)
                    Else
                        dr(AnimalConstants.AnimalID) = If(ddlSampleidfAnimal.SelectedValue = "null", DBNull.Value, ddlSampleidfAnimal.SelectedValue)
                        dr(AnimalConstants.AnimalCode) = If(ddlSampleidfAnimal.SelectedValue = "null", DBNull.Value, ddlSampleidfAnimal.SelectedItem.Text)

                        AddUpdateAnimal(RecordConstants.Update, ddlSampleidfAnimal.SelectedValue, animalCode)
                    End If
                End If
                dr(AnimalConstants.AnimalCode) = animalCode

                dr(SampleConstants.FieldCollectionDate) = If(txtSampledatFieldCollectionDate.Text = "", DBNull.Value, Convert.ToDateTime(txtSampledatFieldCollectionDate.Text))
                dr(SampleConstants.ConditionReceived) = If(txtSamplestrCondition.Text = "", DBNull.Value, txtSamplestrCondition.Text)
                dr(SampleConstants.Note) = If(txtSamplestrNote.Text = "", DBNull.Value, txtSamplestrNote.Text)
                Dim ddl As System.Web.UI.WebControls.DropDownList = CType(Me.ddlSampleidfsSendToOffice.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
                dr(SampleConstants.SendToOfficeID) = If(ddl.SelectedValue = "null", DBNull.Value, ddl.SelectedValue)
                dr(SampleConstants.SendToOfficeName) = If(ddl.SelectedValue = "null", DBNull.Value, ddl.SelectedItem.Text)
                dr(SampleConstants.Site) = hdfidfsSite.Value
                dr(SampleConstants.ReadOnlyIndicator) = 0

                If hdfRecordAction.Value = RecordConstants.Read Or Not hdfRecordID.Value = "0" Then
                    If dr(SampleConstants.SampleID) > 0 Then
                        dr(RecordConstants.RecordAction) = RecordConstants.Update
                    End If
                Else
                    hdfIdentity.Value += 1
                    Dim identity As Integer = (hdfIdentity.Value * -1)
                    dr(SampleConstants.SampleID) = identity
                    dr(RecordConstants.RowStatus) = RecordConstants.ActiveRowStatus
                    dr(RecordConstants.RecordAction) = RecordConstants.Insert
                    dsSamples.Tables(0).Rows.Add(dr)
                End If

                dsSamples.AcceptChanges()

                gvSamples.DataSource = Nothing
                If dsSamples.CheckDataSet() Then
                    ViewState(SAMPLE_DATASET) = dsSamples
                    Dim dv As DataView = New DataView(dsSamples.Tables(0), RecordConstants.RowStatus & " = '" & RecordConstants.ActiveRowStatus & "'", SampleConstants.SampleCode, DataViewRowState.CurrentRows)
                    gvSamples.DataSource = dv
                    gvSamples.DataBind()

                    FillDropDown(ddlTestidfMaterial, GetType(clsSample), Nothing, SampleConstants.SampleID, SampleConstants.SampleCode, String.Empty, Nothing, True, dsSamples)
                End If
            End If

            ResetSample()

            RollUpSampleCounts()

            ToggleVisibility(SectionDetailedAnimalsAndSamples)

            btnSubmit.Enabled = True

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, HIDE_SAMPLE_MODAL, True)
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub UpdateSampleDependentGrids(ByVal dataSetName As String, ByVal dataSet As DataSet, ByVal gridView As EIDSSControlLibrary.GridView, ByVal sampleID As Long, ByVal sampleCode As String, ByVal sampleTypeName As String)

        For Each dr As DataRow In dataSet.Tables(0).Rows
            If dr(SampleConstants.SampleID).ToString = sampleID Then
                dr(SampleConstants.SampleCode) = sampleCode
                dr(SampleTypeConstants.SampleTypeName) = sampleTypeName
            End If
        Next

        dataSet.AcceptChanges()

        gridView.DataSource = Nothing
        If dataSet.CheckDataSet() Then
            ViewState(dataSetName) = dataSet
            gridView.DataSource = dataSet.Tables(0)
            gridView.DataBind()
        End If

    End Sub

    Private Sub UpdateSampleDependentGrids(ByVal dataSetName As String, ByVal dataSet As DataSet, ByVal gridView As EIDSSControlLibrary.GridView, ByVal sampleID As Long, ByVal sampleCode As String, ByVal sampleTypeName As String, ByVal animalCode As String)

        For Each dr As DataRow In dataSet.Tables(0).Rows
            If dr(SampleConstants.SampleID).ToString = sampleID Then
                dr(SampleConstants.SampleCode) = sampleCode
                dr(SampleTypeConstants.SampleTypeName) = sampleTypeName
                dr(AnimalConstants.AnimalCode) = animalCode
            End If
        Next

        dataSet.AcceptChanges()

        gridView.DataSource = Nothing
        If dataSet.CheckDataSet() Then
            ViewState(dataSetName) = dataSet
            gridView.DataSource = dataSet.Tables(0)
            gridView.DataBind()
        End If

    End Sub

    Protected Sub gvSamples_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvSamples.RowDataBound

        Try
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim dr As DataRowView = TryCast(e.Row.DataItem, DataRowView)
                If Not dr Is Nothing Then
                    Dim lnbEditSample As LinkButton = CType(e.Row.FindControl("btnEditSample"), LinkButton)
                    hdfidfRootMaterial.Value = lnbEditSample.CommandArgument

                    Dim gvAliquots As EIDSSControlLibrary.GridView = e.Row.FindControl("gvAliquots")
                    gvAliquots.DataSource = FillAliqouts(CType(hdfidfRootMaterial.Value, Long))
                    gvAliquots.DataBind()

                    Dim expandCollapseSampleAliquotDetails As HtmlAnchor = e.Row.FindControl("expandCollapseSampleAliquotDetails")
                    expandCollapseSampleAliquotDetails.Disabled = False
                End If
            End If
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub gvSamples_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSamples.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    DeleteSample(CType(e.CommandArgument, Long))
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditSample(CType(e.CommandArgument, Long))
            End Select
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub EditSample(sampleID As Long)

        Dim dsSamples As DataSet = CType(ViewState(SAMPLE_DATASET), DataSet)
        Dim dsAnimals As DataSet = CType(ViewState(ANIMAL_DATASET), DataSet)
        Dim dr = dsSamples.Tables(0).Select(SampleConstants.SampleID & " = " & sampleID).First
        Dim drAnimal = dsAnimals.Tables(0).Select(AnimalConstants.AnimalID & " = " & dr(AnimalConstants.AnimalID)).First

        If Not dr Is Nothing Then
            ddlSampleidfFarm.SelectedValue = If(dr(FarmConstants.FarmID).ToString = "", "null", dr(FarmConstants.FarmID))
            If ddlSampleidfFarm.SelectedValue = "null" Then
                ddlSampleidfSpecies.Enabled = False
            Else
                ddlSampleidfSpecies.Enabled = True
                ddlSampleidfSpecies.SelectedValue = If(dr(HerdSpeciesConstants.SpeciesID).ToString = "", "null", dr(HerdSpeciesConstants.SpeciesID))
            End If
            ddlSampleidfAnimal.SelectedValue = If(dr(AnimalConstants.AnimalID).ToString = "", "null", dr(AnimalConstants.AnimalID))

            If Not drAnimal Is Nothing Then
                ddlSampleidfsAnimalAge.SelectedValue = If(drAnimal(AnimalConstants.AnimalAgeTypeID).ToString = "", "null", drAnimal(AnimalConstants.AnimalAgeTypeID))
                ddlSampleidfsAnimalGender.SelectedValue = If(drAnimal(AnimalConstants.AnimalGenderTypeID).ToString = "", "null", drAnimal(AnimalConstants.AnimalGenderTypeID))
                txtSamplestrColor.Text = If(drAnimal(AnimalConstants.Color).ToString = "", "", drAnimal(AnimalConstants.Color))
                txtSamplestrName.Text = If(drAnimal(AnimalConstants.AnimalName).ToString = "", "", drAnimal(AnimalConstants.AnimalName))
            End If

            ddlSampleidfsSampleType.SelectedValue = If(dr(SampleTypeConstants.SampleTypeID).ToString = "", "null", dr(SampleTypeConstants.SampleTypeID))
            Dim ddl As System.Web.UI.WebControls.DropDownList = CType(Me.ddlSampleidfsSendToOffice.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
            ddl.SelectedValue = If(dr(SampleConstants.SendToOfficeID).ToString = "", "null", dr(SampleConstants.SendToOfficeID))
            txtSampledatFieldCollectionDate.Text = If(dr(SampleConstants.FieldCollectionDate).ToString = "", "", dr(SampleConstants.FieldCollectionDate))
            txtSamplestrCondition.Text = If(dr(SampleConstants.ConditionReceived).ToString = "", "", dr(SampleConstants.ConditionReceived))
            txtSamplestrFieldBarCode.Text = If(dr(SampleConstants.SampleCode).ToString = "", "", dr(SampleConstants.SampleCode))
            txtSamplestrNote.Text = If(dr(SampleConstants.Note).ToString = "", "", dr(SampleConstants.Note))
            hdfRecordID.Value = dr(SampleConstants.SampleID)
            hdfRecordAction.Value = dr(RecordConstants.RecordAction).ToString

            ToggleVisibility(SectionDetailedAnimalAndSample)
            If hdfAvianOrLivestock.Value = HACodeList.Avian Then
                divSampleAnimalContainer1.Visible = False
                divSampleAnimalContainer2.Visible = False
            Else
                divSampleAnimalContainer1.Visible = True
                divSampleAnimalContainer2.Visible = True
            End If
            lblNumberToCopy.Visible = True
            btnCopySample.Visible = True
            txtNumberToCopy.Visible = True

            rvSampleCollectionDate.MinimumValue = txtdatCampaignDateStart.Text
            rvSampleCollectionDate.MaximumValue = txtdatCampaignDateEND.Text

            'Not sure if this is needed...modal screen prevent the touching of this button anyway. keeping for now, until I get a better idea.
            'btnSubmitSession.Enabled = False

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, SHOW_SAMPLE_MODAL, True)
        End If

    End Sub

    Private Sub DeleteSample(sampleID As Long)

        ViewState("Action") = "DeleteSample"
        ViewState("sampleID") = sampleID
        RaiseEvent ShowWarningModal(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Nothing)

    End Sub

    Private Function FillAliqouts(ByVal rootMaterialID As Long) As DataSet

        Dim oSample As clsSample = New clsSample()
        Dim strParams As String = oCommon.Gather(divLabModuleFields, oCommon.GetSPList(SAMPLE_GET_LIST_SP)(0), 3, True)
        Dim dsAliquots As DataSet = oSample.ListAllAliquots({strParams})

        If dsAliquots.CheckDataSet() Then
            Dim keys(1) As DataColumn
            keys(0) = dsAliquots.Tables(0).Columns(0)
            dsAliquots.Tables(0).PrimaryKey = keys
        End If

        FillAliqouts = dsAliquots

    End Function

    Protected Sub btnDeleteSelectedSamples_Click(sender As Object, e As EventArgs) Handles btnDeleteSelectedSamples.ServerClick

        Try
            Dim button As LinkButton
            RaiseEvent ShowWarningModal(messageType:=MessageType.ConfirmDelete, isConfirm:=False, message:=Nothing)

            For Each gvr As GridViewRow In gvSamples.Rows
                If (CType(gvr.FindControl("chkDeleteSample"), CheckBox)).Checked = True Then
                    button = CType(gvr.FindControl("btnEditSample"), LinkButton)
                    DeleteSample(button.CommandArgument)
                End If
            Next

            RollUpSampleCounts()
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub ddlSampleidfFarm_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlSampleidfFarm.SelectedIndexChanged

        Dim dsFarmHerdSpecies As DataSet = CType(ViewState(HERD_SPECIES_DATASET), DataSet)

        If ddlSampleidfFarm.SelectedValue = "" Then
            ddlSampleidfSpecies.Enabled = False
        Else
            Dim li As ListItem = New ListItem
            Dim dsSpeciesAndSamples As DataSet = TryCast(ViewState(SPECIES_AND_SAMPLES_DATASET), DataSet)
            ddlSampleidfSpecies.Items.Clear()
            If ddlSampleidfSpecies.Items.Count = 0 Then
                li.Value = ""
                li.Text = ""
                li.Selected = False
                ddlSampleidfSpecies.Items.Add(li)
            End If

            For Each drFarmSpecies As DataRow In dsFarmHerdSpecies.Tables(0).Rows
                If drFarmSpecies(RecordConstants.RecordType).ToString() = RecordTypeConstants.Species And drFarmSpecies(FarmConstants.FarmCode) = ddlSampleidfFarm.SelectedItem.Text Then
                    If dsSpeciesAndSamples.Tables(0).Select(HerdSpeciesConstants.SpeciesTypeID & " = " & drFarmSpecies(HerdSpeciesConstants.SpeciesTypeID).ToString()).Count > 0 Then
                        li = New ListItem
                        li.Value = If(drFarmSpecies(HerdSpeciesConstants.SpeciesID).ToString = "", drFarmSpecies(HerdSpeciesConstants.SpeciesActualID), drFarmSpecies(HerdSpeciesConstants.SpeciesID))
                        li.Text = drFarmSpecies(HerdSpeciesConstants.SpeciesTypeName)
                        li.Selected = False
                        ddlSampleidfSpecies.Items.Add(li)
                    End If
                End If
            Next
            ddlSampleidfSpecies = SortDropDownList(ddlSampleidfSpecies)
            ddlSampleidfSpecies.Enabled = True
        End If

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, SHOW_SAMPLE_MODAL, True)

    End Sub

    Protected Sub btnCopySample_Click(sender As Object, e As EventArgs) Handles btnCopySample.Click

        Try
            Dim btn As Button = sender
            Dim value As Integer = 0
            Dim identity As Integer
            Dim numberToCopy = IIf(Int64.TryParse(txtNumberToCopy.Text, value), value, 1)
            Dim dsSamples As DataSet = CType(ViewState(SAMPLE_DATASET), DataSet)
            Dim dr = dsSamples.Tables(0).Select(SampleConstants.SampleID & " = " & hdfRecordID.Value).First
            Dim bAnimalSelected As Boolean = False

            If hdfAvianOrLivestock.Value = HACodeList.Livestock Then
                If Not ddlSampleidfAnimal.SelectedValue = "null" Then
                    bAnimalSelected = True
                End If
            End If

            If Not dr Is Nothing Then
                For i As Integer = 1 To numberToCopy
                    dr = dsSamples.Tables(0).NewRow()
                    dr(FarmConstants.FarmID) = If(ddlSampleidfFarm.SelectedValue = "", DBNull.Value, ddlSampleidfFarm.SelectedValue)
                    dr(FarmConstants.FarmCode) = If(ddlSampleidfFarm.SelectedValue = "", DBNull.Value, ddlSampleidfFarm.SelectedItem.Text)
                    dr(SampleTypeConstants.SampleTypeID) = If(ddlSampleidfsSampleType.SelectedValue = "null", DBNull.Value, ddlSampleidfsSampleType.SelectedValue)
                    dr(SampleTypeConstants.SampleTypeName) = If(ddlSampleidfsSampleType.SelectedValue = "null", DBNull.Value, ddlSampleidfsSampleType.SelectedItem.Text)
                    dr(HerdSpeciesConstants.SpeciesID) = If(ddlSampleidfSpecies.SelectedValue.Replace("null", "") = "", DBNull.Value, ddlSampleidfSpecies.SelectedValue)
                    dr(HerdSpeciesConstants.SpeciesTypeName) = If(ddlSampleidfSpecies.SelectedValue.Replace("null", "") = "", DBNull.Value, ddlSampleidfSpecies.SelectedItem.Text)

                    Dim animalCode As String = ""
                    If bAnimalSelected = True Then
                        dr(AnimalConstants.AnimalID) = AddUpdateAnimal(RecordConstants.Insert, 0, animalCode)
                        dr(AnimalConstants.AnimalCode) = animalCode
                    End If

                    dr(SampleConstants.FieldCollectionDate) = If(txtSampledatFieldCollectionDate.Text = "", DBNull.Value, Convert.ToDateTime(txtSampledatFieldCollectionDate.Text))
                    dr(SampleConstants.ConditionReceived) = If(txtSamplestrCondition.Text = "", DBNull.Value, txtSamplestrCondition.Text)
                    dr(SampleConstants.Note) = If(txtSamplestrNote.Text = "", DBNull.Value, txtSamplestrNote.Text)
                    Dim ddl As System.Web.UI.WebControls.DropDownList = CType(Me.ddlSampleidfsSendToOffice.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
                    dr(SampleConstants.SendToOfficeID) = If(ddl.SelectedValue = "null", DBNull.Value, ddl.SelectedValue)
                    dr(SampleConstants.SendToOfficeName) = If(ddl.SelectedValue = "null", DBNull.Value, ddl.SelectedItem.Text)
                    dr(SampleConstants.Site) = hdfidfsSite.Value
                    dr(SampleConstants.ReadOnlyIndicator) = 0

                    hdfIdentity.Value += 1
                    identity = (hdfIdentity.Value * -1)
                    dr(SampleConstants.SampleID) = identity
                    dr(RecordConstants.RowStatus) = RecordConstants.ActiveRowStatus
                    dr(RecordConstants.RecordAction) = RecordConstants.Insert

                    dsSamples.Tables(0).Rows.Add(dr)
                Next
            End If

            dsSamples.AcceptChanges()

            If dsSamples.CheckDataSet() Then
                ViewState(SAMPLE_DATASET) = dsSamples
                gvSamples.DataSource = dsSamples.Tables(0)
                gvSamples.DataBind()
            End If

            ResetSample()

            RollUpSampleCounts()

            ToggleVisibility(SectionDetailedAnimalsAndSamples)

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, HIDE_SAMPLE_MODAL, True)
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub RollUpSampleCounts()

        Dim dsSamples As DataSet = CType(ViewState(SAMPLE_DATASET), DataSet)
        txtTotalNumberSamples.Text = dsSamples.Tables(0).Rows.Count.ToString
        Dim distinctAnimalSample As DataTable = dsSamples.Tables(0).DefaultView.ToTable(True, AnimalConstants.AnimalCode)
        txtTotalNumberAnimalsSampled.Text = distinctAnimalSample.Rows.Count.ToString

    End Sub

    Public Function CanDeleteSample(ByVal sampleID As Long) As Boolean

        Dim dsTests As DataSet = TryCast(ViewState(TEST_DATASET), DataSet)

        If dsTests.Tables(0).Select(SampleConstants.SampleID & " = " & sampleID & " AND intRowStatus = 0").Count = 0 Then
            Return True
        Else
            Return False
        End If

    End Function

#End Region

#Region "Testing Methods"

    Private Sub FillTests(ByVal refresh As Boolean)

        Try
            Dim dsTests As DataSet

            'Save the data set in view state to re-use
            If refresh Then ViewState(TEST_DATASET) = Nothing

            If IsNothing(ViewState(TEST_DATASET)) Then
                Dim oTest As clsTest = New clsTest()
                Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, oCommon.GetSPList(TEST_GET_LIST_SP)(0), 3, True)
                dsTests = oTest.ListAll({strParams})
            Else
                dsTests = CType(ViewState(TEST_DATASET), DataSet)
            End If

            gvTests.DataSource = Nothing
            If dsTests.CheckDataSet() Then
                Dim keys(1) As DataColumn
                keys(0) = dsTests.Tables(0).Columns(0)
                dsTests.Tables(0).PrimaryKey = keys
                ViewState(TEST_DATASET) = dsTests
                gvTests.DataSource = dsTests.Tables(0)
                gvTests.DataBind()
            End If
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnAddTest_Click(sender As Object, e As EventArgs) Handles btnAddTest.ServerClick

        Try
            ResetTest()

            hdfRecordAction.Value = RecordConstants.Insert

            ToggleVisibility(SectionTest)
            If hdfAvianOrLivestock.Value = HACodeList.Avian Then
                divTestAnimalContainer.Visible = False
            Else
                divTestAnimalContainer.Visible = True
            End If

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, SHOW_TEST_MODAL, True)
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub ResetTest()

        ddlTestidfMaterial.SelectedIndex = -1

        Dim ddlTestCategory As System.Web.UI.WebControls.DropDownList = CType(Me.ddlTestidfsTestCategory.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
        ddlTestCategory.SelectedIndex = -1

        Dim ddlTestName As System.Web.UI.WebControls.DropDownList = CType(Me.ddlTestidfsTestName.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
        ddlTestName.SelectedIndex = -1

        Dim ddlTestResult As System.Web.UI.WebControls.DropDownList = CType(Me.ddlTestidfsTestResult.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
        ddlTestResult.SelectedIndex = -1

        txtTeststrFarmCode.Text = ""
        txtTestdatConcludedDate.Text = ""
        txtTestDiagnosis.Text = ddlidfsDiagnosis.SelectedItem.Text
        txtTeststrAnimalCode.Text = ""
        txtTestSampleTypeName.Text = ""
        txtTeststrBarCode.Text = ""
        txtTestTestStatus.Text = Resources.Labels.Lbl_Final_Text
        hdfRecordID.Value = "0"
        hdfRecordAction.Value = ""

    End Sub

    Protected Sub btnTestOK_Click(sender As Object, e As EventArgs) Handles btnTestOK.Click

        Try
            Dim dsTests As DataSet = TryCast(ViewState(TEST_DATASET), DataSet)
            Dim dr As DataRow

            If hdfRecordAction.Value = RecordConstants.Read Or Not hdfRecordID.Value = "0" Then
                dr = dsTests.Tables(0).Select(LabTestConstants.LabTestID & " = " & hdfRecordID.Value).First
            Else
                dr = dsTests.Tables(0).NewRow()
            End If

            dr(SampleConstants.SampleID) = If(ddlTestidfMaterial.SelectedValue = "", DBNull.Value, ddlTestidfMaterial.SelectedValue)
            dr(SampleConstants.SampleCode) = If(ddlTestidfMaterial.SelectedValue = "", DBNull.Value, ddlTestidfMaterial.SelectedItem.Text)

            Dim dsSamples As DataSet = CType(ViewState(SAMPLE_DATASET), DataSet)
            Dim drSample = dsSamples.Tables(0).Select(SampleConstants.SampleID & " = " & ddlTestidfMaterial.SelectedValue).First
            If Not drSample Is Nothing Then
                dr(FarmConstants.FarmID) = If(drSample(FarmConstants.FarmID).ToString = "", DBNull.Value, drSample(FarmConstants.FarmID))
                dr(FarmConstants.FarmCode) = If(drSample(FarmConstants.FarmCode).ToString = "", DBNull.Value, drSample(FarmConstants.FarmCode))
                dr(HerdSpeciesConstants.SpeciesID) = If(drSample(HerdSpeciesConstants.SpeciesID).ToString = "", DBNull.Value, drSample(HerdSpeciesConstants.SpeciesID))
                dr(HerdSpeciesConstants.SpeciesTypeName) = If(drSample(HerdSpeciesConstants.SpeciesTypeName).ToString = "", DBNull.Value, drSample(HerdSpeciesConstants.SpeciesTypeName))
                dr(AnimalConstants.AnimalID) = If(drSample(AnimalConstants.AnimalID).ToString = "", DBNull.Value, drSample(AnimalConstants.AnimalID))
                dr(AnimalConstants.AnimalCode) = If(drSample(AnimalConstants.AnimalCode) = "", DBNull.Value, drSample(AnimalConstants.AnimalCode))
            End If

            Dim ddlTestCategory As System.Web.UI.WebControls.DropDownList = CType(Me.ddlTestidfsTestCategory.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
            dr(LabTestConstants.TestCategoryTypeID) = If(ddlTestCategory.SelectedValue = "null", DBNull.Value, ddlTestCategory.SelectedValue)
            dr(LabTestConstants.TestCategoryTypeName) = If(ddlTestCategory.SelectedValue = "null", DBNull.Value, ddlTestCategory.SelectedItem.Text)

            Dim ddlTestName As System.Web.UI.WebControls.DropDownList = CType(Me.ddlTestidfsTestName.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
            dr(LabTestConstants.TestNameTypeID) = If(ddlTestName.SelectedValue = "null", DBNull.Value, ddlTestName.SelectedValue)
            dr(LabTestConstants.TestNameTypeName) = If(ddlTestName.SelectedValue = "null", DBNull.Value, ddlTestName.SelectedItem.Text)

            dr(LabTestConstants.ConcludedDate) = If(txtTestdatConcludedDate.Text = "", DBNull.Value, Convert.ToDateTime(txtTestdatConcludedDate.Text))
            dr(LabTestConstants.DiseaseID) = ddlidfsDiagnosis.SelectedValue
            dr(LabTestConstants.DiseaseName) = ddlidfsDiagnosis.SelectedItem.Text
            dr(SampleTypeConstants.SampleTypeName) = If(txtTestSampleTypeName.Text = "", DBNull.Value, txtTestSampleTypeName.Text)
            dr(LabTestConstants.LabTestCode) = If(txtTeststrBarCode.Text = "", DBNull.Value, txtTeststrBarCode.Text)

            Dim ddlTestResult As System.Web.UI.WebControls.DropDownList = CType(Me.ddlTestidfsTestResult.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
            dr(LabTestConstants.TestResultTypeID) = If(ddlTestResult.SelectedValue = "null", DBNull.Value, ddlTestResult.SelectedValue)
            dr(LabTestConstants.TestResultTypeName) = If(ddlTestResult.SelectedValue = "null", DBNull.Value, ddlTestResult.SelectedItem.Text)

            'Entered by epidemiologist, default to final.
            dr(LabTestConstants.TestStatusTypeID) = TestStatusTypes.Final
            dr(LabTestConstants.TestStatusTypeName) = Resources.Labels.Lbl_Final_Text

            'TODO: Observation needs to be addressed.  This is part of flex forms.
            dr(LabTestConstants.ObservationID) = 0
            dr(LabTestConstants.ReadOnlyIndicator) = 1
            dr(LabTestConstants.NonLaboratoryTestIndicator) = 1

            dr(AnimalConstants.AnimalCode) = If(txtTeststrAnimalCode.Text = "", DBNull.Value, txtTeststrAnimalCode.Text)

            If hdfRecordAction.Value = RecordConstants.Read Or Not hdfRecordID.Value = "0" Then
                If dr(LabTestConstants.LabTestID) > 0 Then
                    dr(RecordConstants.RecordAction) = RecordConstants.Update
                End If

                UpdateTestDependentGrids(INTERPRETATION_DATASET,
                                         CType(ViewState(INTERPRETATION_DATASET), DataSet),
                                         gvResultSummaries,
                                         dr(LabTestConstants.LabTestID),
                                         dr(LabTestConstants.TestNameTypeID),
                                         dr(LabTestConstants.TestNameTypeName),
                                         dr(LabTestConstants.TestCategoryTypeID),
                                         dr(LabTestConstants.TestCategoryTypeName),
                                         dr(LabTestConstants.TestResultTypeID),
                                         dr(LabTestConstants.TestResultTypeName))
            Else
                hdfIdentity.Value += 1
                Dim identity As Integer = (hdfIdentity.Value * -1)
                dr(LabTestConstants.LabTestID) = identity
                dr(RecordConstants.RowStatus) = RecordConstants.ActiveRowStatus
                dr(RecordConstants.RecordAction) = RecordConstants.Insert
                dsTests.Tables(0).Rows.Add(dr)
            End If

            dsTests.AcceptChanges()

            gvTests.DataSource = Nothing
            If dsTests.CheckDataSet() Then
                ViewState(TEST_DATASET) = dsTests
                Dim dv As DataView = New DataView(dsTests.Tables(0), RecordConstants.RowStatus & " = '" & RecordConstants.ActiveRowStatus & "'", LabTestConstants.LabTestCode, DataViewRowState.CurrentRows)
                gvTests.DataSource = dv
                gvTests.DataBind()
            End If

            ResetTest()

            ToggleVisibility(SectionTestsResultSummaries)

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, HIDE_TEST_MODAL, True)
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub UpdateTestDependentGrids(ByVal dataSetName As String,
                                         ByVal dataSet As DataSet,
                                         ByVal gridView As EIDSSControlLibrary.GridView,
                                         ByVal labTestID As Long,
                                         ByVal testNameTypeID As Long,
                                         ByVal testNameTypeName As String,
                                         ByVal testCategoryTypeID As Long,
                                         ByVal testCategoryTypeName As String,
                                         ByVal testResultTypeID As Long,
                                         ByVal testResultTypeName As String)

        For Each dr As DataRow In dataSet.Tables(0).Rows
            If dr(LabTestConstants.LabTestID).ToString = labTestID Then
                dr(LabTestConstants.TestNameTypeID) = testNameTypeID
                dr(LabTestConstants.TestNameTypeName) = testNameTypeName
                dr(LabTestConstants.TestCategoryTypeID) = testCategoryTypeID
                dr(LabTestConstants.TestCategoryTypeName) = testCategoryTypeName
                dr(LabTestConstants.TestResultTypeID) = testResultTypeID
                dr(LabTestConstants.TestResultTypeName) = testResultTypeName
            End If
        Next

        dataSet.AcceptChanges()

        gridView.DataSource = Nothing
        If dataSet.CheckDataSet() Then
            ViewState(dataSetName) = dataSet
            gridView.DataSource = dataSet.Tables(0)
            gridView.DataBind()
        End If

    End Sub

    Protected Sub gvTests_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvTests.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    DeleteTest(CType(e.CommandArgument, Long))
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditTest(CType(e.CommandArgument, Long))
                Case GridViewCommandConstants.NewInterpretationCommand
                    e.Handled = True
                    NewInterpretation(CType(e.CommandArgument, Long))
            End Select
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub EditTest(labTestID As Long)

        Dim dsLabTests As DataSet = CType(ViewState(TEST_DATASET), DataSet)
        Dim dr = dsLabTests.Tables(0).Select(LabTestConstants.LabTestID & " = " & labTestID).First

        If Not dr Is Nothing Then
            ddlTestidfMaterial.SelectedValue = If(dr(SampleConstants.SampleID).ToString = "", "", dr(SampleConstants.SampleID))

            Dim ddlTestCategory As System.Web.UI.WebControls.DropDownList = CType(Me.ddlTestidfsTestCategory.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
            ddlTestCategory.SelectedValue = If(dr(LabTestConstants.TestCategoryTypeID).ToString = "", "null", dr(LabTestConstants.TestCategoryTypeID))

            Dim ddlTestName As System.Web.UI.WebControls.DropDownList = CType(Me.ddlTestidfsTestName.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
            ddlTestName.SelectedValue = If(dr(LabTestConstants.TestNameTypeID).ToString = "", "null", dr(LabTestConstants.TestNameTypeID))

            Dim ddlTestResult As System.Web.UI.WebControls.DropDownList = CType(Me.ddlTestidfsTestResult.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
            ddlTestResult.SelectedValue = If(dr(LabTestConstants.TestResultTypeID).ToString = "", "null", dr(LabTestConstants.TestResultTypeID))

            txtTestdatConcludedDate.Text = If(dr(LabTestConstants.ConcludedDate).ToString = "", "", dr(LabTestConstants.ConcludedDate))
            txtTestDiagnosis.Text = If(dr(LabTestConstants.DiseaseName).ToString = "", "", dr(LabTestConstants.DiseaseName))
            txtTestSampleTypeName.Text = If(dr(SampleTypeConstants.SampleTypeName).ToString = "", "", dr(SampleTypeConstants.SampleTypeName))
            txtTeststrBarCode.Text = If(dr(LabTestConstants.LabTestCode).ToString = "", "", dr(LabTestConstants.LabTestCode))
            txtTestTestStatus.Text = If(dr(LabTestConstants.TestStatusTypeName).ToString = "", "", dr(LabTestConstants.TestStatusTypeName))
            txtTeststrFarmCode.Text = If(dr(FarmConstants.FarmCode).ToString = "", "", dr(FarmConstants.FarmCode))
            txtTeststrAnimalCode.Text = If(dr(AnimalConstants.AnimalCode).ToString = "", "", dr(AnimalConstants.AnimalCode))
            hdfRecordID.Value = dr(LabTestConstants.LabTestID)
            hdfRecordAction.Value = dr(RecordConstants.RecordAction).ToString

            ToggleVisibility(SectionTest)
            If hdfAvianOrLivestock.Value = HACodeList.Avian Then
                divTestAnimalContainer.Visible = False
            Else
                divTestAnimalContainer.Visible = True
            End If

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, SHOW_TEST_MODAL, True)
        End If

    End Sub

    Private Sub DeleteTest(labTestID As Long)

        ViewState("Action") = "DeleteTest"
        ViewState("labTestID") = labTestID
        RaiseEvent ShowWarningModal(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Nothing)

    End Sub

    Public Function CanDeleteTest(ByVal labTestID As Long) As Boolean

        Dim dsInterpretations As DataSet = TryCast(ViewState(INTERPRETATION_DATASET), DataSet)

        If dsInterpretations.Tables(0).Select(LabTestConstants.LabTestID & " = " & labTestID).Count = 0 Then
            Return True
        Else
            Return False
        End If

    End Function

    Protected Sub ddlTestidfMaterial_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlTestidfMaterial.SelectedIndexChanged

        Dim dsSamples As DataSet = TryCast(ViewState(SAMPLE_DATASET), DataSet)

        If Not ddlTestidfMaterial.SelectedValue = Nothing Then
            Dim dr As DataRow = dsSamples.Tables(0).Select(SampleConstants.SampleID & " = " & ddlTestidfMaterial.SelectedValue).First

            txtTeststrAnimalCode.Text = If(dr(AnimalConstants.AnimalCode).ToString = "", "", dr(AnimalConstants.AnimalCode))
            txtTestSampleTypeName.Text = If(dr(SampleTypeConstants.SampleTypeName).ToString = "", "", dr(SampleTypeConstants.SampleTypeName))
            txtTeststrFarmCode.Text = If(dr(FarmConstants.FarmCode).ToString = "", "", dr(FarmConstants.FarmCode))
        End If

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, SHOW_TEST_MODAL, True)

    End Sub

#End Region

#Region "Result Summary Methods"

    Private Sub FillResultSummaries(ByVal refresh As Boolean)

        Try
            Dim dsInterpretations As DataSet

            'Save the data set in view state to re-use
            If refresh Then ViewState(INTERPRETATION_DATASET) = Nothing

            If IsNothing(ViewState(INTERPRETATION_DATASET)) Then
                Dim oTestInterpretation As clsTestInterpretation = New clsTestInterpretation()
                Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, oCommon.GetSPList(INTERPRETATION_GET_LIST_SP)(0), 3, True)
                dsInterpretations = oTestInterpretation.ListAll({strParams})
            Else
                dsInterpretations = CType(ViewState(INTERPRETATION_DATASET), DataSet)
            End If

            gvResultSummaries.DataSource = Nothing
            If dsInterpretations.CheckDataSet() Then
                Dim keys(1) As DataColumn
                keys(0) = dsInterpretations.Tables(0).Columns(0)
                dsInterpretations.Tables(0).PrimaryKey = keys
                ViewState(INTERPRETATION_DATASET) = dsInterpretations
                gvResultSummaries.DataSource = dsInterpretations.Tables(0)
                gvResultSummaries.DataBind()
            End If
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub chkResultSummaryblnValidateStatus_CheckedChanged(sender As Object, e As EventArgs) Handles chkResultSummaryblnValidateStatus.CheckedChanged

        Try
            If chkResultSummaryblnValidateStatus.Checked Then
                txtResultSummarydatValidationDate.Text = DateTime.Today
                txtResultSummaryValidatedByPersonName.Text = hdfstrUserName.Value
                hdfResultSummaryidfValidatedByPerson.Value = hdfidfPerson.Value
            Else
                txtResultSummarydatValidationDate.Text = ""
                txtResultSummaryValidatedByPersonName.Text = ""
                hdfResultSummaryidfValidatedByPerson.Value = "NULL"
            End If

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, SHOW_RESULT_SUMMARY_MODAL, True)
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub ddlResultSummaryidfsInterpretedStatus_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlResultSummaryidfsInterpretedStatus.SelectedIndexChanged

        Try
            If ddlResultSummaryidfsInterpretedStatus.SelectedIndex = -1 Then
                txtResultSummarydatInterpretationDate.Text = ""
                txtResultSummaryInterpretedByPersonName.Text = ""
                hdfResultSummaryidfInterpretedByPerson.Value = "NULL"
                txtResultSummarystrInterpretedComment.Enabled = False
                txtResultSummarystrInterpretedComment.Text = ""
            Else
                txtResultSummarydatInterpretationDate.Text = DateTime.Today
                txtResultSummaryInterpretedByPersonName.Text = hdfstrUserName.Value
                hdfResultSummaryidfInterpretedByPerson.Value = hdfidfPerson.Value
                txtResultSummarystrInterpretedComment.Enabled = True
            End If

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, SHOW_RESULT_SUMMARY_MODAL, True)
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub NewInterpretation(interpretationID As Long)

        hdfidfTesting.Value = interpretationID.ToString()

        ResetResultSummary()

        Dim dsLabTests As DataSet = CType(ViewState(TEST_DATASET), DataSet)
        Dim drLabTest = dsLabTests.Tables(0).Select(LabTestConstants.LabTestID & " = " & hdfidfTesting.Value).First
        If Not drLabTest Is Nothing Then
            txtResultSummarystrFarmCode.Text = If(drLabTest(FarmConstants.FarmCode).ToString = "", "", drLabTest(FarmConstants.FarmCode))
            txtResultSummarySpeciesTypeName.Text = If(drLabTest(HerdSpeciesConstants.SpeciesTypeName).ToString = "", "", drLabTest(HerdSpeciesConstants.SpeciesTypeName))
            txtResultSummarystrAnimalCode.Text = If(drLabTest(AnimalConstants.AnimalCode).ToString = "", "", drLabTest(AnimalConstants.AnimalCode))
            txtResultSummarystrBarCode.Text = If(drLabTest(LabTestConstants.LabTestCode).ToString = "", "", drLabTest(LabTestConstants.LabTestCode))
            txtResultSummarySampleTypeName.Text = If(drLabTest(SampleTypeConstants.SampleTypeName).ToString = "", "", drLabTest(SampleTypeConstants.SampleTypeName))
            txtResultSummarystrFieldCode.Text = If(drLabTest(SampleConstants.SampleCode).ToString = "", "", drLabTest(SampleConstants.SampleCode))
            txtResultSummaryDiagnosis.Text = If(drLabTest(LabTestConstants.DiseaseName).ToString = "", "", drLabTest(LabTestConstants.DiseaseName))
            txtResultsummaryTestCategoryTypeName.Text = If(drLabTest(LabTestConstants.TestCategoryTypeName).ToString = "", "", drLabTest(LabTestConstants.TestCategoryTypeName))
            txtResultSummaryTestTypeName.Text = If(drLabTest(LabTestConstants.TestNameTypeName).ToString = "", "", drLabTest(LabTestConstants.TestNameTypeName))
        End If

        hdfRecordAction.Value = RecordConstants.Insert

        ToggleVisibility(SectionResultSummary)
        btnCreateDiseaseReport.Visible = False
        If hdfAvianOrLivestock.Value = HACodeList.Avian Then
            divResultSummaryAnimalContainer.Visible = False
        Else
            divResultSummaryAnimalContainer.Visible = True
        End If

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, SHOW_RESULT_SUMMARY_MODAL, True)

    End Sub

    Private Sub ResetResultSummary()

        chkResultSummaryblnValidateStatus.Checked = False
        ddlResultSummaryidfsInterpretedStatus.SelectedIndex = -1
        txtResultSummarydatInterpretationDate.Text = ""
        txtResultSummarydatValidationDate.Text = ""
        txtResultSummarystrInterpretedComment.Text = ""
        txtResultSummarystrValidateComment.Text = ""
        txtResultSummaryValidatedByPersonName.Text = ""
        txtResultSummaryDiagnosis.Text = ""
        txtResultSummaryInterpretedByPersonName.Text = ""
        txtResultSummarySampleTypeName.Text = ""
        txtResultSummarystrAnimalCode.Text = ""
        txtResultSummarystrBarCode.Text = ""
        txtResultSummarystrFarmCode.Text = ""
        txtResultSummarySpeciesTypeName.Text = ""
        txtResultSummarystrFieldCode.Text = ""
        txtResultsummaryTestCategoryTypeName.Text = ""
        txtResultSummaryTestTypeName.Text = ""
        hdfRecordID.Value = "0"
        hdfRecordAction.Value = ""
        hdfResultSummaryidfInterpretedByPerson.Value = "NULL"
        hdfResultSummaryidfValidatedByPerson.Value = "NULL"

    End Sub

    Protected Sub gvResultSummaries_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvResultSummaries.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    DeleteResultSummary(CType(e.CommandArgument, Long))
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditResultSummary(CType(e.CommandArgument, Long))
            End Select
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub EditResultSummary(interpretationID As Long)

        Dim dsInterpretations As DataSet = TryCast(ViewState(INTERPRETATION_DATASET), DataSet)
        Dim dr = dsInterpretations.Tables(0).Select(InterpretationConstants.InterpretationID & " = " & interpretationID).First

        If Not dr Is Nothing Then
            txtResultSummarystrFarmCode.Text = If(dr(FarmConstants.FarmCode).ToString = "", "", dr(FarmConstants.FarmCode))
            txtResultSummarySpeciesTypeName.Text = If(dr(HerdSpeciesConstants.SpeciesTypeName).ToString = "", "", dr(HerdSpeciesConstants.SpeciesTypeName))
            txtResultSummarystrAnimalCode.Text = If(dr(AnimalConstants.AnimalCode).ToString = "", "", dr(AnimalConstants.AnimalCode))
            txtResultSummarystrBarCode.Text = If(dr(LabTestConstants.LabTestCode).ToString = "", "", dr(LabTestConstants.LabTestCode))
            txtResultSummarySampleTypeName.Text = If(dr(SampleTypeConstants.SampleTypeName).ToString = "", "", dr(SampleTypeConstants.SampleTypeName))
            txtResultSummarystrFieldCode.Text = If(dr(SampleConstants.SampleCode).ToString = "", "", dr(SampleConstants.SampleCode))
            txtResultSummaryDiagnosis.Text = If(dr(LabTestConstants.DiseaseName).ToString = "", "", dr(LabTestConstants.DiseaseName))
            txtResultsummaryTestCategoryTypeName.Text = If(dr(LabTestConstants.TestCategoryTypeName).ToString = "", "", dr(LabTestConstants.TestCategoryTypeName))
            txtResultSummaryTestTypeName.Text = If(dr(LabTestConstants.TestNameTypeName).ToString = "", "", dr(LabTestConstants.TestNameTypeName))
            ddlResultSummaryidfsInterpretedStatus.SelectedValue = If(dr(InterpretationConstants.InterpretedStatusTypeID).ToString = "", "", dr(InterpretationConstants.InterpretedStatusTypeID))
            txtResultSummaryInterpretedByPersonName.Text = If(dr(InterpretationConstants.InterpretedByPersonName).ToString = "", "", dr(InterpretationConstants.InterpretedByPersonName))
            hdfResultSummaryidfInterpretedByPerson.Value = If(dr(InterpretationConstants.InterpretedByPersonID).ToString = "", "NULL", dr(InterpretationConstants.InterpretedByPersonID))
            txtResultSummarydatInterpretationDate.Text = If(dr(InterpretationConstants.InterpretationDate).ToString = "", "", dr(InterpretationConstants.InterpretationDate))
            txtResultSummarydatValidationDate.Text = If(dr(InterpretationConstants.ValidationDate).ToString = "", "", dr(InterpretationConstants.ValidationDate))
            txtResultSummarystrInterpretedComment.Text = If(dr(InterpretationConstants.InterpretedComment).ToString = "", "", dr(InterpretationConstants.InterpretedComment))
            txtResultSummarystrValidateComment.Text = If(dr(InterpretationConstants.ValidatedComment).ToString = "", "", dr(InterpretationConstants.ValidatedComment))
            txtResultSummaryValidatedByPersonName.Text = If(dr(InterpretationConstants.ValidatedByPersonName).ToString = "", "", dr(InterpretationConstants.ValidatedByPersonName))
            hdfResultSummaryidfValidatedByPerson.Value = If(dr(InterpretationConstants.ValidatedByPersonID).ToString = "", "NULL", dr(InterpretationConstants.ValidatedByPersonID))
            chkResultSummaryblnValidateStatus.Checked = If(dr(InterpretationConstants.ValidatedIndicator).ToString = "", "", dr(InterpretationConstants.ValidatedIndicator))
            hdfRecordID.Value = dr(InterpretationConstants.InterpretationID)
            hdfRecordAction.Value = dr(RecordConstants.RecordAction).ToString

            ToggleVisibility(SectionResultSummary)
            If Not dr(FarmConstants.FarmCode).ToString = "" AndAlso dr(RecordConstants.RecordAction) = "R" Then
                btnCreateDiseaseReport.CommandArgument = interpretationID
                btnCreateDiseaseReport.Visible = True
            Else
                btnCreateDiseaseReport.Visible = False
            End If

            If hdfAvianOrLivestock.Value = HACodeList.Avian Then
                divResultSummaryAnimalContainer.Visible = False
            Else
                divResultSummaryAnimalContainer.Visible = True
            End If

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, SHOW_RESULT_SUMMARY_MODAL, True)
        End If

    End Sub

    Private Sub DeleteResultSummary(interpretationID As Long)

        ViewState("Action") = "DeleteResultSummary"
        ViewState("interpretationID") = interpretationID
        RaiseEvent ShowWarningModal(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Nothing)

    End Sub

    Public Function CanDeleteInterpretation(ByVal interpretationID As Long) As Boolean

        Dim dsInterpretations As DataSet = TryCast(ViewState(INTERPRETATION_DATASET), DataSet)

        If dsInterpretations.Tables(0).Select(InterpretationConstants.InterpretationID & " = " & interpretationID).Count = 0 Then
            Return True
        Else
            Return False
        End If

    End Function

    Protected Sub btnResultSummaryOK_Click(sender As Object, e As EventArgs) Handles btnResultSummaryOK.Click

        Try
            Dim dsInterpretations As DataSet = TryCast(ViewState(INTERPRETATION_DATASET), DataSet)
            Dim dr As DataRow

            If hdfRecordAction.Value = RecordConstants.Read Or Not hdfRecordID.Value = "0" Then
                dr = dsInterpretations.Tables(0).Select(InterpretationConstants.InterpretationID & " = " & hdfRecordID.Value).First
            Else
                dr = dsInterpretations.Tables(0).NewRow()
            End If

            dr(InterpretationConstants.InterpretedStatusTypeID) = If(ddlResultSummaryidfsInterpretedStatus.SelectedValue = "null", DBNull.Value, ddlResultSummaryidfsInterpretedStatus.SelectedValue)
            dr(InterpretationConstants.InterpretedByPersonName) = If(txtResultSummaryInterpretedByPersonName.Text = "", DBNull.Value, txtResultSummaryInterpretedByPersonName.Text)
            dr(InterpretationConstants.InterpretedByPersonID) = hdfResultSummaryidfInterpretedByPerson.Value
            dr(InterpretationConstants.InterpretedStatusTypeName) = If(ddlResultSummaryidfsInterpretedStatus.SelectedValue = "null", DBNull.Value, ddlResultSummaryidfsInterpretedStatus.SelectedItem.Text)
            dr(InterpretationConstants.InterpretationDate) = If(txtResultSummarydatInterpretationDate.Text = "", DBNull.Value, Convert.ToDateTime(txtResultSummarydatInterpretationDate.Text))
            dr(InterpretationConstants.InterpretedComment) = If(txtResultSummarystrInterpretedComment.Text = "", DBNull.Value, txtResultSummarystrInterpretedComment.Text)
            dr(InterpretationConstants.ValidationDate) = If(txtResultSummarydatValidationDate.Text = "", DBNull.Value, Convert.ToDateTime(txtResultSummarydatValidationDate.Text))
            dr(InterpretationConstants.ValidatedComment) = If(txtResultSummarystrValidateComment.Text = "", DBNull.Value, txtResultSummarystrValidateComment.Text)
            dr(InterpretationConstants.ValidatedByPersonName) = If(txtResultSummaryValidatedByPersonName.Text = "", DBNull.Value, txtResultSummaryValidatedByPersonName.Text)
            dr(InterpretationConstants.ValidatedByPersonID) = hdfResultSummaryidfValidatedByPerson.Value
            dr(InterpretationConstants.ValidatedIndicator) = chkResultSummaryblnValidateStatus.Checked
            dr(InterpretationConstants.ReadOnlyIndicator) = False
            dr(LabTestConstants.DiseaseID) = ddlidfsDiagnosis.SelectedValue
            dr(LabTestConstants.DiseaseName) = ddlidfsDiagnosis.SelectedItem.Text

            Dim dsLabTests As DataSet = CType(ViewState(TEST_DATASET), DataSet)
            Dim drLabTest = dsLabTests.Tables(0).Select(LabTestConstants.LabTestID & " = " & hdfidfTesting.Value).First
            If Not drLabTest Is Nothing Then
                dr(LabTestConstants.LabTestID) = drLabTest(LabTestConstants.LabTestID)
                dr(LabTestConstants.TestCategoryTypeID) = drLabTest(LabTestConstants.TestCategoryTypeID)
                dr(LabTestConstants.TestCategoryTypeName) = drLabTest(LabTestConstants.TestCategoryTypeName)
                dr(LabTestConstants.TestNameTypeID) = drLabTest(LabTestConstants.TestNameTypeID)
                dr(LabTestConstants.TestNameTypeName) = drLabTest(LabTestConstants.TestNameTypeName)
                dr(LabTestConstants.TestResultTypeID) = drLabTest(LabTestConstants.TestResultTypeID)
                dr(LabTestConstants.TestResultTypeName) = drLabTest(LabTestConstants.TestResultTypeName)
                dr(FarmConstants.FarmID) = If(drLabTest(FarmConstants.FarmID).ToString = "", DBNull.Value, drLabTest(FarmConstants.FarmID))
                dr(FarmConstants.FarmCode) = If(drLabTest(FarmConstants.FarmCode).ToString = "", DBNull.Value, drLabTest(FarmConstants.FarmCode))
                dr(HerdSpeciesConstants.SpeciesID) = If(drLabTest(HerdSpeciesConstants.SpeciesID).ToString = "", DBNull.Value, drLabTest(HerdSpeciesConstants.SpeciesID))
                dr(HerdSpeciesConstants.SpeciesTypeName) = If(drLabTest(HerdSpeciesConstants.SpeciesTypeName).ToString = "", DBNull.Value, drLabTest(HerdSpeciesConstants.SpeciesTypeName))
                dr(AnimalConstants.AnimalCode) = If(drLabTest(AnimalConstants.AnimalCode).ToString = "", DBNull.Value, drLabTest(AnimalConstants.AnimalCode))
                dr(SampleConstants.SampleCode) = If(drLabTest(SampleConstants.SampleCode).ToString = "", DBNull.Value, drLabTest(SampleConstants.SampleCode))
                dr(SampleTypeConstants.SampleTypeName) = If(drLabTest(SampleTypeConstants.SampleTypeName).ToString = "", DBNull.Value, drLabTest(SampleTypeConstants.SampleTypeName))
            End If

            If hdfRecordAction.Value = RecordConstants.Read Or Not hdfRecordID.Value = "0" Then
                If dr(InterpretationConstants.InterpretationID) > 0 Then
                    dr(RecordConstants.RecordAction) = RecordConstants.Update
                End If
            Else
                hdfIdentity.Value += 1
                Dim identity As Integer = (hdfIdentity.Value * -1)
                dr(InterpretationConstants.InterpretationID) = identity
                dr(RecordConstants.RowStatus) = RecordConstants.ActiveRowStatus
                dr(RecordConstants.RecordAction) = RecordConstants.Insert
                dsInterpretations.Tables(0).Rows.Add(dr)
            End If

            dsInterpretations.AcceptChanges()

            gvResultSummaries.DataSource = Nothing
            If dsInterpretations.CheckDataSet() Then
                ViewState(INTERPRETATION_DATASET) = dsInterpretations
                Dim dv As DataView = New DataView(dsInterpretations.Tables(0), RecordConstants.RowStatus & " = '" & RecordConstants.ActiveRowStatus & "'", InterpretationConstants.InterpretationID, DataViewRowState.CurrentRows)
                gvResultSummaries.DataSource = dv
                gvResultSummaries.DataBind()
            End If

            ResetResultSummary()

            ToggleVisibility(SectionTestsResultSummaries)

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, HIDE_RESULT_SUMMARY_MODAL, True)
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnCreateDiseaseReport_Click(sender As Object, e As EventArgs) Handles btnCreateDiseaseReport.Click

        Dim btn As LinkButton = sender
        Dim recordID As String
        recordID = btn.CommandArgument.ToString()

        Dim dsInterpretations As DataSet = TryCast(ViewState(INTERPRETATION_DATASET), DataSet)
        Dim dr = dsInterpretations.Tables(0).Select(InterpretationConstants.InterpretationID & " = " & recordID).First

        Session(FarmConstants.FarmID) = dr(FarmConstants.FarmID)
        ViewState(CALLER) = CallerPages.VeterinaryActiveSurveillanceMonitoringSession
        ViewState(CALLER_KEY) = hdfidfMonitoringSession.Value

        oCommon.SaveViewState(ViewState)

        If hdfAvianOrLivestock.Value = HACodeList.Avian Then
            Response.Redirect(GetURL(CallerPages.AvianVeterinaryDiseaseReportURL), True)
        Else
            Response.Redirect(GetURL(CallerPages.LivestockVeterinaryDiseaseReportURL), True)
        End If

    End Sub

#End Region

#Region "Action Methods"

    Private Sub FillActions(ByVal refresh As Boolean)

        Try
            Dim dsActions As DataSet

            'Save the data set in view state to re-use
            If refresh Then ViewState(ACTION_DATASET) = Nothing

            If IsNothing(ViewState(ACTION_DATASET)) Then
                Dim oVetActiveSurvSession As clsVeterinaryActiveSurveillanceMonitoringSession = New clsVeterinaryActiveSurveillanceMonitoringSession()
                Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, oCommon.GetSPList(ACTION_GET_LIST_SP)(0), 3, True)
                dsActions = oVetActiveSurvSession.ListAllMonitoringSessionActions({strParams})
            Else
                dsActions = CType(ViewState(ACTION_DATASET), DataSet)
            End If

            gvActions.DataSource = Nothing
            If dsActions.CheckDataSet() Then
                Dim keys(1) As DataColumn
                keys(0) = dsActions.Tables(0).Columns(0)
                dsActions.Tables(0).PrimaryKey = keys
                ViewState(ACTION_DATASET) = dsActions
                gvActions.DataSource = dsActions.Tables(0)
                gvActions.DataBind()
            End If
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnAddAction_ServerClick(sender As Object, e As EventArgs) Handles btnAddAction.ServerClick

        Try
            ResetAction()

            hdfRecordAction.Value = RecordConstants.Insert

            ToggleVisibility(SectionAction)

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, SHOW_ACTION_MODAL, True)
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub ResetAction()

        Dim ddlMonitoringSessionActionType As System.Web.UI.WebControls.DropDownList = CType(Me.ddlActionidfsMonitoringSessionActionType.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
        ddlMonitoringSessionActionType.SelectedIndex = -1

        txtActiondatActionDate.Text = ""
        ddlActionidfPersonEnteredBy.SelectedValue = Session("Person")
        txtActionstrComments.Text = ""
        ddlActionidfsMonitoringSessionActionStatus.SelectedIndex = -1
        hdfRecordID.Value = "0"
        hdfRecordAction.Value = ""

    End Sub

    Protected Sub btnActionOK_Click(sender As Object, e As EventArgs) Handles btnActionOK.Click

        Try
            Dim dsActions As DataSet = TryCast(ViewState(ACTION_DATASET), DataSet)
            Dim dr As DataRow

            If hdfRecordAction.Value = RecordConstants.Read Or Not hdfRecordID.Value = "0" Then
                dr = dsActions.Tables(0).Select(MonitoringSessionActionConstants.MonitoringSessionActionID & " = " & hdfRecordID.Value).First
            Else
                dr = dsActions.Tables(0).NewRow()
            End If

            dr(MonitoringSessionActionConstants.MonitoringSessionID) = hdfidfMonitoringSession.Value
            dr(MonitoringSessionActionConstants.ActionDate) = If(txtActiondatActionDate.Text = "", DBNull.Value, Convert.ToDateTime(txtActiondatActionDate.Text))
            dr(MonitoringSessionActionConstants.PersonEnteredByID) = If(ddlActionidfPersonEnteredBy.SelectedValue = "null", DBNull.Value, ddlActionidfPersonEnteredBy.SelectedValue)
            dr(MonitoringSessionActionConstants.PersonFullName) = If(ddlActionidfPersonEnteredBy.SelectedValue = "null", DBNull.Value, ddlActionidfPersonEnteredBy.SelectedItem.Text)
            dr(MonitoringSessionActionConstants.MonitoringSessionStatusTypeID) = If(ddlActionidfsMonitoringSessionActionStatus.SelectedValue = "null", DBNull.Value, ddlActionidfsMonitoringSessionActionStatus.SelectedValue)
            dr(MonitoringSessionActionConstants.MonitoringSessionStatusName) = If(ddlActionidfsMonitoringSessionActionStatus.SelectedValue = "null", DBNull.Value, ddlActionidfsMonitoringSessionActionStatus.SelectedItem.Text)
            dr(MonitoringSessionActionConstants.Comment) = If(txtActionstrComments.Text = "", DBNull.Value, txtActionstrComments.Text)
            Dim ddlMonitoringSessionActionType As System.Web.UI.WebControls.DropDownList = CType(Me.ddlActionidfsMonitoringSessionActionType.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
            dr(MonitoringSessionActionConstants.MonitoringSessionActionTypeID) = If(ddlMonitoringSessionActionType.SelectedValue = "null", DBNull.Value, ddlMonitoringSessionActionType.SelectedValue)
            dr(MonitoringSessionActionConstants.MonitoringSessionActionName) = If(ddlMonitoringSessionActionType.SelectedValue = "null", DBNull.Value, ddlMonitoringSessionActionType.SelectedItem.Text)

            If hdfRecordAction.Value = RecordConstants.Read Or Not hdfRecordID.Value = "0" Then
                If dr(MonitoringSessionActionConstants.MonitoringSessionActionID) > 0 Then
                    dr(RecordConstants.RecordAction) = RecordConstants.Update
                End If
            Else
                hdfIdentity.Value += 1
                Dim identity As Integer = (hdfIdentity.Value * -1)
                dr(MonitoringSessionActionConstants.MonitoringSessionActionID) = identity
                dr(RecordConstants.RowStatus) = RecordConstants.ActiveRowStatus
                dr(RecordConstants.RecordAction) = RecordConstants.Insert
                dsActions.Tables(0).Rows.Add(dr)
            End If

            dsActions.AcceptChanges()

            gvActions.DataSource = Nothing
            If dsActions.CheckDataSet() Then
                ViewState(ACTION_DATASET) = dsActions
                Dim dv As DataView = New DataView(dsActions.Tables(0), RecordConstants.RowStatus & " = '" & RecordConstants.ActiveRowStatus & "'", MonitoringSessionActionConstants.MonitoringSessionActionID, DataViewRowState.CurrentRows)
                gvActions.DataSource = dv
                gvActions.DataBind()
            End If

            ResetAction()

            ToggleVisibility(SectionActions)

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, HIDE_ACTION_MODAL, True)
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub gvActions_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvActions.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    DeleteAction(CType(e.CommandArgument, Long))
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditAction(CType(e.CommandArgument, Long))
            End Select
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub EditAction(monitoringSessionActionID As Long)

        Dim dsActions As DataSet = CType(ViewState(ACTION_DATASET), DataSet)
        Dim dr = dsActions.Tables(0).Select(MonitoringSessionActionConstants.MonitoringSessionActionID & " = " & monitoringSessionActionID).First

        If Not dr Is Nothing Then
            Dim ddlMonitoringSessionActionType As System.Web.UI.WebControls.DropDownList = CType(Me.ddlActionidfsMonitoringSessionActionType.FindControl("ddlAllItems"), System.Web.UI.WebControls.DropDownList)
            ddlMonitoringSessionActionType.SelectedValue = If(dr(MonitoringSessionActionConstants.MonitoringSessionActionTypeID).ToString = "", "null", dr(MonitoringSessionActionConstants.MonitoringSessionActionTypeID))
            txtActiondatActionDate.Text = If(dr(MonitoringSessionActionConstants.ActionDate).ToString = "", "", dr(MonitoringSessionActionConstants.ActionDate))
            ddlActionidfPersonEnteredBy.SelectedValue = If(dr(MonitoringSessionActionConstants.PersonEnteredByID).ToString = "", "null", dr(MonitoringSessionActionConstants.PersonEnteredByID))
            ddlActionidfsMonitoringSessionActionStatus.SelectedValue = If(dr(MonitoringSessionActionConstants.MonitoringSessionStatusTypeID).ToString = "null", "", dr(MonitoringSessionActionConstants.MonitoringSessionStatusTypeID))
            txtActionstrComments.Text = If(dr(MonitoringSessionActionConstants.Comment).ToString = "", "", dr(MonitoringSessionActionConstants.Comment))
            hdfRecordID.Value = dr(MonitoringSessionActionConstants.MonitoringSessionActionID)
            hdfRecordAction.Value = dr(RecordConstants.RecordAction).ToString

            ToggleVisibility(SectionAction)

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, SHOW_ACTION_MODAL, True)
        End If

    End Sub

    Private Sub DeleteAction(monitoringSessionActionID As Long)

        ViewState("Action") = "DeleteAction"
        ViewState("monitoringSessionActionID") = monitoringSessionActionID
        RaiseEvent ShowWarningModal(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Nothing)

    End Sub

#End Region

#Region "Aggregate Information Methods"

    Private Sub FillAggregateInfo(ByVal refresh As Boolean)

        Try
            Dim dsAggregateInfo As DataSet

            'Save the data set in view state to re-use
            If refresh Then ViewState(AGGREGATE_INFO_DATASET) = Nothing

            If IsNothing(ViewState(AGGREGATE_INFO_DATASET)) Then
                Dim oVetActiveSurvSession As clsVeterinaryActiveSurveillanceMonitoringSession = New clsVeterinaryActiveSurveillanceMonitoringSession()
                Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, oCommon.GetSPList(AGGREGATE_INFO_GET_LIST_SP)(0), 3, True)
                dsAggregateInfo = oVetActiveSurvSession.ListAllMonitoringSessionSummaries({strParams})
            Else
                dsAggregateInfo = CType(ViewState(AGGREGATE_INFO_DATASET), DataSet)
            End If

            gvAggregateInfos.DataSource = Nothing
            If dsAggregateInfo.CheckDataSet() Then
                Dim keys(1) As DataColumn
                keys(0) = dsAggregateInfo.Tables(0).Columns(0)
                dsAggregateInfo.Tables(0).PrimaryKey = keys
                ViewState(AGGREGATE_INFO_DATASET) = dsAggregateInfo
                gvAggregateInfos.DataSource = dsAggregateInfo.Tables(0)
                gvAggregateInfos.DataBind()
            End If
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnAddAggregateInfo_ServerClick(sender As Object, e As EventArgs) Handles btnAddAggregateInfo.ServerClick

        Try
            ResetAggregateInfo()

            hdfRecordAction.Value = RecordConstants.Insert

            rvAggregateInfoCollectionDate.MinimumValue = txtdatCampaignDateStart.Text
            rvAggregateInfoCollectionDate.MaximumValue = txtdatCampaignDateEND.Text

            ToggleVisibility(SectionAggregateInfo)

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, SHOW_AGGREGATE_INFO_MODAL, True)
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub ResetAggregateInfo()

        ddlAggregateInfoidfFarm.SelectedIndex = -1
        ddlAggregateInfoidfSpecies.SelectedIndex = -1
        ddlAggregateInfoidfsAnimalSex.SelectedIndex = -1
        txtintSampledAnimalsQty.Text = ""
        ddlAggregateInfoidfsSampleType.SelectedIndex = -1
        txtintSamplesQty.Text = ""
        txtAggregateInfodatCollectionDate.Text = ""
        txtintPositiveAnimalsQty.Text = ""
        ddlAggregateInfoidfsDiagnosis.SelectedIndex = -1
        hdfRecordID.Value = "0"
        hdfRecordAction.Value = ""

    End Sub

    Protected Sub btnAggregateInfoOK_Click(sender As Object, e As EventArgs) Handles btnAggregateInfoOK.Click

        Try
            Dim dsAggregateInfo As DataSet = TryCast(ViewState(AGGREGATE_INFO_DATASET), DataSet)
            Dim dr As DataRow

            If hdfRecordAction.Value = RecordConstants.Read Or Not hdfRecordID.Value = "0" Then
                dr = dsAggregateInfo.Tables(0).Select(MonitoringSessionSummaryConstants.MonitoringSessionSummaryID & " = " & hdfRecordID.Value).First
            Else
                dr = dsAggregateInfo.Tables(0).NewRow()
            End If

            dr(ActiveSurveillanceSessionConstants.Session) = hdfidfMonitoringSession.Value
            dr(FarmConstants.FarmID) = If(ddlAggregateInfoidfFarm.SelectedValue = "null", DBNull.Value, ddlAggregateInfoidfFarm.SelectedValue)
            dr(FarmConstants.FarmCode) = If(ddlAggregateInfoidfFarm.SelectedValue = "null", DBNull.Value, ddlAggregateInfoidfFarm.SelectedItem.Text)
            dr(HerdSpeciesConstants.SpeciesID) = If(ddlAggregateInfoidfSpecies.SelectedValue = "", DBNull.Value, ddlAggregateInfoidfSpecies.SelectedValue)
            dr(HerdSpeciesConstants.SpeciesTypeName) = If(ddlAggregateInfoidfSpecies.SelectedValue = "", DBNull.Value, ddlAggregateInfoidfSpecies.SelectedItem.Text)
            dr(MonitoringSessionSummaryConstants.AnimalGenderTypeID) = If(ddlAggregateInfoidfsAnimalSex.SelectedValue = "null", DBNull.Value, ddlAggregateInfoidfsAnimalSex.SelectedValue)
            dr(MonitoringSessionSummaryConstants.AnimalGenderTypeName) = If(ddlAggregateInfoidfsAnimalSex.SelectedValue = "null", DBNull.Value, ddlAggregateInfoidfsAnimalSex.SelectedItem.Text)
            dr(MonitoringSessionSummaryConstants.SampledAnimalsQuantity) = If(txtintSampledAnimalsQty.Text = "", DBNull.Value, txtintSampledAnimalsQty.Text)
            dr(MonitoringSessionSummaryConstants.SampleTypeID) = If(ddlAggregateInfoidfsSampleType.SelectedValue = "null", DBNull.Value, ddlAggregateInfoidfsSampleType.SelectedValue)
            dr(MonitoringSessionSummaryConstants.SampleTypeName) = If(ddlAggregateInfoidfsSampleType.SelectedValue = "null", DBNull.Value, ddlAggregateInfoidfsSampleType.SelectedItem.Text)
            dr(MonitoringSessionSummaryConstants.SamplesQuantity) = If(txtintSamplesQty.Text = "", DBNull.Value, txtintSamplesQty.Text)
            dr(MonitoringSessionSummaryConstants.CollectionDate) = If(txtAggregateInfodatCollectionDate.Text = "", DBNull.Value, Convert.ToDateTime(txtAggregateInfodatCollectionDate.Text))
            dr(MonitoringSessionSummaryConstants.PositiveAnimalsQuantity) = If(txtintPositiveAnimalsQty.Text = "", DBNull.Value, txtintPositiveAnimalsQty.Text)
            dr(MonitoringSessionSummaryConstants.DiseaseTypeID) = If(ddlAggregateInfoidfsDiagnosis.SelectedValue = "null", DBNull.Value, ddlAggregateInfoidfsDiagnosis.SelectedValue)
            dr(MonitoringSessionSummaryConstants.DiseaseTypeName) = If(ddlAggregateInfoidfsDiagnosis.SelectedValue = "null", DBNull.Value, ddlAggregateInfoidfsDiagnosis.SelectedItem.Text)

            If hdfRecordAction.Value = RecordConstants.Read Or Not hdfRecordID.Value = "0" Then
                If dr(MonitoringSessionSummaryConstants.MonitoringSessionSummaryID) > 0 Then
                    dr(RecordConstants.RecordAction) = RecordConstants.Update
                End If
            Else
                hdfIdentity.Value += 1
                Dim identity As Integer = (hdfIdentity.Value * -1)
                dr(MonitoringSessionSummaryConstants.MonitoringSessionSummaryID) = identity
                dr(RecordConstants.RowStatus) = RecordConstants.ActiveRowStatus
                dr(RecordConstants.RecordAction) = RecordConstants.Insert
                dsAggregateInfo.Tables(0).Rows.Add(dr)
            End If

            dsAggregateInfo.AcceptChanges()

            gvAggregateInfos.DataSource = Nothing
            If dsAggregateInfo.CheckDataSet() Then
                ViewState(AGGREGATE_INFO_DATASET) = dsAggregateInfo
                Dim dv As DataView = New DataView(dsAggregateInfo.Tables(0), RecordConstants.RowStatus & " = '" & RecordConstants.ActiveRowStatus & "'", MonitoringSessionSummaryConstants.MonitoringSessionSummaryID, DataViewRowState.CurrentRows)
                gvAggregateInfos.DataSource = dv
                gvAggregateInfos.DataBind()
            End If

            ResetAggregateInfo()

            ToggleVisibility(SectionAggregateInfos)

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, HIDE_AGGREGATE_INFO_MODAL, True)
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub gvAggregateInfos_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvAggregateInfos.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    DeleteAggregateInfo(CType(e.CommandArgument, Long))
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditAggregateInfo(CType(e.CommandArgument, Long))
            End Select
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub EditAggregateInfo(monitoringSessionSummaryID As Long)

        Dim dsAggregateInfo As DataSet = CType(ViewState(AGGREGATE_INFO_DATASET), DataSet)
        Dim dr = dsAggregateInfo.Tables(0).Select(MonitoringSessionSummaryConstants.MonitoringSessionSummaryID & " = " & monitoringSessionSummaryID).First

        If Not dr Is Nothing Then
            ddlAggregateInfoidfFarm.SelectedValue = If(dr(FarmConstants.FarmID).ToString = "", "null", dr(FarmConstants.FarmID))
            ddlAggregateInfoidfSpecies.SelectedValue = If(dr(HerdSpeciesConstants.SpeciesID).ToString = "", "null", dr(HerdSpeciesConstants.SpeciesID))
            ddlAggregateInfoidfsAnimalSex.SelectedValue = If(dr(MonitoringSessionSummaryConstants.AnimalGenderTypeID).ToString = "", "null", dr(MonitoringSessionSummaryConstants.AnimalGenderTypeID))
            txtintSampledAnimalsQty.Text = If(dr(MonitoringSessionSummaryConstants.SampledAnimalsQuantity).ToString = "", "", dr(MonitoringSessionSummaryConstants.SampledAnimalsQuantity))
            ddlAggregateInfoidfsSampleType.SelectedValue = If(dr(MonitoringSessionSummaryConstants.SampleTypeID).ToString = "", "null", dr(MonitoringSessionSummaryConstants.SampleTypeID))
            ddlAggregateInfoidfsDiagnosis.SelectedValue = If(dr(MonitoringSessionSummaryConstants.DiseaseTypeID).ToString = "", "null", dr(MonitoringSessionSummaryConstants.DiseaseTypeID))
            txtintSamplesQty.Text = If(dr(MonitoringSessionSummaryConstants.SamplesQuantity).ToString = "", "", dr(MonitoringSessionSummaryConstants.SamplesQuantity))
            txtAggregateInfodatCollectionDate.Text = If(dr(MonitoringSessionSummaryConstants.CollectionDate).ToString = "", "", dr(MonitoringSessionSummaryConstants.CollectionDate))
            txtintPositiveAnimalsQty.Text = If(dr(MonitoringSessionSummaryConstants.PositiveAnimalsQuantity).ToString = "", "", dr(MonitoringSessionSummaryConstants.PositiveAnimalsQuantity))
            hdfRecordID.Value = dr(MonitoringSessionSummaryConstants.MonitoringSessionSummaryID)
            hdfRecordAction.Value = dr(RecordConstants.RecordAction).ToString

            ToggleVisibility(SectionAggregateInfo)
            rvAggregateInfoCollectionDate.MinimumValue = txtdatCampaignDateStart.Text
            rvAggregateInfoCollectionDate.MaximumValue = txtdatCampaignDateEND.Text

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, SHOW_AGGREGATE_INFO_MODAL, True)
        End If

    End Sub

    Private Sub DeleteAggregateInfo(monitoringSessionSummaryID As Long)

        ViewState("Action") = "DeleteAggregateInfo"
        ViewState("monitoringSessionSummaryID") = monitoringSessionSummaryID

        RaiseEvent ShowWarningModal(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Nothing)

    End Sub

    Protected Sub ddlAggregateInfoidfFarm_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlAggregateInfoidfFarm.SelectedIndexChanged

        Dim dsFarmHerdSpecies As DataSet = CType(ViewState(HERD_SPECIES_DATASET), DataSet)

        If ddlAggregateInfoidfFarm.SelectedValue = "" Then
            ddlAggregateInfoidfSpecies.Enabled = False
        Else
            Dim li As ListItem = New ListItem
            Dim dsSpeciesAndSamples As DataSet = TryCast(ViewState(SPECIES_AND_SAMPLES_DATASET), DataSet)
            ddlAggregateInfoidfSpecies.Items.Clear()
            If ddlAggregateInfoidfSpecies.Items.Count = 0 Then
                li.Value = ""
                li.Text = ""
                li.Selected = False
                ddlAggregateInfoidfSpecies.Items.Add(li)
            End If

            For Each drFarmSpecies As DataRow In dsFarmHerdSpecies.Tables(0).Rows
                If drFarmSpecies(RecordConstants.RecordType).ToString() = RecordTypeConstants.Species And drFarmSpecies(FarmConstants.FarmCode) = ddlAggregateInfoidfFarm.SelectedItem.Text Then
                    If dsSpeciesAndSamples.Tables(0).Select(HerdSpeciesConstants.SpeciesTypeID & " = " & drFarmSpecies(HerdSpeciesConstants.SpeciesTypeID).ToString()).Count > 0 Then
                        li = New ListItem
                        li.Value = If(drFarmSpecies(HerdSpeciesConstants.SpeciesID).ToString = "", drFarmSpecies(HerdSpeciesConstants.SpeciesActualID), drFarmSpecies(HerdSpeciesConstants.SpeciesID))
                        li.Text = drFarmSpecies(HerdSpeciesConstants.SpeciesTypeName)
                        li.Selected = False
                        ddlAggregateInfoidfSpecies.Items.Add(li)
                    End If
                End If
            Next
            ddlAggregateInfoidfSpecies = SortDropDownList(ddlAggregateInfoidfSpecies)
            ddlAggregateInfoidfSpecies.Enabled = True
        End If

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), MODAL_KEY, SHOW_AGGREGATE_INFO_MODAL, True)

    End Sub

#End Region

#Region "Veterinary Disease Report Methods"

    Private Sub FillVeterinaryDiseaseReportsList(Optional getDataFor As String = GridViewSortConstants.GridRows,
        Optional refresh As Boolean = False)

        Try
            Dim dsVeterinaryDiseaseReports As DataSet

            'Save the data set in view state to re-use
            If refresh Then ViewState(VETERINARY_DISEASE_REPORT_DATASET) = Nothing

            If IsNothing(ViewState(VETERINARY_DISEASE_REPORT_DATASET)) Then
                Dim oCommon As New clsCommon()
                Dim oDiseaseReport As New clsVeterinaryDiseaseReport()
                Dim oService As NG.EIDSSService = oCommon.GetService()

                Dim aSP As String() = oService.getSPList(VETERINARY_DISEASE_REPORT_GET_LIST_SP)
                Dim strParams As String = oCommon.Gather(divHiddenFieldsSection, aSP(0), 3, True)

                dsVeterinaryDiseaseReports = oDiseaseReport.ListAll({strParams})
            Else
                dsVeterinaryDiseaseReports = CType(ViewState(VETERINARY_DISEASE_REPORT_DATASET), DataSet)
            End If

            Dim primaryKey(0) As DataColumn
            primaryKey(0) = dsVeterinaryDiseaseReports.Tables(0).Columns(VeterinaryDiseaseReportConstants.VeterinaryDiseaseReportID)
            dsVeterinaryDiseaseReports.Tables(0).PrimaryKey = primaryKey

            gvVeterinaryDiseaseReports.DataSource = Nothing
            If dsVeterinaryDiseaseReports.CheckDataSet() Then
                ViewState(VETERINARY_DISEASE_REPORT_DATASET) = dsVeterinaryDiseaseReports
                gvVeterinaryDiseaseReports.DataSource = dsVeterinaryDiseaseReports.Tables(0)
                gvVeterinaryDiseaseReports.DataBind()
            End If
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub EditVeterinaryDiseaseReport(veterinaryDiseaseReportID As Long)

        hdfidfVetCase.Value = veterinaryDiseaseReportID.ToString()
        Dim dsVeterinaryDiseaseReports As DataSet = CType(ViewState(VETERINARY_DISEASE_REPORT_DATASET), DataSet)
        Dim dr = dsVeterinaryDiseaseReports.Tables(0).Select("idfVetCase = " & hdfidfVetCase.Value).First

        ViewState(CALLER_KEY) = hdfidfVetCase.Value.ToString()
        ViewState(CALLER) = CallerPages.VeterinaryActiveSurveillanceMonitoringSessionEditVeterinaryDiseaseReport

        oCommon.SaveViewState(ViewState)

        If (dr(VeterinaryDiseaseReportConstants.CaseTypeID) = VeterinaryDiseaseReportConstants.AvianDiseaseReportCaseType) Then
            Response.Redirect(GetURL(CallerPages.AvianVeterinaryDiseaseReportURL), True)
        Else
            Response.Redirect(GetURL(CallerPages.LivestockVeterinaryDiseaseReportURL), True)
        End If

    End Sub

    Private Sub DeleteVeterinaryDiseaseReport(veterinaryDiseaseReportID As Long)

        hdfidfVetCase.Value = veterinaryDiseaseReportID.ToString()
        Dim dsVeterinaryDiseaseReports As DataSet = CType(ViewState(VETERINARY_DISEASE_REPORT_DATASET), DataSet)
        Dim dr = dsVeterinaryDiseaseReports.Tables(0).Select("idfVetCase = " & hdfidfVetCase.Value).First

        ViewState(CALLER_KEY) = hdfidfVetCase.Value.ToString()
        ViewState(CALLER) = CallerPages.VeterinaryActiveSurveillanceMonitoringSessionDeleteVeterinaryDiseaseReport

        oCommon.SaveViewState(ViewState)

        If (dr(VeterinaryDiseaseReportConstants.CaseTypeID) = VeterinaryDiseaseReportConstants.AvianDiseaseReportCaseType) Then
            Response.Redirect(GetURL(CallerPages.AvianVeterinaryDiseaseReportURL), True)
        Else
            Response.Redirect(GetURL(CallerPages.LivestockVeterinaryDiseaseReportURL), True)
        End If

    End Sub

    Private Sub gvVeterinaryDiseaseReports_Sorting(sender As Object, e As GridViewSortEventArgs) Handles gvVeterinaryDiseaseReports.Sorting

        SortGrid(e, CType(sender, GridView), VETERINARY_DISEASE_REPORT_DATASET)

    End Sub

    Protected Sub gvVeterinaryDiseaseReports_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvVeterinaryDiseaseReports.PageIndexChanging

        gvVeterinaryDiseaseReports.PageIndex = e.NewPageIndex
        FillVeterinaryDiseaseReportsList(getDataFor:=GridViewSortConstants.Page)

    End Sub

    Protected Sub gvVeterinaryDiseaseReports_RowCommand(sender As Object, e As GridViewCommandEventArgs)

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    DeleteVeterinaryDiseaseReport(CType(e.CommandArgument, Long))
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditVeterinaryDiseaseReport(CType(e.CommandArgument, Long))
            End Select
        Catch ex As Exception
            Err.Raise(vbObjectError + 513, System.Reflection.MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

End Class