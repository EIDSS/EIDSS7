using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Parameter class that satisfies parameter values for the Human ActiveSurveillanceSessionToAction service method
    /// </summary>
    public sealed class HumanActiveSurveillanceSessionToActionParams
    {
        public long? idfMonitoringSession { get; set; }
        public long? idfPersonEnteredBy { get; set; }
        public long? idfsMonitoringSessionActionType { get; set; }
        public long? idfsMonitoringSessionActionStatus { get; set; }
        public System.DateTime? datActionDate { get; set; }
        public string strComments { get; set; }
    }
}
