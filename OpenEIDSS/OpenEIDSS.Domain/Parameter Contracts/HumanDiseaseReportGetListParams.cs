using System;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class HumanDiseaseReportGetListParams
    {
        public string LanguageID { get; set; }
        public long? HumanDiseaseReportID { get; set; }
        public string LegacyHumanDiseaseReportID { get; set; }
        public long? PatientID { get; set; }
        public string EIDSSPersonID { get; set; }
        public long? DiseaseID { get; set; }
        public long? ReportStatusTypeID { get; set; }
        public long? RegionID { get; set; }
        public long? RayonID { get; set; }
        public DateTime? HumanDiseaseReportDateEnteredFrom { get; set; }
        public DateTime? HumanDiseaseReportDateEnteredTo { get; set; }
        public long? ClassificationTypeID { get; set; }
        public long? HospitalizationStatusTypeID { get; set; }
        public string EIDSSReportID { get; set; }
        public string PatientFirstOrGivenName { get; set; }
        public string PatientMiddleName { get; set; }
        public string PatientLastOrSurname { get; set; }

        /// <summary>
        /// Specifies the collection of pages to return in the result set. If the pagination set number is 1, 
        /// then rows 1 through the max page fetch size will be returned.
        /// 
        /// The current default max page fetch size is 10, so 100 rows will be returned per pagination set.
        /// </summary>
        public int PaginationSetNumber { get; set; }
    }
}
