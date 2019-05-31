using OpenEIDSS.Domain.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Parameter class that satisfies parameter values for the HumanActiveSurveillanceCampaignToSampleTypeParams service method.
    /// </summary>
    public sealed class HumanActiveSurveillanceCampaignToSampleTypeParams
    {
        [Optional]
        public long campaignToSampleTypeUid { get; set; }
        [Optional]
        public long? idfCampaign { get; set; }
        [Optional]
        public int? intOrder { get; set; }
        [Optional]
        public long? idfsSpeciesType { get; set; }
        [Optional]
        public int? intPlannedNumber { get; set; }
        [Optional]
        public long? idfsSampleType { get; set; }
    }
}
