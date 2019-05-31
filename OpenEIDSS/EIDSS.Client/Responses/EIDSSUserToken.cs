using EIDSS.Client.Enumerations;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace EIDSS.Client.Responses
{
    /// <summary>
    /// User information returned from the API when the user is successfully authenticated.
    /// </summary>
    [DataContract]
    public class EIDSSAuthenticatedUser
    {
        #region Properties

        /// <summary>
        /// The authorization bearer token. 
        /// </summary>
        [DataMember(Name = "access_token")]
        public static string AccessToken { get; private set; }


        /// <summary>
        /// A string representing the ASPNet Identity identifier for the logged in user.
        /// </summary>
        [DataMember]
        public static string ASPNetId { get; private set; }

        /// <summary>
        /// An integer representing the EIDSS Userid for the logged in user.
        /// </summary>
        [DataMember]
        public static string EIDSSUserId { get; private set; }

        /// <summary>
        /// The logged in users email address.  This value is not required by the system and may be null.
        /// </summary>
        [DataMember]
        public static string Email { get; private set; }

        /// <summary>
        /// Date and time the token expires in universal time (GMT).
        /// </summary>
        [DataMember(Name = ".expires")]
        public static DateTime ExpireDate { get; private set; }

        /// <summary>
        /// Indicates the expiry of the token (in seconds).
        /// </summary>
        [DataMember(Name = "expires_in")]
        public static int ExpireSeconds { get; private set; }

        /// <summary>
        /// The firstname of the logged in user.
        /// </summary>
        [DataMember]
        public static string FirstName { get; private set; }

        /// <summary>
        /// An integer representing the institution (organization) of the logged in user.
        /// </summary>
        [DataMember]
        public static string Institution { get; private set; }

        /// <summary>
        /// Date and time the token was issued in universal time (GMT).
        /// </summary>
        [DataMember(Name = ".issued")]
        public static DateTime IssueDate { get; private set; }

        /// <summary>
        /// An integer representing the EIDSS person/employee identifier of the logged in user.
        /// </summary>
        [DataMember]
        public static string PersonId { get; private set; }

        /// <summary>
        /// The lastname of the logged in user.
        /// </summary>
        [DataMember]
        public static string LastName { get; private set; }

        /// <summary>
        /// An integer representing the office (location) of the logged in user.
        /// </summary>
        [DataMember]
        public static long OfficeId { get; private set; }

        /// <summary>
        /// An integer representing the organization (institution) of the logged in user. 
        /// </summary>
        [DataMember]
        public static string Organization { get; private set; }

        /// <summary>
        /// The logged in users middlename.  
        /// </summary>
        [DataMember]
        public static string SecondName { get; private set; }

        /// <summary>
        /// An integer that represents the site of the logged in user.
        /// </summary>
        [DataMember]
        public static string SiteId { get; private set; }

        /// <summary>
        /// A string indicating the type of token this is.
        /// </summary>
        [DataMember(Name = "token_type")]
        public static string TokenType { get; private set; }

        /// <summary>
        /// The user for which the token is assigned.
        /// </summary>
        [DataMember(Name = "userName")]
        public static string UserName { get; private set; }

        public static List<string> RoleMembership { get; private set; } = new List<string>();

        public static List<Permission> Claims { get; private set; } = new List<Permission>();

        #endregion
        
        /// <summary>
        /// Returns an instance of the EIDSSAuthenticatedUser class.
        /// </summary>
        /// <returns></returns>
        public static EIDSSAuthenticatedUser Instance()
        {
            return new EIDSSAuthenticatedUser();
        }

        /// <summary>
        /// Returns the entire list of the logged in user's permissions.
        /// </summary>
        /// <returns></returns>
        public static List<Permission> GetPermissions()
        {
            return Claims;
        }

        /// <summary>
        /// Determines if the user has been assigned to any of the given roles.
        /// </summary>
        /// <param name="roles"></param>
        /// <returns></returns>
        public static bool IsInAnyRole( List<EIDSSRoleEnum> roles)
        {
            // convert the list of enums to list of strings...
            List<string> r = new List<string>();
            roles.ForEach(a => r.Add(a.ToEnumString()));

            // Get the exceptions of the two lists...
            // If the exception list is empty, this means the user is assigned all of the passed in roles...
            // If the list contains any items, the user hasn't been assigned all roles.
            return RoleMembership.Except(r).Any();
        }

        /// <summary>
        /// Determines if the logged in user has been assigned the specified role.
        /// </summary>
        /// <param name="role"></param>
        /// <returns></returns>
       public static bool IsInRole( EIDSSRoleEnum role )
        {
            var r = role.ToEnumString().Replace(" ", string.Empty).ToLower();

            // case insensitive compare...
            var ret = RoleMembership.Where(a => a.Replace( " ", string.Empty).ToLower() == r);

            return !(ret == null || ret.Count() == 0);
            //return RoleMembership.Any(a => a.ToLower() == role.ToEnumString().ToLower());
        }

        /// <summary>
        /// Determines if the logged in has been assigned to all of the given roles.
        /// </summary>
        /// <param name="roles"></param>
        /// <returns></returns>
        public static bool IsInRole( List<EIDSSRoleEnum> roles)
        {
            // convert the list of enums to list of strings...
            List<string> r = new List<string>();
            roles.ForEach(a => r.Add(a.ToEnumString()));

            // Get the exceptions of the two lists...
            // If the exception list is empty, this means the user is assigned all of the passed in roles...
            // If the list contains any items, the user hasn't been assigned all roles.
            return !RoleMembership.Except(r).Any();

        }

        /// <summary>
        /// Clears the roles and permissions.
        /// </summary>
        static internal void Clear()
        {
            AccessToken = null;
            ASPNetId = null;
            EIDSSUserId = null;
            Email = null;
            FirstName = null;
            Institution = null;
            PersonId = null;
            LastName = null;
            OfficeId = 0;
            Organization = null;
            SecondName = null;
            SiteId = null;
            UserName = null;

            RoleMembership = new List<string>();
            Claims = new List<Permission>();
        }


    }
}
