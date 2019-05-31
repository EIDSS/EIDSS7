using System;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using NUnit.Framework;
using OpenQA.Selenium.Interactions;
using System.Threading;

namespace EIDSS7Test.Selenium
{
    public class LoginPage
    {
        private static By HeaderFormTitle = By.TagName("h1");
        private static By EIDSSHomePageLogo = By.Id("ucPageHeader_lnkHome");
        private static By lblOrganizationText = By.Id("lblOrganizationText");
        private static By txtOrganization = By.Id("txtOrganization");
        private static By lblUserName = By.Id("lblUserName");
        private static By txtUserName = By.Id("txtUserName");
        private static By lblPasswordText = By.Id("lblUserKey");
        private static By txtPassword = By.Id("txtPassword");
        //private static IWebElement btnLogIn { get { return Driver.Instance.FindElement(By.Id("btnLogin")); } }
        private static By btnLogIn = By.XPath("//*[@id='btnLogin']");
        private static By errorUserNameMsg = By.Id("rfvUserName");
        private static By errorOrgMsg = By.Id("rfvOrganization");
        private static By errorPwdMsg = By.Id("rfvPassword");
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(360));
        public static IJavaScriptExecutor executor = (IJavaScriptExecutor)Driver.Instance;
        public static string errorString;
        private static string organization = "MoLHAH";
        private static string username = "NCDC&PH Administrator";
        private static string AJUserName = "AJTestAdmin";
        private static string IQUserName = "IQTestAdmin";
        private static string KZUserName = "KZTestAdmin";
        private static string AMUserName = "AMTestAdmin";
        private static string DEVIntegUserName = "JDoe";
        private static string GGUserName = "GGTestAdmin";
        private static string GGBetaUserName = "GGBetaAdmin";
        private static string AJBetaUserName = "AJBetaAdmin";
        private static string UKBetaUserName = "UKBetaAdmin";
        private static string AMBetaUserName = "AMBetaAdmin";
        private static string KZBetaUserName = "KZBetaAdmin";
        private static string IQBetaUserName = "IQBetaAdmin";
        private static string THBetaUserName = "THBetaAdmin";
        private static string DEVUserName = "demo";
        private static string DEVIntPWD = "EIDSS123";
        private static string USBetaUserName = "demo";
        private static string pwd = "EIDSS";
        private static string BetaPWD = "!EIDSSADMIN)";
        private static string QApwd = "QAGROUP";

        public static bool IsAt
        {
            get
            {
                Driver.Instance.WaitForPageToLoad();
                if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                     || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Page cannot be displayed");
                    return false;
                }
                else if (Driver.Instance.FindElements(EIDSSHomePageLogo).Count > 0)
                {
                    {
                        Driver.Wait(TimeSpan.FromMinutes(45));
                        if (Driver.Instance.FindElement(EIDSSHomePageLogo).Displayed)
                            return true;
                        else
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                }
                else if (Driver.Instance.FindElement(HeaderFormTitle).Text.Contains("This page isn't working"))
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                    return false;
                }
                else
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Page cannot be displayed");
                    return false;
                }
            }
        }


        public static void GoTo()
        {
            try
            {
                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Driver.Wait(TimeSpan.FromMinutes(10));
                Driver.Instance.Manage().Window.Maximize();
                var wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(10));
                Driver.Wait(TimeSpan.FromMinutes(10));
            }
            catch
            {
                //executor.ExecuteScript("top.window.moveTo(0,0); top.window.resizeTo(screen.availWidth,screen.availHeight); ");
                //var screenResolution = new Size(SystemInformation.PrimaryMonitorSize.Width, SystemInformation.PrimaryMonitorSize.Height);
                //Driver.Instance.Manage().Window.Size = screenResolution;
            }
        }

        public static By getOrg(string organization)
        {
            return txtOrganization;
        }

        public static By getUsr(string usrname)
        {
            return txtUserName;
        }

        public static By getPW(string password)
        {
            return txtPassword;
        }

        public static void LoginIntoBetaEIDSS(String usrnm, string pwds)
        {
            try
            {
                Driver.Instance.WaitForPageToLoad();
                if (Driver.Instance.Title.Contains("403 - Forbidden: Access is denied.") || Driver.Instance.Title.Contains("The resource cannot be found.")
                    || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                {
                    var usr = wait.Until(ExpectedConditions.ElementIsVisible(txtUserName));
                    usr.SendKeys(usrnm);

                    var pw = wait.Until(ExpectedConditions.ElementIsVisible(txtPassword));
                    pw.SendKeys(pwds);

                    var login = wait.Until(ExpectedConditions.ElementIsVisible((btnLogIn)));
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    login.SendKeys(OpenQA.Selenium.Keys.Space);
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    //wait.Until(ExpectedConditions.ElementIsVisible(EIDSSHomePageLogo));
                }
                else
                {
                    var usr = wait.Until(ExpectedConditions.ElementIsVisible(txtUserName));
                    usr.SendKeys(usrnm);

                    var pw = wait.Until(ExpectedConditions.ElementIsVisible(txtPassword));
                    pw.SendKeys(pwds);

                    var login = wait.Until(ExpectedConditions.ElementIsVisible((btnLogIn)));
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    login.SendKeys(OpenQA.Selenium.Keys.Space);
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    //wait.Until(ExpectedConditions.ElementIsVisible(EIDSSHomePageLogo));
                }
            }
            catch
            {
                if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("The resource cannot be found."))
                {
                    var usr = wait.Until(ExpectedConditions.ElementIsVisible(txtUserName));
                    usr.SendKeys(usrnm);

                    var pw = wait.Until(ExpectedConditions.ElementIsVisible(txtPassword));
                    pw.SendKeys(pwds);

                    var login = wait.Until(ExpectedConditions.ElementIsVisible((btnLogIn)));
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    login.SendKeys(OpenQA.Selenium.Keys.Space);
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    //wait.Until(ExpectedConditions.ElementIsVisible(EIDSSHomePageLogo));
                }
                else
                {
                    var usr = wait.Until(ExpectedConditions.ElementIsVisible(txtUserName));
                    usr.SendKeys(usrnm);

                    var pw = wait.Until(ExpectedConditions.ElementIsVisible(txtPassword));
                    pw.SendKeys(pwds);

                    var login = wait.Until(ExpectedConditions.ElementIsVisible((btnLogIn)));
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    login.SendKeys(OpenQA.Selenium.Keys.Space);
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    //wait.Until(ExpectedConditions.ElementIsVisible(EIDSSHomePageLogo));
                }
            }
        }

        public static void LoginIntoEIDSS(String usrnm, string pwds)
        {
            try
            {
                Driver.Instance.WaitForPageToLoad();
                if (Driver.Instance.Title.Contains("403 - Forbidden: Access is denied.") || Driver.Instance.Title.Contains("The resource cannot be found.")
                    || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Driver.Wait(TimeSpan.FromMinutes(10));

                    var usr = wait.Until(ExpectedConditions.ElementIsVisible(txtUserName));
                    usr.SendKeys(usrnm);

                    var pw = wait.Until(ExpectedConditions.ElementIsVisible(txtPassword));
                    pw.SendKeys(pwds);

                    var login = wait.Until(ExpectedConditions.ElementIsVisible((btnLogIn)));
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    login.SendKeys(OpenQA.Selenium.Keys.Space);
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    //wait.Until(ExpectedConditions.ElementIsVisible(EIDSSHomePageLogo));
                }
                else
                {
                    var usr = wait.Until(ExpectedConditions.ElementIsVisible(txtUserName));
                    usr.SendKeys(usrnm);

                    var pw = wait.Until(ExpectedConditions.ElementIsVisible(txtPassword));
                    pw.SendKeys(pwds);

                    var login = wait.Until(ExpectedConditions.ElementIsVisible((btnLogIn)));
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    login.SendKeys(OpenQA.Selenium.Keys.Space);
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    //wait.Until(ExpectedConditions.ElementIsVisible(EIDSSHomePageLogo));
                }
            }
            catch
            {
                if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("The resource cannot be found."))
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Driver.Wait(TimeSpan.FromMinutes(10));

                    var usr = wait.Until(ExpectedConditions.ElementIsVisible(txtUserName));
                    usr.SendKeys(usrnm);

                    var pw = wait.Until(ExpectedConditions.ElementIsVisible(txtPassword));
                    pw.SendKeys(pwds);

                    var login = wait.Until(ExpectedConditions.ElementIsVisible((btnLogIn)));
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    login.SendKeys(OpenQA.Selenium.Keys.Space);
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    //wait.Until(ExpectedConditions.ElementIsVisible(EIDSSHomePageLogo));
                }
                else
                {
                    var usr = wait.Until(ExpectedConditions.ElementIsVisible(txtUserName));
                    usr.SendKeys(usrnm);

                    var pw = wait.Until(ExpectedConditions.ElementIsVisible(txtPassword));
                    pw.SendKeys(pwds);

                    var login = wait.Until(ExpectedConditions.ElementIsVisible((btnLogIn)));
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    login.SendKeys(OpenQA.Selenium.Keys.Space);
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    //wait.Until(ExpectedConditions.ElementIsVisible(EIDSSHomePageLogo));
                }
            }
        }

        public static void GGLoginIntoEIDSS()
        {
            LoginIntoEIDSS(GGUserName, QApwd);
        }

        public static void AJLoginIntoEIDSS()
        {
            LoginIntoEIDSS(AJUserName, QApwd);
        }

        public static void KZLoginIntoEIDSS()
        {
            LoginIntoEIDSS(KZUserName, QApwd);
        }

        public static void AMLoginIntoEIDSS()
        {
            LoginIntoEIDSS(AMUserName, QApwd);
        }

        public static void IQLoginIntoEIDSS()
        {
            LoginIntoEIDSS(IQUserName, QApwd);
        }

        public static void GGBetaLoginIntoEIDSS()
        {
            LoginIntoEIDSS(GGBetaUserName, BetaPWD);
        }

        public static void AJBetaLoginIntoEIDSS()
        {
            LoginIntoEIDSS(AJBetaUserName, BetaPWD);
        }
        public static void KZBetaLoginIntoEIDSS()
        {
            LoginIntoEIDSS(KZBetaUserName, BetaPWD);
        }

        public static void AMBetaLoginIntoEIDSS()
        {
            LoginIntoEIDSS(AMBetaUserName, BetaPWD);
        }
        public static void UKBetaLoginIntoEIDSS()
        {
            LoginIntoEIDSS(UKBetaUserName, BetaPWD);
        }
        public static void IQBetaLoginIntoEIDSS()
        {
            LoginIntoEIDSS(IQBetaUserName, BetaPWD);
        }

        public static void THBetaLoginIntoEIDSS()
        {
            LoginIntoEIDSS(THBetaUserName, BetaPWD);
        }


        public static void USBetaLoginIntoEIDSS()
        {
            LoginIntoEIDSS(USBetaUserName, pwd);
        }

        public static void DEVLoginIntoEIDSS()
        {
            LoginIntoEIDSS(DEVUserName, pwd);
        }

        public static void DEVIntegLoginIntoEIDSS()
        {
            LoginIntoEIDSS(DEVIntegUserName, DEVIntPWD);
        }


        public static void LoginIntoEIDSSErrorTest(string orgs, string usrs, string passwds)
        {
            try
            {
                Thread.Sleep(2000);
                var org = wait.Until(ExpectedConditions.ElementIsVisible(txtOrganization));
                org.SendKeys(orgs);

                var usr = wait.Until(ExpectedConditions.ElementIsVisible(txtUserName));
                usr.SendKeys(usrs);

                var pw = wait.Until(ExpectedConditions.ElementIsVisible(txtPassword));
                pw.SendKeys(passwds);

                var login = wait.Until(ExpectedConditions.ElementIsVisible((btnLogIn)));
                Driver.Wait(TimeSpan.FromMinutes(10));
                login.Click();
                Driver.Wait(TimeSpan.FromMinutes(1000));
                //wait.Until(ExpectedConditions.ElementIsVisible(EIDSSHomePageLogo));
            }
            catch
            {
                var org = wait.Until(ExpectedConditions.ElementIsVisible(txtOrganization));
                org.Clear();
                org.SendKeys(organization);

                var usr = wait.Until(ExpectedConditions.ElementIsVisible(txtUserName));
                usr.Clear();
                usr.SendKeys(username);

                var pw = wait.Until(ExpectedConditions.ElementIsVisible(txtPassword));
                pw.Clear();
                pw.SendKeys(pwd);

                var login = wait.Until(ExpectedConditions.ElementIsVisible((btnLogIn)));
                Actions action = new Actions(Driver.Instance);
                action.MoveToElement(login).Click().Perform();
                Driver.Wait(TimeSpan.FromMinutes(20));
                wait.Until(ExpectedConditions.ElementIsVisible(EIDSSHomePageLogo));
            }
        }
        public static string doesErrorAlertMessageDisplay()
        {
            try
            {
                string text = Driver.Instance.SwitchTo().Alert().Text;
                errorString = text;
            }
            catch
            {
                //Fails the test if error message does not display
                Assert.IsTrue(String.IsNullOrEmpty(errorString));
            }
            return errorString;
        }

        public static void acceptMessage()
        {
            IAlert alert = Driver.Instance.SwitchTo().Alert();
            alert.Accept();
        }

        public static void declineMessage()
        {
            IAlert alert = Driver.Instance.SwitchTo().Alert();
            alert.Dismiss();
        }

        private static void doesValidationErrorMessageDisplay(By element)
        {
            if (Driver.Instance.FindElement(element).Displayed && Driver.Instance.FindElements(element).Count > 0)
            {
                Driver.Wait(TimeSpan.FromMinutes(20));
                string text = wait.Until(ExpectedConditions.ElementIsVisible(element)).Text;
                errorString = text;
            }
            else
            {
                //Fails the test if error message does not display
                Assert.IsTrue(String.IsNullOrEmpty(errorString));
            }
        }

        private static void doesOrgValidationErrorMessageDisplay(By element)
        {
            if (Driver.Instance.FindElements(element).Count <= 0)
            {
                //Test passes for this case
                Assert.Pass();
            }
            else
            {
                Assert.Fail();
            }
        }

        public static void doesMissingOrgErrorMsgDisplay()
        {
            doesOrgValidationErrorMessageDisplay(errorOrgMsg);
        }

        public static string doesErrorDisplayForOrg()
        {
            try
            {
                //Had to refactor for error message ID, not popup alert
                Driver.Wait(TimeSpan.FromMinutes(20));
                var text = wait.Until(ExpectedConditions.ElementIsVisible(errorOrgMsg)).Text;
                Driver.Wait(TimeSpan.FromMinutes(20));
                errorString = text;
            }
            catch
            {
                //Fails the test if error message does not display
                Assert.IsTrue(String.IsNullOrEmpty(errorString));
            }
            return errorString;
        }

        public static string doesErrorDisplayForUserName()
        {
            try
            {
                //Had to refactor for error message ID, not popup alert
                var text = wait.Until(ExpectedConditions.ElementIsVisible(errorUserNameMsg)).Text;
                Driver.Wait(TimeSpan.FromMinutes(20));
                errorString = text;
            }
            catch
            {
                //Fails the test if error message does not display
                Assert.IsTrue(String.IsNullOrEmpty(errorString));
            }
            return errorString;
        }

        public static string doesErrorDisplayForPassword()
        {
            try
            {
                //Had to refactor for error message ID, not popup alert
                var text = wait.Until(ExpectedConditions.ElementIsVisible(errorPwdMsg)).Text;
                Driver.Wait(TimeSpan.FromMinutes(20));
                errorString = text;
            }
            catch
            {
                //Fails the test if error message does not display
                Assert.IsTrue(String.IsNullOrEmpty(errorString));
            }
            return errorString;
        }

        private static bool IsElementPresent(By by)
        {
            try
            {
                Driver.Instance.FindElement(by);
                return true;
            }
            catch (NoSuchElementException)
            {
                return false;
            }
        }
    }
}
