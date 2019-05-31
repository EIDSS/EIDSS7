using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace EIDSS.Client.Responses
{
    /// <summary>
    /// Contains error information When a login attempt fails
    /// </summary>
    [DataContract]
    public sealed class SecurityErrorResponse
    {
        /// <summary>
        /// Indicates the type of error that ocurred.
        /// </summary>
        [DataMember( Name ="error")]
        public string Error { get; internal set; }

        /// <summary>
        /// Error details
        /// </summary>
        [DataMember(Name ="error_description")]
        public string ErrorDescription { get; internal set; }
    }
}
