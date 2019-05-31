using System;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Selenium;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Collections.Generic;
using System.Threading;

namespace EIDSS7Test.Administration.ReferenceEditor
{
    public class DiseasesPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));
        public static Random rnd = new Random();
        private static By HeaderFormTitle = By.TagName("h1");
        private static By titleFormTitle = By.TagName("h2");
        private static By btnAdd = By.Id(CommonCtrls.GeneralContent + "btnAddReference");
        public static String englishValue = null;
        public static String idc10value = null;
        public static String refRecordValue = null;
        public static int orderValue = 0;
        private static By lblError = By.Id(CommonCtrls.GeneralContent + "lbl_Error");
        private static By lblSuccess = By.Id(CommonCtrls.GeneralContent + "lblSuccess");
        private static By btnPopupOK = By.XPath("//*[@id='successModal']/div/div/div[3]/button");
        private static By btnEdit_4 = By.Id(CommonCtrls.GeneralContent + "gvDiseases_btnEdit_4");
        private static By btnEdit_9 = By.Id(CommonCtrls.GeneralContent + "gvDiseases_btnEdit_9");
        private static By lblICD10_4 = By.Id(CommonCtrls.GeneralContent + "gvDiseases_lbstrIDC10_4");
        private static By txtICD10_4 = By.Id(CommonCtrls.GeneralContent + "gvDiseases_txtstrIDC10_4");
        private static By lblOrder_4 = By.Id(CommonCtrls.GeneralContent + "gvDiseases_lblOrder_4");
        private static By txtOrder_4 = By.Id(CommonCtrls.GeneralContent + "gvDiseases_txtOrder_4");
        private static By lblTransValue_4 = By.Id(CommonCtrls.GeneralContent + "gvDiseases_lblstrName_4");
        private static By txtTransValue_4 = By.Id(CommonCtrls.GeneralContent + "gvDiseases_txtstrName_4");
        private static By lblTransValue_10 = By.Id(CommonCtrls.GeneralContent + "gvDiseases_lblstrName_9");
        private static By txtTransValue_10 = By.Id(CommonCtrls.GeneralContent + "gvDiseases_txtstrName_9");
        private static By lblSample_4 = By.Id(CommonCtrls.GeneralContent + "gvDiseases_lblSampleType_4");
        private static By ddlSample_4 = By.Id(CommonCtrls.GeneralContent + "gvDiseases_lstSampleType_4");
        private static IList<IWebElement> sampleTypeOpts_4 { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvDiseases_lstSampleType_4']/option")); } }
        public static String refValue1 = null;
        public static String refValue2 = null;
        private static By btnSave_4 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvDiseases']/tbody/tr[6]/td[14]/a");
        private static By btnSave_10 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvDiseases']/tbody/tr[11]/td[14]/a");


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
                else if (Driver.Instance.FindElements(titleFormTitle).Count > 0)
                {
                    {
                        Thread.Sleep(5000);
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Diseases List") &&
                            Driver.Instance.FindElement(titleFormTitle).Displayed)
                            return true;
                        else
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                }
                else if (Driver.Instance.FindElement(HeaderFormTitle).Text.Contains("This page isn't working"))
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                    return false;
                }
                else
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Page cannot be displayed");
                    return false;
                }
            }
        }

        public static void clickPopupOK()
        {
            SetMethods.clickObjectButtons(btnPopupOK);
        }

        public static String getRefDataNumber()
        {
            var ID = Driver.Instance.FindElement(lblSuccess).Text;
            Driver.Wait(TimeSpan.FromMinutes(20));
            return refRecordValue = ID.Substring(ID.Length - 9).TrimEnd('.');
        }

        public static void clickAddReference()
        {
            SetMethods.clickObjectButtons(btnAdd);
        }

        public static void editRefCode(String value)
        {
            int codeValue = rnd.Next(01, 99);
            SetMethods.enterObjectValue(txtICD10_4, value + codeValue);
            refValue2 = value + codeValue;
        }

        public static void getCurDiseaseICD10Value()
        {
            SetMethods.GetCurrentValue(txtICD10_4);
        }

        public static void getNewDiseaseICD10Value()
        {
            SetMethods.GetNewvalue(lblICD10_4);
        }

        public static void getCurDiseaseTransValue()
        {
            SetMethods.GetCurrentValue(txtTransValue_10);
        }

        public static void getNewDiseaseTransValue()
        {
            SetMethods.GetNewvalue(lblTransValue_10);
        }

        public static void enterNewTransValue()
        {
            SetMethods.EditRefValue(txtTransValue_10, "DIS");
        }

        public static void clickSaveFourthRecord()
        {
            SetMethods.clickObjectButtons(btnSave_4);
        }

        public static void editFourthRecordInGird()
        {
            SetMethods.clickObjectButtons(btnEdit_4);
        }

        public static void clickSaveTenthRecord()
        {
            SetMethods.clickObjectButtons(btnSave_10);
        }

        public static void editTenthRecordInGird()
        {
            //Scroll back to the bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1100)", "");
            SetMethods.clickObjectButtons(btnEdit_9);
        }

        public static void clearICD10CodeField()
        {
            SetMethods.clearField(txtICD10_4);
        }

        public static void clearTransValueField()
        {
            SetMethods.clearField(txtTransValue_10);
        }

        public class DiseasesPopupWndw
        {
            private static By titleFormTitle = By.TagName("h4");
            private static By txtEnglishValue = By.Id(CommonCtrls.GeneralContent + "txtCDstrDefault");
            private static By txtTransValue = By.Id(CommonCtrls.GeneralContent + "txtCDstrName");
            private static By txtIDC10Value = By.Id(CommonCtrls.GeneralContent + "txtCDstrIDC10");
            private static By txtOIECode = By.Id(CommonCtrls.GeneralContent + "txtCDstrOIECode");
            private static By ddlUsingType = By.Id(CommonCtrls.GeneralContent + "ddlCDidfsUsingType");
            private static IList<IWebElement> usingTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlCDidfsUsingType']/option")); } }
            private static By ddlAccessoryCode = By.Id(CommonCtrls.GeneralContent + "lstCDHACode");
            private static IList<IWebElement> accessCodeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lstCDHACode']/option")); } }
            private static By ddlPensideTest = By.Id(CommonCtrls.GeneralContent + "lstCDPensideTest");
            private static IList<IWebElement> pensideOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lstCDPensideTest']/option")); } }
            private static By ddlLabTests = By.Id(CommonCtrls.GeneralContent + "lstCDLabTest");
            private static IList<IWebElement> labOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lstCDLabTest']/option")); } }
            private static By ddlSampleType = By.Id(CommonCtrls.GeneralContent + "lstCDSampleType");
            private static IList<IWebElement> sampleTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lstCDSampleType']/option")); } }
            private static By chkZoonotic = By.Id(CommonCtrls.GeneralContent + "chkCDblnZoonotic");
            private static By chkSynSurv = By.Id(CommonCtrls.GeneralContent + "chkCDblnSyndrome");
            private static By txtOrder = By.Id(CommonCtrls.GeneralContent + "txtCDintOrder");
            private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSaveDiagnosis");
            private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancelAdd");
            private static By btnSpinnerUp = By.XPath("//*[@class='glyphicon glyphicon-triangle-top']");
            private static By btnSpinnerDwn = By.XPath("//*[@class='glyphicon glyphicon-triangle-bottom']");


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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Diseases") &&
                                Driver.Instance.FindElement(titleFormTitle).Displayed)
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

            public static void enterEnglishValue(String value)
            {
                int numValue = rnd.Next(10000, 99999);
                SetMethods.enterObjectValue(txtEnglishValue, value + numValue);
                englishValue = value + numValue;
            }

            public static void enterTransValue()
            {
                SetMethods.enterObjectValue(txtTransValue, englishValue);
            }

            public static void enterIDC10Value(string value)
            {
                int icdValue = rnd.Next(00, 99);
                SetMethods.enterObjectValue(txtIDC10Value, value + icdValue);
                idc10value = value + icdValue;
            }

            public static void enterOIECodeValue()
            {
                SetMethods.enterObjectValue(txtOIECode, idc10value);
            }

            public static void enterUsingType(string value)
            {
                SetMethods.enterObjectValue(ddlUsingType, value);
            }

            public static void randomSelectAccessoryCode()
            {
                SetMethods.randomSelectObjectElement(ddlAccessoryCode, accessCodeOpts);
            }

            public static void enterAccessoryCode(string value)
            {
                SetMethods.enterObjectValue(ddlAccessoryCode, value);
            }

            public static void randomSelectPensideTest()
            {
                SetMethods.randomSelectObjectElement(ddlPensideTest, pensideOpts);
            }

            public static void enterPensideTest(string value)
            {
                SetMethods.enterObjectValue(ddlPensideTest, value);
            }

            public static void randomSelectLabTests()
            {
                SetMethods.randomSelectObjectElement(ddlLabTests, labOpts);
            }

            public static void enterLabTest(string value)
            {
                SetMethods.enterObjectValue(ddlLabTests, value);
            }

            public static void randomSelectSampleType()
            {
                SetMethods.randomSelectObjectElement(ddlSampleType, sampleTypeOpts);
            }

            public static void enterSampleType(string value)
            {
                SetMethods.enterObjectValue(ddlSampleType, value);
            }

            public static void clickSyndromeSurvCheckbox()
            {
                SetMethods.clickObjectButtons(chkSynSurv);
            }

            public static void clickZoonoticCheckbox()
            {
                SetMethods.clickObjectButtons(chkZoonotic);
            }

            public static void clickOrderUpSpinner()
            {
                for (int i = 0; i < 15; i++)
                {
                    SetMethods.clickObjectButtons(btnSpinnerUp);
                }
            }

            public static void clickOrderDownSpinner()
            {
                for (int i = 0; i < 2; i++)
                {
                    SetMethods.clickObjectButtons(btnSpinnerDwn);
                }
            }

            public static void enterOrder(int value)
            {
                SetMethods.enterIntObjectValue(txtOrder, value);
            }

            public static void randomEnterOrder()
            {
                int orderValue = rnd.Next(1, 100);
                SetMethods.enterIntObjectValue(txtOrder, orderValue);
            }
            public static void clickSubmit()
            {
                SetMethods.clickObjectButtons(btnSubmit);
            }

            public static void clickCancel()
            {
                SetMethods.clickObjectButtons(btnCancel);
            }
        }
    }
}
