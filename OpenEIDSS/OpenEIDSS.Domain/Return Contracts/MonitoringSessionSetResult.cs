using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Return_Contracts
{
    /// <summary>
    /// 
    /// </summary>
    public class MonitoringSessionSetResult : SPReturnResult
    {
        public long? MonitoringSessionId { get; set; }
        public string EIDSSId { get; set; }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="resultCode"></param>
        /// <param name="monitoringSessionId"></param>
        /// <param name="eidssId"></param>
        public MonitoringSessionSetResult(int resultCode, long? monitoringSessionId, string eidssId) : base(resultCode)
        {
            MonitoringSessionId = monitoringSessionId;
            EIDSSId = eidssId;
        }
    }
}
