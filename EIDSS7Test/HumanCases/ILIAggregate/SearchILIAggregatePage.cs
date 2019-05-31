using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Threading;

namespace EIDSS7Test.HumanCases.ILIAggregate
{
    public class SearchILIAggregatePage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();

        private static By HeaderFormTitle = By.TagName("h1");
        private static By titleFormTitle = By.TagName("h2");
        private static By subtitleFormTitle = By.TagName("h3");
        private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancelAgg");
        private static By btnClear = By.Id(CommonCtrls.GeneralContent + "btnClear");
        private static By btnSearch = By.Id(CommonCtrls.GeneralContent + "btnSearch");
        private static By btnAdd = By.Id(CommonCtrls.GeneralContent + "btnAddILIAgg");


        public static bool IsAt
        {
            get
            {
                try
                {
                    Driver.Instance.WaitForPageToLoad();
                    Thread.Sleep(2000);
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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("ILI Aggregate") &&
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
                    Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again." + e.Message);
                    return false;
                }
            }
        }

        public static void clickCancel()
        {
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clickClear()
        {
            SetMethods.clickObjectButtons(btnClear);
        }

        public static void clickSearch()
        {
            SetMethods.clickObjectButtons(btnSearch);
        }

        public static void clickAdd()
        {
            SetMethods.clickObjectButtons(btnAdd);
        }

        public class SearchCriteria
        {
            private static By subtitleFormTitle = By.Id(CommonCtrls.GeneralContent + "hdgSearchCriteria");
            private static By txtFormID = By.Id(CommonCtrls.GeneralContent + "txtSearchformILIAggCode");
            private static By datWeeksToDate = By.Id(CommonCtrls.GeneralContent + "txtdatSearchWeeksToDate");
            private static By datWeeksFromDate = By.Id(CommonCtrls.GeneralContent + "txtdatSearchWeeksFromDate");
            private static By ddlHospital = By.Id(CommonCtrls.GeneralContent + "ddlidfILIAggHospitalName");
            private static IList<IWebElement> hospitalOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfILIAggHospitalName']/option")); } }
            private static By ddlSite = By.Id(CommonCtrls.GeneralContent + "ddlidfILIAggDataSite");
            private static IList<IWebElement> siteOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfILIAggDataSite']/option")); } }

            public static bool IsAt
            {
                get
                {
                    try
                    {
                        Driver.Instance.WaitForPageToLoad();
                        Thread.Sleep(2000);
                        if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                             || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                        {
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("Page cannot be displayed");
                            return false;
                        }
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Search") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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

            public static void enterWeeksFromDate(int value)
            {
                SetMethods.enterDateInDays(value, datWeeksFromDate);
            }

            public static void enterWeeksToDate()
            {
                SetMethods.enterCurrentDate(datWeeksToDate);
            }
        }


        public class SearchResults
        {
            private static By subtitleFormTitle = By.Id(CommonCtrls.GeneralContent + "hdrSearchResults");
            public static bool IsAt
            {
                get
                {
                    try
                    {
                        Driver.Instance.WaitForPageToLoad();
                        Thread.Sleep(2000);
                        if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                             || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                        {
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("Page cannot be displayed");
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
        }
    }
}
