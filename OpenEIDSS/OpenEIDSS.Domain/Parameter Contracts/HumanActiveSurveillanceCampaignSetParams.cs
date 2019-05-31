using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Parameter class that satisfies parameter values for the HumanActiveSurveillanceCampaignSet service method.
    /// </summary>
    public sealed class HumanActiveSurveillanceCampaignSetParams
    {
        public long? idfCampaign {get; set; }
        public long? idfsCampaignType {get; set; }
        public long? idfsCampaignStatus {get; set; }
        public System.DateTime? datCampaignDateStart {get; set; }
        public System.DateTime? datCampaignDateEnd {get; set; }
        public string strCampaignId {get; set; }
        public string strCampaignName {get; set; }
        public string strCampaignAdministrator {get; set; }
        public string strComments {get; set; }
        public string strConclusion {get; set; }
        public long? idfsDiagnosis {get; set; }
        public long? campaignCategoryId {get; set; }
        public System.DateTime? datModificationForArchiveDate {get; set; }
    }
}
