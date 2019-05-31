using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using System.Threading;
using EIDSS7Test.Common;
using NUnit.Framework;

namespace EIDSS7Test.HumanCases.SearchDiseaseReports
{
    public class SearchHumanDiseaseReportsPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();
        public static string eidssNumber;
        public static string eidssPerNumber;
        public static string personFirstName;
        public static string personLastName;
        public static int personAge;

        private static By titleFormTitle = By.TagName("h2");
        private static By srchResultsFormTitle = By.Id(CommonCtrls.GeneralContent + "hdrSearchResults");
        private static By srchCriteriaFormTitle = By.Id(CommonCtrls.GeneralContent + "hdgSearchCriteria");
        private static By srchByRptFormTitle = By.Id(CommonCtrls.GeneralContent + "hdgSearch");
        private static By txtEIDSSIdNumber = By.Id(CommonCtrls.GeneralContent + "txtEIDSSIDNumber");
        private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancelSearch");
        private static By btnSearch = By.Id(CommonCtrls.GeneralContent + "btnSearch");
        private static By btnClear = By.Id(CommonCtrls.GeneralContent + "btnClear");
        private static By btnReturnToDash = By.Id(CommonCtrls.GeneralContent + "btnRetToDashboard");
        private static By btnNewSearch = By.Id(CommonCtrls.GeneralContent + "btnNewSearch");
        private static By btnAddNew = By.Id(CommonCtrls.GeneralContent + "btnAddNew");
        private static By btnAddDiseaseRpt = By.Id(CommonCtrls.GeneralContent + "btnAddDisease");

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
                else if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Error:"))
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                    return false;
                }
                else if (Driver.Instance.FindElements(titleFormTitle).Count > 0)
                {
                    {
                        Driver.Wait(TimeSpan.FromMinutes(45));
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Search Disease Reports") &&
                            Driver.Instance.FindElement(titleFormTitle).Displayed)
                            return true;
                        else
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("This is not the correct title");
                        return false;
                    }
                }
                else
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    return false;
                }
            }
        }

        public static void clickSearch()
        {
            try
            {
                SetMethods.clickObjectButtons(btnSearch);
            }
            catch
            {
                SetMethods.clickObjectButtons(btnSearch);
            }
        }

        public static void clickClear()
        {
            SetMethods.clickObjectButtons(btnClear);
        }

        public static void clickReturnToDash()
        {
            SetMethods.clickObjectButtons(btnReturnToDash);
        }

        public static void clickCancel()
        {
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clickAddDiseaseReport()
        {
            SetMethods.clickObjectButtons(btnAddDiseaseRpt);
        }

        public static void clickAddNewReport()
        {
            SetMethods.clickObjectButtons(btnAddNew);
        }


        public class Search
        {
            private static By txtEIDSSID = By.Id(CommonCtrls.GeneralContent + "txtSearchStrCaseId");
            private static By ddlDiagnosis = By.Id(CommonCtrls.GeneralContent + "ddlSearchDiagnosis");
            private static By datFromDate = By.Id(CommonCtrls.GeneralContent + "txtSearchHDRDateEnteredFrom");
            private static By datToDate = By.Id(CommonCtrls.GeneralContent + "txtSearchHDRDateEnteredTo");
            private static IList<IWebElement> srchDiagnosisOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSearchDiagnosis']/option")); } }
            private static By ddlRegion = By.Id(CommonCtrls.SrchDiseaseLocContent + "ddllsearchFormidfsRegion");
            private static IList<IWebElement> regionOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SrchDiseaseLocContent + "ddllsearchFormidfsRegion']/option")); } }
            private static By ddlReportStatus = By.Id(CommonCtrls.GeneralContent + "ddlSearchReportStatus");
            private static IList<IWebElement> reportStatusOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSearchReportStatus']/option")); } }
            private static By ddlRayon = By.Id(CommonCtrls.SrchDiseaseLocContent + "ddllsearchFormidfsRayon");
            private static IList<IWebElement> rayonOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SrchDiseaseLocContent + "ddllsearchFormidfsRayon']/option")); } }
            private static By ddlFinalCaseClass = By.Id(CommonCtrls.GeneralContent + "ddlSearchCaseClassification");
            private static IList<IWebElement> finalCaseOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSearchCaseClassification']/option")); } }
            private static By ddlCurrentPersonLoc = By.Id(CommonCtrls.GeneralContent + "ddlSearchIdfsHospitalizationStatus");
            private static IList<IWebElement> currLocPersonOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSearchIdfsHospitalizationStatus']/option")); } }


            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(srchByRptFormTitle).Count > 0)
                    {
                        {
                            wait.Until(ExpectedConditions.ElementExists(srchByRptFormTitle));
                            if (Driver.Instance.FindElement(srchByRptFormTitle).Text.Contains("Search") &&
                                Driver.Instance.FindElement(srchByRptFormTitle).Displayed)
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


            public static void enterEIDSSnumber()
            {
                SetMethods.enterObjectValue(txtEIDSSID, eidssNumber);
            }

            public static void enterReportID(string value)
            {
                SetMethods.enterObjectValue(txtEIDSSID, value);
            }

            public static void randomSelectDiagnosis()
            {
                SetMethods.randomSelectObjectElement(ddlDiagnosis, srchDiagnosisOpts);
            }

            public static void enterDiagnosis(string el)
            {
                SetMethods.enterObjectValue(ddlDiagnosis, el);
            }

            public static void randomSelectReportStatus()
            {
                SetMethods.randomSelectObjectElement(ddlReportStatus, reportStatusOpts);
            }

            public static void enterReportStatus(string el)
            {
                SetMethods.enterObjectValue(ddlReportStatus, el);
            }

            public static void randomSelectRegon()
            {
                SetMethods.randomSelectObjectElement(ddlRegion, regionOpts);
            }

            public static void enterRegion(string el)
            {
                SetMethods.enterObjectValue(ddlRegion, el);
            }

            public static void randomSelectRayon()
            {
                SetMethods.randomSelectObjectElement(ddlRayon, rayonOpts);
            }

            public static void enterRayon(string el)
            {
                SetMethods.enterObjectValue(ddlRayon, el);
            }

            public static void randomSelectFinalCaseClass()
            {
                SetMethods.randomSelectObjectElement(ddlFinalCaseClass, finalCaseOpts);
            }

            public static void enterFinalCaseclassification(string el)
            {
                SetMethods.enterObjectValue(ddlFinalCaseClass, el);
            }

            public static void randomSelectLocationOfPerson()
            {
                SetMethods.randomSelectObjectElement(ddlCurrentPersonLoc, currLocPersonOpts);
            }

            public static void enterLocationOfPerson(string el)
            {
                SetMethods.enterObjectValue(ddlCurrentPersonLoc, el);
            }

            public static void enterFromDate()
            {
                SetMethods.enterCurrentDate(datFromDate);
            }

            public static void enterToDate()
            {
                SetMethods.enterCurrentDate(datToDate);
            }

        }

        public class SearchCriteria
        {
            public static bool IsAt
            {
                get
                {
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
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
                                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("This is not the correct title");
                            return false;
                        }
                    }
                    else
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                }
            }

            public static void clickNewSearch()
            {
                SetMethods.clickObjectButtons(btnNewSearch);
            }

            public static void clickCreateNewReport()
            {
                SetMethods.clickObjectButtons(btnAddNew);
            }

        }

        public class SearchResults
        {
            //private static By tlbSearchResults = By.CssSelector("#EIDSSBodyCPH_gvDisease > tbody");
            private static By tlbSearchResults = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvDisease']");
            //private static By tlbSearchResults = By.XPath("/html/body/form/div[3]/div/div[2]/div[4]/div/div[2]/div[1]/div/table/tbody");
            private static IList<IWebElement> btnEdits { get { return Driver.Instance.FindElements(By.XPath("/html/body/form/div[3]/div/div[2]/div[4]/div/div[2]/div[1]/div/table/tbody/tr[3]/td[9]/a/span")); } }
            private static By btnEdit = By.XPath("//a[@id='glyphicon glyphicon_btnEdit_0']");

            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    Thread.Sleep(3000);
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                         || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElement(srchResultsFormTitle).Text.Contains("Error:"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
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
                                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("This is not the correct title");
                            return false;
                        }
                    }
                    else
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("This is not the correct title");
                        return false;
                    }
                }
            }

            public static void randomEditHumanDiseaseRpt()
            {
                SetMethods.randomSelectObjectElement(tlbSearchResults, btnEdits);
            }

            public static void clickNewSearch()
            {
                SetMethods.clickObjectButtons(btnNewSearch);
            }

            public static void clickCreateNewReport()
            {
                SetMethods.clickObjectButtons(btnAddNew);
            }

        }
    }
}