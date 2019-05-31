using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Model that satisfies body parmater values to the OMMSessionNoteSet service method
    /// </summary>
    public sealed class OMMSessionNoteSetParams
    {
        public string langId {get; set; } 
        public long? idfOutbreakNote {get; set; }
        public long? idfOutbreak {get; set; } 
        public string strNote {get; set; }
        //public System.DateTime? datNoteDate {get; set; } 
        public long? idfPerson {get; set; }
        public int? intRowStatus {get; set; }
        public string strMaintenanceFlag {get; set; }
        public string strReservedAttribute {get; set; }
        public long? updatePriorityId {get; set; }
        public string updateRecordTitle {get; set; }
        public string uploadFileName {get; set; }
        public string uploadFileDescription {get; set; }
        public byte[] uploadFileObject {get; set; }
        public string DeleteAttachment { get; set; }
    }
}
