using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AggregateCaseVerionPostParams
    {
        public long? idfVersion {get;set;}
        public long? idfsMatrixType {get;set;}
        public System.DateTime? datStartDate {get;set;}
        public string matrixName {get;set;}
        public bool? blnIsActive {get;set;}
        public bool? blnIsDefault { get; set; }
    }
}
