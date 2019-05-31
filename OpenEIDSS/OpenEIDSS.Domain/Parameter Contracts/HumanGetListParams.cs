using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Parameter collection that satisfies Filter parameters for the HumanListAsync service method
    /// </summary>
    public sealed class HumanGetListParams
    {
        [Required]
        /// <summary>
        /// Filter the search by language using a language code
        /// </summary>
        public string LanguageID { get; set; }

        /// <summary>
        /// Filter the search by an EIDSS Person Identifier
        /// </summary>
        public string EIDSSPersonID { get; set; }

        /// <summary>
        /// Filter the search by an EIDSS Personal ID Type Identifier such as a passport
        /// </summary>
        public long? PersonalIDType { get; set; }

        /// <summary>
        /// Filter the search by an EIDSS Personal Identifier such as a passport identification
        /// </summary>
        public string PersonalID { get; set; }

        /// <summary>
        /// Filter the search by the patient's or farm owner's first or given name using a LIKE Filter
        /// </summary>
        public string FirstOrGivenName { get; set; }

        /// <summary>
        /// Filter the search by the patient's or farm owner's middle or second name using a LIKE Filter
        /// </summary>
        public string SecondName { get; set; }

        /// <summary>
        /// Filter the search by the patient's or farm owner's last or surname using a LIKE Filter
        /// </summary>
        public string LastOrSurname { get; set; }

        public System.DateTime? ExactDateOfBirth { get; set; }

        /// <summary>
        /// Filtery the search by the patient's or farm owner's date of birth - from date
        /// </summary>
        public System.DateTime? DateOfBirthFrom { get; set; }

        /// <summary>
        /// Filtery the search by the patient's or farm owner's date of birth - to date
        /// </summary>
        public System.DateTime? DateOfBirthTo { get; set; }

        /// <summary>
        /// Filter the search by patient's or farm owner's Gender
        /// </summary>
        public long? GenderTypeID { get; set; }

        /// <summary>
        /// Filter the search by the patient's or farm owner's address Region Identifier
        /// </summary>
        public long? RegionID { get; set; }

        /// <summary>
        /// Filter the search by the patient's or farm owner's address Rayon Identifier
        /// </summary>
        public long? RayonID { get; set; }

        /// <summary>
        /// Specifies the collection of pages to return in the result set. If the pagination set number is 1, 
        /// then rows 1 through the max page fetch size will be returned.
        /// 
        /// The current default max page fetch size is 10, so 100 rows will be returned per pagination set.
        /// </summary>
        public int PaginationSetNumber { get; set; }
    }
}
