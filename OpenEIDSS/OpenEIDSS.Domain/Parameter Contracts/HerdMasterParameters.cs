namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class HerdMasterParameters
    {
        public long HerdMasterID { get; set; }
        public string EIDSSHerdID { get; set; }
        public long FarmMasterID { get; set; }
        public int? SickAnimalQuantity { get; set; }
        public int? TotalAnimalQuantity { get; set; }
        public int? DeadAnimalQuantity { get; set; }
        public int RowStatus { get; set; }
        public string RowAction { get; set; }
    }
}