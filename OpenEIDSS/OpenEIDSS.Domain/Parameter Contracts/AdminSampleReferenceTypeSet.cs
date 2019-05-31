using OpenEIDSS.Domain.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AdminSampleReferenceTypeSet
    {
        [Optional]
        public long ? idfsSampleType { get; set; }
        public string strDefault{ get; set; }
        public string  strName { get; set; }
        public string  strSampleCode { get; set; }

        public int intHaCode{ get; set; }
        
        public int intOrder{ get; set; }
        public string laguageId { get; set; }
    }
}
