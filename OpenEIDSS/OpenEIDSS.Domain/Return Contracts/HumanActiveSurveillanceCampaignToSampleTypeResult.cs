using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Return_Contracts
{
    /// <summary>
    /// CampaignToSample Set results container that indicates the state of the call
    /// </summary>
    public sealed class HumanActiveSurveillanceCampaignToSampleTypeResult :SPReturnResult
    {
        /// <summary>
        /// The updated campaign to sample type identifier in the case where the call resulted in an insert
        /// </summary>
        public long? CampaignToSampleTypeUid { get; set; }
        public HumanActiveSurveillanceCampaignToSampleTypeResult( int resultCode, long? campaignSampleTypeId) :base( resultCode)
        {
            this.CampaignToSampleTypeUid = campaignSampleTypeId;
        }
    }
}
