using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AdminFfParameterDesignOptionsSetParams
    {
        public long? idfsParameter{get;set;}
        public long? idfsFormTemplate{get;set;}
        public int? intLeft{get;set;}
        public int? intTop{get;set;}
        public int? intWidth{get;set;}
        public int? intHeight{get;set;}
        public int? intScheme{get;set;}
        public int? intLabelSize{get;set;}
        public int? intOrder{get;set;}
        public string langId { get; set; }
    }
}
