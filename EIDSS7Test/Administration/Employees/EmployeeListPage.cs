using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using System.Linq;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Threading;
using EIDSS7Test.Administration.Employees;
using EIDSS7Test.Navigation;
using OpenQA.Selenium.Interactions;


namespace EIDSS7Test.Administration.Employees
{
    public class EmployeeListPage
    {
        public static String lastName;
        public static String firstName;
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(360));
        public static int beforeCount;
        public static int afterCount;
        public static List<String> NewFormattedTitle;

        private static By HeaderFormTitle = By.TagName("h1");
        private static By titleFormTitle = By.XPath("//*[@id='frmMain']/div[3]/div/div[1]/div/div/div[1]/h2");
        private static By empDetailsTitle = By.XPath("/html/body/form/div[3]/div/div[1]/div/div/div[1]/h2");
        private static IJavaScriptExecutor executor = (IJavaScriptExecutor)Driver.Instance;


        //SEARCH PANEL
        private static By ddlPosition = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfPosition']");
        private static IList<IWebElement> posOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlPosition']/option")); } }
        private static By txtLastName = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "txtstrFamilyName']");
        private static By txtFirstName = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "txtstrFirstName']");
        private static By txtMiddleName = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "txtstrSecondName']");
        private static By ddlOrganization = By.Id(CommonCtrls.GeneralContent + "ddlOrganization");
        private static IList<IWebElement> orgOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlOrganization']/option")); } }
        private static By txtUniqueOrgID = By.Id(CommonCtrls.GeneralContent + "txtstrUniqueOrgID");

        //NEED TO ASK WHY THIS CLEAR BUTTON IS NOT SET LIKE THE OTHER BUTTONS
        //private static IWebElement btnClear { get { return Driver.Instance.FindElement(By.Id(CommonCtrls.GeneralContent + "Clear")); } }
        private static By btnClear = By.XPath("//input[@class='btn btn-default']");
        private static By btnSearchOnPanel = By.Id(CommonCtrls.GeneralContent + "btnSearch");


        //EMPLOYEE LIST     
        private static By tlbEmployeeList = By.Id(CommonCtrls.GeneralContent + "upEmployeeList");
        private static By lblLastName = By.Name("Last Name");
        private static By lblFirstName = By.Name("First Name");
        private static By lblMiddleName = By.Name("Middle Name");
        private static By lblAbbreviation = By.Name("Abbreviation");
        private static By lblOrgFullName = By.Name("Organization Full Name");
        private static By lblPosition = By.Name("Position");
        private static IList<IWebElement> tblRows { get { return Driver.Instance.FindElements(By.TagName("tr")); } }
        private static IList<IWebElement> tblColumns { get { return Driver.Instance.FindElements(By.TagName("td")); } }
        private static IList<IWebElement> btnEdits { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-edit']")); } }
        private static By btnEdit = By.XPath("//a[@class='btn glyphicon glyphicon-edit']");
        private static IList<IWebElement> btnDeletes { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-trash']")); } }
        private static By btnNew = By.Id(CommonCtrls.GeneralContent + "btnNew");
        private static By btnSearchOnList = By.XPath("//*[@id='btnOpenModal']/span[1]");
        private static By gvLastPage = By.XPath("//*[@id='EIDSSBodyCPH_gvEmployeeList']/tbody/tr[11]/td/table/tbody/tr/td[5]/a");
        private static IList<IWebElement> btnSelectEmpRecords { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-edit']")); } }
        private static By lblDeleteEmployeeMsg = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lblDeleteEmployee']");
        private static By btnPopupYes = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "btnDeleteYes']");
        private static By btnPopupNo = By.XPath("/html/body/form/div[3]/div/div[1]/div/div/div[2]/div/div/div[3]/button[2]");
        public static string searchResultsValue;

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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Employee List") &&
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

        public static void clickYesToDeleteEmployee()
        {
            SetMethods.clickObjectButtons(btnPopupYes);
        }

        public static void clickNoToDeleteEmployee()
        {
            SetMethods.clickObjectButtons(btnPopupNo);
        }

        public static void clickLastPageArrow()
        {
            SetMethods.clickObjectButtons(gvLastPage);
        }

        public static void clickAddNewEmployee()
        {
            SetMethods.clickObjectButtons(btnNew);
        }

        public static void clickSearchOnList()
        {
            Thread.Sleep(120);
            SetMethods.clickObjectButtons(btnSearchOnList);

            //Switch to new window
            string newWindowHandle = Driver.Instance.WindowHandles.Last();
            var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);
            Thread.Sleep(120);
        }

        public static void randomDeleteEmployee()
        {
            Driver.Wait(TimeSpan.FromMinutes(10));
            SetMethods.SelectRandomOptionFromDropdown(btnDeletes);
            Driver.Wait(TimeSpan.FromMinutes(10));
        }

        public static void randomEditEmployee()
        {
            Driver.Wait(TimeSpan.FromMinutes(10));
            SetMethods.SelectRandomOptionFromDropdown(btnEdits);
            Driver.Wait(TimeSpan.FromMinutes(10));
        }

        public static void randomSelectEmployee()
        {
            SetMethods.SelectRandomOptionFromDropdown(btnSelectEmpRecords);
            Thread.Sleep(2000);
        }

        public static void doesNewEmployeeDisplayInList()
        {
            IWebElement table = wait.Until(ExpectedConditions.ElementIsVisible(tlbEmployeeList));
            if (tblColumns.Count > 0)
            {
                foreach (IWebElement col in tblColumns)
                {
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    if (col.Text.Contains(EmployeeDetailsPage.firstname))
                    {
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        firstName = col.Text;
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        break;
                    }
                    else
                    {
                        //Fails test if name does not display in list
                        Assert.IsFalse(String.IsNullOrEmpty(firstName));
                    }
                }
            }
            else
            {
                //Fails test if name does not display in list
                Assert.IsFalse(String.IsNullOrEmpty(firstName));
            }
        }

        public static void doesDeleteEmployeeConfirmMsgDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(lblDeleteEmployeeMsg);
        }

        public static void manuallyEditEmployee(string employee)
        {
            var edit = wait.Until(ExpectedConditions.ElementIsVisible(btnEdit));
            foreach (IWebElement row in tblRows)
            {
                foreach (IWebElement col in tblColumns)
                {
                    if (col.Text.Contains(employee))
                    {
                        Actions builder = new Actions(Driver.Instance);
                        builder.MoveToElement(edit).Click();
                        Thread.Sleep(1000);
                        //col.Click();
                        break;
                    }
                    else
                    {
                        Assert.Fail();
                    }
                    break;
                }
                break;
            }
        }

        public static void manuallyDeleteEmployee()
        {
            Driver.Wait(TimeSpan.FromMinutes(120));
            var link = Driver.Instance.FindElement(By.XPath("/html/body/form/div[3]/div/div[1]/div/div/div[3]/div/div/table/tbody/tr[1]/td[8]/a/span"));
            link.Click();
            Thread.Sleep(2000);
        }

        public static void manuallyEditFirstEmployee()
        {
            Driver.Wait(TimeSpan.FromMinutes(120));
            var link = Driver.Instance.FindElement(By.XPath("//*[@id='EIDSSBodyCPH_gvEmployeeList']/tbody/tr/td[7]/a"));
            Driver.Wait(TimeSpan.FromMinutes(120));
            link.Click();
        }

        public static void manuallyEditEmployee()
        {
            //FOR FIREFOX - Need to search for table again
            By table = tlbEmployeeList;
            //var edit = wait.Until(ExpectedConditions.ElementIsVisible(btnEdit));
            //IList<IWebElement> links = Driver.Instance.FindElements(By.TagName("a"));

            foreach (IWebElement link in btnEdits)
            {
                Thread.Sleep(30);
                if (link.Displayed)
                {
                    Actions action = new Actions(Driver.Instance);
                    action.MoveToElement(link).Click().Perform();
                    Driver.Wait(TimeSpan.FromMinutes(20));
                    break;
                }
                else
                {
                    Console.WriteLine("Element does not exist.");
                }
                break;
            }
        }

        public static void doesEmployeeDisplayNewPosition()
        {
            Thread.Sleep(1000);
            if (tblColumns.Count > 0)
            {
                foreach (IWebElement col in tblColumns)
                {
                    Driver.Wait(TimeSpan.FromMinutes(20));
                    if (col.Text.Contains(EmployeeDetailsPage.pos))
                    {
                        Driver.Wait(TimeSpan.FromMinutes(20));
                        Console.WriteLine("Employee new position, " + EmployeeDetailsPage.pos + " displays in the list successfully.");
                    }
                }
            }
            else
            {
                //Fails test if name does not display in list
                Assert.IsFalse(String.IsNullOrEmpty(EmployeeDetailsPage.pos));
            }
        }

        public static void doesEmployeeRecordDisplayInList()
        {
            if (tblColumns.Count > 0)
            {
                foreach (IWebElement col in tblColumns)
                {
                    if (col.Text.Contains(SetMethods.newValue))
                    {
                        Console.WriteLine("Employee " + SetMethods.newValue + " was removed from list successfully.");
                        Assert.Pass();
                    }
                    break;
                }
            }
            else
            {
                //Fails test if name does not display in list
                //Redirect it to the login page for next test 
                //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail("An error occurred. Element could not be displayed.");
            }
        }

        public static void doesEmployeeDisplayNewOrganization()
        {

            if (tblColumns.Count > 0)
            {
                foreach (IWebElement col in tblColumns)
                {
                    if (col.Text.Contains(SetMethods.newValue))
                    {
                        Console.WriteLine("Employee new organization, " + SetMethods.newValue + " displays in the list successfully.");
                    }
                }
            }
            else
            {
                //Fails test if name does not display in list
                Assert.IsFalse(String.IsNullOrEmpty(SetMethods.newValue));
            }
        }

        public static int getCurCountOfEmployees()
        {
            //Return current count of employees in the list
            Driver.Wait(TimeSpan.FromMinutes(10));
            By element = tlbEmployeeList;
            IList<IWebElement> lists = Driver.Instance.FindElements(By.TagName("tr"));
            Driver.Wait(TimeSpan.FromMinutes(10));
            return beforeCount = lists.Count;
        }

        public static int getCountOfEmployees()
        {
            //Return count of employees after deletion
            Driver.Wait(TimeSpan.FromMinutes(10));
            By element = tlbEmployeeList;
            IList<IWebElement> lists = Driver.Instance.FindElements(By.TagName("tr"));
            Driver.Wait(TimeSpan.FromMinutes(10));
            return afterCount = lists.Count;
        }

        public static void getSearchResultsValue(String value)
        {
            try
            {
                IWebElement table = Driver.Instance.FindElement(tlbEmployeeList);
                IList<IWebElement> rows = table.FindElements(By.TagName("tr"));
                foreach (var row in rows)
                {
                    IList<IWebElement> cols = Driver.Instance.FindElements(By.TagName("td"));
                    foreach (var col in cols)
                    {
                        if (col.Text.Contains(value))
                        {
                            searchResultsValue = col.Text;
                            break;
                        }
                    }
                }
            }
            catch
            {
                //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail(value + " does not exist in the table.");
            }
        }

        public class SearchPanel
        {

            private void selectOption1InList(int element)
            {
                var selItemIndex = (long)((IJavaScriptExecutor)Driver.Instance).ExecuteScript("return arguments[0].selectedIndex;", element);
            }

            private static void selectNullValueToClear(By element, string value, IList<IWebElement> list)
            {
                var obj = wait.Until(ExpectedConditions.ElementIsVisible(element));
                Driver.Wait(TimeSpan.FromMinutes(10));
                obj.Click();

                foreach (var el in list)
                {
                    if (el.Text.Contains(value))
                    {
                        ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", el);
                        Thread.Sleep(120);
                        el.SendKeys(" ");
                    }
                    break;
                }
            }

            private static void selectNullValueToClear2(By element, int value, IList<IWebElement> list)
            {
                var obj = wait.Until(ExpectedConditions.ElementIsVisible(element));
                Driver.Wait(TimeSpan.FromMinutes(10));
                obj.Click();

                SelectElement selOpt = new SelectElement(obj);
                //Scroll back up to the top of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0,-250)", selOpt);
                selOpt.SelectByIndex(1);
                //var selItemIndex = (long)((IJavaScriptExecutor)Driver.Instance).ExecuteScript("return arguments[0].selectedIndex;", value);
            }

            public static void clearOrganizationField()
            {
                SetMethods.clearDropdownList(ddlOrganization);
            }

            public static void clearPositionField()
            {
                SetMethods.clearDropdownList(ddlPosition);
            }

            public static void clearFirstNameField()
            {
                SetMethods.clearField(txtFirstName);
            }

            public static void clearFamilyNameField()
            {
                SetMethods.clearField(txtLastName);
            }

            public static void clearOrgField()
            {
                SetMethods.clearField(ddlOrganization);
            }

            public static void clearOrganizationFieldBySelectOpt1()
            {
                selectNullValueToClear2(ddlOrganization, 1, orgOptions);
            }

            public static void selectRandomPosition()
            {
                SetMethods.randomSelectObjectElement(ddlPosition, posOptions);
            }

            public static String enterLastName(string LName)
            {
                Random rnd = new Random();
                int rNum = rnd.Next(1000, 1000000000);
                lastName = LName + rNum;
                SetMethods.enterStringObjectValue(txtLastName, lastName);
                return lastName;
            }

            public static void searchLastName(string LName)
            {
                SetMethods.enterObjectValue(txtLastName, LName);
            }

            public static void enterFirstName()
            {
                SetMethods.enterObjectValue(txtFirstName, EmployeeDetailsPage.firstname);
            }

            public static void enterFirstName(string value)
            {
                SetMethods.enterStringObjectValue(txtFirstName, value);
            }

            public static void searchFirstName()
            {
                SetMethods.enterObjectValue(txtFirstName, EmployeeDetailsPage.firstname);
            }

            public static void manuallyEnterFirstName(string FName)
            {
                SetMethods.enterObjectValue(txtFirstName, FName);
            }

            public static void enterMiddleName(string value)
            {
                SetMethods.enterObjectValue(txtMiddleName, value);
            }

            public static void enterEmployeeOrganization(string value)
            {
                SetMethods.enterObjectValue(ddlOrganization, value);
            }

            public static void selectRandomOrganization()
            {
                SetMethods.randomSelectObjectElement(ddlOrganization, orgOptions);
            }

            public static void enterUniqueOrgID(string value)
            {
                SetMethods.enterStringObjectValue(txtUniqueOrgID, value);
            }

            public static void enterEmployeePosition(string value)
            {
                SetMethods.enterStringObjectValue(ddlPosition, value);
            }

            public static void enterEmployeeFamilyName(string value)
            {
                SetMethods.enterStringObjectValue(txtLastName, value);
            }

            public static void enterEmployeeSecondName(string value)
            {
                SetMethods.enterStringObjectValue(txtMiddleName, value);
            }

            public static void enterEmployeeFirstName(string value)
            {
                SetMethods.enterStringObjectValue(txtFirstName, value);
            }

            public static void clickClear()
            {
                SetMethods.clickObjectButtons(btnClear);
                Driver.Instance.WaitForPageToLoad();
            }

            public static void clearDefaultOrgField()
            {
                //DEPRECIATED
                //The first option in the list is blank, select this option
                //foreach(IWebElement opt in orgOptions)
                //{
                //    if(opt.Text.Contains(" "))
                //    {
                //        opt.Click();
                //        Driver.Wait(TimeSpan.FromMinutes(10));
                //        break;
                //    }
                //}

                new SelectElement(Driver.Instance.FindElement(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlOrganization']"))).SelectByIndex(0);
            }

            public static void clickSearchOnPanel()
            {
                SetMethods.clickObjectButtons(btnSearchOnPanel);
                Driver.Instance.WaitForPageToLoad();

                //Switch to new window
                string newWindowHandle = Driver.Instance.WindowHandles.Last();
                var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);
                Driver.Instance.WaitForPageToLoad();
            }
        }

        public static void Add100NewEmployees()
        {
            for (int i = 0; i <= 100; i++)
            {

                //Navigate to System | Admininstration | Employees
                MainMenuNavigation.clickAdministration();
                MainMenuNavigation.Administration.clickEmployees();

                //Click the New button and enter required information
                EmployeeListPage.clickAddNewEmployee();
                EmployeeDetailsPage.PersonalInformation.randomEnterFirstName("Test");
                EmployeeDetailsPage.PersonalInformation.enterMiddleName();
                EmployeeDetailsPage.PersonalInformation.enterLastName();
                EmployeeDetailsPage.PersonalInformation.selectRandomOrganization();
                //EmployeeDetailsPage.PersonalInformation.selectNCDCPHOrg();
                EmployeeDetailsPage.PersonalInformation.selectRandomDepartment();
                EmployeeDetailsPage.PersonalInformation.selectRandomPosition();
                EmployeeDetailsPage.PersonalInformation.enterRandomPhoneNumber();

                //Click the Login tab
                EmployeeDetailsPage.clickLoginTab();
                Assert.IsTrue(EmployeeDetailsPage.Login.IsAt, "This is not the Login tab");
                EmployeeDetailsPage.Login.enterUserLogin();
                EmployeeDetailsPage.Login.enterPassword();
                EmployeeDetailsPage.Login.enterConfirmPassword();

                //Review record and submit
                EmployeeDetailsPage.clickReviewTab();
                EmployeeDetailsPage.clickSubmitButton();

                //IMPLEMENT WORKAROUND FOR ADDING MULTIPLE EMPLOYEES SINCE SUBMIT BUTTON DOES NOT RETURN FOCUS TO LIST PAGE
                MainMenuNavigation.clickEIDSSHomeLink();
            }
        }
    }
}