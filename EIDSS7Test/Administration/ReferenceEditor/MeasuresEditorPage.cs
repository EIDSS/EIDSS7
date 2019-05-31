using System;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Selenium;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Collections.Generic;

namespace EIDSS7Test.Administration.ReferenceEditor
{
    public class MeasuresEditorPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));
        public static Random rnd = new Random();
        private static By titleFormTitle = By.TagName("h2");
        public static int orderValue = 0;
        private static By btnAdd = By.Id(CommonCtrls.GeneralContent + "btnAddReference");
        private static By tlbMeasures = By.Id(CommonCtrls.GeneralContent + "gvMeasures");
        private static By ddlMeasures = By.Id(CommonCtrls.GeneralContent + "ddlMeasures");
        private static By btnEdit_4 = By.Id(CommonCtrls.GeneralContent + "gvMeasures_btnEdit_4");
        private static By btnEdit_10 = By.Id(CommonCtrls.GeneralContent + "gvMeasures_btnEdit_9");
        private static By btnDelete_7 = By.Id(CommonCtrls.GeneralContent + "gvMeasures_btnDelete_6");
        private static By lblEngValue_7 = By.Id(CommonCtrls.GeneralContent + "gvMeasures_lblstrDefault_6");
        private static By txtOrder_10 = By.Id(CommonCtrls.GeneralContent + "gvMeasures_txtintOrder_9");
        private static By lblOrder_10 = By.Id(CommonCtrls.GeneralContent + "gvMeasures_lblintOrder_9");
        private static By txtTransValue_10 = By.Id(CommonCtrls.GeneralContent + "gvMeasures_txtstrName_9");
        private static By lblTransValue_10 = By.Id(CommonCtrls.GeneralContent + "gvMeasures_lblstrName_9");
        private static By txtCode_4 = By.Id(CommonCtrls.GeneralContent + "gvMeasures_txtstrActionCode_4");
        private static By lblCode_4 = By.Id(CommonCtrls.GeneralContent + "gvMeasures_lblstrActionCode_4");
        private static IList<IWebElement> measureOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlMeasures']/option")); } }
        private static IList<IWebElement> btnEdits { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-edit']")); } }
        private static IList<IWebElement> btnDeletes { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-trash']")); } }
        private static IList<IWebElement> lblAllEngVals { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[1]/div[1]/div[1]/div[2]/div[2]/div[1]/table[1]/tbody[1]/tr/td[2]/span[1]")); } }
        public static String englishValue = null;
        public static String refRecordValue = null;
        public static String refCodeValue = null;
        private static By lblSuccess = By.Id(CommonCtrls.GeneralContent + "lblSuccess");
        private static By btnPopupOK = By.XPath("//*[@id='successModal']/div/div/div[3]/button");
        private static By btnSave_4 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvMeasures']/tbody/tr[5]/td[6]/a");
        private static By btnSave_10 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvMeasures']/tbody/tr[10]/td[6]/a");
        private static By lblDeleteMsg = By.Id(CommonCtrls.GeneralContent + "lblDeleteReference");
        private static By btnPopupYES = By.Id(CommonCtrls.GeneralContent + "btnDeleteYes");
        private static By btnPopupNO = By.XPath("//*[@id='deleteReference']/div/div/div[3]/button[2]");
        //*[@id="EIDSSBodyCPH_lbl_Delete"]


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
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Measures List") &&
                            Driver.Instance.FindElement(titleFormTitle).Displayed)
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

        public static void clickAddReference()
        {
            SetMethods.clickObjectButtons(btnAdd);
        }

        public static void enterMeasureRefType(String value)
        {
            SetMethods.enterObjectValue(ddlMeasures, value);
        }

        public static void editFourthRecordInGird()
        {
            SetMethods.clickObjectButtons(btnEdit_4);
        }

        public static void deleteSeventhRecordInGrid()
        {
            SetMethods.clickObjectButtons(btnDelete_7);
        }

        public static void getSeventhTransValInGrid()
        {
            SetMethods.GetNewvalue(lblEngValue_7);
        }

        public static void clearCodeField()
        {
            SetMethods.clearField(txtCode_4);
        }

        public static void editTenthRecordInGird()
        {
            SetMethods.clickObjectButtons(btnEdit_10);
        }

        public static void clearTransValueField()
        {
            SetMethods.clearField(txtTransValue_10);
        }

        public static void randomEditRecordFromGrid()
        {
            SetMethods.randomSelectObjectElement(tlbMeasures, btnEdits);
        }

        public static void randomDeleteRecordFromGrid()
        {
            SetMethods.randomSelectObjectElement(tlbMeasures, btnDeletes);
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

        public static void enterEnglishValue(By val, String value)
        {
            int numValue = rnd.Next(10000, 99999);
            SetMethods.enterObjectValue(val, value + numValue);
            englishValue = value + numValue;
        }

        public static void getCurMeasureTransValue()
        {
            SetMethods.GetCurrentValue(txtTransValue_10);
        }

        public static void getNewMeasureTransValue()
        {
            SetMethods.GetNewvalue(lblTransValue_10);
        }

        public static void editRefCode(String value)
        {
            SetMethods.EditRefValue(txtCode_4, value);
        }

        public static void getCurMeasureCodeValue()
        {
            SetMethods.GetCurrentValue(txtCode_4);
        }

        public static void getNewMeasureCodeValue()
        {
            SetMethods.GetNewvalue(lblCode_4);
        }

        public static void clickSaveFourthRecord()
        {
            SetMethods.clickObjectButtons(btnSave_4);
        }

        public static void clickSaveTenthRecord()
        {
            SetMethods.clickObjectButtons(btnSave_10);
        }

        public static void enterNewTransValue()
        {
            enterEnglishValue(txtTransValue_10, "MEA");
        }

        public static void doesDeleteConfirmMessageDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(lblDeleteMsg);
        }

        public static void doesMeasureRefRecordShowInList()
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

        public class MeasuresPopupWndw
        {
            private static By titleFormTitle = By.XPath("//*[@class='modal-title']");
            private static By txtEnglishValue = By.Id(CommonCtrls.GeneralContent + "txtMEstrDefault");
            private static By txtTransValue = By.Id(CommonCtrls.GeneralContent + "txtMEstrName");
            private static By txtActionCode = By.Id(CommonCtrls.GeneralContent + "txtMEstrActionCode");
            private static By txtOrder = By.Id(CommonCtrls.GeneralContent + "txtMEintOrder");
            private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSaveMeasure");
            private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancelMeasures");
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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Measures") &&
                                Driver.Instance.FindElement(titleFormTitle).Displayed)
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


            public static void clickSubmit()
            {
                SetMethods.clickObjectButtons(btnSubmit);
            }

            public static void clickCancel()
            {
                SetMethods.clickObjectButtons(btnCancel);
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

            public static void enterOrderNumber(int value)
            {
                SetMethods.enterIntObjectValue(txtOrder, value);
            }

            public static void enterCode(String value)
            {
                int codeValue = rnd.Next(01, 99);
                SetMethods.enterObjectValue(txtActionCode, value + codeValue);
                refCodeValue = value + codeValue;
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

            public static void clearCodeField()
            {
                SetMethods.clearField(txtActionCode);
            }

            public static void clearEnglishValField()
            {
                SetMethods.clearField(txtEnglishValue);
            }

            public static void clearTransValField()
            {
                SetMethods.clearField(txtTransValue);
            }
        }
    }
}