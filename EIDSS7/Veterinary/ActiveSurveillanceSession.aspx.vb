Imports System.Reflection
Imports EIDSS.Client.API_Clients
Imports EIDSS.Client.Enumerations
Imports EIDSS.Client.Responses
Imports EIDSS.EIDSS
Imports EIDSSControlLibrary
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts

Public Class VeterinaryActiveSurveillanceSession
    Inherits BaseEidssPage

#Region "Global Values"

    Private Const SectionSearch As String = "Search"
    Private Const SectionSessionInformation As String = "Session Information"
    Private Const SectionDetailedInformation As String = "Detailed Information"
    Private Const SectionTest As String = "Test"
    Private Const SectionResultSummary As String = "Result Summary"

    Private Const PAGE_KEY As String = "Page"
    Private Const MODAL_KEY As String = "Modal"
    Private Const MODAL_ON_MODAL_KEY As String = "ModalOnModal"

    Private Const SHOW_MODAL_HANDLER_SCRIPT As String = "showModalHandler('{0}');"
    Private Const HIDE_MODAL_SCRIPT As String = "hideModal('{0}');"
    Private Const HIDE_MODAL_SHOW_MODAL_SCRIPT As String = "hideModalShowModal('{0}', '{1}');"
    Private Const HIDE_MODAL_AND_WARNING_MODAL_SCRIPT As String = "hideModalAndWarningModal('{0}');"

    Private Const CALLER_INFO As String = "CallerInfo"
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"
    Private Const RETURN_KEY As String = "ReturnKey"

    Private Const DETAILED_INFO_FARM_SORT_DIRECTION As String = "gvFarm_SortDirection"
    Private Const DETAILED_INFO_FARM_SORT_EXPRESSION As String = "gvFarm_SortExpression"
    Private Const DETAILED_INFO_FARM_PAGINATION_SET_NUMBER As String = "gvFarm_PaginationSet"
    Private Const AGGREGATE_INFO_FARM_SORT_DIRECTION As String = "gvAggregateInfoFarm_SortDirection"
    Private Const AGGREGATE_INFO_FARM_SORT_EXPRESSION As String = "gvAggregateInfoFarm_SortExpression"
    Private Const AGGREGATE_INFO_FARM_PAGINATION_SET_NUMBER As String = "gvAggregateInfoFarm_PaginationSet"

    Public sFile As String

    Private Const DETAILED_INFO_FARM_LIST As String = "DetailedInfoFarmList"
    Private Const AGGREGATE_INFO_FARM_LIST As String = "AggregateInfoFarmList"
    Private Const FARMS_INVENTORY_LIST As String = "FarmsInventoryList"
    Private Const SPECIES_SAMPLE_TYPE_COMBINATION_LIST As String = "SpeciesSampleTypeCombinationList"
    Private Const DIAGNSOSIS_GROUP_LIST As String = "DiagnosisGroupList"
    Private Const DISEASE_LIST As String = "DiseaseList"
    Private Const ANIMAL_LIST As String = "MonitoringSessionAnimalList"
    Private Const SAMPLE_LIST As String = "SampleList"
    Private Const TEST_LIST As String = "TestList"
    Private Const INTERPRETATION_LIST As String = "InterpretationList"
    Private Const ACTION_LIST As String = "ActionList"
    Private Const SUMMARY_LIST As String = "SummaryList"
    Private Const VETERINARY_DISEASE_REPORT_LIST As String = "VeterinaryDiseaseReportList"
    Private Const CAMPAIGN_SESSION As String = "Campaign"
    Private Const ADD_FARM_SESSION As String = "AddFarm"

    Public Event ShowWarningModal(messageType As MessageType, isConfirm As Boolean, message As String)
    Public Event CreateVeterinarySessionRecord(veterinarySessionID As Long, sessionCode As String, message As String)
    Public Event UpdateVeterinarySessionRecord(veterinarySessionID As Long, sessionCode As String, message As String)
    Public Event EditVeterinarySessionRecord(veterinarySessionID As Long)

    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private FarmAPIService As FarmServiceClient
    Private OrganizationAPIService As OrganizationServiceClient
    Private VeterinaryAPIService As VeterinaryServiceClient
    Private DiseaseGroupDiseaseAPIService As DiseaseGroupDiseaseServiceClient
    Private DiseaseSampleTypeMatrixAPIService As DiseaseSampleTypeServiceClient
    Private DiseaseTestTypeMatrixAPIService As DiseaseLabTestServiceClient
    Private TestTestResultTypeMatrixAPIService As TestTestResultServiceClient

    Private Shared Log = log4net.LogManager.GetLogger(GetType(VeterinaryActiveSurveillanceSession))

#End Region

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        Try
            If Not Page.IsPostBack Then
                Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

                ExtractViewStateSession()

                hdfSelectMode.Value = SelectModes.Selection
                EnableForm(FarmAddress, False)

                divFarmList.Visible = False
                divFarmInventory.Visible = False

                btnClearCampaign.Visible = False
                lbxDiseaseID.Attributes.Remove("disabled")

                txtCampaignEndDate.Attributes.Add("style", "display:none")
                txtCampaignStartDate.Attributes.Add("style", "display:none")

                cmvFutureSessionEndDate.ValueToCompare = Date.Now.ToShortDateString()
                cmvFutureSessionStartDate.ValueToCompare = Date.Now.ToShortDateString()
                cmvFutureCollectionDate.ValueToCompare = Date.Now.ToShortDateString()
                cmvFutureResultDate.ValueToCompare = Date.Now.ToShortDateString()

                txtTotalNumberAnimalsSampled.Text = "0"
                txtTotalNumberSamples.Text = "0"
                ddlSampleFarmID.Items.Add(New ListItem With {.Text = String.Empty, .Value = GlobalConstants.NullValue.ToLower()})

                If ViewState(CALLER).Equals(CallerPages.VeterinaryActiveSurveillanceCampaignNewMonitoringSession) Then
                    hdfMonitoringSessionID.Value = "-1"
                    ToggleVisibility(SectionSessionInformation)
                    FillForm(edit:=True)
                Else
                    ToggleVisibility(SectionSearch)
                    ucSearchVeterinarySession.Setup(selectMode:=SelectModes.View)
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

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
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
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
    ''' <param name="section"></param>
    Private Sub ToggleVisibility(ByVal section As String)

        ucSearchVeterinarySession.Visible = section.Equals(SectionSearch)
        divActiveSurveillanceMonitoringSessionForm.Visible = section.Equals(SectionSessionInformation)

        If hdfMonitoringSessionID.Value = "-1" Then
            btnNextSection.OnClientClick = "goToReviewSection(0, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')); return false;"

            sbiDetailedInformation.GoToSideBarSection = "0, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')"
            sbiDetailedTests.GoToSideBarSection = "0, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')"
            sbiActions.GoToSideBarSection = "0, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')"
            sbiAggregateInfo.GoToSideBarSection = "0, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')"
            sbiDiseaseReports.GoToSideBarSection = "0, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')"
            sbiReview.GoToReviewSection = "0, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnNextSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')"

            DetailedInformation.Visible = False
            TestsResultSummaries.Visible = False
            Actions.Visible = False
            AggregateInfo.Visible = False
            DiseaseReports.Visible = False
            btnDelete.Visible = False
            hdfVeterinaryActiveSurveillanceSessionPanelController.Value = 0
        Else
            sbiDetailedInformation.GoToSideBarSection = "1, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')"
            sbiDetailedTests.GoToSideBarSection = "2, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')"
            sbiActions.GoToSideBarSection = "3, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')"
            sbiAggregateInfo.GoToSideBarSection = "4, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')"
            sbiDiseaseReports.GoToSideBarSection = "5, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')"
            sbiReview.GoToSideBarSection = "6, document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')"

            DetailedInformation.Visible = True
            TestsResultSummaries.Visible = True
            Actions.Visible = True
            AggregateInfo.Visible = True
            DiseaseReports.Visible = True

            btnNextSection.OnClientClick = "goToNextSection(document.getElementById('EIDSSBodyCPH_hdfVeterinaryActiveSurveillanceSessionPanelController'), document.getElementById('VeterinaryActiveSurveillanceSessionSideBarPanel'), document.getElementById('EIDSSBodyCPH_divActiveSurveillanceMonitoringSessionForm'), document.getElementById('EIDSSBodyCPH_btnPreviousSection'), document.getElementById('EIDSSBodyCPH_btnSubmit')); return false;"
        End If

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
            Case MessageType.CancelSearchConfirm
                hdfWarningMessageType.Value = MessageType.CancelSearchConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Search_Confirm
            Case MessageType.CancelSampleConfirm
                hdfWarningMessageType.Value = MessageType.CancelSampleConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Form_Confirm
            Case MessageType.CancelLabTestConfirm
                hdfWarningMessageType.Value = MessageType.CancelLabTestConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Form_Confirm
            Case MessageType.CancelResultSummaryConfirm
                hdfWarningMessageType.Value = MessageType.CancelResultSummaryConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Form_Confirm
            Case MessageType.CancelActionConfirm
                hdfWarningMessageType.Value = MessageType.CancelActionConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Form_Confirm
            Case MessageType.CancelAggregateInfoConfirm
                hdfWarningMessageType.Value = MessageType.CancelAggregateInfoConfirm
                divWarningBody.InnerText = Resources.WarningMessages.Cancel_Form_Confirm
            Case MessageType.ConfirmDelete
                divWarningBody.InnerText = message
            Case MessageType.AssociatedInterpretationRecords
                divWarningBody.InnerText = Resources.WarningMessages.Associated_Interpretations
            Case MessageType.CannotGetValidatorSection
                divWarningBody.InnerText = Resources.WarningMessages.Validator_Section
            Case MessageType.UnhandledException
                divWarningBody.InnerText = Resources.WarningMessages.Unhandled_Exception
            Case MessageType.SearchCriteriaRequired
                divWarningBody.InnerText = Resources.WarningMessages.Search_Criteria_Required
            Case MessageType.ConfirmDeleteSpeciesToSampleType
                divWarningBody.InnerText = Resources.WarningMessages.Confirm_Delete_Message
            Case MessageType.ConfirmFarmToMonitoringSessionAddressMismatch
                hdfWarningMessageType.Value = MessageType.ConfirmFarmToMonitoringSessionAddressMismatch
                divWarningBody.InnerText = Resources.WarningMessages.Confirm_Farm_Monitoring_Session_Address_Mismatch
            Case MessageType.ConfirmDeleteFarmInventory
                divWarningBody.InnerText = Resources.WarningMessages.Confirm_Delete_Message
            Case MessageType.ConfirmDeleteMonitoringSession
                divWarningBody.InnerText = Resources.WarningMessages.Confirm_Delete_Message
            Case MessageType.ConfirmDeleteSamples
                divWarningBody.InnerText = Resources.WarningMessages.Confirm_Delete_Message
            Case MessageType.ConfirmDeleteSample
                divWarningBody.InnerText = Resources.WarningMessages.Confirm_Delete_Message
        End Select

        If isConfirm Then
            divWarningYesNo.Visible = True
            divWarningOK.Visible = False
        Else
            divWarningOK.Visible = True
            divWarningYesNo.Visible = False
        End If

        upWarningModal.Update()
        upHiddenFields.Update()

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divWarningModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub WarningModalYes_Click(sender As Object, e As EventArgs) Handles btnWarningModalYes.Click

        Try
            Select Case hdfWarningMessageType.Value
                Case MessageType.CancelConfirmAddUpdate
                    ToggleVisibility(SectionSearch)
                    upAddUpdateActiveSurveillanceSession.Update()
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divWarningModal"), True)
                Case MessageType.CancelSampleConfirm
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_AND_WARNING_MODAL_SCRIPT, "#divSampleModal"), True)
                Case MessageType.CancelLabTestConfirm
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_AND_WARNING_MODAL_SCRIPT, "#divLabTestModal"), True)
                Case MessageType.CancelResultSummaryConfirm
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_AND_WARNING_MODAL_SCRIPT, "#divResultSummaryModal"), True)
                Case MessageType.CancelActionConfirm
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_AND_WARNING_MODAL_SCRIPT, "#divActionModal"), True)
                Case MessageType.CancelAggregateInfoConfirm
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_AND_WARNING_MODAL_SCRIPT, "#divAggregateInfoModal"), True)
                Case MessageType.CancelSearchConfirm
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divWarningModal"), True)
                    SaveEIDSSViewState(ViewState)
                    Response.Redirect(GetURL(CallerPages.DashboardURL), True)
                    Context.ApplicationInstance.CompleteRequest()
                Case MessageType.ConfirmDeleteCampaign
                Case MessageType.ConfirmDeleteSpeciesToSampleType
                    Dim monitoringSessionToSampleTypeID As Long = hdfRowID.Value
                    Dim speciesToSampleTypes = TryCast(Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST), List(Of VctMonitoringSessionSpeciesToSampleTypeGetListModel))
                    Dim speciesToSampleType = speciesToSampleTypes.Where(Function(x) x.MonitoringSessionToSampleTypeID = monitoringSessionToSampleTypeID).FirstOrDefault

                    If speciesToSampleType.RowAction = RecordConstants.Insert Then
                        speciesToSampleTypes.Remove(speciesToSampleType)
                    Else
                        speciesToSampleType.RowAction = RecordConstants.Delete
                        speciesToSampleType.RowStatus = RecordConstants.InactiveRowStatus
                    End If

                    Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST) = speciesToSampleTypes
                    gvSpeciesAndSamples.DataSource = speciesToSampleTypes.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus).OrderBy(Function(x) x.SpeciesTypeName)
                    gvSpeciesAndSamples.DataBind()

                    upSessionInformation.Update()
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divWarningModal"), True)
                Case MessageType.ConfirmFarmToMonitoringSessionAddressMismatch
                    AddFarmToSession()
                    Session.Remove(ADD_FARM_SESSION)
                    divFarmInventory.Visible = True
                    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_AND_WARNING_MODAL_SCRIPT, "#divSearchFarmModal"), True)
                Case MessageType.ConfirmDeleteFarmInventory
                    If CanDeleteFarmInventory(hdfRowID.Value) = True Then
                        DeleteFarmInventory(hdfRowID.Value)
                        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divWarningModal"), True)
                    Else
                        ShowErrorMessage(messageType:=MessageType.CannotDeleteFarmInventory)
                    End If
                Case MessageType.ConfirmDeleteMonitoringSession
                    DeleteMonitoringSession()
                Case MessageType.ConfirmDeleteSamples
                    DeleteSelectedSamples()
                Case MessageType.ConfirmDeleteSample
                    DeleteSample(hdfRowID.Value)
            End Select

            hdfWarningMessageType.Value = String.Empty
            hdfRowID.Value = String.Empty
            upHiddenFields.Update()
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
            hdfWarningMessageType.Value = String.Empty
            hdfRowID.Value = String.Empty

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divWarningModal"), True)

            upHiddenFields.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

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
                errorSubTitle.InnerText = Resources.WarningMessages.Cannot_Save
                divErrorBody.InnerText = message
            Case MessageType.CannotDelete
                divErrorBody.InnerText = Resources.WarningMessages.Cannot_Delete
            Case MessageType.CannotDeleteFarmInventory
                divErrorBody.InnerText = Resources.WarningMessages.Child_Objects_Message
            Case MessageType.CannotDeleteSample
                divErrorBody.InnerText = Resources.WarningMessages.Child_Objects_Message
            Case MessageType.UnhandledException
                divErrorBody.InnerText = Resources.WarningMessages.Unhandled_Exception
        End Select

        upErrorModal.Update()

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divErrorModal"), True)

    End Sub

#End Region

#Region "Search Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="bIsConfirm"></param>
    Protected Sub SearchVeterinarySession_ShowWarningModal(messageType As MessageType, bIsConfirm As Boolean) Handles ucSearchVeterinarySession.ShowWarningModal

        upAddUpdateActiveSurveillanceSession.Update()
        ShowWarningMessage(messageType:=messageType, isConfirm:=bIsConfirm)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sessionID"></param>
    Protected Sub SearchVeterinarySession_ViewVeterinarySessionRecord(sessionID As Long) Handles ucSearchVeterinarySession.ViewVeterinarySessionRecord

        Try
            ToggleVisibility(SectionSearch)

            upSearchActiveSurveillanceSession.Update()
            upAddUpdateActiveSurveillanceSession.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub SearchVeterinarySession_CreateVeterinarySessionRecord() Handles ucSearchVeterinarySession.CreateVeterinarySessionRecord

        Try
            upSearchActiveSurveillanceSession.Update()
            upAddUpdateActiveSurveillanceSession.Update()

            ToggleVisibility(section:=SectionSessionInformation)

            FillForm(edit:=True)

            hdfMonitoringSessionID.Value = "-1"
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sessionID"></param>
    Protected Sub SearchVeterinarySession_EditVeterinarySessionRecord(sessionID As Long) Handles ucSearchVeterinarySession.EditVeterinarySessionRecord

        Try
            hdfMonitoringSessionID.Value = sessionID

            ToggleVisibility(section:=SectionSessionInformation)

            FillForm(edit:=True)

            upSearchActiveSurveillanceSession.Update()
            upAddUpdateActiveSurveillanceSession.Update()
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
        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSearchPersonModal"), True)

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

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchPersonModal"), True)
        upAddUpdateFarm.Update()
        ucAddUpdateFarm.SetFarmOwner(farmOwnerID:=humanID, farmOwnerName:=fullName, eidssPersonID:=eidssPersonID, firstName:=firstName, lastName:=lastName)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub SearchPerson_CreatePerson() Handles ucSearchPerson.CreatePerson

        InitializeAddUpdatePerson(runScript:=False)

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SHOW_MODAL_SCRIPT, "#divSearchPersonModal", "#divAddUpdatePersonModal"), True)

    End Sub

#End Region

#Region "Add/Update Person Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="runScript"></param>
    Private Sub InitializeAddUpdatePerson(runScript As Boolean)

        upAddUpdateFarm.Update()
        upAddUpdatePerson.Update()
        ucAddUpdatePerson.Setup(initialPanelID:=0)

        If runScript = True Then
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAddUpdatePersonModal"), True)
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

        ucAddUpdateFarm.SetFarmOwner(farmOwnerID:=humanID, farmOwnerName:=fullName, eidssPersonID:=eidssPersonID, firstName:=firstName, lastName:=lastName)

    End Sub

#End Region

#Region "Farm Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub InitializeAddUpdateFarm()

        upAddUpdateFarm.Update()

        ucAddUpdateFarm.Setup(initialPanelID:=0)

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAddUpdateFarmModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub AddUpdateFarm_ShowSearchPersonModal() Handles ucAddUpdateFarm.ShowSearchPersonModal

        ScriptManager.RegisterStartupScript(Me, Page.GetType(), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSearchPersonModal"), True)

        InitializeSearchPerson()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Protected Sub AddUpdateFarm_Validate() Handles ucAddUpdateFarm.ValidatePage

        Validate("FarmInformation")
        Validate("FarmAddress")

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    ''' <param name="message"></param>
    Protected Sub AddUpdateFarm_ShowWarningModal(messageType As MessageType, isConfirm As Boolean, message As String) Handles ucAddUpdateFarm.ShowWarningModal

        upWarningModal.Update()
        ShowWarningMessage(messageType:=messageType, isConfirm:=isConfirm, message:=message)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="farmID"></param>
    ''' <param name="farmName"></param>
    ''' <param name="eidssFarmID"></param>
    ''' <param name="message"></param>
    Protected Sub AddUpdateFarm_CreateFarm(farmID As Long, farmName As String, eidssFarmID As String, message As String) Handles ucAddUpdateFarm.CreateFarm

        Try
            upSessionInformation.Update()

            If FarmAPIService Is Nothing Then
                FarmAPIService = New FarmServiceClient()
            End If

            Dim parameters = New FarmGetListParameters() With {.LanguageID = GetCurrentLanguage(), .FarmMasterID = farmID, .PaginationSetNumber = 1}

            Dim farms = FarmAPIService.FarmMasterGetListAsync(parameters).Result

            Session(ADD_FARM_SESSION) = farms.FirstOrDefault()

            AddFarmToSession()

            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divAddUpdateFarmModal"), True)
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
    Private Sub FarmLookup_Click(sender As Object, e As EventArgs) Handles btnFarmLookup.Click

        Try
            If FarmAPIService Is Nothing Then
                FarmAPIService = New FarmServiceClient()
            End If

            Dim parameters As New FarmGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1}
            parameters.RegionID = If(MonitoringSessionAddress.SelectedRegionValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CLng(MonitoringSessionAddress.SelectedRegionValue))
            parameters.RayonID = If(MonitoringSessionAddress.SelectedRayonValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CLng(MonitoringSessionAddress.SelectedRayonValue))
            parameters.SettlementID = If(MonitoringSessionAddress.SelectedSettlementValue.IsValueNullOrEmpty() Or MonitoringSessionAddress.SelectedSettlementValue = "-1", CType(Nothing, Long?), CLng(MonitoringSessionAddress.SelectedSettlementValue))

            Dim list As List(Of VetFarmMasterGetCountModel)
            list = FarmAPIService.FarmMasterGetListCountAsync(parameters).Result
            gvDetailedInfoFarms.PageIndex = 0
            gvDetailedInfoFarms.Visible = True
            hdfDetailedInfoFarmCount.Value = list.FirstOrDefault().SearchCount

            upHiddenFields.Update()

            If list.FirstOrDefault().SearchCount = 1 Then
                lblDetailedInfoFarmRecordCount.Text = list.FirstOrDefault().SearchCount & " " & Resources.Labels.Lbl_Record_Found_Text & list.FirstOrDefault().TotalCount & " " & Resources.Labels.Lbl_Total_Records_Text
            Else
                lblDetailedInfoFarmRecordCount.Text = list.FirstOrDefault().SearchCount & " " & Resources.Labels.Lbl_Records_Found_Text & list.FirstOrDefault().TotalCount & " " & Resources.Labels.Lbl_Total_Records_Text
            End If

            lblDetailedInfoFarmPageNumber.Text = "1"

            FillDetailedInfoFarms(pageIndex:=1, paginationSetNumber:=1)

            divFarmDetails.Visible = False
            divFarmList.Visible = True
            divFarmInventory.Visible = False

            upFarmDetails.Update()
            upFarmList.Update()
            upFarmInventory.Update()
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
    Private Sub CancelFarmLookup_Click(sender As Object, e As EventArgs) Handles btnCancelFarmLookup.Click

        Try
            divFarmDetails.Visible = True
            divFarmList.Visible = False
            divFarmInventory.Visible = False

            upFarmDetails.Update()
            upFarmList.Update()
            upFarmInventory.Update()
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
    Protected Sub DetailedInfoFarmPage_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)

            lblDetailedInfoFarmPageNumber.Text = pageIndex.ToString()

            Dim paginationSetNumber As Integer
            paginationSetNumber = Math.Ceiling(pageIndex / gvDetailedInfoFarms.PageSize)

            If Not ViewState(DETAILED_INFO_FARM_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvDetailedInfoFarms.PageIndex = gvDetailedInfoFarms.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvDetailedInfoFarms.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvDetailedInfoFarms.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvDetailedInfoFarms.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvDetailedInfoFarms.PageIndex = gvDetailedInfoFarms.PageSize - 1
                        Else
                            gvDetailedInfoFarms.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillDetailedInfoFarms(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvDetailedInfoFarms.PageIndex = gvDetailedInfoFarms.PageSize - 1
                Else
                    gvDetailedInfoFarms.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If
                BindDetailedInfoFarmGridView()
                FillDetailedInfoFarmPager(hdfDetailedInfoFarmCount.Value, pageIndex)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    Private Sub FillDetailedInfoFarms(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            Dim parameters As New FarmGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = paginationSetNumber}
            parameters.RegionID = If(MonitoringSessionAddress.SelectedRegionValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CLng(MonitoringSessionAddress.SelectedRegionValue))
            parameters.RayonID = If(MonitoringSessionAddress.SelectedRayonValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CLng(MonitoringSessionAddress.SelectedRayonValue))
            parameters.SettlementID = If(MonitoringSessionAddress.SelectedSettlementValue.IsValueNullOrEmpty() Or MonitoringSessionAddress.SelectedSettlementValue = "-1", CType(Nothing, Long?), CLng(MonitoringSessionAddress.SelectedSettlementValue))

            If FarmAPIService Is Nothing Then
                FarmAPIService = New FarmServiceClient()
            End If

            'Dim farmsInventory = TryCast(Session(FARMS_INVENTORY_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            'If farmsInventory Is Nothing Then
            '    farmsInventory = New List(Of VetFarmHerdSpeciesGetListModel)()
            'End If
            'Dim farms = FarmAPIService.FarmMasterGetListAsync(parameters).Result

            'Session(FARM_LIST) = farms.Where(Function(f) farmsInventory.All(Function(f2) Not f2.FarmMasterID = f.FarmMasterID)).ToList()
            Session(DETAILED_INFO_FARM_LIST) = FarmAPIService.FarmMasterGetListAsync(parameters).Result

            gvDetailedInfoFarms.DataSource = Nothing

            BindDetailedInfoFarmGridView()
            FillDetailedInfoFarmPager(hdfDetailedInfoFarmCount.Value, pageIndex)
            ViewState(DETAILED_INFO_FARM_PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindDetailedInfoFarmGridView()

        Dim farms = CType(Session(DETAILED_INFO_FARM_LIST), List(Of VetFarmMasterGetListModel))

        If (Not ViewState(DETAILED_INFO_FARM_SORT_EXPRESSION) Is Nothing) Then
            If ViewState(DETAILED_INFO_FARM_SORT_DIRECTION) = SortConstants.Ascending Then
                farms = farms.OrderBy(Function(x) x.GetType().GetProperty(ViewState(DETAILED_INFO_FARM_SORT_EXPRESSION)).GetValue(x)).ToList()
            Else
                farms = farms.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(DETAILED_INFO_FARM_SORT_EXPRESSION)).GetValue(x)).ToList()
            End If
        End If

        gvDetailedInfoFarms.DataSource = farms
        gvDetailedInfoFarms.DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillDetailedInfoFarmPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        If recordCount > 0 Then
            divDetailedInfoFarmPager.Visible = True

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
            rptDetailedInfoFarmPager.DataSource = pages
            rptDetailedInfoFarmPager.DataBind()
            divDetailedInfoFarmPager.Visible = True
        Else
            divDetailedInfoFarmPager.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub DetailedInfoFarms_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvDetailedInfoFarms.RowCommand

        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.SelectCommand
                        Dim commandArguments As String() = e.CommandArgument.ToString().Split(",")
                        divFarmDetails.Visible = True
                        divFarmList.Visible = False
                        divFarmInventory.Visible = True

                        Dim farms = TryCast(Session(DETAILED_INFO_FARM_LIST), List(Of VetFarmMasterGetListModel))
                        Session(ADD_FARM_SESSION) = farms.Where(Function(x) x.FarmMasterID = commandArguments(0)).FirstOrDefault()

                        AddFarmToSession()
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
    Private Sub FarmSearch_Click(sender As Object, e As EventArgs) Handles btnFarmSearch.Click

        Try
            Dim countryID As Long? = If(MonitoringSessionAddress.SelectedCountryValue.IsValueNullOrEmpty(), Nothing, MonitoringSessionAddress.SelectedCountryValue)
            Dim regionID As Long? = If(MonitoringSessionAddress.SelectedRegionValue.IsValueNullOrEmpty(), Nothing, MonitoringSessionAddress.SelectedRegionValue)
            Dim rayonID As Long? = If(MonitoringSessionAddress.SelectedRayonValue.IsValueNullOrEmpty(), Nothing, MonitoringSessionAddress.SelectedRayonValue)
            Dim settlementID As Long? = If(MonitoringSessionAddress.SelectedSettlementValue.IsValueNullOrEmpty(), Nothing, MonitoringSessionAddress.SelectedSettlementValue)

            ucSearchFarm.Setup(enableFarmType:=False, selectMode:=SelectModes.Selection, farmType:=ddlSpeciesType.SelectedItem.Text, countryID:=countryID, regionID:=regionID, rayonID:=rayonID, settlementID:=settlementID)
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSearchFarmModal"), True)
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, "showFarmSearchCriteria()", True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    ''' <param name="farm"></param>
    Private Sub SearchFarm_SelectFarmWithWarningModal(messageType As MessageType, isConfirm As Boolean, farm As VetFarmMasterGetListModel) Handles ucSearchFarm.SelectFarmWithWarningModal

        Try
            Session(ADD_FARM_SESSION) = farm
            ShowWarningMessage(messageType:=messageType, isConfirm:=isConfirm, message:=Nothing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub SearchFarm_CreateFarm() Handles ucSearchFarm.CreateFarm

        Try
            upAddUpdateFarm.Update()
            Dim speciesToSampleTypeCombinations = TryCast(Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST), List(Of VctMonitoringSessionSpeciesToSampleTypeGetListModel))
            ucAddUpdateFarm.Setup(initialPanelID:=0, monitoringSessionIndicator:=True, action:=UserAction.Insert, farmType:=ddlSpeciesType.SelectedItem.Text, monitoringSessionSpeciesToSampleTypes:=speciesToSampleTypeCombinations)

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SHOW_MODAL_SCRIPT, "#divSearchFarmModal", "#divAddUpdateFarmModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub AddFarmToSession()

        divFarmDetails.Visible = True
        divFarmList.Visible = False
        divFarmInventory.Visible = True

        Dim farm = TryCast(Session(ADD_FARM_SESSION), VetFarmMasterGetListModel)
        Scatter(divFarmDetails, farm)
        FarmAddress.LocationCountryID = farm.CountryID
        FarmAddress.LocationRegionID = farm.RegionID
        FarmAddress.LocationRayonID = farm.RayonID
        FarmAddress.LocationSettlementID = farm.SettlementID
        FarmAddress.LocationPostalCodeName = farm.PostalCode
        FarmAddress.StreetText = farm.Street
        FarmAddress.ApartmentText = farm.Apartment
        FarmAddress.BuildingText = farm.Building
        FarmAddress.HouseText = farm.House
        FarmAddress.LatitudeText = farm.Latitude.ToString()
        FarmAddress.LongitudeText = farm.Longitude.ToString()

        If CrossCuttingAPIService Is Nothing Then
            CrossCuttingAPIService = New CrossCuttingServiceClient()
        End If
        FarmAddress.Setup(CrossCuttingAPIService)

        Dim samples = TryCast(Session(SAMPLE_LIST), List(Of GblSampleGetListModel))
        If samples Is Nothing Then
            samples = New List(Of GblSampleGetListModel)()
        End If

        If samples.Where(Function(x) x.EIDSSFarmID = farm.EIDSSFarmID).Count > 0 Then
            FillFarmInventory(refresh:=True, isRootFarm:=False, farmID:=samples.Where(Function(x) x.EIDSSFarmID = farm.EIDSSFarmID).FirstOrDefault().FarmID)
            hdfFarmID.Value = samples.Where(Function(x) x.EIDSSFarmID = farm.EIDSSFarmID).FirstOrDefault().FarmID
        Else
            FillFarmInventory(refresh:=True, isRootFarm:=True, farmID:=farm.FarmMasterID)
            ddlSampleFarmID.Items.Add(New ListItem With {.Value = farm.FarmMasterID, .Text = farm.EIDSSFarmID})
            hdfFarmMasterID.Value = farm.FarmMasterID
        End If

        upHiddenFields.Update()
        upFarmDetails.Update()
        upFarmList.Update()
        upFarmInventory.Update()

    End Sub

#End Region

#Region "Monitoring Session Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Submit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        Try
            Validate("SessionInfo")

            If Not hdfMonitoringSessionID.Value = "-1" Then
                Validate("DetailedInformation")
                Validate("Tests")
                Validate("Actions")
                Validate("Summaries")
            End If

            If (Page.IsValid) Then
                If AddUpdateSession() = True Then
                    FillForm(edit:=True)
                    ToggleVisibility(SectionSessionInformation)
                End If
            Else
                DisplaySessionValidationErrors()
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub DeleteMonitoringSession()

        Try
            If VeterinaryAPIService Is Nothing Then
                VeterinaryAPIService = New VeterinaryServiceClient()
            End If
            Dim returnResults As List(Of VctMonitoringSessionDelModel) = VeterinaryAPIService.DeleteMonitoringSessionAsync(GetCurrentLanguage(), hdfMonitoringSessionID.Value).Result

            If returnResults.Count = 0 Then
                ShowErrorMessage(messageType:=MessageType.CannotDelete)
            Else
                Select Case returnResults.FirstOrDefault().ReturnCode
                    Case 0
                        upSearchActiveSurveillanceSession.Update()
                        upSessionInformation.Update()
                        ShowSuccessMessage(messageType:=MessageType.DeleteSuccess)
                        ToggleVisibility(SectionSearch)
                    Case 1
                        ShowWarningMessage(messageType:=MessageType.CannotDelete, isConfirm:=False, message:=Resources.WarningMessages.Child_Objects_Message)
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
    Protected Sub SearchCampaign_Click(sender As Object, e As EventArgs) Handles btnSearchCampaign.Click

        Try
            ucSearchVeterinaryCampaign.Setup(selectMode:=SelectModes.RecordDataSelection)
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSearchCampaignModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="campaign"></param>
    Private Sub SearchVeterinaryCampaign_SelectVeterinaryCampaignData(campaign As VctCampaignGetListModel) Handles ucSearchVeterinaryCampaign.SelectVeterinaryCampaignData

        Try
            Session(CAMPAIGN_SESSION) = campaign

            txtCampaignName.Text = campaign.CampaignName
            txtCampaignTypeName.Text = campaign.CampaignTypeName
            txtEIDSSCampaignID.Text = campaign.EIDSSCampaignID

            hdfCampaignID.Value = campaign.CampaignID
            lbxDiseaseID.DataBind()
            lbxDiseaseID.Items.Add(New ListItem With {.Value = campaign.DiseaseID, .Text = campaign.DiseaseName})
            lbxDiseaseID.Attributes.Add("disabled", "")

            txtCampaignStartDate.Text = campaign.CampaignStartDate
            txtCampaignEndDate.Text = campaign.CampaignEndDate
            cmvSessionStartDateCampaignStartDate.Enabled = True
            cmvSessionStartDateCampaignEndDate.Enabled = True

            btnClearCampaign.Visible = True

            upHiddenFields.Update()
            upSessionInformation.Update()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divSearchCampaignModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' Disassociates the session from the campaign.
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub ClearCampaign_Click(sender As Object, e As EventArgs) Handles btnClearCampaign.Click

        Try
            hdfCampaignID.Value = String.Empty
            txtCampaignEndDate.Text = String.Empty
            txtCampaignName.Text = String.Empty
            txtCampaignStartDate.Text = String.Empty
            txtCampaignTypeName.Text = String.Empty
            txtEIDSSCampaignID.Text = String.Empty

            cmvSessionEndDateCampaignEndDate.Enabled = False
            cmvSessionEndDateCampaignStartDate.Enabled = False
            cmvSessionStartDateCampaignEndDate.Enabled = False
            cmvSessionStartDateCampaignStartDate.Enabled = False

            lbxDiseaseID.Attributes.Remove("disabled")

            btnClearCampaign.Visible = False

            upSessionInformation.Update()
            upHiddenFields.Update()
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
    Protected Sub Cancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click

        Try
            ScriptManager.RegisterClientScriptBlock(Me, [GetType](), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divWarningModal"), True)
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
    Private Sub ReturnToDashboard_Click(sender As Object, e As EventArgs) Handles btnReturnToDashboard.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            Response.Redirect(GetURL(CallerPages.DashboardURL), True)
            Context.ApplicationInstance.CompleteRequest()
        Catch ae As Threading.ThreadAbortException
            'Response.End = True throws abort exception within Try/Catch.
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
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub ReturnToCampaign_Click(sender As Object, e As EventArgs) Handles btnReturnToCampaign.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            Dim campaign = TryCast(Session(CAMPAIGN_SESSION), VctCampaignGetDetailModel)
            ViewState(CALLER_KEY) = campaign.CampaignID
            SaveEIDSSViewState(ViewState)

            Response.Redirect(GetURL(CallerPages.VeterinaryActiveSurveillanceCampaignURL), True)
            Context.ApplicationInstance.CompleteRequest()
        Catch ae As Threading.ThreadAbortException
            'Response.End = True throws abort exception within Try/Catch.
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
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Delete_Click(sender As Object, e As EventArgs) Handles btnDelete.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            ShowWarningMessage(messageType:=MessageType.ConfirmDeleteMonitoringSession, isConfirm:=True, message:=Nothing)

            hdfWarningMessageType.Value = MessageType.ConfirmDeleteMonitoringSession

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
    Private Function AddUpdateSession() As Boolean

        If Session(FARMS_INVENTORY_LIST) Is Nothing Then
            Session(FARMS_INVENTORY_LIST) = New List(Of VetFarmHerdSpeciesGetListModel)()
        End If
        Dim farmHerdSpecies = CType(Session(FARMS_INVENTORY_LIST), List(Of VetFarmHerdSpeciesGetListModel))

        If Session(DISEASE_LIST) Is Nothing Then
            Session(DISEASE_LIST) = New List(Of VctMonitoringSessionToDiseaseGetListModel)()
        End If

        If Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST) Is Nothing Then
            Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST) = New List(Of VctMonitoringSessionSpeciesToSampleTypeGetListModel)()
        End If

        If Session(ANIMAL_LIST) Is Nothing Then
            Session(ANIMAL_LIST) = New List(Of VetAnimalGetListModel)()
        End If

        If Session(SAMPLE_LIST) Is Nothing Then
            Session(SAMPLE_LIST) = New List(Of GblSampleGetListModel)()
        End If

        If Session(TEST_LIST) Is Nothing Then
            Session(TEST_LIST) = New List(Of GblTestGetListModel)()
        End If

        If Session(INTERPRETATION_LIST) Is Nothing Then
            Session(INTERPRETATION_LIST) = New List(Of GblTestInterpretationGetListModel)()
        End If

        If Session(ACTION_LIST) Is Nothing Then
            Session(ACTION_LIST) = New List(Of VctMonitoringSessionActionGetListModel)()
        End If

        If Session(SUMMARY_LIST) Is Nothing Then
            Session(SUMMARY_LIST) = New List(Of VctMonitoringSessionSummaryGetListModel)()
        End If

        Dim parameters = New MonitoringSessionSetParameters()

        Gather(divHiddenFieldsSection, parameters)
        Gather(divActiveSurveillanceMonitoringSessionForm, parameters)

        parameters.LanguageID = GetCurrentLanguage()
        parameters.AvianOrLivestock = ddlSpeciesType.SelectedItem.Text
        parameters.AuditUserName = EIDSSAuthenticatedUser.UserName
        parameters.EnteredByPersonID = EIDSSAuthenticatedUser.PersonId
        parameters.SiteID = EIDSSAuthenticatedUser.SiteId
        parameters.CountryID = If(MonitoringSessionAddress.SelectedCountryValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CLng(MonitoringSessionAddress.SelectedCountryValue))
        parameters.RayonID = If(MonitoringSessionAddress.SelectedRayonValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CLng(MonitoringSessionAddress.SelectedRayonValue))
        parameters.RegionID = If(MonitoringSessionAddress.SelectedRegionValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CLng(MonitoringSessionAddress.SelectedRegionValue))
        parameters.SettlementID = If((MonitoringSessionAddress.SelectedSettlementValue.IsValueNullOrEmpty() Or MonitoringSessionAddress.SelectedSettlementValue = "-1"), CType(Nothing, Long?), CLng(MonitoringSessionAddress.SelectedSettlementValue))
        parameters.DiseaseCombinations = BuildDiseaseCombinationParameters(CType(Session(DISEASE_LIST), List(Of VctMonitoringSessionToDiseaseGetListModel)))
        parameters.Farms = BuildFarmParameters(CType(Session(FARMS_INVENTORY_LIST), List(Of VetFarmHerdSpeciesGetListModel)).Where(Function(x) x.RecordType = HerdSpeciesConstants.Farm).ToList())
        parameters.HerdsOrFlocks = BuildFlockOrHerdParameters(CType(Session(FARMS_INVENTORY_LIST), List(Of VetFarmHerdSpeciesGetListModel)).Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd).ToList())
        parameters.Species = BuildSpeciesParameters(CType(Session(FARMS_INVENTORY_LIST), List(Of VetFarmHerdSpeciesGetListModel)).Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList())
        parameters.Animals = BuildAnimalParameters(CType(Session(ANIMAL_LIST), List(Of VetAnimalGetListModel)))
        parameters.SpeciesToSampleTypeCombinations = BuildSpeciesToSampleTypeCombinationParameters(CType(Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST), List(Of VctMonitoringSessionSpeciesToSampleTypeGetListModel)))
        parameters.Samples = BuildSampleParameters(CType(Session(SAMPLE_LIST), List(Of GblSampleGetListModel)))
        parameters.Tests = BuildLabTestParameters(CType(Session(TEST_LIST), List(Of GblTestGetListModel)))
        parameters.TestInterpretations = BuildTestInterpretationParameters(CType(Session(INTERPRETATION_LIST), List(Of GblTestInterpretationGetListModel)))
        parameters.Actions = BuildActionParameters(CType(Session(ACTION_LIST), List(Of VctMonitoringSessionActionGetListModel)))
        parameters.Summaries = BuildSummaryParameters(CType(Session(SUMMARY_LIST), List(Of VctMonitoringSessionSummaryGetListModel)))

        If VeterinaryAPIService Is Nothing Then
            VeterinaryAPIService = New VeterinaryServiceClient()
        End If
        Dim returnResults As List(Of VctMonitoringSessionSetModel) = VeterinaryAPIService.SaveMonitoringSessionAsync(parameters).Result

        If returnResults.Count = 0 Then
            ShowErrorMessage(messageType:=MessageType.CannotAddUpdate)
        Else
            If returnResults.FirstOrDefault().ReturnCode = 0 Then
                divAddUpdate.Visible = True
                divSuccessOK.Visible = False
                If hdfMonitoringSessionID.Value = "-1" Then
                    hdfMonitoringSessionID.Value = returnResults.FirstOrDefault().MonitoringSessionID

                    ShowSuccessMessage(messageType:=MessageType.AddUpdateSuccess, message:=GetLocalResourceObject("Lbl_Create_Success") & returnResults.FirstOrDefault().EIDSSSessionID & ".")
                Else
                    ShowSuccessMessage(messageType:=MessageType.AddUpdateSuccess, message:=GetLocalResourceObject("Lbl_Update_Success"))
                End If

                Return True
            Else
                ShowErrorMessage(messageType:=MessageType.CannotAddUpdate, message:=returnResults.FirstOrDefault().ReturnMessage)
            End If
        End If

        Return False

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="diseaseCombinations"></param>
    ''' <returns></returns>
    Private Function BuildDiseaseCombinationParameters(diseaseCombinations As List(Of VctMonitoringSessionToDiseaseGetListModel)) As List(Of MonitoringSessionToDiseaseParameters)

        Dim diseaseCombinationParameters As List(Of MonitoringSessionToDiseaseParameters) = New List(Of MonitoringSessionToDiseaseParameters)()
        Dim diseaseCombinationParameter As MonitoringSessionToDiseaseParameters
        Dim orderNumber As Integer = 0
        Dim monitoringSessionToDiseaseID As Long = 0
        Dim rowAction As String = String.Empty
        Dim rowStatus As String = String.Empty
        Dim selectedItems = lbxDiseaseID.Items.GetSelectedItems()
        lbxDiseaseID.SelectionMode = ListSelectionMode.Single
        lbxDiseaseID.Rows = 1

        'Remove any disease combinations that are currently not selected on the list box.
        For Each diseaseCombination In diseaseCombinations
            If selectedItems.Where(Function(x) x.Value = diseaseCombination.DiseaseID).Count = 0 Then
                diseaseCombinationParameter = New MonitoringSessionToDiseaseParameters()

                With diseaseCombinationParameter
                    .RowAction = RecordConstants.Update
                    .RowStatus = RecordConstants.InactiveRowStatus
                End With

                diseaseCombinationParameters.Add(diseaseCombinationParameter)
            End If
        Next

        For Each item As ListItem In selectedItems
            diseaseCombinationParameter = New MonitoringSessionToDiseaseParameters()

            If diseaseCombinations.Where(Function(x) x.DiseaseID = item.Value).Count = 0 Then
                monitoringSessionToDiseaseID = ((orderNumber + 1) * -1)
                rowAction = RecordConstants.Insert
                rowStatus = RecordConstants.ActiveRowStatus
            Else
                monitoringSessionToDiseaseID = diseaseCombinations.Where(Function(x) x.DiseaseID = item.Value).FirstOrDefault().MonitoringSessionToDiseaseID
                rowAction = RecordConstants.Update
                rowStatus = RecordConstants.ActiveRowStatus
            End If

            With diseaseCombinationParameter
                .MonitoringSessionToDiseaseID = monitoringSessionToDiseaseID
                .DiseaseID = item.Value
                .OrderNumber = (orderNumber + 1)
                .MonitoringSessionID = hdfMonitoringSessionID.Value
                .RowAction = rowAction
                .RowStatus = rowStatus
                .SampleTypeID = Nothing
                .SpeciesTypeID = Nothing
            End With

            diseaseCombinationParameters.Add(diseaseCombinationParameter)
        Next

        Return diseaseCombinationParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="farms"></param>
    ''' <returns></returns>
    Private Function BuildFarmParameters(farms As List(Of VetFarmHerdSpeciesGetListModel)) As List(Of FarmParameters)

        Dim farmParameters As List(Of FarmParameters) = New List(Of FarmParameters)()
        Dim farmParameter As FarmParameters

        For Each farmModel As VetFarmHerdSpeciesGetListModel In farms
            farmParameter = New FarmParameters()
            With farmParameter
                .DeadAnimalQuantity = farmModel.DeadAnimalQuantity
                .EIDSSFarmID = farmModel.EIDSSFarmID
                .FarmID = farmModel.FarmID
                .FarmMasterID = farmModel.FarmMasterID
                .SickAnimalQuantity = farmModel.SickAnimalQuantity
                .TotalAnimalQuantity = farmModel.TotalAnimalQuantity
                .RowAction = farmModel.RowAction
                .RowStatus = farmModel.RowStatus
            End With

            farmParameters.Add(farmParameter)
        Next

        Return farmParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="herds"></param>
    ''' <returns></returns>
    Private Function BuildFlockOrHerdParameters(herds As List(Of VetFarmHerdSpeciesGetListModel)) As List(Of HerdParameters)

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
                .RowAction = herdModel.RowAction
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
    ''' <returns></returns>
    Private Function BuildSpeciesParameters(species As List(Of VetFarmHerdSpeciesGetListModel)) As List(Of SpeciesParameters)

        Dim speciesParameters As List(Of SpeciesParameters) = New List(Of SpeciesParameters)()
        Dim speciesParameter As SpeciesParameters

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
                .RowAction = speciesModel.RowAction
                .RowStatus = speciesModel.RowStatus
            End With

            speciesParameters.Add(speciesParameter)
        Next

        Return speciesParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="speciesToSampleTypeCombinations"></param>
    ''' <returns></returns>
    Private Function BuildSpeciesToSampleTypeCombinationParameters(speciesToSampleTypeCombinations) As List(Of MonitoringSessionSpeciesToSampleTypeParameters)

        Dim speciesToSampleTypeParameters As List(Of MonitoringSessionSpeciesToSampleTypeParameters) = New List(Of MonitoringSessionSpeciesToSampleTypeParameters)()
        Dim speciesToSampleTypeParameter As MonitoringSessionSpeciesToSampleTypeParameters

        For Each speciesToSampleTypeModel As VctMonitoringSessionSpeciesToSampleTypeGetListModel In speciesToSampleTypeCombinations
            speciesToSampleTypeParameter = New MonitoringSessionSpeciesToSampleTypeParameters()
            With speciesToSampleTypeParameter
                .MonitoringSessionToSampleTypeID = speciesToSampleTypeModel.MonitoringSessionToSampleTypeID
                .OrderNumber = speciesToSampleTypeModel.OrderNumber
                .MonitoringSessionID = speciesToSampleTypeModel.MonitoringSessionID
                .RowAction = speciesToSampleTypeModel.RowAction
                .RowStatus = speciesToSampleTypeModel.RowStatus
                .SampleTypeID = speciesToSampleTypeModel.SampleTypeID
                .SpeciesTypeID = speciesToSampleTypeModel.SpeciesTypeID
            End With

            speciesToSampleTypeParameters.Add(speciesToSampleTypeParameter)
        Next

        Return speciesToSampleTypeParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="animals"></param>
    ''' <returns></returns>
    Private Function BuildAnimalParameters(animals As List(Of VetAnimalGetListModel)) As List(Of AnimalParameters)

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
                .RowAction = animalModel.RowAction
                .RowStatus = animalModel.RowStatus
            End With

            animalParameters.Add(animalParameter)
        Next

        Return animalParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="samples"></param>
    ''' <returns></returns>
    Private Function BuildSampleParameters(samples As List(Of GblSampleGetListModel)) As List(Of VeterinarySampleParameters)

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
                .RowAction = sampleModel.RowAction
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
    ''' <param name="labTests"></param>
    ''' <returns></returns>
    Private Function BuildLabTestParameters(labTests As List(Of GblTestGetListModel)) As List(Of LabTestParameters)

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
                .RowAction = labTestModel.RowAction
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
    ''' <returns></returns>
    Private Function BuildTestInterpretationParameters(testInterpretations As List(Of GblTestInterpretationGetListModel)) As List(Of TestInterpretationParameters)

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
                .RowAction = testIntepretationModel.RowAction
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
    ''' <param name="actions"></param>
    ''' <returns></returns>
    Private Function BuildActionParameters(actions As List(Of VctMonitoringSessionActionGetListModel)) As List(Of MonitoringSessionActionParameters)

        Dim actionParameters As List(Of MonitoringSessionActionParameters) = New List(Of MonitoringSessionActionParameters)()
        Dim actionParameter As MonitoringSessionActionParameters

        For Each actionModel As VctMonitoringSessionActionGetListModel In actions
            actionParameter = New MonitoringSessionActionParameters()
            With actionParameter
                .ActionDate = actionModel.ActionDate
                .ActionStatusTypeID = actionModel.MonitoringSessionActionStatusTypeID
                .ActionTypeID = actionModel.MonitoringSessionActionTypeID
                .Comments = actionModel.Comments
                .EnteredByPersonID = actionModel.EnteredByPersonID
                .MonitoringSessionActionID = actionModel.MonitoringSessionActionID
                .MonitoringSessionID = actionModel.MonitoringSessionID
                .RowAction = actionModel.RowAction
                .RowStatus = actionModel.RowStatus
            End With

            actionParameters.Add(actionParameter)
        Next

        Return actionParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="summaries"></param>
    ''' <returns></returns>
    Private Function BuildSummaryParameters(summaries As List(Of VctMonitoringSessionSummaryGetListModel)) As List(Of MonitoringSessionSummaryParameters)

        Dim summaryParameters As List(Of MonitoringSessionSummaryParameters) = New List(Of MonitoringSessionSummaryParameters)()
        Dim summaryParameter As MonitoringSessionSummaryParameters

        For Each summaryModel As VctMonitoringSessionSummaryGetListModel In summaries
            summaryParameter = New MonitoringSessionSummaryParameters()
            With summaryParameter
                .AnimalGenderTypeID = summaryModel.AnimalGenderTypeID
                .CollectionDate = summaryModel.CollectionDate
                .DiseaseID = summaryModel.DiseaseID
                .FarmID = summaryModel.FarmID
                .MonitoringSessionID = summaryModel.MonitoringSessionID
                .MonitoringSessionSummaryID = summaryModel.MonitoringSessionSummaryID
                .PositiveAnimalsQuantity = summaryModel.PositiveAnimalsQuantity
                .MonitoringSessionID = summaryModel.MonitoringSessionID
                .RowAction = summaryModel.RowAction
                .RowStatus = summaryModel.RowStatus
            End With

            summaryParameters.Add(summaryParameter)
        Next

        Return summaryParameters

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub DisplaySessionValidationErrors()

        'Paint all SideBarItems as passed validation and then correct those that failed.
        sbiActions.ItemStatus = SideBarStatus.IsValid
        sbiAggregateInfo.ItemStatus = SideBarStatus.IsValid
        sbiDetailedInformation.ItemStatus = SideBarStatus.IsValid
        sbiDiseaseReports.ItemStatus = SideBarStatus.IsValid
        sbiSessionInformation.ItemStatus = SideBarStatus.IsValid
        sbiDetailedTests.ItemStatus = SideBarStatus.IsValid

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
                        Case "DetailedInformation"
                            sbiDetailedInformation.ItemStatus = SideBarStatus.IsInvalid
                            sbiDetailedInformation.CssClass = "glyphicon glyphicon-remove"
                        Case "DiseaseReports"
                            sbiDiseaseReports.ItemStatus = SideBarStatus.IsInvalid
                            sbiDiseaseReports.CssClass = "glyphicon glyphicon-remove"
                        Case "SessionInfo"
                            sbiSessionInformation.ItemStatus = SideBarStatus.IsInvalid
                            sbiSessionInformation.CssClass = "glyphicon glyphicon-remove"
                        Case "TestsResultSummaries"
                            sbiDetailedTests.ItemStatus = SideBarStatus.IsInvalid
                            sbiDetailedTests.CssClass = "glyphicon glyphicon-remove"
                    End Select
                End If
            End If
        Next

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="edit"></param>
    Private Sub FillForm(edit As Boolean)

        If CrossCuttingAPIService Is Nothing Then
            CrossCuttingAPIService = New CrossCuttingServiceClient()
        End If

        If DiseaseGroupDiseaseAPIService Is Nothing Then
            DiseaseGroupDiseaseAPIService = New DiseaseGroupDiseaseServiceClient()
        End If

        FillBaseReferenceDropDownList(ddlMonitoringSessionStatusTypeID, BaseReferenceConstants.ASSessionStatus, (HACodeList.LivestockHACode + HACodeList.AvianHACode), False)
        If ((ddlMonitoringSessionStatusTypeID.Items.Count > 0) AndAlso (ddlMonitoringSessionStatusTypeID.Items.Contains(ddlMonitoringSessionStatusTypeID.Items.FindByText("Open")))) Then
            ddlMonitoringSessionStatusTypeID.ClearSelection()
            ddlMonitoringSessionStatusTypeID.Items.FindByText("Open").Selected = True
        End If

        Dim diseaseGroups As List(Of ConfDiseasegroupdiseasematrixGetlistModel) = DiseaseGroupDiseaseAPIService.ConfDiseasegroupdiseasematrixGetlist(GetCurrentLanguage(), DiagnosisGroups.Anthrax).Result
        diseaseGroups.AddRange(DiseaseGroupDiseaseAPIService.ConfDiseasegroupdiseasematrixGetlist(GetCurrentLanguage(), DiagnosisGroups.Plague).Result)
        diseaseGroups.AddRange(DiseaseGroupDiseaseAPIService.ConfDiseasegroupdiseasematrixGetlist(GetCurrentLanguage(), DiagnosisGroups.Tularemia).Result)

        Session(DIAGNSOSIS_GROUP_LIST) = diseaseGroups

        PopulateAvianLiveStock()

        If Not hdfMonitoringSessionID.Value = -1 Then 'editing the session record
            If VeterinaryAPIService Is Nothing Then
                VeterinaryAPIService = New VeterinaryServiceClient()
            End If

            Dim monitoringSession = VeterinaryAPIService.GetMonitoringSessionDetailAsync(GetCurrentLanguage, hdfMonitoringSessionID.Value).Result
            MonitoringSessionAddress.LocationCountryID = monitoringSession.FirstOrDefault().CountryID
            MonitoringSessionAddress.LocationRegionID = monitoringSession.FirstOrDefault().RegionID
            MonitoringSessionAddress.LocationRayonID = monitoringSession.FirstOrDefault().RayonID
            MonitoringSessionAddress.LocationSettlementID = monitoringSession.FirstOrDefault().SettlementID
            MonitoringSessionAddress.Setup(CrossCuttingAPIService)

            If monitoringSession.FirstOrDefault().AvianOrLivestock = HACodeList.Avian Then
                ddlSpeciesType.SelectedValue = HACodeList.AvianHACode
                btnAddFlock.Visible = True
                btnAddHerd.Visible = False
            Else
                ddlSpeciesType.SelectedValue = HACodeList.LivestockHACode
                btnAddFlock.Visible = False
                btnAddHerd.Visible = True
            End If

            Scatter(divActiveSurveillanceMonitoringSessionForm, monitoringSession.FirstOrDefault())
            Scatter(divHiddenFieldsSection, monitoringSession.FirstOrDefault())

            txtSec2EIDSSSessionID.Text = monitoringSession.FirstOrDefault().EIDSSSessionID
            txtSec2DiseaseName.Text = monitoringSession.FirstOrDefault().DiseaseName
            txtSec2SessionStatusTypeName.Text = monitoringSession.FirstOrDefault().SessionStatusTypeName
            txtSec3EIDSSSessionID.Text = monitoringSession.FirstOrDefault().EIDSSSessionID
            txtSec3DiseaseName.Text = monitoringSession.FirstOrDefault().DiseaseName
            txtSec3SessionStatusTypeName.Text = monitoringSession.FirstOrDefault().SessionStatusTypeName
            txtSec4EIDSSSessionID.Text = monitoringSession.FirstOrDefault().EIDSSSessionID
            txtSec4DiseaseName.Text = monitoringSession.FirstOrDefault().DiseaseName
            txtSec4SessionStatusTypeName.Text = monitoringSession.FirstOrDefault().SessionStatusTypeName
            txtSec5EIDSSSessionID.Text = monitoringSession.FirstOrDefault().EIDSSSessionID
            txtSec5DiseaseName.Text = monitoringSession.FirstOrDefault().DiseaseName
            txtSec5SessionStatusTypeName.Text = monitoringSession.FirstOrDefault().SessionStatusTypeName
            txtSec6EIDSSSessionID.Text = monitoringSession.FirstOrDefault().EIDSSSessionID
            txtSec6DiseaseName.Text = monitoringSession.FirstOrDefault().DiseaseName
            txtSec6SessionStatusTypeName.Text = monitoringSession.FirstOrDefault().SessionStatusTypeName

            txtActionEnteredByPersonName.Text = EIDSSAuthenticatedUser.LastName & ", " & EIDSSAuthenticatedUser.FirstName & " " & EIDSSAuthenticatedUser.SecondName

            'Fill the species/samples based on campaign associated with sessions
            If Not monitoringSession.FirstOrDefault().CampaignID Is Nothing Then
                Session(CAMPAIGN_SESSION) = GetCampaignSpecifications(monitoringSession.FirstOrDefault().CampaignID)
                Dim campaign = TryCast(Session(CAMPAIGN_SESSION), VctCampaignGetDetailModel)
                txtCampaignName.Text = campaign.CampaignName
                txtCampaignTypeName.Text = campaign.CampaignTypeName
                txtEIDSSCampaignID.Text = campaign.EIDSSCampaignID
                hdfCampaignID.Value = campaign.CampaignID
                lbxDiseaseID.DataBind()
                lbxDiseaseID.Items.Add(New ListItem With {.Value = campaign.DiseaseID, .Text = campaign.DiseaseName})
                lbxDiseaseID.Attributes.Add("disabled", "")

                txtCampaignStartDate.Text = campaign.CampaignStartDate
                txtCampaignEndDate.Text = campaign.CampaignEndDate
                cmvSessionStartDateCampaignStartDate.Enabled = True
                cmvSessionStartDateCampaignEndDate.Enabled = True
            End If

            FillDropDowns()
            SpeciesType_SelectedIndexChanged(Nothing, Nothing)

            FillDiseaseCombinations(refresh:=True)
            DiseaseID_SelectedIndexChanged(Nothing, Nothing)

            FillSpeciesToSampleTypeCombinations(refresh:=True)
            FillSamples(refresh:=True)
            FillTests(refresh:=True)
            FillResultSummaries(refresh:=True)
            FillActions(refresh:=True)
            FillAggregateInfo(refresh:=True)
            FillVeterinaryDiseaseReportsList(refresh:=True)

            upDetailedAnimalsAndSamples.Update()
        Else
            txtEnteredByPersonName.Text = EIDSSAuthenticatedUser.LastName & ", " & EIDSSAuthenticatedUser.FirstName
            txtSiteName.Text = EIDSSAuthenticatedUser.Organization
            txtEnteredDate.Text = Date.Today

            MonitoringSessionAddress.Setup(CrossCuttingAPIService)

            FillSpeciesToSampleTypeCombinations(refresh:=True)

            If ViewState(CALLER).Equals(CallerPages.VeterinaryActiveSurveillanceCampaignNewMonitoringSession) Then
                If Not Session(CAMPAIGN_SESSION) Is Nothing Then
                    Dim campaign = TryCast(Session(CAMPAIGN_SESSION), List(Of VctCampaignGetDetailModel))
                    txtCampaignName.Text = campaign.FirstOrDefault().CampaignName
                    txtCampaignTypeName.Text = campaign.FirstOrDefault().CampaignTypeName
                    txtEIDSSCampaignID.Text = campaign.FirstOrDefault().EIDSSCampaignID
                    hdfCampaignID.Value = campaign.FirstOrDefault().CampaignID
                    lbxDiseaseID.DataBind()
                    lbxDiseaseID.Items.Add(New ListItem With {.Value = campaign.FirstOrDefault().DiseaseID, .Text = campaign.FirstOrDefault().DiseaseName})
                    lbxDiseaseID.Attributes.Add("disabled", "")

                    txtCampaignStartDate.Text = If(campaign.FirstOrDefault().CampaignStartDate, String.Empty)
                    txtCampaignEndDate.Text = If(campaign.FirstOrDefault().CampaignEndDate, String.Empty)
                    cmvSessionStartDateCampaignStartDate.Enabled = True
                    cmvSessionStartDateCampaignEndDate.Enabled = True
                End If
            End If
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillDropDowns()

        If CrossCuttingAPIService Is Nothing Then
            CrossCuttingAPIService = New CrossCuttingServiceClient()
        End If
        Dim list As List(Of GblOrganizationByTypeGetListModel) = CrossCuttingAPIService.OrganizationByTypeGetListAsync(GetCurrentLanguage(), OrganizationTypes.Laboratory).Result
        FillDropDownList(ddlSampleSentToOrganizationID, list, {GlobalConstants.NullValue}, OrganizationConstants.OrganizationID, OrganizationConstants.OrganizationName, Nothing, Nothing, True)

        FillBaseReferenceDropDownList(ddlActionMonitoringSessionActionStatusTypeID, BaseReferenceConstants.ASSessionActionStatus, HACodeList.LivestockHACode, True)
        FillBaseReferenceDropDownList(ddlActionMonitoringSessionActionTypeID, BaseReferenceConstants.ASSessionActionType, HACodeList.LivestockHACode, True)

        FillBaseReferenceDropDownList(ddlAggregateInfoAnimalGenderTypeID, BaseReferenceConstants.AnimalSex, HACodeList.LivestockHACode, True)

        FillTestNameType()
        FillTestResultType()

        For Each item In lbxDiseaseID.Items
            ddlAggregateInfoDiseaseID.Items.Add(item)
        Next

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="campaignID"></param>
    ''' <returns></returns>
    Private Function GetCampaignSpecifications(Optional campaignID As String = "") As VctCampaignGetDetailModel

        If VeterinaryAPIService Is Nothing Then
            VeterinaryAPIService = New VeterinaryServiceClient()
        End If

        Dim campaign = VeterinaryAPIService.GetCampaignDetailAsync(GetCurrentLanguage(), campaignID).Result

        Dim speciesToSampleTypes = New List(Of VctCampaignSpeciesToSampleTypeGetListModel)()

        speciesToSampleTypes = VeterinaryAPIService.GetCampaignSpeciesToSampleTypeListAsync(GetCurrentLanguage(), campaignID).Result
        Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST) = speciesToSampleTypes

        Scatter(divHiddenFieldsSection, campaign)

        Return campaign.FirstOrDefault()

    End Function

#End Region

#Region "Diseases Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refresh"></param>
    Private Sub FillDiseaseCombinations(ByVal refresh As Boolean)

        Try
            Dim diseaseCombinations = New List(Of VctMonitoringSessionToDiseaseGetListModel)()

            If refresh Then Session(DISEASE_LIST) = Nothing

            If IsNothing(Session(DISEASE_LIST)) Then
                If VeterinaryAPIService Is Nothing Then
                    VeterinaryAPIService = New VeterinaryServiceClient()
                End If
                diseaseCombinations = VeterinaryAPIService.GetMonitoringSessionToDiseaseListAsync(GetCurrentLanguage(), hdfMonitoringSessionID.Value).Result
                Session(DISEASE_LIST) = diseaseCombinations
            Else
                diseaseCombinations = CType(Session(DISEASE_LIST), List(Of VctMonitoringSessionToDiseaseGetListModel))
            End If

            For Each diseaseCombination In diseaseCombinations
                lbxDiseaseID.Items.FindByValue(diseaseCombination.DiseaseID).Selected = True
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Species To Sample Type Combination Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refresh"></param>
    Private Sub FillSpeciesToSampleTypeCombinations(ByVal refresh As Boolean)

        Try
            Dim speciesToSampleTypeCombinations = New List(Of VctMonitoringSessionSpeciesToSampleTypeGetListModel)()

            If refresh Then Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST) = Nothing

            If IsNothing(Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST)) Then
                If VeterinaryAPIService Is Nothing Then
                    VeterinaryAPIService = New VeterinaryServiceClient()
                End If
                speciesToSampleTypeCombinations = VeterinaryAPIService.GetMonitoringSessionSpeciesToSampleTypeListAsync(GetCurrentLanguage(), hdfMonitoringSessionID.Value).Result
                Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST) = speciesToSampleTypeCombinations
            Else
                speciesToSampleTypeCombinations = CType(Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST), List(Of VctMonitoringSessionSpeciesToSampleTypeGetListModel))
            End If

            gvSpeciesAndSamples.DataSource = Nothing
            gvSpeciesAndSamples.DataSource = speciesToSampleTypeCombinations
            gvSpeciesAndSamples.DataBind()

            ddlSampleSampleTypeID.Items.Clear()
            ddlSampleSampleTypeID.Items.Add(New ListItem With {.Text = String.Empty, .Value = GlobalConstants.NullValue.ToLower()})
            For Each combination In speciesToSampleTypeCombinations
                ddlSampleSampleTypeID.Items.Add(New ListItem With {.Text = combination.SampleTypeName, .Value = combination.SampleTypeID})
            Next

            ddlAggregateInfoSampleTypeID.Items.Clear()
            ddlAggregateInfoSampleTypeID.Items.Add(New ListItem With {.Text = String.Empty, .Value = GlobalConstants.NullValue.ToLower()})
            For Each combination In speciesToSampleTypeCombinations
                ddlAggregateInfoSampleTypeID.Items.Add(New ListItem With {.Text = combination.SampleTypeName, .Value = combination.SampleTypeID})
            Next

            If speciesToSampleTypeCombinations.Count = 0 Then
                'Filter based on disease to sample type matrix (EUR8500).
                If DiseaseSampleTypeMatrixAPIService Is Nothing Then
                    DiseaseSampleTypeMatrixAPIService = New DiseaseSampleTypeServiceClient()
                End If
                Dim diseaseSampleTypeMatrix As List(Of ConfDiseasesampletypematrixGetlistModel) = DiseaseSampleTypeMatrixAPIService.GetConfDiseasesampletypematrices(GetCurrentLanguage()).Result

                For Each matrice In diseaseSampleTypeMatrix
                    ddlSampleSampleTypeID.Items.Add(New ListItem With {.Text = matrice.strSampleType, .Value = matrice.idfsSampleType})
                Next
            ElseIf speciesToSampleTypeCombinations.Count = 1 Then
                ddlSampleSampleTypeID.SelectedValue = speciesToSampleTypeCombinations.FirstOrDefault().SampleTypeID
                ddlSampleSampleTypeID.Enabled = False

                ddlAggregateInfoSampleTypeID.SelectedValue = speciesToSampleTypeCombinations.FirstOrDefault().SampleTypeID
                ddlAggregateInfoSampleTypeID.Enabled = False
            Else
                ddlSampleSampleTypeID.SelectedIndex = 0
                ddlSampleSampleTypeID.Enabled = True

                ddlAggregateInfoSampleTypeID.SelectedIndex = 0
                ddlAggregateInfoSampleTypeID.Enabled = True
            End If

            upDetailedAnimalsAndSamples.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="rowAction"></param>
    ''' <param name="rowID"></param>
    ''' <param name="monitoringSessionID"></param>
    ''' <param name="sampleTypeID"></param>
    ''' <param name="sampleTypeName"></param>
    ''' <param name="speciesTypeID"></param>
    ''' <param name="speciesTypeName"></param>
    Private Sub AddUpdateSpeciesAndSampleRow(ByVal rowAction As String,
                                             ByVal rowID As Integer,
                                             ByVal monitoringSessionID As Long,
                                             ByVal sampleTypeID As Long,
                                             ByVal sampleTypeName As String,
                                             ByVal speciesTypeID As Long,
                                             ByVal speciesTypeName As String)

        Dim speciesSampleTypeCombinations = TryCast(Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST), List(Of VctMonitoringSessionSpeciesToSampleTypeGetListModel))
        Dim speciesSampleTypeCombination As VctMonitoringSessionSpeciesToSampleTypeGetListModel = New VctMonitoringSessionSpeciesToSampleTypeGetListModel()

        If rowAction = RecordConstants.Read Or Not rowID = "0" Then
            speciesSampleTypeCombination = speciesSampleTypeCombinations.Where(Function(x) x.MonitoringSessionToSampleTypeID = rowID).First
        End If

        speciesSampleTypeCombination.MonitoringSessionID = monitoringSessionID
        speciesSampleTypeCombination.SampleTypeID = sampleTypeID
        speciesSampleTypeCombination.SampleTypeName = sampleTypeName
        speciesSampleTypeCombination.SpeciesTypeID = speciesTypeID
        speciesSampleTypeCombination.SpeciesTypeName = speciesTypeName

        If rowAction = RecordConstants.Read Or Not rowID = "0" Then
            If speciesSampleTypeCombination.MonitoringSessionToSampleTypeID > 0 Then
                speciesSampleTypeCombination.RowAction = RecordConstants.Update
            End If
        Else
            hdfIdentity.Value += 1
            Dim identity As Integer = (hdfIdentity.Value * -1)
            speciesSampleTypeCombination.MonitoringSessionToSampleTypeID = identity
            speciesSampleTypeCombination.OrderNumber = speciesSampleTypeCombinations.Count + 1
            speciesSampleTypeCombination.RowStatus = RecordConstants.ActiveRowStatus
            speciesSampleTypeCombination.RowAction = RecordConstants.Insert
            speciesSampleTypeCombinations.Add(speciesSampleTypeCombination)
        End If

        Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST) = speciesSampleTypeCombinations
        FillSpeciesToSampleTypeCombinations(refresh:=False)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub SpeciesAndSamples_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSpeciesAndSamples.RowCommand

        Try
            e.Handled = True

            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    hdfRowID.Value = e.CommandArgument
                    hdfWarningMessageType.Value = MessageType.ConfirmDeleteSpeciesToSampleType
                    ShowWarningMessage(MessageType.ConfirmDeleteSpeciesToSampleType, True)
                    upHiddenFields.Update()
                Case GridViewCommandConstants.EditCommand
                    Dim speciesToSampleTypes = CType(Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST), List(Of VctMonitoringSessionSpeciesToSampleTypeGetListModel))
                    Dim speciesToSampleType = speciesToSampleTypes.Where(Function(x) x.MonitoringSessionToSampleTypeID = e.CommandArgument).FirstOrDefault
                    Dim gvr As GridViewRow = CType(e.CommandSource, LinkButton).NamingContainer
                    Dim ddlEditSpeciesTypeID As DropDownList = gvr.FindControl("ddlEditSpeciesTypeID")
                    Dim ddlEditSampleTypeID As DropDownList = gvr.FindControl("ddlEditSampleTypeID")
                    If Not speciesToSampleType Is Nothing Then
                        ddlEditSpeciesTypeID.SelectedValue = If(speciesToSampleType.SpeciesTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue, speciesToSampleType.SpeciesTypeID)
                        ddlEditSpeciesTypeID.Enabled = True
                        ddlEditSampleTypeID.SelectedValue = If(speciesToSampleType.SampleTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue, speciesToSampleType.SampleTypeID)
                        ddlEditSampleTypeID.Enabled = True

                        hdfRowID.Value = speciesToSampleType.MonitoringSessionToSampleTypeID
                        hdfRowAction.Value = speciesToSampleType.RowAction.ToString
                    End If
            End Select
            upSessionInformation.Update()
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
    Private Sub SpeciesAndSamples_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvSpeciesAndSamples.RowDataBound

        Try
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim speciesToSampleType As VctMonitoringSessionSpeciesToSampleTypeGetListModel = TryCast(e.Row.DataItem, VctMonitoringSessionSpeciesToSampleTypeGetListModel)
                If Not speciesToSampleType Is Nothing Then
                    Dim ddl As DropDownList = CType(e.Row.FindControl("ddlEditSpeciesTypeID"), DropDownList)
                    FillBaseReferenceDropDownList(ddl, BaseReferenceConstants.SpeciesList, HACodeList.AllHACode, False)
                    ddl.SelectedValue = speciesToSampleType.SpeciesTypeID
                    ddl.Enabled = False

                    ddl = CType(e.Row.FindControl("ddlEditSampleTypeID"), DropDownList)
                    FillBaseReferenceDropDownList(ddl, BaseReferenceConstants.SampleType, HACodeList.AllHACode, True)
                    ddl.SelectedValue = speciesToSampleType.SampleTypeID
                    ddl.Enabled = False
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
    Protected Sub DiseaseID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles lbxDiseaseID.SelectedIndexChanged

        Try
            ' Determine avian/livestock selection based on disease selection to populate species and samples based on the selection.
            If Not lbxDiseaseID.SelectedValue.IsValueNullOrEmpty() = False Then
                If CrossCuttingAPIService Is Nothing Then
                    CrossCuttingAPIService = New CrossCuttingServiceClient()
                End If

                Dim diseaseGroups = TryCast(Session(DIAGNSOSIS_GROUP_LIST), List(Of ConfDiseasegroupdiseasematrixGetlistModel))
                Dim selectedItems = lbxDiseaseID.Items.GetSelectedItems()
                lbxDiseaseID.SelectionMode = ListSelectionMode.Single
                lbxDiseaseID.Rows = 1

                If selectedItems.Count > 0 Then
                    For Each item As ListItem In selectedItems
                        If item.Value.IsValueNullOrEmpty() = False Then
                            If diseaseGroups.Where(Function(x) x.idfsDiagnosis = item.Value).Count > 0 Then
                                lbxDiseaseID.SelectionMode = ListSelectionMode.Multiple
                                lbxDiseaseID.Rows = 5
                            End If
                        End If
                    Next
                End If
            End If

            ddlAggregateInfoDiseaseID.Items.Clear()
            For Each item As ListItem In lbxDiseaseID.Items
                ddlAggregateInfoDiseaseID.Items.Add(New ListItem With {.Text = item.Text, .Value = item.Value})
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub PopulateAvianLiveStock()

        ddlSpeciesType.SelectedValue = Nothing
        ddlSpeciesType.Items.Clear()

        Dim items As List(Of ListItem) = New List(Of ListItem) From {
            New ListItem With {.Text = String.Empty, .Value = GlobalConstants.NullValue.ToLower()},
            New ListItem With {.Text = HACodeList.Avian, .Value = HACodeList.AvianHACode},
            New ListItem With {.Text = HACodeList.Livestock, .Value = HACodeList.LivestockHACode}
        }

        ddlSpeciesType.DataTextField = "Text"
        ddlSpeciesType.DataValueField = "Value"
        ddlSpeciesType.DataSource = items
        ddlSpeciesType.DataBind()
        ddlSpeciesType.SelectedIndex = -1

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub SpeciesType_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlSpeciesType.SelectedIndexChanged

        Try
            ddlAggregateInfoSampleTypeID.Items.Clear()
            ddlAggregateInfoSampleTypeID.Items.Add(New ListItem With {.Value = GlobalConstants.NullValue.ToLower(), .Text = String.Empty, .Selected = False})

            Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST) = New List(Of VctMonitoringSessionSpeciesToSampleTypeGetListModel)()
            FillSpeciesToSampleTypeCombinations(refresh:=False)

            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If

            If (ddlSpeciesType.SelectedValue = HACodeList.AvianHACode.ToString()) Then
                If hdfCampaignID.Value.IsValueNullOrEmpty() Then
                    Dim diseases = CrossCuttingAPIService.GetBaseReferenceList(GetCurrentLanguage(), BaseReferenceConstants.Diagnosis, HACodeList.AvianHACode).Result
                    lbxDiseaseID.DataSource = diseases
                    lbxDiseaseID.DataTextField = "name"
                    lbxDiseaseID.DataValueField = "idfsBaseReference"
                    lbxDiseaseID.DataBind()
                    lbxDiseaseID.Items.Insert(0, New ListItem With {.Value = GlobalConstants.NullValue.ToLower(), .Text = String.Empty})
                End If

                Session(ANIMAL_LIST) = New List(Of VetAnimalGetListModel)()

                PopulateDetailsSpeciesAndSamples()

                divAggregateInfoAnimalContainer.Visible = False

                FillBaseReferenceDropDownList(ddlLabTestTestCategoryTypeID, BaseReferenceConstants.TestCategory, HACodeList.AvianHACode, True)
                ddlLabTestTestCategoryTypeID.DataSource = SortDropDownList(ddlLabTestTestCategoryTypeID).Items

                FillBaseReferenceDropDownList(ddlLabTestTestNameTypeID, BaseReferenceConstants.TestName, HACodeList.AvianHACode, True)
                ddlLabTestTestNameTypeID.DataSource = SortDropDownList(ddlLabTestTestNameTypeID).Items

                FillBaseReferenceDropDownList(ddlLabTestTestResultTypeID, BaseReferenceConstants.TestResult, HACodeList.AvianHACode, True)
                ddlLabTestTestResultTypeID.DataSource = SortDropDownList(ddlLabTestTestResultTypeID).Items

                FillBaseReferenceDropDownList(ddlResultSummaryInterpretedStatusTypeID, BaseReferenceConstants.RuleInValueforTestValidation, HACodeList.AvianHACode, True)
            Else
                If hdfCampaignID.Value.IsValueNullOrEmpty Then
                    Dim diseases = CrossCuttingAPIService.GetBaseReferenceList(GetCurrentLanguage(), BaseReferenceConstants.Diagnosis, HACodeList.LivestockHACode).Result
                    lbxDiseaseID.DataSource = diseases
                    lbxDiseaseID.DataTextField = "name"
                    lbxDiseaseID.DataValueField = "idfsBaseReference"
                    lbxDiseaseID.DataBind()
                    lbxDiseaseID.Items.Insert(0, New ListItem With {.Value = GlobalConstants.NullValue.ToLower(), .Text = String.Empty})
                End If

                FillAnimals(refresh:=True)

                PopulateDetailsSpeciesAndSamples()

                FillBaseReferenceDropDownList(ddlSampleAnimalAgeTypeID, BaseReferenceConstants.AnimalAge, HACodeList.LivestockHACode, True)
                ddlSampleAnimalAgeTypeID = SortDropDownList(ddlSampleAnimalAgeTypeID)
                FillBaseReferenceDropDownList(ddlSampleAnimalGenderTypeID, BaseReferenceConstants.AnimalSex, HACodeList.LivestockHACode, True)
                ddlSampleAnimalGenderTypeID = SortDropDownList(ddlSampleAnimalGenderTypeID)

                FillBaseReferenceDropDownList(ddlSampleAnimalGenderTypeID, BaseReferenceConstants.AnimalSex, HACodeList.LivestockHACode, True)
                ddlSampleAnimalGenderTypeID = SortDropDownList(ddlSampleAnimalGenderTypeID)

                divAggregateInfoAnimalContainer.Visible = True

                FillBaseReferenceDropDownList(ddlLabTestTestCategoryTypeID, BaseReferenceConstants.TestCategory, HACodeList.LivestockHACode, True)
                ddlLabTestTestCategoryTypeID.DataSource = SortDropDownList(ddlLabTestTestCategoryTypeID).Items

                FillBaseReferenceDropDownList(ddlLabTestTestNameTypeID, BaseReferenceConstants.TestName, HACodeList.LivestockHACode, True)
                ddlLabTestTestNameTypeID.DataSource = SortDropDownList(ddlLabTestTestNameTypeID).Items

                FillBaseReferenceDropDownList(ddlLabTestTestResultTypeID, BaseReferenceConstants.TestResult, HACodeList.LivestockHACode, True)
                ddlLabTestTestResultTypeID.DataSource = SortDropDownList(ddlLabTestTestResultTypeID).Items

                FillBaseReferenceDropDownList(ddlResultSummaryInterpretedStatusTypeID, BaseReferenceConstants.RuleInValueforTestValidation, HACodeList.LivestockHACode, True)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub PopulateDetailsSpeciesAndSamples()

        If CrossCuttingAPIService Is Nothing Then
            CrossCuttingAPIService = New CrossCuttingServiceClient()
        End If

        Dim sampleTypes As List(Of GblLkupBaseRefGetListModel) = CrossCuttingAPIService.GetBaseReferenceList(GetCurrentLanguage(), BaseReferenceConstants.SampleType, HACodeList.AllHACode).Result
        Dim speciesTypes As List(Of GblLkupBaseRefGetListModel) = CrossCuttingAPIService.GetBaseReferenceList(GetCurrentLanguage(), BaseReferenceConstants.SpeciesList, HACodeList.AllHACode).Result

        Dim speciesSampleTypeCombinations = TryCast(Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST), List(Of VctMonitoringSessionSpeciesToSampleTypeGetListModel))

        ddlSampleSampleTypeID.Items.Clear()
        ddlSampleSampleTypeID.Items.Add(New ListItem With {.Text = String.Empty, .Value = GlobalConstants.NullValue.ToLower()})

        Select Case ddlSpeciesType.SelectedValue
            Case HACodeList.LivestockHACode
                sampleTypes = CrossCuttingAPIService.GetBaseReferenceList(GetCurrentLanguage(), BaseReferenceConstants.SampleType, HACodeList.LivestockHACode).Result
                speciesTypes = CrossCuttingAPIService.GetBaseReferenceList(GetCurrentLanguage(), BaseReferenceConstants.SpeciesList, HACodeList.LivestockHACode).Result
                FillDropDownList(ddlInsertSampleTypeID, sampleTypes, Nothing, BaseReferenceConstants.idfsBaseReference, BaseReferenceConstants.Name, blankRow:=True)
                FillDropDownList(ddlInsertSpeciesTypeID, speciesTypes, Nothing, BaseReferenceConstants.idfsBaseReference, BaseReferenceConstants.Name, blankRow:=True)

                ddlSampleAnimalAgeTypeID.Enabled = True
                ddlSampleAnimalGenderTypeID.Enabled = True
                ddlSampleAnimalID.Enabled = True
                txtSampleAnimalColor.Enabled = True
                txtSampleAnimalName.Enabled = True
            Case HACodeList.AvianHACode
                sampleTypes = CrossCuttingAPIService.GetBaseReferenceList(GetCurrentLanguage(), BaseReferenceConstants.SampleType, HACodeList.AvianHACode).Result
                speciesTypes = CrossCuttingAPIService.GetBaseReferenceList(GetCurrentLanguage(), BaseReferenceConstants.SpeciesList, HACodeList.AvianHACode).Result
                FillDropDownList(ddlInsertSampleTypeID, sampleTypes, Nothing, BaseReferenceConstants.idfsBaseReference, BaseReferenceConstants.Name, blankRow:=True)
                FillDropDownList(ddlInsertSpeciesTypeID, speciesTypes, Nothing, BaseReferenceConstants.idfsBaseReference, BaseReferenceConstants.Name, blankRow:=True)

                ddlSampleAnimalAgeTypeID.Enabled = True
                ddlSampleAnimalGenderTypeID.Enabled = True
                ddlSampleAnimalID.Enabled = True
                txtSampleAnimalColor.Enabled = True
                txtSampleAnimalName.Enabled = True
        End Select

        If Not speciesSampleTypeCombinations Is Nothing Then
            For Each sampleType In sampleTypes
                If speciesSampleTypeCombinations.Where(Function(x) x.SampleTypeID = sampleType.idfsBaseReference.ToString()).Count > 0 Then
                    ddlSampleSampleTypeID.Items.Add(New ListItem With {.Value = sampleType.idfsBaseReference, .Text = sampleType.name, .Selected = False})
                    ddlAggregateInfoSampleTypeID.Items.Add(New ListItem With {.Value = sampleType.idfsBaseReference, .Text = sampleType.name, .Selected = False})
                End If
            Next
            ddlSampleSampleTypeID = SortDropDownList(ddlSampleSampleTypeID)
            ddlAggregateInfoSampleTypeID = SortDropDownList(ddlAggregateInfoSampleTypeID)
        End If

        If Not speciesSampleTypeCombinations Is Nothing Then
            For Each speciesType In speciesTypes
                If speciesSampleTypeCombinations.Where(Function(x) x.SpeciesTypeID = speciesType.idfsBaseReference.ToString()).Count > 0 Then
                    ddlSampleAnimalID.Items.Add(New ListItem With {.Value = speciesType.idfsBaseReference, .Text = speciesType.name, .Selected = False})
                    ddlAggregateInfoSampleTypeID.Items.Add(New ListItem With {.Value = speciesType.idfsBaseReference, .Text = speciesType.name, .Selected = False})
                End If
            Next
            ddlSampleSampleTypeID = SortDropDownList(ddlSampleSampleTypeID)
            ddlAggregateInfoSampleTypeID = SortDropDownList(ddlAggregateInfoSampleTypeID)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub NewSpeciesToSampleType_Click(sender As Object, e As EventArgs) Handles btnNewSpeciesToSampleType.Click

        Try
            Log.Info(MethodBase.GetCurrentMethod().Name & " entered.")

            hdfRowID.Value = 0
            hdfRowAction.Value = RecordConstants.Insert

            'Check if species to sample type combination already exists.
            If ExistsSpeciesAndSampleRow(hdfRowID.Value,
                                         If(ddlInsertSampleTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, CLng(ddlInsertSampleTypeID.SelectedValue)),
                                         If(ddlInsertSpeciesTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, CLng(ddlInsertSpeciesTypeID.SelectedValue))) Then
                ShowWarningMessage(messageType:=MessageType.DuplicateSpeciesAndSample, isConfirm:=False)
            Else
                AddUpdateSpeciesAndSampleRow(hdfRowAction.Value,
                                         hdfRowID.Value,
                                         hdfMonitoringSessionID.Value,
                                         If(ddlInsertSampleTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, CLng(ddlInsertSampleTypeID.SelectedValue)),
                                         If(ddlInsertSampleTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlInsertSampleTypeID.SelectedItem.Text),
                                         If(ddlInsertSpeciesTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, CLng(ddlInsertSpeciesTypeID.SelectedValue)),
                                         If(ddlInsertSpeciesTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlInsertSpeciesTypeID.SelectedItem.Text))

                ddlInsertSpeciesTypeID.SelectedIndex = -1
                ddlInsertSampleTypeID.SelectedIndex = -1
                hdfRowID.Value = "0"
                hdfRowAction.Value = ""
            End If

            upSessionInformation.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        Finally
            Log.Info(MethodBase.GetCurrentMethod().Name & " exited.")
        End Try

    End Sub

    ''' <summary>
    ''' Return true if species and samples exist.
    ''' </summary>
    ''' <param name="monitoringSessionToSampleTypeID"></param>
    ''' <param name="sampleTypeID"></param>
    ''' <param name="speciesTypeID"></param>
    ''' <returns>Boolean</returns>
    Private Function ExistsSpeciesAndSampleRow(ByVal monitoringSessionToSampleTypeID As Long,
                                               ByVal sampleTypeID As Long,
                                               ByVal speciesTypeID As Long)

        Dim exist As Boolean = False
        Dim speciesToSampleTypes = TryCast(Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST), List(Of VctMonitoringSessionSpeciesToSampleTypeGetListModel))

        If speciesToSampleTypes Is Nothing Then
            Return exist
        End If

        Dim foundRow = speciesToSampleTypes.Where(Function(x) x.SampleTypeID = sampleTypeID And x.SpeciesTypeID = speciesTypeID And x.MonitoringSessionToSampleTypeID <> monitoringSessionToSampleTypeID).FirstOrDefault()

        If (Not foundRow Is Nothing) AndAlso (speciesToSampleTypes.Where(Function(x) x.SampleTypeID = sampleTypeID And x.SpeciesTypeID = speciesTypeID And x.MonitoringSessionToSampleTypeID <> monitoringSessionToSampleTypeID).Count > 0) Then
            exist = True
        Else
            exist = False
        End If

        Return exist

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub InsertSpeciesTypeID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlInsertSpeciesTypeID.SelectedIndexChanged

        Try
            If ddlInsertSpeciesTypeID.SelectedValue.IsValueNullOrEmpty Then
                ddlInsertSampleTypeID.Enabled = False
                ddlInsertSampleTypeID.ClearSelection()
            Else
                ddlInsertSampleTypeID.Enabled = True
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
    Protected Sub EditSpeciesTypeID_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            Dim gvr As GridViewRow = CType(sender, DropDownList).NamingContainer

            EditSpeciesToSampleTypeRecord(sender.ID, gvr)
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
    Protected Sub EditSampleTypeID_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            Dim gvr As GridViewRow = CType(sender, DropDownList).NamingContainer

            EditSpeciesToSampleTypeRecord(sender.ID, gvr)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="gvr"></param>
    Private Sub EditSpeciesToSampleTypeRecord(sender As String, gvr As GridViewRow)

        Dim speciesToSampleTypes = CType(Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST), List(Of VctMonitoringSessionSpeciesToSampleTypeGetListModel))
        Dim speciesToSampleType = speciesToSampleTypes.Where(Function(x) x.MonitoringSessionToSampleTypeID = gvSpeciesAndSamples.DataKeys(gvr.RowIndex).Values(0)).FirstOrDefault
        Dim ddlEditSpeciesTypeID As DropDownList = gvr.FindControl("ddlEditSpeciesTypeID")
        Dim ddlEditSampleTypeID As DropDownList = gvr.FindControl("ddlEditSampleTypeID")

        'Check if species to sample type combination already exists.
        If ExistsSpeciesAndSampleRow(hdfRowID.Value,
                                         If(ddlEditSampleTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, CLng(ddlEditSampleTypeID.SelectedValue)),
                                         If(ddlEditSpeciesTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, CLng(ddlEditSpeciesTypeID.SelectedValue))) Then
            ShowWarningMessage(messageType:=MessageType.DuplicateSpeciesAndSample, isConfirm:=False)

            Select Case sender
                Case "ddlEditSpeciesTypeID"
                    ddlEditSpeciesTypeID.SelectedValue = speciesToSampleType.SpeciesTypeID
                Case "ddlEditSampleTypeID"
                    ddlEditSampleTypeID.SelectedValue = speciesToSampleType.SampleTypeID
            End Select
        Else
            speciesToSampleType.SampleTypeID = If(ddlEditSampleTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, CLng(ddlEditSampleTypeID.SelectedValue))
            speciesToSampleType.SampleTypeName = If(ddlEditSampleTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlEditSampleTypeID.SelectedItem.Text)
            speciesToSampleType.SpeciesTypeID = If(ddlEditSpeciesTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, CLng(ddlEditSpeciesTypeID.SelectedValue))
            speciesToSampleType.SpeciesTypeName = If(ddlEditSpeciesTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlEditSpeciesTypeID.SelectedItem.Text)

            If speciesToSampleType.RowAction = RecordConstants.Read Then
                speciesToSampleType.RowAction = RecordConstants.Update
            End If
        End If

    End Sub

#End Region

#Region "Farm Inventory Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refresh"></param>
    ''' <param name="isRootFarm"></param>
    ''' <param name="farmID"></param>
    Private Sub FillFarmInventory(refresh As Boolean, isRootFarm As Boolean, farmID As Long)

        Try
            Dim farmsInventory = TryCast(Session(FARMS_INVENTORY_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            If farmsInventory Is Nothing Then
                farmsInventory = New List(Of VetFarmHerdSpeciesGetListModel)()
            End If
            Dim farmInventory = New List(Of VetFarmHerdSpeciesGetListModel)()
            Dim identity As Integer = 0

            If refresh = True Then
                If FarmAPIService Is Nothing Then
                    FarmAPIService = New FarmServiceClient()
                End If

                Dim parameters = New FarmHerdSpeciesGetListParameters With {.LanguageID = GetCurrentLanguage()}

                If isRootFarm Then
                    parameters.FarmMasterID = farmID
                Else
                    parameters.FarmID = farmID
                End If

                farmInventory = FarmAPIService.FarmHerdSpeciesGetListAsync(parameters).Result
            Else
                farmInventory = farmsInventory.Where(Function(x) x.FarmID = farmID Or x.FarmMasterID = farmID).ToList()
            End If

            farmsInventory.AddRange(farmInventory)
            Session(FARMS_INVENTORY_LIST) = farmsInventory

            gvFlocksHerds.DataSource = Nothing
            If isRootFarm Then
                gvFlocksHerds.DataSource = farmInventory.Where(Function(x) (x.RecordType = HerdSpeciesConstants.Herd Or x.RecordType = HerdSpeciesConstants.Farm) And x.FarmMasterID = farmID).ToList()
            Else
                gvFlocksHerds.DataSource = farmInventory.Where(Function(x) (x.RecordType = HerdSpeciesConstants.Herd Or x.RecordType = HerdSpeciesConstants.Farm) And x.FarmID = farmID).ToList()
            End If
            gvFlocksHerds.DataBind()

            If farmInventory.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).Count > 0 Then
                If hdfMonitoringSessionID.Value = "-1" Then
                    For Each record In farmInventory
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
                                record.HerdID = farmInventory.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd And x.HerdMasterID = record.HerdMasterID).FirstOrDefault().HerdID
                            End If
                        End If
                    Next
                End If

                upHiddenFields.Update()

                'Populate species filtered down to the species on the samples to species type section, and the associated farms.
                Dim speciesSampleTypeCombinations = TryCast(Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST), List(Of VctMonitoringSessionSpeciesToSampleTypeGetListModel))

                ddlSampleFarmID.Items.Clear()
                If ddlSampleFarmID.Items.Count = 0 Then
                    ddlSampleFarmID.Items.Add(New ListItem With {.Value = GlobalConstants.NullValue.ToLower(), .Text = String.Empty, .Selected = False})
                End If

                For Each record In farmInventory
                    If record.RecordType.ToString() = RecordTypeConstants.Farm Then
                        ddlSampleFarmID.Items.Add(New ListItem With {.Value = If(record.FarmID.ToString() = String.Empty, record.FarmMasterID, record.FarmID), .Text = If(record.EIDSSFarmID.ToString() = "", "N/A", record.EIDSSFarmID), .Selected = False})
                    End If
                Next
                ddlSampleFarmID = SortDropDownList(ddlSampleFarmID)

                FillDropDownList(ddlSampleSpeciesID, farmInventory.Where(Function(x) x.RecordType = HerdSpeciesConstants.Species).ToList(), Nothing, "SpeciesID", HerdSpeciesConstants.SpeciesTypeName, blankRow:=True)
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
    Protected Sub AddFlock_Click(sender As Object, e As EventArgs) Handles btnAddFlock.Click

        Try
            Dim farmsInventory = TryCast(Session(FARMS_INVENTORY_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            Dim herdFlock = New VetFarmHerdSpeciesGetListModel()

            hdfIdentity.Value += 1
            Dim identity As Integer = (hdfIdentity.Value * -1)

            herdFlock.RecordID = identity
            herdFlock.RecordType = RecordTypeConstants.Herd
            herdFlock.FarmMasterID = hdfFarmMasterID.Value
            herdFlock.FarmID = If(hdfFarmID.Value.IsValueNullOrEmpty(), CType(Nothing, Long?), hdfFarmID.Value)
            herdFlock.HerdMasterID = identity

            If hdfFarmID.Value.IsValueNullOrEmpty = False Then
                herdFlock.EIDSSHerdID = Resources.Labels.Lbl_Flock_Text & " " & farmsInventory.Where(Function(x) x.FarmID = hdfFarmID.Value And x.RecordType = RecordTypeConstants.Herd And x.RowAction = RecordConstants.Insert).Count().ToString()
            Else
                herdFlock.EIDSSHerdID = Resources.Labels.Lbl_Flock_Text & " " & farmsInventory.Where(Function(x) x.FarmMasterID = hdfFarmMasterID.Value And x.RecordType = RecordTypeConstants.Herd And x.RowAction = RecordConstants.Insert).Count().ToString()
            End If

            herdFlock.TotalAnimalQuantity = 0
            herdFlock.DeadAnimalQuantity = 0
            herdFlock.SickAnimalQuantity = 0
            herdFlock.RowStatus = RecordConstants.ActiveRowStatus
            herdFlock.RowAction = RecordConstants.Insert

            farmsInventory.Add(herdFlock)
            Session(FARMS_INVENTORY_LIST) = farmsInventory

            gvFlocksHerds.DataSource = Nothing
            If hdfFarmID.Value.IsValueNullOrEmpty = False Then
                gvFlocksHerds.DataSource = farmsInventory.Where(Function(x) x.FarmID = hdfFarmID.Value And (x.RecordType = RecordTypeConstants.Farm Or x.RecordType = RecordTypeConstants.Herd))
            Else
                gvFlocksHerds.DataSource = farmsInventory.Where(Function(x) x.FarmMasterID = hdfFarmMasterID.Value And (x.RecordType = RecordTypeConstants.Farm Or x.RecordType = RecordTypeConstants.Herd))
            End If
            gvFlocksHerds.DataBind()

            upHiddenFields.Update()
            upFarmInventory.Update()
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
    Private Sub AddHerd_Click(sender As Object, e As EventArgs) Handles btnAddHerd.Click

        Try
            Dim farmsInventory = TryCast(Session(FARMS_INVENTORY_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            Dim herdFlock = New VetFarmHerdSpeciesGetListModel()

            hdfIdentity.Value += 1
            Dim identity As Integer = (hdfIdentity.Value * -1)

            herdFlock.RecordID = identity
            herdFlock.RecordType = RecordTypeConstants.Herd
            herdFlock.FarmMasterID = hdfFarmMasterID.Value
            herdFlock.FarmID = If(hdfFarmID.Value.IsValueNullOrEmpty(), CType(Nothing, Long?), hdfFarmID.Value)
            herdFlock.HerdMasterID = identity

            If hdfFarmID.Value.IsValueNullOrEmpty = False Then
                herdFlock.EIDSSHerdID = Resources.Labels.Lbl_Herd_Text & " " & farmsInventory.Where(Function(x) x.FarmID = hdfFarmID.Value And x.RecordType = RecordTypeConstants.Herd And x.RowAction = RecordConstants.Insert).Count().ToString()
            Else
                herdFlock.EIDSSHerdID = Resources.Labels.Lbl_Herd_Text & " " & farmsInventory.Where(Function(x) x.FarmMasterID = hdfFarmMasterID.Value And x.RecordType = RecordTypeConstants.Herd And x.RowAction = RecordConstants.Insert).Count().ToString()
            End If

            herdFlock.TotalAnimalQuantity = 0
            herdFlock.DeadAnimalQuantity = 0
            herdFlock.SickAnimalQuantity = 0
            herdFlock.RowStatus = RecordConstants.ActiveRowStatus
            herdFlock.RowAction = RecordConstants.Insert

            farmsInventory.Add(herdFlock)
            Session(FARMS_INVENTORY_LIST) = farmsInventory

            gvFlocksHerds.DataSource = Nothing
            If hdfFarmID.Value.IsValueNullOrEmpty = False Then
                gvFlocksHerds.DataSource = farmsInventory.Where(Function(x) x.FarmID = hdfFarmID.Value And (x.RecordType = RecordTypeConstants.Farm Or x.RecordType = RecordTypeConstants.Herd))
            Else
                gvFlocksHerds.DataSource = farmsInventory.Where(Function(x) x.FarmMasterID = hdfFarmMasterID.Value And (x.RecordType = RecordTypeConstants.Farm Or x.RecordType = RecordTypeConstants.Herd))
            End If
            gvFlocksHerds.DataBind()

            upHiddenFields.Update()
            upFarmInventory.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub RollUp()

        Dim farmsInventory = TryCast(Session(FARMS_INVENTORY_LIST), List(Of VetFarmHerdSpeciesGetListModel))

        Dim herds As List(Of VetFarmHerdSpeciesGetListModel) = farmsInventory.Where(Function(x) x.RecordType = RecordTypeConstants.Farm Or x.RecordType = RecordTypeConstants.Herd).ToList()
        Dim speciesList As List(Of VetFarmHerdSpeciesGetListModel) = farmsInventory.Where(Function(x) x.RecordType = RecordTypeConstants.Species).ToList()

        If Not speciesList Is Nothing Then
            Dim species As VetFarmHerdSpeciesGetListModel

            For Each herd In herds
                If hdfFarmID.Value.IsValueNullOrEmpty() = False Then
                    If herd.FarmID = hdfFarmID.Value Then
                        Dim intTotal As Short = 0

                        If Not herd.RecordType = HerdSpeciesConstants.Farm Then
                            For Each species In speciesList.Where(Function(x) x.HerdMasterID = herd.HerdMasterID And x.RowStatus = 0).ToList()
                                If (Not species.TotalAnimalQuantity Is Nothing) Then
                                    intTotal += species.TotalAnimalQuantity
                                End If
                            Next

                            farmsInventory.Where(Function(x) x.RecordID = herd.RecordID).FirstOrDefault().TotalAnimalQuantity = intTotal
                        End If
                    End If
                Else
                    If herd.FarmMasterID = hdfFarmMasterID.Value Then
                        Dim intTotal As Short = 0

                        If Not herd.RecordType = HerdSpeciesConstants.Farm Then
                            For Each species In speciesList.Where(Function(x) x.HerdMasterID = herd.HerdMasterID And x.RowStatus = 0).ToList()
                                If (Not species.TotalAnimalQuantity Is Nothing) Then
                                    intTotal += species.TotalAnimalQuantity
                                End If
                            Next

                            farmsInventory.Where(Function(x) x.RecordID = herd.RecordID).FirstOrDefault().TotalAnimalQuantity = intTotal
                        End If
                    End If
                End If
            Next

            If hdfFarmID.Value.IsValueNullOrEmpty() = False Then
                farmsInventory.Where(Function(x) x.RecordType = RecordTypeConstants.Farm And x.FarmID = hdfFarmID.Value).FirstOrDefault().TotalAnimalQuantity = farmsInventory.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd And x.FarmID = hdfFarmID.Value).Sum(Function(x) x.TotalAnimalQuantity)
            Else
                farmsInventory.Where(Function(x) x.RecordType = RecordTypeConstants.Farm And x.FarmMasterID = hdfFarmMasterID.Value).FirstOrDefault().TotalAnimalQuantity = farmsInventory.Where(Function(x) x.RecordType = HerdSpeciesConstants.Herd And x.FarmMasterID = hdfFarmMasterID.Value).Sum(Function(x) x.TotalAnimalQuantity)
            End If

            upFarmInventory.Update()
            Session(FARMS_INVENTORY_LIST) = farmsInventory
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub FlocksHerds_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvFlocksHerds.RowCommand

        Try
            e.Handled = True

            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    hdfRowID.Value = e.CommandArgument
                    upHiddenFields.Update()
                    hdfWarningMessageType.Value = MessageType.ConfirmDeleteFarmInventory
                    ShowWarningMessage(MessageType.ConfirmDeleteFarmInventory, True)
                Case GridViewCommandConstants.AddCommand
                    Dim farmsInventory = TryCast(Session(FARMS_INVENTORY_LIST), List(Of VetFarmHerdSpeciesGetListModel))
                    If farmsInventory Is Nothing Then
                        farmsInventory = New List(Of VetFarmHerdSpeciesGetListModel)()
                    End If
                    Dim species = New VetFarmHerdSpeciesGetListModel()

                    Dim eidssFarmID As String
                    If hdfFarmID.Value.IsValueNullOrEmpty() = False Then
                        eidssFarmID = farmsInventory.Where(Function(x) x.RecordType = RecordTypeConstants.Farm And x.FarmID = hdfFarmID.Value).FirstOrDefault().EIDSSFarmID
                    Else
                        eidssFarmID = farmsInventory.Where(Function(x) x.RecordType = RecordTypeConstants.Farm And x.FarmMasterID = hdfFarmMasterID.Value).FirstOrDefault().EIDSSFarmID
                    End If

                    Dim eidssHerdID = farmsInventory.Where(Function(x) x.RecordType = RecordTypeConstants.Herd And x.HerdMasterID = CType(e.CommandArgument, Long)).FirstOrDefault().EIDSSHerdID

                    hdfIdentity.Value += 1
                    Dim identity As Integer = (hdfIdentity.Value * -1)
                    species.RecordID = identity
                    species.RecordType = RecordTypeConstants.Species
                    species.SpeciesID = identity
                    species.SpeciesMasterID = identity
                    species.EIDSSFarmID = eidssFarmID
                    species.EIDSSHerdID = eidssHerdID
                    species.FarmMasterID = hdfFarmMasterID.Value
                    species.FarmID = If(hdfFarmID.Value.IsValueNullOrEmpty(), CType(Nothing, Long?), hdfFarmID.Value)
                    species.HerdMasterID = CType(e.CommandArgument, Long)
                    species.TotalAnimalQuantity = 0
                    species.DeadAnimalQuantity = 0
                    species.SickAnimalQuantity = 0
                    species.RowStatus = RecordConstants.ActiveRowStatus
                    species.RowAction = RecordConstants.Insert
                    farmsInventory.Add(species)

                    Session(FARMS_INVENTORY_LIST) = farmsInventory

                    If hdfFarmID.Value.IsValueNullOrEmpty() = False Then
                        gvFlocksHerds.DataSource = farmsInventory.Where(Function(x) (x.RecordType = RecordTypeConstants.Farm Or x.RecordType = RecordTypeConstants.Herd) And x.FarmID = hdfFarmID.Value).ToList()
                    Else
                        gvFlocksHerds.DataSource = farmsInventory.Where(Function(x) (x.RecordType = RecordTypeConstants.Farm Or x.RecordType = RecordTypeConstants.Herd) And x.FarmMasterID = hdfFarmMasterID.Value).ToList()
                    End If
                    gvFlocksHerds.DataBind()

                    upHiddenFields.Update()
            End Select
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
    Protected Sub FlocksHerds_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvFlocksHerds.RowDataBound

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
                        If ddlSpeciesType.SelectedValue = FarmTypes.AvianFarmType Then
                            lblEIDSSHerdID.Text = Resources.Labels.Lbl_Flock_Text & " " & e.Row.DataItem.EIDSSHerdID.ToString().Remove(0, 5)
                        Else
                            lblEIDSSHerdID.Text = Resources.Labels.Lbl_Herd_Text & " " & e.Row.DataItem.EIDSSHerdID.ToString().Remove(0, 4)
                        End If
                    End If

                    Dim farmsInventory = TryCast(Session(FARMS_INVENTORY_LIST), List(Of VetFarmHerdSpeciesGetListModel))
                    Dim speciesList As List(Of VetFarmHerdSpeciesGetListModel) = farmsInventory.Where(Function(x) x.HerdMasterID = e.Row.DataItem.HerdMasterID And x.RecordType = RecordTypeConstants.Species).ToList()

                    If Not speciesList Is Nothing Then
                        Dim gvSpecies As GridView = CType(e.Row.FindControl("gvSpecies"), GridView)

                        gvSpecies.DataSource = speciesList
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
    Protected Sub Species_RowDataBound(sender As Object, e As GridViewRowEventArgs)

        Try
            If e.Row.RowType = DataControlRowType.DataRow Then
                Dim ddlFarmSpeciesTypeID As DropDownList = CType(e.Row.FindControl("ddlFarmSpeciesTypeID"), DropDownList)

                If ddlSpeciesType.SelectedValue = FarmTypes.AvianFarmType Then
                    BaseReferenceLookUp(ddlFarmSpeciesTypeID, BaseReferenceConstants.SpeciesList, HACodeList.AvianHACode, True)
                    ddlFarmSpeciesTypeID.SelectedValue = e.Row.DataItem.SpeciesTypeID
                Else
                    BaseReferenceLookUp(ddlFarmSpeciesTypeID, BaseReferenceConstants.SpeciesList, HACodeList.LivestockHACode, True)
                    ddlFarmSpeciesTypeID.SelectedValue = e.Row.DataItem.SpeciesTypeID
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
    Protected Sub FarmSpeciesTypeID_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            UpdateFlockHerdSpecies()
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
    Protected Sub FarmTotalAnimalQuantity_TextChanged(sender As Object, e As EventArgs)

        Try
            Dim txt As TextBox = sender
            Dim row As GridViewRow = TryCast(txt.NamingContainer, GridViewRow)

            UpdateFlockHerdSpecies()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub UpdateFlockHerdSpecies()

        Try
            Dim farmsInventory = TryCast(Session(FARMS_INVENTORY_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            Dim record As VetFarmHerdSpeciesGetListModel
            Dim index As Integer = 0

            For Each row As GridViewRow In gvFlocksHerds.Rows
                Dim gvSpecies As GridView = CType(row.FindControl("gvSpecies"), GridView)

                If Not gvSpecies Is Nothing Then
                    For Each speciesRow As GridViewRow In gvSpecies.Rows
                        Dim hdfSpeciesMasterID As HiddenField = CType(speciesRow.FindControl("hdfSpeciesMasterID"), HiddenField)
                        Dim ddlSpeciesTypeID As DropDownList = CType(speciesRow.FindControl("ddlFarmSpeciesTypeID"), WebControls.DropDownList)
                        Dim txtTotalAnimalQuantity As TextBox = CType(speciesRow.FindControl("txtFarmTotalAnimalQuantity"), TextBox)

                        record = New VetFarmHerdSpeciesGetListModel()
                        record = farmsInventory.Where(Function(x) x.RecordType = RecordTypeConstants.Species And x.SpeciesMasterID = hdfSpeciesMasterID.Value).FirstOrDefault()

                        If hdfRowAction.Value = RecordConstants.Read Then
                            record.RowAction = RecordConstants.Update
                        End If

                        record.SpeciesTypeID = ddlSpeciesTypeID.SelectedValue
                        record.SpeciesTypeName = ddlSpeciesTypeID.SelectedItem.Text
                        record.TotalAnimalQuantity = If(String.IsNullOrEmpty(txtTotalAnimalQuantity.Text), 0, Short.Parse(txtTotalAnimalQuantity.Text))

                        index = farmsInventory.IndexOf(record)
                        farmsInventory(index) = record

                        index = farmsInventory.IndexOf(record)
                        farmsInventory(index) = record
                    Next
                End If
            Next

            Session(FARMS_INVENTORY_LIST) = farmsInventory

            RollUp()

            If hdfFarmID.Value.IsValueNullOrEmpty() = False Then
                gvFlocksHerds.DataSource = farmsInventory.Where(Function(x) (x.RecordType = RecordTypeConstants.Farm Or x.RecordType = RecordTypeConstants.Herd) And x.FarmID = hdfFarmID.Value).ToList()
            Else
                gvFlocksHerds.DataSource = farmsInventory.Where(Function(x) (x.RecordType = RecordTypeConstants.Farm Or x.RecordType = RecordTypeConstants.Herd) And x.FarmMasterID = hdfFarmMasterID.Value).ToList()
            End If
            gvFlocksHerds.DataBind()
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
    Protected Sub Species_RowCommand(sender As Object, e As GridViewCommandEventArgs)

        Try
            e.Handled = True

            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    hdfRowID.Value = e.CommandArgument
                    hdfWarningMessageType.Value = MessageType.ConfirmDeleteFarmInventory
                    ShowWarningMessage(MessageType.ConfirmDeleteFarmInventory, True)
                    upHiddenFields.Update()
                    upFarmInventory.Update()
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
    Private Sub DeleteFarmInventory(recordID As Long)

        If CanDeleteFarmInventory(recordID) = True Then
            Dim farmsInventory = TryCast(Session(FARMS_INVENTORY_LIST), List(Of VetFarmHerdSpeciesGetListModel))
            If farmsInventory Is Nothing Then
                ShowErrorMessage(messageType:=MessageType.CannotDeleteFarmInventory)
            End If
            Dim inventory = farmsInventory.Where(Function(x) x.RecordID = recordID).FirstOrDefault()
            farmsInventory.Remove(inventory)

            If farmsInventory.Where(Function(x) x.FarmMasterID = hdfFarmMasterID.Value).Count() = 0 Then
                divFarmDetails.Visible = True
                divFarmInventory.Visible = False

                ResetForm(divFarmDetails)

                upFarmDetails.Update()
                upFarmInventory.Update()
            End If

            Session(FARMS_INVENTORY_LIST) = farmsInventory
            gvFlocksHerds.DataSource = farmsInventory
            gvFlocksHerds.DataBind()
        Else
            ShowErrorMessage(messageType:=MessageType.CannotDeleteFarmInventory)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordID"></param>
    ''' <returns></returns>
    Private Function CanDeleteFarmInventory(recordID As Long) As Boolean

        Dim farmsInventory = TryCast(Session(FARMS_INVENTORY_LIST), List(Of VetFarmHerdSpeciesGetListModel))
        If farmsInventory Is Nothing Then
            Return False
        End If
        Dim samples = TryCast(Session(SAMPLE_LIST), List(Of GblSampleGetListModel))
        If samples Is Nothing Then
            samples = New List(Of GblSampleGetListModel)()
        End If
        Dim animals = TryCast(Session(ANIMAL_LIST), List(Of VetAnimalGetListModel))
        If animals Is Nothing Then
            animals = New List(Of VetAnimalGetListModel)()
        End If
        Dim summaries = TryCast(Session(SUMMARY_LIST), List(Of VctMonitoringSessionSummaryGetListModel))
        If summaries Is Nothing Then
            summaries = New List(Of VctMonitoringSessionSummaryGetListModel)()
        End If
        Dim inventory = farmsInventory.Where(Function(x) x.RecordID = recordID).FirstOrDefault()

        If animals.Where(Function(x) x.SpeciesID = inventory.SpeciesID).Count > 0 Then
            Return False
        End If

        If samples.Where(Function(x) x.SpeciesID = inventory.SpeciesID).Count > 0 Then
            Return False
        End If

        If summaries.Where(Function(x) x.SpeciesID = inventory.SpeciesID).Count > 0 Then
            Return False
        End If

        'Check against 1 instead of 0 to account for the inventory record itself (used for flocks/herds or the farm).
        If farmsInventory.Where(Function(x) x.RecordID = inventory.RecordID).Count > 1 Then
            Return False
        End If

        Return True

    End Function

#End Region

#Region "Animal Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refresh"></param>
    Private Sub FillAnimals(ByVal refresh As Boolean)

        Try
            Dim animals = New List(Of VetAnimalGetListModel)()

            If refresh Then Session(ANIMAL_LIST) = Nothing

            If IsNothing(Session(ANIMAL_LIST)) Then
                If VeterinaryAPIService Is Nothing Then
                    VeterinaryAPIService = New VeterinaryServiceClient()
                End If
                animals = VeterinaryAPIService.GetAnimalListAsync(GetCurrentLanguage(), Nothing, hdfMonitoringSessionID.Value, Nothing, Nothing, Nothing).Result
                Session(ANIMAL_LIST) = animals
            Else
                animals = CType(Session(ANIMAL_LIST), List(Of VetAnimalGetListModel))
            End If

            txtTotalNumberAnimalsSampled.Text = animals.Count

            FillDropDownList(ddlSampleAnimalID, animals, Nothing, "AnimalID", "EIDSSAnimalID", Nothing, blankRow:=True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="rowID"></param>
    ''' <param name="eidssAnimalID"></param>
    ''' <returns></returns>
    Private Function AddUpdateAnimal(ByVal rowID As Long, ByRef eidssAnimalID As String) As Long

        Dim animals = TryCast(Session(ANIMAL_LIST), List(Of VetAnimalGetListModel))
        Dim animal As VetAnimalGetListModel

        If rowID = 0 Then
            animal = New VetAnimalGetListModel()
        Else
            animal = animals.Where(Function(x) x.AnimalID = rowID).First
        End If

        animal.AnimalAgeTypeID = If(ddlSampleAnimalAgeTypeID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlSampleAnimalAgeTypeID.SelectedValue, Long))
        animal.AnimalAgeTypeName = If(ddlSampleAnimalAgeTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlSampleAnimalAgeTypeID.SelectedItem.Text)
        animal.AnimalGenderTypeID = If(ddlSampleAnimalGenderTypeID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlSampleAnimalGenderTypeID.SelectedValue, Long))
        animal.AnimalGenderTypeName = If(ddlSampleAnimalGenderTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlSampleAnimalGenderTypeID.SelectedItem.Text)
        animal.AnimalName = If(txtSampleAnimalName.Text.IsValueNullOrEmpty(), Nothing, txtSampleAnimalName.Text)
        animal.SpeciesID = If(ddlSampleSpeciesID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlSampleSpeciesID.SelectedValue, Long))
        animal.SpeciesTypeName = If(ddlSampleSpeciesID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlSampleSpeciesID.SelectedItem.Text)
        animal.Color = If(txtSampleAnimalColor.Text.IsValueNullOrEmpty(), Nothing, txtSampleAnimalColor.Text)

        If rowID = 0 Then
            hdfIdentity.Value += 1
            Dim identity As Integer = (hdfIdentity.Value * -1)
            animal.AnimalID = identity
            animal.EIDSSAnimalID = "(" & Resources.Labels.Lbl_New_Text & " " & animals.Count.ToString() & ")"
            animal.RowStatus = RecordConstants.ActiveRowStatus
            animal.RowAction = RecordConstants.Insert
            animals.Add(animal)
        Else
            If animal.AnimalID > 0 Then
                animal.RowAction = RecordConstants.Update
            End If

            Dim labTests = TryCast(Session(TEST_LIST), List(Of GblTestGetListModel))
            Dim interpretations = TryCast(Session(INTERPRETATION_LIST), List(Of GblTestInterpretationGetListModel))

            For Each labTest In labTests
                If labTest.AnimalID.ToString = animal.AnimalID Then
                    labTest.EIDSSAnimalID = eidssAnimalID
                End If
            Next
            Session(TEST_LIST) = labTests
            gvLabTests.DataSource = Session(TEST_LIST)
            gvLabTests.DataBind()

            For Each interpretation In interpretations
                If interpretation.AnimalID.ToString = animal.AnimalID Then
                    interpretation.EIDSSAnimalID = eidssAnimalID
                End If
            Next
            Session(TEST_LIST) = labTests
            gvTestInterpretations.DataSource = Session(TEST_LIST)
            gvTestInterpretations.DataBind()
        End If

        eidssAnimalID = animal.EIDSSAnimalID

        Session(ANIMAL_LIST) = animals

        FillDropDownList(ddlSampleAnimalID, animals, Nothing, "AnimalID", "EIDSSAnimalID", blankRow:=True)

        Return animal.AnimalID

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="animalToCopy"></param>
    ''' <returns></returns>
    Private Function CopyAnimal(animalToCopy As VetAnimalGetListModel) As Long

        Dim animals = TryCast(Session(ANIMAL_LIST), List(Of VetAnimalGetListModel))
        Dim newAnimal = New VetAnimalGetListModel With {
            .AnimalAgeTypeID = animalToCopy.AnimalAgeTypeID,
            .AnimalAgeTypeName = animalToCopy.AnimalAgeTypeName,
            .AnimalGenderTypeID = animalToCopy.AnimalGenderTypeID,
            .AnimalGenderTypeName = animalToCopy.AnimalGenderTypeName,
            .AnimalName = animalToCopy.AnimalName,
            .SpeciesID = animalToCopy.SpeciesID,
            .SpeciesTypeName = animalToCopy.SpeciesTypeName,
            .Color = animalToCopy.Color
        }

        hdfIdentity.Value += 1
        Dim identity As Integer = (hdfIdentity.Value * -1)
        newAnimal.AnimalID = identity
        newAnimal.EIDSSAnimalID = "(" & Resources.Labels.Lbl_New_Text & " " & animals.Count.ToString() & ")"
        newAnimal.RowStatus = RecordConstants.ActiveRowStatus
        newAnimal.RowAction = RecordConstants.Insert
        animals.Add(newAnimal)

        Session(ANIMAL_LIST) = animals

        FillDropDownList(ddlSampleAnimalID, animals, Nothing, "AnimalID", "EIDSSAnimalID", blankRow:=True)

        Return newAnimal.AnimalID

    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="animalID"></param>
    Private Sub DeleteAnimal(ByVal animalID As Long)

        Dim animals = CType(Session(ANIMAL_LIST), List(Of VetAnimalGetListModel))
        Dim animal = animals.Where(Function(x) x.AnimalID = animalID).FirstOrDefault

        If animal.RowAction = RecordConstants.Insert Then
            animals.Remove(animal)
        Else
            animal.RowAction = RecordConstants.Delete
            animal.RowStatus = RecordConstants.InactiveRowStatus
        End If

        Session(ANIMAL_LIST) = animals

        FillDropDownList(ddlSampleAnimalID, animals, Nothing, "AnimalID", "EIDSSAnimalID", blankRow:=True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="animalID"></param>
    ''' <returns></returns>
    Public Function CanDeleteAnimal(ByVal animalID As Long) As Boolean

        Dim labTests = TryCast(Session(TEST_LIST), List(Of GblTestGetListModel))

        If labTests.Where(Function(x) x.AnimalID = animalID).Count = 0 Then
            Return True
        Else
            Return False
        End If

        Dim interpretations = TryCast(Session(INTERPRETATION_LIST), List(Of GblTestInterpretationGetListModel))

        If interpretations.Where(Function(x) x.AnimalID = animalID).Count = 0 Then
            Return True
        Else
            Return False
        End If

        Return False

    End Function

#End Region

#Region "Detailed Animal and Sample Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refresh"></param>
    Private Sub FillSamples(ByVal refresh As Boolean)

        Try
            Dim samples = New List(Of GblSampleGetListModel)()

            If refresh Then Session(SAMPLE_LIST) = Nothing

            If IsNothing(Session(SAMPLE_LIST)) Then
                If CrossCuttingAPIService Is Nothing Then
                    CrossCuttingAPIService = New CrossCuttingServiceClient()
                End If
                samples = CrossCuttingAPIService.GetSampleListAsync(GetCurrentLanguage(), Nothing, Nothing, Nothing, hdfMonitoringSessionID.Value, Nothing).Result
                Session(SAMPLE_LIST) = samples
            Else
                samples = CType(Session(SAMPLE_LIST), List(Of GblSampleGetListModel))
            End If

            gvSamples.DataSource = Nothing
            gvSamples.DataSource = samples
            gvSamples.DataBind()

            txtTotalNumberSamples.Text = samples.Count

            If samples.Count > 0 Then
                FillDropDownList(ddlLabTestSampleID, samples, Nothing, "SampleID", "EIDSSLocalOrFieldSampleID", String.Empty, Nothing, True)

                Dim distinctFarms = samples.GroupBy(Function(x) x.FarmID).Select(Function(x) x.First).ToList.OrderBy(Function(y) y.EIDSSFarmID)
                For Each farm In distinctFarms
                    ddlSampleFarmID.Items.Add(New ListItem With {.Value = farm.FarmID, .Text = farm.EIDSSFarmID})
                Next

                Dim diseaseCombinations = TryCast(Session(DISEASE_LIST), List(Of VctMonitoringSessionToDiseaseGetListModel))
                lbxDiseaseID.Enabled = False
                lbxDiseaseID.Items.Clear()
                For Each diseaseCombination In diseaseCombinations
                    lbxDiseaseID.Items.FindByValue(diseaseCombination.DiseaseID).Selected = True
                Next

                btnCopySelectedSamples.Visible = True
                btnDeleteSelectedSamples.Visible = True
                lbxDiseaseID.Enabled = False
            Else
                btnCopySelectedSamples.Visible = False
                btnDeleteSelectedSamples.Visible = False
                lbxDiseaseID.Enabled = True
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

            If ddlSpeciesType.SelectedValue = HACodeList.Avian Then
                divSampleAnimalContainer1.Visible = False
                divSampleAnimalContainer2.Visible = False
            Else
                divSampleAnimalContainer1.Visible = True
                divSampleAnimalContainer2.Visible = True
            End If

            ddlSampleSpeciesID.Enabled = False

            upSampleModal.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSampleModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ResetSample()

        If Not ddlSampleSampleTypeID.Items.Count = 2 Then
            ddlSampleSampleTypeID.SelectedIndex = -1
        End If
        ddlSampleFarmID.SelectedIndex = -1
        ddlSampleSpeciesID.SelectedIndex = -1
        ddlSampleAnimalID.SelectedIndex = -1
        ddlSampleAnimalAgeTypeID.SelectedIndex = -1
        ddlSampleAnimalGenderTypeID.SelectedIndex = -1
        ddlSampleSentToOrganizationID.SelectedIndex = -1
        ddlSampleSpeciesID.SelectedIndex = -1
        txtSampleAnimalName.Text = String.Empty
        txtSampleAnimalColor.Text = String.Empty
        txtSampleCollectionDate.Text = String.Empty
        txtSampleAccessionComment.Text = String.Empty
        txtSampleEIDSSLocalOrFieldSampleID.Text = String.Empty
        txtSampleNote.Text = String.Empty
        ddlSampleSentToOrganizationID.SelectedIndex = -1
        hdfRowID.Value = "0"
        hdfRowAction.Value = String.Empty
        divNumberToCopy.Visible = False

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub PopulateSampleDefaults()

        Dim samples = CType(Session(SAMPLE_LIST), List(Of GblSampleGetListModel))

        If samples.Count > 0 Then
            If ddlSampleSentToOrganizationID.Items.Count > 1 Then
                If Not samples.Last().SentToOrganizationID Is Nothing Then
                    ddlSampleSentToOrganizationID.SelectedValue = samples.Last().SentToOrganizationID
                End If
            End If
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub SampleSave_Click(sender As Object, e As EventArgs) Handles btnSampleSave.Click

        Try
            Dim samples = CType(Session(SAMPLE_LIST), List(Of GblSampleGetListModel))
            Dim sample = New GblSampleGetListModel()

            If Not hdfRowID.Value = "0" And Not hdfRowID.Value = String.Empty Then
                sample = samples.Where(Function(x) x.SampleID = hdfRowID.Value).FirstOrDefault
            End If

            sample.FarmID = If(ddlSampleFarmID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlSampleFarmID.SelectedValue, Long))
            sample.EIDSSFarmID = If(ddlSampleFarmID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlSampleFarmID.SelectedItem.Text)
            sample.SampleTypeID = If(ddlSampleSampleTypeID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlSampleSampleTypeID.SelectedValue, Long))
            sample.SampleTypeName = If(ddlSampleSampleTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlSampleSampleTypeID.SelectedItem.Text)
            sample.EIDSSLocalOrFieldSampleID = If(txtSampleEIDSSLocalOrFieldSampleID.Text.IsValueNullOrEmpty(), Nothing, txtSampleEIDSSLocalOrFieldSampleID.Text)
            sample.SpeciesID = If(ddlSampleSpeciesID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlSampleSpeciesID.SelectedValue, Long))
            sample.SpeciesTypeName = If(ddlSampleSpeciesID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlSampleSpeciesID.SelectedItem.Text)
            sample.CollectionDate = If(txtSampleCollectionDate.Text.IsValueNullOrEmpty(), CType(Nothing, Date?), Convert.ToDateTime(txtSampleCollectionDate.Text))
            sample.AccessionComment = If(txtSampleAccessionComment.Text.IsValueNullOrEmpty(), Nothing, txtSampleAccessionComment.Text)
            sample.SentToOrganizationID = If(ddlSampleSentToOrganizationID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlSampleSentToOrganizationID.SelectedValue, Long))
            sample.SentToOrganizationName = If(ddlSampleSentToOrganizationID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlSampleSentToOrganizationID.SelectedItem.Text)
            sample.SiteID = EIDSSAuthenticatedUser.SiteId
            sample.ReadOnlyIndicator = 0

            Dim eidssAnimalID As String = ""
            If ddlSpeciesType.SelectedValue = HACodeList.LivestockHACode Then
                If ddlSampleAnimalID.SelectedValue.IsValueNullOrEmpty() Then
                    sample.AnimalID = AddUpdateAnimal(0, eidssAnimalID)
                Else
                    sample.AnimalID = If(ddlSampleAnimalID.SelectedValue = GlobalConstants.NullValue, CType(Nothing, Long?), CType(ddlSampleAnimalID.SelectedValue, Long))
                    sample.EIDSSAnimalID = If(ddlSampleAnimalID.SelectedValue = GlobalConstants.NullValue, Nothing, ddlSampleAnimalID.SelectedItem.Text)

                    AddUpdateAnimal(ddlSampleAnimalID.SelectedValue, eidssAnimalID)
                End If
            End If
            sample.EIDSSAnimalID = eidssAnimalID

            FillDropDown(ddlLabTestSampleID, GetType(clsSample), Nothing, SampleConstants.SampleID, SampleConstants.SampleCode, String.Empty, Nothing, True)

            If Not hdfRowID.Value = "0" And Not hdfRowID.Value = String.Empty Then
                If sample.SampleID > 0 Then
                    sample.RowAction = RecordConstants.Update
                End If

                Dim tests = CType(Session(TEST_LIST), List(Of GblTestGetListModel))
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
                Session(TEST_LIST) = tests
                gvLabTests.DataSource = tests
                gvLabTests.DataBind()

                Dim testInterpretations = CType(Session(INTERPRETATION_LIST), List(Of GblTestInterpretationGetListModel))
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
                Session(INTERPRETATION_LIST) = testInterpretations
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
            Session(SAMPLE_LIST) = samples
            gvSamples.DataSource = samples
            gvSamples.DataBind()

            FillDropDownList(ddlLabTestSampleID, samples, Nothing, "SampleID", "EIDSSLocalOrFieldSampleID", blankRow:=True)

            ResetSample()

            RollUpSampleCounts()

            btnCopySelectedSamples.Visible = True
            btnDeleteSelectedSamples.Visible = True
            lbxDiseaseID.Enabled = False
            upSessionInformation.Update()

            upDetailedAnimalsAndSamples.Update()

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
    Protected Sub SampleCancel_Click(sender As Object, e As EventArgs) Handles btnSampleCancel.Click

        Try
            ShowWarningMessage(messageType:=MessageType.CancelSampleConfirm, isConfirm:=True, message:=Nothing)
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
    Protected Sub CopySample_Click(sender As Object, e As EventArgs) Handles btnCopySelectedSamples.Click

        Try
            divNumberToCopy.Visible = True
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
    Protected Sub NumberToCopy_TextChanged(sender As Object, e As EventArgs)

        Try
            Dim txt As TextBox = sender
            Dim row As GridViewRow = TryCast(txt.NamingContainer, GridViewRow)

            Dim samples = TryCast(Session(SAMPLE_LIST), List(Of GblSampleGetListModel))
            Dim copySample As GblSampleGetListModel
            Dim newSample As GblSampleGetListModel
            Dim counter As Integer = 1
            Dim eidssAnimalID As String = String.Empty
            Dim editButton As LinkButton

            For Each gvr As GridViewRow In gvSamples.Rows
                If (CType(gvr.FindControl("chkSelectSample"), CheckBox)).Checked = True Then
                    editButton = CType(gvr.FindControl("btnEditSample"), LinkButton)
                    copySample = samples.Where(Function(x) x.SampleID = editButton.CommandArgument).FirstOrDefault()

                    Do Until counter > txtNumberToCopy.Text
                        newSample = New GblSampleGetListModel()

                        hdfIdentity.Value += 1
                        Dim identity As Integer = (hdfIdentity.Value * -1)
                        newSample.SampleID = identity
                        newSample.RowStatus = RecordConstants.ActiveRowStatus
                        newSample.RowAction = RecordConstants.Insert
                        newSample.EIDSSFarmID = copySample.EIDSSFarmID
                        newSample.FarmID = copySample.FarmID
                        newSample.SpeciesID = copySample.SpeciesID
                        newSample.SpeciesTypeName = copySample.SpeciesTypeName
                        newSample.CollectionDate = copySample.CollectionDate
                        newSample.SentToOrganizationID = copySample.SentToOrganizationID
                        newSample.SentToOrganizationName = copySample.SentToOrganizationName
                        newSample.SiteID = EIDSSAuthenticatedUser.SiteId
                        newSample.ReadOnlyIndicator = 0

                        Dim animals = TryCast(Session(ANIMAL_LIST), List(Of VetAnimalGetListModel))

                        newSample.AnimalID = CopyAnimal(animals.Where(Function(x) x.AnimalID = copySample.AnimalID).FirstOrDefault())
                        newSample.EIDSSAnimalID = animals.Where(Function(x) x.AnimalID = newSample.AnimalID).FirstOrDefault().EIDSSAnimalID
                        newSample.AnimalAgeTypeID = copySample.AnimalAgeTypeID
                        newSample.AnimalAgeTypeName = copySample.AnimalAgeTypeName
                        newSample.AnimalColor = copySample.AnimalColor
                        newSample.AnimalGenderTypeID = copySample.AnimalGenderTypeID
                        newSample.AnimalGenderTypeName = copySample.AnimalGenderTypeName
                        newSample.EIDSSAnimalID = copySample.EIDSSAnimalID
                        newSample.SampleTypeID = copySample.SampleTypeID
                        newSample.SampleTypeName = copySample.SampleTypeName

                        samples.Add(newSample)

                        counter += 1
                    Loop
                End If
            Next

            gvSamples.DataSource = Nothing
            Session(SAMPLE_LIST) = samples
            gvSamples.DataSource = samples
            gvSamples.DataBind()

            FillDropDownList(ddlLabTestSampleID, samples, Nothing, "SampleID", "EIDSSLocalOrFieldSampleID", blankRow:=True)

            ResetSample()

            RollUpSampleCounts()

            upDetailedAnimalsAndSamples.Update()
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
                    hdfParentSampleID.Value = btnEditSample.CommandArgument

                    Dim gvAliquots As GridView = e.Row.FindControl("gvAliquots")
                    gvAliquots.DataSource = FillAliqouts(hdfParentSampleID.Value)
                    gvAliquots.DataBind()

                    Dim expandCollapseSampleAliquotDetails As HtmlAnchor = e.Row.FindControl("expandCollapseSampleAliquotDetails")
                    expandCollapseSampleAliquotDetails.Disabled = False
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
    Protected Sub gvSamples_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSamples.RowCommand

        Try
            e.Handled = True

            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    upWarningModal.Update()
                    upHiddenFields.Update()
                    ShowWarningMessage(messageType:=MessageType.ConfirmDeleteSample, isConfirm:=True, message:=Resources.WarningMessages.Confirm_Delete_Message)
                    hdfRowAction.Value = RecordConstants.Delete
                    hdfRowID.Value = e.CommandArgument
                Case GridViewCommandConstants.EditCommand
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

        Dim samples = CType(Session(SAMPLE_LIST), List(Of GblSampleGetListModel))
        Dim animals = CType(Session(ANIMAL_LIST), List(Of VetAnimalGetListModel))
        Dim sample = samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault()
        Dim animal = animals.Where(Function(x) x.AnimalID = sample.AnimalID).FirstOrDefault()

        If Not sample Is Nothing Then
            ddlSampleFarmID.SelectedValue = If(sample.FarmID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), sample.FarmID)
            If ddlSampleFarmID.SelectedValue = GlobalConstants.NullValue.ToLower() Then
                ddlSampleSpeciesID.Enabled = False
            Else
                ddlSampleSpeciesID.Enabled = True
                ddlSampleSpeciesID.SelectedValue = If(sample.SpeciesID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), sample.SpeciesID)
            End If
            ddlSampleAnimalID.SelectedValue = If(sample.AnimalID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), sample.AnimalID)

            If Not animal Is Nothing Then
                ddlSampleAnimalAgeTypeID.SelectedValue = If(animal.AnimalAgeTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), animal.AnimalAgeTypeID)
                ddlSampleAnimalGenderTypeID.SelectedValue = If(animal.AnimalGenderTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), animal.AnimalGenderTypeID)
                txtSampleAnimalColor.Text = If(animal.Color, String.Empty)
                txtSampleAnimalName.Text = If(animal.AnimalName, String.Empty)
            End If

            ddlSampleSampleTypeID.SelectedValue = If(sample.SampleTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), sample.SampleTypeID)
            ddlSampleSentToOrganizationID.SelectedValue = If(sample.SentToOrganizationID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), sample.SentToOrganizationID)
            txtSampleCollectionDate.Text = If(sample.CollectionDate.ToString.IsValueNullOrEmpty(), String.Empty, sample.CollectionDate)
            txtSampleAccessionComment.Text = If(sample.AccessionComment, String.Empty)
            txtSampleEIDSSLocalOrFieldSampleID.Text = If(sample.EIDSSLocalOrFieldSampleID, String.Empty)
            txtSampleNote.Text = If(sample.Comments, String.Empty)
            hdfRowID.Value = sample.SampleID
            hdfRowAction.Value = sample.RowAction.ToString

            If ddlSpeciesType.SelectedValue = HACodeList.Avian Then
                divSampleAnimalContainer1.Visible = False
                divSampleAnimalContainer2.Visible = False
            Else
                divSampleAnimalContainer1.Visible = True
                divSampleAnimalContainer2.Visible = True
            End If

            upHiddenFields.Update()
            upSampleModal.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSampleModal"), True)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="parentSampleID"></param>
    ''' <returns></returns>
    Private Function FillAliqouts(ByVal parentSampleID As Long) As List(Of GblSampleGetListModel)

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
    Protected Sub DeleteSelectedSamples_Click(sender As Object, e As EventArgs) Handles btnDeleteSelectedSamples.Click

        Try
            upWarningModal.Update()
            upHiddenFields.Update()
            ShowWarningMessage(messageType:=MessageType.ConfirmDeleteSamples, isConfirm:=True, message:=Resources.WarningMessages.Confirm_Delete_Message)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub DeleteSelectedSamples()

        Dim samples = TryCast(Session(SAMPLE_LIST), List(Of GblSampleGetListModel))
        Dim sample As GblSampleGetListModel
        Dim button As LinkButton

        For Each gvr As GridViewRow In gvSamples.Rows
            If (CType(gvr.FindControl("chkSelectSample"), CheckBox)).Checked = True Then
                button = CType(gvr.FindControl("btnEditSample"), LinkButton)
                sample = samples.Where(Function(x) x.SampleID = button.CommandArgument).FirstOrDefault()
                If CanDeleteSample(sample.SampleID) Then
                    If sample.RowAction = RecordConstants.Insert Then
                        samples.Remove(sample)
                    Else
                        sample.RowAction = RecordConstants.Delete
                        sample.RowStatus = RecordConstants.InactiveRowStatus
                    End If

                    Session(SAMPLE_LIST) = samples
                    FillSamples(refresh:=False)
                Else
                    ShowErrorMessage(messageType:=MessageType.CannotDeleteSample)
                End If
            End If
        Next

        RollUpSampleCounts()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sampleID"></param>
    Private Sub DeleteSample(sampleID As Long)

        Dim samples = TryCast(Session(SAMPLE_LIST), List(Of GblSampleGetListModel))
        Dim sample = samples.Where(Function(x) x.SampleID = sampleID).FirstOrDefault()

        If CanDeleteSample(sample.SampleID) Then
            If sample.RowAction = RecordConstants.Insert Then
                samples.Remove(sample)
            Else
                sample.RowAction = RecordConstants.Delete
                sample.RowStatus = RecordConstants.InactiveRowStatus
            End If

            Session(SAMPLE_LIST) = samples
            FillSamples(refresh:=False)

            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divWarningModal"), True)
        Else
            ShowErrorMessage(messageType:=MessageType.CannotDeleteSample)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub SampleFarmID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlSampleFarmID.SelectedIndexChanged

        Dim farmsInventory = CType(Session(FARMS_INVENTORY_LIST), List(Of VetFarmHerdSpeciesGetListModel))

        If ddlSampleFarmID.SelectedValue = "" Then
            ddlSampleSpeciesID.Enabled = False
        Else
            Dim speciesToSampleTypes = TryCast(Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST), List(Of VctMonitoringSessionSpeciesToSampleTypeGetListModel))
            ddlSampleSpeciesID.Items.Clear()
            If ddlSampleSpeciesID.Items.Count = 0 Then
                ddlSampleSpeciesID.Items.Add(New ListItem With {.Text = String.Empty, .Value = GlobalConstants.NullValue.ToLower(), .Selected = False})
            End If

            For Each farmInventory In farmsInventory
                If farmInventory.RecordType.ToString() = RecordTypeConstants.Species And farmInventory.EIDSSFarmID = ddlSampleFarmID.SelectedItem.Text Then
                    If speciesToSampleTypes.Where(Function(x) x.SpeciesTypeID = farmInventory.SpeciesTypeID.ToString()).Count > 0 Then
                        ddlSampleSpeciesID.Items.Add(New ListItem With {.Value = If(farmInventory.SpeciesID.ToString.IsValueNullOrEmpty(), farmInventory.SpeciesMasterID, farmInventory.SpeciesID), .Text = (farmInventory.EIDSSHerdID & " - " & farmInventory.SpeciesTypeName), .Selected = False})
                    End If
                End If
            Next
            ddlSampleSpeciesID = SortDropDownList(ddlSampleSpeciesID)
            ddlSampleSpeciesID.Enabled = True
        End If

        ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divSampleModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub RollUpSampleCounts()

        Dim samples = CType(Session(SAMPLE_LIST), List(Of GblSampleGetListModel))
        txtTotalNumberSamples.Text = samples.Count.ToString
        txtTotalNumberAnimalsSampled.Text = samples.GroupBy(Function(x) x.AnimalID).ToList().Count.ToString

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sampleID"></param>
    ''' <returns></returns>
    Public Function CanDeleteSample(ByVal sampleID As Long) As Boolean

        Dim labTests = TryCast(Session(TEST_LIST), List(Of GblTestGetListModel))

        If labTests.Where(Function(x) x.SampleID = sampleID And x.RowStatus = RecordConstants.ActiveRowStatus).Count = 0 Then
            Return True
        Else
            Return False
        End If

        Return False

    End Function

#End Region

#Region "Test Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refresh"></param>
    Private Sub FillTests(ByVal refresh As Boolean)

        Try
            Dim tests = New List(Of GblTestGetListModel)()

            If refresh Then Session(TEST_LIST) = Nothing

            If IsNothing(Session(TEST_LIST)) Then
                If CrossCuttingAPIService Is Nothing Then
                    CrossCuttingAPIService = New CrossCuttingServiceClient()
                End If
                tests = CrossCuttingAPIService.GetTestListAsync(GetCurrentLanguage(), Nothing, Nothing, hdfMonitoringSessionID.Value, Nothing, Nothing).Result
                Session(TEST_LIST) = tests
            Else
                tests = CType(Session(TEST_LIST), List(Of GblTestGetListModel))
            End If

            gvLabTests.DataSource = Nothing
            gvLabTests.DataSource = tests
            gvLabTests.DataBind()
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

            ToggleVisibility(SectionTest)
            If ddlSpeciesType.SelectedValue = HACodeList.Avian Then
                divTestAnimalContainer.Visible = False
            Else
                divTestAnimalContainer.Visible = True
            End If

            upLabTestModal.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divLabTestModal"), True)
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
    Protected Sub LabTestCancel_Click(sender As Object, e As EventArgs) Handles btnLabTestCancel.Click

        Try
            ShowWarningMessage(messageType:=MessageType.CancelLabTestConfirm, isConfirm:=True, message:=Nothing)
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
        txtLabTestEIDSSFarmID.Text = String.Empty
        txtLabTestResultDate.Text = String.Empty
        txtLabTestDiseaseName.Text = lbxDiseaseID.SelectedItem.Text
        txtLabTestEIDSSAnimalID.Text = String.Empty
        txtLabTestSampleTypeName.Text = String.Empty
        txtLabTestEIDSSLaboratorySampleID.Text = String.Empty
        txtLabTestTestStatusTypeName.Text = Resources.Labels.Lbl_Final_Text
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
            Dim labTests = TryCast(Session(TEST_LIST), List(Of GblTestGetListModel))
            Dim labTest = New GblTestGetListModel()

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                labTest = labTests.Where(Function(x) x.TestID = hdfRowID.Value).FirstOrDefault()
            End If

            labTest.SampleID = If(ddlLabTestSampleID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlLabTestSampleID.SelectedValue, Long))
            labTest.EIDSSLaboratorySampleID = If(ddlLabTestSampleID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlLabTestSampleID.SelectedItem.Text)

            Dim samples = CType(Session(SAMPLE_LIST), List(Of GblSampleGetListModel))
            Dim sample = samples.Where(Function(x) x.SampleID = ddlLabTestSampleID.SelectedValue).FirstOrDefault()
            If Not sample Is Nothing Then
                sample.FarmID = If(sample.FarmID.ToString.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(sample.FarmID, Long))
                sample.EIDSSFarmID = If(sample.EIDSSFarmID.ToString.IsValueNullOrEmpty(), Nothing, sample.EIDSSFarmID)
                sample.SpeciesID = If(sample.SpeciesID.ToString.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(sample.SpeciesID, Long))
                sample.SpeciesTypeName = If(sample.SpeciesTypeName.ToString.IsValueNullOrEmpty(), Nothing, sample.SpeciesTypeName)
                sample.AnimalID = If(sample.AnimalID.ToString.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(sample.AnimalID, Long))
                sample.EIDSSAnimalID = If(sample.EIDSSAnimalID.IsValueNullOrEmpty(), Nothing, sample.EIDSSAnimalID)
            End If

            labTest.TestCategoryTypeID = If(ddlLabTestTestCategoryTypeID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlLabTestTestCategoryTypeID.SelectedValue, Long))
            labTest.TestCategoryTypeName = If(ddlLabTestTestCategoryTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlLabTestTestCategoryTypeID.SelectedItem.Text)

            labTest.TestNameTypeID = If(ddlLabTestTestNameTypeID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlLabTestTestNameTypeID.SelectedValue, Long))
            labTest.TestNameTypeName = If(ddlLabTestTestNameTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlLabTestTestNameTypeID.SelectedItem.Text)

            labTest.ResultDate = If(txtLabTestResultDate.Text.IsValueNullOrEmpty(), CType(Nothing, DateTime?), Convert.ToDateTime(txtLabTestResultDate.Text))
            labTest.DiseaseID = lbxDiseaseID.SelectedValue
            labTest.DiseaseName = lbxDiseaseID.SelectedItem.Text
            labTest.SampleTypeName = If(txtLabTestSampleTypeName.Text.IsValueNullOrEmpty(), Nothing, txtLabTestSampleTypeName.Text)
            labTest.EIDSSLaboratorySampleID = If(txtLabTestEIDSSLaboratorySampleID.Text.IsValueNullOrEmpty(), Nothing, txtLabTestEIDSSLaboratorySampleID.Text)

            labTest.TestResultTypeID = If(ddlLabTestTestResultTypeID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlLabTestTestResultTypeID.SelectedValue, Long))
            labTest.TestResultTypeName = If(ddlLabTestTestResultTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlLabTestTestResultTypeID.SelectedItem.Text)

            'Entered by epidemiologist, default to final.
            labTest.TestStatusTypeID = TestStatusTypes.Final
            labTest.TestStatusTypeName = Resources.Labels.Lbl_Final_Text

            labTest.ObservationID = Nothing
            labTest.ReadOnlyIndicator = 1
            labTest.NonLaboratoryTestIndicator = 1

            labTest.EIDSSAnimalID = If(txtLabTestEIDSSAnimalID.Text.IsValueNullOrEmpty(), Nothing, txtLabTestEIDSSAnimalID.Text)

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                If labTest.TestID > 0 Then
                    labTest.RowAction = RecordConstants.Update
                End If

                Dim interpretations = CType(Session(INTERPRETATION_LIST), List(Of GblTestInterpretationGetListModel))

                For Each interpretation In interpretations
                    If interpretation.TestID.ToString = labTest.TestID Then
                        interpretation.TestNameTypeID = labTest.TestNameTypeID
                        interpretation.TestNameTypeName = labTest.TestNameTypeName
                        interpretation.TestCategoryTypeID = labTest.TestCategoryTypeID
                        interpretation.TestCategoryTypeName = labTest.TestCategoryTypeName
                        interpretation.TestResultTypeID = labTest.TestResultTypeID
                        interpretation.TestResultTypeName = labTest.TestResultTypeName
                    End If
                Next

                gvTestInterpretations.DataSource = Nothing
                Session(INTERPRETATION_LIST) = interpretations
                gvTestInterpretations.DataSource = Session(INTERPRETATION_LIST)
                gvTestInterpretations.DataBind()
            Else
                hdfIdentity.Value += 1
                Dim identity As Integer = (hdfIdentity.Value * -1)
                labTest.TestID = identity
                labTest.RowStatus = RecordConstants.ActiveRowStatus
                labTest.RowAction = RecordConstants.Insert
                labTests.Add(labTest)
            End If

            gvLabTests.DataSource = Nothing
            Session(TEST_LIST) = labTests.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus).OrderBy(Function(x) x.EIDSSLaboratorySampleID)
            gvLabTests.DataSource = Session(TEST_LIST)
            gvLabTests.DataBind()

            ResetTest()

            upTestsResultSummaries.Update()

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
                    e.Handled = True
                    DeleteTest(e.CommandArgument)
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditTest(e.CommandArgument)
                Case GridViewCommandConstants.NewInterpretationCommand
                    e.Handled = True
                    NewInterpretation(e.CommandArgument)
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
    Private Sub EditTest(labTestID As Long)

        Dim labTests = CType(Session(TEST_LIST), List(Of GblTestGetListModel))
        Dim labTest = labTests.Where(Function(x) x.TestID = labTestID).FirstOrDefault()
        Dim samples = TryCast(Session(SAMPLE_LIST), List(Of GblSampleGetListModel))
        If samples Is Nothing Then
            samples = New List(Of GblSampleGetListModel)()
        End If
        Dim sample = samples.Where(Function(x) x.SampleID = labTest.SampleID).FirstOrDefault()

        If Not labTest Is Nothing Then
            ddlLabTestSampleID.SelectedValue = If(labTest.SampleID.ToString.IsValueNullOrEmpty(), Nothing, labTest.SampleID)
            ddlLabTestTestCategoryTypeID.SelectedValue = If(labTest.TestCategoryTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), CType(labTest.TestCategoryTypeID, Long))
            ddlLabTestTestNameTypeID.SelectedValue = If(labTest.TestNameTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), CType(labTest.TestNameTypeID, Long))
            ddlLabTestTestResultTypeID.SelectedValue = If(labTest.TestResultTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), CType(labTest.TestResultTypeID, Long))
            txtLabTestResultDate.Text = If(labTest.ResultDate.ToString.IsValueNullOrEmpty(), String.Empty, labTest.ResultDate)
            txtLabTestDiseaseName.Text = If(labTest.DiseaseName.ToString.IsValueNullOrEmpty(), String.Empty, labTest.DiseaseName)
            txtLabTestSampleTypeName.Text = If(labTest.SampleTypeName.ToString.IsValueNullOrEmpty(), String.Empty, labTest.SampleTypeName)
            txtLabTestEIDSSLaboratorySampleID.Text = If(labTest.EIDSSLaboratorySampleID.ToString.IsValueNullOrEmpty(), Nothing, labTest.EIDSSLaboratorySampleID)
            txtLabTestTestStatusTypeName.Text = If(labTest.TestStatusTypeName.ToString.IsValueNullOrEmpty(), String.Empty, labTest.TestStatusTypeName)
            txtLabTestEIDSSFarmID.Text = If(labTest.EIDSSFarmID.ToString.IsValueNullOrEmpty(), String.Empty, labTest.EIDSSFarmID)
            txtLabTestEIDSSAnimalID.Text = If(labTest.EIDSSAnimalID.ToString.IsValueNullOrEmpty(), String.Empty, labTest.EIDSSAnimalID)
            hdfRowID.Value = labTest.TestID
            hdfRowAction.Value = labTest.RowAction

            ToggleVisibility(SectionTest)
            If ddlSpeciesType.SelectedValue = HACodeList.Avian Then
                divTestAnimalContainer.Visible = False
            Else
                divTestAnimalContainer.Visible = True
            End If

            upHiddenFields.Update()
            upLabTestModal.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divLabTestModal"), True)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="labTestID"></param>
    Private Sub DeleteTest(labTestID As Long)

        ViewState("Action") = "DeleteTest"
        ViewState("labTestID") = labTestID
        RaiseEvent ShowWarningModal(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Nothing)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="labTestID"></param>
    ''' <returns></returns>
    Public Function CanDeleteTest(ByVal labTestID As Long) As Boolean

        Dim interpretations = TryCast(Session(INTERPRETATION_LIST), List(Of GblTestInterpretationGetListModel))

        If interpretations.Where(Function(x) x.TestID = labTestID).Count = 0 Then
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
    Protected Sub LabTestSampleID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlLabTestSampleID.SelectedIndexChanged

        Try
            Dim samples = TryCast(Session(SAMPLE_LIST), List(Of GblSampleGetListModel))

            If Not ddlLabTestSampleID.SelectedValue = Nothing Then
                Dim sample = samples.Where(Function(x) x.SampleID = ddlLabTestSampleID.SelectedValue).FirstOrDefault()

                txtLabTestEIDSSAnimalID.Text = If(sample.EIDSSAnimalID.ToString.IsValueNullOrEmpty(), Nothing, sample.EIDSSAnimalID)
                txtLabTestSampleTypeName.Text = If(sample.SampleTypeName.ToString.IsValueNullOrEmpty(), Nothing, sample.SampleTypeName)
                txtLabTestEIDSSFarmID.Text = If(sample.EIDSSFarmID.ToString.IsValueNullOrEmpty(), Nothing, sample.EIDSSFarmID)

                cmvTestResultDateCollectionDate.ValueToCompare = sample.CollectionDate
                cmvTestResultDateCollectionDate.Type = ValidationDataType.Date
            End If

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divLabTestModal"), True)
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
    Private Sub FilterByDisease_CheckedChanged(sender As Object, e As EventArgs) Handles chkFilterByDisease.CheckedChanged

        Try
            FillTestNameType()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillTestNameType()

        Try
            If chkFilterByDisease.Checked = True Then
                If DiseaseTestTypeMatrixAPIService Is Nothing Then
                    DiseaseTestTypeMatrixAPIService = New DiseaseLabTestServiceClient()
                End If
                Dim diseaseTestTypeMatrix As List(Of ConfDiseaselabtestmatrixGetlistModel) = DiseaseTestTypeMatrixAPIService.GetConfDiseaselabtestmatrices(GetCurrentLanguage()).Result

                ddlLabTestTestNameTypeID.Items.Clear()
                ddlLabTestTestNameTypeID.Items.Add(New ListItem With {.Text = String.Empty, .Value = GlobalConstants.NullValue.ToLower()})

                For Each matrice In diseaseTestTypeMatrix
                    ddlLabTestTestNameTypeID.Items.Add(New ListItem With {.Text = matrice.strTestName, .Value = matrice.idfsTestName})
                Next
            Else
                If ddlSpeciesType.SelectedValue = HACodeList.AvianHACode Then
                    FillBaseReferenceDropDownList(ddlLabTestTestNameTypeID, BaseReferenceConstants.TestName, HACodeList.AvianHACode, True)
                Else
                    FillBaseReferenceDropDownList(ddlLabTestTestNameTypeID, BaseReferenceConstants.TestName, HACodeList.LivestockHACode, True)
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
    Private Sub FilterByTestName_CheckedChanged(sender As Object, e As EventArgs) Handles chkFilterByTestName.CheckedChanged

        Try
            FillTestResultType()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub FillTestResultType()

        Try
            ddlLabTestTestResultTypeID.Items.Clear()

            If chkFilterByTestName.Checked = True Then
                If ddlLabTestTestNameTypeID.SelectedValue.IsValueNullOrEmpty() = False Then
                    If TestTestResultTypeMatrixAPIService Is Nothing Then
                        TestTestResultTypeMatrixAPIService = New TestTestResultServiceClient()
                    End If
                    Dim testTestResultTypeMatrix As List(Of ConfTesttotestresultmatrixGetlistModel) = TestTestResultTypeMatrixAPIService.GetConfTesttotestresultmatrices(GetCurrentLanguage(), ReferenceTypes.TestName, ddlLabTestTestNameTypeID.SelectedValue).Result

                    ddlLabTestTestResultTypeID.Items.Add(New ListItem With {.Text = String.Empty, .Value = GlobalConstants.NullValue.ToLower()})

                    For Each matrice In testTestResultTypeMatrix
                        ddlLabTestTestResultTypeID.Items.Add(New ListItem With {.Text = matrice.strTestName, .Value = matrice.idfsTestName})
                    Next
                End If
            Else
                If ddlSpeciesType.SelectedValue = HACodeList.AvianHACode Then
                    FillBaseReferenceDropDownList(ddlLabTestTestResultTypeID, BaseReferenceConstants.TestResult, HACodeList.AvianHACode, True)
                Else
                    FillBaseReferenceDropDownList(ddlLabTestTestResultTypeID, BaseReferenceConstants.TestResult, HACodeList.LivestockHACode, True)
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Result Summary Methods"

    Private Sub FillResultSummaries(ByVal refresh As Boolean)

        Try
            Dim testInterpretations = New List(Of GblTestInterpretationGetListModel)()

            If refresh Then Session(INTERPRETATION_LIST) = Nothing

            If IsNothing(Session(INTERPRETATION_LIST)) Then
                If CrossCuttingAPIService Is Nothing Then
                    CrossCuttingAPIService = New CrossCuttingServiceClient()
                End If
                testInterpretations = CrossCuttingAPIService.GetTestInterpretationListAsync(GetCurrentLanguage(), Nothing, Nothing, hdfMonitoringSessionID.Value, Nothing, Nothing).Result
                Session(INTERPRETATION_LIST) = testInterpretations
            Else
                testInterpretations = CType(Session(INTERPRETATION_LIST), List(Of GblTestInterpretationGetListModel))
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
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub ResultSummaryValidatedStatusIndicator_CheckedChanged(sender As Object, e As EventArgs) Handles chkResultSummaryValidatedStatusIndicator.CheckedChanged

        Try
            If chkResultSummaryValidatedStatusIndicator.Checked Then
                txtResultSummaryValidatedDate.Text = Date.Today
                txtResultSummaryValidatedByPersonName.Text = EIDSSAuthenticatedUser.UserName
                hdfResultSummaryValidatedByPersonID.Value = EIDSSAuthenticatedUser.PersonId
            Else
                txtResultSummaryValidatedDate.Text = ""
                txtResultSummaryValidatedByPersonName.Text = ""
                hdfResultSummaryValidatedByPersonID.Value = "NULL"
            End If

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divInterpretationModal"), True)
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
    Protected Sub ResultSummaryInterpretedStatusTypeID_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlResultSummaryInterpretedStatusTypeID.SelectedIndexChanged

        Try
            If ddlResultSummaryInterpretedStatusTypeID.SelectedIndex = -1 Then
                txtResultSummaryInterpretedDate.Text = String.Empty
                txtResultSummaryInterpretedByPersonName.Text = String.Empty
                hdfResultSummaryInterpretedByPersonID.Value = GlobalConstants.NullValue.ToLower()
                txtResultSummaryInterpretedComment.Enabled = False
                txtResultSummaryInterpretedComment.Text = String.Empty
            Else
                txtResultSummaryInterpretedDate.Text = Date.Today
                txtResultSummaryInterpretedByPersonName.Text = EIDSSAuthenticatedUser.UserName
                hdfResultSummaryInterpretedByPersonID.Value = EIDSSAuthenticatedUser.PersonId
                txtResultSummaryInterpretedComment.Enabled = True
            End If

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divResultSummaryModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="interpretationID"></param>
    Private Sub NewInterpretation(interpretationID As Long)

        hdfTestID.Value = interpretationID.ToString()

        ResetResultSummary()

        Dim labTests = CType(Session(TEST_LIST), List(Of GblTestGetListModel))
        Dim labTest = labTests.Where(Function(x) x.TestID = hdfTestID.Value).FirstOrDefault
        If Not labTest Is Nothing Then
            txtResultSummaryEIDSSFarmID.Text = If(labTest.EIDSSFarmID.ToString.IsValueNullOrEmpty(), String.Empty, labTest.EIDSSFarmID)
            txtResultSummarySpeciesTypeName.Text = If(labTest.SpeciesTypeName.ToString.IsValueNullOrEmpty(), String.Empty, labTest.SpeciesTypeName)
            txtResultSummaryEIDSSAnimalID.Text = If(labTest.EIDSSAnimalID.ToString.IsValueNullOrEmpty(), String.Empty, labTest.EIDSSAnimalID)
            txtResultSummaryEIDSSLaboratorySampleID.Text = If(labTest.EIDSSLaboratorySampleID.ToString.IsValueNullOrEmpty(), String.Empty, labTest.EIDSSLaboratorySampleID)
            txtResultSummarySampleTypeName.Text = If(labTest.SampleTypeName.ToString.IsValueNullOrEmpty(), String.Empty, labTest.SampleTypeName)
            txtResultSummaryEIDSSLocalOrFieldSampleID.Text = If(labTest.EIDSSLocalOrFieldSampleID.ToString.IsValueNullOrEmpty(), String.Empty, labTest.EIDSSLocalOrFieldSampleID)
            txtResultSummaryDiseaseName.Text = If(labTest.DiseaseName.ToString.IsValueNullOrEmpty(), String.Empty, labTest.DiseaseName)
            txtResultSummaryTestCategoryTypeName.Text = If(labTest.TestCategoryTypeName.ToString.IsValueNullOrEmpty(), String.Empty, labTest.TestCategoryTypeName)
            txtResultSummaryTestTypeName.Text = If(labTest.TestNameTypeName.ToString.IsValueNullOrEmpty(), String.Empty, labTest.TestNameTypeName)
        End If

        hdfRowAction.Value = RecordConstants.Insert

        ToggleVisibility(SectionResultSummary)
        btnCreateDiseaseReport.Visible = False
        If ddlSpeciesType.SelectedValue = HACodeList.Avian Then
            divResultSummaryAnimalContainer.Visible = False
        Else
            divResultSummaryAnimalContainer.Visible = True
        End If

        upResultSummaryModal.Update()

        ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divResultSummaryModal"), True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ResetResultSummary()

        chkResultSummaryValidatedStatusIndicator.Checked = False
        ddlResultSummaryInterpretedStatusTypeID.SelectedIndex = -1
        txtResultSummaryInterpretedDate.Text = String.Empty
        txtResultSummaryValidatedDate.Text = String.Empty
        txtResultSummaryInterpretedComment.Text = String.Empty
        txtResultSummaryValidatedComment.Text = String.Empty
        txtResultSummaryValidatedByPersonName.Text = String.Empty
        txtResultSummaryDiseaseName.Text = String.Empty
        txtResultSummaryInterpretedByPersonName.Text = String.Empty
        txtResultSummarySampleTypeName.Text = String.Empty
        txtResultSummaryEIDSSAnimalID.Text = String.Empty
        txtResultSummaryEIDSSLaboratorySampleID.Text = String.Empty
        txtResultSummaryEIDSSFarmID.Text = String.Empty
        txtResultSummarySpeciesTypeName.Text = String.Empty
        txtResultSummaryEIDSSLocalOrFieldSampleID.Text = String.Empty
        txtResultSummaryTestCategoryTypeName.Text = String.Empty
        txtResultSummaryTestTypeName.Text = String.Empty
        hdfRowID.Value = "0"
        hdfRowAction.Value = String.Empty
        hdfResultSummaryInterpretedByPersonID.Value = String.Empty
        hdfResultSummaryValidatedByPersonID.Value = String.Empty

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
                    e.Handled = True
                    DeleteResultSummary(e.CommandArgument)
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditResultSummary(e.CommandArgument)
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="interpretationID"></param>
    Private Sub EditResultSummary(interpretationID As Long)

        Dim interpretations = TryCast(Session(INTERPRETATION_LIST), List(Of GblTestInterpretationGetListModel))
        Dim interpretation = interpretations.Where(Function(x) x.TestInterpretationID = interpretationID).FirstOrDefault()

        If Not interpretation Is Nothing Then
            txtResultSummaryEIDSSFarmID.Text = If(interpretation.EIDSSFarmID.ToString.IsValueNullOrEmpty(), String.Empty, interpretation.EIDSSFarmID)
            txtResultSummarySpeciesTypeName.Text = If(interpretation.SpeciesTypeName.ToString.IsValueNullOrEmpty(), String.Empty, interpretation.SpeciesTypeName)
            txtResultSummaryEIDSSAnimalID.Text = If(interpretation.EIDSSAnimalID.ToString.IsValueNullOrEmpty(), String.Empty, interpretation.EIDSSAnimalID)
            txtResultSummaryEIDSSLaboratorySampleID.Text = If(interpretation.EIDSSLaboratorySampleID.ToString.IsValueNullOrEmpty(), String.Empty, interpretation.EIDSSLaboratorySampleID)
            txtResultSummarySampleTypeName.Text = If(interpretation.SampleTypeName.ToString.IsValueNullOrEmpty(), String.Empty, interpretation.SampleTypeName)
            txtResultSummaryEIDSSLocalOrFieldSampleID.Text = If(interpretation.EIDSSLocalOrFieldSampleID.ToString.IsValueNullOrEmpty(), String.Empty, interpretation.EIDSSLocalOrFieldSampleID)
            txtResultSummaryDiseaseName.Text = If(interpretation.DiseaseName.ToString.IsValueNullOrEmpty(), String.Empty, interpretation.DiseaseName)
            txtResultSummaryTestCategoryTypeName.Text = If(interpretation.TestCategoryTypeName.ToString.IsValueNullOrEmpty(), String.Empty, interpretation.TestCategoryTypeName)
            txtResultSummaryTestTypeName.Text = If(interpretation.TestNameTypeName.ToString.IsValueNullOrEmpty(), String.Empty, interpretation.TestNameTypeName)
            ddlResultSummaryInterpretedStatusTypeID.SelectedValue = If(interpretation.InterpretedStatusTypeID.ToString.IsValueNullOrEmpty(), String.Empty, interpretation.InterpretedStatusTypeID)
            txtResultSummaryInterpretedByPersonName.Text = If(interpretation.InterpretedByPersonName.ToString.IsValueNullOrEmpty(), String.Empty, interpretation.InterpretedByPersonName)
            hdfResultSummaryInterpretedByPersonID.Value = If(interpretation.InterpretedByPersonID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), interpretation.InterpretedByPersonID)
            txtResultSummaryInterpretedDate.Text = If(interpretation.InterpretedDate.ToString.IsValueNullOrEmpty(), String.Empty, interpretation.InterpretedDate)
            txtResultSummaryValidatedDate.Text = If(interpretation.ValidatedDate.ToString.IsValueNullOrEmpty(), String.Empty, interpretation.ValidatedDate)
            txtResultSummaryInterpretedComment.Text = If(interpretation.InterpretedComment.ToString.IsValueNullOrEmpty(), String.Empty, interpretation.InterpretedComment)
            txtResultSummaryValidatedComment.Text = If(interpretation.ValidatedComment.ToString.IsValueNullOrEmpty(), String.Empty, interpretation.ValidatedComment)
            txtResultSummaryValidatedByPersonName.Text = If(interpretation.ValidatedByPersonName.ToString.IsValueNullOrEmpty(), String.Empty, interpretation.ValidatedByPersonName)
            hdfResultSummaryValidatedByPersonID.Value = If(interpretation.ValidatedByPersonID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), interpretation.ValidatedByPersonID)
            chkResultSummaryValidatedStatusIndicator.Checked = If(interpretation.ValidatedStatusIndicator.ToString.IsValueNullOrEmpty(), String.Empty, interpretation.ValidatedStatusIndicator)
            hdfRowID.Value = interpretation.TestInterpretationID
            hdfRowAction.Value = interpretation.RowAction.ToString

            ToggleVisibility(SectionResultSummary)
            If Not interpretation.EIDSSFarmID.ToString = String.Empty AndAlso interpretation.RowAction = "R" Then
                btnCreateDiseaseReport.CommandArgument = interpretationID
                btnCreateDiseaseReport.Visible = True
            Else
                btnCreateDiseaseReport.Visible = False
            End If

            If ddlSpeciesType.SelectedValue = HACodeList.Avian Then
                divResultSummaryAnimalContainer.Visible = False
            Else
                divResultSummaryAnimalContainer.Visible = True
            End If

            upHiddenFields.Update()
            upResultSummaryModal.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divResultSummaryModal"), True)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="interpretationID"></param>
    Private Sub DeleteResultSummary(interpretationID As Long)

        ViewState("Action") = "DeleteResultSummary"
        ViewState("interpretationID") = interpretationID
        RaiseEvent ShowWarningModal(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Nothing)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="interpretationID"></param>
    ''' <returns></returns>
    Public Function CanDeleteInterpretation(ByVal interpretationID As Long) As Boolean

        Dim interpretations = TryCast(Session(INTERPRETATION_LIST), List(Of GblTestInterpretationGetListModel))

        If interpretations.Where(Function(x) x.TestInterpretationID = interpretationID).Count = 0 Then
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
    Protected Sub ResultSummarySave_Click(sender As Object, e As EventArgs) Handles btnResultSummarySave.Click

        Try
            Dim interpretations = TryCast(Session(INTERPRETATION_LIST), List(Of GblTestInterpretationGetListModel))
            Dim interpretation As GblTestInterpretationGetListModel = New GblTestInterpretationGetListModel()

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                interpretation = interpretations.Where(Function(x) x.TestInterpretationID = hdfRowID.Value).FirstOrDefault()
            End If

            interpretation.InterpretedStatusTypeID = If(ddlResultSummaryInterpretedStatusTypeID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), ddlResultSummaryInterpretedStatusTypeID.SelectedValue)
            interpretation.InterpretedByPersonName = If(txtResultSummaryInterpretedByPersonName.Text.IsValueNullOrEmpty(), Nothing, txtResultSummaryInterpretedByPersonName.Text)
            interpretation.InterpretedByPersonID = hdfResultSummaryInterpretedByPersonID.Value
            interpretation.InterpretedStatusTypeName = If(ddlResultSummaryInterpretedStatusTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlResultSummaryInterpretedStatusTypeID.SelectedItem.Text)
            interpretation.InterpretedDate = If(txtResultSummaryInterpretedDate.Text.IsValueNullOrEmpty(), CType(Nothing, Date?), Convert.ToDateTime(txtResultSummaryInterpretedDate.Text))
            interpretation.InterpretedComment = If(txtResultSummaryInterpretedComment.Text.IsValueNullOrEmpty(), Nothing, txtResultSummaryInterpretedComment.Text)
            interpretation.ValidatedDate = If(txtResultSummaryValidatedDate.Text.IsValueNullOrEmpty(), Nothing, Convert.ToDateTime(txtResultSummaryValidatedDate.Text))
            interpretation.ValidatedComment = If(txtResultSummaryValidatedComment.Text.IsValueNullOrEmpty(), Nothing, txtResultSummaryValidatedComment.Text)
            interpretation.ValidatedByPersonName = If(txtResultSummaryValidatedByPersonName.Text.IsValueNullOrEmpty(), Nothing, txtResultSummaryValidatedByPersonName.Text)
            interpretation.ValidatedByPersonID = hdfResultSummaryValidatedByPersonID.Value
            interpretation.ValidatedStatusIndicator = chkResultSummaryValidatedStatusIndicator.Checked
            interpretation.ReadOnlyIndicator = False
            interpretation.DiseaseID = lbxDiseaseID.SelectedValue
            interpretation.DiseaseName = lbxDiseaseID.SelectedItem.Text

            Dim labTests = CType(Session(TEST_LIST), List(Of GblTestGetListModel))
            Dim labTest = labTests.Where(Function(x) x.TestID = hdfTestID.Value).FirstOrDefault()
            If Not labTest Is Nothing Then
                interpretation.TestID = labTest.TestID
                interpretation.TestCategoryTypeID = labTest.TestCategoryTypeID
                interpretation.TestCategoryTypeName = labTest.TestCategoryTypeName
                interpretation.TestNameTypeID = labTest.TestNameTypeID
                interpretation.TestNameTypeName = labTest.TestNameTypeName
                interpretation.TestResultTypeID = labTest.TestResultTypeID
                interpretation.TestResultTypeName = labTest.TestResultTypeName
                interpretation.FarmID = If(labTest.FarmID.ToString.IsValueNullOrEmpty(), CType(Nothing, Long?), labTest.FarmID)
                interpretation.EIDSSFarmID = If(labTest.EIDSSFarmID.ToString.IsValueNullOrEmpty(), Nothing, labTest.EIDSSFarmID)
                interpretation.SpeciesID = If(labTest.SpeciesID.ToString.IsValueNullOrEmpty(), CType(Nothing, Long?), labTest.SpeciesID)
                interpretation.SpeciesTypeName = If(labTest.SpeciesTypeName.ToString.IsValueNullOrEmpty(), Nothing, labTest.SpeciesTypeName)
                interpretation.EIDSSAnimalID = If(labTest.EIDSSAnimalID.ToString.IsValueNullOrEmpty(), Nothing, labTest.EIDSSAnimalID)
                interpretation.EIDSSLocalOrFieldSampleID = If(labTest.EIDSSLocalOrFieldSampleID.ToString.IsValueNullOrEmpty(), Nothing, labTest.EIDSSLocalOrFieldSampleID)
                interpretation.SampleTypeName = If(labTest.SampleTypeName.ToString.IsValueNullOrEmpty(), Nothing, labTest.SampleTypeName)
            End If

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                If interpretation.TestInterpretationID > 0 Then
                    interpretation.RowAction = RecordConstants.Update
                End If
            Else
                hdfIdentity.Value += 1
                Dim identity As Integer = (hdfIdentity.Value * -1)
                interpretation.TestInterpretationID = identity
                interpretation.RowStatus = RecordConstants.ActiveRowStatus
                interpretation.RowAction = RecordConstants.Insert
                interpretations.Add(interpretation)
            End If


            Session(INTERPRETATION_LIST) = interpretations.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus)
            gvTestInterpretations.DataSource = Nothing
            gvTestInterpretations.DataSource = Session(INTERPRETATION_LIST)
            gvTestInterpretations.DataBind()

            ResetResultSummary()

            upTestsResultSummaries.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divResultSummaryModal"), True)
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
    Protected Sub ResultSummaryCancel_Click(sender As Object, e As EventArgs) Handles btnResultSummaryCancel.Click

        Try
            ShowWarningMessage(messageType:=MessageType.CancelResultSummaryConfirm, isConfirm:=True, message:=Nothing)
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
    Protected Sub CreateDiseaseReport_Click(sender As Object, e As EventArgs) Handles btnCreateDiseaseReport.Click

        Try
            Dim btn As LinkButton = sender
            Dim recordID As String
            recordID = btn.CommandArgument.ToString()

            Dim interpretations = TryCast(Session(INTERPRETATION_LIST), List(Of GblTestInterpretationGetListModel))
            Dim interpretation = interpretations.Where(Function(x) x.TestInterpretationID = recordID).FirstOrDefault()

            Session(FarmConstants.FarmID) = interpretation.FarmID
            ViewState(CALLER) = CallerPages.VeterinaryActiveSurveillanceMonitoringSession
            ViewState(CALLER_KEY) = hdfMonitoringSessionID.Value

            SaveEIDSSViewState(ViewState)

            If ddlSpeciesType.SelectedValue = HACodeList.Avian Then
                Response.Redirect(GetURL(CallerPages.AvianVeterinaryDiseaseReportURL), True)
            Else
                Response.Redirect(GetURL(CallerPages.LivestockVeterinaryDiseaseReportURL), True)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Action Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refresh"></param>
    Private Sub FillActions(ByVal refresh As Boolean)

        Try
            Dim actions = New List(Of VctMonitoringSessionActionGetListModel)()

            If refresh Then Session(ACTION_LIST) = Nothing

            If IsNothing(Session(ACTION_LIST)) Then
                If VeterinaryAPIService Is Nothing Then
                    VeterinaryAPIService = New VeterinaryServiceClient()
                End If
                actions = VeterinaryAPIService.GetMonitoringSessionActionListAsync(GetCurrentLanguage(), hdfMonitoringSessionID.Value).Result
                Session(TEST_LIST) = actions
            Else
                actions = CType(Session(ACTION_LIST), List(Of VctMonitoringSessionActionGetListModel))
            End If

            gvActions.DataSource = Nothing
            gvActions.DataSource = actions
            gvActions.DataBind()
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
    Protected Sub AddAction_Click(sender As Object, e As EventArgs) Handles btnAddAction.Click

        Try
            ResetAction()

            hdfRowAction.Value = RecordConstants.Insert

            upActionModal.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divActionModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ResetAction()

        ddlActionMonitoringSessionActionTypeID.SelectedIndex = -1
        txtActionActionDate.Text = String.Empty
        txtActionComments.Text = String.Empty
        ddlActionMonitoringSessionActionStatusTypeID.SelectedIndex = -1
        hdfRowID.Value = "0"
        hdfRowAction.Value = String.Empty

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub ActionSave_Click(sender As Object, e As EventArgs) Handles btnActionSave.Click

        Try
            Dim actions = TryCast(Session(ACTION_LIST), List(Of VctMonitoringSessionActionGetListModel))
            Dim action As VctMonitoringSessionActionGetListModel = New VctMonitoringSessionActionGetListModel()

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                action = actions.Where(Function(x) x.MonitoringSessionActionID = hdfRowID.Value).FirstOrDefault()
            End If

            action.MonitoringSessionID = hdfMonitoringSessionID.Value
            action.ActionDate = If(txtActionActionDate.Text.IsValueNullOrEmpty(), CType(Nothing, Date?), Convert.ToDateTime(txtActionActionDate.Text))
            action.EnteredByPersonID = EIDSSAuthenticatedUser.PersonId
            action.EnteredByPersonName = txtActionEnteredByPersonName.Text
            action.MonitoringSessionActionStatusTypeID = If(ddlActionMonitoringSessionActionStatusTypeID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlActionMonitoringSessionActionStatusTypeID.SelectedValue, Long))
            action.MonitoringSessionActionStatusTypeName = If(ddlActionMonitoringSessionActionStatusTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlActionMonitoringSessionActionStatusTypeID.SelectedItem.Text)
            action.Comments = If(txtActionComments.Text.IsValueNullOrEmpty(), Nothing, txtActionComments.Text)
            action.MonitoringSessionActionTypeID = If(ddlActionMonitoringSessionActionTypeID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlActionMonitoringSessionActionTypeID.SelectedValue, Long))
            action.MonitoringSessionActionTypeName = If(ddlActionMonitoringSessionActionTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlActionMonitoringSessionActionTypeID.SelectedItem.Text)

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                If action.MonitoringSessionActionID > 0 Then
                    action.RowAction = RecordConstants.Update
                End If
            Else
                hdfIdentity.Value += 1
                Dim identity As Integer = (hdfIdentity.Value * -1)
                action.MonitoringSessionActionID = identity
                action.RowStatus = RecordConstants.ActiveRowStatus
                action.RowAction = RecordConstants.Insert
                actions.Add(action)
            End If

            Session(ACTION_LIST) = actions.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus)
            gvActions.DataSource = Nothing
            gvActions.DataSource = Session(ACTION_LIST)
            gvActions.DataBind()

            ResetAction()

            upActions.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divActionModal"), True)
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
    Protected Sub ActionCancel_Click(sender As Object, e As EventArgs) Handles btnActionCancel.Click

        Try
            ShowWarningMessage(messageType:=MessageType.CancelActionConfirm, isConfirm:=True, message:=Nothing)
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
    Protected Sub Actions_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvActions.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    DeleteAction(e.CommandArgument)
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditAction(e.CommandArgument)
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="monitoringSessionActionID"></param>
    Private Sub EditAction(monitoringSessionActionID As Long)

        Dim actions = CType(Session(ACTION_LIST), List(Of VctMonitoringSessionActionGetListModel))
        Dim action = actions.Where(Function(x) x.MonitoringSessionActionID = monitoringSessionActionID).FirstOrDefault()

        If Not action Is Nothing Then
            ddlActionMonitoringSessionActionTypeID.SelectedValue = If(action.MonitoringSessionActionTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), action.MonitoringSessionActionTypeID)
            txtActionActionDate.Text = If(action.ActionDate.ToString.IsValueNullOrEmpty(), String.Empty, action.ActionDate)
            ddlActionMonitoringSessionActionStatusTypeID.SelectedValue = If(action.MonitoringSessionActionStatusTypeID.ToString.IsValueNullOrEmpty(), String.Empty, action.MonitoringSessionActionStatusTypeID)
            txtActionComments.Text = If(action.Comments, String.Empty)
            hdfRowID.Value = action.MonitoringSessionActionID
            hdfRowAction.Value = action.RowAction.ToString

            upHiddenFields.Update()
            upActionModal.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divActionModal"), True)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="monitoringSessionActionID"></param>
    Private Sub DeleteAction(monitoringSessionActionID As Long)

        ViewState("Action") = "DeleteAction"
        hdfRowID.Value = monitoringSessionActionID

        upHiddenFields.Update()

        ShowWarningMessage(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Nothing)

    End Sub

#End Region

#Region "Aggregate Information Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refresh"></param>
    Private Sub FillAggregateInfo(ByVal refresh As Boolean)

        Try
            Dim summaries = New List(Of VctMonitoringSessionSummaryGetListModel)()

            If refresh Then Session(SUMMARY_LIST) = Nothing

            If IsNothing(Session(SUMMARY_LIST)) Then
                If VeterinaryAPIService Is Nothing Then
                    VeterinaryAPIService = New VeterinaryServiceClient()
                End If
                summaries = VeterinaryAPIService.GetMonitoringSessionSummaryListAsync(GetCurrentLanguage(), hdfMonitoringSessionID.Value).Result
                Session(SUMMARY_LIST) = summaries
            Else
                summaries = CType(Session(SUMMARY_LIST), List(Of VctMonitoringSessionSummaryGetListModel))
            End If

            gvAggregateInfos.DataSource = Nothing
            gvAggregateInfos.DataSource = summaries
            gvAggregateInfos.DataBind()
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
    Protected Sub AddAggregateInfo_Click(sender As Object, e As EventArgs) Handles btnAddAggregateInfo.Click

        Try
            ResetAggregateInfo()

            hdfRowAction.Value = RecordConstants.Insert

            upAggregateInfo.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAggregateInfoModal"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub ResetAggregateInfo()

        txtAggregateInfoEIDSSFarmID.Text = String.Empty
        hdfAggregateInfoFarmMasterID.Value = String.Empty
        ddlAggregateInfoSpeciesID.SelectedIndex = -1
        ddlSampleAnimalGenderTypeID.SelectedIndex = -1
        txtSampledAnimalsQuantity.Text = String.Empty
        ddlAggregateInfoSampleTypeID.SelectedIndex = -1
        txtSamplesQuantity.Text = String.Empty
        txtAggregateInfoCollectionDate.Text = String.Empty
        txtPositiveAnimalsQuantity.Text = String.Empty
        ddlAggregateInfoDiseaseID.SelectedIndex = -1
        hdfRowID.Value = "0"
        hdfRowAction.Value = String.Empty

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Private Sub AggregateInfoFarmLookup_Click(sender As Object, e As EventArgs) Handles btnAggregateInfoFarmLookup.Click

        Try
            If FarmAPIService Is Nothing Then
                FarmAPIService = New FarmServiceClient()
            End If

            Dim parameters As New FarmGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = 1}
            parameters.RegionID = If(MonitoringSessionAddress.SelectedRegionValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CLng(MonitoringSessionAddress.SelectedRegionValue))
            parameters.RayonID = If(MonitoringSessionAddress.SelectedRayonValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CLng(MonitoringSessionAddress.SelectedRayonValue))
            parameters.SettlementID = If(MonitoringSessionAddress.SelectedSettlementValue.IsValueNullOrEmpty() Or MonitoringSessionAddress.SelectedSettlementValue = "-1", CType(Nothing, Long?), CLng(MonitoringSessionAddress.SelectedSettlementValue))

            Dim list As List(Of VetFarmMasterGetCountModel)
            list = FarmAPIService.FarmMasterGetListCountAsync(parameters).Result
            gvAggregateInfoFarms.PageIndex = 0
            gvAggregateInfoFarms.Visible = True
            hdfAggregateInfoFarmCount.Value = list.FirstOrDefault().SearchCount

            upHiddenFields.Update()

            If list.FirstOrDefault().SearchCount = 1 Then
                lblAggregateInfoFarmRecordCount.Text = list.FirstOrDefault().SearchCount & " " & Resources.Labels.Lbl_Record_Found_Text & list.FirstOrDefault().TotalCount & " " & Resources.Labels.Lbl_Total_Records_Text
            Else
                lblAggregateInfoFarmRecordCount.Text = list.FirstOrDefault().SearchCount & " " & Resources.Labels.Lbl_Records_Found_Text & list.FirstOrDefault().TotalCount & " " & Resources.Labels.Lbl_Total_Records_Text
            End If

            lblAggregateInfoFarmPageNumber.Text = "1"

            FillAggregateInfoFarms(pageIndex:=1, paginationSetNumber:=1)

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_ON_MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAggregateInfoLookupFarmModal"), True)

            upAggregateInfoFarms.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="pageIndex"></param>
    ''' <param name="paginationSetNumber"></param>
    Private Sub FillAggregateInfoFarms(pageIndex As Integer, paginationSetNumber As Integer)

        Try
            Dim parameters As New FarmGetListParameters With {.LanguageID = GetCurrentLanguage(), .PaginationSetNumber = paginationSetNumber}
            parameters.RegionID = If(MonitoringSessionAddress.SelectedRegionValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CLng(MonitoringSessionAddress.SelectedRegionValue))
            parameters.RayonID = If(MonitoringSessionAddress.SelectedRayonValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CLng(MonitoringSessionAddress.SelectedRayonValue))
            parameters.SettlementID = If(MonitoringSessionAddress.SelectedSettlementValue.IsValueNullOrEmpty() Or MonitoringSessionAddress.SelectedSettlementValue = "-1", CType(Nothing, Long?), CLng(MonitoringSessionAddress.SelectedSettlementValue))

            If FarmAPIService Is Nothing Then
                FarmAPIService = New FarmServiceClient()
            End If

            Session(AGGREGATE_INFO_FARM_LIST) = FarmAPIService.FarmMasterGetListAsync(parameters).Result

            gvAggregateInfoFarms.DataSource = Nothing

            BindAggregateInfoFarmGridView()
            FillAggregateInfoFarmPager(hdfAggregateInfoFarmCount.Value, pageIndex)
            ViewState(AGGREGATE_INFO_FARM_PAGINATION_SET_NUMBER) = paginationSetNumber
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub BindAggregateInfoFarmGridView()

        Dim farms = CType(Session(AGGREGATE_INFO_FARM_LIST), List(Of VetFarmMasterGetListModel))

        If (Not ViewState(AGGREGATE_INFO_FARM_SORT_EXPRESSION) Is Nothing) Then
            If ViewState(AGGREGATE_INFO_FARM_SORT_DIRECTION) = SortConstants.Ascending Then
                farms = farms.OrderBy(Function(x) x.GetType().GetProperty(ViewState(AGGREGATE_INFO_FARM_SORT_EXPRESSION)).GetValue(x)).ToList()
            Else
                farms = farms.OrderByDescending(Function(x) x.GetType().GetProperty(ViewState(AGGREGATE_INFO_FARM_SORT_EXPRESSION)).GetValue(x)).ToList()
            End If
        End If

        gvAggregateInfoFarms.DataSource = farms
        gvAggregateInfoFarms.DataBind()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AggregateInfoFarmPage_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Try
            Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)

            lblAggregateInfoFarmPageNumber.Text = pageIndex.ToString()

            Dim paginationSetNumber As Integer
            paginationSetNumber = Math.Ceiling(pageIndex / gvAggregateInfoFarms.PageSize)

            If Not ViewState(AGGREGATE_INFO_FARM_PAGINATION_SET_NUMBER) = paginationSetNumber Then
                Select Case CType(sender, LinkButton).Text
                    Case PagingConstants.PreviousButtonText
                        gvAggregateInfoFarms.PageIndex = gvDetailedInfoFarms.PageSize - 1
                    Case PagingConstants.NextButtonText
                        gvAggregateInfoFarms.PageIndex = 0
                    Case PagingConstants.FirstButtonText
                        gvAggregateInfoFarms.PageIndex = 0
                    Case PagingConstants.LastButtonText
                        gvAggregateInfoFarms.PageIndex = 0
                    Case Else
                        If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                            gvAggregateInfoFarms.PageIndex = gvDetailedInfoFarms.PageSize - 1
                        Else
                            gvAggregateInfoFarms.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                        End If
                End Select

                FillAggregateInfoFarms(pageIndex, paginationSetNumber:=paginationSetNumber)
            Else
                If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                    gvAggregateInfoFarms.PageIndex = gvAggregateInfoFarms.PageSize - 1
                Else
                    gvAggregateInfoFarms.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                End If

                BindAggregateInfoFarmGridView()
                FillAggregateInfoFarmPager(hdfAggregateInfoFarmCount.Value, pageIndex)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="recordCount"></param>
    ''' <param name="currentPage"></param>
    Private Sub FillAggregateInfoFarmPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

        Dim pages As New List(Of ListItem)()
        Dim startIndex As Integer, endIndex As Integer
        Dim pagerSpan As Integer = 5

        If recordCount > 0 Then
            divAggregateInfoFarmPager.Visible = True

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

            rptAggregateInfoFarmPager.DataSource = pages
            rptAggregateInfoFarmPager.DataBind()
            divAggregateInfoFarmPager.Visible = True
        Else
            divAggregateInfoFarmPager.Visible = False
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AggregateInfoSave_Click(sender As Object, e As EventArgs) Handles btnAggregateInfoSave.Click

        Try
            Dim summaries = TryCast(Session(SUMMARY_LIST), List(Of VctMonitoringSessionSummaryGetListModel))
            Dim summary As VctMonitoringSessionSummaryGetListModel = New VctMonitoringSessionSummaryGetListModel()

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                summary = summaries.Where(Function(x) x.MonitoringSessionSummaryID = hdfRowID.Value).FirstOrDefault()
            End If

            summary.MonitoringSessionID = hdfMonitoringSessionID.Value
            summary.FarmID = If(hdfAggregateInfoFarmMasterID.Value.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(hdfAggregateInfoFarmMasterID.Value, Long))
            summary.EIDSSFarmID = If(txtAggregateInfoEIDSSFarmID.Text.IsValueNullOrEmpty(), Nothing, txtAggregateInfoEIDSSFarmID.Text)
            summary.SpeciesID = If(ddlAggregateInfoSpeciesID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlAggregateInfoSpeciesID.SelectedValue, Long))
            summary.SpeciesTypeName = If(ddlAggregateInfoSpeciesID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlAggregateInfoSpeciesID.SelectedItem.Text)
            summary.AnimalGenderTypeID = If(ddlSampleAnimalGenderTypeID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlSampleAnimalGenderTypeID.SelectedValue, Long))
            summary.AnimalGenderTypeName = If(ddlSampleAnimalGenderTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlSampleAnimalGenderTypeID.SelectedItem.Text)
            summary.SampledAnimalsQuantity = If(txtSampledAnimalsQuantity.Text.IsValueNullOrEmpty(), CType(Nothing, Integer?), CType(txtSampledAnimalsQuantity.Text, Integer))
            summary.SampleTypeID = If(ddlAggregateInfoSampleTypeID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlAggregateInfoSampleTypeID.SelectedValue, Long))
            summary.SampleTypeName = If(ddlAggregateInfoSampleTypeID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlAggregateInfoSampleTypeID.SelectedItem.Text)
            summary.SamplesQuantity = If(txtSamplesQuantity.Text.IsValueNullOrEmpty(), CType(Nothing, Integer?), CType(txtSamplesQuantity.Text, Integer))
            summary.CollectionDate = If(txtAggregateInfoCollectionDate.Text.IsValueNullOrEmpty(), CType(Nothing, Date?), CType(txtAggregateInfoCollectionDate.Text, Date))
            summary.PositiveAnimalsQuantity = If(txtPositiveAnimalsQuantity.Text.IsValueNullOrEmpty(), CType(Nothing, Integer?), CType(txtPositiveAnimalsQuantity.Text, Integer))
            summary.DiseaseID = If(ddlAggregateInfoDiseaseID.SelectedValue.IsValueNullOrEmpty(), CType(Nothing, Long?), CType(ddlAggregateInfoDiseaseID.SelectedValue, Long))
            summary.DiseaseName = If(ddlAggregateInfoDiseaseID.SelectedValue.IsValueNullOrEmpty(), Nothing, ddlAggregateInfoDiseaseID.SelectedItem.Text)

            If hdfRowAction.Value = RecordConstants.Read Or Not hdfRowID.Value = "0" Then
                If summary.MonitoringSessionSummaryID > 0 Then
                    summary.RowAction = RecordConstants.Update
                End If
            Else
                hdfIdentity.Value += 1
                Dim identity As Integer = (hdfIdentity.Value * -1)
                summary.MonitoringSessionSummaryID = identity
                summary.RowStatus = RecordConstants.ActiveRowStatus
                summary.RowAction = RecordConstants.Insert
                summaries.Add(summary)
            End If

            Session(SUMMARY_LIST) = summaries.Where(Function(x) x.RowStatus = RecordConstants.ActiveRowStatus)
            gvAggregateInfos.DataSource = Nothing
            gvAggregateInfos.DataSource = Session(SUMMARY_LIST)
            gvAggregateInfos.DataBind()

            ResetAggregateInfo()

            upAggregateInfos.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divAggregateInfoModal"), True)
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
    Protected Sub AggregateInfoCancel_Click(sender As Object, e As EventArgs) Handles btnAggregateInfoCancel.Click

        Try
            ShowWarningMessage(messageType:=MessageType.CancelAggregateInfoConfirm, isConfirm:=True, message:=Nothing)
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
    Protected Sub AggregateInfos_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvAggregateInfos.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    DeleteAggregateInfo(e.CommandArgument)
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditAggregateInfo(e.CommandArgument)
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="monitoringSessionSummaryID"></param>
    Private Sub EditAggregateInfo(monitoringSessionSummaryID As Long)

        Dim summaries = TryCast(Session(SUMMARY_LIST), List(Of VctMonitoringSessionSummaryGetListModel))
        If summaries Is Nothing Then
            summaries = New List(Of VctMonitoringSessionSummaryGetListModel)()
        End If
        Dim summary = summaries.Where(Function(x) x.MonitoringSessionSummaryID = monitoringSessionSummaryID).FirstOrDefault()

        If Not summary Is Nothing Then
            hdfAggregateInfoFarmMasterID.Value = If(summary.FarmID.ToString.IsValueNullOrEmpty(), String.Empty, summary.FarmID)
            txtAggregateInfoEIDSSFarmID.Text = If(summary.FarmID.ToString.IsValueNullOrEmpty(), String.Empty, summary.EIDSSFarmID)
            ddlAggregateInfoSpeciesID.SelectedValue = If(summary.SpeciesID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), summary.SpeciesID)
            ddlAggregateInfoAnimalGenderTypeID.SelectedValue = If(summary.AnimalGenderTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), summary.AnimalGenderTypeID)
            txtSampledAnimalsQuantity.Text = If(summary.SampledAnimalsQuantity.ToString.IsValueNullOrEmpty(), String.Empty, summary.SampledAnimalsQuantity)
            ddlAggregateInfoSampleTypeID.SelectedValue = If(summary.SampleTypeID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), summary.SampleTypeID)
            ddlAggregateInfoDiseaseID.SelectedValue = If(summary.DiseaseID.ToString.IsValueNullOrEmpty(), GlobalConstants.NullValue.ToLower(), summary.DiseaseID)
            txtSamplesQuantity.Text = If(summary.SamplesQuantity.ToString.IsValueNullOrEmpty(), String.Empty, summary.SamplesQuantity)
            txtAggregateInfoCollectionDate.Text = If(summary.CollectionDate.ToString.IsValueNullOrEmpty(), String.Empty, summary.CollectionDate)
            txtPositiveAnimalsQuantity.Text = If(summary.PositiveAnimalsQuantity.ToString.IsValueNullOrEmpty(), String.Empty, summary.PositiveAnimalsQuantity)
            hdfRowID.Value = summary.MonitoringSessionSummaryID
            hdfRowAction.Value = summary.RowAction.ToString

            upHiddenFields.Update()
            upAggregateInfo.Update()

            ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(SHOW_MODAL_HANDLER_SCRIPT, "#divAggregateInfoModal"), True)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="monitoringSessionSummaryID"></param>
    Private Sub DeleteAggregateInfo(monitoringSessionSummaryID As Long)

        hdfRowID.Value = monitoringSessionSummaryID

        upHiddenFields.Update()

        ShowWarningMessage(messageType:=MessageType.ConfirmDelete, isConfirm:=True, message:=Nothing)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub AggregateInfoFarms_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvAggregateInfoFarms.RowCommand

        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.SelectCommand
                        Dim commandArguments As String() = e.CommandArgument.ToString().Split(",")
                        Dim farms = TryCast(Session(AGGREGATE_INFO_FARM_LIST), List(Of VetFarmMasterGetListModel))
                        hdfAggregateInfoFarmMasterID.Value = farms.Where(Function(x) x.FarmMasterID = commandArguments(0)).FirstOrDefault().FarmMasterID
                        txtAggregateInfoEIDSSFarmID.Text = farms.Where(Function(x) x.FarmMasterID = commandArguments(0)).FirstOrDefault().EIDSSFarmID

                        Dim parameters = New FarmHerdSpeciesGetListParameters With {.LanguageID = GetCurrentLanguage()}
                        parameters.FarmMasterID = hdfAggregateInfoFarmMasterID.Value
                        If FarmAPIService Is Nothing Then
                            FarmAPIService = New FarmServiceClient()
                        End If
                        Dim farmInventory = FarmAPIService.FarmHerdSpeciesGetListAsync(parameters).Result

                        Dim speciesToSampleTypes = TryCast(Session(SPECIES_SAMPLE_TYPE_COMBINATION_LIST), List(Of VctMonitoringSessionSpeciesToSampleTypeGetListModel))
                        ddlAggregateInfoSpeciesID.Items.Clear()
                        If ddlAggregateInfoSpeciesID.Items.Count = 0 Then
                            ddlAggregateInfoSpeciesID.Items.Add(New ListItem With {.Text = String.Empty, .Value = GlobalConstants.NullValue.ToLower(), .Selected = False})
                        End If

                        For Each inventory In farmInventory
                            If inventory.RecordType.ToString() = RecordTypeConstants.Species Then
                                If speciesToSampleTypes.Where(Function(x) x.SpeciesTypeID = inventory.SpeciesTypeID.ToString()).Count > 0 Then
                                    ddlAggregateInfoSpeciesID.Items.Add(New ListItem With {.Value = If(inventory.SpeciesID.ToString.IsValueNullOrEmpty(), inventory.SpeciesMasterID, inventory.SpeciesID), .Text = (inventory.EIDSSHerdID & " - " & inventory.SpeciesTypeName), .Selected = False})
                                End If
                            End If
                        Next
                        ddlAggregateInfoSpeciesID = SortDropDownList(ddlSampleSpeciesID)
                        ddlAggregateInfoSpeciesID.Enabled = True

                        ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, String.Format(HIDE_MODAL_SCRIPT, "#divAggregateInfoLookupFarmModal"), True)

                        upAggregateInfo.Update()
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
    Private Sub SamplesQuantity_TextChanged(sender As Object, e As EventArgs) Handles txtSamplesQuantity.TextChanged

        Try
            If txtSamplesQuantity.Text.IsValueNullOrEmpty() = False Then
                txtPositiveAnimalsQuantity.MaxValue = txtSamplesQuantity.Text
            Else
                txtPositiveAnimalsQuantity.MaxValue = ""
            End If

            upAggregateInfo.Update()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Veterinary Disease Report Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refresh"></param>
    Private Sub FillVeterinaryDiseaseReportsList(Optional refresh As Boolean = False)

        Try
            Dim veterinaryDiseaseReports = New List(Of VetDiseaseReportGetListModel)()

            If refresh Then Session(VETERINARY_DISEASE_REPORT_LIST) = Nothing

            If IsNothing(Session(VETERINARY_DISEASE_REPORT_LIST)) Then
                If VeterinaryAPIService Is Nothing Then
                    VeterinaryAPIService = New VeterinaryServiceClient()
                End If
                Dim parameters = New VeterinaryDiseaseReportGetListParameters()
                parameters.LanguageID = GetCurrentLanguage()
                parameters.MonitoringSessionID = hdfMonitoringSessionID.Value
                veterinaryDiseaseReports = VeterinaryAPIService.GetVeterinaryDiseaseReportListAsync(parameters).Result
                Session(VETERINARY_DISEASE_REPORT_LIST) = veterinaryDiseaseReports
            Else
                veterinaryDiseaseReports = CType(Session(VETERINARY_DISEASE_REPORT_LIST), List(Of VetDiseaseReportGetListModel))
            End If

            gvVeterinaryDiseaseReports.DataSource = Nothing
            gvVeterinaryDiseaseReports.DataSource = veterinaryDiseaseReports
            gvVeterinaryDiseaseReports.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="veterinaryDiseaseReportID"></param>
    Private Sub EditVeterinaryDiseaseReport(veterinaryDiseaseReportID As Long)

        Dim veterinaryDiseaseReports = CType(Session(VETERINARY_DISEASE_REPORT_LIST), List(Of VetDiseaseReportGetListModel))
        Dim veterinaryDiseaseReport = veterinaryDiseaseReports.Where(Function(x) x.VeterinaryDiseaseReportID = veterinaryDiseaseReportID).FirstOrDefault()

        ViewState(CALLER_KEY) = veterinaryDiseaseReportID.ToString()
        ViewState(CALLER) = CallerPages.VeterinaryActiveSurveillanceMonitoringSessionEditVeterinaryDiseaseReport

        SaveEIDSSViewState(ViewState)

        If (veterinaryDiseaseReport.ReportTypeID = VeterinaryDiseaseReportConstants.AvianDiseaseReportCaseType) Then
            Response.Redirect(GetURL(CallerPages.AvianVeterinaryDiseaseReportURL), True)
        Else
            Response.Redirect(GetURL(CallerPages.LivestockVeterinaryDiseaseReportURL), True)
        End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="veterinaryDiseaseReportID"></param>
    Private Sub DeleteVeterinaryDiseaseReport(veterinaryDiseaseReportID As Long)

        'hdfVeteterinaryDiseaseReportID.Value = veterinaryDiseaseReportID.ToString()
        'Dim dsVeterinaryDiseaseReports As DataSet = CType(ViewState(VETERINARY_DISEASE_REPORT_DATASET), DataSet)
        'Dim dr = dsVeterinaryDiseaseReports.Tables(0).Select("idfVetCase = " & hdfVeteterinaryDiseaseReportID.Value).First

        'ViewState(CALLER_KEY) = hdfVeteterinaryDiseaseReportID.Value.ToString()
        'ViewState(CALLER) = CallerPages.VeterinaryActiveSurveillanceMonitoringSessionDeleteVeterinaryDiseaseReport

        'oCommon.SaveViewState(ViewState)

        'If (dr(VeterinaryDiseaseReportConstants.CaseTypeID) = VeterinaryDiseaseReportConstants.AvianDiseaseReportCaseType) Then
        '    Response.Redirect(GetURL(CallerPages.AvianVeterinaryDiseaseReportURL), True)
        'Else
        '    Response.Redirect(GetURL(CallerPages.LivestockVeterinaryDiseaseReportURL), True)
        'End If

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub VeterinaryDiseaseReports_RowCommand(sender As Object, e As GridViewCommandEventArgs)

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    DeleteVeterinaryDiseaseReport(e.CommandArgument)
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditVeterinaryDiseaseReport(e.CommandArgument)
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

End Class