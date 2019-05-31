using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OrganizationGetListParams
    {
        [Required]
        /// <summary>
        /// Filter the search by language using a language code
        /// </summary>
        public string LanguageID { get; set; }

        /// <summary>
        /// Filter the search by an EIDSS organization identifier
        /// </summary>
        public string EIDSSOrganizationID { get; set; }

        /// <summary>
        /// Filter the search by an EIDSS organization internal identifier
        /// </summary>
        public long? OrganizationID { get; set; }

        /// <summary>
        /// Filter the search by the organization's abbreviated name using a LIKE filter
        /// </summary>
        public string OrganizationAbbreviatedName { get; set; }

        /// <summary>
        /// Filter the search by the organization's full name using a LIKE filter
        /// </summary>
        public string OrganizationFullName { get; set; }

        /// <summary>
        /// Filter the search by the accessory code such as human, veterinary, vector, etc.
        /// </summary>
        public int? AccessoryCode { get; set; }

        /// <summary>
        /// Filtery the search by the site internal identifier
        /// </summary>
        public long? SiteID { get; set; }

        /// <summary>
        /// Filter the search by the organization's address region internal identifier
        /// </summary>
        public long? RegionID { get; set; }

        /// <summary>
        /// Filter the search by the organization's address rayon internal identifier
        /// </summary>
        public long? RayonID { get; set; }

        /// <summary>
        /// Filter the search by the organization's address settlement (town or village) internal identifier
        /// </summary>
        public long? SettlementID { get; set; }

        /// <summary>
        /// Filter the search by the organization's type internal identifier
        /// </summary>
        public long? OrganizationTypeID { get; set; }

        /// <summary>
        /// Specifies the collection of pages to return in the result set. If the pagination set number is 1, 
        /// then rows 1 through the max page fetch size will be returned.
        /// 
        /// The current default max page fetch size is 10, so 100 rows will be returned per pagination set.
        /// </summary>
        public int PaginationSetNumber { get; set; }
    }
}
