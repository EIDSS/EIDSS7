using System;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Selenium;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Collections.Generic;
using System.Linq;

namespace EIDSS7Test.Veterinary.LivestockDiseaseReport
{
    public class CreateLivestockDiseaseReportPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();
        public static string farmNM;
        public static string farmID;
        public static string street;

        private static By titleFormTitle = By.TagName("h2");
        private static By subtitleFormTitle = By.TagName("h3");
        private static By linkFarmDetails = By.LinkText("Farm Details");
        private static By linkNotification = By.LinkText("Notification");
        private static By linkFarmHerdSpecies = By.LinkText("Farm/Herd/Species");
        private static By linkFarmEpi = By.LinkText("Farm Epidemiological Info");
        private static By linkSpeciesInvest = By.LinkText("Species Investigation");
        private static By linkVaccineInfo = By.LinkText("Vaccination Information");
        private static By linkCtrlMeasuresInfo = By.LinkText("Control Measures");
        private static By linkAnimals = By.LinkText("Animals");
        private static By linkSamples = By.LinkText("Samples");
        private static By linkPensideTests = By.LinkText("Penside Tests");
        private static By linkLabTestInterp = By.LinkText("Lab Test/Interpretation");
        private static By linkCaseLog = By.LinkText("Case Log");
        private static By linkReview = By.LinkText("Review");
        private static By btnNext = By.Id(CommonCtrls.GeneralContent + "btnNextSection");
        private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmit");


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
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Livestock Disease Report") &&
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

        public class DiseaseReportSummary
        {

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

        public class FarmDetails
        {
            private static By farmDetailsSection = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "farmDetails']/div/div[1]/div/div[1]/h3");
            //*[@id="EIDSSBodyCPH_FarmDetails"]/div/div[1]/div/div[1]/h3

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
                    else if (Driver.Instance.FindElements(farmDetailsSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(farmDetailsSection).Text.Contains("Farm Details") &&
                                Driver.Instance.FindElement(farmDetailsSection).Displayed)
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

        public static void clickFarmDetailsLink()
        {
            SetMethods.clickObjectButtons(linkFarmDetails);
        }

        public static void clickNotificationLink()
        {
            SetMethods.clickObjectButtons(linkNotification);
        }

        public static void clickFarmHerdSpeciesLink()
        {
            SetMethods.clickObjectButtons(linkFarmHerdSpecies);
        }

        public static void clickAnimalsLink()
        {
            SetMethods.clickObjectButtons(linkAnimals);
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

        public static void clickNextToAnimalsTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 5; i++)
            {
                SetMethods.clickObjectButtons(btnNext);
            }
        }

        public static void clickNextToSamplesTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 6; i++)
            {
                SetMethods.clickObjectButtons(btnNext);
            }
        }

        public static void clickNextToPensideTestsTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 7; i++)
            {
                SetMethods.clickObjectButtons(btnNext);
            }
        }

        public static void clickNextToLabTestInterpretTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 8; i++)
            {
                SetMethods.clickObjectButtons(btnNext);
            }
        }

        public static void clickNextToCaseLogTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 9; i++)
            {
                SetMethods.clickObjectButtons(btnNext);
            }
        }

        public static void clickNextToReviewTab()
        {
            //Scroll to bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            for (int i = 0; i <= 10; i++)
            {
                SetMethods.clickObjectButtons(btnNext);
            }
        }

        public class Notification
        {
            private static By notifySection = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "Notification']/div/div[1]/div/div[1]/h3");
            //*[@id="EIDSSBodyCPH_Notification"]/div/div[1]/div/div[1]/h3
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
                    else if (Driver.Instance.FindElements(notifySection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(notifySection).Text.Contains("Notification") &&
                                Driver.Instance.FindElement(notifySection).Displayed)
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
        }

        public class FarmHeardSpecies
        {
            private static By linkNewHerd = By.LinkText("New Herd");
            private static By farmHerdSpeciesSection = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "upFarmHerdSpecies']/div/div[1]/div/div[1]/h3");
            //*[@id="EIDSSBodyCPH_upFarmHerdSpecies"]/div/div[1]/div/div[1]/h3

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
                    else if (Driver.Instance.FindElements(farmHerdSpeciesSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(farmHerdSpeciesSection).Text.Contains("Farm/Herd/Species") &&
                                Driver.Instance.FindElement(farmHerdSpeciesSection).Displayed)
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

            public static void clickNewHerd()
            {
                SetMethods.clickObjectButtons(linkNewHerd);
            }

        }

        public class FarmEpiInfo
        {
            private static By linkNewFlock = By.LinkText("New Flock");
            private static By farmEpiInfoSection = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "FarmEpidemiologicalInfo']/div/div[1]/div/div[1]/h3");
            //*[@id="EIDSSBodyCPH_FarmEpidemiologicalInfo']/div/div[1]/div/div[1]/h3

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
                    else if (Driver.Instance.FindElements(farmEpiInfoSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(farmEpiInfoSection).Text.Contains("Farm Epidemiological Info") &&
                                Driver.Instance.FindElement(farmEpiInfoSection).Displayed)
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

            public static void clickNewFlockLink()
            {
                SetMethods.clickObjectButtons(linkNewFlock);
            }
        }

        public class SpeciesInvestigation
        {
            private static By speciesInvestSection = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "SpeciesInvestigation']/div/div[1]/div/div[1]/h3");
            //*[@id="EIDSSBodyCPH_SpeciesInvestigation']/div/div[1]/div/div[1]/h3

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
                    else if (Driver.Instance.FindElements(speciesInvestSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(speciesInvestSection).Text.Contains("Species Investigation") &&
                                Driver.Instance.FindElement(speciesInvestSection).Displayed)
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
        }

        public class VaccineInfo
        {
            private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "upVaccination']/div/div[1]/div/div[1]/h3");
            private static By linkNewVaccine = By.LinkText("New Vaccination");
            private static By btnAddVaccine = By.Id(CommonCtrls.GeneralContent + "btnAddVaccination");
            //*[@id="EIDSSBodyCPH_upVaccination']/div/div[1]/div/div[1]/h3

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
                    else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Vaccination Information") &&
                                Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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

            public static void clickNewVaccineLink()
            {
                SetMethods.clickObjectButtons(linkNewVaccine);
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
                private static By ddlDisease = By.Id(CommonCtrls.GeneralContent + "ddlVaccinationDiseaseID");
                private static IList<IWebElement> diseaseOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVaccinationDiseaseID']/option")); } }
                private static By datDate = By.Id(CommonCtrls.GeneralContent + "txtVaccinationVaccinationDate");
                private static By ddlSpecies = By.Id(CommonCtrls.GeneralContent + "ddlVaccinationSpeciesID");
                private static IList<IWebElement> speciesOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVaccinationSpeciesID']/option")); } }
                private static By txtNumberVac = By.Id(CommonCtrls.GeneralContent + "txtVaccinationNumberVaccinated");
                private static By ddlVaccType = By.Id(CommonCtrls.GeneralContent + "ddlVaccinationVaccinationTypeID");
                private static IList<IWebElement> vacTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVaccinationVaccinationTypeID']/option")); } }
                private static By ddlVaccRoute = By.Id(CommonCtrls.GeneralContent + "ddlVaccinationVaccinationRouteTypeID");
                private static IList<IWebElement> vacRouteOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVaccinationVaccinationRouteTypeID']/option")); } }


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

        public class Animals
        {
            private static By linkNewAnimal = By.LinkText("New Animal");
            private static By animalsSection = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "upAnimal']/div/div[1]/div/div[1]/h3");
            //*[@id="EIDSSBodyCPH_upAnimal"]/div/div[1]/div/div[1]/h3

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
                    else if (Driver.Instance.FindElements(animalsSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(animalsSection).Text.Contains("Animals") &&
                                Driver.Instance.FindElement(animalsSection).Displayed)
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

            public static void clickNewAnimalLink()
            {
                SetMethods.clickObjectButtons(linkNewAnimal);
            }
        }

        public class Samples
        {
            private static By linkNewSample = By.LinkText("New Sample");
            private static By samplesSection = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "upSample']/div/div[1]/div/div[1]/h3");
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
                    else if (Driver.Instance.FindElements(samplesSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(samplesSection).Text.Contains("Samples") &&
                                Driver.Instance.FindElement(samplesSection).Displayed)
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

            public static void clickNewSampleLink()
            {
                SetMethods.clickObjectButtons(linkNewSample);
            }
        }

        public class PensideTests
        {
            private static By pensideTestsSection = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "upPensideTest']/div/div[1]/div/div[1]/h3");
            //*[@id="EIDSSBodyCPH_upPensideTest']/div/div[1]/div/div[1]/h3

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
                    else if (Driver.Instance.FindElements(pensideTestsSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(pensideTestsSection).Text.Contains("Penside Tests") &&
                                Driver.Instance.FindElement(pensideTestsSection).Displayed)
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

        public class LabTestInterpret
        {
            public class LabTest
            {
                private static By linkNewLabTest = By.LinkText("New Lab Test");
                private static By labTestSection = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "upTestsAndTestInterpretations']/div[1]/div[1]/div/div[1]/h3");
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
                        else if (Driver.Instance.FindElements(labTestSection).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(labTestSection).Text.Contains("Lab Test") &&
                                    Driver.Instance.FindElement(labTestSection).Displayed)
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

                public static void clickNewLabTestLink()
                {
                    SetMethods.clickObjectButtons(linkNewLabTest);
                }

            }
            public class Interpretation
            {
                private static By interpretSection = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "upTestsAndTestInterpretations']/div[2]/div[1]/div/div/h3");
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
                        else if (Driver.Instance.FindElements(interpretSection).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(interpretSection).Text.Contains("Interpretation") &&
                                    Driver.Instance.FindElement(interpretSection).Displayed)
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

        public class CaseLog
        {
            private static By linkNewCaseLog = By.LinkText("New Case Log");
            private static By caseLogSection = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "upReportLog']/div/div[1]/div/div[1]/h3");

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
                    else if (Driver.Instance.FindElements(caseLogSection).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(caseLogSection).Text.Contains("Case Log") &&
                                Driver.Instance.FindElement(caseLogSection).Displayed)
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

            public static void clickNewCaseLogLink()
            {
                SetMethods.clickObjectButtons(linkNewCaseLog);
            }
        }
    }
}