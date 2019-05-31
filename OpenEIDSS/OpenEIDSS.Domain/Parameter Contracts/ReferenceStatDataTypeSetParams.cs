using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
   public  class ReferenceStatDataTypeSetParams
    {
        public long ? idfsStatisticDataType { get; set; }
        public long idfsReferenceType{ get; set; }
        public string strDefault{ get; set; }
        public string strName{ get; set; }
        public long idfsStatisticPeriodType{ get; set; }
        public long ? idfsStatisticAreaType{ get; set; }
        public bool blnRelatedWithAgeGroup{ get; set; }
        public string languageId { get; set; }
    }
}
