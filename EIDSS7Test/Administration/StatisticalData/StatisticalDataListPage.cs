using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Linq;
using System.Threading;

namespace EIDSS7Test.Administration.StatisticalData
{
    public class StatisticalDataListPage
    {
        public static int getTotalCnt;
        public static int getCurTotalCnt;
        public static string defaultNM;

        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));
        private static By titleFormTitle = By.TagName("h2");

        private static By lblStatisticalDataType = By.Id("lblStatisticalDataType");
        private static By lblStartDateforPeriod = By.Id("lblStartDateforPeriod");
        private static By lblStartDateforFrom = By.Id("lblStartDateforFrom");
        private static By lblStartDateforTo = By.Id("lblStartDateforTo");
        private static By lblCountry = By.Id("lblCountry");
        private static By lblRegion = By.Id("lblRegion");
        private static By lblRayon = By.Id("lblRayon");
        private static By lblSettlement = By.Id("lblSettlement");
        private static By tblStatDataList = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataList");
        private static IList<IWebElement> tblColumns { get { return Driver.Instance.FindElements(By.TagName("td")); } }
        private static IList<IWebElement> btnEdits { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-edit']")); } }
        private static IList<IWebElement> btnDeletes { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-trash']")); } }
        private static By btnNew = By.Id(CommonCtrls.GeneralContent + "btnNew");
        private static By btnSearchOnList = By.XPath("//*[@id='btnOpenModal']/span[1]");


        public static bool IsAt
        {
            get
            {
                Driver.Instance.WaitForPageToLoad();
                if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                     || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                {
                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Page cannot be displayed");
                    return false;
                }
                else if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Error:"))
                {
                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                    return false;
                }
                else if (Driver.Instance.FindElements(titleFormTitle).Count > 0)
                {
                    if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Statistical Data List") &&
                        Driver.Instance.FindElement(titleFormTitle).Displayed)
                        return true;
                    else
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                    return false;
                }
                else
                {
                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Page cannot be displayed");
                    return false;
                }
            }
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

        public static void doesStatDataDisplayOnTable()
        {
            if (tblColumns.Count > 0)
            {
                IList<IWebElement> dtList = tblColumns;
                var count = dtList.Count;
                for (var i = count - 1; i > -i; i--)
                {
                    if (dtList[i] == null) dtList.RemoveAt(i);
                }
                dtList = dtList.Where(s => !string.IsNullOrWhiteSpace(s.ToString())).Distinct().ToList();

                foreach (IWebElement col in dtList)
                {
                    if (col.Text.Contains(StatisticalDataDetailsPage.getValue.ToString()))
                    {
                        defaultNM = col.Text;
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        Console.WriteLine(defaultNM + " displays on the table successfully.");
                        break;
                    }
                }
            }
            else
            {
                //Fails test if name does not display in list
                Assert.IsFalse(String.IsNullOrEmpty(defaultNM));
            }
        }

        public static void randomDeleteStats()
        {
            SetMethods.randomSelectObjectElement(tblStatDataList, btnDeletes);
        }

        public static void randomEditStats()
        {
            SetMethods.randomSelectObjectElement(tblStatDataList, btnEdits);
        }

        public static int getTotalCountOfStats()
        {
            var table = tblStatDataList;
            IList<IWebElement> lists = Driver.Instance.FindElements(By.TagName("tr"));
            return getTotalCnt = lists.Count;
        }

        public static int getCurTotalCountOfStats()
        {
            var table = tblStatDataList;
            IList<IWebElement> lists = Driver.Instance.FindElements(By.TagName("tr"));
            return getCurTotalCnt = lists.Count;
        }


        public static void clickSearch()
        {
            SetMethods.clickObjectButtons(btnSearchOnList);

            //Switch to new window
            Thread.Sleep(45);
            string newWindowHandle = Driver.Instance.WindowHandles.Last();
            var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);
        }

        public static void clickNewStatData()
        {
            SetMethods.clickObjectButtons(btnNew);
        }


        public class SearchPanel
        {
            private static By ddlStatisticalDataType = By.Id(CommonCtrls.GeneralContent + "ddlidfsStatisticalDataType");
            private static IList<IWebElement> statDatTypeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsStatisticalDataType']/option")); } }
            private static By txtStartDateforFrom = By.Id(CommonCtrls.GeneralContent + "txtdatStatisticStartDateFrom");
            private static By txtStartDateforTo = By.Id(CommonCtrls.GeneralContent + "txtdatStatisticStartDateTo");
            private static By ddlCountry = By.Id(CommonCtrls.GeneralContent + "ddlCountry");
            private static IList<IWebElement> countryOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlCountry']/option")); } }
            private static By ddlRegion = By.Id(CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsRegion");
            private static IList<IWebElement> regionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsRegion']/option")); } }
            private static By ddlRayon = By.Id(CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsRayon");
            private static IList<IWebElement> rayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsRayon']/option")); } }
            private static By ddlSettlement = By.Id(CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsSettlement");
            private static IList<IWebElement> settlementOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsSettlement']/option")); } }
            private static By btnClear = By.XPath("//input[@type='rest'][text()='Clear']");
            private static By btnSearchOnPanel = By.Id(CommonCtrls.GeneralContent + "btnSearch");


            public static void selectRandomStatisticalDataType()
            {
                SetMethods.randomSelectObjectElement(ddlStatisticalDataType, statDatTypeOptions);
            }

            public static void selectStatisticalDataType(string type)
            {
                var types = wait.Until(ExpectedConditions.ElementIsVisible(ddlStatisticalDataType));
                types.Click();
                Driver.Wait(TimeSpan.FromMinutes(10));

                foreach (var item in statDatTypeOptions)
                {
                    if (item.Text.Contains(type))
                    {
                        item.Click();
                        Driver.Wait(TimeSpan.FromMinutes(10));
                    }
                }
            }

            public static void enterStartDateForPeriod()
            {
                SetMethods.enterCurrentDate(txtStartDateforFrom);
            }

            public static void enterEndDateForPeriod()
            {
                SetMethods.enterCurrentDate(txtStartDateforTo);
            }

            public static void selectRandomCountry()
            {
                SetMethods.randomSelectObjectElement(ddlCountry, countryOptions);
            }

            public static void selectRandomRegion()
            {
                SetMethods.randomSelectObjectElement(ddlRegion, regionOptions);
            }

            public static void selectRandomRayon()
            {
                SetMethods.randomSelectObjectElement(ddlRayon, rayonOptions);
            }

            public static void selectRandomSettlement()
            {
                SetMethods.randomSelectObjectElement(ddlSettlement, settlementOptions);
            }

            public static void clickClear()
            {
                SetMethods.clickObjectButtons(btnClear);
            }

            public static void clickSearch()
            {
                SetMethods.clickObjectButtons(btnSearchOnPanel);

                //Switch to new window
                Thread.Sleep(45);
                string newWindowHandle = Driver.Instance.WindowHandles.Last();
                var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);
            }
        }
    }
}
