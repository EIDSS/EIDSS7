using System;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Selenium;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Collections.Generic;

namespace EIDSS7Test.Administration.ReferenceEditor
{
    public class CaseClassificationEditorPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));
        public static Random rnd = new Random();
        private static By titleFormTitle = By.TagName("h2");
        private static By lblError = By.Id(CommonCtrls.GeneralContent + "lbl_Error");
        private static By lblSuccess = By.Id(CommonCtrls.GeneralContent + "lblSuccess");
        //private static By btnPopupOK = By.XPath("btnError");
        private static By btnPopupOK = By.XPath("//*[@id='successModal']/div/div/div[3]/button");
        private static By btnEdit_4 = By.Id(CommonCtrls.GeneralContent + "gvCaseClass_btnEdit_3");
        private static By btnEdit_12 = By.Id(CommonCtrls.GeneralContent + "gvCaseClass_btnEdit_11");
        private static By lblCode_4 = By.Id(CommonCtrls.GeneralContent + "gvCaseClass_lblCode_3");
        private static By txtCode_4 = By.Id(CommonCtrls.GeneralContent + "gvCaseClass_txtCode_3");
        private static By lblOrder_4 = By.Id(CommonCtrls.GeneralContent + "gvCaseClass_lblOrder_3");
        private static By txtOrder_4 = By.Id(CommonCtrls.GeneralContent + "gvCaseClass_txtOrder_3");
        private static By lblEngValue_4 = By.Id(CommonCtrls.GeneralContent + "gvCaseClass_lblstrDefault_3");
        private static By txtEngValue_4 = By.Id(CommonCtrls.GeneralContent + "gvCaseClass_txtstrDefault_3");
        private static By lblTransValue_4 = By.Id(CommonCtrls.GeneralContent + "gvCaseClass_txtstrName_3");
        private static By txtTransValue_4 = By.Id(CommonCtrls.GeneralContent + "gvCaseClass_txtstrName_3");
        private static By lblEngValue_12 = By.Id(CommonCtrls.GeneralContent + "gvCaseClass_lblstrDefault_11");
        private static By txtEngValue_12 = By.Id(CommonCtrls.GeneralContent + "gvCaseClass_txtstrDefault_11");
        private static By lblTransValue_12 = By.Id(CommonCtrls.GeneralContent + "gvCaseClass_lblstrName_11");
        private static By txtTransValue_12 = By.Id(CommonCtrls.GeneralContent + "gvCaseClass_txtstrName_11");
        private static By lblOrder_12 = By.Id(CommonCtrls.GeneralContent + "gvCaseClass_lblOrder_11");
        private static By txtOrder_12 = By.Id(CommonCtrls.GeneralContent + "gvCaseClass_txtOrder_11");
        private static By btnPopupErrOK = By.Id(CommonCtrls.GeneralContent + "btnErrorOK");
        private static By txtOrder = By.Id(CommonCtrls.GeneralContent + "txtintOrder");
        private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnAddSpecies");
        private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancelSpecies");
        private static By btnAdd = By.Id(CommonCtrls.GeneralContent + "btnAddReference");
        private static By btnSave_4 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvCaseClass']/tbody/tr[5]/td[7]/a");
        private static By btnCancelSave_4 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvCaseClass']/tbody/tr[5]/td[8]/a");
        private static By btnDelete_4 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvCaseClass_btnDelete_3']");
        private static By btnSave_12 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvCaseClass']/tbody/tr[12]/td[8]/a");
        private static By btnDelete_12 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvCaseClass_btnDelete_11']");
        private static By btnCancelSave_12 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvCaseClass']/tbody/tr[12]/td[9]/a");
        private static By lblDeleteMsg = By.Id(CommonCtrls.GeneralContent + "lbl_Delete");
        private static By lblDeleteAnywayMsg = By.Id(CommonCtrls.GeneralContent + "lbl_Delete_Anyway");
        private static By btnErrorOK = By.Id(CommonCtrls.GeneralContent + "btnErrorOK");
        private static By btnPopupYES = By.Id(CommonCtrls.GeneralContent + "btnDeleteYes");
        private static By btnPopupAnywayYES = By.Id(CommonCtrls.GeneralContent + "btnDeleteAnywayYes");
        private static By btnPopupNO = By.XPath("//*[@id='deleteModal']/div/div/div[3]/button[2]");
        private static By btnPopupAnywayNO = By.XPath("//*[@id='currentlyInUseModal']/div/div/div[3]/button[2]");
        private static IList<IWebElement> lblAllEngVals { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[1]/div[1]/div[1]/div[2]/div[2]/div[1]/table[1]/tbody[1]/tr/td[2]/span[1]")); } }
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
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Case Classification List") &&
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

        public static void doesCaseClassRefRecordShowInListNO()
        {
            SetMethods.isElementNotPresent(lblAllEngVals, SetMethods.refValue2);
        }

        public static void doesCaseClassRefRecordShowInListYES()
        {
            SetMethods.isElementPresent(lblAllEngVals, SetMethods.refValue2);
        }

        public static void doesDeleteConfirmMessageForTwelfthDisplay()
        {
            if (Driver.Instance.FindElement(lblDeleteMsg).Displayed)
            {
                SetMethods.clickObjectButtons(btnPopupYES);
                SetMethods.clickObjectButtons(btnPopupOK);

                //Check if reference value in use message displays
                if (Driver.Instance.FindElement(lblDeleteAnywayMsg).Displayed)
                {
                    SetMethods.clickObjectButtons(btnPopupAnywayYES);
                    SetMethods.clickObjectButtons(btnPopupOK);
                }
            }
            else
            {
                SetMethods.clickObjectButtons(btnPopupErrOK);
                clickCancelSaveTwelfthRecord();
            }
        }

        public static void doesDeleteConfirmMessageForFourthDisplay()
        {
            if (Driver.Instance.FindElement(lblDeleteMsg).Displayed)
            {
                SetMethods.clickObjectButtons(btnPopupYES);
                SetMethods.clickObjectButtons(btnPopupOK);

                //Check if reference value in use message displays
                if (Driver.Instance.FindElement(lblDeleteAnywayMsg).Displayed)
                {
                    SetMethods.clickObjectButtons(btnPopupAnywayYES);
                    SetMethods.clickObjectButtons(btnPopupOK);
                }
            }
            else
            {
                SetMethods.clickObjectButtons(btnPopupErrOK);
                clickCancelSaveFourthRecord();
            }
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
                clickCancelSaveTwelfthRecord();
            }
        }

        public static void clickPopupOK()
        {
            SetMethods.clickObjectButtons(btnPopupOK);
        }

        public static void clickPopupOK_TFS3600()
        {
            SetMethods.clickObjectButtons(btnErrorOK);
        }

        public static void clickPopupYES()
        {
            SetMethods.clickObjectButtons(btnPopupYES);
        }

        public static void clickPopupNO()
        {
            SetMethods.clickObjectButtons(btnPopupNO);
        }

        public static String getRefDataNumber()
        {
            var ID = Driver.Instance.FindElement(lblSuccess).Text;
            Driver.Wait(TimeSpan.FromMinutes(20));
            return refRecordValue = ID.Substring(ID.Length - 9).TrimEnd('.');
        }

        public static String getRefDataNumber_TFS3600()
        {
            var ID = Driver.Instance.FindElement(lblError).Text;
            Driver.Wait(TimeSpan.FromMinutes(20));
            return refRecordValue = ID.Substring(ID.Length - 9).TrimEnd('.');
        }

        public static void clickAddReference()
        {
            SetMethods.clickObjectButtons(btnAdd);
        }

        public static void editRefCode(String value)
        {
            SetMethods.EditRefValue(txtCode_4, SetMethods.refValue2);
        }

        public static void getCurCaseClassCodeValue()
        {
            SetMethods.GetCurrentValue(txtCode_4);
        }

        public static void getNewCaseClassCodeValue()
        {
            SetMethods.GetNewvalue(lblCode_4);
        }

        public static void getCurCaseClassTransValue()
        {
            SetMethods.GetCurrentValue(txtTransValue_12);
        }

        public static void getNewCaseClassTransValue()
        {
            SetMethods.GetNewvalue(lblTransValue_12);
        }

        public static void enterNewTransValue()
        {
            SetMethods.EditRefValue(txtTransValue_12, "CCC");
        }

        public static void getTwelfthTransValInGrid()
        {
            SetMethods.GetNewvalue(lblTransValue_12);
        }

        public static void getTwelfthOrderNoInGrid()
        {
            SetMethods.GetNewIntValue2(lblOrder_12);
        }

        public static void deleteTwelfthRecordInGrid()
        {
            SetMethods.clickObjectButtons(btnDelete_12);
        }

        public static void getFourthTransValInGrid()
        {
            SetMethods.GetNewvalue(lblEngValue_4);
        }

        public static void getFourthOrderNoInGrid()
        {
            SetMethods.GetNewIntValue2(lblOrder_4);
        }

        public static void clickSaveFourthRecord()
        {
            SetMethods.clickObjectButtons(btnSave_4);
        }

        public static void editFourthRecordInGird()
        {
            SetMethods.clickObjectButtons(btnEdit_4);
        }

        public static void deleteFourthRecordInGrid()
        {
            SetMethods.clickObjectButtons(btnDelete_4);
        }
        public static void clickSaveTwelfthRecord()
        {
            SetMethods.clickObjectButtons(btnSave_12);
        }

        public static void clickCancelSaveFourthRecord()
        {
            SetMethods.clickObjectButtons(btnCancelSave_4);
        }

        public static void clickCancelSaveTwelfthRecord()
        {
            SetMethods.clickObjectButtons(btnCancelSave_12);
        }

        public static void editTwelfthRecordInGird()
        {
            //Scroll back to the bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1100)", "");
            SetMethods.clickObjectButtons(btnEdit_12);
        }

        public static void clearCaseClassCodeField()
        {
            SetMethods.clearField(txtCode_4);
        }

        public static void clearTransValueField()
        {
            SetMethods.clearField(txtTransValue_12);
        }




        public class CaseClassPopupWndw
        {
            private static By titleFormTitle = By.TagName("h4");
            private static By txtEnglishValue = By.Id(CommonCtrls.GeneralContent + "txtCCstrDefault");
            private static By txtTransValue = By.Id(CommonCtrls.GeneralContent + "txtCCstrName");
            private static By txtCode = By.Id(CommonCtrls.GeneralContent + "txtCCstrCode");
            private static By txtOrder = By.Id(CommonCtrls.GeneralContent + "txtCCintOrder");
            private static By chkInitCaseClass = By.Id(CommonCtrls.GeneralContent + "chkCCblnInitialHumanCaseClassification");
            private static By chkFinalCaseClass = By.Id(CommonCtrls.GeneralContent + "chkCCblnFinalHumanCaseClassification");
            private static By ddlAccessoryCode = By.Id(CommonCtrls.GeneralContent + "lstCCHACode");
            private static IList<IWebElement> accessCodeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lstCCHACode']/option")); } }
            private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSaveCaseClass");
            private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancelCaseClass");
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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Case Classification") &&
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

            public static void clickInitCaseClass()
            {
                SetMethods.clickObjectButtons(chkInitCaseClass);
            }

            public static void clickFinalCaseClass()
            {
                SetMethods.clickObjectButtons(chkFinalCaseClass);
            }

            public static void enterEnglishValue(String value)
            {
                int numValue = rnd.Next(10000, 99999);
                SetMethods.enterObjectValue(txtEnglishValue, value + numValue);
                englishValue = value + numValue;
            }

            public static void enterManualEnglishValue()
            {
                SetMethods.enterObjectValue(txtEnglishValue, SetMethods.refValue2);
            }

            public static void enterTransValue()
            {
                SetMethods.enterObjectValue(txtTransValue, englishValue);
            }

            public static void enterManualTransValue()
            {
                SetMethods.enterObjectValue(txtTransValue, SetMethods.refValue2);
            }


            public static void randomSelectAccessoryCode()
            {
                SetMethods.randomSelectObjectElement(ddlAccessoryCode, accessCodeOpts);
            }

            public static void enterAccessoryCode(string value)
            {
                SetMethods.enterObjectValue(ddlAccessoryCode, value);
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

            public static void enterManualOrderNo()
            {
                SetMethods.enterIntObjectValue(txtOrder, SetMethods.refValue3);
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
