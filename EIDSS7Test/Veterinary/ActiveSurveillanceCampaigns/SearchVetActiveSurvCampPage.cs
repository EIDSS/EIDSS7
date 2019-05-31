using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using System.Threading;
using EIDSS7Test.Common;
using EIDSS7Test.Reports;
using NUnit.Framework;

namespace EIDSS7Test.Veterinary.ActiveSurveillanceCampaigns
{
    public class SearchVetActiveSurvCampPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();

        private static By HeaderFormTitle = By.TagName("h1");
        private static By titleFormTitle = By.TagName("h2");
        private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "hdgSearch']");
        private static By btnReturnToDashboard = By.LinkText("Return to Dashboard");
        private static By btnSearch = By.Id(CommonCtrls.GeneralContent + "btnSearch");
        private static By btnEditSearch = By.Id(CommonCtrls.GeneralContent + "btnEditSearch");
        private static By btnNewSearch = By.Id(CommonCtrls.GeneralContent + "btnNewSearch");
        private static By btnNewCampaign = By.Id(CommonCtrls.GeneralContent + "btnAddCampaign");
        private static By btnClear = By.Id(CommonCtrls.GeneralContent + "btnClear");


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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Veterinary Active Surveillance Campaign") &&
                                Driver.Instance.FindElement(titleFormTitle).Displayed)
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
                    Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
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

        public static void clickReturnToDashboard()
        {
            SetMethods.clickObjectButtons(btnReturnToDashboard);
        }

        public static void clickNewSearch()
        {
            SetMethods.clickObjectButtons(btnNewSearch);
        }

        public static void clickNewCampaign()
        {
            SetMethods.clickObjectButtons(btnNewCampaign);
        }

        public static void clickEditSearch()
        {
            SetMethods.clickObjectButtons(btnEditSearch);
        }

        public class SearchCriteria
        {
            private static By subtitleFormTitle = By.Id(CommonCtrls.GeneralContent + "hdgSearchCriteria");
            private static By txtCampaignID = By.Id(CommonCtrls.GeneralContent + "txtCampaignStrIDFilter");
            private static By txtCampaignName = By.Id(CommonCtrls.GeneralContent + "txtCampaignNameFilter");
            private static By ddlCampaignType = By.Id(CommonCtrls.GeneralContent + "ddlCampaignTypedFilter");
            private static IList<IWebElement> typeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlCampaignTypedFilter']/option")); } }
            private static By ddlCampaignStatus = By.Id(CommonCtrls.GeneralContent + "ddlCampaignStatusFilter");
            private static IList<IWebElement> statusOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlCampaignStatusFilter']/option")); } }
            private static By ddlCampaignDisease = By.Id(CommonCtrls.GeneralContent + "ddlCampaignDiseaseFilter");
            private static IList<IWebElement> diseaseOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlCampaignDiseaseFilter']/option")); } }
            private static By datCampaignStartDate = By.Id(CommonCtrls.GeneralContent + "txtStartDateFromFilter");
            private static By datCampaignEndDate = By.Id(CommonCtrls.GeneralContent + "txtStartToFilter");
            public static String campaignNM;
            public static String currentDate;


            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Search Criteria") &&
                                Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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
            }



            public static void enterCampaignID(string campID)
            {
                SetMethods.enterObjectValue(txtCampaignID, campID);
            }

            public static void enterCampaignName(string campName)
            {
                SetMethods.enterObjectValue(txtCampaignName, campName);
            }

            public static void selectCampType(string campType)
            {
                try
                {
                    IList<IWebElement> campList = typeOptions;
                    Driver.Wait(TimeSpan.FromMinutes(5));
                    foreach (var ls in campList)
                    {
                        if (ls.Text.Contains(campType))
                        {
                            ls.Click();
                            Driver.Wait(TimeSpan.FromMinutes(5));
                        }
                        break;
                    }
                }
                catch (Exception e)
                {
                    Console.WriteLine(@"Error occurred logging on:" + e.ToString());
                }
            }

            public static void selectCampStatus(string campStatus)
            {
                try
                {
                    IList<IWebElement> campStat = statusOptions;
                    Driver.Wait(TimeSpan.FromMinutes(5));
                    foreach (var ls in campStat)
                    {
                        if (ls.Text.Contains(campStatus))
                        {
                            ls.Click();
                            Driver.Wait(TimeSpan.FromMinutes(5));
                        }
                        break;
                    }
                }
                catch (Exception e)
                {
                    Console.WriteLine(@"Error occurred logging on:" + e.ToString());
                }
            }

            public static void randomSelectCampDisease()
            {
                SetMethods.randomSelectObjectElement(ddlCampaignDisease, diseaseOptions);
            }

            public static void enterCampaignStartDate()
            {
                SetMethods.enterCurrentDate(datCampaignStartDate);
            }

            public static void enterCampaignEndDate()
            {
                SetMethods.enterCurrentDate(datCampaignEndDate);
            }

        }



        public class SearchResults
        {
            private static By expandRow = By.Id("expandRow");
            private static By selectCampaign = By.Id(CommonCtrls.GeneralContent + "gvVeterinaryCampaignsList");
            private static By activeCampSrchResultsSection = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "searchResults']/div/div[1]/div/div/h3");
            private static IList<IWebElement> campaignList { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvVeterinaryCampaignsList']/option")); } }

            public static bool IsAt
            {
                get
                {
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("The resource cannot be found"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(activeCampSrchResultsSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(activeCampSrchResultsSection).Text.Contains("Search Results") &&
                                Driver.Instance.FindElement(activeCampSrchResultsSection).Displayed)
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

            //Function that should return "True" if element does not exist
            public static bool DoesCampaignExistInList(string element)
            {
                try
                {
                    IList<IWebElement> campList = campaignList;
                    Driver.Wait(TimeSpan.FromMinutes(5));
                    foreach (var ls in campList)
                    {
                        if (!ls.Text.Contains(element))
                        {
                            return true;
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

            public static void randomSelectActSurvCamp()
            {
                try
                {
                    //Scroll to bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 500)", "");
                    Thread.Sleep(120);

                    By selList = selectCampaign;
                    IList<IWebElement> links = Driver.Instance.FindElements(By.LinkText("Select"));
                    foreach (var link in links)
                    {
                        link.Click();
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        break;
                    }
                }
                catch (NoSuchElementException e)
                {
                    Console.WriteLine(e.Message);
                }
            }

            public static void expandCampaignList()
            {
                try
                {
                    var campaign = wait.Until(ExpectedConditions.ElementExists(expandRow));
                    campaign.Click();
                    Driver.Wait(TimeSpan.FromMinutes(5));
                }
                catch
                {
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", expandRow);
                    var campaign = wait.Until(ExpectedConditions.ElementExists(expandRow));
                    campaign.Click();
                    Driver.Wait(TimeSpan.FromMinutes(5));
                }
            }
        }
    }
}