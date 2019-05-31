using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OMMSessionNoteGetListParams
    {
        public string langId { get; set; }
        public long? idfOutbreak { get; set; }
    }
}
