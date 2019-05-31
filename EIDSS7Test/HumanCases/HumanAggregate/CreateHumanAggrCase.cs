using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;


namespace EIDSS7Test.HumanCases.HumanAggregate
{
    public class CreateHumanAggrCase
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();

        private static By titleFormTitle = By.TagName("h2");
        private static By HeaderFormTitle = By.TagName("h1");


        public class HumanAggregateCaseDetails
        {
            private static By subtitleFormTitle = By.TagName("h3");
            private static By subTitleHumAggCaseDetails = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "humanAggregate']/div/div[1]/h3");
            private static By txtCaseID = By.Id(CommonCtrls.GeneralContent + "txtstrSearchCaseID");
            private static By ddlYear = By.Id(CommonCtrls.GeneralContent + "ddlintYear");
            private static IList<IWebElement> yearOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlintYear']/option")); } }
            private static By ddlMonth = By.Id(CommonCtrls.GeneralContent + "ddlintMonth");
            private static IList<IWebElement> monthOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlintMonth']/option")); } }
            private static By ddlCountry = By.Id(CommonCtrls.GeneralContent + "txtstrCountry");
            private static IList<IWebElement> countryOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "txtstrCountry']/option")); } }
            private static By ddlRegion = By.Id(CommonCtrls.HumanAggrLocContent + "ddllucHumanAggregateidfsRegion");
            private static IList<IWebElement> regionOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.HumanAggrLocContent + "ddllucHumanAggregateidfsRegion']/option")); } }
            private static By ddlRayon = By.Id(CommonCtrls.HumanAggrLocContent + "ddllucHumanAggregateidfsRayon");
            private static IList<IWebElement> rayonOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.HumanAggrLocContent + "ddllucHumanAggregateidfsRayon']/option")); } }
            private static By ddlSettlement = By.Id(CommonCtrls.HumanAggrLocContent + "ddllucHumanAggregateidfsSettlement");
            private static IList<IWebElement> settlementOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.HumanAggrLocContent + "ddllucHumanAggregateidfsSettlement']/option")); } }
            private static By ddlNotSentByInst = By.Id(CommonCtrls.GeneralContent + "ddlidfSentByOffice");
            private static IList<IWebElement> NotSendByInstOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfSentByOffice']/option")); } }
            private static By ddlNotSentByOfficer = By.Id(CommonCtrls.GeneralContent + "ddlidfSentByPerson");
            private static IList<IWebElement> NotSendByOfficerOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfSentByPerson']/option")); } }
            private static By datNotSendByDate = By.Id(CommonCtrls.GeneralContent + "txtdatSentbyDate");
            private static By ddlNotRecvdByInst = By.Id(CommonCtrls.GeneralContent + "ddlidfReceivedByOffice");
            private static IList<IWebElement> NotRecvdByOrgOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfReceivedByOffice']/option")); } }
            private static By ddlNotRecvdByOfficer = By.Id(CommonCtrls.GeneralContent + "ddlidfReceivedByPerson");
            private static IList<IWebElement> NotRecvdByOfficerOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfReceivedByPerson']/option")); } }
            private static By datNotRecvdByDate = By.Id(CommonCtrls.GeneralContent + "txtdatReceivedByDate");
            private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancel");
            private static By btnNext = By.Id(CommonCtrls.GeneralContent + "btnNext");

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
                                if (Driver.Instance.FindElement(subTitleHumAggCaseDetails).Text.Contains("Human Aggregate Case Details") &&
                                    Driver.Instance.FindElement(subTitleHumAggCaseDetails).Displayed)
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

            public static void enterCaseYear(string yr)
            {
                SetMethods.enterObjectValue(ddlYear, yr);
            }

            public static void randomSelectCaseYear()
            {
                SetMethods.randomSelectObjectElement(ddlYear, yearOpts);
            }

            public static void enterCaseMonth(string mo)
            {
                SetMethods.enterObjectValue(ddlMonth, mo);
            }

            public static void randomSelectCaseMonth()
            {
                SetMethods.randomSelectObjectElement(ddlMonth, monthOpts);
            }

            public static void randomSelectCaseRegion()
            {
                SetMethods.randomSelectObjectElement(ddlRegion, regionOpts);
            }

            public static void randomSelectCaseRayon()
            {
                SetMethods.randomSelectObjectElement(ddlRayon, rayonOpts);
            }

            public static void randomSelectCaseTownOrVillage()
            {
                SetMethods.randomSelectObjectElement(ddlSettlement, settlementOpts);
            }

            public static void randomSelectNotifySentByInstitution()
            {
                SetMethods.randomSelectObjectElement(ddlNotSentByInst, NotSendByInstOpts);
            }

            public static void randomSelectNotifySentByOfficer()
            {
                SetMethods.randomSelectObjectElement(ddlNotSentByOfficer, NotSendByInstOpts);
            }

            public static void randomSelectNotifySentByDate()
            {
                SetMethods.enterCurrentDate(datNotSendByDate);
            }

            public static void randomSelectNotifyRecvdByInstitution()
            {
                SetMethods.randomSelectObjectElement(ddlNotRecvdByInst, NotRecvdByOrgOpts);
            }

            public static void randomSelectNotifyRecvdByOfficer()
            {
                SetMethods.randomSelectObjectElement(ddlNotRecvdByOfficer, NotRecvdByOfficerOpts);
            }

            public static void randomSelectNotifyRecvdByDate()
            {
                SetMethods.enterCurrentDate(datNotRecvdByDate);
            }
        }
    }
}