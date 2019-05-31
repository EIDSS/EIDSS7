using OpenEIDSS.Domain.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Parameter class that satisfies parameter values for the HumanActiveSurveillanceSessionSet service method.
    /// </summary>
    public sealed class HumanActiveSurveillanceSessionSetParams
    {
        [Optional]
        public long? dfMonitoringSession { get; set; }
        [Optional]
        public long? idfsMonitoringSessionStatus { get; set; }
        [Optional]
        public long? idfsCountry { get; set; }
        [Optional]
        public long? idfsRegion { get; set; }
        [Optional]
        public long? idfsRayon { get; set; }
        [Optional]
        public long? idfsSettlement { get; set; }
        [Optional]
        public long? idfPersonEnteredBy { get; set; }
        [Optional]
        public long? idfCampaign { get; set; }
        [Optional]
        public long? idfsDiagnosis { get; set; }
        [Optional]
        public System.DateTime? datEnteredDate { get; set; }
        [Optional]
        public System.DateTime? datStartDate { get; set; }
        [Optional]
        public System.DateTime? datEndDate { get; set; }
        [Optional]
        public long? sessionCategoryId { get; set; }
        [Optional]
        public long? idfsSite { get; set; }
        [Optional]
        public string strMonitoringSessionId { get; set; }

    }
}
