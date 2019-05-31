using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class DepartmentSetParams
    {
        public string action { get; set; }
        public long idfDepartment { get; set; }
        public long idfOrganization { get; set; }
        public string defaultName { get; set; }
        public string name { get; set; }
        public long idfsCountry { get; set; }
        public string langId { get; set; }
        public string user { get; set; }
    }
}
