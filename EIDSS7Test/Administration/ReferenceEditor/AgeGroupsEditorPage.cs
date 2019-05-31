using System;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Selenium;
using NUnit.Framework;
using EIDSS7Test.Common;
using EIDSS7Test.Navigation;
using System.Collections.Generic;

namespace EIDSS7Test.Administration.ReferenceEditor
{
    public class AgeGroupsEditorPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));
        public static Random rnd = new Random();
        private static By titleFormTitle = By.TagName("h2");
        private static By lblError = By.Id(CommonCtrls.GeneralContent + "lbl_Error");
        private static By lblSuccess = By.Id(CommonCtrls.GeneralContent + "lblSuccess");
        private static By btnPopupOK = By.XPath("//*[@id='successModal']/div/div/div[3]/button");
        private static By btnEdit_4 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_btnEdit_3");
        private static By btnEdit_7 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_btnEdit_6");
        private static By lblEngValue_4 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_lblstrDefault_3");
        private static By txtEngValue_4 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_txtstrDefault_3");
        private static By lblTransValue_4 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_lblstrName_3");
        private static By txtTransValue_4 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_txtstrName_3");
        private static By lblOrder_4 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_lblOrder_3");
        private static By txtOrder_4 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_txtOrder_3");
        private static By lblLBound_4 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_lblintLowerBoundary_3");
        private static By txtLBound_4 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_txtintLowerBoundary_3");
        private static By lblUBound_4 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_lbintUpperBoundary_3");
        private static By txtUBound_4 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_txtintUpperBoundary_3");
        private static By lblAgeType_4 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_lblstrAgeType_3");
        private static By ddlAgeType_4 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_ddlidsfAgeType_3");
        private static By lblEngValue_7 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_lblstrDefault_6");
        private static By txtEngValue_7 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_txtstrDefault_6");
        private static By lblTransValue_7 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_lblstrName_6");
        private static By txtTransValue_7 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_txtstrName_6");
        private static By lblOrder_7 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_lblOrder_6");
        private static By txtOrder_7 = By.Id(CommonCtrls.GeneralContent + "gvAgeGroups_txtOrder_6");
        private static By btnPopupErrOK = By.Id(CommonCtrls.GeneralContent + "btnErrorOK");
        private static By txtOrder = By.Id(CommonCtrls.GeneralContent + "txtintOrder");
        private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnAddSpecies");
        private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancelSpecies");
        private static By btnAdd = By.Id(CommonCtrls.GeneralContent + "btnAddReference");
        private static By btnSave_4 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvAgeGroups']/tbody/tr[4]/td[8]/a");
        private static By btnCancelSave_4 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvAgeGroups']/tbody/tr[4]/td[9]/a");
        private static By btnDelete_4 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvAgeGroups_btnDelete_3']");
        private static By btnSave_7 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvAgeGroups']/tbody/tr[8]/td[7]/a");
        private static By btnDelete_7 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvAgeGroups']/tbody/tr[8]/td[8]/a");
        private static By btnCancelSave_7 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvAgeGroups']/tbody/tr[8]/td[8]/a");
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
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Age Group List") &&
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


        public static void doesAgeGroupsRefRecordShowInListNO()
        {
            SetMethods.isElementNotPresent(lblAllEngVals, SetMethods.refValue2);
        }

        public static void doesAgeGroupsObjRefRecordShowInListNO(object value)
        {
            SetMethods.isElementNotPresent(lblAllEngVals, value.ToString());
        }

        public static void doesAgeGroupsRefRecordShowInListYES()
        {
            SetMethods.isElementPresent(lblAllEngVals, SetMethods.refValue2);
        }

        public static void doesAgeGroupsObjRefRecordShowInListYES(object value)
        {
            SetMethods.isElementPresent(lblAllEngVals, value.ToString());
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

        public static void editRefOrder(String value)
        {
            SetMethods.EditRefValue(txtOrder_4, SetMethods.refValue2);
        }

        public static void getCurAgeGroupsOrderValue()
        {
            SetMethods.GetCurrentValue(txtOrder_4);
        }

        public static void getNewAgeGroupsOrderValue()
        {
            SetMethods.GetNewvalue(lblOrder_4);
        }

        public static void enterNewTransValue_4()
        {
            SetMethods.enterObjectValue(txtTransValue_4, SetMethods.refValue1 + "-B");
        }

        public static void getCurAgeGroupsTransValue_4()
        {
            SetMethods.GetCurrentValue(txtTransValue_4);
        }

        public static void getNewAgeGroupsTransValue_4()
        {
            SetMethods.GetNewvalue(lblTransValue_4);
        }

        public static void getCurAgeGroupsTransValue()
        {
            SetMethods.GetCurrentValue(txtTransValue_7);
        }

        public static void getNewAgeGroupsTransValue()
        {
            SetMethods.GetNewvalue(lblTransValue_7);
        }

        public static void enterNewTransValue()
        {
            SetMethods.EditRefValue(txtTransValue_7, "AGC");
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

        public static void getFourthLowerBoundInGrid()
        {
            SetMethods.GetNewIntValue5(lblLBound_4);
        }

        public static void getFourthUpperBoundInGrid()
        {
            SetMethods.GetNewIntValue6(lblUBound_4);
        }

        public static void getFourthIntervalTypeInGrid()
        {
            SetMethods.GetNewvalue4(lblAgeType_4);
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

        public static void clearAgeGroupOrderField()
        {
            SetMethods.clearField(txtOrder_4);
        }

        public static void clearTransValueField_4()
        {
            SetMethods.clearField(txtTransValue_4);
        }

        public static void clearTransValueField()
        {
            SetMethods.clearField(txtTransValue_7);
        }

        public class AgeGroupPopupWndw
        {
            private static By titleFormTitle = By.TagName("h4");
            private static By txtEnglishValue = By.Id(CommonCtrls.GeneralContent + "txtAGstrDefault");
            private static By txtTransValue = By.Id(CommonCtrls.GeneralContent + "txtAGstrName");
            private static By txtLowerBound = By.Id(CommonCtrls.GeneralContent + "txtAGintLowerBoundary");
            private static By txtUpperBound = By.Id(CommonCtrls.GeneralContent + "txtAGintUpperBoundary");
            private static By ddlIntervalType = By.Id(CommonCtrls.GeneralContent + "ddlAGidfsAgeType");
            private static IList<IWebElement> interTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAGidfsAgeType']/option")); } }
            private static By txtOrder = By.Id(CommonCtrls.GeneralContent + "txtAGintOrder");
            private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSaveAgeGroup");
            private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancelAgeGroup");
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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Age Group") &&
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

            public static void doesAgeGroupRefRecordShowInListNO()
            {
                SetMethods.isElementNotPresent(lblAllEngVals, SetMethods.refValue2);
            }

            public static void doesAgeGroupRefRecordShowInListYES()
            {
                SetMethods.isElementPresent(lblAllEngVals, SetMethods.refValue2);
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

            public static void enterEnglishValueObject(object value)
            {
                SetMethods.enterObjectValue(txtEnglishValue, value.ToString());
            }

            public static void enterTranslateValueObject(object value)
            {
                SetMethods.enterObjectValue(txtTransValue, value.ToString());
            }

            public static void enterLowerBoundObject(object value)
            {
                SetMethods.enterObjectValue(txtLowerBound, value.ToString());
            }

            public static void enterLowerBound(string value)
            {
                SetMethods.enterObjectValue(txtLowerBound, value);
            }

            public static void enterUpperBoundObject(object value)
            {
                SetMethods.enterObjectValue(txtUpperBound, value.ToString());
            }

            public static void enterUpperBound(string value)
            {
                SetMethods.enterObjectValue(txtUpperBound, value);
            }

            public static void randomSelectIntervalType()
            {
                SetMethods.randomSelectObjectElement(ddlIntervalType, interTypeOpts);
            }

            public static void enterIntervalType(string value)
            {
                SetMethods.enterObjectValue(ddlIntervalType, value);
            }

            public static void enterIntervalTypeObject(object value)
            {
                SetMethods.enterObjectValue(ddlIntervalType, value.ToString());
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

            public static void enterManualLowerBoundNo()
            {
                SetMethods.enterIntObjectValue(txtLowerBound, SetMethods.refValue5);
            }

            public static void enterManualUpperBoundNo()
            {
                SetMethods.enterIntObjectValue(txtUpperBound, SetMethods.refValue6);
            }

            public static void enterManualIntervalType()
            {
                SetMethods.enterObjectValue(ddlIntervalType, SetMethods.refValue4);
            }

            public static void enterOrderObject(object value)
            {
                SetMethods.enterObjectValue(txtOrder, value.ToString());
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