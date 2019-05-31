using System;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class VectorSurveillanceSessionGetListParams
    {
        public string LanguageID { get; set; }
        public string EIDSSSessionID { get; set; }
        public string FieldSessionID { get; set; }
        public long? SessionStatusTypeID { get; set; }
        public string VectorType { get; set; }
        public long? SpeciesTypeID { get; set; }
        public long? DiseaseID { get; set; }
        public string DiseaseGroup { get; set; }
        public long? RegionID { get; set; }
        public long? RayonID { get; set; }
        public long? SettlementID { get; set; }
        public DateTime? StartDateFrom { get; set; }
        public DateTime? StartDateTo { get; set; }
        public DateTime? CloseDateFrom { get; set; }
        public DateTime? CloseDateTo { get; set; }
        public long? OutbreakID { get; set; }
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
