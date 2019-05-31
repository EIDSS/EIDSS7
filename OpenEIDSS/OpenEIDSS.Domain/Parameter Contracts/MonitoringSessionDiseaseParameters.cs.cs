using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class MonitoringSessionToDiseaseParameters
    {
        [Required]
        public long MonitoringSessionToDiseaseID { get; set; }
        [Required]
        public long MonitoringSessionID { get; set; }
        public long DiseaseID { get; set; }
        public long? SampleTypeID { get; set; }
        public long? SpeciesTypeID { get; set; }
        [Required]
        public int OrderNumber { get; set; }
        public int RowStatus { get; set; }
        public string RowAction { get; set; }
    }
}