using System;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    //Model used to stage data before sending to API.
    //this will serve as a local storage until a primary key can be established to link it
    public sealed class OmmHumanVetContact
    {
        public long? idfContactCasePerson { get; set; }
        public long idfHumanActual { get; set; }
        public string ContactName { get; set; }
        public long? ContactRelationshipTypeID { get; set; }
        public string Relation { get; set; }
        public DateTime DateOfLastContact { get; set; }
        public string PlaceOfLastContact { get; set; }
        public long? ContactStatusId { get; set; }
        public string ContactStatus { get; set; }
        public string Comments { get; set; }
        public string ContactType { get; set; }
        public long? idfsPersonContactType { get; set; }
        public int intRowStatus { get; set; }
    }
}