using System;
using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Body parameters uses with a call to the CrossCuttingController.SaveNotification service method.
    /// </summary>
    public sealed class NotificationSetParameters
    {
        [Required]
        public string LanguageID { get; set; }
        public long NotificationID { get; set; }
        public long? NotificationTypeID { get; set; }
        public long? UserID { get; set; }
        public long? NotificationObjectID { get; set; }
        public long? NotificationObjectTypeID { get; set; }
        public long? TargetUserID { get; set; }
        public long? TargetSiteID { get; set; }
        public long? TargetSiteTypeID { get; set; }
        public long? SiteID { get; set; }
        public string Payload { get; set; }
        public string LoginSite { get; set; }
    }
}