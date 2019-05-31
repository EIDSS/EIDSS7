using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Threading;

namespace EIDSS7Test.HumanCases.HumanActiveSurveillanceSesson
{
    public class CreateHumanActiveSurvSessionPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();

        public static string campaignName;
        public static String campaignNo;
        public static String campaignRecordNo;
        public static String sessionRecordNo;
        public static string sessionIdNo;
        public static string campTypeName;
        public static string sessionStatus;
        public static string selectedRegion;
        public static string selectedRayon;
        public static string enteredDate;
        public static string sampleTypeNames;
        public static string diagnosisName;
        public static string regionName;
        public static string rayonName;
        public static string settlementName;
        public static string currentDate;
        public static string plannedNumber;
        public static string errorString;
        public static int numberOfRows1;
        public static int numberOfRows2;

        private static By titleFormTitle = By.TagName("h2");
        private static By btnCancel = By.XPath("//input[@class='btn btn-default']");
        private static By btnContinue = By.Id(CommonCtrls.GeneralContent + "btnNextSection");
        private static By btnBack = By.Id(CommonCtrls.GeneralContent + "btnPreviousSection");
        private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmit");
        private static By btnReturnToSearch = By.Id(CommonCtrls.GeneralContent + "btnReturntoSearchResults");
        private static IList<IWebElement> btnEdits { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-edit']")); } }
        private static By linkSessInfo = By.LinkText("Session Information");
        private static By linkPersonSamples = By.LinkText("Person & Samples");
        private static By linkActions = By.LinkText("Actions");
        private static By linkDiseaseReport = By.LinkText("Disease Report");
        private static By linkTests = By.LinkText("Tests");
        private static By linkReview = By.LinkText("Review");
        private static By txtSessionCancelMsg = By.Id(CommonCtrls.GeneralContent + "lblCampaignCancel");
        private static By txtSessionSuccessMsg = By.Id(CommonCtrls.GeneralContent + "lblCampaignSuccess");
        private static By btnOK = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "errorCampaign']/div/div/div[3]/button");
        private static By btnYes = By.Id(CommonCtrls.GeneralContent + "btnCancelYes");
        private static By btnNo = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "cancelCampaign']/div/div/div[3]/button[2]");
        private static By btnPopupRTSrch = By.Id(CommonCtrls.GeneralContent + "btnReturntoSearchResults");
        private static By btnPopupRTD = By.Id(CommonCtrls.GeneralContent + "btnRtD");
        private static By btnPopupRTS = By.Id(CommonCtrls.GeneralContent + "btnRTSR");
        private static By lblEIDSSErrorMsg = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lbl_Error']");
        private static By btnEIDSSErrorOK = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "errorSession']/div/div/div[3]/button");

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
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Active Surveillance Session") &&
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

        public static void doesProblemRetrievingSearchDataMsgDisplays()
        {
            if (Driver.Instance.FindElement(lblEIDSSErrorMsg).Displayed && Driver.Instance.FindElements(lblEIDSSErrorMsg).Count > 0)
            {
                Thread.Sleep(1000);
                string text = wait.Until(ExpectedConditions.ElementIsVisible(lblEIDSSErrorMsg)).Text;
                if (text == null)
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Pass("Message does not display successfully.");
                }
                else
                {
                    errorString = text;
                    SetMethods.clickObjectButtons(btnEIDSSErrorOK);
                }
            }
        }


        public static String getSelectedElement(By element, string val)
        {
            Driver.Wait(TimeSpan.FromMinutes(1000));
            var element2 = Driver.Instance.FindElement(element).Text;
            Driver.Wait(TimeSpan.FromMinutes(1000));
            return val = element2;
        }

        public static void clickCancel()
        {
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clickContinue()
        {
            SetMethods.clickObjectButtons(btnContinue);
        }

        public static void clickBack()
        {
            SetMethods.clickObjectButtons(btnBack);
        }

        public static void clickSubmit()
        {
            SetMethods.clickObjectButtons(btnSubmit);
        }

        public static void clickPersonAndSamplesLink()
        {
            SetMethods.clickObjectButtons(linkPersonSamples);
        }

        public static void clickActionsLink()
        {
            SetMethods.clickObjectButtons(linkActions);
        }

        public static void clickDiseaseReportLink()
        {
            SetMethods.clickObjectButtons(linkDiseaseReport);
        }

        public static void clickTestsLink()
        {
            SetMethods.clickObjectButtons(linkTests);
        }

        public static void clickSessionInfoLink()
        {
            SetMethods.clickObjectButtons(linkSessInfo);
        }

        public static void clickReviewLink()
        {
            SetMethods.clickObjectButtons(linkReview);
        }

        public static void clickReturnToSessRecord()
        {
            SetMethods.clickObjectButtons(btnPopupRTS);
        }

        public static void clickReturnToDashboard()
        {
            SetMethods.clickObjectButtons(btnPopupRTD);
        }

        public static void clickReturnToSearch()
        {
            SetMethods.clickObjectButtons(btnPopupRTSrch);
        }

        public static void doesSessionSuccessPopupMessageDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(txtSessionSuccessMsg);
        }

        public static void doesCancelSessionPopupMessageDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(txtSessionCancelMsg);
        }


        public class SessionInformation
        {
            private static By sessInfoFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "sesInfo']/div[1]/div[1]/div[1]/h3");
            private static By txtSessionIDNum = By.Id(CommonCtrls.GeneralContent + "txtstrMonitoringSessionID");
            private static By datSessStartDate = By.Id(CommonCtrls.GeneralContent + "txtdatStartDate");
            private static By datSessEndDate = By.Id(CommonCtrls.GeneralContent + "txtdatEndDate");
            private static By ddlSessStatus = By.Id(CommonCtrls.GeneralContent + "ddlidfsMonitoringSessionStatus");
            private static IList<IWebElement> sessStatOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsMonitoringSessionStatus']/option")); } }
            private static By ddlDisease = By.Id(CommonCtrls.GeneralContent + "ddlidfsDiagnosis");
            private static IList<IWebElement> diseaseOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsDiagnosis']/option")); } }
            private static By readOnlyCampaignID = By.Id(CommonCtrls.GeneralContent + "txtstrCampaignID");
            private static By readOnlyCampaignName = By.Id(CommonCtrls.GeneralContent + "txtstrCampaignName");
            private static By readOnlyCampaignType = By.Id(CommonCtrls.GeneralContent + "txtstrCampaignType");
            private static By readOnlyDateEntered = By.Id(CommonCtrls.GeneralContent + "txtdatEnteredDate");
            private static By readOnlyOfficer = By.Id(CommonCtrls.GeneralContent + "txtstrOfficer");
            private static By readOnlySite = By.Id(CommonCtrls.GeneralContent + "txtstrSite");

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
                    else if (Driver.Instance.FindElements(sessInfoFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(sessInfoFormTitle).Text.Contains("Session Information") &&
                                Driver.Instance.FindElement(sessInfoFormTitle).Displayed)
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

            public static void enterSessionStatus(string value)
            {
                SetMethods.enterObjectValue(ddlSessStatus, value);
            }

            public static String getSessionStatus()
            {
                Driver.Wait(TimeSpan.FromMinutes(1000));
                IWebElement dropDown = Driver.Instance.FindElement(By.Id(CommonCtrls.GeneralContent + "ddlidfsMonitoringSessionStatus"));
                SelectElement selectedVal = new SelectElement(dropDown);
                var element2 = selectedVal.SelectedOption.Text;
                Driver.Wait(TimeSpan.FromMinutes(1000));
                return sessionStatus = element2;
            }

            public static void enterSessionStartDate()
            {
                SetMethods.enterCurrentDate(datSessStartDate);
            }

            public static String getDateEnteredDate()
            {
                var element = Driver.Instance.FindElement(readOnlyDateEntered).GetAttribute("value");
                Driver.Wait(TimeSpan.FromMinutes(20));
                return enteredDate = element.ToString();
            }


            public static void enterFutureSessionEndDate(int value)
            {
                SetMethods.enterFutureDate(datSessEndDate, value);
            }

            public static void randomSelectDisease()
            {
                SetMethods.randomSelectObjectElement(ddlDisease, diseaseOpts);
            }


            public static String getPopupSessionID()
            {
                var sessionID = Driver.Instance.FindElement(txtSessionSuccessMsg).Text;
                Driver.Wait(TimeSpan.FromMinutes(20));
                return sessionIdNo = sessionID.Substring(sessionID.Length - 15).TrimEnd('.');
            }

            private static void getElementValue(By element, string val)
            {
                var ID = Driver.Instance.FindElement(element).GetAttribute("value");
                Driver.Wait(TimeSpan.FromMinutes(20));
                val = ID.ToString();
            }

            public static void getSessionRecordID()
            {
                var ID = Driver.Instance.FindElement(txtSessionIDNum).GetAttribute("value");
                Driver.Wait(TimeSpan.FromMinutes(20));
                sessionRecordNo = ID.ToString();
            }

            public static void getSessionCampaignID()
            {
                var ID = Driver.Instance.FindElement(readOnlyCampaignID).GetAttribute("value");
                Driver.Wait(TimeSpan.FromMinutes(20));
                campaignRecordNo = ID.ToString();
            }

            public static String getSessionDisease()
            {
                Driver.Wait(TimeSpan.FromMinutes(1000));
                IWebElement dropDown = Driver.Instance.FindElement(ddlDisease);
                SelectElement selectedVal = new SelectElement(dropDown);
                var element2 = selectedVal.SelectedOption.Text;
                Driver.Wait(TimeSpan.FromMinutes(1000));
                return diagnosisName = element2;
            }
        }

        public class SessionLocation
        {
            private static By sessLocFormTitle = By.XPath("//*[contains(text(), 'Session Location')]");
            private static By ddlRegion = By.Id(CommonCtrls.SrchSessionLocContent + "ddlsLIidfsRegion");
            private static IList<IWebElement> regionOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SrchSessionLocContent + "ddlsLIidfsRegion']/option")); } }
            private static By ddlRayon = By.Id(CommonCtrls.SrchSessionLocContent + "ddlsLIidfsRayon");
            private static IList<IWebElement> rayonOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SrchSessionLocContent + "ddlsLIidfsRayon']/option")); } }
            private static By ddlTownOrVillage = By.Id(CommonCtrls.SrchSessionLocContent + "ddlsLIidfsSettlement");
            private static IList<IWebElement> townOrVillageOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SrchSessionLocContent + "ddlsLIidfsSettlement']/option")); } }

            private static By ddlCountry = By.Id(CommonCtrls.SrchSessionLocContent + "ddlsLIidfsCountry");
            private static IList<IWebElement> countryOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.SrchSessionLocContent + "ddlsLIidfsCountry']/option")); } }

            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(sessLocFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(sessLocFormTitle).Text.Contains("Session Location") &&
                                Driver.Instance.FindElement(sessLocFormTitle).Displayed)
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

            public static void randomSelectCountry()
            {
                SetMethods.randomSelectObjectElement(ddlCountry, countryOpts);
            }

            public static void enterCountry(string value)
            {
                //Scroll to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1200)", "");
                SetMethods.enterObjectValue(ddlCountry, value);
            }

            public static void randomSelectRegion()
            {
                //Scroll to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1200)", "");
                SetMethods.randomSelectObjectElement(ddlRegion, regionOpts);
            }

            public static String getSessionRegion()
            {
                Driver.Wait(TimeSpan.FromMinutes(1000));
                IWebElement dropDown = Driver.Instance.FindElement(ddlRegion);
                SelectElement selectedVal = new SelectElement(dropDown);
                var element2 = selectedVal.SelectedOption.Text;
                Driver.Wait(TimeSpan.FromMinutes(1000));
                return regionName = element2;
            }

            public static void enterRegion(string value)
            {
                //Scroll to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1200)", "");
                SetMethods.enterObjectValue(ddlRegion, value);
            }

            public static void randomSelectRayon()
            {
                SetMethods.randomSelectObjectElement(ddlRayon, rayonOpts);
            }

            public static void enterRayon(string value)
            {
                SetMethods.enterObjectValue(ddlRayon, value);
            }

            public static String getSessionRayon()
            {
                Driver.Wait(TimeSpan.FromMinutes(1000));
                IWebElement dropDown = Driver.Instance.FindElement(ddlRayon);
                SelectElement selectedVal = new SelectElement(dropDown);
                var element2 = selectedVal.SelectedOption.Text;
                Driver.Wait(TimeSpan.FromMinutes(1000));
                return rayonName = element2;
            }

            public static void randomSelectSettlement()
            {
                SetMethods.randomSelectObjectElement(ddlTownOrVillage, townOrVillageOpts);
            }
        }

        public class SampleTypes
        {
            private static By sampleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "sessionInformation']/div[3]/div[1]/div/h3");
            private static By ddlSample = By.Id(CommonCtrls.GeneralContent + "ddlidfsSample");
            private static IList<IWebElement> sampleOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsSample']/option")); } }
            private static By btnAddSamples = By.Id(CommonCtrls.GeneralContent + "btnAddSamples");

            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
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
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(sampleFormTitle).Text.Contains("Sample Types") &&
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

            public static void randomSelectSample()
            {
                SetMethods.randomSelectObjectElement(ddlSample, sampleOpts);
            }

            public static void clickAddSample()
            {
                SetMethods.clickObjectButtons(btnAddSamples);
            }
        }

        public class PersonAndSamples
        {
            private static By personSampleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "personsAndSamples']/div/div[1]/div/div[1]/h3");
            private static By ddlSample = By.Id(CommonCtrls.GeneralContent + "ddlidfsSample");
            private static IList<IWebElement> sampleOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsSample']/option")); } }
            private static By btnAddSamples = By.Id(CommonCtrls.GeneralContent + "btnAddSamples");

            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    //Scroll to the bottom of the page
                    //((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(personSampleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(personSampleFormTitle).Text.Contains("Persons & Samples") &&
                                Driver.Instance.FindElement(personSampleFormTitle).Displayed)
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

        public class Actions
        {
            private static By actionsFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "actionsHdg']");
            private static By tlbActionsTable = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvActions']/tbody");
            private static By btnCreateActions = By.Id(CommonCtrls.GeneralContent + "btnCreateActions");
            private static By btnAddNewActions = By.Id(CommonCtrls.GeneralContent + "btnNewAction");
            private static By rdoActionEntriesYes = By.Id(CommonCtrls.GeneralContent + "rdbActionEntriesYes");
            private static By rdoActionEntriesNo = By.Id(CommonCtrls.GeneralContent + "rdbActionEntriesNo");
            private static By rdoActionEntriesUnk = By.Id(CommonCtrls.GeneralContent + "rdbActionEntriesUnknown");
            private static By ddlActionType = By.Id(CommonCtrls.GeneralContent + "ddlidfsActionType");
            private static IList<IWebElement> actTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsActionType']/option")); } }
            private static By datDateOfAction = By.Id(CommonCtrls.GeneralContent + "txtdatActionDate");
            private static By ddlEnteredBy = By.Id(CommonCtrls.GeneralContent + "ddlidfsEnteredBy");
            private static IList<IWebElement> enteredByOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsEnteredBy']/option")); } }
            private static By ddlStatus = By.Id(CommonCtrls.GeneralContent + "ddlidfsActionStatus");
            private static IList<IWebElement> statusOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsActionStatus']/option")); } }
            private static By txtComments = By.Id(CommonCtrls.GeneralContent + "txtstrComments");
            private static String longCommentString = "jljjououaofuoufouaoufoiaofjnlznkznknfnnfanfaf08097975927491710810890418jfajflaflanflaknf,anf,mjflkjaljfj0808080&$^#@%#$$%&^*&(ljljljfljlsjfljowuoqu7r97(^%%$&lnlnalfnlanflalkfkjalfjlahlaljflajfljfjolau&(&(&9796827972959775972597275927927597927592597797579";
            private static string txtDateOfActionErrorMsg = "";

            public static bool IsAt
            {
                get
                {
                    //Scroll to the bottom of the page
                    //((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(actionsFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(actionsFormTitle).Text.Contains("Actions") &&
                                Driver.Instance.FindElement(actionsFormTitle).Displayed)
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

            public static void clickCreateNewEntry()
            {
                SetMethods.clickObjectButtons(btnCreateActions);
            }

            public static void clickAddNewEntry()
            {
                SetMethods.clickObjectButtons(btnAddNewActions);
            }

            public static void clickActionEntriesYes()
            {
                SetMethods.clickObjectButtons(rdoActionEntriesYes);
            }

            public static void clickActionEntriesNo()
            {
                SetMethods.clickObjectButtons(rdoActionEntriesNo);
            }

            public static void clickActionEntriesUnk()
            {
                SetMethods.clickObjectButtons(rdoActionEntriesUnk);
            }

            public static void randomSelectActionReq()
            {
                SetMethods.randomSelectObjectElement(ddlActionType, actTypeOpts);
            }

            public static void enterPastDateOfAction(int value)
            {
                SetMethods.enterPastDate(datDateOfAction, value);
            }

            public static void enterFutureDateOfAction(int value)
            {
                SetMethods.enterFutureDate(datDateOfAction, value);
            }

            public static void enterDateOfAction()
            {
                SetMethods.enterCurrentDate(datDateOfAction);
            }

            public static void randomSelectEnteredBy()
            {
                SetMethods.randomSelectObjectElement(ddlEnteredBy, enteredByOpts);
            }

            public static void enterStatus(string value)
            {
                SetMethods.enterObjectValue(ddlStatus, value);
            }

            public static void enterComments()
            {
                SetMethods.enterObjectValue(txtComments, longCommentString);
            }

            public static void getTableRowCountBefore()
            {
                SetMethods.GetNumberOfRowsInTableBefore(tlbActionsTable);
            }

            public static void getTableRowCountAfter()
            {
                SetMethods.GetNumberOfRowsInTableAfter(tlbActionsTable);
            }

            public static void doesDateOfActionErrorMsgDisplay()
            {
                //SetMethods.doesValidationErrorMessageDisplay();
            }
        }

        public class DiseaseReport
        {
            private static By actionsFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "diseaseReport']/div/div[1]/div/div[1]/h3");

            public static bool IsAt
            {
                get
                {
                    //Scroll to the bottom of the page
                    //((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(actionsFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(actionsFormTitle).Text.Contains("Disease Reports") &&
                                Driver.Instance.FindElement(actionsFormTitle).Displayed)
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

        public class Tests
        {
            private static By actionsFormTitle = By.XPath("//*[contains(text(), 'Tests')]");

            public static bool IsAt
            {
                get
                {
                    //Scroll to the bottom of the page
                    //((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(actionsFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(actionsFormTitle).Text.Contains("Tests") &&
                                Driver.Instance.FindElement(actionsFormTitle).Displayed)
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