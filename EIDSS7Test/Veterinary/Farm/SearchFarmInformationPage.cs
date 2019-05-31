using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;
using OpenQA.Selenium.Interactions;

namespace EIDSS7Test.Veterinary.Farm
{
    public class SearchFarmInformationPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();
        public static string farmNM;
        public static string farmID;

        private static By HeaderFormTitle = By.TagName("h1");
        private static By titleFormTitle = By.TagName("h2");
        private static By srchByFarmFormTitle = By.TagName("h3");
        private static By srchResultsFarmFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "divSearchResultsContainer']/div[1]/div[1]/div[1]/div[1]/h3");
        private static By btnReturnToDashboard = By.LinkText("Return to Dashboard");
        private static By btnSearch = By.Id(CommonCtrls.SearchFarmContent + "btnSearch");
        private static By btnFarmSearch = By.Id(CommonCtrls.SearchFarmContent + "btnSearch");
        private static By btnEditSearch = By.Id(CommonCtrls.GeneralContent + "btnEditSearch");
        private static By btnNewSearch = By.Id(CommonCtrls.GeneralContent + "btnNewSearch");
        private static By btnNewFarm = By.Id(CommonCtrls.SearchFarmContent + "btnAddFarm");
        private static By btnClear = By.Id(CommonCtrls.SearchFarmContent + "btnClear");
        private static By btnCancel = By.XPath("/html/body/form/div[3]/div/div[2]/div/div[1]/div/div[2]/div/div[2]/div/button");
        private static By btnReturnToDash = By.LinkText("Return to Dashboard");
        private static By linkLivestockRecord = By.Id(CommonCtrls.SearchFarmContent + "gvFarms_btnEdit_3");
        private static By linkAvianRecord = By.Id(CommonCtrls.SearchFarmContent + "gvFarms_btnEdit_3");

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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Farm") &&
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

        public class SearchCriteria
        {
            private static By txtFarmID = By.Id(CommonCtrls.SearchFarmContent + "txtEIDSSFarmID");
            private static By txtFarmName = By.Id(CommonCtrls.SearchFarmContent + "txtFarmName");
            private static By chkAvianFarmType = By.Id(CommonCtrls.SearchFarmContent + "cbxFarmTypeID_0");
            private static By chkLivestockFarmType = By.Id(CommonCtrls.SearchFarmContent + "cbxFarmTypeID_1");
            private static By txtFirstName = By.Id(CommonCtrls.SearchFarmContent + "txtFarmOwnerFirstName");
            private static By txtLastName = By.Id(CommonCtrls.SearchFarmContent + "txtFarmOwnerLastName");
            private static By txtFarmOwnerID = By.Id(CommonCtrls.SearchFarmContent + "txtEIDSSPersonID");
            private static By ddlSearchRegion = By.Id(CommonCtrls.SearchFarmLocContent + "ddlidfsRegion");
            private static IList<IWebElement> srchRegOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchFarmLocContent + "ddlidfsRegion']/option")); } }
            private static By ddlSearchRayon = By.Id(CommonCtrls.SearchFarmLocContent + "ddlidfsRayon");
            private static IList<IWebElement> srchRayOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchFarmLocContent + "ddlidfsRayon']/option")); } }
            private static By ddlSearchTownVillage = By.Id(CommonCtrls.SearchFarmLocContent + "ddlidfsSettlement");
            private static IList<IWebElement> srchTownVillOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchFarmLocContent + "ddlidfsSettlement']/option")); } }


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
                                if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Search Criteria") &&
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


            private static void selectFarmType(By farmType)
            {
                try
                {
                    var element = wait.Until(ExpectedConditions.ElementToBeClickable(farmType));
                    element.Click();
                    Driver.Wait(TimeSpan.FromMinutes(5));
                }
                catch
                {
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", farmType);
                    var element = wait.Until(ExpectedConditions.ElementToBeClickable(farmType));
                    element.Click();
                    Driver.Wait(TimeSpan.FromMinutes(5));
                }
            }

            public static void enterFarmID()
            {
                SetMethods.enterObjectValue(txtFarmID, farmID);
            }

            public static void enterFarmName()
            {
                SetMethods.enterObjectValue(txtFarmName, farmNM);
            }

            public static void enterOwnerFirstName(string ownerNM)
            {
                SetMethods.enterObjectValue(txtFirstName, ownerNM);
            }

            public static void enterOwnerLastName(string ownerNM)
            {
                SetMethods.enterObjectValue(txtLastName, ownerNM);
            }

            public static void enterOwnerFarmID(string ownerNM)
            {
                SetMethods.enterObjectValue(txtFarmOwnerID, ownerNM);
            }

            public static void selectAvianFarmType()
            {
                selectFarmType(chkAvianFarmType);
            }

            public static void selectLivestockFarmType()
            {
                selectFarmType(chkLivestockFarmType);
            }

            public static void randomSelectRegion()
            {
                SetMethods.randomSelectObjectElement(ddlSearchRegion, srchRegOptions);
            }

            public static void randomSelectRayon()
            {
                SetMethods.randomSelectObjectElement(ddlSearchRayon, srchRayOptions);
            }

            public static void randomSelectTownOrVillage()
            {
                SetMethods.randomSelectObjectElement(ddlSearchTownVillage, srchTownVillOptions);
            }
        }

        public static void clickSearchBtn()
        {
            SetMethods.clickObjectButtons(btnSearch);
        }

        public static void clickFarmSearchBtn()
        {
            SetMethods.clickObjectButtons(btnFarmSearch);
        }

        public static void clickNewSearchBtn()
        {
            SetMethods.clickObjectButtons(btnNewSearch);
        }

        public static void clickCancelBtn()
        {
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clickClearBtn()
        {
            SetMethods.clickObjectButtons(btnClear);
        }

        public static void clickReturnToDashboardBtn()
        {
            SetMethods.clickObjectButtons(btnReturnToDash);
        }

        public static void clickCreateNewFarmRecordBtn()
        {
            SetMethods.clickObjectButtons(btnNewFarm);
        }

        public static void clickEditSearchBtn()
        {
            SetMethods.clickObjectButtons(btnEditSearch);
        }

        public class SearchResults
        {
            private static By titleFormTitle = By.Id("hdrSearchResults");
            private static List<IWebElement> allEditButton = new List<IWebElement>(Driver.Instance.FindElements(By.XPath("//div/a[contains(@class,'glyphicon glyphicon-edit')]")));
            private static IList<IWebElement> allEditButtons { get { return Driver.Instance.FindElements(By.XPath("//*[contains(@class,'glyphicon glyphicon-edit')]")); } }
            private static IList<IWebElement> allDeleteButtons { get { return Driver.Instance.FindElements(By.XPath("//div/a[contains(@class,'glyphicon glyphicon-trash')]")); } }
            private static By tlbResultsTable = By.XPath("//*[@id='" + CommonCtrls.SearchFormContent + "gvFarms']");
            private static By tlbFarmResultTable = By.Id(CommonCtrls.SearchFarmContent + "gvFarms");

            public static bool IsAt
            {
                get
                {
                    try
                    {
                        Driver.Instance.WaitForPageToLoad();
                        //Scroll to bottom of the page
                        //((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 700)", "");
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
                                Driver.Wait(TimeSpan.FromMinutes(15));
                                if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Search Results") &&
                                    Driver.Instance.FindElement(titleFormTitle).Displayed)
                                    return true;
                                else
                                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                    Assert.Fail("This is not the correct title");
                                return false;
                            }
                        }
                    }
                    catch
                    {
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                    }
                    return false;
                }
            }

            public static void randomSelectFromFarmResults()
            {
                SetMethods.SelectRandomOptionFromDropdown(allEditButtons);
            }

            public static void selectAvianRecord()
            {
                SetMethods.clickObjectButtons(linkAvianRecord);
            }

            public static void selectLivestockRecord()
            {
                SetMethods.clickObjectButtons(linkLivestockRecord);
            }

            public static void selectFarmRecord(String value)
            {
                var table = tlbResultsTable;
                IList<IWebElement> rows = Driver.Instance.FindElements(By.TagName("tr"));
                Driver.Wait(TimeSpan.FromMinutes(30));
                foreach (var row in rows)
                {
                    if (row.Text.Contains(value))
                    {
                        IList<IWebElement> cols = row.FindElements(By.TagName("td"));
                        Driver.Wait(TimeSpan.FromMinutes(30));
                        foreach (var col in cols)
                        {
                            IList<IWebElement> edits = allEditButtons;
                            Driver.Wait(TimeSpan.FromMinutes(30));
                            foreach (var edit in edits)
                            {
                                edit.Click();
                                break;
                            }
                            break;
                        }
                    }
                }
            }

            public static void randomDeleteFromFarmResults()
            {
                SetMethods.randomSelectObjectElement(tlbFarmResultTable, allDeleteButtons);
            }

            public static void editFarmRecord()
            {
                IList<IWebElement> rows = Driver.Instance.FindElements(By.TagName("tr"));
                Driver.Wait(TimeSpan.FromMinutes(1000));
                foreach (var edit in allEditButtons)
                {
                    edit.Click();
                    Driver.Wait(TimeSpan.FromMinutes(15));
                    break;
                }
            }
        }

        public class FarmRecordReview
        {
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
                    else if (Driver.Instance.FindElements(titleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Farm Review") &&
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


            public class VeterinaryDiseaseRptsSection
            {
                private static By titleFormTitle = By.TagName("h3");
                private static By btnAddAvianDiseaseRpt = By.Id(CommonCtrls.GeneralContent + "btnAddAvianVeterinaryDiseaseReport");
                private static By btnAddLivestockDiseaseRpt = By.Id(CommonCtrls.GeneralContent + "btnAddLivestockDiseaseReport");


                public static bool IsAt
                {
                    get
                    {
                        //Scroll 1/2 way to the bottom of the page
                        ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 250)", "");
                        if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                            || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                        {
                            Assert.Fail("Page cannot be displayed");
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            return false;
                        }
                        else if (Driver.Instance.FindElements(titleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(15));
                                if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Veterinary Disease Reports") &&
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

                public static void clickAddAvianDiseaseRpt()
                {
                    SetMethods.clickObjectButtons(btnAddAvianDiseaseRpt);
                }

                public static void clickAddLivestockDiseaseRpt()
                {
                    SetMethods.clickObjectButtons(btnAddLivestockDiseaseRpt);
                }
            }

            public class LaboratoryTestSamplesSection
            {
                private static By titleFormTitle = By.TagName("h3");
                private static By btnAddLabTestSample = By.Id(CommonCtrls.GeneralContent + "btnAddLaboratoryTestSample");

                public static bool IsAt
                {
                    get
                    {
                        //Scroll to the bottom of the page
                        ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 500)", "");
                        if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                            || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                        {
                            Assert.Fail("Page cannot be displayed");
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            return false;
                        }
                        else if (Driver.Instance.FindElements(srchByFarmFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(15));
                                if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Laboratory Test Samples") &&
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

                public static void clickAddLabTestSample()
                {
                    SetMethods.clickObjectButtons(btnAddLabTestSample);
                }
            }
        }

        public class OutbreakSearchFarm
        {
            private static By titleFormTitle = By.XPath("//*[@id='hdgSearchFarm']");
            private static By srchByFarmFormTitle = By.TagName("h3");
            private static By srchResultsFarmFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "divSearchResultsContainer']/div[1]/div[1]/div[1]/div[1]/h3");
            private static By btnReturnToDashboard = By.LinkText("Return to Dashboard");
            private static By btnSearch = By.Id(CommonCtrls.SearchFarmContent + "btnSearch");
            private static By btnClear = By.Id(CommonCtrls.SearchFarmContent + "btnClear");
            private static By btnCancel = By.XPath("/html/body/form/div[3]/div/div[2]/div/div[1]/div/div[2]/div/div[2]/div/button");
            private static By linkLivestockRecord = By.Id(CommonCtrls.SearchFarmContent + "gvFarms_btnEdit_3");
            private static By linkAvianRecord = By.Id(CommonCtrls.SearchFarmContent + "gvFarms_btnEdit_3");

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
                                if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Search Farm") &&
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

            public class SearchCriteria
            {
                private static By txtFarmID = By.Id(CommonCtrls.SrchOutbreakFarmContent + "txtEIDSSFarmID");
                private static By txtFarmName = By.Id(CommonCtrls.SrchOutbreakFarmContent + "txtFarmName");
                private static By chkAvianFarmType = By.Id(CommonCtrls.SrchOutbreakFarmContent + "cbxFarmTypeID_0");
                private static By chkLivestockFarmType = By.Id(CommonCtrls.SrchOutbreakFarmContent + "cbxFarmTypeID_1");
                private static By txtFirstName = By.Id(CommonCtrls.SrchOutbreakFarmContent + "txtFarmOwnerFirstName");
                private static By txtLastName = By.Id(CommonCtrls.SrchOutbreakFarmContent + "txtFarmOwnerLastName");
                private static By txtFarmOwnerID = By.Id(CommonCtrls.SrchOutbreakFarmContent + "txtEIDSSPersonID");
                private static By ddlSearchRegion = By.Id(CommonCtrls.SrchOutbrLocFarmContent + "ddlidfsRegion");
                private static IList<IWebElement> srchRegOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SrchOutbrLocFarmContent + "ddlidfsRegion']/option")); } }
                private static By ddlSearchRayon = By.Id(CommonCtrls.SrchOutbrLocFarmContent + "ddlidfsRayon");
                private static IList<IWebElement> srchRayOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SrchOutbrLocFarmContent + "ddlidfsRayon']/option")); } }
                private static By ddlSettleType = By.Id(CommonCtrls.SrchOutbrLocFarmContent + "ddlSettlementType");
                private static IList<IWebElement> settleTypeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SrchOutbrLocFarmContent + "ddlSettlementType']/option")); } }
                private static By ddlSearchSettlement = By.Id(CommonCtrls.SrchOutbrLocFarmContent + "ddlidfsSettlement");
                private static IList<IWebElement> srchSettleOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SrchOutbrLocFarmContent + "ddlidfsSettlement']/option")); } }
                private static By btnSearch = By.Id(CommonCtrls.SrchOutbreakFarmContent + "btnSearch");
                private static By btnClear = By.Id(CommonCtrls.SrchOutbreakFarmContent + "btnClear");
                private static By btnCancel = By.Id(CommonCtrls.SrchOutbreakFarmContent + "btnCancelSearchCriteria");

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
                                    if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Search Criteria") &&
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

                public static void clickSearch()
                {
                    SetMethods.clickObjectButtons(btnSearch);
                }

                public static void clickCancel()
                {
                    SetMethods.clickObjectButtons(btnCancel);
                }

                public static void clickClear()
                {
                    SetMethods.clickObjectButtons(btnClear);
                }

                private static void selectFarmType(By farmType)
                {
                    try
                    {
                        var element = wait.Until(ExpectedConditions.ElementToBeClickable(farmType));
                        element.Click();
                        Driver.Wait(TimeSpan.FromMinutes(5));
                    }
                    catch
                    {
                        ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", farmType);
                        var element = wait.Until(ExpectedConditions.ElementToBeClickable(farmType));
                        element.Click();
                        Driver.Wait(TimeSpan.FromMinutes(5));
                    }
                }

                public static void enterFarmID()
                {
                    SetMethods.enterObjectValue(txtFarmID, farmID);
                }

                public static void enterFarmName()
                {
                    SetMethods.enterObjectValue(txtFarmName, farmNM);
                }

                public static void enterOwnerFirstName(string ownerNM)
                {
                    SetMethods.enterObjectValue(txtFirstName, ownerNM);
                }

                public static void enterOwnerLastName(string ownerNM)
                {
                    SetMethods.enterObjectValue(txtLastName, ownerNM);
                }

                public static void enterOwnerFarmID(string ownerNM)
                {
                    SetMethods.enterObjectValue(txtFarmOwnerID, ownerNM);
                }

                public static void selectAvianFarmType()
                {
                    selectFarmType(chkAvianFarmType);
                }

                public static void selectLivestockFarmType()
                {
                    selectFarmType(chkLivestockFarmType);
                }

                public static void randomSelectRegion()
                {
                    SetMethods.randomSelectObjectElement(ddlSearchRegion, srchRegOptions);
                }

                public static void randomSelectRayon()
                {
                    SetMethods.randomSelectObjectElement(ddlSearchRayon, srchRayOptions);
                }

                public static void randomSelectSettlement()
                {
                    SetMethods.randomSelectObjectElement(ddlSearchSettlement, srchSettleOptions);
                }
            }

            public class SearchResults
            {
                private static By titleFormTitle = By.XPath("/html[1]/body[1]/form[1]/div[3]/div[1]/div[11]/div[1]/div[2]/div[3]/div[1]/div[1]/div[1]/div[1]/div[1]/h3[1]");
                private static List<IWebElement> allEditButton = new List<IWebElement>(Driver.Instance.FindElements(By.XPath("//div/a[contains(@class,'glyphicon glyphicon-edit')]")));
                private static IList<IWebElement> allEditButtons { get { return Driver.Instance.FindElements(By.XPath("//*[contains(@class,'glyphicon glyphicon-edit')]")); } }
                private static IList<IWebElement> allFarmIDLinks { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[1]/div[11]/div[1]/div[2]/div[3]/div[1]/div[1]/div[2]/div[1]/div[1]/table[1]/tbody[1]/tr/td[1]/a[1]")); } }
                private static By tlbResultsTable = By.XPath("//*[@id='" + CommonCtrls.SrchOutbreakFarmContent + "gvFarms']");

                public static bool IsAt
                {
                    get
                    {
                        try
                        {
                            Driver.Instance.WaitForPageToLoad();
                            //Scroll to bottom of the page
                            //((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 700)", "");
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
                                    Driver.Wait(TimeSpan.FromMinutes(15));
                                    if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Search Results") &&
                                        Driver.Instance.FindElement(titleFormTitle).Displayed)
                                        return true;
                                    else
                                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                        Assert.Fail("This is not the correct title");
                                    return false;
                                }
                            }
                        }
                        catch
                        {
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("Page cannot be displayed");
                        }
                        return false;
                    }
                }

                public static void randomEditFromFarmResults()
                {
                    SetMethods.SelectRandomOptionFromDropdown(allEditButtons);
                }

                public static void selectAvianRecord()
                {
                    SetMethods.clickObjectButtons(linkAvianRecord);
                }

                public static void selectLivestockRecord()
                {
                    SetMethods.clickObjectButtons(linkLivestockRecord);
                }

                public static void selectFarmRecord(String value)
                {
                    var table = tlbResultsTable;
                    IList<IWebElement> rows = Driver.Instance.FindElements(By.TagName("tr"));
                    Driver.Wait(TimeSpan.FromMinutes(30));
                    foreach (var row in rows)
                    {
                        if (row.Text.Contains(value))
                        {
                            IList<IWebElement> cols = row.FindElements(By.TagName("td"));
                            Driver.Wait(TimeSpan.FromMinutes(30));
                            foreach (var col in cols)
                            {
                                IList<IWebElement> edits = allEditButtons;
                                Driver.Wait(TimeSpan.FromMinutes(30));
                                foreach (var edit in edits)
                                {
                                    edit.Click();
                                    break;
                                }
                                break;
                            }
                        }
                    }
                }

                public static void randomSelectFromFarmResults()
                {
                    SetMethods.randomSelectObjectElement(tlbResultsTable, allFarmIDLinks);
                }

                public static void editFarmRecord()
                {
                    IList<IWebElement> rows = Driver.Instance.FindElements(By.TagName("tr"));
                    Driver.Wait(TimeSpan.FromMinutes(1000));
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
}