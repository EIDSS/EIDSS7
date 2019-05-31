using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Return_Contracts
{
    /// <summary>
    /// Campaign Set results container that indicates the state of the call
    /// </summary>
    public class CampaignSetResult : SPReturnResult
    {
        /// <summary>
        /// The updated campaign identifier in the case where the call resulted in an insert
        /// </summary>
        public long? CampaignID { get; set; }

        /// <summary>
        /// The updated campaign identifier string in the case where the call resulted in an insert
        /// </summary>
        public string CampaignIDString { get; set; }

        /// <summary>
        /// Instantiates a new instance of the CampaignSetResult class.
        /// </summary>
        /// <param name="resultCode"></param>
        public CampaignSetResult( int resultCode, long? campaignId ) :base( resultCode)
        {
            this.CampaignID = campaignId;
        }
    }
}
