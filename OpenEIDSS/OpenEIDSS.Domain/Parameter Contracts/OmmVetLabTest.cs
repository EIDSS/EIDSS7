using System;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OmmVetLabTest
    {
        public long? idfLabTest { get; set; }
        public string LabSampleId { get; set; }
        public string SampleType { get; set; }
        public string FieldSampleId { get; set; }
        public string strAnimalId { get; set; }
        public string AnimalId { get; set; }
        public string Species { get; set; }
        public long? idfSpecies { get; set; }
        public string TestDisease { get; set; }
        public long? idfTestDisease { get; set; }
        public string TestName { get; set; }
        public long? idfTestName { get; set; }
        public string TestCategory { get; set; }
        public long? idfTestCategory { get; set; }
        public string TestStatus { get; set; }
        public DateTime ResultDate { get; set; }
        public string ResultObservation { get; set; }
        public long? idfResultObservcvation { get; set; }
        public int intRowStatus { get; set; }
    }
}