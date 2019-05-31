using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Threading;

namespace EIDSS7Test.HumanCases.CreateNewPerson
{
    public class SearchPersonPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();
        public static List<String> suffixes = new List<String> { "Mr.", "Mrs.", "Miss", "Jr.", "Sr." };
        public static string eidssNumber;
        public static string eidssPerNumber;
        public static string personFirstName;
        public static string personLastName;
        public static int personAge;
        public static string searchResultsValue;

        private static By HeaderFormTitle = By.TagName("h1");
        private static By titleFormTitle = By.TagName("h2");
        private static By subTitleFormTitle = By.TagName("h3");
        private static By srchParmsFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "parametersHeading']");
        private static By srchFormTitle = By.Id(CommonCtrls.GeneralContent + "hdgSearch");
        private static By srchCriteriaFormTitle = By.Id("hdgSearchCriteria");
        private static By srchBetaParameterFormTitle = By.Id(CommonCtrls.SearchPersonContent + "hdgSearchParameters");
        private static By txtEIDSSPersonID = By.Id(CommonCtrls.SearchPersonContent + "txtEIDSSPersonID");
        private static By ddlPersonalIDType = By.Id(CommonCtrls.SearchPersonContent + "ddlPersonalIDType");
        private static IList<IWebElement> personalIDOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchPersonContent + "ddlPersonalIDType']/option")); } }
        private static By txtPersonalID = By.Id(CommonCtrls.SearchPersonContent + "txtPersonalID");
        private static By txtFirstName = By.Id(CommonCtrls.SearchPersonContent + "txtFirstOrGivenName");
        private static By txtMiddleInit = By.Id(CommonCtrls.SearchPersonContent + "txtSecondName");
        private static By txtLastName = By.Id(CommonCtrls.SearchPersonContent + "txtLastOrSurname");
        private static By txtSuffix = By.Id(CommonCtrls.GeneralContent + "txtSuffix");
        private static By datDateOfBirth = By.Id(CommonCtrls.SearchPersonContent + "txtDateofBirth");
        private static By ddlGender = By.Id(CommonCtrls.SearchPersonContent + "ddlGenderTypeID");
        private static IList<IWebElement> genderOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchPersonContent + "ddlGenderTypeID']/option")); } }
        private static By ddlRegion = By.Id(CommonCtrls.SearchPersonLocContent + "ddlucLocationidfsRegion");
        private static IList<IWebElement> regionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchPersonLocContent + "ddlucLocationidfsRegion']/option")); } }
        private static By ddlRayon = By.Id(CommonCtrls.SearchPersonLocContent + "ddlucLocationidfsRayon");
        private static IList<IWebElement> regionRayon { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchPersonLocContent + "ddlucLocationidfsRayon']/option")); } }
        private static By btnSearch = By.Id(CommonCtrls.SearchPersonContent + "btnSearch");
        private static By btnReturnToDashboard = By.LinkText("Return to Dashboard");
        private static By btnClear = By.Id(CommonCtrls.SearchPersonContent + "btnClear");
        //private static By btnCancel = By.Id()
        private static By btnNewSearch = By.Id(CommonCtrls.GeneralContent + "btnNewSearch");
        private static By btnAddNewPerson = By.Id(CommonCtrls.SearchPersonContent + "btnAddPerson");
        private static By btnSubmit = By.Id(CommonCtrls.AddPersonUpdateContent + "btnSubmit");
        private static By btnCancel = By.XPath("//input[@class='btn btn-default']");

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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Person") &&
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

        public static void clickSearch()
        {
            SetMethods.clickObjectButtons(btnSearch);
        }

        public static void clickClear()
        {
            SetMethods.clickObjectButtons(btnClear);
        }

        public static void clickCancel()
        {
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clickAddPerson()
        {
            SetMethods.clickObjectButtons(btnAddNewPerson);
        }

        public class SearchCriteria
        {

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
                        else if (Driver.Instance.FindElements(srchCriteriaFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(srchCriteriaFormTitle).Text.Contains("Search Criteria") &&
                                    Driver.Instance.FindElement(srchCriteriaFormTitle).Displayed)
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

            public static void clearPersonIDField()
            {
                SetMethods.clearField(txtEIDSSPersonID);
            }

            public static String enterRandomEIDSSIDNumber(string eidss)
            {
                try
                {
                    int rNum = rnd.Next(1000, 10000000);
                    eidssNumber = eidss + rNum;
                    SetMethods.enterObjectValue(txtEIDSSPersonID, eidssNumber);
                    return eidssNumber;
                }
                catch
                {
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", txtEIDSSPersonID);
                    int rNum = rnd.Next(1000, 10000000);
                    eidssNumber = eidss + rNum;
                    SetMethods.enterObjectValue(txtEIDSSPersonID, eidssNumber);
                    return eidssNumber;
                }
            }

            public static String enterPersonID(string eidss)
            {
                SetMethods.enterStringObjectValue(txtEIDSSPersonID, eidss);
                return eidssNumber = eidss;
            }

            public static String enterEIDSSIDNumber(string eidss)
            {
                SetMethods.enterStringObjectValue(txtEIDSSPersonID, eidss);
                return eidssNumber = eidss;
            }

            public static void randomSelectPersonalIDType()
            {
                SetMethods.randomSelectObjectElement(ddlPersonalIDType, personalIDOptions);
            }

            public static Boolean isPersonalIDDisabled()
            {
                try
                {
                    var ID = wait.Until(ExpectedConditions.ElementIsVisible(txtPersonalID));
                    ID.GetAttribute("disabled");
                    return true;
                }
                catch (Exception)
                {
                    Console.WriteLine("Field is not disabled");
                    return false;
                }
            }

            public static Boolean isPersonalIDEnabled()
            {
                try
                {
                    var ID = wait.Until(ExpectedConditions.ElementIsVisible(txtPersonalID));
                    ID.GetAttribute("enabled");
                    return true;
                }
                catch (Exception)
                {
                    Console.WriteLine("Field is not enabled");
                    return false;
                }
            }


            public static String enterPersonalID(string eidss)
            {
                int rNum = rnd.Next(1000, 10000000);
                eidssPerNumber = eidss + rNum;
                SetMethods.enterObjectValue(txtPersonalID, eidss);
                return eidssPerNumber;
            }

            public static void enterPartialPersonalID(String value)
            {
                SetMethods.enterObjectValue(txtEIDSSPersonID, value);
            }

            public static String enterPersonFirstName(string fName)
            {
                int rNum = rnd.Next(1000, 10000000);
                personFirstName = fName + rNum;
                SetMethods.enterObjectValue(txtFirstName, fName);
                return personFirstName;
            }

            public static void enterPersonMiddleInit()
            {
                SetMethods.enterObjectValue(txtMiddleInit, personFirstName);
            }

            public static String enterPersonLastName()
            {
                SetMethods.enterObjectValue(txtFirstName, personFirstName);
                return personLastName;
            }
            public static void randomEnterPersonSuffix()
            {
                try
                {
                    int index = rnd.Next(suffixes.Count);
                    var name = suffixes[index];
                    suffixes.RemoveAt(index);

                    var personSuffix = wait.Until(ExpectedConditions.ElementIsVisible(txtSuffix));
                    personSuffix.EnterText(name);
                    Driver.Wait(TimeSpan.FromMinutes(5));
                }
                catch
                {
                    int index = rnd.Next(suffixes.Count);
                    var name = suffixes[index];
                    suffixes.RemoveAt(index);

                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", txtSuffix);
                    var personSuffix = wait.Until(ExpectedConditions.ElementIsVisible(txtSuffix));
                    personSuffix.EnterText(name);
                    Driver.Wait(TimeSpan.FromMinutes(5));
                }
            }

            public static void randomEnterPersonDOB()
            {
                SetMethods.randomEnterDOB(datDateOfBirth);
            }

            public static void randomEnterPersonDOBOver100()
            {
                SetMethods.randomEnterDOBOver100(datDateOfBirth, personAge);
            }

            //public static void doesWarningDisplayPatientAgeOver100()
            //{
            //    try
            //    {
            //        string text = Driver.Instance.SwitchTo().Alert().Text;
            //        errorString = text;
            //    }
            //    catch
            //    {
            //        //Fails the test if error message does not display
            //        Assert.IsTrue(String.IsNullOrEmpty(errorString));
            //    }
            //    return errorString;
            //}

            public static void selectGender(String sex)
            {
                SetMethods.enterStringObjectValue(ddlGender, sex);
            }


        }

        public class SearchParameters
        {
            private static By txtSearchEIDSSID = By.Id(CommonCtrls.SearchPersonContent + "txtstrCaseId");
            private static By txtFirstName = By.Id(CommonCtrls.SearchPersonContent + "txtstrFirstName");
            private static By txtMiddleInit = By.Id(CommonCtrls.SearchPersonContent + "txtstrSecondName");
            private static By txtLastName = By.Id(CommonCtrls.SearchPersonContent + "txtstrLastName");
            private static By ddlPersonalIDType = By.Id(CommonCtrls.SearchPersonContent + "ddlidfsPersonIDType");
            private static IList<IWebElement> personTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchPersonContent + "ddlidfsPersonIDType']/option")); } }
            private static By ddlGender = By.Id(CommonCtrls.SearchPersonContent + "ddlidfsHumanGender");
            private static IList<IWebElement> genderOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchPersonContent + "ddlidfsHumanGender']/option")); } }
            private static By ddlRegion = By.Id(CommonCtrls.SearchPersonContent + "searchForm_ddlsearchFormidfsRegion");
            private static IList<IWebElement> regionOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchPersonContent + "searchForm_ddlsearchFormidfsRegion']/option")); } }
            private static By ddlRayon = By.Id(CommonCtrls.SearchPersonContent + "searchForm_ddlsearchFormidfsRayon");
            private static IList<IWebElement> rayonOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchPersonContent + "Search_ddlSearchidfsRayon']/option")); } }
            private static By txtDateOfBirth = By.Id(CommonCtrls.SearchPersonContent + "txtdatDateofBirth");
            private static By btnAddPerson = By.Id(CommonCtrls.SearchPersonContent + "btnAddPerson");
            private static By btnSearch = By.Id(CommonCtrls.SearchPersonContent + "btnSearch");
            private static By btnClear = By.Id(CommonCtrls.SearchPersonContent + "btnClear");
            private static By btnCancel = By.Id("btnCancel");


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
                        else if (Driver.Instance.FindElements(srchBetaParameterFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(srchBetaParameterFormTitle).Text.Contains("Search Parameters") &&
                                    Driver.Instance.FindElement(srchBetaParameterFormTitle).Displayed)
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

            public static void clickAddPersonBtn()
            {
                SetMethods.clickObjectButtons(btnAddPerson);
            }

            public static void randomEnterDateEnteredFrom(String value)
            {
                SetMethods.enterObjectValue(txtDateOfBirth, value);
            }
        }


        public class SearchResults
        {
            private static By srchResultsFormTitle = By.XPath("//*[@id='hdrSearchResults']");
            private static By searchGridTable = By.Id(CommonCtrls.SearchPersonContent + "gvHumanMaster");
            private static IList<IWebElement> personList { get { return Driver.Instance.FindElements(By.TagName("a")); } }
            private static By linkPersonInGrid = By.XPath("//*[@id='" + CommonCtrls.SearchPersonContent + "gvHumanMaster_btnViewHumanMaster_0']");
            private static IList<IWebElement> linkPersonsInGrid { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[1]/div[10]/div[1]/div[2]/div[3]/div[1]/div[1]/div[2]/div[1]/div[1]/table[1]/tbody[1]/tr/td[1]/a[1]")); } }
            //*[@id="EIDSSBodyCPH_ucSearchPerson_gvPeople_btnSelect_0"]
            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    Thread.Sleep(2000);
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, -500)", "");
                    Thread.Sleep(200);
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

            public static void randomSelectPerson()
            {
                IList<IWebElement> links = linkPersonsInGrid;
                Driver.Wait(TimeSpan.FromMinutes(20));
                foreach (var link in links)
                {
                    link.Click();
                    Driver.Wait(TimeSpan.FromMinutes(20));
                    break;
                }
            }

            public static void randomSelectPersonFromGrid()
            {
                SetMethods.randomSelectObjectElement(searchGridTable, linkPersonsInGrid);
            }

            public static void selectFirstRowPersonFromGrid()
            {
                SetMethods.randomSelectObjectElement(searchGridTable, linkPersonsInGrid);
            }

            private static void getSearchResultsValue(By element, String value)
            {
                try
                {
                    IWebElement table = Driver.Instance.FindElement(element);
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
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail(value + " does not exist in the table.");
                }
            }

            public static void getSrchResultValue(string value)
            {
                getSearchResultsValue(searchGridTable, value);
            }

        }
    }
}