using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Body parameters uses with a call to the LaboratoryController.SaveLaboratory service method.
    /// </summary>
    public sealed class FarmMasterSetParameters
    {
        [Required]
        public string LanguageID { get; set; }
        public long FarmMasterID { get; set; }
        public long? FarmTypeID { get; set; }
        public long? FarmOwnerID { get; set; }
        public string FarmName { get; set; }
        public string EIDSSFarmID { get; set; }
        public long? OwnershipStructureTypeID { get; set; }
        public string Fax { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public long? FarmAddressID { get; set; }
        public bool? ForeignAddressIndicator { get; set; }
        public long? FarmAddressidfsCountry { get; set; }
        public long? FarmAddressidfsRegion { get; set; }
        public long? FarmAddressidfsRayon { get; set; }
        public long? FarmAddressidfsSettlement { get; set; }
        public string FarmAddressstrStreetName { get; set; }
        public string FarmAddressstrApartment { get; set; }
        public string FarmAddressstrBuilding { get; set; }
        public string FarmAddressstrHouse { get; set; }
        public string FarmAddressidfsPostalCode { get; set; }
        public double? FarmAddressstrLatitude { get; set; }
        public double? FarmAddressstrLongitude { get; set; }
        public List<HerdMasterParameters> HerdsOrFlocks { get; set; }
        public List<SpeciesMasterParameters> Species { get; set; }
    }
}