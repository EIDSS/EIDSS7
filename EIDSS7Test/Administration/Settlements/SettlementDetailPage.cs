using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Threading;

namespace EIDSS7Test.Administration.Settlements
{
    public class SettlementDetailPage
    {
        public static string defaultName;
        private static Random rnd = new Random();
        public static string englishNM;
        public static string settlemNM;
        public static string errorString;
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(360));

        private static By HeaderFormTitle = By.TagName("h1");
        private static By titleFormTitle = By.XPath(".//*[@id='frmMain']/div[3]/div/div/div/div/div[1]/h2");
        private static By ddlCountry = By.Id(CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsCountry");
        private static IList<IWebElement> countryOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsCountry']/option")); } }
        private static By ddlRegion = By.Id(CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsRegion");
        private static IList<IWebElement> regionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsRegion']/option")); } }
        private static By ddlRayon = By.Id(CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsRayon");
        private static IList<IWebElement> rayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsRayon']/option")); } }
        private static By txtUniqueCode = By.Id(CommonCtrls.GeneralContent + "txtstrSettlementCode");
        private static By subFormTitle = By.XPath("//*[@id='OrganizationSection']/div/div[1]/div/div[1]/h3");
        private static By txtNationalName = By.Id(CommonCtrls.GeneralContent + "txtstrNationalName");
        private static By txtSettlementName = By.Id(CommonCtrls.GeneralContent + "txtstrEnglishName");
        private static By ddlSettlementType = By.Id(CommonCtrls.GeneralContent + "ddlidfsSettlementType");
        private static IList<IWebElement> settleTypeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsSettlementType']/option")); } }
        private static By txtdblLongitude = By.Id(CommonCtrls.LocationUsrContent + "txtLocationUserControlstrLongitude");
        private static By txtdblLatitude = By.Id(CommonCtrls.LocationUsrContent + "txtLocationUserControlstrLatitude");
        private static By txtintElevation = By.Id(CommonCtrls.LocationUsrContent + "txtLocationUserControlstrElevation");
        private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmit");
        private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancel");
        private static By btnPrevious = By.Id(CommonCtrls.GeneralContent + "btnPreviousSection");
        private static By btnContinue = By.Id(CommonCtrls.GeneralContent + "btnNextSection");
        private static By linkReview = By.LinkText("Review");
        private static By linkSettlementDetails = By.LinkText("Settlement Details");
        private static By settleNameErrorMsg = By.Id(CommonCtrls.GeneralContent + "ctl10");
        private static By settleNationalNameErrorMsg = By.Id(CommonCtrls.GeneralContent + "ctl13");
        private static By settleTypeErrorMsg = By.Id(CommonCtrls.GeneralContent + "ctl18");
        private static By countryErrorMsg = By.Id(CommonCtrls.LocationUsrContent + "ctl02");
        private static By regionErrorMsg = By.Id(CommonCtrls.LocationUsrContent + "ctl05");
        private static By rayonErrorMsg = By.Id(CommonCtrls.LocationUsrContent + "ctl08");

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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Settlement Details") &&
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

        public static void clickContinue()
        {
            SetMethods.clickObjectButtons(btnContinue);
        }

        public static void clickPrevious()
        {
            SetMethods.clickObjectButtons(btnPrevious);
        }

        public static void clickSubmit()
        {
            SetMethods.clickObjectButtons(btnSubmit);
        }

        public static void clickReview()
        {
            //Scroll to bottom of the page
            Thread.Sleep(2000);
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 500)", "");
            SetMethods.clickObjectButtons(linkReview);
        }

        public static void clickCancel()
        {
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clearNationalName()
        {
            SetMethods.clearField(txtNationalName);
        }

        public static void clearSettlementName()
        {
            SetMethods.clearField(txtSettlementName);
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
            SetMethods.clearDropdownList(ddlCountry);
        }

        public static void clearSettleTypeField()
        {
            SetMethods.clearDropdownList(ddlSettlementType);
        }

        public static void doesCountryErrorMsgDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(countryErrorMsg);
        }

        public static void doesRegionErrorMsgDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(regionErrorMsg);
        }

        public static void doesRayonErrorMsgDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(rayonErrorMsg);
        }

        public static void doesSettleNameErrorMsgDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(settleNameErrorMsg);
        }

        public static void doesNationalNameErrorMsgDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(settleNationalNameErrorMsg);
        }

        public static void doesSettleTypeErrorMsgDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(settleTypeErrorMsg);
        }


        public static void selectRandomCountry()
        {
            SetMethods.randomSelectObjectElement(ddlCountry, countryOptions);
        }

        public static void selectRandomRegion()
        {
            SetMethods.RandomSelectDropdownListObjectWithRetry(ddlRegion, regionOptions);
        }

        public static void selectRandomRayon()
        {
            SetMethods.RandomSelectDropdownListObjectWithRetry(ddlRayon, rayonOptions);
        }

        public static void enterUniqueCode()
        {
            int rNum = rnd.Next(0, 1000000);
            var element = wait.Until(ExpectedConditions.ElementToBeClickable(txtUniqueCode));
            element.EnterAmount(rNum);
            Driver.Wait(TimeSpan.FromMinutes(10));
        }

        public static String enterRandomSettlementName(String settlementName)
        {
            int rNum = rnd.Next(0, 1000000);
            settlementName = settlementName + rNum;
            SetMethods.enterStringObjectValue(txtSettlementName, settlementName);
            return settlemNM = settlementName;
        }

        public static void enterNationalName()
        {
            SetMethods.enterStringObjectValue(txtNationalName, settlemNM);
        }

        public static String enterRandomNationalName(String englishName)
        {
            int rNum = rnd.Next(0, 1000000);
            englishName = englishName + rNum;
            SetMethods.enterStringObjectValue(txtNationalName, englishName);
            return englishNM = englishName;
        }

        public static void selectRandomSettlementType()
        {
            SetMethods.RandomSelectDropdownListObjectWithRetry(ddlSettlementType, settleTypeOptions);
        }


        public static void enterRandomMinLongitude()
        {
            SetMethods.enterRandomMinLongitude(txtdblLongitude);
        }

        public static void enterRandomMinLatitude()
        {
            SetMethods.enterRandomMinLatitude(txtdblLatitude);
        }

        public static void enterRandomElevation()
        {
            SetMethods.enterRandomElevation(txtintElevation);
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
