using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
   public class AdminFfParameterFixedPresetValueSet
    {
        public long? idfsParameterType{get;set;}
        public string defaultName{get;set;}
        public string nationalName {get;set;}
        public string langId{get;set;}
        public int? intOrder{get;set;}
        public long? idfsParameterFixedPresetValue { get; set; }
    }
}
