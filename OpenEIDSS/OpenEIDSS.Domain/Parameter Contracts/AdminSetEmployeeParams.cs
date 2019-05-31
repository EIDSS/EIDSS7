using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AdminSetEmployeeParams
    {
        public long personId{get;set;}
        public long staffPositionId{get;set;}
        public long institutionId{get;set;}
        public long departmentId{get;set;}
        public string familyName{get;set;}
        public string firstName{get;set;}
        public string secondName{get;set;}
        public string contactPhone{get;set;}
        public string barcode{get;set;}
        public long siteId{get;set;}
        public string user { get; set; }
    }
}
