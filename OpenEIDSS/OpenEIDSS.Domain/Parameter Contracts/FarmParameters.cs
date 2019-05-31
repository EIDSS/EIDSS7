namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class FarmParameters
    {
        public long? FarmID { get; set; }
        public long FarmMasterID { get; set; }
        public string EIDSSFarmID { get; set; }
        public int? SickAnimalQuantity { get; set; }
        public int? TotalAnimalQuantity { get; set; }
        public int? DeadAnimalQuantity { get; set; }
        public int RowStatus { get; set; }
        public string RowAction { get; set; }
    }
}