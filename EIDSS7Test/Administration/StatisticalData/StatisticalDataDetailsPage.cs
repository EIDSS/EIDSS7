using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using System.Threading;
using NUnit.Framework;

namespace EIDSS7Test.Administration.StatisticalData
{
    public class StatisticalDataDetailsPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));
        public static Random rnd = new Random();
        public static string errorString;
        public static string currentDate;
        public static String getValue;
        public static int getValue2;


        private static By titleFormTitle = By.XPath("//*[@id='frmMain']/div[3]/div/div/div/div/div[1]/h2");
        private static By subtitleFormTitle = By.Id("h3");
        private static By lblStatisticalDataType = By.Name("Statistical Data Type");
        private static By ddlStatisticalDataType = By.Id(CommonCtrls.GeneralContent + "ddlidfsStatisticDataType");
        private static IList<IWebElement> statDatTypeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsStatisticDataType']/option")); } }
        private static By lblStatisticalPeriodType = By.Name("Statistical Period Type");
        private static By txtStatisticalPeriodType = By.Id(CommonCtrls.GeneralContent + "txtsetnPeriodTypeName");
        private static By lblStatisticalDateforPeriod = By.Name("Statistical Date for Period");
        private static By datStatisticalStartDateforPeriod = By.Id(CommonCtrls.GeneralContent + "txtdatStatisticStartDate");
        private static By lblStatisticalAreaType = By.Name("Statistical Area Type");
        private static By txtStatAreaType = By.Id(CommonCtrls.GeneralContent + "txtsetnAreaTypeName");
        private static By lblArea = By.Name("Statistical Area Type");
        private static By ddlArea = By.Id(CommonCtrls.GeneralContent + "ddlStatisticalArea");
        private static IList<IWebElement> areaOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlStatisticalArea']/option")); } }
        private static By ddlCountry = By.Id(CommonCtrls.GeneralContent + "ddlLocationUserControlidfsCountry");
        private static IList<IWebElement> countryOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlLocationUserControlidfsCountry']/option")); } }
        private static By ddlRegion = By.Id(CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsRegion");
        private static IList<IWebElement> regionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsRegion']/option")); } }
        private static By ddlRayon = By.Id(CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsRayon");
        private static IList<IWebElement> rayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationUsrContent + "ddlLocationUserControlidfsRayon']/option")); } }
        private static By lblValue = By.Name("Value");
        private static By txtValue = By.Id(CommonCtrls.GeneralContent + "txtvarValue");
        private static By lblAgeGroup = By.Name("Statistical Age Group");
        private static By ddlAgeGroup = By.Id(CommonCtrls.GeneralContent + "ddlidfsStatisticalAgeGroup");
        private static IList<IWebElement> ageGrpOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlstrStatisticalAgeGroup']/option")); } }
        private static By txtParameterType = By.Id(CommonCtrls.GeneralContent + "txtParameterType");
        private static By lblParameter = By.Name("Parameter");
        private static By ddlParameter = By.Id(CommonCtrls.GeneralContent + "ddlidfsParameterName");
        private static IList<IWebElement> parmOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsParameterName']/option")); } }
        private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancel");
        private static By btnEdit = By.XPath("//*[@id='EIDSSBodyCPH_StatisticalDataSection']/div/div[1]/div/div[2]/a");
        private static By btnContinue = By.Id(CommonCtrls.GeneralContent + "btnNextSection");
        private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmit");
        private static By linkReview = By.LinkText("Review");
        private static By linkStatDataDetails = By.LinkText("Statistical Data Details");
        private static By btnSpinnerUp = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "txtvarValue_buttons']/button[1]");
        private static By btnSpinnerDown = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "txtvarValue_buttons']/button[2]");
        private static By statPeriodTypeErrorMsg = By.Id(CommonCtrls.GeneralContent + "ctl07");
        private static By statPeriodDateErrorMsg = By.Id(CommonCtrls.GeneralContent + "valDay");
        private static By statAreaTypeErrorMsg = By.Id(CommonCtrls.GeneralContent + "ctl08");
        private static By statParmTypeErrorMsg = By.Id(CommonCtrls.GeneralContent + "rfvParameterType");
        private static By regionErrorMsg = By.Id(CommonCtrls.LocationUsrContent + "ctl05");
        private static By countryErrorMsg = By.Id(CommonCtrls.LocationUsrContent + "ctl02");
        private static By rayonErrorMsg = By.Id(CommonCtrls.LocationUsrContent + "ctl08");
        private static By statValueErrorMsg = By.Id(CommonCtrls.GeneralContent + "ctl09");
        public static String statPeriodTypeError = "Statistical Period Type is required.";
        public static String statAreaTypeError = "Statistical Area Type is required.";
        public static String statPeriodDateError = "Statistical Date for Period is required.";
        public static String statRegionError = "Region is required.";
        public static String statRayonError = "Rayon is required.";
        public static String statValueError = "Value is required.";


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
                    {
                        Driver.Wait(TimeSpan.FromMinutes(15));
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Statistical Data Details") &&
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


        public static void clearField(By el)
        {
            var element = wait.Until(ExpectedConditions.ElementToBeClickable(el));
            element.Clear();
            element.SendKeys(Keys.Tab);
            Driver.Wait(TimeSpan.FromMinutes(10));
        }

        public static void clearStatPeriodType()
        {
            clearField(txtStatisticalPeriodType);
        }

        public static void clearStatPeriodDate()
        {
            clearField(datStatisticalStartDateforPeriod);
        }

        public static void clearStatAreaType()
        {
            clearField(txtStatAreaType);
        }

        public static void clearStatParameterType()
        {
            clearField(txtParameterType);
        }

        public static void clearValue()
        {
            clearField(txtValue);
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
                    Driver.Wait(TimeSpan.FromMinutes(10));
                }
                break;
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
            SetMethods.clearDropdownList(ddlCountry);
        }


        public static void doesStatRegionErrorMsgDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(regionErrorMsg);
        }

        public static void doesStatRayonErrorMsgDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(rayonErrorMsg);
        }

        public static void doesStatPeriodTypeErrorMsgDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(statPeriodTypeErrorMsg);
        }

        public static void doesStatDateForPeriodErrorMsgDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(statPeriodDateErrorMsg);
        }

        public static void doesStatAreaTypeErrorMsgDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(statAreaTypeErrorMsg);
        }

        public static void doesStatValueErrorMsgDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(statValueErrorMsg);
        }

        public static void doesStatParmTypeErrorMsgDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(statParmTypeErrorMsg);
        }

        public static void selectStatisticalDataType(string datatype)
        {
            var statdatatype = wait.Until(ExpectedConditions.ElementIsVisible(ddlStatisticalDataType));
            foreach (IWebElement opt in statDatTypeOptions)
            {
                if (opt.Text.Contains(datatype))
                {
                    opt.Click();
                    Thread.Sleep(120);
                    break;
                }
            }
        }

        public static void enterStatPeriodType(string type)
        {
            SetMethods.enterObjectValue(txtStatisticalPeriodType, type);
        }

        public static void enterStartDateForPeriod()
        {
            SetMethods.enterCurrentDate(datStatisticalStartDateforPeriod);
        }

        public static void selectCurrentDate()
        {
            SetMethods.enterCurrentDate(datStatisticalStartDateforPeriod);
        }

        public static void enterStatDataValue(int value)
        {
            SetMethods.enterIntObjectValue(txtValue, value);
        }

        public static void enterParameterType(string type)
        {
            SetMethods.enterObjectValue(txtParameterType, type);
        }


        public static void doesParmeterTypeDisplay(string type)
        {
            var parmType = wait.Until(ExpectedConditions.ElementIsVisible(txtParameterType)).Text;
            Driver.Wait(TimeSpan.FromMinutes(10));
            if (parmType.Contains(type))
            {
                Assert.IsTrue(true);
            }
            else
            {
                Assert.IsFalse(false);
            }
        }

        public static void doesStatisticalPeriodTypeDisplay(string type)
        {
            var parmType = wait.Until(ExpectedConditions.ElementIsVisible(txtStatisticalPeriodType)).Text;
            Driver.Wait(TimeSpan.FromMinutes(10));
            if (parmType.Contains(type))
            {
                Assert.IsTrue(true);
                Driver.Wait(TimeSpan.FromMinutes(10));
            }
            else
            {
                Assert.IsFalse(false);
                Driver.Wait(TimeSpan.FromMinutes(10));
            }
        }

        public static void doesStatisticalRegionDisplay(string type)
        {
            var Type = wait.Until(ExpectedConditions.ElementIsVisible(ddlRegion)).Text;
            Driver.Wait(TimeSpan.FromMinutes(10));
            if (Type.Contains(type))
            {
                Assert.IsTrue(true);
                Driver.Wait(TimeSpan.FromMinutes(10));
            }
            else
            {
                Assert.IsFalse(false);
                Driver.Wait(TimeSpan.FromMinutes(10));
            }
        }

        public static void doesStatisticalAreaTypeDisplay(string type)
        {
            var parmType = wait.Until(ExpectedConditions.ElementIsVisible(txtStatAreaType)).Text;
            Driver.Wait(TimeSpan.FromMinutes(10));
            if (parmType.Contains(type))
            {
                Assert.IsTrue(true);
                Driver.Wait(TimeSpan.FromMinutes(10));
            }
            else
            {
                Assert.IsFalse(false);
                Driver.Wait(TimeSpan.FromMinutes(10));
            }
        }

        public static void randomSelectParameter()
        {
            SetMethods.randomSelectObjectElement(ddlParameter, parmOptions);
        }

        public static void enterParameter(string parm)
        {
            SetMethods.enterObjectDropdownListValue(ddlParameter, parm);
        }

        public static void enterRandomStatDataValue()
        {
            int rNum = rnd.Next(0, 2000);
            SetMethods.enterIntObjectValue(txtValue, rNum);
            getValue2 = rNum;
        }

        public static void getValueFromValueField()
        {
            var element = wait.Until(ExpectedConditions.ElementIsVisible(txtValue)).Text;
            Driver.Wait(TimeSpan.FromMinutes(10));
            getValue = element;
        }

        private static void clickSpinnerUpTwelveTimes(By el)
        {
            var element = wait.Until(ExpectedConditions.ElementIsVisible(el));
            Thread.Sleep(120);
            Driver.Wait(TimeSpan.FromMinutes(10));
            for (int i = 0; i <= 25; i++)
            {
                element.Click();
                Driver.Wait(TimeSpan.FromMinutes(10));
            }
        }

        public static void clickSpinnerUp()
        {
            clickSpinnerUpTwelveTimes(btnSpinnerUp);
        }

        public static void clickSpinnerDown()
        {
            Thread.Sleep(120);
            clickSpinnerUpTwelveTimes(btnSpinnerDown);
            Driver.Wait(TimeSpan.FromMinutes(10));
        }

        public static void clickArea()
        {
            var element = wait.Until(ExpectedConditions.ElementIsVisible(ddlArea));
            element.Click();
            Driver.Wait(TimeSpan.FromMinutes(10));
        }

        public static void selectRandomCountry()
        {
            SetMethods.randomSelectObjectElement(ddlCountry, countryOptions);
        }

        public static void selectRandomAreaCountry()
        {
            SetMethods.randomSelectObjectElement(ddlArea, areaOptions);
        }

        public static void enterStatAreaType(string type)
        {
            SetMethods.enterObjectValue(txtStatAreaType, type);
        }

        public static void selectRegion(string el)
        {
            SetMethods.enterObjectDropdownListValue(ddlRegion, el);
        }
        public static void selectRandomRegion()
        {
            SetMethods.RandomSelectDropdownListObjectWithRetry(ddlRegion, regionOptions);
        }

        public static void selectRayon(string el)
        {
            SetMethods.enterObjectDropdownListValue(ddlRayon, el);
        }
        public static void selectRandomRayon()
        {
            SetMethods.RandomSelectDropdownListObjectWithRetry(ddlRayon, rayonOptions);
        }

        public static void selectRandomStatAgeGroup()
        {
            SetMethods.RandomSelectDropdownListObjectWithRetry(ddlAgeGroup, ageGrpOptions);
        }

        public static void selectRandomParameter()
        {
            SetMethods.RandomSelectDropdownListObjectWithRetry(ddlParameter, parmOptions);
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


        public static void clickEdit()
        {
            SetMethods.clickObjectButtons(btnEdit);
        }

        public static void clickCancel()
        {
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static Boolean isStatDataTypeDisabled()
        {
            return SetMethods.isFieldDisabled(txtStatAreaType);
        }

        public static Boolean isRayonEnabled()
        {
            return SetMethods.isFieldDisabled(ddlRayon);
        }

        public static Boolean isRayonDisabled()
        {
            return SetMethods.isFieldDisabled(ddlRayon);
        }

        public static Boolean isStartDateForPeriodDisabled()
        {
            return SetMethods.isFieldDisabled(datStatisticalStartDateforPeriod);
        }

        public static void clickSubmit()
        {
            SetMethods.clickObjectButtons(btnSubmit);
        }

        public static void clickReview()
        {
            //Scroll back up to the top of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0,-250)", "");
            SetMethods.clickObjectButtons(linkReview);
        }

        public static void clickContinue()
        {
            SetMethods.clickObjectButtons(btnContinue);
        }
    }
}