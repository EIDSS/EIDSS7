namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OmmVetSample
    {
        public short idfVetSample { get; set; }
        public long? idfVetSampleTypeID { get; set; }
        public long? idfSpeciesID { get; set; }
        public string FieldId { get; set; }
        public string strAnimalID { get; set; }
        public long AnimalID { get; set; }
        public long? idfMonitoringSessionID { get; set; }
        public long? idfSampleStatusTypeId { get; set; }
        public System.DateTime? datCollectionDate { get; set; }
        public long? idfCollectedByOrganizationID { get; set; }
        public long? idfCollectedByPersonID { get; set; }
        public System.DateTime datSentDate { get; set; }
        public long? idfSentToOrganizationID { get; set; }
        public string strFieldSampleId { get; set; }
        public string Comments { get; set; }
        public long idfSiteId { get; set; }
        public System.DateTime datEnteredDate { get; set; }
        public long? idfBirdStatusTypeID { get; set; }
        public short intRowStatus { get; set; }
        public char RowAction { get; set; }
        public string Type { get; set; }
        public string Species { get; set; }
        public string BirdStatus { get; set; }
        public string CollectedByOrganization { get; set; }
        public string CollectedByPerson { get; set; }
        public string SentToOrganization { get; set; }
    }
}