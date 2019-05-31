using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Body parameters used with a call to the HumanController or VeterinaryController.SaveActiveSurveillanceCampaign service method.
    /// </summary>
    public sealed class CampaignSetParameters
    {
        [Required]
        public string LanguageID { get; set; }
        public long? CampaignID { get; set; }
        public long? CampaignTypeID { get; set; }
        public long? CampaignStatusTypeID { get; set; }
        public DateTime? CampaignStartDate { get; set; }
        public DateTime? CampaignEndDate { get; set; }  
        public string EIDSSCampaignID { get; set; }
        public string CampaignName { get; set; }
        public string CampaignAdministrator { get; set; }
        public string Conclusion { get; set; }
        public long SiteID { get; set; }
        public long? DiseaseID { get; set; }
        public long? CampaignCategoryTypeID { get; set; }
        [Required]
        public string AuditUserName { get; set; }
        [Required]
        public int RowStatus { get; set; }
        public List<CampaignSpeciesToSampleTypeParameters> SpeciesToSampleTypeCombinations { get; set; }
        public List<CampaignMonitoringSessionParameters> MonitoringSessions { get; set; }
    }
}