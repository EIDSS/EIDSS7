using System;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OMMContactSetParams
    {
        public string langId { get; set; }
        public long? OutbreakCaseContactUID { get; set; }
        public long? OutbreakCaseReportUID { get; set; }
        public long? idfHuman { get; set; }
        public long? contactLocationidfsCountry { get; set; }
        public long? contactLocationidfsRegion { get; set; }
        public long? contactLocationidfsRayon { get; set; }
        public long? contactLocationidfsSettlement { get; set; }
        public string strStreetName { get; set; }
        public string strPostCode { get; set; }
        public string strBuilding { get; set; }
        public string strHouse { get; set; }
        public string strApartment { get; set; }
        public string strAddressString { get; set; }
        public long? ContactRelationshipTypeID { get; set; }
        public DateTime? DateOfLastContact { get; set; }
        public string phone { get; set; }
        public string PlaceOfLastContact { get; set; }
        public string CommentText { get; set; }
        public long? ContactStatusID { get; set; }
        public int? intRowStatus { get; set; }
        public string AuditUser { get; set; }
        public DateTime? AuditDTM { get; set; }
        public long? ContactTracingObservationID { get; set; }
    }

    public sealed class OmmContact
    {
        public long? idfContactCasePerson { get; set; }
        public string ContactType { get; set; } //Locally Used
        public string ContactName { get; set; } //Locally Used
        public string Relation { get; set; } //Locally Used
        public DateTime? DateOfLastContact { get; set; }
        public string PlaceOfLastContact { get; set; }
        public string ContactStatus { get; set; } //Locally Used
        public long? idfsPersonContactType { get; set; }
        public long? ContactRelationshipTypeID { get; set; }
        public long? ContactStatusID { get; set; }
    }
}