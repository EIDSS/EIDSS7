using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;
using EIDSS7Test.Navigation;
using EIDSS7Test.Database;
using System.Threading;
using System.Linq;

namespace EIDSS7Test.Administration.Organizations
{
    public class OrgListPage
    {
        public static string Org;
        public static String abbrvNM;
        public static string orgFullName;
        public static string searchResultsValue;
        public static string orgUniqID;
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));
        private static By titleFormTitle = By.TagName("h2");
        private static By HeaderFormTitle = By.TagName("h1");

        //ORGANIZATION LIST PANEL        
        private static By tblOrganiztionList = By.Id(CommonCtrls.GeneralContent + "upOrganizationList");
        private static By lblAbbreviation = By.Id("LblAbbreviationText");
        private static By lblOrganizationFullName = By.Id("LblOrganizationFullNameText");
        private static By lblOrganizationAddress = By.Id("LblOrganizationAddressHeaderText");
        private static By lblOrder = By.Id("LblOrderHeaderText");

        private static By lblOrgFullName = By.Id("LblOrganizationText");
        private static By lblPosition = By.Id("LblPositionText");
        private static By btnNew = By.Id(CommonCtrls.GeneralContent + "btnNew");
        private static By btnSearchOnList = By.Id("btnOpenModal");
        private static IList<IWebElement> tblRows { get { return Driver.Instance.FindElements(By.TagName("tr")); } }
        private static IList<IWebElement> tblColumns { get { return Driver.Instance.FindElements(By.TagName("td")); } }
        private static IList<IWebElement> btnEdits { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-edit']")); } }
        private static IList<IWebElement> btnDeletes { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-trash']")); } }
        private static IList<IWebElement> btnSelectOrgRecords { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-hand-up']")); } }

        public static void doesNewOrganizationDisplayInList()
        {
            if (tblColumns.Count > 0)
            {
                foreach (IWebElement col in tblColumns)
                {
                    if (col.Text.Contains(EIDSSParameterData.orguniqueid))
                    {
                        orgFullName = col.Text;
                        break;
                    }
                }
            }
            else
            {
                //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail("Cannot find " + orgFullName + " in the list.");
            }
        }

        public static void getSearchResultsValue(String value)
        {
            try
            {
                IWebElement table = Driver.Instance.FindElement(tblOrganiztionList);
                IList<IWebElement> rows = table.FindElements(By.TagName("tr"));
                foreach (var row in rows)
                {
                    IList<IWebElement> cols = row.FindElements(By.TagName("td"));
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
                //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail(value + " does not exist in the table.");
            }
        }

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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Organizations List") &&
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

        public static void wasOrganizationRemovedFromTheList(string value)
        {
            SetMethods.isElementNotPresent(tblColumns, value);
        }

        public static void acceptMessage()
        {
            try
            {
                IAlert alert = Driver.Instance.SwitchTo().Alert();
                alert.Accept();
            }
            catch
            {
                Assert.Fail();
            }
        }

        public static void declineMessage()
        {
            try
            {
                IAlert alert = Driver.Instance.SwitchTo().Alert();
                alert.Dismiss(); ;
            }
            catch
            {
                Assert.Fail();
            }
        }

        public static void clickNewOrg()
        {
            SetMethods.clickObjectButtons(btnNew);
        }

        public static void clickSearchOnList()
        {
            Thread.Sleep(1000);
            SetMethods.clickObjectButtons(btnSearchOnList);

            //Switch to new window
            string newWindowHandle = Driver.Instance.WindowHandles.Last();
            var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);
            Thread.Sleep(120);
        }

        public static void randomDeleteOrg()
        {
            SetMethods.randomSelectObjectElement(tblOrganiztionList, btnDeletes);
        }

        public static void randomEditOrg()
        {
            SetMethods.randomSelectObjectElement(tblOrganiztionList, btnEdits);
        }

        public static void randomSelectOrganizations()
        {
            Driver.Wait(TimeSpan.FromMinutes(10));
            SetMethods.SelectRandomOptionFromDropdown(btnSelectOrgRecords);
            Driver.Wait(TimeSpan.FromMinutes(10));
        }

        public static void Add100NewOrganizations()
        {
            for (int i = 0; i <= 100; i++)
            {
                //Navigate to System | Admininstration | Organizations
                MainMenuNavigation.clickAdministration();
                MainMenuNavigation.Administration.clickOrganizations();

                //Click the New button.  Verify that the Organization Details page displays
                //Enter all required information
                OrgListPage.clickNewOrg();
                OrgDetailsPage.OrganizationInfo.enterUniqueOrganizationID("ORGTEST");
                OrgDetailsPage.OrganizationInfo.enterAbbreviation();
                OrgDetailsPage.OrganizationInfo.enterGeneratedOrganizationName();
                OrgDetailsPage.OrganizationInfo.randomSelectAccessoryCode();
                //OrgDetailsPage.OrganizationInfo.selectRandomCountry();
                OrgDetailsPage.OrganizationInfo.selectRandomRegion();
                OrgDetailsPage.OrganizationInfo.selectRandomRayon();
                OrgDetailsPage.OrganizationInfo.selectRandomTownOrVillage();

                //Click Review and Submit
                OrgDetailsPage.clickReview();
                OrgDetailsPage.clickSubmit();

                //IMPLEMENT WORKAROUND FOR ADDING MULTIPLE EMPLOYEES SINCE SUBMIT BUTTON DOES NOT RETURN FOCUS TO LIST PAGE
                MainMenuNavigation.clickEIDSSHomeLink();
            }
        }


        public class SearchPanel
        {
            private static By searchPanelTitle = By.TagName("h4");
            private static By txtUniqueOrgID = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "txtstrOrganizationID']");
            private static By txtAbbreviation = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "txtstrOrgName']");
            private static By txtOrginazationFullName = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "txtstrOrgFullName']");
            private static By ddlSpecialization = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSpecialization']");
            private static IList<IWebElement> specializeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSpecialization']/option")); } }
            private static By chkShowForeignOrganizations = By.Id(CommonCtrls.GeneralContent + "chkShowForeignOrganizations");
            private static By ddlCountry = By.Id(CommonCtrls.LocationUsrContent + "ddlCountry");
            private static IList<IWebElement> countryOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationUsrContent + "ddlCountry']/option")); } }
            private static By ddlRegion = By.Id(CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsRegion");
            private static IList<IWebElement> regionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsRegion']/option")); } }
            private static By ddlRayon = By.Id(CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsRayon");
            private static IList<IWebElement> rayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsRayon']/option")); } }
            private static By ddlSettlement = By.Id(CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsSettlement");
            private static IList<IWebElement> settlementOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsSettlement']/option")); } }
            private static By btnSearchOnPanel = By.Id(CommonCtrls.GeneralContent + "btnSearch");
            //private static By btnClear = By.XPath("//input[@class='btn btn-default']");
            private static By btnClear = By.Id(CommonCtrls.GeneralContent + "btnClear");

            public static bool IsAt
            {
                get
                {
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(searchPanelTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(searchPanelTitle).Text.Contains("Search") &&
                                Driver.Instance.FindElement(searchPanelTitle).Displayed)
                                return true;
                            else
                                //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                Assert.Fail("This is not the correct title");
                            return false;
                        }
                    }
                    else
                    {
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                }
            }

            public static void enterSpecialization(string element2)
            {
                var region = wait.Until(ExpectedConditions.ElementIsVisible(ddlSpecialization));
                region.Click();

                foreach (var element in regionOptions)
                {
                    if (element.Text.Contains(element2))
                    {
                        element.Click();
                        Driver.Wait(TimeSpan.FromMinutes(15));
                    }
                }
            }

            public static void enterUniqueOrgID(string value)
            {
                SetMethods.enterStringObjectValue(txtUniqueOrgID, value);
            }

            public static void enterOrganizationFullName(string organization)
            {
                SetMethods.enterStringObjectValue(txtOrginazationFullName, organization);
            }

            public static void enterOrganizationAbbreviation(string abbreviation)
            {
                SetMethods.enterObjectValue(txtAbbreviation, abbreviation);
            }

            public static void randomSelectCountry()
            {
                SetMethods.randomSelectObjectElement(ddlCountry, countryOptions);
            }

            public static void randomSelectRegion()
            {
                SetMethods.randomSelectObjectElement(ddlRegion, regionOptions);
            }

            public static void randomSelectRayon()
            {
                SetMethods.randomSelectObjectElement(ddlRayon, rayonOptions);
            }

            public static void randomSelectSettlement()
            {
                SetMethods.randomSelectObjectElement(ddlSettlement, settlementOptions);
            }
            public static void clickSearchOrg()
            {
                SetMethods.clickObjectButtons(btnSearchOnPanel);
            }

            public static void clickClearOrg()
            {
                SetMethods.clickObjectButtons(btnClear);
            }

            public static void clickForeignOrgs()
            {
                SetMethods.clickObjectButtons(chkShowForeignOrganizations);
            }

            public static void clickSearchOnPanel()
            {
                Driver.Instance.WaitForPageToLoad();
                SetMethods.clickObjectButtons(btnSearchOnPanel);

                //Switch to new window
                string newWindowHandle = Driver.Instance.WindowHandles.Last();
                var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);
                Driver.Instance.WaitForPageToLoad();
                Thread.Sleep(2000);
            }

            public static void clearOrgFullName()
            {
                SetMethods.clearField(txtOrginazationFullName);
            }

            public static void clearOrgAbbreviation()
            {
                SetMethods.clearField(txtAbbreviation);
            }

            public static void clearOrgUniqueID()
            {
                SetMethods.clearField(txtUniqueOrgID);
            }

            public static void clearOrgSpecialization()
            {
                SetMethods.clearDropdownList(ddlSpecialization);
            }

        }

        //This class if for Outbreak Management
        public class OutbreakSrchCriteria
        {
            private static By subTitleFormTitle = By.XPath("//*[@id='hdgSearchCriteria']");
            private static By txtUniqueOrgID = By.XPath("//*[@id='" + CommonCtrls.SearchOutbreakOrgContent + "txtOrganizationID']");
            private static By txtAbbrv = By.XPath("//*[@id='" + CommonCtrls.SearchOutbreakOrgContent + "txtOrganizationAbbreviatedName']");
            private static By txtOrgFullName = By.XPath("//*[@id='" + CommonCtrls.SearchOutbreakOrgContent + "txtOrganizationFullName']");
            private static By ddlAccessCode = By.XPath("//*[@id='" + CommonCtrls.SearchOutbreakOrgContent + "ddlAccessoryCode']");
            private static IList<IWebElement> accessCodeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchOutbreakOrgContent + "ddlAccessoryCode']/option")); } }
            private static By ddlOrgType = By.XPath("//*[@id='" + CommonCtrls.SearchOutbreakOrgContent + "ddlOrganizationTypeID']");
            private static IList<IWebElement> orgTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchOutbreakOrgContent + "ddlOrganizationTypeID']/option")); } }
            private static By chkShowForeignOrganizations = By.Id(CommonCtrls.SearchOutbreakOrgContent + "chkShowForeignOrganization");
            private static By ddlRegion = By.Id(CommonCtrls.SearchOutbreakOrgContent + "ucLocation_ddlidfsRegion");
            private static IList<IWebElement> regionOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchOutbreakOrgContent + "ucLocation_ddlidfsRegion']/option")); } }
            private static By ddlRayon = By.Id(CommonCtrls.SearchOutbreakOrgContent + "ucLocation_ddlidfsRayon");
            private static IList<IWebElement> rayonOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchOutbreakOrgContent + "ucLocation_ddlidfsRayon']/option")); } }
            private static By ddlSettleType = By.Id(CommonCtrls.LocationUsrContent + "ucLocation_ddlSettlementType");
            private static IList<IWebElement> settleTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchOutbreakOrgContent + "ucLocation_ddlSettlementType']/option")); } }
            private static By ddlSettlement = By.Id(CommonCtrls.SearchOutbreakOrgContent + "ucLocation_ddlidfsSettlement");
            private static IList<IWebElement> settlementOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SearchOutbreakOrgContent + "ucLocation_ddlidfsSettlement']/option")); } }
            private static By btnSearch = By.Id(CommonCtrls.SearchOutbreakOrgContent + "btnSearch");
            private static By btnCancel = By.Id(CommonCtrls.SearchOutbreakOrgContent + "btnCancel");
            private static By btnClear = By.Id(CommonCtrls.SearchOutbreakOrgContent + "btnClear");
            private static By btnAdd = By.Id(CommonCtrls.SearchOutbreakOrgContent + "btnAddOrganization");


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
                    else if (Driver.Instance.FindElements(subTitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subTitleFormTitle).Text.Contains("Search Criteria") &&
                                Driver.Instance.FindElement(subTitleFormTitle).Displayed)
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

            public static void enterOrgID(string value)
            {
                SetMethods.enterStringObjectValue(txtUniqueOrgID, value);
            }

            public static void enterOrgName(string value)
            {
                SetMethods.enterStringObjectValue(txtOrgFullName, value);
            }

            public static void enterOrgAbbreviation(string value)
            {
                SetMethods.enterObjectValue(txtAbbrv, value);
            }

            public static void randomSelectOrgType()
            {
                SetMethods.randomSelectObjectElement(ddlOrgType, orgTypeOpts);
            }

            public static void randomSelectRegion()
            {
                SetMethods.randomSelectObjectElement(ddlRegion, regionOpts);
            }

            public static void randomSelectRayon()
            {
                SetMethods.randomSelectObjectElement(ddlRayon, rayonOpts);
            }

            public static void randomSelectSettlementType()
            {
                SetMethods.randomSelectObjectElement(ddlSettleType, settleTypeOpts);
            }

            public static void randomSelectSettlement()
            {
                SetMethods.randomSelectObjectElement(ddlSettlement, settlementOpts);
            }

            public static void clickSearchOrg()
            {
                SetMethods.clickObjectButtons(btnSearch);
            }

            public static void clickClearOrg()
            {
                SetMethods.clickObjectButtons(btnClear);
            }

            public static void clickForeignOrgs()
            {
                SetMethods.clickObjectButtons(chkShowForeignOrganizations);
            }

            public static void clickSearch()
            {
                SetMethods.clickObjectButtons(btnSearch);
            }

            public static void clearOrgFullName()
            {
                SetMethods.clearField(txtOrgFullName);
            }

            public static void clearOrgAbbreviation()
            {
                SetMethods.clearField(txtAbbrv);
            }

            public static void clearOrgUniqueID()
            {
                SetMethods.clearField(txtUniqueOrgID);
            }

        }

        public class OutbreakSrchResults
        {
            private static By subTitleFormTitle = By.Id("hdgSearchResults");
            private static By txtUniqueOrgID = By.XPath("//*[@id='" + CommonCtrls.SearchOutbreakOrgContent + "txtOrganizationID']");
            private static By txtAbbrv = By.XPath("//*[@id='" + CommonCtrls.SearchOutbreakOrgContent + "txtOrganizationAbbreviatedName']");
            private static By txtOrgFullName = By.XPath("//*[@id='" + CommonCtrls.SearchOutbreakOrgContent + "txtOrganizationFullName']");
            private static By tlbOrgIDs = By.XPath("//*[@id='" + CommonCtrls.SearchOutbreakOrgContent + "gvOrganizations']");
            private static IList<IWebElement> AllOrgIDLinks { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[1]/div[14]/div[1]/div[2]/div[1]/div[2]/div[1]/div[2]/div[1]/div[1]/div[1]/table[1]/tbody[1]/tr/td[1]")); } }
            private static IList<IWebElement> AllOrgEdits { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[1]/div[14]/div[1]/div[2]/div[1]/div[2]/div[1]/div[2]/div[1]/div[1]/div[1]/table[1]/tbody[1]/tr/td[6]")); } }
            private static By linkOrgID = By.Id(CommonCtrls.SearchOutbreakOrgContent + "gvOrganizations_btnSelect_0");
            private static By btnCancel = By.Id(CommonCtrls.SearchOutbreakOrgContent + "btnCancel");
            private static By btnAdd = By.Id(CommonCtrls.SearchOutbreakOrgContent + "btnAddOrganization");


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
                    else if (Driver.Instance.FindElements(subTitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subTitleFormTitle).Text.Contains("Search Results") &&
                                Driver.Instance.FindElement(subTitleFormTitle).Displayed)
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

            public static void randomSelectOrgID()
            {
                SetMethods.randomSelectObjectElement(tlbOrgIDs, AllOrgIDLinks);
            }

            public static void selectFirstOrgID()
            {
                SetMethods.clickObjectButtons(linkOrgID);
            }
        }

    }
}