using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Threading;

namespace EIDSS7Test.HumanCases.SearchPersons
{
    public class CreateNewPersonPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();
        public static List<String> middleInit = new List<String>(new[] { "A", "E", "I", "O", "U" });
        public static string[] suffixes = new string[] { "Mr.", "Mrs.", "Miss", "Jr.", "Sr." };
        public static string street;
        public static String firstName;
        public static String employerName;
        public static string personEIDSSID;
        public static String schoolName;
        public static String ageOver100Error = "Age>100. Please verify age is correct";
        public static String errorMsgString;
        public static string getElementValue;
        public static string regionName;
        public static string rayonName;

        private static By HeaderFormTitle = By.TagName("h1");
        private static By titleFormTitle = By.TagName("h2");
        private static By subtitleFormTitle = By.TagName("h3");
        private static By srchPerEmpSchoolFormTitle = By.XPath("//*[@id='" + CommonCtrls.AddPersonUpdateContent + "PersonEmploymentSchoolInformation']/div/div[1]/div/div[1]/h3");
        private static By sidePanelContainer = By.Id("sidePanelContainer");
        private static By btnSideMenuToggle = By.Id("btnSideMenuToggle");
        private static By linkPersonInfo = By.LinkText("Person Information");
        private static By linkPersonAddress = By.LinkText("Person Address");
        private static By linkPersonEmpSchoolInfo = By.LinkText("Person Employment/School");
        private static By linkPersonReview = By.LinkText("Person Review");
        private static By btnNext = By.Id(CommonCtrls.AddPersonUpdateContent + "btnNextSection");
        private static By btnSubmit = By.Id(CommonCtrls.AddPersonUpdateContent + "btnSubmit");
        private static By btnReturnToDashboard = By.Id(CommonCtrls.GeneralContent + "btnReturntoSearch");
        private static By btnPopupReturnToDash = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "divSuccessModal']/div/div/div[3]/a");
        private static By btnCancel = By.Id(CommonCtrls.AddPersonUpdateContent + "btnCancel");
        private static By btnBack = By.Id(CommonCtrls.GeneralContent + "btnPreviousSection");
        private static By btnAddDiseaseRpt = By.Id(CommonCtrls.AddPersonUpdateContent + "btnAddSelectablePreviewHumanDiseaseReport");
        private static By btnOK = By.Id(CommonCtrls.GeneralContent + "btnReturnToPersonRecord");
        private static By btnAddNewPatient = By.Id(CommonCtrls.GeneralContent + "btnSubmit");
        private static By txtLastNameAlert = By.Id("EIDSSBodyCPH_ctl32");
        private static By lblSuccessMessage = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lblSuccessMessage']");
        private static By btnReturnToPersonRec = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "btnReturnToPersonRecord']");
        private static By btnPopupYes = By.XPath("//*[@id='" + CommonCtrls.AddPersonUpdateContent + "btnCancelYes']");
        private static By btnPopupNo = By.XPath("//*[@id='" + CommonCtrls.AddPersonUpdateContent + "divPersonCancelModal']/div/div/div[3]/button");

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
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(titleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Person") &&
                                Driver.Instance.FindElement(titleFormTitle).Displayed)
                                return true;
                            else
                                //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                            return false;
                        }
                    }
                    else if (Driver.Instance.FindElement(HeaderFormTitle).Displayed ||
                        Driver.Instance.FindElement(HeaderFormTitle).Text.Contains("This page isn't working"))
                    {
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
                    }
                    else
                    {
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
                    }
                }
                catch (NoSuchElementException e)
                {
                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                    return false;
                }
            }
        }


        public static void clickNext()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            SetMethods.clickObjectButtons(btnNext);
        }

        public static void clickCancel()
        {
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clickSubmit()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            SetMethods.clickObjectButtons(btnSubmit);
        }

        public static void clearField(By element)
        {
            var clear = wait.Until(ExpectedConditions.ElementIsVisible(element));
            clear.Clear();
            Driver.Wait(TimeSpan.FromMinutes(5));
        }

        public static void clickReturnToDashboard()
        {
            SetMethods.clickObjectButtons(btnReturnToDashboard);
        }

        public static void clickReturnToPersonRecord()
        {
            SetMethods.clickObjectButtons(btnReturnToPersonRec);
        }

        public static void clickPersonReview()
        {
            SetMethods.clickObjectButtons(linkPersonReview);
        }

        public static void clickPersonInfor()
        {
            SetMethods.clickObjectButtons(linkPersonInfo);
        }

        public static void clickPersonAddress()
        {
            SetMethods.clickObjectButtons(linkPersonAddress);
        }

        public static void clickPersonEmployerSchoolInfo()
        {
            SetMethods.clickObjectButtons(linkPersonEmpSchoolInfo);
        }


        public static void clickAddNewPerson()
        {
            SetMethods.clickObjectButtons(btnAddNewPatient);
        }

        public static void clickPopupYes()
        {
            SetMethods.clickObjectButtons(btnPopupYes);
        }

        public static void clickPopupNo()
        {
            SetMethods.clickObjectButtons(btnPopupNo);
        }

        public static string doesAgeErrorAlertMessageDisplay()
        {
            try
            {
                string text = Driver.Instance.SwitchTo().Alert().Text;
                ageOver100Error = text;
            }
            catch
            {
                //Fails the test if error message does not display
                //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail("Error message does not display");
            }
            return ageOver100Error;
        }

        public static string doesErrorAlertMessageDisplay()
        {
            try
            {
                string text = Driver.Instance.SwitchTo().Alert().Text;
                errorMsgString = text;
            }
            catch
            {
                //Fails the test if error message does not display
                //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail("Error message does not display");
            }
            return errorMsgString;
        }

        public static string doesErrorAlertMessageDisplay(String alert)
        {
            try
            {
                string text = Driver.Instance.SwitchTo().Alert().Text;
                errorMsgString = text;
            }
            catch
            {
                //Fails the test if error message does not display
                //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail("Error message does not display");
            }
            return errorMsgString;
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

        public static void doesCreateNewPersonConfirmMsgDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(lblSuccessMessage);
        }

        public static void clickPopupAddDiseaseReport()
        {
            ////Scroll to bottom of the page
            //((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1500)", "");
            Thread.Sleep(2000);
            SetMethods.clickObjectButtons(btnAddDiseaseRpt);
            Thread.Sleep(2000);
        }

        public static void clickPopupReturnToPersonRecordOK()
        {
            SetMethods.clickObjectButtons(btnOK);
        }

        public static void clickPopupReturnToDashboard()
        {
            SetMethods.clickObjectButtons(btnPopupReturnToDash);
        }

        public static String getPopupPersonEIDSSID()
        {
            var personID = Driver.Instance.FindElement(lblSuccessMessage).Text;
            Driver.Wait(TimeSpan.FromMinutes(20));
            return personEIDSSID = personID.Substring(personID.Length - 15).TrimEnd('.');
        }

        public class PersonInformation
        {

            //private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmit");
            //private static By ddlPersonIDType = By.Id(CommonCtrls.AddPersonUpdateContent + "ddlidfsPersonIDType");
            //private static IList<IWebElement> personIDOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddPersonUpdateContent + "ddlidfsPersonIdType']/option")); } }
            //private static By txtPersonID = By.Id(CommonCtrls.AddPersonUpdateContent + "txtstrPersonId");
            //private static By txtFirstName = By.Id(CommonCtrls.AddPersonUpdateContent + "txtstrFirstName");
            //private static By txtMiddleInit = By.Id(CommonCtrls.AddPersonUpdateContent + "txtstrSecondName");
            //private static By txtLastName = By.Id(CommonCtrls.AddPersonUpdateContent + "txtstrLastName");
            //private static By ddlSuffix = By.Id(CommonCtrls.GeneralContent + "ddlidfsSuffix");
            //private static IList<IWebElement> suffixOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsSuffix']/option")); } }
            ////private static By txtSuffix = By.Id(CommonCtrls.GeneralContent + "txtSuffix");
            //private static By datDateOfBirth = By.Id(CommonCtrls.AddPersonUpdateContent + "txtdatDateofBirth");
            //private static By txtAge = By.Id(CommonCtrls.AddPersonUpdateContent + "txtReportedAge");
            //private static By ddlAgeType = By.Id(CommonCtrls.AddPersonUpdateContent + "ddlReportAgeUOMID");
            //private static IList<IWebElement> ageTypeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddPersonUpdateContent + "ddlReportAgeUOMID']/option")); } }
            //private static By ddlGender = By.Id(CommonCtrls.AddPersonUpdateContent + "ddlidfsHumanGender");
            //private static IList<IWebElement> genderOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddPersonUpdateContent + "ddlidfsHumanGender']/option")); } }
            //private static By ddlCitizenship = By.Id(CommonCtrls.AddPersonUpdateContent + "ddlidfsNationality");
            //private static IList<IWebElement> citizenOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddPersonUpdateContent + "ddlidfsNationality']/option")); } }
            //private static By txtPassportNumber = By.Id(CommonCtrls.AddPersonUpdateContent + "txtstrPassportNbr");

            private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmit");
            private static By ddlPersonIDType = By.Id(CommonCtrls.AddPersonUpdateContent + "ddlPersonalIDType");
            private static By txtPersonalIDNum = By.Id(CommonCtrls.AddPersonUpdateContent + "txtPersonalID");
            private static IList<IWebElement> personIDOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddPersonUpdateContent + "ddlPersonalIdType']/option")); } }
            private static By readOnlyEIDSSID = By.Id(CommonCtrls.AddPersonUpdateContent + "txtEIDSSID");
            private static By txtFirstName = By.Id(CommonCtrls.AddPersonUpdateContent + "txtFirstOrGivenName");
            private static By txtMiddleInit = By.Id(CommonCtrls.AddPersonUpdateContent + "txtSecondName");
            private static By txtLastName = By.Id(CommonCtrls.AddPersonUpdateContent + "txtLastOrSurname");
            private static By ddlSuffix = By.Id(CommonCtrls.GeneralContent + "ddlidfsSuffix");
            private static IList<IWebElement> suffixOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsSuffix']/option")); } }
            //private static By txtSuffix = By.Id(CommonCtrls.GeneralContent + "txtSuffix");
            private static By datDateOfBirth = By.Id(CommonCtrls.AddPersonUpdateContent + "txtDateOfBirth");
            private static By txtAge = By.Id(CommonCtrls.AddPersonUpdateContent + "txtReportedAge");
            private static By ddlAgeType = By.Id(CommonCtrls.AddPersonUpdateContent + "ddlReportAgeUOMID");
            private static IList<IWebElement> ageTypeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddPersonUpdateContent + "ddlReportAgeUOMID']/option")); } }
            private static By ddlGender = By.Id(CommonCtrls.AddPersonUpdateContent + "ddlGenderTypeID");
            private static IList<IWebElement> genderOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddPersonUpdateContent + "ddlGenderTypeID']/option")); } }
            private static By ddlCitizenship = By.Id(CommonCtrls.AddPersonUpdateContent + "ddlCitizenshipTypeID");
            private static IList<IWebElement> citizenOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddPersonUpdateContent + "ddlCitizenshipTypeID']/option")); } }
            private static By txtPassportNumber = By.Id(CommonCtrls.AddPersonUpdateContent + "txtPassportNumber");
            private static By DOBErrorMessage = By.Id(CommonCtrls.GeneralContent + "CustomValidator3DateOrderDiagDate");
            public static String DateOfBirthErrorMsg = "Date of Birth must be before or equal to current date, if present, and not in the future.";
            private static By lastNameErrorMsg = By.Id(CommonCtrls.AddPersonUpdateContent + "ctl19");

            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    Thread.Sleep(3000);
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Person Information") &&
                                Driver.Instance.FindElement(subtitleFormTitle).Displayed)
                                return true;
                            else
                                //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                Assert.Fail("This is not the correct title");
                            return false;
                        }
                    }
                    else
                    {
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                }
            }

            public static void randomSelectPersonIDType()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlPersonIDType, personIDOptions);
            }

            public static void enterPersonIDType(string value)
            {
                SetMethods.enterObjectValue(ddlPersonIDType, value);
            }

            public static void randomSelectGender()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlGender, genderOptions);
            }

            public static void enterGender(string value)
            {
                SetMethods.enterObjectValue(ddlGender, value);
            }

            public static void enterPersonalIDNumber()
            {
                int rNum = rnd.Next(00000000, 9999999);
                SetMethods.enterIntObjectValue(txtPersonalIDNum, rNum);
            }

            public static String enterFirstName(string FName)
            {
                int rNum = rnd.Next(0, 99999999);
                FName = FName + rNum;
                SetMethods.enterObjectValue(txtFirstName, FName);
                return firstName = FName;
            }

            public static void enterMiddleName()
            {

                SetMethods.enterObjectValue(txtMiddleInit, firstName);
            }

            public static void enterLastName()
            {
                SetMethods.enterObjectValue(txtLastName, firstName);
            }

            public static void randomEnterSuffix()
            {
                try
                {
                    var suff = wait.Until(ExpectedConditions.ElementIsVisible(ddlSuffix));
                    string suffix = suffixes[new Random().Next(0, suffixes.Length)];
                    suff.EnterText(suffix);
                }
                catch
                {
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", ddlSuffix);
                    var suff = wait.Until(ExpectedConditions.ElementIsVisible(ddlSuffix));
                    string suffix = suffixes[new Random().Next(0, suffixes.Length)];
                    suff.EnterText(suffix);
                }
            }

            public static void enterRandomDateOfBirth()
            {
                SetMethods.randomEnterDOB(datDateOfBirth);
            }

            //Enter in "Days" how far in the future for the DOB
            public static void enterFutureDateOfBirth(int value)
            {
                SetMethods.enterFutureDate(datDateOfBirth, value);
            }

            public static Boolean isAgeFieldDisabled()
            {
                try
                {
                    var ID = wait.Until(ExpectedConditions.ElementIsVisible(txtAge));
                    ID.GetAttribute("disabled");
                    return true;
                }
                catch (Exception)
                {
                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Field is not disabled.");
                    return false;
                }
            }

            public static Boolean doesCalculatedAgeDisplay()
            {
                var ID = wait.Until(ExpectedConditions.ElementIsVisible(txtAge));
                if (ID.Text.Length > 0)
                {
                    Console.WriteLine("Person " + ID.Text + " age displays successfully");
                    return true;
                }
                else
                {
                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Field is not disabled.");
                    return false;
                }
            }

            public static void doesDateOfBirthGreaterThanCurrentDateDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(DOBErrorMessage);
            }

            public static void enterAgeUnder100()
            {
                int rNum = rnd.Next(-5, -100);
                SetMethods.enterIntObjectValue(txtAge, rNum);
            }

            public static void enterAgeOver100()
            {
                int rNum = rnd.Next(100, 250);
                SetMethods.randomEnterDOBOver100(txtAge, rNum);
            }


            public static void selectGender(string genderSex)
            {
                SetMethods.enterObjectValue(ddlGender, genderSex);
            }

            public static void randomSelectCitizenship()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlCitizenship, citizenOptions);
            }

            public static void enterPassportNumber()
            {
                int rNum = rnd.Next(10000, 10000);
                SetMethods.enterIntObjectValue(txtPassportNumber, rNum);
            }

            public static String getRecordElementValue(By element)
            {
                var ID = Driver.Instance.FindElement(element).GetAttribute("value");
                Driver.Wait(TimeSpan.FromMinutes(20));
                return getElementValue = ID.ToString();
            }

            public static void getPersonEIDSSID()
            {
                getRecordElementValue(readOnlyEIDSSID);
            }

            public static void getPersonFirstName()
            {
                getRecordElementValue(txtFirstName);
            }

            public static void getPersonMiddleName()
            {
                getRecordElementValue(txtMiddleInit);
            }

            public static void getPersonLastName()
            {
                getRecordElementValue(txtLastName);
            }

            public static void getPersonDateOfBirth()
            {
                getRecordElementValue(datDateOfBirth);
            }

            public static void getPersonGender()
            {
                getRecordElementValue(ddlGender);
            }

            public static void doesLastNameErrorMessageDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(lastNameErrorMsg);
            }
        }


        public class PersonEmployment
        {
            private static By employSection = By.Id(CommonCtrls.GeneralContent + "employmentInformation");
            private static By lblPersonEmployedYes = By.Name("Yes");
            private static By radCurrentlyEmployedYes = By.Id(CommonCtrls.AddPersonUpdateContent + "rdbCurrentlyEmployedYes");
            private static By lblPersonEmployedNo = By.Name("No");
            private static By radCurrentlyEmployedNo = By.Id(CommonCtrls.AddPersonUpdateContent + "rdbCurrentlyEmployedNo");
            private static By lblPersonEmployedUnknown = By.Name("Unknown");
            private static By radCurrentlyEmployedUnk = By.Id(CommonCtrls.AddPersonUpdateContent + "rdbCurrentlyEmployedUnknown");
            private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmit");
            private static By txtEmployerName = By.Id(CommonCtrls.AddPersonUpdateContent + "txtEmployerName");
            private static By datEmployedLastDate = By.Id(CommonCtrls.AddPersonUpdateContent + "txtEmployedDateLastPresent");
            private static By txtEmployerCtryCodePhone = By.Id(CommonCtrls.AddPersonUpdateContent + "txtEmployerPhone");
            private static By rdoEmployerForeignAddressYes = By.Id(CommonCtrls.AddPersonUpdateContent + "rdbEmployerForeignAddressYes");
            private static By rdoEmployerForeignAddressNo = By.Id(CommonCtrls.AddPersonUpdateContent + "rdbEmployerForeignAddressNo");
            private static By ddlEmployerPhoneType = By.Id(CommonCtrls.GeneralContent + "ddlidfsEmployerPhoneType");
            private static IList<IWebElement> EmployerPhoneTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsEmployerPhoneType']/option")); } }
            private static By ddlEmployerRegion = By.Id(CommonCtrls.AddPersonEmployerUpdateContent + "ddlEmployeridfsRegion");
            private static IList<IWebElement> emplRegionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddPersonEmployerUpdateContent + "ddlEmployeridfsRegion']/option")); } }
            private static By ddlEmployerRayon = By.Id(CommonCtrls.AddPersonEmployerUpdateContent + "ddlEmployeridfsRayon");
            private static IList<IWebElement> emplRayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddPersonEmployerUpdateContent + "ddlEmployeridfsRayon']/option")); } }
            private static By ddlEmployerTownOrVillage = By.Id(CommonCtrls.AddPersonEmployerUpdateContent + "ddlEmployeridfsSettlement");
            private static IList<IWebElement> emplTownOrVillageOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddPersonEmployerUpdateContent + "ddlEmployeridfsSettlement']/option")); } }
            private static By txtEmployerStreet = By.Id(CommonCtrls.AddPersonEmployerUpdateContent + "txtEmployerstrStreetName");
            private static By txtEmployerBuilding = By.Id(CommonCtrls.AddPersonEmployerUpdateContent + "txtEmployerstrBuilding");
            private static By txtEmployerHouse = By.Id(CommonCtrls.AddPersonEmployerUpdateContent + "txtEmployerstrHouse");
            private static By txtEmployerApt = By.Id(CommonCtrls.AddPersonEmployerUpdateContent + "txtEmployerstrApartment");
            private static By ddlEmployerPostalCode = By.Id(CommonCtrls.AddPersonEmployerUpdateContent + "ddlEmployeridfsPostalCode");


            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") ||
                        Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(srchPerEmpSchoolFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(srchPerEmpSchoolFormTitle).Text.Contains("Person Employment/School") &&
                                Driver.Instance.FindElement(srchPerEmpSchoolFormTitle).Displayed)
                                return true;
                            else
                                //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                Assert.Fail("This is not the correct title");
                            return false;
                        }
                    }
                    else
                    {
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                }
            }

            public static void isPersonEmployedYes()
            {
                SetMethods.clickObjectButtons(radCurrentlyEmployedYes);
            }

            public static void isPersonEmployedNo()
            {
                SetMethods.clickObjectButtons(radCurrentlyEmployedNo);
            }

            public static void isPersonEmployedUnknown()
            {
                SetMethods.clickObjectButtons(radCurrentlyEmployedUnk);
            }

            public static string randomEnterEmployerName(string empName)
            {
                int rNum = rnd.Next(1000, 10000000);
                employerName = empName + rNum;
                SetMethods.enterObjectValue(txtEmployerName, employerName);
                return employerName;
            }

            public static void randomEnterDateOfLastAppearance()
            {
                SetMethods.enterCurrentDate(datEmployedLastDate);
            }


            public static void enterEmployerPhoneNumber()
            {
                string phone = SetMethods.GetRandomTelNo();
                SetMethods.enterStringObjectValue(txtEmployerCtryCodePhone, phone);
            }

            public static void randomSelectEmployerRegion()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlEmployerRegion, emplRegionOptions);
                Thread.Sleep(1000);
            }

            public static void enterEmployerRegion()
            {
                SetMethods.enterObjectValue(ddlEmployerRegion, rayonName);
                Thread.Sleep(1000);
            }

            public static void randomSelectEmployerRayon()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlEmployerRayon, emplRayonOptions);
            }

            public static void enterEmployerRayon()
            {
                SetMethods.enterObjectValue(ddlEmployerRayon, regionName);
                Thread.Sleep(1000);
            }

            public static void randomSelectEmployerTownOrVillage()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlEmployerTownOrVillage, emplTownOrVillageOptions);
            }

            public static void enterEmployerTownOrVillage(String value)
            {
                SetMethods.enterObjectValue(ddlEmployerTownOrVillage, value);
                Thread.Sleep(1000);
            }

            public static String enterEmployerStreetAddress(string addr)
            {
                int rNum = rnd.Next(1, 99999);
                street = rNum + addr;
                SetMethods.enterObjectValue(txtEmployerStreet, street);
                return street;
            }

            public static void enterEmployerHouseNumber()
            {
                SetMethods.enterObjectValue(txtEmployerHouse, street);
            }

            public static void enterBuildingNumber()
            {
                SetMethods.enterObjectValue(txtEmployerBuilding, street);
            }

            public static void enterEmployerAptNumber()
            {
                SetMethods.enterObjectValue(txtEmployerApt, street);
            }

            public static void enterEmployerPostalCode()
            {
                int rNum = rnd.Next(10000, 99999);
                SetMethods.enterIntObjectValue(ddlEmployerPostalCode, rNum);
            }

        }

        public class PersonSchoolInfo
        {
            private static By employSection = By.Id(CommonCtrls.GeneralContent + "schoolInformation");
            private static By lblPersonSchoolYes = By.Name("Yes");
            private static By radPersonInSchoolYes = By.Id(CommonCtrls.AddPersonUpdateContent + "rdbCurrentlyInSchoolYes");
            private static By lblPersonSchoolNo = By.Name("No");
            private static By radPersonInSchoolNo = By.Id(CommonCtrls.AddPersonUpdateContent + "rdbCurrentlyInSchoolNo");
            private static By lblPersonInSchoolUnknown = By.Name("Unknown");
            private static By radPersonInSchoolUnknown = By.Id(CommonCtrls.AddPersonUpdateContent + "rdbCurrentlyInSchoolUnknown");
            private static By txtSchoolName = By.Id(CommonCtrls.AddPersonUpdateContent + "txtstrSchoolName");
            private static By datSchoolLastDate = By.Id(CommonCtrls.AddPersonUpdateContent + "txtSchoolLastAttendedDTM");
            private static By txtSchoolCtryCodePhone = By.Id(CommonCtrls.AddPersonUpdateContent + "txtSchoolPhoneNbr");
            private static By ddlSchoolPhoneType = By.Id(CommonCtrls.AddPersonUpdateContent + "ddlidfsSchoolPhoneType");
            private static IList<IWebElement> schoolPhoneTypeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsSchoolPhoneType']/option")); } }
            private static By ddlSchoolRegion = By.Id(CommonCtrls.AddPersonSchoolUpdateContent + "ddlSchoolidfsRegion");
            private static IList<IWebElement> schoolRegionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddPersonSchoolUpdateContent + "ddlSchoolidfsRegion']/option")); } }
            private static By ddlSchoolRayon = By.Id(CommonCtrls.AddPersonSchoolUpdateContent + "ddlSchoolidfsRayon");
            private static IList<IWebElement> schoolRayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddPersonSchoolUpdateContent + "ddlSchoolidfsRayon']/option")); } }
            private static By ddlSchoolTownOrVillage = By.Id(CommonCtrls.AddPersonSchoolUpdateContent + "ddlSchoolidfsSettlement");
            private static IList<IWebElement> schoolTownOrVillageOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddPersonSchoolUpdateContent + "ddlSchoolidfsSettlement']/option")); } }
            private static By txtSchoolStreet = By.Id(CommonCtrls.AddPersonSchoolUpdateContent + "txtSchoolstrStreetName");
            private static By txtSchoolBuilding = By.Id(CommonCtrls.AddPersonSchoolUpdateContent + "txtSchoolstrBuilding");
            private static By txtSchoolHouse = By.Id(CommonCtrls.AddPersonSchoolUpdateContent + "txtSchoolstrHouse");
            private static By txtSchoolApt = By.Id(CommonCtrls.AddPersonSchoolUpdateContent + "txtSchoolstrApartment");
            private static By ddlSchoolPostalCode = By.Id(CommonCtrls.AddPersonSchoolUpdateContent + "ddlSchoolidfsPostalCode");


            public static void isPersonSchoolYes()
            {
                SetMethods.clickObjectButtons(radPersonInSchoolYes);
            }

            public static void isPersonSchoolNo()
            {
                SetMethods.clickObjectButtons(radPersonInSchoolNo);
            }

            public static void isPersonSchoolUnknown()
            {
                SetMethods.clickObjectButtons(radPersonInSchoolUnknown);
            }

            public static string randomEnterSchoolName(string schName)
            {
                int rNum = rnd.Next(1000, 10000000);
                schoolName = schName + rNum;
                SetMethods.enterStringObjectValue(txtSchoolName, schoolName);
                return schoolName;
            }

            public static void randomEnterDateOfLastAppearance()
            {
                SetMethods.enterCurrentDate(datSchoolLastDate);
            }


            public static void enterSchoolPhoneNumber()
            {
                int rPhoneNum = rnd.Next(100000000, 999999999);
                SetMethods.enterObjectValue(txtSchoolCtryCodePhone, String.Format("{0: (###) ###-####", rPhoneNum));
            }

            public static void enterRandomPhoneNumber()
            {
                string phone = SetMethods.GetRandomTelNo();
                SetMethods.enterStringObjectValue(txtSchoolCtryCodePhone, phone);
                //return contactnum = phone;
            }

            public static void randomSelectSchoolRegion()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlSchoolRegion, schoolRegionOptions);
                Thread.Sleep(2000);
            }

            public static void randomSelectSchoolRayon()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlSchoolRayon, schoolRayonOptions);
                Thread.Sleep(2000);
            }

            public static void randomSelectSchoolTownOrVillage()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlSchoolTownOrVillage, schoolTownOrVillageOptions);
            }

            public static String enterSchoolStreetAddress(string addr)
            {
                var streetLocal = wait.Until(ExpectedConditions.ElementIsVisible(txtSchoolStreet));
                int rNum = rnd.Next(10000, 99999);
                street = rNum + addr;
                SetMethods.enterObjectValue(txtSchoolStreet, street);
                return street;
            }

            public static void enterSchoolHouseNumber()
            {
                SetMethods.enterObjectValue(txtSchoolHouse, street);
            }

            public static void enterSchoolBuildingNumber()
            {
                SetMethods.enterObjectValue(txtSchoolBuilding, street);
            }

            public static void enterSchoolAptNumber()
            {
                SetMethods.enterObjectValue(txtSchoolApt, street);
            }

            public static void enterSchoolPostalCode()
            {
                int rNum = rnd.Next(10000, 99999);
                SetMethods.enterIntObjectValue(ddlSchoolPostalCode, rNum);
            }


        }

        public class PersonAddress
        {
            private static By personAddrFormTitle = By.XPath("//*[@id='" + CommonCtrls.AddPersonUpdateContent + "PersonAddress']/div/div[1]/div/div[1]/h3");
            //private static By btnNext = By.CssSelector("button[btn btn-primary]");
            private static By btnReturnToDashboard = By.LinkText("Return to Dashboard");
            private static By personAddressSection = By.Id("personalAddress");
            private static By ddlCountry = By.Id(CommonCtrls.AddressContent + "ddlHumanidfsCountry");
            private static IList<IWebElement> countryOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddUpdateHumanAddressContent + "ddlHomeidfsCountry']/option")); } }
            private static By ddlRayon = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "ddlHumanidfsRayon");
            private static IList<IWebElement> rayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddUpdateHumanAddressContent + "ddlHumanidfsRayon']/option")); } }
            private static By ddlRegion = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "ddlHumanidfsRegion");
            private static IList<IWebElement> regionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddUpdateHumanAddressContent + "ddlHumanidfsRegion']/option")); } }
            private static By ddlTownOrVillage = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "ddlHumanidfsSettlement");
            private static IList<IWebElement> townOrVillageOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.AddUpdateHumanAddressContent + "ddlHumanidfsSettlement']/option")); } }
            private static By lblStreetLocalAddress = By.Name("Street Address");
            private static By txtStreetLocalAddress = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "txtHumanstrStreetName");
            private static By lblHouse = By.Name("House");
            private static By txtHouse = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "txtHumanstrHouse");
            private static By lblBuilding = By.Name("Building");
            private static By txtBuilding = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "txtHumanstrBuilding");
            private static By lblApt = By.Name("Apartment");
            private static By txtApt = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "txtHumanstrApartment");
            private static By lblPostalCode = By.Name("Postal Code");
            private static By txtPostalCode = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "ddlHumanidfsPostalCode");
            private static By lblLongitudeLocalAddress = By.Name("Latitude");
            private static By txtLatitudeLocalAddress = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "txtHumanstrLatitude");
            private static By lblLatitudeLocalAddress = By.Name("Longitude");
            private static By txtLongitudeLocalAddress = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "txtHumanstrLongitude");
            private static By txtElevation = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "txtHumanstrElevation");
            private static By lblAnotherAddressYes = By.Name("Yes");
            private static By radAnotherAddressYes = By.Id(CommonCtrls.GeneralContent + "rdbAnotherAddressYes");
            private static By lblAnotherAddressNo = By.Name("No");
            private static By radAnotherAddressNo = By.Id(CommonCtrls.GeneralContent + "rdbAnotherAddressNo");
            private static By radAnotherPhoneUnknown = By.Id("anotherPhoneUnknown");
            private static By txtAnother = By.Id(CommonCtrls.GeneralContent + "txtstrCountryCodeandNumber");
            private static By ddlOtherPhoneType = By.Id(CommonCtrls.GeneralContent + "ddlidfsPhoneType");
            private static By radAnotherPhoneYes = By.Id(CommonCtrls.GeneralContent + "rdbAnotherPhoneYes");
            private static By radAnotherPhoneNo = By.Id(CommonCtrls.GeneralContent + "rdbAnotherPhoneNo");
            private static By regionErrorMsg = By.Id(CommonCtrls.AddPersonUpdateContent + "Human_ctl04");
            private static By rayonErrorMsg = By.Id(CommonCtrls.AddPersonUpdateContent + "Human_ctl07");


            //ANOTHER PERSON ADDRESS
            private static By ddlOtherRayon = By.Id(CommonCtrls.HumanAltAddressContent + "ddlHumanAltidfsRayon");
            private static IList<IWebElement> otherRayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.HumanAltAddressContent + "ddlHumanAltidfsRayon']/option")); } }
            private static By ddlOtherRegion = By.Id(CommonCtrls.HumanAltAddressContent + "ddlHumanAltidfsRegion");
            private static IList<IWebElement> otherRegionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.HumanAltAddressContent + "ddlHumanAltidfsRegion']/option")); } }
            private static By ddlOtherTownOrVillage = By.Id(CommonCtrls.HumanAltAddressContent + "ddlHumanAltidfsSettlement");
            private static IList<IWebElement> otherTownOrVillageOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.HumanAltAddressContent + "ddlHumanAltidfsSettlement']/option")); } }
            private static By lblOtherStreetLocalAddress = By.Name("Street");
            private static By txtOtherStreetLocalAddress = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "txtHumanAltstrStreetName");
            private static By lblBuildingHouseApt = By.Name("Building/House/Apartment");
            private static By txtOtherHouse = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "txtHumanAltstrHouse");
            private static By txtOtherBuilding = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "txtHumanAltstrBuilding");
            private static By txtOtherApt = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "txtHumanAltstrApartment");
            private static By lblOtherPostalCode = By.Name("Postal Code");
            private static By ddlOtherPostalCode = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "ddlHumanAltidfsPostalCode");
            private static By lblOtherLongitudeLocalAddress = By.Name("Latitude");
            private static By txtOtherLatitudeLocalAddress = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "txtHumanAltstrLatitude");
            private static By lblOtherLatitudeLocalAddress = By.Name("Longitude");
            private static By txtOtherLongitudeLocalAddress = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "txtHumanAltstrLongitude");
            private static By txtOtherElevation = By.Id(CommonCtrls.AddUpdateHumanAddressContent + "txtHumanAltstrElevation");
            private static By lblLocalAddress = By.Name("Phone Number");
            private static By txtLocalAddress = By.Id(CommonCtrls.GeneralContent + "txtHumanstrCountryCodeandNumber");
            private static By ddlPhoneType = By.Id(CommonCtrls.GeneralContent + "ddlidfsPhoneType");
            private static IList<IWebElement> phoneTypeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsPhoneType']/option")); } }
            private static By lblAltAnotherAddressYes = By.Name("Yes");
            private static By radAltAnotherAddressYes = By.Id(CommonCtrls.GeneralContent + "rdbAnotherAddressYes");
            private static By lblAltAnotherAddressNo = By.Name("No");
            private static By radAltAnotherAddressNo = By.Id(CommonCtrls.GeneralContent + "rdbAnotherAddressNo");
            private static By radAltOtherPhoneUnknown = By.Id("anotherPhoneUnknown");
            private static By txtAltOther = By.Id(CommonCtrls.GeneralContent + "txtstrOtherCountryCodeandNumber");
            private static By ddlAltOtherPhoneType = By.Id(CommonCtrls.GeneralContent + "ddlidfsOtherPhoneType");
            private static By radAltOtherPhoneYes = By.Id(CommonCtrls.GeneralContent + "rdbAnotherAddressYes");
            private static By radAltOtherPhoneNo = By.Id(CommonCtrls.GeneralContent + "rdbAnotherAddressNo");



            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(personAddrFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(personAddrFormTitle).Text.Contains("Person Address") &&
                                Driver.Instance.FindElement(personAddrFormTitle).Displayed)
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

            public static void randomSelectCountry()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlCountry, countryOptions);
            }

            public static void randomSelectRegion()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlRegion, regionOptions);
                Thread.Sleep(1000);
            }

            public static void enterARegion(String value)
            {
                SetMethods.enterObjectValue(ddlRegion, value);
                Thread.Sleep(3000);
            }

            public static void clearField()
            {
                SetMethods.clearField(ddlRegion);
            }

            public static void randomSelectRayon()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlRayon, rayonOptions);
                Thread.Sleep(1000);
            }

            public static void enterARayon(String value)
            {
                SetMethods.enterObjectValue(ddlRayon, value);
                Thread.Sleep(2000);
            }

            public static void randomSelectTownOrVillage()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlTownOrVillage, townOrVillageOptions);
            }

            public static String enterStreetAddress(string addr)
            {
                int rNum = rnd.Next(10000, 99999);
                street = addr + rNum;
                SetMethods.enterObjectValue(txtStreetLocalAddress, street);
                return street;
            }

            public static void enterHouseNumber()
            {
                SetMethods.enterObjectValue(txtHouse, street);
            }

            public static void enterBuildingNumber()
            {
                SetMethods.enterObjectValue(txtBuilding, street);
            }

            public static void enterAptNumber()
            {
                SetMethods.enterObjectValue(txtApt, street);
            }

            public static void enterPostalCode()
            {
                int rNum = rnd.Next(10000, 99999);
                SetMethods.enterIntObjectValue(txtPostalCode, rNum);
            }

            public static void enterLongitude()
            {
                SetMethods.enterRandomMinLongitude(txtLongitudeLocalAddress);
            }

            public static void enterLatitude()
            {
                SetMethods.enterRandomMinLatitude(txtLatitudeLocalAddress);
            }

            //public static void enterPersonPhoneNumber()
            //{
            //    double rPhoneNum = rnd.Next(0, 1000000000);
            //    SetMethods.enterObjectValue(, String.Format("{0: (###) ###-####", rPhoneNum));
            //    var phone = wait.Until(ExpectedConditions.ElementIsVisible(txtPhoneNumberLocalAddress));
            //}

            public static void selectAnotherPhoneYes()
            {
                SetMethods.clickObjectButtons(radAnotherPhoneYes);
            }

            public static void selectAnotherPhoneNo()
            {
                SetMethods.clickObjectButtons(radAnotherPhoneNo);
            }

            public static void selectAnotherPhoneUnknown()
            {
                SetMethods.clickObjectButtons(radAnotherPhoneUnknown);
            }


            //OTHER ADDRESS SECTION

            public static void randomOtherSelectRegion()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlOtherRegion, otherRegionOptions);
            }

            public static void randomOtherSelectRayon()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlOtherRayon, otherRayonOptions);
            }

            public static void randomOtherSelectTownOrVillage()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlOtherTownOrVillage, otherTownOrVillageOptions);
            }

            public static String enterOtherStreetAddress(string addr)
            {
                int rNum = rnd.Next(10000, 99999);
                street = addr + rNum;
                SetMethods.enterObjectValue(txtOtherStreetLocalAddress, street);
                return street;
            }

            public static void enterOtherHouseNumber()
            {
                SetMethods.enterObjectValue(txtOtherHouse, street);
            }

            public static void enterOtherBuildingNumber()
            {
                SetMethods.enterObjectValue(txtOtherBuilding, street);
            }

            public static void enterOtherAptNumber()
            {
                SetMethods.enterObjectValue(txtOtherApt, street);
            }

            public static void enterOtherPostalCode()
            {
                int rNum = rnd.Next(10000, 99999);
                SetMethods.enterIntObjectValue(ddlOtherPostalCode, rNum);
            }

            public static void enterOtherLongitude()
            {
                SetMethods.enterRandomMinLongitude(txtLongitudeLocalAddress);
            }

            public static void enterOtherLatitude()
            {
                SetMethods.enterRandomMinLongitude(txtOtherLongitudeLocalAddress);
            }

            //public static void enterOtherPersonPhoneNumber()
            //{
            //    int rPhoneNum = rnd.Next(1000000000, 999999999);
            //    SetMethods.enterObjectValue(txtOther, String.Format("{0: (###) ###-####", rPhoneNum));               
            //}

            public static void selectOtherPhoneYes()
            {
                SetMethods.clickObjectButtons(radAltOtherPhoneYes);
            }

            public static void selectOtherPhoneNo()
            {
                SetMethods.clickObjectButtons(radAltOtherPhoneNo);
            }

            public static void selectOtherPhoneUnknown()
            {
                SetMethods.clickObjectButtons(radAltOtherPhoneUnknown);
            }

            public static void isThereAnotherAddressNo()
            {
                SetMethods.clickObjectButtons(radAnotherAddressNo);
            }

            public static void isThereAnotherAddressYes()
            {
                SetMethods.clickObjectButtons(radAnotherAddressYes);
            }

            public static void isThereAnotherPhoneNumberNo()
            {
                SetMethods.clickObjectButtons(radAnotherPhoneNo);
            }

            public static void isThereAnotherPhoneNumberYes()
            {
                SetMethods.clickObjectButtons(radAnotherPhoneYes);
            }

            public static void doesRayonErrorMessageDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(rayonErrorMsg);
            }

            public static void doesRegionErrorMessageDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(regionErrorMsg);
            }
        }

        public class PersonReview
        {
            private static By btnEditPersonInfo = By.XPath("//*[@id='EIDSSBodyCPH_personInformation']/div[1]/div[1]/div/div[2]/a");
            private static By btnEditPersonAddrAndPhn = By.XPath("//*[@id='EIDSSBodyCPH_personalAddress']/div/div[1]/div/div[2]/a");
            private static By subtitleFormTitle = By.XPath("//*[@id='divSelectablePreviewDiseaseList']/div[1]/div/div[1]/h3");
            private static By btnAddDiseaseRpt = By.Id(CommonCtrls.AddPersonUpdateContent + "btnAddSelectablePreviewHumanDiseaseReport");

            public class PersonInformation
            {
                private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.AddPersonUpdateContent + "PersonInformation']/div/div[1]/div/div[1]/h3");
                public static bool IsAt
                {
                    get
                    {
                        Driver.Instance.WaitForPageToLoad();
                        if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                            || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                        {
                            Assert.Fail("Page cannot be displayed");
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            return false;
                        }
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Person Information") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
                                    return true;
                                else
                                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                    Assert.Fail("This is not the correct title");
                                return false;
                            }
                        }
                        else
                        {
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            return false;
                        }
                    }
                }
            }

            public class PersonAddress
            {
                private static By subtitleFormTitle = By.XPath("//h3[contains(text(),'Person Address')]");
                public static bool IsAt
                {
                    get
                    {
                        Driver.Instance.WaitForPageToLoad();
                        if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                            || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                        {
                            Assert.Fail("Page cannot be displayed");
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            return false;
                        }
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Person Address") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
                                    return true;
                                else
                                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                    Assert.Fail("This is not the correct title");
                                return false;
                            }
                        }
                        else
                        {
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            return false;
                        }
                    }
                }
            }


            public class PersonEmploymentSchool
            {
                private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.AddPersonUpdateContent + "PersonEmploymentSchoolInformation']/div/div[1]/div/div[1]/h3");
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
                            Assert.Fail("Page cannot be displayed");
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            return false;
                        }
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Person Employment/School") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
                                    return true;
                                else
                                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                    Assert.Fail("This is not the correct title");
                                return false;
                            }
                        }
                        else
                        {
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            return false;
                        }
                    }
                }
            }

            public class OutbreakCaseReports
            {
                private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.AddPersonUpdateContent + "hdgOutbreakCaseReports']");
                private static By btnOutbreakCaseReport = By.XPath("//*[@id='" + CommonCtrls.AddPersonUpdateContent + "btnAddSelectablePreviewOutbreakCaseReport']");
                public static bool IsAt
                {
                    get
                    {
                        Driver.Instance.WaitForPageToLoad();
                        //Scroll to the bottom of the page
                        ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1200)", "");
                        if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                            || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                        {
                            Assert.Fail("Page cannot be displayed");
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            return false;
                        }
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Outbreak Case Reports") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
                                    return true;
                                else
                                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                    Assert.Fail("This is not the correct title");
                                return false;
                            }
                        }
                        else
                        {
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            return false;
                        }
                    }
                }

                public static void clickAddOutbreakCaseReport()
                {
                    SetMethods.clickObjectButtons(btnOutbreakCaseReport);
                }
            }

            public class Farms
            {
                private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.AddPersonUpdateContent + "hdgFarms']");
                public static bool IsAt
                {
                    get
                    {
                        Driver.Instance.WaitForPageToLoad();
                        //Scroll to the bottom of the page
                        ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 2500)", "");
                        Thread.Sleep(2000);
                        if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                            || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                        {
                            Assert.Fail("Page cannot be displayed");
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            return false;
                        }
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Farms") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
                                    return true;
                                else
                                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                    Assert.Fail("This is not the correct title");
                                return false;
                            }
                        }
                        else
                        {
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            return false;
                        }
                    }
                }
            }
            public class DiseaseReports
            {
                private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.AddPersonUpdateContent + "hdgHumanDiseaseReports']");
                public static bool IsAt
                {
                    get
                    {
                        Driver.Instance.WaitForPageToLoad();
                        //Scroll to the bottom of the page
                        ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1200)", "");
                        if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                            || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                        {
                            Assert.Fail("Page cannot be displayed");
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            return false;
                        }
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Disease Reports") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
                                    return true;
                                else
                                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                    Assert.Fail("This is not the correct title");
                                return false;
                            }
                        }
                        else
                        {
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            return false;
                        }
                    }
                }

                public static void clickAddDiseaseReport()
                {
                    SetMethods.clickObjectButtons(btnAddDiseaseRpt);
                }
            }
        }

        public class PersonConfirmationDialogue
        {

        }
    }
}