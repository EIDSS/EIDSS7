using System;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class LaboratoryTransferParameters
    {
        public long TransferID { get; set; }
        public long SampleID { get; set; }
        public string EIDSSTransferID { get; set; }
        public long? TransferStatusTypeID { get; set; }
        public long? TransferredFromOrganizationID { get; set; }
        public long? TransferredToOrganizationID { get; set; }
        public long? SentByPersonID { get; set; }
        public DateTime? TransferDate { get; set; }
        public string PurposeOfTransfer { get; set; }
        public long SiteID { get; set; }
        public string TestRequested { get; set; }
        public int RowStatus { get; set; }
        public string RowAction { get; set; }
    }
}
