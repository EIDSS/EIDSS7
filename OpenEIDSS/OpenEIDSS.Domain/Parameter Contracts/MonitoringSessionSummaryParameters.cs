using System;
using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class MonitoringSessionSummaryParameters
    {
        [Required]
        public long MonitoringSessionSummaryID { get; set; }
        [Required]
        public long MonitoringSessionID { get; set; }
        public long? FarmID { get; set; }
        public long? SpeciesID { get; set; }
        public long? AnimalGenderTypeID { get; set; }
        public int? SampledAnimalsQuantity { get; set; }
        public DateTime? CollectionDate { get; set; }
        public int? PositiveAnimalsQuantity { get; set; }
        public long? SampleTypeID { get; set; }
        public bool? SampleCheckedIndicator { get; set; }
        public long? DiseaseID { get; set; }
        [Required]
        public int RowStatus { get; set; }
        public string RowAction { get; set; }
    }
}