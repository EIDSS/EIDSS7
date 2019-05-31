using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OmmSample
    {
        public long idfMaterial { get; set; }
        //public string strReason { get; set; }
        public string Sampletype { get; set; }
        public long? idfsSampleType { get; set; }
        public string LocalSampleId { get; set; }
        public DateTime? datCollectionDate { get; set; }
        public string CollectedByInstitution { get; set; }
        public long? idfFieldCollectedByOffice { get; set; }
        public string CollectedByOfficer { get; set; }
        public string SentDate { get; set; }
        public string SentToOrganization { get; set; }
    }
}
