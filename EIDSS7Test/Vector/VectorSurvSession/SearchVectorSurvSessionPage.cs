using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using System.Threading;
using EIDSS7Test.Common;
using NUnit.Framework;
using OpenQA.Selenium.Interactions;
using EIDSS7Test.Vector.CreateVectorSurvSession;

namespace EIDSS7Test.Vector.SearchVectorSurvSession
{
    public class SearchVectorSurvSessionPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(5));
        private static Random rnd = new Random();
        public static String sessionID;
        public static String outbreakID;
        public static string searchResultsValue;

        private static By HeaderFormTitle = By.TagName("h1");
        private static By titleFormTitle = By.TagName("h2");
        private static By vectorSearchSection = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "searchHeader']");
        private static By vectorSrchCritSection = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "searchCriteria']");
        private static By vectorSrchResultSection = By.XPath(".//*[@id='hdrSearchResults']");
        private static By lblSessionID = By.Name("Field Session ID");
        private static By txtSessionID = By.Id(CommonCtrls.GeneralContent + "txtSearchSessionID");
        private static By lblFieldSessionID = By.Name("Field Session ID");
        private static By txtFieldSessionID = By.Id(CommonCtrls.GeneralContent + "txtSearchFieldSessionID");
        private static By ddlStatus = By.Id(CommonCtrls.GeneralContent + "ddlSearchStatus");
        private static IList<IWebElement> statOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSearchStatus']/option")); } }
        private static By ddlVectorTypes = By.Id(CommonCtrls.GeneralContent + "ddlSearchVectorType");
        private static IList<IWebElement> vectorTypeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSearchVectorType']/option")); } }
        private static By ddlSpecies = By.Id(CommonCtrls.GeneralContent + "ddlSearchSpeciesTypeID");
        private static IList<IWebElement> speciesOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSearchSpeciesTypeID']/option")); } }
        private static By ddlDisease = By.Id(CommonCtrls.GeneralContent + "ddlSearchDiseaseID");
        private static IList<IWebElement> diseaseOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSearchDiseaseID']/option")); } }
        private static By ddlDiagnosisGroup = By.Id(CommonCtrls.GeneralContent + "ddlSearchDiagnosesGroup");
        private static IList<IWebElement> diagGroupOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSearchDiagnosesGroup']/option")); } }
        private static By ddlSearchRegion = By.Id("ddlLocCtridfsRegion");
        private static IList<IWebElement> searchRegionOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchContent + "ddlLocCtridfsRegion']/option")); } }
        private static By ddlSearchRayon = By.Id(CommonCtrls.SearchContent + "ddlLocCtridfsRayon");
        private static IList<IWebElement> searchRayonOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchContent + "ddlLocCtridfsRayon']/option")); } }
        private static By ddlSearchSettle = By.Id(CommonCtrls.SearchContent + "ddlLocCtridfsSettlement");
        private static IList<IWebElement> searchSettleOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchContent + "ddlLocCtridfsSettlement']/option")); } }
        private static By datStartDateFrom = By.Id(CommonCtrls.GeneralContent + "txtSearchStartDateFrom");
        private static By datStartDateTo = By.Id(CommonCtrls.GeneralContent + "txtSearchStartDateTo");
        private static By datEndDateFrom = By.Id(CommonCtrls.GeneralContent + "txtSearchEndDateFrom");
        private static By datEndDateTo = By.Id(CommonCtrls.GeneralContent + "txtSearchEndDateTo");
        private static By txtOutbreakID = By.Id(CommonCtrls.GeneralContent + "txtSearchOutbreakID");
        private static By ddlDataEntrySite = By.Id(CommonCtrls.GeneralContent + "ddlSearchDataEntrySite");
        private static By tlbResultsTable = By.Id(CommonCtrls.GeneralContent + "gvVSSSearchResults");
        private static By tlbPaginationTable = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "gvSearchResults']/tbody/tr[22]/td/table/tbody");
        private static IList<IWebElement> paginationList { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvSearchResults']//tbody/tr[22]/td/table/tbody/tr/td/a")); } }
        private static IList<IWebElement> tblRows { get { return Driver.Instance.FindElements(By.TagName("tr")); } }
        private static IList<IWebElement> tblColumns { get { return Driver.Instance.FindElements(By.TagName("td")); } }
        private static IList<IWebElement> dataEntrySiteOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSearchDataEntrySite']/option")); } }
        private static IList<IWebElement> btnEdits { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-edit']")); } }
        private static IList<IWebElement> btnSearchEdits { get { return Driver.Instance.FindElements(By.XPath("//*[@class='glyphicon glyphicon-edit']")); } }
        private static IList<IWebElement> AllSessionLinks { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[1]/div[1]/div[1]/div[1]/div[1]/div[2]/div[2]/div[2]/div[1]/div[2]/div[1]/div[1]/div[1]/table[1]/tbody[1]/tr/td[1]/a[1]")); } }
        private static By btnSearch = By.Id(CommonCtrls.GeneralContent + "btnSearchList");
        private static By btnReturnToDash = By.LinkText("Return to Dashboard");
        private static By btnClear = By.Id(CommonCtrls.GeneralContent + "btnClear");
        private static By btnEditSearch = By.Id(CommonCtrls.GeneralContent + "btnEditSearch");
        private static By btnEditVector = By.Id(CommonCtrls.GeneralContent + "btnEditVector");
        private static By btnBetaEditVector = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "btnVectorEdit']/span");
        private static By btnCreateVectorSurv = By.Id(CommonCtrls.GeneralContent + "btnCreateVectorSurveillance");
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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Vector Surveillance Session") &&
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

        public static bool IsAtSection
        {
            get
            {
                if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                {
                    Assert.Fail("Page cannot be displayed");
                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    return false;
                }
                else if (Driver.Instance.FindElements(vectorSearchSection).Count > 0)
                {
                    Driver.TakeScreenShot(vectorSearchSection, "SearchVectorSurvSessionPage");
                    if (Driver.Instance.FindElement(vectorSearchSection).Text.Contains("Search") &&
                        Driver.Instance.FindElement(vectorSearchSection).Displayed)
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

        public static void clickSearch()
        {
            Driver.Wait(TimeSpan.FromMinutes(20));
            SetMethods.clickObjectButtons(btnSearch);
            Thread.Sleep(2000);
        }

        public static void clickNewSearch()
        {
            Driver.Wait(TimeSpan.FromMinutes(20));
            SetMethods.clickObjectButtons(btnNewSearch);
            Driver.Wait(TimeSpan.FromMinutes(20));
        }

        public static void clickEditSearch()
        {
            Driver.Wait(TimeSpan.FromMinutes(20));
            SetMethods.clickObjectButtons(btnEditSearch);
            Driver.Wait(TimeSpan.FromMinutes(20));
        }

        public static void clickEditVector()
        {

            try
            {
                if (!Driver.Instance.FindElement(btnBetaEditVector).Displayed)
                {
                    Driver.Wait(TimeSpan.FromMinutes(20));
                    SetMethods.clickObjectButtons(btnBetaEditVector);
                    Driver.Wait(TimeSpan.FromMinutes(20));
                }

            }
            catch (NoSuchElementException)
            {
                Console.WriteLine("Element does not exist");
            }
            finally
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 2000)", "");
                Driver.Wait(TimeSpan.FromMinutes(20));
                SetMethods.clickObjectButtons(btnEditVector);
                Driver.Wait(TimeSpan.FromMinutes(20));
            }
        }

        public static void clickCreateVectorSurveillance()
        {
            SetMethods.clickObjectButtons(btnCreateVectorSurv);
        }

        public static void clickClear()
        {
            Driver.Wait(TimeSpan.FromMinutes(20));
            SetMethods.clickObjectButtons(btnClear);
            Driver.Wait(TimeSpan.FromMinutes(20));
        }

        public static void clickReturnToDashboard()
        {
            Driver.Wait(TimeSpan.FromMinutes(20));
            SetMethods.clickObjectButtons(btnReturnToDash);
            Driver.Wait(TimeSpan.FromMinutes(20));
        }

        //METHOD CHANGED FOR BETA ENV: TFS2114
        public static void randomlySelectBETASession()
        {
            //((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 700)", "");
            Driver.Wait(TimeSpan.FromMinutes(20));

            //FOR FIREFOX - Need to search for table again
            var table = tlbResultsTable;
            IList<IWebElement> links = btnSearchEdits;
            Driver.Wait(TimeSpan.FromMinutes(20));

            foreach (var link in links)
            {
                link.Click();
                Driver.Wait(TimeSpan.FromMinutes(20));
                break;
            }
        }

        public static void randomlySelectQASession()
        {
            SetMethods.randomSelectObjectElement(tlbResultsTable, AllSessionLinks);
            Thread.Sleep(3000);
        }


        public static String enterRandomSessionID(String session)
        {
            SetMethods.enterObjectValue(txtSessionID, session);
            return sessionID = session;
        }


        public static String enterRandomFieldSessionID(String session)
        {
            SetMethods.enterObjectValue(txtFieldSessionID, session);
            return sessionID = session;
        }

        public static String enterFieldSessionID(String fldSessID)
        {
            SetMethods.enterObjectValue(txtFieldSessionID, fldSessID);
            return fldSessID;
        }

        public static String enterSessionID(String SessID)
        {
            SetMethods.enterObjectValue(txtSessionID, SessID);
            return SessID;
        }


        public static void selectInProcessStatus()
        {
            SetMethods.enterObjectDropdownListValue(ddlStatus, "In Process");
        }

        public static void selectClosedStatus()
        {
            SetMethods.enterObjectDropdownListValue(ddlStatus, "Closed");
        }

        public static void randomSelectVectorType()
        {
            SetMethods.randomSelectObjectElement(ddlVectorTypes, vectorTypeOptions);
        }

        public static void randomSelectSpecies()
        {
            SetMethods.randomSelectObjectElement(ddlSpecies, speciesOptions);
        }

        public static void randomSelectDisease()
        {
            SetMethods.randomSelectObjectElement(ddlDisease, diseaseOptions);
        }

        public static void randomSelectDiagnosisGroup()
        {
            SetMethods.randomSelectObjectElement(ddlDiagnosisGroup, diagGroupOptions);
        }

        public static void randomSelectRegion()
        {
            SetMethods.randomSelectObjectElement(ddlSearchRegion, searchRegionOpts);
        }

        public static void clearRegionField()
        {
            SetMethods.clearDropdownList(ddlSearchRegion);
            Thread.Sleep(2000);
        }

        public static Boolean isRayonFieldEnabled()
        {
            try
            {
                var rayon = wait.Until(ExpectedConditions.ElementIsVisible(ddlSearchRayon));
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

        public static void clearStartDateFromField()
        {
            Thread.Sleep(2000);
            SetMethods.clearField(datStartDateFrom);
            Thread.Sleep(2000);
        }

        public static void enterStartDateFrom(int value)
        {
            Thread.Sleep(5000);
            SetMethods.enterPastDate(datStartDateFrom, value);
            Driver.Wait(TimeSpan.FromMinutes(10));
        }

        public static void enterParmStartDateFrom(string value)
        {
            Thread.Sleep(2000);
            SetMethods.enterStringObjectValue(datStartDateFrom, value);
        }

        public static void clearStartDateToField()
        {
            SetMethods.clearField(datStartDateTo);
            Thread.Sleep(2000);
        }
        public static void enterStartDateTo(int value)
        {
            Driver.Wait(TimeSpan.FromMinutes(10));
            SetMethods.enterDateInDays(value, datStartDateTo);
            Driver.Wait(TimeSpan.FromMinutes(10));
        }

        public static void enterParmStartDateTo(string value)
        {
            Thread.Sleep(2000);
            SetMethods.enterStringObjectValue(datStartDateTo, value);
        }

        public static void enterEndDateFrom()
        {
            SetMethods.enterCurrentDate(datEndDateFrom);
        }

        public static void enterEndDateTo()
        {
            SetMethods.enterCurrentDate(datEndDateTo);
        }

        public static String enterOutbreakID(String outbreak)
        {
            SetMethods.enterObjectValue(txtOutbreakID, outbreak);
            return outbreakID = outbreak;
        }

        public static void randomSelectDataEntrySite()
        {
            SetMethods.randomSelectObjectElement(ddlDataEntrySite, dataEntrySiteOpts);
        }


        public static void doesVectorSurvSessionDisplayInList()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 500)", "");
            Thread.Sleep(120);

            if (tblColumns.Count > 0)
            {
                foreach (var col in tblColumns)
                {
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    if (col.Text.Contains(CreateVectorSurvSessionPage.sessionID))
                    {
                        Console.WriteLine(sessionID + " displays in list successfully");
                        break;
                    }
                    else if (!col.Text.Contains(CreateVectorSurvSessionPage.sessionID))
                    {
                        Console.WriteLine("No data available.");
                    }
                    break;
                }
            }
            else
            {
                //Fails test if name does not display in list
                Assert.Fail(CreateVectorSurvSessionPage.sessionID + " record does not display.");
            }
        }



        public static void doesStatusDisplayCorrectly(string stat)
        {
            if (tblColumns.Count > 0)
            {
                foreach (IWebElement col in tblColumns)
                {
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    if (col.Text.Contains(stat))
                    {
                        Console.WriteLine(stat + " displays correctly for session.");
                        break;
                    }
                }
            }
            else
            {
                //Fails test if name does not display in list
                Assert.Fail("Element cannot be found.");
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
                        CreateVectorSurvSessionPage.fieldSessionID = col.Text;
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
            public static bool IsAtSection
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    Thread.Sleep(2000);
                    ////Scroll to the bottom of the page
                    //((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 500)", "");
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(vectorSrchResultSection).Count > 0)
                    {
                        if (Driver.Instance.FindElement(vectorSrchResultSection).Text.Contains("Search Results") &&
                            Driver.Instance.FindElement(vectorSrchResultSection).Displayed)
                            return true;
                        else
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("Section does not display.  Please try again.");
                        return false;
                    }
                    else
                    {
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Section does not display.  Please try again.");
                        return false;
                    }
                }
            }

            public static void getSearchResultsValue(String value)
            {
                try
                {
                    IWebElement table = Driver.Instance.FindElement(tlbResultsTable);
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

                                //} else if (!col.Text.Contains(value))
                                //{
                                //    IWebElement pageTable = Driver.Instance.FindElement(tlbPaginationTable);
                                //    IList<IWebElement> pages = pageTable.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvSearchResults']//tbody/tr[22]/td/table/tbody/tr/td/a"));

                                //    if(pages.Count > 0)
                                //    {
                                //        for(int i=0; i<pages.Count; i++)
                                //        {
                                //            foreach (var page in pages)
                                //            {
                                //                if (!col.Text.Contains(value))
                                //                {
                                //                    page.Click();
                                //                }
                                //                else if (col.Text.Contains(value))
                                //                {
                                //                    searchResultsValue = col.Text;
                                //                    break;
                                //                }
                                //            }
                                //        }
                                //    }
                                //}
                            }
                        }
                        break;
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