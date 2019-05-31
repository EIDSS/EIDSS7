using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.Cookies;
using Microsoft.Owin.Security.OAuth;
using OpenEIDSS.Domain;
using OpenEIDSS.Models;
using OpenEIDSS.Security;

namespace OpenEIDSS.Providers
{
    /// <summary>
    /// 
    /// </summary>
    public class ApplicationOAuthProvider : OAuthAuthorizationServerProvider
    {
        private readonly string _publicClientId;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="publicClientId"></param>
        public ApplicationOAuthProvider(string publicClientId)
        {
            if (publicClientId == null)
            {
                throw new ArgumentNullException("publicClientId");
            }

            _publicClientId = publicClientId;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public override async Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
        {
            var userManager = context.OwinContext.GetUserManager<ApplicationUserManager>();

            ApplicationUser user = await userManager.FindAsync(context.UserName, context.Password);

            if (user == null)
            {
                context.SetError("invalid_grant", "The user name or password is incorrect.");
                return;
            }

            ClaimsIdentity oAuthIdentity = await user.GenerateUserIdentityAsync(userManager, OAuthDefaults.AuthenticationType);
            ClaimsIdentity cookiesIdentity = await user.GenerateUserIdentityAsync(userManager, CookieAuthenticationDefaults.AuthenticationType);

            // retrieve user details...
            var userDetail = ModelFactory.GetUserDetail(user.Id );

            // Create user properties...
            AuthenticationProperties properties = CreateProperties(oAuthIdentity, userDetail, ModelFactory.GetUserRolesAndPermissions(user.idfUserID, user.UserName ));

            AuthenticationTicket ticket = new AuthenticationTicket(oAuthIdentity, properties);
            context.Validated(ticket);
            context.Request.Context.Authentication.SignIn(cookiesIdentity);


        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public override Task TokenEndpoint(OAuthTokenEndpointContext context)
        {
            foreach (KeyValuePair<string, string> property in context.Properties.Dictionary)
            {
                context.AdditionalResponseParameters.Add(property.Key, property.Value);
            }

            return Task.FromResult<object>(null);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public override Task ValidateClientAuthentication(OAuthValidateClientAuthenticationContext context)
        {
            // Resource owner password credentials does not provide a client ID.
            if (context.ClientId == null)
            {
                context.Validated();
            }

            return Task.FromResult<object>(null);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public override Task ValidateClientRedirectUri(OAuthValidateClientRedirectUriContext context)
        {
            if (context.ClientId == _publicClientId)
            {
                Uri expectedRootUri = new Uri(context.Request.Uri, "/");

                if (expectedRootUri.AbsoluteUri == context.RedirectUri)
                {
                    context.Validated();
                }
            }

            return Task.FromResult<object>(null);
        }

         /// <summary>
         /// Creates user properties.
         /// </summary>
         /// <param name="identity"></param>
         /// <param name="userdetail"></param>
         /// <param name="rolesandPermissions"></param>
         /// <returns></returns>
        public static AuthenticationProperties CreateProperties( ClaimsIdentity identity, OpenEIDSS.Domain.AspNetUserGetDetailModel userdetail, List<AspNetUserGetRolesAndPermissionsModel> rolesandPermissions)
        {
            IDictionary<string, string> data = new Dictionary<string, string>();
            int n = 0;

            data.Add("userName", userdetail.UserName);
            data.Add("ASPNetId", userdetail.Id);
            data.Add("EIDSSUserId", userdetail.idfUserID.ToString());
            data.Add("Email", !string.IsNullOrEmpty(userdetail.Email ) ? userdetail.Email : "");
            data.Add("PersonId", userdetail.idfPerson.ToString());
            data.Add("FirstName", !string.IsNullOrEmpty(userdetail.strFirstName) ? userdetail.strFirstName : "");
            data.Add("SecondName", !string.IsNullOrEmpty(userdetail.strSecondName) ? userdetail.strSecondName : "" );
            data.Add("LastName", !string.IsNullOrEmpty(userdetail.strFamilyName) ? userdetail.strFirstName : "");
            data.Add("SiteId", userdetail.idfsSite.ToString());
            data.Add("Institution", userdetail.Institution.ToString());
            data.Add("Organization", !string.IsNullOrEmpty(userdetail.OfficeAbbreviation) ? userdetail.OfficeAbbreviation : "");
            data.Add("OfficeId", userdetail.idfOffice.ToString());

            if (rolesandPermissions != null && rolesandPermissions.Count > 0)
            {
                // Roles...
                var roles = rolesandPermissions.Select(s => s.Role).Distinct();
                foreach (var r in roles)
                {
                    n++;
                    data.Add( string.Format( "Role{0}", n.ToString()), r);
                }

                n = 0;
                // Permissions...
                foreach (var p in rolesandPermissions)
                {
                    n++;
                    data.Add( string.Format( "Claim{0}", n.ToString()), p.Permission.Trim() + "|" + p.PermissionLevel.Trim());
                    identity.AddClaim(new Claim(ClaimTypes.UserData, p.Permission.Trim() + '.' + p.PermissionLevel.Trim()));
                }
            }

            return new AuthenticationProperties(data);
        }
    }
}