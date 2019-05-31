namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OrganizationSetParam
    {
        public string LangId { get; set; }
        public long OrganizationId { get; set; }
        public string EnglishName { get; set; }
        public string EnglishFullName { get; set; }
        public string Name { get; set; }
        public string FullName { get; set; }
        public string ContactPhone { get; set; }
        public long? CurrentCustomizationId { get; set; }
        public int? AccessoryCode { get; set; }
        public string OrganizationCode { get; set; }
        public int? OrderNumber { get; set; }
        public long? LocationId { get; set; }
        public long? CountryId { get; set; }
        public long? RegionId { get; set; }
        public long? RayonId { get; set; }
        public long? SettlementId { get; set; }
        public string Apartment { get; set; }
        public string Building { get; set; }
        public string StreetName { get; set; }
        public string House { get; set; }
        public string PostalCode { get; set; }
        public bool? ForeignAddressIndicator { get; set; }
        public string ForeignAddress { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public bool? SharedLocationIndicator { get; set; }
    }
}
