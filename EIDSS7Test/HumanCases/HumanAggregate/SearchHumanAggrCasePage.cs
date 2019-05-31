using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;

namespace EIDSS7Test.HumanCases.HumanAggregate
{
    public class SearchHumanAggrCasePage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();
        private static String eidssCaseID;

        private static By titleFormTitle = By.TagName("h2");
        private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "hdgHAC']");
        private static By txtSearchReportID = By.Id(CommonCtrls.GeneralContent + "txtstrSearchCaseID");
        private static By ddlTimeInterUnit = By.Id(CommonCtrls.GeneralContent + "ddlidfsTimeInterval");
        private static IList<IWebElement> timeInterUnitOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsTimeInterval']/option")); } }
        private static By datSearchStartDate = By.Id(CommonCtrls.GeneralContent + "txtdatSearchStartDate");
        private static By datSearchEndDate = By.Id(CommonCtrls.GeneralContent + "txtdatSearchEndDate");
        private static By ddlAdminLevel = By.Id(CommonCtrls.GeneralContent + "ddlifdsSearchAdministrativeLevel");
        private static IList<IWebElement> adminLevelOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlifdsSearchAdministrativeLevel']/option")); } }
        private static By ddlSearchRegion = By.Id(CommonCtrls.LocationSrchContent + "ddllucSearchidfsRegion");
        private static IList<IWebElement> searchRegionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationSrchContent + "ddllucSearchidfsRegion']/option")); } }
        private static By ddlSearchRayon = By.Id(CommonCtrls.LocationSrchContent + "ddllucSearchidfsRayon");
        private static IList<IWebElement> searchRayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationSrchContent + "ddllucSearchidfsRayon']/option")); } }
        private static By ddlSearchSettle = By.Id(CommonCtrls.LocationSrchContent + "ddllucSearchidfsSettlement");
        private static IList<IWebElement> searchSettleOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationSrchContent + "ddllucSearchidfsSettlement']/option")); } }
        private static By ddlSearchOrgs = By.Id(CommonCtrls.LocationSrchContent + "ddlidfsOrganzation");
        private static IList<IWebElement> searchOrgOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationSrchContent + "ddlidfsOrganzation']/option")); } }
        private static By btnSearch = By.Id(CommonCtrls.GeneralContent + "btnSearch");
        private static By ckBoxEnteredByUser = By.Id(CommonCtrls.GeneralContent + "enteredbyuser");
        private static By ddlNotifyRecvdByInstit = By.Id(CommonCtrls.GeneralContent + "ddlidfsOrgNotiRecd");
        private static IList<IWebElement> srchNotifyRecvdByInstOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsOrgNotiRecd']/option")); } }
        private static By ddlEnteredByInstit = By.Id(CommonCtrls.GeneralContent + "ddlidfsOrgNotiRecd");
        private static IList<IWebElement> srchEnteredByInstOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsOrgNotiRecd']/option")); } }
        private static By datNotifyRecvdByDate = By.Id(CommonCtrls.GeneralContent + "ddlstrOperatorNotiSentByDate");
        private static By datEnteredByDate = By.Id(CommonCtrls.GeneralContent + "ddldatEnteredByDate");
        private static By btnReturnToDashboard = By.LinkText("Return to Dashboard");
        private static By btnClear = By.Id(CommonCtrls.GeneralContent + "btnClear");
        private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancel");
        private static By btnNewHAC = By.Id(CommonCtrls.GeneralContent + "btnNewHAC");

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
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Human Aggregate Disease") &&
                            Driver.Instance.FindElement(titleFormTitle).Displayed)
                            return true;
                        else
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("This is not the correct title");
                        return false;
                    }
                }
                else
                {
                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    return false;
                }
            }
        }

        public static void clickSearch()
        {
            SetMethods.clickObjectButtons(btnSearch);
        }

        public static void clickClear()
        {
            SetMethods.clickObjectButtons(btnClear);
        }

        public static void clickReturnToDash()
        {
            SetMethods.clickObjectButtons(btnReturnToDashboard);
        }

        public static void clickCancel()
        {
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clickNewHAC()
        {
            SetMethods.clickObjectButtons(btnNewHAC);
        }

        public static void clearField(By element)
        {
            var clear = wait.Until(ExpectedConditions.ElementIsVisible(element));
            clear.Clear();
            Driver.Wait(TimeSpan.FromMinutes(5));
        }

        private static bool doesDefaultValueDisplay(By element, string val)
        {
            var value = Driver.Instance.FindElement(element).Text;
            if (value.Contains(val))
            {
                return true;
            }
            else
            {
                //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail("Default element does not display");
                return false;
            }
        }

        public static void doesMonthInteralUnitDisplayAsDefault()
        {
            doesDefaultValueDisplay(ddlTimeInterUnit, "Month");
        }

        public class SearchResults
        {
            private static By subtitleFormTitle = By.Id(CommonCtrls.GeneralContent + "hdgHAC");

            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") ||
                        Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Search Results") &&
                                Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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


            public static String enterCaseID(string element)
            {
                SetMethods.enterStringObjectValue(txtSearchReportID, element);
                return eidssCaseID;
            }

            public static void randomSelectTimeIntervalUnit()
            {
                SetMethods.randomSelectObjectElement(ddlTimeInterUnit, timeInterUnitOpts);
            }

            public static void enterSearchStartDate()
            {
                SetMethods.enterCurrentDate(datSearchStartDate);
            }

            public static void enterSearchEndDate()
            {
                SetMethods.enterCurrentDate(datSearchEndDate);
            }

            public static void randomSelectAdminLevel()
            {
                SetMethods.randomSelectObjectElement(ddlAdminLevel, adminLevelOpts);
            }

            public static void randomSelectSearchRegion()
            {
                SetMethods.randomSelectObjectElement(ddlSearchRegion, searchRegionOptions);
            }

            public static void randomSelectSearchRayon()
            {
                SetMethods.randomSelectObjectElement(ddlSearchRayon, searchRayonOptions);
            }

            public static void randomSelectSearchTownOrVillage()
            {
                SetMethods.randomSelectObjectElement(ddlSearchSettle, searchSettleOpts);
            }

            public static void randomSelectSearchOrganizations()
            {
                SetMethods.randomSelectObjectElement(ddlSearchOrgs, searchOrgOpts);
            }

            public static void enterEnteredByDate()
            {
                SetMethods.enterCurrentDate(datEnteredByDate);
            }
        }

        public class HumanAggregateDisease
        {
            private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "hdgHAC']");
            public static bool IsAt
            {
                get
                {
                    try
                    {
                        Driver.Instance.WaitForPageToLoad();
                        if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                             || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                        {
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("Page cannot be displayed");
                            return false;
                        }
                        else if (Driver.Instance.FindElements(titleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Human Aggregate Disease") &&
                                    Driver.Instance.FindElement(titleFormTitle).Displayed)
                                    return true;
                                else
                                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                    Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                                return false;
                            }
                        }
                        else
                        {
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                            return false;
                        }
                    }
                    catch (NoSuchElementException e)
                    {
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
                    }
                }
            }
        }
    }
}