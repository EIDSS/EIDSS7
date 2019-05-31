using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class ReferenceDiagnosisSetParams
    {
        public long ? idfsDiagnosis{ get; set; }
        public string strDefault{ get; set; }
        public string strName{ get; set; }
        public string strOieCode{ get; set; }
        public string strIdc10{ get; set; }
        public int intHaCode{ get; set; }
        public long idfsUsingType{ get; set; }
        public int intOrder{ get; set; }
        public bool blnZoonotic { get; set; }
        public bool blnSyndrome { get; set; }
        public string langId { get;  set; }
        public string strPensideTest { get; set; }
        public string strLabTest { get; set; }
        public string strSampleType { get; set; }

    }
}
