using OpenEIDSS.Domain.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AdminActivityFFFormsSetParams
    {
        [Optional]
        public long? idfsParameter{get;set;}
        [Optional]
        public long? idfObservation{get;set;}
        [Optional]
        public long? idfsFormTemplate{get;set;}
        public string varValue{get;set;}
        public bool? isDynamicParameter{get;set;}
        [Optional]
        public  long? idfRow{get;set;}
        [Optional]
        public long? idfActivityParameters { get;set; }
    }
}
