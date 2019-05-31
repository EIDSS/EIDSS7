using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AdminFfSectionTemplateRecursiveSetParams
    {
        public long? idfsSection{get;set;}
        public long? idfsFormTemplate{get;set;}
        public bool? blnFreeze{get;set;}
        public string langId{get;set;}
        public int? intLeft{get;set;}
        public int? intTop{get;set;}
        public int? intWidth{get;set;}
        public int? intHeight{get;set;}
        public int? intOrder { get; set; }
    }
}
