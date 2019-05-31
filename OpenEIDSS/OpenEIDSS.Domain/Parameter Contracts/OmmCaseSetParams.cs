using System;
using System.Collections.Generic;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OmmCaseSetParams
    {
        public string langId { get; set; }
        public long? CaseReportUID { get; set; }
        public long? idfOutbreak { get; set; }
        public string strOutbreakCaseID { get; set; }
        public long? idfHumanCase { get; set; }
        public long? idfVetCase { get; set; }
        public long? diseaseID { get; set; }
        public long? CaseObservationID { get; set; }
        public int? intRowStatus { get; set; }
        public string User { get; set; }
        public DateTime? DTM { get; set; }
        public long? idfHumanActual { get; set; }
        public long? idfsDiagnosisOrDiagnosisGroup { get; set; }
        public long? idfsYNSpecIFicVaccinationAdministered { get; set; }
        public DateTime? StartDateofInvestigation { get; set; }

        //Notification
        public DateTime? datNotificationDate { get; set; }
        public long? idfSentByOffice { get; set; }
        public string strSentByFirstName { get; set; }
        public string strSentByLastName { get; set; }
        public long? idfReceivedByOffice { get; set; }
        public string strReceivedByFirstName { get; set; }
        public string strReceivedByLastName { get; set; }

        //Case Location
        public long? idfsLocationCountry { get; set; }
        public long? idfsLocationRegion { get; set; }
        public long? idfsLocationRayon { get; set; }
        public long? idfsLocationSettlement { get; set; }
        public string strStreet { get; set; }
        public string strHouse { get; set; }
        public string strBuilding { get; set; }
        public string strApartment { get; set; }
        public string strPostalCode { get; set; }
        public long? intLocationLatitude { get; set; }
        public long? intLocationLongitude { get; set; }

        //Clinical Information
        public long? CaseStatusID { get; set; }
        public DateTime? datOnSetDate { get; set; }
        public DateTime? datFinalDiagnosisDate { get; set; }
        public string strHospitalizationPlace { get; set; }
        public DateTime? datHospitalizationDate { get; set; }
        public DateTime? datDischargeDate { get; set; }
        public string strAntibioticName { get; set; }
        public string strDosage { get; set; }
        public DateTime? datFirstAdministeredDate { get; set; }
        public List<OmmClinicalVaccination> Vaccinations { get; set; }
        public string strClinicalComments { get; set; }

        //Outbreak Investigation
        public long? idfInvestigatedByOffice { get; set; }
        public long? idfInvestigatedByPerson { get; set; }
        public DateTime? datInvestigationStartDate { get; set; }
        public long? CaseClassificationID { get; set; }
        public string IsPrimaryCaseFlag { get; set; }
        public string strOutbreakInvestigationComments { get; set; }

        //Case Monitoring
        public DateTime? datMonitoringDate { get; set; }
        public long? CaseMonitoringObservationID { get; set; }
        public string CaseMonitoringAdditionalComments { get; set; }

        public string CaseInvestigatorOrganization { get; set; }
        public string CaseInvestigatorName { get; set; }

        //Contacts
        public List<OmmContact> CaseContacts { get; set; }

        //Samples
        public List<OmmSample> Samples { get; set; }
        public DateTime? AccessionDate { get; set; }
        public string SampleConditionReceived { get; set; }
        public string VaccinationName { get; set; }
        public DateTime? datDateOfVaccination { get; set; }

        //Test


    }
    public sealed class OmmClinicalVaccination
    {
        public long HumanDiseaseReportVaccinationUID { get; set; }
        public string Name { get; set; }
        public DateTime Date { get; set; }
    }
}