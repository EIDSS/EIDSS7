using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class RefReporDiagnosisTypeSetParams
    {
        public long ? idfsReportDiagnosisGroup { get; set; }
        public string strDefault { get; set; }
        public string strName { get; set; }
        public string strCode { get; set; }
        public string languageId { get; set; }
    }
}
