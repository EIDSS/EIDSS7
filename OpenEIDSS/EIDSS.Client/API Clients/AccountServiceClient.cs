using EIDSS.Client.Abstracts;
using EIDSS.Client.Requests;
using EIDSS.Client.Responses;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace EIDSS.Client.API_Clients
{
    public class AccountServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(AccountServiceClient));

        /// <summary>
        /// Instantiates a new instance of the object.
        /// This contructor overrides the base constructor.
        /// </summary>
        public AccountServiceClient() : base()
        {
        }

        /// <summary>
        /// Logs a user into the application.
        /// </summary>
        /// <param name="username"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public void Logon(string username, string password)
        {
            log.Info("Logon is called");
            SecurityErrorResponse errorResponse = null;

            // This call clears the roles and claims to ensure we're always starting with an empty list...
            EIDSSAuthenticatedUser.Clear();

            var creds = new Dictionary<string, string>
               {
                   {"grant_type", "password"},
                   {"username", username},
                   {"password", password},
               };

            // Perform the login!
            var response = _apiclient.PostAsync(Settings.GetResourceValue("Logon"), new FormUrlEncodedContent(creds)).Result;

            if (!response.IsSuccessStatusCode)
            {
                errorResponse = response.Content.ReadAsAsync<SecurityErrorResponse>(new List<MediaTypeFormatter> { Formatter }).Result;
                var ex = new Exception(errorResponse.ErrorDescription);
                log.Error("Logon failed", ex);
                throw ex;
            }

            // Extract the result from the response object as a JToken...
            var payload = response.Content.ReadAsAsync<Newtonsoft.Json.Linq.JObject>(new List<MediaTypeFormatter> { Formatter }).Result;


            // Serialize the payload to the EIDSSAuthenticatedUser class.  This initializes all the properties decorated with [DataMember] contract.
            payload.ToObject<EIDSSAuthenticatedUser>();

            // All that remains is to enumerate the roles and claims...
            foreach (var child in payload)
            {
                var value = child.Value.Value<string>();

                if (child.Key.ToLower().StartsWith("role") && EIDSSAuthenticatedUser.RoleMembership.IndexOf(value) == -1 )
                    EIDSSAuthenticatedUser.RoleMembership.Add(value);
                if (child.Key.ToLower().StartsWith("claim")) ExtractPermission(value);
            }

            log.Info("Logon returned");

        }

        public void Register( UserRegistrationInfo userinfo)
        {
            log.Info("Register is called");
            UserAdminRequestResponse errorResponse = null;

            try
            {
                //var content = new Dictionary<string, string>
                //{
                //    {"idfUserID", userinfo.idfUserID.ToString() },
                //    {"Email", userinfo.Email },
                //    {"Password", userinfo.Password },
                //    {"ConfirmPassword", userinfo.Password },
                //    {"UserName", userinfo.UserName }
                //};
                //var response = _apiclient.PostAsync(Settings.GetResourceValue("Register"), new FormUrlEncodedContent(content)).Result;

                var content = CreateRequestContent(userinfo);
                var response = _apiclient.PostAsync(Settings.GetResourceValue("Register"), content).Result;

                if ( !response.IsSuccessStatusCode )
                {
                    try
                    {
                        errorResponse = response.Content.ReadAsAsync<UserAdminRequestResponse>(new List<MediaTypeFormatter> { Formatter }).Result;
                    }
                    catch( Exception e)
                    {
                        throw e;
                    }
                    var ex = new Exception(errorResponse.Message);
                    throw ex;
                }

            }
            catch( Exception ex )
            {
                log.Error("Register failed", ex);
                throw ex;
            }

        }

        #region Helpers


        /// <summary>
        /// Extracts a user permission from a dictionary entry returned with the authentication packet.
        /// </summary>
        /// <param name="node"></param>
        /// <returns></returns>
        private void ExtractPermission( string node )
        {
            // return if null or empty...
            if (string.IsNullOrEmpty(node)) return;

            // each entry contains both the permission and the permission level seperated with a pipe | symbol.
            var entries = node.Split('|');

            // check to see if this permission exists in the list...
            var p = EIDSSAuthenticatedUser.Claims.Where(w => w.PermissionType.ToLower() == entries[0].ToLower());
            if (p != null && p.Count() > 0) // test for count because Permission is auto-instantiated and may be empty first time thru...
            {
                // Check to see if the permission level exists...
                if (p.FirstOrDefault().PermissionLevels.IndexOf(entries[1]) == -1)
                    p.FirstOrDefault().PermissionLevels.Add(entries[1]);

            }
            else
            {
                var x = new Permission
                {
                    PermissionType = entries[0],
                    PermissionLevels = new List<string>(new string[] { entries[1] })
                };
                EIDSSAuthenticatedUser.Claims.Add(x);
            }
        }


        #endregion

    }
}
