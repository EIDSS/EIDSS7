using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain
{
    public sealed class OmmVetSample
    {
        public System.Int16 idfVetSample { get; set; }
        public System.Int64? idfVetSampleTypeID { get; set; }
        public string Type { get; set; }
        public string FieldId { get; set; }
        public System.Int64? idfSpeciesID { get; set; }
        public string Species { get; set; }
        public System.Int64? idfBirdStatusTypeID { get; set; }
        public string BirdStatus { get; set; }
        public System.DateTime? datCollectionDate { get; set; }
        public System.Int64? idfCollectedByOrganizationID { get; set; }
        public string CollectedByOrganization { get; set; }
        public System.Int64? idfCollectedByPersonID { get; set; }
        public string CollectedByPerson { get; set; }
        public System.Int64? idfSentToOrganizationID { get; set; }
        public string SentToOrganization { get; set; }
    }
}
