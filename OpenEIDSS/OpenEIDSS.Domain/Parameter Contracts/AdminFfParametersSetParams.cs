using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
   public  class AdminFfParametersSetParams
    {
        public long? idfsSection{get;set;}
        public long? idfsFormType{get;set;}
        public int? intScheme{get;set;}
        public long? idfsParameterType{get;set;}
        public long? idfsEditor{get;set;}
        public int? intHaCode{get;set;}
        public int? intOrder{get;set;}
        public string strNote {get;set;}
        public string defaultName{get;set;}
        public string nationalName{get;set;}
        public string defaultLongName{get;set;}
        public string nationalLongName{get;set;}
        public string langId{get;set;}
        public int? intLeft{get;set;}
        public int? intTop{get;set;}
        public int? intWidth{get;set;}
        public int? intHeight{get;set;}
        public int? intLabelSize { get; set; }
    }
}
