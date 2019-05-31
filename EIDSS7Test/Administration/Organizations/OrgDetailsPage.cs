using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using System.Threading;
using NUnit.Framework;

namespace EIDSS7Test.Administration.Organizations
{
    public class OrgDetailsPage
    {
        public static String orgName;
        public static string orgUniqueID;
        public static String abbrvName;
        public static string errorString;
        public static Random rnd = new Random();
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(1000));
        private static By titleFormTitle = By.TagName("h2");
        private static By HeaderFormTitle = By.TagName("h1");
        private static By departmentSubTitle = By.XPath("/html/body/form/div[3]/div/div[2]/div/div/div[2]/div/div[1]/div[1]/section[2]/div/div[1]/div/div[1]/h3");
        private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancel");
        private static By btnContinue = By.Id("btnNextSection");
        private static By btnBack = By.Id("btnPreviousSection");
        private static By linkReview = By.LinkText("Review");
        private static By linkDepartments = By.LinkText("Departments");
        private static By linkOrgInfo = By.LinkText("Organization Info");
        private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmit");
        private static By accessCodeErrorMsg = By.Id(CommonCtrls.GeneralContent + "ctl16");
        private static By orgFullNameErrorMsg = By.Id(CommonCtrls.GeneralContent + "ctl13");
        private static By orgAbbrErrorMsg = By.Id(CommonCtrls.GeneralContent + "ctl10");
        private static By regionErrorMsg = By.Id(CommonCtrls.LocUsrDetailsContent + "ctl05");
        private static By rayonErrorMsg = By.Id(CommonCtrls.LocUsrDetailsContent + "ctl08");
        private static By countryErrorMsg = By.Id(CommonCtrls.LocUsrDetailsContent + "ctl02");
        private static By btnOrgEditReview = By.XPath("//*[@id='EIDSSBodyCPH_OrganizationSection']/div/div[1]/div/div[2]/a");
        private static By btnDeptEditReview = By.XPath("//*[@id='DepartmentsSection']/div/div[1]/div/div[2]/a");
        public static string searchResultsValue;
        public static List<string> allValues1 = new List<string>();
        public static List<string> allValues2 = new List<string>();
        public int retries = 0;


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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Organization Details") &&
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


        public static void clickOrganizationEdit()
        {
            SetMethods.clickObjectButtons(btnOrgEditReview);
        }

        public static void clickDepartmentsEdit()
        {
            SetMethods.clickObjectButtons(btnDeptEditReview);
        }

        public static void clearField(By element)
        {
            var clear = wait.Until(ExpectedConditions.ElementIsVisible(element));
            clear.Clear();
            Driver.Wait(TimeSpan.FromMinutes(5));
            clear.SendKeys(Keys.Tab);
            Driver.Wait(TimeSpan.FromMinutes(5));
        }

        public static void clickCancel()
        {
            //Scroll back to the bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clickReview()
        {
            //Scroll back up to the top of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0,-250)", "");
            SetMethods.clickObjectButtons(linkReview);
        }

        public static void clickDepartments()
        {
            SetMethods.clickObjectButtons(linkDepartments);
        }

        public static void clickSubmit()
        {
            SetMethods.clickObjectButtons(btnSubmit);
        }

        public static void acceptMessage()
        {

            IAlert alert = Driver.Instance.SwitchTo().Alert();
            alert.Accept();
        }

        public static void declineMessage()
        {

            IAlert alert = Driver.Instance.SwitchTo().Alert();
            alert.Dismiss();
        }

        public static string doesErrorAlertMessageDisplay()
        {
            try
            {
                string text = Driver.Instance.SwitchTo().Alert().Text;
                errorString = text;
            }
            catch
            {
                //Fails the test if error message does not display
                Assert.IsTrue(String.IsNullOrEmpty(errorString));
            }
            return errorString;
        }

        public static void doesAccessCodeErrorMessageDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(accessCodeErrorMsg);
        }

        public static void doesOrgFullNameErrorMessageDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(orgFullNameErrorMsg);
        }

        public static void doesAbbreviationErrorMessageDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(orgAbbrErrorMsg);
        }

        public static void doesRegionErrorMessageDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(regionErrorMsg);
        }

        public static void doesRayonErrorMessageDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(rayonErrorMsg);
        }

        public static void doesCountryErrorMessageDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(countryErrorMsg);
        }

        public class OrganizationInfo
        {
            private static By linkOrganizationInfoTab = By.LinkText("Organization Info");
            private static By lblUniqueOrganizationID = By.Name("Unique Organization ID");
            private static By txtUniqueOrganizationID = By.Id(CommonCtrls.GeneralContent + "txtstrOrganizationID");
            private static By lblAbbreviation = By.Name("Abbreviation");
            private static By txtAbbreviation = By.Id(CommonCtrls.GeneralContent + "txtEnglishName");
            private static By lblOrganizationName = By.Name("Organization Name");
            private static By txtOrganizationName = By.Id(CommonCtrls.GeneralContent + "txtFullName");
            private static By lblAccessoryCode = By.Name("Accessory Code");
            private static By ddlListAccessoryCode = By.Id(CommonCtrls.GeneralContent + "lsbintHACode1");
            private static IList<IWebElement> accessCodeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lsbintHACode1']/option")); } }
            private static By txtOrder = By.Id(CommonCtrls.GeneralContent + "txtintOrder");
            private static By chkShowForeignAddress = By.Id(CommonCtrls.GeneralContent + "chkShowForeignAddress");
            private static By ddlCountry = By.Id(CommonCtrls.LocUsrDetailsContent + "ddlLUCDetailsidfsCountry");
            private static IList<IWebElement> countryOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocUsrDetailsContent + "ddlLUCDetailsidfsCountry']/option")); } }
            private static By ddlRegion = By.Id(CommonCtrls.LocUsrDetailsContent + "ddlLUCDetailsidfsRegion");
            private static IList<IWebElement> regionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocUsrDetailsContent + "ddlLUCDetailsidfsRegion']/option")); } }
            private static By ddlRayon = By.Id(CommonCtrls.LocUsrDetailsContent + "ddlLUCDetailsidfsRayon");
            private static IList<IWebElement> rayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocUsrDetailsContent + "ddlLUCDetailsidfsRayon']/option")); } }
            private static By ddlSettlement = By.Id(CommonCtrls.LocUsrDetailsContent + "ddlLUCDetailsidfsSettlement");
            private static IList<IWebElement> settlementOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocUsrDetailsContent + "ddlLUCDetailsidfsSettlement']/option")); } }
            private static By txtStreet = By.Id(CommonCtrls.LocUsrDetailsContent + "txtLUCDetailsstrStreetName");
            private static By txtBuilding = By.Id(CommonCtrls.LocUsrDetailsContent + "txtLUCDetailsstrBuilding");
            private static By txtHouse = By.Id(CommonCtrls.LocUsrDetailsContent + "txtLUCDetailsstrHouse");
            private static By txtApartment = By.Id(CommonCtrls.LocUsrDetailsContent + "txtLUCDetailsstrApartment");
            private static By ddlPostalCode = By.Id(CommonCtrls.LocUsrDetailsContent + "ddlLUCDetailsidfsPostalCode");
            private static By txtPhone = By.Id(CommonCtrls.LocationUsrContent + "txtstrContactPhone");


            public static void enterRegion(String value)
            {
                SetMethods.enterObjectDropdownListValue(ddlRegion, value);
            }

            public static void enterRayon(String value)
            {
                SetMethods.enterObjectDropdownListValue(ddlRayon, value);
            }

            public static String enterUniqueOrganizationID(string orgID)
            {
                int rNum = rnd.Next(1, 999999);
                orgID = orgID + rNum;
                SetMethods.enterObjectValue(txtUniqueOrganizationID, orgID);
                return orgUniqueID = orgID;
            }

            public static void enterAbbreviation()
            {
                SetMethods.enterObjectValue(txtAbbreviation, orgUniqueID);
            }

            public static void clearAbbreviationField()
            {
                clearField(txtAbbreviation);
            }

            public static void enterGeneratedOrganizationName()
            {
                SetMethods.enterObjectValue(txtOrganizationName, orgUniqueID);
            }

            public static void clearOrgFullNameField()
            {
                clearField(txtOrganizationName);
            }

            public static void enterOrganizationName()
            {
                SetMethods.enterObjectValue(txtOrganizationName, orgUniqueID);
            }

            public static void randomSelectAccessoryCode()
            {
                SetMethods.randomSelectObjectElement(ddlListAccessoryCode, accessCodeOptions);
            }

            public static void enterAccessoryCode(String value)
            {
                SetMethods.enterObjectValue(ddlListAccessoryCode, value);
            }

            public static void randomSelectAnotherAccessCode()
            {
                var element = wait.Until(ExpectedConditions.ElementIsVisible(ddlListAccessoryCode));
                Driver.Wait(TimeSpan.FromMinutes(10));
                foreach (var opt in accessCodeOptions)
                {
                    if (!opt.Selected)
                    {
                        opt.Click();
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        break;
                    }
                }
            }

            public static void selectMultipleAccessoryCodes()
            {
                SetMethods.randomMultiSelectObjectElement(ddlListAccessoryCode, accessCodeOptions);
            }

            public static void enterRandomOrderNumber()
            {
                Random rnd = new Random();
                int rNum = rnd.Next(0, 9);
                SetMethods.enterIntObjectValue(txtOrder, rNum);
            }

            private static void selectNullValueToClear(By element, string value, IList<IWebElement> list)
            {
                var obj = wait.Until(ExpectedConditions.ElementIsVisible(element));
                Driver.Wait(TimeSpan.FromMinutes(10));
                obj.Click();

                foreach (var el in list)
                {
                    if (el.Text.Contains(value))
                    {
                        el.Click();
                        Driver.Wait(TimeSpan.FromMinutes(15));
                    }
                }
            }

            public static void clearRegionField()
            {
                SetMethods.clearDropdownList(ddlRegion);
            }

            public static void clearRayonField()
            {
                SetMethods.clearDropdownList(ddlRayon);
            }

            public static void clearCountryField()
            {
                //Scroll back to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
                SetMethods.clearDropdownList(ddlCountry);
            }

            public static void clickForeignAddressBox()
            {
                var element = wait.Until(ExpectedConditions.ElementIsVisible(chkShowForeignAddress));
                element.Click();
                Driver.Wait(TimeSpan.FromMinutes(5));
            }

            public static void selectRandomCountry()
            {
                //Scroll back to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 300)", "");
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlCountry, countryOptions);
            }

            public static void selectRandomRegion()
            {
                //Scroll back to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 300)", "");
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlRegion, regionOptions);
            }

            public static void selectRandomRayon()
            {
                //Scroll back to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 300)", "");
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlRayon, rayonOptions);
            }


            public static void selectRandomTownOrVillage()
            {
                //Scroll back to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 300)", "");
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlSettlement, settlementOptions);
            }

            public static void enterStreetAddress(string address)
            {
                SetMethods.enterObjectValue(txtStreet, address);
            }

            public static void enterBuildingNumber(int buildingNum)
            {
                SetMethods.enterIntObjectValue(txtBuilding, buildingNum);
            }

            public static void enterHouseNumber(int houseNum)
            {
                SetMethods.enterIntObjectValue(txtHouse, houseNum);
            }

            public static void enterAptNumber(int aptNum)
            {
                SetMethods.enterIntObjectValue(txtApartment, aptNum);
            }

            public static void enterPostalCode()
            {
                Random rnd = new Random();
                int rNum = rnd.Next(10000, 99999);
                SetMethods.enterIntObjectValue(ddlPostalCode, rNum);
            }

            public static void enterPhoneNumber()
            {
                Random rnd = new Random();
                int rPhoneNum = rnd.Next(1000000000, 999999999);
                SetMethods.enterObjectValue(txtPhone, String.Format("{0: (###) ###-####", rPhoneNum));
            }
        }

        public class Departments
        {
            private static By txtDeptName = By.Id(CommonCtrls.GeneralContent + "gvDepartments_txtDepartmentName");
            private static By btnAddDept = By.Id(CommonCtrls.GeneralContent + "gvDepartments_btnDepartmentAdd");
            private static By tlbDepartmentsGrid = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvDepartments']/tbody");

            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(departmentSubTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(departmentSubTitle).Text.Contains("Departments") &&
                                Driver.Instance.FindElement(departmentSubTitle).Displayed)
                                return true;
                            else
                                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("Page cannot be displayed");
                            return false;
                        }
                    }
                    else
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                }
            }

            public static void enterDepartmentName(string value)
            {
                SetMethods.enterStringObjectValue(txtDeptName, value);
            }

            public static void clickAddDepartment()
            {
                SetMethods.clickObjectButtons(btnAddDept);
            }

            public static void getSearchResultsValue(String value)
            {
                try
                {
                    IWebElement table = Driver.Instance.FindElement(tlbDepartmentsGrid);
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

            public static void getSearchResultsValue1()
            {
                try
                {
                    IWebElement table = Driver.Instance.FindElement(tlbDepartmentsGrid);
                    IList<IWebElement> rows = table.FindElements(By.TagName("tr"));
                    foreach (var row in rows)
                    {
                        IList<IWebElement> cols = row.FindElements(By.TagName("td"));
                        foreach (var col in cols)
                        {
                            if (!String.IsNullOrEmpty(col.Text))
                            {
                                allValues1.Add(col.Text);
                                allValues1.Sort();
                                break;
                            }
                        }
                    }
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);

                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail(allValues1 + " does not exist in the table.");
                }
            }

            public static void getSearchResultsValue2()
            {
                try
                {
                    IWebElement table = Driver.Instance.FindElement(tlbDepartmentsGrid);
                    IList<IWebElement> rows = table.FindElements(By.TagName("tr"));
                    foreach (var row in rows)
                    {
                        IList<IWebElement> cols = row.FindElements(By.TagName("td"));
                        foreach (var col in cols)
                        {
                            if (!String.IsNullOrEmpty(col.Text))
                            {
                                allValues2.Add(col.Text);
                                allValues2.Sort();
                                break;
                            }
                        }
                    }
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);

                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail(allValues2 + " does not exist in the table.");
                }
            }

        }
    }
}