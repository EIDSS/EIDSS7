using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
   public class AdminFfParameterTypesSetParams
    {
        public string defaultName{get;set;}
        public string nationalName {get;set;}
        public long? idfsReferenceType{get;set;}
        public string langId{get;set;}
        public long? idfsParameterType { get; set; }
    }
}
