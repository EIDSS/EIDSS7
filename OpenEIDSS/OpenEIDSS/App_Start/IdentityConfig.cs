using System.Collections.Generic;
using System.Configuration;
using System.Runtime.Caching;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Models;
using OpenEIDSS.Security;
using System.Linq;
using System;
using System.Security.Claims;

namespace OpenEIDSS

{
    /// <summary>
    /// API Cache Containers
    /// </summary>
    public enum APICacheableItemsEnum
    {
        /// <summary>
        /// Contains an instance of <see cref="EIDSSCustomPasswordValidator"/>
        /// </summary>
        CustomPWordValidator,

        /// <summary>
        /// Contains an instance of <see cref="SecurityConfigurationGetModel"/> which is the EIDSS Security policy
        /// retrieved from the database
        /// </summary>
        SecurityPolicy
    }

// Configure the application user manager used in this application. UserManager is defined in ASP.NET Identity and is used by the application.
/// <summary>
/// 
/// </summary>
public class ApplicationUserManager : UserManager<ApplicationUser>
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(ApplicationUserManager));

        /// <summary>
        /// Memory cache that contains security policy.
        /// </summary>
        public static ObjectCache PolicyCache = MemoryCache.Default;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="store"></param>
        public ApplicationUserManager(IUserStore<ApplicationUser> store)
            : base(store)
        {
            Init();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="options"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public static ApplicationUserManager Create(IdentityFactoryOptions<ApplicationUserManager> options, IOwinContext context)
        {
            // Register our user store!!!!
            var manager = new ApplicationUserManager(
                new EIDSSUserStore<ApplicationUser>(context.Get<ApplicationDbContext>()));

            manager.UserValidator = new UserValidator<ApplicationUser>(manager)
            {
                AllowOnlyAlphanumericUserNames = true,
                RequireUniqueEmail = false
            };

            //manager.PasswordValidator = new PasswordValidator
            //{
            //    RequiredLength = 8,
            //    RequireNonLetterOrDigit = true,
            //    RequireDigit = true,
            //    RequireLowercase = true,
            //    RequireUppercase = true,
            //};

            // Configure password policy...
            manager.PasswordValidator = PolicyCache.Get(APICacheableItemsEnum.CustomPWordValidator.ToString()) as EIDSSCustomPasswordValidator; 

            var dataProtectionProvider = options.DataProtectionProvider;

            if (dataProtectionProvider != null)
            {
                manager.UserTokenProvider = new DataProtectorTokenProvider<ApplicationUser>(dataProtectionProvider.Create("ASP.NET Identity"));
            }
            return manager;
        }

        public override Task<IList<Claim>> GetClaimsAsync(string userId)
        {
            return base.GetClaimsAsync(userId);
        }

        /// <summary>
        /// Gets the security policy settings from the database and commits it to cache and
        /// intantiates a new instance of the <see cref="EIDSSCustomPasswordValidator"/>
        /// </summary>
        private void Init()
        {
            log.Info("Init is called");

            try
            {
                // Create a "live forever" expiry...
                CacheItemPolicy expiry = new CacheItemPolicy
                {
                    Priority = CacheItemPriority.NotRemovable
                };

                // Check to see if the security policy has been fetched from the DB, if not get it and cache it for subsequent calls.
                var secPolicyCache = PolicyCache.Get( APICacheableItemsEnum.SecurityPolicy.ToString()) as SecurityConfigurationGetModel;
                if (secPolicyCache == null)
                {
                    // fetch the settings from the database...
                    var _repository = new EIDSSRepository();
                    var result = _repository.SecurityConfigurationGet();

                    // if for some reason we didn't get our policy from the database, we'll use default further on down the line...
                    if( result != null && result.Count > 0 )
                        PolicyCache.Set(APICacheableItemsEnum.SecurityPolicy.ToString(), result.FirstOrDefault(), expiry);
                }

                // If there's no instantiated password validator in the cache, create one and cache it...
                var validator = PolicyCache.Get(APICacheableItemsEnum.CustomPWordValidator.ToString()) as EIDSSCustomPasswordValidator;
                if (validator == null)
                {
                    var policy = PolicyCache.Get(APICacheableItemsEnum.SecurityPolicy.ToString());

                    validator = new EIDSSCustomPasswordValidator(policy as SecurityConfigurationGetModel);
                    PolicyCache.Set(APICacheableItemsEnum.CustomPWordValidator.ToString(), validator, expiry);
                }
            }

            catch( Exception e)
            {
                log.Error("Init Failed", e);
            }

            log.Info("Init returned");
        }
    }


}
