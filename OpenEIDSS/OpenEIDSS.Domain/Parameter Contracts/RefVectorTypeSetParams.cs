using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class RefVectorTypeSetParams
    {
        public long ? idfsVectorType{ get; set; }
        public string strDefault{ get; set; }
        public string strName{ get; set; }
        public string strCode{ get; set; }
        public bool bitCollectionByPool{ get; set; }
        public  int intOrder{ get; set; }
        public string languageId { get; set; }
    }
}
