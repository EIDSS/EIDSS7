using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using System.Threading;
using EIDSS7Test.Common;
using NUnit.Framework;

namespace EIDSS7Test.HumanCases.SearchPersons
{
    public class SearchPersonDiseaseReportPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();
        public static List<String> suffixes = new List<String> { "Mr.", "Mrs.", "Miss", "Jr.", "Sr." };
        public static string eidssNumber;
        public static string eidssPerNumber;
        public static string personFirstName;
        public static string personLastName;
        public static int personAge;

        private static By HeaderFormTitle = By.TagName("h1");
        private static By titleFormTitle = By.TagName("h2");
        private static By srchParmsFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "parametersHeading']");
        private static By srchFormTitle = By.Id(CommonCtrls.GeneralContent + "hdgSearch");
        private static By srchCriteriaFormTitle = By.Id(CommonCtrls.SearchPersonContent + "hdgSearchCriteria");
        private static By txtEIDSSIdNumber = By.Id(CommonCtrls.GeneralContent + "txtEIDSSIDNumber");
        private static By ddlPersonalIDType = By.Id(CommonCtrls.GeneralContent + "ddlPersonalIDType");
        private static IList<IWebElement> personalIDOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlPersonalIDType']/option")); } }
        private static By txtPersonalID = By.Id(CommonCtrls.GeneralContent + "txtPersonalID");
        private static By txtFirstName = By.Id(CommonCtrls.GeneralContent + "txtFirstName");
        private static By txtMiddleInit = By.Id(CommonCtrls.GeneralContent + "txtMiddleInit");
        private static By txtLastName = By.Id(CommonCtrls.GeneralContent + "txtLastName");
        private static By txtSuffix = By.Id(CommonCtrls.GeneralContent + "txtSuffix");
        private static By datDateOfBirth = By.Id(CommonCtrls.GeneralContent + "txtdatDoB");
        private static By ddlGender = By.Id(CommonCtrls.GeneralContent + "ddlGender");
        private static IList<IWebElement> genderOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlGender']/option")); } }

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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Search Disease Reports") &&
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

        public static void clickReturnToDash()
        {
            SetMethods.clickObjectButtons(btnReturnToDashboard);
        }

        public static void clickCreateNewPersonRecord()
        {
            SetMethods.clickObjectButtons(btnAddNewPerson);
        }

        public static void clickNewSearch()
        {
            SetMethods.clickObjectButtons(btnNewSearch);
        }

        public static void clickCancel()
        {
            SetMethods.clickObjectButtons(btnCancel);
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
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
                    }
                }
            }

            public static String enterRandomEIDSSIDNumber(string eidss)
            {
                try
                {
                    int rNum = rnd.Next(1000, 10000000);
                    eidssNumber = eidss + rNum;
                    SetMethods.enterObjectValue(txtEIDSSIdNumber, eidssNumber);
                    return eidssNumber;
                }
                catch
                {
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", txtEIDSSIdNumber);
                    int rNum = rnd.Next(1000, 10000000);
                    eidssNumber = eidss + rNum;
                    SetMethods.enterObjectValue(txtEIDSSIdNumber, eidssNumber);
                    return eidssNumber;
                }
            }

            public static String enterEIDSSIDNumber(string eidss)
            {
                SetMethods.enterStringObjectValue(txtEIDSSIdNumber, eidss);
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


            public static String randomEnterPersonalIDNumber(string eidss)
            {
                int rNum = rnd.Next(1000, 10000000);
                eidssPerNumber = eidss + rNum;
                SetMethods.enterObjectValue(txtPersonalID, eidssPerNumber);
                return eidssPerNumber;
            }

            public static String enterPersonFirstName(string fName)
            {
                int rNum = rnd.Next(1000, 10000000);
                personFirstName = fName + rNum;
                SetMethods.enterObjectValue(txtFirstName, personFirstName);
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
                try
                {
                    var female = wait.Until(ExpectedConditions.ElementIsVisible(ddlGender));
                    female.Click();

                    Driver.Wait(TimeSpan.FromMinutes(10));
                    foreach (var gender in genderOptions)
                    {
                        if (gender.Text.Contains(sex))
                        {
                            gender.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                        }
                    }
                }
                catch
                {
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", ddlGender);
                    var female = wait.Until(ExpectedConditions.ElementIsVisible(ddlGender));
                    female.Click();

                    Driver.Wait(TimeSpan.FromMinutes(10));
                    foreach (var gender in genderOptions)
                    {
                        if (gender.Text.Contains(sex))
                        {
                            gender.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                        }
                    }
                }
            }


        }


        public class SearchParameters
        {
            private static By btnEditSearch = By.Id(CommonCtrls.GeneralContent + "btnEditSearch");

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
                        else if (Driver.Instance.FindElements(srchParmsFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(srchParmsFormTitle).Text.Contains("Search Parameters") &&
                                    Driver.Instance.FindElement(srchParmsFormTitle).Displayed)
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
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
                    }
                }
            }
        }

        public class SearchResults
        {
            private static By srchResultsFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "searchResults']/div[1]/div[1]/div/div[1]/h3");
            private static By searchGridTable = By.Id(CommonCtrls.GeneralContent + "gvPeople");
            private static IList<IWebElement> personList { get { return Driver.Instance.FindElements(By.TagName("a")); } }


            public static bool IsAt
            {
                get
                {
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, -500)", "");
                    Thread.Sleep(200);
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(srchResultsFormTitle).Count > 0)
                    {
                        if (Driver.Instance.FindElement(srchResultsFormTitle).Text.Contains("Search Results") &&
                            Driver.Instance.FindElement(srchResultsFormTitle).Displayed)
                            return true;
                        else
                            Assert.Fail();
                        return false;
                    }
                    else
                    {
                        return false;
                    }
                }
            }

            public static void randomSelectPersonFromGrid()
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 700)", "");
                Driver.Wait(TimeSpan.FromMinutes(20));

                //FOR FIREFOX - Need to search for table again
                var table = searchGridTable;
                IList<IWebElement> links = personList;
                Driver.Wait(TimeSpan.FromMinutes(20));

                foreach (var link in links)
                {
                    link.Click();
                    Driver.Wait(TimeSpan.FromMinutes(20));
                    break;
                }
            }
        }
    }
}