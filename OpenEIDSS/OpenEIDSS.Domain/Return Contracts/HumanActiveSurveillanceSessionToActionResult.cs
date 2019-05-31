using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Return_Contracts
{
    /// <summary>
    /// The Montoring session action identifier returned when a call is made to the USP_GBL_ASSESSIONTOACTION_SET stored procedure.
    /// </summary>
    public sealed class HumanActiveSurveillanceSessionToActionResult :SPReturnResult
    {
           /// <summary>
        /// Specifies the inserted/updated identifier affected by this update stored procedure.
        /// </summary>
        public long? MonitoringSessionActionId { get; set; }

        public HumanActiveSurveillanceSessionToActionResult( int resultCode, long? monitoringSessionActionId ) :base(resultCode)
        {
            this.MonitoringSessionActionId = monitoringSessionActionId;
        }
    }
}
