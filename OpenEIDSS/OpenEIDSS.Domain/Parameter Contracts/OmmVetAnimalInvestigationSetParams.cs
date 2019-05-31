using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OmmVetAnimalInvestigationSetParams
    {
        public string langId { get; set; }
        public System.Int64 idfsClinical { get; set; }
        public System.Int64? idfHerd { get; set; }
        public string HerdCode { get; set; }
        public System.Int64? idfsSpeciesType { get; set; }
        public string SpeciesType { get; set; }
        public string AnimalId { get; set; }
        public System.Int64? ddlVetAge { get; set; }
        public string Age { get; set; }
        public System.Int64? ddlVetSex { get; set; }
        public string Sex { get; set; }
        public System.Int64? idfStatus { get; set; }
        public string Status { get; set; }
        public string Note { get; set; }
    }
}
