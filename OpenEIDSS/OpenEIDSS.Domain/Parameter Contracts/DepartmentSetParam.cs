namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class DepartmentSetParam
    {
        public string LanguageId { get; set; }
        public string Action { get; set; }
        public long DepartmentId { get; set; }
        public long OrganizationId { get; set; }
        public string DefaultName { get; set; }
        public string NationalName { get; set; }
        public long CountryID { get; set; }
        public string UserName { get; set; }
    }
}
