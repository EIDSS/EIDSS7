using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Body parameters for satisfying person deduplication API methods parameters.
    /// </summary>
    public sealed class PersonDedupeSetParams
    {
        [Required]
        public long SurvivorHumanMasterID { get; set; }

        [Required]
        public long SupersededHumanMasterID { get; set; }
    }
}
