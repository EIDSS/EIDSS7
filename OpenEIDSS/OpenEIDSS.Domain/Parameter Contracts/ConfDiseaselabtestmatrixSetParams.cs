using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class ConfDiseaselabtestmatrixSetParams
    {
        [Required]
        public long idfTestForDisease { get; set; }

        [Required]
        public long idfsDiagnosis { get; set; }

        [Required]
        public long idfsSampleType { get; set; }

        [Required]
        public long idfsTestName { get; set; }

        [Required]
        public long idfsTestCategory { get; set; }

    }
}
