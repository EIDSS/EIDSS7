using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class FarmHerdSpeciesGetListParameters
    {
        [Required]
        public string LanguageID { get; set; }
        public long? VeterinaryDiseaseReportID { get; set; }
        public long? MonitoringSessionID { get; set; }
        public long? FarmID { get; set; }
        public long? FarmMasterID { get; set; }
        public string EIDSSFarmID { get; set; }
    }
}