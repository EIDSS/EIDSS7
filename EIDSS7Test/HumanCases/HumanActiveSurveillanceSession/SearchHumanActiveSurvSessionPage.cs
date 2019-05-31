using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Threading;

namespace EIDSS7Test.HumanCases.HumanActiveSurveillanceSesson
{
    public class SearchHumanActiveSurvSessionPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();

        private static By titleFormTitle = By.TagName("h2");
        private static By btnCancel = By.XPath("//input[@class='btn btn-default']");
        private static By btnContinue = By.Id(CommonCtrls.GeneralContent + "btnNextSection");
        private static By btnBack = By.Id(CommonCtrls.GeneralContent + "btnPreviousSection");
        private static By btnClear = By.Id(CommonCtrls.GeneralContent + "btnClear");
        private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmit");
        private static By btnReturnToSearch = By.Id(CommonCtrls.GeneralContent + "btnReturntoSearchResults");
        private static By btnCreateSession = By.Id(CommonCtrls.GeneralContent + "btnCreateSession");
        private static By btnNewSearch = By.Id(CommonCtrls.GeneralContent + "btnNewSearch");
        private static By btnSearch = By.Id(CommonCtrls.GeneralContent + "btnSearch");
        //private static By btnPopupOK = By.XPath("//*[@class='btn btn-primary']");
        private static By btnPopupOK = By.XPath("//*[@id='EIDSSBodyCPH_errorSession']/div/div/div[3]/button");
        private static By lblErrorMsg = By.Id(CommonCtrls.GeneralContent + "lbl_Error");
        private static IList<IWebElement> btnEdits { get { return Driver.Instance.FindElements(By.XPath("//*[@class='glyphicon glyphicon-edit']")); } }
        private static By btnEdit = By.XPath("//*[@class='glyphicon glyphicon-edit']");
        private static By linkSessInfo = By.LinkText("Session Information");
        private static By linkSample = By.LinkText("Samples");
        private static By linkReview = By.LinkText("Review");
        public static String searchResultsValue;
        public static String searchResultsValue2;

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
                        Driver.Wait(TimeSpan.FromMinutes(15));
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Human Active Surveillance Session") &&
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

        public static void clickCancel()
        {
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clickContinue()
        {
            SetMethods.clickObjectButtons(btnContinue);
        }

        public static void clickBack()
        {
            SetMethods.clickObjectButtons(btnBack);
        }

        public static void clickClear()
        {
            SetMethods.clickObjectButtons(btnClear);
        }

        public static void clickSubmit()
        {
            SetMethods.clickObjectButtons(btnSubmit);
        }

        public static void clickCreateSession()
        {
            SetMethods.clickObjectButtons(btnCreateSession);
        }

        public static void clickSearch()
        {
            SetMethods.clickObjectButtons(btnSearch);
        }

        public static void clickPopupOK()
        {
            SetMethods.clickObjectButtons(btnPopupOK);
        }

        public static void clickEditRecord()
        {
            if (Driver.Instance.FindElement(lblErrorMsg).Displayed)
            {
                clickPopupOK();
            }
            else
            {
                SetMethods.clickObjectButtons(btnEdit);
            }
        }

        public static void doesRetrievingDataErrorMessageDisplay()
        {
            Thread.Sleep(3000);
            if (Driver.Instance.FindElement(lblErrorMsg).Displayed)
            {
                clickPopupOK();
            }
            else
            {
                Console.Write("No error message display.  Select record.");
            }
        }

        public static void clickNewSearch()
        {
            SetMethods.clickObjectButtons(btnNewSearch);
        }

        public static void clickSamplesLink()
        {
            SetMethods.clickObjectButtons(linkSample);
        }

        public static void clickSessionInfoLink()
        {
            SetMethods.clickObjectButtons(linkSessInfo);
        }

        public static void clickReviewLink()
        {
            SetMethods.clickObjectButtons(linkReview);
        }

        public class Search
        {
            private static By searchFormTitle = By.Id(CommonCtrls.GeneralContent + "hdgSearch");
            private static By txtSessionIDNumber = By.Id(CommonCtrls.GeneralContent + "txtMonitoringSessionstrID");
            private static By datStartDate = By.Id(CommonCtrls.GeneralContent + "txtMonitoringSessionDatEnteredFrom");
            private static By datEndDate = By.Id(CommonCtrls.GeneralContent + "txtMonitoringSessionDatEnteredTo");
            private static By ddlSessStatus = By.Id(CommonCtrls.GeneralContent + "ddlMonitoringSessionidfsStatus");
            private static IList<IWebElement> srchSessStatOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlMonitoringSessionidfsStatus']/option")); } }
            private static By ddlSessDisease = By.Id(CommonCtrls.GeneralContent + "ddlMonitoringSessionidfsDiagnosis");
            private static IList<IWebElement> sessDisOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlMonitoringSessionidfsDiagnosis']/option")); } }
            private static By ddlRegion = By.Id(CommonCtrls.SrchMonitorSessLocContent + "ddlMonitoringSessionidfsDiagnosis");
            private static IList<IWebElement> regionOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SrchMonitorSessLocContent + "ddlMonitoringSessionidfsRegion']/option")); } }
            private static By ddlRayon = By.Id(CommonCtrls.SrchMonitorSessLocContent + "dddlMonitoringSessionidfsRayon");
            private static IList<IWebElement> rayonOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SrchMonitorSessLocContent + "ddlMonitoringSessionidfsRayon']/option")); } }

            public static bool IsAt
            {
                get
                {
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(searchFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(searchFormTitle).Text.Contains("Search") &&
                                Driver.Instance.FindElement(searchFormTitle).Displayed)
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

            public static void enterSessionIDNumber(string value)
            {
                SetMethods.enterObjectValue(txtSessionIDNumber, value);
            }

            public static void selectSessionStatus(string value)
            {
                SetMethods.enterObjectValue(ddlSessStatus, value);
            }

            public static void selectSessionDisease(string value)
            {
                SetMethods.enterObjectValue(ddlSessDisease, value);
            }

            public static void enterFromDate()
            {
                SetMethods.enterCurrentDate(datStartDate);
            }

            public static void enterToDate()
            {
                SetMethods.enterCurrentDate(datEndDate);
            }

            public static void enterRegion(string value)
            {
                SetMethods.enterObjectValue(ddlRegion, value);
            }

            public static void enterRayon(string value)
            {
                SetMethods.enterObjectValue(ddlRayon, value);
            }

            public static void randomSelectRegion()
            {
                SetMethods.randomSelectObjectElement(ddlRegion, regionOpts);
            }

            public static void randomSelectRayon()
            {
                SetMethods.randomSelectObjectElement(ddlRayon, rayonOpts);
            }

        }

        public class SearchCriteria
        {
            private static By srchCriteriaFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "hdgSearchCriteria']");
            private static By txtSessionIDNum = By.Id(CommonCtrls.GeneralContent + "txtMonitoringSessionstrID");
            private static By txtCampaignIDNum = By.Id(CommonCtrls.GeneralContent + "txtMonitoringSessionstrCampaignID");
            private static By ddlSessionStatus = By.Id(CommonCtrls.GeneralContent + "ddlMonitoringSessionidfsStatus");
            private static By ddlDisease = By.Id(CommonCtrls.GeneralContent + "ddlMonitoringSessionidfsDiagnosis");
            private static By datDateEnteredFrom = By.Id(CommonCtrls.GeneralContent + "txtMonitoringSessionDatEnteredFrom");
            private static By datDateEnteredTo = By.Id(CommonCtrls.GeneralContent + "txtMonitoringSessionDatEnteredTo");
            private static By ddlRegion = By.Id(CommonCtrls.SrchMonitorSessLocContent + "ddlMonitoringSessionidfsRegion");
            private static By ddlRayon = By.Id(CommonCtrls.SrchMonitorSessLocContent + "ddlMonitoringSessionidfsRayon");
            private static By btnExpandIcon = By.Id(CommonCtrls.GeneralContent + "btnShowSearchCriteria");

            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(srchCriteriaFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(srchCriteriaFormTitle).Text.Contains("Search Criteria") &&
                                Driver.Instance.FindElement(srchCriteriaFormTitle).Displayed)
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

            public static void clickExpandIcon()
            {
                SetMethods.clickObjectButtons(btnExpandIcon);
            }

            public static void enterSrchSessionIDNumber(string value)
            {
                SetMethods.enterObjectValue(txtSessionIDNum, value);
                Thread.Sleep(1000);
            }

            public static void enterSrchCampaignIDNumber(string value)
            {
                SetMethods.enterObjectValue(txtCampaignIDNum, value);
            }

            public static void enterSrchSessionStatus(string value)
            {
                SetMethods.enterObjectValue(ddlSessionStatus, value);
            }

            public static void enterSrchDisease(string value)
            {
                Thread.Sleep(1000);
                SetMethods.enterObjectValue(ddlDisease, value);
            }

            public static void clearDateFromField()
            {
                SetMethods.clearField(datDateEnteredFrom);
            }

            public static void enterSrchDateFrom(string val)
            {
                SetMethods.enterObjectValue(datDateEnteredFrom, val);
            }

            public static void clearDateToField()
            {
                SetMethods.clearField(datDateEnteredTo);
            }

            public static void enterSrchDateTo(string val)
            {
                SetMethods.enterObjectValue(datDateEnteredTo, val);
            }

            public static void enterSrchDateTo()
            {
                SetMethods.enterCurrentDate(datDateEnteredTo);
            }

            public static void clearRegionField()
            {
                SetMethods.clearDropdownList(ddlRegion);
                Thread.Sleep(2000);
            }

            public static void enterSrchRegion(string value)
            {
                Driver.Instance.FindElement(txtSessionIDNum).SendKeys(Keys.Tab);
                SetMethods.enterObjectValue(ddlRegion, value);
            }

            public static void clearRayonField()
            {
                SetMethods.clearDropdownList(ddlRayon);
            }

            public static void enterSrchRayon(string value)
            {
                Driver.Instance.FindElement(txtSessionIDNum).SendKeys(Keys.Tab);
                SetMethods.enterObjectValue(ddlRayon, value);
            }
        }

        public class SearchResults
        {
            private static By srchResultsFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "searchResults']/div/div[1]/div/div/h3");
            private static IList<IWebElement> linkSessionIDs { get { return Driver.Instance.FindElements(By.XPath("/html/body/form/div[3]/div/div[2]/div/div[1]/div[5]/div[2]/div/div[2]/div/div[2]/div/div/table/tbody/tr/td[1]/a")); } }
            private static By tlbSearchResults = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvSearchResults']/tbody");

            public static bool IsAt
            {
                get
                {
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(srchResultsFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(srchResultsFormTitle).Text.Contains("Search Results") &&
                                Driver.Instance.FindElement(srchResultsFormTitle).Displayed)
                                return true;
                            else
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

            public static void randomSelectSessionRecord()
            {
                IList<IWebElement> links = linkSessionIDs;
                Driver.Wait(TimeSpan.FromMinutes(1000));
                if (links == null || links.Count == 0)
                {
                    Assert.Fail("Query did not return any records.");
                }
                else
                {
                    SetMethods.SelectRandomOptionFromDropdown(links);
                }
            }

            public static void randomEditSessionRecord()
            {
                SetMethods.randomSelectObjectElement(tlbSearchResults, btnEdits);
            }

            public static void getSearchResultsValue(String value)
            {
                try
                {
                    IWebElement table = Driver.Instance.FindElement(tlbSearchResults);
                    IList<IWebElement> rows = table.FindElements(By.TagName("tr"));
                    foreach (var row in rows)
                    {
                        IList<IWebElement> cols = Driver.Instance.FindElements(By.TagName("td"));
                        foreach (var col in cols)
                        {
                            if (col.Text.Contains(value))
                            {
                                searchResultsValue = col.Text;
                                break;
                            }
                        }
                    }
                }
                catch
                {
                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail(value + " does not exist in the table.");
                }
            }

            public static void getSearchResultsValue2(String value)
            {
                try
                {
                    IWebElement table = Driver.Instance.FindElement(tlbSearchResults);
                    IList<IWebElement> rows = table.FindElements(By.TagName("tr"));
                    foreach (var row in rows)
                    {
                        IList<IWebElement> cols = Driver.Instance.FindElements(By.TagName("td"));
                        foreach (var col in cols)
                        {
                            if (col.Text.Contains(value))
                            {
                                searchResultsValue = col.Text;
                                break;
                            }
                        }
                    }
                }
                catch
                {
                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail(value + " does not exist in the table.");
                }
            }
        }
    }
}