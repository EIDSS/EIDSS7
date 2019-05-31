using System;
using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class TestInterpretationParameters
    {
        [Required]
        public long TestInterpretationID { get; set; }
        public long? DiseaseID { get; set; }
        public long? InterpretedStatusTypeID { get; set; }
        public long? ValidatedByOrganizationID { get; set; }
        public long? ValidatedByPersonID { get; set; }
        public long? InterpretedByOrganizationID { get; set; }
        public long? InterpretedByPersonID { get; set; }
        public long TestID { get; set; }
        public bool? ValidatedStatusIndicator { get; set; }
        public bool? ReportSessionCreatedIndicator { get; set; }
        public string ValidatedComment { get; set; }
        public string InterpretedComment { get; set; }
        public DateTime? ValidatedDate { get; set; }
        public DateTime? InterpretedDate { get; set; }
        public bool ReadOnlyIndicator { get; set; }
        public int RowStatus { get; set; }
        public string RowAction { get; set; }
    }
}
