using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Body parameters uses with a call to the LaboratoryController.SaveLaboratory service method.
    /// </summary>
    public sealed class LaboratorySetParameters
    {
        [Required]
        public string LanguageID { get; set; }
        public List<LaboratorySampleParameters> Samples { get; set; }
        public List<BatchTestParameters> BatchTests { get; set; }
        public List<LaboratoryTestParameters> Tests { get; set; }
        public List<TestAmendmentParameters> TestAmendments { get; set; }
        public List<LaboratoryTransferParameters> Transfers { get; set; }
        public List<FreezerBoxLocationAvailabilityParameters> FreezerBoxLocationAvailabilities { get; set; }
        public List<NotificationSetParameters> Notifications { get; set; }
        public long? UserID { get; set; }
        public string Favorites { get; set; }
    }
}
