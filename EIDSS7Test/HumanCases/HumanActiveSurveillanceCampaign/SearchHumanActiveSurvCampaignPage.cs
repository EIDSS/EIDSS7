using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Threading;

namespace EIDSS7Test.HumanCases.HumanActiveSurveillanceCampaign
{
    public class SearchHumanActiveSurvCampaignPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();

        private static By titleFormTitle = By.TagName("h2");
        private static By searchFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "hdgSearch']");
        private static By searchCriteriaFormTitle = By.Id(CommonCtrls.GeneralContent + "hdgSearchCriteria");
        private static By searchResultsFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "searchResults']/div/div[1]/div/div[1]/h3");
        private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancelSearch");
        private static By btnSearch = By.Id(CommonCtrls.GeneralContent + "btnSearch");
        private static By btnClear = By.Id(CommonCtrls.GeneralContent + "btnClear");
        private static By btnEditSearch = By.Id(CommonCtrls.GeneralContent + "btnEditSearch");
        private static By btnNewSearch = By.Id(CommonCtrls.GeneralContent + "btnNewSearch");
        private static By btnCreateCampaign = By.Id(CommonCtrls.GeneralContent + "btnCreateCampaign");
        private static IList<IWebElement> lsSampleTypes = Driver.Instance.FindElements(By.XPath("*[contains(@id,'gvSearchResults_txtSampleTypesList_')]"));
        public static String searchResultsValue;


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
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Human Active Surveillance Campaign") &&
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

        public static void clickCreateCampaign()
        {
            SetMethods.clickObjectButtons(btnCreateCampaign);
        }

        public static void clickSearch()
        {
            SetMethods.clickObjectButtons(btnSearch);
        }

        public static void clickEditSearch()
        {
            SetMethods.clickObjectButtons(btnEditSearch);
        }

        public static void clickCancel()
        {
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clickNewSearch()
        {
            SetMethods.clickObjectButtons(btnNewSearch);
        }

        public static void clickClear()
        {
            SetMethods.clickObjectButtons(btnClear);
        }

        public class SearchCriteria
        {
            private static By txtCampaignNumber = By.Id(CommonCtrls.GeneralContent + "txtCampaignStrIDFilter");
            private static By txtCampaignName = By.Id(CommonCtrls.GeneralContent + "txtCampaignNameFilter");
            private static By ddlCampaignType = By.Id(CommonCtrls.GeneralContent + "ddlCampaignTypedFilter");
            private static IList<IWebElement> campTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlCampaignTypedFilter']/option")); } }
            private static By ddlCampaignStatus = By.Id(CommonCtrls.GeneralContent + "ddlCampaignStatusFilter");
            private static IList<IWebElement> campStatusOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlCampaignStatusFilter']/option")); } }
            private static By ddlDiagnosis = By.Id(CommonCtrls.GeneralContent + "ddlCampaignDiseaseFilter");
            private static IList<IWebElement> diagnosisOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlCampaignDiseaseFilter']/option")); } }
            private static By datStartDateFrom = By.Id(CommonCtrls.GeneralContent + "txtStartDateFromFilter");
            private static By datStartDateTo = By.Id(CommonCtrls.GeneralContent + "txtStartToFilter");
            private static By btnExpandIcon = By.Id(CommonCtrls.GeneralContent + "btnShowSearchCriteria");
            private static By lblSearchError = By.Id(CommonCtrls.GeneralContent + "lbl_Error");
            private static By btnPopupOK = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "errorCampaign']/div/div/div[3]/button");

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
                    else if (Driver.Instance.FindElements(searchCriteriaFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(searchCriteriaFormTitle).Text.Contains("Search Criteria") &&
                                Driver.Instance.FindElement(searchCriteriaFormTitle).Displayed)
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

            public static void clickExpandIcon()
            {
                SetMethods.clickObjectButtons(btnExpandIcon);
            }

            public static void clickPopupOK()
            {
                SetMethods.clickObjectButtons(btnPopupOK);
            }

            public static void enterCampaignNumber(String value)
            {
                SetMethods.enterObjectValue(txtCampaignNumber, value);
            }

            public static void clearCampaignNameField()
            {
                SetMethods.clearField(txtCampaignName);
            }

            public static void enterCampaignName(String value)
            {
                SetMethods.enterObjectValue(txtCampaignName, value);
                Thread.Sleep(2000);
            }

            public static void enterCampaignType(string camptype)
            {
                SetMethods.enterObjectValue(ddlCampaignType, camptype);
            }

            public static void enterCampaignStatus(string campstat)
            {
                SetMethods.enterObjectValue(ddlCampaignStatus, campstat);
            }

            public static void enterDiagnosis(string diag)
            {
                SetMethods.enterObjectValue(ddlDiagnosis, diag);
            }

            public static void enterPastStartDate(int value)
            {
                SetMethods.enterPastDate(datStartDateFrom, value);
            }

            public static void enterPastStartDate(string value)
            {
                SetMethods.enterStringObjectValue(datStartDateFrom, value);
            }

            public static void enterStartDate()
            {
                SetMethods.enterCurrentDate(datStartDateFrom);
            }

            public static void enterEndDate()
            {
                SetMethods.enterCurrentDate(datStartDateTo);
            }

            public static void doesEnterSearchParameterErrorMsgDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(lblSearchError);
            }

            public static void clearCampaignStartDateFromField()
            {
                SetMethods.clearField(datStartDateFrom);
            }

            public static void clearCampaignStartDateToField()
            {
                SetMethods.clearField(datStartDateTo);
            }

        }

        public class SearchResults
        {
            private static By tblSearchResults = By.Id(CommonCtrls.GeneralContent + "gvSearchResults");
            private static By btnExpandResults = By.XPath("/html/body/form/div[3]/div/div/div[1]/div/div[2]/div[2]/div/div[2]/div/div[3]/div[1]/table/tbody/tr[1]/td[9]/span");
            private static By txtCampaignEndDate = By.Id(CommonCtrls.GeneralContent + "gvSearchResults_txtEndDate_0");
            private static By txtCampaignAdmin = By.Id(CommonCtrls.GeneralContent + "gvSearchResults_txtCampaignAdministrator_0");
            private static By srchResultsTable = By.Id(CommonCtrls.GeneralContent + "gvSearchResults");
            private static IList<IWebElement> btnEdits { get { return Driver.Instance.FindElements(By.XPath("//*[@class='glyphicon glyphicon-edit']")); } }
            private static By btnEdit = By.XPath("//a[@class='btn glyphicon glyphicon-edit']");
            private static By btnDelete = By.XPath("//a[@class='glyphicon glyphicon-trash']");


            public static bool IsAt
            {
                get
                {
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 500)", "");
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(searchResultsFormTitle).Count > 0)
                    {
                        {
                            wait.Until(ExpectedConditions.ElementIsVisible(searchResultsFormTitle));
                            if (Driver.Instance.FindElement(searchResultsFormTitle).Text.Contains("Search Results") &&
                                Driver.Instance.FindElement(searchResultsFormTitle).Displayed)
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

            public static void clickExpandIcon()
            {
                SetMethods.clickObjectButtons(btnExpandResults);
            }

            public static void clickEditRecord()
            {
                SetMethods.clickObjectButtons(btnEdit);
            }

            public static void clickDeleteRecord()
            {
                SetMethods.clickObjectButtons(btnDelete);
            }

            public static void getSearchResultsValue()
            {
                SetMethods.StoreElementsInList2(lsSampleTypes);
            }

            public static void getSearchResultsValue(String value)
            {
                try
                {
                    IWebElement table = Driver.Instance.FindElement(tblSearchResults);
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
                    Console.WriteLine(value + " does not exist in the table.");
                }
            }

            public static void randomSelectCampaignRecord()
            {
                SetMethods.randomSelectObjectElement(tblSearchResults, btnEdits);
            }
        }
    }
}