using System;
using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Body parameters used with a call to the LaboratoryController.LaboratoryAdvancedSearchGetListAsync service method
    /// </summary>
    public sealed class LaboratoryAdvancedSearchParameters
    {
        [Required]
        public string LanguageID { get; set; }
        public long? UserID { get; set; }
        public long? OrganizationID { get; set; }
        public long? SiteID { get; set; }
        public string ReportSessionType { get; set; }
        public long? SurveillanceTypeID { get; set; }
        public string SampleStatusTypeID { get; set; }
        public int? AccessionedIndicator { get; set; }
        public string EIDSSLocalFieldSampleID { get; set; }
        public string ExactMatchEIDSSLocalFieldSampleID { get; set; }
        public string EIDSSReportCampaignSessionID { get; set; }
        public long? OrganizationSentToID { get; set; }
        public long? OrganizationTransferredToID { get; set; }
        public string EIDSSTransferID { get; set; }
        public long? ResultsReceivedFromID { get; set; }
        public DateTime? AccessionDateFrom { get; set; }
        public DateTime? AccessionDateTo { get; set; }
        public string EIDSSLaboratorySampleID { get; set; }
        public long? SampleTypeID { get; set; }
        public long? TestNameTypeID { get; set; }
        public long? DiseaseID { get; set; }
        public long? TestStatusTypeID { get; set; }
        public long? TestResultTypeID { get; set; }
        public DateTime? TestResultDateFrom { get; set; }
        public DateTime? TestResultDateTo { get; set; }
        public string PatientName { get; set; }
        public string FarmOwnerName { get; set; }
        public long? SpeciesTypeID { get; set; }

        /// <summary>
        /// Specifies the collection of pages to return in the result set. If the pagination set number is 1, 
        /// then rows 1 through the max page fetch size will be returned.
        /// 
        /// The current default max page fetch size is 10, so 100 rows will be returned per pagination set.
        /// </summary>
        public int PaginationSetNumber { get; set; }
    }
}
