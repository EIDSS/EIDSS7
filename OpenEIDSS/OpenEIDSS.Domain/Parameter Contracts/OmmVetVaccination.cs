using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OmmVetVaccination
    {
        public System.Int64? idfVetVaccination { get; set; }
        public string Species { get; set; }
        public System.Int64? idfType { get; set; }
        public System.Int64? idfRoute { get; set; }
        public System.Int64? idfDisease { get; set; }
        public DateTime Date { get; set; }
        public string Manufacturer { get; set; }
        public string LotNumber { get; set; }
        public System.Int16? NumberVaccinated { get; set; }
        public string Comments { get; set; }
        public System.Int16 RowStatus { get; set; }
        public System.Char RowAction { get; set; }
        public string Name { get; set; }
        public System.Int64? idfSpecies { get; set; }
        public string Type { get; set; }
        public string Route { get; set; }
    }

}
