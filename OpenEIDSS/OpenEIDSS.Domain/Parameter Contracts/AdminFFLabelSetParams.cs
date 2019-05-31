using OpenEIDSS.Domain.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AdminFFLabelSetParams
    {
        public string langId{get;set;}
        [Optional]
        public long? idfsFormTemplate{get;set;}
        [Optional]
        public long? idfsSection{get;set;}
        [Optional]
        public int? intLeft{get;set;}
        [Optional]
        public int? intTop{get;set;}
        [Optional]
        public int? intWidth{get;set;}
        [Optional]
        public int? intHeight{get;set;}
        [Optional]
        public int? intFontStyle{get;set;}
        [Optional]
        public int? intFontSize{get;set;}
        [Optional]
        public int? intColor{get;set;}
        public string defaultText{get;set;}
        public string nationalText { get; set; }
    }
}
