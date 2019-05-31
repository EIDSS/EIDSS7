using System;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Selenium;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Threading;
using System.Collections.Generic;

namespace EIDSS7Test.Administration.ReferenceEditor
{
    public class ReportDiseasesGroupsEditorPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));
        public static Random rnd = new Random();
        private static By HeaderFormTitle = By.TagName("h1");
        private static By titleFormTitle = By.TagName("h2");
        private static By btnAdd = By.Id(CommonCtrls.GeneralContent + "btnAddReference");
        private static By lblDeleteMsg = By.Id(CommonCtrls.GeneralContent + "lbl_Delete");
        private static By lblError = By.Id(CommonCtrls.GeneralContent + "lbl_Error");
        private static By btnPopupErrOK = By.Id(CommonCtrls.GeneralContent + "btnErrorOK");
        private static By lblSuccess = By.Id(CommonCtrls.GeneralContent + "lblSuccess");
        private static By btnPopupOK = By.XPath("//*[@id='successModal']/div/div/div[3]/button");
        private static By btnEdit_4 = By.Id(CommonCtrls.GeneralContent + "gvReportDiagnosisGroup_btnEdit_3");
        private static By btnEdit_10 = By.Id(CommonCtrls.GeneralContent + "gvReportDiagnosisGroup_btnEdit_9");
        private static By lblICD10_4 = By.Id(CommonCtrls.GeneralContent + "gvReportDiagnosisGroup_lbstrICD10Codes_3");
        private static By txtICD10_4 = By.Id(CommonCtrls.GeneralContent + "gvReportDiagnosisGroup_txtstrICD10Codes_3");
        private static By lblOrder_4 = By.Id(CommonCtrls.GeneralContent + "gvReportDiagnosisGroup_lblOrder_3");
        private static By txtOrder_4 = By.Id(CommonCtrls.GeneralContent + "gvReportDiagnosisGroup_txtOrder_3");
        private static By lblEngValue_4 = By.Id(CommonCtrls.GeneralContent + "gvReportDiagnosisGroup_lblstrDefault_3");
        private static By txtEngValue_4 = By.Id(CommonCtrls.GeneralContent + "gvReportDiagnosisGroup_txtstrDefault_3");
        private static By lblTransValue_4 = By.Id(CommonCtrls.GeneralContent + "gvReportDiagnosisGroup_lblstrName_3");
        private static By txtTransValue_4 = By.Id(CommonCtrls.GeneralContent + "gvReportDiagnosisGroup_txtstrName_3");
        private static By lblEngValue_10 = By.Id(CommonCtrls.GeneralContent + "gvReportDiagnosisGroup_lblstrDefault_9");
        private static By txtEngValue_10 = By.Id(CommonCtrls.GeneralContent + "gvReportDiagnosisGroup_txtstrDefault_9");
        private static By lblTransValue_10 = By.Id(CommonCtrls.GeneralContent + "gvReportDiagnosisGroup_lblstrName_9");
        private static By txtTransValue_10 = By.Id(CommonCtrls.GeneralContent + "gvReportDiagnosisGroup_txtstrName_9");
        private static By lblICD10_10 = By.Id(CommonCtrls.GeneralContent + "gvReportDiagnosisGroup_lbstrICD10Codes_9");
        private static By txtICD10_10 = By.Id(CommonCtrls.GeneralContent + "gvReportDiagnosisGroup_txtstrICD10Codes_9");
        public static String refValue1 = null;
        public static String refValue2 = null;
        private static By btnSave_4 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvReportDiagnosisGroup']/tbody/tr[4]/td[5]/a");
        private static By btnCancelSave_4 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvReportDiagnosisGroup']/tbody/tr[4]/td[6]/a");
        private static By btnDelete_4 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvReportDiagnosisGroup_btnDelete_3']");
        private static By btnSave_10 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvReportDiagnosisGroup']/tbody/tr[10]/td[5]/a");
        private static By btnDelete_10 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvReportDiagnosisGroup_btnDelete_9']");
        private static By btnCancelSave_10 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvReportDiagnosisGroup']/tbody/tr[10]/td[6]/a");
        private static By lblDeleteAnywayMsg = By.Id(CommonCtrls.GeneralContent + "lbl_Delete_Anyway");
        private static By btnErrorOK = By.Id(CommonCtrls.GeneralContent + "btnErrorOK");
        private static By btnPopupYES = By.Id(CommonCtrls.GeneralContent + "btnDeleteYes");
        private static By btnPopupAnywayYES = By.Id(CommonCtrls.GeneralContent + "btnDeleteAnywayYes");
        private static By btnPopupNO = By.XPath("//*[@id='deleteModal']/div/div/div[3]/button[2]");
        private static By btnPopupAnywayNO = By.XPath("//*[@id='currentlyInUseModal']/div/div/div[3]/button[2]");
        private static IList<IWebElement> lblAllEngVals { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[1]/div[1]/div[1]/div[2]/div[2]/div[1]/table[1]/tbody[1]/tr/td[2]/span[1]")); } }
        public static String englishValue = null;
        public static String codeValue = null;
        public static List<String> multiCodeValues = new List<String>();
        public static String refRecordValue = null;


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
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Report Disease Groups List") &&
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

        public static void doesRptDisGrpRefRecordShowInListNO()
        {
            SetMethods.isElementNotPresent(lblAllEngVals, SetMethods.refValue2);
        }

        public static void doesRptDisGrpRefRecordShowInListYES()
        {
            SetMethods.isElementPresent(lblAllEngVals, SetMethods.refValue1);
        }

        public static void doesDeleteConfirmMessageForTenthDisplay()
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
                clickCancelSaveTenthRecord();
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
                clickCancelSaveTenthRecord();
            }
        }

        public static void clickPopupOK()
        {
            SetMethods.clickObjectButtons(btnPopupOK);
        }

        public static void enterEnglishVal(By element, String value)
        {
            int numValue = rnd.Next(10000, 99999);
            SetMethods.enterObjectValue(element, value + numValue);
            SetMethods.refValue1 = value + numValue;
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

        public static void enterEnglishValue_4()
        {
            enterEnglishVal(txtEngValue_4, "RGD");
        }

        public static void editRefCode(String value)
        {
            int codeValue = rnd.Next(01, 99);
            SetMethods.enterObjectValue(txtICD10_4, value + codeValue);
            refValue2 = value + codeValue;
        }

        public static void getCurRptDiseaseICD10Value_4()
        {
            SetMethods.GetCurrentValue(txtICD10_4);
        }

        public static void getNewRptDiseaseICD10Value_4()
        {
            SetMethods.GetNewvalue(lblICD10_4);
        }

        public static void getCurRptDiseaseTransValue_4()
        {
            SetMethods.GetCurrentValue(txtTransValue_4);
        }

        public static void getNewRptDiseaseTransValue_4()
        {
            SetMethods.GetNewvalue(lblTransValue_4);
        }

        public static void getCurRptDiseaseEngValue_4()
        {
            SetMethods.GetCurrentValue(txtEngValue_4);
        }

        public static void getNewRptDiseaseEngValue_4()
        {
            SetMethods.GetNewvalue(lblEngValue_4);
        }

        public static void getCurRptDiseaseTransValue_10()
        {
            SetMethods.GetCurrentValue(txtTransValue_10);
        }

        public static void getNewRptDiseaseTransValue_10()
        {
            SetMethods.GetNewvalue(lblTransValue_10);
        }

        public static void getCurRptDiseaseEngValue_10()
        {
            SetMethods.GetCurrentValue(txtEngValue_10);
        }

        public static void getNewRptDiseaseEngValue_10()
        {
            SetMethods.GetNewvalue(lblEngValue_10);
        }

        public static void enterNewTransValue_10()
        {
            SetMethods.EditRefValue(txtTransValue_10, "RPTD");
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

        public static void clickCancelSaveFourthRecord()
        {
            SetMethods.clickObjectButtons(btnCancelSave_4);
        }

        public static void clickCancelSaveTenthRecord()
        {
            SetMethods.clickObjectButtons(btnCancelSave_10);
        }

        public static void editTenthRecordInGrid()
        {
            //Scroll back to the bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1100)", "");
            SetMethods.clickObjectButtons(btnEdit_10);
        }

        public static void clearICD10CodeField_4()
        {
            SetMethods.clearField(txtICD10_4);
        }

        public static void clearTransValueField_10()
        {
            SetMethods.clearField(txtTransValue_10);
        }

        public static void clearEnglishValueField_10()
        {
            SetMethods.clearField(txtEngValue_10);
        }

        public static void clearTransValueField_4()
        {
            SetMethods.clearField(txtTransValue_4);
        }

        public static void clearEnglishValueField_4()
        {
            SetMethods.clearField(txtEngValue_4);
        }

        public static void getTenthTransValInGrid()
        {
            SetMethods.GetCurrentValue(lblTransValue_10);
        }

        public static void getTenthICD10CodeInGrid()
        {
            SetMethods.GetNewvalue(lblICD10_10);
        }

        public static void deleteTenthRecordInGrid()
        {
            SetMethods.clickObjectButtons(btnDelete_10);
        }

        public class RptDisGrpsPopupWndw
        {
            private static By titleFormTitle = By.TagName("h4");
            private static By txtEnglishValue = By.Id(CommonCtrls.GeneralContent + "txtRDstrDefault");
            private static By txtTransValue = By.Id(CommonCtrls.GeneralContent + "txtRDstrName");
            private static By txtICD10Value = By.Id(CommonCtrls.GeneralContent + "txtRDstrCode");
            private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSaveReportDiagnosisGroup");
            private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancelReportDiagnosisGroup");
            private static By btnSpinnerUp = By.XPath("//*[@class='glyphicon glyphicon-triangle-top']");
            private static By btnSpinnerDwn = By.XPath("//*[@class='glyphicon glyphicon-triangle-bottom']");

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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Report Disease Groups") &&
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



            public static void enterEnglishValue()
            {
                enterEnglishVal(txtEnglishValue, "RGD");
            }

            public static void enterTransValue()
            {
                SetMethods.enterObjectValue(txtTransValue, SetMethods.refValue1);
            }

            public static void enterIDC10Value(string value)
            {
                int icdValue = rnd.Next(00, 99);
                SetMethods.enterObjectValue(txtICD10Value, value + icdValue);
                codeValue = value + icdValue;
            }

            public static void enterMultipleIDC10Value(string value)
            {
                for (int i = 0; i <= 10; i++)
                {
                    int icdValue = rnd.Next(00, 99);
                    SetMethods.enterObjectValue(txtICD10Value, value + icdValue + ",");
                    codeValue = value + icdValue;
                    multiCodeValues.Add(codeValue + ",");
                }
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

            public static void clickSubmit()
            {
                SetMethods.clickObjectButtons(btnSubmit);
            }

            public static void clickCancel()
            {
                SetMethods.clickObjectButtons(btnCancel);
            }

            public static void enterManualEnglishValue()
            {
                SetMethods.enterObjectValue(txtEnglishValue, SetMethods.refValue2);
            }

            public static void enterManualTransValue()
            {
                SetMethods.enterObjectValue(txtTransValue, SetMethods.refValue2);
            }

            public static void enterManualICD10Value()
            {
                SetMethods.enterIntObjectValue(txtICD10Value, SetMethods.refValue3);
            }
        }
    }
}
