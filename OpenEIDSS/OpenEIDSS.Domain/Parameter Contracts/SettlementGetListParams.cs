using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class SettlementGetListParams
    {
        public string langId{ get; set; }
        public long idfsSettlement{ get; set; }
        public long idfsSettlementType{ get; set; }
        public string defaultName{ get; set; }
        public string strNationalName{ get; set; }
        public long idfsRegion{ get; set; }
        public long idfsRayon{ get; set; }
        public double latMin{ get; set; }
        public double latMax{ get; set; }
        public double lngMin{ get; set; }
        public double lngMax{ get; set; }

        public double elemMin { get; set; }
        public double eleMax { get; set; }
    }
}
