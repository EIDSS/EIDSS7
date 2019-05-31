Namespace EIDSS

    Public Enum EmployeeGroupTypes As Long

        ChiefEpidemiologist = 49535210000000
        Epidemiologist = 49535220000000
        ChiefVeterinarian = 49535160000000
        Veterinarian = 49535200000000
        Administrator = 49535150000000
        ChiefOfLaboratoryHuman = 1521580000000
        ChiefOfLaboratoryVeterinary = 1521600000000
        LabTechnicianHuman = 1521680000000
        LabTechnicianVeterinary = 1521700000000

    End Enum

    Public Enum AccessoryCodes As Integer

        NoneHACode = 0
        HumanHACode = 2
        ExophyteHACode = 4
        PlantHACode = 8
        SoilHACode = 16
        LivestockHACode = 32
        ASHACode = 34
        AvianHACode = 64
        LiveStockAndAvian = 96
        OutbreakPriorityHACode = 98
        VectorHACode = 128
        HALVHACode = 226
        SyndromicHACode = 256
        AllHACode = 510

    End Enum

    Public Enum GoogleMapAddressType
        Local = 1
        OtherAddress = 2
        WorkOrSchool = 3
        LocationOfExposure = 4
    End Enum

    Public Enum ClassificationQuestionType
        Suspect
        Probable
    End Enum

    Public Enum RiskFactorType
        DropDown
        TextBox
    End Enum

    Public Enum SPType
        SPGetList = 0
        SPGetDetail = 1
        SPSet = 2
        SPDelete = 3
    End Enum

    Public Enum MessageType

        AddUpdateSuccess
        CannotAddUpdate
        DeleteSuccess
        CannotDelete
        ConfirmDelete
        ConfirmDeletePerson
        ConfirmDeleteFarm
        ConfirmDeleteFreezer
        ConfirmDeleteFreezerSubdivision
        ConfirmDeleteDiseaseReport
        ConfirmDeleteCampaign
        ConfirmDeleteMonitoringSession
        ConfirmDeleteSpeciesToSampleType
        ConfirmDeleteFarmInventory
        ConfirmDeleteSample
        ConfirmDeleteSamples
        ConfirmDeleteLabTest
        ConfirmDeleteAction
        ConfirmDeleteAggregateInfo
        CancelConfirm
        CancelConfirmAddUpdate
        CancelSearchConfirm
        CancelSampleConfirm
        CancelVaccinationConfirm
        CancelLabTestConfirm
        CancelResultSummaryConfirm
        CancelTestInterpretationConfirm
        CancelActionConfirm
        CancelAggregateInfoConfirm
        CancelAnimalConfirm
        CancelPensideTestConfirm
        CancelReportLogConfirm
        AssociatedPensideTestRecords
        AssociatedLabTestRecords
        AssociatedInterpretationRecords
        AssociatedSpeciesRecordsToFlock
        AssociatedSpeciesRecordsToHerd
        AssociatedRecordsToSpecies
        CannotGetValidatorSection
        DuplicateFarm
        DuplicateHuman
        DuplicateSpeciesAndSample
        DuplicateCampaign
        FarmTypeNotSelected
        DuplicateSpeciesFlock
        DuplicateSpeciesHerd
        CampaignStatusOpenNew
        CampaignStatusOpenClosed
        UnhandledException
        SearchCriteriaRequired
        NoFlockHerdSpeciesAssociated
        CannotRegisterNewSample
        CannotAccession
        CannotAssignTest
        CannotBatchTest
        CannotCloseBatch
        CannotSetTestResult
        CannotEditTest
        CannotEditSample
        CannotGroupAccession
        CannotTransferOut
        CannotDeleteSample
        CannotRestoreSample
        CannotSaveSampleTestDetails
        CannotDeleteSubdivision
        CannotDeleteFarmInventory
        ConfirmFarmToMonitoringSessionAddressMismatch
        InvalidDateOfBirth
        NoSamplesToAccession
        SampleMustBeAccessioned
        NoSampleSelectedForSampleDestruction
        NoSampleSelectedForSampleDeletion
        NoSamplesToPrintBarCodes
        NoBatchSelectedForClosure
        RegisterNewSampleSuccess
        NoTestSelectedForTestDeletion
        TestMustBePreliminaryOrInProgressStatus
        ReportSessionNotFound
        PrintBarcodes
        ConfirmClose
        FieldValuePairFoundNoSelection
        SaveSuccess
        ConfirmMerge
        CancelFormConfirm
        CancelSearchPersonConfirm
        CancelSearchFarmConfirm
        CancelSearchVeterinaryDiseaseReportConfirm
        CannotSelectVeterinaryMonitoringSessionForCampaign

    End Enum

    Public Enum NotificationTypes As Long

        ReferenceChange = 10056001
        TestResultsReceived = 10056002
        ReportDiseaseChange = 10056005
        ReportStatusChange = 10056006
        HumanDiseaseReport = 10056008
        OutbreakReport = 10056011
        VeterinaryDiseaseReport = 10056012
        AVR = 10056013
        SettlementChange = 10056014
        LaboratoryTestResultRejected = 10056062

    End Enum

    Public Enum ReferenceTypes

        SpeciesList = 19000086
        TestCategory = 19000095
        TestName = 19000097
        TestResult = 19000096
        ASSessionActionType = 19000127

    End Enum

    Public Enum ApplicationActions As Integer

        None = 0
        PersonAddHumanDiseaseReport = 1
        PersonAddOutbreakCaseReport = 2
        PersonPreviewHumanDiseaseReport = 3
        PersonPreviewOutbreakCaseReport = 4
        PersonPreviewFarm = 5
        FarmAddOutbreakCase = 6
        FarmAddAvianVeterinaryDiseaseReport = 7
        FarmAddLivestockVeterinaryDiseaseReport = 8
        DashboardEditEmployee = 9
        DashboardAddHumanDiseaseReport = 10
        DashboardEditHumanDiseaseReport = 11
        DashboardEditVeterinaryDiseaseReport = 12
    End Enum

    Public Enum LaboratoryModuleActions As Integer

        None = 0
        AccessionIn = 1
        GroupAccessionIn = 2
        TransferOut = 3
        AssignTest = 4
        RegisterNewSample = 5
        SetTestResults = 6
        ValidateTestResult = 7
        AmendTestResult = 8
        SampleDestruction = 9
        DestroyByIncineration = 10
        DestroyByAutoclave = 11
        ApproveDestruction = 12
        RejectDestruction = 13
        LabRecordDeletion = 14
        DeleteSample = 15
        DeleteTest = 16
        ApproveDeletion = 17
        RejectDeletion = 18
        PaperForms = 19
        SampleReport = 20
        TestReport = 21
        TransferReport = 22
        DestructionReport = 23
        PrintBarcode = 24
        CreateAliquot = 25
        EditSample = 26
        Reference = 27
        SearchPerson = 28
        EditTest = 29
        CreateDerivative = 30
        AccessionInForm = 31
        RestoreSample = 32
        SetTestResultsForSample = 33
        SetTestResultsForTest = 34
        SetTestResultsForTramsfer = 35
        AdvancedSearch = 36
        EditTransfer = 37
        SampleDestructionApprovals = 38
        RecordDeletionApprovals = 39
        ValidationApprovals = 40
        EditBatch = 41

    End Enum

    Public Enum SelectModes As Integer

        Read = 0
        FarmOwner = 1
        AvianDiseaseReport = 3
        LivestockDiseaseReport = 4
        Outbreak = 5
        VeterinarySession = 6
        Selection = 7
        View = 8
        Label = 9
        Human = 10
        RecordDataSelection = 11

    End Enum

    Public Enum ModuleTypes As Integer

        Human = 1
        Veterinary = 2
        Laboratory = 3
        Outbreak = 4
        Administration = 5

    End Enum

    Public Enum AccessionConditionTypes As Long

        AcceptedInGoodCondition = 10108001
        AcceptedInPoorCondition = 10108002
        Rejected = 10108003

    End Enum

    Public Enum DestructionMethodTypes As Long

        Incineration = 12675220000000
        Autoclave = 12675230000000

    End Enum

    Public Enum SampleTypes As Long

        BloodPlasma = 781520000000
        BloodSerum = 781530000000
        DNAFromClinicalSpecimen = 781750000000
        RNAFromClinicalSpecimen = 782850000000

    End Enum

    Public Enum SampleStatusTypes As Long

        MarkedForDeletion = 10015002
        MarkedForDestruction = 10015003
        InRepository = 10015007
        Deleted = 10015008
        Destroyed = 10015009
        TransferredOut = 10015010

    End Enum

    Public Enum SampleKindTypes As Long

        Aliquot = 12675410000000
        Derivative = 12675420000000
        TransferredIn = 12675430000000

    End Enum

    Public Enum TestResultTypes As Long

        Indeterminate = 7723820000000

    End Enum

    Public Enum TestStatusTypes As Long

        Final = 10001001
        Declined = 10001002
        InProgress = 10001003
        Preliminary = 10001004
        NotStarted = 10001005
        Amended = 10001006
        MarkedForDeletion = 10001007
        Deleted = 10001008

    End Enum

    Public Enum BatchTestStatusTypes As Long

        InProgress = 10001003
        Closed = 10001001

    End Enum

    Public Enum InterpretedStatusTypes As Long

        RuledIn = 10104001
        RuledOut = 10104002

    End Enum

    Public Enum VeterinaryDiseaseReportStatusTypes As Long

        InProcess = 10109001
        Closed = 10109002

    End Enum

    Public Enum DiseaseReportLogStatusTypes As Long

        Open = 10103001
        Closed = 10103002

    End Enum

    Public Enum TransferStatusTypes As Long

        Final = 10001001
        Declined = 10001002
        InProgress = 10001003
        Preliminary = 10001004
        NotStarted = 10001005
        Amended = 10001006
        MarkedForDeletion = 10001007
        Deleted = 10001008

    End Enum

    Public Enum ReportSessionTypes As Integer

        Avian = 10012004
        Human = 10012001
        Livestock = 10012003
        Vector = 10012006
        Veterinary = 10012005

    End Enum

    Public Enum YesNoUnknown As Integer

        Yes = 10100001
        No = 10100002
        Unknown = 10100003

    End Enum

    Public Enum OrganizationTypes As Integer

        Laboratory = 10504001
        Hospital = 10504002
        Other = 10504003

    End Enum

    Public Enum SubdivisionTypes As Long

        Box = 39890000000
        Shelf = 39900000000
        Rack = 10093001

    End Enum

    Public Enum LaboratoryActionsRequested

        SampleDeletion
        SampleDestruction
        Validation
        Unknown

    End Enum

    Public Enum SettlementTypes As Long

        Settlement = 730120000000
        Town = 730130000000
        Village = 730140000000

    End Enum

    Public Enum CampaignStatusTypes As Long

        NewStatus = 10140000
        Open = 10140001
        Closed = 10140002

    End Enum

    Public Enum DiagnosisGroups As Long

        Anthrax = 51529030000000
        Plague = 51529040000000
        Tularemia = 51529050000000

    End Enum

End Namespace

