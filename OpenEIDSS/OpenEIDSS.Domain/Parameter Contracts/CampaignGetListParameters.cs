using System;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class CampaignGetListParameters
    {
        /// <summary>
        /// Filter the search by language using a language code
        /// </summary>
        public string LanguageID { get; set; }

        /// <summary>
        /// Filter the search by an external system identifier; smart key
        /// </summary>
        public string EIDSSCampaignID { get; set; }

        /// <summary>
        /// Filter the search by the user assigned campaign name
        /// </summary>
        public string CampaignName { get; set; }

        /// <summary>
        /// Filter the search by the campaign type identifier
        /// </summary>
        public long? CampaignTypeID { get; set; }

        /// <summary>
        /// Filter the search by the campaign status type identifier
        /// </summary>
        public long? CampaignStatusTypeID { get; set; }

        /// <summary>
        /// Filter the search by the campaign start from date range
        /// </summary>
        public DateTime? StartDateFrom { get; set; }

        /// <summary>
        /// Filter the search by the campaign start to date range
        /// </summary>
        public DateTime? StartDateTo { get; set; }

        /// <summary>
        /// Filter the search by the disease internal system identifier
        /// </summary>
        public long? DiseaseID { get; set; }

        /// <summary>
        /// Specifies the collection of pages to return in the result set. If the pagination set number is 1, 
        /// then rows 1 through the max page fetch size will be returned.
        /// 
        /// The current default max page fetch size is 10, so 100 rows will be returned per pagination set.
        /// </summary>
        public int PaginationSetNumber { get; set; }
    }
}
