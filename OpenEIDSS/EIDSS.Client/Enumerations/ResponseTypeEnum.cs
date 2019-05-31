using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EIDSS.Client.Enumerations
{
    /// <summary>
    /// Determines the desired response payload type.  System defaults to BSON.
    /// </summary>
    public enum ResponseTypeEnum
    {

        /// <summary>
        /// Requests a JSON payload from the API.
        /// </summary>
        JSON = 1,

        /// <summary>
        /// Requests a BSON payload from the API. (default)
        /// </summary>
        BSON = 2,

        /// <summary>
        /// Requests an XML payload from the API.
        /// </summary>
        XML = 3,

        /// <summary>
        /// Reserved for system use only!  Usage of this enumeration will break your code!
        /// </summary>
        NONE = 99

    }
}
