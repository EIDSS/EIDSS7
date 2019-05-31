using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class CampaignSpeciesToSampleTypeParameters
    {
        [Required]
        public long CampaignToSampleTypeID { get; set; }
        public long? SpeciesTypeID { get; set; }
        public long? SampleTypeID { get; set; }
        [Required]
        public int OrderNumber { get; set; }
        public int? PlannedNumber { get; set; }
        public string Comments { get; set; }
        [Required]
        public int RowStatus { get; set; }
        public string RowAction { get; set; }
    }
}