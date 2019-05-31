using OpenEIDSS.Domain.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AdminReferenceAgeGroupSetParams
    {
        [Optional]
        public long ? idfsAgeGroup{ get; set; }
        public string strDefault{ get; set; }
        public string strName{ get; set; }
        [Optional]
        public int ? intLowerBoundary{ get; set; }
        [Optional]
        public int ? intUpperBoundary{ get; set; }
        [Optional]
        public long ? idfsAgeType{ get; set; }
        public string languageId{ get; set; }
        [Optional]
        public int ? intOrder { get; set; }
    }
}
