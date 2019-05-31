using System;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class TestAmendmentParameters
    {
        public long TestAmendmentID { get; set; }
        public long TestID { get; set; }
        public long? AmendedByOrganizationID { get; set; }
        public long? AmendedByPersonID { get; set; }
        public DateTime? AmendmentDate { get; set; }
        public long? OldTestResultTypeID { get; set; }
        public long? ChangedTestResultTypeID  { get; set; }
        public string OldNote { get; set; }
        public string ChangedNote { get; set; }
        public string ReasonForAmendment { get; set; }
        public int RowStatus { get; set; }
        public string RowAction { get; set; }
    }
}