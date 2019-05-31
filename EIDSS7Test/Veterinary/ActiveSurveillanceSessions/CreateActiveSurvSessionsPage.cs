using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;


namespace EIDSS7Test.Veterinary.ActiveSurveillanceSessions
{
    public class CreateVetActiveSurvSessionPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();
        public static string fieldSessionID;

        private static By titleFormTitle = By.TagName("h2");
        private static By subtitleFormTitle = By.TagName("h3");
        private static By lblSessionID = By.Name("Session ID");
        private static By readOnlytxtSessionID = By.Id(CommonCtrls.GeneralContent + "txtSessionID");
        private static By ddlSessionStatus = By.Id(CommonCtrls.GeneralContent + "ddlSessionStatus");
        private static IList<IWebElement> statusOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSessionStatus']/option")); } }
        private static By datStartDate = By.Id(CommonCtrls.GeneralContent + "txtSetMonitoringSessiondatStartDate");
        private static By datEndDate = By.Id(CommonCtrls.GeneralContent + "txtSetMonitoringSessiondatEndDate");
        private static By readOnlyCampaignID = By.Id(CommonCtrls.GeneralContent + "txtCampaignID");
        private static By readOnlyCampaignName = By.Id(CommonCtrls.GeneralContent + "txtCampaignName");
        private static By readOnlyCampaignType = By.Id(CommonCtrls.GeneralContent + "txtCampaignType");
        private static By ddlSite = By.Id(CommonCtrls.GeneralContent + "ddlSessionSetSite");
        private static IList<IWebElement> siteOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddressContent + "ddlSessionSetSite']/option")); } }
        private static By ddlOfficer = By.Id(CommonCtrls.GeneralContent + "ddlSetMonitoringSessionidfPersonEnteredBy");
        private static IList<IWebElement> officerOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddressContent + "ddlSetMonitoringSessionidfPersonEnteredBy']/option")); } }
        private static By ddlDisease = By.Id(CommonCtrls.AddressContent + "ddlidfsDiagnosis");
        private static IList<IWebElement> diseaseOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddressContent + "ddlidfsDiagnosis']/option")); } }
        private static By ddlCountry = By.Id(CommonCtrls.MonitorSessionContent + "ddlSetMonitoringSessionidfsCountry");
        private static IList<IWebElement> searchCountryOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.MonitorSessionContent + "ddlSetMonitoringSessionidfsCountry']/option")); } }
        private static By ddlRegion = By.Id(CommonCtrls.MonitorSessionContent + "ddlSetMonitoringSessionidfsRegion");
        private static IList<IWebElement> regionOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.MonitorSessionContent + "ddlSetMonitoringSessionidfsRegion']/option")); } }
        private static By ddlRayon = By.Id(CommonCtrls.MonitorSessionContent + "ddlSetMonitoringSessionidfsRayon");
        private static IList<IWebElement> rayonOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.MonitorSessionContent + "ddlSetMonitoringSessionidfsRayon']/option")); } }
        private static By ddlTownOrVillage = By.Id(CommonCtrls.MonitorSessionContent + "ddlSetMonitoringSessionidfsSettlement");
        private static IList<IWebElement> townOrVillageOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.MonitorSessionContent + "ddlSetMonitoringSessionidfsSettlement']/option")); } }
        public static String campaignNM;
        public static String campaignAD;
        public static String campID;
        public static String diagnosis;
        public static String currentDate;

        public static bool IsAt
        {
            get
            {
                if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                     || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Page cannot be displayed");
                    return false;
                }
                else if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Error:"))
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                    return false;
                }
                else if (Driver.Instance.FindElements(titleFormTitle).Count > 0)
                {
                    {
                        Driver.Wait(TimeSpan.FromMinutes(15));
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Active Surveillance Sessions") &&
                            Driver.Instance.FindElement(titleFormTitle).Displayed)
                            return true;
                        else
                            Assert.Fail("This is not the correct title");
                        return false;
                    }
                }
                else
                {
                    return false;
                }
            }
        }


        public static void enterSessionStartDate()
        {
            SetMethods.enterCurrentDate(datStartDate);
        }

        public static void enterCampaignIncorrectEndDate()
        {
            string curDate = DateTime.Today.AddDays(-5).ToString("MM/dd/yyyy");
            var element = wait.Until(ExpectedConditions.ElementIsVisible(datEndDate));
            element.EnterText(curDate);
            Driver.Wait(TimeSpan.FromMinutes(10));
            currentDate = curDate;
        }

        public static void enterSessionEndDate()
        {
            SetMethods.enterCurrentDate(datEndDate);
        }

        public static void enterSessionEnteredDate()
        {
            SetMethods.enterCurrentDate(datStartDate);
        }

        public static void enterEnteredByOfficer(string person)
        {
            SetMethods.enterObjectValue(ddlOfficer, person);
        }

        public static void randomSelectOfficer()
        {
            SetMethods.randomSelectObjectElement(ddlOfficer, officerOpts);
        }

        public static void randomSelectDisease()
        {
            SetMethods.randomSelectObjectElement(ddlDisease, diseaseOpts);
        }

        public static void randomSelectRegion()
        {
            SetMethods.randomSelectObjectElement(ddlRegion, regionOpts);
        }

        public static void randomSelectRayon()
        {
            SetMethods.randomSelectObjectElement(ddlRayon, rayonOpts);
        }

        public static void randomSelectTownOrVillage()
        {
            SetMethods.randomSelectObjectElement(ddlTownOrVillage, townOrVillageOpts);
        }


        public class SessionInformation
        {
            private static By activeSessInfoSection = By.Id(CommonCtrls.GeneralContent + "H1");

            public static bool IsAt
            {
                get
                {
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(activeSessInfoSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(activeSessInfoSection).Text.Contains("Session Information") &&
                                Driver.Instance.FindElement(activeSessInfoSection).Displayed)
                                return true;
                            else
                                Assert.Fail("This is not the correct title");
                            return false;
                        }
                    }
                    else
                    {
                        return false;
                    }
                }
            }
        }


        public class SessionLocation
        {
            private static By activeSessLocSection = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "upSessionInformation']/div[1]/div[1]/div/div[1]/h3");
            public static bool IsAt
            {
                get
                {
                    //Scroll 1/2 way to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 250)", "");
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("The resource cannot be found"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(activeSessLocSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(activeSessLocSection).Text.Contains("Session Location") &&
                                Driver.Instance.FindElement(activeSessLocSection).Displayed)
                                return true;
                            else
                                Assert.Fail("This is not the correct title");
                            return false;
                        }
                    }
                    else
                    {
                        return false;
                    }
                }
            }
        }

        public class DiseaseAndSpecies
        {
            private static By activeSpeciesAndSampSection = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "upSessionInformation']/div[2]/div[1]/div[1]/div[1]/h3");
            public static bool IsAt
            {
                get
                {
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 500)", "");
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("The resource cannot be found"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(activeSpeciesAndSampSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(activeSpeciesAndSampSection).Text.Contains("Diseases and Species List") &&
                                Driver.Instance.FindElement(activeSpeciesAndSampSection).Displayed)
                                return true;
                            else
                                Assert.Fail("This is not the correct title");
                            return false;
                        }
                    }
                    else
                    {
                        return false;
                    }
                }
            }
        }
    }
}
