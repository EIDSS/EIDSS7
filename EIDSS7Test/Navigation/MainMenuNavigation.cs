using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using EIDSS7Test.Selenium;
using OpenQA.Selenium.Support.UI;
using OpenQA.Selenium;
using System.Threading;
using EIDSS7Test.Administration.Employees;
using OpenQA.Selenium.Interactions;
using NUnit.Framework;

namespace EIDSS7Test.Navigation
{
    public class MainMenuNavigation
    {
        private static string[] stringSeparators = new string[] { "\r\n" };
        private static Actions actions = new Actions(Driver.Instance);
        private static IList<IWebElement> headerTags { get { return Driver.Instance.FindElements(By.TagName("h4")); } }
        private static IList<IWebElement> subTags { get { return Driver.Instance.FindElements(By.TagName("h3")); } }
        private static By btnLogOut = By.XPath("//*[@id=frmMain']/div[3]/nav/div/div[2]/ul[1]/li[3]/ul/li[1]/a");
        private static By btnBetaLogout = By.XPath("/html/body/form/nav/div/nav/div/div[2]/ul/li[3]/ul/li[1]/a");
        private static By btnLogOutLink = By.LinkText("LOGOUT");
        private static By hoverOverActor = By.XPath("//*[@id='frmMain']/div[3]/nav/div/div[2]/ul/li[3]/a/span[2]");
        private static By hoverOverOverlayActor = By.XPath("/html/body/form/div[3]/div[2]/nav/div/div[2]/ul/li[3]/a/span[2]");
        //*[@id="frmMain"]/div[3]/nav/div/div[2]/ul/li[3]/a/span[2]
        //*[@id="divOverlay"]/nav/div/div[2]/ul/li[3]/a/span[2]
        private static By BetaHoverOverActor = By.XPath("/html/body/form/nav/div/nav/div/div[2]/ul/li[3]/a/span[2]");

        private static By titleEIDSSMainPage = By.XPath(".//*[@id='frmMain']/section[1]/div/h1");
        private static By pageHdrLinkHome = By.XPath(".//*[@id='PageHeader_lnkHome']/div");
        private static By EIDSSCollapseNavIcon = By.XPath("//*[@id='divCollapsedNav']/div[1]/div[2]");
        //*[@id="divCollapsedNav"]/div[1]/div[2]

        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromSeconds(360));
        private static By navMenuBar = By.Id("bs-example-navbar-collapse-1");
        private static IList<IWebElement> refEditorMenuLinks { get { return Driver.Instance.FindElements(By.XPath("//*[@id='frmMain']/nav/div/nav/div/div[2]/ul[2]/li[6]/a")); } }
        private static IList<IWebElement> adminMenuLinks { get { return Driver.Instance.FindElements(By.XPath("//*[@id='frmMain']/nav/div/nav/div/div[2]/ul[2]/li[5]/a")); } }
        private static IList<IWebElement> vetMenuLinks { get { return Driver.Instance.FindElements(By.XPath("//*[@id='frmMain']/nav/div/nav/div/div[2]/ul[2]/li[4]/a")); } }
        private static IList<IWebElement> humanMenuLinks { get { return Driver.Instance.FindElements(By.XPath("//*[@id='frmMain']/nav/div/nav/div/div[2]/ul[2]/li[3]/a")); } }
        private static IList<IWebElement> vectorMenuLinks { get { return Driver.Instance.FindElements(By.XPath("//*[@id='frmMain']/nav/div/nav/div/div[2]/ul[2]/li[2]/a")); } }
        private static IList<IWebElement> outbrMenuLinks { get { return Driver.Instance.FindElements(By.XPath("//*[@id='frmMain']/nav/div/nav/div/div[2]/ul[2]/li[1]/a")); } }
        private static IList<IWebElement> subMenuLinks { get { return Driver.Instance.FindElements(By.TagName("a")); } }
        private static By navMenuDropDown = By.TagName("li");

        //JOURNALS
        private static By linkJournals = By.LinkText("Journals");
        //private static By linkVeterinaryCases = By.LinkText("Veterinary Cases");
        //private static By linkHumanCases = By.LinkText("Human Cases");
        private static By linkOutbreak = By.LinkText("OUTBREAK");
        private static By linkOutbreaks = By.LinkText("OUTBREAKS");
        //private static By linkPersons = By.LinkText("Persons");
        private static By linkFarms = By.LinkText("FARMS");
        //private static By linkBasicSyndromicSurv = By.LinkText("Basic Syndromic Surveillance");
        private static By linkHumanAggregCases = By.LinkText("HUMAN AGGREGATE CASES");
        private static By linkVetAggregateCases = By.LinkText("Veterinary Aggregate Cases");
        private static By linkVetAggregActions = By.LinkText("Veterinary Aggregate Actions");
        private static By linkActiveSurveillance = By.LinkText("ACTIVE SURVEILLANCE SESSIONS");
        private static By linkVectorSurvSessions = By.XPath("//*[@id='leftNav_10506041']");
        //*[@id="leftNav_10506041"]
        private static By linkLabSection = By.LinkText("Laboratory Section");

        //VECTOR
        private static By linkVector = By.LinkText("VECTOR");
        private static By linkVectorSurvSession = By.LinkText("VECTOR SURVEILLANCE SESSION");

        //HUMAN CASES
        private static By linkHumanCases = By.LinkText("HUMAN CASES");
        private static By linkHumanDiseaseRpt = By.LinkText("HUMAN DISEASE REPORT");
        private static By linkBasicSyndSurvForm = By.LinkText("BASIC SYNDROMIC SURVEILLANCE FORM");
        private static By linkHumanSrchPersonDiseaseRpt = By.LinkText("SEARCH PERSON DISEASE REPORT");
        private static By linkHumanAggregate = By.LinkText("HUMAN AGGREGATE");
        private static By linkHumanSearchDiseaseRpts = By.LinkText("SEARCH DISEASE REPORTS");
        private static By linkHumanActSurvCampaign = By.LinkText("HUMAN ACTIVE SURVEILLANCE CAMPAIGN");
        private static By linkHumanActSurvSession = By.LinkText("HUMAN ACTIVE SURVEILLANCE SESSION");

        //VETERINARY
        private static By linkVeterinary = By.LinkText("VETERINARY");
        private static By linkActiveSurvSessions = By.LinkText("ACTIVE SURVEILLANCE SESSIONS");
        private static By linkActiveSurvCampaigns = By.LinkText("ACTIVE SURVEILLANCE CAMPAIGNS");
        private static By linkAvianDiseaseRpt = By.LinkText("AVIAN DISEASE REPORT");
        private static By linkLivestockDiseaseRpt = By.LinkText("LIVESTOCK DISEASE REPORT");
        private static By linkVetSearchDiseaseRpts = By.LinkText("SEARCH DISEASE REPORTS");
        private static By linkVeterinaryAggr = By.LinkText("VETERINARY AGGREGATE");


        //ADMINISTRATION
        private static By linkEmployees = By.LinkText("EMPLOYEES");
        private static By linkOrganizations = By.LinkText("ORGANIZATIONS");
        private static By linkStatisticalData = By.LinkText("STATISTICAL DATA");
        private static By linkSettlements = By.LinkText("SETTLEMENTS");
        private static By linkSystemPreferences = By.LinkText("SYSTEM PREFERENCES");

        //SEARCH
        private static By linkSearch = By.LinkText("Search");
        private static By linkHumanAggregCasesSum = By.LinkText("Human Aggregate Cases Summary");
        private static By linkVetAggregCasesSum = By.LinkText("Veterinary Aggregate Cases Summary");
        private static By linkVetAggregActionsSum = By.LinkText("Veterinary Aggregate Actions Summary");


        //REPORTS

        private static By linkReports = By.LinkText("Reports");
        private static By linkPaperForms = By.LinkText("Paper Forms");
        private static By linkHumanCaseInvestForm = By.LinkText("Human Case Investigation Form");
        private static By linkInvestFormForAvianDisBreakout = By.LinkText("Investigation Form for Avian Disease Outbreaks");
        private static By linkInvestFormForLivestockDisBreakout = By.LinkText("Investigation Form for Livestock Disease Outbreaks");
        private static By linkStandardReports = By.LinkText("Reports");
        private static By linkHuman = By.LinkText("Human");
        private static By linkHumanMonthlyMorbAndMortality = By.LinkText("Human Monthly Morbidity And Mortality");
        private static By linkConcordBetInitAndFinalDiag = By.LinkText("Concordance between Initial and Final Diagnosis");
        //private static By linkVeterinary = By.LinkText("Veterinary");
        private static By linkVetYearlySituation = By.LinkText("Veterinary Yearly Situation");
        private static By linkActiveSurvReport = By.LinkText("Active Surveillance Report");
        private static By linkAdministrative = By.LinkText("Administrative");
        private static By linkAdminEventLog = By.LinkText("Administrative Event Log");
        private static By linkPrintBarcodes = By.LinkText("Print Barcodes");


        //AVR
        private static By linkAVR = By.LinkText("AVR");

        //REPLICATE DATA
        private static By linkReplicateData = By.LinkText("Replicate Data");

        //SYSTEM
        private static By linkSystem = By.LinkText("System");




        public static bool IsAt
        {
            get
            {
                //EIDSSv6 opens a new tab so we need to switch to the last tab opened
                //var newTabHandle = Driver.Instance.WindowHandles.First();
                //Driver.Instance.SwitchTo().Window(newTabHandle);
                var title = wait.Until(ExpectedConditions.ElementIsVisible(titleEIDSSMainPage));
                Driver.TakeScreenShot(title, "EIDSMainMenu");
                Driver.Wait(TimeSpan.FromMinutes(10));
                if (title.Displayed)
                    return title.Text == "Welcome to the Electronic Integrated Disease Surveillance System";
                return false;
            }
        }

        private static void clickMenuLink(string UpperStr, string LowerStr)
        {
            Driver.Instance.WaitForPageToLoad();
            Thread.Sleep(3000);
            //var ulTag = wait.Until(ExpectedConditions.ElementExists(By.XPath("//*[@id='frmMain']/nav/div/nav/div/div[2]/ul[2]")));
            foreach (IWebElement ls in subMenuLinks)
            {
                try
                {
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        break;
                    }
                    if (ls.Text.Contains(UpperStr) || ls.Text.Contains(LowerStr))
                    {
                        Actions action = new Actions(Driver.Instance);
                        action.MoveToElement(ls).Click().Build().Perform();
                        //Thread.Sleep(2000);
                        //ls.Click();
                        break;
                    }
                }
                catch (StaleElementReferenceException)
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail();
                }
            }
        }

        private static void clickSubMenuLink(string UpperStr, string LowerStr)
        {
            //var ulTag = wait.Until(ExpectedConditions.ElementExists(By.XPath("//*[@id='frmMain']/nav/div/nav/div/div[2]/ul[2]")));
            foreach (IWebElement ls in subMenuLinks)
            {
                try
                {
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        break;
                    }
                    else if (ls.Text.Contains(UpperStr) || ls.Text.Contains(LowerStr))
                    {
                        Actions action = new Actions(Driver.Instance);
                        action.MoveToElement(ls).Click().Build().Perform();
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        //ls.Click();
                        break;
                    }
                }
                catch
                {
                    Driver.TakeScreenShot(ls, "ScreenShot");
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail();
                    clickLogOut();
                }
            }
        }

        public static void clickVector()
        {
            clickMenuLink("VECTOR", "Vector");
        }

        public static void clickOutbreaks()
        {
            clickMenuLink("OUTBREAK", "Outbreak");
        }


        public static void clickActiveSurveillance()
        {
            clickMenuLink("ACTIVE SURVEILLANCE", "Active Surveillance");
        }

        public static void clickLaboratory()
        {
            clickMenuLink("LABORATORY", "Laboratory");
        }

        public static void clickHuman()
        {
            clickMenuLink("HUMAN", "Human");
        }

        public static void clickVeterinary()
        {
            clickMenuLink("VETERINARY", "Veterinary");
        }

        public static void clickAdministration()
        {
            clickMenuLink("ADMINISTRATION", "Administration");
        }

        public static void clickReferenceEditor()
        {
            clickMenuLink("REFERENCE EDITORS", "Reference Editors");
        }

        public static void clickConfigurations()
        {
            clickMenuLink("CONFIGURATIONS", "Configurations");
        }


        public static void clickCreate()
        {
            foreach (IWebElement ls in subMenuLinks)
            {
                if (ls.Text.Contains("CREATE") || ls.Text.Contains("Create"))
                {
                    ls.Click();
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    break;
                }
            }
        }

        public static void clickLogOut()
        {
            hoverOverLogoutElement();
            clickMenuLink("LOGOUT", "Logout");
            //var logoutUsr = wait.Until(ExpectedConditions.ElementToBeClickable(btnLogOutLink));
            //Actions action = new Actions(Driver.Instance);
            //action.MoveToElement(logoutUsr).Click().Build().Perform();
            //logoutUsr.Click();
        }

        public static void clickEIDSSLogOutFromLab()
        {
            hoverOverOverlayLogoutElement();
            clickMenuLink("LOGOUT", "Logout");
        }

        public static void clickBetaLogOut()
        {
            hoverOverBetaLogoutElement();
            var logoutUsr = wait.Until(ExpectedConditions.ElementToBeClickable(btnBetaLogout));
            logoutUsr.Click();
        }

        public static void clickEIDSSIconBarToExitLab()
        {
            SetMethods.clickObjectButtons(EIDSSCollapseNavIcon);
        }

        public static void clickEIDSSHomeLink()
        {
            try
            {
                var element = wait.Until(ExpectedConditions.ElementIsVisible(pageHdrLinkHome));
                element.Click();
                Driver.Wait(TimeSpan.FromMinutes(10));
            }
            catch
            {
                //Scroll back up to the top of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0,-250)", "");
                var element = wait.Until(ExpectedConditions.ElementIsVisible(pageHdrLinkHome));
                element.Click();
                Driver.Wait(TimeSpan.FromMinutes(10));
            }
        }

        public static void hoverOverLogoutElement()
        {
            Driver.Wait(TimeSpan.FromMinutes(10));
            var actor = wait.Until(ExpectedConditions.ElementToBeClickable(hoverOverActor));
            Thread.Sleep(2000);
            Actions action = new Actions(Driver.Instance);
            action.MoveToElement(actor).Click().Perform();
        }

        public static void hoverOverOverlayLogoutElement()
        {
            Driver.Wait(TimeSpan.FromMinutes(10));
            var actor = wait.Until(ExpectedConditions.ElementToBeClickable(hoverOverOverlayActor));
            Thread.Sleep(2000);
            Actions action = new Actions(Driver.Instance);
            action.MoveToElement(actor).Click().Perform();
        }

        public static void hoverOverBetaLogoutElement()
        {
            Driver.Wait(TimeSpan.FromMinutes(10));
            var actor = wait.Until(ExpectedConditions.ElementToBeClickable(BetaHoverOverActor));
            Thread.Sleep(2000);
            Actions action = new Actions(Driver.Instance);
            action.MoveToElement(actor).Perform();
        }

        public static void clickLogoutElement()
        {
            Driver.Wait(TimeSpan.FromMinutes(10));
            var logoutUsr = wait.Until(ExpectedConditions.ElementToBeClickable(btnLogOutLink));
            Actions action = new Actions(Driver.Instance);
            action.MoveToElement(logoutUsr).Perform();
        }

        public class Outbreaks
        {
            private static By SubOutbreakLink = By.XPath("(//*[@id='leftNav_10506040'])");

            public static void clickOutbreak()
            {
                SetMethods.clickObjectButtons(SubOutbreakLink);
            }
        }

        public class Vector
        {
            public static void clickSurveillanceSession()
            {
                try
                {
                    Thread.Sleep(2000);
                    //clickSubMenuLink("SURVEILLANCE SESSION", "Surveillance Session");
                    SetMethods.clickObjectButtons(linkVectorSurvSessions);
                }
                catch (NoSuchElementException e)
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Element cannot be found.:" + e.Message);
                }
            }

        }

        public class Laboratory
        {
            public static void clickSamples()
            {
                clickSubMenuLink("SAMPLES", "Samples");
            }

            public static void clickTesting()
            {
                clickSubMenuLink("TESTING", "Testing");
            }

            public static void clickTransferred()
            {
                clickSubMenuLink("TRANSFERRED", "Transferred");
            }

            public static void clickApprovals()
            {
                clickSubMenuLink("APPROVALS", "Approvals");
            }

            public static void clickBatches()
            {
                clickSubMenuLink("BATCHES", "Batches");
            }

            public static void clickFreezers()
            {
                clickSubMenuLink("FREEZERS", "Freezers");
            }

            public static void clickMyFavorites()
            {
                clickSubMenuLink("MY FAVORITES", "My Favorites");
            }

        }

        public class Human
        {
            public static void clickHumanDiseaseReport()
            {
                clickSubMenuLink("HUMAN DISEASE REPORT", "Human Disease Report");
            }

            public static void clickPersonMenuItem()
            {
                clickSubMenuLink("PERSON", "Person");
            }

            public static void clickSearchPersonDiseaseReport()
            {
                clickSubMenuLink("SEARCH PERSON DISEASE REPORT", "Search Person Disease Report");
            }

            public static void clickAggregateDiseaseReport()
            {
                clickSubMenuLink("AGGREGATE DISEASE REPORT", "Aggregate Disease Report");
            }

            public static void clickBasicSyndSurvForm()
            {
                clickSubMenuLink("BASIC SYNDROMIC SURVEILLANCE FORM", "Basic Syndromic Surveillance Form");
            }

            public static void clickDiseaseReports()
            {
                clickSubMenuLink("DISEASE REPORT", "Disease Report");
            }

            public static void clickActiveSurvCampaign()
            {
                clickSubMenuLink("ACTIVE SURVEILLANCE CAMPAIGN", "Active Surveillance Campaign");
            }

            public static void clickActiveSurvSession()
            {
                clickSubMenuLink("ACTIVE SURVEILLANCE SESSION", "Active Surveillance Session");
            }

            public static void clickILIAggregateForm()
            {
                clickSubMenuLink("ILI AGGREGATE FORM", "ILI Aggregate Form");
            }

        }

        public class Veterinary
        {
            public static void clickActiveSurvSessions()
            {
                clickSubMenuLink("ACTIVE SURVEILLANCE SESSION", "Active Surveillance Session");
            }

            public static void clickActiveSurvCampaigns()
            {
                clickSubMenuLink("ACTIVE SURVEILLANCE CAMPAIGN", "Active Surveillance Campaign");
            }

            public static void clickAvianDiseaseReport()
            {
                clickSubMenuLink("AVIAN REPORT", "Avian Report");
            }

            public static void clickLivestockDiseaseReport()
            {
                clickSubMenuLink("LIVESTOCK REPORT", "Livestock Report");
            }

            public static void clickSearchDiseaseReports()
            {
                clickSubMenuLink("SEARCH DISEASE REPORTS", "Search Disease Reports");
            }

            public static void clickAggregateReport()
            {
                clickSubMenuLink("AGGREGATE REPORT", "Aggregate Report");
            }

            public static void clickFarm()
            {
                clickSubMenuLink("FARM", "Farm");
            }

        }

        public class Administration
        {
            public static void clickEmployees()
            {
                clickMenuLink("EMPLOYEES", "Employees");
            }

            public static void clickOrganizations()
            {
                clickMenuLink("ORGANIZATIONS", "Organizations");
            }

            public static void clickSettlements()
            {
                clickMenuLink("SETTLEMENTS", "Settlements");
            }

            public static void clickStatisticalData()
            {
                clickMenuLink("STATISTICAL DATA", "Statistical Data");
            }

        }

        public class ReferenceEditor
        {
            private static By linkBaseRefEditor = By.LinkText("BASE REFERENCE EDITOR");
            private static By linkClinicalDiagEditor = By.LinkText("CLINICAL DIAGNOSIS EDITOR");
            private static By linkMeasuresEditor = By.LinkText("MEASURES EDITOR");
            private static By linkSampleTypesEditor = By.LinkText("SAMPLE TYPES EDITOR");
            private static By linkVectorSpeciesTypeEditor = By.LinkText("VECTOR SPECIES TYPE EDITOR");
            private static By linkSpeciesTypesEditor = By.LinkText("SPECIES TYPES EDITOR");
            private static By linkGenericStatTypesEditor = By.LinkText("GENERIC STATISTICAL TYPES EDITOR");
            private static By linkReportDiagGrpsEditor = By.LinkText("REPORT DIAGNOSES GROUPS EDITOR");
            private static By linkAgeGroupsEditor = By.LinkText("AGE GROUPS EDITOR");

            private static void clickReferenceEditorMenuItem(String menu1, String menu2)
            {
                foreach (IWebElement ls in subMenuLinks)
                {
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    }
                    else if (ls.Text.Contains(menu1) || ls.Text.Contains(menu2))
                    {
                        Actions action = new Actions(Driver.Instance);
                        action.MoveToElement(ls).Click().Build().Perform();
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        break;
                    }
                    else
                    {
                        Assert.Fail();
                        clickLogOut();
                    }
                }
            }

            public class SpeciesType
            {
                private static By SubSpeciesTypeLink = By.XPath("(//*[@id='leftNav_10506073'])");

                public static void clickSpeciesTypes()
                {
                    SetMethods.clickObjectButtons(SubSpeciesTypeLink);
                }
            }

            public static void clickDiseasesEditor()
            {
                clickMenuLink("DISEASES", "Diseases");
            }

            public static void clickCaseClassificationEditor()
            {
                clickMenuLink("CASE CLASSIFICATIONS", "Case Classifications");
            }

            public static void clickBaseRefEditor()
            {
                clickMenuLink("BASE REFERENCE", "Base Reference");
            }

            public static void clickClinicalDiagEditor()
            {
                clickMenuLink("CLINICAL DIAGNOSIS", "Clinical Diagnosis");
            }

            public static void clickMeasuresEditor()
            {
                clickMenuLink("MEASURES", "Measures");
            }

            public static void clickSampleTypesEditor()
            {
                clickMenuLink("SAMPLE TYPES", "Sample Types");
            }

            public static void clickVectorTypesEditor()
            {
                clickMenuLink("VECTOR TYPES", "Vector Types");
            }

            public static void clickVectorSpeciesTypesEditor()
            {
                clickMenuLink("VECTOR SPECIES TYPES", "Vector Species Types");
            }

            public static void clickSpeciesTypesEditor()
            {
                clickMenuLink("SPECIES TYPES", "Species Types");
            }

            public static void clickGenericStatTypesEditor()
            {
                clickMenuLink("GENERIC STATISTICAL TYPES", "Generic Statistical Types");
            }

            public static void clickReportDiseasesGroups()
            {
                clickMenuLink("REPORT DISEASE GROUPS", "Report Disease Groups");
            }

            public static void clickAgeGroupsEditor()
            {
                clickMenuLink("AGE GROUPS", "Age Groups");
            }

        }

        public class Configurations
        {
            public static void clickDataArchivingSettings()
            {
                clickMenuLink("DATA ARCHIVING SETTINGS", "Data Archiving Settings");
            }

            public static void clickHumanAggregateCaseMatrix()
            {
                clickMenuLink("HUMAN AGGREGATE CASE MATRIX", "Human Aggregate Case Matrix");
            }

            public static void clickVetAggregateCaseMatrix()
            {
                clickMenuLink("VETERINARY AGGREGATE CASE MATRIX", "Veterinary Aggregate Case Matrix");
            }

            public static void clickVetDiagnosticInvestMatrix()
            {
                clickMenuLink("VETERINARY DIAGNOSTIC INVESTIGATION MATRIX", "Veterinary Diagnostic Investigation Matrix");
            }

            public static void clickVetProphylacticMeasureMatrix()
            {
                clickMenuLink("VETERINARY PROPHYLACTIC MEASURE MATRIX", "Veterinary Prophylactic Measure Matrix");
            }

            public static void clickVetSanitaryActionMatrix()
            {
                clickMenuLink("VETERINARY SANITARY ACTION MATRIX", "Veterinary Sanitary Action Matrix");
            }

            public static void clickSpeciesAnimalAgeMatrix()
            {
                clickMenuLink("SPECIES - ANIMAL AGE MATRIX", "Species - Animal Age Matrix");
            }

            public static void clickSampleTypeDerivativeMatrix()
            {
                clickMenuLink("SAMPLE TYPE - DERIVATIVE TYPE MATRIX", "Sample Type - Derivative Type Matrix");
            }

            public static void clickDiseaseSampleTypeMatrix()
            {
                clickMenuLink("DISEASE - SAMPLE TYPE MATRIX", "Disease - Sample Type Matrix");
            }

            public static void clickDiseaseLabTestMatrix()
            {
                clickMenuLink("DISEASE - LAB TEST MATRIX", "Disease - Lab Test Matrix");
            }

            public static void clickDiseasePensideTestMatrix()
            {
                clickMenuLink("DISEASE - PENSIDE TEST MATRIX", "Disease - Penside Test Matrix");
            }

            public static void clickTestTestResultMatrix()
            {
                clickMenuLink("TEST - TEST RESULT MATRIX", "Test - Test Result Matrix");
            }

            public static void clickVectorTypeCollectMethodMatrix()
            {
                clickMenuLink("VECTOR TYPE - COLLECTION METHOD MATRIX", "Vector Type - Collection Method Matrix");
            }

            public static void clickVectorTypeSampleMatrix()
            {
                clickMenuLink("VECTOR TYPE - SAMPLE MATRIX", "Vector Type - Sample Matrix");
            }

            public static void clickVectorTypeFieldTestMatrix()
            {
                clickMenuLink("VECTOR TYPE - FIELD TEST MATRIX", "Vector Type - Field Test Matrix");
            }

            public static void clickDiseaseAgeGroupMatrix()
            {
                clickMenuLink("DISEASE - AGE GROUP MATRIX", "Disease - Age Group Matrix");
            }
            public static void clickReportDiagnosisGroupMatrix()
            {
                clickMenuLink("REPORT DIAGNOSIS GROUP -DIAGNOSIS MATRIX", "Report Diagnosis Group - Diagnosis Matrix");
            }
            public static void clickCustomReportRows()
            {
                clickMenuLink("CUSTOM REPORT ROWS", "Custom Report Rows");
            }
            public static void clickAgeGroupStatAgeGroupMatrix()
            {
                clickMenuLink("AGE GROUP - STATISTICAL AGE GROUP MATRIX", "Age Group - Statistical Age Group Matrix");
            }
            public static void clickDiseaseGroupDiseaseMatrix()
            {
                clickMenuLink("DISEASE GROUP - DISEASE MATRIX", "Disease Group - Disease Group Matrix");
            }
            public static void clickParameterTypesEditor()
            {
                clickMenuLink("PARAMETER TYPES EDITOR", "Parameter Types Editor");
            }
            public static void clickUniqueNumberingSchema()
            {
                clickMenuLink("UNIQUE NUMBERING SCHEMA", "Disease - Age Group Matrix");
            }

            public static void clickAggregateSettings()
            {
                clickMenuLink("AGGREGATE SETTINGS", "Aggregate Settings");
            }

            public static void clickMapCustomization()
            {
                clickMenuLink("MAP CUSTOMIZATION", "Map Customization");
            }
        }

        public class Create
        {

            private static By linkCreate = By.LinkText("CREATE");
            private static By linkHumanCase = By.LinkText("HUMAN CASE");
            private static By linkCaseInvestigation = By.LinkText("CASE INVESTIGATION");
            private static By linkFinalCaseClass = By.LinkText("FINAL CASE CLASSIFICATION");
            private static By linkBasicSynSurvForm = By.LinkText("BASIC SYNDROMIC SURVEILLANCE FORM");
            private static By linkAvianDiseaseRpt = By.LinkText("AVIAN REPORT");
            private static By linkLivestockDiseaseRpt = By.LinkText("LIVESTOCK REPORT");
            private static By linkOutbreakCase = By.LinkText("OUTBREAK");
            private static By linkHumanAggregCase = By.LinkText("HUMAN AGGREGATE");
            private static By linkVetAggregReport = By.LinkText("AGGREGATE REPORT");
            private static By linkVetAggregAction = By.LinkText("AGGREGATE ACTIONS");
            private static By linkActiveSurvCampaign = By.LinkText("ACTIVE SURVEILLANCE CAMPAIGN");
            private static By linkActiveSurvSession = By.LinkText("ACTIVE SURVEILLANCE SESSION");
            private static By linkVectorSurvSession = By.LinkText("SURVEILLANCE SESSION");


            public static void clickHumanCase()
            {
                SetMethods.clickObjectButtons(linkHumanCase);
            }

            public static void clickCaseInvestigation()
            {
                SetMethods.clickObjectButtons(linkCaseInvestigation);
            }

            public static void clickFinalCaseClassification()
            {
                SetMethods.clickObjectButtons(linkFinalCaseClass);
            }

            //public static void clickBasicSynSurvForm()
            //{
            //    Driver.Wait(TimeSpan.FromMinutes(10));
            //    linkBasicSyndromicSurv.Click();
            //    Driver.Wait(TimeSpan.FromMinutes(10));
            //}

            //public static void clickAvianCase()
            //{
            //    var element = wait.Until(ExpectedConditions.ElementIsVisible(L));
            //    element.Click();
            //    Driver.Wait(TimeSpan.FromMinutes(10));
            //}

            //public static void clickLivestockCase()
            //{
            //    var element = wait.Until(ExpectedConditions.ElementIsVisible(linkLivestockCase));
            //    element.Click();
            //    Driver.Wait(TimeSpan.FromMinutes(10));
            //}

            public static void clickOutbreak()
            {
                SetMethods.clickObjectButtons(linkOutbreakCase);
            }

            public static void clickHumanAggCase()
            {
                SetMethods.clickObjectButtons(linkHumanAggregCase);
            }

            public static void clickVetAggReport()
            {
                SetMethods.clickObjectButtons(linkVetAggregReport);
            }


            //public static void clickBasicSyndromicSurv()
            //{
            //    linkBasicSyndromicSurv.Click();
            //    Driver.Wait(TimeSpan.FromMinutes(10));
            //}

            public static void clickVetAggAction()
            {
                SetMethods.clickObjectButtons(linkVetAggregAction);
            }

            public static void clickActiveSurvCampaign()
            {
                SetMethods.clickObjectButtons(linkActiveSurvCampaign);
            }

            public static void clickActiveSurvSession()
            {
                SetMethods.clickObjectButtons(linkActiveSurvSession);
            }

            public static void clickVectorSurvSession()
            {
                SetMethods.clickObjectButtons(linkVectorSurvSession);
            }


            public static void clickAvian()
            {
                IList<IWebElement> cols = Driver.Instance.FindElements(By.TagName("th"));
                foreach (IWebElement col in cols)
                {
                    if (col.Text.Contains("AVIAN") || col.Text.Contains("Avian"))
                    {
                        col.Click();
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        break;
                    }
                }
            }

            public static void clickLivestock()
            {
                IList<IWebElement> cols = Driver.Instance.FindElements(By.TagName("th"));
                foreach (IWebElement col in cols)
                {
                    if (col.Text.Contains("LIVESTOCK") || col.Text.Contains("Livestock"))
                    {
                        col.Click();
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        break;
                    }
                }
            }
        }


        public class CreateSurveillance
        {
            public static void clickActiveSurvCampaign()
            {
                foreach (IWebElement tag in subTags)
                {
                    if (tag.Text.Contains("ACTIVE Surveillance Campaign"))
                    {
                        tag.Click();
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        break;
                    }
                }
            }

            public static void clickActiveSurvSession()
            {
                IList<IWebElement> cols = Driver.Instance.FindElements(By.TagName("th"));
                foreach (IWebElement col in cols)
                {
                    if (col.Text.Contains("ACTIVE Surveillance Session"))
                    {
                        col.Click();
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        break;
                    }
                }
            }

            public static void clickVectorSurvSession()
            {
                IList<IWebElement> cols = Driver.Instance.FindElements(By.TagName("th"));
                foreach (IWebElement col in cols)
                {
                    if (col.Text.Contains("VECTOR SURVEILLANCE SESSION") || col.Text.Contains("Vector Surveillance Session"))
                    {
                        col.Click();
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        break;
                    }
                }
            }
        }


        public class Summarys
        {
            public static void clickHumanAggrCases()
            {
                foreach (IWebElement tag in subTags)
                {
                    if (tag.Text.Contains("HUMAN Aggregate Cases"))
                    {
                        tag.Click();
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        break;
                    }
                }
            }

            public static void clickVeterinaryAggrCases()
            {
                IList<IWebElement> cols = Driver.Instance.FindElements(By.TagName("th"));
                foreach (IWebElement col in cols)
                {
                    if (col.Text.Contains("VETERINARY Aggregate Cases"))
                    {
                        col.Click();
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        break;
                    }
                }
            }

            public static void clickVeterinaryAggregate()
            {
                IList<IWebElement> cols = Driver.Instance.FindElements(By.TagName("th"));
                foreach (IWebElement col in cols)
                {
                    if (col.Text.Contains("VETERINARY Aggregate"))
                    {
                        col.Click();
                        Driver.Wait(TimeSpan.FromMinutes(10));
                        break;
                    }
                }
            }
        }


        public class Options
        {
            public static class Dashboard
            {

                public static void clickReportOutbreak()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Report Outbreak"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickAVR()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("AVR"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickReplicateData()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Replicate Data"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickEnterUrgentNotification()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Enter Urgent Case Notification"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickSearchExistingCases()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Search Existing Cases"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickDownloadPaperForms()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Download Paper Forms"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickEnterLabResults()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Enter Lab Results"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickSearchLabResults()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Search Lab Results"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }


                public static void clickEnterEIDSS61()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Enter EIDSS 6.1"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickAccessManagement()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Access Management"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }
                public static void clickSystemPreferences()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("System Preferences"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickReferenceEditor()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Reference Editor"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickConfiguration()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Configuration"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickDataArchive()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Data Archive"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickActivityLog()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Activity Log"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickOtherTasks()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Other Tasks"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickEnterOldEIDSS()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Enter Old EIDSS"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickViewMyCases()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("View My Cases"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickEnterTestSamples()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Enter Test Samples"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickViewLabResults()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("View Lab Results"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickActiveSurveillance()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Active Surveillance"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }


                public static void clickRunReportNotDiseases()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Run report/graph for notifiable diseases"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickRunAbberationDetGraph()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Run the aberration detection graph"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickRunAnalysisReportSurvIndi()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Run the analysis report with surveillance indicators"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickRunOtherReports()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Run other reports..."))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }

                public static void clickContactRegionalLevel()
                {
                    foreach (IWebElement header in headerTags)
                    {
                        if (header.Text.Contains("Contact Regional Level"))
                        {
                            header.Click();
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            break;
                        }
                    }
                }



                public class ViewCases
                {
                    public static void clickViewCases()
                    {
                        foreach (IWebElement tag in subTags)
                        {
                            if (tag.Text.Contains("View Cases"))
                            {
                                tag.Click();
                                Driver.Wait(TimeSpan.FromMinutes(10));
                                break;
                            }
                        }
                    }

                    public static void clickHumanCase()
                    {
                        IList<IWebElement> cols = Driver.Instance.FindElements(By.TagName("th"));
                        foreach (IWebElement col in cols)
                        {
                            if (col.Text.Contains("HUMAN Case"))
                            {
                                col.Click();
                                Driver.Wait(TimeSpan.FromMinutes(10));
                                break;
                            }
                        }
                    }

                    public static void clickVeterinaryCase()
                    {
                        IList<IWebElement> cols = Driver.Instance.FindElements(By.TagName("th"));
                        foreach (IWebElement col in cols)
                        {
                            if (col.Text.Contains("VETERINARY Case"))
                            {
                                col.Click();
                                Driver.Wait(TimeSpan.FromMinutes(10));
                                break;
                            }
                        }
                    }

                    public static void clickVectorSurvSessions()
                    {
                        IList<IWebElement> cols = Driver.Instance.FindElements(By.TagName("th"));
                        foreach (IWebElement col in cols)
                        {
                            if (col.Text.Contains("VECTOR Surveillance Sessions"))
                            {
                                col.Click();
                                Driver.Wait(TimeSpan.FromMinutes(10));
                                break;
                            }
                        }
                    }

                    public static void clickActiveSurvSessions()
                    {
                        IList<IWebElement> cols = Driver.Instance.FindElements(By.TagName("th"));
                        foreach (IWebElement col in cols)
                        {
                            if (col.Text.Contains("ACTIVE Surveillance Sessions"))
                            {
                                col.Click();
                                Driver.Wait(TimeSpan.FromMinutes(10));
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
}