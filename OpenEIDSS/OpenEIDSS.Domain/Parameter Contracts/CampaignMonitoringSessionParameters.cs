using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class CampaignMonitoringSessionParameters
    {
        [Required]
        public long MonitoringSessionID { get; set; }
    }
}