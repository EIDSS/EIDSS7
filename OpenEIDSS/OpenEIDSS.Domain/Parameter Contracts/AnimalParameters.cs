using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class AnimalParameters
    {
        [Required]
        public long AnimalID { get; set; }
        public long? AnimalGenderTypeID { get; set; }
        public long? AnimalConditionTypeID { get; set; }
        public long? AnimalAgeTypeID { get; set; }
        public long? SpeciesID { get; set; }
        public long? ObservationID { get; set; }
        public string EIDSSAnimalID { get; set; }
        public string AnimalName { get; set; }
        public string Color { get; set; }
        public string AnimalDescription { get; set; }
        [Required]
        public int RowStatus { get; set; }
        public string RowAction { get; set; }
    }
}