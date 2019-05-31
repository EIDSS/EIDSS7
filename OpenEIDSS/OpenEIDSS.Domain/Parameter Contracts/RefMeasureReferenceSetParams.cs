using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class RefMeasureReferenceSetParams
    {
        public long ? idfsBaseReference{ get; set; }
        public long idfsReferenceType{ get; set; }
        public string strDefault{ get; set; }
        public string strActionCode{ get; set; }
        public string strName{ get; set; }
        public int intOrder{ get; set; }
        public string languageId { get; set; }
    }
}
