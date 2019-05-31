using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class ConfDiseasesampletypematrixSetParams
    {
        [Required]
        public long idfMaterialForDisease { get; set; }

        [Required]
        public long idfsDiagnosis { get; set; }

        [Required]
        public long idfsSampleType { get; set; }
    }
}
