using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OmmContactGetDetailParams
    {
        public string langId { get; set; }
        public long? OutbreakCaseContactUID { get; set; }
    }
}
