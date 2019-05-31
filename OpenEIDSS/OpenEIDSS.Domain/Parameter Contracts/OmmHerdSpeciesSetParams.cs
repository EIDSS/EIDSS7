using System.Collections.Generic;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OmmHerdSpeciesSetParams
    {
        public string langId { get; set; }
        public long idfFarmActual { get; set; }
        public List<OmmHerdGetListModel> Herds { get; set; }
        public List<OmmSpeciesGetListModel> Species { get; set; }
    }
}
