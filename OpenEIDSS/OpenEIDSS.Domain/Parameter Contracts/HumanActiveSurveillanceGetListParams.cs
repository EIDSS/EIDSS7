using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Parameter class that satisfies parameter values for the HumanActiveSurveillanceGetList service method.
    /// </summary>
    public class HumanActiveSurveillanceGetListParams
    {
        public string campaignStrIdFilter;
        public string campaignNameFilter;
        public long? campaignTypedFilter;
        public long? campaignStatusFilter;
        public System.DateTime? startDateFromFilter;
        public System.DateTime? startToFilter;
        public long? campaignDiseaseFilter;
        public string langId;
        public string campaignModule;
    }
}
