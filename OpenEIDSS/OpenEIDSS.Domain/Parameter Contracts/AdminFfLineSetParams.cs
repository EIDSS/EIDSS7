using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AdminFfLineSetParams
    {
        public long? idfsDecorElementType{get;set;}
        public string langId{get;set;}
        public long? idfsFormTemplate{get;set;}
        public long? idfsSection{get;set;}
        public int? intLeft{get;set;}
        public int? intTop{get;set;}
        public int? intWidth{get;set;}
        public int? intHeight{get;set;}
        public int? intColor{get;set;}
        public bool? blnOrientation{get;set;}
        public long? idfDecorElement { get; set; }
    }
}
