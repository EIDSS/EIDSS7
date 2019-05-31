using System;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Selenium;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Collections.Generic;

namespace EIDSS7Test.Administration.ReferenceEditor
{
    public class SpeciesTypesEditorPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));
        public static Random rnd = new Random();
        private static By titleFormTitle = By.TagName("h2");
        private static By lblError = By.Id(CommonCtrls.GeneralContent + "lbl_Error");
        private static By lblSuccess = By.Id(CommonCtrls.GeneralContent + "lblSuccess");
        private static By btnPopupOK = By.XPath("//*[@id='successModal']/div/div/div[3]/button");
        private static By btnEdit_4 = By.Id(CommonCtrls.GeneralContent + "gvSpeciesType_btnEdit_3");
        private static By btnEdit_7 = By.Id(CommonCtrls.GeneralContent + "gvSpeciesType_btnEdit_6");
        private static By lblCode_4 = By.Id(CommonCtrls.GeneralContent + "gvSpeciesType_lblCode_3");
        private static By txtCode_4 = By.Id(CommonCtrls.GeneralContent + "gvSpeciesType_txtCode_3");
        private static By lblOrder_4 = By.Id(CommonCtrls.GeneralContent + "gvSpeciesType_lblOrder_3");
        private static By txtOrder_4 = By.Id(CommonCtrls.GeneralContent + "gvSpeciesType_txtOrder_3");
        private static By lblEngValue_4 = By.Id(CommonCtrls.GeneralContent + "gvSpeciesType_lblstrDefault_3");
        private static By txtEngValue_4 = By.Id(CommonCtrls.GeneralContent + "gvSpeciesType_txtstrDefault_3");
        private static By lblTransValue_4 = By.Id(CommonCtrls.GeneralContent + "gvSpeciesType_txtstrName_3");
        private static By txtTransValue_4 = By.Id(CommonCtrls.GeneralContent + "gvSpeciesType_txtstrName_3");
        private static By lblEngValue_7 = By.Id(CommonCtrls.GeneralContent + "gvSpeciesType_lblstrDefault_6");
        private static By txtEngValue_7 = By.Id(CommonCtrls.GeneralContent + "gvSpeciesType_txtstrDefault_6");
        private static By lblTransValue_7 = By.Id(CommonCtrls.GeneralContent + "gvSpeciesType_lblstrName_6");
        private static By txtTransValue_7 = By.Id(CommonCtrls.GeneralContent + "gvSpeciesType_txtstrName_6");
        private static By lblOrder_7 = By.Id(CommonCtrls.GeneralContent + "gvSpeciesType_lblOrder_6");
        private static By txtOrder_7 = By.Id(CommonCtrls.GeneralContent + "gvSpeciesType_txtOrder_6");
        private static By btnPopupErrOK = By.Id(CommonCtrls.GeneralContent + "btnErrorOK");
        private static By txtOrder = By.Id(CommonCtrls.GeneralContent + "txtintOrder");
        private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnAddSpecies");
        private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancelSpecies");
        private static By btnAdd = By.Id(CommonCtrls.GeneralContent + "btnAddReference");
        private static By btnSave_4 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvSpeciesType']/tbody/tr[5]/td[7]/a");
        private static By btnCancelSave_4 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvSpeciesType']/tbody/tr[5]/td[8]/a");
        private static By btnDelete_4 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvSpeciesType_btnDelete_3']");
        private static By btnSave_7 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvSpeciesType']/tbody/tr[8]/td[7]/a");
        private static By btnDelete_7 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvSpeciesType']/tbody/tr[8]/td[8]/a");
        private static By btnCancelSave_7 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvSpeciesType']/tbody/tr[8]/td[8]/a");
        private static By lblDeleteMsg = By.Id(CommonCtrls.GeneralContent + "lbl_Delete");
        private static By lblDeleteAnywayMsg = By.Id(CommonCtrls.GeneralContent + "lbl_Delete_Anyway");
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
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Species Types List") &&
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


        public static void doesSpeciesTypeRefRecordShowInListNO()
        {
            SetMethods.isElementNotPresent(lblAllEngVals, SetMethods.refValue2);
        }

        public static void doesSpeciesTypeRefRecordShowInListYES()
        {
            SetMethods.isElementPresent(lblAllEngVals, SetMethods.refValue2);
        }

        public static void doesDeleteConfirmMessageForSeventhDisplay()
        {
            if (Driver.Instance.FindElement(lblDeleteMsg).Displayed)
            {
                SetMethods.clickObjectButtons(btnPopupYES);

                //Check if reference value in use message displays
                if (Driver.Instance.FindElement(lblDeleteAnywayMsg).Displayed)
                {
                    SetMethods.clickObjectButtons(btnPopupAnywayYES);
                }
            }
            else
            {
                SetMethods.clickObjectButtons(btnPopupErrOK);
                clickCancelSaveSeventhRecord();
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
                clickCancelSaveSeventhRecord();
            }
        }

        public static void clickPopupOK()
        {
            SetMethods.clickObjectButtons(btnPopupOK);
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

        public static void clickAddReference()
        {
            SetMethods.clickObjectButtons(btnAdd);
        }

        public static void editRefCode(String value)
        {
            SetMethods.EditRefValue(txtCode_4, SetMethods.refValue2);
        }

        public static void getCurSpeciesTypeCodeValue()
        {
            SetMethods.GetCurrentValue(txtCode_4);
        }

        public static void getNewSpeciesTypeCodeValue()
        {
            SetMethods.GetNewvalue(lblCode_4);
        }

        public static void getCurSpeciesTypeTransValue()
        {
            SetMethods.GetCurrentValue(txtTransValue_7);
        }

        public static void getNewSpeciesTypeTransValue()
        {
            SetMethods.GetNewvalue(lblTransValue_7);
        }

        public static void enterNewTransValue()
        {
            SetMethods.EditRefValue(txtTransValue_7, "SPC");
        }

        public static void getSeventhTransValInGrid()
        {
            SetMethods.GetNewvalue(lblEngValue_7);
        }

        public static void getSeventhOrderNoInGrid()
        {
            SetMethods.GetNewIntValue2(lblOrder_7);
        }

        public static void deleteSeventhRecordInGrid()
        {
            SetMethods.clickObjectButtons(btnDelete_7);
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
        public static void clickSaveSeventhRecord()
        {
            SetMethods.clickObjectButtons(btnSave_7);
        }

        public static void clickCancelSaveFourthRecord()
        {
            SetMethods.clickObjectButtons(btnCancelSave_4);
        }

        public static void clickCancelSaveSeventhRecord()
        {
            SetMethods.clickObjectButtons(btnCancelSave_7);
        }

        public static void editSeventhRecordInGird()
        {
            //Scroll back to the bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1100)", "");
            SetMethods.clickObjectButtons(btnEdit_7);
        }

        public static void clearSpeciesTypeCodeField()
        {
            SetMethods.clearField(txtCode_4);
        }

        public static void clearTransValueField()
        {
            SetMethods.clearField(txtTransValue_7);
        }


        public class SpeciesTypesPopupWndw
        {
            private static By titleFormTitle = By.TagName("h4");
            private static By txtEnglishValue = By.Id(CommonCtrls.GeneralContent + "txtSPstrDefault");
            private static By txtTransValue = By.Id(CommonCtrls.GeneralContent + "txtSPstrName");
            private static By txtCode = By.Id(CommonCtrls.GeneralContent + "txtSPstrCode");
            private static By txtOrder = By.Id(CommonCtrls.GeneralContent + "txtSPintOrder");
            private static By ddlAccessoryCode = By.Id(CommonCtrls.GeneralContent + "ddlSPintHACode");
            private static IList<IWebElement> accessCodeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSPintHACode']/option")); } }
            private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSaveSpeciesType");
            private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancelSpeciesType");
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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Species Types") &&
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

            public static void enterRandomSpeciesTypeCodeValue(string value)
            {
                int codeVal = rnd.Next(00, 99);
                SetMethods.enterObjectValue(txtCode, value + codeVal);
                codeValue = value + codeVal;
            }

            public static void enterSpeciesTypeCodeValue(String value)
            {
                int codeVal = rnd.Next(00, 99);
                SetMethods.enterObjectValue(txtCode, value + codeVal);
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