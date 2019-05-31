Module EIDSSConstants

    Public Structure EIDSSModules
        Public Const Employee As String = "Employee"
        Public Const Organization As String = "Organization"
        Public Const Settlement As String = "Settlement"
        Public Const StatisticalData As String = "StatisticalData"
    End Structure

    Public Structure CallerPages

        Public Const Dashboard As String = "DASHBOARD"
        Public Const DashboardURL As String = "/Dashboard.aspx"

        Public Const EmployeeAdmin As String = "EMPLOYEEADMIN"
        Public Const EmployeeAdminPrefix As String = "EA"
        Public Const EmployeeAdminURL As String = "/System/Administration/EmployeeAdmin.aspx"

        Public Const EmployeeDetails As String = "EMPLOYEEDETAILS"
        Public Const EmployeeDetailsPrefix As String = "ED"
        Public Const EmployeeDetailsURL As String = "/System/Administration/EmployeeDetails.aspx"

        Public Const OrganizationAdmin As String = "ORGANIZATIONADMIN"
        Public Const OrganizationAdminPrefix As String = "OA"
        Public Const OrganizationAdminURL As String = "/System/Administration/OrganizationAdmin.aspx"

        Public Const OrganizationDetails As String = "ORGANIZATIONDETAILS"
        Public Const OrganizationDetailsPrefix As String = "OD"
        Public Const OrganizationDetailsURL As String = "/System/Administration/OrganizationDetails.aspx"

        Public Const Person As String = "PERSON"
        Public Const PersonURL As String = "/Global/Person.aspx"
        Public Const PersonPrefix As String = "PER"

        Public Const Farm As String = "FARM"
        Public Const FarmURL As String = "/Global/Farm.aspx"
        Public Const FarmPrefix As String = "FRM"

        Public Const HumanDiseaseReport As String = "HUMANDISEASEREPORT"
        Public Const HumanDiseaseReportDetail As String = "HUMANDISEASEREPORTDETAIL"
        Public Const HumanDiseaseReportURL As String = "/Human/HumanDiseaseReport.aspx"
        Public Const HumanDiseaseReportPreviewURL As String = "/Human/HumanDiseaseReport.aspx?action=preview"
        Public Const HumanDiseaseReportSuffix As String = "_HDR"
        Public Const HumanDiseaseReportInitSuffix As String = "_HDRInit"
        Public Const HumanDiseaseReportSamples As String = "_HDRSamples"
        Public Const HumanDiseaseReportTests As String = "_HDRTests"
        Public Const HumanDiseaseReportContacts As String = "_HDRContacts"
        Public Const HumanDiseaseReportDeduplication As String = "HUMANDISEASEREPORTDEDUPLICATION"

        Public Const OutbreakCaseReportURL As String = "/Outbreaks/Outbreak.aspx"

        Public Const SearchDiseaseReports As String = "SearchDiseaseReports"
        Public Const SearchDiseaseReports_SelectPerson As String = "SearchDiseaseReports_SelectPerson"
        Public Const SearchDiseaseReportsURL As String = "/Human/SearchDiseaseReports.aspx"
        Public Const SearchDiseaseReportsSuffix As String = "_SDR"
        Public Const HumanDiseaseReportPrefix As String = "HDR"

        Public Const VeterinaryAggregate As String = "VETERINARYAGGREGATE"
        Public Const VeterinaryAggregateURL As String = "/Veterinary/VeterinaryAggregateCase.aspx"
        Public Const VeterinaryAggregateActionReportURL As String = "/Veterinary/VeterinaryAggregateActionReport.aspx"

        Public Const AvianVeterinaryDiseaseReport As String = "AVIANVETERINARYDISEASEREPORT"
        Public Const AvianVeterinaryDiseaseReportAddFarm As String = "AVIANVETERINARYDISEASEREPORTADDFARM"
        Public Const AvianVeterinaryDiseaseReportURL As String = "/Veterinary/AvianDiseaseReport.aspx"

        Public Const LivestockVeterinaryDiseaseReport As String = "LIVESTOCKVETERINARYDISEASEREPORT"
        Public Const LivestockVeterinaryDiseaseReportAddFarm As String = "LIVESTOCKVETERINARYDISEASEREPORTADDFARM"
        Public Const LivestockVeterinaryDiseaseReportURL As String = "/Veterinary/LivestockDiseaseReport.aspx"

        Public Const SearchVeterinaryDiseaseReport As String = "SEARCHVETERINARYDISEASEREPORT"
        Public Const SearchVeterinaryDiseaseReportDelete As String = "SEARCHVETERINARYDISEASEREPORTDELETE"
        Public Const SearchVeterinaryDiseaseReportEdit As String = "SEARCHVETERINARYDISEASEREPORTEDIT"
        Public Const SearchVeterinaryDiseaseReportSelect As String = "SEARCHVETERINARYDISEASEREPORTSELECT"
        Public Const SearchVeterinaryDiseaseReportURL As String = "/Veterinary/SearchVeterinaryDiseaseReport.aspx"
        Public Const VeterinaryDiseaseReportPrefix As String = "VDR"

        Public Const LaboratorySamples As String = "Samples"
        Public Const LaboratoryTestingURL As String = "/Laboratory/Laboratory.aspx?Tab=Testing"

        Public Const VeterinaryActiveSurveillanceMonitoringSession As String = "VASMONITORINGSESSION"
        Public Const VeterinaryActiveSurveillanceMonitoringSessionDeleteVeterinaryDiseaseReport As String = "VASMSDELETEVETERINARYDISEASEREPORT"
        Public Const VeterinaryActiveSurveillanceMonitoringSessionEditVeterinaryDiseaseReport As String = "VASMSEDITVETERINARYDISEASEREPORT"
        Public Const VeterinaryActiveSurveillanceMonitoringSessionURL As String = "/Veterinary/ActiveSurveillanceSession.aspx"
        Public Const VeterinaryActiveSurveillanceMonitoringSessionAddFarm As String = "VASMONITORSESSIONADDFARM"
        Public Const VeterinaryMonitoringSessionPrefix As String = "VMS"

        Public Const VeterinaryActiveSurveillanceCampaign As String = "VASCAMPAIGN"
        Public Const VeterinaryActiveSurveillanceCampaignNewMonitoringSession As String = "VASCAMPAIGNNEWMONITORINGSESSION"
        Public Const VeterinaryActiveSurveillanceCampaignDeleteMonitoringSession As String = "VASCAMPAIGNDELETEMONITORINGSESSION"
        Public Const VeterinaryActiveSurveillanceCampaignSelectMonitoringSession As String = "VASCAMPAIGNSELECTMONITORINGSESSION"
        Public Const VeterinaryActiveSurveillanceCampaignSelectMonitoringSessionAddFarm As String = "VASCAMPAIGNSELECTMONITORINGSESSIONADDFARM"
        Public Const VeterinaryActiveSurveillanceCampaignURL As String = "/Veterinary/ActiveSurveillanceCampaign.aspx"

        Public Const OutbreakImportHumanDiseaseReport As String = "OUTBREAKIMPORTHUMANDISEASEREPORT"
        Public Const OutbreakImportVeterinaryDiseaseReport As String = "OUTBREAKIMPORTVETERINARYDISEASEREPORT"
        Public Const OutbreakCreateHumanDiseaseReport As String = "OUTBREAKCREATEHUMANDISEASEREPORT"
        Public Const OutbreakCreateVeterinaryDiseaseReport As String = "OUTBREAKCREATEVETERINARYDISEASEREPORT"

        Public Const FarmWithVeterinaryDiseaseReport As String = "FARMWITHVETERINARYDISEASEREPORT"

        Public Const SettlementAdmin As String = "SETTLEMENTADMIN"
        Public Const SettlementAdminPrefix As String = "SA"
        Public Const SettlementAdminURL As String = "/System/Administration/SettlementAdmin.aspx"

        Public Const SettlementDetails As String = "SETTLEMENTDETAILS"
        Public Const SettlementDetailsPrefix As String = "SD"
        Public Const SettlementDetailsURL As String = "/System/Administration/SettlementDetails.aspx"

        Public Const StatDataAdmin As String = "STATISTICALDATAADMIN"
        Public Const StatDataAdminPrefix As String = "SDA"
        Public Const StatDataAdminURL = "/System/Administration/StatisticalDataAdmin.aspx"

        Public Const StatDataDetails As String = "STATISTICALDATADETAILS"
        Public Const StatDataDetailsPrefix As String = "SDD"
        Public Const StatDataDetailsURL = "/System/Administration/StatisticalDataDetails.aspx"

        Public Const HumanActiveSurveillanceCampaignPrefix As String = "HASC"
        Public Const HumanActiveSurveillanceCampaignSuffix As String = "_HASC"
        Public Const HumanActiveSurveillanceCampaign As String = "HumanActiveSurveillanceCampaign"
        Public Const HumanActiveSurveillanceCampaignSearch As String = "HumanActiveSurveillanceCampaignSearch"
        Public Const HumanActiveSurveillanceCampaignIDSearch As String = "HumanActiveSurveillanceCampaignIDSearch"
        Public Const HumanActiveSurveillanceReturnToCampaignSessions As String = "HumanActiveSurveillanceReturnToCampaignSessions"
        Public Const HumanActiveSurveillanceEditCampaignSession As String = "HumanActiveSurveillanceEditCampaignSession"
        Public Const HumanActiveSurveillanceCampaignUrl As String = "/HumanActiveSurveillance/ActiveSurveillanceCampaign.aspx"

        Public Const HumanActiveSurveillanceSessionPrefix As String = "HASS"
        Public Const HumanMonitoringSessionPrefix As String = "HMS"
        Public Const HumanActiveSurveillanceSessionSuffix As String = "_HASS"
        Public Const HumanActiveSurveillanceSession As String = "HumanActiveSurveillanceSession"
        Public Const HumanActiveSurveillanceSessionSearch As String = "HumanActiveSurveillanceSessionSearch"
        Public Const HumanActiveSurveillanceSessionUrl As String = "/HumanActiveSurveillance/ActiveSurveillanceSession.aspx"
        Public Const HumanActiveSurveillanceSessionDetailedInformationPersonSearch As String = "HumanActiveSurveillanceSessionDetailedInformationPersonSearch"
        Public Const HumanActiveSurveillanceSessionDetailedInformationOrganizationSearch As String = "HumanActiveSurveillanceSessionDetailedInformationOrganizationSearch"
        Public Const HumanActiveSurveillanceSessionContinue As String = "HumanActiveSurveillanceSessionContinue"

        Public Const SearchVectorSurveillanceSessionDelete As String = "SEARCHVECTORSURVEILLANCESESSIONDELETE"
        Public Const SearchVectorSurveillanceSessionEdit As String = "SEARCHVECTORSURVEILLANCESESSIONEDIT"
        Public Const SearchVectorSurveillanceSessionRead As String = "SEARCHVECTORSURVEILLANCESESSIONREAD"
        Public Const VectorSurveillanceSessionURL As String = "/Vector/VectorSurveillanceSession.aspx"
        Public Const VectorSurveillanceSessionPrefix As String = "VSS"

        Public Const FlexibleFormParameterReferenceType As String = "FFParameterReferenceType"
        Public Const FlexibleFormParameterTypeID As String = "FFParameterTypeID"
        Public Const FlexibleFormParameterquestion As String = "FFParameterquestion"

        Public Const PersonRecordDeduplicationURL As String = "/System/Administration/Deduplication/PersonRecordDeduplication.aspx"

    End Structure

    Public Structure Roles

        Public Const Administrators As String = "Administrators"
        Public Const ChiefEpidemiologists As String = "Chief Epidemiologists"
        Public Const ChiefVeterinarians As String = "Chief Veterinarians"
        Public Const Entomologists As String = "Entomologists"
        Public Const Epidemiologists As String = "Epidemiologists"
        Public Const ChiefOfLaboratoryHuman As String = "Chief of Laboratory (Human)"
        Public Const ChiefOfLaboratoryVeterinary As String = "Chief of Laboratory (Veterinary)"
        Public Const LaboratoryTechnicianHuman As String = "Laboratory Technician (Human)"
        Public Const LaboratoryTechnicianVeterinary As String = "Laboratory Technician (Veterinary)"
        Public Const Veterinarians As String = "Veterinarians"

    End Structure

    Public Structure GlobalConstants
        Public Const UserSettings As String = "UserSettings"
        Public Const DefaultLanguage As String = "DefaultLanguage"
        Public Const UserSettingsFilePrefix As String = "US"

        Public Const UserID As String = "idfUserID"
        Public Const PersonID As String = "idfPerson"
        Public Const FirstName As String = "strFirstName"
        Public Const SecondName As String = "strSecondName"
        Public Const FamilyName As String = "strFamilyName"
        Public Const Institution As String = "idfInstitution"
        Public Const UserName As String = "strUserName"
        Public Const Organization As String = "strLoginOrganization"
        Public Const Options As String = "strOptions"

        Public Const NullValue As String = "NULL"
    End Structure

    Public Structure LoggingConstants

        Public Const ExceptionWasThrownMessage As String = " exception was thrown."
        Public Const MissingReferenceDataMessage As String = "Missing reference data.  Contact data team to resolve."

    End Structure

    Public Structure ExceptionConstants

        Public Const NotFound As String = "Response status code does not indicate success: 404 (Not Found)"

    End Structure

    'List from trtHACode
    Public Structure HACodeList
        Public Const None As String = "None"
        Public Const Human As String = "Human"
        Public Const Exophyte As String = "Exophyte"
        Public Const Plant As String = "Plant"
        Public Const Soil As String = "Soil"
        Public Const Livestock As String = "Livestock"
        Public Const Avian As String = "Avian"
        Public Const Vector As String = "Vector"
        Public Const Syndromic As String = "Syndromic"
        Public Const All As String = "All"

        Public Const NoneHACode As Integer = 0
        Public Const HumanHACode As Integer = 2
        Public Const ExophyteHACode As Integer = 4
        Public Const PlantHACode As Integer = 8
        Public Const SoilHACode As Integer = 16
        Public Const LivestockHACode As Integer = 32
        Public Const ASHACode As Integer = 34
        Public Const AvianHACode As Integer = 64
        Public Const LiveStockAndAvian As Integer = 96
        Public Const OutbreakPriorityHACode As Integer = 98
        Public Const VectorHACode As Integer = 128
        Public Const HALVHACode As Integer = 226
        Public Const SyndromicHACode As Integer = 256
        Public Const AllHACode As Integer = 510
    End Structure

    Public Structure ServiceConstants
        Public Const EvaluateHash = "EVALUATEHASH"
        Public Const SetContext = "SETCONTEXT"
        Public Const AuthenticateUser = "AUTHENTICATE"
        Public Const ChangePassword = "CHANGEPASSWORD"
        Public Const UpdatePreferences = "UPDATE_SYSTEM_PREFS"
        Public Const SecurityPolicyGet = "SECURITYPOLICYGET"
        Public Const SecurityPolicySet = "SECURITYPOLICYSET"
        Public Const PeersonList = "PERSONLIST"
        Public Const PersonGetDetail = "PERSONGETDETAIL"
        Public Const OrganizationList = "ORGANIZATIONLIST"
        Public Const PositionGetList = "POSITIONLIST"
        Public Const PositionGetDetail = "POSITIONDETAIL"
        Public Const OrganizationDetail = "ORGANIZATIONDETAIL"
        Public Const TownOrVillageList = "TOWNORVILLAGELIST"

    End Structure

    Public Structure UserAction
        Public Const Insert As String = "I"
        Public Const Update As String = "U"
        Public Const Delete As String = "D"
        Public Const Read As String = "R"
    End Structure

    Public Structure UserConstants
        Public Const idfUserID As String = "idfUserId"
        Public Const FirstName As String = "FirstName"
        Public Const Organization As String = "Organization"
        Public Const UserSite As String = "UserSite"
    End Structure
    Public Structure HumanAggregateCaseMatrixHeadersConstants
        Public Const Diagnosis As String = "Diagnosis"
        Public Const ICD10Code As String = "ICD-10 Code"
        Public Const OECODE As String = "OE CODE"
    End Structure
    Public Structure EmployeeConstants
        Public Const EMPLOYEE_ID As String = "_id"
        Public Const DS_EMPLOYEE_LIST As String = "dsEmployeeList"
        Public Const idfEmployee As String = "idfEmployee"
        Public Const FullName As String = "employeeFullName"
        Public Const EmployeeID As String = "EmployeeID"
    End Structure

    Public Structure LoginConstants
        Public Const AccountName As String = "strAccountName"
        Public Const binPassword As String = "binPassword"
    End Structure

    Public Structure PersonConstants
        Public Const idfPerson = "idfPerson"
        Public Const idfsSite = "idfsSite"
        Public Const idfInstitution = "idfInstitution"
        Public Const UserId = "UserId"
        Public Const idfsStaffPosition = "idfsStaffPosition"
    End Structure

    Public Structure OrganizationConstants
        Public Const idfInstitution As String = "idfInstitution"
        Public Const idOffice As String = "idfOffice"
        Public Const OrgName As String = "name"
        Public Const OrgFullName As String = "FullName"
        Public Const strOrganizationID As String = "strOrganizationID"
        Public Const EnglishFullName As String = "EnglishFullName"
        Public Const idfOrganization As String = "idfOrganization"
        Public Const idfLocation As String = "idfLocation"
        Public Const idfsSite As String = "idfsSite"
        Public Const idfsRegion As String = "idfsRegion"
        Public Const idfsRayon As String = "idfsRayon"
        Public Const intHACode As String = "intHACode"
        Public Const OrganizationID As String = "OrganizationID"
        Public Const OrganizationName As String = "OrganizationName"
    End Structure

    Public Structure DepartmentConstants
        Public Const Name As String = "Name"
        Public Const idfDepartment As String = "idfDepartment"
        Public Const DefaultName As String = "DefaultName"
        Public Const User As String = "User"
        Public Const DepartmentId As String = "DepartmentID"
        Public Const DepartmentName As String = "DepartmentName"
    End Structure

    ''' <summary>
    ''' These constants are for table trtReferenceType.
    ''' They are the column values for  
    ''' 
    ''' column idfsReferenceType 
    ''' column strReferenceTypeCode
    ''' column strReferenceTypeName
    ''' </summary>
    Public Structure BaseReferenceConstants

        Public Const idfsBaseReference As String = "idfsBaseReference"
        Public Const Name As String = "Name"

        'trtReferenceType Table - Gets idfsReferenceType matching the value with strReferenceTypeName
        Public Const AberrationAnalysisMethod As String = "Aberration Analysis Method"
        Public Const AccessionCondition As String = "Accession Condition"
        Public Const AccessoryList As String = "Accessory List"
        Public Const AdministrativeLevel As String = "Administrative Level"
        Public Const AgeGroups As String = "Age Groups"
        Public Const AggregateCaseType As String = "Aggregate Case Type"
        Public Const AnimalAge As String = "Animal Age"
        Public Const AnimalSex As String = "Animal Sex"
        Public Const AnimalBirdStatus As String = "Animal/Bird Status"
        Public Const ASCampaignStatus As String = "AS Campaign Status"
        Public Const ASCampaignType As String = "AS Campaign Type"
        Public Const ASSessionActionStatus As String = "AS Session Action Status"
        Public Const ASSessionActionType As String = "AS Session Action Type"
        Public Const ASSessionStatus As String = "AS Session Status"
        Public Const AvianFarmProductionType As String = "Avian Farm Production Type"
        Public Const AvianFarmType As String = "Avian Farm Type"
        Public Const AVRAggregateFunction As String = "AVR Aggregate Function"
        Public Const AVRChartName As String = "AVR Chart Name"
        Public Const AVRChartType As String = "AVR Chart Type"
        Public Const AVRFolderName As String = "AVR Folder Name"
        Public Const AVRGroupDate As String = "AVR Group Date"
        Public Const AVRLayoutDescription As String = "AVR Layout Description"
        Public Const AVRLayoutFieldName As String = "AVR Layout Field Name"
        Public Const AVRLayoutName As String = "AVR Layout Name"
        Public Const AVRMapName As String = "AVR Map Name"
        Public Const AVRQueryDescription As String = "AVR Query Description"
        Public Const AVRQueryName As String = "AVR Query Name"
        Public Const AVRReportName As String = "AVR Report Name"
        Public Const AVRSearchField As String = "AVR Search Field"
        Public Const AVRSearchFieldType As String = "AVR Search Field Type"
        Public Const AVRSearchObject As String = "AVR Search Object"
        Public Const BasicSyndromicSurveillanceAggregateColumns As String = "Basic Syndromic Surveillance - Aggregate Columns"
        Public Const BasicSyndromicSurveillanceMethodofMeasurement As String = "Basic Syndromic Surveillance - Method of Measurement"
        Public Const BasicSyndromicSurveillanceOutcome As String = "Basic Syndromic Surveillance - Outcome"
        Public Const BasicSyndromicSurveillanceTestResult As String = "Basic Syndromic Surveillance - Test Result"
        Public Const BasicSyndromicSurveillanceType As String = "Basic Syndromic Surveillance - Type"
        Public Const Basisofrecord As String = "Basis of record"
        Public Const OutbreakCaseStatus As String = "Outbreak Case Status"
        Public Const CaseClassification As String = "Case Classification"
        Public Const CaseOutcomeList As String = "Case Outcome List"
        Public Const CaseReportType As String = "Case Report Type"
        Public Const CaseStatus As String = "Case Status"
        Public Const CaseType As String = "Case Type"
        Public Const Collectionmethod As String = "Collection method"
        Public Const Collectiontimeperiod As String = "Collection time period"
        Public Const ConfigurationDescription As String = "Configuration Description"
        Public Const ContactPhoneType As String = "Contact Phone Type"
        Public Const CustomReportType As String = "Custom Report Type"
        Public Const DataAuditEventType As String = "Data Audit Event Type"
        Public Const DataAuditObjectType As String = "Data Audit Object Type"
        Public Const DataExportDetailStatus As String = "Data Export Detail Status"
        Public Const DepartmentName As String = "Department Name"
        Public Const DestructionMethod As String = "Destruction Method"
        Public Const DiagnosesGroups As String = "Diagnoses Groups"
        Public Const Diagnosis As String = "Diagnosis"
        Public Const DiagnosisUsingType As String = "Diagnosis Using Type"
        Public Const DiagnosticInvestigationList As String = "Diagnostic Investigation List"
        Public Const EmployeeGroupName As String = "Employee Group Name"
        Public Const EmployeePosition As String = "Employee Position"
        Public Const EmployeeType As String = "Employee Type"
        Public Const EventInformationString As String = "Event Information String"
        Public Const EventSubscriptions As String = "Event Subscriptions"
        Public Const EventType As String = "Event Type"
        Public Const FarmGrazingPattern As String = "Farm Grazing Pattern"
        Public Const FarmIntendedUse As String = "Farm Intended Use"
        Public Const FarmMovementPattern As String = "Farm Movement Pattern"
        Public Const FarmOwnershipType As String = "Farm Ownership Type"
        Public Const FarmingSystem As String = "Farming System"
        Public Const FlexibleFormCheckPoint As String = "Flexible Form Check Point"
        Public Const FlexibleFormDecorateElementType As String = "Flexible Form Decorate Element Type"
        Public Const FlexibleFormLabelText As String = "Flexible Form Label Text"
        Public Const FlexibleFormParameterCaption As String = "Flexible Form Parameter Caption"
        Public Const FlexibleFormParameterEditor As String = "Flexible Form Parameter Editor"
        Public Const FlexibleFormParameterMode As String = "Flexible Form Parameter Mode"
        Public Const FlexibleFormParameterTooltip As String = "Flexible Form Parameter Tooltip"
        Public Const FlexibleFormParameterType As String = "Flexible Form Parameter Type"
        Public Const FlexibleFormParameterValue As String = "Flexible Form Parameter Value"
        Public Const FlexibleFormRule As String = "Flexible Form Rule"
        Public Const FlexibleFormRuleAction As String = "Flexible Form Rule Action"
        Public Const FlexibleFormRuleFunction As String = "Flexible Form Rule Function"
        Public Const FlexibleFormRuleMessage As String = "Flexible Form Rule Message"
        Public Const FlexibleFormSection As String = "Flexible Form Section"
        Public Const FlexibleFormTemplate As String = "Flexible Form Template"
        Public Const FlexibleFormType As String = "Flexible Form Type"
        Public Const FreezerBoxSize As String = "Freezer Box Size"
        Public Const FreezerSubdivisionType As String = "Freezer Subdivision Type"
        Public Const GeoLocationType As String = "Geo Location Type"
        Public Const GroundType As String = "Ground Type"
        Public Const HumanAgeType As String = "Human Age Type"
        Public Const HumanGender As String = "Human Gender"
        Public Const Identificationmethod As String = "Identification method"
        Public Const InformationString As String = "Information String"
        Public Const Language As String = "Language"
        Public Const LivestockFarmProductionType As String = "Livestock Farm Production Type"
        Public Const MatrixColumn As String = "Matrix Column"
        Public Const MatrixType As String = "Matrix Type"
        Public Const NationalityList As String = "Nationality List"
        Public Const NonNotifiableDiagnosis As String = "Non-Notifiable Diagnosis"
        Public Const NotificationObjectType As String = "Notification Object Type"
        Public Const NotificationType As String = "Notification Type"
        Public Const NumberingSchemaDocumentType As String = "Numbering Schema Document Type"
        Public Const ObjectType As String = "Object Type"
        Public Const ObjectTypeRelation As String = "Object Type Relation"
        Public Const OccupationType As String = "Occupation Type"
        Public Const OfficeType As String = "Office Type"
        Public Const OrganizationAbbreviation As String = "Organization Abbreviation"
        Public Const OrganizationName As String = "Organization Name"
        Public Const OrganizationType As String = "Organization Type"
        Public Const OutbreakContactStatus As String = "Outbreak Contact Status"
        Public Const OutbreakContactType As String = "Outbreak Contact Type"
        Public Const OutbreakStatus As String = "Outbreak Status"
        Public Const OutbreakUpdatePriority As String = "Outbreak Update Priority"
        Public Const OutbreakType As String = "Outbreak Type"
        Public Const OutbreakPeriod As String = "AVR Group Date"
        Public Const PartyType As String = "Party Type"
        Public Const PatientContactType As String = "Patient Contact Type"
        Public Const PatientLocationType As String = "Patient Location Type"
        Public Const PatientState As String = "Patient State"
        Public Const PensideTestCategory As String = "Penside Test Category"
        Public Const PensideTestName As String = "Penside Test Name"
        Public Const PensideTestResult As String = "Penside Test Result"
        Public Const PersonIDType As String = "Person ID Type"
        Public Const PersonalIDType As String = "Personal ID Type"
        Public Const ProphylacticMeasureList As String = "Prophylactic Measure List"
        Public Const ReasonforChangedDiagnosis As String = "Reason for Changed Diagnosis"
        Public Const ReasonfornotCollectingSample As String = "Reason for not Collecting Sample"
        Public Const ReferenceTypeName As String = "Reference Type Name"
        Public Const ReportAdditionalText As String = "Report Additional Text"
        Public Const ReportDiagnosisGroup As String = "Report Diagnosis Group"
        Public Const ResidentType As String = "Resident Type"
        Public Const RuleInValueforTestValidation As String = "Rule In Value for Test Validation"
        Public Const SampleKind As String = "Sample Kind"
        Public Const SampleStatus As String = "Sample Status"
        Public Const SampleType As String = "Sample Type"
        Public Const SanitaryMeasureList As String = "Sanitary Measure List"
        Public Const SecurityAuditAction As String = "Security Audit Action"
        Public Const SecurityAuditProcessType As String = "Security Audit Process Type"
        Public Const SecurityAuditResult As String = "Security Audit Result"
        Public Const SecurityConfigurationAlphabetName As String = "Security Configuration Alphabet Name"
        Public Const SecurityLevel As String = "Security Level"
        Public Const SessionCategory As String = "Session Category"
        Public Const SiteRelationType As String = "Site Relation Type"
        Public Const SiteType As String = "Site Type"
        Public Const SpeciesGroups As String = "Species Groups"
        Public Const SpeciesList As String = "Species List"
        Public Const StatisticalAgeGroups As String = "Statistical Age Groups"
        Public Const StatisticalAreaType As String = "Statistical Area Type"
        Public Const StatisticalDataType As String = "Statistical Data Type"
        Public Const StatisticalPeriodType As String = "Statistical Period Type"
        Public Const StorageType As String = "Storage Type"
        Public Const Surrounding As String = "Surrounding"
        Public Const SystemFunction As String = "System Function"
        Public Const SystemFunctionOperation As String = "System Function Operation"
        Public Const TestCategory As String = "Test Category"
        Public Const TestName As String = "Test Name"
        Public Const TestResult As String = "Test Result"
        Public Const TestStatus As String = "Test Status"
        Public Const VaccinationRouteList As String = "Vaccination Route List"
        Public Const VaccinationType As String = "Vaccination Type"
        Public Const VectorSubType As String = "Vector Sub Type"
        Public Const VectorSurveillanceSessionStatus As String = "Vector Surveillance Session Status"
        Public Const VectorType As String = "Vector Type"
        Public Const VetCaseLogStatus As String = "Vet Case Log Status"
        Public Const YesNoValueList As String = "Yes/No Value List"
        Public Const BaseRefTbl As String = "BaseRef"
    End Structure

    Public Structure AggregateValue
        Public Const Human As String = "10102001"
        Public Const Veterinary As String = "10102002"
        Public Const TimeInterval As String = "idfsTimeInterval"
        Public Const CaseType As String = "idfsAggrCaseType"
        Public Const Region As String = "idfsAdministrativeUnit"
        Public Const CaseID As String = "idfAggrCase"
        Public Const StrSearchCaseID As String = "strCaseID"
    End Structure

    Public Structure AggregateSetting
        Public Const CaseTypes As String = "19000102"
        Public Const AdminLevels As String = "19000089"
        Public Const MinimumTimeInterVal As String = "19000091"
    End Structure

    Public Structure CampaignCategory
        Public Const Human As String = "10168001"
        Public Const Veterinary As String = "10168002"
    End Structure

    Public Structure SessionCategory
        Public Const Human As String = "10169001"
        Public Const Veterinary As String = "10169002"
    End Structure

    Public Structure PositionConstants
        Public Const PositionId As String = "PositionId"
        Public Const PositionName As String = "PositionName"
        Public Const idfPositionId As String = "idfPositionId"
    End Structure

    Public Structure CountryConstants
        Public Const CountryID As String = "idfsCountry"
        Public Const CountryName As String = "strCountryName"
    End Structure

    Public Structure ReferenceEditorType
        Public Const Disease As Long = 19000019
        Public Const InvestigationTypes As Long = 19000021
        Public Const SpeciesList As Long = 19000086
        Public Const Prophylactic As Long = 19000074
        Public Const Sanitary As Long = 19000079
        Public Const VetAggregateCaseMatrix As Long = 10506079

    End Structure

    Public Structure RegionConstants
        Public Const RegionID As String = "idfsRegion"
        Public Const RegionName As String = "strRegionName"
    End Structure

    Public Structure RayonConstants
        Public Const RayonID As String = "idfsRayon"
        Public Const RayonName As String = "strRayonName"
    End Structure

    'TownOrVillage is same as settlement.
    'Be careful with idfsSettlement as it is same for Settlement module
    Public Structure TownOrVillageConstants
        Public Const TownOrVillageID As String = "idfsSettlement"
        Public Const TownOrVillageName As String = "strSettlementName"
    End Structure

    Public Structure PostalCodeConstants
        Public Const PostalCodeID As String = "idfPostalCode"
        Public Const PostalCodeName As String = "strPostCode"
    End Structure

    Public Structure SettlementConstants
        Public Const idfsSettlement As String = "idfsSettlement"
        Public Const idfsSettlementID As String = "idfsSettlementID"
        Public Const SettlementID As String = "idfsSettlement"
        Public Const idfsSettlementType As String = "idfsSettlementType"
        Public Const SettlementName As String = "SettlementDefaultName"
        Public Const Settlement_Name As String = "strSettlementName"
        Public Const NationalSettlement As String = "SettlementNationalName"
    End Structure

    Public Structure SettlementGetList
        Public Const SettlementDefaultName As String = "SettlementDefaultName"
        Public Const SettlementNationalName As String = "SettlementNationalName"
        Public Const SettlementTypeDefaultName As String = "SettlementTypeDefaultName"
        Public Const SettlementTypeNationalName As String = "SettlementTypeNationalName"
        Public Const CountryDefaultName As String = "CountryDefaultName"
        Public Const CountryNationalName As String = "CountryNationalName"
        Public Const RegionDefaultName As String = "RegionDefaultName"
        Public Const RegionNationalName As String = "RegionNationalName"
        Public Const RayonDefaultName As String = "RayonDefaultName"
        Public Const RayonNationalName As String = "RayonNationalName"
        Public Const SettlementCode As String = "strSettlementCode"
        Public Const Longitude As String = "dblLongitude"
        Public Const Latitude As String = "dblLatitude"
        Public Const Elevation As String = "intElevation"
    End Structure

    Public Structure SettlementTypeConstants
        Public Const Name As String = "Name"
        Public Const idfsReference As String = "idfsReference"
    End Structure

    Public Structure EmployeeGroupConstants
        Public Const idfEmployeeGroup As String = "idfEmployeeGroup"
        Public Const idfsEmployeeGroupName As String = "idfsEmployeeGroupName"
        Public Const Name As String = "strName"
    End Structure

    Public Structure ObjectAccessConstants

        Public Const idfObjectAccess As String = "idfObjectAccess"
        Public Const idfsObjectOperation As String = "idfsObjectOperation"
        Public Const idfsObjectType As String = "idfsObjectType"
        Public Const idfsObjectTypeName As String = "idfsObjectTypeName"
        Public Const idfsObjectID As String = "idfsObjectID"
        Public Const idfEmployee As String = "idfEmployee"
        Public Const isAllow As String = "isAllow"
        Public Const isDeny As String = "isDeny"

    End Structure

    Public Structure ObjectAccessOperationNames

        Public Const Create As String = "Create"
        Public Const Read As String = "Read"
        Public Const Write As String = "Write"
        Public Const Delete As String = "Delete"
        Public Const Execute As String = "Execute"
        Public Const AccessToPersonalData As String = "Access To Personal Data"

    End Structure

    Public Structure PageUsageMode
        Public Const Edit As String = "EditExisting"
        Public Const CreateNew As String = "CreateNew"
    End Structure

    Public Structure OutbreakIDConstants
        Public Const idfsOutbreakID As String = "idOutbreak"
        Public Const OutbreakIDName As String = "strOutbreakID"
    End Structure

    Public Structure EntrySiteConstants
        Public Const idfsEntrySite As String = "idfsEntrySite"
        Public Const EntrySiteName As String = "EntrySiteName"
    End Structure

    Public Structure VectorTypeFeedingLifeStatus
        Public Const FeedingStatus As String = "6707190000000"
        Public Const LifeStages As String = "6707200000000"
        Public Const RodentReproduction As String = "6707210000000"
        Public Const idfsParameter As String = "idfsParameterFixedPresetValue"
        Public Const Name As String = "NationalName"
    End Structure

    Public Structure OrganizationPerson
        Public Const PersonId As String = "idfPerson"
        Public Const fullName As String = "FullName"

    End Structure
    Public Structure HACodeItem
        Public Const ItemId As String = "intHACode"
        Public Const Name As String = "strNote"

    End Structure

    Public Structure HumanConstants
        Public Const HumanID As String = "idfHumanActual"
        Public Const HumanName As String = "FullName"
    End Structure

    Public Structure AdminOrganization
        Public Const OfficeID As String = "idfInstitution"
        Public Const Name As String = "FullName"

    End Structure

    Public Structure FarmConstants

        Public Const FarmID As String = "idfFarm"
        Public Const FarmActualID As String = "idfFarmActual"
        Public Const FarmCode As String = "strFarmCode"
        Public Const TotalAnimalQuantity As String = "intTotalAnimalQty"
        Public Const DeadAnimalQuantity As String = "intDeadAnimalQty"
        Public Const SickAnimalQuantity As String = "intSickAnimalQty"
        Public Const DiseaseReports As String = "Disease Reports"
        Public Const ActiveSurveillanceSessions As String = "Active Surveillance Sessions"
        Public Const LaboratoryTestSamples As String = "Laboratory Test Samples"

    End Structure

    Public Structure VeterinaryDiseaseReportConstants

        Public Const VeterinaryDiseaseReportID As String = "idfVetCase"
        Public Const CaseTypeID As String = "idfsCaseType"
        Public Const AvianDiseaseReportCaseType = "10012004"
        Public Const LivestockDiseaseReportCaseType = "10012003"
        Public Const Animals As String = "Animals"
        Public Const Herds As String = "Herds"
        Public Const Species As String = "Species"
        Public Const Samples As String = "Samples"
        Public Const LabTests As String = "LabTests"
        Public Const Interpretations As String = "Interpretations"
        Public Const PensideTests As String = "PensideTests"
        Public Const Vaccinations As String = "Vaccinations"
        Public Const VetCaseLogs As String = "VetCaseLogs"

    End Structure

    Public Structure HerdSpeciesConstants

        Public Const HerdID As String = "idfHerd"
        Public Const HerdActualID As String = "idfHerdActual"
        Public Const HerdCode As String = "strHerdCode"
        Public Const SpeciesID As String = "idfSpecies"
        Public Const SpeciesActualID As String = "idfSpeciesActual"
        Public Const SpeciesTypeID As String = "idfsSpeciesType"
        Public Const SpeciesTypeName As String = "SpeciesTypeName"
        Public Const TotalAnimalQuantity As String = "intTotalAnimalQty"
        Public Const SickAnimalQuantity As String = "intSickAnimalQty"
        Public Const DeadAnimalQuantity As String = "intDeadAnimalQty"
        Public Const StartOfSignsDate As String = "datStartOfSignsDate"
        Public Const AverageAge As String = "strAverageAge"
        Public Const Comment As String = "strNote"
        Public Const Flock As String = "Flock"
        Public Const Herd As String = "Herd"
        Public Const Species As String = "Species"
        Public Const Farm As String = "Farm"

    End Structure

    Public Structure AnimalConstants

        Public Const AnimalID As String = "idfAnimal"
        Public Const AnimalAgeTypeID As String = "idfsAnimalAge"
        Public Const AnimalAgeTypeName As String = "AnimalAgeTypeName"
        Public Const AnimalGenderTypeID As String = "idfsAnimalGender"
        Public Const AnimalGenderTypeName As String = "AnimalGenderTypeName"
        Public Const AnimalConditionTypeID As String = "idfsAnimalCondition"
        Public Const AnimalConditionTypeName As String = "AnimalConditionTypeName"
        Public Const AnimalCode As String = "strAnimalCode"
        Public Const AnimalName As String = "strName"
        Public Const Color As String = "strColor"
        Public Const SpeciesID As String = "idfSpecies"
        Public Const SpeciesTypeName As String = "SpeciesTypeName"
        Public Const HerdID As String = "idfHerd"
        Public Const HerdCode As String = "strHerdCode"
        Public Const Animal As String = "Animal"

    End Structure

    Public Structure SampleConstants

        Public Const SampleID As String = "idfMaterial"
        Public Const SampleCode As String = "strFieldBarCode"
        Public Const BirdStatusTypeID As String = "idfsBirdStatus"
        Public Const BirdStatusTypeName As String = "BirdStatusTypeName"
        Public Const FieldCollectedByOfficeID As String = "idfFieldCollectedByOffice"
        Public Const FieldCollectionByOfficeName As String = "FieldCollectedByOfficeSiteName"
        Public Const FieldCollectedByPersonID As String = "idfFieldCollectedByPerson"
        Public Const FieldCollectedByPersonName As String = "FieldCollectedByPersonName"
        Public Const SendToOfficeID As String = "idfSendToOffice"
        Public Const SendToOfficeName As String = "SendToOfficeSiteName"
        Public Const AccessionDate As String = "datAccession"
        Public Const AccessionConditionTypeID As String = "idfsAccessionCondition"
        Public Const AccessionConditionTypeName As String = "AccessionConditionTypeName"
        Public Const FieldCollectionDate As String = "datFieldCollectionDate"
        Public Const ConditionReceived As String = "strCondition"
        Public Const Note As String = "strNote"
        Public Const Site As String = "idfsSite"
        Public Const ReadOnlyIndicator As String = "blnReadOnly"
        Public Const AccessionedIndicator As String = "blnAccessioned"
        Public Const SampleStatusTypeID As String = "idfsSampleStatus"
        Public Const FunctionalAreaID As String = "idfInDepartment"
        Public Const FunctionalAreaName As String = "FunctionalAreaName"
        Public Const CurrentSite As String = "idfsCurrentSite"
        Public Const AccessionByPersonID As String = "idfAccesionByPerson"
        Public Const CaseID As String = "strCalculatedCaseID"
        Public Const VeterinaryDiseaseReportID As String = "idfVetCase"
        Public Const HumanDiseaseReportID As String = "idfHumanCase"
        Public Const MonitoringSessionID As String = "idfMonitoringSession"
        Public Const VectorSurveillanceSessionID As String = "idfVectorSurveillanceSession"
        Public Const HumanID As String = "idfHuman"

    End Structure

    Public Structure SampleTypeConstants

        Public Const SampleTypeID As String = "idfsSampleType"
        Public Const SampleTypeName As String = "SampleTypeName"

    End Structure

    Public Structure TestNameTypeConstants

        Public Const TestNameTypeID As String = "TestNameTypeID"
        Public Const TestNameTypeName As String = "TestNameTypeName"

    End Structure

    Public Structure VaccinationConstants

        Public Const VaccinationID As String = "idfVaccination"
        Public Const VaccinationTypeID As String = "idfsVaccinationType"
        Public Const VaccinationTypeName As String = "VaccinationTypeName"
        Public Const VaccinationRouteTypeID As String = "idfsVaccinationRoute"
        Public Const VaccinationRouteTypeName As String = "VaccinationRouteTypeName"
        Public Const SpeciesID As String = "idfSpecies"
        Public Const SpeciesTypeName As String = "SpeciesTypeName"
        Public Const DiseaseID As String = "idfsDiagnosis"
        Public Const DiseaseName As String = "DiagnosisTypeName"
        Public Const VaccinationDate As String = "datVaccinationDate"
        Public Const NumberVaccinated As String = "intNumberVaccinated"
        Public Const LotNumber As String = "strLotNumber"
        Public Const ManufacturerName As String = "strManufacturer"
        Public Const Note As String = "strNote"

    End Structure

    Public Structure PensideTestConstants

        Public Const PensideTestID As String = "idfPensideTest"
        Public Const PensideTestNameTypeID As String = "idfsPensideTestName"
        Public Const PensideTestNameTypeName As String = "TestNameTypeName"
        Public Const PensideTestResultTypeID As String = "idfsPensideTestResult"
        Public Const PensideTestResultTypeName As String = "TestResultTypeName"
        Public Const SpeciesTypeName As String = "SpeciesTypeName"
        Public Const AnimalCode As String = "strAnimalCode"

    End Structure

    Public Structure LabTestConstants

        Public Const LabTestID As String = "idfTesting"
        Public Const LabTestCode As String = "strBarCode"
        Public Const ConcludedDate As String = "datConcludedDate"
        Public Const TestResultTypeID As String = "idfsTestResult"
        Public Const TestResultTypeName As String = "TestResultTypeName"
        Public Const TestNameTypeID As String = "idfsTestName"
        Public Const TestNameTypeName As String = "TestNameTypeName"
        Public Const TestCategoryTypeID As String = "idfsTestCategory"
        Public Const TestCategoryTypeName As String = "TestCategoryTypeName"
        Public Const TestStatusTypeID As String = "idfsTestStatus"
        Public Const TestStatusTypeName As String = "TestStatusTypeName"
        Public Const DiseaseID As String = "idfsDiagnosis"
        Public Const DiseaseName As String = "DiagnosisName"
        Public Const ReadOnlyIndicator As String = "blnReadOnly"
        Public Const NonLaboratoryTestIndicator As String = "blnNonLaboratoryTest"
        Public Const ObservationID As String = "idfObservation"

    End Structure

    Public Structure InterpretationConstants

        Public Const InterpretationID As String = "idfTestValidation"
        Public Const InterpretedStatusTypeID As String = "idfsInterpretedStatus"
        Public Const InterpretedStatusTypeName As String = "InterpretedStatusTypeName"
        Public Const InterpretedByPersonName As String = "InterpretedByPersonName"
        Public Const InterpretedByPersonID As String = "idfInterpretedByPerson"
        Public Const InterpretationDate As String = "datInterpretationDate"
        Public Const ValidationDate As String = "datValidationDate"
        Public Const InterpretedComment As String = "strInterpretedComment"
        Public Const ValidatedComment As String = "strValidateComment"
        Public Const ValidatedByPersonID As String = "idfValidatedByPerson"
        Public Const ValidatedByPersonName As String = "ValidatedByPersonName"
        Public Const ValidatedIndicator As String = "blnValidateStatus"
        Public Const LabTestID As String = "idfTesting"
        Public Const ReadOnlyIndicator As String = "blnReadOnly"

    End Structure

    Public Structure CaseLogConstants

        Public Const VeterinaryCaseLogID As String = "idfVetCaseLog"
        Public Const CaseLogDate As String = "datCaseLogDate"
        Public Const PersonName As String = "PersonName"
        Public Const ActionRequired As String = "strActionRequired"
        Public Const CaseLogStatusTypeID As String = "idfsCaseLogStatus"
        Public Const CaseLogStatusTypeName As String = "CaseLogStatusTypeName"
        Public Const Note As String = "strNote"

    End Structure

    Public Structure Months
        Public Const MonthName As String = "strTextString"
    End Structure

    Public Structure StatisticTypes
        Public Const StatAreaType = "idfsStatisticAreaType"
        Public Const StatPeriodType = "idfsStatisticPeriodType"
        Public Const idfStatisticData = "idfStatistic"
        Public Const idfsStatTypeData = "idfsStatisticDataType"
        Public Const Population = "39850000000"
        Public Const PopGender = "840900000000"
        Public Const PopAgeGen = "39860000000"

        Public Const StatStartDate = "datStatisticStartDate"

    End Structure

    Public Structure StatisticAreaType
        Public Const Country = "10089001"
        Public Const Rayon = "10089002"
        Public Const Region = "10089003"
        Public Const Settlement = "10089004"
    End Structure

    Public Structure StatisticPeriodType
        Public Const Month = "10091001"
        Public Const Day = "10091002"
        Public Const Quarter = "10091003"
        Public Const Week = "10091004"
        Public Const Year = "10091005"
    End Structure

    Public Structure FarmTypes

        Public Const AvianFarmType = "10040003"
        Public Const AvianFarmTypeName = "Avian"
        Public Const LivestockFarmType = "10040007"
        Public Const LivestockFarmTypeName = "Livestock"

    End Structure

    Public Structure DiseaseReportLogStatusTypeConstants

        Public Const Open = "Open"
        Public Const Closed = "Closed"

    End Structure

    Public Structure VectorConstants
        Public Const VectorSurveillanceSessionID As String = "idfVectorSurveillanceSession"
        Public Const StringSessionID As String = "strSessionID"
        Public Const GridViewCode_VecSurv As String = "vecSurv"
        Public Const GridViewCode_CollDetail As String = "CollDetail"
        Public Const GridViewCode_CollSummary As String = "CollSummary"
        Public Const GridViewCode_Samp As String = "samp"
        Public Const GridViewCode_FieldTest As String = "fieldTest"
        Public Const GridViewCode_LabTest As String = "labTest"
        Public Const GridViewCode_Diseases As String = "Diseases"
        Public Const GridViewCode_VectorSurvList As String = "VectorSurvList"
        Public Const List As String = "List"
        Public Const DataTable As String = "DT"
        Public Const NewItem As String = "NewItem"
        Public Const NewWithBrackets As String = "(New)"
        Public Const Closed As String = "Closed"
    End Structure

    Public Structure VectorMessages
        Public Const SurveillanceSessionSaved As String = "Vector Surveillance Session data saved sucessfully."
        Public Const PageError As String = "An Error occurred On this page. Please verify your information To resolve the issue."
        Public Const DetailedCollectionSaved As String = "Vector Detailed Collection Data saved sucessfully."
        Public Const VectorSaveValidationError As String = "Please first create Vector Data record."
        Public Const MessageBox_Want_To_Cancel As String = "Are you sure that you want To cancel?"
        Public Const MessageBox_Confirm_Cancel As String = "Confirm Cancel"
        Public Const AggregateCollectionValidationError As String = "Please first create Vector Surveillance Session record"
        Public Const DetailedCollectionValidationError As String = "Please first create Vector Surveillance Session record"
        Public Const SummaryCollectionSaved As String = "Summary collection saved successfully"
        Public Const SampleDeletedSuccessfully As String = "Sample deleted successfully"
        Public Const FieldTestDeletedSuccessfully As String = "FieldTest deleted successfully"
        Public Const MessageBox_Want_To_Delete As String = "Are you sure that you want to delete this record?"
        Public Const MessageBox_Confirm_Delete As String = "Confirm Delete"
        Public Const DetailedCollectionDeleted As String = "Detailed Collection deleted successfully"
        Public Const AggregateCollectionDeleted As String = "Aggregate Collection deleted successfully"
        Public Const SampleSavedSuccessfully As String = "Sample saved successfully"
        Public Const SampleSaveSampleIdValidationError As String = "Please enter in valid Field Sample ID"
        Public Const DetailedCollectionCopied As String = "Vector Detailed Collection Data copied sucessfully"
        Public Const SampleSavedValidationError As String = "Please first create Sample record."
        Public Const FieldTestSavedSuccessfully As String = "FieldTest saved successfully."
        Public Const FieldTestSavedValidationError As String = "Please first create FieldTest record."
        Public Const VectorSurveillanceSessionDeleted As String = "Successful Deletion Of Vector Surveillance Session record."
        Public Const SearchValidationError As String = "Please enter at least one search parameter."
        Public Const ValidateForCreateVectorSurveillanceError As String = "Please at least select status and start date parameters."
        Public Const ValidateForCreateVectorSurveillanceDescriptionMaxLengthError As String = "Please limit the Description and Description of Location parameters character length to 500 or less"
        Public Const ValidateForExactLocationError As String = "Please select address region and rayon location parameters."
        Public Const ValidateForRelativeLocationError As String = "Please select address region, rayon, and town or village location parameters."
        Public Const ValidateForForeignLocationError As String = "Please select address country location parameter."
        Public Const ValidateForSpeciesError As String = "Please select species parameter."

    End Structure

    Public Structure GridViewCommandConstants

        Public Const AddCommand As String = "Add"
        Public Const SelectCommand As String = "Select"
        Public Const SelectRecordCommand As String = "Select Record"
        Public Const ViewCommand As String = "View"
        Public Const EditCommand As String = "Edit"
        Public Const DeleteCommand As String = "Delete"
        Public Const UpdateCommand As String = "Update"
        Public Const PageCommand As String = "Page"
        Public Const SortCommand As String = "Sort"
        Public Const NewInterpretationCommand As String = "New Interpretation"
        Public Const NewTestAssignmentCommand As String = "New Test Assignment"
        Public Const GetAliquotsCommand As String = "Get Aliquots"
        Public Const MyFavoriteCommand As String = "My Favorite"
        Public Const SelectAllRecordsMyFavoriteCommand As String = "Select All Records My Favorite"
        Public Const ToggleSelectAll As String = "Toggle Select All"
        Public Const ToggleSelect As String = "Toggle Select"
        Public Const SelectFarm As String = "Select Farm"

    End Structure

    Public Structure RecordConstants

        Public Const RecordID As String = "RecordID"
        Public Const RecordType As String = "RecordType"
        Public Const RecordAction = "RecordAction"
        Public Const Read As String = "R"
        Public Const Insert As String = "I"
        Public Const Update As String = "U"
        Public Const Delete As String = "D"
        Public Const Accession As String = "A"
        Public Const InsertAccession As String = "C"
        Public Const InsertAliquotDerivative As String = "Q"
        Public Const SelectFarm As String = "F"
        Public Const Favorite As String = "Favorite"
        Public Const RowStatus As String = "intRowStatus"
        Public Const ActiveRowStatus As String = "0"
        Public Const InactiveRowStatus As String = "1"
        Public Const RecordCount As String = "RecordCount"

    End Structure

    Public Structure RecordTypeConstants

        Public Const AvianDiseaseReport = "Avian"
        Public Const LivestockDiseaseReport = "Livestock"
        Public Const Farm As String = "Farm"
        Public Const Herd As String = "Herd"
        Public Const Species As String = "Species"
        Public Const Animals As String = "Animals"
        Public Const Samples As String = "Samples"
        Public Const LabTests As String = "LabTests"
        Public Const Interpretations As String = "Interpretations"
        Public Const PensideTests As String = "PensideTests"
        Public Const Vaccinations As String = "Vaccinations"
        Public Const VetCaseLogs As String = "VetCaseLogs"

    End Structure

    Public Structure ActiveSurveillanceCampaignConstants
        Public Const Campaign As String = "idfCampaign"
        Public Const CampaignID As String = "strCampaignID"
        Public Const CampaignName As String = "strCampaignName"
        Public Const CampaignAdministrator As String = "strCampaignAdministrator"
        Public Const CampaignType As String = "CampaignType"
        Public Const CampaignTypeID As String = "idfsCampaignType"
        Public Const StartDate As String = "datCampaignDateStart"
        Public Const EndDate As String = "datCampaignDateEND"
        Public Const DiagnosisID As String = "idfsDiagnosis"
        Public Const Diagnosis As String = "Diagnosis"
        Public Const Comments As String = "strComments"
        Public Const Conclusion As String = "Conclusion"
        Public Const CampaignStatus As String = "CampaignStatus"
        Public Const CampaignStatusID As String = "idfsCampaignStatus"
        Public Const SampleTypesList As String = "SampleTypesList"
    End Structure

    Public Structure ActiveSurveillanceSessionConstants
        Public Const Session As String = "idfMonitoringSession"
        Public Const SessionID As String = "strMonitoringSessionID"
        Public Const SessionStatus As String = "MonitoringSessionStatus"
        Public Const SessionStatusID As String = "idfsMonitoringSessionStatus"
        Public Const Organization As String = "EnglishName"
        Public Const OrganizationID As String = "idfsSite"
        Public Const Officer As String = "Officer"
        Public Const OfficerID As String = "idfsPersonEnteredBy"
        Public Const StartDate As String = "datStartDate"
        Public Const EndDate As String = "datEndDate"
        Public Const DateEntered As String = "datEnteredDate"
        Public Const DiagnosisID As String = "idfsDiagnosis"
        Public Const Diagnosis As String = "Diagnosis"
        Public Const RegionID As String = "idfsRegion"
        Public Const Region As String = "Region"
        Public Const CountryID As String = "idfsCountry"
        Public Const Country As String = "Country"
        Public Const RayonID As String = "idfsRayon"
        Public Const Rayon As String = "Rayon"
        Public Const TownID As String = "idfsSettlement"
        Public Const Town As String = "Town"
        Public Const Animals As String = "Animals"
        Public Const Farms As String = "Farms"
        Public Const Herds As String = "Herds"
        Public Const Species As String = "Species"
        Public Const SpeciesAndSamples As String = "SpeciesAndSamples"
        Public Const Samples As String = "Samples"
        Public Const Tests As String = "Tests"
        Public Const Interpretations As String = "Interpretations"
        Public Const Actions As String = "Actions"
        Public Const Summaries As String = "Summaries"
        Public Const SessionCategoryID As String = "SessionCategoryID"
        Public Const SessionCategory As String = "SessionCategory"
    End Structure

    Public Structure ActiveSurveillanceCampaignToSampleTypeConstants
        Public Const Campaign As String = "idfCampaign"
        Public Const CampaignToSampleType As String = "CampaignToSampleTypeUID"
        Public Const PlannedNumber As String = "intPlannedNumber"
        Public Const Order As String = "intOrder"
        Public Const SampleTypeID As String = "idfsSampleType"
        Public Const SampleType As String = "SampleType"
        Public Const SampleTypeName As String = "SampleTypeName"
        Public Const SpeciesTypeID As String = "idfsSpeciesType"
        Public Const SpeciesType As String = "SpeciesType"
        Public Const SpeciesTypeName As String = "SpeciesTypeName"
        Public Const HasOpenSession As String = "HasOpenSession"
    End Structure

    Public Structure MonitoringSessionActionConstants

        Public Const MonitoringSessionActionID As String = "idfMonitoringSessionAction"
        Public Const MonitoringSessionID As String = "idfMonitoringSession"
        Public Const ActionDate As String = "datActionDate"
        Public Const PersonEnteredByID As String = "idfPersonEnteredBy"
        Public Const PersonName As String = "strPersonEnteredBy"
        Public Const PersonFullName As String = "PersonName"
        Public Const ActionRequired As String = "strMonitoringSessionActionType"
        Public Const MonitoringSessionActionTypeID As String = "idfsMonitoringSessionActionType"
        Public Const MonitoringSessionActionTypeName As String = "strMonitoringSessionActionType" 'TODO: Combine vet and human - duplicate code
        Public Const MonitoringSessionActionName As String = "MonitoringSessionActionTypeName" 'TODO: Combine vet and human - duplicate code
        Public Const MonitoringSessionStatusTypeID As String = "idfsMonitoringSessionActionStatus"
        Public Const MonitoringSessionStatusTypeName As String = "strMonitoringSessionActionStatus" 'TODO: Combine vet and human - duplicate code
        Public Const MonitoringSessionStatusName As String = "MonitoringSessionActionStatusName" 'TODO: Combine vet and human - duplicate code
        Public Const Comment As String = "strComments"

    End Structure

    Public Structure MonitoringSessionSummaryConstants

        Public Const MonitoringSessionSummaryID As String = "idfMonitoringSessionSummary"
        Public Const CollectionDate As String = "datCollectionDate"
        Public Const SampledAnimalsQuantity As String = "intSampledAnimalsQty"
        Public Const SamplesQuantity As String = "intSamplesQty"
        Public Const PositiveAnimalsQuantity As String = "intPositiveAnimalsQty"
        Public Const SampleTypeID As String = "idfsSampleType"
        Public Const SampleTypeName As String = "SampleTypeName"
        Public Const DiseaseTypeID As String = "idfsDiagnosis"
        Public Const DiseaseTypeName As String = "DiagnosisName"
        Public Const AnimalGenderTypeID As String = "idfsAnimalSex"
        Public Const AnimalGenderTypeName As String = "AnimalGenderTypeName"

    End Structure

    Public Structure ActiveSurveillanceMonitoringSessionToSampleTypeConstants
        Public Const MonitoringSession As String = "idfMonitoringSession"
        Public Const SessionToSampleType As String = "MonitoringSessionToSampleType"
        Public Const Order As String = "intOrder"
        Public Const SampleTypeID As String = "idfsSampleType"
        Public Const SampleType As String = "SampleType"
        Public Const SampleTypeName As String = "SampleTypeName"
        Public Const SpeciesTypeID As String = "idfsSpeciesType"
        Public Const SpeciesType As String = "SpeciesType"
        Public Const SpeciesTypeName As String = "SpeciesTypeName"
    End Structure

    Public Structure SortConstants

        Public Const Ascending As String = "ASC"
        Public Const Descending As String = "DESC"
        Public Const Direction As String = "SortDirection"
        Public Const Expression As String = "SortExpression"

    End Structure

    Public Structure MaterialConstants
        Public Const Material As String = "idfMaterial"
        Public Const SampleTypeID As String = "idfsSampleType"
        Public Const SampleType As String = "SampleTypeName"
        Public Const RootMaterial As String = "idfRootMaterial"
        Public Const Parent As String = "idfParentMaterial"
        Public Const SpeciesTypeID As String = "idfSpecies"
        Public Const SpeciesType As String = "SpeciesTypeName"
        Public Const AnimalID As String = "idfAnimal"
        Public Const MonitoringSessionID As String = "idfMonitoringSession"
        Public Const FieldCollectedByPersonID As String = "idfFieldCollectedByPerson"
        Public Const FieldCollectedByPerson As String = "FieldCollectedByPersonName"
        Public Const FieldCollectedByOfficeID As String = "idfFieldCollectedByOffice"
        Public Const FieldCollectedByOffice As String = "FieldCollectedByOfficeSiteName"
        Public Const MainTestID As String = "idfMainTest"
        Public Const TestNumber As String = "intTestNumber"
        Public Const FieldCollectionDate As String = "datFieldCollectionDate"
        Public Const FieldSentDate As String = "datFieldSentDate"
        Public Const FieldBarCode As String = "strFieldBarcode"
        Public Const CalculatedCaseID As String = "strCalculatedCaseID"
        Public Const CalculatedHumanName As String = " strCalculatedHumanName"
        Public Const VectorSurveillanceSessionID As String = "idfVectorSurveillanceSession"
        Public Const VectorID As String = "idfVector"
        Public Const SubdivisionID As String = "idfSubdivision"
        Public Const NameChars As String = "strNameChars"
        Public Const SampleStatusID As String = "idfsSampleStatus"
        Public Const SampleStatus As String = "SampleStatusTypeName"
        Public Const InDepartmentID As String = "idfInDepartment"
        Public Const InDepartmentSite As String = "InDepartmentSiteName"
        Public Const DestroyedByPersonID As String = "idfDestroyedByPerson"
        Public Const DestroyedByPersonName As String = "DestroyedByPersonName"
        Public Const EnteringDate As String = "datEnteringDate"
        Public Const DestructionDate As String = "datDestructionDate"
        Public Const Barcode As String = "strBarcode"
        Public Const Note As String = "strNote"
        Public Const MaterialSiteID As String = "idfsSite"
        Public Const MaterialSite As String = "MaterialSiteName"
        Public Const RowStatus As String = "intRowStatus"
        Public Const SendToOfficeID As String = "idfSendToOffice"
        Public Const SendToOffice As String = "SendToOfficeSiteName"
        Public Const IsReadOnly As String = "blnReadOnly"
        Public Const BirdStatusID As String = "idfsBirdStatus"
        Public Const BirdStatus As String = "BirdStatusTypeName"
        Public Const HumanCaseID As String = "idfHumanCase"
        Public Const VetCaseID As String = "idfVetCase"
        Public Const AccessionDate As String = "datAccession"
        Public Const AccessionConditionID As String = "idfsAccessionCondition"
        Public Const AccessionCondition As String = "AccessionConditionTypeName"
        Public Const Condition As String = "strCondition"
        Public Const AccesionByPersonID As String = "idfAccesionByPerson"
        Public Const AccessionByPersonName As String = "AccessionByPersonName"
        Public Const DestructionMethodID As String = "idfsDestructionMethod"
        Public Const DestructionMethod As String = "DestructionMethodTypeName"
        Public Const CurrentSiteID As String = "idfsCurrentSite"
        Public Const CurrentSite As String = "CurrentSiteName"
        Public Const SampleKindID As String = "idfsSampleKind"
        Public Const SampleKind As String = "SampleKindTypeName"
        Public Const WasAccessioned As String = "blnAccessioned"
        Public Const ShowInCaseOrSession As String = "blnShowInCaseOrSession"
        Public Const ShowInLabList As String = "blnShowInLabList"
        Public Const ShowInDispositionList As String = "blnShowInDispositionList"
        Public Const ShowInAccessionInForm As String = " blnShowInAccessionInForm"
        Public Const MarkedForDispositionByPersonID As String = "idfMarkedForDispositionByPerson"
        Public Const MarkedForDispositionByPerson As String = "MarkedForDispositionByPersonName"
        Public Const OutOfRepositoryDate As String = "datOutOfRepositoryDate"
        Public Const SampleStatusDate As String = "datSampleStatusDate"
        Public Const MaintenanceFlag As String = "strMaintenanceFlag"
        Public Const RecordAction As String = "RecordAction"
    End Structure

    Public Structure TestConstants
        Public Const TestingID As String = "idfTesting"
        Public Const TestNameID As String = "idfsTestName"
        Public Const TestName As String = "strTestName"
        Public Const TestCategoryID As String = "idfsTestCategory"
        Public Const TestCategory As String = "strTestCategory"
        Public Const TestResultID As String = "idfsTestResult"
        Public Const TestResult As String = "strTestResult"
        Public Const TestStatusID As String = "idfsTestStatus"
        Public Const TestStatus As String = "strTestStatus"
        Public Const DiagnosisID As String = "idfsDiagnosis"
        Public Const Diagnosis As String = "Diagnosis"
        Public Const MaterialID As String = "idfMaterial"
        Public Const BatchTestID As String = "idfBatchTest"
        Public Const ObservationID As String = "idfObservation"
        Public Const TestNumber As String = "intTestNumber"
        Public Const Note As String = "strNote"
        Public Const RowStatus As String = "intRowStatus"
        Public Const StartDate As String = "datStartedDate"
        Public Const ConclusionDate As String = "datConcludedDate"
        Public Const TestedByOfficeID As String = "idfTestedByOffice"
        Public Const TestedByOffice As String = "strTestedByOffice"
        Public Const TestedByPersonID As String = "idfTestedByPerson"
        Public Const TestedByPerson As String = "strTestedByPerson"
        Public Const ResultEnteredByOfficeID As String = "idfResultEnteredByOffice"
        Public Const ResultEnteredByOffice As String = "strResultEnteredByOffice"
        Public Const ResultEnteredByPersonID As String = "idfResultEnteredByPerson"
        Public Const ResultEnteredByPerson As String = "strResultEnteredByPerson"
        Public Const ValidateByOfficeID As String = "idfValidatedByOffice"
        Public Const ValidateByOffice As String = "strValidatedByOffice"
        Public Const ValidateByPersonID As String = "idfValidatedByPerson"
        Public Const ValidateByPerson As String = "strValidatedByPerson"
        Public Const IsReadOnly As String = "blnReadOnly"
        Public Const IsLaboratoryTest As String = "blnNonLaboratoryTest"
        Public Const IsExternalTest As String = "blnExternalTest"
        Public Const PerformedByOfficeID As String = "idfPerformedByOffice"
        Public Const DateReceived As String = "datReceivedDate"
        Public Const ContactPerson As String = "strContactPerson"
        Public Const MaintenanceFlag As String = "strMaintenanceFlag"
        Public Const ReservedAttribute As String = "strReservedAttribute"
        Public Const RecordAction As String = "RecordAction"
    End Structure

    Public Structure HumanAgeTypeConstants
        Public Const Days As String = "10042001"
        Public Const Weeks As String = "10042004"
        Public Const Months As String = "10042002"
        Public Const Years As String = "10042003"
    End Structure

    Public Structure GridViewSortConstants

        Public Const GridRows As String = "GRIDROWS"
        Public Const Page As String = "PAGE"

    End Structure

    Public Structure PagingConstants

        Public Const FirstButtonText As String = "<<"
        Public Const LastButtonText As String = ">>"
        Public Const NextButtonText As String = ">"
        Public Const PreviousButtonText As String = "<"

    End Structure

    ''' <summary>
    ''' 
    ''' </summary>
    Public Structure ReportSessionTypeConstants

        Public Const HumanDiseaseReport = "Human Disease Report"
        Public Const HumanActiveSurveillanceSession = "Human Active Surveillance Session"
        Public Const VectorSurveillanceSession = "Vector Surveillance Session"
        Public Const VeterinaryActiveSurveillanceSession = "Veterinary Active Surveillance Session"
        Public Const VeterinaryDiseaseReport = "Veterinary Disease Report"

    End Structure

    Public Structure LaboratoryModuleTabConstants

        Public Const Samples = "Samples"
        Public Const Testing = "Testing"
        Public Const Transferred = "Transferred"
        Public Const MyFavorites = "Favorites"
        Public Const Batches = "Batches"
        Public Const Approvals = "Approvals"

    End Structure

End Module