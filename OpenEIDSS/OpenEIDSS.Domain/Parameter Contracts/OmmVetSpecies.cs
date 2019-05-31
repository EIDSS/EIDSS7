using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class OmmVetSpecies
    {
        public System.Int64? idfSpecies { get; set; }
        public System.Int64? idfSpeciesActual { get; set; }
        public System.Int64? idfsSpeciesType { get; set; }
        public System.Int64? idfHerd { get; set; }
        public System.Int32? intSickAnimalQty { get; set; }
        public System.Int32? intTotalAnimalQty { get; set; }
        public System.Int32? intDeadAnimalQty { get; set; }
        public System.DateTime? datStartOfSignsDate { get; set; }
        public System.Int32? intAverageAge { get; set; }
        public System.Int64? ObservationId { get; set; }
        public System.String strNote { get; set; }
        public System.Int32? intRowStatus { get; set; }
        public System.Char RowAction { get; set; }
        public System.Int64 idfHerdActual { get; set; }
    }

}
