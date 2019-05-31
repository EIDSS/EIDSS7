using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Threading;

namespace EIDSS7Test.HumanCases.HumanActiveSurveillanceCampaign
{
    public class CreateHumanActiveSurvCampaignPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();
        public static string campaignName;
        public static String campaignNo;
        public static String campaignRecordNo;
        public static string sessionIdNo;
        public static String campTypeName;
        public static String campaignStatus;
        public static String sampleTypeNames;
        public static String diagnosisName;
        public static string currentDate;
        public static string plannedNumber;
        public static string errorString;
        public static int numberOfRows1;
        public static int numberOfRows2;

        private static By titleFormTitle = By.TagName("h2");
        private static By btnCancel = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "campaignInformation']/div/div[3]/div/button");
        private static By btnNext = By.Id(CommonCtrls.GeneralContent + "btnNextSection");
        private static By btnPrevious = By.Id(CommonCtrls.GeneralContent + "btnPreviousSection");
        private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmit");
        private static By sideBarFailMark = By.Id("sideBarItemEnterHASC");
        private static By panelMenuList = By.Id("panelList");
        private static IList<IWebElement> btnEdits { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-edit']")); } }
        private static By linkCampInfo = By.LinkText("Campaign Information");
        private static By linkSample = By.LinkText("Samples");
        private static By linkReview = By.LinkText("Review");
        private static By txtCampaignCancelMsg = By.Id(CommonCtrls.GeneralContent + "lblCampaignCancel");
        private static By txtCampaignSuccessMsg = By.Id(CommonCtrls.GeneralContent + "lblCampaignSuccess");
        private static By btnOK = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "errorCampaign']/div/div/div[3]/button");
        private static By btnYes = By.Id(CommonCtrls.GeneralContent + "btnCancelYes");
        private static By btnNo = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "cancelCampaign']/div/div/div[3]/button[2]");
        private static By btnReturnToSearch = By.Id(CommonCtrls.GeneralContent + "btnRTS");
        private static By btnReturnToDashboard = By.Id(CommonCtrls.GeneralContent + "btnRTDSC");
        private static By btnReturnToCampRecord = By.Id(CommonCtrls.GeneralContent + "btnRTCR");
        private static By lblSampleDeleteErrorMsg = By.Id(CommonCtrls.GeneralContent + "lbl_Error");
        private static By btnPopupErrorOK = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "errorCampaign']/div/div/div[3]/button");

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
                        Driver.Wait(TimeSpan.FromMinutes(45));
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Active Surveillance Campaign") &&
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


        public static bool doesRedCheckMarkDisplay()
        {
            try
            {
                Driver.Instance.FindElement(sideBarFailMark);
                return true;
            }
            catch
            {
                return false;
            }
        }

        public static void clickCancel()
        {
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clickNext()
        {
            SetMethods.clickObjectButtons(btnNext);
        }

        public static void clickNextToReviewTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 1; i++)
            {
                SetMethods.clickObjectButtons(btnNext);
            }
        }

        public static void clickPrevious()
        {
            SetMethods.clickObjectButtons(btnPrevious);
        }

        public static void clickSubmit()
        {
            SetMethods.clickObjectButtons(btnSubmit);
        }

        public static void clickSamplesLink()
        {
            SetMethods.clickObjectButtons(linkSample);
        }

        public static void clickCampInfoLink()
        {
            SetMethods.clickObjectButtons(linkCampInfo);
        }

        public static void clickReviewLink()
        {
            SetMethods.clickObjectButtons(linkReview);
        }

        public static void clickPopupOK()
        {
            SetMethods.clickObjectButtons(btnOK);
        }

        public static void clickPopupYes()
        {
            SetMethods.clickObjectButtons(btnYes);
        }

        public static void clickPopupNo()
        {
            SetMethods.clickObjectButtons(btnNo);
        }

        public static void clickReturnToCampRecord()
        {
            SetMethods.clickObjectButtons(btnReturnToCampRecord);
        }

        public static void clickReturnToDashboard()
        {
            SetMethods.clickObjectButtons(btnReturnToDashboard);
        }

        public static void clickReturnToSearch()
        {
            SetMethods.clickObjectButtons(btnReturnToSearch);
        }

        public static String doesCancelPopupMessageDisplays()
        {
            try
            {
                //Had to refactor for error message ID, not popup alert
                Driver.Wait(TimeSpan.FromMinutes(20));
                var text = wait.Until(ExpectedConditions.ElementIsVisible(txtCampaignCancelMsg)).Text;
                Driver.Wait(TimeSpan.FromMinutes(20));
                errorString = text;
            }
            catch
            {
                //Fails the test if error message does not display
                Assert.Fail();
            }
            return errorString;
        }

        public static String doesCreateCampaignSuccessfulMessageDisplays()
        {
            try
            {
                //Had to refactor for error message ID, not popup alert
                Driver.Wait(TimeSpan.FromMinutes(20));
                var text = wait.Until(ExpectedConditions.ElementIsVisible(txtCampaignSuccessMsg)).Text;
                Driver.Wait(TimeSpan.FromMinutes(20));
                errorString = text;
            }
            catch
            {
                //Fails the test if error message does not display
                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail("Success message does not display.");
            }
            return errorString;
        }

        public static String getPopupCampaignID()
        {
            var campaignID = Driver.Instance.FindElement(txtCampaignSuccessMsg).Text;
            Driver.Wait(TimeSpan.FromMinutes(20));
            return campaignNo = campaignID.Substring(campaignID.Length - 15).TrimEnd('.');
        }

        public static String getCampRecordID()
        {
            var campaignID = Driver.Instance.FindElement(txtCampaignSuccessMsg).GetAttribute("value");
            Driver.Wait(TimeSpan.FromMinutes(20));
            return campaignRecordNo = campaignID.ToString();
        }

        public static void doesEIDSSDeleteErrorMessageDisplays()
        {
            SetMethods.doesValidationErrorMessageDisplay(Samples.lblRemoveSample, lblSampleDeleteErrorMsg, btnPopupErrorOK);
        }


        public class CampaignInformation
        {
            private static By campInfoFormTitle = By.TagName("h3");
            private static By txtCampaignName = By.Id(CommonCtrls.GeneralContent + "txtstrCampaignName");
            private static By txtCampaignIDNumber = By.Id(CommonCtrls.GeneralContent + "txtstrCampaignID");
            private static By datStartDate = By.Id(CommonCtrls.GeneralContent + "txtdatCampaignDateStart");
            private static By datEndDate = By.Id(CommonCtrls.GeneralContent + "txtdatCampaignDateEnd");
            private static By ddlCampaignType = By.Id(CommonCtrls.GeneralContent + "ddlidfsCampaignType");
            private static IList<IWebElement> campTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsCampaignType']/option")); } }
            private static By ddlCampaignStatus = By.Id(CommonCtrls.GeneralContent + "ddlidfsCampaignStatus");
            private static IList<IWebElement> campStatusOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsCampaignStatus']/option")); } }
            private static By txtCampAdmin = By.Id(CommonCtrls.GeneralContent + "txtstrCampaignAdministrator");
            private static By ddlDiagnosis = By.Id(CommonCtrls.GeneralContent + "ddlidfsDiagnosis");
            private static IList<IWebElement> diagnosisOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsDiagnosis']/option")); } }
            private static By CampaignNameError = By.Id(CommonCtrls.GeneralContent + "ctl24");
            private static By CampaignTypeError = By.Id(CommonCtrls.GeneralContent + "ctl28");
            private static By SampleTypeError = By.Id(CommonCtrls.GeneralContent + "lbl_Error");
            public static String CampaignNameErrorMsg = "Campaign Name is required";
            public static String CampaignTypeErrorMsg = "Campaign Type is required";
            public static String SampleErrorMsg = "A sample must contain a sample type and planned number.";



            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(campInfoFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(campInfoFormTitle).Text.Contains("Campaign Information") &&
                                Driver.Instance.FindElement(campInfoFormTitle).Displayed)
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
                        return false;
                    }
                }
            }

            public static String enterRandomCampaignName(string FName)
            {
                int rNum = rnd.Next(1000, 100000000);
                campaignName = FName + rNum;
                SetMethods.enterObjectValue(txtCampaignName, campaignName);
                return campaignName;
            }

            public static void randomSelectCampaignType()
            {
                SetMethods.randomSelectObjectElement(ddlCampaignType, campTypeOpts);
            }

            public static void selectClosedCampaignStatus()
            {
                SetMethods.enterObjectValue(ddlCampaignStatus, "Closed");
            }

            public static void selectOpenCampaignStatus()
            {
                SetMethods.enterObjectValue(ddlCampaignStatus, "Open");
            }

            public static void enterCampStartDate()
            {
                SetMethods.enterCurrentDate(datStartDate);
            }

            public static void enterCampEndDate()
            {
                SetMethods.enterDate30DaysAhead(datEndDate);
            }

            public static void enterCampaignAdministrator()
            {
                SetMethods.enterObjectValue(txtCampAdmin, "LMA Administrator");
            }

            public static void enterCampaignType(String value)
            {
                SetMethods.enterObjectValue(ddlCampaignType, value);
                Driver.Wait(TimeSpan.FromMinutes(20));
                campTypeName = value;
            }

            public static void enterCampaignStatus(String value)
            {
                SetMethods.enterObjectValue(ddlCampaignStatus, value);
                Driver.Wait(TimeSpan.FromMinutes(20));
                campaignStatus = value;
            }

            public static void randomSelectDiagnosis()
            {
                SetMethods.randomSelectObjectElement(ddlDiagnosis, diagnosisOpts);
            }

            public static void enterDiagnosis(String value)
            {
                SetMethods.enterObjectValue(ddlDiagnosis, value);
                Thread.Sleep(3000);
                diagnosisName = value;
            }

            public static String storeDiagnosis()
            {
                var campaignID = Driver.Instance.FindElement(ddlDiagnosis).GetAttribute("value");
                Driver.Wait(TimeSpan.FromMinutes(20));
                return diagnosisName = campaignID.ToString();
            }

            public static String getCampRecordID()
            {
                var campaignID = Driver.Instance.FindElement(txtCampaignIDNumber).GetAttribute("value");
                Driver.Wait(TimeSpan.FromMinutes(20));
                return campaignRecordNo = campaignID.ToString();
            }

            public static void doesCampaignNameErrorMessageDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(CampaignNameError);
            }

            public static void doesCampaignTypeErrorMessageDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(CampaignTypeError);
            }

            public static void doesSampleErrorMessageDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(SampleTypeError);
            }
        }


        public class Samples
        {
            private static By sampleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "campaignInformation']/div/div[2]/div[4]/div[1]/div/h3");
            private static By ddlSampleType = By.Id(CommonCtrls.GeneralContent + "gvSamples_ddlSampleType");
            private static By tlbSampleTable = By.Id(CommonCtrls.GeneralContent + "gvSamples");
            public static By lblRemoveSample = By.Id(CommonCtrls.GeneralContent + "lblRemoveSampleType");
            private static By btnYesRemoveSample = By.Id(CommonCtrls.GeneralContent + "btnDeleteSampleType");
            private static By btnNoRemoveSample = By.XPath("/html/body/form/div[3]/div/div/div[7]/div/div/div[3]/button[2]");
            private static IList<IWebElement> sampleTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvSamples_ddlSampleType']/option")); } }
            private static By btnAddSamples = By.Id(CommonCtrls.GeneralContent + "gvSamples_btnAdd");
            private static By btnDeleteSample = By.Id(CommonCtrls.GeneralContent + "gvSamples_btnDelete_0");
            private static By txtPlannedNumber = By.Id(CommonCtrls.GeneralContent + "gvSamples_txtPlannedNumber");
            //private static By txtSampleTypeName = By.Id(CommonCtrls.GeneralContent + "gvSamples_lblSampleTypeText_0");
            private static IList<IWebElement> lsSampleTypeNames = Driver.Instance.FindElements(By.XPath("*[contains(@id,'gvSamples_lblSampleTypeText_')]"));

            public static bool IsAt
            {
                get
                {
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 500)", "");
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(sampleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(sampleFormTitle).Text.Contains("Samples") &&
                                Driver.Instance.FindElement(sampleFormTitle).Displayed)
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
                        return false;
                    }
                }
            }

            public static void randomSelectSampleType()
            {
                SetMethods.randomSelectObjectElement(ddlSampleType, sampleTypeOpts);
            }

            public static void enterSampleType(string value)
            {
                SetMethods.enterObjectValue(ddlSampleType, value);
            }

            public static void clickAddSample()
            {
                SetMethods.clickObjectButtons(btnAddSamples);
            }

            public static void clickDeleteFirstSample()
            {
                SetMethods.clickObjectButtons(btnDeleteSample);
            }

            public static void getTableRowCountBefore()
            {
                SetMethods.GetNumberOfRowsInTableBefore(tlbSampleTable);
            }

            public static void getTableRowCountAfter()
            {
                SetMethods.GetNumberOfRowsInTableAfter(tlbSampleTable);
            }

            public static void clickYesToConfirmDelete()
            {
                SetMethods.clickObjectButtons(btnYesRemoveSample);
            }

            public static void clickNoToConfirmNoDeletion()
            {
                SetMethods.clickObjectButtons(btnYesRemoveSample);
            }

            public static void randomEnterPlannedNumber()
            {
                int rNum = rnd.Next(1, 10);
                SetMethods.enterIntObjectValue(txtPlannedNumber, rNum);
            }

            public static IList<IWebElement> getSampleNames()
            {
                return SetMethods.StoreElementsInList1(lsSampleTypeNames);
            }

            public static void doesRemoveSampleTypeConfirmMsgDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(lblRemoveSample);
            }
        }

        public class Sessions
        {
            private static By sessionFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "sessions']/div/div[1]/div/div[1]/h3");
            private static By readOnlySessionID = By.Id(CommonCtrls.GeneralContent + "gvSessions_lblstrMonitoringSessionID_0");
            private static By btnSearchSessions = By.Id(CommonCtrls.GeneralContent + "btnSearchSessions");
            private static By btnNewSession = By.Id(CommonCtrls.GeneralContent + "btnNewSession");
            private static IList<IWebElement> btnEdits { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-edit']")); } }
            private static By btnEdit = By.XPath("//a[@class='btn glyphicon glyphicon-edit']");
            private static By btnDelete = By.XPath("//a[@class='glyphicon glyphicon-trash']");


            public static bool IsAt
            {
                get
                {
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1000)", "");
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(sessionFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(sessionFormTitle).Text.Contains("Sessions") &&
                                Driver.Instance.FindElement(sessionFormTitle).Displayed)
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
                        return false;
                    }
                }
            }

            public static void clickAddNewSession()
            {
                SetMethods.clickObjectButtons(btnNewSession);
            }

            public static void clickSearchForASession()
            {
                SetMethods.clickObjectButtons(btnSearchSessions);
            }

            public static void clickDeleteSession()
            {
                SetMethods.clickObjectButtons(btnDelete);
            }

            public static void clickEditSession()
            {
                SetMethods.clickObjectButtons(btnEdit);
            }

            public static String getCampaignSessionID()
            {
                //Scroll to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1200)", "");
                Thread.Sleep(1000);
                var sessionID = Driver.Instance.FindElement(readOnlySessionID).Text;
                return sessionIdNo = sessionID.ToString();
            }
        }

        public class Conclusions
        {
            private static By sessionFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "sessions']/div/div[1]/div/div[1]/h3");
            private static By txtConclusion = By.Id(CommonCtrls.GeneralContent + "txtstrConclusion");


            public static bool IsAt
            {
                get
                {
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1500)", "");
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(sessionFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(sessionFormTitle).Text.Contains("Conclusions") &&
                                Driver.Instance.FindElement(sessionFormTitle).Displayed)
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
                        return false;
                    }
                }
            }
        }
    }
}
