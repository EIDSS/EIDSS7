using System;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Linq;
using System.Collections.Generic;

namespace EIDSS7Test.Veterinary.AvianAvianDiseaseRpt
{
    public class CreateAvianAvianDiseaseRptPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();
        public static string farmNM;
        public static string farmID;
        public static string street;

        private static By titleFormTitle = By.TagName("h2");
        private static By HeaderFormTitle = By.TagName("h1");
        private static By farmTitleFormTitle = By.XPath("/html/body/form/div[3]/div/div[2]/div/div[1]/div/div/div[2]/div[2]/div/div[2]/section[1]/div/div[1]/div/div[1]/h3");
        private static By linkFarmDetails = By.LinkText("Farm Details");
        private static By linkNotification = By.LinkText("Notification");
        private static By linkFarmFlockSpecies = By.LinkText("Farm/Flock/Species");
        private static By linkFarmEpi = By.LinkText("Farm Epidemiological Info");
        private static By linkSpeciesInvest = By.LinkText("Species Investigation");
        private static By linkVaccineInfo = By.LinkText("Vaccination Information");
        private static By linkCtrlMeasuresInfo = By.LinkText("Control Measures");
        private static By linkSamples = By.LinkText("Samples");
        private static By linkPensideTests = By.LinkText("Penside Tests");
        private static By linkLabTestInterp = By.LinkText("Lab Test/Interpretation");
        private static By linkCaseLog = By.LinkText("Case Log");
        private static By linkReview = By.LinkText("Review");

        private static By btnNext = By.Id(CommonCtrls.GeneralContent + "btnNextSection");


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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Avian Disease Report") &&
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
                    Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again." + e.Message);
                    return false;
                }
            }
        }

        public static void clickFarmDetailsLink()
        {
            SetMethods.clickObjectButtons(linkFarmDetails);
        }

        public static void clickNotificationLink()
        {
            SetMethods.clickObjectButtons(linkNotification);
        }

        public static void clickFarmFlockSpeciesLink()
        {
            SetMethods.clickObjectButtons(linkFarmFlockSpecies);
        }

        public static void clickFarmEpiInfoLink()
        {
            SetMethods.clickObjectButtons(linkFarmEpi);
        }

        public static void clickSpeciesInvestLink()
        {
            SetMethods.clickObjectButtons(linkSpeciesInvest);
        }

        public static void clickVaccineInfoLink()
        {
            SetMethods.clickObjectButtons(linkVaccineInfo);
        }

        public static void clickContrMeasureInfoLink()
        {
            SetMethods.clickObjectButtons(linkCtrlMeasuresInfo);
        }


        public static void clickSamplesLink()
        {
            SetMethods.clickObjectButtons(linkSamples);
        }

        public static void clickPensideTestsLink()
        {
            SetMethods.clickObjectButtons(linkPensideTests);
        }

        public static void clickLabTestsInterpretLink()
        {
            SetMethods.clickObjectButtons(linkLabTestInterp);
        }

        public static void clickCaseLogLink()
        {
            SetMethods.clickObjectButtons(linkCaseLog);
        }

        public static void clickReviewLink()
        {
            SetMethods.clickObjectButtons(linkReview);
        }

        public static void clickNextToNotificationTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            SetMethods.clickObjectButtons(btnNext);
        }

        public static void clickNextToFarmFlockSpeciesTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 1; i++)
            {
                SetMethods.clickObjectButtons(btnNext);
            }
        }

        public static void clickNextToFarmEpiInfoTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 2; i++)
            {
                SetMethods.clickObjectButtons(btnNext);
            }
        }

        public static void clickNextToSpeciesInvestTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 3; i++)
            {
                SetMethods.clickObjectButtons(btnNext);
            }
        }

        public static void clickNextToVaccineInfoTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 4; i++)
            {
                SetMethods.clickObjectButtons(btnNext);
            }
        }

        public static void clickNextToSamplesTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 5; i++)
            {
                SetMethods.clickObjectButtons(btnNext);
            }
        }

        public static void clickNextToPensideTestsTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 6; i++)
            {
                SetMethods.clickObjectButtons(btnNext);
            }
        }

        public static void clickNextToLabTestInterpretTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 7; i++)
            {
                SetMethods.clickObjectButtons(btnNext);
            }
        }

        public static void clickNextToCaseLogTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 8; i++)
            {
                SetMethods.clickObjectButtons(btnNext);
            }
        }

        public static void clickNextToReviewTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 9; i++)
            {
                SetMethods.clickObjectButtons(btnNext);
            }
        }

        public class DiseaseReportSummary
        {
            private static By subtitleFormTitle = By.TagName("h3");

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
                    else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
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
                        return false;
                    }
                }
            }
        }

        public class FarmDetails
        {
            private static By farmTitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "FarmDetails']/div/div[1]/div/div[1]/h3");
            //*[@id="EIDSSBodyCPH_FarmDetails']/div/div[1]/div/div[1]/h3

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
                    else if (Driver.Instance.FindElements(farmTitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(farmTitleFormTitle).Text.Contains("Farm Details") &&
                                Driver.Instance.FindElement(farmTitleFormTitle).Displayed)
                                return true;
                            else
                                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
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
        }

        public class Notification
        {
            private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "Notification']/div/div[1]/div/div[1]/h3");
            private static By ddlOrganization = By.Id(CommonCtrls.GeneralContent + "ddlReportedByOrganizationID");
            private static IList<IWebElement> orgOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlReportedByOrganizationID']/option")); } }
            private static By ddlReportedBy = By.Id(CommonCtrls.GeneralContent + "ddlReportedByPersonID");
            private static IList<IWebElement> rptByOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlReportedByPersonID']/option")); } }
            private static By datInitRptDate = By.Id(CommonCtrls.GeneralContent + "txtReportDate");
            private static By ddlInvestOrg = By.Id(CommonCtrls.GeneralContent + "ddlInvestigatedByOrganizationID");
            private static IList<IWebElement> investOrgOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlInvestigatedByOrganizationID']/option")); } }
            private static By ddlInvestName = By.Id(CommonCtrls.GeneralContent + "ddlInvestigatedByPersonID");
            private static IList<IWebElement> investNameOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlInvestigatedByPersonID']/option")); } }
            private static By datAssignedDate = By.Id(CommonCtrls.GeneralContent + "txtAssignedDate");
            private static By datInvestDate = By.Id(CommonCtrls.GeneralContent + "txtInvestigationDate");


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
                    else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Notification") &&
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
                        return false;
                    }
                }
            }
        }

        public class FarmFlockSpecies
        {
            private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "upFarmFlockSpecies']/div/div[1]/div/div[1]/h3");
            private static By btnAddFLock = By.Id(CommonCtrls.GeneralContent + "btnAddFlock");
            private static By btnUpdateSpecies = By.Id(CommonCtrls.GeneralContent + "btnUpdateSpecies");
            //*[@id="EIDSSBodyCPH_upFarmFlockSpecies']/div/div[1]/div/div[1]/h3

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
                    else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Farm/Flock/Species") &&
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
                        return false;
                    }
                }
            }


        }

        public class FarmEpiInfo
        {
            private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "FarmEpidemiologicalInfo']/div/div[1]/div/div[1]/h3");
            //*[@id="EIDSSBodyCPH_FarmEpidemiologicalInfo']/div/div[1]/div/div[1]/h3

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
                    else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Farm Epidemiological Info") &&
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
                        return false;
                    }
                }
            }
        }

        public class SpeciesInvestigation
        {
            private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "SpeciesInvestigation']/div/div[1]/div/div[1]/h3");
            //*[@id="EIDSSBodyCPH_SpeciesInvestigation']/div/div[1]/div/div[1]/h3

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
                    else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Species Investigation") &&
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
                        return false;
                    }
                }
            }
        }

        public class VaccineInfo
        {
            private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "upVaccination']/div/div[1]/div/div[1]/h3");
            private static By btnAddVaccine = By.Id(CommonCtrls.GeneralContent + "btnAddVaccination");
            //*[@id="EIDSSBodyCPH_upVaccination']/div/div[1]/div/div[1]/h3


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
                    else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Vaccination Information") &&
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
                        return false;
                    }
                }
            }

            public static void clickAddNewVaccine()
            {
                SetMethods.clickObjectButtons(btnAddVaccine);

                //Switch to popup
                Driver.Instance.SwitchTo().Window(Driver.Instance.WindowHandles.Last());
            }

            public class VaccinationInfoDialogueBox
            {
                private static By subtitleFormTitle = By.XPath("//*[@id='divVaccinationContainer']/div/div/div[1]/h4");
                private static By btnSaveVaccination = By.Id(CommonCtrls.GeneralContent + "btnVaccinationOK");
                private static By btnCancel = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "divVaccinationForm']/div[3]/div[3]/button");


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
                            else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                            {
                                {
                                    Driver.Wait(TimeSpan.FromMinutes(45));
                                    if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Vaccination Information") &&
                                        Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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
                            Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again." + e.Message);
                            return false;
                        }
                    }
                }

                public static void clickSaveVaccination()
                {
                    SetMethods.clickObjectButtons(btnSaveVaccination);
                }

                public static void clickCancel()
                {
                    SetMethods.clickObjectButtons(btnCancel);
                }
            }
        }

        public class ControlMeasures
        {
            private static By linkCtrlMeasures = By.LinkText("Control Measures");
            private static By ctrlMeaSection = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "upControlMeasures']/div/div[1]/div/div[1]/h3");


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
                    else if (Driver.Instance.FindElements(ctrlMeaSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(ctrlMeaSection).Text.Contains("Control Measures") &&
                                Driver.Instance.FindElement(ctrlMeaSection).Displayed)
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

        public class Samples
        {
            private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "upSample']/div/div[1]/div/div[1]/h3");
            private static By linkNewSample = By.LinkText("New Sample");
            //*[@id="EIDSSBodyCPH_upSample']/div/div[1]/div/div[1]/h3

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
                    else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
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
                        return false;
                    }
                }
            }

            public class SamplesPopupWndw
            {
                private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "divSampleContainer']/div/div/div[1]/h4");
                private static By btnSaveSample = By.Id(CommonCtrls.GeneralContent + "btnSampleOK");
                private static By btnCancel = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "divSampleForm']/div[6]/button");


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
                            else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                            {
                                {
                                    Driver.Wait(TimeSpan.FromMinutes(45));
                                    if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Samples") &&
                                        Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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
                            Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again." + e.Message);
                            return false;
                        }
                    }
                }

                public static void clickSaveSample()
                {
                    SetMethods.clickObjectButtons(btnSaveSample);
                }

                public static void clickCancel()
                {
                    SetMethods.clickObjectButtons(btnCancel);
                }
            }
        }

        public class PensideTests
        {
            private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "upPensideTest']/div/div[1]/div/div[1]/h3");
            //*[@id="EIDSSBodyCPH_upPensideTest']/div/div[1]/div/div[1]/h3

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
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Penside Tests") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again." + e.Message);
                        return false;
                    }
                }
            }
        }

        public class LabTestInterpret
        {
            public class LabTest
            {
                private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "upTestsAndTestInterpretations']/div[1]/div[1]/div/div[1]/h3");
                private static By linkLabTest = By.LinkText("New Lab Test");
                //*[@id="EIDSSBodyCPH_upTestsAndTestInterpretations']/div[1]/div[1]/div/div[1]/h3

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
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(15));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Lab Test") &&
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
                            return false;
                        }
                    }
                }
            }

            public class Interpretation
            {
                private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "upTestsAndTestInterpretations']/div[2]/div[1]/div/div/h3");
                //*[@id="EIDSSBodyCPH_upTestsAndTestInterpretations']/div[2]/div[1]/div/div/h3

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
                        else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(15));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Results Summary and Interpretation") &&
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
                            return false;
                        }
                    }
                }
            }

        }

        public class CaseLog
        {
            private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "upReportLog']/div/div[1]/div/div[1]/h3");
            //*[@id="EIDSSBodyCPH_upReportLog"]/div/div[1]/div/div[1]/h3
            private static By linkNewCaseLog = By.LinkText("New Case Log");

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
                    else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Case Log") &&
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
                        return false;
                    }
                }
            }
        }
    }
}