using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace EIDSS.Client.Responses
{
    /// <summary>
    /// User administrative request response message
    /// </summary>
    [DataContract]
    public class UserAdminRequestResponse
    {
        [DataMember]
        public string Message { get; set; }

        [DataMember]
        public ModelState State { get; set; } 
    }

    [DataContract]
    public class ModelState
    {
        [DataMember( Name="name")]
        public string Name { get; set; }

        [DataMember(Name="value")]
        public string Value { get; set; }

        [DataMember(Name="model.ConfirmPassword")]
        public string ConfirmPasswordIssue { get; set; }

        [DataMember(Name="model.Password")]
        public string PasswordIssue { get; set; }
    }
}
