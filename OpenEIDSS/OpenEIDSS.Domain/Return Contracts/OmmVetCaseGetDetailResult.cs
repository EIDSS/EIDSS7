using System.Collections.Generic;
using System.Runtime.Serialization;

namespace OpenEIDSS.Domain.Return_Contracts
{
    [DataContract(Name = "OmmVetCaseGetDetailModel")]
    public class OmmVetCaseGetDetailResult
    {
        [DataMember]
        public System.Int64 idfFarm { get; private set; }
        [DataMember]
        public System.Int64 idfFarmActual { get; private set; }
        [DataMember]
        public System.DateTime? datVetNotificationDate { get; private set; }
        [DataMember]
        public System.Int64? idfVetNotificationSentByFacilty { get; private set; }
        [DataMember]
        public System.Int64? idfVetNotificationSentByName { get; private set; }
        [DataMember]
        public System.Int64? idfVetNotificationReceivedByFacilty { get; private set; }
        [DataMember]
        public System.Int64? idfVetNotificationReceivedByName { get; private set; }
        [DataMember]
        public System.String strVetNotificationSentByFacilty { get; private set; }
        [DataMember]
        public System.String strVetNotificationSentByName { get; private set; }
        [DataMember]
        public System.String strVetNotificationReceivedByFacilty { get; private set; }
        [DataMember]
        public System.String strVetNotificationReceivedByName { get; private set; }
        [DataMember]
        public System.Int64? idfsCountry { get; private set; }
        [DataMember]
        public System.Int64? idfsRegion { get; private set; }
        [DataMember]
        public System.Int64? idfsRayon { get; private set; }
        [DataMember]
        public System.Int64? idfsSettlement { get; private set; }
        [DataMember]
        public System.String strStreetName { get; private set; }
        [DataMember]
        public System.String strPostCode { get; private set; }
        [DataMember]
        public System.String strBuilding { get; private set; }
        [DataMember]
        public System.String strHouse { get; private set; }
        [DataMember]
        public System.String strApartment { get; private set; }
        public List<Parameter_Contracts.OmmVetHerds> HerdsOrFlocks { get; set; } = new List<Parameter_Contracts.OmmVetHerds>();
        [DataMember]
        public System.Int64? idfsCaseType { get; private set; }
        public List<Parameter_Contracts.OmmVetSpecies> Species { get; set; } = new List<Parameter_Contracts.OmmVetSpecies>();
        public List<Parameter_Contracts.OmmVetAnimalInvestigation> AnimalsInvestigations { get; set; } = new List<Parameter_Contracts.OmmVetAnimalInvestigation>();
        public List<Parameter_Contracts.OmmVetVaccination> Vaccinations { get; set; } = new List<Parameter_Contracts.OmmVetVaccination>();
        public List<Parameter_Contracts.OmmHumanVetContact> Contacts { get; set; } = new List<Parameter_Contracts.OmmHumanVetContact>();
        [DataMember]
        public System.DateTime? datInvestigationDate { get; private set; }
        [DataMember]
        public System.Int64? idfVetInvestigatorOrganization { get; private set; }
        [DataMember]
        public System.Int64? idfVetInvestigatorName { get; private set; }
        [DataMember]
        public System.String strVetInvestigatorOrganization { get; private set; }
        [DataMember]
        public System.String strVetInvestigatorName { get; private set; }
        [DataMember]
        public System.String VetPrimaryCase { get; private set; }
        [DataMember]
        public System.Int64? idfVetCaseStatus { get; private set; }
        [DataMember]
        public System.Int64? idfVetCaseClassification { get; private set; }
        public List<Parameter_Contracts.OmmVetSample> Samples { get; set; } = new List<Parameter_Contracts.OmmVetSample>();
        public List<Parameter_Contracts.OmmVetPensideTest> PensideTests { get; set; } = new List<Parameter_Contracts.OmmVetPensideTest>();
        public List<Parameter_Contracts.OmmVetLabTest> LabTests { get; set; } = new List<Parameter_Contracts.OmmVetLabTest>();
        public System.String TestInterpretations { get; private set; }
    }
}
