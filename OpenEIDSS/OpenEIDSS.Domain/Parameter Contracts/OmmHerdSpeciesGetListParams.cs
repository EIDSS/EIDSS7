using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
  public sealed class OmmHerdSpeciesGetListParams
    {
        public string langId { get; set; }
        public long? idfFarmActual { get; set; }
    }
  
}