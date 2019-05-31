using System;
using System.Collections.Generic;

namespace OpenEIDSS.Models
{
    // Models returned by AccountController actions.
    /// <summary>
    /// 
    /// </summary>
    public class ExternalLoginViewModel
    {
        /// <summary>
        /// 
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Url { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string State { get; set; }
    }

    /// <summary>
    /// 
    /// </summary>
    public class ManageInfoViewModel
    {
        /// <summary>
        /// 
        /// </summary>
        public string LocalLoginProvider { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Email { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public IEnumerable<UserLoginInfoViewModel> Logins { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public IEnumerable<ExternalLoginViewModel> ExternalLoginProviders { get; set; }
    }

    /// <summary>
    /// 
    /// </summary>
    public class UserInfoViewModel
    {
        /// <summary>
        /// 
        /// </summary>
        public string Email { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public bool HasRegistered { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string LoginProvider { get; set; }
    }

    /// <summary>
    /// 
    /// </summary>
    public class UserLoginInfoViewModel
    {
        /// <summary>
        /// 
        /// </summary>
        public string LoginProvider { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string ProviderKey { get; set; }
    }
}
