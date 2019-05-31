namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OmmVetPensideTest
    {
        public long idfVetPensideTest { get; set; }
        public string FieldSampleId { get; set; }
        public long? idfSampleType { get; set; }
        public string SampleType { get; set; }
        public long? idfSpecies { get; set; }
        public string Species { get; set; }
        public string strAnimalId { get; set; }
        public long? AnimalId { get; set; }
        public long? idfTestName { get; set; }
        public string TestName { get; set; }
        public long? idfResult { get; set; }
        public string Result { get; set; }
        public int intRowStatus { get; set; }
    }
}