using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OmmVetCaseMonitoring
    {
        public string langId { get; set; }
        public System.Int64 idfVetCaseMonitoring { get; set; }
        public System.DateTime? datMonitoringDate { get; set; }
        public string InvestigatorOrganization { get; set; }
        public string InvestigatorName { get; set; }
        public string AdditionalComments { get; set; }
    }
}
