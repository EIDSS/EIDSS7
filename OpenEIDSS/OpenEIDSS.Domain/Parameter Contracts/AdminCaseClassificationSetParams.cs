using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
   public  class AdminCaseClassificationSetParams
    {
        public long? idfsCaseClassification{ get; set; }
        public string    strDefault { get; set; }
        public string  strName { get; set; }
        public bool blnInitialHumanCaseClassification { get; set; }
        public bool blnFinalHumanCaseClassification { get; set; }
        public string languageId { get; set; }
        public int intOrder { get; set; }
        public int intHaCode { get; set; }
    }
}
