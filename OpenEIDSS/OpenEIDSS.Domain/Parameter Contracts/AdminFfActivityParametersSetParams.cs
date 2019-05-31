using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AdminFfActivityParametersSetParams
    {
        public long? idfsParameter{get;set;}
        public long? idfObservation{get;set;}
        public long? idfsFormTemplate{get;set;}
        public string varValue{get;set;}
        public bool? isDynamicParameter{get;set;}
        public long? idfRow{get;set;}
        public long? idfActivityParameters { get; set; }
    }
}
