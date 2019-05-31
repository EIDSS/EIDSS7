using System;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Parameter collection that satisfies Filter parameters for the VeterinaryDiseaseReportListAsync service method.
    /// </summary>
    public sealed class VeterinaryDiseaseReportGetListParameters
    {
        /// <summary>
        /// Filter the search by language using a language code
        /// </summary>
        public string LanguageID { get; set; }

        /// <summary>
        /// Filter the search by an internal system identifier
        /// </summary>
        public long? VeterinaryDiseaseReportID { get; set; }

        /// <summary>
        /// Filter the search by an internal system monitoring session identifier
        /// </summary>
        public long? MonitoringSessionID { get; set; }

        /// <summary>
        /// Filter the search by an the master record for the associated farm record
        /// </summary>
        public long? FarmMasterID { get; set; }

        /// <summary>
        /// Filter the search by the disease internal system identifier
        /// </summary>
        public long? DiseaseID { get; set; }

        /// <summary>
        /// Filter the search by the report status type identifier
        /// </summary>
        public long? ReportStatusTypeID { get; set; }

        /// <summary>
        /// Filter the search by the farm's location region identifier
        /// </summary>
        public long? RegionID { get; set; }

        /// <summary>
        /// Filtery the search by the farm's location rayon identifier
        /// </summary>
        public long? RayonID { get; set; }

        /// <summary>
        /// Filter the search by report entry from date range
        /// </summary>
        public DateTime? DateEnteredFrom { get; set; }

        /// <summary>
        /// Filter the search by report entry to date range
        /// </summary>
        public DateTime? DateEnteredTo { get; set; }

        /// <summary>
        /// Filter the search by report classification type identifier
        /// </summary>
        public long? ClassificationTypeID { get; set; }

        /// <summary>
        /// Filter the search by the EIDSS smart number identifier
        /// </summary>
        public string EIDSSReportID { get; set; }

        /// <summary>
        /// Filter the search by the report type identifier
        /// </summary>
        public long? ReportTypeID { get; set; }

        /// <summary>
        /// Filter the search by the species type of avian or livestock
        /// </summary>
        public long? SpeciesTypeID { get; set; }

        /// <summary>
        /// Filter the search by veterinary disease reports that are associated with an outbreak record.
        /// </summary>
        public bool? OutbreakCasesIndicator { get; set; }

        public DateTime? DiagnosisDateFrom { get; set; }
        public DateTime? DiagnosisDateTo { get; set; }
        public DateTime? InvestigationDateFrom { get; set; }
        public DateTime? InvestigationDateTo { get; set; }
        public string @LocalOrFieldSampleID { get; set; }
        public int? TotalAnimalQuantityFrom { get; set; }
        public int? TotalAnimalQuantityTo { get; set; }
        public long? SiteID { get; set; }

        /// <summary>
        /// Specifies the collection of pages to return in the result set. If the pagination set number is 1, 
        /// then rows 1 through the max page fetch size will be returned.
        /// 
        /// The current default max page fetch size is 10, so 100 rows will be returned per pagination set.
        /// </summary>
        public int PaginationSetNumber { get; set; }
    }
}
