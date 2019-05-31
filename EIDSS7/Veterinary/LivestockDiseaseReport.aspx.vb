Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.Client.Enumerations
Imports EIDSS.Client.Responses
Imports EIDSS.EIDSS
Imports EIDSSControlLibrary
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

'******************************************************************************
'* Use Cases: VUC04 and VUC06
'*
'* Description: Code-behind that supports the creating and editing of a 
'* veterinary disease report for the livestock case type.
'* 
'******************************************************************************
Public Class LivestockDiseaseReport
    Inherits BaseEidssPage

#Region "Global Values"

    Private Const FARM_SEARCH_PREFIX As String = "_FRM"

    Private Const SectionDiseaseReportSearch As String = "Disease Report Search"
    Private Const SectionFarmSearch As String = "Farm Search"
    Private Const SectionFarm As String = "Farm"
    Private Const SectionFarmReview As String = "Farm Review"
    Private Const SectionDisease As String = "Disease"
    Private Const SectionNotification As String = "Notification"
    Private Const SectionSpecies As String = "Species"
    Private Const SectionFarmFlockSpecies As String = "Farm/Herd/Species"
    Private Const SectionFarmEpidemiologicalInformation As String = "Farm Epidemiological Information"
    Private Const SectionSpeciesInvestigation As String = "Species Investigation"
    Private Const SectionVaccinations As String = "Vaccinations"
    Private Const SectionVaccination As String = "Vaccination"
    Private Const SectionAnimals As String = "Animals"
    Private Const SectionAnimal As String = "Animal"
    Private Const SectionSamples As String = "Samples"
    Private Const SectionSample As String = "Sample"
    Private Const SectionPensideTests As String = "Penside Tests"
    Private Const SectionPensideTest As String = "Penside Test"
    Private Const SectionLabTestsInterpretations As String = "Lab Tests/Interpretations"
    Private Const SectionLabTest As String = "Lab Test"
    Private Const SectionInterpretation As String = "Interpretation"
    Private Const SectionCaseLogs As String = "Case Logs"
    Private Const SectionCaseLog As String = "Case Log"
    Private Const SectionConnectedDiseaseReport As String = "Connected Disease Report"

    Private Const HERDS_LIST As String = "gvHerds"
    Private Const SPECIES_LIST As String = "gvSpecies"
    Private Const HERD_SPECIES_LIST As String = "gvFarmHerdSpecies"
    Private Const VACCINATIONS_LIST As String = "gvVaccinations"
    Private Const ANIMALS_LIST As String = "gvAnimals"
    Private Const SAMPLES_LIST As String = "gvSamples"
    Private Const PENSIDE_TESTS_LIST As String = "gvPensideTests"
    Private Const TESTS_LIST As String = "gvTests"
    Private Const TEST_INTERPRETATIONS_LIST As String = "gvTestInterpretations"
    Private Const REPORT_LOGS_LIST As String = "gvReportLogs"

    Private Const PAGE_KEY As String = "Page"
    Private Const MODAL_KEY As String = "Modal"
    Private Const MODAL_ON_MODAL_KEY As String = "ModalOnModal"

    Private Const SHOW_MODAL_HANDLER_SCRIPT As String = "showModalHandler('{0}');"
    Private Const HIDE_MODAL_SCRIPT As String = "hideModal('{0}');"
    Private Const HIDE_MODAL_AND_WARNING_MODAL_SCRIPT As String = "hideModalAndWarningModal('{0}');"
    Private Const SHOW_ADD_UPDATE_FARM_MODAL As String = "showAddUpdateFarmModal();"
    Private Const HIDE_ADD_UPDATE_FARM_MODAL As String = "hideAddUpdateFarmModal();"
    Private Const SHOW_SEARCH_PERSON_MODAL As String = "showSearchPersonModal();"
    Private Const HIDE_SEARCH_PERSON_MODAL As String = "hideSearchPersonModal();"
    Private Const HIDE_SEARCH_PERSON_SHOW_ADD_UPDATE_PERSON_MODALS As String = "hideSearchPersonModalShowAddUpdatePersonModal();"
    Private Const SHOW_ADD_UPDATE_PERSON_MODAL As String = "showAddUpdatePersonModal();"
    Private Const HIDE_ADD_UPDATE_PERSON_MODAL As String = "hideAddUpdatePersonModal();"

    Private IsDelete As Boolean = False

    Private Const CALLER_INFO As String = "CallerInfo"
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"

    Private EmployeeAPIService As EmployeeServiceClient
    Private FarmAPIService As FarmServiceClient
    Private OrganizationAPIService As OrganizationServiceClient
    Private VeterinaryAPIService As VeterinaryServiceClient

    Private Shared Log = log4net.LogManager.GetLogger(GetType(LivestockDiseaseReport))

#End Region

#Region "Initalize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        Try
            If (Not IsPostBack) Then
                'Do not allow future dates on the following date controls as per use case:
                cmvFutureReportDate.ValueToCompare = Date.Now.ToShortDateString()
                cmvFutureAssignedDate.ValueToCompare = Date.Now.ToShortDateString()
                cmvFutureInvestigationDate.ValueToCompare = Date.Now.ToShortDateString()
                cmvFutureVaccinationDate.ValueToCompare = Date.Now.ToShortDateString()
                txtSampleCollectionDate.MaxDate = Date.Today.ToShortDateString()
                txtLabTestResultDate.MaxDate = Date.Today.ToShortDateString()
                txtReportLogLogDate.MaxDate = Date.Today.ToShortDateString()

                CheckCallerHandler()

                btnPrintVeterinaryDiseaseReport.Visible = False
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub FarmAddress_Load() Handles FarmAddress.Load

        'The location user control has not completed loading with the page load, so verify permissions is called again
        'to account for its controls.
        VerifyLocationUserPermissions(False)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub CheckCallerHandler()

        ExtractViewStateSession()

        If (hdfRowAction.Value = RecordConstants.SelectFarm) Or (ViewState(CALLER).Equals(ApplicationActions.FarmAddLivestockVeterinaryDiseaseReport.ToString())) Then
            hdfRowAction.Value = String.Empty
            ViewState(CALLER) = CallerPages.Dashboard
            FillDropDowns()

            hdfVeterinaryDiseaseReportID.Value = "-1"
            hdfEnteredByPersonID.Value = EIDSSAuthenticatedUser.PersonId
            txtEnteredByPersonName.Text = EIDSSAuthenticatedUser.LastName & ", " & EIDSSAuthenticatedUser.FirstName
            txtSiteName.Text = EIDSSAuthenticatedUser.Organization
            txtEnteredDate.Text = Date.Today
            hdfFarmMasterID.Value = ViewState(CALLER_KEY)
            ddlReportStatusTypeID.SelectedValue = VeterinaryDiseaseReportStatusTypes.InProcess
            divLegacyID.Visible = False

            'Use data from farm actual as the disease report has not been saved with no copy to farm.
            FillFarmReview(True)
            FillFarmHerdSpecies(True, True)
            FillFarmEpidemiologicalInfo()
            FillVaccinations(True)
            FillControlMeasures()
            FillAnimals(True)
            FillSamples(True)
            FillPensideTests(True)
            FillTests(True)
            FillTestInterpretations(True)
            FillReportLogs(True)

            VerifyUserPermissions(True)

            ToggleVisibility(SectionDisease)
        ElseIf (ViewState(CALLER).ToString().Equals(CallerPages.VeterinaryActiveSurveillanceMonitoringSession)) Then
            ViewState(CALLER) = CallerPages.Dashboard
            FillDropDowns()

            hdfVeterinaryDiseaseReportID.Value = "-1"
            hdfEnteredByPersonID.Value = EIDSSAuthenticatedUser.PersonId
            txtEnteredByPersonName.Text = EIDSSAuthenticatedUser.LastName & ", " & EIDSSAuthenticatedUser.FirstName
            txtSiteName.Text = EIDSSAuthenticatedUser.Organization
            txtEnteredDate.Text = Date.Today
            txtEIDSSParentMonitoringSessionID.Text = ViewState(CALLER_KEY)
            hdfFarmMasterID.Value = ViewState(CALLER_KEY)
            ViewState(CALLER_KEY) = Nothing

            divLegacyID.Visible = False

            'Use data from farm actual as the disease report has not been saved with no copy to farm.
            FillFarmReview(True)
            FillFarmHerdSpecies(True, True)
            FillFarmEpidemiologicalInfo()
            FillVaccinations(True)
            FillControlMeasures()
            FillAnimals(True)
            FillSamples(True)
            FillPensideTests(True)
            FillTests(True)
            FillTestInterpretations(True)
            FillReportLogs(True)

            VerifyUserPermissions(True)

            ToggleVisibility(SectionDisease)
        ElseIf (ViewState(CALLER).ToString().EqualsAny({CallerPages.FarmWithVeterinaryDiseaseReport,
                                                       CallerPages.SearchVeterinaryDiseaseReportSelect,
                                                       CallerPages.SearchVeterinaryDiseaseReportEdit,
                                                       CallerPages.VeterinaryActiveSurveillanceMonitoringSessionEditVeterinaryDiseaseReport,
                                                       CallerPages.SearchVeterinaryDiseaseReportDelete})) Then
            If ViewState(CALLER) = CallerPages.SearchVeterinaryDiseaseReportDelete Then
                IsDelete = True
            Else
                IsDelete = False
            End If

            ViewState(CALLER) = CallerPages.Dashboard
            FillDropDowns()

            hdfVeterinaryDiseaseReportID.Value = ViewState(CALLER_KEY).ToString()
            ViewState(CALLER_KEY) = Nothing

            'Fills the disease summary div and notification section.
            FillForm(hdfVeterinaryDiseaseReportID.Value)

            'Fills the farm details section.  Use data from farm as the disease report has been saved, 
            'and a copy of the farm actual inserted into farm.
            FillFarmReview(False)
            FillFarmHerdSpecies(True, False)
            FillFarmEpidemiologicalInfo()
            FillVaccinations(True)
            FillControlMeasures()
            FillAnimals(True)
            FillSamples(True)
            FillPensideTests(True)
            FillTests(True)
            FillTestInterpretations(True)
            FillReportLogs(True)

            VerifyUserPermissions(True)

            ToggleVisibility(SectionDisease)
        Else
            upSearchDiseaseReports.Update()
            ViewState(CALLER) = CallerPages.LivestockVeterinaryDiseaseReport
            ViewState(CALLER_KEY) = Nothing
            SaveEIDSSViewState(ViewState)

            ucSearchVeterinaryDiseaseReport.Setup(selectMode:=SelectModes.View, farmType:=FarmTypes.LivestockFarmType)
            ToggleVisibility(SectionDiseaseReportSearch)
        End If

    End Sub

#End Region

#Region "Common Methods"

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

        PrepViewStates()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub PrepViewStates()

        'Used to correct any "nothing" values for known Viewstate variables
        'Add your new View State variables here
        Dim lKeys As List(Of String) = New List(Of String) From {CALLER, CALLER_KEY}

        For Each sKey As String In lKeys
            If (ViewState(sKey) Is Nothing) Then
                ViewState(sKey) = String.Empty
            End If
        Next

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sSection"></param>
    Private Sub ToggleVisibility(ByVal sSection As String)

        'Containers
        ucSearchVeterinaryDiseaseReport.Visible = sSection.Equals(SectionDiseaseReportSearch)
        divDiseaseReportContainer.Visible = sSection.EqualsAny({SectionFarmReview, SectionDisease, SectionFarmFlockSpecies, SectionSpecies, SectionFarmEpidemiologicalInformation, SectionSpeciesInvestigation, SectionVaccinations, SectionVaccination, SectionAnimals, SectionAnimal, SectionSample, SectionPensideTests, SectionPensideTest, SectionLabTestsInterpretations, SectionLabTest, SectionInterpretation, SectionCaseLogs, SectionCaseLog})
        divDiseaseReportForm.Visible = sSection.EqualsAny({SectionDisease, SectionFarmFlockSpecies, SectionSpecies, SectionVaccinations, SectionVaccination, SectionAnimals, SectionAnimal, SectionSamples, SectionSample, SectionPensideTests, SectionPensideTest, SectionLabTestsInterpretations, SectionLabTest, SectionInterpretation, SectionCaseLogs, SectionCaseLog})
        divAnimalForm.Visible = sSection.Equals(SectionAnimal)
        divSampleForm.Visible = sSection.Equals(SectionSample)
        divPensideTestForm.Visible = sSection.Equals(SectionPensideTest)
        divLabTestForm.Visible = sSection.Equals(SectionLabTest)
        divTestInterpretationForm.Visible = sSection.Equals(SectionInterpretation)
        divReportLogForm.Visible = sSection.Equals(SectionCaseLog)

        'Buttons
        If hdfVeterinaryDiseaseReportID.Value = "-1" Then
            btnPrintVeterinaryDiseaseReport.Visible = False
        Else
            btnPrintVeterinaryDiseaseReport.Visible = True
        End If

        If IsDelete = True Then
            btnDelete.Visible = True
        Else
            btnDelete.Visible = False
        End If

        If sSection.Equals(SectionConnectedDiseaseReport) Then
            btnAddVaccination.Visible = False
            btnAddAnimal.Visible = False
            btnAddSample.Visible = False
            btnAddPensideTest.Visible = False
            btnAddLabTest.Visible = False
            btnAddReportLog.Visible = False
        Else
            If gvSamples.Rows.Count >= 1 Then
                btnAddPensideTest.Visible = True
            Else
                btnAddPensideTest.Visible = False
            End If
        End If

        btnCreateConnectedDiseaseReport.Visible = CanCreateConnectedDiseaseReport()

        If Not sSection = SectionDiseaseReportSearch And Not sSection = SectionFarmSearch Then
            'Set focus to correct panel
            Select Case sSection
                Case SectionFarmReview, SectionDisease
                    hdfDiseaseReportPanelController.Value = 0
                Case SectionNotification
                    hdfDiseaseReportPanelController.Value = 1
                Case SectionFarmFlockSpecies, SectionSpecies
                    hdfDiseaseReportPanelController.Value = 2
                Case SectionFarmEpidemiologicalInformation
                    hdfDiseaseReportPanelController.Value = 3
                Case SectionSpeciesInvestigation
                    hdfDiseaseReportPanelController.Value = 4
                Case SectionVaccinations, SectionVaccination
                    hdfDiseaseReportPanelController.Value = 5
                Case SectionAnimals, SectionAnimal
                    hdfDiseaseReportPanelController.Value = 6
                Case SectionSamples, SectionSample
                    hdfDiseaseReportPanelController.Value = 7
                Case SectionPensideTests, SectionPensideTest
                    hdfDiseaseReportPanelController.Value = 8
                Case SectionLabTestsInterpretations, SectionLabTest, SectionInterpretation
                    hdfDiseaseReportPanelController.Value = 9
                Case SectionCaseLogs, SectionCaseLog
                    hdfDiseaseReportPanelController.Value = 10
            End Select
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub AvianDiseaseReport_Error(sender As Object, e As EventArgs) Handles Me.[Error]

        Dim exc As Exception = Server.GetLastError()

        If (TypeOf exc Is HttpUnhandledException) Then
            ShowWarningMessage(messageType:=MessageType.UnhandledException, isConfirm:=False)
        Else
            'Pass the error on to the error page.
            Dim delimiter As Char = "/"
            Dim sHandler As String() = Request.ServerVariables("SCRIPT_NAME").Split(delimiter)
            Server.Transfer("~/GeneralError.aspx?handler=" & sHandler.Last.ToString().Replace(".aspx", "") & "_Error%20-%20Default.aspx&aspxerrorpath=" & [GetType].Name, True)
        End If

        'Clear the error from the server.
        Server.ClearError()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    ''' <param name="message"></param>
    Private Sub ShowWarningMessage(messageType As MessageType, isConfirm As Boolean, Optional message As String = Nothing)

        hdgWarning.InnerText = Resources.WarningMessages.Warning_Message_Alert
        warningSubTitle.InnerText = String.Empty

        Select Case messageType
            Case MessageType.FarmTypeNotSelected
                divWarningBody.InnerText = Resources.WarningMessages.Farm_Type_Unselected
            Case MessageType.DuplicateSpeciesFlock
                warningSubTitle.InnerText = Resources.WarningMessages.Duplicate_Record_SubHeading
                divWarningBody.InnerText = Resources.WarningMessages.Duplicate_Species_Flock
            Case MessageType.DuplicateSpeciesHerd
                warningSubTitle.InnerText = Resources.WarningMessages.Duplicate_Record_SubHeading
                divWarningBody.InnerText = Resources.WarningMessages.Duplicate_Species_Herd
            Case MessageType.AssociatedSpeciesRecordsToFlock
                divWarningBody.InnerText = Resources.WarningMessages.Associated_Species_Records_Flock
            Case MessageType.AssociatedSpeciesRecordsToHerd
                divWarningBody.InnerText = Resources.WarningMessages.Associated_Species_Records_Herd
            Case MessageType.AssociatedRecordsToSpecies
                divWarningBody.InnerText = Resources.WarningMessages.Associated_Records_To_Species
            Case MessageType.CannotDelete
                warningSubTitle.InnerText = Resources.WarningMessages.Has_Child_Records_SubHeading
                divWarningBody.InnerText = message
            Case MessageType.NoFlockHerdSpeciesAssociated
                divWarningBody.InnerText = Resources.WarningMessages.Flock_Herd_Species
            Case MessageType.CancelConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Confirm
            Case MessageType.CancelSearchVeterinaryDiseaseReportConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Search_Confirm
            Case MessageType.ConfirmDelete
                divWarningBody.InnerText = message
            Case MessageType.AssociatedPensideTestRecords
                divWarningBody.InnerText = Resources.WarningMessages.Associated_Penside_Tests
            Case MessageType.AssociatedInterpretationRecords
                divWarningBody.InnerText = Resources.WarningMessages.Associated_Interpretations
            Case MessageType.CannotGetValidatorSection
                divWarningBody.InnerText = Resources.WarningMessages.Validator_Section
            Case MessageType.UnhandledException
                divWarningBody.InnerText = Resources.WarningMessages.Unhandled_Exception
            Case MessageType.SearchCriteriaRequired
                divWarningBody.InnerText = Resources.WarningMessages.Search_Criteria_Required
            Case MessageType.CancelAnimalConfirm
                hdfWarningMessageType.Value = MessageType.CancelAnimalConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Form_Confirm
            Case MessageType.CancelVaccinationConfirm
                hdfWarningMessageType.Value = MessageType.CancelVaccinationConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Form_Confirm
            Case MessageType.CancelPensideTestConfirm
                hdfWarningMessageType.Value = MessageType.CancelPensideTestConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Form_Confirm
            Case MessageType.CancelSampleConfirm
                hdfWarningMessageType.Value = MessageType.CancelSampleConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Form_Confirm
            Case MessageType.CancelLabTestConfirm
                hdfWarningMessageType.Value = MessageType.CancelLabTestConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Form_Confirm
            Case MessageType.CancelTestInterpretationConfirm
                hdfWarningMessageType.Value = MessageType.CancelTestInterpretationConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Form_Confirm
            Case MessageType.CancelReportLogConfirm
                hdfWarningMessageType.Value = MessageType.CancelReportLogConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Form_Confirm
        End Select

        If isConfirm Then
            divWarningYesNo.Visible = True
            divWarningOK.Visible = False
        Else
            divWarningOK.Visible = True
            divWarningYesNo.Visible = False
        End If

        upHiddenFields.Update()
        upWarningModal.Update()

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divWarningModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub SearchVeterinaryDiseaseReport_CancelVeterinaryDiseaseReport() Handles ucSearchVeterinaryDiseaseReport.ShowWarningModal

        Try
            ShowWarningMessage(messageType:=MessageType.CancelSearchVeterinaryDiseaseReportConfirm, isConfirm:=True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub WarningModalYes_Click(sender As Object, e As EventArgs) Handles btnWarningModalYes.Click

        Try
            If hdfRowAction.Value = RecordConstants.Delete Then
                Select Case hdfRecordType.Value
                    Case RecordTypeConstants.AvianDiseaseReport
                        DeleteDiseaseReport()
                    Case RecordTypeConstants.Interpretations
                        DeleteInterpretation(hdfRowID.Value)
                    Case RecordTypeConstants.LabTests
                        DeleteLabTest(hdfRowID.Value)
                    Case RecordTypeConstants.PensideTests
                        DeletePensideTest(hdfRowID.Value)
                    Case RecordTypeConstants.Animals
                        DeleteAnimal(hdfRowID.Value)
                    Case RecordTypeConstants.Samples
                        DeleteSample(hdfRowID.Value)
                    Case RecordTypeConstants.Vaccinations
                        DeleteVaccination(hdfRowID.Value)
                    Case RecordTypeConstants.VetCaseLogs
                        DeleteReportLog(hdfRowID.Value)
                    Case RecordTypeConstants.Herd
                        'ucAddUpdateFarm.DeleteHerdSpecies(hdfRowID.Value)
                End Select

                hdfRowAction.Value = String.Empty
                hdfRowID.Value = String.Empty
                hdfRecordType.Value = String.Empty
            ElseIf hdfRowAction.Value = RecordConstants.SelectFarm Then
                CheckCallerHandler()
            ElseIf hdfWarningMessageType.Value.IsValueNullOrEmpty = False Then
                Select Case hdfWarningMessageType.Value
                    Case MessageType.CancelAnimalConfirm
                        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_AND_WARNING_MODAL_SCRIPT, "#divAnimalModal"), True)
                    Case MessageType.CancelVaccinationConfirm
                        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_AND_WARNING_MODAL_SCRIPT, "#divVaccinationModal"), True)
                    Case MessageType.CancelPensideTestConfirm
                        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_AND_WARNING_MODAL_SCRIPT, "#divPensideTestModal"), True)
                    Case MessageType.CancelSampleConfirm
                        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_AND_WARNING_MODAL_SCRIPT, "#divSampleModal"), True)
                    Case MessageType.CancelLabTestConfirm
                        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_AND_WARNING_MODAL_SCRIPT, "#divLabTestModal"), True)
                    Case MessageType.CancelTestInterpretationConfirm
                        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_AND_WARNING_MODAL_SCRIPT, "#divTestInterpretationModal"), True)
                    Case MessageType.CancelReportLogConfirm
                        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_AND_WARNING_MODAL_SCRIPT, "#divReportLogModal"), True)
                End Select
            Else
                Response.Redirect(GetURL(CallerPages.DashboardURL), True)
                Context.ApplicationInstance.CompleteRequest()
            End If

            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divWarningModal"), True)
        Catch ae As Threading.ThreadAbortException
            'Response.End = True throws abort exception within Try/Catch.
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub WarningModalNo_Click(sender As Object, e As EventArgs) Handles btnWarningModalNo.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            hdfWarningMessageType.Value = String.Empty

            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divWarningModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    Private Sub ShowErrorMessage(messageType As MessageType, Optional message As String = Nothing)

        hdgError.InnerText = Resources.WarningMessages.Error_Message_Text
        errorSubTitle.InnerText = String.Empty

        Select Case messageType
            Case MessageType.CannotAddUpdate
                divErrorBody.InnerText = Resources.WarningMessages.Cannot_Save
            Case MessageType.UnhandledException
                divErrorBody.InnerText = Resources.WarningMessages.Unhandled_Exception
        End Select

        upErrorModal.Update()

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, "function showErrorModal() { $('#divErrorModal').modal('show'); }", True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    Private Sub ShowSuccessMessage(messageType As MessageType, Optional message As String = Nothing)

        Select Case messageType
            Case MessageType.DeleteSuccess
                lblSuccessMessage.InnerText = GetLocalResourceObject("Lbl_Message_Delete_Success")
            Case MessageType.AddUpdateSuccess
                lblSuccessMessage.InnerText = message
        End Select

        upSuccessModal.Update()

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSuccessModal"), True)

    End Sub

    '**************************************************************************
    '* Method: Verifies the employee groups a user/employee is a member of.
    '* 
    '* The requirements for this method are documented in use case VUC14.
    '**************************************************************************
    Private Sub VerifyUserPermissions(ByVal isEdit As Boolean)

        If EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.ChiefEpizootologist) Or
            EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.Epizootologist) Or
            EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.Administrator) Then
            If isEdit = True Then
                EnableForm(divDiseaseReportContainer, True)
                EnableForm(FarmHerdSpecies, True)
                EnableForm(VaccinationInformation, True)
                EnableForm(Animals, True)
                EnableForm(Samples, True)
                EnableForm(PensideTests, True)
                EnableForm(TestsAndTestInterpretations, True)
                EnableForm(ReportLog, True)
            Else
                EnableForm(divDiseaseReportContainer, False)
                EnableForm(FarmHerdSpecies, False)
                EnableForm(VaccinationInformation, False)
                EnableForm(Animals, False)
                EnableForm(Samples, False)
                EnableForm(PensideTests, False)
                EnableForm(TestsAndTestInterpretations, False)
                EnableForm(ReportLog, False)
            End If
        Else
            EnableForm(divDiseaseReportContainer, False)
            EnableForm(FarmHerdSpecies, False)
            EnableForm(VaccinationInformation, False)
            EnableForm(Animals, False)
            EnableForm(Samples, False)
            EnableForm(PensideTests, False)
            EnableForm(TestsAndTestInterpretations, False)
            EnableForm(ReportLog, False)
        End If

        EnableForm(FarmDetails, False)

        txtEIDSSOutbreakID.Enabled = False
        txtEIDSSParentMonitoringSessionID.Enabled = False
        txtFarmName.Enabled = False
        txtEIDSSReportID.Enabled = False
        txtEIDSSFarmID.Enabled = False
        txtSiteName.Enabled = False
        txtEnteredByPersonName.Enabled = False
        txtEnteredDate.Enabled = False
        txtPensideTestEIDSSAnimalID.Enabled = False
        txtPensideTestSampleType.Enabled = False
        txtLabTestEIDSSLaboratorySampleID.Enabled = False
        txtLabTestSampleTypeName.Enabled = False
        txtLabTestEIDSSAnimalID.Enabled = False
        txtLabTestDisease.Enabled = False

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="isEdit"></param>
    Private Sub VerifyLocationUserPermissions(ByVal isEdit As Boolean)

        If EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.ChiefEpizootologist) Or
            EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.Epizootologist) Or
            EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.Administrator) Then
            If isEdit = True Then
                EnableForm(FarmAddress, True)
            Else
                EnableForm(FarmAddress, False)
            End If
        Else
            EnableForm(FarmAddress, False)
        End If

    End Sub

#End Region

#Region "Veterinary Disease Report Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="diseaseReportID"></param>
    Protected Sub SearchVeterinaryDiseaseReport_EditDiseaseReport(diseaseReportID As Long) Handles ucSearchVeterinaryDiseaseReport.EditVeterinaryDiseaseReport

        Try
            FillDropDowns()

            hdfVeterinaryDiseaseReportID.Value = diseaseReportID.ToString()
            FillForm(hdfVeterinaryDiseaseReportID.Value)
            FillFarmReview(False)
            FillFarmHerdSpecies(True, False)
            FillFarmEpidemiologicalInfo()
            FillVaccinations(True)
            FillControlMeasures()
            FillAnimals(True)
            FillSamples(True)
            FillPensideTests(True)
            FillTests(True)
            FillTestInterpretations(True)
            FillReportLogs(True)

            VerifyUserPermissions(True)

            ToggleVisibility(SectionDisease)
            btnDelete.Visible = False

            upHiddenFields.Update()
            upSearchDiseaseReports.Update()
            upAddUpdateDiseaseReport.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="diseaseReportID"></param>
    Protected Sub SearchVeterinaryDiseaseReport_ViewDiseaseReport(diseaseReportID As Long) Handles ucSearchVeterinaryDiseaseReport.ViewVeterinaryDiseaseReport

        Try
            FillDropDowns()

            hdfVeterinaryDiseaseReportID.Value = diseaseReportID.ToString()
            FillForm(hdfVeterinaryDiseaseReportID.Value)
            FillFarmReview(False)
            FillFarmHerdSpecies(True, False)
            FillFarmEpidemiologicalInfo()
            FillControlMeasures()
            FillVaccinations(True)
            FillAnimals(True)
            FillSamples(True)
            FillPensideTests(True)
            FillTests(True)
            FillTestInterpretations(True)
            FillReportLogs(True)

            VerifyUserPermissions(True)

            ToggleVisibility(SectionDisease)
            btnSubmit.Visible = False

            upHiddenFields.Update()
            upSearchDiseaseReports.Update()
            upAddUpdateDiseaseReport.Update()

            If EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.Epizootologist) Or EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.ChiefEpizootologist) Or EIDSSAuthenticatedUser.IsInRole(EIDSSRoleEnum.Administrator) Then
                btnDelete.Visible = True
                ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, "displayPreviewMode(document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'))", True)
            Else
                btnDelete.Visible = False
                ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, "displayPreviewModeSecured(document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'))", True)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillDropDowns()

        FillBaseReferenceDropDownList(ddlReportStatusTypeID, BaseReferenceConstants.CaseStatus, HACodeList.LivestockHACode, True)
        ddlReportStatusTypeID = SortDropDownList(ddlReportStatusTypeID)
        FillBaseReferenceDropDownList(ddlClassificationTypeID, BaseReferenceConstants.CaseClassification, HACodeList.LivestockHACode, True)
        ddlClassificationTypeID = SortDropDownList(ddlClassificationTypeID)
        FillBaseReferenceDropDownList(ddlDiseaseID, BaseReferenceConstants.Diagnosis, HACodeList.LivestockHACode, True)
        FillBaseReferenceDropDownList(ddlVaccinationDiseaseID, BaseReferenceConstants.Diagnosis, HACodeList.LivestockHACode, True)
        ddlVaccinationDiseaseID = SortDropDownList(ddlVaccinationDiseaseID)
        FillBaseReferenceDropDownList(ddlReportTypeID, BaseReferenceConstants.CaseReportType, HACodeList.LivestockHACode, True)
        ddlReportTypeID = SortDropDownList(ddlReportTypeID)
        FillBaseReferenceDropDownList(ddlVaccinationVaccinationRouteTypeID, BaseReferenceConstants.VaccinationRouteList, HACodeList.LivestockHACode, True)
        ddlVaccinationVaccinationRouteTypeID = SortDropDownList(ddlVaccinationVaccinationRouteTypeID)
        FillBaseReferenceDropDownList(ddlVaccinationVaccinationTypeID, BaseReferenceConstants.VaccinationType, HACodeList.LivestockHACode, True)
        ddlVaccinationVaccinationTypeID = SortDropDownList(ddlVaccinationVaccinationTypeID)
        FillBaseReferenceDropDownList(ddlAnimalAgeTypeID, BaseReferenceConstants.AnimalAge, HACodeList.LivestockHACode, True)
        ddlAnimalAgeTypeID = SortDropDownList(ddlAnimalAgeTypeID)
        FillBaseReferenceDropDownList(ddlAnimalConditionTypeID, BaseReferenceConstants.AnimalBirdStatus, HACodeList.LivestockHACode, True)
        ddlAnimalConditionTypeID = SortDropDownList(ddlAnimalConditionTypeID)
        FillBaseReferenceDropDownList(ddlAnimalGenderTypeID, BaseReferenceConstants.AnimalSex, HACodeList.LivestockHACode, True)
        ddlAnimalGenderTypeID = SortDropDownList(ddlAnimalGenderTypeID)
        FillBaseReferenceDropDownList(ddlSampleSampleTypeID, BaseReferenceConstants.SampleType, HACodeList.LivestockHACode, True)
        ddlSampleSampleTypeID = SortDropDownList(ddlSampleSampleTypeID)
        FillBaseReferenceDropDownList(ddlPensideTestPensideTestNameTypeID, BaseReferenceConstants.PensideTestName, HACodeList.LivestockHACode, True)
        ddlPensideTestPensideTestNameTypeID = SortDropDownList(ddlPensideTestPensideTestNameTypeID)
        FillBaseReferenceDropDownList(ddlPensideTestPensideTestResultTypeID, BaseReferenceConstants.PensideTestResult, HACodeList.LivestockHACode, True)
        ddlPensideTestPensideTestResultTypeID = SortDropDownList(ddlPensideTestPensideTestResultTypeID)
        FillBaseReferenceDropDownList(ddlLabTestTestCategoryTypeID, BaseReferenceConstants.TestCategory, HACodeList.LivestockHACode, True)
        ddlLabTestTestCategoryTypeID.DataSource = SortDropDownList(ddlLabTestTestCategoryTypeID).Items
        FillBaseReferenceDropDownList(ddlLabTestTestNameTypeID, BaseReferenceConstants.TestName, HACodeList.LivestockHACode, True)
        ddlLabTestTestNameTypeID.DataSource = SortDropDownList(ddlLabTestTestNameTypeID).Items
        FillBaseReferenceDropDownList(ddlLabTestTestResultTypeID, BaseReferenceConstants.TestResult, HACodeList.LivestockHACode, True)
        ddlLabTestTestResultTypeID.DataSource = SortDropDownList(ddlLabTestTestResultTypeID).Items
        FillBaseReferenceDropDownList(ddlLabTestTestStatusTypeID, BaseReferenceConstants.TestStatus, HACodeList.LivestockHACode, True)
        FillBaseReferenceDropDownList(ddlInterpretationInterpretedStatusTypeID, BaseReferenceConstants.RuleInValueforTestValidation, HACodeList.LivestockHACode, True)

        'TODO: Migrate over to OrganizationServiceClient when ready; duplicate API methods.
        If CrossCuttingAPIService Is Nothing Then
            CrossCuttingAPIService = New CrossCuttingServiceClient()
        End If

        Dim organizationParameters = New OrganizationGetListParams()
        organizationParameters.LanguageID = GetCurrentLanguage()
        organizationParameters.AccessoryCode = AccessoryCodes.LivestockHACode
        organizationParameters.PaginationSetNumber = 1
        Dim organizations As List(Of GblOrganizationGetListModel) = CrossCuttingAPIService.GetOrganizationListAsync(organizationParameters).Result

        FillDropDownList(ddlReportedByOrganizationID, organizations, Nothing, OrganizationConstants.OrganizationID, "OrganizationAbbreviatedName", blankRow:=True)
        FillDropDownList(ddlInvestigatedByOrganizationID, organizations, Nothing, OrganizationConstants.OrganizationID, "OrganizationAbbreviatedName", blankRow:=True)

        organizationParameters.AccessoryCode = Nothing
        organizationParameters.OrganizationTypeID = OrganizationTypes.Laboratory
        organizations = CrossCuttingAPIService.GetOrganizationListAsync(organizationParameters).Result
        FillDropDownList(ddlSampleSentToOrganizationID, organizations, Nothing, OrganizationConstants.OrganizationID, "OrganizationAbbreviatedName", blankRow:=True)

        If EmployeeAPIService Is Nothing Then
            EmployeeAPIService = New EmployeeServiceClient()
        End If

        Dim parameters = New AdminEmployeeGetListParams With {.OrganizationID = EIDSSAuthenticatedUser.Institution}
        Dim employees = EmployeeAPIService.GetEmployees(parameters).Result
        ddlReportLogEnteredByPersonID.DataSource = employees.ToList()
        ddlReportLogEnteredByPersonID.DataTextField = "EmployeeFullName"
        ddlReportLogEnteredByPersonID.DataValueField = "EmployeeID"
        ddlReportLogEnteredByPersonID.DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="diseaseReportID"></param>
    Private Sub FillForm(ByVal diseaseReportID As String)

        Dim report As List(Of VetDiseaseReportGetDetailModel)
        If VeterinaryAPIService Is Nothing Then
            VeterinaryAPIService = New VeterinaryServiceClient()
        End If
        report = VeterinaryAPIService.GetVeterinaryDiseaseReportDetailAsync(GetCurrentLanguage(), diseaseReportID).Result

        upHiddenFields.Update()
        upDiseaseReportStickySummary.Update()
        upDiseaseReportCollapsibleSummary.Update()

        Scatter(divHiddenFieldsSection, report.FirstOrDefault(), 3)
        Scatter(divStickyHeader, report.FirstOrDefault(), 3)
        Scatter(divReportSummary, report.FirstOrDefault(), 3)
        Scatter(Notification, report.FirstOrDefault(), 3)

        If report.FirstOrDefault().LegacyID Is Nothing Then
            divLegacyID.Visible = False
        Else
            divLegacyID.Visible = True
        End If

        If report.FirstOrDefault().RelatedToVeterinaryDiseaseReportID Is Nothing Then
            divRelatedToDiseaseReport.Visible = False
        Else
            btnRelatedToDiseaseReport.Text = report.FirstOrDefault().RelatedToVeterinaryDiseaseEIDSSReportID
            divRelatedToDiseaseReport.Visible = True
        End If

        upDiseaseReportStickySummary.Update()
        upDiseaseReportCollapsibleSummary.Update()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Submit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click

        Try
            Validate("DiseaseReport")
            Validate("Notification")
            Validate("FarmHerdSpeciesSection")
            Validate("AnimalsSection")
            Validate("VaccinationsSection")
            Validate("ControlMeasures")
            Validate("SamplesSection")
            Validate("PensideTestsSection")
            Validate("LabTestSection")
            Validate("InterpretationSection")
            Validate("CaseLogSection")


            'TODO: Kishore will add SaveActualData method for all 4 flexible forms. 
            'hdfControlMeasuresObservationID.Value
            'hdfFarmEpidemiologicalInfoObservationID.Value




            If (Page.IsValid) Then
                AddUpdateDiseaseReport(createConnectedDiseaseReportIndicator:=False)

                FillDropDowns()
                'flaxformSave()
                'Fills the disease summary div and notification section.
                FillForm(hdfVeterinaryDiseaseReportID.Value)

                'Fills the farm details section.  Use data from farm as the disease report has been saved, 
                'and a copy of the farm actual inserted into farm.
                FillFarmReview(False)
                FillFarmHerdSpecies(True, False)
                FillFarmEpidemiologicalInfo()
                FillVaccinations(True)
                FillAnimals(True)
                FillSamples(True)
                FillPensideTests(True)
                FillTests(True)
                FillTestInterpretations(True)
                FillReportLogs(True)

                ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, "displayPreviewMode(document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'))", True)

                VerifyUserPermissions(True)
            Else
                DisplayDiseaseValidationErrors()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="createConnectedDiseaseReportIndicator"></param>
    Private Sub AddUpdateDiseaseReport(createConnectedDiseaseReportIndicator As Boolean)

        If Session(HERD_SPECIES_LIST) Is Nothing Then
            Session(HERD_SPECIES_LIST) = New List(Of VetFarmHerdSpeciesGetListModel)()
        End If
        Dim farmHerdSpecies = CType(Session(HERD_SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))

        If Session(VACCINATIONS_LIST) Is Nothing Then
            Session(VACCINATIONS_LIST) = New List(Of VetVaccinationGetListModel)()
        End If

        If Session(ANIMALS_LIST) Is Nothing Then
            Session(ANIMALS_LIST) = New List(Of VetAnimalGetListModel)()
        End If

        If Session(SAMPLES_LIST) Is Nothing Then
            Session(SAMPLES_LIST) = New List(Of GblSampleGetListModel)()
        End If

        If Session(PENSIDE_TESTS_LIST) Is Nothing Then
            Session(PENSIDE_TESTS_LIST) = New List(Of VetPensideTestGetListModel)()
        End If

        If Session(TESTS_LIST) Is Nothing Then
            Session(TESTS_LIST) = New List(Of GblTestGetListModel)()
        End If

        If Session(TEST_INTERPRETATIONS_LIST) Is Nothing Then
            Session(TEST_INTERPRETATIONS_LIST) = New List(Of GblTestInterpretationGetListModel)()
        End If

        If Session(REPORT_LOGS_LIST) Is Nothing Then
            Session(REPORT_LOGS_LIST) = New List(Of VetDiseaseReportLogGetListModel)()
        End If

        Dim parameters As VeterinaryDiseaseReportSetParameters = New VeterinaryDiseaseReportSetParameters With {
                .LanguageID = GetCurrentLanguage(),
                .FarmDeadAnimalQuantity = farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Farm).FirstOrDefault().DeadAnimalQuantity,
                .FarmSickAnimalQuantity = farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Farm).FirstOrDefault().SickAnimalQuantity,
                .FarmTotalAnimalQuantity = farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Farm).FirstOrDefault().TotalAnimalQuantity,
                .SiteID = EIDSSAuthenticatedUser.SiteId,
                .HerdsOrFlocks = BuildHerdParameters(CType(Session(HERDS_LIST), List(Of VetFarmHerdSpeciesGetListModel)).Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).ToList(), createConnectedDiseaseReportIndicator),
                .Species = BuildSpeciesParameters(CType(Session(SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel)), createConnectedDiseaseReportIndicator),
                .Animals = BuildAnimalParameters(CType(Session(ANIMALS_LIST), List(Of VetAnimalGetListModel)), createConnectedDiseaseReportIndicator),
                .Vaccinations = BuildVaccinationParameters(CType(Session(VACCINATIONS_LIST), List(Of VetVaccinationGetListModel)), createConnectedDiseaseReportIndicator),
                .Samples = BuildSampleParameters(CType(Session(SAMPLES_LIST), List(Of GblSampleGetListModel)), createConnectedDiseaseReportIndicator),
                .PensideTests = BuildPensideTestParameters(CType(Session(PENSIDE_TESTS_LIST), List(Of VetPensideTestGetListModel)), createConnectedDiseaseReportIndicator),
                .Tests = BuildLabTestParameters(CType(Session(TESTS_LIST), List(Of GblTestGetListModel)), createConnectedDiseaseReportIndicator),
                .TestInterpretations = BuildTestInterpretationParameters(CType(Session(TEST_INTERPRETATIONS_LIST), List(Of GblTestInterpretationGetListModel)), createConnectedDiseaseReportIndicator),
                .VeterinaryDiseaseReportLogs = BuildReportLogParameters(CType(Session(REPORT_LOGS_LIST), List(Of VetDiseaseReportLogGetListModel)), createConnectedDiseaseReportIndicator)
            }

        'TODO: Kishore, parameter for the farm epi ID is FarmEpidemiologicalObservationID; set on parameters.  Potentially save FF info and get obs id here?
        'TODO: Kishore, control measure (FF type 10034014) observation ID on the tlbVetCase table.  Potentially save FF info and get obs ID here?

        Gather(divHiddenFieldsSection, parameters, 3)
        Gather(divStickyHeader, parameters, 3)
        Gather(divReportSummary, parameters, 3)
        Gather(Notification, parameters, 3)

        If VeterinaryAPIService Is Nothing Then
            VeterinaryAPIService = New VeterinaryServiceClient()
        End If
        Dim returnResults As List(Of VetDiseaseReportSetModel) = VeterinaryAPIService.SaveVeterinaryDiseaseReportAsync(parameters).Result

        If returnResults.Count = 0 Then
            ShowErrorMessage(messageType:=MessageType.CannotAddUpdate)
        Else
            If returnResults.FirstOrDefault().ReturnCode = 0 Then
                If hdfVeterinaryDiseaseReportID.Value = "-1" Then
                    hdfVeterinaryDiseaseReportID.Value = returnResults.FirstOrDefault().VeterinaryDiseaseReportID

                    ShowSuccessMessage(messageType:=MessageType.AddUpdateSuccess, message:=GetLocalResourceObject("Lbl_Create_Success") & returnResults.FirstOrDefault().EIDSSReportID & ".")
                Else
                    ShowSuccessMessage(messageType:=MessageType.AddUpdateSuccess, message:=GetLocalResourceObject("Lbl_Update_Success"))

                End If
            Else
                ShowWarningMessage(messageType:=MessageType.CannotAddUpdate, isConfirm:=False)
            End If
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="herds"></param>
    ''' <param name="createConnectedDiseaseReportIndicator"></param>
    ''' <returns></returns>
    Private Function BuildHerdParameters(herds As List(Of VetFarmHerdSpeciesGetListModel), createConnectedDiseaseReportIndicator As Boolean) As List(Of HerdParameters)

        Dim herdParameters As List(Of HerdParameters) = New List(Of HerdParameters)()
        Dim herdParameter As HerdParameters

        For Each herdModel As VetFarmHerdSpeciesGetListModel In herds
            herdParameter = New HerdParameters()
            With herdParameter
                .DeadAnimalQuantity = herdModel.DeadAnimalQuantity
                .EIDSSHerdID = herdModel.EIDSSHerdID
                .FarmID = herdModel.FarmID
                .HerdID = herdModel.HerdID
                .HerdMasterID = herdModel.HerdMasterID
                .SickAnimalQuantity = herdModel.SickAnimalQuantity
                .TotalAnimalQuantity = herdModel.TotalAnimalQuantity
                .RowAction = If(createConnectedDiseaseReportIndicator = False, herdModel.RowAction, RecordConstants.Insert)
                .RowStatus = herdModel.RowStatus
            End With

            herdParameters.Add(herdParameter)
        Next

        Return herdParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="species"></param>
    ''' <param name="createConnectedDiseaseReportIndicator"></param>
    ''' <returns></returns>
    Private Function BuildSpeciesParameters(species As List(Of VetFarmHerdSpeciesGetListModel), createConnectedDiseaseReportIndicator As Boolean) As List(Of SpeciesParameters)

        Dim speciesParameters As List(Of SpeciesParameters) = New List(Of SpeciesParameters)()
        Dim speciesParameter As SpeciesParameters

        'TODO: Kishore, observation ID sent into main vet disease stored proc here for each species... 

        For Each speciesModel As VetFarmHerdSpeciesGetListModel In species
            speciesParameter = New SpeciesParameters()
            With speciesParameter
                .AverageAge = speciesModel.AverageAge
                .DeadAnimalQuantity = speciesModel.DeadAnimalQuantity
                .HerdID = speciesModel.HerdID
                .ObservationID = speciesModel.ObservationID
                .SickAnimalQuantity = speciesModel.SickAnimalQuantity
                .SpeciesID = speciesModel.SpeciesID
                .SpeciesMasterID = speciesModel.SpeciesMasterID
                .SpeciesTypeID = speciesModel.SpeciesTypeID
                .StartOfSignsDate = speciesModel.StartOfSignsDate
                .TotalAnimalQuantity = speciesModel.TotalAnimalQuantity
                .RowAction = If(createConnectedDiseaseReportIndicator = False, speciesModel.RowAction, RecordConstants.Insert)
                .RowStatus = speciesModel.RowStatus
            End With

            speciesParameters.Add(speciesParameter)
        Next

        Return speciesParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="animals"></param>
    ''' <param name="createConnectedDiseaseReportIndicator"></param>
    ''' <returns></returns>
    Private Function BuildAnimalParameters(animals As List(Of VetAnimalGetListModel), createConnectedDiseaseReportIndicator As Boolean) As List(Of AnimalParameters)

        Dim animalParameters As List(Of AnimalParameters) = New List(Of AnimalParameters)()
        Dim animalParameter As AnimalParameters

        For Each animalModel As VetAnimalGetListModel In animals
            animalParameter = New AnimalParameters()
            With animalParameter
                .AnimalAgeTypeID = animalModel.AnimalAgeTypeID
                .AnimalConditionTypeID = animalModel.AnimalConditionTypeID
                .AnimalDescription = animalModel.AnimalDescription
                .AnimalID = animalModel.AnimalID
                .AnimalName = animalModel.AnimalName
                .Color = animalModel.Color
                .EIDSSAnimalID = animalModel.EIDSSAnimalID
                .AnimalGenderTypeID = animalModel.AnimalGenderTypeID
                .ObservationID = animalModel.ObservationID
                .SpeciesID = animalModel.SpeciesID
                .RowAction = If(createConnectedDiseaseReportIndicator = False, animalModel.RowAction, RecordConstants.Insert)
                .RowStatus = animalModel.RowStatus
            End With

            animalParameters.Add(animalParameter)
        Next

        Return animalParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="vaccinations"></param>
    ''' <param name="createConnectedDiseaseReportIndicator"></param>
    ''' <returns></returns>
    Private Function BuildVaccinationParameters(vaccinations As List(Of VetVaccinationGetListModel), createConnectedDiseaseReportIndicator As Boolean) As List(Of VeterinaryVaccinationParameters)

        Dim vaccinationParameters As List(Of VeterinaryVaccinationParameters) = New List(Of VeterinaryVaccinationParameters)()
        Dim vaccinationParameter As VeterinaryVaccinationParameters

        For Each vaccinationModel As VetVaccinationGetListModel In vaccinations
            vaccinationParameter = New VeterinaryVaccinationParameters()
            With vaccinationParameter
                .Comments = vaccinationModel.Comments
                .DiseaseID = vaccinationModel.DiseaseID
                .LotNumber = vaccinationModel.LotNumber
                .Manufacturer = vaccinationModel.Manufacturer
                .NumberVaccinated = vaccinationModel.NumberVaccinated
                .RouteTypeID = vaccinationModel.VaccinationRouteTypeID
                .RowAction = If(createConnectedDiseaseReportIndicator = False, vaccinationModel.RowAction, RecordConstants.Insert)
                .RowStatus = vaccinationModel.RowStatus
                .SpeciesID = vaccinationModel.SpeciesID
                .VaccinationDate = vaccinationModel.VaccinationDate
                .VaccinationID = vaccinationModel.VaccinationID
                .VaccinationTypeID = vaccinationModel.VaccinationTypeID
            End With

            vaccinationParameters.Add(vaccinationParameter)
        Next

        Return vaccinationParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="samples"></param>
    ''' <param name="createConnectedDiseaseReportIndicator"></param>
    ''' <returns></returns>
    Private Function BuildSampleParameters(samples As List(Of GblSampleGetListModel), createConnectedDiseaseReportIndicator As Boolean) As List(Of VeterinarySampleParameters)

        Dim sampleParameters As List(Of VeterinarySampleParameters) = New List(Of VeterinarySampleParameters)()
        Dim sampleParameter As VeterinarySampleParameters

        For Each sampleModel As GblSampleGetListModel In samples
            sampleParameter = New VeterinarySampleParameters()
            With sampleParameter
                .AnimalID = sampleModel.AnimalID
                .BirdStatusTypeID = sampleModel.BirdStatusTypeID
                .DiseaseID = sampleModel.DiseaseID
                .EIDSSLocalOrFieldSampleID = sampleModel.EIDSSLocalOrFieldSampleID
                .EnteredDate = sampleModel.EnteredDate
                .CollectedByOrganizationID = sampleModel.CollectedByOrganizationID
                .CollectedByPersonID = sampleModel.CollectedByPersonID
                .CollectionDate = sampleModel.CollectionDate
                .SentDate = sampleModel.SentDate
                .SentToOrganizationID = sampleModel.SentToOrganizationID
                .MonitoringSessionID = sampleModel.MonitoringSessionID
                .Comments = sampleModel.Comments
                .RowAction = If(createConnectedDiseaseReportIndicator = False, sampleModel.RowAction, RecordConstants.Insert)
                .RowStatus = sampleModel.RowStatus
                .SampleID = sampleModel.SampleID
                .SampleStatusTypeID = sampleModel.SampleStatusTypeID
                .SampleTypeID = sampleModel.SampleTypeID
                .SiteID = sampleModel.SiteID
                .SpeciesID = sampleModel.SpeciesID
            End With

            sampleParameters.Add(sampleParameter)
        Next

        Return sampleParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pensideTests"></param>
    ''' <param name="createConnectedDiseaseReportIndicator"></param>
    ''' <returns></returns>
    Private Function BuildPensideTestParameters(pensideTests As List(Of VetPensideTestGetListModel), createConnectedDiseaseReportIndicator As Boolean) As List(Of PensideTestParameters)

        Dim pensideTestParameters As List(Of PensideTestParameters) = New List(Of PensideTestParameters)()
        Dim pensideTestParameter As PensideTestParameters

        For Each pensideTestModel As VetPensideTestGetListModel In pensideTests
            pensideTestParameter = New PensideTestParameters()
            With pensideTestParameter
                .DiseaseID = pensideTestModel.DiseaseID
                .PensideTestCategoryTypeID = pensideTestModel.PensideTestCategoryTypeID
                .PensideTestID = pensideTestModel.PensideTestID
                .PensideTestNameTypeID = pensideTestModel.PensideTestNameTypeID
                .PensideTestResultTypeID = pensideTestModel.PensideTestResultTypeID
                .RowAction = If(createConnectedDiseaseReportIndicator = False, pensideTestModel.RowAction, RecordConstants.Insert)
                .RowStatus = pensideTestModel.RowStatus
                .SampleID = pensideTestModel.SampleID
                .TestDate = pensideTestModel.TestDate
                .TestedByOrganizationID = pensideTestModel.TestedByOrganizationID
                .TestedByPersonID = pensideTestModel.TestedByPersonID
            End With

            pensideTestParameters.Add(pensideTestParameter)
        Next

        Return pensideTestParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="labTests"></param>
    ''' <param name="createConnectedDiseaseReportIndicator"></param>
    ''' <returns></returns>
    Private Function BuildLabTestParameters(labTests As List(Of GblTestGetListModel), createConnectedDiseaseReportIndicator As Boolean) As List(Of LabTestParameters)

        Dim labTestParameters As List(Of LabTestParameters) = New List(Of LabTestParameters)()
        Dim labTestParameter As LabTestParameters

        For Each labTestModel As GblTestGetListModel In labTests
            labTestParameter = New LabTestParameters()
            With labTestParameter
                .BatchTestID = labTestModel.BatchTestID
                .Comments = labTestModel.Comments
                .ContactPersonName = labTestModel.ContactPersonName
                .DiseaseID = labTestModel.DiseaseID
                .ExternalTestIndicator = labTestModel.ExternalTestIndicator
                .NonLaboratoryTestIndicator = labTestModel.NonLaboratoryTestIndicator
                .ObservationID = labTestModel.ObservationID
                .PerformedByOrganizationID = labTestModel.PerformedByOrganizationID
                .ReadOnlyIndicator = labTestModel.ReadOnlyIndicator
                .ReceivedDate = labTestModel.ReceivedDate
                .ResultDate = labTestModel.ResultDate
                .ResultEnteredByOrganizationID = labTestModel.ResultEnteredByOrganizationID
                .ResultEnteredByPersonID = labTestModel.ResultEnteredByPersonID
                .RowAction = If(createConnectedDiseaseReportIndicator = False, labTestModel.RowAction, RecordConstants.Insert)
                .RowStatus = labTestModel.RowStatus
                .SampleID = labTestModel.SampleID
                .StartedDate = labTestModel.StartedDate
                .TestCategoryTypeID = labTestModel.TestCategoryTypeID
                .TestedByOrganizationID = labTestModel.TestedByOrganizationID
                .TestedByPersonID = labTestModel.TestedByPersonID
                .TestID = labTestModel.TestID
                .TestNameTypeID = labTestModel.TestNameTypeID
                .TestNumber = labTestModel.TestNumber
                .TestResultTypeID = labTestModel.TestResultTypeID
                .TestStatusTypeID = labTestModel.TestStatusTypeID
                .ValidatedByOrganizationID = labTestModel.ValidatedByOrganizationID
                .ValidatedByPersonID = labTestModel.ValidatedByPersonID
            End With

            labTestParameters.Add(labTestParameter)
        Next

        Return labTestParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testInterpretations"></param>
    ''' <param name="createConnectedDiseaseReportIndicator"></param>
    ''' <returns></returns>
    Private Function BuildTestInterpretationParameters(testInterpretations As List(Of GblTestInterpretationGetListModel), createConnectedDiseaseReportIndicator As Boolean) As List(Of TestInterpretationParameters)

        Dim testInterpretationParameters As List(Of TestInterpretationParameters) = New List(Of TestInterpretationParameters)()
        Dim testInterpretationParameter As TestInterpretationParameters

        For Each testIntepretationModel As GblTestInterpretationGetListModel In testInterpretations
            testInterpretationParameter = New TestInterpretationParameters()
            With testInterpretationParameter
                .DiseaseID = testIntepretationModel.DiseaseID
                .InterpretedByOrganizationID = testIntepretationModel.InterpretedByOrganizationID
                .InterpretedByPersonID = testIntepretationModel.InterpretedByPersonID
                .InterpretedComment = testIntepretationModel.InterpretedComment
                .InterpretedDate = testIntepretationModel.InterpretedDate
                .InterpretedStatusTypeID = testIntepretationModel.InterpretedStatusTypeID
                .ReadOnlyIndicator = testIntepretationModel.ReadOnlyIndicator
                .ReportSessionCreatedIndicator = testIntepretationModel.ReportSessionCreatedIndicator
                .RowAction = If(createConnectedDiseaseReportIndicator = False, testIntepretationModel.RowAction, RecordConstants.Insert)
                .RowStatus = testIntepretationModel.RowStatus
                .TestID = testIntepretationModel.TestID
                .TestInterpretationID = testIntepretationModel.TestInterpretationID
                .ValidatedByOrganizationID = testIntepretationModel.ValidatedByOrganizationID
                .ValidatedByPersonID = testIntepretationModel.ValidatedByPersonID
                .ValidatedComment = testIntepretationModel.ValidatedComment
                .ValidatedStatusIndicator = testIntepretationModel.ValidatedStatusIndicator
            End With

            testInterpretationParameters.Add(testInterpretationParameter)
        Next

        Return testInterpretationParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="reportLogs"></param>
    ''' <param name="createConnectedDiseaseReportIndicator"></param>
    ''' <returns></returns>
    Private Function BuildReportLogParameters(reportLogs As List(Of VetDiseaseReportLogGetListModel), createConnectedDiseaseReportIndicator As Boolean) As List(Of VeterinaryDiseaseReportLogParameters)

        Dim reportLogParameters As List(Of VeterinaryDiseaseReportLogParameters) = New List(Of VeterinaryDiseaseReportLogParameters)()

        If createConnectedDiseaseReportIndicator = False Then
            Dim reportLogParameter As VeterinaryDiseaseReportLogParameters

            For Each reportLogModel As VetDiseaseReportLogGetListModel In reportLogs
                reportLogParameter = New VeterinaryDiseaseReportLogParameters()
                With reportLogParameter
                    .ActionRequired = reportLogModel.ActionRequired
                    .Comments = reportLogModel.Comments
                    .LogDate = reportLogModel.LogDate
                    .LoggedByPersonID = reportLogModel.PersonID
                    .LogStatusTypeID = reportLogModel.LogStatusTypeID
                    .RowAction = reportLogModel.RowAction
                    .RowStatus = reportLogModel.RowStatus
                    .VeterinaryDiseaseReportLogID = reportLogModel.VeterinaryDiseaseReportLogID
                End With

                reportLogParameters.Add(reportLogParameter)
            Next
        End If

        Return reportLogParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub DisplayDiseaseValidationErrors()

        'Paint all SideBarItems as passed validation and then correct those that failed.
        sbiFarmDetails.ItemStatus = SideBarStatus.IsValid
        sbiNotification.ItemStatus = SideBarStatus.IsValid
        sbiFarmHerdSpecies.ItemStatus = SideBarStatus.IsValid
        sbiFarmEpidemiologicalInfo.ItemStatus = SideBarStatus.IsValid
        sbiSpeciesInvestigation.ItemStatus = SideBarStatus.IsValid
        sbiVaccinationInformation.ItemStatus = SideBarStatus.IsValid
        sbiSamples.ItemStatus = SideBarStatus.IsValid
        sbiPensideTests.ItemStatus = SideBarStatus.IsValid
        sbiLabTestsInterpretation.ItemStatus = SideBarStatus.IsValid
        sbiCaseLog.ItemStatus = SideBarStatus.IsValid

        Dim oValidator As IValidator
        For Each oValidator In Validators
            If oValidator.IsValid = False Then
                Dim failedValidator As RequiredFieldValidator = oValidator
                Dim section As HtmlGenericControl = TryCast(failedValidator.Parent.Parent, HtmlGenericControl)

                If section Is Nothing AndAlso Not failedValidator.ValidationGroup = "DiseaseReport" Then
                    'Validator's parent could not be determined, set the review section as invalid and report the issue to the user.
                    sbiReview.ItemStatus = SideBarStatus.IsInvalid
                    sbiReview.CssClass = "glyphicon glyphicon-remove"
                    ShowWarningMessage(messageType:=MessageType.CannotGetValidatorSection, isConfirm:=False)
                Else
                    If Not section Is Nothing Then
                        Select Case section.ID
                            Case "FarmDetails"
                                sbiFarmDetails.ItemStatus = SideBarStatus.IsInvalid
                                sbiFarmDetails.CssClass = "glyphicon glyphicon-remove"
                            Case "Notification"
                                sbiNotification.ItemStatus = SideBarStatus.IsInvalid
                                sbiNotification.CssClass = "glyphicon glyphicon-remove"
                            Case "FarmHerdpecies"
                                sbiFarmHerdSpecies.ItemStatus = SideBarStatus.IsInvalid
                                sbiFarmHerdSpecies.CssClass = "glyphicon glyphicon-remove"
                            Case "FarmEpidemiologicalInfo"
                                sbiFarmEpidemiologicalInfo.ItemStatus = SideBarStatus.IsInvalid
                                sbiFarmEpidemiologicalInfo.CssClass = "glyphicon glyphicon-remove"
                            Case "SpeciesClinicalInvestigation"
                                sbiSpeciesInvestigation.ItemStatus = SideBarStatus.IsInvalid
                                sbiSpeciesInvestigation.CssClass = "glyphicon glyphicon-remove"
                            Case "ControlMeasures"
                                sbiControlMeasures.ItemStatus = SideBarStatus.IsInvalid
                                sbiControlMeasures.CssClass = "glyphicon glyphicon-remove"
                            Case "Animals"
                                sbiAnimals.ItemStatus = SideBarStatus.IsInvalid
                                sbiAnimals.CssClass = "glyphicon glyphicon-remove"
                            Case "Samples"
                                sbiSamples.ItemStatus = SideBarStatus.IsInvalid
                                sbiSamples.CssClass = "glyphicon glyphicon-remove"
                            Case "VaccinationInformation"
                                sbiVaccinationInformation.ItemStatus = SideBarStatus.IsInvalid
                                sbiVaccinationInformation.CssClass = "glyphicon glyphicon-remove"
                            Case "PensideTests"
                                sbiPensideTests.ItemStatus = SideBarStatus.IsInvalid
                                sbiPensideTests.CssClass = "glyphicon glyphicon-remove"
                            Case "LabTestsInterpretation"
                                sbiLabTestsInterpretation.ItemStatus = SideBarStatus.IsInvalid
                                sbiLabTestsInterpretation.CssClass = "glyphicon glyphicon-remove"
                            Case "CaseLog"
                                sbiCaseLog.ItemStatus = SideBarStatus.IsInvalid
                                sbiCaseLog.CssClass = "glyphicon glyphicon-remove"
                        End Select
                    End If
                End If
            End If
        Next

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Disease_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlDiseaseID.SelectedIndexChanged

        Try
            Dim tests = CType(Session(TESTS_LIST), List(Of GblTestGetListModel))

            If tests Is Nothing Then
                tests = New List(Of GblTestGetListModel)()
            End If

            If ddlDiseaseID.SelectedIndex = -1 Then
                chkFilterByDisease.Enabled = False

                For Each test As GblTestGetListModel In tests
                    test.DiseaseID = "-1"
                    test.DiseaseName = String.Empty
                Next

                txtLabTestDisease.Text = String.Empty
            Else
                chkFilterByDisease.Enabled = True

                For Each test As GblTestGetListModel In tests
                    test.DiseaseID = ddlDiseaseID.SelectedValue
                    test.DiseaseName = ddlDiseaseID.SelectedItem.Text
                Next

                txtLabTestDisease.Text = ddlDiseaseID.SelectedItem.Text

                txtVaccinationVaccinationDate.Text = Date.Today.ToShortDateString()
                upVaccinationModal.Update()
            End If

            gvLabTests.DataSource = Nothing
            Session(TESTS_LIST) = tests
            gvLabTests.DataSource = tests.ToList()
            gvLabTests.DataBind()

            'Keep the disease report summary collapsible expanded for better user experience.
            ScriptManager.RegisterStartupScript(Me, [GetType](), "Expand", "expandDiseaseReportSummary();", True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <returns></returns>
    Private Function CanCreateConnectedDiseaseReport() As Boolean

        Dim tests = CType(ViewState(TESTS_LIST), List(Of GblTestGetListModel))
        Dim testInterpretations = CType(ViewState(TEST_INTERPRETATIONS_LIST), List(Of GblTestInterpretationGetListModel))

        If tests Is Nothing Or testInterpretations Is Nothing Then
            Return False
        End If

        If ddlDiseaseID.SelectedValue = GlobalConstants.NullValue.ToLower() Then
            Return False
        ElseIf tests.Where(Function(x) x.DiseaseID = ddlDiseaseID.SelectedValue).Count > 0 Then
            If testInterpretations.Where(Function(x) x.InterpretedStatusTypeID = InterpretedStatusTypes.RuledIn And x.ValidatedStatusIndicator = True).Count > 0 Then
                Return True
            Else
                Return False
            End If
        Else
            Return False
        End If

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub CreateConnectedDiseaseReport()

        Try
            upHiddenFields.Update()
            Validate("DiseaseReport")
            Validate("Notification")
            Validate("FarmHerdSpeciesSection")
            Validate("VaccinationsSection")
            Validate("SamplesSection")
            Validate("PensideTestsSection")
            Validate("LabTestSection")
            Validate("InterpretationSection")
            Validate("CaseLogSection")
            hdfRelatedToVeterinaryDiseaseReportID.Value = hdfVeterinaryDiseaseReportID.Value
            hdfVeterinaryDiseaseReportID.Value = "-1"
            If (Page.IsValid) Then
                AddUpdateDiseaseReport(createConnectedDiseaseReportIndicator:=True)

                FillDropDowns()

                'Fills the disease summary div and notification section.
                FillForm(hdfVeterinaryDiseaseReportID.Value)

                'Fills the farm details section.  Use data from farm as the disease report has been saved, 
                'and a copy of the farm actual inserted into farm.
                FillFarmReview(False)
                FillFarmHerdSpecies(True, False)
                FillFarmEpidemiologicalInfo()
                FillVaccinations(True)
                FillSamples(True)
                FillPensideTests(True)
                FillTests(True)
                FillTestInterpretations(True)
                FillReportLogs(True)

                ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, "displayPreviewMode(document.getElementById('EIDSSBodyCPH_hdfDiseaseReportPanelController'), document.getElementById('DiseaseReportSideBar'), document.getElementById('EIDSSBodyCPH_divDiseaseReportForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit'))", True)

                VerifyUserPermissions(True)
            Else
                DisplayDiseaseValidationErrors()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub DeleteVeterinaryDiseaseReport_Click(sender As Object, e As EventArgs) Handles btnDelete.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            ShowWarningMessage(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Resources.WarningMessages.Confirm_Delete_Message)

            hdfRowAction.Value = RecordConstants.Delete
            hdfRecordType.Value = RecordTypeConstants.AvianDiseaseReport

            upHiddenFields.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub DeleteDiseaseReport()

        Try
            If VeterinaryAPIService Is Nothing Then
                VeterinaryAPIService = New VeterinaryServiceClient()
            End If
            Dim returnResults As List(Of VetDiseaseReportDelModel) = VeterinaryAPIService.DeleteVeterinaryDiseaseReportAsync(GetCurrentLanguage(), hdfVeterinaryDiseaseReportID.Value).Result

            If returnResults.Count = 0 Then
                ShowErrorMessage(messageType:=MessageType.CannotDelete)
            Else
                Select Case returnResults.FirstOrDefault().ReturnCode
                    Case 0
                        upSearchDiseaseReports.Update()
                        upAddUpdateDiseaseReport.Update()
                        ShowSuccessMessage(messageType:=MessageType.DeleteSuccess)
                        ucSearchVeterinaryDiseaseReport.Setup(selectMode:=SelectModes.View, farmType:=FarmTypes.LivestockFarmType)
                        ToggleVisibility(SectionDiseaseReportSearch)
                    Case 1
                        ShowWarningMessage(messageType:=MessageType.CannotDelete, isConfirm:=False, message:=Resources.WarningMessages.Child_Objects_Message)
                    Case 2
                        ShowWarningMessage(messageType:=MessageType.CannotDelete, isConfirm:=False, message:=Resources.WarningMessages.Another_Object_Message)
                End Select
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub CancelVeterinaryDiseaseReport_Click(sender As Object, e As EventArgs) Handles btnCancelVeterinaryDiseaseReport.Click

        ScriptManager.RegisterClientScriptBlock(Me, [GetType](), MODAL_KEY, "$(function(){ $('#" & divCancelModalContainer.ClientID & "').modal('show');});", True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub CancelYes_Click(sender As Object, e As EventArgs) Handles btnCancelYes.Click

        Try
            ScriptManager.RegisterClientScriptBlock(Me, [GetType](), MODAL_KEY, "$(function(){ $('#" & divCancelModalContainer.ClientID & "').modal('hide');});", True)

            ViewState(CALLER) = CallerPages.Dashboard
            SaveEIDSSViewState(ViewState)

            CheckCallerHandler()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub PrintVeterinaryDiseaseReport_Click(sender As Object, e As EventArgs) Handles btnPrintVeterinaryDiseaseReport.Click

    End Sub

#End Region

#Region "Farm Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="isRootFarm"></param>
    Private Sub FillFarmReview(ByVal isRootFarm As Boolean)

        Try
            If FarmAPIService Is Nothing Then
                FarmAPIService = New FarmServiceClient()
            End If

            If isRootFarm Then
                Dim farmMaster = FarmAPIService.GetFarmMasterDetailAsync(GetCurrentLanguage(), hdfFarmMasterID.Value).Result

                If Not IsNothing(farmMaster) Then
                    FarmAddress.LocationCountryID = farmMaster.FirstOrDefault().FarmAddressidfsCountry
                    FarmAddress.LocationRegionID = farmMaster.FirstOrDefault().FarmAddressidfsRegion
                    FarmAddress.LocationRayonID = farmMaster.FirstOrDefault().FarmAddressidfsRayon
                    FarmAddress.LocationSettlementID = farmMaster.FirstOrDefault().FarmAddressidfsSettlement
                    FarmAddress.LocationPostalCodeName = farmMaster.FirstOrDefault().FarmAddressstrPostalCode
                    FarmAddress.ApartmentText = farmMaster.FirstOrDefault().FarmAddressstrApartment
                    FarmAddress.BuildingText = farmMaster.FirstOrDefault().FarmAddressstrBuilding
                    FarmAddress.HouseText = farmMaster.FirstOrDefault().FarmAddressstrHouse
                    FarmAddress.StreetText = farmMaster.FirstOrDefault().FarmAddressstrStreetName
                    FarmAddress.Setup(CrossCuttingAPIService)

                    Scatter(divHiddenFieldsSection, farmMaster.FirstOrDefault(), 3)
                    Scatter(FarmDetails, farmMaster.FirstOrDefault(), 3)
                    Scatter(divReportSummary, farmMaster.FirstOrDefault(), 3)
                End If
            Else
                Dim farm = FarmAPIService.GetFarmDetailAsync(GetCurrentLanguage(), hdfFarmID.Value).Result

                If Not IsNothing(farm) Then
                    FarmAddress.LocationCountryID = farm.FirstOrDefault().FarmAddressidfsCountry
                    FarmAddress.LocationRegionID = farm.FirstOrDefault().FarmAddressidfsRegion
                    FarmAddress.LocationRayonID = farm.FirstOrDefault().FarmAddressidfsRayon
                    FarmAddress.LocationSettlementID = farm.FirstOrDefault().FarmAddressidfsSettlement
                    FarmAddress.LocationPostalCodeName = farm.FirstOrDefault().FarmAddressstrPostalCode
                    FarmAddress.ApartmentText = farm.FirstOrDefault().FarmAddressstrApartment
                    FarmAddress.BuildingText = farm.FirstOrDefault().FarmAddressstrBuilding
                    FarmAddress.HouseText = farm.FirstOrDefault().FarmAddressstrHouse
                    FarmAddress.StreetText = farm.FirstOrDefault().FarmAddressstrStreetName
                    FarmAddress.Setup(CrossCuttingAPIService)

                    Scatter(divHiddenFieldsSection, farm.FirstOrDefault(), 3)
                    Scatter(FarmDetails, farm.FirstOrDefault(), 3)
                    Scatter(divReportSummary, farm.FirstOrDefault(), 3)
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Search Person Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub InitializeSearchPerson()

        upSearchPerson.Update()
        ucSearchPerson.Setup(useHumanMasterIndicator:=True, selectMode:=SelectModes.Selection)
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_ON_MODAL_KEY, SHOW_SEARCH_PERSON_MODAL, True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    Protected Sub SearchPerson_ShowWarningModal(messageType As MessageType, isConfirm As Boolean) Handles ucSearchPerson.ShowWarningModal

        upWarningModal.Update()
        ShowWarningMessage(messageType:=messageType, isConfirm:=isConfirm)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="humanID"></param>
    ''' <param name="eidssPersonID"></param>
    ''' <param name="fullName"></param>
    ''' <param name="firstName"></param>
    ''' <param name="lastName"></param>
    Protected Sub SearchPerson_SelectPerson(humanID As Long, eidssPersonID As String, fullName As String, firstName As String, lastName As String) Handles ucSearchPerson.SelectPerson

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_ON_MODAL_KEY, HIDE_SEARCH_PERSON_MODAL, True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub SearchPerson_CreatePerson() Handles ucSearchPerson.CreatePerson

        InitializeAddUpdatePerson(runScript:=False)

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_ON_MODAL_KEY, HIDE_SEARCH_PERSON_SHOW_ADD_UPDATE_PERSON_MODALS, True)

    End Sub

#End Region

#Region "Add/Update Person Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="runScript"></param>
    Private Sub InitializeAddUpdatePerson(runScript As Boolean)

        upPerson.Update()

        ucAddUpdatePerson.Setup(initialPanelID:=0)

        If runScript = True Then
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_ON_MODAL_KEY, SHOW_ADD_UPDATE_PERSON_MODAL, True)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub AddUpdatePerson_Validate() Handles ucAddUpdatePerson.ValidatePage

        Validate("PersonInformation")
        Validate("PersonAddress")
        Validate("PersonEmploymentSchoolInformation")

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    ''' <param name="message"></param>
    Protected Sub AddUpdatePerson_ShowWarningModal(messageType As MessageType, isConfirm As Boolean, message As String) Handles ucAddUpdatePerson.ShowWarningModal

        upWarningModal.Update()
        ShowWarningMessage(messageType:=messageType, isConfirm:=isConfirm, message:=message)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="humanID"></param>
    ''' <param name="eidssPersonID"></param>
    ''' <param name="fullName"></param>
    ''' <param name="firstName"></param>
    ''' <param name="lastName"></param>
    ''' <param name="message"></param>
    Protected Sub AddUpdatePerson_CreatePerson(humanID As Long, eidssPersonID As String, fullName As String, firstName As String, lastName As String, message As String) Handles ucAddUpdatePerson.CreatePerson


    End Sub

#End Region

#Region "Farm Epidemiological Information Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillFarmEpidemiologicalInfo()

        Try
            Dim diseaseID As Long = 0
            Dim observationID As Long? = CType(Nothing, Long?)

            If ddlDiseaseID.SelectedValue.IsValueNullOrEmpty() = False Then
                diseaseID = ddlDiseaseID.SelectedValue
            End If

            If hdfFarmEpidemiologicalInfoObservationID.Value.IsValueNullOrEmpty() = False Then
                observationID = hdfFarmEpidemiologicalInfoObservationID.Value
            End If

            ucFarmEpidemiologicalInfo.Setup(observationID, diseaseID)

            upFarmEpidemiologicalInfo.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Species Clinical Investigation Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub SpeciesClinicalInvestigationSpeciesID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlSpeciesClinicalInvestigationSpeciesID.SelectedIndexChanged

        Try
            Dim farmHerdSpecies = TryCast(Session(SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))

            If farmHerdSpecies Is Nothing Then
                If hdfVeterinaryDiseaseReportID.Value = "-1" Then
                    FillFarmHerdSpecies(refresh:=True, isRootFarm:=True)
                Else
                    FillFarmHerdSpecies(refresh:=True, isRootFarm:=False)
                End If

                farmHerdSpecies = TryCast(Session(SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            End If

            If ddlSpeciesClinicalInvestigationSpeciesID.SelectedValue.IsValueNullOrEmpty() = False Then
                Dim species = farmHerdSpecies.Where(Function(x) x.SpeciesID = ddlSpeciesClinicalInvestigationSpeciesID.SelectedValue).FirstOrDefault()
                Dim diseaseID As Long = 0
                Dim observationID As Long? = CType(Nothing, Long?)

                If ddlDiseaseID.SelectedValue.IsValueNullOrEmpty() = False Then
                    diseaseID = ddlDiseaseID.SelectedValue
                End If

                If Not species.ObservationID Is Nothing Then
                    observationID = species.ObservationID
                End If

                ucSpeciesClinicalInvestigation.Setup(observationID, diseaseID)

                upSpeciesClinicalInvestigation.Update()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub ClearSpeciesInvestigation_Click(sender As Object, e As EventArgs) Handles btnClearSpeciesInvestigation.Click

        Try
            ResetForm(ucSpeciesClinicalInvestigation)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub CopySpeciesInvestigation_Click(sender As Object, e As EventArgs) Handles btnCopySpeciesInvestigation.Click

        Try
            Dim farmHerdSpecies = TryCast(Session(SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))

            If farmHerdSpecies Is Nothing Then
                If hdfVeterinaryDiseaseReportID.Value = "-1" Then
                    FillFarmHerdSpecies(refresh:=True, isRootFarm:=True)
                Else
                    FillFarmHerdSpecies(refresh:=True, isRootFarm:=False)
                End If

                farmHerdSpecies = TryCast(Session(SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            End If

            If ddlSpeciesClinicalInvestigationSpeciesID.SelectedValue.IsValueNullOrEmpty() = False Then
                Dim speciesClinicalInvestigation = farmHerdSpecies.Where(Function(x) x.SpeciesID = ddlSpeciesClinicalInvestigationSpeciesID.SelectedValue).FirstOrDefault()

                hdfCopySpeciesClinicalInvestigationObservationID.Value = speciesClinicalInvestigation.ObservationID
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub PasteSpeciesInvestigation_Click(sender As Object, e As EventArgs) Handles btnPasteSpeciesInvestigation.Click

        Try
            Dim farmHerdSpecies = TryCast(Session(SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))

            If farmHerdSpecies Is Nothing Then
                If hdfVeterinaryDiseaseReportID.Value = "-1" Then
                    FillFarmHerdSpecies(refresh:=True, isRootFarm:=True)
                Else
                    FillFarmHerdSpecies(refresh:=True, isRootFarm:=False)
                End If

                farmHerdSpecies = TryCast(Session(SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            End If

            If ddlSpeciesClinicalInvestigationSpeciesID.SelectedValue.IsValueNullOrEmpty() = False Then
                Dim species = farmHerdSpecies.Where(Function(x) x.SpeciesID = ddlSpeciesClinicalInvestigationSpeciesID.SelectedValue).FirstOrDefault()

                'Session(SPECIES_CLINICAL_INVESTIGATIONS_LIST) = Call FF Get Data Method, save data at this time or Observation ID????, or add new record to the session list and assign temporary obs id?????
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Farm Inventory Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refresh"></param>
    ''' <param name="isRootFarm"></param>
    Private Sub FillFarmHerdSpecies(ByVal refresh As Boolean, ByVal isRootFarm As Boolean)

        Try
            Dim farmHerdSpecies = CType(Session(HERD_SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            Dim identity As Integer = 0

            If refresh Then Session(HERD_SPECIES_LIST) = Nothing

            If IsNothing(Session(HERD_SPECIES_LIST)) Then
                If FarmAPIService Is Nothing Then
                    FarmAPIService = New FarmServiceClient()
                End If
                Dim parameters = New FarmHerdSpeciesGetListParameters()
                parameters.LanguageID = GetCurrentLanguage()

                If isRootFarm Then
                    parameters.FarmMasterID = hdfFarmMasterID.Value
                Else
                    parameters.FarmID = hdfFarmID.Value
                End If

                farmHerdSpecies = FarmAPIService.FarmHerdSpeciesGetListAsync(parameters).Result
                Session(HERD_SPECIES_LIST) = farmHerdSpecies
            Else
                farmHerdSpecies = CType(Session(HERD_SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            End If

            Session(HERDS_LIST) = farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd Or x.RecordType = HerdSpeciesConstants.Farm).ToList()
            Session(SPECIES_LIST) = farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList()

            gvHerds.DataSource = Nothing
            gvHerds.DataSource = farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd Or x.RecordType = HerdSpeciesConstants.Farm).ToList()
            gvHerds.DataBind()

            If farmHerdSpecies.Where(Function(x) (x.RecordType = HerdSpeciesConstants.Species Or x.RecordType = HerdSpeciesConstants.Herd)).Count > 0 Then
                If hdfVeterinaryDiseaseReportID.Value = "-1" Then
                    For Each record In farmHerdSpecies
                        record.RowAction = RecordConstants.Insert
                        If record.RecordType = RecordTypeConstants.Herd Then
                            If record.HerdID.ToString = String.Empty Then
                                hdfIdentity.Value += 1
                                identity = (hdfIdentity.Value * -1)
                                record.HerdID = identity
                            End If
                        ElseIf record.RecordType = RecordTypeConstants.Species Then
                            If record.SpeciesID.ToString = String.Empty Then
                                hdfIdentity.Value += 1
                                identity = (hdfIdentity.Value * -1)
                                record.SpeciesID = identity
                                record.HerdID = farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd And x.HerdMasterID = record.HerdMasterID).FirstOrDefault().HerdID
                            End If
                        End If
                    Next
                End If

                upHiddenFields.Update()
                hdfFarmTotalAnimalQuantity.Value = farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).Sum(Function(x) x.TotalAnimalQuantity)
                hdfFarmDeadAnimalQuantity.Value = farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).Sum(Function(x) x.DeadAnimalQuantity)
                hdfFarmSickAnimalQuantity.Value = farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).Sum(Function(x) x.SickAnimalQuantity)

                If farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList().Count > 1 Then
                    btnCopySpeciesInvestigation.Enabled = True
                End If

                FillDropDownList(ddlSpeciesClinicalInvestigationSpeciesID, farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList(), Nothing, "SpeciesID", HerdSpeciesConstants.SpeciesTypeName, blankRow:=True)
                FillDropDownList(ddlAnimalHerdID, farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).ToList(), Nothing, "HerdID", "EIDSSHerdID", blankRow:=True)
                FillDropDownList(ddlAnimalSpeciesID, farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList(), Nothing, "SpeciesID", HerdSpeciesConstants.SpeciesTypeName, blankRow:=True)
                FillDropDownList(ddlVaccinationSpeciesID, farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList(), Nothing, "SpeciesID", HerdSpeciesConstants.SpeciesTypeName, blankRow:=True)
                FillDropDownList(ddlSampleSpeciesID, farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList(), Nothing, "SpeciesID", HerdSpeciesConstants.SpeciesTypeName, blankRow:=True)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddHerd_Click(sender As Object, e As EventArgs) Handles btnAddHerd.Click

        Try
            Dim farmHerdSpecies = TryCast(Session(HERDS_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            Dim herdFlock = New VetFarmHerdSpeciesGetListModel()

            If farmHerdSpecies Is Nothing Then
                farmHerdSpecies = New List(Of VetFarmHerdSpeciesGetListModel)()
            End If

            hdfIdentity.Value += 1
            Dim identity As Integer = (hdfIdentity.Value * -1)

            herdFlock.RecordID = identity
            herdFlock.RecordType = RecordTypeConstants.Herd
            herdFlock.FarmID = hdfFarmMasterID.Value
            herdFlock.HerdMasterID = identity

            herdFlock.EIDSSHerdID = HerdSpeciesConstants.Herd & " " & farmHerdSpecies.Where(Function(x) x.RowAction = RecordConstants.Insert).Count.ToString

            herdFlock.TotalAnimalQuantity = 0
            herdFlock.DeadAnimalQuantity = 0
            herdFlock.SickAnimalQuantity = 0
            herdFlock.RowStatus = RecordConstants.ActiveRowStatus
            herdFlock.RowAction = RecordConstants.Insert

            farmHerdSpecies.Add(herdFlock)
            farmHerdSpecies.OrderBy(Function(x) x.EIDSSHerdID)
            Session(HERDS_LIST) = farmHerdSpecies

            FillDropDownList(ddlAnimalHerdID, farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).ToList(), Nothing, "HerdID", "EIDSSHerdID", blankRow:=True)
            upAnimalModal.Update()

            gvHerds.DataSource = Nothing
            gvHerds.DataSource = farmHerdSpecies
            gvHerds.DataBind()

            ToggleVisibility(SectionFarmFlockSpecies)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub RollUp()

        Dim herds As List(Of VetFarmHerdSpeciesGetListModel) = CType(Session(HERDS_LIST), List(Of VetFarmHerdSpeciesGetListModel))
        Dim speciesList As List(Of VetFarmHerdSpeciesGetListModel) = CType(Session(SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))

        If Not speciesList Is Nothing Then
            Dim herd As VetFarmHerdSpeciesGetListModel
            Dim species As VetFarmHerdSpeciesGetListModel

            Dim _herds As List(Of VetFarmHerdSpeciesGetListModel) = New List(Of VetFarmHerdSpeciesGetListModel)()
            Dim _herd As VetFarmHerdSpeciesGetListModel = New VetFarmHerdSpeciesGetListModel

            For Each herd In herds
                Dim intSick As Short = 0
                Dim intDead As Short = 0
                Dim intTotal As Short = 0

                If Not herd.RecordType = HerdSpeciesConstants.Farm Then
                    For Each species In speciesList.Where(Function(x) x.HerdMasterID = herd.HerdMasterID And x.RowStatus = 0).ToList()
                        If (Not species.SickAnimalQuantity Is Nothing) Then
                            intSick += species.SickAnimalQuantity
                        End If

                        If (Not species.DeadAnimalQuantity Is Nothing) Then
                            intDead += species.DeadAnimalQuantity
                        End If

                        If (Not species.TotalAnimalQuantity Is Nothing) Then
                            intTotal += species.TotalAnimalQuantity
                        End If
                    Next

                    herd.SickAnimalQuantity = intSick
                    herd.DeadAnimalQuantity = intDead
                    herd.TotalAnimalQuantity = intTotal
                End If

                _herds.Add(herd)
            Next

            _herds.Where(Function(x) x.RecordType = HerdSpeciesConstants.Farm).FirstOrDefault().TotalAnimalQuantity = _herds.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).Sum(Function(x) x.TotalAnimalQuantity)
            _herds.Where(Function(x) x.RecordType = HerdSpeciesConstants.Farm).FirstOrDefault().DeadAnimalQuantity = _herds.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).Sum(Function(x) x.DeadAnimalQuantity)
            _herds.Where(Function(x) x.RecordType = HerdSpeciesConstants.Farm).FirstOrDefault().SickAnimalQuantity = _herds.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).Sum(Function(x) x.SickAnimalQuantity)

            hdfFarmTotalAnimalQuantity.Value = _herds.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).Sum(Function(x) x.TotalAnimalQuantity)
            hdfFarmDeadAnimalQuantity.Value = _herds.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).Sum(Function(x) x.DeadAnimalQuantity)
            hdfFarmSickAnimalQuantity.Value = _herds.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).Sum(Function(x) x.SickAnimalQuantity)

            Session(HERDS_LIST) = _herds
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Herds_ItemCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvHerds.RowCommand

        Try
            Dim farmHerdSpecies = CType(Session(SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            Dim species = New VetFarmHerdSpeciesGetListModel()

            hdfIdentity.Value += 1
            Dim identity As Integer = (hdfIdentity.Value * -1)
            species.RecordID = identity
            species.RecordType = RecordTypeConstants.Species
            species.SpeciesID = identity
            species.SpeciesMasterID = identity
            species.FarmID = hdfFarmMasterID.Value
            species.HerdMasterID = CType(e.CommandArgument, Long)
            species.TotalAnimalQuantity = 0
            species.DeadAnimalQuantity = 0
            species.SickAnimalQuantity = 0
            species.RowStatus = RecordConstants.ActiveRowStatus
            species.RowAction = RecordConstants.Insert
            farmHerdSpecies.Add(species)

            ToggleVisibility(SectionFarmFlockSpecies)
            Session(SPECIES_LIST) = farmHerdSpecies
            gvHerds.DataSource = CType(Session(HERDS_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            gvHerds.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Species_OnDataBinding(sender As Object, e As GridViewRowEventArgs)

        Try
            If e.Row.RowType = DataControlRowType.Header Then
            Else
                If e.Row.RowType = DataControlRowType.DataRow Then
                    Dim herds = CType(Session(HERDS_LIST), List(Of VetFarmHerdSpeciesGetListModel))
                    Dim species = CType(Session(SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))

                    Dim herdSpecies As VetFarmHerdSpeciesGetListModel = TryCast(e.Row.DataItem, VetFarmHerdSpeciesGetListModel)

                    Dim ddlSpeciesType As DropDownList = CType(e.Row.FindControl("ddlSpeciesTypeID"), DropDownList)
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub SpeciesTypeID_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Herds_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvHerds.RowDataBound

        Try
            If e.Row.RowType = DataControlRowType.Header Then

            Else
                If e.Row.RowType = DataControlRowType.DataRow Then
                    Dim lblAddSpecies As Label = CType(e.Row.FindControl("lblAddSpecies"), Label)
                    Dim btnAddSpecies As LinkButton = CType(e.Row.FindControl("btnAddSpecies"), LinkButton)
                    Dim lblEIDSSHerdID As Label = CType(e.Row.FindControl("lblEIDSSHerdID"), Label)

                    If e.Row.RowIndex = 0 Then
                        btnAddSpecies.Visible = False
                    End If

                    If e.Row.DataItem.RecordType = HerdSpeciesConstants.Farm Then
                        lblEIDSSHerdID.Text = Resources.Labels.Lbl_Farm_Text & " " & e.Row.DataItem.EIDSSHerdID.ToString().Remove(0, 4)
                    ElseIf e.Row.DataItem.RecordType = HerdSpeciesConstants.Herd Then
                        lblEIDSSHerdID.Text = Resources.Labels.Lbl_Herd_Text & " " & e.Row.DataItem.EIDSSHerdID.ToString().Remove(0, 5)
                    End If

                    Dim speciesList As List(Of VetFarmHerdSpeciesGetListModel) = CType(Session(SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))

                    If Not speciesList Is Nothing Then
                        Dim gvSpecies As GridView = CType(e.Row.FindControl("gvSpecies"), GridView)

                        gvSpecies.DataSource = speciesList.Where(Function(x) x.HerdMasterID = e.Row.DataItem.HerdMasterID).ToList()
                        gvSpecies.DataBind()
                    End If
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Herds_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvHerds.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    DeleteFarmHerdSpecies(CType(e.CommandArgument, Long))
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                Case GridViewCommandConstants.UpdateCommand
                    e.Handled = True
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordID"></param>
    Private Sub DeleteFarmHerdSpecies(recordID As Long)

        upFarmHerdSpecies.Update()

        Dim farmHerdSpecies = CType(Session(HERD_SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))
        Dim herdSpecies = farmHerdSpecies.Where(Function(x) x.RecordID = recordID).FirstOrDefault

        If herdSpecies.RowAction = RecordConstants.Insert Then
            farmHerdSpecies.Remove(herdSpecies)
        Else
            herdSpecies.RowAction = RecordConstants.Delete
            herdSpecies.RowStatus = RecordConstants.InactiveRowStatus
        End If

        Session(HERD_SPECIES_LIST) = farmHerdSpecies
        Session(HERDS_LIST) = farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd Or x.RecordType = HerdSpeciesConstants.Farm).ToList()
        Session(SPECIES_LIST) = farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList()

        RollUp()

        gvHerds.DataSource = farmHerdSpecies.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus).OrderBy(Function(x) x.RecordID)
        gvHerds.DataBind()

        upHiddenFields.Update()
        hdfFarmTotalAnimalQuantity.Value = farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).Sum(Function(x) x.TotalAnimalQuantity)
        hdfFarmDeadAnimalQuantity.Value = farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).Sum(Function(x) x.DeadAnimalQuantity)
        hdfFarmSickAnimalQuantity.Value = farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).Sum(Function(x) x.SickAnimalQuantity)

        If farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList().Count > 1 Then
            btnCopySpeciesInvestigation.Enabled = True
        End If

        FillDropDownList(ddlSpeciesClinicalInvestigationSpeciesID, farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList(), Nothing, "SpeciesID", HerdSpeciesConstants.SpeciesTypeName, blankRow:=True)
        FillDropDownList(ddlAnimalHerdID, farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).ToList(), Nothing, "HerdID", "EIDSSHerdID", blankRow:=True)
        FillDropDownList(ddlAnimalSpeciesID, farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList(), Nothing, "SpeciesID", HerdSpeciesConstants.SpeciesTypeName, blankRow:=True)
        FillDropDownList(ddlVaccinationSpeciesID, farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList(), Nothing, "SpeciesID", HerdSpeciesConstants.SpeciesTypeName, blankRow:=True)
        FillDropDownList(ddlSampleSpeciesID, farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList(), Nothing, "SpeciesID", HerdSpeciesConstants.SpeciesTypeName, blankRow:=True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Species_RowDataBound(sender As Object, e As GridViewRowEventArgs)

        Try
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim ddlSpeciesTypeID As DropDownList = CType(e.Row.FindControl("ddlSpeciesTypeID"), DropDownList)
                BaseReferenceLookUp(ddlSpeciesTypeID, BaseReferenceConstants.SpeciesList, HACodeList.LivestockHACode, True)
                ddlSpeciesTypeID.SelectedValue = e.Row.DataItem.SpeciesTypeID

                Dim upStartOfSignsDate As UpdatePanel = CType(e.Row.FindControl("upStartOfSignsDate"), UpdatePanel)
                Dim cmvFutureStartOfSignsDate As CompareValidator = CType(e.Row.FindControl("cmvFutureStartOfSignsDate"), CompareValidator)
                Dim txtStartOfSignsDate As CalendarInput = CType(e.Row.FindControl("txtStartOfSignsDate"), CalendarInput)

                cmvFutureStartOfSignsDate.Type = ValidationDataType.Date
                cmvFutureStartOfSignsDate.ValueToCompare = Date.Now.ToShortDateString()

                ScriptManager.RegisterClientScriptBlock(Me, Page.GetType(), "calendarScript" + txtStartOfSignsDate.ClientID, txtStartOfSignsDate.WritejQueryCalendar(), True)
                txtStartOfSignsDate.Text = String.Empty

                upStartOfSignsDate.Update()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub SpeciesControlEventHandler(sender As Object, e As EventArgs)

        Try
            UpdateHerdSpecies()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub UpdateHerdSpecies()

        Try
            Dim farmHerdSpecies = CType(Session(SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            Dim record As VetFarmHerdSpeciesGetListModel
            Dim index As Integer = 0

            For Each row As GridViewRow In gvHerds.Rows
                Dim gvSpecies As GridView = CType(row.FindControl("gvSpecies"), GridView)

                If Not gvSpecies Is Nothing Then
                    For Each speciesRow As GridViewRow In gvSpecies.Rows
                        Dim hdfSpeciesMasterID As HiddenField = CType(speciesRow.FindControl("hdfSpeciesMasterID"), HiddenField)
                        Dim ddlSpeciesTypeID As DropDownList = CType(speciesRow.FindControl("ddlSpeciesTypeID"), WebControls.DropDownList)
                        Dim txtDeadAnimalQuantity As TextBox = CType(speciesRow.FindControl("txtDeadAnimalQuantity"), TextBox)
                        Dim txtSickAnimalQuantity As TextBox = CType(speciesRow.FindControl("txtSickAnimalQuantity"), TextBox)
                        Dim txtTotalAnimalQuantity As TextBox = CType(speciesRow.FindControl("txtTotalAnimalQuantity"), TextBox)
                        Dim txtStartOfSignsDate As CalendarInput = CType(speciesRow.FindControl("txtStartOfSignsDate"), CalendarInput)

                        record = New VetFarmHerdSpeciesGetListModel()
                        record = farmHerdSpecies.Where(Function(x) x.SpeciesMasterID = hdfSpeciesMasterID.Value).FirstOrDefault()

                        If hdfRowAction.Value = RecordConstants.Read Then
                            record.RowAction = RecordConstants.Update
                        End If

                        record.SpeciesTypeID = ddlSpeciesTypeID.SelectedValue
                        record.SpeciesTypeName = ddlSpeciesTypeID.SelectedItem.Text
                        record.TotalAnimalQuantity = If(String.IsNullOrEmpty(txtTotalAnimalQuantity.Text), 0, Short.Parse(txtTotalAnimalQuantity.Text))
                        record.DeadAnimalQuantity = If(String.IsNullOrEmpty(txtDeadAnimalQuantity.Text), 0, Short.Parse(txtDeadAnimalQuantity.Text))
                        record.SickAnimalQuantity = If(String.IsNullOrEmpty(txtSickAnimalQuantity.Text), 0, Short.Parse(txtSickAnimalQuantity.Text))
                        record.AverageAge = Nothing
                        record.StartOfSignsDate = If(txtStartOfSignsDate.Text = String.Empty, Nothing, Convert.ToDateTime(txtStartOfSignsDate.Text))

                        index = farmHerdSpecies.IndexOf(record)
                        farmHerdSpecies(index) = record

                        Dim vaccinations = CType(Session(VACCINATIONS_LIST), List(Of VetVaccinationGetListModel))
                        For Each vaccination In vaccinations
                            If vaccination.SpeciesID.ToString = record.SpeciesID Then
                                vaccination.SpeciesTypeName = ddlSpeciesTypeID.SelectedItem.Text
                            End If
                        Next
                        gvVaccinations.DataSource = Nothing
                        Session(VACCINATIONS_LIST) = vaccinations
                        gvVaccinations.DataSource = vaccinations
                        gvVaccinations.DataBind()

                        Dim samples = CType(Session(SAMPLES_LIST), List(Of GblSampleGetListModel))
                        For Each sample In samples
                            If sample.SpeciesID.ToString = record.SpeciesID Then
                                sample.SpeciesTypeName = ddlSpeciesTypeID.SelectedItem.Text
                            End If
                        Next
                        gvSamples.DataSource = Nothing
                        Session(SAMPLES_LIST) = samples
                        gvSamples.DataSource = samples
                        gvSamples.DataBind()

                        Dim pensideTests = CType(Session(PENSIDE_TESTS_LIST), List(Of VetPensideTestGetListModel))
                        For Each pensideTest In pensideTests
                            If pensideTest.SpeciesID.ToString = record.SpeciesID Then
                                pensideTest.SpeciesTypeName = ddlSpeciesTypeID.SelectedItem.Text
                            End If
                        Next
                        gvPensideTests.DataSource = Nothing
                        Session(PENSIDE_TESTS_LIST) = pensideTests
                        gvPensideTests.DataSource = pensideTests
                        gvPensideTests.DataBind()

                        Dim tests = CType(Session(TESTS_LIST), List(Of GblTestGetListModel))
                        For Each test In tests
                            If test.SpeciesID.ToString = record.SpeciesID Then
                                test.SpeciesTypeName = ddlSpeciesTypeID.SelectedItem.Text
                            End If
                        Next
                        gvLabTests.DataSource = Nothing
                        Session(TESTS_LIST) = tests
                        gvLabTests.DataSource = tests
                        gvLabTests.DataBind()

                        Dim testInterpretations = CType(Session(TEST_INTERPRETATIONS_LIST), List(Of GblTestInterpretationGetListModel))
                        For Each testInterpretation In testInterpretations
                            If testInterpretation.SpeciesID.ToString = record.SpeciesID Then
                                testInterpretation.SpeciesTypeName = ddlSpeciesTypeID.SelectedItem.Text
                            End If
                        Next
                        gvTestInterpretations.DataSource = Nothing
                        Session(TEST_INTERPRETATIONS_LIST) = testInterpretations
                        gvTestInterpretations.DataSource = testInterpretations
                        gvTestInterpretations.DataBind()
                    Next
                End If
            Next

            Session(SPECIES_LIST) = farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList()

            RollUp()

            gvHerds.DataSource = Session(HERDS_LIST)
            gvHerds.DataBind()

            FillDropDownList(ddlAnimalHerdID, farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).ToList(), Nothing, "HerdID", "EIDSSHerdID", blankRow:=True)
            FillDropDownList(ddlAnimalSpeciesID, farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList(), Nothing, "SpeciesID", HerdSpeciesConstants.SpeciesTypeName, blankRow:=True)
            FillDropDownList(ddlSpeciesClinicalInvestigationSpeciesID, farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList(), Nothing, "SpeciesID", HerdSpeciesConstants.SpeciesTypeName, blankRow:=True)
            FillDropDownList(ddlVaccinationSpeciesID, farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList(), Nothing, "SpeciesID", HerdSpeciesConstants.SpeciesTypeName, blankRow:=True)
            FillDropDownList(ddlSampleSpeciesID, farmHerdSpecies.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList(), Nothing, "SpeciesID", HerdSpeciesConstants.SpeciesTypeName, blankRow:=True)

            upAnimalModal.Update()
            'ToggleVisibility(SectionFarmFlockSpecies)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Vaccination Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refresh"></param>
    Private Sub FillVaccinations(ByVal refresh As Boolean)

        Try
            Dim vaccinations = New List(Of VetVaccinationGetListModel)()

            If refresh Then Session(VACCINATIONS_LIST) = Nothing

            If IsNothing(Session(VACCINATIONS_LIST)) Then
                If VeterinaryAPIService Is Nothing Then
                    VeterinaryAPIService = New VeterinaryServiceClient()
                End If
                vaccinations = VeterinaryAPIService.GetVaccinationListAsync(GetCurrentLanguage(), hdfVeterinaryDiseaseReportID.Value, Nothing).Result
                Session(VACCINATIONS_LIST) = vaccinations
            Else
                vaccinations = CType(Session(VACCINATIONS_LIST), List(Of VetVaccinationGetListModel))
            End If

            gvVaccinations.DataSource = Nothing
            gvVaccinations.DataSource = vaccinations
            gvVaccinations.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddVaccination_Click(sender As Object, e As EventArgs) Handles btnAddVaccination.Click

        Try
            ResetVaccination()

            hdfRowAction.Value = RecordConstants.Insert

            upVaccinationModal.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divVaccinationModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try


    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ResetVaccination()

        ddlVaccinationDiseaseID.SelectedIndex = -1
        ddlVaccinationSpeciesID.SelectedIndex = -1
        ddlVaccinationVaccinationRouteTypeID.SelectedIndex = -1
        ddlVaccinationVaccinationTypeID.SelectedIndex = -1
        If ddlDiseaseID.SelectedValue.IsValueNullOrEmpty() = True Then
            txtVaccinationVaccinationDate.Text = String.Empty
        Else
            txtVaccinationVaccinationDate.Text = Date.Now.ToShortDateString()
        End If
        txtVaccinationVaccinationDate.MaxDate = Date.Today.ToShortDateString()
        txtVaccinationNumberVaccinated.Text = String.Empty
        txtVaccinationLotNumber.Text = String.Empty
        txtVaccinationManufacturer.Text = String.Empty
        txtVaccinationComments.Text = String.Empty
        hdfRowID.Value = "0"
        hdfRowAction.Value = String.Empty

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub VaccinationSave_Click(sender As Object, e As EventArgs) Handles btnVaccinationSave.Click

        Dim vaccinations = TryCast(Session(VACCINATIONS_LIST), List(Of VetVaccinationGetListModel))
        Dim vaccination = New VetVaccinationGetListModel()

        If Not hdfRowID.Value = "0" Then
            vaccination = vaccinations.Where(Function(x) x.VaccinationID = hdfRowID.Value).First
        End If

        vaccination.VaccinationTypeID = If(ddlVaccinationVaccinationTypeID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlVaccinationVaccinationTypeID.SelectedValue, Long))
        vaccination.VaccinationTypeName = If(ddlVaccinationVaccinationTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlVaccinationVaccinationTypeID.SelectedItem.Text)
        vaccination.VaccinationRouteTypeID = If(ddlVaccinationVaccinationRouteTypeID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlVaccinationVaccinationRouteTypeID.SelectedValue, Long))
        vaccination.VaccinationRouteTypeName = If(ddlVaccinationVaccinationRouteTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlVaccinationVaccinationRouteTypeID.SelectedItem.Text)
        vaccination.SpeciesID = If(ddlVaccinationSpeciesID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlVaccinationSpeciesID.SelectedValue, Long))
        vaccination.SpeciesTypeName = If(ddlVaccinationSpeciesID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlVaccinationSpeciesID.SelectedItem.Text)
        vaccination.DiseaseID = If(ddlVaccinationDiseaseID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlVaccinationDiseaseID.SelectedValue, Long))
        vaccination.DiseaseName = If(ddlVaccinationDiseaseID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlVaccinationDiseaseID.SelectedItem.Text)
        vaccination.VaccinationDate = If(txtVaccinationVaccinationDate.Text.IsValueNullOrEmpty(), CType(Nothing, Date?), Convert.ToDateTime(txtVaccinationVaccinationDate.Text))
        vaccination.NumberVaccinated = If(txtVaccinationNumberVaccinated.Text.IsValueNullOrEmpty(), CType(Nothing, Integer?), CType(txtVaccinationNumberVaccinated.Text, Integer))
        vaccination.LotNumber = If(txtVaccinationLotNumber.Text.IsValueNullOrEmpty(), Nothing, txtVaccinationLotNumber.Text)
        vaccination.Manufacturer = If(txtVaccinationManufacturer.Text.IsValueNullOrEmpty(), Nothing, txtVaccinationManufacturer.Text)
        vaccination.Comments = If(txtVaccinationComments.Text.IsValueNullOrEmpty(), Nothing, txtVaccinationComments.Text)

        If vaccination.VaccinationID > 0 Then
            vaccination.RowAction = RecordConstants.Update
        Else
            hdfIdentity.Value += 1
            Dim identity As Integer = (hdfIdentity.Value * -1)
            vaccination.VaccinationID = identity
            vaccination.RowStatus = RecordConstants.ActiveRowStatus
            vaccination.RowAction = RecordConstants.Insert
            vaccinations.Add(vaccination)
        End If

        gvVaccinations.DataSource = Nothing
        Session(VACCINATIONS_LIST) = vaccinations
        gvVaccinations.DataSource = vaccinations.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus).OrderBy(Function(x) x.VaccinationTypeName)
        gvVaccinations.DataBind()

        ResetVaccination()

        ToggleVisibility(SectionVaccinations)

        upVaccinations.Update()

        ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divVaccinationModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub VaccinationCancel_Click(sender As Object, e As EventArgs) Handles btnVaccinationCancel.Click

        Try
            ShowWarningMessage(messageType:=MessageType.CancelVaccinationConfirm, isConfirm:=True, message:=Nothing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Vaccinations_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvVaccinations.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    upWarningModal.Update()
                    upHiddenFields.Update()
                    e.Handled = True
                    ShowWarningMessage(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Resources.WarningMessages.Confirm_Delete_Message)
                    hdfRowAction.Value = RecordConstants.Delete
                    hdfRowID.Value = e.CommandArgument
                    hdfRecordType.Value = RecordTypeConstants.Vaccinations
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditVaccination(e.CommandArgument)
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="vaccinationID"></param>
    Private Sub EditVaccination(vaccinationID As Long)

        Dim vaccinations = CType(Session(VACCINATIONS_LIST), List(Of VetVaccinationGetListModel))
        Dim vaccination = vaccinations.Where(Function(x) x.VaccinationID = vaccinationID).FirstOrDefault

        If Not vaccination Is Nothing Then
            ddlVaccinationDiseaseID.SelectedValue = If(vaccination.DiseaseID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), vaccination.DiseaseID)
            ddlVaccinationSpeciesID.SelectedValue = If(vaccination.SpeciesID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), vaccination.SpeciesID)
            ddlVaccinationVaccinationRouteTypeID.SelectedValue = If(vaccination.VaccinationRouteTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), vaccination.VaccinationRouteTypeID)
            ddlVaccinationVaccinationTypeID.SelectedValue = If(vaccination.VaccinationTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), vaccination.VaccinationTypeID)
            txtVaccinationVaccinationDate.Text = If(vaccination.VaccinationDate.ToString.IsValueNullOrEmpty(), String.Empty, vaccination.VaccinationDate)
            txtVaccinationNumberVaccinated.Text = If(vaccination.NumberVaccinated Is Nothing, String.Empty, vaccination.NumberVaccinated)
            txtVaccinationLotNumber.Text = If(vaccination.LotNumber, String.Empty)
            txtVaccinationManufacturer.Text = If(vaccination.Manufacturer, String.Empty)
            txtVaccinationComments.Text = If(vaccination.Comments, String.Empty)
            hdfRowID.Value = vaccination.VaccinationID
            hdfRowAction.Value = vaccination.RowAction.ToString

            ToggleVisibility(SectionVaccination)

            upHiddenFields.Update()
            upVaccinationModal.Update()

            ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divVaccinationModal"), True)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="vaccinationID"></param>
    Private Sub DeleteVaccination(vaccinationID As Long)

        Dim vaccinations = CType(Session(VACCINATIONS_LIST), List(Of VetVaccinationGetListModel))
        Dim vaccination = vaccinations.Where(Function(x) x.VaccinationID = vaccinationID).FirstOrDefault

        If vaccination.RowAction = RecordConstants.Insert Then
            vaccinations.Remove(vaccination)
        Else
            vaccination.RowAction = RecordConstants.Delete
            vaccination.RowStatus = RecordConstants.InactiveRowStatus
        End If

        Session(VACCINATIONS_LIST) = vaccinations
        gvVaccinations.DataSource = vaccinations.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus).OrderBy(Function(x) x.VaccinationTypeName)
        gvVaccinations.DataBind()

    End Sub

#End Region

#Region "Control Measures"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillControlMeasures()

        Try
            Dim diseaseID As Long = 0
            Dim observationID As Long? = CType(Nothing, Long?)

            If ddlDiseaseID.SelectedValue.IsValueNullOrEmpty() = False Then
                diseaseID = ddlDiseaseID.SelectedValue
            End If

            If hdfControlMeasuresObservationID.Value.IsValueNullOrEmpty() = False Then
                observationID = hdfControlMeasuresObservationID.Value
            End If

            ucControlMeasures.Setup(observationID, diseaseID)

            upControlMeasures.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Animal Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refresh"></param>
    Private Sub FillAnimals(ByVal refresh As Boolean)

        Try
            Dim animals = New List(Of VetAnimalGetListModel)()

            If refresh Then Session(ANIMALS_LIST) = Nothing

            If IsNothing(Session(ANIMALS_LIST)) Then
                If VeterinaryAPIService Is Nothing Then
                    VeterinaryAPIService = New VeterinaryServiceClient()
                End If
                animals = VeterinaryAPIService.GetAnimalListAsync(GetCurrentLanguage(), hdfVeterinaryDiseaseReportID.Value, Nothing, Nothing, Nothing, Nothing).Result
                Session(ANIMALS_LIST) = animals
            Else
                animals = CType(Session(ANIMALS_LIST), List(Of VetAnimalGetListModel))
            End If

            gvAnimals.DataSource = Nothing
            gvAnimals.DataSource = animals
            gvAnimals.DataBind()

            FillDropDownList(ddlSampleAnimalID, animals, Nothing, "AnimalID", "EIDSSAnimalID", Nothing, blankRow:=True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddAnimal_Click(sender As Object, e As EventArgs) Handles btnAddAnimal.Click

        Try
            ResetAnimal()

            hdfRowAction.Value = RecordConstants.Insert

            Dim diseaseID As Long = 0
            Dim observationID As Long? = CType(Nothing, Long?)

            If ddlDiseaseID.SelectedValue.IsValueNullOrEmpty() = False Then
                diseaseID = ddlDiseaseID.SelectedValue
            End If

            ucClinicalSigns.Setup(observationID, diseaseID)

            upHiddenFields.Update()
            upAnimalModal.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAnimalModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ResetAnimal()

        ddlAnimalHerdID.SelectedIndex = -1
        ddlAnimalSpeciesID.SelectedIndex = -1
        ddlAnimalAgeTypeID.SelectedIndex = -1
        ddlAnimalConditionTypeID.SelectedIndex = -1
        ddlAnimalGenderTypeID.SelectedIndex = -1
        txtAnimalName.Text = ""
        hdfRowID.Value = "0"
        hdfRowAction.Value = ""

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AnimalHerd_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlAnimalHerdID.SelectedIndexChanged

        Try
            Dim farmHerdSpecies = CType(Session(SPECIES_LIST), List(Of VetFarmHerdSpeciesGetListModel))

            ddlAnimalSpeciesID.Items.Clear()
            Dim li As ListItem = New ListItem With {
            .Value = "",
            .Text = "",
            .Selected = False
        }
            ddlAnimalSpeciesID.Items.Add(li)

            If ddlAnimalHerdID.SelectedValue Is Nothing Then
                ddlAnimalSpeciesID.Enabled = False
            ElseIf Not ddlAnimalHerdID.SelectedValue.IsValueNullOrEmpty() Then
                For Each record In farmHerdSpecies
                    If record.RecordType = RecordTypeConstants.Species Then
                        If record.HerdID = ddlAnimalHerdID.SelectedValue Then
                            li = New ListItem With {
                            .Value = record.SpeciesID,
                            .Text = record.SpeciesTypeName,
                            .Selected = False
                        }
                            ddlAnimalSpeciesID.Items.Add(li)
                        End If
                        ddlAnimalSpeciesID.Enabled = True
                    End If
                Next
            Else
                ddlAnimalSpeciesID.Enabled = False
            End If

            upAnimalModal.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAnimalModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AnimalSave_Click(sender As Object, e As EventArgs) Handles btnAnimalSave.Click

        Try
            Dim animals = TryCast(Session(ANIMALS_LIST), List(Of VetAnimalGetListModel))
            Dim animal = New VetAnimalGetListModel()

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                animal = animals.Where(Function(x) x.AnimalID And hdfRowID.Value).First
            End If

            animal.AnimalAgeTypeID = If(ddlAnimalAgeTypeID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlAnimalAgeTypeID.SelectedValue, Long))
            animal.AnimalAgeTypeName = If(ddlAnimalAgeTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlAnimalAgeTypeID.SelectedItem.Text)
            animal.AnimalConditionTypeID = If(ddlAnimalConditionTypeID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlAnimalConditionTypeID.SelectedValue, Long))
            animal.AnimalConditionTypeName = If(ddlAnimalConditionTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlAnimalConditionTypeID.SelectedItem.Text)
            animal.AnimalGenderTypeID = If(ddlAnimalGenderTypeID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlAnimalGenderTypeID.SelectedValue, Long))
            animal.AnimalGenderTypeName = If(ddlAnimalGenderTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlAnimalGenderTypeID.SelectedItem.Text)
            animal.SpeciesID = If(ddlAnimalSpeciesID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlAnimalSpeciesID.SelectedValue, Long))
            animal.SpeciesTypeName = If(ddlAnimalSpeciesID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlAnimalSpeciesID.SelectedItem.Text)
            animal.HerdID = If(ddlAnimalHerdID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlAnimalHerdID.SelectedValue, Long))
            animal.EIDSSHerdID = If(ddlAnimalHerdID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlAnimalHerdID.SelectedItem.Text)
            animal.AnimalName = If(txtAnimalName.Text.IsValueNullOrEmpty(), Nothing, txtAnimalName.Text)

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                If animal.AnimalID > 0 Then
                    animal.RowAction = RecordConstants.Update
                End If

                Dim samples = CType(Session(SAMPLES_LIST), List(Of GblSampleGetListModel))
                For Each sample In samples
                    If sample.AnimalID.ToString = animal.AnimalID Then
                        sample.EIDSSAnimalID = animal.EIDSSAnimalID
                    End If
                Next
                gvSamples.DataSource = Nothing
                Session(SAMPLES_LIST) = samples
                gvSamples.DataSource = samples
                gvSamples.DataBind()

                Dim pensideTests = CType(Session(PENSIDE_TESTS_LIST), List(Of VetPensideTestGetListModel))
                For Each pensideTest In pensideTests
                    If pensideTest.AnimalID.ToString = animal.AnimalID Then
                        pensideTest.EIDSSAnimalID = animal.EIDSSAnimalID
                    End If
                Next
                gvPensideTests.DataSource = Nothing
                Session(PENSIDE_TESTS_LIST) = pensideTests
                gvPensideTests.DataSource = pensideTests
                gvPensideTests.DataBind()

                Dim labTests = CType(Session(TESTS_LIST), List(Of GblTestGetListModel))
                For Each labTest In labTests
                    If labTest.AnimalID.ToString = animal.AnimalID Then
                        labTest.EIDSSAnimalID = animal.EIDSSAnimalID
                    End If
                Next
                gvLabTests.DataSource = Nothing
                Session(TESTS_LIST) = labTests
                gvLabTests.DataSource = labTests
                gvLabTests.DataBind()

                Dim testInterpretations = CType(Session(TEST_INTERPRETATIONS_LIST), List(Of GblTestInterpretationGetListModel))
                For Each testInterpretation In testInterpretations
                    If testInterpretation.AnimalID.ToString = animal.AnimalID Then
                        testInterpretation.EIDSSAnimalID = animal.EIDSSAnimalID
                    End If
                Next
                gvTestInterpretations.DataSource = Nothing
                Session(TEST_INTERPRETATIONS_LIST) = testInterpretations
                gvTestInterpretations.DataSource = testInterpretations
                gvTestInterpretations.DataBind()

                upSamples.Update()
                upPensideTests.Update()
                upTestsAndTestInterpretations.Update()
            Else
                hdfIdentity.Value += 1
                Dim identity As Integer = (hdfIdentity.Value * -1)
                animal.AnimalID = identity
                animal.EIDSSAnimalID = Resources.Labels.Lbl_Animal_Text & " " & animals.Count.ToString()
                animal.RowStatus = RecordConstants.ActiveRowStatus
                animal.RowAction = RecordConstants.Insert
                animals.Add(animal)
            End If

            Session(ANIMALS_LIST) = animals
            gvAnimals.DataSource = Nothing
            gvAnimals.DataSource = animals.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus).OrderBy(Function(x) x.AnimalID)
            gvAnimals.DataBind()

            FillDropDownList(ddlSampleAnimalID, animals, Nothing, "AnimalID", "EIDSSAnimalID", Nothing, blankRow:=True)

            ResetAnimal()

            ToggleVisibility(SectionAnimals)

            upAnimals.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divAnimalModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Animals_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvAnimals.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    upWarningModal.Update()
                    upHiddenFields.Update()
                    e.Handled = True
                    ShowWarningMessage(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Resources.WarningMessages.Confirm_Delete_Message)
                    hdfRowAction.Value = RecordConstants.Delete
                    hdfRowID.Value = e.CommandArgument
                    hdfRecordType.Value = RecordTypeConstants.Animals
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditAnimal(e.CommandArgument)
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="animalID"></param>
    Private Sub EditAnimal(animalID As Long)

        Dim animals = CType(Session(ANIMALS_LIST), List(Of VetAnimalGetListModel))
        Dim animal = animals.Where(Function(x) x.AnimalID = animalID).FirstOrDefault

        If Not animal Is Nothing Then
            ddlAnimalHerdID.SelectedValue = If(animal.HerdID.ToString.IsValueNullOrEmpty(), String.Empty, animal.HerdID)
            ddlAnimalSpeciesID.SelectedValue = If(animal.SpeciesID.ToString.IsValueNullOrEmpty(), String.Empty, animal.SpeciesID)
            ddlAnimalAgeTypeID.SelectedValue = If(animal.AnimalAgeTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), animal.AnimalAgeTypeID)
            ddlAnimalConditionTypeID.SelectedValue = If(animal.AnimalConditionTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), animal.AnimalConditionTypeID)
            ddlAnimalGenderTypeID.SelectedValue = If(animal.AnimalGenderTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), animal.AnimalGenderTypeID)
            txtAnimalName.Text = If(animal.AnimalName, String.Empty)
            hdfRowID.Value = animal.AnimalID
            hdfRowAction.Value = animal.RowAction.ToString

            Dim diseaseID As Long = 0
            Dim observationID As Long? = CType(Nothing, Long?)

            If ddlDiseaseID.SelectedValue.IsValueNullOrEmpty() = False Then
                diseaseID = ddlDiseaseID.SelectedValue
            End If

            If Not animal.ObservationID Is Nothing Then
                observationID = animal.ObservationID
            End If

            ucClinicalSigns.Setup(observationID, diseaseID)

            ToggleVisibility(SectionAnimal)

            upHiddenFields.Update()
            upAnimalModal.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAnimalModal"), True)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="animalID"></param>
    Private Sub DeleteAnimal(animalID As Long)

        upAnimals.Update()

        Dim animals = CType(Session(ANIMALS_LIST), List(Of VetAnimalGetListModel))
        Dim animal = animals.Where(Function(x) x.AnimalID = animalID).FirstOrDefault

        If animal.RowAction = RecordConstants.Insert Then
            animals.Remove(animal)
        Else
            animal.RowAction = RecordConstants.Delete
            animal.RowStatus = RecordConstants.InactiveRowStatus
        End If

        Session(ANIMALS_LIST) = animals
        gvAnimals.DataSource = animals.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus).OrderBy(Function(x) x.AnimalID)
        gvAnimals.DataBind()

        FillDropDownList(ddlSampleAnimalID, animals, Nothing, AnimalConstants.AnimalID, AnimalConstants.AnimalCode, blankRow:=True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub ClinicalSignsYes_CheckedChanged(sender As Object, e As EventArgs) Handles radClinicalSignsYes.CheckedChanged

        Try
            If (radClinicalSignsYes.Checked) Then
                ucClinicalSigns.Visible = True
            Else
                ucClinicalSigns.Visible = False
            End If

            upAnimalModal.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAnimalModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub ClinicalSignsNo_CheckedChanged(sender As Object, e As EventArgs) Handles rdbLabTestConductedNo.CheckedChanged

        Try
            If (radClinicalSignsYes.Checked) Then
                ucClinicalSigns.Visible = False
            End If

            upAnimalModal.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAnimalModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub ClinicalSignsUnknown_CheckedChanged(sender As Object, e As EventArgs) Handles rdbLabTestConductedUnknown.CheckedChanged

        Try
            If (rdbLabTestConductedUnknown.Checked) Then
                ucClinicalSigns.Visible = False
            End If

            upAnimalModal.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAnimalModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Sample Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refresh"></param>
    Private Sub FillSamples(ByVal refresh As Boolean)

        Try
            Dim samples = New List(Of GblSampleGetListModel)()

            If refresh Then Session(SAMPLES_LIST) = Nothing

            If IsNothing(Session(SAMPLES_LIST)) Then
                If CrossCuttingAPIService Is Nothing Then
                    CrossCuttingAPIService = New CrossCuttingServiceClient()
                End If
                samples = CrossCuttingAPIService.GetSampleListAsync(GetCurrentLanguage(), Nothing, hdfVeterinaryDiseaseReportID.Value, Nothing, Nothing, Nothing).Result
                Session(SAMPLES_LIST) = samples
            Else
                samples = CType(Session(SAMPLES_LIST), List(Of GblSampleGetListModel))
            End If

            gvSamples.DataSource = Nothing
            gvSamples.DataSource = samples
            gvSamples.DataBind()

            If samples.Count > 0 Then
                FillDropDownList(ddlPensideTestSampleID, samples, Nothing, "SampleID", "EIDSSLocalOrFieldSampleID", String.Empty, Nothing, True)
                FillDropDownList(ddlLabTestSampleID, samples, Nothing, "SampleID", "EIDSSLocalOrFieldSampleID", String.Empty, Nothing, True)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddSample_Click(sender As Object, e As EventArgs) Handles btnAddSample.Click

        Try
            ResetSample()

            hdfRowAction.Value = RecordConstants.Insert

            PopulateSampleDefaults()

            ToggleVisibility(SectionSample)

            upSampleModal.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSampleModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try


    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ResetSample()

        ddlSampleAnimalID.SelectedIndex = -1
        ddlSampleCollectedByPersonID.SelectedIndex = -1
        ddlSampleSampleTypeID.SelectedIndex = -1
        ddlSampleSpeciesID.SelectedIndex = -1
        txtSampleAccessionDate.Text = String.Empty
        txtSampleCollectionDate.Text = String.Empty
        txtSampleAccessionComment.Text = String.Empty
        txtSampleEIDSSLocalOrFieldSampleID.Text = String.Empty
        txtSampleComments.Text = String.Empty
        hdfRowID.Value = "0"
        hdfRowAction.Value = String.Empty

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub PopulateSampleDefaults()

        Dim samples = CType(Session(SAMPLES_LIST), List(Of GblSampleGetListModel))

        If samples.Count > 0 Then
            ddlSampleCollectedByOrganizationID.SelectedValue = samples.LastOrDefault().CollectedByOrganizationID
            ddlSampleSentToOrganizationID.SelectedValue = samples.LastOrDefault().SentToOrganizationID
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub SampleSave_Click(sender As Object, e As EventArgs) Handles btnSampleSave.Click

        Try
            Dim samples = CType(Session(SAMPLES_LIST), List(Of GblSampleGetListModel))
            Dim sample = New GblSampleGetListModel()

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                sample = samples.Where(Function(x) x.SampleID = hdfRowID.Value).FirstOrDefault
            End If

            sample.SampleTypeID = If(ddlSampleSampleTypeID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlSampleSampleTypeID.SelectedValue, Long))
            sample.SampleTypeName = If(ddlSampleSampleTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlSampleSampleTypeID.SelectedItem.Text)
            sample.EIDSSLocalOrFieldSampleID = If(txtSampleEIDSSLocalOrFieldSampleID.Text.IsValueNullOrEmpty(), Nothing, txtSampleEIDSSLocalOrFieldSampleID.Text)
            sample.SpeciesID = If(ddlSampleSpeciesID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlSampleSpeciesID.SelectedValue, Long))
            sample.SpeciesTypeName = If(ddlSampleSpeciesID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlSampleSpeciesID.SelectedItem.Text)
            sample.AnimalID = If(ddlSampleAnimalID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlSampleAnimalID.SelectedValue, Long))
            sample.EIDSSAnimalID = If(ddlSampleAnimalID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlSampleAnimalID.SelectedItem.Text)
            sample.CollectionDate = If(txtSampleCollectionDate.Text.IsValueNullOrEmpty(), CType(Nothing, Date?), Convert.ToDateTime(txtSampleCollectionDate.Text))
            sample.AccessionDate = If(txtSampleAccessionDate.Text.IsValueNullOrEmpty(), CType(Nothing, Date?), Convert.ToDateTime(txtSampleAccessionDate.Text))
            sample.AccessionComment = If(txtSampleAccessionComment.Text.IsValueNullOrEmpty(), Nothing, txtSampleAccessionComment.Text)
            sample.Comments = If(txtSampleComments.Text.IsValueNullOrEmpty(), Nothing, txtSampleComments.Text)
            sample.CollectedByOrganizationID = If(ddlSampleCollectedByOrganizationID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlSampleCollectedByOrganizationID.SelectedValue)
            sample.CollectedByOrganizationName = If(ddlSampleCollectedByOrganizationID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlSampleCollectedByOrganizationID.SelectedItem.Text)
            sample.CollectedByPersonID = If(ddlSampleCollectedByPersonID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlSampleCollectedByPersonID.SelectedValue)
            sample.CollectedByPersonName = If(ddlSampleCollectedByPersonID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlSampleCollectedByPersonID.SelectedItem.Text)
            sample.SentToOrganizationID = If(ddlSampleSentToOrganizationID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlSampleSentToOrganizationID.SelectedValue, Long))
            sample.SentToOrganizationName = If(ddlSampleSentToOrganizationID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlSampleSentToOrganizationID.SelectedItem.Text)
            sample.SiteID = EIDSSAuthenticatedUser.SiteId
            sample.ReadOnlyIndicator = 0

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                If sample.SampleID > 0 Then
                    sample.RowAction = RecordConstants.Update
                End If

                Dim pensideTests = CType(Session(PENSIDE_TESTS_LIST), List(Of VetPensideTestGetListModel))
                If pensideTests Is Nothing Then
                    pensideTests = New List(Of VetPensideTestGetListModel)()
                End If
                For Each pensideTest In pensideTests
                    If pensideTest.SampleID.ToString = sample.SampleID Then
                        pensideTest.EIDSSLocalOrFieldSampleID = txtSampleEIDSSLocalOrFieldSampleID.Text
                        pensideTest.SampleTypeName = ddlSampleSampleTypeID.SelectedItem.Text
                    End If
                Next
                gvPensideTests.DataSource = Nothing
                Session(PENSIDE_TESTS_LIST) = pensideTests
                gvPensideTests.DataSource = pensideTests
                gvPensideTests.DataBind()

                Dim tests = CType(Session(TESTS_LIST), List(Of GblTestGetListModel))
                If tests Is Nothing Then
                    tests = New List(Of GblTestGetListModel)()
                End If
                For Each test In tests
                    If test.SampleID.ToString = sample.SampleID Then
                        test.EIDSSLocalOrFieldSampleID = txtSampleEIDSSLocalOrFieldSampleID.Text
                        test.SampleTypeName = ddlSampleSampleTypeID.SelectedItem.Text
                    End If
                Next
                gvLabTests.DataSource = Nothing
                Session(TESTS_LIST) = tests
                gvLabTests.DataSource = tests
                gvLabTests.DataBind()

                Dim testInterpretations = CType(Session(TEST_INTERPRETATIONS_LIST), List(Of GblTestInterpretationGetListModel))
                If testInterpretations Is Nothing Then
                    testInterpretations = New List(Of GblTestInterpretationGetListModel)()
                End If
                For Each testInterpretation In testInterpretations
                    If testInterpretation.SampleID.ToString = sample.SampleID Then
                        testInterpretation.EIDSSLocalOrFieldSampleID = txtSampleEIDSSLocalOrFieldSampleID.Text
                        testInterpretation.SampleTypeName = ddlSampleSampleTypeID.SelectedItem.Text
                    End If
                Next
                gvTestInterpretations.DataSource = Nothing
                Session(TEST_INTERPRETATIONS_LIST) = testInterpretations
                gvTestInterpretations.DataSource = testInterpretations
                gvTestInterpretations.DataBind()
            Else
                hdfIdentity.Value += 1
                Dim identity As Integer = (hdfIdentity.Value * -1)
                sample.SampleID = identity
                sample.RowStatus = RecordConstants.ActiveRowStatus
                sample.RowAction = RecordConstants.Insert
                samples.Add(sample)
            End If

            gvSamples.DataSource = Nothing
            Session(SAMPLES_LIST) = samples
            gvSamples.DataSource = samples
            gvSamples.DataBind()

            FillDropDownList(ddlPensideTestSampleID, samples, Nothing, "SampleID", "EIDSSLocalOrFieldSampleID", blankRow:=True)
            FillDropDownList(ddlLabTestSampleID, samples, Nothing, "SampleID", "EIDSSLocalOrFieldSampleID", blankRow:=True)

            ResetSample()

            ToggleVisibility(SectionSamples)

            upSamples.Update()

            upPensideTests.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSampleModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Samples_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvSamples.RowDataBound

        Try
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim dr As DataRowView = TryCast(e.Row.DataItem, DataRowView)
                If Not dr Is Nothing Then
                    Dim btnEditSample As LinkButton = CType(e.Row.FindControl("btnEditSample"), LinkButton)
                    Dim gvAliquotsDerivatives As GridView = e.Row.FindControl("gvAliquotsDerivatives")
                    gvAliquotsDerivatives.DataSource = FillAliqoutsDerivatives(btnEditSample.CommandArgument)
                    gvAliquotsDerivatives.DataBind()
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Samples_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSamples.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    upWarningModal.Update()
                    upHiddenFields.Update()
                    e.Handled = True
                    ShowWarningMessage(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Resources.WarningMessages.Confirm_Delete_Message)
                    hdfRowAction.Value = RecordConstants.Delete
                    hdfRowID.Value = e.CommandArgument
                    hdfRecordType.Value = RecordTypeConstants.Samples
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditSample(e.CommandArgument)
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sampleID"></param>
    Private Sub EditSample(sampleID As Long)

        Dim samples = CType(Session(SAMPLES_LIST), List(Of GblSampleGetListModel))
        Dim sample = samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault

        If Not sample Is Nothing Then
            If ddlSampleAnimalID.Items.Count > 0 Then
                ddlSampleAnimalID.SelectedValue = If(sample.EIDSSAnimalID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), sample.EIDSSAnimalID)
            End If

            If ddlSampleCollectedByOrganizationID.Items.Count > 0 Then
                ddlSampleCollectedByOrganizationID.SelectedValue = If(sample.CollectedByOrganizationID.ToString.IsValueNullOrEmpty(), String.Empty, sample.CollectedByOrganizationID)
            End If

            If ddlSampleCollectedByPersonID.Items.Count > 0 Then
                ddlSampleCollectedByPersonID.SelectedValue = If(sample.CollectedByPersonID.ToString.IsValueNullOrEmpty(), String.Empty, sample.CollectedByPersonID)
            End If

            If ddlSampleSpeciesID.Items.Count > 0 Then
                ddlSampleSpeciesID.SelectedValue = If(sample.SpeciesID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), sample.SpeciesID)
            End If

            If ddlSampleSampleTypeID.Items.Count > 0 Then
                ddlSampleSampleTypeID.SelectedValue = If(sample.SampleTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), sample.SampleTypeID)
            End If

            If ddlSampleSentToOrganizationID.Items.Count > 0 Then
                ddlSampleSentToOrganizationID.SelectedValue = If(sample.SentToOrganizationID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), sample.SentToOrganizationID)
            End If

            If Not sample.AccessionDate Is Nothing Then
                txtSampleAccessionDate.Text = sample.AccessionDate
            End If

            If Not sample.CollectionDate Is Nothing Then
                txtSampleCollectionDate.Text = sample.CollectionDate
            End If

            txtSampleAccessionComment.Text = If(sample.AccessionComment, String.Empty)
            txtSampleEIDSSLocalOrFieldSampleID.Text = If(sample.EIDSSLocalOrFieldSampleID, String.Empty)
            txtSampleComments.Text = If(sample.Comments, String.Empty)
            hdfRowID.Value = sample.SampleID
            hdfRowAction.Value = sample.RowAction.ToString

            ToggleVisibility(SectionSample)

            upHiddenFields.Update()
            upSampleModal.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSampleModal"), True)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sampleID"></param>
    Private Sub DeleteSample(sampleID As Long)

        upSamples.Update()

        Dim samples = CType(Session(SAMPLES_LIST), List(Of GblSampleGetListModel))
        Dim sample = samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault

        If CanDeleteSample(sample.SampleID) Then
            If sample.RowAction = RecordConstants.Insert Then
                samples.Remove(sample)
            Else
                sample.RowAction = RecordConstants.Delete
                sample.RowStatus = RecordConstants.InactiveRowStatus
            End If

            Session(SAMPLES_LIST) = samples
            gvSamples.DataSource = samples.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus).OrderBy(Function(x) x.SampleID)
            gvSamples.DataBind()
        Else
            ShowWarningMessage(messageType:=MessageType.AssociatedPensideTestRecords, isConfirm:=False)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sampleID"></param>
    ''' <returns></returns>
    Public Function CanDeleteSample(ByVal sampleID As Long) As Boolean

        Dim pensideTests = CType(Session(PENSIDE_TESTS_LIST), List(Of VetPensideTestGetListModel))

        If pensideTests Is Nothing Then
            pensideTests = New List(Of VetPensideTestGetListModel)()
        End If

        If pensideTests.Where(Function(x) x.SampleID = sampleID).Count = 0 Then
            Return True
        Else
            Return False
        End If

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="parentSampleID"></param>
    ''' <returns></returns>
    Private Function FillAliqoutsDerivatives(ByVal parentSampleID As Long) As List(Of GblSampleGetListModel)

        If CrossCuttingAPIService Is Nothing Then
            CrossCuttingAPIService = New CrossCuttingServiceClient()
        End If
        Dim samples = CrossCuttingAPIService.GetSampleListAsync(GetCurrentLanguage(), Nothing, Nothing, parentSampleID, Nothing, Nothing).Result

        Return samples

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub FilterByDisease_CheckedChanged(sender As Object, e As EventArgs) Handles chkFilterByDisease.CheckedChanged

        'TODO: convert to API method
        If chkFilterByDisease.Checked Then
            FillDropDown(ddlSampleSampleTypeID,
                GetType(clsSampleDisease),
                {ddlDiseaseID.SelectedValue},
                SampleTypeConstants.SampleTypeID,
                SampleTypeConstants.SampleTypeName,
                String.Empty,
                Nothing,
                True)
        Else
            BaseReferenceLookUp(ddlSampleSampleTypeID, BaseReferenceConstants.SampleType, HACodeList.LivestockHACode, True)
        End If

    End Sub

    ' TODO: Check handles on this control; it is part of a user control.
    Protected Sub SampleCollectedByOrganization_SelectedIndexChanged(sender As Object, e As EventArgs)

        'TODO: convert to API method
        'Field collected by person filtered by the selected collected by office.
        Dim ddl As WebControls.DropDownList = TryCast(ddlSampleCollectedByOrganizationID.FindControl("ddlAllItems"), WebControls.DropDownList)

        FillDropDown(ddlSampleCollectedByPersonID,
            GetType(clsOrgPerson),
            {ddl.SelectedValue},
            OrganizationPerson.PersonId,
            OrganizationPerson.fullName,
            String.Empty,
            Nothing,
            True)

        upSampleModal.Update()

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSampleModal"), True)

    End Sub

#End Region

#Region "Penside Test Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refresh"></param>
    Private Sub FillPensideTests(ByVal refresh As Boolean)

        Try
            Dim pensideTests = New List(Of VetPensideTestGetListModel)()

            If refresh Then Session(PENSIDE_TESTS_LIST) = Nothing

            If IsNothing(Session(PENSIDE_TESTS_LIST)) Then
                If VeterinaryAPIService Is Nothing Then
                    VeterinaryAPIService = New VeterinaryServiceClient()
                End If
                pensideTests = VeterinaryAPIService.GetPensideTestListAsync(GetCurrentLanguage(), hdfVeterinaryDiseaseReportID.Value, Nothing).Result
                Session(PENSIDE_TESTS_LIST) = pensideTests
            Else
                pensideTests = CType(Session(PENSIDE_TESTS_LIST), List(Of VetPensideTestGetListModel))
            End If

            gvPensideTests.DataSource = Nothing
            gvPensideTests.DataSource = pensideTests
            gvPensideTests.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddPensideTest_Click(sender As Object, e As EventArgs) Handles btnAddPensideTest.Click

        Try
            ResetPensideTest()

            hdfRowAction.Value = RecordConstants.Insert

            ToggleVisibility(SectionPensideTest)

            upPensideTestModal.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divPensideTestModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try


    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ResetPensideTest()

        ddlPensideTestSampleID.SelectedIndex = -1
        ddlPensideTestPensideTestNameTypeID.SelectedIndex = -1
        txtPensideTestSampleType.Text = String.Empty
        txtPensideTestEIDSSAnimalID.Text = String.Empty
        ddlPensideTestPensideTestResultTypeID.SelectedIndex = -1
        hdfRowID.Value = "0"
        hdfRowAction.Value = String.Empty

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub PensideTestSave_Click(sender As Object, e As EventArgs) Handles btnPensideTestSave.Click

        Try
            Dim pensideTests = CType(Session(PENSIDE_TESTS_LIST), List(Of VetPensideTestGetListModel))
            Dim pensideTest = New VetPensideTestGetListModel()

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                pensideTest = pensideTests.Where(Function(x) x.PensideTestID = hdfRowID.Value).FirstOrDefault
            End If

            pensideTest.PensideTestResultTypeID = If(ddlPensideTestPensideTestResultTypeID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), ddlPensideTestPensideTestResultTypeID.SelectedValue)
            pensideTest.PensideTestResultTypeName = If(ddlPensideTestPensideTestResultTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlPensideTestPensideTestResultTypeID.SelectedItem.Text)
            pensideTest.PensideTestNameTypeID = If(ddlPensideTestPensideTestNameTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlPensideTestPensideTestNameTypeID.SelectedValue)
            pensideTest.PensideTestNameTypeName = If(ddlPensideTestPensideTestNameTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlPensideTestPensideTestNameTypeID.SelectedItem.Text)
            pensideTest.EIDSSAnimalID = If(txtPensideTestEIDSSAnimalID.Text.IsValueNullOrEmpty(), Nothing, txtPensideTestEIDSSAnimalID.Text)
            pensideTest.EIDSSLocalOrFieldSampleID = If(ddlPensideTestSampleID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlPensideTestSampleID.SelectedItem.Text)
            pensideTest.SampleTypeName = If(txtPensideTestSampleType.Text.IsValueNullOrEmpty(), Nothing, txtPensideTestSampleType.Text)
            pensideTest.SampleID = ddlPensideTestSampleID.SelectedValue

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                If pensideTest.PensideTestID > 0 Then
                    pensideTest.RowAction = RecordConstants.Update
                End If
            Else
                hdfIdentity.Value += 1
                Dim identity As Integer = (hdfIdentity.Value * -1)
                pensideTest.PensideTestID = identity
                pensideTest.RowStatus = RecordConstants.ActiveRowStatus
                pensideTest.RowAction = RecordConstants.Insert
                pensideTests.Add(pensideTest)
            End If

            gvPensideTests.DataSource = Nothing
            Session(PENSIDE_TESTS_LIST) = pensideTests
            gvPensideTests.DataSource = pensideTests
            gvPensideTests.DataBind()

            ResetPensideTest()

            ToggleVisibility(SectionPensideTests)

            upPensideTests.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divPensideTestModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub PensideTests_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvPensideTests.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    upWarningModal.Update()
                    upHiddenFields.Update()
                    e.Handled = True
                    ShowWarningMessage(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Resources.WarningMessages.Confirm_Delete_Message)
                    hdfRowAction.Value = RecordConstants.Delete
                    hdfRowID.Value = e.CommandArgument
                    hdfRecordType.Value = RecordTypeConstants.PensideTests
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditPensideTest(e.CommandArgument)
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pensideTestID"></param>
    Private Sub EditPensideTest(pensideTestID As Long)

        Dim pensideTests = CType(Session(PENSIDE_TESTS_LIST), List(Of VetPensideTestGetListModel))
        Dim pensideTest = pensideTests.Where(Function(x) x.PensideTestID = hdfRowID.Value).FirstOrDefault

        If Not pensideTest Is Nothing Then
            ddlPensideTestPensideTestNameTypeID.SelectedValue = If(pensideTest.PensideTestNameTypeID.ToString = "", "null", pensideTest.PensideTestNameTypeID)
            ddlPensideTestPensideTestResultTypeID.SelectedValue = If(pensideTest.PensideTestResultTypeID.ToString = "", "null", pensideTest.PensideTestResultTypeID)
            txtPensideTestEIDSSAnimalID.Text = If(pensideTest.EIDSSAnimalID.ToString = "", "", pensideTest.EIDSSAnimalID)
            ddlPensideTestSampleID.SelectedValue = If(pensideTest.SampleID.ToString = "", "", pensideTest.SampleID)
            txtPensideTestSampleType.Text = If(pensideTest.SampleTypeName.ToString = "", "", pensideTest.SampleTypeName)
            hdfRowID.Value = pensideTest.PensideTestID
            hdfRowAction.Value = pensideTest.RowAction.ToString

            ToggleVisibility(SectionPensideTest)

            upHiddenFields.Update()
            upPensideTestModal.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divPensideTestModal"), True)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pensideTestID"></param>
    Private Sub DeletePensideTest(pensideTestID As Long)

        upPensideTests.Update()

        Dim pensideTests = CType(Session(PENSIDE_TESTS_LIST), List(Of VetPensideTestGetListModel))
        Dim pensideTest = pensideTests.Where(Function(x) x.PensideTestID = hdfRowID.Value).FirstOrDefault

        If pensideTest.RowAction = RecordConstants.Insert Then
            pensideTests.Remove(pensideTest)
        Else
            pensideTest.RowAction = RecordConstants.Delete
            pensideTest.RowStatus = RecordConstants.InactiveRowStatus
        End If

        Session(PENSIDE_TESTS_LIST) = pensideTests
        gvPensideTests.DataSource = pensideTests.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus).OrderBy(Function(x) x.PensideTestID)
        gvPensideTests.DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub PensideTestSampleID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlPensideTestSampleID.SelectedIndexChanged

        Dim samples As List(Of GblSampleGetListModel) = TryCast(Session(SAMPLES_LIST), List(Of GblSampleGetListModel))

        If Not ddlPensideTestSampleID.SelectedValue = Nothing Then
            Dim sample = samples.Where(Function(x) x.SampleID = ddlPensideTestSampleID.SelectedValue).FirstOrDefault()

            txtPensideTestEIDSSAnimalID.Text = If(sample.EIDSSAnimalID.ToString.IsValueNullOrEmpty(), String.Empty, sample.EIDSSAnimalID)
            txtPensideTestSampleType.Text = If(sample.SampleTypeName.ToString.IsValueNullOrEmpty(), String.Empty, sample.SampleTypeName)
        End If

        upPensideTestModal.Update()

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divPensideTestModal"), True)

    End Sub

#End Region

#Region "Lab Test Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refresh"></param>
    Private Sub FillTests(ByVal refresh As Boolean)

        Try
            Dim tests = New List(Of GblTestGetListModel)()

            If refresh Then Session(TESTS_LIST) = Nothing

            If IsNothing(Session(TESTS_LIST)) Then
                If CrossCuttingAPIService Is Nothing Then
                    CrossCuttingAPIService = New CrossCuttingServiceClient()
                End If
                tests = CrossCuttingAPIService.GetTestListAsync(GetCurrentLanguage(), Nothing, hdfVeterinaryDiseaseReportID.Value, Nothing, Nothing, Nothing).Result
                Session(TESTS_LIST) = tests
            Else
                tests = CType(Session(TESTS_LIST), List(Of GblTestGetListModel))
            End If

            gvLabTests.DataSource = Nothing
            gvLabTests.DataSource = tests
            gvLabTests.DataBind()

            If rdbLabTestConductedYes.Checked Then
                btnAddLabTest.Enabled = True
            Else
                btnAddLabTest.Enabled = False
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddLabTest_Click(sender As Object, e As EventArgs) Handles btnAddLabTest.Click

        Try
            ResetTest()

            hdfRowAction.Value = RecordConstants.Insert

            If ddlDiseaseID.SelectedValue = Nothing Then
                txtLabTestDisease.Text = GetLocalResourceObject("Notification_Message_No_Disease")
            Else
                txtLabTestDisease.Text = ddlDiseaseID.SelectedItem.Text
            End If

            ToggleVisibility(SectionLabTest)

            upLabTestModal.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divLabTestModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ResetTest()

        ddlLabTestSampleID.SelectedIndex = -1
        ddlLabTestTestCategoryTypeID.SelectedIndex = -1
        ddlLabTestTestNameTypeID.SelectedIndex = -1
        ddlLabTestTestResultTypeID.SelectedIndex = -1

        txtLabTestResultDate.Text = String.Empty
        txtLabTestEIDSSAnimalID.Text = String.Empty
        txtLabTestSampleTypeName.Text = String.Empty
        txtLabTestEIDSSLaboratorySampleID.Text = String.Empty
        ddlLabTestTestStatusTypeID.SelectedIndex = -1
        hdfRowID.Value = "0"
        hdfRowAction.Value = String.Empty

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub LabTestSave_Click(sender As Object, e As EventArgs) Handles btnLabTestSave.Click

        Try
            Dim tests = CType(Session(TESTS_LIST), List(Of GblTestGetListModel))
            Dim test = New GblTestGetListModel()

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                test = tests.Where(Function(x) x.TestID = hdfRowID.Value).FirstOrDefault
            End If

            test.SampleID = If(ddlLabTestSampleID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlLabTestSampleID.SelectedValue)
            test.EIDSSLocalOrFieldSampleID = If(ddlLabTestSampleID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlLabTestSampleID.SelectedItem.Text)
            test.TestCategoryTypeID = If(ddlLabTestTestCategoryTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlLabTestTestCategoryTypeID.SelectedValue)
            test.TestCategoryTypeName = If(ddlLabTestTestCategoryTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlLabTestTestCategoryTypeID.SelectedItem.Text)
            test.TestNameTypeID = If(ddlLabTestTestNameTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlLabTestTestNameTypeID.SelectedValue)
            test.TestNameTypeName = If(ddlLabTestTestNameTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlLabTestTestNameTypeID.SelectedItem.Text)
            test.ResultDate = If(txtLabTestResultDate.Text = String.Empty, Nothing, Convert.ToDateTime(txtLabTestResultDate.Text))
            test.DiseaseID = If(ddlDiseaseID.SelectedValue.IsValueNullOrEmpty(), "-1", ddlDiseaseID.SelectedValue)
            test.DiseaseName = If(ddlDiseaseID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlDiseaseID.SelectedItem.Text)
            test.SampleTypeName = If(txtLabTestSampleTypeName.Text = String.Empty, Nothing, txtLabTestSampleTypeName.Text)
            test.EIDSSLaboratorySampleID = If(txtLabTestEIDSSLaboratorySampleID.Text = String.Empty, Nothing, txtLabTestEIDSSLaboratorySampleID.Text)
            test.TestResultTypeID = If(ddlLabTestTestResultTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlLabTestTestResultTypeID.SelectedValue)
            test.TestResultTypeName = If(ddlLabTestTestResultTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlLabTestTestResultTypeID.SelectedItem.Text)
            test.TestStatusTypeID = If(ddlLabTestTestStatusTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlLabTestTestStatusTypeID.SelectedValue)
            test.TestStatusTypeName = If(ddlLabTestTestStatusTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlLabTestTestStatusTypeID.SelectedItem.Text)
            test.EIDSSAnimalID = If(txtLabTestEIDSSAnimalID.Text = String.Empty, Nothing, txtLabTestEIDSSAnimalID.Text)
            test.ReadOnlyIndicator = False
            test.NonLaboratoryTestIndicator = False

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                If test.TestID > 0 Then
                    test.RowAction = RecordConstants.Update
                End If

                Dim testInterpretations = CType(Session(TEST_INTERPRETATIONS_LIST), List(Of GblTestInterpretationGetListModel))
                For Each testInterpretation As GblTestInterpretationGetListModel In testInterpretations
                    If testInterpretation.TestID.ToString = test.TestID Then
                        testInterpretation.TestNameTypeID = test.TestNameTypeID
                        testInterpretation.TestNameTypeName = test.TestNameTypeName
                        testInterpretation.TestCategoryTypeID = test.TestCategoryTypeID
                        testInterpretation.TestCategoryTypeName = test.TestCategoryTypeName
                        testInterpretation.TestResultTypeID = test.TestResultTypeID
                        testInterpretation.TestResultTypeName = test.TestResultTypeName
                    End If
                Next

                Session(TEST_INTERPRETATIONS_LIST) = testInterpretations
                gvTestInterpretations.DataSource = Nothing
                gvTestInterpretations.DataSource = testInterpretations
                gvTestInterpretations.DataBind()
            Else
                hdfIdentity.Value += 1
                Dim identity As Integer = (hdfIdentity.Value * -1)
                test.TestID = identity
                test.RowStatus = RecordConstants.ActiveRowStatus
                test.RowAction = RecordConstants.Insert
                tests.Add(test)
            End If

            Session(TESTS_LIST) = tests
            gvLabTests.DataSource = Nothing
            gvLabTests.DataSource = tests.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus).OrderBy(Function(x) x.TestID)
            gvLabTests.DataBind()

            ResetTest()

            ToggleVisibility(SectionLabTestsInterpretations)

            upTestsAndTestInterpretations.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divLabTestModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub LabTests_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvLabTests.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    upWarningModal.Update()
                    upHiddenFields.Update()
                    e.Handled = True
                    ShowWarningMessage(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Resources.WarningMessages.Confirm_Delete_Message)
                    hdfRowAction.Value = RecordConstants.Delete
                    hdfRowID.Value = e.CommandArgument
                    hdfRecordType.Value = RecordTypeConstants.LabTests
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditLabTest(e.CommandArgument)
                Case GridViewCommandConstants.NewInterpretationCommand
                    e.Handled = True
                    upTestsAndTestInterpretations.Update()
                    NewTestInterpretation(e.CommandArgument)
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="labTestID"></param>
    Private Sub EditLabTest(labTestID As Long)

        Dim tests = CType(Session(TESTS_LIST), List(Of GblTestGetListModel))
        Dim test = tests.Where(Function(x) x.TestID = hdfRowID.Value).FirstOrDefault

        If Not test Is Nothing Then
            ddlLabTestSampleID.SelectedValue = If(test.SampleID.ToString = String.Empty, String.Empty, test.SampleID)
            ddlLabTestTestCategoryTypeID.SelectedValue = If(test.TestCategoryTypeID.ToString = String.Empty, GlobalConstants.NullValue.ToLower(), test.TestCategoryTypeID)
            ddlLabTestTestNameTypeID.SelectedValue = If(test.TestNameTypeID.ToString = String.Empty, GlobalConstants.NullValue.ToLower(), test.TestNameTypeID)
            ddlLabTestTestResultTypeID.SelectedValue = If(test.TestResultTypeID.ToString = "", GlobalConstants.NullValue.ToLower(), test.TestResultTypeID)
            txtLabTestResultDate.Text = If(test.ResultDate.ToString = String.Empty, String.Empty, test.ResultDate)
            txtLabTestDisease.Text = If(test.DiseaseName.ToString = String.Empty, String.Empty, test.DiseaseName)
            txtLabTestSampleTypeName.Text = If(test.SampleTypeName.ToString = String.Empty, String.Empty, test.SampleTypeName)
            txtLabTestEIDSSLaboratorySampleID.Text = If(test.EIDSSLaboratorySampleID.ToString = String.Empty, String.Empty, test.EIDSSLaboratorySampleID)
            ddlLabTestTestStatusTypeID.SelectedValue = If(test.TestStatusTypeID.ToString = String.Empty, GlobalConstants.NullValue.ToLower(), test.TestStatusTypeID)
            txtLabTestEIDSSAnimalID.Text = If(test.EIDSSAnimalID.ToString = String.Empty, String.Empty, test.EIDSSAnimalID)
            hdfRowID.Value = test.TestID
            hdfRowAction.Value = test.RowAction.ToString

            ToggleVisibility(SectionLabTest)

            upHiddenFields.Update()
            upLabTestModal.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divLabTestModal"), True)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="labTestID"></param>
    Private Sub DeleteLabTest(labTestID As Long)

        upTestsAndTestInterpretations.Update()

        Dim tests = CType(Session(TESTS_LIST), List(Of GblTestGetListModel))
        Dim test = tests.Where(Function(x) x.TestID = labTestID).FirstOrDefault

        If CanDeleteTest(test.TestID) Then
            If test.RowAction = RecordConstants.Insert Then
                tests.Remove(test)
            Else
                test.RowAction = RecordConstants.Delete
                test.RowStatus = RecordConstants.InactiveRowStatus
            End If

            Session(TESTS_LIST) = tests
            gvLabTests.DataSource = tests.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus).OrderBy(Function(x) x.TestID)
            gvLabTests.DataBind()
        Else
            ShowWarningMessage(messageType:=MessageType.AssociatedInterpretationRecords, isConfirm:=False)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testID"></param>
    ''' <returns></returns>
    Public Function CanDeleteTest(ByVal testID As Long) As Boolean

        Dim testInterpretations = CType(Session(TEST_INTERPRETATIONS_LIST), List(Of GblTestInterpretationGetListModel))

        If testInterpretations.Where(Function(x) x.TestID = testID).Count = 0 Then
            Return True
        Else
            Return False
        End If

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub LabTestConductedYes_CheckedChanged(sender As Object, e As EventArgs) Handles rdbLabTestConductedYes.CheckedChanged

        If (rdbLabTestConductedYes.Checked) Then
            btnAddLabTest.Enabled = True
        Else
            btnAddLabTest.Enabled = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub LabTestConductedNo_CheckedChanged(sender As Object, e As EventArgs) Handles rdbLabTestConductedNo.CheckedChanged

        If (rdbLabTestConductedYes.Checked) Then
            btnAddLabTest.Enabled = True
        Else
            btnAddLabTest.Enabled = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub LabTestConductedUnknown_CheckedChanged(sender As Object, e As EventArgs) Handles rdbLabTestConductedUnknown.CheckedChanged

        If (rdbLabTestConductedYes.Checked) Then
            btnAddLabTest.Enabled = True
        Else
            btnAddLabTest.Enabled = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub LabTestSampleID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlLabTestSampleID.SelectedIndexChanged

        Dim samples = CType(Session(SAMPLES_LIST), List(Of GblSampleGetListModel))

        If Not ddlLabTestSampleID.SelectedValue = Nothing Then
            Dim sample = samples.Where(Function(x) x.SampleID = ddlLabTestSampleID.SelectedValue).FirstOrDefault()

            txtLabTestEIDSSAnimalID.Text = If(sample.EIDSSAnimalID.ToString = String.Empty, String.Empty, sample.EIDSSAnimalID)
            txtLabTestSampleTypeName.Text = If(sample.SampleTypeName.ToString = String.Empty, String.Empty, sample.SampleTypeName)
        End If

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divLabTestModal"), True)

    End Sub

#End Region

#Region "Test Interpretation Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refresh"></param>
    Private Sub FillTestInterpretations(ByVal refresh As Boolean)

        Try
            Dim testInterpretations = New List(Of GblTestInterpretationGetListModel)()

            If refresh Then Session(TEST_INTERPRETATIONS_LIST) = Nothing

            If IsNothing(Session(TEST_INTERPRETATIONS_LIST)) Then
                If CrossCuttingAPIService Is Nothing Then
                    CrossCuttingAPIService = New CrossCuttingServiceClient()
                End If
                testInterpretations = CrossCuttingAPIService.GetTestInterpretationListAsync(GetCurrentLanguage(), Nothing, hdfVeterinaryDiseaseReportID.Value, Nothing, Nothing, Nothing).Result
                Session(TEST_INTERPRETATIONS_LIST) = testInterpretations
            Else
                testInterpretations = CType(Session(TEST_INTERPRETATIONS_LIST), List(Of GblTestInterpretationGetListModel))
            End If

            gvTestInterpretations.DataSource = Nothing
            gvTestInterpretations.DataSource = testInterpretations
            gvTestInterpretations.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="labTestID"></param>
    Private Sub NewTestInterpretation(labTestID As Long)

        ResetTestInterpretation()

        hdfRowAction.Value = RecordConstants.Insert

        hdfTestID.Value = labTestID.ToString()

        ToggleVisibility(SectionInterpretation)

        upTestInterpretationModal.Update()

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divTestInterpretationModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub CreateConnectedDiseaseReport_Click(sender As Object, e As EventArgs) Handles btnCreateConnectedDiseaseReport.Click

        Try
            CreateConnectedDiseaseReport()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ResetTestInterpretation()

        chkInterpretationValidatedStatusIndicator.Checked = False
        ddlInterpretationInterpretedStatusTypeID.SelectedIndex = -1
        txtInterpretationInterpretedDate.Text = String.Empty
        txtInterpretationValidatedDate.Text = String.Empty
        txtInterpretationInterpretedComment.Text = String.Empty
        txtInterpretationValidatedComment.Text = String.Empty
        txtInterpretationValidatedByPersonName.Text = String.Empty
        hdfRowID.Value = "0"
        hdfRowAction.Value = String.Empty

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub TestInterpretations_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvTestInterpretations.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    upWarningModal.Update()
                    upHiddenFields.Update()
                    e.Handled = True
                    ShowWarningMessage(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Resources.WarningMessages.Confirm_Delete_Message)
                    hdfRowAction.Value = RecordConstants.Delete
                    hdfRowID.Value = e.CommandArgument
                    hdfRecordType.Value = RecordTypeConstants.Interpretations
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditInterpretation(e.CommandArgument)
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testInterpretationID"></param>
    Private Sub EditInterpretation(testInterpretationID As Long)

        Dim testInterpretations = CType(Session(TEST_INTERPRETATIONS_LIST), List(Of GblTestInterpretationGetListModel))
        Dim testInterpretation = testInterpretations.Where(Function(x) x.TestInterpretationID = testInterpretationID).FirstOrDefault

        If Not testInterpretation Is Nothing Then
            ddlInterpretationInterpretedStatusTypeID.SelectedValue = If(testInterpretation.InterpretedStatusTypeID.ToString = String.Empty, String.Empty, testInterpretation.InterpretedStatusTypeID)

            If Not testInterpretation.InterpretedDate Is Nothing Then
                txtInterpretationInterpretedDate.Text = testInterpretation.InterpretedDate
            End If

            If Not testInterpretation.ValidatedDate Is Nothing Then
                txtInterpretationValidatedDate.Text = testInterpretation.ValidatedDate
            End If

            txtInterpretationInterpretedComment.Text = If(String.IsNullOrEmpty(testInterpretation.InterpretedComment), Nothing, testInterpretation.InterpretedComment)
            txtInterpretationValidatedComment.Text = If(String.IsNullOrEmpty(testInterpretation.ValidatedComment), Nothing, testInterpretation.ValidatedComment)
            txtInterpretationValidatedByPersonName.Text = If(String.IsNullOrEmpty(testInterpretation.ValidatedByPersonName), Nothing, testInterpretation.ValidatedByPersonName)
            chkInterpretationValidatedStatusIndicator.Checked = If(testInterpretation.ValidatedStatusIndicator.ToString = String.Empty, String.Empty, testInterpretation.ValidatedStatusIndicator)
            hdfRowID.Value = testInterpretation.TestInterpretationID
            hdfRowAction.Value = testInterpretation.RowAction.ToString

            ToggleVisibility(SectionInterpretation)

            upHiddenFields.Update()
            upTestInterpretationModal.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divTestInterpretationModal"), True)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testInterpretationID"></param>
    Private Sub DeleteInterpretation(testInterpretationID As Long)

        upTestsAndTestInterpretations.Update()

        Dim testInterpretations = CType(Session(TEST_INTERPRETATIONS_LIST), List(Of GblTestInterpretationGetListModel))
        Dim testInterpretation = testInterpretations.Where(Function(x) x.TestInterpretationID = testInterpretationID).FirstOrDefault

        If testInterpretation.RowAction = RecordConstants.Insert Then
            testInterpretations.Remove(testInterpretation)
        Else
            testInterpretation.RowAction = RecordConstants.Delete
            testInterpretation.RowStatus = RecordConstants.InactiveRowStatus
        End If

        Session(TEST_INTERPRETATIONS_LIST) = testInterpretations
        gvTestInterpretations.DataSource = testInterpretations.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus).OrderBy(Function(x) x.TestInterpretationID)
        gvTestInterpretations.DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="testInterpretationID"></param>
    ''' <returns></returns>
    Public Function CanDeleteTestInterpretation(ByVal testInterpretationID As Long) As Boolean

        Dim testInterpretations = CType(Session(TEST_INTERPRETATIONS_LIST), List(Of GblTestInterpretationGetListModel))

        If testInterpretations.Where(Function(x) x.TestInterpretationID = testInterpretationID).Count = 0 Then
            Return True
        Else
            Return False
        End If

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub TestInterpretationSave_Click(sender As Object, e As EventArgs) Handles btnTestInterpretationSave.Click

        Try
            Dim testInterpretations = CType(Session(TEST_INTERPRETATIONS_LIST), List(Of GblTestInterpretationGetListModel))
            Dim testInterpretation = New GblTestInterpretationGetListModel()

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                testInterpretation = testInterpretations.Where(Function(x) x.TestInterpretationID = hdfRowID.Value).FirstOrDefault()
            End If

            testInterpretation.InterpretedStatusTypeID = If(ddlInterpretationInterpretedStatusTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlInterpretationInterpretedStatusTypeID.SelectedValue)
            testInterpretation.InterpretedStatusTypeName = If(ddlInterpretationInterpretedStatusTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlInterpretationInterpretedStatusTypeID.SelectedItem.Text)
            testInterpretation.InterpretedDate = If(txtInterpretationInterpretedDate.Text.IsValueNullOrEmpty(), Nothing, Convert.ToDateTime(txtInterpretationInterpretedDate.Text))
            testInterpretation.ValidatedDate = If(txtInterpretationValidatedDate.Text.IsValueNullOrEmpty(), CType(Nothing, Date?), CType(Convert.ToDateTime(txtInterpretationValidatedDate.Text), Date))
            testInterpretation.InterpretedComment = If(txtInterpretationInterpretedComment.Text.IsValueNullOrEmpty(), Nothing, txtInterpretationInterpretedComment.Text)
            testInterpretation.ValidatedComment = If(txtInterpretationValidatedComment.Text.IsValueNullOrEmpty(), Nothing, txtInterpretationValidatedComment.Text)
            testInterpretation.ValidatedByPersonName = If(txtInterpretationValidatedByPersonName.Text.IsValueNullOrEmpty(), Nothing, txtInterpretationValidatedByPersonName.Text)
            testInterpretation.ValidatedStatusIndicator = chkInterpretationValidatedStatusIndicator.Checked
            testInterpretation.ReadOnlyIndicator = False
            testInterpretation.TestID = hdfTestID.Value

            Dim tests = CType(Session(TESTS_LIST), List(Of GblTestGetListModel))
            Dim test = tests.Where(Function(x) x.TestID = hdfTestID.Value).FirstOrDefault

            If Not test Is Nothing Then
                testInterpretation.TestID = test.TestID
                testInterpretation.TestCategoryTypeID = test.TestCategoryTypeID
                testInterpretation.TestCategoryTypeName = test.TestCategoryTypeName
                testInterpretation.TestNameTypeID = test.TestNameTypeID
                testInterpretation.TestNameTypeName = test.TestNameTypeName
                testInterpretation.TestResultTypeID = test.TestResultTypeID
                testInterpretation.TestResultTypeName = test.TestResultTypeName
                testInterpretation.EIDSSAnimalID = test.EIDSSAnimalID
            End If

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                If testInterpretation.TestInterpretationID > 0 Then
                    testInterpretation.RowAction = RecordConstants.Update
                End If
            Else
                hdfIdentity.Value += 1
                Dim identity As Integer = (hdfIdentity.Value * -1)
                testInterpretation.TestInterpretationID = identity
                testInterpretation.RowStatus = RecordConstants.ActiveRowStatus
                testInterpretation.RowAction = RecordConstants.Insert
                testInterpretations.Add(testInterpretation)
            End If

            gvTestInterpretations.DataSource = Nothing
            Session(TEST_INTERPRETATIONS_LIST) = testInterpretations
            gvTestInterpretations.DataSource = testInterpretations.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus).OrderBy(Function(x) x.TestInterpretationID)
            gvTestInterpretations.DataBind()

            ResetTestInterpretation()

            ToggleVisibility(SectionLabTestsInterpretations)

            upTestsAndTestInterpretations.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divTestInterpretationModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Veterinary Disease Report Log Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refresh"></param>
    Private Sub FillReportLogs(ByVal refresh As Boolean)

        Try
            Dim reportLogs = New List(Of VetDiseaseReportLogGetListModel)()

            If refresh Then Session(REPORT_LOGS_LIST) = Nothing

            If IsNothing(Session(REPORT_LOGS_LIST)) Then
                If VeterinaryAPIService Is Nothing Then
                    VeterinaryAPIService = New VeterinaryServiceClient()
                End If
                reportLogs = VeterinaryAPIService.GetDiseaseReportLogListAsync(GetCurrentLanguage(), hdfVeterinaryDiseaseReportID.Value).Result
                Session(REPORT_LOGS_LIST) = reportLogs
            Else
                reportLogs = CType(Session(REPORT_LOGS_LIST), List(Of VetDiseaseReportLogGetListModel))
            End If

            gvReportLogs.DataSource = Nothing
            gvReportLogs.DataSource = reportLogs
            gvReportLogs.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AddReportLog_Click(sender As Object, e As EventArgs) Handles btnAddReportLog.Click

        Try
            ResetReportLog()

            hdfRowAction.Value = RecordConstants.Insert

            ToggleVisibility(SectionCaseLog)

            upReportLogModal.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divReportLogModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ResetReportLog()

        txtReportLogLogDate.Text = String.Empty
        ddlReportLogEnteredByPersonID.SelectedIndex = -1
        txtReportLogActionRequired.Text = String.Empty
        txtReportLogComments.Text = String.Empty
        rdbReportLogStatusClosed.Checked = False
        rdbReportLogStatusOpen.Checked = False
        hdfRowID.Value = "0"
        hdfRowAction.Value = String.Empty

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub ReportLogSave_Click(sender As Object, e As EventArgs) Handles btnReportLogSave.Click

        Try
            Dim reportLogs = TryCast(Session(REPORT_LOGS_LIST), List(Of VetDiseaseReportLogGetListModel))
            Dim reportLog = New VetDiseaseReportLogGetListModel()

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                reportLog = reportLogs.Where(Function(x) x.VeterinaryDiseaseReportLogID = hdfRowID.Value).FirstOrDefault()
            End If

            reportLog.LogDate = If(txtReportLogLogDate.Text = String.Empty, CType(Nothing, Date?), CType(Convert.ToDateTime(txtReportLogLogDate.Text), Date))
            reportLog.PersonID = If(ddlReportLogEnteredByPersonID.SelectedValue = GlobalConstants.NullValue.ToLower(), Nothing, ddlReportLogEnteredByPersonID.SelectedValue)
            reportLog.PersonName = If(ddlReportLogEnteredByPersonID.SelectedValue = GlobalConstants.NullValue.ToLower(), Nothing, ddlReportLogEnteredByPersonID.SelectedItem.Text)
            reportLog.ActionRequired = If(txtReportLogActionRequired.Text = String.Empty, Nothing, txtReportLogActionRequired.Text)
            reportLog.Comments = If(txtReportLogComments.Text = String.Empty, Nothing, txtReportLogComments.Text)
            reportLog.LogStatusTypeID = If(rdbReportLogStatusOpen.Checked, DiseaseReportLogStatusTypes.Open, DiseaseReportLogStatusTypes.Closed)
            reportLog.LogStatusTypeName = If(rdbReportLogStatusOpen.Checked, Resources.Labels.Lbl_Open_Text, Resources.Labels.Lbl_Closed_Text)

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                If reportLog.VeterinaryDiseaseReportLogID > 0 Then
                    reportLog.RowAction = RecordConstants.Update
                End If
            Else
                hdfIdentity.Value += 1
                Dim identity As Integer = (hdfIdentity.Value * -1)
                reportLog.VeterinaryDiseaseReportLogID = identity
                reportLog.RowStatus = RecordConstants.ActiveRowStatus
                reportLog.RowAction = RecordConstants.Insert
                reportLogs.Add(reportLog)
            End If

            Session(REPORT_LOGS_LIST) = reportLogs
            gvReportLogs.DataSource = Nothing
            gvReportLogs.DataSource = reportLogs.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus).OrderBy(Function(x) x.VeterinaryDiseaseReportLogID)
            gvReportLogs.DataBind()

            ResetReportLog()

            ToggleVisibility(SectionCaseLogs)

            upReportLogs.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divReportLogModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub ReportLogs_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvReportLogs.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    upWarningModal.Update()
                    upHiddenFields.Update()
                    e.Handled = True
                    ShowWarningMessage(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Resources.WarningMessages.Confirm_Delete_Message)
                    hdfRowAction.Value = RecordConstants.Delete
                    hdfRowID.Value = e.CommandArgument
                    hdfRecordType.Value = RecordTypeConstants.VetCaseLogs
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditReportLog(e.CommandArgument)
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="reportLogID"></param>
    Private Sub EditReportLog(reportLogID As Long)

        Dim reportLogs = TryCast(Session(REPORT_LOGS_LIST), List(Of VetDiseaseReportLogGetListModel))
        Dim reportLog = reportLogs.Where(Function(x) x.VeterinaryDiseaseReportLogID = reportLogID).FirstOrDefault()

        If Not reportLog Is Nothing Then
            txtReportLogLogDate.Text = If(reportLog.LogDate.ToString = String.Empty, String.Empty, reportLog.LogDate)
            ddlReportLogEnteredByPersonID.SelectedValue = If(reportLog.PersonID.ToString = String.Empty, GlobalConstants.NullValue.ToLower(), reportLog.PersonID)
            txtReportLogActionRequired.Text = If(String.IsNullOrEmpty(reportLog.ActionRequired), Nothing, reportLog.ActionRequired)
            txtReportLogComments.Text = If(String.IsNullOrEmpty(reportLog.Comments), Nothing, reportLog.Comments)
            hdfRowID.Value = reportLog.VeterinaryDiseaseReportLogID
            hdfRowAction.Value = reportLog.RowAction.ToString

            If reportLog.LogStatusTypeID = DiseaseReportLogStatusTypes.Open Then
                rdbReportLogStatusClosed.Checked = False
                rdbReportLogStatusOpen.Checked = True
            Else
                rdbReportLogStatusClosed.Checked = True
                rdbReportLogStatusOpen.Checked = False
            End If

            ToggleVisibility(SectionCaseLog)

            upHiddenFields.Update()
            upReportLogModal.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divReportLogModal"), True)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="reportLogID"></param>
    Private Sub DeleteReportLog(reportLogID As Long)

        upReportLogs.Update()

        Dim reportLogs = TryCast(Session(REPORT_LOGS_LIST), List(Of VetDiseaseReportLogGetListModel))
        Dim reportLog = reportLogs.Where(Function(x) x.VeterinaryDiseaseReportLogID = hdfRowID.Value).FirstOrDefault()

        If reportLog.RowAction = RecordConstants.Insert Then
            reportLogs.Remove(reportLog)
        Else
            reportLog.RowAction = RecordConstants.Delete
            reportLog.RowStatus = RecordConstants.InactiveRowStatus
        End If

        Session(REPORT_LOGS_LIST) = reportLogs
        gvReportLogs.DataSource = reportLogs.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus).OrderBy(Function(x) x.VeterinaryDiseaseReportLogID)
        gvReportLogs.DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub ReportLogActionRequired_TextChanged(sender As Object, e As EventArgs) Handles txtReportLogActionRequired.TextChanged

        ddlReportLogEnteredByPersonID.SelectedValue = EIDSSAuthenticatedUser.PersonId

        upReportLogModal.Update()

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divReportLogModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub ReportedByOrganizationID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlReportedByOrganizationID.SelectedIndexChanged

        If ddlReportedByOrganizationID.SelectedValue.IsValueNullOrEmpty = False Then
            If EmployeeAPIService Is Nothing Then
                EmployeeAPIService = New EmployeeServiceClient()
            End If

            Dim employeeParameters = New AdminEmployeeGetListParams()
            employeeParameters.LanguageID = GetCurrentLanguage()
            employeeParameters.OrganizationID = ddlReportedByOrganizationID.SelectedValue
            Dim employees As List(Of AdminEmployeeGetlistModel) = EmployeeAPIService.GetEmployees(employeeParameters).Result
            FillDropDownList(ddlReportLogEnteredByPersonID, employees, {GlobalConstants.NullValue}, "EmployeeID", "EmployeeFullName", Nothing, Nothing, True)
            ddlReportLogEnteredByPersonID = SortDropDownList(ddlReportLogEnteredByPersonID)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub InvestigatedByOrganizationID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlInvestigatedByOrganizationID.SelectedIndexChanged

        If ddlInvestigatedByOrganizationID.SelectedValue.IsValueNullOrEmpty = False Then
            If EmployeeAPIService Is Nothing Then
                EmployeeAPIService = New EmployeeServiceClient()
            End If

            Dim employeeParameters = New AdminEmployeeGetListParams()
            employeeParameters.LanguageID = GetCurrentLanguage()
            employeeParameters.OrganizationID = ddlReportedByOrganizationID.SelectedValue
            Dim employees As List(Of AdminEmployeeGetlistModel) = EmployeeAPIService.GetEmployees(employeeParameters).Result
            FillDropDownList(ddlInvestigatedByPersonID, employees, {GlobalConstants.NullValue}, "EmployeeID", "EmployeeFullName", Nothing, Nothing, True)
            ddlInvestigatedByPersonID = SortDropDownList(ddlInvestigatedByPersonID)
        End If

    End Sub

#End Region

End Class