using System;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Selenium;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Collections.Generic;

namespace EIDSS7Test.Configurations
{
    public class SampleTypeDerivTypeMatrixPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));
        private static By titleFormTitle = By.TagName("h2");
        private static Random rnd = new Random();
        private static By lblSampValue_1 = By.Id(CommonCtrls.GeneralContent + "gvSampleTypeDerivativeMatrix_lblstrSampleType_0");
        private static By lblDeriveValue_1 = By.Id(CommonCtrls.GeneralContent + "gvSampleTypeDerivativeMatrix_lblstrDerivativeType_0");
        private static By btnDelete_1 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvSampleTypeDerivativeMatrix_btnDelete_0']");
        private static By lblSampValue_5 = By.Id(CommonCtrls.GeneralContent + "gvSampleTypeDerivativeMatrix_lblstrSampleType_4");
        private static By lblDeriveValue_5 = By.Id(CommonCtrls.GeneralContent + "gvSampleTypeDerivativeMatrix_lblstrDerivativeType_4");
        private static By btnDelete_5 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvSampleTypeDerivativeMatrix_btnDelete_4']");
        private static By cancelMsg = By.Id(CommonCtrls.GeneralContent + "lbl_Cancel");
        private static By lblError = By.Id(CommonCtrls.GeneralContent + "lbl_Continue_Required");
        private static By lblSuccess = By.Id(CommonCtrls.GeneralContent + "lblSuccess");
        //private static By btnPopupOK = By.XPath("btnError");
        private static By btnPopupOK = By.XPath("//*[@id='successModal']/div/div/div[3]/button");
        private static By btnPopupRequirYES = By.Id(CommonCtrls.GeneralContent + "btnContinueRequiredYes");
        private static By btnPopupRequirNO = By.Id(CommonCtrls.GeneralContent + "btnContinueRequiredNo");
        private static By btnPopupErrOK = By.Id(CommonCtrls.GeneralContent + "btnErrorOK");
        private static By btnCancelYES = By.Id(CommonCtrls.GeneralContent + "btnCancelYes");
        private static By btnCancelNO = By.Id(CommonCtrls.GeneralContent + "btnCancelNo");
        private static By btnSuccessOK = By.Id(CommonCtrls.GeneralContent + "btnSuccessOK");
        private static By btnAddSampleDerivType = By.Id(CommonCtrls.GeneralContent + "btnAddSampleTypeDerivativeMatrix");
        private static IList<IWebElement> lblAllSampTypeVals { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[1]/div[1]/div[1]/div[2]/div[2]/div[1]/table[1]/tbody[1]/tr/td[2]/span[1]")); } }
        private static IList<IWebElement> lblAllDerivTypeVals { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[1]/div[1]/div[1]/div[2]/div[2]/div[1]/table[1]/tbody[1]/tr/td[3]/span[1]")); } }
        private static By lblMandatoryErrorMsg = By.Id(CommonCtrls.GeneralContent + "lbl_Continue_Required");
        private static By lblDeleteMsg = By.Id(CommonCtrls.GeneralContent + "lbl_Delete");
        private static By lblDeleteAnywayMsg = By.Id(CommonCtrls.GeneralContent + "lbl_Delete_Anyway");
        private static By btnErrorOK = By.Id(CommonCtrls.GeneralContent + "btnErrorOK");
        private static By btnPopupYES = By.Id(CommonCtrls.GeneralContent + "btnDeleteYes");
        private static By btnPopupAnywayYES = By.Id(CommonCtrls.GeneralContent + "btnDeleteAnywayYes");
        private static By btnPopupNO = By.XPath("//*[@id='deleteModal']/div/div/div[3]/button[2]");
        private static By btnPopupAnywayNO = By.XPath("//*[@id='currentlyInUseModal']/div/div/div[3]/button[2]");
        public static String englishValue = null;
        public static String codeValue = null;
        public static String refRecordValue = null;
        public static int orderValue = 0;



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
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Sample Type-Derivative Type Matrix") &&
                            Driver.Instance.FindElement(titleFormTitle).Displayed)
                            return true;
                        else
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("This is not the correct title");
                        return false;
                    }
                }
                else
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("This is not the correct title");
                    return false;
                }
            }
        }

        public static void clickCancelYES()
        {
            SetMethods.clickObjectButtons(btnCancelYES);
        }

        public static void clickCancelNO()
        {
            SetMethods.clickObjectButtons(btnCancelNO);
        }

        public static void clickAddSampleDervType()
        {
            SetMethods.clickObjectButtons(btnAddSampleDerivType);
        }

        public static void doesPopupSuccessMessageDisplay()
        {
            if (Driver.Instance.FindElement(lblSuccess).Displayed)
            {
                SetMethods.clickObjectButtons(btnPopupOK);
            }
            else
            {
                SetMethods.clickObjectButtons(btnPopupErrOK);
            }
        }

        public static void doesRequiredMandatoryMessageDisplay()
        {
            try
            {
                SetMethods.doesValidationErrorMessageDisplay(lblMandatoryErrorMsg);
                clickPopupRequiredNO();
            }
            catch (Exception ex)
            {
                Assert.Fail("Error message does not displays" + ex);
            }

        }

        public static void doesDeleteConfirmMessageForRecordDisplay()
        {
            if (Driver.Instance.FindElement(lblDeleteMsg).Displayed)
            {
                SetMethods.clickObjectButtons(btnPopupYES);
                SetMethods.clickObjectButtons(btnPopupOK);
            }
            else if (Driver.Instance.FindElement(lblDeleteAnywayMsg).Displayed)
            {
                SetMethods.clickObjectButtons(btnPopupAnywayYES);
                SetMethods.clickObjectButtons(btnPopupOK);
            }
            else
            {
                SetMethods.clickObjectButtons(btnPopupErrOK);
            }
        }

        public static void doesSampleTypeDerivativeRecordShowInListNO(String value)
        {
            SetMethods.isElementNotPresent(lblAllSampTypeVals, value);
        }

        public static void doesSampleTypeDerivativeRecordShowInLisYES(String value)
        {
            SetMethods.isElementPresent(lblAllDerivTypeVals, value);
        }

        public static void getFirstSampleValInGrid()
        {
            SetMethods.GetNewvalue(lblSampValue_1);
        }

        public static void getFirstDerivativeValNoInGrid()
        {
            SetMethods.GetNewvalue4(lblDeriveValue_1);
        }

        public static void deleteFirstRecordInGrid()
        {
            SetMethods.clickObjectButtons(btnDelete_1);
        }

        public static void getFifthSampleValInGrid()
        {
            SetMethods.GetNewvalue(lblSampValue_5);
        }

        public static void getFifthDerivativeValNoInGrid()
        {
            SetMethods.GetNewvalue4(lblDeriveValue_5);
        }

        public static void deleteFifthRecordInGrid()
        {
            SetMethods.clickObjectButtons(btnDelete_5);
        }

        public static void clickPopupRequiredYES()
        {
            SetMethods.clickObjectButtons(btnPopupRequirYES);
        }

        public static void clickPopupRequiredNO()
        {
            SetMethods.clickObjectButtons(btnPopupRequirNO);
        }




        public class SampleTypePopupWndw
        {
            private static By titleFormTitle = By.TagName("h4");
            private static By txtSOrder = By.Id(CommonCtrls.GeneralContent + "txtSTintOrder");
            private static By txtDOrder = By.Id(CommonCtrls.GeneralContent + "txtDintOrder");
            private static By txtDEngValue = By.Id(CommonCtrls.GeneralContent + "txtDstrDefault");
            private static By txtDTransValue = By.Id(CommonCtrls.GeneralContent + "txtDstrName");
            private static By txtDSampleCode = By.Id(CommonCtrls.GeneralContent + "txtDstrCode");
            private static By ddlAccessoryCode = By.Id(CommonCtrls.GeneralContent + "lstSTHACode");
            private static IList<IWebElement> accessCodeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lstSTHACode']/option")); } }
            private static By ddlDAccessoryCode = By.Id(CommonCtrls.GeneralContent + "lstDHACode");
            private static IList<IWebElement> accessDCodeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lstDHACode']/option")); } }
            private static By ddlSampleType = By.Id(CommonCtrls.GeneralContent + "ddlidfsSampleType");
            private static IList<IWebElement> sampleTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsSampleType']/option")); } }
            private static By btnAddSampleType = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "btnAddSampleType']/span");
            private static By ddlDerivative = By.Id(CommonCtrls.GeneralContent + "ddlidfsDerivative");
            private static IList<IWebElement> derivativeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsDerivative']/option")); } }
            private static By btnAddDerivative = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "btnAddDerivative']/span");
            private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmitSampleTypeDerivative");
            private static By btnSubmitSampleType = By.Id(CommonCtrls.GeneralContent + "btnSubmitSampleType");
            private static By btnSubmitDerivativeType = By.Id(CommonCtrls.GeneralContent + "btnSubmitDerivative");
            private static By btnCancelSampleType = By.Id(CommonCtrls.GeneralContent + "btnCancelSampleType");
            private static By btnCancelDerivativeType = By.Id(CommonCtrls.GeneralContent + "btnCancelDerivative");
            private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancelSampleTypeDerivative");

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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Sample Type-Derivative Type Matrix") &&
                                Driver.Instance.FindElement(titleFormTitle).Displayed)
                                return true;
                            else
                                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("This is not the correct title");
                            return false;
                        }
                    }
                    else
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("This is not the correct title");
                        return false;
                    }
                }
            }

            public static void randomSelectSampleType()
            {
                SetMethods.randomSelectObjectElement(ddlSampleType, sampleTypeOpts);
            }

            public static void enterSampleType(String value)
            {
                SetMethods.enterObjectValue(ddlSampleType, value);
            }

            public static void getCurrentSampleType()
            {
                SetMethods.GetNewvalue(ddlSampleType);
            }

            public static void clickNewSampleType()
            {
                SetMethods.clickObjectButtons(btnAddSampleType);
            }

            public static void randomSelectDerivative()
            {
                SetMethods.randomSelectObjectElement(ddlDerivative, derivativeOpts);
            }

            public static void enterDerivativeType(String value)
            {
                SetMethods.enterObjectValue(ddlDerivative, value);
            }

            public static void getCurrentDerivativeType()
            {
                SetMethods.GetNewvalue4(ddlDerivative);
            }

            public static void clickNewDerivative()
            {
                SetMethods.clickObjectButtons(btnAddDerivative);
            }

            public static void randomEnterSampleTypeOrder()
            {
                int orderValue = rnd.Next(1, 100);
                SetMethods.enterIntObjectValue(txtSOrder, orderValue);
            }

            public static void randomEnterDerivaTypeOrder()
            {
                int orderValue = rnd.Next(1, 100);
                SetMethods.enterIntObjectValue(txtDOrder, orderValue);
            }

            public static void enterDEnglishValue(String value)
            {
                int numValue = rnd.Next(10000, 99999);
                SetMethods.enterObjectValue(txtDEngValue, value + numValue);
                englishValue = value + numValue;
            }

            public static void enterManualDEnglishValue()
            {
                SetMethods.enterObjectValue(txtDEngValue, SetMethods.refValue2);
            }

            public static void enterDTransValue()
            {
                SetMethods.enterObjectValue(txtDTransValue, englishValue);
            }

            public static void enterManualDTransValue()
            {
                SetMethods.enterObjectValue(txtDTransValue, SetMethods.refValue2);
            }

            public static void enterRandomSampleCodeValue(string value)
            {
                int codeVal = rnd.Next(00, 99);
                SetMethods.enterObjectValue(txtDSampleCode, value + codeVal);
                codeValue = value + codeVal;
            }

            public static void enterDSampleCodeValue(String value)
            {
                int codeVal = rnd.Next(00, 99);
                SetMethods.enterObjectValue(txtDSampleCode, value + codeVal);
                codeValue = value + codeVal;
            }

            public static void randomSelectAccessoryCode()
            {
                SetMethods.randomSelectObjectElement(ddlAccessoryCode, accessCodeOpts);
            }

            public static void enterAccessoryCode(string value)
            {
                SetMethods.enterObjectValue(ddlAccessoryCode, value);
            }

            public static void randomSelectDAccessoryCode()
            {
                SetMethods.randomSelectObjectElement(ddlDAccessoryCode, accessDCodeOpts);
            }

            public static void enterDAccessoryCode(string value)
            {
                SetMethods.enterObjectValue(ddlDAccessoryCode, value);
            }



            public static void clickSubmit()
            {
                SetMethods.clickObjectButtons(btnSubmit);
            }

            public static void clickSubmitSampleType()
            {
                SetMethods.clickObjectButtons(btnSubmitSampleType);
            }

            public static void clickSubmitDerivativeType()
            {
                SetMethods.clickObjectButtons(btnSubmitDerivativeType);
            }

            public static void clickCancel()
            {
                SetMethods.clickObjectButtons(btnCancel);
            }
        }
    }
}
