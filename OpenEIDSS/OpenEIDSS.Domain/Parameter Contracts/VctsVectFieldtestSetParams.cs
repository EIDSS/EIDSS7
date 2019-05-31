using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class VctsVectFieldtestSetParams
    {
        public string strFieldBarCode{get;set;}
        public string langId{get;set;}
        public long idfTesting{get;set;}
        public long idfsTestName {get;set;}
        public long idfsTestCategory {get;set;}
        public long idfTestedByOffice {get;set;}
        public long idfsTestResult{get;set;}
        public long idfTestedByPerson {get;set;}
        public long idfsDiagnosis { get; set; }
    }
}
