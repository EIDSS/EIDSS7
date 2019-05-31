using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class ILIAggregateSetParams
    {
        public string langId{get;set;}


        public long? idfAggregateDetail { get; set; }

        public long? idfAggregateHeader { get; set; }


        public long? idfEnteredBy{get;set;}
        public long? idfsSite{get;set;}
        public int? intYear{get;set;}
        public int? intWeek{get;set;}
        public System.DateTime? datStartDate{get;set;}
        public System.DateTime? datFinishDate{get;set;}

        public long? idfHospital { get; set; }

        public long? intAge0_4 { get; set; }

        public long? intAge5_14 { get; set; }

        public int? intAge15_29 { get; set; }

        public int? intAge30_64 { get; set; }
        public int? intAge65 { get; set; }
        public int? inTotalIli { get; set; }
        public int? intTotalAdmissions { get; set; }
        public int? intIliSamples { get; set; }

        public int? intRowStatus{get;set;}

    }
}
