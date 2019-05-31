using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class VectorSurveillanceSessionSetParams
    {
        public long idfVectorSurveillanceSession { get;set;}
        public string strSessionId { get;set;}
        public string strFieldSessionId { get;set;}
        public long idfsVectorSurveillanceStatus { get;set;}
        public DateTime? datStartDate { get;set;}
        public DateTime? datCloseDate { get;set;}
        public long? idfOutbreak { get;set;}
        public int intCollectionEffort { get;set;}
        public DateTime? datModificationForArchiveDate { get;set;}
        public long idfGeoLocation { get;set;}
        public long idfsGeolocationType { get;set;}
        public long idfsCountry { get;set;}
        public long idfsRegion { get;set;}
        public long? idfsRayon { get;set;}
        public long? idfsSettlement { get;set;}
        public double dblLatitude { get; set; }
        public double? dblLongitude { get; set; }
        public string strDescription { get; set; }
        public long? idfsGroundType { get; set; }
        public double? dblDistance { get; set; }
        public double? dblDirection { get; set; }
        public string strStreetName { get; set; }
        public bool? blnForeignAddress { get; set; }
        public string strForeignAddress { get; set; }
        public bool? blnGeoLocationShared { get; set; }

        //public bool addressType { get; set; }
        //public string foreignAddressType { get; set; }
        //public double vectorInsstrLatitude { get; set; }
        //public double vectorInsstrLongitude { get; set; }
    }
}
