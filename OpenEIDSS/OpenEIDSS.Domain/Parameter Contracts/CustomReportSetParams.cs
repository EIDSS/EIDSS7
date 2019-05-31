using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
   public class CustomReportSetParams
    {
        public long? idfReportRows{get;set;}
        public long? idfsCustomReportType{get;set;}
        public long? idfsDiagnosisOrReportDiagnosisGroup{get;set;}
        public long? idfsReportAdditionalText{get;set;}
        public long? idfsIcdReportAdditionalText { get; set; }
    }
}
