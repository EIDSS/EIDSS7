using EIDSS7Test.Selenium;
using EIDSS7Test.Common;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using System;
using System.Collections.Generic;

using NUnit.Framework;

namespace EIDSS7Test.Outbreaks
{
    public class CreateOutbreakPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(320));
        private static Random rnd = new Random();
        public static String longCommentString = "jljjououaofuoufouaoufoiaofjnlznkznknfnnfanfaf08097975927491710810890418jfajflaflanflaknf,anf,mjflkjaljfj0808080&$^#@%#$$%&^*&(ljljljfljlsjfljowuoqu7r97(^%%$&lnlnalfnlanflalkfkjalfjlahlaljflajfljfjolau&(&(&9796827972959775972597275927927597927592597797579";
        public static string street;
        public static string outBreakID;
        private static By titleFormTitle = By.TagName("h2");
        private static By HeaderFormTitle = By.TagName("h1");
        private static By btnSubmit = By.Id("bSubmit");
        private static By btnNext = By.Id("bNext");
        private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "bCancel");
        public static string getElementValue;
        private static int rNum = rnd.Next(1, 365);

        public static Boolean isFieldEnabled(By element)
        {
            try
            {
                var rayon = wait.Until(ExpectedConditions.ElementToBeClickable(element));
                rayon.GetAttribute("enabled");
                return true;
            }
            catch (Exception)
            {
                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail("Field is not enabled");
                return false;
            }
        }

        public static Boolean isFieldChecked(By element)
        {
            try
            {
                var rayon = wait.Until(ExpectedConditions.ElementExists(element)).GetAttribute("checked");
                return true;
            }
            catch (Exception)
            {
                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail("Field is not checked");
                return false;
            }
        }

        public static Boolean isFieldUnChecked(By element)
        {
            try
            {
                var rayon = wait.Until(ExpectedConditions.ElementExists(element));
                if (!rayon.Selected)
                {
                    return true;
                }
            }
            catch (Exception)
            {
                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail("Field is checked");
                return false;
            }
            return true;
        }

        private static String getRecordElementValue(By element)
        {
            var ID = Driver.Instance.FindElement(element).Text;
            Driver.Wait(TimeSpan.FromMinutes(20));
            return getElementValue = ID;
        }

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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Create Outbreak") &&
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
                    Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again." + e.Message);
                    return false;
                }
            }
        }

        public static void clickSubmit()
        {
            //Scroll to the bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            SetMethods.clickObjectButtons(btnSubmit);
        }

        public static void clickCancel()
        {
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clickNext()
        {
            SetMethods.clickObjectButtons(btnNext);
        }

        public class OutbreakInfo
        {
            private static By outbreakInfoSection = By.TagName("h3");
            private static By datStartDate = By.Id(CommonCtrls.GeneralContent + "cliStartDate");
            private static By datCloseDate = By.Id(CommonCtrls.GeneralContent + "cliCloseDate");
            private static By ddlDiagnosesGroup = By.Id(CommonCtrls.GeneralContent + "ddlidfsDiagnosisOrDiagnosisGroup");
            private static IList<IWebElement> diagGrpOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsDiagnosisOrDiagnosisGroup']/option")); } }
            private static By ddlOutbreakStatus = By.Id(CommonCtrls.GeneralContent + "ddlidfsOutbreakStatus");
            private static IList<IWebElement> outStatOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsOutbreakStatus']/option")); } }
            private static By ddlOutbreakType = By.Id(CommonCtrls.GeneralContent + "ddlOutbreakTypeId");
            private static IList<IWebElement> outTypeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlOutbreakTypeId']/option")); } }
            public static By ddlRegion = By.Id(CommonCtrls.OutbreakLocContent + "ddloutbreakLocationidfsRegion");
            private static IList<IWebElement> regionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.OutbreakLocContent + "ddloutbreakLocationidfsRegion']/option")); } }
            public static By ddlRayon = By.Id(CommonCtrls.OutbreakLocContent + "ddloutbreakLocationidfsRayon");
            private static IList<IWebElement> rayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.OutbreakLocContent + "ddloutbreakLocationidfsRayon']/option")); } }
            public static By ddlTownOrVillage = By.Id(CommonCtrls.OutbreakLocContent + "ddloutbreakLocationidfsSettlement");
            private static IList<IWebElement> townOrVillageOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.OutbreakLocContent + "ddloutbreakLocationidfsSettlement']/option")); } }
            private static By chkBxHuman = By.Id(CommonCtrls.GeneralContent + "idfscbHuman");
            private static By chkBxAvian = By.Id(CommonCtrls.GeneralContent + "idfscbAvian");
            private static By chkBxLivestock = By.Id(CommonCtrls.GeneralContent + "idfscbLivestock");
            private static By chkBxVector = By.Id(CommonCtrls.GeneralContent + "idfscbVector");
            private static By speciesAffErrorMsg = By.Id("dSpeciesAffectedError");
            private static By outTypeErrorMsg = By.Id(CommonCtrls.GeneralContent + "ctl44");
            private static By outStatErrorMsg = By.Id(CommonCtrls.LocationUsrContent + "ctl47");
            private static By diseaseErrorMsg = By.Id(CommonCtrls.LocationUsrContent + "ctl50");
            private static By startDateErrorMsg = By.Id(CommonCtrls.LocationUsrContent + "ctl41");
            private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancel");
            private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmit");
            public static String speciesAffectMsg = "At least one other selection must be made.";
            public static String outbreakStatMsg = "Outbreak Status is required";
            public static String outbreakTypeMsg = "Outbreak Type is required";
            public static String outbreakDiseaseMsg = "Disease is required";
            public static String outbreakStartDte = "Start Date is required";

            public static object fieldSessionID;

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
                    else if (Driver.Instance.FindElement(outbreakInfoSection).Text.Contains("Error:"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(outbreakInfoSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(outbreakInfoSection).Text.Contains("Outbreak Information") &&
                                Driver.Instance.FindElement(outbreakInfoSection).Displayed)
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

            public static void randomSelectRegion()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlRegion, regionOptions);
            }

            public static void randomSelectRayon()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlRayon, rayonOptions);
            }

            public static void randomSelectTownOrVillage()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlTownOrVillage, townOrVillageOptions);
            }

            public static void randomSelectOutbreakType()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlOutbreakType, outTypeOptions);
            }

            public static void enterOutbreakType(string value)
            {
                SetMethods.enterObjectValue(ddlOutbreakType, value);
            }

            public static void randomSelectOutbreakStatus()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlOutbreakStatus, outStatOptions);
            }

            public static void enterOutbreakStatus(string value)
            {
                SetMethods.enterObjectValue(ddlOutbreakStatus, value);
            }

            public static void randomSelectDisease()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlDiagnosesGroup, diagGrpOptions);
            }

            public static void enterDisease(string value)
            {
                SetMethods.enterObjectValue(ddlDiagnosesGroup, value);
            }

            public static void clearDateField()
            {
                SetMethods.clearField(datStartDate);
            }

            public static void doesStartDateErrorMessageDisplay()
            {
                try
                {
                    SetMethods.doesValidationErrorMessageDisplay(startDateErrorMsg);
                }
                catch
                {
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", startDateErrorMsg);
                    SetMethods.doesValidationErrorMessageDisplay(startDateErrorMsg);
                }
            }

            public static void doesSpeciesAffectedErrorMsgDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(speciesAffErrorMsg);
            }

            public static void doesOutbreakStatusErrorMsgDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(outStatErrorMsg);
            }

            public static void doesDiseaseErrorMsgDisplay()
            {
                SetMethods.doesValidationErrorMessageDisplay(diseaseErrorMsg);
            }

            public static void isHumanSpeciesAffectedChecked()
            {
                isFieldChecked(chkBxHuman);
            }

            public static void isHumanSpeciesAffectedDisabled()
            {
                SetMethods.isFieldDisabled(chkBxHuman);
            }

            public static void isHumanSpeciesAffectedUnChecked()
            {
                isFieldUnChecked(chkBxHuman);
            }

            public static void isAvianSpeciesAffectedChecked()
            {
                isFieldChecked(chkBxAvian);
            }

            public static void isAvianSpeciesAffectedUnChecked()
            {
                isFieldUnChecked(chkBxAvian);
            }

            public static void isAvianSpeciesAffectedDisabled()
            {
                SetMethods.isFieldDisabled(chkBxAvian);
            }

            public static void isLivestockSpeciesAffectedChecked()
            {
                isFieldChecked(chkBxLivestock);
            }

            public static void isLivestockSpeciesAffectedUnChecked()
            {
                isFieldUnChecked(chkBxLivestock);
            }

            public static void isLivestockSpeciesAffectedDisabled()
            {
                SetMethods.isFieldDisabled(chkBxLivestock);
            }

            public static void isVectorSpeciesAffectedChecked()
            {
                isFieldChecked(chkBxVector);
            }

            public static void isVectorSpeciesAffectedUnChecked()
            {
                isFieldUnChecked(chkBxVector);
            }

            public static void isVectorSpeciesAffectedDisabled()
            {
                SetMethods.isFieldDisabled(chkBxVector);
            }

            public static void clickHumanCheckbox()
            {
                SetMethods.clickObjectButtons(chkBxHuman);
            }

            public static void clickAvianCheckbox()
            {
                SetMethods.clickObjectButtons(chkBxAvian);
            }

            public static void clickLivestockCheckbox()
            {
                SetMethods.clickObjectButtons(chkBxLivestock);
            }

            public static void clickVectorCheckbox()
            {
                SetMethods.clickObjectButtons(chkBxVector);
            }
        }

        public class OutbreakParameters
        {
            private static By outbreakParmSection = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "dOutbreakHeading']/h3");
            private static By btnContToQuestYES = By.Id("rbQuestionnaireYes");
            private static By btnContToQuestNO = By.Id("rbQuestionnaireNo");

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
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElement(outbreakParmSection).Text.Contains("Error:"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(outbreakParmSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(outbreakParmSection).Text.Contains("Outbreak Parameters") &&
                                Driver.Instance.FindElement(outbreakParmSection).Displayed)
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

            public static void clickQuestionnaireYES()
            {
                SetMethods.clickObjectButtons(btnContToQuestYES);
            }

            public static void clickQuestionnaireNO()
            {
                SetMethods.clickObjectButtons(btnContToQuestNO);
            }

            public class HumanParameters
            {
                private static By txtCaseMonitorDur = By.Id("ensHumanCaseMonitoringDuration");
                private static By txtCaseMonitorFreq = By.Id("ensHumanCaseMonitoringFrequency");
                private static By txtContactTraceDur = By.Id("ensHumanContactTracingDuration");
                private static By txtContactTraceFreq = By.Id("ensHumanContactTracingFrequency");


                public static void randomEnterCaseMonitorDuration()
                {
                    SetMethods.enterIntObjectValue(txtCaseMonitorDur, rNum);
                }

                public static void randomEnterCaseMonitorFrequency()
                {
                    SetMethods.enterIntObjectValue(txtCaseMonitorFreq, rNum);
                }

                public static void randomEnterContactTracingDuration()
                {
                    SetMethods.enterIntObjectValue(txtContactTraceDur, rNum);
                }

                public static void randomEnterContactTracingFrequency()
                {
                    SetMethods.enterIntObjectValue(txtContactTraceFreq, rNum);
                }
            }

            public class AvianParameters
            {
                private static By txtCaseMonitorDur = By.Id("ensxAvianCaseMonitoringDuration");
                private static By txtCaseMonitorFreq = By.Id("ensxAvianCaseMonitoringFrequency");
                private static By txtContactTraceDur = By.Id("ensxAvianContactTracingDuration");
                private static By txtContactTraceFreq = By.Id("ensxAvianContactTracingFrequency");


                public static void randomEnterCaseMonitorDuration()
                {
                    SetMethods.enterIntObjectValue(txtCaseMonitorDur, rNum);
                }

                public static void randomEnterCaseMonitorFrequency()
                {
                    SetMethods.enterIntObjectValue(txtCaseMonitorFreq, rNum);
                }

                public static void randomEnterContactTracingDuration()
                {
                    SetMethods.enterIntObjectValue(txtContactTraceDur, rNum);
                }

                public static void randomEnterContactTracingFrequency()
                {
                    SetMethods.enterIntObjectValue(txtContactTraceFreq, rNum);
                }
            }

            public class LivestockParameters
            {
                private static By txtCaseMonitorDur = By.Id("ensLivestockCaseMonitoringDuration");
                private static By txtCaseMonitorFreq = By.Id("ensLivestockCaseMonitoringFrequency");
                private static By txtContactTraceDur = By.Id("ensLivestockContactTracingDuration");
                private static By txtContactTraceFreq = By.Id("ensLivestockContactTracingFrequency");


                public static void randomEnterCaseMonitorDuration()
                {
                    SetMethods.enterIntObjectValue(txtCaseMonitorDur, rNum);
                }

                public static void randomEnterCaseMonitorFrequency()
                {
                    SetMethods.enterIntObjectValue(txtCaseMonitorFreq, rNum);
                }

                public static void randomEnterContactTracingDuration()
                {
                    SetMethods.enterIntObjectValue(txtContactTraceDur, rNum);
                }

                public static void randomEnterContactTracingFrequency()
                {
                    SetMethods.enterIntObjectValue(txtContactTraceFreq, rNum);
                }
            }

            public class ZoonoticParameters
            {
                private static By txtCaseMonitorDur = By.Id("ensxVectorCaseMonitoringDuration");
                private static By txtCaseMonitorFreq = By.Id("ensxVectorCaseMonitoringFrequency");
                private static By txtContactTraceDur = By.Id("ensxVectorContactTracingDuration");
                private static By txtContactTraceFreq = By.Id("ensxVectorContactTracingFrequency");


                public static void randomEnterCaseMonitorDuration()
                {
                    SetMethods.enterIntObjectValue(txtCaseMonitorDur, rNum);
                }

                public static void randomEnterCaseMonitorFrequency()
                {
                    SetMethods.enterIntObjectValue(txtCaseMonitorFreq, rNum);
                }

                public static void randomEnterContactTracingDuration()
                {
                    SetMethods.enterIntObjectValue(txtContactTraceDur, rNum);
                }

                public static void randomEnterContactTracingFrequency()
                {
                    SetMethods.enterIntObjectValue(txtContactTraceFreq, rNum);
                }
            }
        }

        public class OutbreakSession
        {
            private static By titleFormTitle = By.TagName("h2");

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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Outbreak Session") &&
                                Driver.Instance.FindElement(titleFormTitle).Displayed)
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

            public class OutbreakSummary
            {
                private static By outbreakSummSection = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "outbreakInfoHeading']");
                private static By lblOutbreakID = By.Id(CommonCtrls.GeneralContent + "lblstrOutbreakID");


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
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("Page cannot be displayed");
                            return false;
                        }
                        else if (Driver.Instance.FindElement(outbreakSummSection).Text.Contains("Error:"))
                        {
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                            return false;
                        }
                        else if (Driver.Instance.FindElements(titleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(outbreakSummSection).Text.Contains("Outbreak Summary") &&
                                    Driver.Instance.FindElement(outbreakSummSection).Displayed)
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

                public static void getOutbreakIDValue()
                {
                    getRecordElementValue(lblOutbreakID);
                }

                public static void isOutbreakSessionIDPopulated()
                {
                    SetMethods.isFieldPopulatedWithText(lblOutbreakID);
                }

                public class Cases
                {
                    private static By btnImportCase = By.Id("bImportCase");
                    private static By btnCreateCase = By.Id("bCreateCase");
                    private static By rdoHuman = By.Id(CommonCtrls.GeneralContent + "rblCreateCase_0");
                    private static By rdoVeterinary = By.Id(CommonCtrls.GeneralContent + "rblCreateCase_1");

                    public static void clickCreateCase()
                    {
                        SetMethods.clickObjectButtons(btnCreateCase);
                    }

                    public static void clickImportCase()
                    {
                        SetMethods.clickObjectButtons(btnImportCase);
                    }

                    public static void clickHuman()
                    {
                        SetMethods.clickObjectButtons(rdoHuman);
                    }

                    public static void clickVeterinary()
                    {
                        SetMethods.clickObjectButtons(rdoVeterinary);
                    }
                }
            }
        }

        //public static void selectExactAddress()
        //{
        //    SetMethods.clickObjectButtons(radAddrExact);
        //}

        //public static void selectRelativeAddress()
        //{
        //    SetMethods.clickObjectButtons(radAddrRelative);
        //}

        //public static void selectForeignAddress()
        //{
        //    SetMethods.clickObjectButtons(radAddrForeign);
        //}

        //public static void randomSelectCountry()
        //{
        //    SetMethods.RandomSelectDropdownListObjectWithRetry(ddlCountry, countryOptions);
        //}


        //public static String enterStreetAddress(string addr)
        //{
        //    int rNum = rnd.Next(1, 10000);
        //    street = rNum + addr;
        //    SetMethods.enterStringObjectValue(txtStreet, street);
        //    return street;
        //}

        //public static void enterHouseNumber()
        //{
        //    SetMethods.enterStringObjectValue(txtHouse, street);
        //}

        //public static void enterBuildingNumber()
        //{
        //    SetMethods.enterStringObjectValue(txtBuilding, street);
        //}

        //public static void enterAptNumber()
        //{
        //    SetMethods.enterStringObjectValue(txtApartment, street);
        //}

        //public static void enterPostalCode()
        //{
        //    int rNum = rnd.Next(10000, 99999);
        //    SetMethods.enterIntObjectValue(ddlPostalCode, rNum);
        //}

        //public static void clickSubmit()
        //{
        //    SetMethods.clickObjectButtons(btnSubmit);
        //}

        //public static void enterRandomLatitude()
        //{
        //    try
        //    {
        //        var lat = wait.Until(ExpectedConditions.ElementToBeClickable(txtLatitude));
        //        lat.EnterDoubleAmount(Convert.ToDouble("-41." + SetMethods.RandomDoubleNum()));
        //    }
        //    catch
        //    {
        //        ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", txtLatitude);
        //        var lat = wait.Until(ExpectedConditions.ElementToBeClickable(txtLatitude));
        //        lat.EnterDoubleAmount(Convert.ToDouble("-41." + SetMethods.RandomDoubleNum()));
        //    }
        //}

        ////public static String enterRandomOutbreakID(string outbreak)
        ////{
        ////    try
        ////    {
        ////        int rNum = rnd.Next(0, 100000000);
        ////        string ID = outbreak + rNum;

        ////        var sessionID = wait.Until(ExpectedConditions.ElementToBeClickable(txt));
        ////        sessionID.EnterText(ID);
        ////        Driver.Wait(TimeSpan.FromMinutes(20));
        ////        return outBreakID = ID;
        ////    }
        ////    catch
        ////    {
        ////        ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", txtFieldSessionID);
        ////        int rNum = rnd.Next(0, 100000000);
        ////        string ID = session + rNum;

        ////        var sessionID = wait.Until(ExpectedConditions.ElementToBeClickable(txtFieldSessionID));
        ////        sessionID.EnterText(ID);
        ////        Driver.Wait(TimeSpan.FromMinutes(20));
        ////        return fieldSessionID = session;
        ////    }
        ////}


        //public static void enterDescription()
        //{
        //    SetMethods.enterStringObjectValue(txtDescription, longCommentString);
        //}

        //public static void enterForeignTypeDescription()
        //{
        //    SetMethods.enterStringObjectValue(txtForeignAddrType, longCommentString);
        //}

        //public static void enterRandomStartDate()
        //{
        //    SetMethods.enterCurrentDate(datStartDate);
        //}

        //public static void enterRandomCloseDate()
        //{
        //    SetMethods.enterCurrentDate(datCloseDate);
        //}

        //public static void clearCloseDateField()
        //{
        //    var closeDate = wait.Until(ExpectedConditions.ElementToBeClickable(datCloseDate));
        //    closeDate.Clear();
        //}

        //public static void enterRandomLongitude()
        //{
        //    try
        //    {
        //        var lg = wait.Until(ExpectedConditions.ElementToBeClickable(txtLongitude));
        //        lg.EnterDoubleAmount(Convert.ToDouble("44." + SetMethods.RandomDoubleNum()));
        //    }
        //    catch
        //    {
        //        ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", txtLongitude);
        //        var lg = wait.Until(ExpectedConditions.ElementToBeClickable(txtLongitude));
        //        lg.EnterDoubleAmount(Convert.ToDouble("44." + SetMethods.RandomDoubleNum()));
        //    }
        //}

        //public static void enterDescriptionOfLocation()
        //{
        //    SetMethods.enterStringObjectValue(txtLocDescription, longCommentString);
        //}

        //public static void randomSelectGroundType()
        //{
        //    SetMethods.RandomSelectDropdownListObjectWithRetry(ddlGroundType, groundTypeOptions);
        //}

        //public static void enterDistance()
        //{
        //    int rNum = rnd.Next(1, 100);
        //    SetMethods.enterIntObjectValue(txtDistance, rNum);
        //}

        //public static void enterDirection()
        //{
        //    int rNum = rnd.Next(1, 100);
        //    SetMethods.enterIntObjectValue(txtDirection, rNum);
        //}
    }
}
