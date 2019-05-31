using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AdminFfRulesSetParams
    {
        public long? idfsFormTemplate{get;set;}
        public long? idfsCheckPoint{get;set;}
        public long? idfsRuleFunction{get;set;}
        public string defaultName{get;set;}
        public string nationalName{get;set;}
        public string messageText{get;set;}
        public string messageNationalText{get;set;}
        public bool? blnNot{get;set;}
        public string langId{get;set;}
        public long? idfsRule{get;set;}
        public long? idfsRuleMessage { get; set; }
    }
}
