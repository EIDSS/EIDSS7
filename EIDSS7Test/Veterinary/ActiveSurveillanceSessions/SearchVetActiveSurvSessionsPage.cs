using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using System.Threading;
using EIDSS7Test.Common;
using NUnit.Framework;


namespace EIDSS7Test.Veterinary.ActiveSurveillanceSessions
{
    public class SearchActiveSurvSessionsPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(2));
        private static Random rnd = new Random();
        public static String sessionID;
        public static String sampleID;

        private static By HeaderFormTitle = By.TagName("h1");
        private static By titleFormTitle = By.TagName("h2");
        private static By activeSearchSection = By.Id(CommonCtrls.GeneralContent + "hdgSearchParameters");
        private static By lblSessionID = By.Name("Session ID");
        private static By txtSearchSessionID = By.Id(CommonCtrls.GeneralContent + "txtSearchSessionID");
        private static By txtFieldSampleID = By.Id(CommonCtrls.GeneralContent + "txtSearchFieldSampleID");
        private static By ddlSearchSessionStatus = By.Id(CommonCtrls.GeneralContent + "ddlSearchSessionStatus");
        private static IList<IWebElement> sessionStatOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSearchSessionStatus']/option")); } }
        private static By ddlSearchSessionDisease = By.Id(CommonCtrls.GeneralContent + "ddlSearchSessionDisease");
        private static IList<IWebElement> sessionDiseaseOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSearchSessionDisease']/option")); } }
        private static By ddlSearchRegion = By.Id(CommonCtrls.SearchLocContent + "ddlidfsRegion");
        private static IList<IWebElement> searchRegionOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchLocContent + "ddlidfsRegion']/option")); } }
        private static By ddlSearchRayon = By.Id(CommonCtrls.SearchLocContent + "ddlidfsRayon");
        private static IList<IWebElement> searchRayonOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchLocContent + "ddlidfsRayon']/option")); } }
        private static By ddlSearchTownOrVillage = By.Id(CommonCtrls.SearchLocContent + "ddlidfsSettlement");
        private static IList<IWebElement> searchTownOrVillageOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchLocContent + "ddlidfsSettlement']/option")); } }
        private static By datSearchStartDateFrom = By.Id(CommonCtrls.GeneralContent + "txtSearchStartDateFrom");
        private static By datSearchStartDateTo = By.Id(CommonCtrls.GeneralContent + "txtSearchStartDateTo");
        private static By datSearchEndDateFrom = By.Id(CommonCtrls.GeneralContent + "txtSearchEndDateFrom");
        private static By datSearchEndDateTo = By.Id(CommonCtrls.GeneralContent + "txtSearchEndDateTo");
        private static By datSearchDateEnteredFrom = By.Id(CommonCtrls.GeneralContent + "txtSearchDateEnteredFrom");
        private static By datSearchDateEnteredTo = By.Id(CommonCtrls.GeneralContent + "txtSearchDateEnteredTo");
        private static By ddlSearchEnteredBy = By.Id(CommonCtrls.GeneralContent + "ddlSearchEnteredBy");
        private static IList<IWebElement> searchEnterByOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSearchEnteredBy']/option")); } }
        private static By txtSearchCampaignID = By.Id(CommonCtrls.GeneralContent + "txtSearchCampaignID");
        private static By txtSearchCampaignName = By.Id(CommonCtrls.GeneralContent + "txtSearchCampaignName");
        private static By ddlSearchCampaignType = By.Id(CommonCtrls.GeneralContent + "ddlSearchCampaignType");
        private static IList<IWebElement> searchCampaignTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSearchCampaignType']/option")); } }
        private static By ddlSearchDataEntrySite = By.Id(CommonCtrls.GeneralContent + "ddlSearchDataEntrySite");
        private static IList<IWebElement> searchDataEntryOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSearchDataEntrySite']/option")); } }
        private static By tlbResultsTable = By.Id(CommonCtrls.GeneralContent + "gvSessionsList");
        private static IList<IWebElement> tblRows { get { return Driver.Instance.FindElements(By.TagName("tr")); } }
        private static IList<IWebElement> tblColumns { get { return Driver.Instance.FindElements(By.TagName("td")); } }
        private static By btnReturnToDash = By.LinkText("Return to Dashboard");
        private static By btnClear = By.Id(CommonCtrls.GeneralContent + "btnClearSearchContainer");
        private static By btnSearch = By.Id(CommonCtrls.GeneralContent + "btnSearch");
        private static By btnEditSearch = By.Id(CommonCtrls.GeneralContent + "btnEditSearchCriteria");
        private static By btnNewSession = By.Id(CommonCtrls.GeneralContent + "btnNewSession");
        private static By btnNewSearch = By.Id(CommonCtrls.GeneralContent + "btnNewSearch");


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
                            if (Driver.Instance.FindElement(activeSearchSection).Text.Contains("Search Criteria") &&
                                Driver.Instance.FindElement(activeSearchSection).Displayed)
                                return true;
                            else
                                //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                            return false;
                        }
                    }
                    else if (Driver.Instance.FindElement(HeaderFormTitle).Displayed ||
                        Driver.Instance.FindElement(HeaderFormTitle).Text.Contains("This page isn't working"))
                    {
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
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
                    Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again." + e.Message);
                    return false;
                }
            }
        }

        public static void clearSessStartDateFrom()
        {
            SetMethods.clearField(datSearchStartDateFrom);
        }

        public static void clearSessStartDateTo()
        {
            SetMethods.clearField(datSearchStartDateTo);
        }

        public static void clickSearch()
        {
            SetMethods.clickObjectButtons(btnSearch);
        }

        public static void clickNewSession()
        {
            SetMethods.clickObjectButtons(btnNewSession);
        }

        public static void clickClear()
        {
            SetMethods.clickObjectButtons(btnClear);
        }

        public static void clickReturnToDashboard()
        {
            SetMethods.clickObjectButtons(btnReturnToDash);
        }

        public static String enterSessionID(String session)
        {
            SetMethods.enterStringObjectValue(txtSearchSessionID, session);
            return sessionID = session;
        }

        public static void clearSessionIDField()
        {
            SetMethods.clearField(txtSearchSessionID);
        }


        public static String enterRandomFieldSampleID(String session)
        {
            SetMethods.enterStringObjectValue(txtFieldSampleID, session);
            return sessionID = session;
        }

        public static String enterFieldSessionID(String sessID)
        {
            SetMethods.enterStringObjectValue(txtFieldSampleID, sessID);
            return sessID;
        }

        public static void selectOpenStatus()
        {
            SetMethods.selectObjectFromDropdownList(ddlSearchSessionStatus, sessionStatOpts, "Open");
        }



        public static void selectClosedStatus()
        {
            SetMethods.selectObjectFromDropdownList(ddlSearchSessionStatus, sessionStatOpts, "Closed");
        }

        public static void randomSelectSessionDisease()
        {
            SetMethods.randomSelectObjectElement(ddlSearchSessionDisease, sessionDiseaseOpts);
        }

        public static void randomSelectRegion()
        {
            SetMethods.randomSelectObjectElement(ddlSearchRegion, searchRegionOpts);
        }

        public static Boolean isFieldEnabled(By element)
        {
            try
            {
                var rayon = wait.Until(ExpectedConditions.ElementIsVisible(element));
                rayon.GetAttribute("enabled");
                return true;
            }
            catch (Exception)
            {
                Console.WriteLine("Field is not enabled");
                return false;
            }
        }

        public static void randomSelectRayon()
        {
            SetMethods.randomSelectObjectElement(ddlSearchRayon, searchRayonOpts);
        }

        public static void randomSelectTownOrVillage()
        {
            SetMethods.randomSelectObjectElement(ddlSearchTownOrVillage, searchTownOrVillageOpts);
        }


        public static void enterStartDateFrom()
        {
            SetMethods.enterCurrentDate(datSearchStartDateFrom);
        }

        public static void enterStartDateTo()
        {
            SetMethods.enterCurrentDate(datSearchStartDateTo);
        }


        public static void enterEndDateFrom()
        {
            SetMethods.enterCurrentDate(datSearchEndDateFrom);
        }

        public static void enterEndDateTo()
        {
            SetMethods.enterCurrentDate(datSearchEndDateTo);
        }


        public static void enterDateEnteredFrom()
        {
            SetMethods.enterCurrentDate(datSearchDateEnteredFrom);
        }

        public static void enterDateEnteredTo()
        {
            SetMethods.enterCurrentDate(datSearchDateEnteredTo);
        }

        public static void randomSelectEnteredBy()
        {
            SetMethods.randomSelectObjectElement(ddlSearchEnteredBy, searchEnterByOpts);
        }

        public static String randomEnterCampaignID(String session)
        {
            SetMethods.enterStringObjectValue(txtSearchCampaignID, session);
            return sessionID = session;
        }

        public static String randomEnterCampaignName(String session)
        {
            SetMethods.enterStringObjectValue(txtSearchCampaignName, session);
            return sessionID = session;
        }

        public static void randomSelectCampaignType()
        {
            SetMethods.randomSelectObjectElement(ddlSearchCampaignType, searchCampaignTypeOpts);
        }

        public static void randomSelectDataEntrySite()
        {
            SetMethods.randomSelectObjectElement(ddlSearchDataEntrySite, searchDataEntryOpts);
        }

        public static void doesActiveSurvSessionDisplayInList()
        {
            if (tblColumns.Count > 0)
            {
                foreach (IWebElement col in tblColumns)
                {
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    if (col.Text.Contains(CreateVetActiveSurvSessionPage.fieldSessionID))
                    {
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        CreateVetActiveSurvSessionPage.fieldSessionID = col.Text;
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        break;
                    }
                }
            }
            else
            {
                //Fails test if name does not display in list
                Assert.IsFalse(String.IsNullOrEmpty(CreateVetActiveSurvSessionPage.fieldSessionID));
            }
        }

        public static void doesModifiedRecordDisplayInList(String Element)
        {
            if (tblColumns.Count > 0)
            {
                foreach (IWebElement col in tblColumns)
                {
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    if (col.Text.Contains(Element))
                    {
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        CreateVetActiveSurvSessionPage.fieldSessionID = col.Text;
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        break;
                    }
                }
            }
            else
            {
                //Fails test if name does not display in list
                Assert.IsFalse(String.IsNullOrEmpty(Element));
            }
        }

        public class SearchResults
        {
            private static By activeSurvResultsSection = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "divResultsContainer']/div[1]/div[1]/div/div[1]/h3");
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
                    else if (Driver.Instance.FindElements(activeSurvResultsSection).Count > 0)
                    {
                        if (Driver.Instance.FindElement(activeSurvResultsSection).Text.Contains("Search Results") &&
                            Driver.Instance.FindElement(activeSurvResultsSection).Displayed)
                            return true;
                        else
                            return false;
                    }
                    else
                    {
                        return false;
                    }
                }
            }

            public static bool IsElementDisplayedInList(string element)
            {
                try
                {
                    IList<IWebElement> rows = Driver.Instance.FindElements(By.TagName("tr"));
                    Driver.Wait(TimeSpan.FromMinutes(5));
                    foreach (var row in rows)
                    {
                        IList<IWebElement> cols = row.FindElements(By.TagName("td"));
                        foreach (var col in cols)
                        {
                            if (col.Text.Contains(element))
                            {
                                return true;
                            }
                            break;
                        }
                        break;
                    }
                }
                catch (NoSuchElementException)
                {
                    return false;
                }
                return false;
            }
        }
    }
}