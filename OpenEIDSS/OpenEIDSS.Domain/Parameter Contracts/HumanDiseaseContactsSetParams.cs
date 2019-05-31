using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
   public class HumanDiseaseContactsSetParams
    {
        public long? idfContactedCasePerson{get;set;}
        public long? idfsPersonContactType{get;set;}
        public long? idfHuman{get;set;}
        public long? idfHumanCase{get;set;}
        public System.DateTime? datDateOfLastContact{get;set;}
        public string strPlaceInfo{get;set;}
        public int? intRowStatus{get;set;}
        public System.Guid? rowguid{get;set;}
        public string strComments{get;set;}
        public string strMaintenanceFlag{get;set;}
        public string strReservedAttribute { get; set; }
    }
}
