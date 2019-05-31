using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class ConfReportdiseasegroupdiseasematrixSetParams
    {
        public long? idfDiagnosisToGroupForReportType{get;set;}
        public long? idfsCustomReportType{get;set;}
        public long? idfsReportDiagnosisGroup{get;set;}
        public long? idfsDiagnosis { get; set; }
    }
}
