using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Parameter class that satisfies parameter values for the HumanActiveSurveillanceSessionGetList service method
    /// </summary>
    public sealed class HumanActiveSurveillanceSessionGetListParams
    {
        public string monitoringSessionstrId { get; set; }
        public long? monitoringSessionidfsStatus { get; set; }
        public System.DateTime? monitoringSessionDatEnteredFrom { get; set; }
        public System.DateTime? monitoringSessionDatEnteredTo { get; set; }
        public long? monitoringSessionidfsRegion { get; set; }
        public long? monitoringSessionidfsRayon { get; set; }
        public long? monitoringSessionidfsDiagnosis { get; set; }
        public string monitoringSessionstrCampaignId { get; set; }
        public string langId { get; set; }
        public string sessionModule { get; set; }
    }
}
