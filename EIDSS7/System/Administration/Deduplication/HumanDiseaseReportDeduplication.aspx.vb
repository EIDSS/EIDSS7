Imports EIDSS.Client.API_Clients
Imports OpenEIDSS.Domain
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports System.Reflection
Imports EIDSS.EIDSS
Imports System.Drawing


Public Class HumanDiseaseReportDeduplication
    Inherits System.Web.UI.Page

#Region "Global Values"
    Private Const MODAL_KEY As String = "Modal"
    Private Const PAGE_KEY As String = "Page"
    Private Const CALLER_INFO As String = "CallerInfo"
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"
    Private Const SET_ACTIVE_TAB_ITEM_SCRIPT As String = "setActiveTabItem();"
    Private Const TAB_CHANGED_EVENT As String = "TabChanged"
    'Private Const SORT_DIRECTION As String = "gvPeople_SortDirection"
    'Private Const SORT_EXPRESSION As String = "gvPeople_SortExpression"
    'Private Const PAGINATION_SET_NUMBER As String = "gvPeople_PaginationSet"
    Private Const HIDE_WARNING_MODAL As String = "hideWarningModal();"
    Private Const BTN_TOGGLE_SELECT As String = "btnToggleSelect"
    Private Const HIDE_SEARCH_CRITERIA_SCRIPT As String = "hideSearchCriteria();"
    Private Const SHOW_SEARCH_CRITERIA_SCRIPT As String = "showSearchCriteria();"

    'CSS Constants
    Private Const CSS_BTN_GLYPHICON_CHECKED As String = "btn glyphicon glyphicon-check selectButton"
    Private Const CSS_BTN_GLYPHICON_UNCHECKED As String = "btn glyphicon glyphicon-unchecked selectButton"

    Private Const TextField As String = "Label"
    Private Const ValueField As String = "Value"
    Private Const NotificationList As String = "NotificationList"
    Private Const NotificationList2 As String = "NotificationList2"
    Private Const ClinicalList As String = "ClinicalList"
    Private Const ClinicalList2 As String = "ClinicalList2"
    Private Const ClinicalFacilityList As String = "ClinicalFacilityList"
    Private Const ClinicalFacilityList2 As String = "ClinicalFacilityList2"
    Private Const ClinicalAntibioticsList As String = "ClinicalAntibioticsList"
    Private Const ClinicalAntibioticsList2 As String = "ClinicalAntibioticsList2"
    Private Const ClinicalVaccinesList As String = "ClinicalVaccinesList"
    Private Const ClinicalVaccinesList2 As String = "ClinicalVaccinesList2"
    Private Const SampleList As String = "SampleList"
    Private Const SampleList2 As String = "SampleList2"
    Private Const CaseList As String = "CaseList"
    Private Const CaseList2 As String = "CaseList2"
    Private Const OutcomeList As String = "OutcomeList"
    Private Const OutcomeList2 As String = "OutcomeList2"
    Private Const CaseList0 As String = "CaseList0"
    Private Const CaseList02 As String = "CaseList02"
    Private Const SurvivorHumanDiseaseReportID As String = "SurvivorHumanDiseaseReportID"
    Private Const SupersededHumanDiseaseReportID As String = "SupersededHumanDiseaseReportID"
    Private Const SURVIVOR_LIST_NOTIFICATION As String = "SurvivorListNotification"
    Private Const SURVIVOR_LIST_CLINICAL As String = "SurvivorListClinical"
    Private Const SURVIVOR_LIST_SAMPLE As String = "SurvivorListSample"
    Private Const SURVIVOR_LIST_CASE As String = "SurvivorListCase"
    Private Const SURVIVOR_LIST_OUTCOME As String = "SurvivorListOutcome"
    Private Const SURVIVOR_LIST_FACILITY As String = "SurvivorListClinicalFacility"
    Private Const SURVIVOR_LIST_ANTIBIOTICS As String = "SurvivorListClinicalAntibiotics"
    Private Const SURVIVOR_LIST_VACCINES As String = "SurvivorListClinicalVaccines"

    Private Const EXACTADDRESSNUMBERFIELD As Int16 = 2

    Public Event TabItemSelected(tab As String)

    Private Shared Log As log4net.ILog = log4net.LogManager.GetLogger(GetType(PersonRecordDeduplication))
    Private ReadOnly divSearchForm As Object

    Private HumanAPIService As HumanServiceClient
    Private CrossCuttingAPIService As CrossCuttingServiceClient

    Private SurvivorListNotification As New List(Of Field)
    Private SurvivorListClinical As New List(Of Field)
    Private SurvivorListSample As New List(Of Field)
    Private SurvivorListCase As New List(Of Field)
    Private SurvivorListOutcome As New List(Of Field)
    Private SurvivorListClinicalFacility As New List(Of Field)
    Private SurvivorListClinicalAntibiotics As New List(Of Field)
    Private SurvivorListClinicalVaccines As New List(Of Field)


    Dim keyDict As New Dictionary(Of String, Integer) From {{"idfsFinalDiagnosis", 0}, {"datDateOfDiagnosis", 1}, {"datNotificationDate", 2}, {"idfsFinalState", 3},
                {"idfSentByOffice", 4}, {"idfSentByPerson", 5},
                {"idfReceivedByOffice", 6}, {"idfReceivedByPerson", 7}, {"idfsHospitalizationStatus", 8}, {"idfHospital", 9}, {"strCurrentLocation", 10}}

    Dim keyDict2 As New Dictionary(Of String, Integer) From {{"datOnSetDate", 0}, {"idfsInitialCaseStatus", 1}, {"idfEpiObservation", 2}, {"idfsYNPreviouslySoughtCare", 3},
                    {"idfSougtCareFacility", 4},
                    {"datFirstSoughtCareDate", 5}, {"idfsNonNotifiableDiagnosis", 6}, {"idfsYNHospitalization", 7}, {"strHospitalName", 8}, {"datHospitalizationDate", 9},
                    {"datDischargeDate", 10}, {"idfsYNAntimicrobialTherapy", 11},
                    {"idfsYNSpecificVaccinationAdministered", 12}}
    '{"strAntibioticName", 12}, {"strDosage", 13}, {"datFirstAdministeredDate", 14}, {"strAntibioticComments", 15},
    '{"idfsYNSpecificVaccinationAdministered", 16}, {"VaccinationName", 17}, {"VaccinationDate", 18}}

    'Dim keyDict3 As New Dictionary(Of String, Integer) From {{"idfsYNSpecimenCollected", 0}, {"DiseaseReportTypeID", 1}, {"idfsSampleType", 2}, {"strFieldBarcode", 3}, {"datFieldCollectionDate", 4}, {"datFieldSentDate", 5},
    '                {"strSendToOffice", 6}, {"strFieldCollectedByOffice", 7}, {"idfFieldCollectedByPerson", 8}}
    Dim keyDict3 As New Dictionary(Of String, Integer) From {{"idfsYNSpecimenCollected", 0}, {"strFieldBarcode", 1}}

    Dim keyDict4 As New Dictionary(Of String, Integer) From {{"strBarcode", 0}, {"strSampleTypeName", 1}, {"name", 2}, {"datFieldCollectionDate", 3}, {"strTestResult", 4},
                    {"datFieldSentDate", 5}, {"idfsTestCategory", 6}, {"strInterpretedStatus", 7}, {"strInterpretedComment", 8}, {"datInterpretedDate", 9},
                    {"strInterpretedBy", 10}, {"blnValidateStatus", 11},
                    {"strValidateComment", 12}, {"datValidationDate", 13}, {"strValidatedBy", 14}}

    'Dim keyDict5 As New Dictionary(Of String, Integer) From {{"idfInvestigatedByOffice", 0}, {"StartDateofInvestigation", 1}, {"idfsYNRelatedToOutbreak", 2}, {"idfOutbreak", 3},
    '                {"idfsYNExposureLocationKnown", 4}, {"datExposureDate", 5}, {"idfPointGeoLocation", 6},
    '                {"strLocationDescription", 7}, {"idfsLocationRegion", 8}, {"idfsLocationRayon", 9}, {"idfsLocationSettlement", 10}, {"idfsLocationStreet", 11},
    '                {"intLocationLatitude", 12}, {"intLocationLongitude", 13}, {"Elevation", 14}, {"strDescription", 15}, {"Region", 16}, {"Rayon", 17}, {"Settlement", 18},
    '                {"Street", 19}, {"idfsLocationGroundType", 20},
    '                {"intLocationDistance", 21}, {"Direction", 22}, {"idfsLocationCountry", 23}, {"Address", 24}}

    Dim keyDict5 As New Dictionary(Of String, Integer) From {{"idfInvestigatedByOffice", 0}, {"StartDateofInvestigation", 1}, {"idfsYNRelatedToOutbreak", 2}, {"idfOutbreak", 3},
                 {"idfsYNExposureLocationKnown", 4}, {"datExposureDate", 5}, {"idfPointGeoLocation", 6},
                    {"strLocationDescription", 7}, {"Region", 8}, {"Rayon", 9}, {"idfCSObservation", 10}}

    Dim keyDict7 As New Dictionary(Of String, Integer) From {{"idfsFinalCaseStatus", 0}, {"DateofClassification", 1}, {"strClinicalDiagnosis", 2}, {"idfsOutcome", 3}, {"datDateofDeath", 4}}



    Dim labelDict As New Dictionary(Of Integer, String) From {{0, "Disease"}, {1, "DateOfDisease"}, {2, "NotificationDate"}, {3, "PatientStatus"}, {4, "SentByOffice"},
                    {5, "SentByPerson"}, {6, "ReceivedByOffice"}, {7, "ReceivedByPerson"}, {8, "PatientCurrentLocation"}, {9, "HospitalName"}, {10, "OtherLocation"}}

    Dim labelDict2 As New Dictionary(Of Integer, String) From {{0, "OnSetDate"}, {1, "InitialCaseStatus"}, {2, "SymptomList"}, {3, "PreviouslySoughtCare"}, {4, "FacilityFirstSoughtCare"},
                    {5, "FirstSoughtCareDate"}, {6, "NonNotifiableDiagnosis"}, {7, "Hospitalization"}, {8, "HospitalName"}, {9, "HospitalizationDate"}, {10, "DischargeDate"},
                    {11, "AntimicrobialTherapy"},
                    {12, "SpecificVaccinationAdministered"}}
    '{12, "AntimicrobialTherapyName"}, {13, "Dosage"}, {14, "FirstAdministeredDate"}, {15, "AdditionalComments"},
    '{16, "SpecificVaccinationAdministered"}, {17, "VaccinationName"}, {18, "VaccinationDate"}}

    'Dim labelDict3 As New Dictionary(Of Integer, String) From {{0, "SampleCollected"}, {1, "FilterSample"}, {2, "SampleType"}, {3, "LocalSampleID"}, {4, "CollectionDate"},
    '                {5, "SentDate"}, {6, "SendToOffice"}, {7, "CollectedByOffice"}, {8, "CollectedByPerson"}}
    Dim labelDict3 As New Dictionary(Of Integer, String) From {{0, "SampleCollected"}, {1, "SampleList"}}

    Dim labelDict4 As New Dictionary(Of Integer, String) From {{0, "LabSampleID"}, {1, "SampleType"}, {2, "TestName"}, {3, "TestStartedDate"}, {4, "TestResult"},
                    {5, "TestResultDate"}, {6, "TestCategory"}, {7, "InterpretedStatus"}, {8, "InterpretedComment"}, {9, "InterpretedDate"}, {10, "InterpretedBy"},
                    {11, "ValidateStatus"},
                    {12, "ValidateComment"}, {13, "ValidationDate"}, {14, "ValidatedBy"}}

    'Dim labelDict5 As New Dictionary(Of Integer, String) From {{0, "InvestigatedByOffice"}, {1, "StartDateofInvestigation"}, {2, "RelatedToOutbreak"},
    '                {3, "OutbreakID"}, {4, "ExposureLocationKnown"}, {5, "ExposureDate"}, {6, "ExposureLocation"},
    '                {7, "Description"}, {8, "Region"}, {9, "Rayon"}, {10, "Settlement"}, {11, "Street"},
    '                {12, "Latitude"}, {13, "Longitude"}, {14, "Elevation"}, {15, "strDescription"}, {16, "Region"},
    '                {17, "Rayon"}, {18, "Settlement"}, {19, "Street"}, {20, "GroundType"},
    '                {21, "Distance"}, {22, "Direction"}, {23, "Country"}, {24, "Address"}}


    Dim labelDict5 As New Dictionary(Of Integer, String) From {{0, "InvestigatedByOffice"}, {1, "StartDateofInvestigation"}, {2, "RelatedToOutbreak"},
                    {3, "OutbreakID"}, {4, "ExposureLocationKnown"}, {5, "ExposureDate"}, {6, "ExposureLocation"},
                    {7, "Description"}, {8, "Region"}, {9, "Rayon"}, {10, "RiskFactorList"}}

    Dim labelDict7 As New Dictionary(Of Integer, String) From {{0, "FinalCaseStatus"}, {1, "DateofClassification"}, {2, "BasisofDiagnosis"}, {3, "Outcome"}, {4, "DateofDeath"}}




#End Region

#Region "Initialize Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Not Page.IsPostBack Then
                CheckCallerHandler()
            Else
                Dim eventArg As Object = Request("__EVENTARGUMENT")
                Dim eventSource As String = Request.Form("__EVENTTARGET")

                Select Case eventArg.ToString()
                    Case TAB_CHANGED_EVENT
                        RaiseEvent TabItemSelected(eventSource)
                End Select
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    '**********************************************************************************************
    '* Sub-routine: CheckCallerHandler
    '*
    '* Description: Handler for checking if calls from other web pages were made.
    '* 
    '**********************************************************************************************
    Private Sub CheckCallerHandler()
        Try
            ExtractViewStateSession()

            '******************************************************************************************
            '* Add additional modules to the equals any as needed for selecting a person.
            '******************************************************************************************
            Select Case ViewState(CALLER).ToString()
                Case CallerPages.Dashboard, CallerPages.Person
                    Setup()
                    SetInitialVisibility()
                Case Else
                    Setup()
                    SetInitialVisibility()
            End Select

            upDeduplication.Update()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Public Sub Setup()

        Try
            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If

            GetUserProfile()

            Reset()

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), PAGE_KEY, SHOW_SEARCH_CRITERIA_SCRIPT, True)

            upSearch.Update()
            upSearchResults.Update()

            FillDropDowns()

            ucLocation.Setup(CrossCuttingAPIService)

            ExtractViewStateSession()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

    ''' <summary>
    ''' Fill and bind the selected tab.  For performance purposes, the application does not 
    ''' initially load all 3 tabs.  It is more efficient to load seperately as needed by the 
    ''' user.
    ''' </summary>
    ''' <param name="tab"></param>
    Protected Sub TabItemSelected_Event(tab As String) Handles Me.TabItemSelected
        Try
            hdfCurrentTab.Value = tab.Replace("lnk", "")

            Select Case hdfCurrentTab.Value
                Case DeduplicationTabConstants.Notification
                    btnNextSection.Visible = True
                Case DeduplicationTabConstants.Clinical
                    btnNextSection.Visible = True
                    'LoadFlexFormSymptoms()
                Case DeduplicationTabConstants.Sample
                    btnNextSection.Visible = True
                Case DeduplicationTabConstants.TestResults
                    btnNextSection.Visible = True
                Case DeduplicationTabConstants.CaseInvestigation
                    btnNextSection.Visible = True
                    'LoadFlexFormRiskFactors()
                Case DeduplicationTabConstants.ContactList
                    btnNextSection.Visible = True
                Case DeduplicationTabConstants.Outcome
                    btnNextSection.Visible = False
            End Select

            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
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

    Private Sub FillDropDowns()
        Try
            If CrossCuttingAPIService Is Nothing Then
                CrossCuttingAPIService = New CrossCuttingServiceClient()
            End If

            FillBaseReferenceDropDownList(ddlDiseaseID, BaseReferenceConstants.Diagnosis, HACodeList.HumanHACode, True)
            FillBaseReferenceDropDownList(ddlReportStatusTypeID, BaseReferenceConstants.CaseStatus, HACodeList.HumanHACode, True)
            FillBaseReferenceDropDownList(ddlClassificationTypeID, BaseReferenceConstants.CaseClassification, HACodeList.HumanHACode, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Sub SetInitialVisibility()
        divSearchCriteria.Visible = True
        btnClear.Visible = True
        btnSearch.Visible = True

        divSearchResults.Visible = False

        divDeduplicationDetails.Visible = False
        divSurvivorReview.Visible = False
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub Reset()

        ResetForm(divSearchCriteria)
        ResetForm(ucLocation)

        txtEIDSSReportID.Text = String.Empty

        'ViewState(SORT_DIRECTION) = SortConstants.Ascending
        'ViewState(SORT_EXPRESSION) = "EIDSSReportID"
        'ViewState(PAGINATION_SET_NUMBER) = 1

        'ToggleVisibility(SectionSearchCriteria)

        gvSearchResults.PageSize = CInt(ConfigurationManager.AppSettings("PageSize"))

        txtEIDSSReportID.Focus()

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    Private Sub GetUserProfile()

        'Assign defaults from current user data.
        hdfidfUserID.Value = Session("UserID")
        hdfidfInstitution.Value = Session("Institution")

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="isConfirm"></param>
    ''' <param name="message"></param>
    Private Sub ShowWarningMessage(messageType As MessageType, isConfirm As Boolean, Optional message As String = Nothing)

        warningHeading.InnerText = Resources.WarningMessages.Warning_Message_Alert
        warningSubTitle.InnerText = String.Empty
        hdfWarningMessageType.Value = messageType.ToString()

        Select Case messageType
            Case MessageType.CancelConfirm
                warningBody.InnerText = Resources.WarningMessages.Cancel_Confirm
            Case MessageType.CancelSearchConfirm
                warningBody.InnerText = Resources.WarningMessages.Cancel_Search_Confirm
            Case MessageType.CancelFormConfirm
                warningBody.InnerText = Resources.WarningMessages.Cancel_Form_Confirm
            Case MessageType.CannotGetValidatorSection
                warningBody.InnerText = Resources.WarningMessages.Validator_Section
            Case MessageType.UnhandledException
                warningBody.InnerText = Resources.WarningMessages.Unhandled_Exception
            Case MessageType.SearchCriteriaRequired
                warningBody.InnerText = Resources.WarningMessages.Search_Criteria_Required
            Case MessageType.ConfirmMerge
                warningBody.InnerText = Resources.WarningMessages.Confirm_Merge_Record
            Case MessageType.FieldValuePairFoundNoSelection
                warningBody.InnerText = Resources.WarningMessages.Field_Value_Pair_Found_No_Selection
        End Select

        If isConfirm Then
            divWarningYesNoContainer.Visible = True
            divWarningOKContainer.Visible = False
        Else
            divWarningOKContainer.Visible = True
            divWarningYesNoContainer.Visible = False
        End If

        ScriptManager.RegisterClientScriptBlock(Me, [GetType](), MODAL_KEY, "$(function(){ $('#" & divWarningModal.ClientID & "').modal('show');});", True)

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
            Case MessageType.UnhandledException
                divErrorBody.InnerText = Resources.WarningMessages.Unhandled_Exception
        End Select

        ScriptManager.RegisterClientScriptBlock(Me, [GetType](), MODAL_KEY, "$(function(){ $('#" & divErrorModal.ClientID & "').modal('show');});", True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="messageType"></param>
    ''' <param name="message"></param>
    Private Sub ShowSuccessMessage(messageType As MessageType, Optional message As String = Nothing)

        Select Case messageType
            Case MessageType.SaveSuccess
                lblSuccessMessage.InnerText = message
        End Select

        ScriptManager.RegisterClientScriptBlock(Me, [GetType](), MODAL_KEY, "$(function(){ $('#" & divSuccessModal.ClientID & "').modal('show');});", True)

    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="Sender"></param>
    ''' <param name="e"></param>
    Private Sub Page_Error(Sender As Object, e As EventArgs) Handles Me.Error

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

    Protected Sub WarningModalYes_Click(sender As Object, e As EventArgs) Handles btnWarningModalYes.Click

        Try
            Select Case hdfWarningMessageType.Value.ToString()
                Case MessageType.FieldValuePairFoundNoSelection.ToString()
                    upDeduplication.Update()
                    ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, HIDE_WARNING_MODAL, True)
                Case MessageType.ConfirmMerge.ToString()
                    upDeduplication.Update()
                    ScriptManager.RegisterStartupScript(Me, [GetType](), MODAL_KEY, HIDE_WARNING_MODAL, True)
                    'DeduplicateRecords()
                Case Else
                    Response.Redirect(GetURL(CallerPages.DashboardURL), False)
                    Context.ApplicationInstance.CompleteRequest()
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region

#Region "Search Methods"

    Private Function ValidateSearch() As Boolean
        Dim blnValidated As Boolean = False
        'Dim oCom As clsCommon = New clsCommon()

        ''check if Report ID is entered
        ''If Yes then ignore rest of the serach fields
        ''If No, check if any other search criteria is entered, if not, raise error

        blnValidated = (Not txtEIDSSReportID.Text.IsValueNullOrEmpty())

        If Not blnValidated Then
            'searchForm
            Dim allCtrl As New List(Of Control)

            allCtrl.Clear()
            For Each txt As WebControls.TextBox In FindControlList(allCtrl, divSearchCriteria, GetType(WebControls.TextBox))
                If Not blnValidated Then blnValidated = (Not txt.Text.ToString().IsValueNullOrEmpty())
            Next

            If Not blnValidated Then
                allCtrl.Clear()
                For Each ddl As WebControls.DropDownList In FindControlList(allCtrl, divSearchCriteria, GetType(WebControls.DropDownList))
                    If Not blnValidated Then blnValidated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not blnValidated Then
                allCtrl.Clear()
                For Each ddl As EIDSSControlLibrary.DropDownList In FindControlList(allCtrl, divSearchCriteria, GetType(EIDSSControlLibrary.DropDownList))
                    If Not blnValidated Then blnValidated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not blnValidated Then
                allCtrl.Clear()
                For Each txt As EIDSSControlLibrary.CalendarInput In FindControlList(allCtrl, divSearchCriteria, GetType(EIDSSControlLibrary.CalendarInput))
                    If Not blnValidated Then blnValidated = (Not txt.Text.ToString().IsValueNullOrEmpty())
                Next
            End If

            allCtrl.Clear()
            For Each txt As TextBox In FindControlList(allCtrl, ucLocation, GetType(TextBox))
                If Not blnValidated Then blnValidated = (Not txt.Text.ToString().IsValueNullOrEmpty())
            Next

            If Not blnValidated Then
                allCtrl.Clear()
                For Each ddl As DropDownList In FindControlList(allCtrl, ucLocation, GetType(DropDownList))
                    If Not blnValidated Then blnValidated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not blnValidated Then
                allCtrl.Clear()
                For Each ddl As EIDSSControlLibrary.DropDownList In FindControlList(allCtrl, ucLocation, GetType(EIDSSControlLibrary.DropDownList))
                    If Not blnValidated Then blnValidated = (Not ddl.SelectedValue.ToString().IsValueNullOrEmpty())
                Next
            End If

            If Not blnValidated Then
                allCtrl.Clear()
                For Each txt As EIDSSControlLibrary.CalendarInput In FindControlList(allCtrl, ucLocation, GetType(EIDSSControlLibrary.CalendarInput))
                    If Not blnValidated Then blnValidated = (Not txt.Text.ToString().IsValueNullOrEmpty())
                Next
            End If

            If blnValidated And (txtHumanDiseaseReportDateEnteredFrom.Text.Length > 0 Or txtHumanDiseaseReportDateEnteredTo.Text.Length > 0) Then
                blnValidated = ValidateFromToDates(txtHumanDiseaseReportDateEnteredFrom.Text, txtHumanDiseaseReportDateEnteredTo.Text)
                If Not blnValidated Then
                    'show message, search criteria dates are not valid.
                    'Exits search with bad date error message
                    'lblErr.InnerText = GetLocalResourceObject("Msg_Dates_Are_Invalid.InnerText")
                    'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "modalFieldTest", "$(Function(){ $('#errorVSS').modal('show');});", True)
                    'txtSearchHDRDateEnteredFrom.Focus()
                    ShowWarningMessage(messageType:=MessageType.InvalidDateOfBirth, isConfirm:=False)
                End If
            Else
                If Not blnValidated Then
                    blnValidated = True
                    'ASPNETMsgBox(GetLocalResourceObject("Msg_At_Least_One_Field_Needs_Value"))
                    'txtSearchStrCaseId.Focus()
                End If
            End If

            If blnValidated Then
                divSearchResults.Visible = blnValidated
            Else
                ShowWarningMessage(MessageType.SearchCriteriaRequired, False)
                txtEIDSSPersonID.Focus()
            End If
        End If

        divSearchResults.Visible = blnValidated

        Return blnValidated
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Search_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        Try
            If ValidateSearch() Then
                FillDeduplicationList()
                divSearchResults.Visible = True
                divSearchCriteria.Visible = False
                toggleIcon.Visible = False
                'divDeduplicationList.Visible = False
                'divDeduplicationDetails.Visible = False
                divSurvivorReview.Visible = False
                'btnCancelSearchResults.Visible = True
                'btnCancelSearch.Visible = False
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Sub FillDeduplicationList()
        Try
            Dim list = New List(Of HumDiseaseReportGetListModel)()
            Dim parameters As New HumanDiseaseReportGetListParams() With {.LanguageID = GetCurrentLanguage()}
            Dim controls As New List(Of Control)

            controls.Clear()
            parameters.PaginationSetNumber = 1

            For Each ddl As EIDSSControlLibrary.DropDownList In FindControlList(controls, ucLocation, GetType(EIDSSControlLibrary.DropDownList))
                If ddl.ClientID.Contains("ddlucLocationidfsRegion") = True Then
                    If Not ddl.SelectedValue = "null" Then
                        parameters.RegionID = CType(ddl.SelectedValue, Long)
                    End If
                End If

                If ddl.ClientID.Contains("ddlucLocationidfsRayon") = True Then
                    If Not ddl.SelectedValue = "null" And Not ddl.SelectedValue = "" Then
                        parameters.RayonID = CType(ddl.SelectedValue, Long)
                    End If
                End If
            Next

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            list = HumanAPIService.GetHumanDiseaseReportListAsync(Gather(divSearchCriteria, parameters, 3)).Result

            gvSearchResults.DataSource = list
            gvSearchResults.DataBind()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    'Private Sub FillDiseaseList(Optional sGetDataFor As String = "GRIDROWS", Optional bRefresh As Boolean = False)
    '    Try
    '        Dim dsDisease As DataSet
    '        'Dim list = New List(Of HumDiseaseReportGetListModel)()
    '        Dim advancedList = New List(Of HumDiseaseAdvanceSearchReportGetListModel)()
    '        Dim parameters As New HumanDiseaseReportGetListParams() With {.LanguageID = GetCurrentLanguage()}
    '        Dim advancedSearchParameters As New HumanDiseaseAdvanceSearchParams() With {.languageId = GetCurrentLanguage()}

    '        'Save the data set in view state to re-use
    '        If bRefresh Then ViewState("dsDisease") = Nothing

    '        'If IsNothing(ViewState("dsDisease")) Then
    '        If bRefresh = True Then

    '            If HumanAPIService Is Nothing Then
    '                HumanAPIService = New HumanServiceClient()
    '            End If

    '            advancedSearchParameters.eidssReportId = If(String.IsNullOrEmpty(txtEIDSSReportID.Text), Nothing, txtEIDSSReportID.Text)
    '            advancedSearchParameters.eidssPersonId = If(String.IsNullOrEmpty(txtEIDSSPersonID.Text), Nothing, txtEIDSSPersonID.Text)

    '            If ddlDiseaseID.SelectedIndex > 0 Then
    '                advancedSearchParameters.diseaseId = If(String.IsNullOrEmpty(ddlDiseaseID.SelectedValue), Nothing, ddlDiseaseID.SelectedValue)
    '            Else
    '                advancedSearchParameters.diseaseId = Nothing

    '            End If

    '            If ddlReportStatusTypeID.SelectedIndex > 0 Then
    '                advancedSearchParameters.reportStatusTypeId = ddlReportStatusTypeID.SelectedValue
    '            Else
    '                advancedSearchParameters.reportStatusTypeId = Nothing
    '            End If

    '            If Not String.IsNullOrEmpty(txtHumanDiseaseReportDateEnteredFrom.Text) Then
    '                advancedSearchParameters.dateEnteredFrom = If(String.IsNullOrEmpty(txtHumanDiseaseReportDateEnteredFrom.Text), Nothing, Convert.ToDateTime(txtHumanDiseaseReportDateEnteredFrom.Text))
    '            End If

    '            If Not String.IsNullOrEmpty(txtHumanDiseaseReportDateEnteredTo.Text) Then
    '                parameters.HumanDiseaseReportDateEnteredTo = If(String.IsNullOrEmpty(txtHumanDiseaseReportDateEnteredTo.Text), Nothing, Convert.ToDateTime(txtHumanDiseaseReportDateEnteredTo.Text))
    '            End If

    '            If ddlClassificationTypeID.SelectedIndex > 0 Then
    '                advancedSearchParameters.classificationTypeId = If(String.IsNullOrEmpty(ddlClassificationTypeID.SelectedValue), Nothing, ddlClassificationTypeID.SelectedValue)
    '            Else
    '                advancedSearchParameters.classificationTypeId = Nothing
    '            End If

    '            Dim controls As New List(Of Control)
    '            controls.Clear()

    '            parameters.PaginationSetNumber = 1 'needs to account for additonal pagination sets; recommend user control in place.

    '            advancedSearchParameters.paginationSet = 1
    '            advancedSearchParameters.pageSize = 10
    '            advancedSearchParameters.maxPagesPerFetch = 1000

    '            Dim savedterms = String.Empty
    '            If ViewState("terms") IsNot Nothing Then
    '                savedterms = CType(ViewState("terms"), String)
    '            End If

    '            Dim terms = Newtonsoft.Json.JsonConvert.SerializeObject(advancedSearchParameters)
    '            If savedterms = terms Then
    '                If ViewState("resultSet") IsNot Nothing Then
    '                    Dim serializedResultSet = CType(ViewState("resultSet"), String)
    '                    advancedList = Newtonsoft.Json.JsonConvert.DeserializeObject(Of List(Of HumDiseaseAdvanceSearchReportGetListModel))(serializedResultSet)
    '                End If
    '            Else
    '                gvSearchResults.DataSource = Nothing
    '                advancedList = HumanAPIService.GetHumanDiseaseAdvanceSearchReportListAsync(advancedSearchParameters).Result
    '                ViewState.Add("resultSet", Newtonsoft.Json.JsonConvert.SerializeObject(advancedList))
    '                ViewState.Add("terms", terms)
    '            End If
    '        Else
    '            dsDisease = CType(ViewState("dsDisease"), DataSet)
    '        End If

    '        gvSearchResults.DataSource = advancedList
    '        gvSearchResults.DataBind()

    '    Catch ex As Exception
    '        Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
    '        Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
    '    End Try
    'End Sub


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub Clear_Click(sender As Object, e As EventArgs) Handles btnClear.Click

        Try
            'If hdfidfUserID.Value.IsValueNullOrEmpty = True Then
            '    GetUserProfile()
            'End If

            'DeleteTempFiles(HttpContext.Current.Request.PhysicalApplicationPath & "App_Data\" & ID & hdfidfUserID.Value & ".xml")

            Reset()
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
    Protected Sub Cancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click

        Try
            SaveEIDSSViewState(ViewState)

            ShowWarningMessage(MessageType.CancelSearchConfirm, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try

    End Sub

#End Region

#Region "Deduplication List Methods"

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    Protected Sub gvSearchResults_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSearchResults.RowCommand

        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.ToggleSelect
                        If gvDeduplicationList.Rows.Count < 2 Then
                            ToggleSelect(CType(e.CommandArgument, Integer))
                            TagForDeduplication(CType(e.CommandArgument, Integer))
                        ElseIf gvDeduplicationList.Rows.Count > 2 Then
                            RemoveHighlightedRecord(CType(e.CommandArgument, Integer), gvSearchResults)
                        End If
                    Case GridViewCommandConstants.SelectCommand
                        HighlightRecord(CType(e.CommandArgument, Integer), gvSearchResults)
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
    ''' <param name="index"></param>
    ''' <param name="control"></param>
    Private Sub HighlightRecord(ByVal index As Integer, control As GridView)
        Try
            For Each row As GridViewRow In control.Rows
                If row.RowIndex = index Then
                    For Each cell As TableCell In row.Cells
                        cell.BackColor = Color.LightGray
                    Next
                End If
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="index"></param>
    ''' <param name="control"></param>
    Private Sub RemoveHighlightedRecord(ByVal index As Integer, control As GridView)
        Try
            For Each row As GridViewRow In control.Rows
                If row.RowIndex = index Then
                    For Each cell As TableCell In row.Cells
                        cell.BackColor = Color.White
                    Next
                End If
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="index"></param>
    Private Sub ToggleSelect(ByVal index As Integer)
        Try
            For Each row As GridViewRow In gvSearchResults.Rows
                If row.RowIndex = index Then
                    Dim btnToggleSelect As LinkButton = CType(row.FindControl(BTN_TOGGLE_SELECT), LinkButton)
                    If btnToggleSelect.CssClass = CSS_BTN_GLYPHICON_CHECKED Then
                        btnToggleSelect.CssClass = CSS_BTN_GLYPHICON_UNCHECKED
                    Else
                        btnToggleSelect.CssClass = CSS_BTN_GLYPHICON_CHECKED
                    End If
                End If
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="index"></param>
    Private Sub TagForDeduplication(ByVal index As Integer)
        Try
            Dim parameters As New HumanDiseaseReportGetListParams With {.LanguageID = GetCurrentLanguage()}

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            parameters.PaginationSetNumber = 1
            parameters.HumanDiseaseReportID = gvSearchResults.DataKeys(index).Values().Item("HumanDiseaseReportID").ToString()
            Dim list = New List(Of HumDiseaseReportGetListModel)()
            list = HumanAPIService.GetHumanDiseaseReportListAsync(parameters).Result

            Dim list2 = New List(Of HumDiseaseReportGetListModel)()

            If gvDeduplicationList.Rows.Count > 0 Then
                If Not gvDeduplicationList.DataKeys(0).Values().Item("EIDSSReportID").ToString() = gvSearchResults.DataKeys(index).Values().Item("EIDSSReportID").ToString() Then
                    Dim r As New HumDiseaseReportGetListModel
                    r.HumanDiseaseReportID = CType(gvDeduplicationList.DataKeys(0).Values().Item("HumanDiseaseReportID"), Long)
                    r.EIDSSReportID = gvDeduplicationList.DataKeys(0).Values().Item("EIDSSReportID").ToString()
                    If gvDeduplicationList.DataKeys(0).Values().Item("EIDSSPersonID") IsNot Nothing Then
                        r.EIDSSPersonID = gvDeduplicationList.DataKeys(0).Values().Item("EIDSSPersonID").ToString()
                    End If
                    If gvDeduplicationList.DataKeys(0).Values().Item("DiseaseName") IsNot Nothing Then
                        r.DiseaseName = gvDeduplicationList.DataKeys(0).Values().Item("DiseaseName").ToString()
                    End If

                    If gvDeduplicationList.DataKeys(0).Values().Item("ReportStatusTypeName") IsNot Nothing Then
                        r.ReportStatusTypeName = gvDeduplicationList.DataKeys(0).Values().Item("ReportStatusTypeName").ToString()
                    End If

                    If gvDeduplicationList.DataKeys(0).Values().Item("RegionName") IsNot Nothing Then
                        r.RegionName = gvDeduplicationList.DataKeys(0).Values().Item("RegionName").ToString()
                    End If

                    If gvDeduplicationList.DataKeys(0).Values().Item("RayonName") IsNot Nothing Then
                        r.RayonName = gvDeduplicationList.DataKeys(0).Values().Item("RayonName").ToString()
                    End If

                    If gvDeduplicationList.DataKeys(0).Values().Item("EnteredDate") IsNot Nothing Then
                        r.EnteredDate = gvDeduplicationList.DataKeys(0).Values().Item("EnteredDate")
                    End If

                    If gvDeduplicationList.DataKeys(0).Values().Item("ClassificationTypeName") IsNot Nothing Then
                        r.ClassificationTypeName = gvDeduplicationList.DataKeys(0).Values().Item("ClassificationTypeName").ToString()
                    End If

                    list2.Add(r)
                        list2.Add(list.FirstOrDefault())
                    End If
                Else
                list2.Add(list.FirstOrDefault())
            End If
            gvDeduplicationList.DataSource = Nothing
            gvDeduplicationList.DataSource = list2
            gvDeduplicationList.DataBind()

            'RemoveHighlightPerson(gvHumanMaster)

            upDeduplication.Update()

            If gvDeduplicationList.Rows.Count = 2 Then
                btnDeduplicate.Visible = True
                btnCancelForm.Visible = True
            Else
                btnDeduplicate.Visible = False
                btnCancelForm.Visible = False
            End If

            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, HIDE_SEARCH_CRITERIA_SCRIPT, True)
            'ToggleVisibility(SectionSearchResults)
            divSearchResults.Visible = True
            toggleIcon.Visible = True

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
    Protected Sub gvDeduplicationList_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvDeduplicationList.RowCommand
        Try
            If Not e.CommandName.ToString = GridViewCommandConstants.PageCommand And Not e.CommandName = GridViewCommandConstants.SortCommand Then
                e.Handled = True

                Select Case e.CommandName
                    Case GridViewCommandConstants.SelectCommand
                        HighlightRecord(CType(e.CommandArgument, Integer), gvDeduplicationList)
                    Case GridViewCommandConstants.DeleteCommand
                        Remove(CType(e.CommandArgument, Integer))
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
    ''' 
    ''' <param name="idx"></param>
    Private Sub Remove(ByVal idx As Integer)
        Try
            Dim strRecordID As Long = CType(gvDeduplicationList.DataKeys(idx).Values().Item("HumanDiseaseReportID"), Long)
            Dim keepidx As Integer = 1
            If idx = 1 Then keepidx = 0

            Dim list As New List(Of HumDiseaseReportGetListModel)()
            list = Nothing

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            If gvDeduplicationList.Rows.Count > 1 Then
                Dim parameters As New HumanDiseaseReportGetListParams With {.LanguageID = GetCurrentLanguage()}
                parameters.PaginationSetNumber = 1 'needs to account for additonal pagination sets; recommend user control in place.
                parameters.HumanDiseaseReportID = CType(gvDeduplicationList.DataKeys(keepidx).Values().Item("HumanDiseaseReportID"), Long)
                list = HumanAPIService.GetHumanDiseaseReportListAsync(parameters).Result

                gvDeduplicationList.DataSource = Nothing
                gvDeduplicationList.DataSource = list
                gvDeduplicationList.DataBind()
            Else
                gvDeduplicationList.DataBind()
            End If

            upDeduplication.Update()

            If gvDeduplicationList.Rows.Count = 2 Then
                btnDeduplicate.Visible = True
                btnCancelForm.Visible = True
            Else
                btnDeduplicate.Visible = False
                btnCancelForm.Visible = False
            End If

            For Each row As GridViewRow In gvSearchResults.Rows
                If CType(gvSearchResults.DataKeys(row.RowIndex).Values().Item("HumanDiseaseReportID"), Long) = strRecordID Then
                    ToggleSelect(row.RowIndex)
                    RemoveHighlightedRecord(row.RowIndex, gvSearchResults)
                End If
            Next

            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), PAGE_KEY, HIDE_SEARCH_CRITERIA_SCRIPT, True)
            'ToggleVisibility(SectionSearchResults)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            Throw ex
        End Try
    End Sub

    Protected Sub btnDeduplicate_Click(sender As Object, e As EventArgs) Handles btnDeduplicate.Click
        Try
            upDeduplication.Update()
            divDeduplicationDetails.Visible = True
            divDeduplicationList.Visible = False
            divSearchCriteria.Visible = False
            divSearchResults.Visible = False
            divSurvivorReview.Visible = False

            hdfCurrentTab.Value = DeduplicationTabConstants.Notification
            FillDeduplicationDetails(CType(gvDeduplicationList.DataKeys(0).Values().Item("HumanDiseaseReportID"), Long), CType(gvDeduplicationList.DataKeys(1).Values().Item("HumanDiseaseReportID"), Long))

            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            Throw ex
        End Try
    End Sub

    Protected Sub btnCancelForm_Click(sender As Object, e As EventArgs) Handles btnCancelForm.Click
        Try
            SaveEIDSSViewState(ViewState)

            ShowWarningMessage(MessageType.CancelFormConfirm, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            Throw ex
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="HumanDiseaseReportID"></param>
    ''' <param name="HumanDiseaseReportID2"></param>
    Private Sub FillDeduplicationDetails(HumanDiseaseReportID As Long, HumanDiseaseReportID2 As Long)
        Try
            hdfHumanDiseaseReportID.Value = HumanDiseaseReportID.ToString
            hdfHumanDiseaseReportID2.Value = HumanDiseaseReportID2.ToString

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            Dim list As List(Of HumDiseaseGetDetailModel) = HumanAPIService.GetHumanDiseaseDetail(GetCurrentLanguage(), HumanDiseaseReportID).Result
            Dim list2 As List(Of HumDiseaseGetDetailModel) = HumanAPIService.GetHumanDiseaseDetail(GetCurrentLanguage(), HumanDiseaseReportID2).Result

            Dim record As HumDiseaseGetDetailModel = list.FirstOrDefault()
            Dim record2 As HumDiseaseGetDetailModel = list2.FirstOrDefault()

            Dim kvInfo As New List(Of KeyValuePair(Of String, String))
            Dim kvInfo2 As New List(Of KeyValuePair(Of String, String))

            Dim type As Type = record.GetType()
            Dim props() As PropertyInfo = type.GetProperties()

            Dim type2 = record2.GetType()
            Dim props2() As PropertyInfo = type2.GetProperties()

            Dim value As String = String.Empty

            Dim itemList As New List(Of Field)
            Dim itemList2 As New List(Of Field)

            Dim itemListClinical As New List(Of Field)
            Dim itemListClinical2 As New List(Of Field)

            Dim itemListClinicalFacility As New List(Of Field)
            Dim itemListClinicalFacility2 As New List(Of Field)

            Dim itemListClinicalAntibiotics As New List(Of Field)
            Dim itemListClinicalAntibiotics2 As New List(Of Field)

            Dim itemListClinicalVaccines As New List(Of Field)
            Dim itemListClinicalVaccines2 As New List(Of Field)

            Dim itemListCase As New List(Of Field)
            Dim itemListCase2 As New List(Of Field)

            Dim itemListSample As New List(Of Field)
            Dim itemListSample2 As New List(Of Field)

            Dim itemListOutcome As New List(Of Field)
            Dim itemListOutcome2 As New List(Of Field)

            For index = 0 To props.Count - 1
                If IsInTabNotification(props(index).Name) = True Then
                    FillTabList(props(index).Name, props(index).GetValue(record), props2(index).Name, props2(index).GetValue(record2), itemList, itemList2, keyDict, labelDict)
                End If
                If IsInTabClinicalSymptoms(props(index).Name) = True Then
                    FillTabList(props(index).Name, props(index).GetValue(record), props2(index).Name, props2(index).GetValue(record2), itemListClinical, itemListClinical2, keyDict2, labelDict2)
                End If
                If IsInTabClinicalFacility(props(index).Name) = True Then
                    FillTabList(props(index).Name, props(index).GetValue(record), props2(index).Name, props2(index).GetValue(record2), itemListClinicalFacility, itemListClinicalFacility2, keyDict2, labelDict2)
                End If
                If IsInTabClinicalAntibiotics(props(index).Name) = True Then
                    FillTabList(props(index).Name, props(index).GetValue(record), props2(index).Name, props2(index).GetValue(record2), itemListClinicalAntibiotics, itemListClinicalAntibiotics2, keyDict2, labelDict2)
                End If
                If IsInTabClinicalVaccines(props(index).Name) = True Then
                    FillTabList(props(index).Name, props(index).GetValue(record), props2(index).Name, props2(index).GetValue(record2), itemListClinicalVaccines, itemListClinicalVaccines2, keyDict2, labelDict2)
                End If
                If IsInTabSample(props(index).Name) = True Then
                    FillTabList(props(index).Name, props(index).GetValue(record), props2(index).Name, props2(index).GetValue(record2), itemListSample, itemListSample2, keyDict3, labelDict3)
                End If
                If IsInTabCase(props(index).Name) = True Then
                    FillTabList(props(index).Name, props(index).GetValue(record), props2(index).Name, props2(index).GetValue(record2), itemListCase, itemListCase2, keyDict5, labelDict5)
                End If
                If IsInTabOutcome(props(index).Name) = True Then
                    FillTabList(props(index).Name, props(index).GetValue(record), props2(index).Name, props2(index).GetValue(record2), itemListOutcome, itemListOutcome2, keyDict7, labelDict7)
                End If
            Next

            'Bind Tab Notification 
            Session(NotificationList) = itemList.OrderBy(Function(s) s.Index).ToList()
            Session(NotificationList2) = itemList2.OrderBy(Function(s) s.Index).ToList()

            CheckBoxList1.DataSource = itemList.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList1.DataTextField = TextField
            CheckBoxList1.DataValueField = ValueField

            CheckBoxList2.DataSource = itemList2.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList2.DataTextField = TextField
            CheckBoxList2.DataValueField = ValueField

            CheckBoxList1.DataBind()
            CheckBoxList2.DataBind()

            For i As Integer = 0 To CheckBoxList1.Items.Count - 1
                If itemList.OrderBy(Function(s) s.Index).ToList().Item(i).Checked = True Then
                    CheckBoxList1.Items(i).Selected = True
                    CheckBoxList1.Items(i).Enabled = False
                    CheckBoxList2.Items(i).Selected = True
                    CheckBoxList2.Items(i).Enabled = False
                End If
            Next

            If CheckBoxList1.Items(0).Value Is Nothing OrElse CheckBoxList1.Items(0).Value = "" Then
                hdfidfsFinalDiagnosis.Value = "0"
            Else
                hdfidfsFinalDiagnosis.Value = CheckBoxList1.Items(0).Value
            End If
            If CheckBoxList2.Items(0).Value Is Nothing OrElse CheckBoxList2.Items(0).Value = "" Then
                hdfidfsFinalDiagnosis2.Value = "0"
            Else
                hdfidfsFinalDiagnosis2.Value = CheckBoxList2.Items(0).Value
            End If

            'Bind Tab Clinical Information 
            'Clinical Information: Symptoms
            Session(ClinicalList) = itemListClinical.OrderBy(Function(s) s.Index).ToList()
            Session(ClinicalList2) = itemListClinical2.OrderBy(Function(s) s.Index).ToList()

            CheckBoxList3.DataSource = itemListClinical.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList3.DataTextField = TextField
            CheckBoxList3.DataValueField = ValueField

            CheckBoxList4.DataSource = itemListClinical2.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList4.DataTextField = TextField
            CheckBoxList4.DataValueField = ValueField

            CheckBoxList3.DataBind()
            CheckBoxList4.DataBind()

            For i As Integer = 0 To CheckBoxList3.Items.Count - 1
                If itemListClinical.OrderBy(Function(s) s.Index).ToList().Item(i).Checked = True Then
                    CheckBoxList3.Items(i).Selected = True
                    CheckBoxList3.Items(i).Enabled = False
                    CheckBoxList4.Items(i).Selected = True
                    CheckBoxList4.Items(i).Enabled = False
                End If
            Next

            LoadFlexFormSymptoms()

            'If CheckBoxList3.Items(CheckBoxList3.Items.Count - 1).Value Is Nothing OrElse CheckBoxList3.Items(CheckBoxList3.Items.Count - 1).Value = "" Then
            '    hdfidfEpiObservation.Value = "0"
            'Else
            '    hdfidfEpiObservation.Value = CheckBoxList3.Items(CheckBoxList3.Items.Count - 1).Value
            'End If
            'FlexFormSymptoms.HumanCaseID = Long.Parse(hdfHumanDiseaseReportID.Value)
            'FlexFormSymptoms.DiagnosisID = Long.Parse(hdfidfsFinalDiagnosis.Value)
            'FlexFormSymptoms.ObservationID = Long.Parse(hdfidfEpiObservation.Value)
            'EnableForm(Symptoms, False)
            ''FlexFormSymptoms.EnableControls(False)

            'If CheckBoxList4.Items(CheckBoxList4.Items.Count - 1).Value Is Nothing OrElse CheckBoxList4.Items(CheckBoxList4.Items.Count - 1).Value = "" Then
            '    hdfidfEpiObservation2.Value = "0"
            'Else
            '    hdfidfEpiObservation2.Value = CheckBoxList4.Items(CheckBoxList4.Items.Count - 1).Value
            'End If
            'FlexFormSymptoms2.HumanCaseID = Long.Parse(hdfHumanDiseaseReportID2.Value)
            'FlexFormSymptoms2.DiagnosisID = Long.Parse(hdfidfsFinalDiagnosis2.Value)
            'FlexFormSymptoms2.ObservationID = Long.Parse(hdfidfEpiObservation2.Value)
            'EnableForm(Symptoms2, False)
            ''FlexFormSymptoms2.EnableControls(False)

            'Clinical Information: Facility Details
            Session(ClinicalFacilityList) = itemListClinicalFacility.OrderBy(Function(s) s.Index).ToList()
            Session(ClinicalFacilityList2) = itemListClinicalFacility2.OrderBy(Function(s) s.Index).ToList()

            CheckBoxList20.DataSource = itemListClinicalFacility.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList20.DataTextField = TextField
            CheckBoxList20.DataValueField = ValueField

            CheckBoxList21.DataSource = itemListClinicalFacility2.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList21.DataTextField = TextField
            CheckBoxList21.DataValueField = ValueField

            CheckBoxList20.DataBind()
            CheckBoxList21.DataBind()

            For i As Integer = 0 To CheckBoxList20.Items.Count - 1
                If itemListClinicalFacility.OrderBy(Function(s) s.Index).ToList().Item(i).Checked = True Then
                    CheckBoxList20.Items(i).Selected = True
                    CheckBoxList20.Items(i).Enabled = False
                    CheckBoxList21.Items(i).Selected = True
                    CheckBoxList21.Items(i).Enabled = False
                End If
            Next

            'Clinical Information: Antibiotics
            Session(ClinicalAntibioticsList) = itemListClinicalAntibiotics.OrderBy(Function(s) s.Index).ToList()
            Session(ClinicalAntibioticsList2) = itemListClinicalAntibiotics2.OrderBy(Function(s) s.Index).ToList()

            CheckBoxList22.DataSource = itemListClinicalAntibiotics.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList22.DataTextField = TextField
            CheckBoxList22.DataValueField = ValueField

            CheckBoxList24.DataSource = itemListClinicalAntibiotics2.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList24.DataTextField = TextField
            CheckBoxList24.DataValueField = ValueField

            CheckBoxList22.DataBind()
            CheckBoxList24.DataBind()

            For i As Integer = 0 To CheckBoxList22.Items.Count - 1
                If itemListClinicalAntibiotics.OrderBy(Function(s) s.Index).ToList().Item(i).Checked = True Then
                    CheckBoxList22.Items(i).Selected = True
                    CheckBoxList22.Items(i).Enabled = False
                    CheckBoxList24.Items(i).Selected = True
                    CheckBoxList24.Items(i).Enabled = False
                End If
            Next

            'Clinical Information: Vaccines
            Session(ClinicalVaccinesList) = itemListClinicalVaccines.OrderBy(Function(s) s.Index).ToList()
            Session(ClinicalVaccinesList2) = itemListClinicalVaccines2.OrderBy(Function(s) s.Index).ToList()

            CheckBoxList23.DataSource = itemListClinicalVaccines.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList23.DataTextField = TextField
            CheckBoxList23.DataValueField = ValueField

            CheckBoxList25.DataSource = itemListClinicalVaccines2.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList25.DataTextField = TextField
            CheckBoxList25.DataValueField = ValueField

            CheckBoxList23.DataBind()
            CheckBoxList25.DataBind()

            For i As Integer = 0 To CheckBoxList23.Items.Count - 1
                If itemListClinicalVaccines.OrderBy(Function(s) s.Index).ToList().Item(i).Checked = True Then
                    CheckBoxList23.Items(i).Selected = True
                    CheckBoxList23.Items(i).Enabled = False
                    CheckBoxList25.Items(i).Selected = True
                    CheckBoxList25.Items(i).Enabled = False
                End If
            Next

            'Bind Tab Samples
            Session(SampleList) = itemListSample.OrderBy(Function(s) s.Index).ToList()
            Session(SampleList2) = itemListSample2.OrderBy(Function(s) s.Index).ToList()

            CheckBoxList5.DataSource = itemListSample.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList5.DataTextField = TextField
            CheckBoxList5.DataValueField = ValueField

            CheckBoxList6.DataSource = itemListSample2.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList6.DataTextField = TextField
            CheckBoxList6.DataValueField = ValueField

            CheckBoxList5.DataBind()
            CheckBoxList6.DataBind()

            For i As Integer = 0 To CheckBoxList5.Items.Count - 1
                If itemListSample.OrderBy(Function(s) s.Index).ToList().Item(i).Checked = True Then
                    CheckBoxList5.Items(i).Selected = True
                    CheckBoxList5.Items(i).Enabled = False
                    CheckBoxList6.Items(i).Selected = True
                    CheckBoxList6.Items(i).Enabled = False
                End If
            Next

            'Bind Tab Case Investigation
            Session(CaseList0) = itemListCase.OrderBy(Function(s) s.Index).ToList().ConvertAll(Function(x) New Field(x))
            Session(CaseList02) = itemListCase2.OrderBy(Function(s) s.Index).ToList().ConvertAll(Function(x) New Field(x))

            Session(CaseList) = itemListCase.OrderBy(Function(s) s.Index).ToList()
            Session(CaseList2) = itemListCase2.OrderBy(Function(s) s.Index).ToList()

            CheckBoxList9.DataSource = itemListCase.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList9.DataTextField = TextField
            CheckBoxList9.DataValueField = ValueField

            CheckBoxList10.DataSource = itemListCase2.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList10.DataTextField = TextField
            CheckBoxList10.DataValueField = ValueField

            CheckBoxList9.DataBind()
            CheckBoxList10.DataBind()

            For i As Integer = 0 To CheckBoxList9.Items.Count - 1
                If itemListCase.OrderBy(Function(s) s.Index).ToList().Item(i).Checked = True Then
                    CheckBoxList9.Items(i).Selected = True
                    CheckBoxList9.Items(i).Enabled = False
                    CheckBoxList10.Items(i).Selected = True
                    CheckBoxList10.Items(i).Enabled = False
                ElseIf IsInExactAddressGroup(itemListCase.OrderBy(Function(s) s.Index).ToList().Item(i).Key) = True Then
                    CheckBoxList9.Items(i).Enabled = False
                    CheckBoxList10.Items(i).Enabled = False
                    'ElseIf IsInSchoolAddressGroup(itemListCase.OrderBy(Function(s) s.Index).ToList().Item(i).Key) = True Then
                    '    CheckBoxList9.Items(i).Enabled = False
                    '    CheckBoxList10.Items(i).Enabled = False
                End If
            Next

            For i As Integer = 0 To CheckBoxList9.Items.Count - 1
                If Session(CaseList)(i).Key = DiseaseReportDeduplicationCaseConstants.Region And CheckBoxList9.Items(i).Selected = True Then
                    If GroupAllChecked(i, EXACTADDRESSNUMBERFIELD, CheckBoxList9) = False Then
                        CType(Session(CaseList), List(Of Field))(i).Checked = False
                        CType(Session(CaseList2), List(Of Field))(i).Checked = False
                        CheckBoxList9.Items(i).Selected = False
                        CheckBoxList9.Items(i).Enabled = True
                        CheckBoxList10.Items(i).Selected = False
                        CheckBoxList10.Items(i).Enabled = True
                    End If
                    'ElseIf CType(Session(CaseList), List(Of Field))(i).Key = DiseaseReportDeduplicationCaseConstants.Region And CheckBoxList9.Items(i).Selected = True Then
                    '    If GroupAllChecked(i, SCHOOLADDRESSNUMBERFIELD, CheckBoxList5) = False Then
                    '        CType(Session(CaseList), List(Of Field))(i).Checked = False
                    '        CType(Session(CaseList2), List(Of Field))(i).Checked = False
                    '        CheckBoxList9.Items(i).Selected = False
                    '        CheckBoxList9.Items(i).Enabled = True
                    '        CheckBoxList10.Items(i).Selected = False
                    '        CheckBoxList10.Items(i).Enabled = True
                    '    End If
                End If
            Next

            LoadFlexFormRiskFactors()
            'If CheckBoxList9.Items(CheckBoxList9.Items.Count - 1).Value Is Nothing OrElse CheckBoxList9.Items(CheckBoxList9.Items.Count - 1).Value = "" Then
            '    hdfidfCSObservation.Value = "0"
            'Else
            '    hdfidfCSObservation.Value = CheckBoxList9.Items(CheckBoxList9.Items.Count - 1).Value
            'End If
            'HumanDiseaseFlexFormRiskFactors.HumanCaseID = Long.Parse(hdfHumanDiseaseReportID.Value)
            'HumanDiseaseFlexFormRiskFactors.DiagnosisID = Long.Parse(hdfidfsFinalDiagnosis.Value)
            'HumanDiseaseFlexFormRiskFactors.ObservationID = Long.Parse(hdfidfCSObservation.Value)
            ''EnableForm(Symptoms, False)
            'HumanDiseaseFlexFormRiskFactors.EnableControls(True)

            'If CheckBoxList10.Items(CheckBoxList10.Items.Count - 1).Value Is Nothing OrElse CheckBoxList10.Items(CheckBoxList10.Items.Count - 1).Value = "" Then
            '    hdfidfCSObservation2.Value = "0"
            'Else
            '    hdfidfCSObservation2.Value = CheckBoxList10.Items(CheckBoxList10.Items.Count - 1).Value
            'End If
            'HumanDiseaseFlexFormRiskFactors2.HumanCaseID = Long.Parse(hdfHumanDiseaseReportID2.Value)
            'HumanDiseaseFlexFormRiskFactors2.DiagnosisID = Long.Parse(hdfidfsFinalDiagnosis2.Value)
            'HumanDiseaseFlexFormRiskFactors2.ObservationID = Long.Parse(hdfidfCSObservation2.Value)
            ''EnableForm(Symptoms2, False)
            'HumanDiseaseFlexFormRiskFactors2.EnableControls(True)

            'Bind Tab Final Outcome 
            Session(OutcomeList) = itemListOutcome.OrderBy(Function(s) s.Index).ToList()
            Session(OutcomeList2) = itemListOutcome2.OrderBy(Function(s) s.Index).ToList()

            CheckBoxList13.DataSource = itemListOutcome.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList13.DataTextField = TextField
            CheckBoxList13.DataValueField = ValueField

            CheckBoxList14.DataSource = itemListOutcome2.OrderBy(Function(s) s.Index).ToList()
            CheckBoxList14.DataTextField = TextField
            CheckBoxList14.DataValueField = ValueField

            CheckBoxList13.DataBind()
            CheckBoxList14.DataBind()

            For i As Integer = 0 To CheckBoxList13.Items.Count - 1
                If itemListOutcome.OrderBy(Function(s) s.Index).ToList().Item(i).Checked = True Then
                    CheckBoxList13.Items(i).Selected = True
                    CheckBoxList13.Items(i).Enabled = False
                    CheckBoxList14.Items(i).Selected = True
                    CheckBoxList14.Items(i).Enabled = False
                End If
            Next

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            Throw ex
        End Try
    End Sub

    Private Sub LoadFlexFormSymptoms()
        Try
            If CheckBoxList3.Items(CheckBoxList3.Items.Count - 1).Value Is Nothing OrElse CheckBoxList3.Items(CheckBoxList3.Items.Count - 1).Value = "" Then
                hdfidfEpiObservation.Value = "0"
            Else
                hdfidfEpiObservation.Value = CheckBoxList3.Items(CheckBoxList3.Items.Count - 1).Value
            End If
            FlexFormSymptoms.HumanCaseID = Long.Parse(hdfHumanDiseaseReportID.Value)
            FlexFormSymptoms.DiagnosisID = Long.Parse(hdfidfsFinalDiagnosis.Value)
            FlexFormSymptoms.ObservationID = Long.Parse(hdfidfEpiObservation.Value)
            'EnableForm(FlexFormSymptoms, False)
            FlexFormSymptoms.EnableControls(False)

            If CheckBoxList4.Items(CheckBoxList4.Items.Count - 1).Value Is Nothing OrElse CheckBoxList4.Items(CheckBoxList4.Items.Count - 1).Value = "" Then
                hdfidfEpiObservation2.Value = "0"
            Else
                hdfidfEpiObservation2.Value = CheckBoxList4.Items(CheckBoxList4.Items.Count - 1).Value
            End If
            FlexFormSymptoms2.HumanCaseID = Long.Parse(hdfHumanDiseaseReportID2.Value)
            FlexFormSymptoms2.DiagnosisID = Long.Parse(hdfidfsFinalDiagnosis2.Value)
            FlexFormSymptoms2.ObservationID = Long.Parse(hdfidfEpiObservation2.Value)
            'EnableForm(FlexFormSymptoms2, False)
            FlexFormSymptoms2.EnableControls(False)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            Throw ex
        End Try
    End Sub

    Private Sub LoadFlexFormRiskFactors()
        Try
            If CheckBoxList9.Items(CheckBoxList9.Items.Count - 1).Value Is Nothing OrElse CheckBoxList9.Items(CheckBoxList9.Items.Count - 1).Value = "" Then
                hdfidfCSObservation.Value = "0"
            Else
                hdfidfCSObservation.Value = CheckBoxList9.Items(CheckBoxList9.Items.Count - 1).Value
            End If
            HumanDiseaseFlexFormRiskFactors.HumanCaseID = Long.Parse(hdfHumanDiseaseReportID.Value)
            HumanDiseaseFlexFormRiskFactors.DiagnosisID = Long.Parse(hdfidfsFinalDiagnosis.Value)
            HumanDiseaseFlexFormRiskFactors.ObservationID = Long.Parse(hdfidfCSObservation.Value)
            'EnableForm(Symptoms, False)
            HumanDiseaseFlexFormRiskFactors.EnableControls(True)

            If CheckBoxList10.Items(CheckBoxList10.Items.Count - 1).Value Is Nothing OrElse CheckBoxList10.Items(CheckBoxList10.Items.Count - 1).Value = "" Then
                hdfidfCSObservation2.Value = "0"
            Else
                hdfidfCSObservation2.Value = CheckBoxList10.Items(CheckBoxList10.Items.Count - 1).Value
            End If
            HumanDiseaseFlexFormRiskFactors2.HumanCaseID = Long.Parse(hdfHumanDiseaseReportID2.Value)
            HumanDiseaseFlexFormRiskFactors2.DiagnosisID = Long.Parse(hdfidfsFinalDiagnosis2.Value)
            HumanDiseaseFlexFormRiskFactors2.ObservationID = Long.Parse(hdfidfCSObservation2.Value)
            'EnableForm(Symptoms2, False)
            HumanDiseaseFlexFormRiskFactors2.EnableControls(True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            Throw ex
        End Try
    End Sub

    Private Sub FillAntibioticsList()
        Try
            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            Dim list = New List(Of HumDiseaseAntiviraltherapiesGetListModel)()
            list = HumanAPIService.HumDiseaseAntiviraltherapiesGetListAsync(GetCurrentLanguage(), Long.Parse(hdfHumanDiseaseReportID.Value)).Result

            gvAntibiotics.DataSource = list
            gvAntibiotics.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Private Sub FillAntibiotics2List()
        Try
            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            Dim list = New List(Of HumDiseaseAntiviraltherapiesGetListModel)()
            list = HumanAPIService.HumDiseaseAntiviraltherapiesGetListAsync(GetCurrentLanguage(), Long.Parse(hdfHumanDiseaseReportID2.Value)).Result

            gvAntibiotics2.DataSource = list
            gvAntibiotics2.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Private Sub FillVaccinationsList()
        Try
            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            Dim list = New List(Of HumDiseaseVaccinationsGetListModel)()
            list = HumanAPIService.HumDiseaseVaccinationsGetListAsync(GetCurrentLanguage(), Long.Parse(hdfHumanDiseaseReportID.Value)).Result

            gvVaccinations.DataSource = list
            gvVaccinations.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Private Sub FillVaccinations2List()
        Try
            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            Dim list = New List(Of HumDiseaseVaccinationsGetListModel)()
            list = HumanAPIService.HumDiseaseVaccinationsGetListAsync(GetCurrentLanguage(), Long.Parse(hdfHumanDiseaseReportID2.Value)).Result

            gvVaccinations2.DataSource = list
            gvVaccinations2.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Private Sub FillSamplesList()
        Try
            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            Dim list = New List(Of HumSamplesGetListModel)()
            list = HumanAPIService.GetHumanSamples(GetCurrentLanguage(), Long.Parse(hdfHumanDiseaseReportID.Value), Long.Parse("0")).Result

            gvSamples.DataSource = list
            gvSamples.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Private Sub FillSamples2List()
        Try
            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            Dim list = New List(Of HumSamplesGetListModel)()
            list = HumanAPIService.GetHumanSamples(GetCurrentLanguage(), Long.Parse(hdfHumanDiseaseReportID2.Value), Long.Parse("0")).Result

            gvSamples2.DataSource = list
            gvSamples2.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Private Sub FillTestsList()
        Try
            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            Dim list = New List(Of HumTestsGetListModel)()
            list = HumanAPIService.GetHumanDiseaseTests(GetCurrentLanguage(), Long.Parse(hdfHumanDiseaseReportID.Value), Long.Parse("0")).Result

            gvTests.DataSource = list
            gvTests.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Private Sub FillTests2List()
        Try
            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            Dim list = New List(Of HumTestsGetListModel)()
            list = HumanAPIService.GetHumanDiseaseTests(GetCurrentLanguage(), Long.Parse(hdfHumanDiseaseReportID2.Value), Long.Parse("0")).Result

            gvTests2.DataSource = list
            gvTests2.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Private Sub FillContactsList()
        Try
            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            Dim List = New List(Of HumDiseaseContactsGetListModel)()
            List = HumanAPIService.GetHumanDiseaseContacts(GetCurrentLanguage(), Long.Parse(hdfHumanDiseaseReportID.Value)).Result

            gvContacts.DataSource = List
            gvContacts.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    Private Sub FillContacts2List()
        Try
            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If

            Dim List = New List(Of HumDiseaseContactsGetListModel)()
            List = HumanAPIService.GetHumanDiseaseContacts(GetCurrentLanguage(), Long.Parse(hdfHumanDiseaseReportID2.Value)).Result

            gvContacts2.DataSource = List
            gvContacts2.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Throw
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsInTabNotification(ByVal strName As String) As Boolean
        Select Case strName
            Case DiseaseReportDeduplicationNotificationConstants.Disease
                Return True
            Case DiseaseReportDeduplicationNotificationConstants.DateOfDisease
                Return True
            Case DiseaseReportDeduplicationNotificationConstants.NotificationDate
                Return True
            Case DiseaseReportDeduplicationNotificationConstants.PatientStatus
                Return True
            Case DiseaseReportDeduplicationNotificationConstants.SentByOffice
                Return True
            Case DiseaseReportDeduplicationNotificationConstants.SentByPerson
                Return True
            Case DiseaseReportDeduplicationNotificationConstants.ReceivedByOffice
                Return True
            Case DiseaseReportDeduplicationNotificationConstants.ReceivedByPerson
                Return True
            Case DiseaseReportDeduplicationNotificationConstants.PatientCurrentLocation
                Return True
            Case DiseaseReportDeduplicationNotificationConstants.HospitalName
                Return True
            Case DiseaseReportDeduplicationNotificationConstants.OtherLocation
                Return True
        End Select
        Return False
    End Function


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsInTabClinical(ByVal strName As String) As Boolean
        Select Case strName
            Case DiseaseReportDeduplicationClinicalConstants.OnSetDate
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.InitialCaseStatus
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.SymptomList
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.PreviouslySoughtCare
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.FacilityFirstSoughtCare
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.FirstSoughtCareDate
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.NonNotifiableDiagnosis
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.Hospitalization
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.HospitalName
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.HospitalizationDate
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.DischargeDate
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.AntimicrobialTherapy
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.AntimicrobialTherapyName
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.Dosage
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.FirstAdministeredDate
                Return True
            'Case DiseaseReportDeduplicationClinicalConstants.AdditionalComments
            '    Return True
            Case DiseaseReportDeduplicationClinicalConstants.SpecificVaccinationAdministered
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.VaccinationName
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.VaccinationDate
                Return True
        End Select
        Return False
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsInTabClinicalSymptoms(ByVal strName As String) As Boolean
        Select Case strName
            Case DiseaseReportDeduplicationClinicalConstants.OnSetDate
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.InitialCaseStatus
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.SymptomList
                Return True
        End Select
        Return False
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsInTabClinicalFacility(ByVal strName As String) As Boolean
        Select Case strName
            Case DiseaseReportDeduplicationClinicalConstants.PreviouslySoughtCare
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.FacilityFirstSoughtCare
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.FirstSoughtCareDate
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.NonNotifiableDiagnosis
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.Hospitalization
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.HospitalName
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.HospitalizationDate
                Return True
            Case DiseaseReportDeduplicationClinicalConstants.DischargeDate
                Return True
        End Select
        Return False
    End Function


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsInTabClinicalAntibiotics(ByVal strName As String) As Boolean
        Select Case strName
            Case DiseaseReportDeduplicationClinicalConstants.AntimicrobialTherapy
                Return True
        End Select
        Return False
    End Function


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsInTabClinicalVaccines(ByVal strName As String) As Boolean
        Select Case strName
            Case DiseaseReportDeduplicationClinicalConstants.SpecificVaccinationAdministered
                Return True
        End Select
        Return False
    End Function

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsInTabCase(ByVal strName As String) As Boolean
        Select Case strName
            Case DiseaseReportDeduplicationCaseConstants.InvestigatedByOffice
                Return True
            Case DiseaseReportDeduplicationCaseConstants.StartDateofInvestigation
                Return True
            Case DiseaseReportDeduplicationCaseConstants.RelatedToOutbreak
                Return True
            Case DiseaseReportDeduplicationCaseConstants.OutbreakID
                Return True
            Case DiseaseReportDeduplicationCaseConstants.ExposureLocationKnown
                Return True
            Case DiseaseReportDeduplicationCaseConstants.ExposureDate
                Return True
            Case DiseaseReportDeduplicationCaseConstants.ExposureLocation
                Return True
            Case DiseaseReportDeduplicationCaseConstants.Description
                Return True
            Case DiseaseReportDeduplicationCaseConstants.Region
                Return True
            Case DiseaseReportDeduplicationCaseConstants.Rayon
                Return True
                'Case DiseaseReportDeduplicationCaseConstants.Settlement
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.Street
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.Latitude
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.Longitude
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.Elevation
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.Description
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.Region
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.Rayon
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.Settlement
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.Street
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.GroundType
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.Distance
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.Direction
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.Country
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.Address
                '    Return True
            Case DiseaseReportDeduplicationCaseConstants.RiskFactorList
                Return True
        End Select
        Return False
    End Function


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsInTabOutcome(ByVal strName As String) As Boolean
        Select Case strName
            Case DiseaseReportDeduplicationOutcomeConstants.FinalCaseStatus
                Return True
            Case DiseaseReportDeduplicationOutcomeConstants.DateofClassification
                Return True
            Case DiseaseReportDeduplicationOutcomeConstants.BasisofDiagnosis
                Return True
            Case DiseaseReportDeduplicationOutcomeConstants.Outcome
                Return True
            Case DiseaseReportDeduplicationOutcomeConstants.DateofDeath
                Return True
        End Select
        Return False
    End Function


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsInTabSample(ByVal strName As String) As Boolean
        Select Case strName
            Case DiseaseReportDeduplicationSampleConstants.SampleCollected
                Return True
        End Select
        Return False
    End Function

    Public Structure DiseaseReportDeduplicationNotificationConstants
        Public Const Disease As String = "idfsFinalDiagnosis"
        Public Const DateOfDisease As String = "datDateOfDiagnosis"
        Public Const NotificationDate As String = "datNotificationDate"
        Public Const PatientStatus As String = "idfsFinalState"
        Public Const SentByOffice As String = "idfSentByOffice"
        Public Const SentByPerson As String = "idfSentByPerson"
        Public Const ReceivedByOffice As String = "idfReceivedByOffice"
        Public Const ReceivedByPerson As String = "idfReceivedByPerson"
        Public Const PatientCurrentLocation As String = "idfsHospitalizationStatus"
        Public Const HospitalName As String = "idfHospital"
        Public Const OtherLocation As String = "strCurrentLocation"
    End Structure

    Public Structure DiseaseReportDeduplicationClinicalConstants
        Public Const OnSetDate As String = "datOnSetDate"
        Public Const InitialCaseStatus As String = "idfsInitialCaseStatus"
        Public Const SymptomList As String = "idfEpiObservation"
        Public Const PreviouslySoughtCare As String = "idfsYNPreviouslySoughtCare"
        Public Const FacilityFirstSoughtCare As String = "idfSougtCareFacility"
        Public Const FirstSoughtCareDate As String = "datFirstSoughtCareDate"
        Public Const NonNotifiableDiagnosis As String = "idfsNonNotifiableDiagnosis"
        Public Const Hospitalization As String = "idfsYNHospitalization"
        Public Const HospitalName As String = "strHospitalName"
        Public Const HospitalizationDate As String = "datHospitalizationDate"
        Public Const DischargeDate As String = "datDischargeDate"
        Public Const AntimicrobialTherapy As String = "idfsYNAntimicrobialTherapy"
        Public Const AntimicrobialTherapyName As String = "strAntibioticName"
        Public Const Dosage As String = "strDosage"
        Public Const FirstAdministeredDate As String = "datFirstAdministeredDate"
        Public Const strAntibioticComments As String = "AdditionalComments"
        Public Const SpecificVaccinationAdministered As String = "idfsYNSpecificVaccinationAdministered"
        Public Const VaccinationName As String = "VaccinationName"
        Public Const VaccinationDate As String = "VaccinationDate"
    End Structure

    Public Structure DiseaseReportDeduplicationCaseConstants
        Public Const InvestigatedByOffice As String = "idfInvestigatedByOffice"
        Public Const StartDateofInvestigation As String = "StartDateofInvestigation"
        Public Const RelatedToOutbreak As String = "idfsYNRelatedToOutbreak"
        Public Const OutbreakID As String = "idfOutbreak"
        Public Const ExposureLocationKnown As String = "idfsYNExposureLocationKnown"
        Public Const ExposureDate As String = "datExposureDate"
        Public Const ExposureLocation As String = "idfPointGeoLocation"
        Public Const Description As String = "strLocationDescription"
        Public Const Region As String = "Region"
        Public Const Rayon As String = "Rayon"
        'Public Const Settlement As String = "Settlement"
        'Public Const Street As String = "Street"
        'Public Const Latitude As String = "Latitude"
        'Public Const Longitude As String = "Longitude"
        'Public Const Elevation As String = "Elevation"
        'Public Const Description As String = "strDescription"
        'Public Const Region As String = "Region"
        'Public Const Rayon As String = "Rayon"
        'Public Const Settlement As String = "Settlement"
        'Public Const Street As String = "Street"
        Public Const GroundType As String = "GroundType"
        Public Const Distance As String = "Distance"
        Public Const Direction As String = "Direction"
        Public Const Country As String = "Country"
        Public Const Address As String = "Address"
        Public Const RiskFactorList As String = "idfCSObservation"
    End Structure

    Public Structure DiseaseReportDeduplicationOutcomeConstants
        Public Const FinalCaseStatus As String = "idfsFinalCaseStatus"
        Public Const DateofClassification As String = "DateofClassification"
        Public Const BasisofDiagnosis As String = "strClinicalDiagnosis"
        Public Const Outcome As String = "idfsOutcome"
        Public Const DateofDeath As String = "datDateofDeath"
    End Structure

    Public Structure DiseaseReportDeduplicationSampleConstants
        Public Const SampleCollected As String = "idfsYNSpecimenCollected"
    End Structure


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="key"></param>
    ''' <param name="value"></param>
    ''' <param name="key2"></param>
    ''' <param name="value2"></param>
    ''' <param name="list"></param>
    ''' <param name="list2"></param>
    ''' <param name="keyDict"></param>
    ''' <param name="labelDict"></param>
    Sub FillTabList(key As String, value As String, key2 As String, value2 As String, ByRef list As List(Of Field), ByRef list2 As List(Of Field), ByRef keyDict As Dictionary(Of String, Integer), ByRef labelDict As Dictionary(Of Integer, String))
        Try
            Dim temp As String = String.Empty
            Dim temp2 As String = String.Empty
            Dim item As New Field
            Dim item2 As New Field

            If keyDict.ContainsKey(key) Then
                item.Index = keyDict.Item(key)
                item.Key = key
                item.Value = value
                item2.Index = keyDict.Item(key)
                item2.Key = key
                item2.Value = value2

                If value = value2 Then
                    If value IsNot Nothing Then
                        temp = value.ToString
                        temp2 = value2.ToString
                    Else
                        temp = String.Empty
                    End If

                    item.Label = "<font style='color:#2C6187;font-size:12px'>" & GetLocalResourceObject(labelDict.Item(item.Index)).ToString + "</font>" + "<br><font style='color:#333;font-size:12px;font-weight:normal'>" & temp + "</font>"
                    item2.Label = "<font style='color:#2C6187;font-size:12px'>" & GetLocalResourceObject(labelDict.Item(item.Index)).ToString + "</font>" + "<br><font style='color:#333;font-size:12px;font-weight:normal'>" & temp2 + "</font>"
                    item.Checked = True
                    item2.Checked = True
                Else
                    If value IsNot Nothing Then
                        temp = value.ToString
                    Else
                        temp = String.Empty
                    End If

                    item.Label = "<font style='color:#9b1010;font-size:12px'>" & GetLocalResourceObject(labelDict.Item(item.Index)).ToString + "</font>" + "<br><font style='color:#333;font-size:12px;font-weight:normal'>" & temp + "</font>"
                    item.Checked = False

                    If value2 IsNot Nothing Then
                        temp = value2.ToString
                    Else
                        temp = String.Empty
                    End If

                    item2.Label = "<font style='color:#9b1010;font-size:12px'>" & GetLocalResourceObject(labelDict.Item(item.Index)).ToString + "</font>" + "<br><font style='color:#333;font-size:12px;font-weight:normal'>" & temp + "</font>"
                    item2.Checked = False
                End If

                list.Add(item)
                list2.Add(item2)
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            Throw ex
        End Try
    End Sub


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="index"></param>
    ''' <param name="length"></param>
    ''' <param name="control"></param>
    Private Function GroupAllChecked(ByVal index As Integer, ByVal length As Integer, control As CheckBoxList) As Boolean
        Try
            Dim AllChecked As Boolean = True

            For i As Integer = index + 1 To index + length - 1
                If control.Items(i).Selected = False Then
                    AllChecked = False
                    Return False
                End If
            Next
            Return True
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            Return False
        End Try
    End Function


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsInExactAddressGroup(ByVal strName As String) As Boolean
        Select Case strName
            Case DiseaseReportDeduplicationCaseConstants.Rayon
                Return True
                'Case DiseaseReportDeduplicationCaseConstants.Settlement
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.Street
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.strDescription
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.Latitude
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.Longitude
                '    Return True
                'Case DiseaseReportDeduplicationCaseConstants.Elevation
                '    Return True
        End Select
        Return False
    End Function


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsInRelativeAddressGroup(ByVal strName As String) As Boolean
        Select Case strName
            Case DiseaseReportDeduplicationCaseConstants.Rayon
                Return True
            'Case DiseaseReportDeduplicationCaseConstants.Settlement
            '    Return True
            'Case DiseaseReportDeduplicationCaseConstants.Street
            '    Return True
            'Case DiseaseReportDeduplicationCaseConstants.strDescription
            '    Return True
            Case DiseaseReportDeduplicationCaseConstants.GroundType
                Return True
            Case DiseaseReportDeduplicationCaseConstants.Distance
                Return True
            Case DiseaseReportDeduplicationCaseConstants.Direction
                Return True
        End Select
        Return False
    End Function

#End Region

#Region "Deduplication Details Methods"

    Protected Sub Record_CheckedChanged(sender As Object, e As EventArgs) Handles rdbSurvivor.CheckedChanged, rdbSuperceded.CheckedChanged
        Try
            If rdbSurvivor.Checked Then
                rdbSuperceded2.Checked = True
                FillSurvivorLists(False)
                Session(SurvivorHumanDiseaseReportID) = hdfHumanDiseaseReportID.Value
                Session(SupersededHumanDiseaseReportID) = hdfHumanDiseaseReportID2.Value
            End If
            If rdbSuperceded.Checked Then
                rdbSurvivor2.Checked = True
                FillSurvivorLists(True)
                Session(SurvivorHumanDiseaseReportID) = hdfHumanDiseaseReportID2.Value
                Session(SupersededHumanDiseaseReportID) = hdfHumanDiseaseReportID.Value
            End If
            BindTabs()
            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub Record2_CheckedChanged(sender As Object, e As EventArgs) Handles rdbSurvivor2.CheckedChanged, rdbSuperceded2.CheckedChanged
        Try
            If rdbSurvivor2.Checked Then
                rdbSuperceded.Checked = True
                FillSurvivorLists(True)
                Session(SurvivorHumanDiseaseReportID) = hdfHumanDiseaseReportID2.Value
                Session(SupersededHumanDiseaseReportID) = hdfHumanDiseaseReportID.Value
            End If
            If rdbSuperceded2.Checked Then
                rdbSurvivor.Checked = True
                FillSurvivorLists(False)
                Session(SurvivorHumanDiseaseReportID) = hdfHumanDiseaseReportID.Value
                Session(SupersededHumanDiseaseReportID) = hdfHumanDiseaseReportID2.Value
            End If
            BindTabs()
            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="record2"></param>
    Protected Sub FillSurvivorLists(record2 As Boolean)
        Try
            SurvivorListNotification.Clear()
            SurvivorListClinical.Clear()
            SurvivorListClinicalFacility.Clear()
            SurvivorListClinicalAntibiotics.Clear()
            SurvivorListClinicalVaccines.Clear()
            SurvivorListSample.Clear()
            SurvivorListCase.Clear()
            SurvivorListOutcome.Clear()

            If record2 = True Then
                If SurvivorListNotification.Count = 0 Then
                    For i As Integer = 0 To CType(Session(NotificationList2), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(NotificationList2), List(Of Field)).Item(i))
                        SurvivorListNotification.Add(item)
                    Next
                End If
                If SurvivorListClinical.Count = 0 Then
                    For i As Integer = 0 To CType(Session(ClinicalList2), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(ClinicalList2), List(Of Field)).Item(i))
                        SurvivorListClinical.Add(item)
                    Next
                End If
                If SurvivorListClinicalFacility.Count = 0 Then
                    For i As Integer = 0 To CType(Session(ClinicalFacilityList2), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(ClinicalFacilityList2), List(Of Field)).Item(i))
                        SurvivorListClinicalFacility.Add(item)
                    Next
                End If
                If SurvivorListClinicalAntibiotics.Count = 0 Then
                    For i As Integer = 0 To CType(Session(ClinicalAntibioticsList2), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(ClinicalAntibioticsList2), List(Of Field)).Item(i))
                        SurvivorListClinicalAntibiotics.Add(item)
                    Next
                End If
                If SurvivorListClinicalVaccines.Count = 0 Then
                    For i As Integer = 0 To CType(Session(ClinicalVaccinesList2), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(ClinicalVaccinesList2), List(Of Field)).Item(i))
                        SurvivorListClinicalVaccines.Add(item)
                    Next
                End If
                If SurvivorListSample.Count = 0 Then
                    For i As Integer = 0 To CType(Session(SampleList2), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(SampleList2), List(Of Field)).Item(i))
                        SurvivorListSample.Add(item)
                    Next
                End If
                If SurvivorListCase.Count = 0 Then
                    For i As Integer = 0 To CType(Session(CaseList02), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(CaseList02), List(Of Field)).Item(i))
                        SurvivorListCase.Add(item)
                    Next
                End If
                If SurvivorListOutcome.Count = 0 Then
                    For i As Integer = 0 To CType(Session(OutcomeList2), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(OutcomeList2), List(Of Field)).Item(i))
                        SurvivorListOutcome.Add(item)
                    Next
                End If
            Else
                If SurvivorListNotification.Count = 0 Then
                    For i As Integer = 0 To CType(Session(NotificationList), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(NotificationList), List(Of Field)).Item(i))
                        SurvivorListNotification.Add(item)
                    Next
                End If
                If SurvivorListClinical.Count = 0 Then
                    For i As Integer = 0 To CType(Session(ClinicalList), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(ClinicalList), List(Of Field)).Item(i))
                        SurvivorListClinical.Add(item)
                    Next
                End If
                If SurvivorListSample.Count = 0 Then
                    For i As Integer = 0 To CType(Session(SampleList), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(SampleList), List(Of Field)).Item(i))
                        SurvivorListSample.Add(item)
                    Next
                End If
                If SurvivorListCase.Count = 0 Then
                    For i As Integer = 0 To CType(Session(CaseList0), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(CaseList0), List(Of Field)).Item(i))
                        SurvivorListCase.Add(item)
                    Next
                End If
                If SurvivorListOutcome.Count = 0 Then
                    For i As Integer = 0 To CType(Session(OutcomeList), List(Of Field)).Count - 1
                        Dim item As New Field(CType(Session(OutcomeList), List(Of Field)).Item(i))
                        SurvivorListOutcome.Add(item)
                    Next
                End If
            End If
            Session(SURVIVOR_LIST_NOTIFICATION) = SurvivorListNotification
            Session(SURVIVOR_LIST_CLINICAL) = SurvivorListClinical
            Session(SURVIVOR_LIST_SAMPLE) = SurvivorListSample
            Session(SURVIVOR_LIST_CASE) = SurvivorListCase
            Session(SURVIVOR_LIST_OUTCOME) = SurvivorListOutcome

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Sub BindTabs()
        Try
            CheckBoxList1.DataSource = CType(Session(NotificationList), List(Of Field))
            CheckBoxList1.DataTextField = TextField
            CheckBoxList1.DataValueField = ValueField

            CheckBoxList2.DataSource = CType(Session(NotificationList2), List(Of Field))
            CheckBoxList2.DataTextField = TextField
            CheckBoxList2.DataValueField = ValueField

            CheckBoxList1.DataBind()
            CheckBoxList2.DataBind()

            For i As Integer = 0 To CheckBoxList1.Items.Count - 1
                If Session(NotificationList).Item(i).Checked = True Then
                    CheckBoxList1.Items(i).Selected = True
                    CheckBoxList1.Items(i).Enabled = False
                    CheckBoxList2.Items(i).Selected = True
                    CheckBoxList2.Items(i).Enabled = False
                End If
            Next

            'Bind Tab Clinical Information 
            'Clinical Information: Symptoms
            CheckBoxList3.DataSource = CType(Session(ClinicalList), List(Of Field))
            CheckBoxList3.DataTextField = TextField
            CheckBoxList3.DataValueField = ValueField

            CheckBoxList4.DataSource = CType(Session(ClinicalList2), List(Of Field))
            CheckBoxList4.DataTextField = TextField
            CheckBoxList4.DataValueField = ValueField

            CheckBoxList3.DataBind()
            CheckBoxList4.DataBind()

            For i As Integer = 0 To CheckBoxList3.Items.Count - 1
                If CType(Session(ClinicalList), List(Of Field)).Item(i).Checked = True Then
                    CheckBoxList3.Items(i).Selected = True
                    CheckBoxList3.Items(i).Enabled = False
                    CheckBoxList4.Items(i).Selected = True
                    CheckBoxList4.Items(i).Enabled = False
                End If
            Next

            'Clinical Information: Facility Details
            CheckBoxList20.DataSource = CType(Session(ClinicalFacilityList), List(Of Field))
            CheckBoxList20.DataTextField = TextField
            CheckBoxList20.DataValueField = ValueField

            CheckBoxList21.DataSource = CType(Session(ClinicalFacilityList2), List(Of Field))
            CheckBoxList21.DataTextField = TextField
            CheckBoxList21.DataValueField = ValueField

            CheckBoxList20.DataBind()
            CheckBoxList21.DataBind()

            For i As Integer = 0 To CheckBoxList20.Items.Count - 1
                If CType(Session(ClinicalFacilityList), List(Of Field)).Item(i).Checked = True Then
                    CheckBoxList20.Items(i).Selected = True
                    CheckBoxList20.Items(i).Enabled = False
                    CheckBoxList21.Items(i).Selected = True
                    CheckBoxList21.Items(i).Enabled = False
                End If
            Next

            'Clinical Information: Antibiotics
            CheckBoxList22.DataSource = CType(Session(ClinicalAntibioticsList), List(Of Field))
            CheckBoxList22.DataTextField = TextField
            CheckBoxList22.DataValueField = ValueField

            CheckBoxList24.DataSource = CType(Session(ClinicalAntibioticsList2), List(Of Field))
            CheckBoxList24.DataTextField = TextField
            CheckBoxList24.DataValueField = ValueField

            CheckBoxList22.DataBind()
            CheckBoxList24.DataBind()

            For i As Integer = 0 To CheckBoxList22.Items.Count - 1
                If CType(Session(ClinicalAntibioticsList), List(Of Field)).Item(i).Checked = True Then
                    CheckBoxList22.Items(i).Selected = True
                    CheckBoxList22.Items(i).Enabled = False
                    CheckBoxList24.Items(i).Selected = True
                    CheckBoxList24.Items(i).Enabled = False
                End If
            Next

            'Clinical Information: Vaccines
            CheckBoxList23.DataSource = CType(Session(ClinicalVaccinesList), List(Of Field))
            CheckBoxList23.DataTextField = TextField
            CheckBoxList23.DataValueField = ValueField

            CheckBoxList25.DataSource = CType(Session(ClinicalVaccinesList2), List(Of Field))
            CheckBoxList25.DataTextField = TextField
            CheckBoxList25.DataValueField = ValueField

            CheckBoxList23.DataBind()
            CheckBoxList25.DataBind()

            For i As Integer = 0 To CheckBoxList23.Items.Count - 1
                If CType(Session(ClinicalVaccinesList), List(Of Field)).Item(i).Checked = True Then
                    CheckBoxList23.Items(i).Selected = True
                    CheckBoxList23.Items(i).Enabled = False
                    CheckBoxList25.Items(i).Selected = True
                    CheckBoxList25.Items(i).Enabled = False
                End If
            Next

            'Bind Tab Samples
            CheckBoxList5.DataSource = CType(Session(SampleList), List(Of Field))
            CheckBoxList5.DataTextField = TextField
            CheckBoxList5.DataValueField = ValueField

            CheckBoxList6.DataSource = CType(Session(SampleList2), List(Of Field))
            CheckBoxList6.DataTextField = TextField
            CheckBoxList6.DataValueField = ValueField

            CheckBoxList5.DataBind()
            CheckBoxList6.DataBind()

            For i As Integer = 0 To CheckBoxList5.Items.Count - 1
                If CType(Session(SampleList), List(Of Field)).Item(i).Checked = True Then
                    CheckBoxList5.Items(i).Selected = True
                    CheckBoxList5.Items(i).Enabled = False
                    CheckBoxList6.Items(i).Selected = True
                    CheckBoxList6.Items(i).Enabled = False
                End If
            Next

            'Bind Tab Case Investigation
            CheckBoxList9.DataSource = CType(Session(CaseList0), List(Of Field))
            CheckBoxList9.DataTextField = TextField
            CheckBoxList9.DataValueField = ValueField

            CheckBoxList10.DataSource = CType(Session(CaseList02), List(Of Field))
            CheckBoxList10.DataTextField = TextField
            CheckBoxList10.DataValueField = ValueField

            CheckBoxList9.DataBind()
            CheckBoxList10.DataBind()

            For i As Integer = 0 To CheckBoxList9.Items.Count - 1
                If CType(Session(CaseList0), List(Of Field)).Item(i).Checked = True Then
                    CheckBoxList9.Items(i).Selected = True
                    CheckBoxList9.Items(i).Enabled = False
                    CheckBoxList10.Items(i).Selected = True
                    CheckBoxList10.Items(i).Enabled = False
                ElseIf IsInExactAddressGroup(CType(Session(CaseList0), List(Of Field)).Item(i).Key) = True Then
                    CheckBoxList9.Items(i).Enabled = False
                    CheckBoxList10.Items(i).Enabled = False
                    'ElseIf IsInSchoolAddressGroup(itemListCase.OrderBy(Function(s) s.Index).ToList().Item(i).Key) = True Then
                    '    CheckBoxList9.Items(i).Enabled = False
                    '    CheckBoxList10.Items(i).Enabled = False
                End If
            Next

            For i As Integer = 0 To CheckBoxList9.Items.Count - 1
                If Session(CaseList)(i).Key = DiseaseReportDeduplicationCaseConstants.Region And CheckBoxList9.Items(i).Selected = True Then
                    If GroupAllChecked(i, EXACTADDRESSNUMBERFIELD, CheckBoxList9) = False Then
                        CType(Session(CaseList), List(Of Field))(i).Checked = False
                        CType(Session(CaseList2), List(Of Field))(i).Checked = False
                        CheckBoxList9.Items(i).Selected = False
                        CheckBoxList9.Items(i).Enabled = True
                        CheckBoxList10.Items(i).Selected = False
                        CheckBoxList10.Items(i).Enabled = True
                    End If
                    'ElseIf CType(Session(CaseList), List(Of Field))(i).Key = DiseaseReportDeduplicationCaseConstants.Region And CheckBoxList9.Items(i).Selected = True Then
                    '    If GroupAllChecked(i, SCHOOLADDRESSNUMBERFIELD, CheckBoxList9) = False Then
                    '        CType(Session(CaseList), List(Of Field))(i).Checked = False
                    '        CType(Session(CaseList2), List(Of Field))(i).Checked = False
                    '        CheckBoxList9.Items(i).Selected = False
                    '        CheckBoxList9.Items(i).Enabled = True
                    '        CheckBoxList10.Items(i).Selected = False
                    '        CheckBoxList10.Items(i).Enabled = True
                    '    End If
                End If
            Next

            'Bind Tab Final Outcome 
            CheckBoxList13.DataSource = CType(Session(OutcomeList), List(Of Field))
            CheckBoxList13.DataTextField = TextField
            CheckBoxList13.DataValueField = ValueField

            CheckBoxList14.DataSource = CType(Session(OutcomeList2), List(Of Field))
            CheckBoxList14.DataTextField = TextField
            CheckBoxList14.DataValueField = ValueField

            CheckBoxList13.DataBind()
            CheckBoxList14.DataBind()

            For i As Integer = 0 To CheckBoxList13.Items.Count - 1
                If CType(Session(OutcomeList), List(Of Field)).Item(i).Checked = True Then
                    CheckBoxList13.Items(i).Selected = True
                    CheckBoxList13.Items(i).Enabled = False
                    CheckBoxList14.Items(i).Selected = True
                    CheckBoxList14.Items(i).Enabled = False
                End If
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub CheckBoxList1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList1.SelectedIndexChanged
        Try
            CheckBoxListSelectedIndexChanged(CheckBoxList1, CheckBoxList2, SURVIVOR_LIST_NOTIFICATION)
            'Dim value As String = String.Empty

            'Dim result As String = Request.Form("__EVENTTARGET")

            'Dim checkedBox As String() = result.Split("$"c)
            'Dim index As Integer = Integer.Parse(checkedBox(checkedBox.Length - 1))

            'If CheckBoxList1.Items(index).Selected Then
            '    CheckBoxList2.Items(index).Selected = False
            '    value = CheckBoxList1.Items(index).Value
            'Else
            '    CheckBoxList2.Items(index).Selected = True
            '    value = CheckBoxList2.Items(index).Value
            'End If
            'If Session(SURVIVOR_LIST_NOTIFICATION) IsNot Nothing Then
            '    If CType(Session(SURVIVOR_LIST_NOTIFICATION), List(Of Field)).Count > 0 Then
            '        CType(Session(SURVIVOR_LIST_NOTIFICATION), List(Of Field))(index).Value = value
            '    End If
            'End If
            'ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub CheckBoxList2_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList2.SelectedIndexChanged
        Try
            CheckBoxListSelectedIndexChanged(CheckBoxList2, CheckBoxList1, SURVIVOR_LIST_NOTIFICATION)
            'Dim value As String = String.Empty

            'Dim result As String = Request.Form("__EVENTTARGET")

            'Dim checkedBox As String() = result.Split("$"c)
            'Dim index As Integer = Integer.Parse(checkedBox(checkedBox.Length - 1))

            'If CheckBoxList2.Items(index).Selected Then
            '    CheckBoxList1.Items(index).Selected = False
            '    value = CheckBoxList2.Items(index).Value
            'Else
            '    CheckBoxList1.Items(index).Selected = True
            '    value = CheckBoxList1.Items(index).Value
            'End If
            'If Session(SURVIVOR_LIST_NOTIFICATION) IsNot Nothing Then
            '    If CType(Session(SURVIVOR_LIST_NOTIFICATION), List(Of Field)).Count > 0 Then
            '        CType(Session(SURVIVOR_LIST_NOTIFICATION), List(Of Field))(index).Value = value
            '    End If
            'End If
            'ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="control"></param>
    ''' <param name="control2"></param>
    ''' <param name="strSurvivorTabName"></param>
    Private Sub CheckBoxListSelectedIndexChanged(control As CheckBoxList, control2 As CheckBoxList, ByVal strSurvivorTabName As String)
        Try
            Dim value As String = String.Empty
            Dim label As String = String.Empty

            Dim result As String = Request.Form("__EVENTTARGET")

            Dim checkedBox As String() = result.Split("$"c)
            Dim index As Integer = Integer.Parse(checkedBox(checkedBox.Length - 1))

            If control.Items(index).Selected Then
                control2.Items(index).Selected = False
                value = control.Items(index).Value
            Else
                control2.Items(index).Selected = True
                value = control2.Items(index).Value
            End If

            If Session(strSurvivorTabName) IsNot Nothing Then
                If CType(Session(strSurvivorTabName), List(Of Field)).Count > 0 Then
                    label = CType(Session(strSurvivorTabName), List(Of Field))(index).Label

                    If value Is Nothing Then
                        CType(Session(strSurvivorTabName), List(Of Field))(index).Label = label.Replace(CType(Session(strSurvivorTabName), List(Of Field))(index).Value, "")
                    ElseIf CType(Session(strSurvivorTabName), List(Of Field))(index).Value Is Nothing Then
                        CType(Session(strSurvivorTabName), List(Of Field))(index).Label = label.Replace("</font>", value + "</font>")
                    Else
                        CType(Session(strSurvivorTabName), List(Of Field))(index).Label = label.Replace(CType(Session(strSurvivorTabName), List(Of Field))(index).Value, value)
                    End If

                    CType(Session(strSurvivorTabName), List(Of Field))(index).Value = value
                End If
            End If
            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="control"></param>
    ''' <param name="control2"></param>
    ''' <param name="list"></param>
    ''' <param name="list2"></param>
    ''' <param name="strSurvivorTabName"></param>
    Private Sub CheckBoxListWithAddressSelectedIndexChanged(control As CheckBoxList, control2 As CheckBoxList, ByRef list As List(Of Field), ByRef list2 As List(Of Field), ByVal strSurvivorTabName As String)
        Try
            Dim value As String = String.Empty
            Dim label As String = String.Empty

            Dim result As String = Request.Form("__EVENTTARGET")

            Dim checkedBox As String() = result.Split("$"c)
            Dim index As Integer = Integer.Parse(checkedBox(checkedBox.Length - 1))

            If control.Items(index).Selected Then
                value = control.Items(index).Value
                If list(index).Key = DiseaseReportDeduplicationCaseConstants.Region Then
                    SelectAllAndUnSelectAll(index, EXACTADDRESSNUMBERFIELD, CheckBoxList5, CheckBoxList6, list, list2, CType(Session(strSurvivorTabName), List(Of Field)))
                    'ElseIf list(index).Key = DiseaseReportDeduplicationCaseConstants.Region Then
                    '    SelectAllAndUnSelectAll(index, EXACTADDRESSNUMBERFIELD, CheckBoxList5, CheckBoxList6, list, list2, CType(Session(strSurvivorTabName), List(Of Field)))
                Else
                    control2.Items(index).Selected = False
                    list(index).Checked = True
                    list2(index).Checked = False
                End If
            End If

            If Session(strSurvivorTabName) IsNot Nothing Then
                If CType(Session(strSurvivorTabName), List(Of Field)).Count > 0 Then
                    Label = CType(Session(strSurvivorTabName), List(Of Field))(index).Label

                    If value Is Nothing Then
                        CType(Session(strSurvivorTabName), List(Of Field))(index).Label = Label.Replace(CType(Session(strSurvivorTabName), List(Of Field))(index).Value, "")
                    ElseIf CType(Session(strSurvivorTabName), List(Of Field))(index).Value Is Nothing Then
                        CType(Session(strSurvivorTabName), List(Of Field))(index).Label = Label.Replace("</font>", value + "</font>")
                    Else
                        CType(Session(strSurvivorTabName), List(Of Field))(index).Label = Label.Replace(CType(Session(strSurvivorTabName), List(Of Field))(index).Value, value)
                    End If

                    CType(Session(strSurvivorTabName), List(Of Field))(index).Value = value
                End If
            End If

            'If control.Items(index).Selected Then
            '    control2.Items(index).Selected = False
            '    value = control.Items(index).Value
            'Else
            '    control2.Items(index).Selected = True
            '    value = control2.Items(index).Value
            'End If
            'If Session(strSurvivorTabName) IsNot Nothing Then
            '    If CType(Session(strSurvivorTabName), List(Of Field)).Count > 0 Then
            '        CType(Session(strSurvivorTabName), List(Of Field))(index).Value = value
            '    End If
            'End If
            ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Protected Sub CheckBoxList3_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList3.SelectedIndexChanged
        CheckBoxListSelectedIndexChanged(CheckBoxList3, CheckBoxList4, SURVIVOR_LIST_CLINICAL)
    End Sub

    Protected Sub CheckBoxList4_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList4.SelectedIndexChanged
        CheckBoxListSelectedIndexChanged(CheckBoxList4, CheckBoxList3, SURVIVOR_LIST_CLINICAL)
    End Sub

    Protected Sub CheckBoxList5_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList5.SelectedIndexChanged
        CheckBoxListSelectedIndexChanged(CheckBoxList5, CheckBoxList6, SURVIVOR_LIST_SAMPLE)
    End Sub

    Protected Sub CheckBoxList6_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList6.SelectedIndexChanged
        CheckBoxListSelectedIndexChanged(CheckBoxList6, CheckBoxList5, SURVIVOR_LIST_SAMPLE)
    End Sub

    Protected Sub CheckBoxList9_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList9.SelectedIndexChanged
        CheckBoxListWithAddressSelectedIndexChanged(CheckBoxList9, CheckBoxList10, CType(Session(CaseList), List(Of Field)), CType(Session(CaseList2), List(Of Field)), SURVIVOR_LIST_CASE)
    End Sub

    Protected Sub CheckBoxList10_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList10.SelectedIndexChanged
        CheckBoxListWithAddressSelectedIndexChanged(CheckBoxList10, CheckBoxList9, CType(Session(CaseList), List(Of Field)), CType(Session(CaseList2), List(Of Field)), SURVIVOR_LIST_CASE)
    End Sub

    Protected Sub CheckBoxList13_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList13.SelectedIndexChanged
        CheckBoxListSelectedIndexChanged(CheckBoxList13, CheckBoxList14, SURVIVOR_LIST_OUTCOME)
    End Sub

    Protected Sub CheckBoxList14_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList14.SelectedIndexChanged
        CheckBoxListSelectedIndexChanged(CheckBoxList14, CheckBoxList13, SURVIVOR_LIST_OUTCOME)
    End Sub

    Protected Sub CheckBoxList20_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList20.SelectedIndexChanged
        CheckBoxListSelectedIndexChanged(CheckBoxList20, CheckBoxList21, SURVIVOR_LIST_FACILITY)
    End Sub

    Protected Sub CheckBoxList22_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList22.SelectedIndexChanged
        CheckBoxListSelectedIndexChanged(CheckBoxList22, CheckBoxList24, SURVIVOR_LIST_ANTIBIOTICS)
    End Sub

    Protected Sub CheckBoxList23_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList23.SelectedIndexChanged
        CheckBoxListSelectedIndexChanged(CheckBoxList23, CheckBoxList25, SURVIVOR_LIST_VACCINES)
    End Sub

    Protected Sub CheckBoxList21_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList21.SelectedIndexChanged
        CheckBoxListSelectedIndexChanged(CheckBoxList21, CheckBoxList20, SURVIVOR_LIST_FACILITY)
    End Sub

    Protected Sub CheckBoxList24_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList24.SelectedIndexChanged
        CheckBoxListSelectedIndexChanged(CheckBoxList24, CheckBoxList22, SURVIVOR_LIST_ANTIBIOTICS)
    End Sub

    Protected Sub CheckBoxList25_SelectedIndexChanged(sender As Object, e As EventArgs) Handles CheckBoxList25.SelectedIndexChanged
        CheckBoxListSelectedIndexChanged(CheckBoxList25, CheckBoxList23, SURVIVOR_LIST_VACCINES)
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="index"></param>
    ''' <param name="length"></param>
    ''' <param name="control"></param>
    ''' <param name="control2"></param>
    ''' <param name="list"></param>
    ''' <param name="list2"></param>
    ''' <param name="listSurvivor"></param>
    Private Sub SelectAllAndUnSelectAll(ByVal index As Integer, ByVal length As Integer, control As CheckBoxList, control2 As CheckBoxList, ByRef list As List(Of Field), ByRef list2 As List(Of Field), ByRef listSurvivor As List(Of Field))
        Try
            Dim value As String = String.Empty
            Dim label As String = String.Empty

            For i As Integer = index To index + length - 1
                list(i).Checked = True
                list2(i).Checked = False
                value = control.Items(i).Value
                If listSurvivor IsNot Nothing Then
                    If listSurvivor.Count > 0 Then
                        listSurvivor(i).Checked = True
                        label = listSurvivor(i).Label
                        If value Is Nothing Then
                            listSurvivor(i).Label = label.Replace(listSurvivor(i).Value, "")
                        ElseIf listSurvivor(i).Value Is Nothing Then
                            listSurvivor(i).Label = label.Replace("</font>", value + "</font>")
                        ElseIf listSurvivor(i).Value = value Then
                            listSurvivor(i).Label = label
                        ElseIf listSurvivor(i).Value = "" Then
                            listSurvivor(i).Label = label.Replace("</font>", value + "</font>")
                        Else
                            listSurvivor(i).Label = label.Replace(listSurvivor(i).Value, value)
                        End If
                        listSurvivor(i).Value = value
                    End If
                End If
            Next

            BindCheckBoxList(control, list)
            BindCheckBoxList(control2, list2)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="control"></param>
    ''' <param name="list"></param>
    Private Sub BindCheckBoxList(control As CheckBoxList, ByRef list As List(Of Field))
        Try
            control.Items.Clear()

            control.DataSource = list
            control.DataTextField = TextField
            control.DataValueField = ValueField

            control.DataBind()

            For i As Integer = 0 To control.Items.Count - 1
                If list(i).Checked = True Then
                    If IsRegion(list(i).Key) = True Then
                        control.Items(i).Selected = True
                    Else
                        control.Items(i).Selected = True
                        control.Items(i).Enabled = False
                    End If
                ElseIf IsInExactAddressGroup(list(i).Key) = True Then
                    control.Items(i).Enabled = False
                    'ElseIf IsInRelativeAddressGroup(list(i).Key) = True Then
                    '    control.Items(i).Enabled = False
                End If
            Next
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub


    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="strName"></param>
    Private Function IsRegion(ByVal strName As String) As Boolean
        Select Case strName
            Case DiseaseReportDeduplicationCaseConstants.Region
                Return True
            Case DiseaseReportDeduplicationCaseConstants.Region
                Return True
        End Select
        Return False
    End Function

    Public Structure DeduplicationTabConstants
        Public Const Notification = "Notification"
        Public Const Clinical = "ClinicalInfo"
        Public Const Sample = "Samples"
        Public Const TestResults = "TestResults"
        Public Const CaseInvestigation = "CaseInvestigation"
        Public Const ContactList = "ContactList"
        Public Const Outcome = "FinalOutcome"
    End Structure

    Protected Sub btnMerge_Click(sender As Object, e As EventArgs) Handles btnMerge.Click
        Try
            upDeduplication.Update()
            'divDeduplicationDetails.Visible = False
            divDeduplicationList.Visible = False
            divSearchCriteria.Visible = False
            divSearchResults.Visible = False
            'divSurvivorReview.Visible = True

            If rdbSurvivor.Checked = False And rdbSurvivor2.Checked = False Then
                hdfCurrentTab.Value = DeduplicationTabConstants.Notification
                ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
            Else
                If AllFieldValuePairsSelected() = True Then
                    CheckBoxList15.DataSource = CType(Session(SURVIVOR_LIST_NOTIFICATION), List(Of Field))
                    CheckBoxList15.DataTextField = TextField
                    CheckBoxList15.DataValueField = ValueField

                    CheckBoxList16.DataSource = CType(Session(SURVIVOR_LIST_CLINICAL), List(Of Field))
                    CheckBoxList16.DataTextField = TextField
                    CheckBoxList16.DataValueField = ValueField

                    CheckBoxList17.DataSource = CType(Session(SURVIVOR_LIST_SAMPLE), List(Of Field))
                    CheckBoxList17.DataTextField = TextField
                    CheckBoxList17.DataValueField = ValueField

                    CheckBoxList18.DataSource = CType(Session(SURVIVOR_LIST_CASE), List(Of Field))
                    CheckBoxList18.DataTextField = TextField
                    CheckBoxList18.DataValueField = ValueField

                    CheckBoxList19.DataSource = CType(Session(SURVIVOR_LIST_OUTCOME), List(Of Field))
                    CheckBoxList19.DataTextField = TextField
                    CheckBoxList19.DataValueField = ValueField

                    CheckBoxList15.DataBind()
                    CheckBoxList16.DataBind()
                    CheckBoxList17.DataBind()
                    CheckBoxList18.DataBind()
                    CheckBoxList19.DataBind()

                    For i As Integer = 0 To CheckBoxList15.Items.Count - 1
                        CheckBoxList15.Items(i).Selected = True
                        CheckBoxList15.Items(i).Enabled = False
                    Next
                    For i As Integer = 0 To CheckBoxList16.Items.Count - 1
                        CheckBoxList16.Items(i).Selected = True
                        CheckBoxList16.Items(i).Enabled = False
                    Next
                    For i As Integer = 0 To CheckBoxList17.Items.Count - 1
                        CheckBoxList17.Items(i).Selected = True
                        CheckBoxList17.Items(i).Enabled = False
                    Next
                    For i As Integer = 0 To CheckBoxList18.Items.Count - 1
                        CheckBoxList18.Items(i).Selected = True
                        CheckBoxList18.Items(i).Enabled = False
                    Next
                    For i As Integer = 0 To CheckBoxList19.Items.Count - 1
                        CheckBoxList19.Items(i).Selected = True
                        CheckBoxList19.Items(i).Enabled = False
                    Next

                    divDeduplicationDetails.Visible = False
                    divSurvivorReview.Visible = True
                Else
                    ShowWarningMessage(messageType:=MessageType.FieldValuePairFoundNoSelection, isConfirm:=False)
                    ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub

    Private Function AllFieldValuePairsSelected() As Boolean
        Try
            Dim sScript As String

            For i As Integer = 0 To CheckBoxList1.Items.Count - 1
                If CheckBoxList1.Items(i).Selected = False And CheckBoxList2.Items(i).Selected = False Then
                    hdfCurrentTab.Value = DeduplicationTabConstants.Notification
                    btnNextSection.Visible = True
                    sScript = "SetFocus('" + CheckBoxList1.ClientID + "_" + i.ToString() + "');"
                    ScriptManager.RegisterClientScriptBlock(Me, Page.GetType(), "focusScript", sScript, True)
                    Return False
                End If
            Next

            For i As Integer = 0 To CheckBoxList3.Items.Count - 1
                If CheckBoxList3.Items(i).Selected = False And CheckBoxList4.Items(i).Selected = False Then
                    hdfCurrentTab.Value = DeduplicationTabConstants.Clinical
                    btnNextSection.Visible = True
                    sScript = "SetFocus('" + CheckBoxList3.ClientID + "_" + i.ToString() + "');"
                    ScriptManager.RegisterClientScriptBlock(Me, Page.GetType(), "focusScript", sScript, True)
                    Return False
                End If
            Next

            For i As Integer = 0 To CheckBoxList5.Items.Count - 1
                If CheckBoxList5.Items(i).Selected = False And CheckBoxList6.Items(i).Selected = False Then
                    hdfCurrentTab.Value = DeduplicationTabConstants.Sample
                    btnNextSection.Visible = False
                    sScript = "SetFocus('" + CheckBoxList5.ClientID + "_" + i.ToString() + "');"
                    ScriptManager.RegisterClientScriptBlock(Me, Page.GetType(), "focusScript", sScript, True)
                    Return False
                End If
            Next

            For i As Integer = 0 To CheckBoxList9.Items.Count - 1
                If CheckBoxList9.Items(i).Selected = False And CheckBoxList10.Items(i).Selected = False Then
                    hdfCurrentTab.Value = DeduplicationTabConstants.CaseInvestigation
                    btnNextSection.Visible = True
                    sScript = "SetFocus('" + CheckBoxList9.ClientID + "_" + i.ToString() + "');"
                    ScriptManager.RegisterClientScriptBlock(Me, Page.GetType(), "focusScript", sScript, True)
                    Return False
                End If
            Next

            For i As Integer = 0 To CheckBoxList13.Items.Count - 1
                If CheckBoxList13.Items(i).Selected = False And CheckBoxList14.Items(i).Selected = False Then
                    hdfCurrentTab.Value = DeduplicationTabConstants.Outcome
                    btnNextSection.Visible = False
                    sScript = "SetFocus('" + CheckBoxList13.ClientID + "_" + i.ToString() + "');"
                    ScriptManager.RegisterClientScriptBlock(Me, Page.GetType(), "focusScript", sScript, True)
                    Return False
                End If
            Next

            For i As Integer = 0 To CheckBoxList20.Items.Count - 1
                If CheckBoxList20.Items(i).Selected = False And CheckBoxList21.Items(i).Selected = False Then
                    hdfCurrentTab.Value = DeduplicationTabConstants.Outcome
                    btnNextSection.Visible = False
                    sScript = "SetFocus('" + CheckBoxList20.ClientID + "_" + i.ToString() + "');"
                    ScriptManager.RegisterClientScriptBlock(Me, Page.GetType(), "focusScript", sScript, True)
                    Return False
                End If
            Next

            For i As Integer = 0 To CheckBoxList22.Items.Count - 1
                If CheckBoxList22.Items(i).Selected = False And CheckBoxList24.Items(i).Selected = False Then
                    hdfCurrentTab.Value = DeduplicationTabConstants.Outcome
                    btnNextSection.Visible = False
                    sScript = "SetFocus('" + CheckBoxList22.ClientID + "_" + i.ToString() + "');"
                    ScriptManager.RegisterClientScriptBlock(Me, Page.GetType(), "focusScript", sScript, True)
                    Return False
                End If
            Next

            For i As Integer = 0 To CheckBoxList23.Items.Count - 1
                If CheckBoxList23.Items(i).Selected = False And CheckBoxList25.Items(i).Selected = False Then
                    hdfCurrentTab.Value = DeduplicationTabConstants.Outcome
                    btnNextSection.Visible = False
                    sScript = "SetFocus('" + CheckBoxList23.ClientID + "_" + i.ToString() + "');"
                    ScriptManager.RegisterClientScriptBlock(Me, Page.GetType(), "focusScript", sScript, True)
                    Return False
                End If
            Next

            Return True
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            Return False
        End Try
    End Function

    Protected Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        ShowWarningMessage(messageType:=MessageType.CancelFormConfirm, isConfirm:=True)
    End Sub

    Protected Sub btnCancelMerge_Click(sender As Object, e As EventArgs) Handles btnCancelSubmit.Click
        ShowWarningMessage(messageType:=MessageType.CancelFormConfirm, isConfirm:=True)
    End Sub

    Protected Sub btnNextSection_Click(sender As Object, e As EventArgs) Handles btnNextSection.Click
        upDeduplication.Update()

        Select Case hdfCurrentTab.Value
            Case DeduplicationTabConstants.Notification
                hdfCurrentTab.Value = DeduplicationTabConstants.Clinical
                btnNextSection.Visible = True
                'LoadFlexFormSymptoms()
            Case DeduplicationTabConstants.Clinical
                hdfCurrentTab.Value = DeduplicationTabConstants.Sample
                btnNextSection.Visible = True
            Case DeduplicationTabConstants.Sample
                hdfCurrentTab.Value = DeduplicationTabConstants.TestResults
                btnNextSection.Visible = True
            Case DeduplicationTabConstants.TestResults
                hdfCurrentTab.Value = DeduplicationTabConstants.CaseInvestigation
                btnNextSection.Visible = True
            Case DeduplicationTabConstants.CaseInvestigation
                hdfCurrentTab.Value = DeduplicationTabConstants.ContactList
                btnNextSection.Visible = True
                'LoadFlexFormRiskFactors()
            Case DeduplicationTabConstants.ContactList
                hdfCurrentTab.Value = DeduplicationTabConstants.Outcome
                btnNextSection.Visible = False
            Case DeduplicationTabConstants.Outcome
        End Select

        ScriptManager.RegisterStartupScript(Me, [GetType](), PAGE_KEY, SET_ACTIVE_TAB_ITEM_SCRIPT, True)
    End Sub

    Protected Sub btnCancelSubmit_Click(sender As Object, e As EventArgs) Handles btnCancelSubmit.Click
        ShowWarningMessage(messageType:=MessageType.CancelFormConfirm, isConfirm:=True)
    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs) Handles btnSubmit.Click
        ShowWarningMessage(messageType:=MessageType.ConfirmMerge, isConfirm:=True)
    End Sub

    Private Shared Function IsNullableType(type As Type) As Boolean
        Return type.IsGenericType AndAlso type.GetGenericTypeDefinition().Equals(GetType(Nullable(Of )))
    End Function

    Public Shared Sub SetValue(inputObject As Object, propertyName As String, propertyVal As Object)
        Try
            'find out the type
            Dim type As Type = inputObject.GetType()

            'get the property information based on the type
            Dim propertyInfo As System.Reflection.PropertyInfo = type.GetProperty(propertyName)

            'find the property type
            Dim propertyType As Type = propertyInfo.PropertyType

            'Convert.ChangeType does not handle conversion to nullable types
            'if the property type is nullable, we need to get the underlying type of the property
            Dim targetType = If(IsNullableType(propertyType), Nullable.GetUnderlyingType(propertyType), propertyType)

            'Returns an System.Object with the specified System.Type and whose value is
            'equivalent to the specified object.
            propertyVal = Convert.ChangeType(propertyVal, targetType)

            'Set the value of the property
            propertyInfo.SetValue(inputObject, propertyVal, Nothing)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
        Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub


    Private Sub SaveSurvivorRecord()
        Try
            Dim parameters = New HumanSetParam()
            Dim type As Type = parameters.GetType()
            Dim props() As PropertyInfo = type.GetProperties()
            Dim Index = -1

            For i = 0 To props.Count - 1
                If IsInTabNotification(props(i).Name) = True Then
                    Index = keyDict.Item(props(i).Name)
                    Dim safeValue = CType(Session(SURVIVOR_LIST_NOTIFICATION), List(Of Field))(Index).Value
                    If safeValue IsNot Nothing Then
                        SetValue(parameters, props(i).Name, safeValue)
                    Else
                        props(i).SetValue(parameters, safeValue)
                    End If
                ElseIf IsInTabClinical(props(i).Name) = True Then
                    Index = keyDict2.Item(props(i).Name)
                    Dim safeValue = CType(Session(SURVIVOR_LIST_CLINICAL), List(Of Field))(Index).Value
                    If safeValue IsNot Nothing Then
                        SetValue(parameters, props(i).Name, safeValue)
                    Else
                        props(i).SetValue(parameters, safeValue)
                    End If
                ElseIf IsInTabSample(props(i).Name) = True Then
                    Index = keyDict3.Item(props(i).Name)
                    Dim safeValue = CType(Session(SURVIVOR_LIST_SAMPLE), List(Of Field))(Index).Value
                    If safeValue IsNot Nothing Then
                        SetValue(parameters, props(i).Name, safeValue)
                    Else
                        props(i).SetValue(parameters, safeValue)
                    End If
                ElseIf IsInTabCase(props(i).Name) = True Then
                    Index = keyDict2.Item(props(i).Name)
                    Dim safeValue = CType(Session(SURVIVOR_LIST_CASE), List(Of Field))(Index).Value
                    If safeValue IsNot Nothing Then
                        SetValue(parameters, props(i).Name, safeValue)
                    Else
                        props(i).SetValue(parameters, safeValue)
                    End If
                ElseIf IsInTabOutcome(props(i).Name) = True Then
                    Index = keyDict3.Item(props(i).Name)
                    Dim safeValue = CType(Session(SURVIVOR_LIST_OUTCOME), List(Of Field))(Index).Value
                    If safeValue IsNot Nothing Then
                        SetValue(parameters, props(i).Name, safeValue)
                    Else
                        props(i).SetValue(parameters, safeValue)
                    End If
                End If

            Next

            If HumanAPIService Is Nothing Then
                HumanAPIService = New HumanServiceClient()
            End If
            Dim result As List(Of HumHumanMasterSetModel) = HumanAPIService.SaveHumanMasterAsync(parameters).Result

            If result.Count > 0 Then
                If result.FirstOrDefault().ReturnCode = 0 Then 'Success
                    ShowSuccessMessage(messageType:=MessageType.SaveSuccess, message:=GetLocalResourceObject("Lbl_Save_Success").ToString())
                Else 'Error
                End If
            Else
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try
    End Sub



#End Region
End Class