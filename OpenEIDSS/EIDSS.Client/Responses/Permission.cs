using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EIDSS.Client.Responses
{
    /// <summary>
    /// Specifies actions that a user is authorized to perform.
    /// </summary>
    public class Permission
    {
        /// <summary>
        /// Indicates the type of action.
        /// </summary>
        public string PermissionType { get; internal set; }

        /// <summary>
        /// Specifies the level of the action in more granularity.
        /// </summary>
        public List<string> PermissionLevels { get; internal set; }

        /// <summary>
        /// Instantiates a new instance of the class.
        /// </summary>
        public Permission()
        {
            PermissionLevels = new List<string>();
        }


    }
}
