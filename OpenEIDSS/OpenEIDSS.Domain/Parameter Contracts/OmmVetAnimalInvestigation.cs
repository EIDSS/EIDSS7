namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OmmVetAnimalInvestigation
    {
        public string AnimalId { get; set; }
        public long? idfAnimalGenderTypeID { get; set; }
        public long? idfAnimalConditionType { get; set; }
        public long? AnimalAgeTypeId { get; set; }
        public long? idfsSpeciesType { get; set; }
        public long? ObservationId { get; set; }
        public string strAnimalId { get; set; }
        public string AnimalName { get; set; }
        public string Color { get; set; }
        public string AnimalDescription { get; set; }
        public short RowStatus { get; set; }
        public char RowAction { get; set; }
        public long idfsClinical { get; set; }
        public long? idfHerd { get; set; }
        public string HerdCode { get; set; }
        public string SpeciesType { get; set; }
        public long? ddlVetAge { get; set; }
        public string Age { get; set; }
        public long? ddlVetSex { get; set; }
        public string Sex { get; set; }
        public long? idfStatus { get; set; }
        public string Status { get; set; }
        public string Note { get; set; }
        public int intRowStatus { get; set; }
    }
}