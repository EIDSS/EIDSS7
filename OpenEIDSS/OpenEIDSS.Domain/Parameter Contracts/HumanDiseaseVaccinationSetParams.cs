using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class HumanDiseaseVaccinationSetParams
    {
        public long? humanDiseaseReportVaccinationUid { get; set; }
        public long? idfHumanCase { get; set; }
        public string  vaccinationName { get; set; }
        public System.DateTime? vaccinationDate { get; set; }
    }
}
