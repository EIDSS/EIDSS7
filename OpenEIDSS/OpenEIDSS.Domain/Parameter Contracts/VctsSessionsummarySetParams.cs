using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class VctsSessionsummarySetParams
    {
        
          public long  idfsVsSessionSummary{get;set;}
        public long idfDiagnosisVectorSurveillanceSession { get;set;}
        public string strVsSessionSummaryId{get;set;}
        public long diagnosisidfGeoLocation { get;set;}
        public long lucAggregateCollectiondblAccuracy { get;set;}
        public long lucAggregateCollectionidfsGroundType { get;set;}
        public long lucAggregateCollectionidfsGeolocationType { get;set;}
        public long lucAggregateCollectionidfsCountry { get;set;}
        public long lucAggregateCollectionidfsRegion { get;set;}
        public long lucAggregateCollectionidfsRayon { get;set;}
        public long lucAggregateCollectionidfsSettlement { get;set;}
        public string lucAggregateCollectionstrApartment { get;set;}
        public string lucAggregateCollectionstrBuilding { get;set;}
        public string lucAggregateCollectionstrStreetName { get;set;}
        public string lucAggregateCollectionstrHouse { get;set;}
        public string lucAggregateCollectionstrPostCode { get;set;}
        public string lucAggregateCollectionstrDescription { get;set;}
        public long lucAggregateCollectiondblDistance { get;set;}
        public long lucAggregateCollectionstrLatitude { get;set;}
        public long lucAggregateCollectionstrLongitude { get;set;}
        


        public long lucAggregateCollectiondblAlignment { get;set;}
        public bool blnForeignAddress { get;set;}
        public string strForeignAddress { get;set;}
        public bool blnGeoLocationShared{get;set;}
        public DateTime datSummaryCollectionDateTime { get;set;}
        public long summaryInfoSpecies { get;set;}
        public long summaryInfoSex { get;set;}
        public long poolsVectors{get;set;}
        //public string procResult { get; set; }
    }
}
