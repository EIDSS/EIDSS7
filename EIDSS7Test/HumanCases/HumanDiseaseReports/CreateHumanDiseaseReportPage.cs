using System;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Collections.Generic;
using System.Threading;
using OpenQA.Selenium.Support.UI;

namespace EIDSS7Test.HumanCases.HumanDiseaseReports
{
    public class CreateHumanDiseaseReportPage
    {
        private static By HeaderFormTitle = By.TagName("h1");
        private static By titleFormTitle = By.TagName("h2");
        private static Random rnd = new Random();
        private static By srchParmsFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "parametersHeading']");
        private static By btnReturnToPerson = By.Id(CommonCtrls.GeneralContent + " btn_Return_to_Person_Record");
        private static By btnReturnToSearch = By.Id(CommonCtrls.GeneralContent + " btnReturnToSearch");
        private static By btnReturnToPrevious = By.Id(CommonCtrls.GeneralContent + " btnPreviousSection");
        private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmit");
        private static By btnNextSection = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "btnNextSection']");
        private static By linkContactList = By.LinkText("Contact List");
        private static By linkNotification = By.LinkText("Disease Notification");
        private static By linkSymptoms = By.LinkText("Symptoms");
        private static By linkFacilityDetails = By.LinkText("Facility Details");
        private static By linkAnibioticVaccine = By.LinkText("Antibiotic/Vaccine History");
        private static By linkSamples = By.LinkText("Samples");
        private static By linkTests = By.LinkText("Tests");
        private static By linkCaseInvest = By.LinkText("Case Investigation");
        private static By linkRiskFactors = By.LinkText("Risk Factors");
        private static By linkFinalOutcome = By.LinkText("Final Outcome");
        private static By linkReview = By.LinkText("Review");
        private static By sideBarFailMark = By.ClassName("glyphicon glyphicon-remove failcheckmark");
        private static By txtSaveDiseaseRptSuccessMsg = By.Id(CommonCtrls.GeneralContent + "lblSuccessSave");
        private static By btnPopupOK = By.Id(CommonCtrls.GeneralContent + "btnSuccessSave");
        public static String longCommentString = "jljjououaofuoufouaoufoiaofjnlznkznknfnnfanfaf08097975927491710810890418jfajflaflanflaknf,anf,mjflkjaljfj0808080&$^#@%#$$%&^*&(ljljljfljlsjfljowuoqu7r97(^%%$&lnlnalfnlanflalkfkjalfjlahlaljflajfljfjolau&(&(&9796827972959775972597275927927597927592597797579";
        public static string[] antibiotics = new string[] { "amoxicillin", "doxycycline", "cephalexin", "metronidazole", "Augmentin", "Amoxil", "Zithromax", "Cipro", "Avelox" };
        public static string[] vaccinations = new string[] { "DT", "DTaP", "Td", "Tdap", "GamaSTAN® S/D Immune Globulin", "Pneumococcal conjugate", "Pneumococcal polysaccharide", "Menactra", "Trumenba" };
        public static string[] dosage = new string[] { "200 mg", "125 mg", "250 mg", "500 mg", "125 mg/5 mL", "400 mg/5 mL", "775 mg", "600 mg", "250 mg/5 mL" };
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));
        public static String DateOfNotError;
        public static String DateOfDiseaseError;
        public static String DateOfSympOnsetError;
        public static String DateAntiFirstAdministered;
        public static String GetStringValue;
        public static string diseaseCaseID;

        public static bool IsAt
        {
            get
            {
                try
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
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Human Disease Report") &&
                                Driver.Instance.FindElement(titleFormTitle).Displayed)
                                return true;
                            else
                                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                            return false;
                        }
                    }
                    else if (Driver.Instance.FindElement(HeaderFormTitle).Displayed ||
                        Driver.Instance.FindElement(HeaderFormTitle).Text.Contains("This page isn't working"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
                    }
                    else
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
                    }
                }
                catch (NoSuchElementException e)
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                    return false;
                }
            }
        }

        public static void clickCancel()
        {
            SetMethods.clickObjectButtons(btnReturnToPerson);
        }

        public static void clickReturnToSearch()
        {
            SetMethods.clickObjectButtons(btnReturnToSearch);
        }

        public static void clickPrevious()
        {
            SetMethods.clickObjectButtons(btnReturnToPrevious);
        }

        public static void clickNotificationTab()
        {
            SetMethods.clickObjectButtons(linkNotification);
        }

        public static void clickSymptomsTab()
        {
            SetMethods.clickObjectButtons(linkSymptoms);
        }

        public static void clickFacilityDetailsTab()
        {
            SetMethods.clickObjectButtons(linkFacilityDetails);
        }

        public static void clickAntibioticVaccineHistTab()
        {
            SetMethods.clickObjectButtons(linkAnibioticVaccine);
        }

        public static void clickSamplesTab()
        {
            SetMethods.clickObjectButtons(linkSamples);
        }

        public static void clickTestsTab()
        {
            SetMethods.clickObjectButtons(linkTests);
        }

        public static void clickCaseInvestigationTab()
        {
            SetMethods.clickObjectButtons(linkCaseInvest);
        }

        public static void clickRiskFactorsTab()
        {
            SetMethods.clickObjectButtons(linkRiskFactors);
        }

        public static void clickFinalOutcomeTab()
        {
            SetMethods.clickObjectButtons(linkFinalOutcome);
        }

        public static void clickContactListTab()
        {
            SetMethods.clickObjectButtons(linkContactList);
        }

        public static void clickPopupOK()
        {
            SetMethods.clickObjectButtons(btnPopupOK);
        }

        public static void clickSubmit()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            SetMethods.clickObjectButtons(btnSubmit);
        }

        public static void clickReviewTab()
        {
            SetMethods.clickObjectButtons(linkReview);
        }

        public static void clickNext()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            SetMethods.clickObjectButtons(btnNextSection);
        }

        public static void clickNextToFacilityDetailsTab()
        {
            for (int i = 0; i <= 1; i++)
            {
                SetMethods.clickObjectButtons(btnNextSection);
            }
        }

        public static void clickNextToAntibioticVaccineTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 2; i++)
            {
                SetMethods.clickObjectButtons(btnNextSection);
            }
        }

        public static void clickNextToSamplesTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 3; i++)
            {
                SetMethods.clickObjectButtons(btnNextSection);
            }
        }

        public static void clickNextToTestsTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 4; i++)
            {
                SetMethods.clickObjectButtons(btnNextSection);
            }
        }

        public static void clickNextToCaseInvestigationTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 5; i++)
            {
                SetMethods.clickObjectButtons(btnNextSection);
            }
        }

        public static void clickNextToRiskFactorsTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 6; i++)
            {
                SetMethods.clickObjectButtons(btnNextSection);
            }
        }

        public static void clickNextToFinalOutcomeTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 8; i++)
            {
                SetMethods.clickObjectButtons(btnNextSection);
            }
        }

        public static void clickNextToContactListTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 7; i++)
            {
                SetMethods.clickObjectButtons(btnNextSection);
            }
        }

        public static bool doesRedCheckMarkDisplay(By element)
        {
            try
            {
                Driver.Instance.FindElement(element);
                return true;
            }
            catch
            {
                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail();
                return false;
            }
        }

        public static void doesDiseaseRptSuccessPopupMessageDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(txtSaveDiseaseRptSuccessMsg);
        }

        public static String getPopupCaseID()
        {
            var ID = Driver.Instance.FindElement(txtSaveDiseaseRptSuccessMsg).Text;
            Driver.Wait(TimeSpan.FromMinutes(20));
            return diseaseCaseID = ID.Substring(ID.Length - 15).TrimEnd('.');
        }

        public class DiseaseReportSummary
        {
            private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "disease']/div[1]/div/div/div[1]/h3");
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
                    else if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Error:"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Disease Report Summary") &&
                                Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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

        public class DiseaseNotification
        {
            private static By subtitleFormTitle = By.XPath("//*[contains(text(), 'Disease Notification')]");
            private static By ddlDiagnosis = By.Id(CommonCtrls.GeneralContent + "ddlidfsFinalDiagnosis");
            private static IList<IWebElement> diagnosisOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsFinalDiagnosis']/option")); } }
            private static By txtDateOfDiagnosis = By.Id(CommonCtrls.GeneralContent + "txtdatDateOfDiagnosis");
            private static By txtDateOfNotification = By.Id(CommonCtrls.GeneralContent + "txtdatNotificationDate");
            private static By ddlStatusOfPatient = By.Id(CommonCtrls.GeneralContent + "ddlidfsFinalState");
            private static IList<IWebElement> patientStatOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsFinalState']/option")); } }
            private static By txtNotifySentBy = By.Id(CommonCtrls.GeneralContent + "txtstrNotificationSentby");
            private static By txtNotifyReceivedBy = By.Id(CommonCtrls.GeneralContent + "txtstrNotificationReceivedby");
            private static By ddlCurrentLocOfPerson = By.Id(CommonCtrls.GeneralContent + "ddlidfsHospitalizationStatus");
            private static IList<IWebElement> currentLocOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsHospitalizationStatus']/option")); } }
            private static By btnSearchNotififySentBy = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "diseaseNotification']/div[2]/div[5]/div/div/div/div/input");
            private static By btnSearchNotififyReceivedBy = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "diseaseNotification']/div[2]/div[6]/div/div/div/div/input");
            private static By sideBarFailMark = By.ClassName("glyphicon glyphicon-remove failcheckmark");
            private static By DateOfNotifyError = By.Id(CommonCtrls.GeneralContent + "ctl40");
            private static By DateOfDiseaseError = By.Id(CommonCtrls.GeneralContent + "CustomValidator3DateOrderDiagDate");
            public static String DateOfDiseaseErrorMsg = "Must be after Symptom Onset and before Notification dates, inclusive, if present.";
            public static String DateOfNotificationErrorMsg = "Must be on or after Symptom Onset and Disease dates, if present.";

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
                    else if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Error:"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Disease Notification") &&
                                Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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

            public static void enterDiagnosis(String value)
            {
                SetMethods.enterObjectValue(ddlDiagnosis, value);
            }

            public static void randomSelectDiagnosis()
            {
                SetMethods.randomSelectObjectElement(ddlDiagnosis, diagnosisOpts);
                Thread.Sleep(5000);
            }

            public static void enterDateOfDisease()
            {
                SetMethods.enterDateBack7Days(txtDateOfDiagnosis);
            }

            public static void enterDateOfDisease(int value)
            {
                SetMethods.enterPastDate(txtDateOfDiagnosis, value);
            }

            public static void enterFutureDateOfDisease(int value)
            {
                SetMethods.enterFutureDate(txtDateOfDiagnosis, value);
            }

            public static void enterDateOfNotification()
            {
                SetMethods.enterCurrentDate(txtDateOfNotification);
            }

            public static void enterOtherDateOfNotification(int value)
            {
                SetMethods.enterPastDate(txtDateOfNotification, value);
            }

            public static void enterFutureDateOfNotification(int value)
            {
                SetMethods.enterFutureDate(txtDateOfNotification, value);
            }

            public static void randomSelectStatusOfPerson()
            {
                SetMethods.randomSelectObjectElement(ddlStatusOfPatient, patientStatOpts);
            }

            public static void randomSelectCurrentLocOfPerson()
            {
                SetMethods.randomSelectObjectElement(ddlCurrentLocOfPerson, currentLocOpts);
            }

            public static void enterStatusOfPerson(String value)
            {
                SetMethods.enterStringObjectValue(ddlStatusOfPatient, value);
            }

            public static void enterCurrentLocOfPerson(String value)
            {
                SetMethods.enterStringObjectValue(ddlCurrentLocOfPerson, value);
            }

            public static void clickSearchNotifySentBy()
            {
                SetMethods.clickObjectButtons(btnSearchNotififySentBy);
            }

            public static void clickSearchNotifyReceivedBy()
            {
                SetMethods.clickObjectButtons(btnSearchNotififyReceivedBy);
            }

            public static void doesRedCheckMarkDisplayOnNotification()
            {
                doesRedCheckMarkDisplay(sideBarFailMark);
            }

            public static void doesDateOfNotificationErrorMessageDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(DateOfNotifyError);
            }

            public static void doesDateOfDiseaseErrorMessageDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(DateOfDiseaseError);
            }
        }

        public class ClinicalInformation
        {
            public class Symptoms
            {
                private static By subtitleFormTitle = By.XPath("//*[contains(text(), 'Clinical Information: Symptoms')]");
                private static By txtDateOfSympOnset = By.Id(CommonCtrls.GeneralContent + "txtdatOnSetDate");
                private static By ddlInitialCaseClass = By.Id(CommonCtrls.GeneralContent + "ddlidfsInitialCaseStatus");
                private static IList<IWebElement> initCaseClassOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsInitialCaseStatus']/option")); } }
                private static By DateOfSymptomsOnsetError = By.Id(CommonCtrls.GeneralContent + "CustomValidator3DateOrderSymptOnset");
                public static String DateOfSymptOnsetErrorMsg = "Must be after Symptom Onset, and before or equal to current date, if present, and not in the future.";
                public static String FutureDateOfSymptOnsetErrorMsg = "Must be on or before Disease and Notification dates, if present.";


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
                        else if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Error:"))
                        {
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                            return false;
                        }
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Clinical Information: Symptoms") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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

                public static void enterDateOfSymptomOnset(int value)
                {
                    SetMethods.enterPastDate(txtDateOfSympOnset, value);
                }

                public static void enterFutureDateOfSymptomsOnset(int value)
                {
                    SetMethods.enterFutureDate(txtDateOfSympOnset, value);
                }

                public static void randomSelectInitialCaseClassification()
                {
                    SetMethods.randomSelectObjectElement(ddlInitialCaseClass, initCaseClassOpts);
                }

                public static void enterInitialCaseClassification(String value)
                {
                    SetMethods.enterObjectValue(ddlInitialCaseClass, value);
                }

                public static void doesRedCheckMarkDisplayOnSymptoms()
                {
                    doesRedCheckMarkDisplay(sideBarFailMark);
                }

                public static void doesDateOfSymptomOnsetErrorMessageDisplay()
                {
                    SetMethods.doesValidationErrorMessageDisplay(DateOfSymptomsOnsetError);
                }
            }

            public class FacilityDetails
            {
                private static By subtitleFormTitle = By.XPath("//*[contains(text(), 'Clinical Information: Facility Details')]");
                private static By rdoDatePersonSoughtCareYes = By.Id(CommonCtrls.GeneralContent + "rblidfsYNPreviouslySoughtCare_0");
                private static By rdoDatePersonSoughtCareNo = By.Id(CommonCtrls.GeneralContent + "rblidfsYNPreviouslySoughtCare_1");
                private static By rdoDatePersonSoughtCareUnk = By.Id(CommonCtrls.GeneralContent + "rblidfsYNPreviouslySoughtCare_2");
                private static By datDatePersonSoughtCare = By.Id(CommonCtrls.GeneralContent + "txtdatFirstSoughtCareDate");
                private static By txtFacilityFirstSoughtCare = By.Id(CommonCtrls.GeneralContent + "txtFacilityFirstSoughtCare");
                private static By btnFacilityPersonFirstSoughtCare = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "pnlPatientPreviouslySought']/div/div/div[2]/div/div/span");
                private static By ddlNotifiableDisease = By.Id(CommonCtrls.GeneralContent + "ddlidfsNonNotifiableDiagnosis");
                private static IList<IWebElement> notifiableDiseaseOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsNonNotifiableDiagnosis']/option")); } }
                private static By rdoHospitalizationYes = By.Id(CommonCtrls.GeneralContent + "rblidfsYNHospitalization_0");
                private static By rdoHospitalizationNo = By.Id(CommonCtrls.GeneralContent + "rblidfsYNHospitalization_1");
                private static By rdoHospitalizationUnk = By.Id(CommonCtrls.GeneralContent + "rblidfsYNHospitalization_2");
                private static By datDateOfHospitalization = By.Id(CommonCtrls.GeneralContent + "txtdatHospitalizationDate");
                private static By datDateOfDischarge = By.Id(CommonCtrls.GeneralContent + "txtdatDischargeDate");
                private static By ddlHospitalName = By.Id(CommonCtrls.GeneralContent + "ddlidfFaciltyHospital");
                private static IList<IWebElement> hospitalNameOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfFaciltyHospital']/option")); } }
                private static By DatePersonSoughtCareError = By.Id(CommonCtrls.GeneralContent + "CustomValidator_txtdatFirstSoughtCareDate");
                private static By DateOfHospitalizationError = By.Id(CommonCtrls.GeneralContent + "CustomValidator_txtdatHospitalizationDate");
                private static By DateOfDischargeError = By.Id(CommonCtrls.GeneralContent + "CustomValidator_txtdatDischargeDate");
                public static String DateOfDischargeErrorMsg = "Must be on or after Date of Hospitalization, if present, and not in the future.";
                public static String DateOfHospitalizationErrorMsg = "Must be after Symptom Onset, and before or equal to current date, if present, and not in the future.";
                public static String DatePersonFirstSoughtCareErrorMsg = "Must be after Symptom Onset, and before or equal to current date, if present, and not in the future.";


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
                        else if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Error:"))
                        {
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                            return false;
                        }
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Clinical Information: Facility Details") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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

                public static void clickPatientSoughtCareYes()
                {
                    SetMethods.clickObjectButtons(rdoDatePersonSoughtCareYes);
                }

                public static void clickPatientSoughtCareNo()
                {
                    SetMethods.clickObjectButtons(rdoDatePersonSoughtCareNo);
                }

                public static void clickPatientSoughtCareUnknown()
                {
                    SetMethods.clickObjectButtons(rdoDatePersonSoughtCareUnk);
                }

                public static void enterDatePersonFirstSoughtCare(int value)
                {
                    SetMethods.enterPastDate(datDatePersonSoughtCare, value);
                }

                public static void clickSearchFacilityPersonFirstSoughtCare()
                {
                    SetMethods.clickObjectButtons(btnFacilityPersonFirstSoughtCare);
                }

                public static void doesDatePersonSoughtCarerrorMessageDisplay()
                {
                    SetMethods.doesValidationErrorMessageDisplay(DatePersonSoughtCareError);
                }

                public static void isFacilityPersonSoughtCareFieldPopulated()
                {
                    SetMethods.isFieldPopulated(txtFacilityFirstSoughtCare);
                }

                public static void isNotifiableDiseaseFieldPopulated()
                {
                    SetMethods.isFieldPopulated(ddlNotifiableDisease);
                }

                public static void isDateOfHospitalizationFieldPopulated()
                {
                    SetMethods.isFieldPopulated(datDateOfHospitalization);
                }

                public static void isDateOfDischargeFieldPopulated()
                {
                    SetMethods.isFieldPopulated(datDateOfDischarge);
                }

                public static void enterNonNotifiableDisease(String value)
                {
                    SetMethods.enterObjectValue(ddlNotifiableDisease, value);
                }

                public static void randomSelectNotifiableDisease()
                {
                    SetMethods.randomSelectObjectElement(ddlNotifiableDisease, notifiableDiseaseOptions);
                }

                public static void clickHospitalizationYes()
                {
                    SetMethods.clickObjectButtons(rdoHospitalizationYes);
                }

                public static void clickHospitalizationNo()
                {
                    SetMethods.clickObjectButtons(rdoHospitalizationNo);
                }

                public static void clickHospitalizationUnknown()
                {
                    SetMethods.clickObjectButtons(rdoHospitalizationUnk);
                }

                public static void enterDateOfHospitalization()
                {
                    SetMethods.enterCurrentDate(datDateOfHospitalization);
                }

                public static void enterDateOfDischarge()
                {
                    SetMethods.enterCurrentDate(datDateOfDischarge);
                }

                public static void enterPastDateOfHospitalization(int value)
                {
                    SetMethods.enterPastDate(datDateOfHospitalization, value);
                }

                public static void enterFutureDateOfHospitalization(int value)
                {
                    SetMethods.enterFutureDate(datDateOfHospitalization, value);
                }

                public static void doesDateOfHospitalizationErrorMessageDisplay()
                {
                    SetMethods.doesValidationErrorMessageDisplay(DateOfHospitalizationError);
                }

                public static void enterPastDateOfDischarge(int value)
                {
                    SetMethods.enterPastDate(datDateOfDischarge, value);
                }

                public static void enterFutureDateOfDischarge(int value)
                {
                    SetMethods.enterFutureDate(datDateOfDischarge, value);
                }

                public static void doesDateOfDischargeErrorMessageDisplay()
                {
                    SetMethods.doesValidationErrorMessageDisplay(DateOfDischargeError);
                }

            }

            public class Antibiotics
            {
                private static By subtitleFormTitle = By.XPath("//*[contains(text(), 'Clinical Information: Antibiotics')]");
                private static By rdoAntibioticAntiViralYes = By.Id(CommonCtrls.GeneralContent + "rdbAntibioticAntiviralTherapyAdministeredYes");
                private static By rdoAntibioticAntiViralNo = By.Id(CommonCtrls.GeneralContent + "rdbAntibioticAntiviralTherapyAdministeredNo");
                private static By rdoAntibioticAntiViralUnk = By.Id(CommonCtrls.GeneralContent + "rdbAntibioticAntiviralTherapyAdministeredUnknown");
                private static By txtAntibioticName = By.Id(CommonCtrls.GeneralContent + "txtstrAntibioticName");
                private static By txtDosage = By.Id(CommonCtrls.GeneralContent + "txtstrDosage");
                private static By datFirstAdminDate = By.Id(CommonCtrls.GeneralContent + "txdatFirstAdministeredDate");
                private static By txtAntibioticComments = By.Id(CommonCtrls.GeneralContent + "txtstrAntibioticComments");
                private static By ddlUnitOfMeasure = By.Id(CommonCtrls.GeneralContent + "ddlidfsDoseMeasurements");
                private static IList<IWebElement> dosageOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsDoseMeasurements']/option")); } }

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
                        else if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Error:"))
                        {
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                            return false;
                        }
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Clinical Information: Antibiotics") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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

                //public static Boolean isAntimicrobialTherapyGridEnabled()
                //{
                //    try
                //    {
                //        txtAntibioticName.GetAttribute("enabled");
                //        return true;
                //    }
                //    catch (Exception)
                //    {
                //        Console.WriteLine("Field is not enabled");
                //        return false;
                //    }
                //}

                //public static Boolean isAntimicrobialTherapyGridDisabled()
                //{
                //    try
                //    {
                //        txtAntimicrobialTherapyName.GetAttribute("disabled");
                //        return true;
                //    }
                //    catch (Exception)
                //    {
                //        Console.WriteLine("Field is not disabled");
                //        return false;
                //    }
                //}

                public static void clickAntiAntiviralAdministeredYes()
                {
                    SetMethods.clickObjectButtons(rdoAntibioticAntiViralYes);
                }

                public static void clickAntiAntiviralAdministeredNo()
                {
                    SetMethods.clickObjectButtons(rdoAntibioticAntiViralNo);
                }

                public static void clickAntiAntiviralAdministeredUnknown()
                {
                    SetMethods.clickObjectButtons(rdoAntibioticAntiViralUnk);
                }

                public static void enterAntibacterialNameFromList()
                {
                    string meds = antibiotics[new Random().Next(0, antibiotics.Length)];
                    SetMethods.enterStringObjectValue(txtAntibioticName, meds);
                    GetStringValue = meds;
                }

                public static void enterAntibacterialDosageFromList()
                {
                    string dose = antibiotics[new Random().Next(0, dosage.Length)];
                    SetMethods.enterStringObjectValue(txtAntibioticName, dose);
                    GetStringValue = dose;
                }

                public static void randomSelectUnitOfMeasure()
                {
                    SetMethods.randomSelectObjectElement(ddlUnitOfMeasure, dosageOptions);
                }

                public static void enterDateFirstAdministered()
                {
                    SetMethods.enterCurrentDate(datFirstAdminDate);
                }

                public static void enterOtherDateFirstAdministered(int value)
                {
                    SetMethods.enterPastDate(datFirstAdminDate, value);
                }

                public static void enterComments()
                {
                    var text = wait.Until(ExpectedConditions.ElementToBeClickable(txtAntibioticComments));
                    text.EnterText(longCommentString);
                    Driver.Wait(TimeSpan.FromMinutes(5));
                    GetStringValue = longCommentString;
                }

                public static void isAntibioticNameFieldPopulated()
                {
                    SetMethods.isFieldPopulated(txtAntibioticName);
                }

                public static void isDoseFieldPopulated()
                {
                    SetMethods.isFieldPopulated(txtDosage);
                }

                public static void isUnitOfMeasureFieldPopulated()
                {
                    SetMethods.isFieldPopulated(ddlUnitOfMeasure);
                }

                public static void isDateAntiFirstAdministeredFieldPopulated()
                {
                    SetMethods.isFieldPopulated(datFirstAdminDate);
                }

                public static void isAntibioticCommentsFieldPopulated()
                {
                    SetMethods.isFieldPopulated(txtAntibioticComments);
                }
            }

            public class Vaccines
            {
                private static By subtitleFormTitle = By.XPath("//*[contains(text(), 'Clinical Information: Vaccines')]");
                private static By rdoSpecificVaccineYes = By.Id(CommonCtrls.GeneralContent + "rdbSpecificVaccinationYes");
                private static By rdoSpecificVaccineNo = By.Id(CommonCtrls.GeneralContent + "rdbSpecificVaccinationNo");
                private static By rdoSpecificVaccineUnk = By.Id(CommonCtrls.GeneralContent + "rdbSpecificVaccinationUnknown");
                private static By txtVaccineName = By.Id(CommonCtrls.GeneralContent + "txtVaccinationName");
                private static By datDateOfVaccine = By.Id(CommonCtrls.GeneralContent + "txtVaccinationDate");

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
                        else if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Error:"))
                        {
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                            return false;
                        }
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Clinical Information: Vaccines") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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

                public static void clickVaccineAdministeredYes()
                {
                    SetMethods.clickObjectButtons(rdoSpecificVaccineYes);
                }

                public static void clickVaccineAdministeredNo()
                {
                    SetMethods.clickObjectButtons(rdoSpecificVaccineNo);
                }

                public static void clickVaccineAdministeredUnknown()
                {
                    SetMethods.clickObjectButtons(rdoSpecificVaccineUnk);
                }

                public static void isVaccinationNameFieldPopulated()
                {
                    SetMethods.isFieldPopulated(txtVaccineName);
                }

                public static void isDateOfVaccinationFieldPopulated()
                {
                    SetMethods.isFieldPopulated(datDateOfVaccine);
                }


                public static void enterVaccinationNameFromList()
                {
                    string name = antibiotics[new Random().Next(0, vaccinations.Length)];
                    SetMethods.enterStringObjectValue(txtVaccineName, name);
                    GetStringValue = name;
                }

                public static void enterDateOfVaccination()
                {
                    SetMethods.enterCurrentDate(datDateOfVaccine);
                }
                public static void enterPastDateOfVaccination(int value)
                {
                    SetMethods.enterPastDate(datDateOfVaccine, value);
                }
            }

        }

        public class Samples
        {
            private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "samplesTab']/div/div[1]/div/div[1]/h4");
            private static By rdoSamplesCollectedYes = By.Id(CommonCtrls.GeneralContent + "rblidfsYNSpecimenCollected_0");
            private static By rdoSamplesCollectedNo = By.Id(CommonCtrls.GeneralContent + "rblidfsYNSpecimenCollected_1");
            private static By rdoSamplesCollectedUnk = By.Id(CommonCtrls.GeneralContent + "rblidfsYNSpecimenCollected_2");
            private static By btnAddSample = By.Id(CommonCtrls.GeneralContent + "btnSampleNewAdd");
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
                    else if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Error:"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Samples") &&
                                Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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
            public static void clickAddNewSample()
            {
                SetMethods.clickObjectButtons(btnAddSample);
            }

            public static void clickSamplesCollectedYes()
            {
                SetMethods.clickObjectButtons(rdoSamplesCollectedYes);
            }

            public static void clickSamplesCollectedNo()
            {
                SetMethods.clickObjectButtons(rdoSamplesCollectedNo);
            }

            public static void clickSamplesCollectedUnk()
            {
                SetMethods.clickObjectButtons(rdoSamplesCollectedUnk);
            }

            public static void isTheAddSamplesButtonEnabled()
            {
                SetMethods.isFieldEnabled(btnAddSample);
            }

            public static void isTheAddSamplesButtonDisabled()
            {
                SetMethods.isFieldDisabled(btnAddSample);
            }

            public class SampleDetail
            {
                private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "H1']");
                private static By ddlSampleType = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "masddlSampleType']");
                private static IList<IWebElement> sampleTypeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "masddlSampleType']/option")); } }
                private static By datDateCollected = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "masAddSampleDateCollected']");
                private static By txtLocalSampleID = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "masAddSampleLocalSampleId']");
                private static By datSentDate = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "masAddSampleDateSent']");
                private static By ddlSentToOrg = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlmasAddSampleSentTo']");
                private static IList<IWebElement> sentToOrgOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlmasAddSampleSentTo']/option")); } }
                private static By btnCloseSample = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "btnMasAddSampleClose']");
                private static By btnSaveSample = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "btnMasAddSampleSave']");
                private static By btnDeleteSample = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "btnMasAddSampleDelete']");
                public static String localSampleID;
                public static String dateCollected;
                public static String sampleType;
                public static String sentDate;
                public static String sentToOrg;


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
                        else if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Error:"))
                        {
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                            return false;
                        }
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Sample Detail") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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

                public static void clickSaveSample()
                {
                    SetMethods.clickObjectButtons(btnSaveSample);
                }

                public static void clickCloseSample()
                {
                    SetMethods.clickObjectButtons(btnCloseSample);
                }

                public static void clickDeleteSample()
                {
                    SetMethods.clickObjectButtons(btnDeleteSample);
                }

                public static void randomSelectSampleType()
                {
                    SetMethods.randomSelectObjectElement(ddlSampleType, sampleTypeOptions);
                }

                public static void enterDateCollected()
                {
                    SetMethods.enterCurrentDate(datDateCollected);
                }

                public static void enterLocalSampleID(string value)
                {
                    int rNum = rnd.Next(0, 100000);
                    value = value + rNum;
                    SetMethods.enterStringObjectValue(txtLocalSampleID, value)
;
                }

                public static void enterSentDate()
                {
                    SetMethods.enterCurrentDate(datSentDate);
                }

                public static void randomSelectSentToOrganization()
                {
                    SetMethods.randomSelectObjectElement(ddlSentToOrg, sentToOrgOptions);
                    Thread.Sleep(2000);
                }

                private static void getElementValue(By element, string val)
                {
                    var ID = Driver.Instance.FindElement(element).Text;
                    Driver.Wait(TimeSpan.FromMinutes(20));
                    val = ID.ToString();
                }

                public static void getLocalSampleID()
                {
                    getElementValue(txtLocalSampleID, localSampleID);
                }

                public static void getSampleType()
                {
                    getElementValue(ddlSampleType, sampleType);
                }

                public static void getDateCollected()
                {
                    getElementValue(datDateCollected, dateCollected);
                }

                public static void getSentDate()
                {
                    getElementValue(datSentDate, sentDate);
                }

                public static void getSentToOrg()
                {
                    getElementValue(ddlSentToOrg, sentToOrg);
                }
            }
        }

        public class Tests
        {
            private static By subtitleFormTitle = By.XPath("//*[contains(text(), 'Tests')]");
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
                    else if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Error:"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Tests") &&
                                Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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

        public class CaseInvestigation
        {
            public class Details
            {
                private static By subtitleFormTitle = By.XPath("//*[contains(text(), 'Case Investigation: Details')]");
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
                        else if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Error:"))
                        {
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                            return false;
                        }
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Case Investigation: Details") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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

            public class RiskFactors
            {
                private static By subtitleFormTitle = By.XPath("//*[contains(text(), 'Case Investigation: Risk Factors')]");
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
                        else if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Error:"))
                        {
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                            return false;
                        }
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Case Investigation: Risk Factors") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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

            public class FinalOutcome
            {
                private static By subtitleFormTitle = By.XPath("//*[contains(text(), 'Final Outcome')]");
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
                        else if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Error:"))
                        {
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                            return false;
                        }
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Final Outcome") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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

            public class ContactList
            {
                private static By subtitleFormTitle = By.XPath("//*[contains(text(), 'Case Investigation: Contact List')]");
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
                        else if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Error:"))
                        {
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                            return false;
                        }
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Case Investigation: Contact List") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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
}