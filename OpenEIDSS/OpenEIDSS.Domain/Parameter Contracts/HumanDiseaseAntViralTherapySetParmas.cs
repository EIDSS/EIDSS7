using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class HumanDiseaseAntViralTherapySetParmas
    {
        public string antiviralTherapiesParameters { get; set; }
        public long? idfAntimicrobialTherapy { get; set; }
        public long? idfHumanCase { get; set; }
        public System.DateTime? datFirstAdministeredDate { get; set; }
        public string strAntimicrobialTherapyName { get; set; }
        public string strDosage { get; set; }
    }
}
