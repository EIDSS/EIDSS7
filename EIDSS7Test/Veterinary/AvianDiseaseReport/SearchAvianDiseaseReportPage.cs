using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;
using OpenQA.Selenium.Interactions;

namespace EIDSS7Test.Veterinary.AvianDiseaseReport
{
    public class SearchAvianDiseaseReportPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();
        public static string farmNM;
        public static string farmID;

        private static By HeaderFormTitle = By.TagName("h1");
        private static By titleFormTitle = By.TagName("h2");
        private static By subtitleFormTitle = By.TagName("h3");

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
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(titleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Avian Disease Report") &&
                                Driver.Instance.FindElement(titleFormTitle).Displayed)
                                return true;
                            else
                                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                            return false;
                        }
                    }
                    else if (Driver.Instance.FindElement(HeaderFormTitle).Displayed ||
                        Driver.Instance.FindElement(HeaderFormTitle).Text.Contains("This page isn't working"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
                    }
                    else
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
                    }
                }
                catch (NoSuchElementException e)
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again." + e.Message);
                    return false;
                }
            }
        }

        public class SearchCriteria
        {
            private static By ddlSpeciesType = By.Id(CommonCtrls.SearchVetDiseaseContent + "ddlSearchidfsCaseType");
            private static IList<IWebElement> speciesTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchVetDiseaseContent + "ddlSearchidfsCaseType']/option")); } }
            private static By ddlDisease = By.Id(CommonCtrls.SearchVetDiseaseContent + "ddlSearchidfsFinalDiagnosis");
            private static IList<IWebElement> diseaseOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchVetDiseaseContent + "ddlSearchidfsFinalDiagnosis']/option")); } }
            private static By ddlReportStat = By.Id(CommonCtrls.SearchVetDiseaseContent + "ddlSearchidfsCaseProgressStatus");
            private static IList<IWebElement> rptStatusOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchVetDiseaseContent + "ddlSearchidfsCaseProgressStatus']/option")); } }
            private static By ddlRegion = By.Id(CommonCtrls.SearchVetDiseaseContent + "Search_ddlSearchidfsRegion");
            private static IList<IWebElement> regionOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchVetDiseaseContent + "Search_ddlSearchidfsRegion']/option")); } }
            private static By ddlRayon = By.Id(CommonCtrls.SearchVetDiseaseContent + "Search_ddlSearchidfsRayon");
            private static IList<IWebElement> rayonOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchVetDiseaseContent + "Search_ddlSearchidfsRayon']/option")); } }
            private static By ddlTownOrVillage = By.Id(CommonCtrls.SearchVetDiseaseContent + "Search_ddlSearchidfsSettlement");
            private static IList<IWebElement> townOrVillageOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchVetDiseaseContent + "Search_ddlSearchidfsSettlement']/option")); } }
            private static By ddlCaseClassification = By.Id(CommonCtrls.SearchVetDiseaseContent + "ddlidfsCaseClassification");
            private static IList<IWebElement> caseClassOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchVetDiseaseContent + "ddlidfsCaseClassification']/option")); } }
            private static By txtDateEnteredFrom = By.Id(CommonCtrls.SearchVetDiseaseContent + "txtSearchVDRDateEnteredFrom");
            private static By txtDateEnteredTo = By.Id(CommonCtrls.SearchVetDiseaseContent + "txtSearchVDRDateEnteredTo");
            private static By btnCreateAvianRpt = By.Id(CommonCtrls.SearchVetDiseaseContent + "btnAddAvianVeterinaryDiseaseReport");
            private static By btnSearch = By.Id(CommonCtrls.SearchVetDiseaseContent + "btnSearch");
            private static By btnClear = By.Id(CommonCtrls.SearchVetDiseaseContent + "btnClear");
            private static By btnCancel = By.Id("btnCancel");
            private static By titleFormTitle = By.TagName("h3");

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
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("Page cannot be displayed");
                            return false;
                        }
                        else if (Driver.Instance.FindElements(titleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(15));
                                if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Search Criteria") &&
                                    Driver.Instance.FindElement(titleFormTitle).Displayed)
                                    return true;
                                else
                                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                Assert.Fail("This is not the correct title");
                                return false;
                            }
                        }
                    }
                    catch
                    {
                        return false;
                    }
                    return false;
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

            public static void clickCancelBtn()
            {
                SetMethods.clickObjectButtons(btnCancel);
            }

            public static void clickCreateAvianDiseaseRpt()
            {
                //Scroll to bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 700)", "");
                SetMethods.clickObjectButtons(btnCreateAvianRpt);
            }

            public static void randomEnterDateEnteredFrom()
            {
                int rNum = rnd.Next(-14);
                string curDate = DateTime.Now.AddDays(-rNum).ToString("dd/MM/yyyy");
                SetMethods.enterObjectValue(txtDateEnteredFrom, curDate);
            }

            public static void enterDateEnteredToDate()
            {
                SetMethods.enterCurrentDate(txtDateEnteredTo);
            }
        }

        public class SearchResults
        {
            private static By titleFormTitle = By.TagName("h3");
            private static IList<IWebElement> allEditButtons { get { return Driver.Instance.FindElements(By.XPath("//div/a[contains(@class,'btn glyphicon glyphicon-edit')]")); } }
            private static IList<IWebElement> allDeleteButtons { get { return Driver.Instance.FindElements(By.XPath("//div/a[contains(@class,'btn glyphicon glyphicon-trash')]")); } }

            public static bool IsAt
            {
                get
                {
                    try
                    {
                        //Scroll to bottom of the page
                        ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 500)", "");
                        if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                        {
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("Page cannot be displayed");
                            return false;
                        }
                        else if (Driver.Instance.FindElements(titleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(15));
                                if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Search Results") &&
                                    Driver.Instance.FindElement(titleFormTitle).Displayed)
                                    return true;
                                else
                                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                Assert.Fail("This is not the correct title");
                                return false;
                            }
                        }
                    }
                    catch
                    {
                        return false;
                    }
                    return false;
                }
            }

            //public static void randomSelectFromFarmResults()
            //{
            //    SetMethods.randomSelectObjectElement(tlbFarmResultTable, allEditButtons);
            //}

            //public static void randomDeleteFromFarmResults()
            //{
            //    SetMethods.randomSelectObjectElement(tlbFarmResultTable, allDeleteButtons);
            //}

            public static void editFarmRecord()
            {
                IList<IWebElement> rows = Driver.Instance.FindElements(By.TagName("tr"));
                Driver.Wait(TimeSpan.FromMinutes(15));
                foreach (var edit in allEditButtons)
                {
                    edit.Click();
                    Driver.Wait(TimeSpan.FromMinutes(15));
                    break;
                }
            }
        }
    }
}