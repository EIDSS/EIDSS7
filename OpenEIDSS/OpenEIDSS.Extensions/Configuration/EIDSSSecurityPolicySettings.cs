using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Extensions.Configuration
{
//    /// <summary>
//    /// EIDSS security policy Configuration Settings Section 
//    /// </summary>
//    public sealed class EIDSSSecurityPolicySettingsSection : ConfigurationSection
//    {

//        /// <summary>
//        /// Create a new instance of the class.
//        /// </summary>
//        public EIDSSSecurityPolicySettingsSection()
//            : base()
//        {
//        }

//        /// <summary>
//        /// Configuration properties relevant to the user's account.
//        /// </summary>
//        [ConfigurationProperty("userAccountRequirements")]
//        public UserAccountRequirementsConfigElement UserAccountRequirements 
//        {
//            get { return base["userAccountRequirements"] as UserAccountRequirementsConfigElement; }
//        }

//        /// <summary>
//        /// Configuration properties relevant to the user's password.
//        /// </summary>
//        [ConfigurationProperty("passwordRequirements")]
//        public PasswordRequirementsConfigElement PasswordRequirements
//        {
//            get { return base["passwordRequirements"] as PasswordRequirementsConfigElement; }
//        }

//    }

//    /// <summary>
//    /// User account configuration element
//    /// </summary>
//    public class UserAccountRequirementsConfigElement : ConfigurationElement
//    {
//        /// <summary>
//        /// When a user's account is locked due to entering the password incorrectly determined by the 
//        /// lockout threshold, this property indicates the amount of time the account is locked before
//        /// the user can attempt to login again.  The default is 5 minutes.
//        /// </summary>
//        [ConfigurationProperty("accountLockoutDuration", IsRequired = false, DefaultValue = 5)]
//        public int AccountLockoutDuration
//        {
//            get { return ((int)(base["accountLockoutDuration"])); }
//            set { base["accountLockoutDuration"] = value; }

//        }

//        /// <summary>
//        /// Specifies the number of times a user can incorrectly attempt to login before the account is locked.
//        /// The default is 3 attempts.
//        /// </summary>
//        [ConfigurationProperty("accountLockoutThreshold", IsRequired = false, DefaultValue = 3)]
//        public int AccountLockoutThreshold
//        {
//            get { return ((int)(base["accountLockoutThreshold"])); }
//            set { base["accountLockoutThreshold"] = value; }

//        }
        
//        /// <summary>
//        /// When true specifies that the username must contain both alpha and numeric characters.  The default is true.
//        /// </summary>
//        [ConfigurationProperty("allowOnlyAphaNumericUserNames", IsRequired = false, DefaultValue = true)]
//        public bool AllowOnlyAlphaNumericUserNames
//        {
//            get { return ((bool)(base["allowOnlyAphaNumericUserNames"])); }
//            set { base["allowOnlyAphaNumericUserNames"] = value; }
//        }

//        /// <summary>
//        /// 
//        /// </summary>
//        [ConfigurationProperty("displaySessionInactivityTimeoutWarning", IsRequired = false, DefaultValue = 2)]
//        public int DisplaySessionInactivityTimeoutWarning
//        {
//            get { return ((int)(base["displaySessionInactivityTimeoutWarning"])); }
//            set { base["displaySessionInactivityTimeoutWarning"] = value; }
//        }

//        [ConfigurationProperty("requireUniqueEmail", IsRequired = true, DefaultValue = false)]
//        public bool RequireUniqueEmail
//        {
//            get { return ((bool)(base["requireUniqueEmail"])); }
//            set { base["requireUniqueEmail"] = value; }
//        }

//        [ConfigurationProperty("sessionInactivityTimeOut", IsRequired = false, DefaultValue = 15)]
//        public int SessionInactivityTimeOut
//        {
//            get { return ((int)(base["sessionInactivityTimeOut"])); }
//            set { base["sessionInactivityTimeOut"] = value; }
//        }

//        [ConfigurationProperty("sessionMaximumLengthHours")]
//        public int SessionMaximumLength
//        {
//            get { return ((int)(base["sessionMaximumLengthHours"])); }
//            set { base["sessionMaximumLengthHours"] = value; }
//        }

//    }

//    public class PasswordRequirementsConfigElement : ConfigurationElement
//    {

//        [ConfigurationProperty( "allowUsageOfSpace", IsRequired = true, DefaultValue =true)]
//        public bool AllowUsageOfSpace
//        {
//            get { return ((bool)(base["allowsUsageOfSpace"])); }
//            set { base["allowUsageOfSpace"] = value; }
//        }

//        [ConfigurationProperty("checkAgainstCommonlyUsedPasswords", IsRequired =false, DefaultValue =false)]
//        public bool CheckAgainstCommonlyUsedPasswords
//        {
//            get { return ((bool)(base["checkAgainstCommonlyUsedPasswords"])); }
//            set { base["checkAgainstCommonlyUsedPasswords"] = value; }

//        }

//        [ConfigurationProperty("checkDictionaryWord", IsRequired =false, DefaultValue =false)]
//        public bool CheckDictionaryWord
//        {
//            get { return ((bool)(base["checkDictionaryWord"])); }
//            set { base["checkDictionaryWord"] = value; }
//        }

//        /// <summary>
//        /// When 0 no password history will be kept, when 1 or greater, the same password cannot be used
//        /// for that number of historical changes.  
//        /// The default is 12.
//        /// </summary>
//        [ConfigurationProperty("forcePasswordHistory", IsRequired = true, DefaultValue = 12)]
//        public int ForcePasswordHistory
//        {
//            get { return ((int)(base["forcePasswordHistory"])); }
//            set { base["forcePasswordHistory"] = value; }
//        }


//        [ConfigurationProperty("forceSpecialCharacters", IsRequired = true, DefaultValue =true)]
//        public bool ForceSpecialCharacters
//        {
//            get { return ((bool)(base["forceSpecialCharacters"])); }
//            set { base["forceSpecialCharacters"] = value; }
//        }

//        /// <summary>
//        /// Indicates that at least 1 character of the users password should be an upper case letter.
//        /// </summary>
//        [ConfigurationProperty("forceUpperCase", IsRequired = true, DefaultValue =true)]
//        public bool ForceUpperCase
//        {
//            get { return ((bool)(base["forceUpperCase"])); }
//            set { base["forceUpperCase"] = value; }
//        }

//        /// <summary>
//        /// Indicates that at least 1 character of the users password should be a lower case letter.
//        /// </summary>
//        [ConfigurationProperty("forceLowerCase", IsRequired = true, DefaultValue = true)]
//        public bool ForceLowerCase
//        {
//            get { return ((bool)(base["forceLowerCase"])); }
//            set { base["forceLowerCase"] = value; }
//        }

//        /// <summary>
//        /// Enforces the use of at least 1 number in the users password.
//        /// </summary>
//        [ConfigurationProperty("forceNumberUsage", IsRequired = true, DefaultValue = true)]
//        public bool ForceNumberUsage
//        {
//            get { return ((bool)(base["forceNumberUsage"])); }
//            set { base["forceNumberUsage"] = value; }
//        }

//        /// <summary>
//        /// Determines the period (in days) when a user is forced to change his/her password.  
//        /// The default is 60 days.
//        /// </summary>
//        [ConfigurationProperty("minimumPasswordAge", IsRequired = true, DefaultValue = 60)]
//        public int MinimumPasswordAge
//        {
//            get { return ((int)(base["minimumPasswordAge"])); }
//            set { base["minimumPasswordAge"] = value; }
//        }

//        /// <summary>
//        /// Indicates the minimum password length.  
//        /// The default is 8.
//        /// </summary>
//        [ConfigurationProperty("minimumPasswordLength", IsRequired = true, DefaultValue = 8)]
//        public int MinimumPasswordLength
//        {
//            get { return ((int)(base["minimumPasswordLength"])); }
//            set { base["minimumPasswordLength"] = value; }
//        }

//        /// <summary>
//        /// When true, prevents the usage of sequential numbers in a users password.
//        /// The default is true.
//        /// </summary>
//        [ConfigurationProperty("preventSequentialNumbers", IsRequired = false, DefaultValue = true)]
//        public bool PreventSequentialNumbers
//        {
//            get { return ((bool)(base["preventSequentialNumbers"])); }
//            set { base["preventSequentialNumbers"] = value; }
//        }

//        [ConfigurationProperty("preventUsageOfUsername", IsRequired= true, DefaultValue = true)]
//        public bool PreventUsageOfPassword
//        {
//            get { return ((bool)(base["preventUsageOfUsername"])); }
//            set { base["preventUsageOfUsername"] = value; }
//        }

//        ///// <summary>
//        ///// 
//        ///// </summary>
//        //[ConfigurationProperty("requireNonLetterOrObject", IsRequired = true, DefaultValue = true)]
//        //public bool RequireNonLetterOrDigit
//        //{
//        //    get { return ((bool)(base["requireNonLetterOrObject"])); }
//        //    set { base["requireNonLetterOrObject"] = value; }
//        //}

//    }

}
