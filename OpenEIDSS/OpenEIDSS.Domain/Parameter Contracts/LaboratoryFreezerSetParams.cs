using System.Collections.Generic;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Body parameters uses with a call to the LaboratoryController.SaveLaboratoryFreezer service method.
    /// </summary>
    public sealed class LaboratoryFreezerSetParams
    {
        public string LanguageID { get; set; }
        public long? FreezerID { get; set; }
        public long? StorageTypeID { get; set; }
        public long OrganizationID { get; set; }
        public string FreezerName { get; set; }
        public string FreezerNote { get; set; }
        public string EIDSSFreezerID { get; set; }
        public string Building { get; set; }
        public string Room { get; set; }
        public int RowStatus { get; set; }
        public List<FreezerSubdivisionParameters> FreezerSubdivisions { get; set; }
    }
}
