using System;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Parameter collection that satisfies Filter parameters for the VeterinaryMonitoringSessionListAsync service method.
    /// </summary>
    public sealed class MonitoringSessionGetListParameters
    {
        /// <summary>
        /// Filter the search by language using a language code
        /// </summary>
        public string LanguageID { get; set; }

        /// <summary>
        /// Filter the search by the session smart number.
        /// </summary>
        public string EIDSSSessionID { get; set; }

        /// <summary>
        /// Filter the search by an internal status type identifier.
        /// </summary>
        public long? SessionStatusTypeID { get; set; }

        /// <summary>
        /// Filter the search by the date entered from range.
        /// </summary>
        public DateTime? DateEnteredFrom { get; set; }

        /// <summary>
        /// Filter the search by the date entered to range.
        /// </summary>
        public DateTime? DateEnteredTo { get; set; }

        /// <summary>
        /// Filter the search by the farm's location region identifier
        /// </summary>
        public long? RegionID { get; set; }

        /// <summary>
        /// Filtery the search by the farm's location rayon identifier
        /// </summary>
        public long? RayonID { get; set; }

        /// <summary>
        /// Filter the search by the disease identifier.
        /// </summary>
        public long? DiseaseID { get; set; }

        /// <summary>
        /// Filter the search by the campaign smart number.
        /// </summary>
        public string EIDSSCampaignID { get; set; }

        /// <summary>
        /// Filter the search by the campaign internal identifier.
        /// </summary>
        public long? CampaignID { get; set; }
        
        /// <summary>
        /// Specifies the collection of pages to return in the result set. If the pagination set number is 1, 
        /// then rows 1 through the max page fetch size will be returned.
        /// 
        /// The current default max page fetch size is 10, so 100 rows will be returned per pagination set.
        /// </summary>
        public int PaginationSetNumber { get; set; }
    }
}