using OpenEIDSS.Domain.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
   public  class HumanDiseaseAdvanceSearchParams
    {
        public string languageId{get;set;}
        [Optional]
        public long? humanDiseaseReportId{get;set;}
        [Optional]
        public string legacyId{get;set;}
        [Optional]
        public long? patientId{get;set;}
        [Optional]
        public string eidssPersonId{get;set;}
        [Optional]
        public long? diseaseId{get;set;}
        [Optional]
        public long? reportStatusTypeId{get;set;}
        [Optional]
        public long? regionId{get;set;}
        [Optional]
        public long? rayonId{get;set;}
        [Optional]
        public System.DateTime? dateEnteredFrom{get;set;}
        [Optional]
        public System.DateTime? dateEnteredTo{get;set;}
        [Optional]
        public long? classificationTypeId{get;set;}
        [Optional]
        public long? hospitalizationStatusTypeId{get;set;}
        [Optional]
        public string eidssReportId{get;set;}
        [Optional]
        public string patientFirstOrGivenName{get;set;}
        [Optional]
        public string patientMiddleName{get;set;}
        [Optional]
        public string patientLastOrSurname{get;set;}
        [Optional]
        public int? paginationSet{get;set;}
        [Optional]
        public int? pageSize{get;set;}
        [Optional]
        public int? maxPagesPerFetch{get;set;}
        [Optional]
        public string sentByFacility{get;set;}
        [Optional]
        public string receivedByFacility{get;set;}
        [Optional]
        public System.DateTime? diagnosisDateFrom{get;set;}
        [Optional]
        public System.DateTime? diagnosisDatTo{get;set;}
        [Optional]
        public long? localSampleId{get;set;}
        [Optional]
        public long? dataEntrySite{get;set;}
        [Optional]
        public System.DateTime? dateOfSymptomsOnset{get;set;}
        [Optional]
        public System.DateTime? notificationDate{get;set;}
        [Optional]
        public System.DateTime? dateOfFinalCaseClassification{get;set;}
        [Optional]
        public long? locationOfExposureRegion {get;set;}
        [Optional]
        public long? locationOfExposureRayon { get; set; }
    }
}
