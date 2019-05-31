using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OMMSessionNoteGetDetailsParams
    {
        public string langId { get; set; }
        public long? idfOutbreakNote { get; set; }
    }
}