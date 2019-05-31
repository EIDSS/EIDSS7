using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class ObjectAccessSetParams
    {
        public long idfObjectAccess{ get; set; }
        public long idfsObjectOperation{ get; set; }
        public long idfsObjectType{ get; set; }
        public long idfsObjectId{ get; set; }
        public long idfEmployee{ get; set; }
        public bool isAllow{ get; set; }
        public bool isDeny { get; set; }
    }
}
