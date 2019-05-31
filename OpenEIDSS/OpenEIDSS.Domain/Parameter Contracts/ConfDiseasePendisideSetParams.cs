using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class ConfDiseasePendisideSetParams
    {
        public long? idfPensideTestForDisease { get; set; }
        public long? idfsDiagnosis { get; set; }
        public long? idfsPensideTestName {get;set;}
    }
}
