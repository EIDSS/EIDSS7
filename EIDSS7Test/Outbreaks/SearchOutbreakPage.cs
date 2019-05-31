using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using System.Threading;
using EIDSS7Test.Common;
using NUnit.Framework;

namespace EIDSS7Test.Outbreaks
{
    public class SearchOutbreakPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();
        public static String sessionID;
        public static String outbreakID;

        private static By titleFormTitle = By.TagName("h2");
        private static By tblOutbreakList = By.Id(CommonCtrls.GeneralContent + "gvOutbreaks");
        private static IList<IWebElement> linksOutbreaks { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[1]/div[1]/div[1]/div[1]/div[2]/div[1]/div[3]/table[1]/tbody[1]/tr/td[1]/a[1]")); } }
        ///html[1]/body[1]/form[1]/div[3]/div[1]/div[1]/div[1]/div[1]/div[1]/div[2]/div[1]/div[3]/table[1]/tbody[1]/tr/td[1]/a[1]  GG
        ///html[1]/body[1]/form[1]/div[3]/div[1]/div[1]/div[1]/div[1]/div[1]/div[2]/div[3]/table[1]/tbody[1]/tr[1]/td[1]/a[1]  AM

        private static IList<IWebElement> btnEdits { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-edit']")); } }
        private static IList<IWebElement> btnDeletes { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-trash']")); } }
        private static By btnAdd = By.Id(CommonCtrls.GeneralContent + "btnCreate");
        private static By btnClear = By.Id(CommonCtrls.GeneralContent + "btnClear");
        private static By btnSearch = By.Id(CommonCtrls.GeneralContent + "btnSearchList");
        private static By btnAdvanceSearch = By.Id(CommonCtrls.GeneralContent + "btnAdvanceSearch");

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
                        Driver.Wait(TimeSpan.FromMinutes(15));
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Outbreak Management List") &&
                            Driver.Instance.FindElement(titleFormTitle).Displayed)
                            return true;
                        else
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
                    }
                }
                else
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

        public static void clickAdvancedSearch()
        {
            SetMethods.clickObjectButtons(btnAdvanceSearch);
        }

        public static void clickClear()
        {
            SetMethods.clickObjectButtons(btnClear);
        }

        public static void clickCreateOutbreak()
        {
            SetMethods.clickObjectButtons(btnAdd);
        }

        public static void randomDeleteOutbreak()
        {
            SetMethods.randomSelectObjectElement(tblOutbreakList, btnDeletes);
        }

        public static void randomEditOutbreak()
        {
            SetMethods.randomSelectObjectElement(tblOutbreakList, btnEdits);
        }

        public class SearchOutbreak
        {
            private static By titleFormTitle = By.TagName("h2");

            public static bool IsAt
            {
                get
                {
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
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Search Outbreak") &&
                                Driver.Instance.FindElement(titleFormTitle).Displayed)
                                return true;
                            else
                                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                            return false;
                        }
                    }
                    else
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
                    }
                }
            }


            public class Search
            {
                private static By searchSection = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "searchForm']/div/div[1]/div[1]/h3");
                private static By OutbreakID = By.Id(CommonCtrls.GeneralContent + "sftxtstrOutbreakID");
                private static By ddlOutbreakType = By.Id(CommonCtrls.GeneralContent + "sfddlOutbreakTypeID");
                private static IList<IWebElement> outTypeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "sfddlOutbreakTypeID']/option")); } }
                private static By ddlDiagnosesGroup = By.Id(CommonCtrls.GeneralContent + "sfddlSearchDiagnosesGroup");
                private static IList<IWebElement> diagGrpOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "sfddlSearchDiagnosesGroup']/option")); } }
                private static By ddlRegion = By.Id(CommonCtrls.LocationSrchContent + "ddlsflucSearchidfsRegion");
                private static IList<IWebElement> regionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationSrchContent + "ddlsflucSearchidfsRegion']/option")); } }
                private static By ddlRayon = By.Id(CommonCtrls.LocationSrchContent + "ddlsflucSearchidfsRayon");
                private static IList<IWebElement> rayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationSrchContent + "ddlsflucSearchidfsRayon']/option")); } }
                private static By datStartDateFrom = By.Id(CommonCtrls.GeneralContent + "sftxtStartDateFrom");
                private static By datStartDateTo = By.Id(CommonCtrls.GeneralContent + "sftxtStartDateTo");
                private static By ddlOutTypeStat = By.Id(CommonCtrls.GeneralContent + "sfddlidfsOutbreakStatus");
                private static IList<IWebElement> outTypeStatOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "sfddlidfsOutbreakStatus']/option")); } }


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
                        else if (Driver.Instance.FindElement(searchSection).Text.Contains("Error:"))
                        {
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                            return false;
                        }
                        else if (Driver.Instance.FindElements(searchSection).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(15));
                                if (Driver.Instance.FindElement(searchSection).Text.Contains("Search") &&
                                    Driver.Instance.FindElement(searchSection).Displayed)
                                    return true;
                                else
                                    return false;
                            }
                        }
                        else
                        {
                            return false;
                        }
                    }
                }

                public static void randomSelectDiagnosis()
                {
                    SetMethods.randomSelectObjectElement(ddlDiagnosesGroup, diagGrpOptions);
                }

                public static void randomSelectDiagnosesGrp()
                {
                    SetMethods.randomSelectObjectElement(ddlDiagnosesGroup, diagGrpOptions);
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

                public static void randomSelectRegion()
                {
                    SetMethods.randomSelectObjectElement(ddlRegion, regionOptions);
                }

                public static void randomSelectRayon()
                {
                    SetMethods.randomSelectObjectElement(ddlRayon, rayonOptions);
                }

                public static void enterStartDateFrom()
                {
                    SetMethods.enterCurrentDate(datStartDateFrom);
                }

                public static void enterStartDateTo()
                {
                    SetMethods.enterCurrentDate(datStartDateTo);
                }


                public static void randomSelectOutbreakStatus()
                {
                    SetMethods.randomSelectObjectElement(ddlOutTypeStat, outTypeOptions);
                }
            }


            //public static void enterRandomPatient(String patName)
            //{
            //    Random rnd = new Random();
            //    int rNum = rnd.Next(1000, 99999999);
            //    SetMethods.enterIntObjectValue(txtPatient, rNum);
            //}

            //public static void enterRandomFarmOwner(String farmName)
            //{
            //    Random rnd = new Random();
            //    int rNum = rnd.Next(1000, 99999999);
            //    farmName = farmName + rNum;
            //    SetMethods.enterObjectValue(txtFarmOwner, farmName);
            //}


            public class SearchCriteria
            {
                private static By searchCritSection = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "searchForm']/div/div[1]/div[1]/h3");
                private static By btnEditSearch = By.Id(CommonCtrls.GeneralContent + "btnEditSearch");
                private static By btnCreateOutbreak = By.Id(CommonCtrls.GeneralContent + "btnCreate");
                private static By btnAdd = By.Id(CommonCtrls.GeneralContent + "btnAdd");
                private static By btnReturnToDash = By.LinkText("Return to Dashboard");
                private static By btnSearch = By.Id(CommonCtrls.GeneralContent + "btnSearchList");
                private static By btnNewSearch = By.Id(CommonCtrls.GeneralContent + "btnNewSearch");
                private static By tlbOutreakTable = By.Id(CommonCtrls.GeneralContent + "gvOutbreaks");
                private static By ddlOutbreakType = By.Id(CommonCtrls.GeneralContent + "sfddlOutbreakTypeID");
                private static IList<IWebElement> outTypeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "sfddlOutbreakTypeID']/option")); } }
                private static By ddlStatus = By.Id(CommonCtrls.GeneralContent + "sfddlidfsOutbreakStatus");
                private static IList<IWebElement> statOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "sfddlidfsOutbreakStatus']/option")); } }
                private static IList<IWebElement> AllOutreakSessLinks { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[1]/div[1]/div[1]/div[1]/div[3]/div[1]/div[1]/table[1]/tbody[1]/tr/td[1]/a[1]")); } }


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
                        else if (Driver.Instance.FindElements(searchCritSection).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(searchCritSection).Text.Contains("Search Criteria") &&
                                    Driver.Instance.FindElement(searchCritSection).Displayed)
                                    return true;
                                else
                                    return false;
                            }
                        }
                        else
                        {
                            return false;
                        }
                    }
                }

                public static void clickSearch()
                {
                    SetMethods.clickObjectButtons(btnSearch);
                }

                public static void clickEditSearch()
                {
                    SetMethods.clickObjectButtons(btnEditSearch);
                }

                public static void clickCreateOutbreak()
                {
                    SetMethods.clickObjectButtons(btnCreateOutbreak);
                }

                public static void clickReturnToDash()
                {
                    SetMethods.clickObjectButtons(btnReturnToDash);
                }

                public static void clickNewSearch()
                {
                    SetMethods.clickObjectButtons(btnNewSearch);
                }

                public static void randomSelectOutbreakType()
                {
                    SetMethods.randomSelectObjectElement(ddlOutbreakType, outTypeOptions);
                }

                public static void enterOutbreakType(String value)
                {
                    SetMethods.enterObjectValue(ddlOutbreakType, value);
                }

                public static void randomSelectOutbreakStatus()
                {
                    SetMethods.randomSelectObjectElement(ddlStatus, statOptions);
                }

                public static void enterOutbreakStatus(String value)
                {
                    SetMethods.enterObjectValue(ddlStatus, value);
                }

                public static void randomSelectOutbreakSessionID()
                {
                    SetMethods.randomSelectObjectElement(tlbOutreakTable, AllOutreakSessLinks);
                }
            }

            public class SearchResults
            {
                private static By searchResultsSection = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "searchResults']/div/div[2]/div[1]/h3");
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
                        else if (Driver.Instance.FindElements(searchResultsSection).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(searchResultsSection).Text.Contains("Search Results") &&
                                    Driver.Instance.FindElement(searchResultsSection).Displayed)
                                    return true;
                                else
                                    return false;
                            }
                        }
                        else
                        {
                            return false;
                        }
                    }
                }
            }
        }

        public static void randomSelectOutbreakFromList()
        {
            SetMethods.randomSelectObjectElement(tblOutbreakList, linksOutbreaks);
        }
    }
}