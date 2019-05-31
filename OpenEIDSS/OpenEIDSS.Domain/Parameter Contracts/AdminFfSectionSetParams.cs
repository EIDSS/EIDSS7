using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AdminFfSectionSetParams
    {
        public long? idfsParentSection { get; set; }
        public long? idfsFormType { get; set; }
        public string DefaultName { get; set; }
        public string NationalName { get; set; }
        public string langId { get; set; }
        public int? intOrder { get; set; }
        public bool? blnGrid { get; set; }
        public bool? blnFixedRowset { get; set; }
        public long? idfsMatrixType { get; set; }


        public long? idfsSection { get; set; }
    }
}
