using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AdminOrgGetListParams
    {
        public string languageId{get;set;}
        public long orgId {get;set;}
        public string organizationId{get;set;}
        public string organizationName{get;set;}
        public string organizationFullName {get;set;}
        public int haCode {get;set;}
        public long siteId {get;set;}
        public long regionId{get;set;}
        public long rayonId{get;set;}
        public long settlementId {get;set;}
        public long organizationTypeId { get; set; }
    }
}
