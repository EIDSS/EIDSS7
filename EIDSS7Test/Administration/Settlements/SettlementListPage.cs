using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Threading;
using EIDSS7Test.Navigation;
using System.Text.RegularExpressions;

namespace EIDSS7Test.Administration.Settlements
{
    public class SettlementListPage
    {
        public static string defaultName;
        public static int getTotalCnt;
        public static int getCurTotalCnt;
        public static string lists;
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));

        private static By HeaderFormTitle = By.TagName("h1");
        private static By titleFormTitle = By.XPath(".//*[@id='frmMain']/div[3]/div/div/div/div/div[1]/h2");
        private static By subFormTitle = By.XPath(".//*[@id='OrganizationSection']/div/div[1]/div/div[1]/h3");


        //SETTLEMENTS LIST PANEL
        public static string searchResultsValue;
        private static IList<IWebElement> btnEdits { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-edit']")); } }
        //private static IList<IWebElement> btnDeletes { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-trash']")); } }
        private static IList<IWebElement> btnDeletes { get { return Driver.Instance.FindElements(By.XPath("/html/body/form/div[3]/div/div/div/div/div[2]/div/div/table/tbody/tr/td[11]/a")); } }
        private static By btnNew = By.Id(CommonCtrls.GeneralContent + "btnNew");
        private static By btnSearchOnList = By.XPath("//*[@id='btnOpenModal']/span[1]");
        private static By tblSettlementList = By.Id(CommonCtrls.GeneralContent + "gvSettlementList");
        private static IList<IWebElement> tblRows { get { return Driver.Instance.FindElements(By.TagName("tr")); } }
        private static IList<IWebElement> tblColumns { get { return Driver.Instance.FindElements(By.TagName("td")); } }



        private static By lblTableLabels = By.TagName("th");


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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Settlements List") &&
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
                    Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                    return false;
                }
            }
        }


        public static void clickNewButton()
        {
            SetMethods.clickObjectButtons(btnNew);
        }

        public static void clickSearchButton()
        {
            SetMethods.clickObjectButtons(btnSearchOnList);
        }

        public static void randomDeleteSettlements()
        {
            SetMethods.randomSelectObjectElement(tblSettlementList, btnDeletes);
        }

        public static void randomEditSettlements()
        {
            SetMethods.randomSelectObjectElement(tblSettlementList, btnEdits);
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

        public static void manuallyEditSettlement(string settlement)
        {
            foreach (IWebElement row in tblRows)
            {
                if (row.Text.Contains(settlement))
                {
                    foreach (IWebElement editIcon in btnEdits)
                    {
                        editIcon.Click();
                        Driver.Wait(TimeSpan.FromMinutes(15));
                        break;
                    }
                }
            }
        }

        public static void manuallyDeleteSettlement(string settlement)
        {
            foreach (IWebElement row in tblRows)
            {
                if (row.Text.Contains(settlement))
                {
                    foreach (IWebElement deleteIcon in btnDeletes)
                    {
                        deleteIcon.Click();
                        Driver.Wait(TimeSpan.FromMinutes(15));
                        break;
                    }
                }
            }
        }

        public static void doesListContainSettlement()
        {
            if (tblColumns.Count > 0)
            {
                foreach (IWebElement col in tblColumns)
                {
                    if (col.Text.Contains(SettlementDetailPage.settlemNM))
                    {
                        defaultName = col.Text;
                        break;
                    }
                }
            }
            else
            {
                //Fails test if name does not display in list
                //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail(defaultName + " does not display in the list.");
            }
        }

        public static int getTotalCountOfSettlements()
        {
            var list = tblSettlementList;
            IList<IWebElement> lists = Driver.Instance.FindElements(By.TagName("tr"));
            return getTotalCnt = lists.Count;
        }

        public static int getCurTotalCountOfSettlements()
        {
            var list = tblSettlementList;
            IList<IWebElement> lists = Driver.Instance.FindElements(By.TagName("tr"));
            return getCurTotalCnt = lists.Count;
        }

        public static void selectRandomSettlementFromList()
        {
            var list = tblSettlementList;
            IList<IWebElement> lists = Driver.Instance.FindElements(By.TagName("tr"));
            SetMethods.SelectRandomOptionFromDropdown(lists);
        }

        public static void wasSettlementRemovedFromTheList(string value)
        {
            SetMethods.isElementNotPresent(tblColumns, value);
        }

        public static void Add100NewSettlements()
        {
            for (int i = 0; i <= 100; i++)
            {
                //Navigate to System | Admininstration | Settlements
                MainMenuNavigation.clickAdministration();
                MainMenuNavigation.Administration.clickSettlements();
                Assert.IsTrue(SettlementListPage.IsAt, "This is not the Settlements List Page");

                //Click the New button
                //Verify that the Settlement Details page displays
                SettlementListPage.clickNewButton();
                Assert.IsTrue(SettlementDetailPage.IsAt, "This is not the Settlements Details Page");

                //fill in all required fields.
                SettlementDetailPage.selectRandomCountry();
                SettlementDetailPage.selectRandomRegion();
                SettlementDetailPage.selectRandomRayon();
                SettlementDetailPage.enterUniqueCode();
                SettlementDetailPage.enterRandomNationalName("Settle");
                SettlementDetailPage.selectRandomSettlementType();
                SettlementDetailPage.enterRandomMinLongitude();
                SettlementDetailPage.enterRandomMinLatitude();

                //Click Review and Submit
                SettlementDetailPage.clickReview();
                SettlementDetailPage.clickSubmit();
            }
        }

        public static void getSearchResultsValue(String value)
        {
            try
            {
                IWebElement table = Driver.Instance.FindElement(tblSettlementList);
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


        public class SearchPanel
        {
            private static By txtDefaultName = By.Id(CommonCtrls.GeneralContent + "txtDefaultName");
            private static By txtNationalName = By.Id(CommonCtrls.GeneralContent + "txtstrNationalName");
            private static By ddlSettlementType = By.Id(CommonCtrls.GeneralContent + "ddlSettlementType");
            private static IList<IWebElement> settleTypeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSettlementType']/option")); } }
            private static By ddlCountry = By.Id(CommonCtrls.LocSettlementContent + "ddlLUCSettlementidfsCountry");
            private static IList<IWebElement> countryOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocSettlementContent + "ddlLUCSettlementidfsCountry']/option")); } }
            private static By ddlRegion = By.Id(CommonCtrls.LocSettlementContent + "ddlLUCSettlementidfsRegion");
            private static IList<IWebElement> regionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocSettlementContent + "ddlLUCSettlementidfsRegion']/option")); } }
            private static By ddlRayon = By.Id(CommonCtrls.LocSettlementContent + "ddlLUCSettlementidfsRayon");
            private static IList<IWebElement> rayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocSettlementContent + "ddlLUCSettlementidfsRayon']/option")); } }
            private static By txtSettlementCode = By.Id(CommonCtrls.GeneralContent + "txtSettlementCode");
            private static By txtLngMin = By.Id(CommonCtrls.GeneralContent + "txtLngMin");
            private static By txtLngMax = By.Id(CommonCtrls.GeneralContent + "txtLngMax");
            private static By txtLatMin = By.Id(CommonCtrls.GeneralContent + "txtLatMin");
            private static By txtLatMax = By.Id(CommonCtrls.GeneralContent + "txtLatMax");
            private static By txtEleMin = By.Id(CommonCtrls.GeneralContent + "txtEleMin");
            private static By txtEleMax = By.Id(CommonCtrls.GeneralContent + "txtEleMax");
            private static By btnClear = By.XPath("//input[@class='btn btn-default']");
            private static By btnSearchOnPanel = By.Id(CommonCtrls.GeneralContent + "btnSearch");
            private static By btnClose = By.XPath("//button[@class='close']");

            //*[@id="searchModal"]/div/div/div[1]/button

            public static void enterDefaultName()
            {
                SetMethods.enterObjectValue(txtDefaultName, SettlementDetailPage.settlemNM);
            }

            public static void enterDefaultName(string value)
            {
                SetMethods.enterObjectValue(txtDefaultName, value);
            }

            public static void enterNationalName()
            {
                SetMethods.enterObjectValue(txtNationalName, SettlementDetailPage.englishNM);
            }

            public static void enterNationalName(string value)
            {
                SetMethods.enterObjectValue(txtNationalName, value);
            }

            public static void selectRandomSettlementType()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlSettlementType, settleTypeOptions);
            }

            public static void enterSettlementType(string value)
            {
                SetMethods.enterObjectDropdownListValue(ddlSettlementType, value);
            }

            public static void selectRandomCountry()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlCountry, countryOptions);
            }

            public static void enterCountry(string value)
            {
                SetMethods.enterObjectDropdownListValue(ddlCountry, value);
            }

            public static void selectRandomRegion()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlRegion, regionOptions);
            }
            public static void enterRegion(string value)
            {
                SetMethods.enterObjectDropdownListValue(ddlRegion, value);
            }

            public static void selectRandomRayon()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlRayon, rayonOptions);
            }

            public static void enterRayon(string value)
            {
                SetMethods.enterObjectDropdownListValue(ddlRayon, value);
            }

            public static void enterLatitudeFrom(string value)
            {
                //Scroll back to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
                SetMethods.enterObjectValue(txtLatMin, value);
            }

            public static void enterLatitudeTo(string value)
            {
                //Scroll back to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
                SetMethods.enterObjectValue(txtLatMax, value);
            }

            public static void enterLongitudeFrom(string value)
            {
                //Scroll back to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
                SetMethods.enterObjectValue(txtLngMin, value);
            }

            public static void enterLongitudeTo(string value)
            {
                //Scroll back to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
                SetMethods.enterObjectValue(txtLngMax, value);
            }

            public static void enterElevationFrom(string value)
            {
                //Scroll back to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
                SetMethods.enterObjectValue(txtEleMax, value);
            }

            public static void enterElevationTo(string value)
            {
                //Scroll back to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
                SetMethods.enterObjectValue(txtEleMin, value);
            }

            public static void clearDefaultNameField()
            {
                SetMethods.clearField(txtDefaultName);
            }

            public static void clearNationalNameField()
            {
                SetMethods.clearField(txtNationalName);
            }

            public static void clearCountryField()
            {
                SetMethods.clearDropdownList(ddlCountry);
            }

            public static void clearRegionField()
            {
                SetMethods.clearDropdownList(ddlRegion);
            }

            public static void clearLatitudeMinFromField()
            {
                //Scroll back to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
                SetMethods.clearField(txtLatMin);
            }

            public static void clearLatitudeMaxToField()
            {
                //Scroll back to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
                SetMethods.clearField(txtLatMax);
            }

            public static void clearLongitudeMinFromField()
            {
                //Scroll back to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1200)", "");
                SetMethods.clearField(txtLngMin);
            }

            public static void clearLongitudeMaxToField()
            {
                //Scroll back to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1200)", "");
                SetMethods.clearField(txtLngMax);
            }

            public static void clearElevationMinFromField()
            {
                //Scroll back to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1200)", "");
                SetMethods.clearField(txtEleMin);
            }

            public static void clearElevationMaxToField()
            {
                //Scroll back to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 81200)", "");
                SetMethods.clearField(txtEleMax);
            }

            public static void clickSearchOnPanel()
            {
                SetMethods.clickObjectButtons(btnSearchOnPanel);
                Thread.Sleep(10000);
            }

            public static void clickClearButton()
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", btnClear);
                SetMethods.clickObjectButtons(btnClear);
            }

            public static void manuallyEnterDefaultName(string DName)
            {
                SetMethods.enterObjectValue(txtDefaultName, DName);
            }

            public static void manuallyEnterNationalName(string NName)
            {
                SetMethods.enterObjectValue(txtNationalName, NName);
            }

            public static void closeSearchBox()
            {
                //Scroll back up to the top of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0,-250)", "");
                Driver.Wait(TimeSpan.FromMinutes(10));

                SetMethods.clickObjectButtons(btnClose);
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
        }
    }
}