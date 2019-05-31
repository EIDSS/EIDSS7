using System;
using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class MonitoringSessionActionParameters
    {
        [Required]
        public long MonitoringSessionActionID { get; set; }
        [Required]
        public long MonitoringSessionID { get; set; }
        public long? EnteredByPersonID { get; set; }
        public long? ActionTypeID { get; set; }
        public long? ActionStatusTypeID { get; set; }
        public DateTime? ActionDate { get; set; }
        public string Comments { get; set; }
        [Required]
        public int RowStatus { get; set; }
        public string RowAction { get; set; }
    }
}