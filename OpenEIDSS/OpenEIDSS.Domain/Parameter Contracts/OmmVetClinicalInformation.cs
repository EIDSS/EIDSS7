namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OmmVetClinicalInformation
    {
        public string langId { get; set; }
        public long idfHerdActual { get; set; }
        public long idfHerd { get; set; }
        public string Herd { get; set; }
        public short idfsClinical { get; set; }
        public long? idfsSpeciesType { get; set; }
        public string SpeciesType { get; set; }
        public long? idfsStatus { get; set; }
        public long? idfsInvestigationPerformed { get; set; }
        public int intRowStatus { get; set; }
    }
}