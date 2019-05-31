using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using System.Threading;
using EIDSS7Test.Common;
using NUnit.Framework;

namespace EIDSS7Test.Veterinary.VeterinaryAggregate
{
    public class SearchVetAggrDiseaseReportPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();
        public static String currentToDate;
        public static String currentFromDate;

        private static By titleFormTitle = By.TagName("h2");
        private static By vetAggrDisesesSection = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "hdgVAC']");
        private static By vetAggrSrchFormSection = By.Id(CommonCtrls.GeneralContent + "hdgSearchCriteria");
        private static By ddlTimeIntervalUnit = By.Id(CommonCtrls.GeneralContent + "ddlidfsTimeInterval");
        private static IList<IWebElement> timeIntervalOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsTimeInterval]/option")); } }
        private static By ddlAdminLevel = By.Id(CommonCtrls.GeneralContent + "ddlifdsSearchAdministrativeLevel");
        private static IList<IWebElement> adminLvlOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlifdsSearchAdministrativeLevel]/option")); } }
        private static By txtCaseID = By.Id(CommonCtrls.GeneralContent + "txtstrSearchCaseID");
        private static By datStartDate = By.Id(CommonCtrls.GeneralContent + "txtdatSearchStartDate");
        private static By datEndDate = By.Id(CommonCtrls.GeneralContent + "ttxtdatSearchStartDate");
        private static By ddlRegion = By.Id(CommonCtrls.LocationSrchContent + "ddllucSearchidfsRegion");
        private static IList<IWebElement> regionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationSrchContent + "ddllucSearchidfsRegion']/option")); } }
        private static By ddlRayon = By.Id(CommonCtrls.LocationSrchContent + "ddllucSearchidfsRayon");
        private static IList<IWebElement> rayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationSrchContent + "ddllucSearchidfsRayon']/option")); } }
        private static By ddlTownVillage = By.Id(CommonCtrls.LocationSrchContent + "ddllucSearchidfsSettlement");
        private static IList<IWebElement> townVillOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationSrchContent + "ddllucSearchidfsSettlement']/option")); } }
        private static By ddlOrganization = By.Id(CommonCtrls.GeneralContent + "ddlidfsOrganzation");
        private static IList<IWebElement> orgOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsOrganzation']/option")); } }
        private static By btnCancelSearch = By.Id(CommonCtrls.GeneralContent + "btnCancelSearch");
        private static By btnClear = By.Id(CommonCtrls.GeneralContent + "btnClear");
        private static By btnSearch = By.Id(CommonCtrls.GeneralContent + "btnSearch");
        private static By btnNewSearch = By.Id(CommonCtrls.GeneralContent + "btnNewSearch");
        private static By btnNewVAC = By.Id(CommonCtrls.GeneralContent + "btnNewVAC");


        public static bool IsAt
        {
            get
            {
                Driver.Instance.WaitForPageToLoad();
                if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                     || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                {
                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Page cannot be displayed");
                    return false;
                }
                else if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Error:"))
                {
                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                    return false;
                }
                else if (Driver.Instance.FindElements(titleFormTitle).Count > 0)
                {
                    {
                        Driver.Wait(TimeSpan.FromMinutes(45));
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Veterinary Aggregate Disease Report") &&
                            Driver.Instance.FindElement(titleFormTitle).Displayed)
                            return true;
                        else
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                }
                else
                {
                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Page cannot be displayed");
                    return false;
                }
            }
        }

        public class SearchCriteria
        {
            public static bool IsAtSection
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(vetAggrSrchFormSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(vetAggrSrchFormSection).Text.Contains("Search Criteria") &&
                                Driver.Instance.FindElement(vetAggrSrchFormSection).Displayed)
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

            public static void clickSearchBtn()
            {
                SetMethods.clickObjectButtons(btnSearch);
            }

            public static void clickClearBtn()
            {
                SetMethods.clickObjectButtons(btnClear);
            }

            public static void clickNewSearchBtn()
            {
                SetMethods.clickObjectButtons(btnNewSearch);
            }

            public static void clickNewVACBtn()
            {
                SetMethods.clickObjectButtons(btnNewVAC);
            }

            public static void clickCancelSrchBtn()
            {
                SetMethods.clickObjectButtons(btnCancelSearch);
            }

            public static void randomTimeInterval()
            {
                SetMethods.randomSelectObjectElement(ddlTimeIntervalUnit, timeIntervalOptions);
            }

            public static void randomSelectAdminLevel()
            {
                SetMethods.randomSelectObjectElement(ddlAdminLevel, adminLvlOptions);
            }

            public static void randomSelectRegion()
            {
                SetMethods.randomSelectObjectElement(ddlRegion, regionOptions);
            }

            public static void randomSelectRayon()
            {
                SetMethods.randomSelectObjectElement(ddlRayon, rayonOptions);
            }

            public static void randomSelectTownOrVillage()
            {
                SetMethods.randomSelectObjectElement(ddlTownVillage, townVillOptions);
            }

            public static void randomSelectOrganization()
            {
                SetMethods.randomSelectObjectElement(ddlOrganization, orgOptions);
            }

            public static void selectWeekTimeIntervalUnit()
            {
                SetMethods.enterObjectValue(ddlTimeIntervalUnit, "Week");
            }

            public static void selectYearTimeIntervalUnit()
            {
                SetMethods.enterObjectValue(ddlTimeIntervalUnit, "Year");
            }

            public static void selectMonthTimeIntervalUnit()
            {
                SetMethods.enterObjectValue(ddlTimeIntervalUnit, "Month");
            }

            public static void selectQuarterTimeIntervalUnit()
            {
                SetMethods.enterObjectValue(ddlTimeIntervalUnit, "Quarter");
            }

            public static void selectDayTimeIntervalUnit()
            {
                SetMethods.enterObjectValue(ddlTimeIntervalUnit, "Day");
            }

            public static void selectCountryAdminLevel()
            {
                SetMethods.enterObjectValue(ddlAdminLevel, "Country");
            }

            public static void selectRayonAdminLevel()
            {
                SetMethods.enterObjectValue(ddlAdminLevel, "Rayon");
            }

            public static void selectRegionAdminLevel()
            {
                SetMethods.enterObjectValue(ddlAdminLevel, "Region");
            }

            public static void enterVetAggrCaseID(string csID)
            {
                SetMethods.enterStringObjectValue(txtCaseID, csID);
            }

            public static void enterCaseStartDate()
            {
                SetMethods.enterCurrentDate(datStartDate);
            }

            public static void enterCaseEndDate()
            {
                SetMethods.enterCurrentDate(datEndDate);
            }
        }


        public class SearchForm
        {

        }


        public class VeterinaryAggrCasesResults
        {
            public static bool IsAt
            {
                get
                {
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(vetAggrDisesesSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(vetAggrDisesesSection).Text.Contains("Veterinary Aggregate Diseases") &&
                                Driver.Instance.FindElement(vetAggrDisesesSection).Displayed)
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