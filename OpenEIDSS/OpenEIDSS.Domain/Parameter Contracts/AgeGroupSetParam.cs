namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class AgeGroupSetParam
    {
        public string LanguageId { get; set; }
        public long AgeGroupID { get; set; }
        public string DefaultName { get; set; }
        public string NationalName { get; set; }
        public int LowerBoundary { get; set; }
        public int UpperBoundary { get; set; }
        public long AgeTypeID { get; set; }
        public int? Order { get; set; }
    }
}
