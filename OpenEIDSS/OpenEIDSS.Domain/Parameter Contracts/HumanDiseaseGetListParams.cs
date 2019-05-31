using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class HumanDiseaseGetListParams
    {
       
        public string LangID{ get; set; }
        public long SearchHumanCaseId{ get; set; }
        public string SearchLegacyCaseID{ get; set; }
        public long SearchPatientId{ get; set; }
        public string SearchPersonEIDSSId{ get; set; }
        public long SearchDiagnosis{ get; set; }
        public long SearchReportStatus{ get; set; }
        public long SearchRegion{ get; set; }

        public long SearchRayon{ get; set; }
        public DateTime SearchHDRDateEnteredFrom{ get; set; }
        public DateTime SearchHDRDateEnteredTo{ get; set; }
        public long SearchCaseClassification{ get; set; }
        public DateTime SearchDiagnosisDateFrom{ get; set; }
        public DateTime SearchDiagnosisDateTo{ get; set; }
        public long SearchIdfsHospitalizationStatus{ get; set; }
        public string SearchStrCaseId{ get; set; }
        public string SearchStrPersonFirstName{ get; set; }
        public string SearchStrPersonMiddleName{ get; set; }
        public string SearchStrPersonLastName { get; set; }
    }
}
