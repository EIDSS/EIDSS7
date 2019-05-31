using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
   public  class AdminSetSettlementParams
    {

      public long  idfsStatistic{ get; set; }
        public long idfsStatisticalAgeGroup{ get; set; }
        public long idfsMainBaseReference{ get; set; }
        public long idfsStatisticAreaType{ get; set; }
        public long idfsStatisticPeriodType{ get; set; }
        public long locationUserControlidfsCountry{ get; set; }
        public long locationUserControlidfsRegion{ get; set; }
        public long locationUserControlidfsRayon{ get; set; }
        public DateTime datStatisticStartDate{ get; set; }
        public DateTime datStatisticFinishDate{ get; set; }
        public long idfsParameterName { get; set; }

        public string  varValue { get; set; }
    }
}
