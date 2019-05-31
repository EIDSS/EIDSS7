using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AdminFfTemplateDeterminantValuesSetParams
    {
        public long? idfsFormTemplate{get;set;}
        public long? idfsBaseReference{get;set;}
        public long? idfsGisBaseReference{get;set;}
        public  long? idfDeterminantValue { get; set; }
    }
}
