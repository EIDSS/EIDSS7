namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class HerdParameters
    {
        public long HerdID { get; set; }
        public long? FarmID { get; set; }
        public long HerdMasterID { get; set; }
        public string EIDSSHerdID { get; set; }
        public int? SickAnimalQuantity { get; set; }
        public int? TotalAnimalQuantity { get; set; }
        public int? DeadAnimalQuantity { get; set; }
        public int RowStatus { get; set; }
        public string RowAction { get; set; }
    }
}