namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AdminEmployeeGetListParams
    {
       public string LanguageID { get; set; }
        public long? EmployeeID { get; set; }
        public string FirstOrGivenName { get; set; }
        public string SecondName { get; set; }
        public string FamilyName { get; set; }
        public string ContactPhone { get; set; }
        public string OrganizationAbbreviatedName { get; set; }
        public string OrganizationFullName{ get; set; }
        public string EIDSSOrganizationID { get; set; }
        public long? OrganizationID { get; set; }
        public string PositionTypeName { get; set; }
        public long? PositionTypeID { get; set; }
    }
}
