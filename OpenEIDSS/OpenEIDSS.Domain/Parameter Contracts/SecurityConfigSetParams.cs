using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
   public class SecurityConfigSetParams
    {
        public long id { get; set; }
        public int intAccountLockTimeout { get; set; }
        public int intInactivityTimeout{ get; set; }
        public int intPasswordAge{ get; set; }
        public int intPasswordHistoryLength{ get; set; }
        public int intForcePasswordComplexity { get; set; }
    }
}
