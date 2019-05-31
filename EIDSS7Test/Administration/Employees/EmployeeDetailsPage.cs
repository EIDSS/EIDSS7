using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using System.Threading;
using NUnit.Framework;
using OpenQA.Selenium.Interactions;

namespace EIDSS7Test.Administration.Employees
{
    public class EmployeeDetailsPage
    {
        public static String firstname;
        public static String middlename;
        public static String lastname;
        public static String groupName;
        public static String dept;
        public static String organization;
        public static String pos;
        public static String contactnum;
        public static string confirmPassword;
        public static string errorString;
        public static Random rnd = new Random();
        private static IJavaScriptExecutor executor = (IJavaScriptExecutor)Driver.Instance;
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(360));
        //private static IWebElement value = null;

        private static By titleFormTitle = By.TagName("h2");
        private static By HeaderFormTitle = By.TagName("h1");
        private static By loginSection = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "GroupsSection']/div/div[1]/div/div[1]/h3");
        private static By panelList = By.Id("panelList");
        private static By linkPersonalInfoTab = By.LinkText("Personal Information");
        private static By linkLoginTab = By.LinkText("Login");
        private static By linkGroupsTab = By.LinkText("Groups");
        private static By linkSystemFunctionsTab = By.XPath("//*[@id='panelList']/li[4]/a[2]");
        private static By linkReviewTab = By.LinkText("Review");
        private static By btnDelete = By.Id("btnDelete");
        private static By btnSave = By.Id("btnSave");
        private static By btnOK = By.Id("btnOK");
        private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancel");
        private static By btnContinue = By.Id(CommonCtrls.GeneralContent + "btnNextSection");
        private static By btnGoBack = By.Id(CommonCtrls.GeneralContent + "btnPreviousSection");
        private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmit");

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
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Employee Details") &&
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

        public static void clickPersonalInformationTab()
        {
            var element = wait.Until(ExpectedConditions.ElementIsVisible(linkPersonalInfoTab));
            element.Click();
            Driver.Wait(TimeSpan.FromMinutes(5));
        }

        public static void clickLoginTab()
        {
            SetMethods.clickObjectButtons(linkLoginTab);
        }

        public static void clickGroupsTab()
        {
            SetMethods.clickObjectButtons(linkGroupsTab);
        }

        public static void clickSystemFunctionsTab()
        {
            SetMethods.clickObjectButtons(linkSystemFunctionsTab);
        }

        public static void clickReviewTab()
        {
            SetMethods.clickObjectButtons(linkReviewTab);
        }

        public static void clickSaveButton()
        {
            SetMethods.clickObjectButtons(btnSave);
        }

        public static void clickOkButton()
        {
            SetMethods.clickObjectButtons(btnOK);
        }

        public static void clickCancelButton()
        {
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clickSubmitButton()
        {
            SetMethods.clickObjectButtons(btnSubmit);
        }

        public static void clickGoBackButton()
        {
            SetMethods.clickObjectButtons(btnGoBack);
        }

        public static void clickContinueButton()
        {
            SetMethods.clickObjectButtons(btnContinue);
        }

        public static void acceptMessage()
        {
            try
            {
                IAlert alert = Driver.Instance.SwitchTo().Alert();
                alert.Accept();
            }
            catch
            {
                Assert.Fail();
            }
        }

        public static void declineMessage()
        {
            try
            {
                IAlert alert = Driver.Instance.SwitchTo().Alert();
                alert.Dismiss(); ;
            }
            catch
            {
                Assert.Fail();
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

        public static bool doesEmployeeDataSavedAlertMessageDisplays()
        {
            try
            {
                string text = Driver.Instance.SwitchTo().Alert().Text;
                return true;
            }
            catch
            {
                return false;
            }
        }

        public class PersonalInformation
        {
            private static By subTitle = By.TagName("h3");
            private static By personalInfoSection = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "PersonalInformationSection']/div/div[1]/div/div[1]/h3");
            private static By txtFirstName = By.Id(CommonCtrls.GeneralContent + "txtstrFirstName");
            private static By txtMiddleName = By.Id(CommonCtrls.GeneralContent + "txtstrSecondName");
            private static By txtLastName = By.Id(CommonCtrls.GeneralContent + "txtstrFamilyName");
            private static By ddlOrganization = By.Id(CommonCtrls.GeneralContent + "ddlidfInstitution");
            private static IList<IWebElement> orgOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfInstitution']/option")); } }
            private static By ddlDepartment = By.Id(CommonCtrls.GeneralContent + "ddlidfDepartment");
            private static IList<IWebElement> deptOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfDepartment']/option")); } }
            private static By ddlPosition = By.Id(CommonCtrls.GeneralContent + "ddlidfsStaffPosition");
            private static IList<IWebElement> posOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsStaffPosition']/option")); } }
            private static By txtPhone = By.Id(CommonCtrls.GeneralContent + "txtstrContactPhone");
            private static By firstNameError = By.Id("EIDSSBodyCPH_ctl05");
            private static By familyNameError = By.Id("EIDSSBodyCPH_ctl12");
            private static By phoneNumberError = By.Id("EIDSSBodyCPH_ctl26");
            public static String FirstNameErrorMsg = "First Name is required.";
            public static String FamilyNameErrorMsg = "Family Name is required.";
            public static String PhoneNumberError = "Phone is required";


            public static bool doesPersonalInfoTabDisplay
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
                    else if (Driver.Instance.FindElements(personalInfoSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(personalInfoSection).Text.Contains("Personal Information") &&
                                Driver.Instance.FindElement(personalInfoSection).Displayed)
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


            public static string randomEnterFirstName(string FName)
            {
                Random rnd = new Random();
                int rNum = rnd.Next(1000, 10000000);
                firstname = FName + rNum;
                var element = wait.Until(ExpectedConditions.ElementIsVisible(txtFirstName));
                element.EnterText(firstname);
                Driver.Wait(TimeSpan.FromMinutes(5));
                return firstname;
            }

            public static string randomEnterFirstName_ClearField(string FName)
            {
                Random rnd = new Random();
                int rNum = rnd.Next(1000, 10000000);
                firstname = FName + rNum;
                var element = wait.Until(ExpectedConditions.ElementIsVisible(txtFirstName));
                element.EnterText(firstname);
                element.Clear();
                Driver.Wait(TimeSpan.FromMinutes(5));
                return firstname;

            }

            public static void clearField(By element)
            {
                var clear = wait.Until(ExpectedConditions.ElementIsVisible(element));
                clear.Clear();
                Driver.Wait(TimeSpan.FromMinutes(5));
            }

            public static void clearFamilyNameField()
            {
                clearField(txtLastName);
            }

            public static void clearPhoneNumberField()
            {
                clearField(txtPhone);
            }

            public static string enterMiddleName()
            {
                SetMethods.enterStringObjectValue(txtMiddleName, firstname);
                return middlename = firstname;
            }

            public static string enterLastName()
            {
                SetMethods.enterStringObjectValue(txtLastName, firstname);
                return lastname = firstname;
            }
            public static void selectRandomOrganization()
            {
                SetMethods.randomSelectObjectElement(ddlOrganization, orgOptions);
            }

            public static void selectNCDCPHOrg()
            {
                var org = wait.Until(ExpectedConditions.ElementIsVisible(ddlOrganization));
                Driver.Wait(TimeSpan.FromMinutes(10));
                org.Click();

                foreach (var opt in orgOptions)
                {
                    if (opt.Text.Contains("NCDC&PH"))
                    {
                        //wait.Until(ExpectedConditions.ElementIsVisible(opt));
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        opt.Click();
                        break;
                    }
                }
            }

            public static void selectRandomDepartment()
            {
                SetMethods.randomSelectObjectElement(ddlDepartment, deptOptions);
            }

            public static void selectRandomPosition()
            {
                SetMethods.randomSelectObjectElement(ddlPosition, posOptions);
            }


            private static String doesValidationErrorMessageDisplay(By element)
            {
                try
                {
                    Driver.Wait(TimeSpan.FromMinutes(20));
                    string text = wait.Until(ExpectedConditions.ElementIsVisible(element)).Text;
                    errorString = text;
                }
                catch
                {
                    //Fails the test if error message does not display
                    Assert.IsTrue(String.IsNullOrEmpty(errorString));
                }
                return errorString;
            }

            public static void doesFirstNameErrorMessageDisplay()
            {
                doesValidationErrorMessageDisplay(firstNameError);
            }

            public static void doesFamilyNameErrorMessageDisplay()
            {
                doesValidationErrorMessageDisplay(familyNameError);
            }

            public static void doesPhoneNumberErrorMessageDisplay()
            {
                doesValidationErrorMessageDisplay(phoneNumberError);
            }


            //DEPRECIATED
            public static void enterPhoneNumber()
            {
                double rPhoneNum = rnd.Next(0, 1000000000);
                SetMethods.enterObjectValue(txtPhone, String.Format("{0: (###) ###-####", rPhoneNum));
            }

            //NEW RANDOM PHONE GENERATOR
            public static string enterRandomPhoneNumber()
            {
                string phone = SetMethods.GetRandomTelNo();
                SetMethods.enterStringObjectValue(txtPhone, phone);
                return contactnum = phone;
            }

            public static String getEmployeeOrganization()
            {
                Thread.Sleep(5000);
                IWebElement dropDown = Driver.Instance.FindElement(ddlOrganization);
                SelectElement selectedVal = new SelectElement(dropDown);
                var element2 = selectedVal.SelectedOption.Text;
                Driver.Wait(TimeSpan.FromMinutes(1000));
                return organization = element2;
            }

            public static String getEmployeePosition()
            {
                Thread.Sleep(5000);
                IWebElement dropDown = Driver.Instance.FindElement(ddlPosition);
                SelectElement selectedVal = new SelectElement(dropDown);
                var element2 = selectedVal.SelectedOption.Text;
                Driver.Wait(TimeSpan.FromMinutes(1000));
                return pos = element2;
            }
        }


        public class Login
        {
            private static By loginSection = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "LoginSection']/div/div[1]/div/div[1]/h3");
            private static By txtUserLogin = By.Id(CommonCtrls.GeneralContent + "txtstrAccountName");
            private static By txtPassword = By.Id(CommonCtrls.GeneralContent + "txtPassword");
            private static By txtConfirmPassword = By.Id(CommonCtrls.GeneralContent + "txtPasswordConfirm");
            private static By btnContinue = By.Id(CommonCtrls.GeneralContent + "btnNextSection");
            private static By btnGoBack = By.Id(CommonCtrls.GeneralContent + "btnPreviousSection");
            private static By btnCancel = By.Id("btnCancel");
            private static By btnOKOnForm = By.Id("ctl00$EIDSSBodyCPH$ctl12");
            private static By btnCancelOnForm = By.Id("ctl00$EIDSSBodyCPH$ctl13");
            private static By loginErrorMsg = By.Id(CommonCtrls.GeneralContent + "ctl30");
            private static By passwordErrorMsg = By.Id(CommonCtrls.GeneralContent + "rfvbinPassword");
            private static By confirmPassErrorMsg = By.Id(CommonCtrls.GeneralContent + "rfvPasswordConfirm");
            public static String LoginError = "Login is required";
            public static String LoginPasswordError = "Password is required";
            public static String ConfirmLoginPasswordError = "Confirm Password is required.";

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
                    else if (Driver.Instance.FindElements(loginSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(loginSection).Text.Contains("Login") &&
                                Driver.Instance.FindElement(loginSection).Displayed)
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


            public static void enterUserLogin()
            {
                SetMethods.enterObjectValue(txtUserLogin, firstname);
            }

            public static void clearUserLoginField()
            {
                PersonalInformation.clearField(txtUserLogin);
            }
            public static void enterPassword()
            {
                SetMethods.enterObjectValue(txtPassword, firstname);
            }

            public static void clearUserPasswordField()
            {
                PersonalInformation.clearField(txtPassword);
            }
            public static void enterConfirmPassword()
            {
                SetMethods.enterObjectValue(txtConfirmPassword, firstname);
            }

            public static void clearConfirmPasswordField()
            {
                PersonalInformation.clearField(txtConfirmPassword);
            }

            public static void clickOKOnForm()
            {
                SetMethods.clickObjectButtons(btnOKOnForm);
            }


            public static void clickCancelOnForm()
            {
                SetMethods.clickObjectButtons(btnCancelOnForm);
            }

            public static void clickContinue()
            {
                SetMethods.clickObjectButtons(btnContinue);
            }

            public static void clickGoBack()
            {
                SetMethods.clickObjectButtons(btnGoBack);
            }

            public static void clickCancel()
            {
                SetMethods.clickObjectButtons(btnCancel);
            }

            public static void doesLoginInfoDisplay()
            {
                var element = wait.Until(ExpectedConditions.ElementIsVisible(txtUserLogin)).GetAttribute("value");
                if (element.Contains(firstname))
                {
                    Assert.IsTrue(true, "Login name displays successfully");
                }
                else
                {
                    //Fails test if name does not display in list
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Login name does not display");
                }
            }

            public static void doesLoginErrorMessageDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(loginErrorMsg);
            }

            public static void doesPasswordErrorMessageDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(passwordErrorMsg);
            }

            public static void doesConfirmPasswordErrorMessageDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(confirmPassErrorMsg);
            }
        }
        public class Groups
        {
            private static By subTitle = By.TagName("h3");
            private static By groupsSection = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "GroupsSection']/div/div[1]/div/div[1]/h3");
            private static By groupsTable = By.Id(CommonCtrls.GeneralContent + "gvEmployeeDetailsGroup");
            private static IList<IWebElement> multipleCheckboxes { get { return Driver.Instance.FindElements(By.XPath("//input[@type='checkbox']")); } }
            private static IList<IWebElement> tableRows { get { return Driver.Instance.FindElements(By.TagName("tr")); } }
            private static IList<IWebElement> tableCols { get { return Driver.Instance.FindElements(By.TagName("td")); } }
            private static By btnPrevious = By.Id(CommonCtrls.GeneralContent + "btnPreviousSection");
            private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancel");
            private static By btnContinue = By.Id(CommonCtrls.GeneralContent + "btnNextSection");
            private static By btnOK = By.Id(CommonCtrls.GeneralContent + "btnSubmit");
            private static By lblName = By.Id("Name");
            private static By lblDescription = By.Id("Description");
            private static By sysFunctSection = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "SystemFunctionsSection']/div/div[1]/div/div[1]/h3");
            private static By Admin = By.Id(CommonCtrls.EmpDetailsGrpContent + "chkCreate_0");
            private static By ChiefEpi = By.Id(CommonCtrls.EmpDetailsGrpContent + "chkCreate_1");
            private static By ChiefVet = By.Id(CommonCtrls.EmpDetailsGrpContent + "chkCreate_2");
            private static By Ento = By.Id(CommonCtrls.EmpDetailsGrpContent + "chkCreate_3");
            private static By Epi = By.Id(CommonCtrls.EmpDetailsGrpContent + "chkCreate_4");
            private static By LabChief = By.Id(CommonCtrls.EmpDetailsGrpContent + "chkCreate_5");
            private static By LabTech = By.Id(CommonCtrls.EmpDetailsGrpContent + "chkCreate_6");
            private static By Vet = By.Id(CommonCtrls.EmpDetailsGrpContent + "chkCreate_7");
            private static By tlbEmployeeGroups = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "gvEmployeeDetailsGroup']/tbody");
            private static IList<IWebElement> chkGroupCheckboxes { get { return Driver.Instance.FindElements(By.XPath("//input[@type='checkbox']")); } }

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
                    else if (Driver.Instance.FindElements(groupsSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(groupsSection).Text.Contains("Groups") &&
                                Driver.Instance.FindElement(groupsSection).Displayed)

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


            public static String getSelectedGroupName()
            {
                var table = groupsTable;
                string[] newList = new string[tableCols.Count];

                for (int i = 0; i < newList.Length; i++)
                {
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    newList[i] = tableCols[i].Text;
                    groupName = newList[0];
                    break;
                }
                return groupName;
            }


            public static void clickSave()
            {
                SetMethods.clickObjectButtons(btnSave);
            }
            public static void clickOK()
            {
                SetMethods.clickObjectButtons(btnOK);
            }

            public static void clickCancel()
            {
                SetMethods.clickObjectButtons(btnCancel);
            }

            public static void clickDelete()
            {
                SetMethods.clickObjectButtons(btnDelete);
            }

            public static void doesNewAssignedGroupDisplay()
            {
                if (tableCols.Count > 0)
                {
                    foreach (IWebElement col in tableCols)
                    {
                        if (col.Text.Contains(groupName))
                        {
                            Assert.IsTrue(true, "New group displays for employee successfully");
                            break;
                        }
                    }
                }
                else
                {
                    //Fails test if name does not display in list
                    Assert.IsFalse(String.IsNullOrEmpty(groupName));
                }
            }

            public static void selectRandomMultipleGroups()
            {
                IList<IWebElement> boxes = multipleCheckboxes;
                foreach (var box in boxes)
                {

                }
            }

            public static void randomSelectAGroup()
            {
                SetMethods.randomSelectObjectElement(tlbEmployeeGroups, multipleCheckboxes);
            }

            public static void selectEmployeeGroup(By element)
            {
                try
                {
                    var access = wait.Until(ExpectedConditions.ElementIsVisible(element));
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    access.Click();
                    Driver.Wait(TimeSpan.FromMinutes(10));
                }
                catch
                {
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", element);
                    var access = wait.Until(ExpectedConditions.ElementIsVisible(element));
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    access.Click();
                    Driver.Wait(TimeSpan.FromMinutes(10));
                }
            }

            public static By getAdminGrp()
            {
                return Admin;
            }

            public static By getChiefEpi()
            {
                return ChiefEpi;
            }

            public static By getChiefVet()
            {
                return ChiefVet;
            }

            public static By getEnto()
            {
                return Ento;
            }

            public static By getEpi()
            {
                return Epi;
            }

            public static By getLabChief()
            {
                return LabChief;
            }

            public static By getLabTech()
            {
                return LabTech;
            }

            public static By getVet()
            {
                return Vet;
            }

            public static By getTitle()
            {
                return subTitle;
            }


        }
        public class SystemFunctions
        {
            private static By sysFunctSection = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "SystemFunctionsSection']/div/div[1]/div/div[1]/h3");
            private static By chkRead_AccessToAggrSet = By.Id(CommonCtrls.SysFunctContent + "chkRead_0");
            private static By chkWrite_AccessToAggrSet = By.Id(CommonCtrls.SysFunctContent + "chkWrite_0");
            private static By chkCreate_AccessToAnalysisVisRpt = By.Id(CommonCtrls.SysFunctContent + "chkCreate_1");
            private static By chkRead_AccessToAnalysisVisRpt = By.Id(CommonCtrls.SysFunctContent + "chkRead_1");
            private static By chkWrite_AccessToAnalysisVisRpt = By.Id(CommonCtrls.SysFunctContent + "chkWrite_1");
            private static By chkDelete_AccessToAnalysisVisRpt = By.Id(CommonCtrls.SysFunctContent + "chkDelete_1");
            private static By chkExecute_CanDestroySamples = By.Id(CommonCtrls.SysFunctContent + "chkExecute_2");
            private static By chkExecute_CanValidateTestResults = By.Id(CommonCtrls.SysFunctContent + "chkExecute_3");
            private static By chkExecute_CanInterTestResult = By.Id(CommonCtrls.SysFunctContent + "chkExecute_4");
            private static By chkExecute_CanExecHumCaseDedup = By.Id(CommonCtrls.SysFunctContent + "chkExecute_5");
            private static By chkCreate_AccessToPersonsList = By.Id(CommonCtrls.SysFunctContent + "chkCreate_6");
            private static By chkRead_AccessToPersonsList = By.Id(CommonCtrls.SysFunctContent + "chkRead_6");
            private static By chkWrite_AccessToPersonsList = By.Id(CommonCtrls.SysFunctContent + "chkWrite_6");
            private static By chkDelete_AccessToPersonsList = By.Id(CommonCtrls.SysFunctContent + "chkDelete_6");
            private static By chkExecute_CanPerfSampTransfer = By.Id(CommonCtrls.SysFunctContent + "chkExecute_7");
            private static By chkCreate_AccessToStatList = By.Id(CommonCtrls.SysFunctContent + "chkCreate_8");
            private static By chkRead_AccessToStatList = By.Id(CommonCtrls.SysFunctContent + "chkRead_8");
            private static By chkWrite_AccessToStatList = By.Id(CommonCtrls.SysFunctContent + "chkWrite_8");
            private static By chkDelete_AccessToStatList = By.Id(CommonCtrls.SysFunctContent + "chkDelete_8");
            private static By chkCreate_AccessToSysFunctList = By.Id(CommonCtrls.SysFunctContent + "chkRead_9");
            private static By chkRead_AccessToSysFunctList = By.Id(CommonCtrls.SysFunctContent + "chkRead_9");
            private static By chkWrite_AccessToSysFunctList = By.Id(CommonCtrls.SysFunctContent + "chkWrite_9");
            private static By chkDelete_AccessToSysFunctList = By.Id(CommonCtrls.SysFunctContent + "chkRead_9");
            private static By chkCreate_CanManageUsrAccts = By.Id(CommonCtrls.SysFunctContent + "chkCreate_10");
            private static By chkRead_CanManageUsrAccts = By.Id(CommonCtrls.SysFunctContent + "chkRead_10");
            private static By chkWrite_CanManageUsrAccts = By.Id(CommonCtrls.SysFunctContent + "chkWrite_10");
            private static By chkDelete_CanManageUsrAccts = By.Id(CommonCtrls.SysFunctContent + "chkDelete_10");
            private static By chkCreate_CanManageRefTables = By.Id(CommonCtrls.SysFunctContent + "chkCreate_11");
            private static By chkRead_CanManageRefTables = By.Id(CommonCtrls.SysFunctContent + "chkRead_11");
            private static By chkWrite_CanManageRefTables = By.Id(CommonCtrls.SysFunctContent + "chkWrite_11");
            private static By chkDelete_CanManageRefTables = By.Id(CommonCtrls.SysFunctContent + "chkDelete_11");
            private static By chkRead_AccessToEventLog = By.Id(CommonCtrls.SysFunctContent + "chkRead_12");
            private static By chkCreate_AccessToFlexFormDesign = By.Id(CommonCtrls.SysFunctContent + "chkCreate_13");
            private static By chkRead_AccessToFlexFormDesign = By.Id(CommonCtrls.SysFunctContent + "chkRead_13");
            private static By chkWrite_AccessToFlexFormDesign = By.Id(CommonCtrls.SysFunctContent + "chkWrite_13");
            private static By chkDelete_AccessToFlexFormDesign = By.Id(CommonCtrls.SysFunctContent + "chkDelete_13");
            private static By chkRead_AccessToGISModule = By.Id(CommonCtrls.SysFunctContent + "chkRead_14");
            private static By chkRead_AccessToReports = By.Id(CommonCtrls.SysFunctContent + "chkRead_15");
            private static By chkExecute_CanPrintBarcodes = By.Id(CommonCtrls.SysFunctContent + "chkExecute_16");
            private static By chkRead_CanAccessObjNumSchema = By.Id(CommonCtrls.SysFunctContent + "chkRead_17");
            private static By chkWrite_CanAccessObjNumSchema = By.Id(CommonCtrls.SysFunctContent + "chkWrite_17");
            private static By chkCreate_CanAccessOrgList = By.Id(CommonCtrls.SysFunctContent + "chkCreate_18");
            private static By chkRead_CanAccessOrgList = By.Id(CommonCtrls.SysFunctContent + "chkRead_18");
            private static By chkWrite_CanAccessOrgList = By.Id(CommonCtrls.SysFunctContent + "chkWrite_18");
            private static By chkDelete_CanAccessOrgList = By.Id(CommonCtrls.SysFunctContent + "chkDelete_18");
            private static By chkCreate_CanAccessEmpListNoAccessRights = By.Id(CommonCtrls.SysFunctContent + "chkCreate_19");
            private static By chkRead_CanAccessEmpListNoAccessRights = By.Id(CommonCtrls.SysFunctContent + "chkRead_19");
            private static By chkWrite_CanAccessEmpListNoAccessRights = By.Id(CommonCtrls.SysFunctContent + "chkWrite_19");
            private static By chkDelete_CanAccessEmpListNoAccessRights = By.Id(CommonCtrls.SysFunctContent + "chkDelete_19");
            private static By chkCreate_CanManageRepoSchema = By.Id(CommonCtrls.SysFunctContent + "chkCreate_20");
            private static By chkRead_CanManageRepoSchema = By.Id(CommonCtrls.SysFunctContent + "chkRead_20");
            private static By chkWrite_CanManageRepoSchema = By.Id(CommonCtrls.SysFunctContent + "chkWrite_20");
            private static By chkDelete_CanManageRepoSchema = By.Id(CommonCtrls.SysFunctContent + "chkDelete_20");
            private static By chkRead_CanWorkWithAccessRightsMgmt = By.Id(CommonCtrls.SysFunctContent + "chkRead_21");
            private static By chkWrite_CanWorkWithAccessRightsMgmt = By.Id(CommonCtrls.SysFunctContent + "chkWrite_21");
            private static By chkCreate_CanManageUserGroups = By.Id(CommonCtrls.SysFunctContent + "chkCreate_22");
            private static By chkRead_CanManageUserGroups = By.Id(CommonCtrls.SysFunctContent + "chkRead_22");
            private static By chkWrite_CanManageUserGroups = By.Id(CommonCtrls.SysFunctContent + "chkWrite_22");
            private static By chkDelete_CanManageUserGroups = By.Id(CommonCtrls.SysFunctContent + "chkDelete_22");
            private static By chkCreate_AccessToHumanCaseData = By.Id(CommonCtrls.SysFunctContent + "chkCreate_23");
            private static By chkRead_AccessToHumanCaseData = By.Id(CommonCtrls.SysFunctContent + "chkRead_23");
            private static By chkWrite_AccessToHumanCaseData = By.Id(CommonCtrls.SysFunctContent + "chkWrite_23");
            private static By chkDelete_AccessToHumanCaseData = By.Id(CommonCtrls.SysFunctContent + "chkDelete_23");
            private static By chkAccessToPersonData_AccessToHumanCaseData = By.Id(CommonCtrls.SysFunctContent + "chkAccToPersonData_23");
            private static By chkCreate_AccessToVetCaseData = By.Id(CommonCtrls.SysFunctContent + "chkCreate_24");
            private static By chkRead_AccessToVetCaseData = By.Id(CommonCtrls.SysFunctContent + "chkRead_24");
            private static By chkWrite_AccessToVetCaseData = By.Id(CommonCtrls.SysFunctContent + "chkWrite_24");
            private static By chkDelete_AccessToVetCaseData = By.Id(CommonCtrls.SysFunctContent + "chkDelete_24");
            private static By chkAccessToPersonData_AccessToVetCaseData = By.Id(CommonCtrls.SysFunctContent + "chkAccToPersonData_24");
            private static By chkCreate_AccessToLabSamples = By.Id(CommonCtrls.SysFunctContent + "chkCreate_25");
            private static By chkRead_AccessToLabSamples = By.Id(CommonCtrls.SysFunctContent + "chkRead_25");
            private static By chkWrite_AccessToLabSamples = By.Id(CommonCtrls.SysFunctContent + "chkWrite_25");
            private static By chkDelete_AccessToLabSamples = By.Id(CommonCtrls.SysFunctContent + "chkDelete_25");
            private static By chkCreate_AccessToLabTests = By.Id(CommonCtrls.SysFunctContent + "chkCreate_26");
            private static By chkRead_AccessToLabTests = By.Id(CommonCtrls.SysFunctContent + "chkRead_26");
            private static By chkWrite_AccessToLabTests = By.Id(CommonCtrls.SysFunctContent + "chkWrite_26");
            private static By chkDelete_AccessToLabTests = By.Id(CommonCtrls.SysFunctContent + "chkDelete_26");
            private static By chkRead_AccessToEIDSSSitesList = By.Id(CommonCtrls.SysFunctContent + "chkRead_27");
            private static By chkWrite_AccessToEIDSSSitesList = By.Id(CommonCtrls.SysFunctContent + "chkWrite_27");
            private static By chkRead_CanManageSiteAlerts = By.Id(CommonCtrls.SysFunctContent + "chkRead_28");
            private static By chkWrite_CanManageSiteAlerts = By.Id(CommonCtrls.SysFunctContent + "chkWrite_28");
            private static By chkCreate_AccessToOutbreaks = By.Id(CommonCtrls.SysFunctContent + "chkCreate_29");
            private static By chkRead_AccessToOutbreaks = By.Id(CommonCtrls.SysFunctContent + "chkRead_29");
            private static By chkWrite_AccessToOutbreaks = By.Id(CommonCtrls.SysFunctContent + "chkWrite_29");
            private static By chkDelete_AccessToOutbreaks = By.Id(CommonCtrls.SysFunctContent + "chkDelete_29");
            private static By chkExecute_AccessToReplDataCmd = By.Id(CommonCtrls.SysFunctContent + "chkExecute_30");
            private static By chkExecute_CanPerfSampleAccessIn = By.Id(CommonCtrls.SysFunctContent + "chkExecute_31");
            private static By chkExecute_AccessToAVRAdmin = By.Id(CommonCtrls.SysFunctContent + "chkExecute_32");
            private static By chkRead_AccessToDataAudit = By.Id(CommonCtrls.SysFunctContent + "chkRead_33");
            private static By chkWrite_AccessToDataAudit = By.Id(CommonCtrls.SysFunctContent + "chkWrite_33");
            private static By chkRead_AccessToSecurityLog = By.Id(CommonCtrls.SysFunctContent + "chkRead_34");
            private static By chkRead_AccessToSecurityPolicy = By.Id(CommonCtrls.SysFunctContent + "chkRead_35");
            private static By chkWrite_AccessToSecurityPolicy = By.Id(CommonCtrls.SysFunctContent + "chkWrite_35");
            private static By chkCreate_AccessToActiveSurvCamp = By.Id(CommonCtrls.SysFunctContent + "chkCreate_36");
            private static By chkRead_AccessToActiveSurvCamp = By.Id(CommonCtrls.SysFunctContent + "chkRead_36");
            private static By chkWrite_AccessToActiveSurvCamp = By.Id(CommonCtrls.SysFunctContent + "chkWrite_36");
            private static By chkDelete_AccessToActiveSurvCamp = By.Id(CommonCtrls.SysFunctContent + "chkDelete_36");
            private static By chkCreate_AccessToActiveSurvSess = By.Id(CommonCtrls.SysFunctContent + "chkCreate_37");
            private static By chkRead_AccessToActiveSurvSess = By.Id(CommonCtrls.SysFunctContent + "chkRead_37");
            private static By chkWrite_AccessToActiveSurvSess = By.Id(CommonCtrls.SysFunctContent + "chkWrite_37");
            private static By chkDelete_AccessToActiveSurvSess = By.Id(CommonCtrls.SysFunctContent + "chkDelete_37");
            private static By chkExecute_CanImportExpData = By.Id(CommonCtrls.SysFunctContent + "chkExecute_38");
            private static By chkCreate_AccessToVectorSurvSess = By.Id(CommonCtrls.SysFunctContent + "chkCreate_39");
            private static By chkRead_AccessToVectorSurvSess = By.Id(CommonCtrls.SysFunctContent + "chkRead_39");
            private static By chkWrite_AccessToVectorSurvSess = By.Id(CommonCtrls.SysFunctContent + "chkWrite_39");
            private static By chkDelete_AccessToVectorSurvSess = By.Id(CommonCtrls.SysFunctContent + "chkDelete_39");
            private static By chkExecute_CanAmmendATest = By.Id(CommonCtrls.SysFunctContent + "chkExecute_40");
            private static By chkExecute_CanAddTestResultsForCaseSess = By.Id(CommonCtrls.SysFunctContent + "chkExecute_41");
            private static By chkExecute_CanReadArchData = By.Id(CommonCtrls.SysFunctContent + "chkExecute_42");
            private static By chkExecute_CanRestoreDeletedRecords = By.Id(CommonCtrls.SysFunctContent + "chkExecute_43");
            private static By chkExecute_CanSignReport = By.Id(CommonCtrls.SysFunctContent + "chkExecute_44");
            private static By chkCreate_CanManageGISRefTables = By.Id(CommonCtrls.SysFunctContent + "chkCreate_45");
            private static By chkRead_CanManageGISRefTables = By.Id(CommonCtrls.SysFunctContent + "chkRead_45");
            private static By chkWrite_CanManageGISRefTables = By.Id(CommonCtrls.SysFunctContent + "chkWrite_45");
            private static By chkDelete_CanManageGISRefTables = By.Id(CommonCtrls.SysFunctContent + "chkDelete_45");
            private static By chkCreate_AccessToBasicSynSurvMod = By.Id(CommonCtrls.SysFunctContent + "chkCreate_46");
            private static By chkRead_AccessToBasicSynSurvMod = By.Id(CommonCtrls.SysFunctContent + "chkRead_46");
            private static By chkWrite_AccessToBasicSynSurvMod = By.Id(CommonCtrls.SysFunctContent + "chkWrite_46");
            private static By chkDelete_AccessToBasicSynSurvMod = By.Id(CommonCtrls.SysFunctContent + "chkDelete_46");
            private static By chkCreate_AccessToHumanAggrCases = By.Id(CommonCtrls.SysFunctContent + "chkCreate_47");
            private static By chkRead_AccessToHumanAggrCases = By.Id(CommonCtrls.SysFunctContent + "chkRead_47");
            private static By chkWrite_AccessToHumanAggrCases = By.Id(CommonCtrls.SysFunctContent + "chkWrite_47");
            private static By chkDelete_AccessToHumanAggrCases = By.Id(CommonCtrls.SysFunctContent + "chkDelete_47");
            private static By chkCreate_AccessToVetAggrCases = By.Id(CommonCtrls.SysFunctContent + "chkCreate_48");
            private static By chkRead_AccessToVetAggrCases = By.Id(CommonCtrls.SysFunctContent + "chkRead_48");
            private static By chkWrite_AccessToVetAggrCases = By.Id(CommonCtrls.SysFunctContent + "chkWrite_48");
            private static By chkDelete_AccessToVetAggrCases = By.Id(CommonCtrls.SysFunctContent + "chkDelete_48");
            private static By chkCreate_AccessToVetAggrActions = By.Id(CommonCtrls.SysFunctContent + "chkCreate_49");
            private static By chkRead_AccessToVetAggrActions = By.Id(CommonCtrls.SysFunctContent + "chkRead_49");
            private static By chkWrite_AccessToVetAggrActions = By.Id(CommonCtrls.SysFunctContent + "chkWrite_49");
            private static By chkDelete_AccessToVetAggrActions = By.Id(CommonCtrls.SysFunctContent + "chkDelete_49");
            private static By chkExecute_CanReopenClosedCase = By.Id(CommonCtrls.SysFunctContent + "chkExecute_50");
            private static By chkCreate_AccessToFarmsData = By.Id(CommonCtrls.SysFunctContent + "chkCreate_51");
            private static By chkRead_AccessToFarmsData = By.Id(CommonCtrls.SysFunctContent + "chkRead_51");
            private static By chkWrite_AccessToFarmsData = By.Id(CommonCtrls.SysFunctContent + "chkWrite_51");
            private static By chkDelete_AccessToFarmsData = By.Id(CommonCtrls.SysFunctContent + "chkDelete_51");
            private static By chkExecute_CanFinalizeLabTest = By.Id(CommonCtrls.SysFunctContent + "chkExecute_52");
            private static By chkExecute_UseSimpHumanCaseRptForm = By.Id(CommonCtrls.SysFunctContent + "chkExecute_53");


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
                    else if (Driver.Instance.FindElements(sysFunctSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(sysFunctSection).Text.Contains("System Functions") &&
                                Driver.Instance.FindElement(sysFunctSection).Displayed)
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


            public static void selectAccessToActiveSurvCampaign_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_AccessToActiveSurvCamp);
            }

            public static void selectAccessToActiveSurvCampaign_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToActiveSurvCamp);
            }

            public static void selectAccessToActiveSurvCampaign_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToActiveSurvCamp);
            }

            public static void selectAccessToActiveSurvCampaign_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_AccessToActiveSurvCamp);
            }

            public static void selectAccessToActiveSurvSession_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_AccessToActiveSurvSess);
            }

            public static void selectAccessToActiveSurvSession_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToActiveSurvSess);
            }

            public static void selectAccessToActiveSurvSession_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToActiveSurvSess);
            }

            public static void selectAccessToActiveSurvSession_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_AccessToActiveSurvSess);
            }

            public static void selectAccessToAggregateSettings_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToAggrSet);
            }

            public static void selectAccessToAggregateSettings_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToAggrSet);
            }

            public static void selectAccessToAnalysisVisualAndReport_AVR_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_AccessToAnalysisVisRpt);
            }

            public static void selectAccessToAnalysisVisualAndReport_AVR_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToAnalysisVisRpt);
            }

            public static void selectAccessToAnalysisVisualAndReport_AVR_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToAnalysisVisRpt);
            }

            public static void selectAccessToAnalysisVisualAndReport_AVR_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_AccessToAnalysisVisRpt);
            }

            public static void selectAccessToAVRAdministration_Execute()
            {
                SetMethods.clickObjectButtons(chkExecute_AccessToAVRAdmin);
            }

            public static void selectAccessToBasicSyndSurvMod_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_AccessToBasicSynSurvMod);
            }

            public static void selectAccessToBasicSyndSurvMod_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToBasicSynSurvMod);
            }

            public static void selectAccessToBasicSyndSurvMod_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToBasicSynSurvMod);
            }

            public static void selectAccessToBasicSyndSurvMod_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_AccessToBasicSynSurvMod);
            }

            public static void selectAccessToDataAudit_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToDataAudit);
            }

            public static void selectAccessToDataAudit_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToDataAudit);
            }

            public static void selectAccessToEIDSSSitesList_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToEIDSSSitesList);
            }

            public static void selectAccessToEIDSSSitesLis_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToEIDSSSitesList);
            }

            public static void selectAccessToEventLog_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToEventLog);
            }


            public static void selectAccessToFarmsData_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_AccessToFarmsData);
            }

            public static void selectAccessToFarmsData_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToFarmsData);
            }

            public static void selectAccessToFarmsData_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToFarmsData);
            }

            public static void selectAccessToFarmsData_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_AccessToFarmsData);
            }


            public static void selectAccessToFlexFormsDesign_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_AccessToFlexFormDesign);
            }

            public static void selectAccessToFlexFormsDesign_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToFlexFormDesign);
            }

            public static void selectAccessToFlexFormsDesign_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToFlexFormDesign);
            }

            public static void selectAccessToFlexFormsDesign_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_AccessToFlexFormDesign);
            }

            public static void selectAccessToGISModule_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToGISModule);
            }

            public static void selectAccessToHumanAggrCases_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_AccessToHumanAggrCases);
            }

            public static void selectAccessToHumanAggrCases_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToHumanAggrCases);
            }

            public static void selectAccessToHumanAggrCases_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToHumanAggrCases);
            }

            public static void selectAccessToHumanAggrCases_Delete()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToHumanAggrCases);
            }

            public static void selectAccessToHumanCasesData_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_AccessToHumanCaseData);
            }

            public static void selectAccessToHumanCasesData_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToHumanCaseData);
            }

            public static void selectAccessToHumanCasesData_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToHumanCaseData);
            }

            public static void selectAccessToHumanCasesData_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_AccessToHumanCaseData);
            }

            public static void selectAccessToLaboratorySamples_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_AccessToLabSamples);
            }

            public static void selectAccessToLaboratorySamples_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToLabSamples);
            }

            public static void selectAccessToLaboratorySamples_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToLabSamples);
            }

            public static void selectAccessToLaboratorySamples_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_AccessToLabSamples);
            }

            public static void selectAccessToLaboratoryTests_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_AccessToLabTests);
            }

            public static void selectAccessToLaboratoryTests_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToLabTests);
            }

            public static void selectAccessToLaboratoryTests_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToLabTests);
            }

            public static void selectAccessToLaboratoryTests_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_AccessToLabTests);
            }

            public static void selectAccessToOutbreaks_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_AccessToOutbreaks);
            }

            public static void selectAccessToOutbreaks_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToOutbreaks);
            }

            public static void selectAccessToOutbreaks_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToOutbreaks);
            }

            public static void selectAccessToOutbreaks_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_AccessToOutbreaks);
            }

            public static void selectAccessToPersonsList_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_AccessToPersonsList);
            }

            public static void selectAccessToPersonsList_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToPersonsList);
            }

            public static void selectAccessToPersonsList_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToPersonsList);
            }

            public static void selectAccessToPersonsList_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_AccessToPersonsList);
            }

            public static void selectAccessToRepliDataCMD_Execute()
            {
                SetMethods.clickObjectButtons(chkExecute_AccessToReplDataCmd);
            }

            public static void selectAccessToReports_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToReports);
            }

            public static void selectAccessToSecurityLog_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToSecurityLog);
            }

            public static void selectAccessToSecurityPolicy_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToSecurityPolicy);
            }

            public static void selectAccessToSecurityPolicy_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToSecurityPolicy);
            }

            public static void selectAccessToStatisticsList_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_AccessToStatList);
            }

            public static void selectAccessToStatisticsList_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToStatList);
            }

            public static void selectAccessToStatisticsList_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToStatList);
            }

            public static void selectAccessToStatisticsList_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_AccessToStatList);
            }

            public static void selectAccessToSysFunctList_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_AccessToSysFunctList);
            }

            public static void selectAccessToSysFunctList_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToSysFunctList);
            }

            public static void selectAccessToSysFunctList_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToSysFunctList);
            }

            public static void selectAccessToSysFunctList_Delete()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToSysFunctList);
            }

            public static void selectAccessToVectorSurvSession_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_AccessToVectorSurvSess);
            }

            public static void selectAccessToVectorSurvSession_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToVectorSurvSess);
            }

            public static void selectAccessToVectorSurvSession_Write()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToVectorSurvSess);
            }

            public static void selectAccessToVectorSurvSession_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_AccessToVectorSurvSess);
            }


            public static void selectAccessToVetAggrActions_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_AccessToVetAggrActions);
            }

            public static void selectAccessToVetAggrActions_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToVetAggrActions);
            }

            public static void selectAccessToVetAggrActions_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToVetAggrActions);
            }

            public static void selectAccessToVetAggrActions_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_AccessToVetAggrActions);
            }

            public static void selectAccessToVetAggrCases_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_AccessToSysFunctList);
            }

            public static void selectAccessToVetAggrCases_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToVetAggrCases);
            }

            public static void selectAccessToVetAggrCases_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToVetAggrCases);
            }

            public static void selectAccessToVetAggrCases_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_AccessToVetAggrCases);
            }

            public static void selectAccessToVetCasesData_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_AccessToVetCaseData);
            }

            public static void selectAccessToVetCasesData_Read()
            {
                SetMethods.clickObjectButtons(chkRead_AccessToVetCaseData);
            }

            public static void selectAccessToVetCasesData_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_AccessToVetCaseData);
            }

            public static void selectAccessToVetCasesData_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_AccessToVetCaseData);
            }

            public static void selectCanAccessEmployeeList_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_CanAccessEmpListNoAccessRights);
            }

            public static void selectCanAccessEmployeeList_Read()
            {
                SetMethods.clickObjectButtons(chkRead_CanAccessEmpListNoAccessRights);
            }

            public static void selectCanAccessEmployeeList_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_CanAccessEmpListNoAccessRights);
            }

            public static void selectCanAccessEmployeeList_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_CanAccessEmpListNoAccessRights);
            }

            public static void selectCanObjectNumberSchema_Read()
            {
                SetMethods.clickObjectButtons(chkRead_CanAccessObjNumSchema);
            }

            public static void selectCanObjectNumberSchema_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_CanAccessObjNumSchema);
            }

            public static void selectCanAccessOrganizationsList_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_CanAccessOrgList);
            }

            public static void selectCanAccessOrganizationsList_Read()
            {
                SetMethods.clickObjectButtons(chkRead_CanAccessOrgList);
            }

            public static void selectCanAccessOrganizationsList_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_CanAccessOrgList);
            }

            public static void selectCanAccessOrganizationsList_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_CanAccessOrgList);
            }

            public static void selectCanAddTestResultsForACaseSess_Execute()
            {
                SetMethods.clickObjectButtons(chkExecute_CanAddTestResultsForCaseSess);
            }

            public static void selectCanAmmendATest_Execute()
            {
                SetMethods.clickObjectButtons(chkExecute_CanAmmendATest);
            }

            public static void selectCanDetroySamples_Execute()
            {
                SetMethods.clickObjectButtons(chkExecute_CanDestroySamples);
            }

            public static void selectCanExecuteHumanCaseDedupFunct_Execute()
            {
                SetMethods.clickObjectButtons(chkExecute_CanExecHumCaseDedup);
            }

            public static void selectCanFinalizeLabTest_Execute()
            {
                SetMethods.clickObjectButtons(chkExecute_CanFinalizeLabTest);
            }

            public static void selectCanImportExportData_Execute()
            {
                SetMethods.clickObjectButtons(chkExecute_CanImportExpData);
            }

            public static void selectCanInterTestResult_Execute()
            {
                SetMethods.clickObjectButtons(chkExecute_CanInterTestResult);
            }

            public static void selectCanManageGISRefTables_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_CanManageGISRefTables);
            }

            public static void selectCanManageGISRefTables_Read()
            {
                SetMethods.clickObjectButtons(chkRead_CanManageGISRefTables);
            }

            public static void selectCanManageGISRefTables_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_CanManageGISRefTables);
            }

            public static void selectCanManageGISRefTables_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_CanManageGISRefTables);
            }

            public static void selectCanManageReferenceTables_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_CanManageRefTables);
            }

            public static void selectCanManageReferenceTables_Read()
            {
                SetMethods.clickObjectButtons(chkRead_CanManageRefTables);
            }

            public static void selectCanManageReferenceTables_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_CanManageRefTables);
            }

            public static void selectCanManageReferenceTables_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_CanManageRefTables);
            }

            public static void selectCanManageRepositorySchema_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_CanManageRepoSchema);
            }

            public static void selectCanManageRepositorySchema_Read()
            {
                SetMethods.clickObjectButtons(chkRead_CanManageRepoSchema);
            }

            public static void selectCanManageRepositorySchema_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_CanManageRepoSchema);
            }

            public static void selectCanManageRepositorySchema_Delete()
            {
                SetMethods.clickObjectButtons(chkCreate_CanManageGISRefTables);
            }

            public static void selectCanManageSitesAlertsSubscript_Read()
            {
                SetMethods.clickObjectButtons(chkRead_CanManageSiteAlerts);
            }

            public static void selectCanManageSitesAlertsSubscript_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_CanManageSiteAlerts);
            }

            public static void selectCanManageUserAccounts_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_CanManageUsrAccts);
            }

            public static void selectCanManageUserAccounts_Read()
            {
                SetMethods.clickObjectButtons(chkRead_CanManageUsrAccts);
            }

            public static void selectCanManageUserAccounts_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_CanManageUsrAccts);
            }

            public static void selectCanManageUserAccounts_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_CanManageUsrAccts);
            }

            public static void selectCanManageUserGroups_Create()
            {
                SetMethods.clickObjectButtons(chkCreate_CanManageUserGroups);
            }

            public static void selectCanManageUserGroups_Read()
            {
                SetMethods.clickObjectButtons(chkRead_CanManageUserGroups);
            }

            public static void selectCanManageUserGroups_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_CanManageUserGroups);
            }

            public static void selectCanManageUserGroups_Delete()
            {
                SetMethods.clickObjectButtons(chkDelete_CanManageUserGroups);
            }

            public static void selectCanPerfromSampleAssessIn_Execute()
            {
                SetMethods.clickObjectButtons(chkExecute_CanPerfSampleAccessIn);
            }

            public static void selectCanPerformSampleTransfer_Execute()
            {
                SetMethods.clickObjectButtons(chkExecute_CanPerfSampTransfer);
            }

            public static void selectCanPrintBarcodes_Execute()
            {
                SetMethods.clickObjectButtons(chkExecute_CanPrintBarcodes);
            }

            public static void selectCanReadArchivedData_Execute()
            {
                SetMethods.clickObjectButtons(chkExecute_CanReadArchData);
            }

            public static void selectCanReopenClosedCase_Execute()
            {
                SetMethods.clickObjectButtons(chkExecute_CanReopenClosedCase);
            }

            public static void selectCanRestoreDeletedRecords_Execute()
            {
                SetMethods.clickObjectButtons(chkExecute_CanRestoreDeletedRecords);
            }

            public static void selectCanSignReport_Execute()
            {
                SetMethods.clickObjectButtons(chkExecute_CanSignReport);
            }

            public static void selectCanValidateTestRsultInterp_Execute()
            {
                SetMethods.clickObjectButtons(chkExecute_CanValidateTestResults);
            }

            public static void selectCanWorkWithAccessRightMgmt_Read()
            {
                SetMethods.clickObjectButtons(chkRead_CanWorkWithAccessRightsMgmt);
            }

            public static void selectCanWorkWithAccessRightMgmt_Write()
            {
                SetMethods.clickObjectButtons(chkWrite_CanWorkWithAccessRightsMgmt);
            }

            public static void selectUseSimplifiedHumanCaseRptForm_Execute()
            {
                SetMethods.clickObjectButtons(chkExecute_UseSimpHumanCaseRptForm);
            }
        }
    }
}