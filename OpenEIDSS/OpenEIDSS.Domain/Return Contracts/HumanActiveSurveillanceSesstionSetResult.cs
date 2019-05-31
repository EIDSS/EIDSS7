using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Return_Contracts
{
    public sealed class HumanActiveSurveillanceSessionSetResult : SPReturnResult
    {
        /// <summary>
        /// Specifies the inserted/updated identifier affected by this update stored procedure.
        /// </summary>
        public long? MonitoringSessionId { get; set; }
        /// <summary>
        /// Specifies the inserted/updated identifier (as a string) affected by this update stored procedure.
        /// </summary>
        public string MonitoringSessionIdString { get; set; }

        public HumanActiveSurveillanceSessionSetResult( int resultCode, long? idfMonitoringSession, string strMonitoringSessionId) : base( resultCode)
        {
            this.MonitoringSessionId = idfMonitoringSession;
            this.MonitoringSessionIdString = strMonitoringSessionId;
        }

    }
}
