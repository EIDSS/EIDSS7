using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class ConfTesttotestresultmatrixSetParams
    {
        public long? idfsTestName { get; set; }
        public long? idfsTestResult { get; set; }
        public bool? blnIndicative { get; set; }

        public long? idfsTestResultRelation { get; set; }
    }
}
