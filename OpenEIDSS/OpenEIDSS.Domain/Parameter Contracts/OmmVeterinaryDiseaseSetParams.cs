using System.Collections.Generic;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OmmVeterinaryDiseaseSetParams
    {
        public string languageId { get; set; }
        public long? veterinaryDiseaseReportId { get; set; }
        public long? farmId { get; set; }
        public long? farmMasterId { get; set; }
        public long? farmOwnerId { get; set; }
        public long? diseaseId { get; set; }
        public long? personEnteredById { get; set; }
        public long? personReportedById { get; set; }
        public long? personInvestigatedById { get; set; }
        public long? siteId { get; set; }
        public System.DateTime? reportDate { get; set; }
        public System.DateTime? assignedDate { get; set; }
        public System.DateTime? investigationDate { get; set; }
        public string eidssFieldAccessionId { get; set; }
        public int? rowStatus { get; set; }
        public long? reportedByOrganizationId { get; set; }
        public long? investigatedByOrganizationId { get; set; }
        public long? reportTypeId { get; set; }
        public long? classificationTypeId { get; set; }
        public long? outbreakId { get; set; }
        public System.DateTime? enteredDate { get; set; }
        public string eidssReportId { get; set; }
        public long? statusTypeId { get; set; }
        public long? monitoringSessionId { get; set; }
        public long? reportCategoryTypeId { get; set; }
        public List<OmmVetClinicalInformation> clinicalInformation { get; set; }
        public int? farmTotalAnimalQuantity { get; set; }
        public int? farmSickAnimalQuantity { get; set; }
        public int? farmDeadAnimalQuantity { get; set; }
        public long? originalVeterinaryDiseaseReportId { get; set; }
        public long? farmEpidemiologicalObservationId { get; set; }
        public long? controlMeasuresObservationId { get; set; }
        public long? receivedByOrganizationID { get; set; }
        public long? receivedByPersonID { get; set; }
        public int? isPrimaryCaseFlag { get; set; }
        public long? outbreakCaseStatusId { get; set; }
        public long? outbreakCaseClassificationID { get; set; }
        public List<OmmVetHerds> herdsOrFlocks { get; set; }
        public List<OmmVetSpecies> species { get; set; }
        public List<OmmVetAnimalInvestigation> animalInvestigations { get; set; }
        public List<OmmVetVaccination> vaccinations { get; set; }
        public List<OmmVetSample> samples { get; set; }
        public List<OmmVetPensideTest> pensideTests { get; set; }
        public List<OmmVetLabTest> tests { get; set; }
        public List<TestInterpretationParameters> testInterpretations { get; set; }
        public List<VeterinaryDiseaseReportLogParameters> reportLogs { get; set; }
        public List<OmmHumanVetContact> contacts { get; set; }

        public long? idfReportedByOffice { get; set; }
        public long? idfPersonReportedBy { get; set; }

        public long? idfReceivedByOffice { get; set; }
        public long? idfReceivedByPerson { get; set; }
        public long? idfsCountry { get; set; }
        public long? idfsRegion { get; set; }
        public long? idfsRayon { get; set; }
        public long? idfsSettlementType { get; set; }
        public long? idfsSettlement { get; set; }
        public string strStreetName { get; set; }
        public string strHouse { get; set; }
        public string strBuilding { get; set; }
        public string strApartment { get; set; }
        public string strPostCode { get; set; }
        public System.Double? dblLatitude { get; set; }
        public System.Double? dblLongitude { get; set; }

        public string caseMonitoring { get; set; }
    }
}