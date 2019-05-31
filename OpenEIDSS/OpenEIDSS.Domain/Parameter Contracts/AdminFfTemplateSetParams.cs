using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AdminFfTemplateSetParams
    {
        public long? idfsFormType{get;set;}
        public string defaultName{get;set;}
        public string nationalName{get;set;}
        public string strNote{get;set;}
        public string langId {get;set;}
        public bool? blnUni{get;set;}
        public long? idfsFormTemplate { get; set; }
    }
}
