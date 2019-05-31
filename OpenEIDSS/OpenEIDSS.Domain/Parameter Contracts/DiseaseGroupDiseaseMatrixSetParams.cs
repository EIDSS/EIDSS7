using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
   public  class DiseaseGroupDiseaseMatrixSetParams
    {
        public long? idfDiagnosisToDiagnosisGroup { get; set; }
        public long? idfsDiagnosisGroup { get; set; }
        public long? idfsDiagnosis { get; set; }
    }
}
