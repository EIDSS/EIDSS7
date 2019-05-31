using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{

    public class AdminFfRuleParameterForFunctionSetAsyncParams
    {
        public long? idfsParameter{get;set;}
        public long? idfsFormTemplate{get;set;}
        public long? idfsRule{get;set;}
        public int? intOrder{get;set;}
   //     public long? idfParameterForFunction { get; set; }
    }
}
