using System;
using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class VeterinarySampleParameters
    {
        [Required]
        public long SampleID { get; set; }
        public long? SampleTypeID { get; set; }
        public long? SpeciesID { get; set; }
        public long? AnimalID { get; set; }
        public long? MonitoringSessionID { get; set; }
        public long? SampleStatusTypeID { get; set; }
        public DateTime? CollectionDate { get; set; }
        public long? CollectedByOrganizationID { get; set; }
        public long? CollectedByPersonID { get; set; }
        public DateTime? SentDate { get; set; }
        public long? SentToOrganizationID { get; set; }
        public string EIDSSLocalOrFieldSampleID { get; set; }
        public string Comments { get; set; }
        [Required]
        public long SiteID { get; set; }
        public DateTime? EnteredDate { get; set; }
        public long? DiseaseID { get; set; }
        public long? BirdStatusTypeID { get; set; }
        [Required]
        public int RowStatus { get; set; }
        public string RowAction { get; set; }
    }
}