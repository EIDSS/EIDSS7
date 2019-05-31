using System.Runtime.Serialization;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    [DataContract] //(Name = "HerdsOrFlocks")]
    public sealed class OmmVetHerds
    {
        [DataMember]
        public System.Int64 idfHerd { get; set; }
        [DataMember]
        public System.Int64 idfHerdActual { get; set; }
        [DataMember]
        public System.String strHerdCode { get; set; }
        [DataMember]
        public int? intSickAnimalQty { get; set; }
        [DataMember]
        public int? intTotalAnimalQty { get; set; }
        [DataMember]
        public int? intDeadAnimalQty { get; set; }
        [DataMember]
        public System.String Comments { get; set; }
        [DataMember]
        public int intRowStatus { get; set; }
        [DataMember]
        public System.String RowAction { get; set; }
    }
}
