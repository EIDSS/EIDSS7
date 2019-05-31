using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class GblObservationSetParams
    {
       public  long? idfObservation{get;set;}
        public long? idfsFormTemplate{get;set;}
        public int?  intRowStatus{get;set;}
        public string strMaintenanceFlag{get;set;}
        public long? idfsSite { get; set; }
    }
}
