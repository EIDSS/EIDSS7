using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class VctsSessionsummarydiagnosisSetParams
    {

        public long idfsVsSessionSummaryDiagnosis { get; set; }

        public long idfsVsSessionSummary { get; set; }

        public long idfsDiagnosis{ get; set; }

        public int intPositiveQuantity { get; set; }
    }
}
