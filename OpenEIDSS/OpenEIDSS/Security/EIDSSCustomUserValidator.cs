using Microsoft.AspNet.Identity;
using OpenEIDSS.Domain;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace OpenEIDSS.Security
{
    /// <summary>
    /// 
    /// </summary>
    /// <typeparam name="TUser"></typeparam>
    public class EIDSSCustomUserValidator<TUser> : UserValidator<TUser, string> where TUser : class, IUser<string>
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(EIDSSCustomUserValidator<TUser>));

        private SecurityConfigurationGetModel _config;

        #region properties

        /// <summary>
        /// Gets the number times a user can incorrectly enter his/her password before the account is locked.  The default is 3.
        /// </summary>
        public int AccountLockoutThreshold { get; private set; } = 3;

        /// <summary>
        /// Gets the duration in minutes), an account is locked when it is locked when the user exceeded the account lockout threshold.  
        /// The default is 5 minutes
        /// </summary>
        public int AccountLockoutDuration { get; private set; } = 5;

        /// <summary>
        /// Indicates whether a warning is displayed due to inactivity in the specified number of minutes.
        /// </summary>
        public int DisplaySessionInactivityTimeoutWarning { get; private set; } = 5;

        /// <summary>
        /// Determines the amount of time (in minutes) when no activity occurs in a users' session before the session is ended.
        /// Indicates whether a warning is displayed due to inactivity in the specified number of minutes.  
        /// The default is 15 minutes.
        /// I DON'T SUGGEST WE DO THIS ONE BECAUSE IT WOULD TAX THE SYSTEM'S RESOURCES...
        /// </summary>
        public int SessionInactivityTimeout { get; set; } = 15;

        /// <summary>
        /// Determines the amount of time (in hours) that a user's session can span contguously.  The default is 2 hours.
        /// </summary>
        public int SessionMaxLength { get; set; } = 2;

        #endregion

        /// <summary>
        /// 
        /// </summary>
        /// <param name="manager"></param>
        /// <param name="config"></param>
        public EIDSSCustomUserValidator(UserManager<TUser, string> manager, SecurityConfigurationGetModel config): base( manager)
        {
            _config = config;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="item"></param>
        /// <returns></returns>
        public override Task<IdentityResult> ValidateAsync(TUser item)
        {
            log.Info("ValidateAsync is called");
            IdentityResult result = IdentityResult.Success;

            try
            {
                // this gives us AllowOnlyAlphaNumericUsernames and
                // RequireUniqueEmail
                return base.ValidateAsync(item);
            }
            catch( Exception e )
            {
                log.Error("ValidateAsync failed", e);
                result = IdentityResult.Failed(e.ToString());
            }

            return Task.FromResult(result);
        }
    }
}