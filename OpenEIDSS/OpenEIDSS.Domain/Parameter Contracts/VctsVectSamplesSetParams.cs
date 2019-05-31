using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
   public  class VctsVectSamplesSetParams
    {
        public string languageId{get;set;}
        public long idfMaterial{get;set;}
        public string strFieldBarcode{get;set;}
        public long idfsSampleType{get;set;}
        public long idfVectorSurveillanceSession{get;set;}
        public long idfVector{get;set;}
        public long idfSendToOffice{get;set;}
        public long idfFieldCollectedByOffice { get; set; }
    }
}
