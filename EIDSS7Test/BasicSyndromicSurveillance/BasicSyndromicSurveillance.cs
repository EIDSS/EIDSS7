using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;



namespace EIDSS7Test.BasicSyndromicSurveillance
{
    public class BasicSyndromicSurveillance
    {
        public static String firstName;
        //private static string address1;
        //private static string address2;
        //private static string postalcode;
        public static string errorString;
        public static string[] conditions = new string[] {"Respiratory System","Asthma","Diabetes","Cardiovascular","Obesity: BMI > 30, not evaluated",
                                                            "Renal","Liver","Neurological/Physiological","Immunodefiency","Unknown etiology"};
        public static List<String> medication = new List<String> { "amoxicillin", "doxycycline", "cephalexin", "metronidazole", "Augmentin", "Amoxil", "Zithromax", "Cipro", "Avelox" };
        public static Random rnd = new Random();


        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));
        private static By linkPersonalInfoTab = By.LinkText("Personal Information");
        private static By linkSymptomsTab = By.LinkText("Symptoms");
        private static By linkSamplesTab = By.LinkText("Samples");
        private static By linkReviewTab = By.LinkText("Review");
        private static By titleFormTitle = By.TagName("h2");
        private static By subSymptitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "symptomsSection']/div/div[1]/div/div[1]/h3");
        private static By subSampletitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "samplesSection']/div/div[1]/div/div[1]/h3");
        private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmit");
        private static By btnContinue = By.Id("btnNextSection");
        private static By btnCancel = By.Id("btnCancel");


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
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Basic Syndromic Surveillance") &&
                            Driver.Instance.FindElement(titleFormTitle).Displayed)
                            return true;
                        else
                            return false;
                    }
                }
                else
                {
                    return false;
                }
            }
        }


        public static string doesErrorAlertMessageDisplay()
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

        public static void acceptMessage()
        {
            IAlert alert = Driver.Instance.SwitchTo().Alert();
            alert.Accept();
        }

        public static void declineMessage()
        {
            IAlert alert = Driver.Instance.SwitchTo().Alert();
            alert.Dismiss();
        }

        public static void clickSubmit()
        {
            SetMethods.clickObjectButtons(btnSubmit);
        }

        public static void clickCancel()
        {
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clickContinue()
        {
            SetMethods.clickObjectButtons(btnContinue);
        }

        public static void clickReview()
        {
            SetMethods.clickObjectButtons(linkReviewTab);
        }

        public static void clickSymptoms()
        {
            SetMethods.clickObjectButtons(linkSymptomsTab);
        }

        public static void clickSamples()
        {
            SetMethods.clickObjectButtons(linkSamplesTab);
        }

        public static void clickPersonalInfo()
        {

            SetMethods.clickObjectButtons(linkPersonalInfoTab);
        }


        public class PersonalInfo
        {
            private static By titleFormSectionTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "personalInformationSection']/div/div[1]/div/div[1]/h3");
            private static By lblNotificationOf = By.Id("lblNotificationOf");
            private static By ddlNotificationOf = By.Id("ddlNotificationOf");
            private static IList<IWebElement> notOfOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlNotificationOf']/option")); } }
            private static By lblNameOfHospital = By.Id("lblNameOfHospital");
            private static By ddlNameOfHospital = By.Id("ddlNameOfHospital");
            private static IList<IWebElement> nameHospOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlNameOfHospital']/option")); } }
            private static By lblReportDate = By.Id("lblReportDate");
            private static By txtReportDate = By.Id("txtReportDate");
            private static By lblFirstName = By.Id("lblFirstName");
            private static By txtFirstName = By.Id("txtFirstName");
            private static By lblLastName = By.Id("lblLastName");
            private static By txtLastName = By.Id("txtLastName");
            private static By lblMiddleName = By.Id("lblMiddleName");
            private static By txtMiddleName = By.Id("txtMiddleName");
            private static By lblDateOfBirth = By.Id("lblDateofBirth");
            private static By txtDateOfBirth = By.Id("txtDateofBirth");
            private static By lblGender = By.Id("lblGender");
            private static By ddlGender = By.Id("ddlGender");
            private static By txtStreet = By.Id("txtStreet");
            private static By lblBuildingHouseApt = By.Name("Building");
            private static By txtBuilding = By.Id("txtStreet");
            private static By lblHouse = By.Name("House");
            private static By txtHouse = By.Id("txtHouse");
            private static By lblApt = By.Name("Apt");
            private static By txtApt = By.Id("txtApt");
            private static By lblPostalCode = By.Id("lblPostalCode");
            private static By ddlPostalCode = By.Id("ddlPostalCode");
            private static By lblPhone = By.Id("lblPhone");
            private static By txtPhone = By.Id("txtPhone");
            private static IList<IWebElement> genderOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlGender']/option")); } }
            private static By lblCountry = By.Id("lblCountry");
            private static By ddlCountry = By.Id("ddlCountry");
            private static IList<IWebElement> countryOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlCountry']/option")); } }
            private static By lblRegion = By.Id("lblRegion");
            private static By ddlRegion = By.Id("ddlRegion");
            private static IList<IWebElement> regionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlRegion']/option")); } }
            private static By lblRayon = By.Id("lblRayon");
            private static By ddlRayon = By.Id("ddlRayon");
            private static IList<IWebElement> rayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlRayon']/option")); } }
            private static By lblTownOrVillage = By.Id("lblTownOrVillage");
            private static By ddlTownOrVillage = By.Id("ddlTownOrVillage");
            private static IList<IWebElement> townVillageOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlTownOrVillage']/option")); } }
            private static By lblStreet = By.Name("Street Address");

            public static bool IsAt
            {
                get
                {
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(titleFormSectionTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(titleFormSectionTitle).Text.Contains("Personal Information") &&
                                Driver.Instance.FindElement(titleFormSectionTitle).Displayed)
                                return true;
                            else
                                return false;
                        }
                    }
                    else
                    {
                        return false;
                    }
                }
            }

            public static void randomSelectNotificationOf()
            {
                SetMethods.randomSelectObjectElement(ddlNotificationOf, notOfOptions);
            }

            public static void randomSelectHospital()
            {
                SetMethods.randomSelectObjectElement(ddlNameOfHospital, nameHospOptions);
            }

            public static void enterCurReportDate()
            {
                SetMethods.enterCurrentDate(txtReportDate);
            }
            public static void enterLastName()
            {
                SetMethods.enterObjectValue(txtLastName, firstName);
            }

            public static string enterFirstName(string FName)
            {
                int rNum = rnd.Next(1000, 100000000);
                firstName = FName + rNum;
                SetMethods.enterObjectValue(txtFirstName, firstName);
                return firstName;
            }

            public static void enterFirstMiddleName()
            {
                SetMethods.enterObjectValue(txtMiddleName, firstName);
            }

            public static void enterRandomDateOfBirth()
            {
                SetMethods.randomEnterDOB(txtDateOfBirth);
            }

            public static void enterGender(string genderSex)
            {
                SetMethods.enterObjectDropdownListValue(ddlGender, genderSex);
            }

            public static void enterRandomGender()
            {
                SetMethods.randomSelectObjectElement(ddlGender, genderOptions);
            }

            public static void randomSelectCountry()
            {
                SetMethods.randomSelectObjectElement(ddlCountry, countryOptions);
            }

            public static void randomSelectRegion()
            {
                SetMethods.randomSelectObjectElement(ddlRegion, regionOptions);
            }

            public static void randomSelectRayon()
            {
                SetMethods.randomSelectObjectElement(ddlRayon, rayonOptions);
            }

            public static void randomSelectTownOrVillage()
            {
                SetMethods.randomSelectObjectElement(ddlTownOrVillage, townVillageOptions);
            }

            public static void enterStreetAddress(string addr)
            {
                int rNum = rnd.Next(10000, 10000);
                Driver.Wait(TimeSpan.FromMinutes(5));
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(txtStreet));
                element.EnterText(addr + rNum);
                Driver.Wait(TimeSpan.FromMinutes(5));
            }

            public static void enterRandomPostalCode()
            {
                int rNum = rnd.Next(10000, 10000);
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(ddlPostalCode));
                element.EnterAmount(rNum);
                Driver.Wait(TimeSpan.FromMinutes(5));
            }

            public static void enterRandomPhoneNumber()
            {
                int rPhoneNum = rnd.Next(100000000, 999999999);
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(txtPhone));
                Driver.Wait(TimeSpan.FromMinutes(5));
                element.EnterText(String.Format("{0: (###) ###-####", rPhoneNum));
            }

        }

        public class Symptoms
        {
            private static By lblDateofSymptomOnset = By.Id("lblDateofSymptomOnset");
            private static By txtDateofSymptomOnset = By.Id("txtDateofSymptomOnset");
            private static By rdoPregnantYes = By.Id("pregnantYes");
            private static By rdoPregnantNo = By.Id("pregnantNo");
            private static By rdoPregnantUnknown = By.Id("pregnantUnknown");
            private static By rdoPostpartumYes = By.Id("postpartumYes");
            private static By rdoPostpartumNo = By.Id("postpartumNo");
            private static By rdoPostpartumUnknown = By.Id("postpartumUnknown");
            private static By rdoFever38Yes = By.Id("fever38Yes");
            private static By rdoFever38No = By.Id("fever38No");
            private static By rdoFever38Unknown = By.Id("fever38Unknown");
            private static By ddlMethodOfMeasurement = By.Id("ddlMethodofMeasurement");
            private static IList<IWebElement> measureOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlMethodofMeasurement']/option")); } }
            private static By txtOtherMethod = By.Id("txtOtherMethod");
            private static By rdoCoughYes = By.Id(CommonCtrls.GeneralContent + "coughYes");
            private static By rdoCoughNo = By.Id(CommonCtrls.GeneralContent + "coughNo");
            private static By rdoCoughUnknown = By.Id(CommonCtrls.GeneralContent + "coughUnknown");
            private static By rdoShortnessofBreathYes = By.Id(CommonCtrls.GeneralContent + "shortnessofBreathYes");
            private static By rdoShortnessofBreathNo = By.Id(CommonCtrls.GeneralContent + "shortnessofBreathNo");
            private static By rdoShortnessofBreathUnknown = By.Id(CommonCtrls.GeneralContent + "shortnessofBreathUnknown");
            private static By rdoSeasonalFluVaccineYes = By.Id(CommonCtrls.GeneralContent + "seasonalFluVaccineYes");
            private static By rdoSeasonalFluVaccineNo = By.Id(CommonCtrls.GeneralContent + "seasonalFluVaccineNo");
            private static By rdoSeasonalFluVaccineUnknown = By.Id(CommonCtrls.GeneralContent + "seasonalFluVaccineUnknown");
            private static By rdoAntiviralMedicationYes = By.Id("antiviralMedicationYes");
            private static By rdoAntiviralMedicationNo = By.Id("antiviralMedicationNo");
            private static By rdoAntiviralMedicationUnknown = By.Id("antiviralMedicationUnknown");
            private static By txtNameOfMed = By.Id(CommonCtrls.GeneralContent + "txtNameofMedication");
            private static By txtDateReceived = By.Id("txtDateReceived");

            public static bool IsAt
            {
                get
                {
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(subSymptitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(subSymptitleFormTitle).Text.Contains("Symptoms") &&
                                Driver.Instance.FindElement(subSymptitleFormTitle).Displayed)
                                return true;
                            else
                                return false;
                        }
                    }
                    else
                    {
                        return false;
                    }
                }
            }

            public static void enterDateOfSymptomOnset()
            {
                SetMethods.enterCurrentDate(txtDateofSymptomOnset);
            }

            private static BasicSyndromicSurveillance isSelectionYesNoOrUnknown(By element)
            {
                var el = wait.Until(ExpectedConditions.ElementToBeClickable(element));
                Driver.Wait(TimeSpan.FromMinutes(10));
                el.Click();
                return new BasicSyndromicSurveillance();
            }


            public static BasicSyndromicSurveillance patientPregYes()
            {
                var element = rdoPregnantYes;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance patientPregNo()
            {
                var element = rdoPregnantNo;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance patientPregUnknown()
            {
                var element = rdoPregnantUnknown;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance patientPostpartumYes()
            {
                var element = rdoPostpartumYes;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance patientPostpartumNo()
            {
                var element = rdoPostpartumNo;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance patientPostpartumUnknown()
            {
                var element = rdoPostpartumUnknown;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance feverOver38CYes()
            {
                var element = rdoFever38Yes;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance feverOver38CNo()
            {
                var element = rdoFever38No;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance feverOver38Unknown()
            {
                var element = rdoFever38Unknown;
                return isSelectionYesNoOrUnknown(element);
            }


            public static BasicSyndromicSurveillance coughYes()
            {
                var element = rdoCoughYes;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance coughNo()
            {
                var element = rdoCoughNo;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance coughUnknown()
            {
                var element = rdoCoughUnknown;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance shortnessOfBreathYes()
            {
                var element = rdoShortnessofBreathYes;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance shortnessOfBreathNo()
            {
                var element = rdoShortnessofBreathNo;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance shortnessOfBreathUnknown()
            {
                var element = rdoShortnessofBreathUnknown;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance seasonalFluVaccineYes()
            {
                var element = rdoSeasonalFluVaccineYes;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance seasonalFluVaccineNo()
            {
                var element = rdoSeasonalFluVaccineNo;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance seasonalFluVaccineUnknown()
            {
                var element = rdoSeasonalFluVaccineUnknown;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance antiViralMedicationYes()
            {
                var element = rdoAntiviralMedicationYes;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance antiViralMedicationNo()
            {
                var element = rdoAntiviralMedicationNo;
                return isSelectionYesNoOrUnknown(element);
            }

            public static BasicSyndromicSurveillance antiViralMedicationUnknown()
            {
                var element = rdoAntiviralMedicationUnknown;
                return isSelectionYesNoOrUnknown(element);
            }


            public static void isPostpartumPeriodEnabled()
            {
                var post = wait.Until(ExpectedConditions.ElementToBeClickable(rdoPostpartumYes));
                SetMethods.isFieldEnabled(post);
            }

            public static void isPostpartumPeriodDisabled()
            {
                var post = wait.Until(ExpectedConditions.ElementToBeClickable(rdoPostpartumYes));
                SetMethods.isFieldDisabled(post);
            }

            public static void enterMethodOfMeasurement(string method)
            {
                var measurement = wait.Until(ExpectedConditions.ElementToBeClickable(ddlMethodOfMeasurement));
                Driver.Wait(TimeSpan.FromMinutes(10));
                measurement.EnterText(method);
            }

            public static void randomSelectMethodOfMeasurement()
            {
                SetMethods.randomSelectObjectElement(ddlMethodOfMeasurement, measureOptions);
            }

            public static void isMethodOfMeasurementEnabled()
            {
                var measurement = wait.Until(ExpectedConditions.ElementToBeClickable(ddlMethodOfMeasurement));
                SetMethods.isFieldEnabled(measurement);
            }

            public static void isMethodOfMeasurementDisabled()
            {
                var measurement = wait.Until(ExpectedConditions.ElementToBeClickable(ddlMethodOfMeasurement));
                SetMethods.isFieldDisabled(measurement);
            }

            public static void isOtherMethodEnabled()
            {
                var other = wait.Until(ExpectedConditions.ElementToBeClickable(txtOtherMethod));
                SetMethods.isFieldEnabled(other);
            }

            public static void isOtherMethodDisabled()
            {
                var other = wait.Until(ExpectedConditions.ElementToBeClickable(txtOtherMethod));
                SetMethods.isFieldDisabled(other);
            }

            public static void enterOtherMethod(string meds)
            {
                SetMethods.enterStringObjectValue(txtOtherMethod, meds);
            }

            public static void enterNameOfMedication(string meds)
            {
                SetMethods.enterStringObjectValue(txtOtherMethod, meds);
            }

            public static void randomEnterNameOfMedication()
            {
                int index = rnd.Next(medication.Count);
                var meds = medication[index];
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(txtNameOfMed));
                element.EnterText(meds);
            }

            public static void isNameOfMedsFieldEnabled()
            {
                var nameOfMeds = wait.Until(ExpectedConditions.ElementToBeClickable(txtNameOfMed));
                SetMethods.isFieldEnabled(nameOfMeds);
            }

            public static void isNameOfMedsFieldDisabled()
            {
                var nameOfMeds = wait.Until(ExpectedConditions.ElementToBeClickable(txtNameOfMed));
                SetMethods.isFieldDisabled(nameOfMeds);
            }

            public static void randomSelectDateReceived()
            {
                SetMethods.enterCurrentDate(txtDateReceived);
            }

            public static void isDateReceivedFieldEnabled()
            {
                var dateOfMeds = wait.Until(ExpectedConditions.ElementToBeClickable(txtDateReceived));
                SetMethods.isFieldEnabled(dateOfMeds);
            }

            public static void isDateReceivedFieldDisabled()
            {
                var dateOfMeds = wait.Until(ExpectedConditions.ElementToBeClickable(txtDateReceived));
                SetMethods.isFieldDisabled(dateOfMeds);
            }

        }

        public class Samples
        {
            private static By txtSampleCollectionDate = By.Id(CommonCtrls.GeneralContent + "txtSampleCollectionDate");
            private static By lblSampleID = By.Id("lblSampleID");
            private static By txtSampleID = By.Id(CommonCtrls.GeneralContent + "txtSampleID");
            private static By lblTestResult = By.Id("lblTestResult");
            private static By ddlTestResult = By.Id(CommonCtrls.GeneralContent + "ddlTestResult");
            private static By lblSampleCollectionDate = By.Id("lblSampleCollectionDate"); private static IList<IWebElement> testResultOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlTestResult']/option")); } }
            private static By lblResultDate = By.Id("lblResultDate");
            private static By txtResultDate = By.Id(CommonCtrls.GeneralContent + "txtResultDate");


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
                    else if (Driver.Instance.FindElements(subSampletitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(subSampletitleFormTitle).Text.Contains("Samples") &&
                                Driver.Instance.FindElement(subSampletitleFormTitle).Displayed)
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

            public static void enterSelectCollectionDate()
            {
                SetMethods.enterCurrentDate(txtSampleCollectionDate);
            }

            public static void enterSampleCollectionDate(string element)
            {
                var el = wait.Until(ExpectedConditions.ElementToBeClickable(txtSampleCollectionDate));
                el.EnterText(element);
                Driver.Wait(TimeSpan.FromMinutes(5));
            }

            public static void enterRandomSampleID(string txtID)
            {
                int rNum = rnd.Next(10000, 10000);
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(txtSampleID));
                element.EnterText(txtID + rNum);
                Driver.Wait(TimeSpan.FromMinutes(5));
            }

            public static void randomSelectTestResult()
            {
                SetMethods.randomSelectObjectElement(ddlTestResult, testResultOptions);
            }
            public static void randomSelectResultDate()
            {
                SetMethods.enterCurrentDate(txtResultDate);
            }
        }
    }
}