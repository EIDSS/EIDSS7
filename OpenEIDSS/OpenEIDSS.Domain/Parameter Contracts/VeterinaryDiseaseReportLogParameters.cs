using System;
using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class VeterinaryDiseaseReportLogParameters
    {
        [Required]
        public long VeterinaryDiseaseReportLogID { get; set; }
        public long? LogStatusTypeID { get; set; }
        public long? VeterinaryDiseaseReportID { get; set; }
        public long? LoggedByPersonID { get; set; }
        public DateTime? LogDate { get; set; }
        public string ActionRequired { get; set; }
        public string Comments { get; set; }
        public int RowStatus { get; set; }
        public string RowAction { get; set; }
    }
}