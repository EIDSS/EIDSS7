using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using System.Linq;
using OpenEIDSS.Security;

namespace OpenEIDSS.Models
{
    /// <summary>
    /// 
    /// </summary>
    // You can add profile data for the user by adding more properties to your ApplicationUser class, please visit https://go.microsoft.com/fwlink/?LinkID=317594 to learn more.
    public class ApplicationUser : IdentityUser
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(ApplicationUser));

        #region New Column(s) (Properties)

        /// <summary>
        /// 
        /// </summary>
        public long idfUserID { get; set; }

        #endregion

        /// <summary>
        /// Creates an identity object for a user.
        /// </summary>
        /// <param name="manager"></param>
        /// <param name="authenticationType"></param>
        /// <returns></returns>
        public async Task<ClaimsIdentity> GenerateUserIdentityAsync(UserManager<ApplicationUser> manager, string authenticationType)
        {
            // Note the authenticationType must match the one defined in CookieAuthenticationOptions.AuthenticationType
            var userIdentity = await manager.CreateIdentityAsync(this, authenticationType);

            // Add custom user claims here

            var user = manager.Users.Where(w => w.UserName == userIdentity.Name ).FirstOrDefault();
            var roles = ModelFactory.GetUserRolesAndPermissions(user.idfUserID, user.UserName);

            if (roles != null && roles.Count > 0)
                roles.ForEach(r => userIdentity.AddClaim(new Claim(ClaimTypes.UserData, String.Format("{0}.{1}", new string[] { r.Permission.Trim(), r.PermissionLevel.ToString() }))));



            return userIdentity;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(ApplicationDbContext));

        /// <summary>
        /// 
        /// </summary>
        public ApplicationDbContext()
            : base("EIDSS", throwIfV1Schema: false)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static ApplicationDbContext Create()
        {
            return new ApplicationDbContext();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="modelBuilder"></param>
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <typeparam name="TUser"></typeparam>
    public class EIDSSUserStore<TUser> : UserStore<TUser> where TUser : ApplicationUser
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(EIDSSUserStore<TUser>));
        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public EIDSSUserStore(DbContext context ): base( context)
        {

        }

        ///// <summary>
        ///// Inserts a user into the ASPNetUsers table
        ///// </summary>
        ///// <param name="user"></param>
        ///// <returns></returns>
        //public override async Task CreateAsync(TUser user)
        //{
        //    try
        //    {
        //        log.Info("CreateAsync is called");
        //        var result = _repository.AspNetUserSetAsync(
        //            user.Id, user.idfUserID, user.UserName, user.Email, user.EmailConfirmed, user.PasswordHash,
        //            user.SecurityStamp, user.LockoutEndDateUtc, user.LockoutEnabled, user.AccessFailedCount);

        //        //if (result != null)
        //        //{
        //        //    var r = result.FirstOrDefault();
        //        //    u = new ApplicationUser
        //        //    {
        //        //        AccessFailedCount = r.AccessFailedCount


        //        //    };
        //        //}
        //        //return Task<result>;
        //    }
        //    catch (Exception e)
        //    {
        //        log.Error("CreateAsync Failed", e);
        //        throw e;
        //    }

        //    //return base.CreateAsync(user);
        //    //if( user == null )
        //    //{
        //    //    throw new ArgumentNullException("user");
        //    //}

        //    //// perform the insert.... call the DAC!!!!

        //    //// remove this when fully implemented
        //    //return Task.FromResult<object>(null);
        //}
    }
}