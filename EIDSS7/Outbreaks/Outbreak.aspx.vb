Imports System.Reflection
Imports EIDSS.EIDSS
Imports EIDSSControlLibrary
Imports OpenEIDSS.Domain
Imports EIDSS.Client.API_Clients
Imports OpenEIDSS.Domain.Parameter_Contracts
Imports System.Windows.Forms
Imports log4net


Public Class Outbreak
    Inherits BaseEidssPage

    Dim oCommon As clsCommon = New clsCommon()
    Private Shared Log As log4net.ILog
    Private CrossCuttingAPIService As CrossCuttingServiceClient
    Private OutbreakAPIService As OutbreakServiceClient

    Private Enum ConversionType

        ConvertLong = 0
        ConvertString = 1
        ConvertDate = 2
        ConvertInt = 3
        ConvertDouble = 4

    End Enum

    Private Enum PersonFarmSearchMode

        CaseCreation = 0
        CaseManualAddContact = 1

    End Enum

    Private Enum SearchMode

        None = 0
        QuickSearch = 1
        AdvancedSearch = 2
        TodaysFollowUps = 3

    End Enum

    Private Enum DiseaseReportType

        None = 0
        Human = 1
        Veterionary = 2

    End Enum

    Private Enum ContactListing

        ShowAll = 0
        FollowUpOnly = 1

    End Enum

    Private Enum ObjectTypes
        TextBox = 0
        CheckBox = 1
        RadioButton = 2
        DropDownList = 3
        CalendarControl = 4
    End Enum

    Protected Today As String = DateTime.Today.ToString()

    Private Const PAGINATION_SET_NUMBER As String = "gvPeople_PaginationSet"

    Private Const SectionSearchOutbreak As String = "SearchOutbreak"
    Private Const SectionSearchHuman As String = "SearchHuman"
    Private Const SectionSearchVeterinary As String = "SearchVeterinary"
    Private Const SectionOutbreakManagement = "OutbreakManagement"
    Private Const SectionSearchOutbreakManagement = "SearchOutbreakManagement"
    Private Const SectionCreateOutbreak = "CreateOutbreak"
    Private Const SectionOutbreakSummary As String = "OutbreakSummaryAndQuestions"
    Private Const SectionVeterinarySearch As String = "outbreakVeterinaryDiseaseSearch"
    Private Const SectionHumanSearch As String = "outbreakHumanDiseaseSearch"
    Private Const SectionPersonSearch As String = "outbreakPersonSearch"
    Private Const SectionOutbreakNotes As String = "OutbreakNotes"
    Private Const SectionOutbreakQuestionnaire As String = "OutbreakQuestionnaire"
    Private Const SectionOutbreakCaseCreation As String = "OutbreakCaseCreation"
    Private Const SectionOutbreakCaseEdit As String = "OutbreakCaseEdit"
    Private Const SectionHumanContactSearch As String = "outbreakHumanContactSearch"
    Private Const SectionVeterinaryContactSearch As String = "outbreakVeterinaryContactSearch"

    Private Const CREATE_OUTBREAK_PREFIX As String = "_OBM"
    Private Const OUTBREAK_SP As String = "Outbreak"

    Private Const OUTBREAK_ID As String = "OutbreakId"

    Private Const OUTBREAK_SESSION_SET_SP As String = "OutbreakSessionSet"
    Private Const OUTBREAK_SESSION_GETLIST_SP As String = "OutbreakSessionGetList"
    Private Const OUTBREAK_SESSION_GETDETAIL_SP As String = "OutbreakSessionGetDetail"
    Private Const OUTBREAK_SESSION_DELETE_SP As String = "OutbreakSessionDelete"

    Private Const OUTBREAK_CASE_SET_SP As String = "OutbreakCaseSet"
    Private Const OUTBREAK_CASE_GETLIST_SP As String = "OutbreakCaseGetList"
    Private Const OUTBREAK_CASE_GETDETAIL_SP As String = "OutbreakCaseGetDetail"
    Private Const OUTBREAK_CASE_DELETE_SP As String = "OutbreakCaseDelete"

    Private Const OUTBREAK_SESSION_NOTE_SET_SP As String = "OutbreakSessionNoteSet"
    Private Const OUTBREAK_SESSION_NOTE_GETLIST_SP As String = "OutbreakSessionNoteGetList"
    Private Const OUTBREAK_SESSION_NOTE_GETDETAIL_SP As String = "OutbreakSessionNoteGetDetail"
    Private Const OUTBREAK_SESSION_NOTE_DELETE_SP As String = "OutbreakSessionNoteDelete"

    Private Const OUTBREAKS_DATASET As String = "dsOutbreaks"
    Private Const OUTBREAK_CASES_DATASET As String = "dsOutbreakCases"
    Private Const OUTBREAK_SESSION_NOTES_DATASET As String = "dsOutbreakSessionNotes"
    Private Const OUTBREAK_DATASET As String = "dsOutbreak"
    Private Const OUTBREAK_NOTE_DATASET As String = "dsOutbreakNote"

    Private Const OUTBREAKS_PAGINATION_SET_NUMBER As String = "gvOutbreaks_PaginationSet"

    Private Const OUTBREAK_HUMAN_ID As Int32 = 10514001
    Private Const OUTBREAK_AVIAN_ID As Int32 = 10514002
    Private Const OUTBREAK_LIVESTOCK_ID As Int32 = 10514003
    Private Const OUTBREAK_VECTOR_ID As Int32 = 105140034
    Private Const OUTBREAK_STATUS_CLOSED As Int64 = 10063502
    Private Const OUTBREAK_NOT_AN_OUTBREAK As Int64 = 55459240000000

    Private Const YES As Int32 = 10100001
    Private Const NO As Int32 = 10100002
    Private Const UNKNOWN As Int32 = 10100003

    Private Const CALLER_INFO As String = "CallerInfo"
    Private Const CALLER As String = "Caller"
    Private Const CALLER_KEY As String = "CallerKey"
    Private Const RETURN_KEY As String = "ReturnKey"
    Private Const SEARCH_FARM_TYPE As String = "SearchFarmType"

    Private Const HIDE_MODAL_SHOW_MODAL = "hideModalShowModal('{0}',{1},'{2}','{3}');"
    Private Const SHOW_FORM As String = "showModal({0},'{1}','{2}');"
    Private Const HIDE_FORM As String = "hideModal('{0}','{1}');"
    Private Const SHOW_SCREEN As String = "showScreen('{0}');"
    Private Const CLOSE_MODAL As String = "closeModal();"
    Private Const SHOW_INVALID_EXTENSIONS As String = "showInvalidExtensions();"
    Private Const RECALL_SUMMARY_TABLE As String = "recallSummaryTab();"
    Private Const INITIALIZE_SIDBAR As String = "initalizeSidebar()"

    Private Const VET_HERDS As String = "VetHerdsList"
    Private Const VET_SPECIES As String = "VetSpeciesList"
    Private Const VET_VACCINATIONS As String = "VetVaccinationsList"
    Private Const VET_ANIMAL_INVESTIGATIONS As String = "VetAnimalInvestigationsList"
    Private Const HUM_VET_CONTACTS As String = "VetHumanCaseContactList"
    Private Const VET_SAMPLES As String = "VetSamplesList"
    Private Const VET_PENSIDE_TESTS As String = "VetPensideTestsList"
    Private Const VET_LAB_TESTS As String = "VetLabTests"
    Private Const VET_LAB_INTERPRETATION As String = "VetLabInterpretations"
    Private Const VET_REPORTS As String = "VetReports"
    Private Const VET_CLINICAL_INFORMATION As String = "VetClinicalInformation"
    Private Const VET_CASE_MONITORING As String = "VetCaseMonitoring"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If (Log Is Nothing) Then
            Log = LogManager.GetLogger("Outbreak")
        End If

        Log.Info("Page_Load Is called")

        If CrossCuttingAPIService Is Nothing Then
            CrossCuttingAPIService = New CrossCuttingServiceClient()
        End If

        If OutbreakAPIService Is Nothing Then
            OutbreakAPIService = New OutbreakServiceClient(Page.Session.SessionID)
        End If

        Log.Info("Page_Load Postback " & IsPostBack.ToString())

        If (Not IsPostBack) Then

            Try
                Log.Info("Page_Load Initializatitons.")

                ViewState("SearchControl") = False
                ViewState("CreateOutbreakListCache") = True
                ViewState("CreateNoteListCache") = True
                ViewState("CreateCaseListCache") = True

                ToggleVisibility(SectionOutbreakManagement)
                FillDropDowns()
                FillRadioButtonLists()
                SetFieldDefaults()

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try
        Else

        End If

        Page.Form.Attributes.Add("enctype", "multipart/form-data")

        Log.Info("Exiting  Page_Load")

    End Sub


    Private Sub FillDropDowns()

        Log.Info("FillDropDowns() Is called.")

        Try
            FillBaseReferenceDropDownList(ddlOutbreakTypeId, BaseReferenceConstants.OutbreakType, HACodeList.NoneHACode, True)
            FillBaseReferenceDropDownList(ddlidfsOutbreakStatus, BaseReferenceConstants.OutbreakStatus, HACodeList.AllHACode, True)
            FillBaseReferenceDropDownList(sfddlOutbreakTypeID, BaseReferenceConstants.OutbreakType, HACodeList.NoneHACode, True)
            FillBaseReferenceDropDownList(sfddlidfsOutbreakStatus, BaseReferenceConstants.OutbreakStatus, HACodeList.AllHACode, True)
            FillBaseReferenceDropDownList(drdlUpdatePriorityID, BaseReferenceConstants.OutbreakUpdatePriority, HACodeList.OutbreakPriorityHACode, True)

            FillBaseReferenceDropDownList(ddlCaseStatus, BaseReferenceConstants.OutbreakCaseStatus, HACodeList.OutbreakPriorityHACode, True)
            FillBaseReferenceDropDownList(ddlCaseClassification, BaseReferenceConstants.CaseClassification, HACodeList.OutbreakPriorityHACode, True)
            FillBaseReferenceDropDownList(ddlSampleType, BaseReferenceConstants.SampleType, HACodeList.OutbreakPriorityHACode, True)

            'Human Disease Report
            FillBaseReferenceDropDownList(ddlContactRelationshipType, BaseReferenceConstants.PatientContactType, HACodeList.AllHACode, True)
            FillBaseReferenceDropDownList(ddlContactStatus, BaseReferenceConstants.OutbreakContactStatus, HACodeList.AllHACode, True)
            FillBaseReferenceDropDownList(ddlHospitalName, BaseReferenceConstants.OrganizationName, HACodeList.AllHACode, True)
            FillBaseReferenceDropDownList(sfddlSearchDiagnosesGroup, BaseReferenceConstants.DiagnosesGroups, HACodeList.AllHACode, True)

            'Veterinary Disease Report
            FillBaseReferenceDropDownList(ddlVCISex, BaseReferenceConstants.AnimalSex, HACodeList.AllHACode, True)
            FillBaseReferenceDropDownList(ddlVCIAge, BaseReferenceConstants.AnimalAge, HACodeList.AllHACode, True)
            FillBaseReferenceDropDownList(ddlVCIStatus, BaseReferenceConstants.AnimalBirdStatus, HACodeList.AllHACode, True)
            FillBaseReferenceDropDownList(ddlidfVetCaseStatus, BaseReferenceConstants.OutbreakCaseStatus, HACodeList.OutbreakPriorityHACode, True)
            FillBaseReferenceDropDownList(ddlidfVetCaseClassification, BaseReferenceConstants.CaseClassification, HACodeList.OutbreakPriorityHACode, True)
            FillBaseReferenceDropDownList(ddlVetVaccinationDiseaseName, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode, True)
            FillBaseReferenceDropDownList(ddlVetvaccinationType, BaseReferenceConstants.VaccinationType, HACodeList.AllHACode, True)
            FillBaseReferenceDropDownList(ddlVetVaccinationRoute, BaseReferenceConstants.VaccinationRouteList, HACodeList.AllHACode, True)
            FillBaseReferenceDropDownList(ddlVetContactRelationshipType, BaseReferenceConstants.PatientContactType, HACodeList.AllHACode, True)
            FillBaseReferenceDropDownList(ddlVetContactStatus, BaseReferenceConstants.OutbreakContactStatus, HACodeList.AllHACode, True)

            FillBaseReferenceDropDownList(ddlVetSampleBirdStatusTypeID, BaseReferenceConstants.AnimalBirdStatus, HACodeList.AvianHACode, True)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

        Log.Info("Exiting FillDropDowns().")

    End Sub

    Private Sub FillRadioButtonLists()

        Log.Info("FillRadioButtonLists() Is called.")

        Try

            FillRadioButtonList(rblHospitalization, GetType(clsBaseReference), {"@ReferenceTypeName:" & BaseReferenceConstants.YesNoValueList, "@intHACode:" & HACodeList.NoneHACode}, BaseReferenceConstants.idfsBaseReference, BaseReferenceConstants.Name, "19000100", Nothing)
            FillRadioButtonList(rblAntibioticAntiviralTherapyAdministered, GetType(clsBaseReference), {"@ReferenceTypeName:" & BaseReferenceConstants.YesNoValueList, "@intHACode:" & HACodeList.NoneHACode}, BaseReferenceConstants.idfsBaseReference, BaseReferenceConstants.Name, "19000100", Nothing)
            FillRadioButtonList(rblWasSpecificVaccinationAdministered, GetType(clsBaseReference), {"@ReferenceTypeName:" & BaseReferenceConstants.YesNoValueList, "@intHACode:" & HACodeList.NoneHACode}, BaseReferenceConstants.idfsBaseReference, BaseReferenceConstants.Name, "19000100", Nothing)
            FillRadioButtonList(rblSamplesCollected, GetType(clsBaseReference), {"@ReferenceTypeName:" & BaseReferenceConstants.YesNoValueList, "@intHACode:" & HACodeList.NoneHACode}, BaseReferenceConstants.idfsBaseReference, BaseReferenceConstants.Name, "19000100", Nothing)

            FillRadioButtonList(rblContactType, GetType(clsBaseReference), {"@ReferenceTypeName:" & BaseReferenceConstants.OutbreakContactType, "@intHACode:" & HACodeList.NoneHACode}, BaseReferenceConstants.idfsBaseReference, BaseReferenceConstants.Name, "19000516", Nothing)
            FillRadioButtonList(rblidfsCaseType, GetType(clsBaseReference), {"@ReferenceTypeName:" & BaseReferenceConstants.CaseType, "@intHACode:" & HACodeList.LiveStockAndAvian}, BaseReferenceConstants.idfsBaseReference, BaseReferenceConstants.Name, "19000012", Nothing)

            FillRadioButtonList(rblVCISigns, GetType(clsBaseReference), {"@ReferenceTypeName:" & BaseReferenceConstants.YesNoValueList, "@intHACode:" & HACodeList.NoneHACode}, BaseReferenceConstants.idfsBaseReference, BaseReferenceConstants.Name, "19000100", Nothing)
            FillRadioButtonList(rblVetContactType, GetType(clsBaseReference), {"@ReferenceTypeName:" & BaseReferenceConstants.OutbreakContactType, "@intHACode:" & HACodeList.NoneHACode}, BaseReferenceConstants.idfsBaseReference, BaseReferenceConstants.Name, "19000516", Nothing)

            FillRadioButtonList(rblVetLabTestsInterpretations, GetType(clsBaseReference), {"@ReferenceTypeName:" & BaseReferenceConstants.YesNoValueList, "@intHACode:" & HACodeList.NoneHACode}, BaseReferenceConstants.idfsBaseReference, BaseReferenceConstants.Name, "19000100", Nothing)

        Catch ex As Exception
            Dim str As String = ""
        End Try

        Log.Info("Exiting FillRadioButtonLists().")

    End Sub

    Private Sub SetFilteredDisaseList() Handles ddlOutbreakTypeId.SelectedIndexChanged, sfddlOutbreakTypeID.SelectedIndexChanged

        Log.Info("SetFilteredDisaseList() Is called.")

        Try
            Select Case ddlOutbreakTypeId.SelectedItem.ToString()
                Case "Human"
                    BaseReferenceLookUp(ddlidfsDiagnosisOrDiagnosisGroup, BaseReferenceConstants.Diagnosis, HACodeList.HumanHACode, True)
                    ffOutbreakCase.FormType = 10034010
                    ffOutbreakCase.LegendHeader = "Outbreak Human Case"
                    ffOutbreakCase.DiagnosisID = 784580000000

                    'TODO: Doug will research with Vilma and update the FormType / DiagnosisID to return a TemplateID
                    'declare @p4 bigint
                    'set @p4=57978110000000
                    'exec dbo.spFFGetActualTemplate @idfsGISBaseReference=NULL,@idfsBaseReference=784230000000,@idfsFormType=10034504,@idfsFormTemplateActual=@p4 output
                    '-- call for GetActualTemplate
                    'idfsGISBaseReference = Country ID
                    'idfsBaseReference = Disease ID
                    'idfsFormtType = Form Type 

                    'FormType ID
                    '            10034504    Outbreak Human Case CM
                    '            10034505    Outbreak Livestock Case CM
                    '            10034506    Outbreak Avian Case CM


                Case "Veterinary"
                    BaseReferenceLookUp(ddlidfsDiagnosisOrDiagnosisGroup, BaseReferenceConstants.Diagnosis, HACodeList.LivestockHACode, True)
                    ffOutbreakCase.FormType = 10034010
                    ffOutbreakCase.LegendHeader = "Outbreak Livestock Case"
                    ffOutbreakCase.DiagnosisID = 784580000000
                Case "Zoonotic"
                    BaseReferenceLookUp(ddlidfsDiagnosisOrDiagnosisGroup, BaseReferenceConstants.Diagnosis, HACodeList.VectorHACode, True)
                    ffOutbreakCase.FormType = 10034010
                    ffOutbreakCase.LegendHeader = "Outbreak Avian Case"
                    ffOutbreakCase.DiagnosisID = 784580000000
            End Select

            Select Case sfddlOutbreakTypeID.SelectedItem.ToString()
                Case "Human"
                    BaseReferenceLookUp(sfddlSearchDiagnosesGroup, BaseReferenceConstants.Diagnosis, HACodeList.HumanHACode, True)
                Case "Veterinary"
                    BaseReferenceLookUp(sfddlSearchDiagnosesGroup, BaseReferenceConstants.Diagnosis, HACodeList.LivestockHACode, True)
                Case "Zoonotic"
                    BaseReferenceLookUp(sfddlSearchDiagnosesGroup, BaseReferenceConstants.Diagnosis, HACodeList.VectorHACode, True)
                Case Else
                    BaseReferenceLookUp(sfddlSearchDiagnosesGroup, BaseReferenceConstants.Diagnosis, HACodeList.AllHACode, True)
            End Select

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "", "lockNumericSpinnerButtons()", True)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

        Log.Info("Exiting SetFilteredDisaseList().")

    End Sub

    Private Sub SetSpeciesAffect()

        Log.Info("SetSpeciesAffect() Is called.")

        Try

            Log.Info("SetSpeciesAffect() initializations.")

            idfscbHuman.Disabled = True
            idfscbAvian.Disabled = True
            idfscbLivestock.Disabled = True
            idfscbVector.Disabled = True

            idfscbHuman.Checked = False
            idfscbAvian.Checked = False
            idfscbLivestock.Checked = False
            idfscbVector.Checked = False

            dParametersidfscbHuman.Attributes.Add("style", "display:none")
            dParametersidfscbAvian.Attributes.Add("style", "display:none")
            dParametersidfscbLivestock.Attributes.Add("style", "display:none")
            dParametersidfscbVector.Attributes.Add("style", "display:none")

            dSubmissionPanel.Attributes.Add("style", "")
            dSubmissionPanelDivider.Attributes.Add("style", "")

            Log.Info("Outbreak Type " & ddlOutbreakTypeId.SelectedItem.ToString())

            Select Case ddlOutbreakTypeId.SelectedItem.ToString()
                Case "Human"
                    idfscbHuman.Disabled = True

                    idfscbHuman.Checked = True

                    dParametersidfscbHuman.Attributes.Add("style", "display:block")
                Case "Veterinary"
                    idfscbAvian.Disabled = False
                    idfscbLivestock.Disabled = False

                    idfscbAvian.Checked = True
                    idfscbLivestock.Checked = True

                    dParametersidfscbAvian.Attributes.Add("style", "display:block")
                    dParametersidfscbLivestock.Attributes.Add("style", "display:block")
                Case "Zoonotic"
                    idfscbHuman.Disabled = False
                    idfscbAvian.Disabled = False
                    idfscbLivestock.Disabled = False

                    idfscbVector.Checked = True
                    idfscbHuman.Checked = True
                    idfscbAvian.Checked = True
                    idfscbLivestock.Checked = True

                    dParametersidfscbHuman.Attributes.Add("style", "display:block")
                    dParametersidfscbAvian.Attributes.Add("style", "display:block")
                    dParametersidfscbLivestock.Attributes.Add("style", "display:block")
                    dParametersidfscbVector.Attributes.Add("style", "display:block")
                Case Else
                    dSubmissionPanel.Attributes.Add("style", "display:none")
                    dSubmissionPanelDivider.Attributes.Add("style", "display:none")
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

        Log.Info("Exiting SetSpeciesAffect().")

    End Sub

#Region "Grid View Fill Methods"

    Private Sub FillOutbreakList(pageIndex As Integer, paginationSetNumber As Integer, Optional sGetDataFor As String = "")

        Log.Info("FillOutbreakList() Is called.")

        Dim sessions As List(Of OmmSessionGetListModel) = New List(Of OmmSessionGetListModel)()
        Dim CurrentSearchMode As SearchMode = hdnSearchMode.Value
        Dim bRefresh As Boolean = False

        Try
            Dim parameters As New OmmSessionGetListParams

            parameters.langId = GetCurrentLanguage()
            parameters.pageSize = gvOutbreaks.PageSize
            parameters.paginationSet = paginationSetNumber
            parameters.maxPagesPerFetch = 10

            If (CurrentSearchMode = SearchMode.AdvancedSearch) Then
                ExtractParameterTo(sfddlOutbreakTypeID.SelectedValue, ConversionType.ConvertLong, parameters.outbreakTypeId)
                ExtractParameterTo(sfddlSearchDiagnosesGroup.SelectedValue, ConversionType.ConvertLong, parameters.searchDiagnosesGroup)
                ExtractParameterTo(sftxtStartDateFrom.Text, ConversionType.ConvertDate, parameters.startDateFrom)
                ExtractParameterTo(sftxtStartDateTo.Text, ConversionType.ConvertDate, parameters.startDateTo)
                ExtractParameterTo(sfddlidfsOutbreakStatus.SelectedValue, ConversionType.ConvertLong, parameters.idfsOutbreakStatus)
                ExtractParameterTo(sftxtstrOutbreakID.Text, ConversionType.ConvertString, parameters.strOutbreakID)
                ExtractParameterTo(sflucSearch.SelectedRegionValue, ConversionType.ConvertLong, parameters.idfsRegion)
                ExtractParameterTo(sflucSearch.SelectedRayonValue, ConversionType.ConvertLong, parameters.idfsRayon)
            ElseIf (CurrentSearchMode = SearchMode.QuickSearch) Then
                If (obmtxtstrquickSearch.Text = "") Then
                    hdnSearchMode.Value = SearchMode.None
                End If
                parameters.quickSearch = obmtxtstrquickSearch.Text
            End If

            bRefresh = IIf(ViewState("CreateOutbreakListCache") = Nothing, False, CType(ViewState("CreateOutbreakListCache"), Boolean))

            If (bRefresh) Then
                Try
                    sessions = OutbreakAPIService.OmmSessionGetListAsync(parameters, bRefresh).Result
                    Session(OUTBREAKS_DATASET) = sessions
                    ViewState("CreateOutbreakListCache") = False
                Catch ex As Exception
                    Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                    Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
                End Try
            Else
                sessions = CType(Session(OUTBREAKS_DATASET), List(Of OmmSessionGetListModel))
            End If

            gvOutbreaks.PageIndex = pageIndex - 1
            gvOutbreaks.DataSource = sessions
            gvOutbreaks.DataBind()


            FillOutbreaksPager(sessions.Count, pageIndex)
            lblOutbreakPageNumber.Text = pageIndex

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

        Log.Info("Exiting FillOutbreakList().")

    End Sub

    Private Sub FillOutbreakCaseList()

        Dim cases As List(Of OmmCaseGetListModel) = New List(Of OmmCaseGetListModel)()
        Dim CurrentSearchMode As SearchMode = hdnSearchMode.Value

        Try
            Dim parameters As New OmmCaseGetListParams

            ExtractParameterTo(hdnidfOutbreak.Value, ConversionType.ConvertLong, parameters.idfOutbreak)
            parameters.langId = GetCurrentLanguage()

            Select Case CurrentSearchMode
                Case SearchMode.QuickSearch
                    If (obmctxtstrCaseQuickSearch.Text = "") Then
                        hdnSearchMode.Value = SearchMode.None
                    End If
                    parameters.QuickSearch = obmctxtstrCaseQuickSearch.Text
                Case Else
            End Select

            Dim bRefresh As Boolean = IIf(ViewState("CreateOutbreakCaseListCache") = Nothing, False, CType(ViewState("CreateOutbreakCaseListCache"), Boolean))

            cases = OutbreakAPIService.OmmCaseGetListAsync(parameters, bRefresh).Result
            ViewState("CreateOutbreakCaseListCache") = False

            If (cases.Count <> 0) Then
                lblCaseTotalRecords.Text = GetLocalResourceObject("lbl_Case_Total_Records").ToString() & " " & cases(0).RecordCount.ToString()
                gvOutbreakCases.DataSource = cases
            Else
                gvOutbreakCases.DataSource = Nothing
            End If

            gvOutbreakCases.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub FillOutbreakContactList()

        Dim contacts As List(Of OmmContactGetListModel) = New List(Of OmmContactGetListModel)()
        Dim CurrentSearchMode As SearchMode = hdnSearchMode.Value

        Try
            Dim parameters As New OmmContactGetListParams

            ExtractParameterTo(hdnOutbreakCaseReportUID.Value, ConversionType.ConvertLong, parameters.OutbreakCaseReportUID)
            parameters.langId = GetCurrentLanguage()

            Select Case CurrentSearchMode
                Case SearchMode.QuickSearch
                    If (obmtxtstrQuickContactSearch.Text = "") Then
                        hdnSearchMode.Value = SearchMode.None
                    End If
                    parameters.QuickSearch = obmtxtstrQuickContactSearch.Text
                Case Else

            End Select

            If (chkShowTodaysFollowUps.Checked) Then
                parameters.FollowUp = ContactListing.FollowUpOnly
            End If

            contacts = OutbreakAPIService.OmmContactGetListAsync(parameters).Result

            ViewState("CreateContactListCache") = False

            gvOutbreaks.PageIndex = 1
            gvContacts.DataSource = contacts
            gvContacts.DataBind()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub FillUpdatesList()

        Dim updates As List(Of OmmSessionNoteGetListModel) = New List(Of OmmSessionNoteGetListModel)()

        Try
            Dim parameters = New OMMSessionNoteGetListParams

            ExtractParameterTo(hdnidfOutbreak.Value, ConversionType.ConvertLong, parameters.idfOutbreak)
            parameters.langId = GetCurrentLanguage()

            updates = OutbreakAPIService.OmmSessionNoteGetListAsync(parameters, IIf(ViewState("CreateNoteListCache") = Nothing, False, CType(ViewState("CreateNoteListCache"), Boolean))).Result
            ViewState("CreateNoteListCache") = False

            rOutbreakSessionNotes.DataSource = Nothing

            If updates.Count > 0 Then
                Session(OUTBREAK_SESSION_NOTES_DATASET) = updates
                rOutbreakSessionNotes.DataSource = updates
            End If

            rOutbreakSessionNotes.DataBind()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub FillCaseDetails()

        Dim caseSummaryDetails As List(Of OmmCaseSummaryGetDetailModel) = New List(Of OmmCaseSummaryGetDetailModel)()

        Try
            Dim parameters = New OmmCaseSummaryGetDetailParams

            'Use eithher HumanActualAddlInfoUID or OutbreakCaseReportUID, then set the other to -1
            parameters.langId = GetCurrentLanguage()
            ExtractParameterTo(hdfidfHumanActual.Value, ConversionType.ConvertLong, parameters.idfHumanActual)
            ExtractParameterTo(hdfidfFarmActual.Value, ConversionType.ConvertLong, parameters.idfFarmActual)

            caseSummaryDetails = OutbreakAPIService.OmmCaseSummaryGetDetailAsync(parameters).Result

            Scatter(dCaseDetails, caseSummaryDetails.FirstOrDefault(), includeLabels:=True)

            FillOutbreakDetails(dCaseDetails)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#End Region
    Private Sub FillOutbreakDetails(ByRef container As Object)

        'Show newly added record for the summary page. This will include the smart id that wasn't available before.
        If Not hdnidfOutbreak.Value = "-1" Then
            Dim getDetailParameters As OmmSessionGetDetailParams = New OmmSessionGetDetailParams() With {
                .langId = GetCurrentLanguage(),
                .idfOutbreak = Int32.Parse((hdnidfOutbreak.Value))
            }

            Dim sessionDetails As List(Of OmmSessionGetDetailModel) = New List(Of OmmSessionGetDetailModel)()

            sessionDetails = OutbreakAPIService.OmmSessionGetDetailAsync(getDetailParameters).Result
            Scatter(dCaseDetails, sessionDetails.FirstOrDefault(), includeLabels:=True)

            'Pre-fill fields
            ciVetdatMonitoringDate.Text = Date.Today
            upciVetdatMonitoringDate.Update()

            'Pre-set range validators
            rvcidatVetNotificationDate.MinimumValue = sessionDetails.FirstOrDefault().datStartDate
            rvcidatVetNotificationDate.MaximumValue = Date.Today

            rvciVetVaccinationDate.MinimumValue = sessionDetails.FirstOrDefault().datStartDate
            rvciVetVaccinationDate.MaximumValue = Date.Today

            ViewState("CreateOutbreakListCache") = True
        End If

    End Sub

    'Private Sub SaveSearchFields()

    'oCommon.SaveSearchFields({outbreak}, CREATE_OUTBREAK_PREFIX, oCommon.CreateTempFile(CREATE_OUTBREAK_PREFIX))
    'oCommon.SaveSearchFields({outbreak, divHiddenFieldsSection}, CREATE_OUTBREAK_PREFIX, oCommon.CreateTempFile(CREATE_OUTBREAK_PREFIX))

    'End Sub

    'Private Sub GetSearchFields()

    'oCommon.GetSearchFields({outbreak}, oCommon.CreateTempFile(CREATE_OUTBREAK_PREFIX))
    'oCommon.GetSearchFields({outbreak, divHiddenFieldsSection}, oCommon.CreateTempFile(CREATE_OUTBREAK_PREFIX))

    'End Sub

    Private Sub TempFill(ddl As DropDownList, strParameters As String, iDefaultValue As Int16)

        Try
            Dim li As ListItem

            For Each strNameValuePair As String In strParameters.Split(New Char() {","c})
                li = New ListItem()
                li.Text = strNameValuePair.Split(New Char() {"|"c})(0)
                li.Value = strNameValuePair.Split(New Char() {"|"c})(1)
                ddl.Items.Add(li)
            Next

            ddl.SelectedIndex = iDefaultValue
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub SetFieldDefaults()

        Try
            ResetForm(outbreak)
            ResetForm(outbreakSummaryAndQuestions)

            'TODO - Not sure why, but Common Reset didn't remove the checked boxes here
            idfscbHuman.Checked = False
            idfscbAvian.Checked = False
            idfscbLivestock.Checked = False
            idfscbVector.Checked = False

            'Ensure that the Outbreak parameters are set to invisible
            dOutbreakHeading.Attributes.Add("style", "display:none")
            dParametersidfscbHuman.Attributes.Add("style", "display:none")
            dParametersidfscbAvian.Attributes.Add("style", "display:none")
            dParametersidfscbLivestock.Attributes.Add("style", "display:none")
            dParametersidfscbVector.Attributes.Add("style", "display:none")
            dSubmissionPanelDivider.Attributes.Add("style", "display:none")
            dSubmissionPanel.Attributes.Add("style", "display:none")

            'Reset to new outbreak creation
            hdnidfOutbreak.Value = "-1"

            'Use case default values required for new creation
            clidatStartDate.Text = Date.Today.ToString()

            'Disable these fields
            ddlidfsDiagnosisOrDiagnosisGroup.Enabled = False

            'Populate hidden variables with session used information
            hdfidfPersonEnteredBy.Value = Session("Person").ToString()

            'Country of usage
            hdnidfsCountry.Value = getConfigValue("CountryID").ToString()

            'Reset controlling viewstates to prevent ill behaviors
            ViewState("SaveFlexForm") = False

            rblImportCase.SelectedIndex = -1
            rblCreateCase.SelectedIndex = -1

            'Vet Case Monitoring Date
            ciVetdatMonitoringDate.Text = Date.Today()

            'Set controls that have a maxdate that shouldn't go beyond today
            rvVetLabResultDate.MaximumValue = Date.Today
            rvVetLabResultDate.MinimumValue = CType("1/1/1901", DateTime)

            ciDateOfNotification.Text = ""
            ciDateOfSymptomsOnset.Text = ""
            ciDateOfDiagnosis.Text = ""

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub ToggleVisibility(ByVal sSection As String)

        Try

            pSearchForm.Visible = False
            pOutbreakManagement.Visible = False
            pOutbreak.Visible = False
            pSearchResults.Visible = False
            pOutbreakSummaryAndQuestions.Visible = False
            pOutbreakQuestionnaire.Visible = False
            pOutbreakCaseCreation.Visible = False

            humanDisease.Visible = False
            veterinaryDisease.Visible = False
            dVeterinarySideBarPanel.Visible = False
            dHumanSidebarPanel.Visible = False

            Select Case sSection
                Case SectionSearchOutbreak
                    pSearchForm.Visible = True
                Case SectionSearchHuman
                Case SectionSearchVeterinary
                Case SectionSearchOutbreakManagement
                    FillOutbreakList(pageIndex:=1, paginationSetNumber:=1, sGetDataFor:="AdvancedSearch")
                Case SectionOutbreakManagement
                    pOutbreakManagement.Visible = True
                    pOutbreakManagementHeader.Visible = True
                    pOutbreakManagementControls.Visible = True
                    FillOutbreakList(pageIndex:=1, paginationSetNumber:=1)
                Case SectionCreateOutbreak
                    outbreakLocation.Setup(CrossCuttingAPIService)
                    pOutbreak.Visible = True
                    bSubmit.Attributes.Add("style", "display:none")
                    txtstrOutbreakID.Text = "(New)"
                Case SectionOutbreakSummary
                    pOutbreakSummaryAndQuestions.Visible = True
                    FillOutbreakContactList()
                    FillOutbreakCaseList()
                    FillUpdatesList()
                Case SectionVeterinarySearch
                    'ucSearchVeterinaryDiseaseReport.Setup(selectMode:=SelectModes.Selection)
                    'ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#outbreakVeterinaryDiseaseSearch", ""), True)
                Case SectionHumanSearch
                    'ucSearchPerson.Setup(useHumanMasterIndicator:=True, selectMode:=SelectModes.Selection)
                    'ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#outbreakPersonSearch", ""), True)
                    'ucSearchHumanDiseaseReport.Setup(selectMode:=SelectModes.Selection)
                    'ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#outbreakHumanDiseaseSearch", ""), True)
                Case SectionOutbreakQuestionnaire
                    pOutbreakQuestionnaire.Visible = True
                    'FlexFormQuestionnaire.LoadFlexForm(Long.Parse(1), CType(ddlidfsDiagnosisOrDiagnosisGroup.SelectedValue, Long))
                Case SectionOutbreakCaseCreation
                    pOutbreakCaseCreation.Visible = True

                    Select Case hdnDiseaseReport.Value
                        Case "Human"
                            ResetForm(humanDisease)
                            humanDisease.Visible = True
                            dHumanSidebarPanel.Visible = True
                            lucCaseLocation.Setup(CrossCuttingAPIService)

                        Case "Veterinary"
                            ResetForm(veterinaryDisease)
                            SetFieldDefaults()
                            veterinaryDisease.Visible = True
                            dVeterinarySideBarPanel.Visible = True
                            ucVetCaseLocation.Setup(CrossCuttingAPIService)
                    End Select

                    upMain.Update()
                Case SectionOutbreakCaseEdit
                    pOutbreakCaseCreation.Visible = True

                    Select Case hdnDiseaseReport.Value
                        Case "Human"
                            humanDisease.Visible = True
                            dHumanSidebarPanel.Visible = True
                            lucCaseLocation.Setup(CrossCuttingAPIService)

                        Case "Veterinary"
                            veterinaryDisease.Visible = True
                            dVeterinarySideBarPanel.Visible = True
                            ucVetCaseLocation.Setup(CrossCuttingAPIService)
                    End Select

                    upMain.Update()
            End Select

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub AddUpdateOutbreak()

        Try
            If hdnidfOutbreak.Value = "-1" Then
                txtstrOutbreakID.Text = "(New)"
            End If

            If hdfidfsSite.Value = "null" Then
                hdfidfsSite.Value = Session("UserSite").ToString()
            End If

            If hdfidfPersonEnteredBy.Value = "null" Then
                hdfidfPersonEnteredBy.Value = Session("Person").ToString()
            End If

            Dim parameters As OMMSessionSetParams = New OMMSessionSetParams()

            parameters.langId = GetCurrentLanguage()

            'Extract Parameter To working with the parameters that were generated from the Gather function
            ExtractParameterTo(hdnidfOutbreak.Value, ConversionType.ConvertLong, parameters.idfOutbreak)
            ExtractParameterTo(ddlidfsDiagnosisOrDiagnosisGroup.SelectedValue, ConversionType.ConvertLong, parameters.idfsDiagnosisOrDiagnosisGroup)
            ExtractParameterTo(ddlidfsOutbreakStatus.SelectedValue, ConversionType.ConvertLong, parameters.idfsOutbreakStatus)
            ExtractParameterTo(ddlOutbreakTypeId.SelectedValue, ConversionType.ConvertLong, parameters.OutbreakTypeId)

            ExtractParameterTo(getConfigValue("CountryID").ToString(), ConversionType.ConvertLong, parameters.outbreakLocationidfsCountry)
            ExtractParameterTo(outbreakLocation.SelectedRegionValue, ConversionType.ConvertLong, parameters.outbreakLocationidfsRegion)
            ExtractParameterTo(outbreakLocation.SelectedRayonValue, ConversionType.ConvertLong, parameters.outbreakLocationidfsRayon)
            ExtractParameterTo(outbreakLocation.SelectedSettlementValue, ConversionType.ConvertLong, parameters.outbreakLocationidfsSettlement)

            ExtractParameterTo(clidatStartDate.Text, ConversionType.ConvertDate, parameters.datStartDate)
            ExtractParameterTo(clidatCloseDate.Text, ConversionType.ConvertDate, parameters.datCloseDate)
            ExtractParameterTo(txtstrOutbreakID.Text, ConversionType.ConvertString, parameters.strOutbreakID)
            ExtractParameterTo(hdnintRowStatus.Value, ConversionType.ConvertLong, parameters.intRowStatus)
            ExtractParameterTo(hdfidfsSite.Value, ConversionType.ConvertLong, parameters.idfsSite)

            parameters.OutbreakParameters = New List(Of OMMParameters)()
            parameters.intRowStatus = 0

            GetOutbreakParameters("Human", hdfidfPersonEnteredBy.Value, parameters.OutbreakParameters)
            GetOutbreakParameters("xAvian", hdfidfPersonEnteredBy.Value, parameters.OutbreakParameters)
            GetOutbreakParameters("Livestock", hdfidfPersonEnteredBy.Value, parameters.OutbreakParameters)
            GetOutbreakParameters("xVector", hdfidfPersonEnteredBy.Value, parameters.OutbreakParameters)

            Dim result As List(Of OmmSessionSetModel) = OutbreakAPIService.OmmSessionSetAsync(parameters).Result

            If Not result Is Nothing Then
                hdnidfOutbreak.Value = result(0).idfOutbreak.ToString()
            Else
                ShowWarningMessage(message:=MessageType.CannotAddUpdate, bIsConfirm:=False)
            End If

            'Show newly added record for the summary page. This will include the smart id that wasn't available before.
            ViewState("CreateOutbreakListCache") = True
            SelectOutbreakSession(hdnidfOutbreak.Value)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub AddUpdateNote(Optional bDeleteAttachment As Boolean = False)

        Try
            If hdnidfOutbreakNote.Value = "-1" Then
                txtidfOutbreakNote.Text = "(New)"
            End If

            If hdfidfsSite.Value = "null" Then
                hdfidfsSite.Value = Session("UserSite").ToString()
            End If

            If hdfidfPersonEnteredBy.Value = "null" Then
                hdfidfPersonEnteredBy.Value = Session("Person").ToString()
                hdfidfPerson.Value = Session("Person").ToString()
            End If

            Dim parameters As OMMSessionNoteSetParams = New OMMSessionNoteSetParams()

            Try
                parameters.langId = GetCurrentLanguage()
                ExtractParameterTo(hdnidfOutbreakNote.Value, ConversionType.ConvertLong, parameters.idfOutbreakNote)
                ExtractParameterTo(hdnidfOutbreak.Value, ConversionType.ConvertLong, parameters.idfOutbreak)
                ExtractParameterTo(hdfidfPerson.Value, ConversionType.ConvertLong, parameters.idfPerson)
                ExtractParameterTo(hdnintRowStatus.Value, ConversionType.ConvertInt, parameters.intRowStatus)

                If (bDeleteAttachment) Then
                    parameters.DeleteAttachment = "1"
                Else
                    'ExtractParameterTo(strMaintenanceFlag.Text, ConversionType.ConvertString, parameters.strMaintenanceFlag)
                    ExtractParameterTo(textstrNote.Text, ConversionType.ConvertString, parameters.strNote)
                    'ExtractParameterTo(strReservedAttribute.Text, ConversionType.ConvertString, parameters.strReservedAttribute)
                    ExtractParameterTo(drdlUpdatePriorityID.SelectedValue, ConversionType.ConvertLong, parameters.updatePriorityId)
                    ExtractParameterTo(textUpdateRecordTitle.Text, ConversionType.ConvertString, parameters.updateRecordTitle)
                    ExtractParameterTo(textUploadFileDescription.Text, ConversionType.ConvertString, parameters.uploadFileDescription)

                    'parameters.intRowStatus = 1

                    If (fileUploadFileObject.FileName <> "") Then
                        parameters.uploadFileName = fileUploadFileObject.FileName
                        parameters.uploadFileObject = fileUploadFileObject.FileBytes
                    End If
                End If

                Dim result As OmmSessionNoteSetModel = OutbreakAPIService.OmmSessionNoteSet(parameters).Result(0)

                If bDeleteAttachment Then
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", String.Format(HIDE_FORM, "#dOutbreakNoteForm", "OutbreakNoteForm"), True)
                Else
                    'ShowWarningMessage(message:=MessageType.CannotAddUpdate, bIsConfirm:=False)
                    If Not result Is Nothing Then
                        hdnidfOutbreakNote.Value = result.idfOutbreakNote.ToString()
                    End If
                End If

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

            'Show newly added record for the summary page. This will include the smart id that wasn't available before.
            If Not hdnidfOutbreak.Value = "-1" Then
                Dim getDetailParameters As OmmSessionGetDetailParams = New OmmSessionGetDetailParams()

                getDetailParameters.idfOutbreak = hdnidfOutbreak.Value

                Dim sessionDetails As List(Of OmmSessionGetDetailModel) = New List(Of OmmSessionGetDetailModel)()

                sessionDetails = OutbreakAPIService.OmmSessionGetDetailAsync(getDetailParameters).Result
                Scatter(outbreakSummaryAndQuestions, sessionDetails.FirstOrDefault(), includeLabels:=True)

                ToggleVisibility(SectionOutbreakSummary)
                'FillOutbreakCaseList()

                ViewState("CreateNoteListCache") = True
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub UpdateContact()

        Try
            Dim parameters As OMMContactSetParams = New OMMContactSetParams()

            Try
                parameters.langId = GetCurrentLanguage()
                ExtractParameterTo(hdnOutbreakCaseContactUID.Value, ConversionType.ConvertLong, parameters.OutbreakCaseContactUID)
                ExtractParameterTo(ddlContactRelationshipTypeID.SelectedValue, ConversionType.ConvertLong, parameters.ContactRelationshipTypeID)
                ExtractParameterTo(ciDateOfLastContact.Text, ConversionType.ConvertDate, parameters.DateOfLastContact)

                ExtractParameterTo(txtPlaceOfLastContact.Text, ConversionType.ConvertString, parameters.PlaceOfLastContact)
                ExtractParameterTo(txtCommentText.Text, ConversionType.ConvertString, parameters.CommentText)
                ExtractParameterTo(ddlContactStatusID.SelectedValue, ConversionType.ConvertLong, parameters.ContactStatusID)
                ExtractParameterTo(Date.Today, ConversionType.ConvertDate, parameters.AuditDTM)
                ExtractParameterTo(Session("UserSite").ToString(), ConversionType.ConvertDate, parameters.AuditUser)

                parameters.contactLocationidfsRegion = lucContactLocation.SelectedRegionValue
                parameters.contactLocationidfsRayon = lucContactLocation.SelectedRayonValue
                parameters.contactLocationidfsSettlement = lucContactLocation.SelectedSettlementValue
                parameters.contactLocationidfsRayon = lucContactLocation.SelectedRayonValue
                parameters.strStreetName = lucContactLocation.StreetText
                parameters.strPostCode = lucContactLocation.SelectedPostalText
                parameters.strBuilding = lucContactLocation.BuildingText
                parameters.strHouse = lucContactLocation.HouseText
                parameters.strApartment = lucContactLocation.ApartmentText
                parameters.intRowStatus = 0

                Dim result As OmmContactSetModel = OutbreakAPIService.OmmContactSetAsync(parameters).Result(0)

            Catch ex As Exception
                Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
                Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
            End Try

            'According to the use case, there is not "New" contact creation from the outbreak side...so only editing
            'ToggleVisibility(SectionOutbreakSummary)

            ViewState("CreateContactCache") = True
            FillOutbreakContactList()

            'ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", "showContactsTab()", True)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub DeleteMonitoringSession(dOutbreakID As Long)

        Try

            ViewState("Action") = "DeleteMonitoringSession"
            hdnidfOutbreak.Value = dOutbreakID.ToString()
            ShowWarningMessage(MessageType.ConfirmDelete, True)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub SelectOutbreakSession(dOutbreakID As Long)

        Dim sessionDetails As List(Of OmmSessionGetDetailModel) = New List(Of OmmSessionGetDetailModel)()

        Try
            Dim params = New OmmSessionGetDetailParams With {
                .langId = GetCurrentLanguage(),
                .idfOutbreak = dOutbreakID
            }

            hdnidfOutbreak.Value = dOutbreakID.ToString()

            ViewState("CreateContactListCache") = True

            sessionDetails = OutbreakAPIService.OmmSessionGetDetailAsync(params).Result
            Scatter(outbreakSummaryAndQuestions, sessionDetails.FirstOrDefault(), includeLabels:=True)
            ToggleVisibility(SectionOutbreakSummary)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub EditOutbreakSession()

        EditOutbreakSession(CType(hdnidfOutbreak.Value, Long))

    End Sub

    Private Sub EditOutbreakSession(dOutbreakID As Long)

        Try
            Dim dsOutbreak As DataSet = New DataSet()
            Dim sessionDetails As List(Of OmmSessionGetDetailModel) = New List(Of OmmSessionGetDetailModel)()

            Dim params = New OmmSessionGetDetailParams With {
                        .langId = GetCurrentLanguage(),
                        .idfOutbreak = dOutbreakID
                    }

            sessionDetails = OutbreakAPIService.OmmSessionGetDetailAsync(params).Result

            If sessionDetails.Count > 0 Then
                Session(OUTBREAK_DATASET) = sessionDetails
                Scatter(outbreak, sessionDetails.FirstOrDefault())
            End If

            ToggleVisibility(SectionCreateOutbreak)
            ResetForm(outbreak)

            'When editing, this feature needs to be ran twice, since the order of population will depend on values in some fields.
            Dim iRepeats As Integer = 0

            Do While iRepeats < 2
                ddlOutbreakType_Select(Nothing, Nothing)
                SetFilteredDisaseList()
                SetSpeciesAffect()

                Scatter(outbreak, sessionDetails.FirstOrDefault())
                Scatter(divHiddenFieldsSection, sessionDetails.FirstOrDefault())
                Scatter(outbreak, sessionDetails.FirstOrDefault(), prefixLength:=19)
                iRepeats = iRepeats + 1
            Loop

            clidatCloseDate.Visible = IIf(ddlidfsOutbreakStatus.SelectedValue = OUTBREAK_STATUS_CLOSED, True, False)
            lblclidatCloseDate.Visible = clidatCloseDate.Visible

            outbreakLocation.LocationCountryID = sessionDetails(0).idfsCountry
            outbreakLocation.LocationRegionID = sessionDetails(0).idfsRegion
            outbreakLocation.LocationRayonID = sessionDetails(0).idfsRayon
            outbreakLocation.LocationSettlementID = sessionDetails(0).idfsSettlement
            outbreakLocation.DataBind()

            'Obtain parameters for the session and populate them for edit
            Dim sessionParameters As List(Of OmmSessionParametersGetListModel) = New List(Of OmmSessionParametersGetListModel)()
            Dim paramsForList = New OmmSessionParametersGetListParams With {
                        .langId = GetCurrentLanguage(),
                        .idfOutbreak = dOutbreakID
                    }

            sessionParameters = OutbreakAPIService.OmmSessionParametersGetListAsync(paramsForList).Result

            If (sessionParameters.Count > 0) Then
                Dim iModelLength As Int16 = CType(sessionParameters.Count - 1, Short)
                Dim iIndex As Int16 = 0
                Dim iPrefixLength = 0

                For iIndex = 0 To iModelLength
                    Select Case sessionParameters(iIndex).OutbreakSpeciesTypeID
                        Case OUTBREAK_HUMAN_ID
                            iPrefixLength = 8
                        Case OUTBREAK_AVIAN_ID
                            iPrefixLength = 9
                        Case OUTBREAK_LIVESTOCK_ID
                            iPrefixLength = 12
                        Case OUTBREAK_VECTOR_ID
                            iPrefixLength = 10
                    End Select

                    Scatter(dOutbreakParameters, sessionParameters(iIndex), prefixLength:=iPrefixLength)
                Next
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", String.Format("enableParameters()"), True)
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub EditCaseContact(caseContactUID As Long)

        Try
            ResetForm(upOutbreakContactForm)

            Dim contactDetails As List(Of OmmContactGetDetailModel) = New List(Of OmmContactGetDetailModel)()
            Dim parms = New OmmContactGetDetailParams With {
                .langId = GetCurrentLanguage(),
                .OutbreakCaseContactUID = caseContactUID
            }

            contactDetails = OutbreakAPIService.OmmContactGetDetailAsync(parms).Result
            upOutbreakNoteForm.Visible = True

            FillBaseReferenceDropDownList(ddlContactRelationshipTypeID, BaseReferenceConstants.PatientContactType, HACodeList.HumanHACode, True)

            Scatter(divHiddenFieldsSection, contactDetails.FirstOrDefault(), includeLabels:=True, prefixLength:=3)
            Scatter(dOutbreakContactForm, contactDetails.FirstOrDefault(), includeLabels:=True, prefixLength:=2)
            Scatter(dOutbreakContactForm, contactDetails.FirstOrDefault(), includeLabels:=True, prefixLength:=3)
            Scatter(dOutbreakContactForm, contactDetails.FirstOrDefault(), includeLabels:=True, prefixLength:=21)

            lucContactLocation.LocationCountryID = contactDetails(0).idfsCountry
            lucContactLocation.LocationRegionID = contactDetails(0).idfsRegion
            lucContactLocation.LocationRayonID = contactDetails(0).idfsRayon
            lucContactLocation.LocationSettlementID = contactDetails(0).idfsSettlement
            lucContactLocation.DataBind()

            hdnOutbreakCaseContactUID.Value = caseContactUID.ToString()

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#dOutbreakContactForm", "OutbreakContactForm"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub AddBatchVetVaccination(sender As Object, e As EventArgs) Handles btnVetVaccinationAdd.Click


        Dim vvList As List(Of OmmVetVaccination)

        Try
            vvList = CType(Session(VET_VACCINATIONS), List(Of OmmVetVaccination))

            If (vvList Is Nothing) Then
                vvList = New List(Of OmmVetVaccination)
            End If

        Catch ex As Exception
            vvList = New List(Of OmmVetVaccination)
        End Try

        Dim vv As OmmVetVaccination = New OmmVetVaccination
        Dim iRecords As Int16 = vvList.Count

        vv.idfVetVaccination = -(iRecords + 1)
        vv.Name = ddlVetVaccinationDiseaseName.SelectedItem.Text
        vv.idfDisease = ddlVetVaccinationDiseaseName.SelectedValue
        vv.Date = CType(ciVetVaccinationDate.Text, Date)
        vv.idfSpecies = ddlVetVaccinationSpecies.SelectedValue
        vv.Species = ddlVetVaccinationSpecies.SelectedItem.Text
        vv.NumberVaccinated = CType(nsVetVaccinationVaccinated.Text, Short)
        vv.Type = ddlVetvaccinationType.SelectedItem.Text
        vv.idfType = ddlVetvaccinationType.SelectedValue
        vv.Route = ddlVetVaccinationRoute.SelectedItem.Text
        vv.idfRoute = ddlVetVaccinationRoute.SelectedValue
        vv.LotNumber = txtVetVaccinationLotNumber.Text
        vv.Manufacturer = txtVetVaccinationManufacturer.Text
        vv.Comments = txtVetVaccinationComments.Text
        vv.RowStatus = 0

        vvList.Add(vv)

        Session(VET_VACCINATIONS) = vvList

        ResetForm(dVetVaccinationInformationForm)
        btnVetVaccinationAdd.Enabled = False

        gvVetVaccinations.DataSource = vvList
        gvVetVaccinations.DataBind()

    End Sub

    Private Sub AddBatchCaseVaccination()

        Dim ovls As List(Of OmmClinicalVaccination)

        Try
            ovls = CType(Session(VET_VACCINATIONS), List(Of OmmClinicalVaccination))

            If (ovls Is Nothing) Then
                ovls = New List(Of OmmClinicalVaccination)
            End If

        Catch ex As Exception
            ovls = New List(Of OmmClinicalVaccination)
        End Try

        Dim ovl As OmmClinicalVaccination = New OmmClinicalVaccination
        Dim iRecords As Int16 = ovls.Count

        ovl.HumanDiseaseReportVaccinationUID = -(iRecords + 1)
        ovl.Name = txtstrVaccinationName.Text
        ovl.Date = CType(cidatDateOfVaccination.Text, Date)

        ovls.Add(ovl)

        txtstrVaccinationName.Text = ""
        cidatDateOfVaccination.Text = ""
        btnAddVaccination.Enabled = False

        Session(VET_VACCINATIONS) = ovls

        gvVaccinations.DataSource = ovls
        gvVaccinations.DataBind()

    End Sub

    Protected Sub BatchAddContact(ByVal sender As Object, ByVal e As EventArgs) Handles bBatchAddContact.Click, bBatchAddVetContact.Click

        Dim cs As List(Of OmmHumanVetContact) = Nothing

        Try
            Select Case sender.Id.ToString()
                Case "bBatchAddVetContact"
                    cs = CType(Session(HUM_VET_CONTACTS), List(Of OmmHumanVetContact))
                Case "bBatchAddContact"
                    cs = CType(Session("CaseContactList"), List(Of OmmHumanVetContact))
            End Select

            If (cs Is Nothing) Then
                cs = New List(Of OmmHumanVetContact)
            End If

        Catch ex As Exception
            cs = New List(Of OmmHumanVetContact)
        End Try

        Dim c As OmmHumanVetContact = New OmmHumanVetContact

        Select Case sender.Id.ToString()
            Case "bBatchAddVetContact"
                c.idfContactCasePerson = CType(hdfidfContactHumanActual.Value, Long)
                c.ContactName = tx2VetContactName.Text
                c.DateOfLastContact = CType(ciVetdatDateOfLastContact.Text, Date)
                c.ContactType = rblVetContactType.SelectedItem.ToString()
                c.idfsPersonContactType = rblVetContactType.SelectedValue
                c.ContactStatus = ddlVetContactStatus.SelectedItem.ToString()
                c.ContactStatusId = ddlVetContactStatus.SelectedValue
                c.ContactRelationshipTypeID = ddlVetContactRelationshipType.SelectedValue
                c.Relation = ddlVetContactRelationshipType.SelectedItem.ToString()
                c.PlaceOfLastContact = tx2VetPlaceOfLastContact.Text
            Case "bBatchAddContact"
                c.idfContactCasePerson = CType(hdfidfContactHumanActual.Value, Long)
                c.ContactName = txtContactName.Text
                c.DateOfLastContact = CType(cidatDateOfLastContact.Text, Date)
                c.ContactType = rblContactType.SelectedItem.ToString()
                c.idfsPersonContactType = rblContactType.SelectedValue
                c.ContactStatus = ddlContactStatus.SelectedItem.ToString()
                c.ContactStatusId = ddlContactStatus.SelectedValue
                c.ContactRelationshipTypeID = ddlContactRelationshipType.SelectedValue
                c.Relation = ddlContactRelationshipType.SelectedItem.ToString()
                c.PlaceOfLastContact = tx2PlaceOfLastContact.Text
        End Select
        c.intRowStatus = 0

        cs.Add(c)

        'Reset fields for next entry
        txtContactName.Text = ""
        cidatDateOfLastContact.Text = ""
        rblContactType.SelectedIndex = -1
        rblVetContactType.SelectedIndex = -1
        ddlContactStatus.SelectedIndex = -1
        ddlContactRelationshipType.SelectedIndex = -1
        tx2PlaceOfLastContact.Text = ""
        imContactName.Attributes.Add("disabled", "disabled")

        Select Case sender.Id.ToString()
            Case "bBatchAddVetContact"
                Session(HUM_VET_CONTACTS) = cs

                ResetForm(dVetContacts)

                gvVetCaseContacts.DataSource = cs
                gvVetCaseContacts.DataBind()
            Case "bBatchAddContact"
                Session("CaseContactList") = cs

                gvCaseContacts.DataSource = cs
                gvCaseContacts.DataBind()
        End Select

    End Sub

    Protected Sub BatchAddSample(ByVal sender As Object, ByVal e As EventArgs) Handles btnAddCaseSample.Click

        Dim ss As List(Of OmmSample)

        Try
            ss = CType(Session("CaseSampleList"), List(Of OmmSample))

            If (ss Is Nothing) Then
                ss = New List(Of OmmSample)
            End If

        Catch ex As Exception
            ss = New List(Of OmmSample)
        End Try

        Dim s As OmmSample = New OmmSample
        Dim idfMaterial As Int16 = ss.Count

        s.idfMaterial = -idfMaterial
        s.CollectedByInstitution = txtFieldCollectedByOffice.Text
        s.idfFieldCollectedByOffice = CType(IIf(hdntxtFieldCollectedByOffice.Value = "", -1, hdntxtFieldCollectedByOffice.Value), Long)
        If (cidatCollectionDate.Text <> "") Then
            s.datCollectionDate = CType(cidatCollectionDate.Text, Date)
        End If
        s.Sampletype = ddlSampleType.SelectedItem.ToString()
        s.idfsSampleType = CType(IIf(ddlSampleType.SelectedValue = "null", -1, ddlSampleType.SelectedValue), Long)
        s.LocalSampleId = txtLocalSampleID.Text
        If (cidatSentDate.Text <> "") Then
            s.SentDate = cidatSentDate.Text
        End If
        s.SentToOrganization = txtSentToOrganization.Text

        ss.Add(s)

        'Reset fields for next entry
        ddlSampleType.SelectedIndex = -1
        cidatCollectionDate.Text = ""
        txtFieldCollectedByOffice.Text = ""
        txtFieldCollectedByPerson.Text = ""
        cidatSentDate.Text = ""
        txtSentToOrganization.Text = ""
        btnAddCaseSample.Enabled = False

        Session("CaseSampleList") = ss

        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", "goToTab(currentTab);", True)

        gvCaseSamples.DataSource = ss
        gvCaseSamples.DataBind()

    End Sub
    Protected Sub BatchAddVetCaseMonitoring(ByVal sender As Object, ByVal e As EventArgs) Handles btnVetAddCaseMonitoring.Click

        Dim vcmList As List(Of OmmVetCaseMonitoring)

        Try
            vcmList = CType(Session(VET_CASE_MONITORING), List(Of OmmVetCaseMonitoring))

            If (vcmList Is Nothing) Then
                vcmList = New List(Of OmmVetCaseMonitoring)
            End If

        Catch ex As Exception
            vcmList = New List(Of OmmVetCaseMonitoring)
        End Try

        Dim vcm As OmmVetCaseMonitoring = New OmmVetCaseMonitoring
        Dim idfVetCaseMonitoring As Int16 = vcmList.Count

        vcm.langId = GetCurrentLanguage()
        vcm.idfVetCaseMonitoring = idfVetCaseMonitoring
        vcm.InvestigatorOrganization = tx2VetMonitoringInvestigatorOrganization.Text
        vcm.InvestigatorName = tx2VetMonitoringInvestigatorName.Text
        vcm.datMonitoringDate = ciVetdatMonitoringDate.Text
        vcm.AdditionalComments = tx2VetAdditionalComments.Text
        vcmList.Add(vcm)

        'Reset fields for next entry
        ResetForm(dVetCaseMonitoringForm)
        ciVetdatMonitoringDate.Text = Date.Today

        btnVetAddCaseMonitoring.Enabled = False

        Session(VET_CASE_MONITORING) = vcmList

        gvVetCaseMonitoring.DataSource = vcmList
        gvVetCaseMonitoring.DataBind()

    End Sub

    Protected Sub BatchAddPensideTest(ByVal sender As Object, ByVal e As EventArgs) Handles btnAddPensideText.Click

        Dim vptList As List(Of OmmVetPensideTest)

        Try
            vptList = CType(Session(VET_PENSIDE_TESTS), List(Of OmmVetPensideTest))

            If (vptList Is Nothing) Then
                vptList = New List(Of OmmVetPensideTest)
            End If

        Catch ex As Exception
            vptList = New List(Of OmmVetPensideTest)
        End Try

        Dim vpt As OmmVetPensideTest = New OmmVetPensideTest
        Dim idfPensideTest As Int16 = vptList.Count

        vpt.idfVetPensideTest = -(idfPensideTest + 1)
        vpt.strAnimalId = txtVetAnimalId.Text
        vpt.AnimalId = 0
        vpt.FieldSampleId = ddlVetFieldSampleId.SelectedValue.ToString()
        vpt.idfResult = CType(ddlVetResult.SelectedValue, Long)
        vpt.Result = ddlVetResult.SelectedItem.ToString()
        vpt.SampleType = txtVetSampleType.Text
        vpt.idfSampleType = hdnVetSampleTypeId.Value
        vpt.Species = txtVetSpecies.Text
        vpt.idfSpecies = -1
        vpt.TestName = ddlVetTestName.SelectedItem.ToString()
        vpt.idfTestName = CType(ddlVetTestName.SelectedValue, Long)
        vpt.intRowStatus = 0

        vptList.Add(vpt)

        'Reset fields for next entry
        ResetForm(pVetPensideTest)
        btnVetAddCaseMonitoring.Enabled = False

        Session(VET_PENSIDE_TESTS) = vptList

        gvVetPensideTest.DataSource = vptList
        gvVetPensideTest.DataBind()

    End Sub

    Protected Sub BatchAddVetAnimalInvestigation(sender As Object, e As EventArgs) Handles btnVCIAdd.Click

        Dim vaiList As List(Of OmmVetAnimalInvestigation) = New List(Of OmmVetAnimalInvestigation)

        Try
            vaiList = CType(Session(VET_ANIMAL_INVESTIGATIONS), List(Of OmmVetAnimalInvestigation))

            If (vaiList Is Nothing) Then
                vaiList = New List(Of OmmVetAnimalInvestigation)
            End If

        Catch ex As Exception
            vaiList = New List(Of OmmVetAnimalInvestigation)
        End Try

        Dim vai As OmmVetAnimalInvestigation = New OmmVetAnimalInvestigation
        Dim iRecords As Int16 = vaiList.Count

        ExtractParameterTo(-(iRecords + 1), ConversionType.ConvertLong, vai.AnimalId)
        ExtractParameterTo(txtVCIAnimalID.Text, ConversionType.ConvertString, vai.strAnimalId)
        ExtractParameterTo(ddlVCIAge.SelectedItem.Text, ConversionType.ConvertString, vai.Age)
        ExtractParameterTo(ddlVCIAge.SelectedValue, ConversionType.ConvertLong, vai.ddlVetAge)
        ExtractParameterTo(ddlVCISex.SelectedItem.Text, ConversionType.ConvertString, vai.Sex)
        ExtractParameterTo(ddlVCISex.SelectedValue, ConversionType.ConvertLong, vai.ddlVetSex)
        ExtractParameterTo(ddlVCIAge.SelectedValue, ConversionType.ConvertLong, vai.AnimalAgeTypeId)
        upAnimalinvestigationHerdSpecies.Update()
        ExtractParameterTo(ddlVCIHerdID.SelectedItem.Text, ConversionType.ConvertString, vai.HerdCode)
        ExtractParameterTo(ddlVCIHerdID.SelectedValue, ConversionType.ConvertLong, vai.idfHerd)
        ExtractParameterTo(ddlVCISpecies.SelectedValue, ConversionType.ConvertLong, vai.idfsSpeciesType)
        ExtractParameterTo(ddlVCISpecies.SelectedItem.Text, ConversionType.ConvertString, vai.SpeciesType)
        ExtractParameterTo(txtVCINote.Text, ConversionType.ConvertString, vai.Note)
        ExtractParameterTo(ddlVCIStatus.SelectedItem.Text, ConversionType.ConvertString, vai.Status)
        ExtractParameterTo(ddlVCIStatus.SelectedValue, ConversionType.ConvertLong, vai.idfStatus)

        vai.RowStatus = 0

        vaiList.Add(vai)

        Session(VET_ANIMAL_INVESTIGATIONS) = vaiList

        gvAnimalInvestigation.DataSource = vaiList
        gvAnimalInvestigation.DataBind()

        ResetForm(dVetAnimalInvestigation)

    End Sub

    Private Sub GetOutbreakParameters(strUniqueId As String, strAuditCreateUser As String, ByVal sessionParameters As List(Of OMMParameters))

        Dim objParametersContainer As Object = dOutbreakParameters.FindControl("dParametersidfscb" + strUniqueId.Replace("x", ""))
        Dim op As OMMParameters = New OMMParameters()

        Try
            If Not objParametersContainer Is Nothing Then
                If (objParametersContainer.Attributes("style") <> "display:none") Then
                    Dim objCaseMonitoringDuration As Object = dOutbreakParameters.FindControl("ens" + strUniqueId + "CaseMonitoringDuration")
                    Dim objMonitoringFrequency As Object = dOutbreakParameters.FindControl("ens" + strUniqueId + "CaseMonitoringFrequency")
                    Dim objTracingDuration As Object = dOutbreakParameters.FindControl("ens" + strUniqueId + "ContactTracingDuration")
                    Dim objTracingFrequency As Object = dOutbreakParameters.FindControl("ens" + strUniqueId + "ContactTracingFrequency")
                    Dim iSpeciesType = 0

                    Select Case strUniqueId
                        Case "Human"
                            iSpeciesType = OUTBREAK_HUMAN_ID
                        Case "xAvian"
                            iSpeciesType = OUTBREAK_AVIAN_ID
                        Case "Livestock"
                            iSpeciesType = OUTBREAK_LIVESTOCK_ID
                        Case "xVector"
                            iSpeciesType = OUTBREAK_VECTOR_ID
                    End Select

                    ExtractParameterTo(-1, ConversionType.ConvertLong, op.OutbreakSpeciesParameterUID)
                    ExtractParameterTo(hdnidfOutbreak.Value, ConversionType.ConvertLong, op.idfOutbreak)
                    ExtractParameterTo(iSpeciesType, ConversionType.ConvertLong, op.OutbreakSpeciesTypeID)
                    ExtractParameterTo(objCaseMonitoringDuration.Text, ConversionType.ConvertInt, op.CaseMonitoringDuration)
                    ExtractParameterTo(objMonitoringFrequency.Text, ConversionType.ConvertInt, op.CaseMonitoringFrequency)
                    ExtractParameterTo(objTracingDuration.Text, ConversionType.ConvertInt, op.ContactTracingDuration)
                    ExtractParameterTo(objTracingFrequency.Text, ConversionType.ConvertInt, op.ContactTracingFrequency)
                    ExtractParameterTo(0, ConversionType.ConvertInt, op.intRowStatus)
                    ExtractParameterTo(strAuditCreateUser, ConversionType.ConvertString, op.AuditCreateUser)
                    ExtractParameterTo(Date.Today, ConversionType.ConvertDate, op.AuditCreateDTM)
                    ExtractParameterTo("", ConversionType.ConvertString, op.AuditUpdateUser)
                    ExtractParameterTo(Date.Today, ConversionType.ConvertDate, op.AuditUpdateDTM)

                    sessionParameters.Add(op)
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub rOutbreakSessionNotes_ItemCommand(sender As Object, e As RepeaterCommandEventArgs) Handles rOutbreakSessionNotes.ItemCommand

        Dim iOutbreakNodeId As Double = 0
        Dim ib As ImageButton = rOutbreakSessionNotes.Items(e.Item.ItemIndex).FindControl("ibDelete")

        Double.TryParse(ib.Attributes("outbreaknoteid"), iOutbreakNodeId)

        Select Case e.CommandName
            Case "Delete"
                upWarningModal.Update()

                ViewState("Action") = "DeleteAttachment"
                ViewState("CommandArgument") = iOutbreakNodeId

                ShowWarningMessage(MessageType.ConfirmDelete, True)

                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", "showUpdatesTab()", True)
            Case "Select"

                Dim parameters As OmmNoteFileParams = New OmmNoteFileParams()

                parameters.idfOutbreakNote = iOutbreakNodeId

        End Select

    End Sub

    Protected Sub AddVetSample_Click(sender As Object, e As EventArgs) Handles btnAddVetSample2.Click

        Try

            ddlVetSampleTypeID.SelectedIndex = -1
            upVetSampleTypeId.Update()

            txtVetSampleFieldId.Text = ""
            upVetSampleFieldId.Update()

            ddlSampleSpeciesID.SelectedIndex = -1
            upSampleSpeciesID.Update()

            ddlVetAnimalId.SelectedIndex = -1
            ddlVetSampleBirdStatusTypeID.SelectedIndex = -1
            BuildAnimalIDDropDownList(ddlVetAnimalId)
            upVetSampleStatus.Update()

            cidatVetSampleCollectionDate.Text = ""
            upVetSampleCollectionDate.Update()

            txtSampleCollectedByOrganizationID.Text = ""
            upSampleCollectedByOrganizationID.Update()

            txtSampleCollectedByPersonID.Text = ""
            upSampleCollectedByPersonID.Update()

            txtSampleSentToOrganizationID.Text = ""
            upSampleSentToOrganizationID.Update()

            hdfRowAction.Value = ""
            hdnSampleCollectedByOrganizationID.Value = "-1"
            hdnSampleSentToOrganizationID.Value = "-1"
            hdnSampleCollectedByPersonID.Value = "-1"

            upSample.Update()

            hdfRowAction.Value = RecordConstants.Insert

            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", "goToTab(currentTab);", True)
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#outbreakVetSample", "outbreakVetSample"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try


    End Sub

    Protected Sub AddVetLabTest_Click(sender As Object, e As EventArgs) Handles btnAddVetLabTest2.Click

        Try

            hdfRowAction.Value = RecordConstants.Insert
            ResetForm(pOutbreakVetLabTest)

            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", "goToTab(currentTab);", True)
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#outbreakVetLabTest", "outbreakVetLabTest"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub


    Protected Sub BatchAddVetSample(sender As Object, e As EventArgs) Handles btnVetSampleSave.Click

        Dim ovsl As List(Of OmmVetSample)

        Try
            ovsl = CType(Session(VET_SAMPLES), List(Of OmmVetSample))

            If (ovsl Is Nothing) Then
                ovsl = New List(Of OmmVetSample)
            End If

        Catch ex As Exception
            ovsl = New List(Of OmmVetSample)
        End Try

        Dim ovs As OmmVetSample = New OmmVetSample
        Dim iRecords As Int16 = ovsl.Count

        ovs.idfVetSample = -(iRecords + 1)

        ExtractParameterTo(ddlVetAnimalId.SelectedItem.ToString(), ConversionType.ConvertString, ovs.strAnimalID)
        ExtractParameterTo(ddlVetSampleBirdStatusTypeID.SelectedValue, ConversionType.ConvertLong, ovs.idfBirdStatusTypeID) 'Needs to be looked at again for mappiing against idfSampleStatusTypeId)
        ExtractParameterTo(ddlVetSampleBirdStatusTypeID.SelectedItem.ToString(), ConversionType.ConvertString, ovs.BirdStatus)
        ExtractParameterTo(ddlVetSampleBirdStatusTypeID.SelectedValue, ConversionType.ConvertLong, ovs.idfSampleStatusTypeId) 'Needs to be looked at again for mappiing against idfBirdStatusTypeID)
        ExtractParameterTo(hdnSampleCollectedByOrganizationID.Value, ConversionType.ConvertLong, ovs.idfCollectedByOrganizationID)
        ExtractParameterTo(txtSampleCollectedByOrganizationID.Text, ConversionType.ConvertString, ovs.CollectedByOrganization)
        ExtractParameterTo(hdnSampleCollectedByPersonID.Value, ConversionType.ConvertLong, ovs.idfCollectedByPersonID)
        ExtractParameterTo(txtSampleCollectedByPersonID.Text, ConversionType.ConvertString, ovs.CollectedByPerson)
        ExtractParameterTo(cidatVetSampleCollectionDate.Text, ConversionType.ConvertDate, ovs.datCollectionDate)
        ExtractParameterTo(ddlVetSampleTypeID.SelectedValue, ConversionType.ConvertLong, ovs.idfVetSampleTypeID)
        ExtractParameterTo(ddlVetSampleTypeID.SelectedItem.ToString(), ConversionType.ConvertString, ovs.Type)
        ExtractParameterTo(txtVetSampleFieldId.Text, ConversionType.ConvertString, ovs.FieldId)
        ExtractParameterTo(txtVetSampleFieldId.Text, ConversionType.ConvertString, ovs.strFieldSampleId)
        ExtractParameterTo(ddlSampleSpeciesID.SelectedValue, ConversionType.ConvertLong, ovs.idfSpeciesID)
        ExtractParameterTo(ddlSampleSpeciesID.SelectedItem.ToString(), ConversionType.ConvertString, ovs.Species)
        ExtractParameterTo(txtSampleSentToOrganizationID.Text, ConversionType.ConvertString, ovs.SentToOrganization)
        ExtractParameterTo(hdnSampleSentToOrganizationID.Value, ConversionType.ConvertLong, ovs.idfSentToOrganizationID)

        'Data that is not colleection. Needs to revisit mapping
        ExtractParameterTo(Date.Today, ConversionType.ConvertDate, ovs.datSentDate)
        ExtractParameterTo(Date.Today, ConversionType.ConvertDate, ovs.datEnteredDate)
        ExtractParameterTo(-1, ConversionType.ConvertLong, ovs.idfMonitoringSessionID) 'Might needs population
        ExtractParameterTo("", ConversionType.ConvertString, ovs.Comments) 'Might needs population
        'End faked data section

        ovs.intRowStatus = 0

        ovsl.Add(ovs)
        Session(VET_SAMPLES) = ovsl

        'Populate the Field Sample Dropdown in the Penside Test tab

        BuildFieldSampleIDDropDownList(ddlVetFieldSampleId)
        upVetPenSideFieldSampleId.Update()
        BuildFieldSampleIDDropDownList(ddlVetLabFieldSampleId)
        upVetLabFieldSampleId.Update()

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", "initializeSideBar_Immediate(8);", True)

        gvVetSamples.DataSource = ovsl
        gvVetSamples.DataBind()

    End Sub


    Protected Sub BatchAddVetLabTest(sender As Object, e As EventArgs)

        Dim ovltList As List(Of OmmVetLabTest)

        Try
            ovltList = CType(Session(VET_LAB_TESTS), List(Of OmmVetLabTest))

            If (ovltList Is Nothing) Then
                ovltList = New List(Of OmmVetLabTest)
            End If

        Catch ex As Exception
            ovltList = New List(Of OmmVetLabTest)
        End Try

        Dim ovlt As OmmVetLabTest = New OmmVetLabTest
        Dim iRecords As Int16 = ovltList.Count


        ovlt.idfLabTest = -(iRecords + 1)

        ExtractParameterTo(txtVetLabAnimalId.Text, ConversionType.ConvertString, ovlt.strAnimalId)
        ExtractParameterTo(ddlVetLabFieldSampleId.SelectedValue.ToString(), ConversionType.ConvertLong, ovlt.FieldSampleId)
        ExtractParameterTo(ddlVetLabResultObservation.SelectedItem.ToString(), ConversionType.ConvertLong, ovlt.idfResultObservcvation)
        ExtractParameterTo(hdnVetLabSpecies.Value.ToString(), ConversionType.ConvertLong, ovlt.idfSpecies)
        ExtractParameterTo(ddlVetLabTestCategory.SelectedValue.ToString(), ConversionType.ConvertLong, ovlt.idfTestCategory)
        ExtractParameterTo(ddlVetLabTestDisease.SelectedValue.ToString(), ConversionType.ConvertLong, ovlt.idfTestDisease)
        ExtractParameterTo(ddlVetLabTestName.SelectedValue.ToString(), ConversionType.ConvertLong, ovlt.idfTestName)
        ExtractParameterTo(txtVetLabSampleId.Text, ConversionType.ConvertString, ovlt.LabSampleId)
        ExtractParameterTo(ciVetLabdatResultDate.Text, ConversionType.ConvertDate, ovlt.ResultDate)
        ExtractParameterTo(ddlVetLabResultObservation.SelectedItem.ToString(), ConversionType.ConvertString, ovlt.ResultObservation)
        ExtractParameterTo(txtVetLabSampleType.Text, ConversionType.ConvertString, ovlt.SampleType)
        ExtractParameterTo(txtVetLabSpecies.Text, ConversionType.ConvertString, ovlt.Species)
        ExtractParameterTo(ddlVetLabTestCategory.SelectedItem.ToString(), ConversionType.ConvertString, ovlt.TestCategory)
        ExtractParameterTo(ddlVetLabTestDisease.SelectedItem.ToString(), ConversionType.ConvertString, ovlt.TestDisease)
        ExtractParameterTo(ddlVetLabTestName.SelectedItem.ToString(), ConversionType.ConvertString, ovlt.TestName)
        ExtractParameterTo(txtVetLabTestStatus.Text, ConversionType.ConvertString, ovlt.TestStatus)
        ovlt.intRowStatus = 0

        ovltList.Add(ovlt)
        Session(VET_LAB_TESTS) = ovltList

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", "initializeSideBar_Immediate(10);", True)

        gvLabTests.DataSource = ovltList
        gvLabTests.DataBind()

    End Sub

    Protected Sub btnVetAddHerd_Click(sender As Object, e As EventArgs) Handles btnVetAddHerd.Click

        'If (rblidfsCaseType.SelectedIndex <> -1) Then

        'Save all data on the page to a refresh Session for "Herds" and "Species"
        CacheHerdSpecies()

        Dim herds As List(Of OmmVetHerds)
        Dim herd As OmmVetHerds

        If Session(VET_HERDS) Is Nothing Then
            herds = New List(Of OmmVetHerds)()
        Else
            herds = CType(Session(VET_HERDS), List(Of OmmVetHerds))
        End If

        Dim idfHerdActual As Long = 0

        For Each herd In herds
            If herd.idfHerdActual < idfHerdActual Then
                idfHerdActual = herd.idfHerdActual
            End If
        Next

        herd = New OmmVetHerds
        herd.idfHerd = idfHerdActual - 1
        herd.idfHerdActual = idfHerdActual - 1
        herd.intRowStatus = 0

        'Depending on the selection of Avian or Livestock, the gridview needs to reflect either Flock or Herd
        'Also, upcoming sections will require alterations
        Dim strTerm As String = "Flock "

        If (rblidfsCaseType.SelectedValue = 10012003) Then
            strTerm = "Herd "

            txtVetSpecies.Visible = False
            txtVetAnimalId.Visible = True
        Else
            txtVetSpecies.Visible = True
            txtVetAnimalId.Visible = False
        End If

        herd.strHerdCode = strTerm & Math.Abs(herd.idfHerdActual).ToString()

        herds.Add(herd)

        Session(VET_HERDS) = herds

        gvHerds.DataSource = herds
        gvHerds.DataBind()

    End Sub


    Private Sub TallySpecies()

        Dim herds As List(Of OmmVetHerds) = CType(Session(VET_HERDS), List(Of OmmVetHerds))
        Dim speciesList As List(Of OmmVetSpecies) = CType(Session(VET_SPECIES), List(Of OmmVetSpecies))

        If Not herds Is Nothing Then

            If Not speciesList Is Nothing Then
                Dim herd As OmmVetHerds
                Dim species As OmmVetSpecies

                Dim _herds As List(Of OmmVetHerds) = New List(Of OmmVetHerds)()
                Dim _herd As OmmVetHerds = New OmmVetHerds

                For Each herd In herds

                    Dim intSick As Int16 = 0
                    Dim intDead As Int16 = 0
                    Dim intTotal As Int16 = 0

                    For Each species In speciesList.Where(Function(x) x.idfHerdActual = herd.idfHerdActual And x.intRowStatus = 0).ToList()
                        If (Not species.intSickAnimalQty Is Nothing) Then
                            intSick += species.intSickAnimalQty
                        End If

                        If (Not species.intDeadAnimalQty Is Nothing) Then
                            intDead += species.intDeadAnimalQty
                        End If

                        If (Not species.intTotalAnimalQty Is Nothing) Then
                            intTotal += species.intTotalAnimalQty
                        End If
                    Next

                    herd.intSickAnimalQty = intSick
                    herd.intDeadAnimalQty = intDead
                    herd.intTotalAnimalQty = intTotal
                    herd.intRowStatus = 0

                    _herds.Add(herd)

                Next

                Session(VET_HERDS) = _herds
            End If
        End If

    End Sub

    Protected Sub gvHerds_ItemCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvHerds.RowCommand

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "", "lockNumericSpinnerButtons()", True)

        CacheHerdSpecies()

        Dim speciesList As List(Of OmmVetSpecies)
        Dim species As OmmVetSpecies

        If Session(VET_SPECIES) Is Nothing Then
            speciesList = New List(Of OmmVetSpecies)()
        Else
            speciesList = CType(Session(VET_SPECIES), List(Of OmmVetSpecies))
        End If

        Dim idfSpeciesActual As Int16 = speciesList.Count

        species = New OmmVetSpecies
        species.idfSpecies = -(idfSpeciesActual) - 1
        species.idfSpeciesActual = -(idfSpeciesActual) - 1
        species.idfHerdActual = CType(e.CommandArgument.ToString().Split("|")(0), Long)
        species.idfHerd = CType(e.CommandArgument.ToString().Split("|")(1), Long)
        species.intRowStatus = 0
        speciesList.Add(species)

        Session(VET_SPECIES) = speciesList

        GenerateVCIInformation()

        gvHerds.DataSource = CType(Session(VET_HERDS), List(Of OmmVetHerds))
        gvHerds.DataBind()

        gvClinicalInvestigations.DataSource = CType(Session(VET_CLINICAL_INFORMATION), List(Of OmmVetClinicalInformation))
        gvClinicalInvestigations.DataBind()

    End Sub

    Protected Sub gvClinicalInvestigations_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvClinicalInvestigations.RowDataBound

        Dim ddlClinicalStatus As DropDownList = CType(e.Row.FindControl("ddlClinicalStatus"), DropDownList)
        Dim rblClinicalInvestigationPerformed As RadioButtonList = CType(e.Row.FindControl("rblClinicalInvestigationPerformed"), RadioButtonList)

        BaseReferenceLookUp(ddlClinicalStatus, BaseReferenceConstants.OutbreakCaseStatus, HACodeList.AllHACode, True)

    End Sub

    Protected Sub gvVaccinations_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvVaccinations.RowDataBound

        Dim test As String

        'e.Row.DataItem()
        'gvOutbreaks.HeaderRow.Cells(0).Text = GetLocalResourceObject("Grd_Outbreak_List_Outbreak_ID_Heading")

    End Sub



    Protected Sub gvSpecies_RowCommand(sender As Object, e As GridViewCommandEventArgs)

        UpdateHerdSpecies(Nothing, Nothing)

    End Sub

    Private Sub UpdateHerdSpecies(sender As Object, e As EventArgs) Handles btnVetUpdateSpecies.Click

        CacheHerdSpecies()
        GenerateVCIInformation()

        gvHerds.DataSource = CType(Session(VET_HERDS), List(Of OmmVetHerds))
        gvHerds.DataBind()

    End Sub

    Private Sub GenerateVCIInformation()

        Dim vciList As List(Of OmmVetClinicalInformation) = New List(Of OmmVetClinicalInformation)()
        Dim vci As OmmVetClinicalInformation
        Dim speciesList As List(Of OmmVetSpecies) = CType(Session(VET_SPECIES), List(Of OmmVetSpecies))
        Dim species As OmmVetSpecies

        Dim nvcSpeciesType As NameValueCollection = New NameValueCollection
        Dim nvcHerdCode As NameValueCollection = New NameValueCollection

        For Each gvHerdRow As GridViewRow In gvHerds.Rows
            Dim gvSpecies As GridView = CType(gvHerdRow.FindControl("gvSpecies"), GridView)
            For Each gvSpeciesRow In gvSpecies.Rows
                Dim ddlVetSpeciesType As DropDownList = CType(gvSpeciesRow.FindControl("ddlVetSpeciesType"), DropDownList)
                If (Not ddlVetSpeciesType.SelectedValue Is Nothing) Then
                    nvcSpeciesType.Add(ddlVetSpeciesType.SelectedValue, ddlVetSpeciesType.SelectedItem.Text)
                End If
            Next
        Next

        For Each gvHerdRow As GridViewRow In gvHerds.Rows
            Dim txtstrHerdCode As WebControls.Label = CType(gvHerdRow.FindControl("txtstrHerdCode"), WebControls.Label)
            Dim idfHerdActual As HiddenField = CType(gvHerdRow.FindControl("idfHerdActual"), HiddenField)
            nvcHerdCode.Add(idfHerdActual.Value, txtstrHerdCode.Text)
        Next

        Dim idfSpeciesActual As Long = 0
        Dim idfsClinical As Integer = 0

        If (Not speciesList Is Nothing) Then
            For Each species In speciesList
                If species.idfSpeciesActual < idfSpeciesActual Then
                    idfSpeciesActual = species.idfSpeciesActual
                End If

                If (Not species.idfsSpeciesType Is Nothing) Then
                    idfsClinical = idfsClinical - 1
                    vci = New OmmVetClinicalInformation

                    Try
                        vci.Herd = nvcHerdCode.Item(species.idfHerdActual.ToString()).ToString()
                    Catch ex As Exception

                    End Try

                    vci.idfHerdActual = species.idfHerdActual
                    If (Not species.idfHerd Is Nothing) Then
                        vci.idfHerd = species.idfHerd
                    End If

                    Try
                        vci.SpeciesType = nvcSpeciesType.Item(species.idfsSpeciesType.ToString()).ToString()
                    Catch ex As Exception

                    End Try

                    vci.idfsClinical = idfsClinical
                    vci.idfsSpeciesType = species.idfSpecies
                    vci.langId = GetCurrentCountry()

                    vciList.Add(vci)
                End If
            Next
        End If

        Session(VET_CLINICAL_INFORMATION) = vciList

        gvClinicalInvestigations.DataSource = CType(Session(VET_CLINICAL_INFORMATION), List(Of OmmVetClinicalInformation))
        gvClinicalInvestigations.DataBind()


        BuildHerdDropDownList(ddlVCIHerdID)
        ddlVCIHerdID.DataBind()

        BuildSpeciesDropDownList(ddlVCISpecies)
        upAnimalinvestigationHerdSpecies.Update()

        BuildSpeciesDropDownList(ddlVetVaccinationSpecies)
        BuildSpeciesDropDownList(ddlSampleSpeciesID)

    End Sub

    Private Sub BuildHerdDropDownList(ddl As DropDownList)

        Dim list As List(Of OmmVetClinicalInformation) = CType(Session(VET_CLINICAL_INFORMATION), List(Of OmmVetClinicalInformation))

        If Not list Is Nothing Then
            Dim i As OmmVetClinicalInformation
            Dim li As ListItem = New ListItem

            li.Text = ""
            li.Value = "0"

            ddl.Items.Clear()
            ddl.Items.Add(li)

            For Each i In list

                If (i.Herd <> "") Then
                    li = New ListItem

                    li.Text = i.Herd
                    li.Value = i.idfHerdActual

                    If ddl.Items.FindByText(i.Herd) Is Nothing Then
                        ddl.Items.Add(li)
                    End If
                End If
            Next
        End If

    End Sub

    Private Sub BuildSpeciesDropDownList(ddl As DropDownList)

        Dim list As List(Of OmmVetClinicalInformation) = CType(Session(VET_CLINICAL_INFORMATION), List(Of OmmVetClinicalInformation))

        If Not list Is Nothing Then
            Dim i As OmmVetClinicalInformation
            Dim li As ListItem = New ListItem

            li.Text = ""
            li.Value = "0"

            ddl.Items.Clear()
            ddl.Items.Add(li)

            For Each i In list

                If (i.SpeciesType <> "") Then
                    li = New ListItem

                    li.Text = i.SpeciesType
                    li.Value = i.idfsSpeciesType

                    ddl.Items.Add(li)
                End If
            Next
        End If

    End Sub

    Private Sub BuildAnimalIDDropDownList(ddl As DropDownList)

        Dim list As List(Of OmmVetAnimalInvestigation) = CType(Session(VET_ANIMAL_INVESTIGATIONS), List(Of OmmVetAnimalInvestigation))

        If Not list Is Nothing Then
            Dim i As OmmVetAnimalInvestigation
            Dim li As ListItem = New ListItem

            li.Text = ""
            li.Value = "0"

            ddl.Items.Clear()
            ddl.Items.Add(li)

            For Each i In list
                li = New ListItem
                li.Text = i.strAnimalId
                li.Value = i.AnimalId

                ddl.Items.Add(li)
            Next
        End If

    End Sub

    Private Sub BuildFieldSampleIDDropDownList(ddl As DropDownList)

        Dim list As List(Of OmmVetSample) = CType(Session(VET_SAMPLES), List(Of OmmVetSample))

        If Not list Is Nothing Then
            Dim i As OmmVetSample
            Dim li As ListItem = New ListItem

            li.Text = ""
            li.Value = "0"

            ddl.Items.Clear()
            ddl.Items.Add(li)

            For Each i In list
                li = New ListItem
                li.Text = i.FieldId
                li.Value = i.FieldId

                ddl.Items.Add(li)
            Next
        End If

    End Sub

    'Private Sub ShowSuccessMessage(message As MessageType)

    'Select Case message
    '    Case MessageType.DeleteSuccess
    '        successHeading.InnerText = GetLocalResourceObject("Hdg_Delete_Success_Message")
    '        successBody.InnerText = GetLocalResourceObject("Lbl_Message_Delete_Success")
    '        btnReturnToCampaignRecord.Visible = False
    '    Case MessageType.AddUpdateSuccess
    '        successHeading.InnerText = GetLocalResourceObject("Hdg_Add_Update_Success_Message")
    '        successBody.InnerText = GetLocalResourceObject("Lbl_Message_Add_Update_Success")
    'End Select

    'ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & divSuccessModalContainer.ClientID & "').modal('show');});", True)

    'End Sub

    Private Sub ShowWarningMessage(message As MessageType, bIsConfirm As Boolean)

        Select Case message
            Case MessageType.DuplicateSpeciesAndSample
                warningHeading.InnerText = GetLocalResourceObject("Warning_Message_Alert").ToString()
                warningSubTitle.InnerText = GetLocalResourceObject("Warning_Message_Duplicate_Record_SubHeading").ToString()
                warningBody.InnerText = GetLocalResourceObject("Warning_Message_Duplicate_Record_Body_Text").ToString()
            Case MessageType.CannotDelete
                warningHeading.InnerText = GetLocalResourceObject("Warning_Message_Alert").ToString()
                warningSubTitle.InnerText = GetLocalResourceObject("Warning_Message_Has_Sessions_SubHeading").ToString()
                warningBody.InnerText = GetLocalResourceObject("Warning_Message_Has_Sessions_Body_Text").ToString()
            Case MessageType.CancelConfirm
                warningHeading.InnerText = GetLocalResourceObject("Warning_Message_Alert").ToString()
                warningBody.InnerText = GetLocalResourceObject("Warning_Message_Cancel_Confirm").ToString()
            Case MessageType.CampaignStatusOpenNew
                warningHeading.InnerText = GetLocalResourceObject("Warning_Message_Alert").ToString()
                warningBody.InnerText = GetLocalResourceObject("Status_Open_New").ToString()
            Case MessageType.CampaignStatusOpenClosed
                warningHeading.InnerText = GetLocalResourceObject("Warning_Message_Alert").ToString()
                warningBody.InnerText = GetLocalResourceObject("Success_Message_Delete").ToString()
            Case MessageType.CannotGetValidatorSection
                warningHeading.InnerText = GetLocalResourceObject("Warning_Message_Alert").ToString()
                warningBody.InnerText = GetLocalResourceObject("Warning_Message_Validator_Section_Body_Text").ToString()
            Case MessageType.UnhandledException
                warningHeading.InnerText = GetLocalResourceObject("Warning_Message_ALert").ToString()
                warningBody.InnerText = GetLocalResourceObject("Warning_Message_Unhandled_Exception_Body_Text").ToString()
            Case MessageType.ConfirmDelete
                warningHeading.InnerText = GetLocalResourceObject("Warning_Message_ALert").ToString()
                warningBody.InnerText = GetLocalResourceObject("Confirm_Delete_Message").ToString()
            Case MessageType.ConfirmClose
                warningHeading.InnerText = GetLocalResourceObject("Warning_Message_ALert").ToString()
                warningBody.InnerText = GetLocalResourceObject("Confirm_Close_Message").ToString()
        End Select

        If bIsConfirm Then
            dWarningYesNoContainer.Visible = True
        Else
            dWarningYesNoContainer.Visible = False
        End If

        upWarningModal.Update()

        ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "Modal", "$(function(){ $('#" & dWarningModalContainer.ClientID & "').modal('show');});", True)

    End Sub

    Protected Sub gvOutbreaks_PageIndexChanging(sender As Object, e As GridViewPageEventArgs) Handles gvOutbreaks.PageIndexChanging

        Try
            gvOutbreaks.PageIndex = e.NewPageIndex

            FillOutbreakList(pageIndex:=1, paginationSetNumber:=Int16.Parse(ViewState(PAGINATION_SET_NUMBER)), sGetDataFor:="PAGE")
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    'Protected Sub LocationUserControl_ItemSelected(ID As String) Handles lucCaseLocation.ItemSelected

    '    Select Case ID
    '        Case "lucCaseLocation"
    '            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "", "returnToTab();", True)

    '        Case Else

    '    End Select

    'End Sub

    'Protected Sub lucCaseLocation_Change(sender As Object, e As EventArgs)
#Region "Gridview Row Commands"
    Protected Sub gvOutbreaks_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvOutbreaks.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    DeleteMonitoringSession(CType(e.CommandArgument, Double))
                Case GridViewCommandConstants.SelectCommand
                    e.Handled = True
                    SelectOutbreakSession(CType(e.CommandArgument, Long))
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditOutbreakSession(CType(e.CommandArgument, Long))
            End Select
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub gvOutbreakCases_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvOutbreakCases.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    'DeleteOutbreakCase(CType(e.CommandArgument, Double))
                Case GridViewCommandConstants.SelectCommand
                    e.Handled = True
                    'SelectOutbreakCase(CType(e.CommandArgument, Double))
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True

                    Dim idfVetCase As String = e.CommandSource.Attributes("idfVetCase").ToString()
                    Dim idfHumanCase As String = e.CommandSource.Attributes("idfHumanCase").ToString()

                    If idfVetCase <> "" Then
                        EditVeterinaryDiseaseReport(CType(e.CommandArgument, Double))
                    End If

                    If idfHumanCase <> "" Then
                        EditHumanDiseaseReport(CType(e.CommandArgument, Double))
                    End If
            End Select
        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)

        End Try

    End Sub

    Protected Sub gvContacts_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvContacts.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    'DeleteOutbreakCase(CType(e.CommandArgument, Double))
                Case GridViewCommandConstants.SelectCommand
                    e.Handled = True
                    'SelectOutbreakCase(CType(e.CommandArgument, Double))
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    EditCaseContact(CType(e.CommandArgument, Double))
            End Select
        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)

        End Try

    End Sub

    Protected Sub gvVaccinations_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvVaccinations.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    'DeleteCaseVaccination(CType(e.CommandArgument, Double))
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    'EditCaseVaccination(CType(e.CommandArgument, Double))
                Case GridViewCommandConstants.UpdateCommand
                    e.Handled = True
                    'AddCaseVaccinationn()
            End Select
        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)

        End Try

    End Sub

    Protected Sub gvHerds_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvHerds.RowCommand

        Try
            Select Case e.CommandName
                Case GridViewCommandConstants.DeleteCommand
                    e.Handled = True
                    'DeleteCaseVaccination(CType(e.CommandArgument, Double))
                Case GridViewCommandConstants.EditCommand
                    e.Handled = True
                    'EditCaseVaccination(CType(e.CommandArgument, Double))
                Case GridViewCommandConstants.UpdateCommand
                    e.Handled = True
                    'AddCaseVaccinationn()
                Case GridViewCommandConstants.UpdateCommand
            End Select
        Catch ex As Exception

            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)

        End Try

    End Sub

#End Region

    Protected Sub gvOutbreaks_DataBound(sender As Object, e As EventArgs) Handles gvOutbreaks.DataBound

        Try
            'A problem showed up that I can't explain with populating the header row for the Linkbutton
            'Add the text during run time
            gvOutbreaks.HeaderRow.Cells(0).Text = GetLocalResourceObject("Grd_Outbreak_List_Outbreak_ID_Heading")
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub gvHerds_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvHerds.RowDataBound
        Try

            If e.Row.RowType = DataControlRowType.Header Then
                'Due to Avian or Livestock selection, the language resource object must be appropriately changed for the first column of the gridview
                Dim lbl As WebControls.Label = CType(e.Row.FindControl("lblVetHerdCode"), WebControls.Label)
                If (rblidfsCaseType.SelectedValue = 10012003) Then
                    lbl.Text = GetLocalResourceObject("Grd_Outbreak_Herd_Code_Heading")
                Else
                    lbl.Text = GetLocalResourceObject("Grd_Outbreak_Flock_Code_Heading")
                End If
            Else
                If e.Row.RowType = DataControlRowType.DataRow Then

                    Dim speciesList As List(Of OmmVetSpecies) = CType(Session(VET_SPECIES), List(Of OmmVetSpecies))

                    If Not speciesList Is Nothing Then

                        Dim gvSpecies As GridView = CType(e.Row.FindControl("gvSpecies"), GridView)

                        gvSpecies.DataSource = speciesList.Where(Function(x) x.idfHerdActual = e.Row.DataItem.idfHerdActual).ToList()
                        gvSpecies.DataBind()

                    End If
                End If

            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub gvSpecies_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        Try

            If e.Row.RowType = DataControlRowType.Header Then

            Else
                If e.Row.RowType = DataControlRowType.DataRow Then

                    Dim ddlVetSpeciesType As DropDownList = CType(e.Row.FindControl("ddlVetSpeciesType"), DropDownList)

                    Select Case rblidfsCaseType.SelectedValue
                        Case 10012003
                            BaseReferenceLookUp(ddlVetSpeciesType, BaseReferenceConstants.SpeciesList, HACodeList.LivestockHACode, True)
                        Case 10012004
                            BaseReferenceLookUp(ddlVetSpeciesType, BaseReferenceConstants.SpeciesList, HACodeList.AvianHACode, True)
                    End Select

                    Dim datStartOfSignsDate As CalendarInput = CType(e.Row.FindControl("datStartOfSignsDate"), CalendarInput)

                    ScriptManager.RegisterClientScriptBlock(Me, Page.GetType(), "calendarScript" + datStartOfSignsDate.ClientID, datStartOfSignsDate.WritejQueryCalendar(), True)
                    'datStartOfSignsDate.Text = String.Empty

                    ddlVetSpeciesType.SelectedValue = e.Row.DataItem.idfsSpeciesType
                End If

            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnSaveHerdSpecies_Click(sender As Object, e As EventArgs) 'Handles btnSaveHerdSpecies.Click

        CacheHerdSpecies()
        SaveHerdSpecies()

    End Sub

    Protected Sub CacheHerdSpecies()

        Dim herds As List(Of OmmVetHerds) = New List(Of OmmVetHerds)()
        Dim herd As OmmVetHerds
        Dim speciesList As List(Of OmmVetSpecies) = New List(Of OmmVetSpecies)()
        Dim species As OmmVetSpecies

        For Each row As GridViewRow In gvHerds.Rows

            Dim txtstrHerdCode As WebControls.Label = CType(row.FindControl("txtstrHerdCode"), WebControls.Label)
            Dim idfHerdActual As HiddenField = CType(row.FindControl("idfHerdActual"), HiddenField)
            Dim idfHerd As HiddenField = CType(row.FindControl("idfHerd"), HiddenField)
            Dim gvSpecies As GridView = CType(row.FindControl("gvSpecies"), GridView)

            herd = New OmmVetHerds

            herd.idfHerdActual = idfHerdActual.Value
            herd.idfHerd = idfHerd.Value
            herd.strHerdCode = txtstrHerdCode.Text

            herds.Add(herd)

            If Not gvSpecies Is Nothing Then

                For Each speciesRow As GridViewRow In gvSpecies.Rows

                    Dim idfSpeciesActual As HiddenField = CType(speciesRow.FindControl("idfSpeciesActual"), HiddenField)
                    Dim idfSpecies As HiddenField = CType(speciesRow.FindControl("idfSpecies"), HiddenField)
                    Dim ddlVetSpeciesType As DropDownList = CType(speciesRow.FindControl("ddlVetSpeciesType"), WebControls.DropDownList)
                    Dim intDeadAnimalQty As WebControls.TextBox = CType(speciesRow.FindControl("intDeadAnimalQty"), WebControls.TextBox)
                    Dim intSickAnimalQty As WebControls.TextBox = CType(speciesRow.FindControl("intSickAnimalQty"), WebControls.TextBox)
                    Dim intTotalAnimalQty As WebControls.TextBox = CType(speciesRow.FindControl("intTotalAnimalQty"), WebControls.TextBox)
                    Dim datStartOfSignsDate As CalendarInput = CType(speciesRow.FindControl("datStartOfSignsDate"), CalendarInput)
                    Dim strNote As WebControls.TextBox = CType(speciesRow.FindControl("strNote"), WebControls.TextBox)

                    species = New OmmVetSpecies

                    species.idfHerd = idfHerd.Value
                    species.idfHerdActual = idfHerdActual.Value
                    species.idfSpeciesActual = idfSpeciesActual.Value
                    species.idfSpecies = idfSpecies.Value

                    ExtractParameterTo(ddlVetSpeciesType.SelectedValue, ConversionType.ConvertLong, species.idfsSpeciesType)
                    ExtractParameterTo(intDeadAnimalQty.Text, ConversionType.ConvertInt, species.intDeadAnimalQty)
                    ExtractParameterTo(intSickAnimalQty.Text, ConversionType.ConvertInt, species.intSickAnimalQty)
                    ExtractParameterTo(intTotalAnimalQty.Text, ConversionType.ConvertInt, species.intTotalAnimalQty)
                    ExtractParameterTo(datStartOfSignsDate.Text, ConversionType.ConvertDate, species.datStartOfSignsDate)

                    Dim _speciesList As List(Of OmmVetSpecies) = CType(Session(VET_SPECIES), List(Of OmmVetSpecies))
                    Dim _species As OmmVetSpecies = _speciesList.Where(Function(x) x.idfSpeciesActual = idfSpeciesActual.Value)(0)

                    species.intRowStatus = _species.intRowStatus
                    species.strNote = strNote.Text

                    speciesList.Add(species)
                Next
            End If
        Next

        If herds.Count > 0 Then
            Session(VET_HERDS) = herds
        End If

        If speciesList.Count > 0 Then
            Session(VET_SPECIES) = speciesList
        End If

        TallySpecies()

    End Sub

    Private Sub SaveHerdSpecies()

        'Dim parameters As OmmHerdSpeciesSetParams = New OmmHerdSpeciesSetParams()

        'parameters.langId = GetCurrentCountry()
        'parameters.idfFarmActual = CType(hdfidfFarmActual.Value, Long)
        'parameters.Herds = CType(Session(VET_HERDS), List(Of OmmVetHerds))
        'parameters.Species = CType(Session(VET_SPECIES), List(Of OmmVetSpecies))

        'Dim result As List(Of OmmHerdSpeciesSetModel) = OutbreakAPIService.OmmHerdSpeciesSetAsync(parameters).Result

    End Sub

    Protected Sub ItemNoteBinding_OnDataBinding(sender As Object, e As EventArgs)
        Try

            Dim iRecordPersonId As Double = 0
            Dim hl As HyperLink

            Select Case sender.Id
                Case "hlView"
                    hl = CType(sender, HyperLink)
                    Double.TryParse(hl.Attributes.Item("CommandArgument"), iRecordPersonId)
                    If (hl.Text <> "") Then
                        hl.Text = GetLocalResourceObject("hl_Outbreak_Note_View_File").ToString()
                    End If

                Case "hlDownload"
                    hl = CType(sender, HyperLink)
                    Double.TryParse(hl.Attributes.Item("CommandArgument"), iRecordPersonId)
                    If (hl.Text <> "") Then
                        hl.Text = GetLocalResourceObject("hl_Outbreak_Note_Download_File").ToString()
                    End If
                Case Else
                    Double.TryParse(sender.CommandArgument.ToString(), iRecordPersonId)
            End Select

            'Business rule to keep records updatable by the creator only.
            If (iRecordPersonId <> CType(hdfidfPersonEnteredBy.Value, Double)) Then
                sender.Parent.FindControl("ibDelete").Visible = False
            End If

            If (sender.Id = "hlView" Or sender.Id = "hlDownload") Then
                If (sender.Text.ToString() = "") Then
                    sender.Parent.FindControl("ibDelete").Visible = False
                End If
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub Species_OnDataBinding(sender As Object, e As GridViewRowEventArgs)

        Try
            If e.Row.RowType = DataControlRowType.Header Then
            Else
                If e.Row.RowType = DataControlRowType.DataRow Then

                    Dim herds = CType(Session(VET_HERDS), List(Of OmmVetHerds))
                    Dim species = CType(Session(VET_SPECIES), List(Of OmmVetSpecies))

                    Dim herdSpecies As OmmVetSpecies = TryCast(e.Row.DataItem, OmmVetSpecies)

                    Dim ddlSpeciesType As DropDownList = CType(e.Row.FindControl("idfsSpeciesType"), DropDownList)

                    'FillBaseReferenceDropDownList(ddlSpeciesType, BaseReferenceConstants.AvianFarmType, HACodeList.Avian, True)
                End If
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    'Protected Sub lbFile_Click(sender As Object, e As EventArgs)

    'Obtain parameters for the session and populate them for edit
    'Dim sessionParameters As List(Of OmmSessionParametersGetListModel) = New List(Of OmmSessionParametersGetListModel)()
    'Dim paramsForList = New OmmSessionParametersGetListParams With {
    '                .langId = GetCurrentLanguage(),
    '                .idfOutbreak = dOutbreakID
    '            }

    'sessionParameters = OutbreakAPIService.OmmSessionParametersGetListAsync(paramsForList).Result

    'Response.AddHeader("Content-Type", "application/x-rar-compressed")
    ''Set the name of the file, if you don't set it browsers will use the name of this page which you don't want
    'Response.AddHeader("Content-Disposition", "inline; filename=YourFilenameHere.rar")
    ''Optional but nice, set the length so users get a progress bar
    'Response.AddHeader("Content-Length", Bytes.Count.ToString())
    ''Push the bytes out raw
    'Response.BinaryWrite(Bytes)

    'End Sub

    Protected Sub VetTypeOfCase_OnSelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            Select Case rblidfsCaseType.SelectedValue
                Case "10012003"
                    FillBaseReferenceDropDownList(ddlVetSampleTypeID, BaseReferenceConstants.SampleType, HACodeList.LivestockHACode, True)
                    FillBaseReferenceDropDownList(ddlVetTestName, BaseReferenceConstants.PensideTestName, HACodeList.LivestockHACode, True)
                    FillBaseReferenceDropDownList(ddlVetResult, BaseReferenceConstants.PensideTestResult, HACodeList.LivestockHACode, True)

                    FillBaseReferenceDropDownList(ddlVetLabTestCategory, BaseReferenceConstants.TestCategory, HACodeList.LivestockHACode, True)
                    FillBaseReferenceDropDownList(ddlVetLabTestName, BaseReferenceConstants.TestName, HACodeList.LivestockHACode, True)
                    FillBaseReferenceDropDownList(ddlVetLabTestDisease, BaseReferenceConstants.DiagnosesGroups, HACodeList.LivestockHACode, True)
                    FillBaseReferenceDropDownList(ddlVetLabResultObservation, BaseReferenceConstants.TestResult, HACodeList.LivestockHACode, True)

                    ffOutbreakAnimalInvestigation.FormType = 10034505
                    ffOutbreakAnimalInvestigation.LegendHeader = "Outbreak Livestock Case CM"
                    ffOutbreakAnimalInvestigation.DiagnosisID = 784580000000
                    upOutbreakAnimalInvestigation.Update()

                    'TODO: Doug will research with Vilma and update the FormType / DiagnosisID to return a TemplateID
                    'declare @p4 bigint
                    'set @p4=57978110000000
                    'exec dbo.spFFGetActualTemplate @idfsGISBaseReference=NULL,@idfsBaseReference=784230000000,@idfsFormType=10034504,@idfsFormTemplateActual=@p4 output
                    '-- call for GetActualTemplate
                    'idfsGISBaseReference = Country ID
                    'idfsBaseReference = Disease ID
                    'idfsFormtType = Form Type 

                    'FormType ID
                    '            10034504    Outbreak Human Case CM
                    '            10034505    Outbreak Livestock Case CM
                    '            10034506    Outbreak Avian Case CM
                Case "10012004"
                    FillBaseReferenceDropDownList(ddlVetSampleTypeID, BaseReferenceConstants.SampleType, HACodeList.AvianHACode, True)
                    FillBaseReferenceDropDownList(ddlVetTestName, BaseReferenceConstants.PensideTestName, HACodeList.AvianHACode, True)
                    FillBaseReferenceDropDownList(ddlVetResult, BaseReferenceConstants.PensideTestResult, HACodeList.AvianHACode, True)

                    FillBaseReferenceDropDownList(ddlVetLabTestCategory, BaseReferenceConstants.TestCategory, HACodeList.AvianHACode, True)
                    FillBaseReferenceDropDownList(ddlVetLabTestName, BaseReferenceConstants.TestName, HACodeList.AvianHACode, True)
                    FillBaseReferenceDropDownList(ddlVetLabTestDisease, BaseReferenceConstants.DiagnosesGroups, HACodeList.AvianHACode, True)
                    FillBaseReferenceDropDownList(ddlVetLabResultObservation, BaseReferenceConstants.TestResult, HACodeList.AvianHACode, True)

            End Select

            upVetLabTestDisease.Update()
            upVetLabTestName.Update()
            upVetLabTestCategory.Update()
            upVetSampleTypeId.Update()
            upVetLabResultObservation.Update()

            'Select specifc areas for visibility
            pLivestockSampleStatus.Visible = rblidfsCaseType.SelectedValue = 10012003 'Samples pop-up Dropdown list
            pAvianSampleStatus.Visible = rblidfsCaseType.SelectedValue = 10012004 'Samples pop-up Dropdown list
            upVetSampleStatus.Update()

            dVetAnimalInvestigation.Visible = rblidfsCaseType.SelectedValue = 10012003 'Set visibility of the 'Animal Investigation' on the 'Clinical Information' tab.

            lb2VetSpecies.Visible = rblidfsCaseType.SelectedValue = 10012004
            txtVetSpecies.Visible = rblidfsCaseType.SelectedValue = 10012004
            lb2VetAnimalId.Visible = rblidfsCaseType.SelectedValue = 10012003
            txtVetAnimalId.Visible = rblidfsCaseType.SelectedValue = 10012003

            btnVetAddHerd.Visible = True
            btnVetUpdateSpecies.Visible = True

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub VetLabTestsConducted_OnSelectedIndexChanged(sender As Object, e As EventArgs)

        Try

            Select Case sender.SelectedValue
                Case "10012003"
                    FillBaseReferenceDropDownList(ddlVetSampleTypeID, BaseReferenceConstants.SampleType, HACodeList.LivestockHACode, True)
                    FillBaseReferenceDropDownList(ddlVetTestName, BaseReferenceConstants.PensideTestName, HACodeList.LivestockHACode, True)
                    FillBaseReferenceDropDownList(ddlVetResult, BaseReferenceConstants.PensideTestResult, HACodeList.LivestockHACode, True)

                Case "10012004"
                    FillBaseReferenceDropDownList(ddlVetSampleTypeID, BaseReferenceConstants.SampleType, HACodeList.AvianHACode, True)
                    FillBaseReferenceDropDownList(ddlVetTestName, BaseReferenceConstants.PensideTestName, HACodeList.AvianHACode, True)
                    FillBaseReferenceDropDownList(ddlVetResult, BaseReferenceConstants.PensideTestResult, HACodeList.AvianHACode, True)

            End Select

            upVetSampleTypeId.Update()

            'Select specifc areas for visibility
            pLivestockSampleStatus.Visible = rblidfsCaseType.SelectedValue = 10012003 'Samples pop-up Dropdown list
            pAvianSampleStatus.Visible = rblidfsCaseType.SelectedValue = 10012004 'Samples pop-up Dropdown list
            upVetSampleStatus.Update()

            dVetAnimalInvestigation.Visible = rblidfsCaseType.SelectedValue = 10012003 'Set visibility of the 'Animal Investigation' on the 'Clinical Information' tab.

            lb2VetSpecies.Visible = rblidfsCaseType.SelectedValue = 10012004
            txtVetSpecies.Visible = rblidfsCaseType.SelectedValue = 10012004
            lb2VetAnimalId.Visible = rblidfsCaseType.SelectedValue = 10012003
            txtVetAnimalId.Visible = rblidfsCaseType.SelectedValue = 10012003

            btnVetAddHerd.Visible = True
            btnVetUpdateSpecies.Visible = True

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub ddlVetVaccinationDiseaseName_Selected(sender As Object, e As EventArgs) Handles ddlVetVaccinationDiseaseName.SelectedIndexChanged

        If (ddlVetVaccinationDiseaseName.SelectedIndex <> -1) Then
            ciVetVaccinationDate.Text = Date.Today.ToString()
        End If

    End Sub

    Protected Sub VetClinicalInvestigationPerformed(sender As Object, e As EventArgs)

        Dim ff As FlexFormLoadTemplate = New FlexFormLoadTemplate
        Dim iRows As Integer = gvClinicalInvestigations.Rows.Count
        Dim hd As HiddenField
        Dim iRow As Integer = 0

        For Each gv As GridViewRow In gvClinicalInvestigations.Rows
            hd = gv.FindControl("hdnClinical")
            If (hd.Value = sender.Attributes("idfsClinical")) Then
                iRow = gv.RowIndex
            End If
        Next

        Select Case rblidfsCaseType.SelectedValue
            Case "10012003" ' Livestock
                ff = CType(gvClinicalInvestigations.Rows(iRow).FindControl("ffOutbreakClinicalVetCase"), FlexFormLoadTemplate)
                ff.FormType = 10034505
                ff.LegendHeader = "Outbreak Livestock Case CM"
                ff.DiagnosisID = 784580000000
            Case "10012004" 'Avian
                ff = CType(gvClinicalInvestigations.Rows(iRow).FindControl("ffOutbreakClinicalVetCase"), FlexFormLoadTemplate)
                ff.FormType = 10034506
                ff.LegendHeader = "Outbreak Avian Case CM"
                ff.DiagnosisID = 784580000000
        End Select

        Dim up As UpdatePanel = CType(gvClinicalInvestigations.Rows(0).FindControl("upOutbreakClinicalVetCase"), UpdatePanel)

        up.Update()

        'TODO: Doug will research with Vilma and update the FormType / DiagnosisID to return a TemplateID
        'declare @p4 bigint
        'set @p4=57978110000000
        'exec dbo.spFFGetActualTemplate @idfsGISBaseReference=NULL,@idfsBaseReference=784230000000,@idfsFormType=10034504,@idfsFormTemplateActual=@p4 output
        '-- call for GetActualTemplate
        'idfsGISBaseReference = Country ID
        'idfsBaseReference = Disease ID
        'idfsFormtType = Form Type 

        'FormType ID
        '            10034504    Outbreak Human Case CM
        '            10034505    Outbreak Livestock Case CM
        '            10034506    Outbreak Avian Case CM


    End Sub

    Protected Sub VetFieldSampleId_Selected(sender As Object, e As EventArgs)

        Dim ovsl As List(Of OmmVetSample)

        Try
            ovsl = CType(Session(VET_SAMPLES), List(Of OmmVetSample))

            If (ovsl Is Nothing) Then
                ovsl = New List(Of OmmVetSample)
            End If

        Catch ex As Exception
            ovsl = New List(Of OmmVetSample)
        End Try

        Dim vaiList As List(Of OmmVetAnimalInvestigation) = New List(Of OmmVetAnimalInvestigation)

        Try
            vaiList = CType(Session(VET_ANIMAL_INVESTIGATIONS), List(Of OmmVetAnimalInvestigation))

            If (vaiList Is Nothing) Then
                vaiList = New List(Of OmmVetAnimalInvestigation)
            End If

        Catch ex As Exception
            vaiList = New List(Of OmmVetAnimalInvestigation)
        End Try


        Dim control As String = sender.Id

        Select Case sender.Id.ToString()
            Case "ddlVetLabFieldSampleId"
                Select Case ddlVetLabFieldSampleId.SelectedValue.ToString()
                    Case ""
                    Case "-1"
                    Case Else
                        Dim idfsSpecies As Long = ovsl.Where(Function(x) x.FieldId = ddlVetLabFieldSampleId.SelectedValue)(0).idfSpeciesID
                        txtVetLabAnimalId.Text = vaiList.Where(Function(x) x.idfsSpeciesType = idfsSpecies)(0).strAnimalId
                        upVetLabAnimalId.Update()

                        txtVetLabSpecies.Text = vaiList.Where(Function(x) x.idfsSpeciesType = idfsSpecies)(0).SpeciesType.ToString()
                        upVetLabSpecies.Update()

                        rvVetLabResultDate.MinimumValue = ovsl.Where(Function(x) x.FieldId = ddlVetLabFieldSampleId.SelectedValue)(0).datCollectionDate
                        rvVetLabResultDate.MaximumValue = Date.Today
                        upVetLabdatResultDate.Update()
                End Select

            Case "ddlVetFieldSampleId"
                If (Not ovsl.Where(Function(x) x.FieldId = ddlVetFieldSampleId.SelectedValue)(0) Is Nothing) Then
                    txtVetSampleType.Text = ovsl.Where(Function(x) x.FieldId = ddlVetFieldSampleId.SelectedValue)(0).Type
                    txtVetAnimalId.Text = ovsl.Where(Function(x) x.FieldId = ddlVetFieldSampleId.SelectedValue)(0).strAnimalID
                    hdnVetAnimalId.Value = ovsl.Where(Function(x) x.FieldId = ddlVetFieldSampleId.SelectedValue)(0).AnimalID.ToString()
                Else
                    txtVetSampleType.Text = ""
                    txtVetAnimalId.Text = ""
                    hdnVetAnimalId.Value = "-1"
                End If

                ScriptManager.RegisterStartupScript(Page, Page.GetType(), "", "goToTab(10)", True)
        End Select

    End Sub

    Protected Sub ddlOutbreakType_Select(sender As Object, e As EventArgs) Handles ddlOutbreakTypeId.SelectedIndexChanged, sfddlOutbreakTypeID.SelectedIndexChanged

        Try
            If (ddlOutbreakTypeId.SelectedValue Is Nothing) Then
                ddlidfsDiagnosisOrDiagnosisGroup.Enabled = False
                dOutbreakHeading.Attributes.Item("style") = "display:none"
            Else
                ddlidfsDiagnosisOrDiagnosisGroup.Enabled = True
                dOutbreakHeading.Attributes.Item("style") = "display:normal"
            End If

            If (sfddlOutbreakTypeID.SelectedValue Is Nothing) Then
                sfddlSearchDiagnosesGroup.Enabled = False
            Else
                sfddlSearchDiagnosesGroup.Enabled = True
            End If

            SetSpeciesAffect()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub lnbEditNote_Click(sender As Object, e As EventArgs)

        Try
            hdfRecordAction.Value = RecordConstants.Update

            ResetForm(upOutbreakNoteForm)

            Dim iOutbreakNodeId As Long = 0
            Dim noteDetails As List(Of OmmSessionNoteGetDetailModel) = New List(Of OmmSessionNoteGetDetailModel)()

            Double.TryParse(sender.Attributes("outbreakNoteId"), iOutbreakNodeId)

            Dim parms = New OMMSessionNoteGetDetailsParams With {
                .langId = GetCurrentLanguage(),
                .idfOutbreakNote = iOutbreakNodeId
            }

            noteDetails = OutbreakAPIService.OmmSessionNoteGetDetailAsync(parms).Result
            upOutbreakNoteForm.Visible = True

            Scatter(dOutbreakNoteForm, noteDetails.FirstOrDefault(), includeLabels:=True, prefixLength:=4)
            Scatter(dOutbreakNoteForm, noteDetails.FirstOrDefault(), includeLabels:=True, prefixLength:=3)

            hdnidfOutbreakNote.Value = txtidfOutbreakNote.Text

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#dOutbreakNoteForm", "OutbreakNoteForm"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnIdSearch_Click(sender As Object, e As EventArgs) Handles btnIdSearch.ServerClick

        Try
            hdnSearchMode.Value = SearchMode.QuickSearch
            ViewState("CreateOutbreakListCache") = True
            FillOutbreakList(pageIndex:=1, paginationSetNumber:=1)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnIdSearchCase_Click(sender As Object, e As EventArgs) Handles btnIdSearchCase.ServerClick

        Try
            hdnSearchMode.Value = SearchMode.QuickSearch
            ViewState("CreateOutbreakCaseListCache") = True
            FillOutbreakCaseList()
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnContactSearch_Click(sender As Object, e As EventArgs) Handles btnContactSearch.Click

        Try
            hdnSearchMode.Value = SearchMode.QuickSearch
            ViewState("CreateContactListCache") = True
            FillOutbreakContactList()
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", "$('#nav-contacts-tab').click()", True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub chkShowTodaysFollowUps_CheckedChanged(sender As Object, e As EventArgs) Handles chkShowTodaysFollowUps.CheckedChanged

        Try
            hdnSearchMode.Value = SearchMode.TodaysFollowUps
            ViewState("CreateContactListCache") = True
            FillOutbreakContactList()
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", "$('#nav-contacts-tab').click()", True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub ddlidfsDiagnosisOrDiagnosisGroup_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)

        hdnidfsDiagnosisOrDiagnosisGroup.Value = ddlidfsDiagnosisOrDiagnosisGroup.SelectedValue

    End Sub

    Protected Sub bOutbreakHome_Click(sender As Object, e As EventArgs) Handles lbOutbreakHome.Click, lbOutbreakHome2.Click

        ToggleVisibility(SectionOutbreakManagement)

    End Sub

    Protected Sub btnCancelList_Click(sender As Object, e As EventArgs)

        ViewState("Action") = "ConfirmSearchClose"
        ShowWarningMessage(message:=MessageType.ConfirmClose, bIsConfirm:=True)

    End Sub

    Protected Sub btnAdvanceSearch_Click(sender As Object, e As EventArgs) Handles btnAdvanceSearch.ServerClick

        Try
            ToggleVisibility(SectionSearchOutbreak)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnCreate_Click(sender As Object, e As EventArgs) Handles btnAdd.Click

        Try
            SetFieldDefaults()
            ToggleVisibility(SectionCreateOutbreak)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnSaveNote_Click(sender As Object, e As EventArgs) Handles btnSaveNote.Click

        Try
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", "$('#nav-updates-tab').click()", True)

            AddUpdateNote()
            FillUpdatesList()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnSaveContact_Click(sender As Object, e As EventArgs) Handles btnSaveContact.Click

        Try
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", "$('#nav-contacts-tab').click()", True)

            UpdateContact()

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    'This click even is for the "Note" creation, which is called "Updates" on the user end.
    Protected Sub btnCreateUpdate_Click(sender As Object, e As EventArgs)

        Try
            hdfRecordAction.Value = RecordConstants.Insert
            hdnidfOutbreakNote.Value = "-1"

            upOutbreakNoteForm.Visible = True
            ResetForm(upOutbreakNoteForm)

            txtidfOutbreakNote.Text = "(new)"
            textOrganization.Text = Session("Organization").ToString()
            textUserName.Text = Session("FirstName").ToString() & " " & Session("FamilyName").ToString()
            hdfidfPerson.Value = Session("Person").ToString()

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#dOutbreakNoteForm", "OutbreakNoteForm"), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click

        ResetForm(searchForm)
        sflucSearch.DataBind()

    End Sub

    Protected Sub btnSearchList_Click(sender As Object, e As EventArgs)

        Try
            pOutbreakManagement.Visible = True
            pOutbreakManagementHeader.Visible = False
            pOutbreakManagementControls.Visible = False
            hdnSearchMode.Value = SearchMode.AdvancedSearch
            ViewState("CreateOutbreakListCache") = True
            FillOutbreakList(pageIndex:=1, paginationSetNumber:=1, sGetDataFor:="AdvancedSearch")

            ScriptManager.RegisterClientScriptBlock(Me, Me.GetType(), "", "$('#dSearchForm').collapse('hide');", True)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnSubmitOutbreak_Click(sender As Object, e As EventArgs) Handles bSubmit.Click, bQuestionnaireSubmit.Click

        'ffOutbreakCase.EnableControls(False)
        Try
            If (Page.IsValid()) Then
                ffOutbreakCase.SaveActualData()
                'Dougs ' observationID parameter = ffOutbreakCase.ObservationID
                AddUpdateOutbreak()
            Else
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Modal", "hideLoading();", True)
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub imAddContactName_ServerClick(sender As Object, e As EventArgs)

        Try
            hdnPersonSearchMode.Value = PersonFarmSearchMode.CaseManualAddContact
            ucSearchHumanDiseaseReport.Setup(selectMode:=SelectModes.Selection)
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#outbreakPersonSearch", ""), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnSubmitCaseEntry_Click(sender As Object, e As EventArgs) Handles btnSubmitCaseEntry.Click

        AddHumanDiseaseReport(DiseaseReportType.Human)

    End Sub

    Protected Sub btnVetSubmitCaseEntry_Click(sender As Object, e As EventArgs) Handles btnVetSubmitCaseEntry.Click

        AddUpdateVeterinaryhDiseaseReport()

    End Sub

    Protected Sub btnPreviousOutbreak_Click(sender As Object, e As EventArgs)

        ToggleVisibility(SectionOutbreakQuestionnaire)

    End Sub

    Protected Sub btnNextOutbreak_Click(sender As Object, e As EventArgs)

        ToggleVisibility(SectionOutbreakQuestionnaire)

    End Sub

    Protected Sub btnQuestionnaireSubmitOutbreak_Click(sender As Object, e As EventArgs)

        btnSubmitOutbreak_Click(sender, e)

    End Sub

    Protected Sub btnQuestionnaireCancelOutbreak_Click(sender As Object, e As EventArgs)

        btnCancelOutbreak_Click(sender, e)

    End Sub

    Protected Sub btnCancelOutbreak_Click(sender As Object, e As EventArgs) Handles bCancel.Click

        Try
            ToggleVisibility(SectionOutbreakSummary)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnCreateOutbreak_Click(sender As Object, e As EventArgs)

        Try
            searchResults.Visible = False
            bSubmit.Visible = False
            outbreak.Visible = True
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnNewSearch_Click(sender As Object, e As EventArgs)

        Try
            searchForm.Visible = True
            searchResults.Visible = False
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnEditSearch_Click(sender As Object, e As EventArgs)

        Try
            searchForm.Visible = True
            searchResults.Visible = False
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnEditCase_Click(sender As Object, e As EventArgs)

        Try
            searchForm.Visible = True
            searchResults.Visible = False
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnSubmit_Click(sender As Object, e As EventArgs)

        Try
            outbreak.Visible = False
            searchResults.Visible = True
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub btnAddVaccination_Click() Handles btnAddVaccination.Click

        AddBatchCaseVaccination()

    End Sub

    Protected Sub chkCase_Click(sender As Object, e As EventArgs)

        Try
            If (sender.checked) Then
                hdnOutbreakCaseReportUID.Value = sender.Attributes("value")
            End If

            If (sender.Attributes("CaseType") = "Human") Then
                lblFarmName.Visible = False
                txtFarmName.Visible = False
            End If

            FillOutbreakContactList()
        Catch ex As Exception

        End Try

    End Sub

    Protected Sub chkContact_Click(sender As Object, e As EventArgs)

        Try
            If (sender.checked) Then
                hdnOutbreakContactReportUID.Value = sender.Attributes("value")
            End If

            FillOutbreakContactList()
        Catch ex As Exception

        End Try

    End Sub

    Protected Sub OutbreakPage_Changed(ByVal sender As Object, ByVal e As EventArgs)

        Dim pageIndex As Integer = Integer.Parse(CType(sender, LinkButton).CommandArgument)

        lblOutbreakPageNumber.Text = pageIndex.ToString()

        Dim paginationSetNumber As Integer = Math.Ceiling(pageIndex / gvOutbreaks.PageSize)

        FillDropDowns()

        If Not ViewState(OUTBREAKS_PAGINATION_SET_NUMBER) = paginationSetNumber Then
            Select Case CType(sender, LinkButton).Text
                Case PagingConstants.PreviousButtonText
                    gvOutbreaks.PageIndex = gvOutbreaks.PageSize - 1
                Case PagingConstants.NextButtonText
                    gvOutbreaks.PageIndex = 0
                Case PagingConstants.FirstButtonText
                    gvOutbreaks.PageIndex = 0
                Case PagingConstants.LastButtonText
                    gvOutbreaks.PageIndex = 0
                Case Else
                    If pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) = "0" Then
                        gvOutbreaks.PageIndex = gvOutbreaks.PageSize - 1
                    Else
                        gvOutbreaks.PageIndex = pageIndex.ToString().Substring(pageIndex.ToString().Length - 1) - 1
                    End If
            End Select

            ViewState(OUTBREAKS_PAGINATION_SET_NUMBER) = paginationSetNumber
        End If

        FillOutbreakList(pageIndex, paginationSetNumber)

    End Sub

    Private Sub FillOutbreaksPager(ByVal recordCount As Integer, ByVal currentPage As Integer)

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

        rptOutbreakPager.DataSource = pages
        rptOutbreakPager.DataBind()

    End Sub

    Protected Sub rblHospitalization_SelectedIndexChanged(sender As Object, e As EventArgs) Handles rblHospitalization.SelectedIndexChanged

        Try

            pHospitalization.Visible = False

            Select Case rblHospitalization.SelectedValue
                Case YES
                    pHospitalization.Visible = True
                Case NO
                Case UNKNOWN
            End Select

            If (Not pHospitalization.Visible) Then
                ddlHospitalName.SelectedIndex = -1
                cidatDateOfHospitalization.Text = ""
                cidatDischargeDate.Text = ""
            End If

            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", "goToTab(currentTab);", True)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub rblAntibioticAntiviralTherapyAdministered_SelectedIndexChanged(sender As Object, e As EventArgs) Handles rblAntibioticAntiviralTherapyAdministered.SelectedIndexChanged

        Try

            pAntibioticAntiviralTherapy.Visible = False

            Select Case rblAntibioticAntiviralTherapyAdministered.SelectedValue
                Case YES
                    pAntibioticAntiviralTherapy.Visible = True
                Case NO
                Case UNKNOWN
            End Select

            If (Not pAntibioticAntiviralTherapy.Visible) Then
                txtAntibioticAntiviralName.Text = ""
                txtAntibioticAntiviralDose.Text = ""
                cidatAntibioticAntiviralFirstAdministered.Text = ""
            End If

            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", "goToTab(currentTab);", True)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub rblWasSpecificVaccinationAdministered_SelectedIndexChanged(sender As Object, e As EventArgs) Handles rblWasSpecificVaccinationAdministered.SelectedIndexChanged

        Try

            pVaccination.Visible = False

            Select Case rblWasSpecificVaccinationAdministered.SelectedValue
                Case YES
                    pVaccination.Visible = True

                    gvVaccinations.DataSource = ViewState("VaccinationList")
                    gvVaccinations.DataBind()
                Case NO
                Case UNKNOWN
            End Select

            If (Not pVaccination.Visible) Then
                txtstrVaccinationName.Text = ""
                cidatDateOfVaccination.Text = ""
            End If

            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", "goToTab(currentTab);", True)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub ImportCase_SelectedIndexChanged(sender As Object, e As EventArgs) Handles rblImportCase.SelectedIndexChanged

        Select Case sender.SelectedValue
            Case "Human"
                HumanImport_SelectedIndexChanged(sender, e)
            Case "Veterinary"
                VeterinaryImport_SelectedIndexChanged(sender, e)
        End Select

        rblImportCase.SelectedIndex = -1

    End Sub

    Protected Sub HumanImport_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            If (IIf(ViewState("HumanDiseaseSearchOpen") = Nothing, True, CType(ViewState("HumanDiseaseSearchOpen"), Boolean))) Then
                ucSearchHumanDiseaseReport.Setup(selectMode:=SelectModes.Selection)
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#outbreakHumanDiseaseSearch", ""), True)
            Else
                ViewState("HumanDiseaseSearchOpen") = False
            End If
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub VeterinaryImport_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            ucSearchVeterinaryDiseaseReport.Setup(selectMode:=SelectModes.Selection)
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#outbreakVeterinaryDiseaseSearch", ""), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub CreateCase_SelectedIndexChanged(sender As Object, e As EventArgs) Handles rblCreateCase.SelectedIndexChanged

        ViewState("ContactName") = sender.SelectedValue.ToString()

        Select Case sender.SelectedValue.ToString()
            Case "Human"
                ResetForm(humanDisease)
                Session(VET_VACCINATIONS) = Nothing
                Session("CaseContactList") = Nothing
                Session("CaseSampleList") = Nothing

                gvVaccinations.DataSource = Nothing
                gvCaseContacts.DataSource = Nothing
                gvCaseSamples.DataSource = Nothing

                gvVaccinations.DataBind()
                gvCaseContacts.DataBind()
                gvCaseSamples.DataBind()

                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", "goToTab(0)", True)

                hdnPersonSearchMode.Value = PersonFarmSearchMode.CaseCreation
                HumanCreate_SelectedIndexChanged(sender, e)
            Case "Veterinary"
                ResetForm(veterinaryDisease)
                'Reset app to "New" entry status
                rblidfsCaseType.SelectedIndex = -1
                btnVetAddHerd.Visible = False
                btnVetUpdateSpecies.Visible = False

                Session(VET_VACCINATIONS) = Nothing
                Session(VET_PENSIDE_TESTS) = Nothing
                Session(VET_ANIMAL_INVESTIGATIONS) = Nothing
                Session(VET_SAMPLES) = Nothing
                Session(VET_LAB_TESTS) = Nothing
                Session(VET_HERDS) = Nothing
                Session(VET_SPECIES) = Nothing

                gvHerds.DataSource = Nothing
                gvClinicalInvestigations.DataSource = Nothing
                gvAnimalInvestigation.DataSource = Nothing
                gvVetVaccinations.DataSource = Nothing
                gvVetCaseMonitoring.DataSource = Nothing
                gvVetCaseContacts.DataSource = Nothing
                gvVetSamples.DataSource = Nothing
                gvVetPensideTest.DataSource = Nothing
                gvLabTests.DataSource = Nothing
                gvTestInterpretations.DataSource = Nothing

                gvHerds.DataBind()
                gvClinicalInvestigations.DataBind()
                gvAnimalInvestigation.DataBind()
                gvVetVaccinations.DataBind()
                gvVetCaseMonitoring.DataBind()
                gvVetCaseContacts.DataBind()
                gvVetSamples.DataBind()
                gvVetPensideTest.DataBind()
                gvLabTests.DataBind()
                gvTestInterpretations.DataBind()

                VeterinaryCreate_SelectedIndexChanged(sender, e)
        End Select

        rblCreateCase.SelectedIndex = -1

    End Sub

    Protected Sub HumanCreate_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            ucSearchPerson.Setup(useHumanMasterIndicator:=True, selectMode:=SelectModes.Selection)
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#outbreakPersonSearch", ""), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub VeterinaryCreate_SelectedIndexChanged(sender As Object, e As EventArgs)

        Try
            SearchFarmUserControl.Setup(enableFarmType:=True, selectMode:=SelectModes.Selection)

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#outbreakFarmSearch", ""), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    'Protected Sub HumanContact_Click(sender As Object, e As EventArgs) Handles bAddContact.Click

    '    Try
    '        ucSearchPerson.Setup(useHumanMasterIndicator:=True, selectMode:=SelectModes.Selection)
    '        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#outbreakPersonSearch", ""), True)
    '    Catch ex As Exception
    '        Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
    '        Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
    '    End Try

    'End Sub

    Protected Sub VeterinaryContact_CheckedChange(sender As Object, e As EventArgs)

        Try
            ucSearchPerson.Setup(useHumanMasterIndicator:=False, selectMode:=SelectModes.Selection)
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#outbreakPersonSearch", ""), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub SearchPerson_Click(sender As Object, e As EventArgs)

        Try
            ViewState("ContactName") = sender.Attributes("destination")
            ucSearchPerson.Setup(useHumanMasterIndicator:=True, selectMode:=SelectModes.Selection)

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#outbreakPersonSearch", ""), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub SearchOrganization_Click(sender As Object, e As EventArgs)

        Try
            ViewState("NotificationFacility") = sender.Attributes("destination")
            ucSearchOrganizationUserControl.Setup(selectMode:=SelectModes.Selection, moduleType:=ModuleTypes.Human)

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#SearchOrganization", ""), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub AddOrganization_Click(sender As Object, e As EventArgs) 'Handles bNotificationSentByFacility.ServerClick, bNotificationReceivedByFacility.ServerClick

        Try
            ViewState("NotificationFacility") = sender.Attributes("destination")
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#AddOrganization", ""), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Protected Sub SearchEmployee_Click(sender As Object, e As EventArgs)

        Try
            ViewState("NotificationEmployee") = sender.Attributes("destination")
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#SearchEmployee", ""), True)
        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub btnWarningModalYes_Click(sender As Object, e As EventArgs) Handles btnWarningModalYes.Click

        Select Case ViewState("Action").ToString()
            Case "DeleteAttachment"
                hdnidfOutbreakNote.Value = ViewState("CommandArgument").ToString()

                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", "showUpdatesTab()", True)

                AddUpdateNote(True)
                FillUpdatesList()
                hdnidfOutbreakNote.Value = "-1"
                ViewState("ReportTab") = "Updates"
            Case "DeleteMonitoringSession"
                Dim dOutbreakId As Long = CType(hdnidfOutbreak.Value.ToString(), Long)

                OutbreakAPIService.OmmSessionDeleteAsync(dOutbreakId)
                ViewState("CreateOutbreakListCache") = True
                FillOutbreakList(pageIndex:=1, paginationSetNumber:=1)
                ToggleVisibility(SectionOutbreakManagement)

                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", "hideUpdatesModal()", True)
            Case "ConfirmSessionClose"
            Case "ConfirmSearchClose"
                ToggleVisibility(SectionOutbreakManagement)
        End Select

        ViewState("Action") = ""
        ViewState("CommandArgument") = ""

    End Sub

    Protected Sub btnWarningModalNo_Click(sender As Object, e As EventArgs) Handles btnWarningModalNo.Click

        Select Case ViewState("Action").ToString()
            Case "ConfirmSessionClose"
                EditOutbreakSession()
        End Select

        ViewState("Action") = ""
        ViewState("CommandArgument") = ""

    End Sub

    Protected Sub DeterminePossibleMessage(sender As Object, e As EventArgs)

        Try

            clidatCloseDate.Visible = False
            lblclidatCloseDate.Visible = False

            If (Not (sender.SelectedValue Is Nothing)) Then

                Select Case sender.SelectedValue
                    Case OUTBREAK_STATUS_CLOSED
                        clidatCloseDate.Visible = True
                        ViewState("Action") = "ConfirmSessionClose"
                        ShowWarningMessage(message:=MessageType.ConfirmClose, bIsConfirm:=True)
                    Case OUTBREAK_NOT_AN_OUTBREAK
                        clidatCloseDate.Visible = True
                    Case Else

                End Select

            End If

            lblclidatCloseDate.Visible = clidatCloseDate.Visible

            If (clidatCloseDate.Visible = True) Then
                clidatCloseDate.Text = Date.Today
            Else
                clidatCloseDate.Text = ""
            End If

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

#Region "Raised Events"

    'Event raised from searching via the Human Search Disease control
    Protected Sub SearchHumanDiseaseReportUserControl_SelectHumanDiseaseReport(humanDiseaseReportID As Long, eidssReportID As String, diseaseID As Long?, patientID As Long?, patientName As String) Handles ucSearchHumanDiseaseReport.SelectHumanDiseaseReport

        Dim outbreakCaseReportID As Long

        outbreakCaseReportID = ImportDiseaseReport(humanDiseaseReportID, DiseaseReportType.Human)
        ImportContacts(outbreakCaseReportID)

        ToggleVisibility(SectionOutbreakSummary)
        gvOutbreakCases.DataBind()

        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "modal", CLOSE_MODAL, True)

    End Sub

    'Event raised from searching via the Veterinary Search Disease control
    Protected Sub SearchVeterinaryDiseaseReportUserControl_SelectVeterinaryDiseaseReport(veterinaryDiseaseReportID As Long, eidssID As String, diseaseID As Long?, farmOwnerID As Long?, farmOwnerName As String) Handles ucSearchVeterinaryDiseaseReport.SelectVeterinaryDiseaseReport

        Dim outbreakCaseReportID As Long

        outbreakCaseReportID = ImportDiseaseReport(veterinaryDiseaseReportID, DiseaseReportType.Veterionary)
        ImportContacts(outbreakCaseReportID)

        ToggleVisibility(SectionOutbreakSummary)
        gvOutbreakCases.DataBind()
        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "modal", CLOSE_MODAL, True)

    End Sub

    Protected Sub CancelHumanDiseaseReport() Handles ucSearchHumanDiseaseReport.CancelHumanDiseaseReport

        outbreakSummaryAndQuestions.Visible = True
        ViewState("SearchControl") = False
        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "modal", CLOSE_MODAL, True)

    End Sub

    Protected Sub CancelVeterinaryDiseaseReport() Handles ucSearchVeterinaryDiseaseReport.CancelVeterinaryDiseaseReport

        outbreakSummaryAndQuestions.Visible = True
        ViewState("SearchControl") = False
        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "modal", CLOSE_MODAL, True)

    End Sub

    Private Sub SelectPerson(humanID As Long, eidssPersonID As String, fullName As String, firstName As String, lastName As String) Handles ucSearchPerson.SelectPerson

        Select Case ViewState("ContactName").ToString()
            Case "tx2VetContactName"
                tx2VetContactName.Text = fullName
                hdnVetContactName.Value = humanID.ToString()
            Case Else
                hdnDiseaseReport.Value = "Human"

                Dim psm As PersonFarmSearchMode = CType(hdnPersonSearchMode.Value, PersonFarmSearchMode)

                Select Case psm
                    Case PersonFarmSearchMode.CaseCreation
                        hdfidfHumanActual.Value = humanID
                        FillCaseDetails()
                        ToggleVisibility(SectionOutbreakCaseCreation)
                        lblPersonFarmEIDSSId.InnerText = GetLocalResourceObject("Lbl_Person_ID")
                    Case PersonFarmSearchMode.CaseManualAddContact
                        txtContactName.Text = fullName
                        hdfidfContactHumanActual.Value = humanID
                        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "modal", "goToTab(5)", True)
                        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", "$('#dContacts').show()", True)
                End Select
        End Select

        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "modal", CLOSE_MODAL, True)

    End Sub

    Public Sub CancelPersonSearch(messageType As MessageType, isConfirm As Boolean) Handles ucSearchPerson.ShowWarningModal

        outbreakSummaryAndQuestions.Visible = True
        ViewState("SearchControl") = False
        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "modal", CLOSE_MODAL, True)

    End Sub

    Private Sub SelectFarmRecord(farmID As Long, eidssID As String, farmName As String) Handles SearchFarmUserControl.SelectFarm

        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "modal", CLOSE_MODAL, True)

        hdnDiseaseReport.Value = "Veterinary"
        hdfidfFarmActual.Value = farmID

        Dim psm As PersonFarmSearchMode = CType(hdnPersonSearchMode.Value, PersonFarmSearchMode)

        Select Case psm
            Case PersonFarmSearchMode.CaseCreation
                ResetForm(outbreakCaseCreation)
                hdfidfFarmActual.Value = farmID
                FillCaseDetails()
                ToggleVisibility(SectionOutbreakCaseCreation)
                lblPersonFarmEIDSSId.InnerText = GetLocalResourceObject("Lbl_Farm_ID")
            Case PersonFarmSearchMode.CaseManualAddContact
                'txtContactName.Text = farmName
                'hdfidfContactHumanActual.Value = farmID
                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "modal", "goToTab(5)", True)
                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", "$('#dContacts').show()", True)
        End Select

    End Sub

    Public Sub CancelOrganizationSearch(messageType As MessageType, isConfirm As Boolean, message As String) Handles ucSearchOrganizationUserControl.ShowWarningModal

        outbreakSummaryAndQuestions.Visible = True
        ViewState("SearchControl") = False
        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "modal", CLOSE_MODAL, True)

    End Sub

    Private Sub SelectOrganizationRecord(organizationID As Long, organizationName As String) Handles ucSearchOrganizationUserControl.SelectOrganizationRecord
        Dim iTab As Int16 = 0

        Select Case ViewState("NotificationFacility").ToString()
            Case "tx2NotificationSentByFacility"
                tx2NotificationSentByFacility.Text = organizationName
                hdnNotificationSentByFacility.Value = organizationID.ToString()
                iTab = 0
            Case "txtNotificationReceivedByFacility"
                txtNotificationReceivedByFacility.Text = organizationName
                hdnNotificationReceivedByFacility.Value = organizationID.ToString()
                iTab = 0
            Case "txtstrInvestigatorOrganization"
                txtstrInvestigatorOrganization.Text = organizationName
                hdnstrInvestigatorOrganization.Value = organizationID.ToString()
                iTab = 3
            Case "txtFieldCollectedByOffice"
                txtFieldCollectedByOffice.Text = organizationName
                hdntxtFieldCollectedByOffice.Value = organizationID.ToString()
                iTab = 6
            Case "txtFieldCollectedByPerson"
                txtFieldCollectedByPerson.Text = organizationName
                hdntxtFieldCollectedByPerson.Value = organizationID.ToString()
                iTab = 6
            Case "txtSentToOrganization"
                txtSentToOrganization.Text = organizationName
                hdntxtSentToOrganization.Value = organizationID.ToString()
                iTab = 6
            Case "tx2MonitoringInvestigatorOrganization"
                tx2MonitoringInvestigatorOrganization.Text = organizationName
                hdnMonitoringInvestigatorOrganization.Value = organizationID.ToString()
                iTab = 4
            Case "txtContactName"
                txtContactName.Text = organizationName
                hdnContactName.Value = organizationID.ToString()
                iTab = 5
            Case "txtstrVetInvestigatorOrganization"
                txtstrVetInvestigatorOrganization.Text = organizationName
                hdnstrVetInvestigatorOrganization.Value = organizationID.ToString()
                iTab = 6
            Case "txtstrVetNotificationSentByFacilty"
                txtstrVetNotificationSentByFacilty.Text = organizationName
                hdnidfVetNotificationSentByFacilty.Value = organizationID.ToString()
                iTab = 1
            Case "txtstrVetNotificationSentByName"
                txtstrVetNotificationSentByName.Text = organizationName
                hdnidfVetNotificationSentByName.Value = organizationID.ToString()
                iTab = 1
            Case "txtstrVetNotificationReceivedByFacilty"
                txtstrVetNotificationReceivedByFacilty.Text = organizationName
                hdnidfVetNotificationReceivedByFacilty.Value = organizationID.ToString()
                iTab = 1
            Case "txtstrVetNotificationReceivedByName"
                txtstrVetNotificationReceivedByName.Text = organizationName
                hdnidfVetNotificationReceivedByName.Value = organizationID.ToString()
                iTab = 1
            Case "tx2VetMonitoringInvestigatorOrganization"
                tx2VetMonitoringInvestigatorOrganization.Text = organizationName
                hdnVetMonitoringInvestigatorOrganization.Value = organizationID.ToString()
                iTab = 7
            Case "tx2VetContactName"
                tx2VetContactName.Text = organizationName
                hd2VetContactName.Value = organizationID.ToString()
                iTab = 7
            Case "txtSampleCollectedByOrganizationID"
                txtSampleCollectedByOrganizationID.Text = organizationName
                hdnSampleCollectedByOrganizationID.Value = organizationID.ToString()
                iTab = 108
            Case "txtSampleSentToOrganizationID"
                txtSampleSentToOrganizationID.Text = organizationName
                hdnSampleSentToOrganizationID.Value = organizationID.ToString()
                iTab = 108
            Case "txtSampleCollectedByPersonID"
                txtSampleCollectedByPersonID.Text = organizationName
                hdnSampleCollectedByPersonID.Value = organizationID.ToString()
                iTab = 108
        End Select

        'Enable associated "Sent By Name" fields for population
        txtNotificationSentByName.Enabled = tx2NotificationSentByFacility.Text <> ""
        txtNotificationReceivedByName.Enabled = txtNotificationReceivedByFacility.Text <> ""
        txtstrInvestigatorName.Enabled = txtstrInvestigatorOrganization.Text <> ""
        txtFieldCollectedByPerson.Enabled = txtFieldCollectedByOffice.Text <> ""
        tx2MonitoringInvestigatorName.Enabled = tx2MonitoringInvestigatorOrganization.Text <> ""
        txtstrVetInvestigatorName.Enabled = txtstrVetInvestigatorOrganization.Text <> ""
        tx2VetMonitoringInvestigatorName.Enabled = tx2VetMonitoringInvestigatorOrganization.Text <> ""
        txtstrVetNotificationSentByName.Enabled = txtstrVetNotificationSentByFacilty.Text <> ""
        txtstrVetNotificationReceivedByName.Enabled = txtstrVetNotificationReceivedByFacilty.Text <> ""

        Select Case iTab
            Case 6
                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "modal", "setSamplesPage();", True)
                ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "modal", "showSamplesAdd();", True)
            Case 108
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", String.Format(SHOW_FORM, "true", "#outbreakVetSample", "outbreakVetSample"), True)

            Case Else

        End Select

        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", CLOSE_MODAL, True)

        If (iTab > 100) Then
            iTab -= 100
        End If

        'ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "modal", "goToTab(" + iTab.ToString() + ")", True)

        upMain.Update()

    End Sub

    'Private Sub SelectEmployeeRecord(employeeID As Long, employeeName As String) Handles ucSearchEmployee.SelectEmployee

    '    Select Case ViewState("NotificationEmployee")
    '        Case "txtNotificationSentByName"
    '            txtNotificationSentByName.Text = employeeName
    '            hdnNotificationSentByName.Value = employeeID
    '        Case "txtNotificationReceivedByName"
    '            txtNotificationReceivedByName.Text = employeeName
    '            hdnNotificationReceivedByName.Value = employeeID
    '    End Select

    '    ToggleVisibility(SectionOutbreakCaseCreation)

    '    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "modal", "goToTab(0)", True)
    '    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", CLOSE_MODAL, True)

    'End Sub
    'Public Sub CancelOrganizationRecord(messageType As MessageType, isConfirm As Boolean) Handles ucSearchOrganizationUserControl.ShowWarningModal

    '    outbreakSummaryAndQuestions.Visible = True
    '    ViewState("SearchControl") = False
    '    ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "modal", CLOSE_MODAL, True)

    'End Sub

#End Region

#Region "Private Routines"

    Private Function ExtractParameterTo(ByVal Ctrl As Object, ByRef field As Object) As String

        Dim strValue As String = String.Empty

        'Use the TypeName function to display the class name as text.
        'Use the TypeOf function to determine the object's type.
        If TypeOf Ctrl Is CheckBox Then

        ElseIf TypeOf Ctrl Is DropDownList Then
            strValue = Ctrl.SelectValue.ToString()
            ExtractParameterTo(strValue, ConversionType.ConvertLong, field)
        End If

    End Function

    Private Sub ExtractParameterTo(ByVal Ctrl As Object, ByVal objectType As ObjectTypes, ByVal type As ConversionType, ByRef field As Object)

        If (Not Ctrl Is Nothing) Then

            Dim strValue As String = String.Empty
            Dim conversionType As ConversionType

            'Use the TypeName function to display the class name as text.
            'Use the TypeOf function to determine the object's type.
            Select Case objectType
                Case ObjectTypes.TextBox
                    strValue = Ctrl.Text.ToString()
                    conversionType = ConversionType.ConvertString
                Case ObjectTypes.CheckBox
                    strValue = Ctrl.Checked.ToString()
                    conversionType = ConversionType.ConvertString
                Case ObjectTypes.RadioButton
                    strValue = Ctrl.Checked.ToString()
                    conversionType = ConversionType.ConvertString
                Case ObjectTypes.DropDownList
                    strValue = Ctrl.SelectValue.ToString()
                    conversionType = ConversionType.ConvertLong
                Case ObjectTypes.CalendarControl
                    strValue = Ctrl.Text.ToString()
                    conversionType = ConversionType.ConvertDate
            End Select

            ExtractParameterTo(strValue, ConversionType.ConvertDate, field)

        End If

    End Sub

    Private Sub ExtractParameterTo(ByVal strValue As String, ByVal type As ConversionType, ByRef field As Object)

        Try
            If (strValue.ToString().ToLower() <> "null") Then
                If (strValue <> "") Then
                    Dim bSuccess As Boolean

                    Select Case type
                        Case ConversionType.ConvertLong
                            Dim lValue As Long

                            bSuccess = Long.TryParse(strValue, lValue)

                            If (bSuccess) Then
                                field = lValue
                            End If
                        Case ConversionType.ConvertInt
                            Dim iValue As Int32

                            bSuccess = Int32.TryParse(strValue, iValue)

                            If (bSuccess) Then
                                field = iValue
                            End If
                        Case ConversionType.ConvertString
                            field = strValue.ToString()
                        Case ConversionType.ConvertDate
                            Dim dtValue As DateTime

                            bSuccess = DateTime.TryParse(strValue, dtValue)

                            If (bSuccess) Then
                                field = dtValue
                            End If
                        Case ConversionType.ConvertDouble
                            Dim dValue As Double

                            bSuccess = Double.TryParse(strValue, dValue)

                            If (bSuccess) Then
                                field = dValue
                            End If
                    End Select
                End If
            End If
        Catch Ex As Exception
            'Do something here
        End Try

    End Sub

    Protected Function GetTranslation(strKey As String)

        Return GetLocalResourceObject(strKey)

    End Function

    Private Sub ImportContacts(outbreakCaseReportUID As Long)

        Dim contactParameters As OMMContactSetParams = New OMMContactSetParams()

        contactParameters.langId = GetCurrentLanguage()
        contactParameters.OutbreakCaseReportUID = outbreakCaseReportUID
        contactParameters.AuditDTM = Date.Today
        contactParameters.AuditUser = Session("Person").ToString()

        ViewState("CreateCaseListCache") = True

        OutbreakAPIService.OmmContactSetAsync(contactParameters)

    End Sub

    Private Sub ImportContact(personId As Long)

        Dim contactParameters As OMMContactSetParams = New OMMContactSetParams()

        contactParameters.langId = GetCurrentLanguage()
        contactParameters.AuditDTM = Date.Today
        contactParameters.AuditUser = Session("Person").ToString()

        ViewState("CreateContactListCache") = True

        OutbreakAPIService.OmmContactSetAsync(contactParameters)

    End Sub

    Private Function ImportDiseaseReport(diseaseReportId As Long, ByRef reportType As DiseaseReportType) As Long

        Dim caseParameters As OmmCaseSetParams = New OmmCaseSetParams()

        caseParameters.langId = GetCurrentLanguage()
        caseParameters.idfOutbreak = CType(hdnidfOutbreak.Value, Int32)
        caseParameters.User = Session("Person").ToString()
        caseParameters.DTM = DateTime.Now()
        caseParameters.intRowStatus = 0
        caseParameters.CaseReportUID = -1

        Select Case reportType
            Case DiseaseReportType.Human
                caseParameters.idfHumanCase = diseaseReportId
            Case DiseaseReportType.Veterionary
                caseParameters.idfVetCase = diseaseReportId
        End Select

        ViewState("CreateOutbreakCaseListCache") = True

        Dim caseSetResult As List(Of OmmCaseSetModel)

        caseSetResult = OutbreakAPIService.OmmCaseSetAsync(caseParameters).Result

        Return caseSetResult(0).OutBreakCaseReportUID

    End Function

    Private Sub AddHumanDiseaseReport(ByRef reportType As DiseaseReportType)

        Dim caseParameters As OmmCaseSetParams = New OmmCaseSetParams()

        caseParameters.langId = GetCurrentLanguage()
        caseParameters.idfOutbreak = CType(hdnidfOutbreak.Value, Int32)
        caseParameters.User = Session("Person").ToString()
        caseParameters.DTM = DateTime.Now()
        caseParameters.intRowStatus = 0
        caseParameters.CaseReportUID = CType(hdnOutbreakCaseReportUID.Value, Double)
        caseParameters.idfHumanActual = CType(hdfidfHumanActual.Value, Long)

        'Notification
        caseParameters.datNotificationDate = CType(ciDateOfNotification.Text, Date)
        caseParameters.idfSentByOffice = hdnNotificationSentByFacility.Value

        If (txtNotificationSentByName.Text.Split(" ").Length > 0) Then
            caseParameters.strSentByFirstName = txtNotificationSentByName.Text.Split(" ")(0)
        End If

        If (txtNotificationSentByName.Text.Split(" ").Length > 1) Then
            caseParameters.strSentByLastName = txtNotificationSentByName.Text.Split(" ")(1)
        End If

        caseParameters.idfReceivedByOffice = hdnNotificationReceivedByFacility.Value
        If (txtNotificationReceivedByName.Text.Split(" ").Length > 0) Then
            caseParameters.strReceivedByFirstName = txtNotificationReceivedByName.Text.Split(" ")(0)
        End If

        If (txtNotificationReceivedByName.Text.Split(" ").Length > 1) Then
            caseParameters.strReceivedByLastName = txtNotificationReceivedByName.Text.Split(" ")(1)
        End If

        'Geo Location
        caseParameters.idfsLocationCountry = getConfigValue("CountryID").ToString()
        caseParameters.idfsLocationRegion = lucCaseLocation.SelectedRegionValue
        caseParameters.idfsLocationRayon = lucCaseLocation.SelectedRayonValue

        'Not a required field, a test must be done to detect the default value of "NULL" as a string
        ExtractParameterTo(lucCaseLocation.SelectedSettlementValue, ConversionType.ConvertLong, caseParameters.idfsLocationSettlement)
        ExtractParameterTo(lucCaseLocation.StreetText, ConversionType.ConvertString, caseParameters.strStreet)
        ExtractParameterTo(lucCaseLocation.HouseText, ConversionType.ConvertString, caseParameters.strHouse)
        ExtractParameterTo(lucCaseLocation.BuildingText, ConversionType.ConvertString, caseParameters.strBuilding)
        ExtractParameterTo(lucCaseLocation.ApartmentText, ConversionType.ConvertString, caseParameters.strApartment)
        ExtractParameterTo(lucCaseLocation.SelectedPostalText, ConversionType.ConvertLong, caseParameters.strPostalCode)

        'Clinical Information
        ExtractParameterTo(ddlCaseStatus.SelectedValue, ConversionType.ConvertLong, caseParameters.CaseStatusID)
        ExtractParameterTo(ciDateOfSymptomsOnset.Text, ConversionType.ConvertDate, caseParameters.datOnSetDate)
        ExtractParameterTo(ciDateOfDiagnosis.Text, ConversionType.ConvertDate, caseParameters.datFinalDiagnosisDate)
        ExtractParameterTo(ddlHospitalName.SelectedValue, ConversionType.ConvertLong, caseParameters.strHospitalizationPlace)
        ExtractParameterTo(cidatDateOfHospitalization.Text, ConversionType.ConvertDate, caseParameters.datHospitalizationDate)
        ExtractParameterTo(cidatDischargeDate.Text, ConversionType.ConvertDate, caseParameters.datDischargeDate)
        ExtractParameterTo(txtAntibioticAntiviralName.Text, ConversionType.ConvertString, caseParameters.strAntibioticName)
        ExtractParameterTo(txtAntibioticAntiviralDose.Text, ConversionType.ConvertString, caseParameters.strDosage)
        ExtractParameterTo(cidatAntibioticAntiviralFirstAdministered.Text, ConversionType.ConvertDate, caseParameters.datFirstAdministeredDate)
        ExtractParameterTo(txtClinicalAdditionalComments.Text, ConversionType.ConvertString, caseParameters.strClinicalComments)

        caseParameters.Vaccinations = CType(Session(VET_VACCINATIONS), List(Of OmmClinicalVaccination))

        'Outbreak Investigation
        ExtractParameterTo(hdnstrInvestigatorOrganization.Value, ConversionType.ConvertLong, caseParameters.idfInvestigatedByOffice)
        ExtractParameterTo(hdnstrInvestigatorName.Value, ConversionType.ConvertLong, caseParameters.idfInvestigatedByPerson)
        ExtractParameterTo(cidatStartingDateOfInvestigation.Text, ConversionType.ConvertDate, caseParameters.datInvestigationStartDate)
        ExtractParameterTo(ddlCaseClassification.SelectedValue, ConversionType.ConvertLong, caseParameters.CaseClassificationID)
        ExtractParameterTo(chkPrimaryCase.Text, ConversionType.ConvertString, caseParameters.IsPrimaryCaseFlag)
        ExtractParameterTo(txtAdditionalComments.Text, ConversionType.ConvertString, caseParameters.strOutbreakInvestigationComments)
        ExtractParameterTo(cidatStartingDateOfInvestigation.Text, ConversionType.ConvertDate, caseParameters.StartDateofInvestigation)
        ExtractParameterTo(ddlCaseClassification.SelectedValue, ConversionType.ConvertLong, caseParameters.CaseClassificationID)

        'Case Monitoring
        ExtractParameterTo(cidatMonitoringDate.Text, ConversionType.ConvertDate, caseParameters.datMonitoringDate)
        ExtractParameterTo(tx2AdditionalComments.Text, ConversionType.ConvertString, caseParameters.CaseMonitoringAdditionalComments)
        ExtractParameterTo(tx2MonitoringInvestigatorOrganization.Text, ConversionType.ConvertString, caseParameters.CaseInvestigatorOrganization)
        ExtractParameterTo(tx2MonitoringInvestigatorName.Text, ConversionType.ConvertString, caseParameters.CaseInvestigatorName)

        'Contacts
        caseParameters.CaseContacts = CType(Session("CaseContactList"), List(Of OmmContact))

        'Samples
        caseParameters.Samples = CType(Session("CaseSampleList"), List(Of OmmSample))

        ExtractParameterTo(txtAccessionDate.Text, ConversionType.ConvertString, caseParameters.AccessionDate)
        ExtractParameterTo(txtSampleConditionReceived.Text, ConversionType.ConvertString, caseParameters.SampleConditionReceived)
        ExtractParameterTo(txtstrVaccinationName.Text, ConversionType.ConvertString, caseParameters.VaccinationName)
        ExtractParameterTo(cidatDateOfVaccination.Text, ConversionType.ConvertDate, caseParameters.datDateOfVaccination)

        'Tests

        'Select Case reportType
        '    Case DiseaseReportType.Human
        '        caseParameters.idfHumanCase = diseaseReportId
        '    Case DiseaseReportType.Veterionary
        '        caseParameters.idfVetCase = diseaseReportId
        'End Select

        caseParameters.User = Session("Person").ToString()
        ViewState("CreateCaseListCache") = True

        Dim caseSetResult As List(Of OmmCaseSetModel)

        caseSetResult = OutbreakAPIService.OmmCaseSetAsync(caseParameters).Result
        'SearchHumanDiseaseReportUserControl_SelectHumanDiseaseReport(caseSetResult(0)
        'Return caseSetResult(0).OutBreakCaseReportUID
        ToggleVisibility(SectionOutbreakSummary)

    End Sub

    Private Sub AddUpdateVeterinaryhDiseaseReport()

        If Session(VET_HERDS) Is Nothing Then
            Session(VET_HERDS) = New List(Of OmmVetHerds)()
        End If
        Dim herds As List(Of OmmVetHerds) = CType(Session(VET_HERDS), List(Of OmmVetHerds))

        If Session(VET_SPECIES) Is Nothing Then
            Session(VET_SPECIES) = New List(Of OmmVetSpecies)()
        End If

        If Session(VET_CLINICAL_INFORMATION) Is Nothing Then
            Session(VET_CLINICAL_INFORMATION) = New List(Of OmmVetClinicalInformation)()
        End If

        If Session(VET_VACCINATIONS) Is Nothing Then
            Session(VET_VACCINATIONS) = New List(Of OmmVetVaccination)()
        End If

        If Session(VET_CASE_MONITORING) Is Nothing Then
            Session(VET_CASE_MONITORING) = New List(Of OmmVetCaseMonitoring)()
        End If

        If Session(VET_ANIMAL_INVESTIGATIONS) Is Nothing Then
            Session(VET_ANIMAL_INVESTIGATIONS) = New List(Of OmmVetAnimalInvestigation)()
        End If

        If Session(HUM_VET_CONTACTS) Is Nothing Then
            Session(HUM_VET_CONTACTS) = New List(Of OmmHumanVetContact)()
        End If

        If Session(VET_SAMPLES) Is Nothing Then
            Session(VET_SAMPLES) = New List(Of OmmVetSample)()
        End If

        If Session(VET_PENSIDE_TESTS) Is Nothing Then
            Session(VET_PENSIDE_TESTS) = New List(Of OmmVetPensideTest)()
        End If

        If Session(VET_LAB_TESTS) Is Nothing Then
            Session(VET_LAB_TESTS) = New List(Of OmmVetLabTest)()
        End If

        If Session(VET_LAB_TESTS) Is Nothing Then
            Session(VET_LAB_TESTS) = New List(Of OmmVetLabTest)()
        End If

        'If Session(VET_REPORTS) Is Nothing Then
        '    Session(VET_REPORTS) = New List(Of GblTestInterpretationGetListModel)()
        'End If

        Dim idfFarmActual As Long = CType(hdfidfFarmActual.Value, Long)
        Dim ovdspParms As OmmVeterinaryDiseaseSetParams = New OmmVeterinaryDiseaseSetParams


        'Add fake data until some controls are built to provide them
        hdnidfVetNotificationSentByName.Value = "55465230000003"
        hdnidfVetInvestigatorName.Value = "55465230000003"
        ExtractParameterTo(Date.Today, ConversionType.ConvertDate, ovdspParms.enteredDate)
        'End faked data

        ovdspParms.languageId = GetCurrentLanguage()
        ExtractParameterTo(hdfidfFarmActual.Value, ConversionType.ConvertLong, ovdspParms.farmMasterId)

        'Notifications
        ExtractParameterTo(cidatVetNotificationDate.Text, ConversionType.ConvertDate, ovdspParms.reportDate)
        ExtractParameterTo(hdnidfVetNotificationSentByFacilty.Value, ConversionType.ConvertLong, ovdspParms.reportedByOrganizationId)
        ExtractParameterTo(hdnidfVetNotificationSentByName.Value, ConversionType.ConvertLong, ovdspParms.personReportedById)
        ExtractParameterTo(hdnidfVetNotificationReceivedByFacilty.Value, ConversionType.ConvertLong, ovdspParms.idfReceivedByOffice)
        ExtractParameterTo(hdnidfVetNotificationReceivedByName.Value, ConversionType.ConvertLong, ovdspParms.idfReceivedByPerson)
        ExtractParameterTo(ciVetdatStartingDateOfInvestigation.Text, ConversionType.ConvertDate, ovdspParms.investigationDate)
        ExtractParameterTo(hdnstrVetInvestigatorOrganization.Value, ConversionType.ConvertLong, ovdspParms.investigatedByOrganizationId)
        ExtractParameterTo(hdnidfVetInvestigatorName.Value, ConversionType.ConvertLong, ovdspParms.personInvestigatedById)

        'Location
        ExtractParameterTo(ucVetCaseLocation.SelectedCountryValue, ConversionType.ConvertLong, ovdspParms.idfsCountry)
        ExtractParameterTo(ucVetCaseLocation.SelectedRegionValue, ConversionType.ConvertLong, ovdspParms.idfsRegion)
        ExtractParameterTo(ucVetCaseLocation.SelectedRayonValue, ConversionType.ConvertLong, ovdspParms.idfsRayon)
        ExtractParameterTo(ucVetCaseLocation.SelectedSettlementTypeValue, ConversionType.ConvertLong, ovdspParms.idfsSettlementType)
        ExtractParameterTo(ucVetCaseLocation.SelectedSettlementValue, ConversionType.ConvertLong, ovdspParms.idfsSettlement)
        ExtractParameterTo(ucVetCaseLocation.StreetText, ConversionType.ConvertString, ovdspParms.strStreetName)
        ExtractParameterTo(ucVetCaseLocation.HouseText, ConversionType.ConvertString, ovdspParms.strHouse)
        ExtractParameterTo(ucVetCaseLocation.BuildingText, ConversionType.ConvertString, ovdspParms.strBuilding)
        ExtractParameterTo(ucVetCaseLocation.ApartmentText, ConversionType.ConvertString, ovdspParms.strApartment)
        ExtractParameterTo(ucVetCaseLocation.SelectedPostalValue, ConversionType.ConvertString, ovdspParms.strPostCode)
        ExtractParameterTo(ucVetCaseLocation.LatitudeText, ConversionType.ConvertDouble, ovdspParms.dblLatitude)
        ExtractParameterTo(ucVetCaseLocation.LongitudeText, ConversionType.ConvertDouble, ovdspParms.dblLongitude)

        'Herd/Flock and Species Information
        ovdspParms.herdsOrFlocks = CType(Session(VET_HERDS), List(Of OmmVetHerds))
        ovdspParms.species = CType(Session(VET_SPECIES), List(Of OmmVetSpecies))
        ovdspParms.reportCategoryTypeId = rblidfsCaseType.SelectedValue 'Livesttock 10012003, Avian 10012004

        ExtractParameterTo(herds.Sum(Function(x) x.intDeadAnimalQty), ConversionType.ConvertInt, ovdspParms.farmDeadAnimalQuantity)
        ExtractParameterTo(herds.Sum(Function(x) x.intSickAnimalQty), ConversionType.ConvertInt, ovdspParms.farmSickAnimalQuantity)
        ExtractParameterTo(herds.Sum(Function(x) x.intTotalAnimalQty), ConversionType.ConvertInt, ovdspParms.farmTotalAnimalQuantity)

        'Clinical Information
        ovdspParms.clinicalInformation = CType(Session(VET_CLINICAL_INFORMATION), List(Of OmmVetClinicalInformation))
        ovdspParms.animalInvestigations = CType(Session(VET_ANIMAL_INVESTIGATIONS), List(Of OmmVetAnimalInvestigation))

        'Vaccination
        ovdspParms.vaccinations = CType(Session(VET_VACCINATIONS), List(Of OmmVetVaccination))

        'Outbreak Investigation
        ExtractParameterTo(ciVetdatStartingDateOfInvestigation.Text, ConversionType.ConvertDate, ovdspParms.investigationDate)
        ExtractParameterTo(hdnstrVetInvestigatorOrganization.Value, ConversionType.ConvertLong, ovdspParms.investigatedByOrganizationId)
        ExtractParameterTo(chkVetPrimaryCase.Checked, ConversionType.ConvertInt, ovdspParms.isPrimaryCaseFlag)
        ExtractParameterTo(ddlidfVetCaseStatus.SelectedValue, ConversionType.ConvertLong, ovdspParms.outbreakCaseStatusId)
        ExtractParameterTo(ddlidfVetCaseClassification.SelectedValue, ConversionType.ConvertLong, ovdspParms.outbreakCaseClassificationID)

        'Case Monitoring
        'ovdspParms.caseMonitoring = CType(Session(VET_CASE_MONITORING), List(Of OmmVetCaseMonitoring))


        'Case Contacts
        ovdspParms.contacts = CType(Session(HUM_VET_CONTACTS), List(Of OmmHumanVetContact))

        'Case Samples
        ovdspParms.samples = CType(Session(VET_SAMPLES), List(Of OmmVetSample))

        'Penside Tests
        ovdspParms.pensideTests = CType(Session(VET_PENSIDE_TESTS), List(Of OmmVetPensideTest))

        'Labratory Test
        ovdspParms.tests = CType(Session(VET_LAB_TESTS), List(Of OmmVetLabTest))

        'Interpretations


        'MUST REMOVE WHEN DATA BECOMES AVAILABLE'
        'Fake Data
        ovdspParms.idfReceivedByOffice = 52448330000007
        ovdspParms.idfReceivedByPerson = 55541620000018
        'End Fake Data

        ovdspParms.rowStatus = 0
        ovdspParms.siteId = Session("UserSite").ToString()

        Dim result As List(Of OmmVeterinaryDiseaseSetModel) = OutbreakAPIService.OmmVeterinaryDiseaseSetAsync(ovdspParms).Result

        'ImportDiseaseReport(result(0).VeterinaryDiseaseReportID, DiseaseReportType.Veterionary)

        ToggleVisibility(SectionOutbreakSummary)
    End Sub

    Private Sub EditHumanDiseaseReport(outbreakCaseReportId As Double)
        Try

            Dim caseDetails As List(Of OmmCaseGetDetailModel) = New List(Of OmmCaseGetDetailModel)()

            Dim params = New OmmCaseGetDetailParams With {
                .langId = GetCurrentLanguage(),
                .OutbreakCaseReportUID = outbreakCaseReportId
            }

            caseDetails = OutbreakAPIService.OmmCaseGetDetailAsync(params).Result

            ResetForm(humanDisease)

            Scatter(humanDisease, caseDetails.FirstOrDefault())
            Scatter(humanDisease, caseDetails.FirstOrDefault(), 2)

            hdnDiseaseReport.Value = "Human"

            FillCaseDetails()
            ToggleVisibility(SectionOutbreakCaseCreation)

            lucCaseLocation.LocationCountryID = caseDetails(0).idfsCountry
            lucCaseLocation.LocationRegionID = caseDetails(0).idfsRegion
            lucCaseLocation.LocationRayonID = caseDetails(0).idfsRayon
            lucCaseLocation.LocationSettlementID = caseDetails(0).idfsSettlement
            lucCaseLocation.DataBind()

            'Obtain parameters for the session and populate them for edit
            ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "", "initalizeSidebar();", True)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub

    Private Sub EditVeterinaryDiseaseReport(outbreakCaseReportId As Double)
        Try

            Dim caseDetails As OpenEIDSS.Domain.Return_Contracts.OmmVetCaseGetDetailResult = New OpenEIDSS.Domain.Return_Contracts.OmmVetCaseGetDetailResult()

            Dim params = New OmmCaseGetDetailParams With {
                .langId = GetCurrentLanguage(),
                .OutbreakCaseReportUID = outbreakCaseReportId
            }

            caseDetails = OutbreakAPIService.OmmVetCaseGetDetailAsync(params).Result

            ResetForm(veterinaryDisease)

            hdnDiseaseReport.Value = "Veterinary"

            lblPersonFarmEIDSSId.InnerText = GetLocalResourceObject("Lbl_Farm_ID")

            'RestForm doesn't affect the sub items of nested gridviews. We have to force some of them to reset
            gvHerds.DataSource = Nothing
            gvHerds.DataBind()

            Scatter(veterinaryDisease, caseDetails, 3)
            Scatter(divHiddenFieldsSection, caseDetails, 3)
            Scatter(veterinaryDisease, caseDetails, 2)

            FillCaseDetails()

            ucVetCaseLocation.LocationCountryID = caseDetails.idfsCountry
            ucVetCaseLocation.LocationRegionID = caseDetails.idfsRegion
            ucVetCaseLocation.LocationRayonID = caseDetails.idfsRayon
            ucVetCaseLocation.LocationSettlementID = caseDetails.idfsSettlement
            'ucVetCaseLocation.LocationSettlementTypeID = caseDetails(0).idfsSettlementType
            ucVetCaseLocation.DataBind()

            'ffOutbreakClinicalVetCase
            ffOutbreakAnimalInvestigation.CountryID = getConfigValue("CountryID").ToString()
            ffOutbreakVetInvestigation.CountryID = getConfigValue("CountryID").ToString()
            ffOutbreakVetCaseMonitoring.CountryID = getConfigValue("CountryID").ToString()

            ffOutbreakAnimalInvestigation.ObservationID = 0
            ffOutbreakVetInvestigation.ObservationID = 0
            ffOutbreakVetCaseMonitoring.ObservationID = 0


            Session(VET_HERDS) = caseDetails.HerdsOrFlocks
            Session(VET_SPECIES) = caseDetails.Species
            Session(VET_SAMPLES) = caseDetails.Samples
            Session(VET_ANIMAL_INVESTIGATIONS) = caseDetails.AnimalsInvestigations
            Session(VET_VACCINATIONS) = caseDetails.Vaccinations
            Session(VET_PENSIDE_TESTS) = caseDetails.PensideTests
            Session(VET_LAB_TESTS) = caseDetails.LabTests
            'Session(VET_LAB_INTERPRETATION) = caseDetails

            UpdateHerdSpecies(Nothing, Nothing)
            VetTypeOfCase_OnSelectedIndexChanged(Nothing, Nothing)

            gvVetVaccinations.DataSource = Session(VET_VACCINATIONS)
            gvVetVaccinations.DataBind()

            gvAnimalInvestigation.DataSource = Session(VET_ANIMAL_INVESTIGATIONS)
            gvAnimalInvestigation.DataBind()

            ToggleVisibility(SectionOutbreakCaseEdit)

            'Obtain parameters for the session and populate them for edit
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "Modal", "initializeSideBar_Immediate(0);", True)

        Catch ex As Exception
            Log.Error(MethodBase.GetCurrentMethod().Name & LoggingConstants.ExceptionWasThrownMessage, ex)
            Err.Raise(vbObjectError + 513, MethodBase.GetCurrentMethod().Name, ex.Message)
        End Try

    End Sub
#End Region

End Class