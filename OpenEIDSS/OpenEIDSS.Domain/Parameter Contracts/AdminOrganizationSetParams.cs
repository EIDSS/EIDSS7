using OpenEIDSS.Domain.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AdminOrganizationSetParams
    {
        public long officeId { get; set; }
        [Optional]
        public long idfOffice { get; set; }
        [Optional]
        public string EnglishName { get; set; }
        [Optional]
        public string name { get; set; }
        [Optional]
        public string EnglishFullName { get; set; }
        [Optional]
        public string FullName { get; set; }
        [Optional]
        public string strContactPhone { get; set; }
        [Optional]
        public long idfsCurrentCustomization { get; set; }
        [Optional]
        public int intHACode { get; set; }
        [Optional]
        public string strOrganizationID { get; set; }
        [Optional]
        public string LangID { get; set; }
        [Optional]
        public int intOrder { get; set; }
        [Optional]
        public long idfGeoLocation { get; set; }
        [Optional]
        public long LocationUserControlidfsCountry { get; set; }
        [Optional]
        public long LocationUserControlidfsRegion { get; set; }
        [Optional]
        public long LocationUserControlidfsRayon { get; set; }
        [Optional]
        public long LocationUserControlidfsSettlement { get; set; }
        [Optional]
        public string LocationUserControlstrApartment { get; set; }
        [Optional]
        public string LocationUserControlstrBuilding { get; set; }
        [Optional]
        public string LocationUserControlstrStreetName { get; set; }
        [Optional]
        public string LocationUserControlstrHouse { get; set; }
        [Optional]
        public string strPostCode { get; set; }
        [Optional]
        public bool blnForeignAddress { get; set; }
        [Optional]
        public string strForeignAddress { get; set; }
        [Optional]
        public float LocationUserControldblLatitude { get; set; }
        [Optional]
        public float LocationUserControldblLongitude { get; set; }
        [Optional]
        public bool blnGeoLocationShared { get; set; }
     
    }
}
