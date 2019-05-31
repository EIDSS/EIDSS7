using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Body parameters uses with a call to the VeterinaryController.SaveVeterinaryMonitoringSession service method.
    /// </summary>
    public sealed class MonitoringSessionSetParameters
    {
        [Required]
        public string LanguageID { get; set; }
        public long? MonitoringSessionID { get; set; }
        public long? MonitoringSessionStatusTypeID { get; set; }
        public long? CountryID { get; set; }
        public long? RegionID { get; set; }
        public long? RayonID { get; set; }
        public long? SettlementID { get; set; }
        public long EnteredByPersonID { get; set; }
        public long? CampaignID { get; set; }
        public string CampaignName { get; set; }
        public long? CampaignTypeID { get; set; }
        [Required]
        public long SiteID { get; set; }
        public DateTime? EnteredDate { get; set; }
        public string EIDSSSessionID { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public DateTime? CampaignStartDate { get; set; }
        public DateTime? CampaignEndDate { get; set; }
        public long? DiseaseID { get; set; }
        public long? SessionCategoryTypeID { get; set; }
        [Required]
        public int RowStatus { get; set; }
        public string AvianOrLivestock { get; set; }
        public string AuditUserName { get; set; }
        public List<MonitoringSessionToDiseaseParameters> DiseaseCombinations { get; set; }
        public List<FarmParameters> Farms { get; set; }
        public List<HerdParameters> HerdsOrFlocks { get; set; }
        public List<SpeciesParameters> Species { get; set; }
        public List<AnimalParameters> Animals { get; set; }
        public List<MonitoringSessionSpeciesToSampleTypeParameters> SpeciesToSampleTypeCombinations { get; set; }
        public List<VeterinarySampleParameters> Samples { get; set; }
        public List<LabTestParameters> Tests { get; set; }
        public List<TestInterpretationParameters> TestInterpretations { get; set; }
        public List<MonitoringSessionActionParameters> Actions { get; set; }
        public List<MonitoringSessionSummaryParameters> Summaries { get; set; }
    }
}
