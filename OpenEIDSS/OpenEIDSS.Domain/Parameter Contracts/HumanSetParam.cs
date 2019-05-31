using System;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Body parameter class for the <see cref="OpenEIDSS.Data.EIDSSDBContext.HumHumanSet(long?, long?, string, string, string, string, string, DateTime?, DateTime?, int?, long?, long?, long?, long?, string, long?, string, DateTime?, bool?, string, long?, long?, long?, long?, long?, string, string, string, string, string, string, long?, string, DateTime?, bool?, string, long?, long?, long?, long?, long?, string, string, string, string, string, string, long?, long?, long?, long?, long?, string, string, string, string, string, double?, double?, double?, long?, bool?, string, long?, long?, long?, long?, string, string, string, string, string, double?, double?, double?, string, string, string, int?, string, long?, int?, string, long?) function"/>
    /// </summary>
    public sealed class HumanSetParam
    {
        public long? HumanMasterID { get; set; }

        public bool copyToHumanIndicator { get; set; }
        public bool CopyToHumanIndicator { get; set; }
        public long? PersonalIDType { get; set; }
        public string EIDSSPersonID { get; set; }
        public string PersonalID { get; set; }
        public string FirstOrGivenName { get; set; }
        public string SecondName { get; set; }
        public string LastOrSurname { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public DateTime? DateOfDeath { get; set; }
        public int? ReportedAge { get; set; }
        public long? ReportedAgeUOMID { get; set; }
        public long? GenderTypeID { get; set; }
        public long? OccupationTypeID { get; set; }
        public long? CitizenshipTypeID { get; set; }
        public string PassportNumber { get; set; }
        public long? IsEmployedTypeID { get; set; }
        public string EmployerName { get; set; }
        public DateTime? EmployedDateLastPresent { get; set; }
        public bool? EmployerForeignAddressIndicator { get; set; }
        public string EmployerForeignAddressString { get; set; }
        public long? EmployerGeoLocationID { get; set; }
        public long? EmployeridfsCountry { get; set; }
        public long? EmployeridfsRegion { get; set; }
        public long? EmployeridfsRayon { get; set; }
        public long? EmployeridfsSettlement { get; set; }
        public string EmployerstrStreetName { get; set; }
        public string EmployerstrApartment { get; set; }
        public string EmployerstrBuilding { get; set; }
        public string EmployerstrHouse { get; set; }
        public string EmployeridfsPostalCode { get; set; }
        public string EmployerPhone { get; set; }
        public long? IsStudentTypeID { get; set; }
        public string SchoolName { get; set; }
        public DateTime? SchoolDateLastAttended { get; set; }
        public bool? SchoolForeignAddressIndicator { get; set; }
        public string SchoolForeignAddressString { get; set; }
        public long? SchoolGeoLocationID { get; set; }
        public long? SchoolidfsCountry { get; set; }
        public long? SchoolidfsRegion { get; set; }
        public long? SchoolidfsRayon { get; set; }
        public long? SchoolidfsSettlement { get; set; }
        public string SchoolstrStreetName { get; set; }
        public string SchoolstrApartment { get; set; }
        public string SchoolstrBuilding { get; set; }
        public string SchoolstrHouse { get; set; }
        public string SchoolidfsPostalCode { get; set; }
        public string SchoolPhone { get; set; }
        public long? HumanGeoLocationID { get; set; }
        public long? HumanidfsCountry { get; set; }
        public long? HumanidfsRegion { get; set; }
        public long? HumanidfsRayon { get; set; }
        public long? HumanidfsSettlement { get; set; }
        public string HumanstrStreetName { get; set; }
        public string HumanstrApartment { get; set; }
        public string HumanstrBuilding { get; set; }
        public string HumanstrHouse { get; set; }
        public string HumanidfsPostalCode { get; set; }
        public double? HumanstrLatitude { get; set; }
        public double? HumanstrLongitude { get; set; }
        public double? HumanstrElevation { get; set; }
        public long? HumanAltGeoLocationID { get; set; }
        public bool? HumanAltForeignAddressIndicator { get; set; }
        public string HumanAltForeignAddressString { get; set; }
        public long? HumanAltidfsCountry { get; set; }
        public long? HumanAltidfsRegion { get; set; }
        public long? HumanAltidfsRayon { get; set; }
        public long? HumanAltidfsSettlement { get; set; }
        public string HumanAltstrStreetName { get; set; }
        public string HumanAltstrApartment { get; set; }
        public string HumanAltstrBuilding { get; set; }
        public string HumanAltstrHouse { get; set; }
        public string HumanAltidfsPostalCode { get; set; }
        public double? HumanAltstrLatitude { get; set; }
        public double? HumanAltstrLongitude { get; set; }
        public double? HumanAltstrElevation { get; set; }
        public string RegistrationPhone { get; set; }
        public string HomePhone { get; set; }
        public string WorkPhone { get; set; }
        public int? ContactPhoneCountryCode { get; set; }
        public string ContactPhone { get; set; }
        public long? ContactPhoneTypeID { get; set; }
        public int? ContactPhone2CountryCode { get; set; }
        public string ContactPhone2 { get; set; }
        public long? ContactPhone2TypeID { get; set; }
    }
}