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
    public class VectorTypesEditorPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));
        public static Random rnd = new Random();
        private static By HeaderFormTitle = By.TagName("h1");
        private static By titleFormTitle = By.TagName("h2");
        private static By btnAdd = By.Id(CommonCtrls.GeneralContent + "btnAddReference");
        public static String englishValue = null;
        public static String codevalue = null;
        public static String refRecordValue = null;
        public static int orderValue = 0;
        private static By lblDeleteMsg = By.Id(CommonCtrls.GeneralContent + "lbl_Delete");
        private static By lblError = By.Id(CommonCtrls.GeneralContent + "lbl_Error");
        private static By lblSuccess = By.Id(CommonCtrls.GeneralContent + "lblSuccess");
        private static By btnPopupSuccOK = By.Id(CommonCtrls.GeneralContent + "btnErrorOK");
        private static By btnPopupOK = By.XPath("//*[@id='successModal']/div/div/div[3]/button");
        private static By btnDelete_12 = By.Id(CommonCtrls.GeneralContent + "gvVectorTypes_btnDelete_11");
        private static By lblEngValue_12 = By.Id(CommonCtrls.GeneralContent + "gvVectorTypes_lblstrDefault_11");
        private static By btnEdit_4 = By.Id(CommonCtrls.GeneralContent + "gvVectorTypes_btnEdit_4");
        private static By btnEdit_9 = By.Id(CommonCtrls.GeneralContent + "gvVectorTypes_btnEdit_9");
        private static By lblOrder_4 = By.Id(CommonCtrls.GeneralContent + "gvVectorTypes_lblOrder_4");
        private static By txtOrder_4 = By.Id(CommonCtrls.GeneralContent + "gvVectorTypes_txtOrder_4");
        private static By lblTransValue_4 = By.Id(CommonCtrls.GeneralContent + "gvVectorTypes_lblstrName_4");
        private static By txtTransValue_4 = By.Id(CommonCtrls.GeneralContent + "gvVectorTypes_txtstrName_4");
        private static By lblTransValue_10 = By.Id(CommonCtrls.GeneralContent + "gvVectorTypes_lblstrName_9");
        private static By txtTransValue_10 = By.Id(CommonCtrls.GeneralContent + "gvVectorTypes_txtstrName_9");
        private static By lblSample_4 = By.Id(CommonCtrls.GeneralContent + "gvVectorTypes_lblSampleType_4");
        private static By ddlSample_4 = By.Id(CommonCtrls.GeneralContent + "gvVectorTypes_lstSampleType_4");
        private static IList<IWebElement> sampleTypeOpts_4 { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvVectorTypes_lstSampleType_4']/option")); } }
        public static String refValue1 = null;
        public static String refValue2 = null;
        private static By btnSave_4 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvVectorTypes']/tbody/tr[5]/td[7]/a");
        private static By btnSave_10 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvVectorTypes']/tbody/tr[11]/td[7]/a");
        private static IList<IWebElement> btnEdits { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-edit']")); } }
        private static IList<IWebElement> btnDeletes { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-trash']")); } }
        private static IList<IWebElement> lblAllEngVals { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[1]/div[1]/div[1]/div[2]/div[2]/div[1]/table[1]/tbody[1]/tr/td[2]/span[1]")); } }
        private static By btnPopupYES = By.Id(CommonCtrls.GeneralContent + "btnDeleteYes");
        private static By btnPopupNO = By.XPath("//*[@id='deleteModal']/div/div/div[3]/button[2]");

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
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Vector Types List") &&
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

        public static void clickPopupSuccessOK()
        {
            SetMethods.clickObjectButtons(btnPopupSuccOK);
        }

        public static String getRefDataNumber()
        {
            var ID = Driver.Instance.FindElement(lblError).Text;
            Driver.Wait(TimeSpan.FromMinutes(20));
            return refRecordValue = ID.Substring(ID.Length - 9).TrimEnd('.');
        }

        public static void clickAddReference()
        {
            SetMethods.clickObjectButtons(btnAdd);
        }

        //public static void editRefCode(String value)
        //{
        //    int codeValue = rnd.Next(01, 99);
        //    SetMethods.enterObjectValue(txtIVT10_4, value + codeValue);
        //    refValue2 = value + codeValue;
        //}

        public static void getCurVectorTypeTransValue()
        {
            SetMethods.GetCurrentValue(txtTransValue_10);
        }

        public static void getNewVectorTypeTransValue()
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

        public static void clearTransValueField()
        {
            SetMethods.clearField(txtTransValue_10);
        }

        public static void deleteTwelfthRecordInGrid()
        {
            SetMethods.clickObjectButtons(btnDelete_12);
        }

        public static void getTwelfthTransValInGrid()
        {
            SetMethods.GetNewvalue(lblEngValue_12);
        }

        public static void doesDeleteConfirmMessageDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(lblDeleteMsg);
        }

        public static void doesVectorTypeRefRecordShowInList()
        {
            SetMethods.isElementNotPresent(lblAllEngVals, SetMethods.refValue2);
        }

        public static void clickPopupYES()
        {
            SetMethods.clickObjectButtons(btnPopupYES);
        }

        public static void clickPopupNO()
        {
            SetMethods.clickObjectButtons(btnPopupNO);
        }

        public class VectorTypePopupWndw
        {
            private static By titleFormTitle = By.TagName("h4");
            private static By txtEnglishValue = By.Id(CommonCtrls.GeneralContent + "txtVTstrDefault");
            private static By txtTransValue = By.Id(CommonCtrls.GeneralContent + "txtVTstrName");
            private static By chkCollectByPool = By.Id(CommonCtrls.GeneralContent + "chkVTbitCollectionByPool");
            private static By txtCode = By.Id(CommonCtrls.GeneralContent + "txtVTstrCode");
            private static By txtOrder = By.Id(CommonCtrls.GeneralContent + "txtVTintOrder");
            private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSaveVectorType");
            private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancelVectorType");
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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Vector Types") &&
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

            public static void enterCodeValue(string value)
            {
                int icdValue = rnd.Next(00, 99);
                SetMethods.enterObjectValue(txtCode, value + icdValue);
                codevalue = value + icdValue;
            }

            public static void enterCodeValue()
            {
                SetMethods.enterObjectValue(txtCode, codevalue);
            }



            public static void clickCollectByPoolCheckbox()
            {
                SetMethods.clickObjectButtons(chkCollectByPool);
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
