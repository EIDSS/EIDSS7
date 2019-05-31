using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OpenEIDSS.Domain.Attributes;
namespace OpenEIDSS.Domain.Parameter_Contracts
{


    public class HumanDiseaseSetParams
    { 
        [Optional]
        public long? idfHumanCase { get; set; }

        [Optional]
        public long? idfHumanCaseRelatedTo { get; set; }

        [Optional]
        public long? idfHuman { get; set; }
        [Required]
        public long idfHumanActual { get; set; }
        [Required]
        public string strHumanCaseId { get; set; }
        [Required]
        public long idfsFinalDiagnosis { get; set; }
        [Optional]
        public DateTime? datDateOfDiagnosis { get; set; }
        [Optional]
        public DateTime? datNotificationDate { get; set; }
        [Optional]
        public long? idfsFinalState { get; set; }
        [Optional]
        public long? idfSentByOffice { get; set; }
        [Optional]
        public string strSentByFirstName { get; set; }
        [Optional]
        public string strSentByPatronymicName { get; set; }
        [Optional]
        public string strSentByLastName { get; set; }
        [Optional]
        public long? idfSentByPerson { get; set; }
        [Optional]
        public long? idfReceivedByOffice { get; set; }
        [Optional]
        public string strReceivedByFirstName { get; set; }
        [Optional]
        public string strReceivedByPatronymicName { get; set; }
        [Optional]
        public string strReceivedByLastName { get; set; }
        [Optional]
        public long? idfReceivedByPerson { get; set; }
        [Optional]
        public long? idfsHospitalizationStatus { get; set; }
        [Optional]
        public long? idfHospital { get; set; }
        [Optional]
        public string strCurrentLocation { get; set; }
        [Optional]
        public DateTime? datOnSetDate { get; set; }
        [Optional]
        public long? idfsInitialCaseStatus { get; set; }
        [Optional]
        public long? idfsYNPreviouslySoughtCare { get; set; }
        [Optional]
        public DateTime? datFirstSoughtCareDate { get; set; }
        [Optional]
        public long? idfSougtCareFacility { get; set; }
        [Optional]
        public long? idfsNonNotIFiableDiagnosis { get; set; }
        [Optional]
        public long? idfsYNHospitalization { get; set; }
        [Optional]
        public DateTime? datHospitalizationDate { get; set; }
        [Optional]
        public DateTime? datDischargeDate { get; set; }
        [Optional]
        public string strHospitalName { get; set; }
        [Optional]

        public long? idfsYNAntimicrobialTherapy { get; set; }
        [Optional]
        public string strAntibioticName { get; set; }
        [Optional]
        public string strDosage { get; set; }
        [Optional]

        public DateTime? datFirstAdministeredDate { get; set; }
        [Optional]
        public string strAntibioticComments { get; set; }
        [Optional]
        public long? idfsYNSpecIFicVaccinationAdministered { get; set; }
        [Optional]
        public string VaccinationName { get; set; }
        [Optional]

        public long? idfInvestigatedByOffice { get; set; }
        [Optional]
        public DateTime? startDateOfInvestigation { get; set; }
        [Optional]
        public long? idfsYNRelatedToOutbreak { get; set; }
        [Optional]
        public long? idfOutbreak { get; set; }
        [Optional]
        public long? idfsYNExposureLocationKnown { get; set; }
        [Optional]
        public long? idfPointGeoLocation { get; set; }
        [Optional]
        public DateTime? datExposureDate { get; set; }
        [Optional]
        public string strLocationDescription { get; set; }
        [Optional]
        public long? idfsLocationCountry { get; set; }
        [Optional]
        public long? idfsLocationRegion { get; set; }
        [Optional]
        public long? idfsLocationRayon { get; set; }
        [Optional]
        public long? idfsLocationSettlement { get; set; }
        [Optional]
        public float? intLocationLatitude { get; set; }
        [Optional]
        public float? intLocationLongitude { get; set; }
        [Optional]
        public long? idfsLocationGroundType { get; set; }
        [Optional]
        public float? intLocationDistance { get; set; }
        [Optional]
        public long? idfsFinalCaseStatus { get; set; }
        [Optional]
        public long? idfsOutcome { get; set; }
        [Optional]
        public DateTime? datDateofDeath { get; set; }
        [Optional]
        public long? idfsCaseProgressStatus { get; set; }
        [Optional]
        public long? idfPersonEnteredBy { get; set; }
        [Optional]
        public string strClinicalNotes { get; set; }
        [Optional]
        public long? idfsYNSpecimenCollected { get; set; }
        [Optional]
        public long? DiseaseReportTypeID { get; set; }
        [Optional]
        public bool? blnClinicalDiagBasis { get; set; }
        [Optional]
        public bool? blnLabDiagBasis { get; set; }
        [Optional]
        public bool? blnEpiDiagBasis { get; set; }
        [Optional]
        public DateTime? dateofClassification { get; set; }
        [Optional]
        public string strSummaryNotes { get; set; }
        [Optional]
        public long? idfEpiObservation { get; set; }
        [Optional]
        public long? idfCSObservation { get; set; }

      [Optional]
        public List<SampleParameters> SamplesParameters { get; set; }
        [Optional]
        public List<TestParameters> TestsParameters { get; set; }
        [Optional]
        public List<AntiviralTherapyParameters> AntiviralTherapiesParameters { get; set; }
        [Optional]
        public List<VaccinationParameters> VaccinationsParameters { get; set; }
        public List<ContactParameters> ContactsParameters { get; set; }
    }

    public sealed class SampleParameters
    {
        public long? idfHumanCase { get; set; }
        public long? idfMaterial { get; set; }
        public string strBarcode { get; set; }
        public string strFieldBarcode { get; set; }
        public long? idfsSampleType { get; set; }
        public string strSampleTypeName { get; set; } 
        public DateTime? datFieldCollectionDate { get; set; }
        public long? idfSendToOffice { get; set; }
        public string strSendToOffice { get; set; }
        public long? idfFieldCollectedByOffice { get; set; }
        public string strFieldCollectedByOffice { get; set; }
        public DateTime? datFieldSentDate { get; set; }
        public string strNote { get; set; }
        public DateTime? datAccession { get; set; }
        public long? idfsAccessionCondition { get; set; }
        public string strCondition { get; set; }
        public long? idfsRegion { get; set; }
        public string strRegionName { get; set; }
        public long? idfsRayon { get; set; }
        public string strRayonName { get; set; }
        public long? blnAccessioned { get; set; }
        public string RecordAction { get; set; }
        public long? idfsSampleKind { get; set; }
        public string SampleKindTypeName { get; set; }
        public long? idfsSampleStatus { get; set; }
        public string SampleStatusTypeName { get; set; }
        public long? idfFieldCollectedByPerson { get; set; }
        public DateTime? datSampleStatusDate { get; set; }
        public Guid? sampleGuid { get; set; }
        public long intRowStatus { get; set; }
    }

    public sealed class TestParameters
    {
        public long? idfHumanCase { get; set; }
        public long? idfMaterial { get; set; }
        public string strBarcode { get; set; }
        public string strFieldBarcode { get; set; }
        public long? idfsSampleType { get; set; }
        public string strSampleTypeName { get; set; }
        public DateTime? datFieldCollectionDate { get; set; }
        public long? idfSendToOffice { get; set; }
        public string strSendToOffice { get; set; }
        public long? idfFieldCollectedByOffice { get; set; }
        public string strFieldCollectedByOffice { get; set; }
        public DateTime? datFieldSentDate { get; set; }
        public long? idfsSampleKind { get; set; }
        public string SampleKindTypeName { get; set; }
        public long? idfsSampleStatus { get; set; }
        public string SampleStatusTypeName { get; set; }
        public long? idfFieldCollectedByPerson { get; set; }
        public DateTime? datSampleStatusDate { get; set; }        
        public Guid? sampleGuid { get; set; }
        public long? idfTesting { get; set; }
        public long? idfsTestName { get; set; }
        public long? idfsTestCategory { get; set; }
        public long? idfsTestResult { get; set; }
        public long? idfsTestStatus { get; set; }
        public long? idfsDiagnosis { get; set; }
        public string strTestStatus { get; set; }
        public string strTestResult { get; set; }
        public string name { get; set; }
        public DateTime? datReceivedDate { get; set; }
        public DateTime? datConcludedDate { get; set; }
        public long? idfTestedByPerson { get; set; }
        public long? idfTestedByOffice { get; set; }
        public long? idfsInterpretedStatus { get; set; }       
        public string strInterpretedStatus { get; set; }
        public string strInterpretedComment { get; set; }
        public DateTime? datInterpretedDate { get; set; }
        public string strInterpretedBy { get; set; }
        public bool? blnValidateStatus { get; set; }
        public string strValidateComment { get; set; }
        public DateTime? datValidationDate { get; set; }
        public string strValidatedBy { get; set; }
        public string strAccountName { get; set; }
        public Guid? testGuid { get; set; }
        public long intRowStatus { get; set; }
    }
    public sealed class AntiviralTherapyParameters
    {
        public long? idfAntimicrobialTherapy { get; set; }
        public long? idfHumanCase { get; set; }
        public DateTime? datFirstAdministeredDate { get; set; }
        public string strAntimicrobialTherapyName { get; set; }
        public string strDosage { get; set; }
    }

    public sealed class VaccinationParameters
    {
        public long? HumanDiseaseReportVaccinationUID { get; set; }
        public long? idfHumanCase { get; set; }
        public DateTime? VaccinationDate { get; set; }
        public string VaccinationName { get; set; }
    }
    

    public sealed class ContactParameters
    {
        public long? idfContactedCasePerson { get; set; }
        public long? idfHuman { get; set; }
        public long? idfHumanActual { get; set; }
        public long? idfHumanCase { get; set; }
        public DateTime? datDateOfLastContact { get; set; }
        public string strPlaceInfo { get; set; }
        public long? intRowStatus { get; set; }
        public Guid rowguid { get; set; }
        public string strComments { get; set; }
        public string strMaintenanceFlag { get; set; }
        public string strReservedAttribute { get; set; }
        public string strFirstName { get; set; }
        public string strSecondName { get; set; }
        public string strLastName { get; set; }
        public string strContactPersonFullName { get; set; }
        public DateTime? datDateOfBirth { get; set; }
        public long? dfsHumanGender { get; set; }
        public long? idfCitizenship { get; set; }
        public long? dfsCountry { get; set; }
        public long? idfsRegion { get; set; }
        public long? idfsRayon { get; set; }
        public long? idfsSettlement { get; set; }
        public string strStreetName { get; set; }
        public string strPostCode { get; set; }
        public string strBuilding { get; set; }
        public string strHouse { get; set; }
        public string strApartment { get; set; }
        public string strContactPhone { get; set; }
        public long? idfContactPhoneType { get; set; }
    }
    
}