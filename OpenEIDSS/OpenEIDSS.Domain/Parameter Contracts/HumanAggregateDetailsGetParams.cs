using OpenEIDSS.Domain.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class HumanAggregateDetailsGetParams
    {
        public string langId {get;set;}
        [Optional]
        public long? idfsAggrCaseType {get;set;}
        [Optional]
        public long? idfAggrCase {get;set;}
        [Optional]
        public string strSearchCaseId {get;set;}
        [Optional]
        public long? idfsTimeInterval {get;set;}
        [Optional]
        public System.DateTime? datSearchStartDate {get;set;}
        [Optional]
        public System.DateTime? datSearchEndDate {get;set;}
        [Optional]
        public long? idfsAdministrativeUnit { get; set; }
    }
}
