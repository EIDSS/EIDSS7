using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using System.Threading;
using EIDSS7Test.Common;
using System.Linq;
using NUnit.Framework;
using OpenQA.Selenium.Interactions;

namespace EIDSS7Test.Veterinary.ActiveSurveillanceCampaigns
{
    public class CreateVetActiveSurvCampPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();
        public static string errorString;

        private static By titleFormTitle = By.TagName("h2");
        private static By campInfoSection = By.Id(CommonCtrls.GeneralContent + "campaignInfoHeading");
        private static By sampleSpeciesSection = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "divSpeciesAndSamplesContainer']/div[1]/div/div[1]/h3");
        private static By btnReturnToDashboard = By.LinkText("Return to Dashboard");
        private static By btnDeleteCamp = By.Id(CommonCtrls.GeneralContent + "btnDeleteCampaign");
        private static By btnSaveReview = By.Id(CommonCtrls.GeneralContent + "btnSaveReview");
        private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancelCampaign");
        private static By btnEditCampaign = By.Id(CommonCtrls.GeneralContent + "btnEditCampaign");
        private static By btnSaveReport = By.Id(CommonCtrls.GeneralContent + "btnSaveCampaign");
        private static By btnNewCampaign = By.Id(CommonCtrls.GeneralContent + "btnNewCampaign");
        private static By btnNewSearch = By.Id(CommonCtrls.GeneralContent + "btnNewSearch");
        private static By btnSearch = By.Id(CommonCtrls.GeneralContent + "btnSearch");
        private static By btnClear = By.Id(CommonCtrls.GeneralContent + "btnClear");
        private static By titleSystemAlert = By.Id(CommonCtrls.GeneralContent + "warningHeading");
        private static By btnClose = By.XPath("//*[@id='WarningModal']/div/div/div[3]/button");


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
                    Assert.Fail("Page cannot be found.  Please try again.");
                    return false;
                }
                else if (Driver.Instance.FindElements(titleFormTitle).Count > 0)
                {
                    if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Active Surveillance Campaign") &&
                        Driver.Instance.FindElement(titleFormTitle).Displayed)
                        return true;
                    else
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Page cannot be found.  Please try again.");
                    return false;
                }
                else
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Page cannot be found.  Please try again.");
                    return false;
                }
            }
        }

        public static void EIDSSSystemAlertMessage()
        {
            try
            {
                var eidssAlert = wait.Until(ExpectedConditions.ElementIsVisible(titleSystemAlert));
                if (eidssAlert.Displayed)
                {
                    //Switch to new window
                    Thread.Sleep(45);
                    string newWindowHandle = Driver.Instance.WindowHandles.Last();
                    var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);

                    var closeBtn = wait.Until(ExpectedConditions.ElementToBeClickable(btnClose));
                    closeBtn.Click();
                    Thread.Sleep(45);

                    //Switch back to current window
                    newWindow.SwitchTo().Window(Driver.Instance.CurrentWindowHandle);
                }
            }
            catch
            {
                Console.WriteLine("Alert message does not exist.");
            }
        }

        public static void clickCancel()
        {
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clickNewCampaign()
        {
            SetMethods.clickObjectButtons(btnNewCampaign);
        }

        public static void clickSearch()
        {
            SetMethods.clickObjectButtons(btnSearch);
        }

        public static void clickNewSearch()
        {
            SetMethods.clickObjectButtons(btnNewSearch);
        }


        public static void clickDeleteCampaign()
        {
            SetMethods.clickObjectButtons(btnDeleteCamp);
        }

        public static void clickSaveAndReview()
        {
            SetMethods.clickObjectButtons(btnSaveReview);
        }

        public static void clickSaveReport()
        {
            SetMethods.clickObjectButtons(btnSaveReport);
        }

        public static void clickEditCampaign()
        {
            SetMethods.clickObjectButtons(btnEditCampaign);
        }


        public static string doesErrorAlertPopupMessageDisplay()
        {
            try
            {
                string text = Driver.Instance.SwitchTo().Alert().Text;
                errorString = text;
            }
            catch
            {
                //Fails the test if error message does not display
                Assert.IsTrue(String.IsNullOrEmpty(errorString));
            }
            return errorString;
        }


        public class CampaignInformation
        {
            private static By txtCampaignID = By.Id(CommonCtrls.GeneralContent + "txtstrCampaignID");
            private static By txtCampaignName = By.Id(CommonCtrls.GeneralContent + "txtstrCampaignName");
            private static By ddlCampaignType = By.Id(CommonCtrls.GeneralContent + "ddlidfsCampaignType");
            private static IList<IWebElement> typeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsCampaignType']/option")); } }
            private static By ddlCampaignStatus = By.Id(CommonCtrls.GeneralContent + "ddlidfsCampaignStatus");
            private static IList<IWebElement> statusOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsCampaignStatus']/option")); } }
            private static By datCampaignStartDate = By.Id(CommonCtrls.GeneralContent + "txtdatCampaignDateStart");
            private static By datCampaignEndDate = By.Id(CommonCtrls.GeneralContent + "txtdatCampaignDateEnd");
            private static By txtCampaignAdmin = By.Id(CommonCtrls.GeneralContent + "txtstrCampaignAdministrator");
            private static By ddlDiagnosis = By.Id(CommonCtrls.GeneralContent + "ddlidfsDiagnosis");
            private static By btnEditCampaign = By.Id(CommonCtrls.GeneralContent + "btnEditCampaign");
            private static IList<IWebElement> diagnosisOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsDiagnosis']/option")); } }
            private static By txtCampaignNameError = By.Id(CommonCtrls.GeneralContent + "ctl42");
            private static By txtCampaignTypeError = By.Id(CommonCtrls.GeneralContent + "ctl45");
            private static By txtCampaignStatusError = By.Id(CommonCtrls.GeneralContent + "ctl48");
            private static By txtDiagnosisError = By.Id(CommonCtrls.GeneralContent + "ctl65");
            public static String campaignNM;
            public static String campaignAD;
            public static String campID;
            public static String diagnosis;
            public static String currentDate;

            public static bool IsAt
            {
                get
                {
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(campInfoSection).Count > 0)
                    {
                        if (Driver.Instance.FindElement(campInfoSection).Text.Contains("Campaign Information") &&
                            Driver.Instance.FindElement(campInfoSection).Displayed)
                            return true;
                        else
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Section cannot be found.  Please try again.");
                        return false;
                    }
                    else
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Section cannot be found.  Please try again.");
                        return false;
                    }
                }
            }

            public static String getCampaignStatusError()
            {
                try
                {
                    var campStatusError = wait.Until(ExpectedConditions.ElementIsVisible(txtCampaignStatusError)).Text;
                    Driver.Wait(TimeSpan.FromMinutes(5));
                    return campStatusError;
                }
                catch (Exception e)
                {
                    return e.Message;
                }
            }

            public static void doesCampaignNameErrorMsgDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(txtCampaignNameError);
            }

            public static void doesCampaignStatusErrorMsgDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(txtCampaignStatusError);
            }

            public static void doesCampaignTypeErrorMsgDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(txtCampaignTypeError);
            }

            public static void doesDiagnosisErrorMsgDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(txtDiagnosisError);
            }

            public static void editCampaign()
            {
                SetMethods.clickObjectButtons(btnEditCampaign);
            }

            public static void clearCampaignName()
            {
                SetMethods.clearField(txtCampaignName);
            }

            public static void clearCampaignAdmin()
            {
                SetMethods.clearField(txtCampaignAdmin);
            }

            public static void clearCampaignStatus()
            {
                SetMethods.clearDropdownList(ddlCampaignStatus);
            }

            public static void clearCampaignType()
            {
                SetMethods.clearDropdownList(ddlCampaignType);
            }


            public static string enterCampaignName(string campName)
            {
                int rNum = rnd.Next(1000, 9999999);
                campaignNM = campName + rNum;
                SetMethods.enterObjectValue(txtCampaignName, campName);
                return campaignNM;
            }

            public static void selectRandomCampaignType()
            {
                SetMethods.randomSelectObjectElement(ddlCampaignType, typeOptions);
            }

            public static void selectRandomCampaignStatus()
            {
                SetMethods.randomSelectObjectElement(ddlCampaignStatus, statusOptions);
            }

            public static void selectCampaignStatus(string selStatus)
            {
                SetMethods.selectObjectFromDropdownList(ddlCampaignStatus, statusOptions, selStatus);
            }

            public static void selectCampaignType(string selType)
            {
                SetMethods.selectObjectFromDropdownList(ddlCampaignType, typeOptions, selType);
            }

            public static void enterCampaignStartDate()
            {
                SetMethods.enterCurrentDate(datCampaignStartDate);
            }

            public static void enterCampaignIncorrectEndDate()
            {
                SetMethods.enterPastDate(datCampaignEndDate, 5);
            }

            public static void enterCampaignEndDate()
            {
                SetMethods.enterCurrentDate(datCampaignEndDate);
            }

            public static void enterCampaignAdmin(string campAdmin)
            {
                int rNum = rnd.Next(1, 1000);
                campaignAD = campAdmin + rNum;
                SetMethods.enterObjectValue(txtCampaignAdmin, campaignAD);
            }

            public static void randomSelectDiagnosis()
            {
                SetMethods.randomSelectObjectElement(ddlDiagnosis, diagnosisOptions);
            }

            public static String getCampaignID()
            {
                var campaignID = Driver.Instance.FindElement(txtCampaignID).GetAttribute("value");
                return campID = campaignID;
            }

            public static String getDiagnosis()
            {
                var diag = Driver.Instance.FindElement(ddlDiagnosis).Text;
                return diagnosis = diag;
            }

            public static String getCampaignName()
            {
                var campNM = Driver.Instance.FindElement(txtCampaignName).GetAttribute("value");
                return campaignNM = campNM;
            }

        }

        public class SpeciesAndSamples
        {
            public static string[] GroupA = new string[] { "Anthrax", "Anthrax – Cutaneous", "Anthrax – Gastrointestinal", "Anthrax – Oropharyngeal", "Anthrax – Pulmonary", "Anthrax – Unspecified" };
            public static string[] GroupB = new string[] { "Tularemia – Gastrointestinal", "Tularemia – General", "Tularemia – Oculobubonic", "Tularemia – Oropharyngeal", "Tularemia – Pulmonary", "Tularemia – Ulcerobubonic", "Tularemia – Unspecified" };
            public static string[] GroupC = new string[] { "Plague – Bubonic", "Plague – Pneumonic", "Plague – Septicemic", "Plague – Unspecified" };
            private static By ddlSpecies = By.Id(CommonCtrls.GeneralContent + "gvSpeciesAndSamples_ddlSpecies");
            private static IList<IWebElement> speciesOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvSpeciesAndSamples_ddlSpecies']/option")); } }
            private static By ddlSampleType = By.Id(CommonCtrls.GeneralContent + "gvSpeciesAndSamples_ddlSampleType");
            private static IList<IWebElement> sampleTypeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvSpeciesAndSamples_ddlSampleType']/option")); } }
            private static By txtPlannedNumber = By.Id(CommonCtrls.GeneralContent + "gvSpeciesAndSamples_ddlPlannedNumber");
            private static By btnAddSpecies = By.Id(CommonCtrls.GeneralContent + "gvSpeciesAndSamples_btnAddSpecies");
            private static By btnRemoveSpecies = By.Id(CommonCtrls.GeneralContent + "gvSpeciesAndSamples_btnGvSpeciesDelete");

            public static bool IsAt
            {
                get
                {
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 500)", "");
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(sampleSpeciesSection).Count > 0)
                    {
                        if (Driver.Instance.FindElement(sampleSpeciesSection).Text.Contains("Species and Samples") &&
                            Driver.Instance.FindElement(sampleSpeciesSection).Displayed)
                            return true;
                        else
                            return false;
                    }
                    else
                    {
                        return false;
                    }
                }
            }

            public static void randomSelectSpecies()
            {
                SetMethods.randomSelectObjectElement(ddlSpecies, speciesOptions);
            }

            public static void randomSelectSampleType()
            {
                SetMethods.randomSelectObjectElement(ddlSampleType, sampleTypeOptions);
            }

            public static void enterRandomPlannedNumber()
            {
                Random rnd = new Random();
                int rNum = rnd.Next(1, 100);
                SetMethods.enterIntObjectValue(txtPlannedNumber, rNum);
            }

            public static void clickAddSpeciesAndSamples()
            {
                SetMethods.clickObjectButtons(btnAddSpecies);
            }

            public static void clickRemoveSpeciesAndSamples()
            {
                SetMethods.clickObjectButtons(btnRemoveSpecies);
            }

            public static void getNameOfSpecies()
            {
                throw new NotImplementedException();
            }

            public static void addAllSpeciesGroupA()
            {

            }

            public static void addAllSpeciesGroupB()
            {

            }

            public static void addAllSpeciesGroupC()
            {

            }

            public class SessionsList
            {
                private static By sessionsGrid = By.Id(CommonCtrls.GeneralContent + "Sessions");
                private static By sessionsSection = By.Id(CommonCtrls.GeneralContent + "Sessions']/div[1]/h3");
                private static By btnAddSession = By.Id(CommonCtrls.GeneralContent + "btnAddSession");
                private static By tblSessions = By.Id(CommonCtrls.GeneralContent + "gvSessions");


                public static void clickAddSession()
                {
                    SetMethods.clickObjectButtons(btnAddSession);
                }
            }

        }

        public class CampaignSave
        {
            private static By titleFormTitle = By.TagName("h4");
            private static By txtEidssCampID = By.Id(CommonCtrls.GeneralContent + "successSubTitle");
            private static By btnReturnToCampRecord = By.Id(CommonCtrls.GeneralContent + "btnReturnToCampaignRecord");
            private static By btnNewSearch = By.Id(CommonCtrls.GeneralContent + "btnNewSearchSuccess");
            private static By btnReturnToDash = By.LinkText("Return to Dashboard");
            public static String campaignID;


            public static bool IsAt
            {
                get
                {
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 500)", "");
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(titleFormTitle).Count > 0)
                    {
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Successful Campaign Save") &&
                            Driver.Instance.FindElement(titleFormTitle).Displayed)
                            return true;
                        else
                            return false;
                    }
                    else
                    {
                        return false;
                    }
                }
            }

            public static void clickReturnToCampaignRecord()
            {
                SetMethods.clickObjectButtons(btnReturnToCampRecord);
            }

            public static void clickNewSearch()
            {
                SetMethods.clickObjectButtons(btnNewSearch);
            }

            public static void clickReturnToDashboard()
            {
                SetMethods.clickObjectButtons(btnReturnToDash);
            }

            public static String getCampaignID()
            {
                var ID = wait.Until(ExpectedConditions.ElementIsVisible(txtEidssCampID)).Text;
                return campaignID = ID;
            }
        }
    }
}