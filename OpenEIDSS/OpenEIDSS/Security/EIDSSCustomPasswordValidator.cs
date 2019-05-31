using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Runtime.Caching;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using Resources;
using Microsoft.Owin;

namespace OpenEIDSS.Security
{
    /// <summary>
    /// EIDSS password policy enforcement class.
    /// </summary> 
    //public sealed class EIDSSCustomPasswordValidator<TUser> : IEIDSSPasswordValidator<TUser> //, IIdentityValidator<string>
    //    where TUser : IdentityUser
    public sealed class EIDSSCustomPasswordValidator : IIdentityValidator<string>
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(EIDSSCustomPasswordValidator));

        private IEIDSSRepository _repository = new EIDSSRepository();

        //private IOwinRequest _request;

        #region Properties

        ///// <summary>
        ///// Gets the number times a user can incorrectly enter his/her password before the account is locked.  The default is 3.
        ///// </summary>
        //public int AccountLockoutThreshold { get; private set; } = 3;

        ///// <summary>
        ///// Gets the duration in minutes), an account is locked when it is locked when the user exceeded the account lockout threshold.  
        ///// The default is 5 minutes
        ///// </summary>
        //public int AccountLockoutDuration { get; private set; } = 5;

        /// <summary>
        /// Gets a value determining whether the use of spaces are allowed in the password.  The default is true.
        /// </summary>
        public bool AllowUseofSpace { get; private set; } = true;

        ///// <summary>
        ///// Indicates whether a warning is displayed due to inactivity in the specified number of minutes.
        ///// </summary>
        //public int DisplaySessionInactivityTimeoutWarning { get; private set; } = 5;

        ///// <summary>
        /// A value indicating the previous number of passwords to track.  A value of 0 indicates that no tracking will occur.  
        /// The default is 12.
        /// </summary>
        public int EnforcePasswordHistory { get; private set; } = 12;

        /// <summary>
        /// Specifies that the password must contain at least one lowercase character.  The default is true.
        /// </summary>
        public bool ForceLowercaseCharacters { get; private set; } = true;

        /// <summary>
        /// Specifies that the password must contain at least one number.  The default is true.
        /// </summary>
        public bool ForceNumbers { get; private set; } = true;

        /// <summary>
        /// Specifies that the password must contain at least one special character (non alpha/numeric).  The default is true.
        /// </summary>
        public bool ForceSpecialCharacters { get; private set; } = true;

        /// <summary>
        /// Specifies that the password must contain at least one uppercase charcter.  The default is true.
        /// </summary>
        public bool ForceUppercaseCharacters { get; private set; } = true;

        /// <summary>
        /// Determines the password age in days.  The default is 60.
        /// THIS IS NOT A COMMON FEATURE IN WEB APPLICATIONS!  IS THIS ABSOLUTELY REQUIRED.
        /// </summary>
        public int MinimumPasswordAgeDays { get; private set; } = 60;

        /// <summary>
        /// Determines the minimum password length for and EIDSS account's password.
        /// The default is 8.
        /// </summary>
        //public int MinimumPasswordLength { get; private set; } = 8;
        public int MinimumPasswordLength { get; private set; } = 8;

        /// <summary>
        /// Determines whether the system prevents the usage of 3 sequential characters or numbers in the EIDSS account password.
        /// The default is true.
        /// </summary>
        public bool PreventSequentialNumbers { get; private set; } = true;

        /// <summary>
        /// Determines if the system will prevent the usage of the username as the password.  The defaul is true.
        /// </summary>
        public bool PreventUsernameAsPassword { get; set; } = true;

        ///// <summary>
        ///// Determines the amount of time (in minutes) when no activity occurs in a users' session before the session is ended.
        ///// Indicates whether a warning is displayed due to inactivity in the specified number of minutes.  
        ///// The default is 15 minutes.
        ///// I DON'T SUGGEST WE DO THIS ONE BECAUSE IT WOULD TAX THE SYSTEM'S RESOURCES...
        ///// </summary>
        //public int SessionInactivityTimeout { get; set; } = 15;

        ///// <summary>
        ///// Determines the amount of time (in hours) that a user's session can span contguously.  The default is 2 hours.
        ///// </summary>
        //public int SessionMaxLength { get; set; } = 2;

        #endregion

        /// <summary>
        /// Instantiates an instance of the class.
        /// </summary>
        /// <param name='config"></param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        public EIDSSCustomPasswordValidator( SecurityConfigurationGetModel config,
            string languageId = "en")
        {
            log.Info("EIDSSCustomPasswordValidator is initialized");

            //CultureInfo ci = new CultureInfo(languageId);

            _init(config, languageId);

            log.Info("EIDSSCustomPasswordValidator returned");
        }


        /// <summary>
        /// Performs password validation
        /// </summary>
        /// <param name="item"></param>
        /// <returns></returns>
        //public Task<IdentityResult> ValidateAsync(UserManager<TUser> manager, TUser user, string password)
        public Task<IdentityResult> ValidateAsync(string item)
        {
            log.Info("ValidatAsync is called");

            IdentityResult Result = IdentityResult.Success;

            try
            {


                //base.ValidateAsync(item);

                // Account lockout threshold, duration and all session settings are picked up in the UI...

                // Allow use of Space...
                if (AllowUseofSpace && !item.Contains(" "))
                    return Task.FromResult(IdentityResult.Failed(Resources.APIResources.SECPOLICY_PasswordSpace_Violation));

                // Enforce password history...


                // Force Lowercase characters...
                if (ForceLowercaseCharacters && !item.Any(ch => char.IsLower(ch)))
                    return Task.FromResult(IdentityResult.Failed(APIResources.SECPOLICY_PasswordLowercase_Violation));

                // Force number...
                if (ForceNumbers && !item.Any(ch => char.IsNumber(ch)))
                    return Task.FromResult(IdentityResult.Failed(APIResources.SECPOLICY_PasswordForceNumber_Violation));

                // Force Special Characters...
                if (ForceSpecialCharacters && !item.Any(ch => _IsSymbol(ch)))
                    return Task.FromResult(IdentityResult.Failed(APIResources.SECPOLICY_PasswordForceSpecialChar_Violation));

                // Force Uppercase characters...
                if (ForceUppercaseCharacters && !item.Any(ch => char.IsUpper(ch)))
                    return Task.FromResult(IdentityResult.Failed(APIResources.SECPOLICY_PasswordForceUppercase_Violation));

                // Minimum password age...


                // Minimum password length...
                if (item.Length < MinimumPasswordLength)
                    return Task.FromResult(IdentityResult.Failed(string.Format(APIResources.SECPOLICY_PasswordMinLength_Violation, MinimumPasswordLength)));

                // Prevents the usage of both sequential numbers and characters...
                if (PreventSequentialNumbers)
                {
                    Result = this.EnforceNumberSequence(item);
                    if (Result != IdentityResult.Success) return Task.FromResult(Result);
                }

                // Prevent username as password...

            }
            catch( Exception e )
            {
                log.Error("ValidateAsync failed", e);
                Result = IdentityResult.Failed(e.ToString());
            }

            log.Info("ValidateAsync returned");

            // Made it thru all checks...
            return Task.FromResult(Result);

        }


        /// <summary>
        /// Inhibits the usage of sequential numbers in the users' password
        /// </summary>
        /// <param name="item">A string representing the users' passsword.</param>
        /// <returns>An IdentityResult value representing the state of the rule enforcement.</returns>
        private IdentityResult EnforceNumberSequence(string item)
        {
            IdentityResult result = IdentityResult.Success;

            log.Info("EnforceNumberSequence is called");

            try
            {
                #region functions

                // This function tests if numbers are sequential...
                bool IsSequentialNumbers(int[] array)
                {
                    return
                        array.Zip(
                            // zip enumerates each element, so...
                            // each time thru, skip 1... (this represents the 2nd array)
                            array.Skip(1),

                            // indicate the function we want to execute over each item...
                            // in our case, pass in the current item from both arrays and test if array item (a) + 1 = b
                            // The condition must be true for "All" items...
                            (a, b) => (a + 1) == b).All(x => x);
                }

        
                #endregion

                if (item == null) return IdentityResult.Failed("Please enter a password");

                int firstItem = 0; 
                int count = 1;
                List<int> numbers = new List<int>();
                List<string> chars = new List<string>();
                bool charpreceeded = true;
                bool numberpreceeded = true;
                string alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                string ints = "0123456789";

                // Use Linq to extract letters and numbers!!
                #region Extraction

                // Given the entire password, extract numbers and characters that are in line to each other...
                foreach (var ch in item)
                {
                    // numbers...
                    if (char.IsNumber(ch))
                    {
                        if (count == 1 || numberpreceeded)
                            numbers.Add(Convert.ToInt32(ch));

                        else if (!numberpreceeded)
                        {
                            numbers.Clear();
                            numbers.Add(Convert.ToInt32(ch));
                        }
                        numberpreceeded = true;

                    }
                    else numberpreceeded = false;

                    // alphas...
                    if (char.IsLetter(ch))
                    {
                        if (count == 1 || charpreceeded)
                            chars.Add(ch.ToString());
                        else if (!charpreceeded)
                        {
                            chars.Clear();
                            chars.Add(ch.ToString());
                        }
                        charpreceeded = true;
                    }
                    else charpreceeded = false;

                    count++;
                }

                #endregion

                #region Enforcement

                // Number enforcement...
                count = 0;
                foreach (int x in numbers)
                {
                    // First value in the ordered list: start of a sequence
                    if (count == 0)
                    {
                        firstItem = x;
                        count = 1;
                    }
                    // Skip duplicate values
                    else if (x == firstItem + count - 1)
                    {
                        // No need to do anything
                    }
                    // New value contributes to sequence
                    else if (x == firstItem + count)
                    {
                        count++;
                    }
                    // End of one sequence, start of another
                    else
                    {
                        if (count >= 3)
                            result = IdentityResult.Failed("Passwords cannot contain sequential numbers");

                        count = 1;
                        firstItem = x;
                    }
                }
                if (count >= 3)
                    result = IdentityResult.Failed("Passwords cannot contain sequential numbers");

                // Alphas...
                // Look for the sequence within the alpha list...
                var seq = String.Join("", chars);
                if (alpha.IndexOf(seq, StringComparison.CurrentCultureIgnoreCase) >= 0)
                    result = IdentityResult.Failed( APIResources.SECPOLICY_PasswordSequentialCharacter_Violation);


                #endregion
            }
            finally
            {
                log.Info("EnforceNumberSequence returned");
            }


            return result;
        }

        #region init

        /// <summary>
        /// Sets field values with security policy retrieved from the api.
        /// </summary>
        /// <param name="config"></param>
        /// <param name="language"></param>
        private void _init(SecurityConfigurationGetModel config, string language = "en")
        {
            log.Info("_init is called");
            try
            {

                if (config != null)
                {

                    //// Test for a value  in each policy setting, in the event no value exists, the default is used (see property declaration)...
                    //// account lockout threshold...
                    //if (config.LockoutThld.HasValue) this.AccountLockoutDuration = config.LockoutThld.Value;

                    //// account lockout duration...
                    //if (config.LockoutDurationMinutes.HasValue) this.AccountLockoutDuration = config.LockoutDurationMinutes.Value;

                    //// allow use of space...
                    if (config.AllowUseOfSpaceFlag.HasValue) this.AllowUseofSpace = config.AllowUseOfSpaceFlag.Value;

                    //// display session inactivity timeout warning...
                    //if (config.SesnIdleTimeoutWarnThldMins.HasValue) this.DisplaySessionInactivityTimeoutWarning = config.SesnIdleTimeoutWarnThldMins.Value;

                    // enforce password history...
                    //if (config.EnforcePasswordHistoryFlag.HasValue) this.EnforcePasswordHistory = config.EnforcePasswordHistoryFlag.Value;

                    // force lowercase...
                    if (config.ForceLowercaseFlag.HasValue) this.ForceLowercaseCharacters = config.ForceLowercaseFlag.Value;

                    // force uppercase...
                    if (config.ForceUppercaseFlag.HasValue) this.ForceUppercaseCharacters = config.ForceUppercaseFlag.Value;

                    // force numbers...
                    if (config.ForceNumberUsageFlag.HasValue) this.ForceNumbers = config.ForceNumberUsageFlag.Value;

                    // force special characters...
                    if (config.ForceSpecialCharactersFlag.HasValue) this.ForceSpecialCharacters = config.ForceSpecialCharactersFlag.Value;

                    // minimum password age...
                    if (config.MinPasswordAgeDays.HasValue) this.MinimumPasswordAgeDays = config.MinPasswordAgeDays.Value;

                    // minimum password length...
                    if (config.MinPasswordLength.HasValue) this.MinimumPasswordLength = config.MinPasswordLength.Value;

                    // prevent sequential numbers...
                    if (config.PreventSequentialCharacterFlag.HasValue) this.PreventSequentialNumbers = config.PreventSequentialCharacterFlag.Value;

                    // prevent username as password...
                    if (config.PreventUsernameUsageFlag.HasValue) this.PreventUsernameAsPassword = config.PreventUsernameUsageFlag.Value;

                    //// session inactivity timeout...
                    //if (config.SesnIdleCloseoutThldMins.HasValue) this.SessionInactivityTimeout = config.SesnIdleCloseoutThldMins.Value;

                    //// session max length...
                    //if (config.MaxSessionLength.HasValue) this.SessionMaxLength = config.MaxSessionLength.Value;

                }
            }

            catch( Exception e )
            {
                log.Error("_init failed", e);
            }

            log.Info("_init returned");


        }


        #endregion

        /// <summary>
        /// Determines if the passed in character is a symbol.
        /// </summary>
        /// <param name="c"></param>
        /// <returns></returns>
        private bool _IsSymbol( char c )
        {
            char[] symbols =
                new char[] 
                { '~','!','@','#','$','%','^','&','*','(',')','-','_','+','=','{','}','[',']','|','\\',',','/','<','>' };

            return symbols.Contains(c);

        }

    }
}