using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Return_Contracts
{
    /// <summary>
    /// The results returned when a call is made to the USSP_GBL_TESTING_SET stored procedure.
    /// </summary>
    public sealed class HumanActiveSurveillanceSessionToTestingResult : SPReturnResult
    {
        /// <summary>
        /// Specifies the inserted/updated identifier affected by this update stored procedure.
        /// </summary>
        public long? TestingId { get; set;  }

        public HumanActiveSurveillanceSessionToTestingResult( int resultCode, long? idfTesting ) :base(resultCode)
        {
            this.TestingId = idfTesting;
        }
    }
}
