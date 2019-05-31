using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace EIDSS.Client.Requests
{
    /// <summary>
    /// Model for registering a user.
    /// </summary>
    [DataContract]
    public class UserRegistrationInfo
    {
        [DataMember]
        public long idfUserID { get; set; }

        [DataMember]
        public string Email { get; set; }

        [DataMember]
        public string Password { get; set; }

        [DataMember]
        public string ConfirmPassword { get; set; }

        [DataMember]
        public string UserName { get; set; }
    }
}
