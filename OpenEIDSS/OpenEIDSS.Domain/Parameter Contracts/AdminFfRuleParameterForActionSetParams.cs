using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AdminFfRuleParameterForActionSetParams
    {

        public long? idfsRule { get; set; }
        public long? idfsFormTemplate{get;set;}
        public long? idfsParameter{get;set;}

        public long? idfsRuleAction { get; set; }
    }
}
