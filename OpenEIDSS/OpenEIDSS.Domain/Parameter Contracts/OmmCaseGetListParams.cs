namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OmmCaseGetListParams
    {
        public string langId { get; set; }
        public long? idfOutbreak { get; set; }
        public string QuickSearch { get; set; }
        public long? HumanMasterID { get; set; }
        public long? VetMasterID { get; set; }
    }
}