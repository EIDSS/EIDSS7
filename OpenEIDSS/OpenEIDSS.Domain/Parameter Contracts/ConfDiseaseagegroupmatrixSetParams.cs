using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class ConfDiseaseagegroupmatrixSetParams
    {
        public long? idfDiagnosisAgeGroupToDiagnosis{get;set;}
        public long? idfsDiagnosis{get;set;}
        public long? idfsDiagnosisAgeGroup { get; set; }
    }
}
