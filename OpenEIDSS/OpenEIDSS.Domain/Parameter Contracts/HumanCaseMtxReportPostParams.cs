using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class HumanCaseMtxReportPostParams
    {
        public long? idfAggrHumanCaseMtx { get; set; }
        public long? idfVersion { get; set; }
        public long? idfsDiagnosis { get; set; }
        public int? intNumRow { get; set; }
    }

    public class VetCaseMtxReportPostParams
    {
        public long? idfAggrVetCaseMTX { get; set; }
        public long? idfVersion { get; set; }
        public long? idfsDiagnosis { get; set; }
        public long? idfsSpeciesType { get; set; }
        public int? intNumRow { get; set; }
    }

    public class SanitaryMtxReportPostParams
    {
        public long? idfAggrSanitaryActionMTX { get; set; }
        public long? idfVersion { get; set; }
        public long? idfsSanitaryAction { get; set; }
        public int? intNumRow { get; set; }
    }


    public class VetDiagnosisInvestigationMtxReportPostParams
    {
        public long? idfAggrDiagnosticActionMTX { get; set; }
        public long? idfVersion { get; set; }
        public long? idfsDiagnosis { get; set; }
        public long? idfsSpeciesType { get; set; }
         public long? idfsDiagnosticAction { get; set; }
        public int? intNumRow { get; set; }
    }


    public class ProphylacticMtxReportPostParams
    {
        public long? idfAggrProphylacticActionMTX { get; set; }
        public long? idfVersion { get; set; }
        public long? idfsDiagnosis { get; set; }
        public long? idfsSpeciesType { get; set; }
        public long? idfsProphilacticAction { get; set; }
        public int? intNumRow { get; set; }
    }
}
