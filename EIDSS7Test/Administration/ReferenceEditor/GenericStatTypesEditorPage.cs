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
    public class GenericStatTypesEditorPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));
        public static Random rnd = new Random();
        private static By HeaderFormTitle = By.TagName("h1");
        private static By titleFormTitle = By.TagName("h2");
        private static By btnAdd = By.Id(CommonCtrls.GeneralContent + "btnAddReference");
        public static int orderValue = 0;
        private static By lblError = By.Id(CommonCtrls.GeneralContent + "lbl_Error");
        private static By lblSuccess = By.Id(CommonCtrls.GeneralContent + "lblSuccess");
        private static By btnPopupErrOK = By.Id(CommonCtrls.GeneralContent + "btnErrorOK");
        private static By btnPopupOK = By.XPath("//*[@id='successModal']/div/div/div[3]/button");
        private static By btnEdit_4 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_btnEdit_3");
        private static By btnEdit_9 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_btnEdit_9");
        private static By lblEngValue_4 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_lblstrDefault_3");
        private static By txtEngValue_4 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_txtstrDefault_3");
        private static By lblTransValue_4 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_lblstrName_3");
        private static By txtTransValue_4 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_txtstrName_3");
        private static By lblEngValue_10 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_lblstrDefault_9");
        private static By txtEngValue_10 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_txtstrDefault_9");
        private static By lblTransValue_10 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_lblstrName_9");
        private static By txtTransValue_10 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_txtstrName_9");
        private static By lblParmType_4 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_lblstrParameterType_3");
        private static By ddlParmType_4 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_ddlidfsReferenceType_3");
        private static IList<IWebElement> parmTypeOpts_4 { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvStatisticalDataType_ddlidfsReferenceType_3']/option")); } }
        private static By lblBxStatAgeGrp_4 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_lblblnStatisticalAgeGroup_3");
        private static By chkBxStatAgeGrp_4 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_chkblnStatisticalAgeGroup_3");
        private static By lblStatAreaType_4 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_lblstrAreaType_3");
        private static By ddlStatAreaType_4 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_ddlidfsAreaType_3");
        private static IList<IWebElement> statAreaTypeOpts_4 { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvStatisticalDataType_ddlidfsAreaType_3']/option")); } }
        private static By lblStatPerType_4 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_lblstrPeriodType_3");
        private static By ddlStatPerType_4 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_ddlidfsPeriodType_3");
        private static IList<IWebElement> statPerTypeOpts_4 { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvStatisticalDataType_ddlidfsPeriodType_3']/option")); } }
        private static By lblParmType_10 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_lblstrParameterType_9");
        private static By ddlParmType_10 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_ddlidfsReferenceType_9");
        private static By lblBxStatAgeGrp_10 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_lblblnStatisticalAgeGroup_9");
        private static By chkBxStatAgeGrp_10 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_chkblnStatisticalAgeGroup_9");
        private static IList<IWebElement> parmTypeOpts_10 { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvStatisticalDataType_ddlidfsReferenceType_9']/option")); } }
        private static By lblStatAreaType_10 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_lblstrAreaType_9");
        private static By ddlStatAreaType_10 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_ddlidfsAreaType_9");
        private static IList<IWebElement> statAreaTypeOpts_10 { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvStatisticalDataType_ddlidfsAreaType_9']/option")); } }
        private static By lblStatPerType_10 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_lblstrPeriodType_9");
        private static By ddlStatPerType_10 = By.Id(CommonCtrls.GeneralContent + "gvStatisticalDataType_ddlidfsPeriodType_9");
        private static IList<IWebElement> statPerTypeOpts_10 { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvStatisticalDataType_ddlidfsPeriodType_9']/option")); } }
        public static String refValue1 = null;
        public static String refValue2 = null;
        private static By btnSave_4 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvStatisticalDataType']/tbody/tr[5]/td[8]/a");
        private static By btnCancel_4 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvStatisticalDataType']/tbody/tr[5]/td[9]/a");
        private static By btnDelete_4 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvStatisticalDataType_btnDelete_3");
        private static By btnSave_10 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvStatisticalDataType']/tbody/tr[11]/td[8]/a");
        private static By btnCancel_10 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvStatisticalDataType']/tbody/tr[11]/td[9]/a");
        private static By btnDelete_10 = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvStatisticalDataType_btnDelete_9");
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


        public static bool IsAt
        {
            get
            {
                Driver.Instance.WaitForPageToLoad();
                Thread.Sleep(3000);
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
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Generic Statistical Types List") &&
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

        public static void enterEnglishVal(By element, String value)
        {
            int numValue = rnd.Next(10000, 99999);
            SetMethods.enterObjectValue(element, value + numValue);
            englishValue = value + numValue;
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

        public static void doesRecordStillShowInEditMode(By el1, By el2)
        {
            try
            {
                if (Driver.Instance.FindElement(el1).Displayed)
                {
                    SetMethods.clickObjectButtons(el2);
                }
            }
            catch (NoSuchElementException e)
            {
                Console.WriteLine(e.Message);
            }
        }

        public static void doesFourthRecordShowInEditMode()
        {
            doesRecordStillShowInEditMode(ddlParmType_4, btnCancel_4);
        }

        public static void doesTenthRecordShowInEditMode()
        {
            doesRecordStillShowInEditMode(ddlStatAreaType_10, btnCancel_10);
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

        public static void getCurGenStatTransValue_10()
        {
            SetMethods.GetCurrentValue(txtTransValue_10);
        }

        public static void getNewGenStatTransValue_10()
        {
            SetMethods.GetNewvalue(lblTransValue_10);
        }

        public static void enterNewTransValue_10()
        {
            SetMethods.EditRefValue(txtTransValue_10, "GST");
        }

        public static void getCurGenStatParmType_10()
        {
            SetMethods.GetCurrentValue(ddlParmType_10);
        }

        public static void getNewGenStatParmType_10()
        {
            SetMethods.GetNewvalue(lblParmType_10);
        }

        public static void getCurGenStatStatAgeGrp_10()
        {
            SetMethods.GetNewvalue(lblBxStatAgeGrp_10);
        }

        public static void getNewGenStatStatAgeGrp_10()
        {
            SetMethods.GetNewvalue4(lblBxStatAgeGrp_10);
        }

        public static void getCurGenStatAreaType_10()
        {
            SetMethods.GetCurrentValue(ddlStatAreaType_10);
        }

        public static void getNewGenStatAreaType_10()
        {
            SetMethods.GetNewvalue(lblStatAreaType_10);
        }

        public static void getCurGenStatPerType_10()
        {
            SetMethods.GetNewvalue4(lblStatPerType_10);
        }

        public static void getNewGenStatPerType_10()
        {
            SetMethods.GetNewvalue(lblStatPerType_10);
        }


        public static void getCurGenStatTransValue_4()
        {
            SetMethods.GetCurrentValue(txtTransValue_4);
        }

        public static void getNewGenStatTransValue_4()
        {
            SetMethods.GetNewvalue(lblTransValue_4);
        }

        public static void enterNewTransValue_4()
        {
            SetMethods.EditRefValue(txtTransValue_4, "GST");
        }

        public static void getCurGenStatParmType_4()
        {
            SetMethods.GetCurrentValue(ddlParmType_4);
        }

        public static void getNewGenStatParmType_4()
        {
            SetMethods.GetNewvalue(lblParmType_4);
        }

        public static void enterNewParmType_4()
        {
            SetMethods.EditRefValue(ddlParmType_4, "GST");
        }

        public static void getCurGenStatStatAgeGrp_4()
        {
            SetMethods.GetCurrentValue(lblBxStatAgeGrp_4);
        }

        public static void getNewGenStatStatAgeGrp_4()
        {
            SetMethods.GetNewvalue(lblBxStatAgeGrp_4);
        }

        public static void getCurGenStatAreaType_4()
        {
            SetMethods.GetNewvalue4(lblStatAreaType_4);
        }

        public static void getNewGenStatAreaType_4()
        {
            SetMethods.GetNewvalue(lblStatAreaType_4);
        }

        public static void getCurGenStatPerType_4()
        {
            SetMethods.GetCurrentValue(lblStatPerType_4);
        }

        public static void getNewGenStatPerType_4()
        {
            SetMethods.GetNewvalue(lblStatPerType_4);
        }

        public static void clearEnglishValueField_4()
        {
            SetMethods.clearField(txtTransValue_4);
        }

        public static void clearTransValueField_4()
        {
            SetMethods.clearField(txtTransValue_4);
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

        public static void clickCancelSaveFourthRecord()
        {
            SetMethods.clickObjectButtons(btnCancel_4);
        }

        public static void clickCancelSaveTenthRecord()
        {
            SetMethods.clickObjectButtons(btnCancel_10);
        }

        public static void clearEnglishValueField_10()
        {
            SetMethods.clearField(txtTransValue_10);
        }

        public static void clearTransValueField_10()
        {
            SetMethods.clearField(txtTransValue_10);
        }

        public static void randomSelectParmType_4()
        {
            SetMethods.randomSelectObjectElement(ddlParmType_4, parmTypeOpts_4);
        }

        public static void randomSelectParmType_10()
        {
            SetMethods.randomSelectObjectElement(ddlParmType_10, parmTypeOpts_10);
        }
        public static void clickStatAgeGroup_4()
        {
            SetMethods.clickObjectButtons(chkBxStatAgeGrp_4);
        }

        public static void randomSelectStatAreaType_4()
        {
            SetMethods.randomSelectObjectElement(ddlStatAreaType_4, statAreaTypeOpts_4);
        }
        public static void clickStatAgeGroup_10()
        {
            SetMethods.clickObjectButtons(chkBxStatAgeGrp_10);
        }

        public static void randomSelectStatAreaType_10()
        {
            SetMethods.randomSelectObjectElement(ddlStatPerType_10, statAreaTypeOpts_10);
        }

        public static void randomSelectStatPeriodType_4()
        {
            SetMethods.randomSelectObjectElement(ddlStatPerType_4, statPerTypeOpts_4);
        }

        public static void randomSelectStatPeriodType_10()
        {
            SetMethods.randomSelectObjectElement(ddlStatPerType_10, statPerTypeOpts_10);
        }

        public class GenStatTypesPopupWndw
        {
            private static By titleFormTitle = By.TagName("h4");
            private static By txtEnglishValue = By.Id(CommonCtrls.GeneralContent + "txtSDstrDefault");
            private static By txtTransValue = By.Id(CommonCtrls.GeneralContent + "txtSDstrName");
            private static By chkStatAgeGrp = By.Id(CommonCtrls.GeneralContent + "chkSDblnRelatedWithAgeGroup");
            private static By ddlParmType = By.Id(CommonCtrls.GeneralContent + "ddlSDidfsReferenceType");
            private static IList<IWebElement> parmTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSDidfsReferenceType']/option")); } }
            private static By ddlStatPeriodType = By.Id(CommonCtrls.GeneralContent + "ddlSDidfsStatisticPeriodType");
            private static IList<IWebElement> statPerTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSDidfsStatisticPeriodType']/option")); } }
            private static By ddlStatAreaType = By.Id(CommonCtrls.GeneralContent + "ddlSDidfsStatisticAreaType");
            private static IList<IWebElement> statAreaTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSDidfsStatisticAreaType']/option")); } }
            private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSaveStatisticDataType");
            private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancelStatisticDataType");
            private static By btnSpinnerUp = By.XPath("//*[@class='glyphicon glyphicon-triangle-top']");
            private static By btnSpinnerDwn = By.XPath("//*[@class='glyphicon glyphicon-triangle-bottom']");

            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    Thread.Sleep(3000);
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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Generic Statistical Types") &&
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

            public static void enterEnglishValue()
            {
                enterEnglishVal(txtEnglishValue, "GST");
            }

            public static void enterTransValue()
            {
                SetMethods.enterObjectValue(txtTransValue, englishValue);
            }

            public static void clickStatAgeGroup()
            {
                SetMethods.clickObjectButtons(chkStatAgeGrp);
            }

            public static void randomSelectParameterType()
            {
                SetMethods.randomSelectObjectElement(ddlParmType, parmTypeOpts);
            }

            public static void enterParameterType(string value)
            {
                SetMethods.enterObjectValue(ddlParmType, value);
            }

            public static void randomSelectStatPeriodType()
            {
                SetMethods.randomSelectObjectElement(ddlStatPeriodType, statPerTypeOpts);
            }

            public static void enterStatPeriodType(string value)
            {
                SetMethods.enterObjectValue(ddlStatPeriodType, value);
            }

            public static void randomSelectStatAreaType()
            {
                SetMethods.randomSelectObjectElement(ddlStatAreaType, statAreaTypeOpts);
            }

            public static void enterStatAreaType(string value)
            {
                SetMethods.enterObjectValue(ddlStatAreaType, value);
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


        }
    }
}
