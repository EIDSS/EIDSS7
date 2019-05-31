using EIDSS7Test.Administration.Employees;
using EIDSS7Test.Administration.Organizations;
using EIDSS7Test.Administration.ReferenceEditor;
using EIDSS7Test.Administration.Settlements;
using EIDSS7Test.Administration.StatisticalData;
using EIDSS7Test.Outbreaks;
using EIDSS7Test.Administration.SystemPreferences;
using EIDSS7Test.Administration.ReferenceEditor;
using EIDSS7Test.HumanCases.ILIAggregate;
using EIDSS7Test.Vector.CreateVectorSurvSession;
using EIDSS7Test.Vector.SearchVectorSurvSession;
using EIDSS7Test.BasicSyndromicSurveillance;
using EIDSS7Test.HumanCases.HumanAggregate;
using EIDSS7Test.HumanCases.SearchPersons;
using EIDSS7Test.HumanCases.SearchDiseaseReports;
using EIDSS7Test.HumanCases.HumanActiveSurveillanceCampaign;
using EIDSS7Test.HumanCases.HumanActiveSurveillanceSesson;
using EIDSS7Test.Veterinary.ActiveSurveillanceCampaigns;
using EIDSS7Test.Veterinary.ActiveSurveillanceSessions;
using EIDSS7Test.Veterinary.AvianDiseaseReport;
using EIDSS7Test.Veterinary.AvianAvianDiseaseRpt;
using EIDSS7Test.Veterinary.Farm;
using EIDSS7Test.Veterinary.LivestockDiseaseReport;
using EIDSS7Test.Veterinary.VeterinaryAggregate;
using EIDSS7Test.Navigation;
using EIDSS7Test.Selenium;
using EIDSS7Test.BaseScripts;
using NUnit.Framework;
using RelevantCodes.ExtentReports;
using EIDSS7Test.Reports;
using EIDSS7Test.HumanCases.CreateNewPerson;
using EIDSS7Test.HumanCases.HumanDiseaseReports;
using EIDSS7Test.Configurations;
using EIDSS7Test.Laboratory;

namespace EIDSS7Test
{
    [TestFixture]
    public class SmokeTests : TestBase
    {
        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Person | Outbreak | Outbreak Management page")]
        //public void VerifyHumanPersonOutbreakOutbreakManagementDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Person | Outbreak | Outbreak Management page");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickPersonMenuItem();
        //    Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person Page");

        //    //Search for an existing person
        //    SearchPersonPage.SearchCriteria.clearPersonIDField();
        //    SearchPersonPage.SearchCriteria.enterPersonID("PER");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Random select person from grid
        //    SearchPersonPage.SearchResults.randomSelectPersonFromGrid();
        //    Assert.IsTrue(CreateNewPersonPage.PersonInformation.IsAt, "This is not the Person Information section");

        //    //Click the Review tab
        //    //Verify Farms section displays
        //    CreateNewPersonPage.clickPersonReview();
        //    Assert.IsTrue(CreateNewPersonPage.PersonReview.OutbreakCaseReports.IsAt, "This is not the Outbreak Case Reports section");

        //    CreateNewPersonPage.PersonReview.OutbreakCaseReports.clickAddOutbreakCaseReport();
        //    Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management page");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}


        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Person | Outbreak | Search Outbreak page")]
        //public void VerifyHumanPersonOutbreakSearchOutbreakPageDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Person | Outbreak | Search Outbreak page");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickPersonMenuItem();
        //    Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person Page");

        //    //Search for an existing person
        //    SearchPersonPage.SearchCriteria.clearPersonIDField();
        //    SearchPersonPage.SearchCriteria.enterPersonID("PER");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Random select person from grid
        //    SearchPersonPage.SearchResults.randomSelectPersonFromGrid();
        //    Assert.IsTrue(CreateNewPersonPage.PersonInformation.IsAt, "This is not the Person Information section");

        //    //Click the Review tab
        //    //Verify Farms section displays
        //    CreateNewPersonPage.clickPersonReview();
        //    Assert.IsTrue(CreateNewPersonPage.PersonReview.OutbreakCaseReports.IsAt, "This is not the Outbreak Case Reports section");

        //    CreateNewPersonPage.PersonReview.OutbreakCaseReports.clickAddOutbreakCaseReport();
        //    Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management page");

        //    SearchOutbreakPage.clickAdvancedSearch();
        //    Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.IsAt, "This is not the Search Outbreak page");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Person | Outbreak | Search Outbreak | Search section")]
        //public void VerifyHumanPersonOutbreakSearchOutbreakSearchSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Person | Search Outbreak | Search section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickPersonMenuItem();
        //    Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person Page");

        //    //Search for an existing person
        //    SearchPersonPage.SearchCriteria.clearPersonIDField();
        //    SearchPersonPage.SearchCriteria.enterPersonID("PER");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Random select person from grid
        //    SearchPersonPage.SearchResults.randomSelectPersonFromGrid();
        //    Assert.IsTrue(CreateNewPersonPage.PersonInformation.IsAt, "This is not the Person Information section");

        //    //Click the Review tab
        //    //Verify Farms section displays
        //    CreateNewPersonPage.clickPersonReview();
        //    Assert.IsTrue(CreateNewPersonPage.PersonReview.OutbreakCaseReports.IsAt, "This is not the Outbreak Case Reports section");

        //    CreateNewPersonPage.PersonReview.OutbreakCaseReports.clickAddOutbreakCaseReport();
        //    Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management page");

        //    SearchOutbreakPage.clickAdvancedSearch();
        //    Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.Search.IsAt, "This is not the Search section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Person | Outbreak | Outbreak Parameters section")]
        //public void VerifyHumanPersonOutbreaksOutbreakParametersSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Person | Outbreak | Outbreak Parameters section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickPersonMenuItem();
        //    Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person Page");

        //    //Search for an existing person
        //    SearchPersonPage.SearchCriteria.clearPersonIDField();
        //    SearchPersonPage.SearchCriteria.enterPersonID("PER");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Random select person from grid
        //    SearchPersonPage.SearchResults.randomSelectPersonFromGrid();
        //    Assert.IsTrue(CreateNewPersonPage.PersonInformation.IsAt, "This is not the Person Information section");

        //    //Click the Review tab
        //    //Verify Farms section displays
        //    CreateNewPersonPage.clickPersonReview();
        //    Assert.IsTrue(CreateNewPersonPage.PersonReview.OutbreakCaseReports.IsAt, "This is not the Outbreak Case Reports section");

        //    CreateNewPersonPage.PersonReview.OutbreakCaseReports.clickAddOutbreakCaseReport();
        //    Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management page");

        //    SearchOutbreakPage.clickCreateOutbreak();
        //    Assert.IsTrue(CreateOutbreakPage.OutbreakInfo.IsAt, "This is not the Outbreak Information section");

        //    CreateOutbreakPage.OutbreakInfo.enterOutbreakType("Human");
        //    Assert.IsTrue(CreateOutbreakPage.OutbreakParameters.IsAt, "This is not the Outbreak Parameters section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Person | Outbreak | Outbreak Session page")]
        //public void VerifyHumanPersonOutbreaksOutbreakSessionPageDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Person | Outbreak | Outbreak Session page");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickPersonMenuItem();
        //    Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person Page");

        //    //Search for an existing person
        //    SearchPersonPage.SearchCriteria.clearPersonIDField();
        //    SearchPersonPage.SearchCriteria.enterPersonID("PER");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Random select person from grid
        //    SearchPersonPage.SearchResults.randomSelectPersonFromGrid();
        //    Assert.IsTrue(CreateNewPersonPage.PersonInformation.IsAt, "This is not the Person Information section");

        //    //Click the Review tab
        //    //Verify Outbreak Case Reports section
        //    CreateNewPersonPage.clickPersonReview();
        //    Assert.IsTrue(CreateNewPersonPage.PersonReview.OutbreakCaseReports.IsAt, "This is not the Outbreak Case Reports section");

        //    CreateNewPersonPage.PersonReview.OutbreakCaseReports.clickAddOutbreakCaseReport();
        //    Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management page");

        //    SearchOutbreakPage.randomSelectOutbreakFromList();
        //    Assert.IsTrue(CreateOutbreakPage.OutbreakSession.IsAt, "This is not the Outbreak Session page");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}


        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Person | Outbreak | Outbreak Information section")]
        //public void VerifyHumanPersonOutbreakOutbreakInformationSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Person | Outbreak | Outbreak Information section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickPersonMenuItem();
        //    Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person Page");

        //    //Search for an existing 
        //    SearchPersonPage.SearchCriteria.clearPersonIDField();
        //    SearchPersonPage.SearchCriteria.enterPersonID("PER");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Random select person from grid
        //    SearchPersonPage.SearchResults.randomSelectPersonFromGrid();
        //    Assert.IsTrue(CreateNewPersonPage.PersonInformation.IsAt, "This is not the Person Information section");

        //    //Click the Review tab
        //    //Verify Farms section displays
        //    CreateNewPersonPage.clickPersonReview();
        //    Assert.IsTrue(CreateNewPersonPage.PersonReview.OutbreakCaseReports.IsAt, "This is not the Outbreak Case Reports section");

        //    CreateNewPersonPage.PersonReview.OutbreakCaseReports.clickAddOutbreakCaseReport();
        //    Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management");

        //    SearchOutbreakPage.clickCreateOutbreak();
        //    Assert.IsTrue(CreateOutbreakPage.OutbreakInfo.IsAt, "This is not the Outbreak Information section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Outbreak | Outbreak Management page")]
        public void VerifyOutbreakOutbreakManagementPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Outbreak | Outbreak Management page")
                   .AssignCategory("Outbreak");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");

            Assert.True(test.GetTest().CategoryList.Count == 1);
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Outbreak | Search Outbreak page")]
        public void VerifyOutbreakSearchOutbreakPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Outbreak | Search Outbreak page")
                   .AssignCategory("Outbreak");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.IsAt, "This is not the Search Outbreak page");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");

            Assert.True(test.GetTest().CategoryList.Count == 1);
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Outbreak | Search Outbreak | Search section")]
        public void VerifyOutbreakSearchOutbreakSearchSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Outbreak | Search Outbreak | Search section")
                   .AssignCategory("Outbreak");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.Search.IsAt, "This is not the Search section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");

            Assert.True(test.GetTest().CategoryList.Count == 1);
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Outbreak | Outbreak Parameters section")]
        public void VerifyOutbreaksOutbreakParametersSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Outbreak | Outbreak Parameters section")
                   .AssignCategory("Outbreak");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            SearchOutbreakPage.clickCreateOutbreak();
            Assert.IsTrue(CreateOutbreakPage.OutbreakInfo.IsAt, "This is not the Outbreak Information section");

            CreateOutbreakPage.OutbreakInfo.enterOutbreakType("Veterinary");
            Assert.IsTrue(CreateOutbreakPage.OutbreakParameters.IsAt, "This is not the Outbreak Parameters section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");

            Assert.True(test.GetTest().CategoryList.Count == 1);
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Outbreak | Outbreak Information section")]
        public void VerifyOutbreakOutbreakInformationSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Outbreak | Outbreak Information section")
                   .AssignCategory("Outbreak");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List Page");

            SearchOutbreakPage.clickCreateOutbreak();
            Assert.IsTrue(CreateOutbreakPage.OutbreakInfo.IsAt, "This is not the Outbreak Information section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");

            Assert.True(test.GetTest().CategoryList.Count == 1);
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Outbreak | Outbreak Session section")]
        public void VerifyOutbreakOutbreakSessionSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Outbreak | Outbreak Session section")
                   .AssignCategory("Outbreak");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List Page");

            SearchOutbreakPage.randomSelectOutbreakFromList();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.IsAt, "This is not the Outbreak Session page");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");

            Assert.True(test.GetTest().CategoryList.Count == 1);
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Notification section displays")]
        public void VerifyOutbreakOutbreakSummCreateLivestockVetCaseNotificSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Notification section displays")
                   .AssignCategory("Outbreak");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List Page");

            /// Navigate to the Advanced Search page
            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Search for an existing Vet Outbreak Session, Status = In Progress
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakType("Veterinary");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakStatus("In Progress");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.clickSearch();

            //Random select an existing session
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.randomSelectOutbreakSessionID();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.OutbreakSummary.IsAt, "This is not the Outbreak Summary section");

            //Create a new Veterinary Disease Report
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickCreateCase();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickVeterinary();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.IsAt, "This is not the Search Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.clickSearch();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select the Farm
            SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Notification.IsAt, "This is not the Notification section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Location section displays")]
        public void VerifyOutbreakOutbreakSummCreateLivestockVetCaseLocationSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Location section displays")
                   .AssignCategory("Outbreak");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List Page");

            /// Navigate to the Advanced Search page
            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Search for an existing Vet Outbreak Session, Status = In Progress
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakType("Veterinary");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakStatus("In Progress");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.clickSearch();

            //Random select an existing session
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.randomSelectOutbreakSessionID();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.OutbreakSummary.IsAt, "This is not the Outbreak Summary section");

            //Create a new Veterinary Disease Report
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickCreateCase();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickVeterinary();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.IsAt, "This is not the Search Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.clickSearch();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select the Farm
            SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Notification.IsAt, "This is not the Notification section");

            //Navigate to Location section
            OutbreakVetDiseaseRptPage.clickLocationLink();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Location.IsAt, "This is not the Location section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Herd/Flock/Species Info section displays")]
        public void VerifyOutbreakOutbreakSummCreateLivestockVetCaseHerdFlockSpeciesInfoSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Herd/Flock/Species Infosection displays")
                   .AssignCategory("Outbreak");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List Page");

            /// Navigate to the Advanced Search page
            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Search for an existing Vet Outbreak Session, Status = In Progress
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakType("Veterinary");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakStatus("In Progress");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.clickSearch();

            //Random select an existing session
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.randomSelectOutbreakSessionID();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.OutbreakSummary.IsAt, "This is not the Outbreak Summary section");

            //Create a new Veterinary Disease Report
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickCreateCase();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickVeterinary();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.IsAt, "This is not the Search Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.clickSearch();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select the Farm
            SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Notification.IsAt, "This is not the Notification section");

            //Navigate to Herd/Flock/Species Info section
            OutbreakVetDiseaseRptPage.clickHerdFlockSpeciesLink();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.HerdFlockSpeciesInfo.IsAt, "This is not the Herd/Flock/Species section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Clinical Info section displays")]
        public void VerifyOutbreakOutbreakSummCreateLivestockVetCaseClinicalInfoSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Clinical Info Infosection displays")
                   .AssignCategory("Outbreak");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List Page");

            /// Navigate to the Advanced Search page
            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Search for an existing Vet Outbreak Session, Status = In Progress
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakType("Veterinary");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakStatus("In Progress");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.clickSearch();

            //Random select an existing session
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.randomSelectOutbreakSessionID();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.OutbreakSummary.IsAt, "This is not the Outbreak Summary section");

            //Create a new Veterinary Disease Report
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickCreateCase();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickVeterinary();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.IsAt, "This is not the Search Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.clickSearch();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select the Farm
            SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Notification.IsAt, "This is not the Notification section");

            //Navigate to Clinical Info section
            OutbreakVetDiseaseRptPage.clickClinicalInfoLink();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.ClinicalInfo.IsAt, "This is not the Clinical Information section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Vaccination Info section displays")]
        public void VerifyOutbreakOutbreakSummCreateLivestockVetCaseVaccineInfoSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Vaccination Info Infosection displays")
                   .AssignCategory("Outbreak");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List Page");

            /// Navigate to the Advanced Search page
            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Search for an existing Vet Outbreak Session, Status = In Progress
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakType("Veterinary");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakStatus("In Progress");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.clickSearch();

            //Random select an existing session
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.randomSelectOutbreakSessionID();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.OutbreakSummary.IsAt, "This is not the Outbreak Summary section");

            //Create a new Veterinary Disease Report
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickCreateCase();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickVeterinary();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.IsAt, "This is not the Search Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.clickSearch();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select the Farm
            SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Notification.IsAt, "This is not the Notification section");

            //Navigate to Vaccination Info section
            //Verify section displays correctly
            OutbreakVetDiseaseRptPage.clickVaccineInfoLink();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.VaccinationInfo.IsAt, "This is not the Vaccination Information section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Outbreak Investigation section displays")]
        public void VerifyOutbreakOutbreakSummCreateLivestockVetCaseOutbreakInvestSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Outbreak Investigation Infosection displays")
                   .AssignCategory("Outbreak");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List Page");

            /// Navigate to the Advanced Search page
            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Search for an existing Vet Outbreak Session, Status = In Progress
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakType("Veterinary");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakStatus("In Progress");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.clickSearch();

            //Random select an existing session
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.randomSelectOutbreakSessionID();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.OutbreakSummary.IsAt, "This is not the Outbreak Summary section");

            //Create a new Veterinary Disease Report
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickCreateCase();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickVeterinary();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.IsAt, "This is not the Search Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.clickSearch();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select the Farm
            SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Notification.IsAt, "This is not the Notification section");

            //Navigate to Outbreak Investigation section
            //Verify section displays correctly
            OutbreakVetDiseaseRptPage.clickOutbreakInvestLink();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.OutbreakInvest.IsAt, "This is not the Outbreak Investigation section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Case Monitoring section displays")]
        public void VerifyOutbreakOutbreakSummCreateLivestockVetCaseCaseMonitorSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Case Monitoring section displays")
                   .AssignCategory("Outbreak");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List Page");

            /// Navigate to the Advanced Search page
            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Search for an existing Vet Outbreak Session, Status = In Progress
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakType("Veterinary");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakStatus("In Progress");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.clickSearch();

            //Random select an existing session
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.randomSelectOutbreakSessionID();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.OutbreakSummary.IsAt, "This is not the Outbreak Summary section");

            //Create a new Veterinary Disease Report
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickCreateCase();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickVeterinary();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.IsAt, "This is not the Search Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.clickSearch();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select the Farm
            SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Notification.IsAt, "This is not the Notification section");

            //Navigate to Case Monitoring section
            //Verify section displays correctly
            OutbreakVetDiseaseRptPage.clickCaseMonitoringLink();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.CaseMonitoring.IsAt, "This is not the Case Monitoring section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Contacts section displays")]
        public void VerifyOutbreakOutbreakSummCreateLivestockVetCaseContactsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Contacts section displays")
                   .AssignCategory("Outbreak");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List Page");

            /// Navigate to the Advanced Search page
            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Search for an existing Vet Outbreak Session, Status = In Progress
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakType("Veterinary");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakStatus("In Progress");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.clickSearch();

            //Random select an existing session
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.randomSelectOutbreakSessionID();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.OutbreakSummary.IsAt, "This is not the Outbreak Summary section");

            //Create a new Veterinary Disease Report
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickCreateCase();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickVeterinary();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.IsAt, "This is not the Search Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.clickSearch();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select the Farm
            SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Notification.IsAt, "This is not the Notification section");

            //Navigate to Outbreak Investigation section
            //Verify section displays correctly
            OutbreakVetDiseaseRptPage.clickContactsLink();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Contacts.IsAt, "This is not the Contacts section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Samples section displays")]
        public void VerifyOutbreakOutbreakSummCreateLivestockVetCaseSamplesSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Samples section displays")
                   .AssignCategory("Outbreak");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List Page");

            /// Navigate to the Advanced Search page
            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Search for an existing Vet Outbreak Session, Status = In Progress
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakType("Veterinary");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakStatus("In Progress");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.clickSearch();

            //Random select an existing session
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.randomSelectOutbreakSessionID();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.OutbreakSummary.IsAt, "This is not the Outbreak Summary section");

            //Create a new Veterinary Disease Report
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickCreateCase();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickVeterinary();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.IsAt, "This is not the Search Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.clickSearch();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select the Farm
            SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Notification.IsAt, "This is not the Notification section");

            //Navigate to Samples section
            //Verify section displays correctly
            OutbreakVetDiseaseRptPage.clickSamplesLink();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Samples.IsAt, "This is not the Samples section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Penside Tests section displays")]
        public void VerifyOutbreakOutbreakSummCreateLivestockVetCasePensideTestsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Penside Tests section displays")
                   .AssignCategory("Outbreak");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List Page");

            /// Navigate to the Advanced Search page
            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Search for an existing Vet Outbreak Session, Status = In Progress
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakType("Veterinary");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakStatus("In Progress");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.clickSearch();

            //Random select an existing session
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.randomSelectOutbreakSessionID();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.OutbreakSummary.IsAt, "This is not the Outbreak Summary section");

            //Create a new Veterinary Disease Report
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickCreateCase();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickVeterinary();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.IsAt, "This is not the Search Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.clickSearch();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select the Farm
            SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Notification.IsAt, "This is not the Notification section");

            //Navigate to Penside Tests section
            //Verify section displays correctly
            OutbreakVetDiseaseRptPage.clickPensideTestsLink();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.PensideTests.IsAt, "This is not the Penside Tests section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Lab Tests & Interpre section displays")]
        public void VerifyOutbreakOutbreakSummCreateLivestockVetCaseLabTestsInterpSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Outbreak | Outbreak Summary | Create Livestock Vet Case | Lab Tests & Interpre section displays")
                   .AssignCategory("Outbreak");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List Page");

            /// Navigate to the Advanced Search page
            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Search for an existing Vet Outbreak Session, Status = In Progress
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakType("Veterinary");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.enterOutbreakStatus("In Progress");
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.clickSearch();

            //Random select an existing session
            SearchOutbreakPage.SearchOutbreak.SearchCriteria.randomSelectOutbreakSessionID();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.OutbreakSummary.IsAt, "This is not the Outbreak Summary section");

            //Create a new Veterinary Disease Report
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickCreateCase();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.Cases.clickVeterinary();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.IsAt, "This is not the Search Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.clickSearch();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select the Farm
            SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Notification.IsAt, "This is not the Notification section");

            //Navigate to Lab Tests & Interpretation section
            //Verify section displays correctly
            OutbreakVetDiseaseRptPage.clickLabTestsInterpretLink();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.LabTestInterpret.IsAt, "This is not the Lab Tests & Interpretation section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Search Person Disease Report | Person page")]
        //public void VerifyHumanCasesSearchPersonDiseaseReportPersonPageDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Search Person Disease Report | Person page");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickPersonMenuItem();
        //    Assert.IsTrue(SearchPersonDiseaseReportPage.IsAt, "This is not the Person Information Page");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Person | Search Criteria section")]
        //public void VerifyHumanPersonSearchCriteriaSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Human | Person | Search Criteria section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickPersonMenuItem();
        //    Assert.IsTrue(SearchPersonPage.SearchCriteria.IsAt, "This is not the Search Criteria Page");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Person | Search Criteria section - Beta")]
        public void VerifyHumanPersonSearchCriteriaSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Person | Search Criteria section - Beta")
                   .AssignCategory("Human");

            //Loginto EIDSS
            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Person
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickPersonMenuItem();
            Assert.IsTrue(SearchPersonPage.SearchCriteria.IsAt, "This is not the Search Criteria Page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Disease Report | Search Parameters section")]
        //public void VerifyHumanSearchPersonDiseaseReportSearchParametersSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Search Person Disease Report | Search Parameters section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickDiseaseReports();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.Search.IsAt, "This is not the Search Criteria section");

        //    SearchPersonDiseaseReportPage.clickSearch();
        //    Assert.IsTrue(SearchPersonDiseaseReportPage.SearchParameters.IsAt, "This is not the Search Parameters section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Person | Search Results section")]
        public void VerifyHumanPersonSearchResultsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Person | Search Results section")
                   .AssignCategory("Human");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Person
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickPersonMenuItem();
            Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person page");

            //Search for an existing person
            SearchPersonPage.SearchCriteria.clearPersonIDField();
            SearchPersonPage.SearchCriteria.enterPersonID("PER");
            SearchPersonPage.clickSearch();
            Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Person | Person Information section via Person ID hyperlink")]
        public void VerifyHumanPersonPersonInformationSectionDisplayThroughPersonIDHyperlink()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Person | Person Information section via Person ID hyperlink")
                   .AssignCategory("Human");

            //Loginto EIDSS
            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Person
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickPersonMenuItem();
            Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person Page");

            //Enter search parameters and select a person from the grid
            SearchPersonPage.SearchCriteria.clearPersonIDField();
            SearchPersonPage.SearchCriteria.enterPersonID("PER");
            SearchPersonPage.clickSearch();

            SearchPersonDiseaseReportPage.clickCreateNewPersonRecord();
            Assert.IsTrue(CreateNewPersonPage.PersonInformation.IsAt, "This is not the Person Information section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Person | Person Information section")]
        public void VerifyHumanPersonPersonInformationSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Person | Person Information section")
                   .AssignCategory("Human");

            //Loginto EIDSS
            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Person
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickPersonMenuItem();
            Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person Page");

            //Enter search parameters and select a person from the grid
            SearchPersonPage.SearchCriteria.clearPersonIDField();
            SearchPersonPage.SearchCriteria.enterPersonID("PER");
            SearchPersonPage.clickSearch();

            SearchPersonDiseaseReportPage.clickCreateNewPersonRecord();
            Assert.IsTrue(CreateNewPersonPage.PersonInformation.IsAt, "This is not the Person Information section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Person | Person Address section")]
        public void VerifyHumanPersonPersonAddressSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Person | Person Address section")
                   .AssignCategory("Human");

            //Loginto EIDSS
            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Person
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickPersonMenuItem();
            Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person Page");

            //Enter search parameters and select a person from the grid
            SearchPersonPage.SearchCriteria.clearPersonIDField();
            SearchPersonPage.SearchCriteria.enterPersonID("PER");
            SearchPersonPage.clickSearch();

            SearchPersonDiseaseReportPage.clickCreateNewPersonRecord();
            CreateNewPersonPage.clickNext();
            Assert.IsTrue(CreateNewPersonPage.PersonAddress.IsAt, "This is not the Person Address section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Person | Person Employment/School Information section")]
        public void VerifyHumanPersonPersonEmploySchoolInformationSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Person | Person Employment/School Information section")
                   .AssignCategory("Human");

            //Loginto EIDSS
            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Person
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickPersonMenuItem();
            Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person Page");

            //Enter search parameters and select a person from the grid
            SearchPersonPage.SearchCriteria.clearPersonIDField();
            SearchPersonPage.SearchCriteria.enterPersonID("PER");
            SearchPersonPage.clickSearch();

            SearchPersonDiseaseReportPage.clickCreateNewPersonRecord();
            Assert.IsTrue(CreateNewPersonPage.PersonInformation.IsAt, "This is not the Person Information section");

            CreateNewPersonPage.clickPersonAddress();
            CreateNewPersonPage.clickNext();
            Assert.IsTrue(CreateNewPersonPage.PersonEmployment.IsAt, "This is not the Person Employment/School section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Person | Person Review section")]
        public void VerifyHumanPersonPersonReviewSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Person | Person Review section")
                   .AssignCategory("Human");

            //Loginto EIDSS
            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Person
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickPersonMenuItem();
            Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person Page");

            //Search for an existing person
            SearchPersonPage.SearchCriteria.clearPersonIDField();
            SearchPersonPage.SearchCriteria.enterPersonID("PER");
            SearchPersonPage.clickSearch();
            Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

            SearchPersonDiseaseReportPage.clickCreateNewPersonRecord();
            CreateNewPersonPage.clickPersonAddress();
            CreateNewPersonPage.clickNext();
            CreateNewPersonPage.clickPersonReview();
            Assert.IsTrue(CreateNewPersonPage.PersonInformation.IsAt, "This is not the Person Information section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Person | Person Review | Person Address section")]
        public void VerifyHumanPersonPersonReviewPersonAddressSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Person | Person Review | Person Address section")
                   .AssignCategory("Human");

            //Loginto EIDSS
            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Person
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickPersonMenuItem();
            Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person Page");

            //Enter search parameters and select a person from the grid
            SearchPersonPage.SearchCriteria.clearPersonIDField();
            SearchPersonPage.SearchCriteria.enterPersonID("PER");
            SearchPersonPage.clickSearch();
            Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

            SearchPersonDiseaseReportPage.clickCreateNewPersonRecord();
            Assert.IsTrue(CreateNewPersonPage.PersonInformation.IsAt, "This is not the Person Information section");

            //Click Review and verify Person Address displays
            CreateNewPersonPage.clickPersonReview();
            Assert.IsTrue(CreateNewPersonPage.PersonReview.PersonAddress.IsAt, "This is not the Person Address section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Person | Person Review | Person Employment/School section")]
        public void VerifyHumanPersonPersonReviewPersonEmploySchoolSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Person | Person Review | Person Employment/School section")
                   .AssignCategory("Human");

            //Loginto EIDSS
            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Person
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickPersonMenuItem();
            Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person Page");

            //Enter search parameters and select a person from the grid
            SearchPersonPage.SearchCriteria.clearPersonIDField();
            SearchPersonPage.SearchCriteria.enterPersonID("PER");
            SearchPersonPage.clickSearch();
            Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

            //Click Add
            SearchPersonDiseaseReportPage.clickCreateNewPersonRecord();
            Assert.IsTrue(CreateNewPersonPage.PersonInformation.IsAt, "This is not the Person Information section");

            //Go to Review section and verify Person Employment/School section
            CreateNewPersonPage.clickPersonAddress();
            CreateNewPersonPage.clickNext();
            CreateNewPersonPage.clickPersonReview();
            Assert.IsTrue(CreateNewPersonPage.PersonReview.PersonEmploymentSchool.IsAt, "This is not the Person Employment/School section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        ////NOTE: THIS TEST WAS REMOVED BY PM. THE ADD BUTTON SHOULD NOT BE DISPLAYED AND USER SHOULD NOT
        ////BE ALLOWED TO ADD AN OUTBREAK FROM PERSON RECORD.  OUTBREAK SECTION STAYS HIDDEN UNLESS A DISEASE
        ////REPORT IS CREATED FOR THAT PERSON AND IT IS ATTACHED TO AN OUTBREAK CASE
        //[Description("Verify user can navigate to the Human | Person | Person Review | Outbreak Case Reports section")]
        //public void VerifyHumanPersonPersonReviewOutbreakCaseReportsSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Person | Person Review | Outbreak Case Reports section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickPersonMenuItem();
        //    Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person Page");

        //    //Search for an existing person
        //    SearchPersonPage.SearchCriteria.clearPersonIDField();
        //    SearchPersonPage.SearchCriteria.enterPersonID("PER");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Random select person from grid
        //    SearchPersonPage.SearchResults.randomSelectPersonFromGrid();
        //    Assert.IsTrue(CreateNewPersonPage.PersonInformation.IsAt, "This is not the Person Information section");

        //    //Click the Review tab
        //    //Verify Farms section displays
        //    CreateNewPersonPage.clickPersonReview();
        //    Assert.IsTrue(CreateNewPersonPage.PersonReview.OutbreakCaseReports.IsAt, "This is not the Outbreak Case Reports section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}



        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Person | Person Review | Farms section")]
        //public void VerifyHumanPersonPersonReviewFarmsSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Person | Person Review | Farms section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickPersonMenuItem();
        //    Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person Page");

        //    //Search for an existing person
        //    SearchPersonPage.SearchCriteria.clearPersonIDField();
        //    SearchPersonPage.SearchCriteria.enterPersonID("PER");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Random select person from grid
        //    SearchPersonPage.SearchResults.randomSelectPersonFromGrid();
        //    Assert.IsTrue(CreateNewPersonPage.PersonInformation.IsAt, "This is not the Person Information section");

        //    //Click the Review tab
        //    //Verify Farms section displays
        //    CreateNewPersonPage.clickPersonReview();
        //    Assert.IsTrue(CreateNewPersonPage.PersonReview.Farms.IsAt, "This is not the Farms section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Person | Person Review | Disease Reports section")]
        public void VerifyHumanPersonPersonReviewDiseaseReportsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Person | Person Review | Disease Reports section")
                   .AssignCategory("Human");

            //Loginto EIDSS
            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Person
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickPersonMenuItem();
            Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person Page");

            //Search for an existing person
            SearchPersonPage.SearchCriteria.clearPersonIDField();
            SearchPersonPage.SearchCriteria.enterPersonID("PER");
            SearchPersonPage.clickSearch();
            Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

            //Random select person from grid
            SearchPersonPage.SearchResults.randomSelectPersonFromGrid();
            Assert.IsTrue(CreateNewPersonPage.PersonInformation.IsAt, "This is not the Person Information section");

            //Click the Review tab
            //Verify Farms section displays
            CreateNewPersonPage.clickPersonReview();
            Assert.IsTrue(CreateNewPersonPage.PersonReview.DiseaseReports.IsAt, "This is not the Disease Reports section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Person | Search Criteria section")]
        public void VerifyHumanPersonPersonHumanDiseaseReportPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("VeVerify user can navigate to the Human | Person | Search Criteria section")
                   .AssignCategory("Human");

            //Loginto EIDSS
            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Person
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickPersonMenuItem();
            Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person Page");

            //Enter search parameters and select a person from the grid
            SearchPersonPage.SearchCriteria.clearPersonIDField();
            SearchPersonPage.SearchCriteria.enterPersonID("PER");
            SearchPersonPage.clickSearch();

            SearchPersonPage.SearchResults.randomSelectPersonFromGrid();
            Assert.IsTrue(CreateNewPersonPage.IsAt, "This is not the Person page");

            //Click Add Disease Report
            CreateNewPersonPage.clickPersonReview();
            Assert.IsTrue(CreateNewPersonPage.PersonReview.DiseaseReports.IsAt, "This is not the Disease Reports section");

            CreateNewPersonPage.clickPopupAddDiseaseReport();
            Assert.IsTrue(CreateHumanDiseaseReportPage.IsAt, "This is not the Human Disease Report");

            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
            //extent.EndTest(test);
        }


        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Disease Report | Human Disease Report page")]
        public void VerifyHumanSearchDiseaseReportsPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Human Disease Report page")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickDiseaseReports();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Human Disease Report Page");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }




        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Search Disease Reports | Search Disease Reports section")]
        //public void VerifyHumanSearchDiseaseReportsPageDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Search Disease Report | Search Disease Reports section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickDiseaseReports();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Disease Reports | Search Criteria section")]
        public void VerifyHumanDiseaseReportsSearchCriteriaSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Disease Reports | Search Criteria section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickDiseaseReports();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchCriteria.IsAt, "This is not the Search Criteria section");
            //Assert.IsTrue(SearchHumanDiseaseReportsPage.Search.IsAt, "This is not the Search section");

            //SearchHumanDiseaseReportsPage.Search.enterReportID("H");
            //SearchHumanDiseaseReportsPage.clickSearch();
            //SearchHumanDiseaseReportsPage.clickSearch();
            //Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Disease Reports | Search Results section")]
        public void VerifyHumanDiseaseReportsSearchResultsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Search Disease Reports | Search Results section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickDiseaseReports();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

            SearchHumanDiseaseReportsPage.Search.enterReportID("H");
            SearchHumanDiseaseReportsPage.clickSearch();
            SearchHumanDiseaseReportsPage.clickSearch();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Disease Report | Human Disease Report page")]
        //public void VerifyAddHumanDiseaseReportPageDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Human | Disease Report | Human Disease Report page");

        //    LoginPage.AJLoginIntoEIDSS();

        //    //Navigate to Disease Reports
        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickDiseaseReports();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

        //    //Enter parameters and click "Search"
        //    SearchHumanDiseaseReportsPage.Search.enterReportID("H");
        //    SearchHumanDiseaseReportsPage.clickSearch();
        //    //SearchHumanDiseaseReportsPage.clickSearch();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Click "Add" to add a new report
        //    SearchHumanDiseaseReportsPage.clickAddNewReport();
        //    Assert.IsTrue(SearchPersonPage.SearchCriteria.IsAt, "This is not the Search criteria section");

        //    //Search for a person(s)
        //    SearchPersonPage.SearchCriteria.enterPersonFirstName("Test");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Select first person record in the table
        //    SearchPersonPage.SearchResults.selectFirstRowPersonFromGrid();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.IsAt, "This is not the Human Disease Report page");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Disease Summary Report section")]
        //public void VerifyAddHumanDiseaseReportDiseaseSummaryReportSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Disease Summary Report section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    //Navigate to Disease Reports
        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickDiseaseReports();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

        //    //Enter parameters and click "Search"
        //    SearchHumanDiseaseReportsPage.Search.enterReportID("H");
        //    SearchHumanDiseaseReportsPage.clickSearch();
        //    //SearchHumanDiseaseReportsPage.clickSearch();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Click "Add" to add a new report
        //    SearchHumanDiseaseReportsPage.clickAddNewReport();
        //    Assert.IsTrue(SearchPersonPage.SearchCriteria.IsAt, "This is not the Search criteria section");

        //    //Search for a person or persons
        //    SearchPersonPage.SearchCriteria.enterPersonFirstName("Test");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Select first person record in the table
        //    SearchPersonPage.SearchResults.selectFirstRowPersonFromGrid();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseReportSummary.IsAt, "This is not the Disease Summary Report section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Disease Notification section")]
        //public void VerifyAddHumanDiseaseReportDiseaseNotificationSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Disease Notification section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    //Navigate to Disease Reports
        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickDiseaseReports();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

        //    //Enter parameters and click "Search"
        //    SearchHumanDiseaseReportsPage.Search.enterReportID("H");
        //    SearchHumanDiseaseReportsPage.clickSearch();
        //    //SearchHumanDiseaseReportsPage.clickSearch();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Click "Add" to add a new report
        //    SearchHumanDiseaseReportsPage.clickAddNewReport();
        //    Assert.IsTrue(SearchPersonPage.SearchCriteria.IsAt, "This is not the Search criteria section");

        //    //Search for a person or persons
        //    SearchPersonPage.SearchCriteria.enterPersonFirstName("Test");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Select first person record in the table
        //    SearchPersonPage.SearchResults.selectFirstRowPersonFromGrid();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}


        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Clinical Information: Symptoms section")]
        //public void VerifyAddHumanDiseaseReportClinicalInfoSymptomsSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Clinical Information: Symptoms section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    //Navigate to Disease Reports
        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickDiseaseReports();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

        //    //Enter parameters and click "Search"
        //    SearchHumanDiseaseReportsPage.Search.enterReportID("H");
        //    SearchHumanDiseaseReportsPage.clickSearch();
        //    //SearchHumanDiseaseReportsPage.clickSearch();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Click "Add" to add a new report
        //    SearchHumanDiseaseReportsPage.clickAddNewReport();
        //    Assert.IsTrue(SearchPersonPage.SearchCriteria.IsAt, "This is not the Search criteria section");

        //    //Search for a person or persons
        //    SearchPersonPage.SearchCriteria.enterPersonFirstName("Test");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Select first person record in the table
        //    SearchPersonPage.SearchResults.selectFirstRowPersonFromGrid();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

        //    //Click next to go to the Symptoms section
        //    CreateHumanDiseaseReportPage.clickNext();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.ClinicalInformation.Symptoms.IsAt, "This is not the Clinical Information: Symptoms section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Clinical Information: Facility Details section")]
        //public void VerifyAddHumanDiseaseReportClinicalInfoFacilityDetailsSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Clinical Information: Facility Details section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    //Navigate to Disease Reports
        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickDiseaseReports();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

        //    //Enter parameters and click "Search"
        //    SearchHumanDiseaseReportsPage.Search.enterReportID("H");
        //    SearchHumanDiseaseReportsPage.clickSearch();
        //    //SearchHumanDiseaseReportsPage.clickSearch();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Click "Add" to add a new report
        //    SearchHumanDiseaseReportsPage.clickAddNewReport();
        //    Assert.IsTrue(SearchPersonPage.SearchCriteria.IsAt, "This is not the Search criteria section");

        //    //Search for a person or persons
        //    SearchPersonPage.SearchCriteria.enterPersonFirstName("Test");
        //    SearchPersonPage.clickSearch();
        //    //Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Select first person record in the table
        //    SearchPersonPage.SearchResults.selectFirstRowPersonFromGrid();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

        //    //Click next to go to the Clinical Information: Facility Details section
        //    CreateHumanDiseaseReportPage.clickNextToFacilityDetailsTab();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.ClinicalInformation.FacilityDetails.IsAt, "This is not the Clinical Information: Facility Details section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Clinical Information: Antibiotics section")]
        //public void VerifyAddHumanDiseaseReportClinicalInfoAntibioticsSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Clinical Information: Antibiotics section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    //Navigate to Disease Reports
        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickDiseaseReports();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

        //    //Enter parameters and click "Search"
        //    SearchHumanDiseaseReportsPage.Search.enterReportID("H");
        //    SearchHumanDiseaseReportsPage.clickSearch();
        //    //SearchHumanDiseaseReportsPage.clickSearch();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Click "Add" to add a new report
        //    SearchHumanDiseaseReportsPage.clickAddNewReport();
        //    Assert.IsTrue(SearchPersonPage.SearchCriteria.IsAt, "This is not the Search criteria section");

        //    //Search for a person or persons
        //    SearchPersonPage.SearchCriteria.enterPersonFirstName("Test");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Select first person record in the table
        //    SearchPersonPage.SearchResults.selectFirstRowPersonFromGrid();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

        //    //Click next to go to the Antibiotic / Vaccine History section
        //    CreateHumanDiseaseReportPage.clickNextToAntibioticVaccineTab();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.ClinicalInformation.Antibiotics.IsAt, "This is not the Clinical Information: Antibiotics section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Clinical Information: Vaccines section")]
        //public void VerifyAddHumanDiseaseReportClinicalInfoVaccinesSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Clinical Information: Vaccines section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    //Navigate to Disease Reports
        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickDiseaseReports();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

        //    //Enter parameters and click "Search"
        //    SearchHumanDiseaseReportsPage.Search.enterReportID("H");
        //    SearchHumanDiseaseReportsPage.clickSearch();
        //    //SearchHumanDiseaseReportsPage.clickSearch();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Click "Add" to add a new report
        //    SearchHumanDiseaseReportsPage.clickAddNewReport();
        //    Assert.IsTrue(SearchPersonPage.SearchCriteria.IsAt, "This is not the Search criteria section");

        //    //Search for a person or persons
        //    SearchPersonPage.SearchCriteria.enterPersonFirstName("Test");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Select first person record in the table
        //    SearchPersonPage.SearchResults.selectFirstRowPersonFromGrid();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

        //    //Click next to go to the Antibiotic / Vaccine History section
        //    CreateHumanDiseaseReportPage.clickNextToAntibioticVaccineTab();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.ClinicalInformation.Vaccines.IsAt, "This is not the Clinical Information: Vaccines section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Samples section")]
        //public void VerifyAddHumanDiseaseReportSamplesSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Samples section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    //Navigate to Disease Reports
        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickDiseaseReports();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

        //    //Enter parameters and click "Search"
        //    SearchHumanDiseaseReportsPage.Search.enterReportID("H");
        //    SearchHumanDiseaseReportsPage.clickSearch();
        //    //SearchHumanDiseaseReportsPage.clickSearch();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Click "Add" to add a new report
        //    SearchHumanDiseaseReportsPage.clickAddNewReport();
        //    Assert.IsTrue(SearchPersonPage.SearchCriteria.IsAt, "This is not the Search criteria section");

        //    //Search for a person or persons
        //    SearchPersonPage.SearchCriteria.enterPersonFirstName("Test");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Select first person record in the table
        //    SearchPersonPage.SearchResults.selectFirstRowPersonFromGrid();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

        //    //Click next to go to the Samples section
        //    CreateHumanDiseaseReportPage.clickNextToSamplesTab();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.Samples.IsAt, "This is not the Samples section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Tests section")]
        //public void VerifyAddHumanDiseaseReportTestsSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Tests section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    //Navigate to Disease Reports
        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickDiseaseReports();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

        //    //Enter parameters and click "Search"
        //    SearchHumanDiseaseReportsPage.Search.enterReportID("H");
        //    SearchHumanDiseaseReportsPage.clickSearch();
        //    //SearchHumanDiseaseReportsPage.clickSearch();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Click "Add" to add a new report
        //    SearchHumanDiseaseReportsPage.clickAddNewReport();
        //    Assert.IsTrue(SearchPersonPage.SearchCriteria.IsAt, "This is not the Search criteria section");

        //    //Search for a person or persons
        //    SearchPersonPage.SearchCriteria.enterPersonFirstName("Test");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Select first person record in the table
        //    SearchPersonPage.SearchResults.selectFirstRowPersonFromGrid();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

        //    //Click next to go to the Tests section
        //    CreateHumanDiseaseReportPage.clickNextToTestsTab();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.Tests.IsAt, "This is not the Tests section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Case Investigation: Details section")]
        //public void VerifyAddHumanDiseaseReportCaseInvestigationDetailsSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Case Investigation: Details section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    //Navigate to Disease Reports
        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickDiseaseReports();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

        //    //Enter parameters and click "Search"
        //    SearchHumanDiseaseReportsPage.Search.enterReportID("H");
        //    SearchHumanDiseaseReportsPage.clickSearch();
        //    //SearchHumanDiseaseReportsPage.clickSearch();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Click "Add" to add a new report
        //    SearchHumanDiseaseReportsPage.clickAddNewReport();
        //    Assert.IsTrue(SearchPersonPage.SearchCriteria.IsAt, "This is not the Search criteria section");

        //    //Search for a person or persons
        //    SearchPersonPage.SearchCriteria.enterPersonFirstName("Test");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Select first person record in the table
        //    SearchPersonPage.SearchResults.selectFirstRowPersonFromGrid();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

        //    //Click next to go to the Case Investigation: Details section
        //    CreateHumanDiseaseReportPage.clickNextToCaseInvestigationTab();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.CaseInvestigation.Details.IsAt, "This is not the Case Investigation: Details section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Case Investigation: Risk Factors section")]
        //public void VerifyAddHumanDiseaseReportCaseInvestigationRiskFactorsSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Case Investigation: Risk Factors section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    //Navigate to Disease Reports
        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickDiseaseReports();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

        //    //Enter parameters and click "Search"
        //    SearchHumanDiseaseReportsPage.Search.enterReportID("H");
        //    SearchHumanDiseaseReportsPage.clickSearch();
        //    //SearchHumanDiseaseReportsPage.clickSearch();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Click "Add" to add a new report
        //    SearchHumanDiseaseReportsPage.clickAddNewReport();
        //    Assert.IsTrue(SearchPersonPage.SearchCriteria.IsAt, "This is not the Search criteria section");

        //    //Search for a person or persons
        //    SearchPersonPage.SearchCriteria.enterPersonFirstName("Test");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Select first person record in the table
        //    SearchPersonPage.SearchResults.selectFirstRowPersonFromGrid();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

        //    //Click next to go to the Risk Factors section
        //    CreateHumanDiseaseReportPage.clickNextToRiskFactorsTab();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.CaseInvestigation.RiskFactors.IsAt, "This is not the Case Investigation: Risk Factors section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Case Investigation: Final Outcome section")]
        //public void VerifyAddHumanDiseaseReportCaseInvestigationFinalOutcomeSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Case Investigation: Final Outcome section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    //Navigate to Disease Reports
        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickDiseaseReports();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

        //    //Enter parameters and click "Search"
        //    SearchHumanDiseaseReportsPage.Search.enterReportID("H");
        //    SearchHumanDiseaseReportsPage.clickSearch();
        //    //SearchHumanDiseaseReportsPage.clickSearch();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Click "Add" to add a new report
        //    SearchHumanDiseaseReportsPage.clickAddNewReport();
        //    Assert.IsTrue(SearchPersonPage.SearchCriteria.IsAt, "This is not the Search criteria section");

        //    //Search for a person or persons
        //    SearchPersonPage.SearchCriteria.enterPersonFirstName("Test");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Select first person record in the table
        //    SearchPersonPage.SearchResults.selectFirstRowPersonFromGrid();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

        //    //Click next to go to the Final Outcome section
        //    CreateHumanDiseaseReportPage.clickFinalOutcomeTab();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.CaseInvestigation.FinalOutcome.IsAt, "This is not the Case Investigation: Final Outcome section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Case Investigation: Contact List section")]
        //public void VerifyAddHumanDiseaseReportCaseInvestigationContactListSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Add Human Disease Report | Case Investigation: Contact List section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    //Navigate to Disease Reports
        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickDiseaseReports();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

        //    //Enter parameters and click "Search"
        //    //SearchHumanDiseaseReportsPage.Search.enterReportID("H");
        //    SearchHumanDiseaseReportsPage.clickSearch();
        //    //SearchHumanDiseaseReportsPage.clickSearch();
        //    Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Click "Add" to add a new report
        //    SearchHumanDiseaseReportsPage.clickAddNewReport();
        //    Assert.IsTrue(SearchPersonPage.SearchCriteria.IsAt, "This is not the Search criteria section");

        //    //Search for a person or persons
        //    SearchPersonPage.SearchCriteria.enterPersonID("PER");
        //    SearchPersonPage.clickSearch();
        //    Assert.IsTrue(SearchPersonPage.SearchResults.IsAt, "This is not the Search Results section");

        //    //Select first person record in the table
        //    SearchPersonPage.SearchResults.randomSelectPersonFromGrid();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

        //    //Click next to go to the Contact List section
        //    CreateHumanDiseaseReportPage.clickContactListTab();
        //    Assert.IsTrue(CreateHumanDiseaseReportPage.CaseInvestigation.ContactList.IsAt, "This is not the Case Investigation: Contact List section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}


        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Disease Summary Report section")]
        public void VerifyEditHumanDiseaseReportDiseaseSummaryReportSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Disease Summary Report section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Disease Reports
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickDiseaseReports();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

            //Enter parameters and click "Search"
            SearchHumanDiseaseReportsPage.Search.enterReportID("H");
            SearchHumanDiseaseReportsPage.clickSearch();
            SearchHumanDiseaseReportsPage.clickSearch();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

            //Edit a Disease Report
            SearchHumanDiseaseReportsPage.SearchResults.randomEditHumanDiseaseRpt();
            Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseReportSummary.IsAt, "This is not the Disease Report Summary section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Disease Notification section")]
        public void VerifyEditHumanDiseaseReportDiseaseNotificationSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Disease Notification section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Disease Reports
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickDiseaseReports();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

            //Enter parameters and click "Search"
            SearchHumanDiseaseReportsPage.Search.enterReportID("H");
            SearchHumanDiseaseReportsPage.clickSearch();
            SearchHumanDiseaseReportsPage.clickSearch();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

            //Edit a Disease Report
            SearchHumanDiseaseReportsPage.SearchResults.randomEditHumanDiseaseRpt();
            Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Clinical Information: Symptoms section")]
        public void VerifyEditHumanDiseaseReportClinicalInfoSymptomsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Clinical Information: Symptoms section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Disease Reports
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickDiseaseReports();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

            //Enter parameters and click "Search"
            SearchHumanDiseaseReportsPage.Search.enterReportID("H");
            SearchHumanDiseaseReportsPage.clickSearch();
            SearchHumanDiseaseReportsPage.clickSearch();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

            //Edit a Disease Report
            SearchHumanDiseaseReportsPage.SearchResults.randomEditHumanDiseaseRpt();
            Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

            //Click next to go to the Symptoms section
            CreateHumanDiseaseReportPage.clickNext();
            Assert.IsTrue(CreateHumanDiseaseReportPage.ClinicalInformation.Symptoms.IsAt, "This is not the Clinical Information: Symptoms section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Clinical Information: Facility Details section")]
        public void VerifyEditHumanDiseaseReportClinicalInfoFacilityDetailsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Clinical Information: Facility Details section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Disease Reports
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickDiseaseReports();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

            //Enter parameters and click "Search"
            SearchHumanDiseaseReportsPage.Search.enterReportID("H");
            SearchHumanDiseaseReportsPage.clickSearch();
            SearchHumanDiseaseReportsPage.clickSearch();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

            //Edit a Disease Report
            SearchHumanDiseaseReportsPage.SearchResults.randomEditHumanDiseaseRpt();
            Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

            //Click next to go to the Clinical Information: Facility Details section
            CreateHumanDiseaseReportPage.clickNextToFacilityDetailsTab();
            Assert.IsTrue(CreateHumanDiseaseReportPage.ClinicalInformation.FacilityDetails.IsAt, "This is not the Clinical Information: Facility Details section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Clinical Information: Antibiotics section")]
        public void VerifyEditHumanDiseaseReportClinicalInfoAntibioticsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Clinical Information: Antibiotics section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Disease Reports
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickDiseaseReports();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

            //Enter parameters and click "Search"
            SearchHumanDiseaseReportsPage.Search.enterReportID("H");
            SearchHumanDiseaseReportsPage.clickSearch();
            SearchHumanDiseaseReportsPage.clickSearch();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

            //Edit a Disease Report
            SearchHumanDiseaseReportsPage.SearchResults.randomEditHumanDiseaseRpt();
            Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

            //Click next to go to the Antibiotic / Vaccine History section
            CreateHumanDiseaseReportPage.clickNextToAntibioticVaccineTab();
            Assert.IsTrue(CreateHumanDiseaseReportPage.ClinicalInformation.Antibiotics.IsAt, "This is not the Clinical Information: Antibiotics section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Clinical Information: Vaccines section")]
        public void VerifyEditHumanDiseaseReportClinicalInfoVaccinesSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Clinical Information: Vaccines section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Disease Reports
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickDiseaseReports();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

            //Enter parameters and click "Search"
            SearchHumanDiseaseReportsPage.Search.enterReportID("H");
            SearchHumanDiseaseReportsPage.clickSearch();
            SearchHumanDiseaseReportsPage.clickSearch();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

            //Edit a Disease Report
            SearchHumanDiseaseReportsPage.SearchResults.randomEditHumanDiseaseRpt();
            Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

            //Click next to go to the Antibiotic / Vaccine History section
            CreateHumanDiseaseReportPage.clickNextToAntibioticVaccineTab();
            Assert.IsTrue(CreateHumanDiseaseReportPage.ClinicalInformation.Vaccines.IsAt, "This is not the Clinical Information: Vaccines section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Samples section")]
        public void VerifyEditHumanDiseaseReportSamplesSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Samples section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Disease Reports
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickDiseaseReports();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

            //Enter parameters and click "Search"
            SearchHumanDiseaseReportsPage.Search.enterReportID("H");
            SearchHumanDiseaseReportsPage.clickSearch();
            SearchHumanDiseaseReportsPage.clickSearch();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

            //Edit a Disease Report
            SearchHumanDiseaseReportsPage.SearchResults.randomEditHumanDiseaseRpt();
            Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

            //Click next to go to the Samples section
            CreateHumanDiseaseReportPage.clickNextToSamplesTab();
            Assert.IsTrue(CreateHumanDiseaseReportPage.Samples.IsAt, "This is not the Samples section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Tests section")]
        public void VerifyEditHumanDiseaseReportTestsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Tests section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Disease Reports
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickDiseaseReports();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

            //Enter parameters and click "Search"
            SearchHumanDiseaseReportsPage.Search.enterReportID("H");
            SearchHumanDiseaseReportsPage.clickSearch();
            SearchHumanDiseaseReportsPage.clickSearch();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

            //Edit a Disease Report
            SearchHumanDiseaseReportsPage.SearchResults.randomEditHumanDiseaseRpt();
            Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

            //Click next to go to the Tests section
            CreateHumanDiseaseReportPage.clickNextToTestsTab();
            Assert.IsTrue(CreateHumanDiseaseReportPage.Tests.IsAt, "This is not the Tests section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Case Investigation: Details section")]
        public void VerifyEditHumanDiseaseReportCaseInvestigationDetailsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Case Investigation: Details section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Disease Reports
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickDiseaseReports();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

            //Enter parameters and click "Search"
            SearchHumanDiseaseReportsPage.Search.enterReportID("H");
            SearchHumanDiseaseReportsPage.clickSearch();
            SearchHumanDiseaseReportsPage.clickSearch();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

            //Edit a Disease Report
            SearchHumanDiseaseReportsPage.SearchResults.randomEditHumanDiseaseRpt();
            Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

            //Click next to go to the Case Investigation: Details section
            CreateHumanDiseaseReportPage.clickNextToCaseInvestigationTab();
            Assert.IsTrue(CreateHumanDiseaseReportPage.CaseInvestigation.Details.IsAt, "This is not the Case Investigation: Details section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Case Investigation: Risk Factors section")]
        public void VerifyEditHumanDiseaseReportCaseInvestigationRiskFactorsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Case Investigation: Risk Factors section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Disease Reports
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickDiseaseReports();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

            //Enter parameters and click "Search"
            SearchHumanDiseaseReportsPage.Search.enterReportID("H");
            SearchHumanDiseaseReportsPage.clickSearch();
            SearchHumanDiseaseReportsPage.clickSearch();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

            //Edit a Disease Report
            SearchHumanDiseaseReportsPage.SearchResults.randomEditHumanDiseaseRpt();
            Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

            //Click next to go to the Risk Factors section
            CreateHumanDiseaseReportPage.clickNextToRiskFactorsTab();
            Assert.IsTrue(CreateHumanDiseaseReportPage.CaseInvestigation.RiskFactors.IsAt, "This is not the Case Investigation: Risk Factors section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Case Investigation: Final Outcome section")]
        public void VerifyEditHumanDiseaseReportCaseInvestigationFinalOutcomeSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Case Investigation: Final Outcome section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Disease Reports
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickDiseaseReports();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

            //Enter parameters and click "Search"
            SearchHumanDiseaseReportsPage.Search.enterReportID("H");
            SearchHumanDiseaseReportsPage.clickSearch();
            SearchHumanDiseaseReportsPage.clickSearch();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

            //Edit a Disease Report
            SearchHumanDiseaseReportsPage.SearchResults.randomEditHumanDiseaseRpt();
            Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

            //Click next to go to the Final Outcome section
            CreateHumanDiseaseReportPage.clickFinalOutcomeTab();
            Assert.IsTrue(CreateHumanDiseaseReportPage.CaseInvestigation.FinalOutcome.IsAt, "This is not the Case Investigation: Final Outcome section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Case Investigation: Contact List section")]
        public void VerifyEditHumanDiseaseReportCaseInvestigationContactListSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Disease Report | Edit Human Disease Report | Case Investigation: Contact List section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Disease Reports
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickDiseaseReports();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.IsAt, "This is not the Search Disease Reports Page");

            //Enter parameters and click "Search"
            SearchHumanDiseaseReportsPage.Search.enterReportID("H");
            SearchHumanDiseaseReportsPage.clickSearch();
            SearchHumanDiseaseReportsPage.clickSearch();
            Assert.IsTrue(SearchHumanDiseaseReportsPage.SearchResults.IsAt, "This is not the Search Results section");

            //Edit a Disease Report
            SearchHumanDiseaseReportsPage.SearchResults.randomEditHumanDiseaseRpt();
            Assert.IsTrue(CreateHumanDiseaseReportPage.DiseaseNotification.IsAt, "This is not the Disease Notification section");

            //Click next to go to the Contact List section
            CreateHumanDiseaseReportPage.clickContactListTab();
            Assert.IsTrue(CreateHumanDiseaseReportPage.CaseInvestigation.ContactList.IsAt, "This is not the Case Investigation: Contact List section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Active Surveillance Campaign | Active Surveillance Campaign page")]
        public void VerifyHumanHumanActiveSurvCampaignPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Campaign | Active Surveillance Campaign page")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickActiveSurvCampaign();
            Assert.IsTrue(SearchHumanActiveSurvCampaignPage.IsAt, "This is not the Human Active Surveillance Campaign Page");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        //[Test]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Human Active Surveillance Campaign | Search section")]
        //public void VerifyHumanHumanActiveSurvCampaignSearchSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Campaign | Search section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickHumanActSurvCampaign();
        //    Assert.IsTrue(SearchHumanActiveSurvCampaignPage.SearchCriteria.IsAt, "This is not the Search section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Active Surveillance Campaign | Search Criteria section")]
        public void VerifyHumanHumanActiveSurvCampaignSearchCriteriaSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Campaign | Search Criteria section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Active Surveillance Campaign
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickActiveSurvCampaign();
            Assert.IsTrue(SearchHumanActiveSurvCampaignPage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Enter 1 or more parameters
            SearchHumanActiveSurvCampaignPage.SearchCriteria.enterStartDate();
            SearchHumanActiveSurvCampaignPage.SearchCriteria.enterEndDate();
            SearchHumanActiveSurvCampaignPage.clickSearch();
            Assert.IsTrue(SearchHumanActiveSurvCampaignPage.SearchCriteria.IsAt, "This is not the Search Criteria section");
            //Log out of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
            Assert.True(test.GetTest().CategoryList.Count == 1);
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Active Surveillance Campaign | Search Results section")]
        public void VerifyHumanHumanActiveSurvCampaignSearchResultsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Campaign | Search Results section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickActiveSurvCampaign();
            Assert.IsTrue(SearchHumanActiveSurvCampaignPage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            SearchHumanActiveSurvCampaignPage.SearchCriteria.enterStartDate();
            SearchHumanActiveSurvCampaignPage.SearchCriteria.enterEndDate();

            SearchHumanActiveSurvCampaignPage.clickSearch();
            Assert.IsTrue(SearchHumanActiveSurvCampaignPage.SearchResults.IsAt, "This is not the Search Results section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Active Surveillance Campaign | Campaign Information section")]
        public void VerifyHumanHumanActiveSurvCampaignCampaignInformationSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Campaign | Campaign Information section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickActiveSurvCampaign();
            Assert.IsTrue(SearchHumanActiveSurvCampaignPage.IsAt, "This is not the Active Surveillance Campaign Page");

            SearchHumanActiveSurvCampaignPage.SearchCriteria.enterStartDate();
            SearchHumanActiveSurvCampaignPage.SearchCriteria.enterEndDate();
            SearchHumanActiveSurvCampaignPage.clickSearch();
            SearchHumanActiveSurvCampaignPage.clickCreateCampaign();
            Assert.IsTrue(CreateHumanActiveSurvCampaignPage.CampaignInformation.IsAt, "This is not the Campaign Information section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Active Surveillance Campaign | Samples section")]
        public void VerifyHumanHumanActiveSurvCampaignSamplesSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Campaign | Samples section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickActiveSurvCampaign();
            Assert.IsTrue(SearchHumanActiveSurvCampaignPage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            SearchHumanActiveSurvCampaignPage.SearchCriteria.enterStartDate();
            SearchHumanActiveSurvCampaignPage.SearchCriteria.enterEndDate();
            SearchHumanActiveSurvCampaignPage.clickSearch();
            SearchHumanActiveSurvCampaignPage.clickCreateCampaign();
            //CreateHumanActiveSurvCampaignPage.clickSamplesLink();
            Assert.IsTrue(CreateHumanActiveSurvCampaignPage.Samples.IsAt, "This is not the Samples section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Active Surveillance Campaign | Sessions section")]
        public void VerifyHumanHumanActiveSurvCampaignSessionsSessionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Campaign | Sessions section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickActiveSurvCampaign();
            Assert.IsTrue(SearchHumanActiveSurvCampaignPage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            SearchHumanActiveSurvCampaignPage.SearchCriteria.clearCampaignNameField();
            SearchHumanActiveSurvCampaignPage.SearchCriteria.clearCampaignStartDateFromField();
            SearchHumanActiveSurvCampaignPage.SearchCriteria.enterPastStartDate("1/1/1900");

            SearchHumanActiveSurvCampaignPage.clickSearch();
            SearchHumanActiveSurvCampaignPage.SearchResults.randomSelectCampaignRecord();
            Assert.IsTrue(CreateHumanActiveSurvCampaignPage.Sessions.IsAt, "This is not the Sessions section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Active Surveillance Campaign | Conclusion section")]
        public void VerifyHumanHumanActiveSurvCampaignConclusionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Campaign | Conclusion section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickActiveSurvCampaign();
            Assert.IsTrue(SearchHumanActiveSurvCampaignPage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            SearchHumanActiveSurvCampaignPage.SearchCriteria.clearCampaignNameField();
            SearchHumanActiveSurvCampaignPage.SearchCriteria.clearCampaignStartDateFromField();
            SearchHumanActiveSurvCampaignPage.SearchCriteria.enterPastStartDate("1/1/1900");

            SearchHumanActiveSurvCampaignPage.clickSearch();
            SearchHumanActiveSurvCampaignPage.SearchResults.randomSelectCampaignRecord();
            Assert.IsTrue(CreateHumanActiveSurvCampaignPage.Sessions.IsAt, "This is not the Sessions section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Active Surveillance Session | Human Active Surveillance Session page")]
        public void VerifyHumanHumanActiveSurvSessionPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Session | Human Active Surveillance Session page")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickActiveSurvSession();
            Assert.IsTrue(SearchHumanActiveSurvSessionPage.IsAt, "This is not the Human Active Surveillance Session Page");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        //[Test]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Human Active Surveillance Session | Session section")]
        //public void VerifyHumanHumanActiveSurvSessionSearchSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Session | Session section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickHumanActSurvSession();
        //    Assert.IsTrue(SearchHumanActiveSurvSessionPage.Search.IsAt, "This is not the Search section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Active Surveillance Session | Session Criteria section")]
        public void VerifyHumanHumanActiveSurvSessionSearchCriteriaSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Session | Session Criteria section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickActiveSurvSession();
            Assert.IsTrue(SearchHumanActiveSurvSessionPage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Active Surveillance Session | Search Results section")]
        public void VerifyHumanHumanActiveSurvSessionSearchResultsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Session | Search Results section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickActiveSurvSession();
            Assert.IsTrue(SearchHumanActiveSurvSessionPage.SearchCriteria.IsAt, "This is not the Search Criteria section");
            //SearchHumanActiveSurvSessionPage.Search.enterFromDate();
            //SearchHumanActiveSurvSessionPage.Search.enterToDate();
            //SearchHumanActiveSurvSessionPage.clickSearch();
            SearchHumanActiveSurvSessionPage.clickSearch();
            Assert.IsTrue(SearchHumanActiveSurvSessionPage.SearchResults.IsAt, "This is not the Search Results section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Active Surveillance Session | Session Information section")]
        public void VerifyHumanHumanActiveSurvSessionSearchSessionInfoSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Session | Session Information section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickActiveSurvSession();
            Assert.IsTrue(SearchHumanActiveSurvSessionPage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Click Add button
            SearchHumanActiveSurvSessionPage.clickCreateSession();
            Assert.IsTrue(CreateHumanActiveSurvSessionPage.SessionInformation.IsAt, "This is not the Search Information section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Active Surveillance Session | Session Location section")]
        public void VerifyHumanHumanActiveSurvSessionSearchSessionLocationSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Session | Session Location section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Active Surveillance Session | Human Active Surveillance Session
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickActiveSurvSession();
            Assert.IsTrue(SearchHumanActiveSurvSessionPage.IsAt, "This is not the Human Active Surveillance Session page");

            //Enter Search Criteria
            SearchHumanActiveSurvSessionPage.Search.enterFromDate();
            SearchHumanActiveSurvSessionPage.Search.enterToDate();
            SearchHumanActiveSurvSessionPage.clickSearch();

            SearchHumanActiveSurvSessionPage.clickCreateSession();
            Assert.IsTrue(CreateHumanActiveSurvSessionPage.SessionLocation.IsAt, "This is not the Search Location section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Active Surveillance Session | Sample Types section")]
        public void VerifyHumanHumanActiveSurvSessionCreateSampleTypesSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Session | Sample Types section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Active Surveillance Session
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickActiveSurvSession();
            Assert.IsTrue(SearchHumanActiveSurvSessionPage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Click Add to create new Session
            SearchHumanActiveSurvSessionPage.clickCreateSession();
            //Assert.IsTrue(CreateHumanActiveSurvSessionPage.SessionLocation.IsAt, "This is not the Session Location section");

            //Click the Sample Types link
            //CreateHumanActiveSurvSessionPage.clickSamplesLink();
            Assert.IsTrue(CreateHumanActiveSurvSessionPage.SampleTypes.IsAt, "This is not the Sample Types section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Active Surveillance Session | Person & Samples section")]
        public void VerifyHumanHumanActiveSurvSessionPersonAndSamplesSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Session | Person & Samples section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Active Surveillance Session
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickActiveSurvSession();
            Assert.IsTrue(SearchHumanActiveSurvSessionPage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Clear any data in the Date Range fields
            //Enter a date range
            SearchHumanActiveSurvSessionPage.SearchCriteria.clearDateFromField();
            SearchHumanActiveSurvSessionPage.SearchCriteria.enterSrchDateFrom("01/01/1900");
            SearchHumanActiveSurvSessionPage.SearchCriteria.clearDateToField();
            SearchHumanActiveSurvSessionPage.SearchCriteria.enterSrchDateTo();

            //Clear Region field which will automatically clear Rayon field
            SearchHumanActiveSurvSessionPage.SearchCriteria.clearRegionField();

            //Search for an existing session
            SearchHumanActiveSurvSessionPage.clickSearch();
            //SearchHumanActiveSurvSessionPage.SearchResults.randomSelectSessionRecord();
            SearchHumanActiveSurvSessionPage.SearchResults.randomEditSessionRecord();
            SearchHumanActiveSurvSessionPage.doesRetrievingDataErrorMessageDisplay();
            Assert.IsTrue(CreateHumanActiveSurvSessionPage.SessionInformation.IsAt, "This is not the Search Information section");

            //Click the Person & Samples link
            CreateHumanActiveSurvSessionPage.clickPersonAndSamplesLink();
            Assert.IsTrue(CreateHumanActiveSurvSessionPage.PersonAndSamples.IsAt, "This is not the Person & Samples section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Active Surveillance Session | Actions section")]
        public void VerifyHumanHumanActiveSurvSessionActionsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Session | Actions section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Active Surveillance Session
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickActiveSurvSession();
            Assert.IsTrue(SearchHumanActiveSurvSessionPage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Clear any data in the Date Range fields
            //Enter a date range
            SearchHumanActiveSurvSessionPage.SearchCriteria.clearDateFromField();
            SearchHumanActiveSurvSessionPage.SearchCriteria.enterSrchDateFrom("01/01/1900");
            SearchHumanActiveSurvSessionPage.SearchCriteria.clearDateToField();
            SearchHumanActiveSurvSessionPage.SearchCriteria.enterSrchDateTo();

            //Clear Region field which will automatically clear Rayon field
            SearchHumanActiveSurvSessionPage.SearchCriteria.clearRegionField();

            //Search for an existing session
            SearchHumanActiveSurvSessionPage.clickSearch();
            //SearchHumanActiveSurvSessionPage.SearchResults.randomSelectSessionRecord();
            SearchHumanActiveSurvSessionPage.SearchResults.randomEditSessionRecord();
            SearchHumanActiveSurvSessionPage.doesRetrievingDataErrorMessageDisplay();
            Assert.IsTrue(CreateHumanActiveSurvSessionPage.SessionInformation.IsAt, "This is not the Search Information section");

            //Click the Person & Samples link
            CreateHumanActiveSurvSessionPage.clickActionsLink();
            Assert.IsTrue(CreateHumanActiveSurvSessionPage.Actions.IsAt, "This is not the Actions section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Active Surveillance Session | Disease Reports section")]
        public void VerifyHumanHumanActiveSurvSessionDiseaseReportsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Session | Disease Reports section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Active Surveillance Session
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickActiveSurvSession();
            Assert.IsTrue(SearchHumanActiveSurvSessionPage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Clear any data in the Date Range fields
            //Enter a date range
            SearchHumanActiveSurvSessionPage.SearchCriteria.clearDateFromField();
            SearchHumanActiveSurvSessionPage.SearchCriteria.enterSrchDateFrom("01/01/1900");
            SearchHumanActiveSurvSessionPage.SearchCriteria.clearDateToField();
            SearchHumanActiveSurvSessionPage.SearchCriteria.enterSrchDateTo();

            //Clear Region field which will automatically clear Rayon field
            SearchHumanActiveSurvSessionPage.SearchCriteria.clearRegionField();

            //Search for an existing session
            SearchHumanActiveSurvSessionPage.clickSearch();
            //SearchHumanActiveSurvSessionPage.SearchResults.randomSelectSessionRecord();
            SearchHumanActiveSurvSessionPage.SearchResults.randomEditSessionRecord();
            SearchHumanActiveSurvSessionPage.doesRetrievingDataErrorMessageDisplay();
            Assert.IsTrue(CreateHumanActiveSurvSessionPage.SessionInformation.IsAt, "This is not the Search Information section");

            //Click the Disease Report link
            CreateHumanActiveSurvSessionPage.clickDiseaseReportLink();
            Assert.IsTrue(CreateHumanActiveSurvSessionPage.DiseaseReport.IsAt, "This is not the Disease Reports section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Active Surveillance Session | Tests section")]
        public void VerifyHumanHumanActiveSurvSessionTestsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Active Surveillance Session | Tests section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Active Surveillance Session
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickActiveSurvSession();
            Assert.IsTrue(SearchHumanActiveSurvSessionPage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Clear any data in the Date Range fields
            //Enter a date range
            SearchHumanActiveSurvSessionPage.SearchCriteria.clearDateFromField();
            SearchHumanActiveSurvSessionPage.SearchCriteria.enterSrchDateFrom("01/01/1900");
            SearchHumanActiveSurvSessionPage.SearchCriteria.clearDateToField();
            SearchHumanActiveSurvSessionPage.SearchCriteria.enterSrchDateTo();

            //Clear Region field which will automatically clear Rayon field
            SearchHumanActiveSurvSessionPage.SearchCriteria.clearRegionField();

            //Search for an existing session
            SearchHumanActiveSurvSessionPage.clickSearch();
            //SearchHumanActiveSurvSessionPage.SearchResults.randomSelectSessionRecord();
            SearchHumanActiveSurvSessionPage.SearchResults.randomEditSessionRecord();
            SearchHumanActiveSurvSessionPage.doesRetrievingDataErrorMessageDisplay();
            Assert.IsTrue(CreateHumanActiveSurvSessionPage.SessionInformation.IsAt, "This is not the Search Information section");
            Assert.IsTrue(CreateHumanActiveSurvSessionPage.SessionInformation.IsAt, "This is not the Search Information section");


            //Click the Person & Samples link
            CreateHumanActiveSurvSessionPage.clickTestsLink();
            Assert.IsTrue(CreateHumanActiveSurvSessionPage.Tests.IsAt, "This is not the Tests section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | ILI Aggregate Form | ILI Aggregate page")]
        public void VerifyHumanILIAggregateFormPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | ILI Aggregate Form | ILI Aggregate page")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Active Surveillance Session
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickILIAggregateForm();
            Assert.IsTrue(SearchILIAggregatePage.IsAt, "This is not the ILI Aggregate page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | ILI Aggregate Form | Search Criteria section")]
        public void VerifyHumanILIAggregateFormSearchCriteriaSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | ILI Aggregate Form | Search Criteria section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | Active Surveillance Session
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickILIAggregateForm();
            Assert.IsTrue(SearchILIAggregatePage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | ILI Aggregate Form | Search Results section")]
        public void VerifyHumanILIAggregateFormSearchResultsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | ILI Aggregate Form | Search Results section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Human | ILI Aggregate Form | Search Results
            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickILIAggregateForm();
            Assert.IsTrue(SearchILIAggregatePage.IsAt, "This is not the ILI Aggregate page");

            //SearchILIAggregatePage.SearchCriteria.enterWeeksToDate();
            //SearchILIAggregatePage.SearchCriteria.enterWeeksFromDate(90);
            SearchILIAggregatePage.clickSearch();
            Assert.IsTrue(SearchILIAggregatePage.SearchResults.IsAt, "This is not the Search Results section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Aggregate | Human Aggregate Case page")]
        public void VerifyHumanHumanAggregateCasePageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Aggregate | Human Aggregate Case page")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickAggregateDiseaseReport();
            Assert.IsTrue(SearchHumanAggrCasePage.IsAt, "This is not the Human Aggregate Disease page");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Aggregate | Human Aggregate Case | Search Form section")]
        public void VerifyHumanHumanAggregateCaseSearchFormSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Aggregate Case | Search Form section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickAggregateDiseaseReport();
            Assert.IsTrue(SearchHumanAggrCasePage.IsAt, "This is not the Human Aggregate Disease page");

            SearchHumanAggrCasePage.clickSearch();
            Assert.IsTrue(SearchHumanAggrCasePage.SearchResults.IsAt, "This is not the Search Results section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Human | Human Aggregate | Human Aggregate Case | Human Aggregate Cases section")]
        public void VerifyHumanHumanAggregateCaseHumanAggregateCasesSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Human | Human Aggregate Case | Human Aggregate Cases section")
                   .AssignCategory("Human");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickHuman();
            MainMenuNavigation.Human.clickAggregateDiseaseReport();
            //SearchHumanAggrCasePage.clickSearch();
            Assert.IsTrue(SearchHumanAggrCasePage.HumanAggregateDisease.IsAt, "This is not the Human Aggregate Disease page");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        //[Test]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Human Aggregate | Human Aggregate Case | Human Aggregate Case Details section")]
        //public void VerifyHumanHumanAggregateCaseHumanAggregatCaseDetailsSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Human Aggregate Case | Human Aggregate Case Details section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickAggregateDiseaseReport();
        //    Assert.IsTrue(SearchHumanAggrCasePage.SearchForm.IsAt, "This is not the Search Form section");

        //    SearchHumanAggrCasePage.clickSearch();
        //    SearchHumanAggrCasePage.clickNewHAC();
        //    Assert.IsTrue(CreateHumanAggrCase.HumanAggregateCaseDetails.IsAt, "This is not the Human Aggregate Case Details section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        //[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Basic Syndromic Surveillance page")]
        //public void VerifyHumanBasicSyndromicSurvPageDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Basic Syndromic Surveillance page");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickBasicSyndSurvForm();
        //    Assert.IsTrue(BasicSyndromicSurveillance.IsAt, "This is not the Basic Syndromic Surveillance page");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        //[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Basic Syndromic Surveillance | Personal Information section")]
        //public void VerifyHumanBasicSyndromicSurvPersonalInfoSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Basic Syndromic Surveillance | Personal Information section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickBasicSyndSurvForm();
        //    Assert.IsTrue(BasicSyndromicSurveillance.PersonalInfo.IsAt, "This is not the Personal Information section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        //[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Basic Syndromic Surveillance | Symptoms section")]
        //public void VerifyHumanBasicSyndromicSurvSymptomsSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Basic Syndromic Surveillance | Symptoms section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickBasicSyndSurvForm();
        //    BasicSyndromicSurveillance.clickSymptoms();
        //    Assert.IsTrue(BasicSyndromicSurveillance.Symptoms.IsAt, "This is not the Symptoms section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        //[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Human | Basic Syndromic Surveillance | Samples section")]
        //public void VerifyHumanBasicSyndromicSurvSamplesSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Basic Syndromic Surveillance | Samples section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickHuman();
        //    MainMenuNavigation.Human.clickBasicSyndSurvForm();
        //    BasicSyndromicSurveillance.clickSamples();
        //    Assert.IsTrue(BasicSyndromicSurveillance.Samples.IsAt, "This is not the Samples section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Vector Surveillance Session page")]
        public void VerifyVectorSurveillanceSessionSearchPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session page")
                   .AssignCategory("Vector");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVector();
            MainMenuNavigation.Vector.clickSurveillanceSession();
            Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Vector Surveillance Session Page");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Vector Surveillance Session | Search Results section")]
        public void VerifyVectorSurveillanceSessionSearchResultsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Search Results section")
                   .AssignCategory("Vector");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVector();
            MainMenuNavigation.Vector.clickSurveillanceSession();
            Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

            //SearchVectorSurvSessionPage.clearStartDateFromField();
            SearchVectorSurvSessionPage.enterStartDateFrom(365);
            SearchVectorSurvSessionPage.enterStartDateTo(-1);
            SearchVectorSurvSessionPage.clickSearch();
            Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Vector Surveillance Session Page")]
        public void VerifyVectorSurveillanceSessionPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Search Results section")
                   .AssignCategory("Vector");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVector();
            MainMenuNavigation.Vector.clickSurveillanceSession();
            Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

            SearchVectorSurvSessionPage.clearStartDateFromField();
            SearchVectorSurvSessionPage.enterStartDateFrom(365);
            SearchVectorSurvSessionPage.enterStartDateTo(-1);
            SearchVectorSurvSessionPage.clickSearch();
            Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

            SearchVectorSurvSessionPage.clickCreateVectorSurveillance();
            Assert.IsTrue(CreateVectorSurvSessionPage.IsAt, "This is not the Vector Surveillance Session page");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Vector Surveillance Session | Location section")]
        public void VerifyVectorSurveillanceSessionPageLocationSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Location section")
                   .AssignCategory("Vector");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVector();
            MainMenuNavigation.Vector.clickSurveillanceSession();
            Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

            SearchVectorSurvSessionPage.clearStartDateFromField();
            SearchVectorSurvSessionPage.enterStartDateFrom(365);
            SearchVectorSurvSessionPage.enterStartDateTo(-1);
            SearchVectorSurvSessionPage.clearRegionField();
            SearchVectorSurvSessionPage.clickSearch();
            Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

            SearchVectorSurvSessionPage.randomlySelectQASession();
            Assert.IsTrue(CreateVectorSurvSessionPage.Location.IsAt, "This is not the Location section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Vector Surveillance Session | Session Summary section")]
        public void VerifyVectorSurveillanceSessionPageSessionSummarySectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Session Summary section")
                   .AssignCategory("Vector");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVector();
            MainMenuNavigation.Vector.clickSurveillanceSession();
            Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

            SearchVectorSurvSessionPage.clearStartDateFromField();
            SearchVectorSurvSessionPage.enterStartDateFrom(365);
            SearchVectorSurvSessionPage.enterStartDateTo(-1);
            SearchVectorSurvSessionPage.clearRegionField();
            SearchVectorSurvSessionPage.clickSearch();
            Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

            SearchVectorSurvSessionPage.randomlySelectQASession();
            Assert.IsTrue(CreateVectorSurvSessionPage.SessionSummary.IsAt, "This is not the Session Summary section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }



        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Vector Surveillance Session | Detailed Collections section")]
        public void VerifyVectorSurveillanceSessionPageDetailedCollectionsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Detailed Collections section")
                   .AssignCategory("Vector");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVector();
            MainMenuNavigation.Vector.clickSurveillanceSession();
            Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

            SearchVectorSurvSessionPage.clearStartDateFromField();
            SearchVectorSurvSessionPage.enterStartDateFrom(365);
            SearchVectorSurvSessionPage.enterStartDateTo(-1);
            SearchVectorSurvSessionPage.clearRegionField();
            SearchVectorSurvSessionPage.clickSearch();
            Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

            SearchVectorSurvSessionPage.randomlySelectQASession();
            Assert.IsTrue(CreateVectorSurvSessionPage.DetailedCollections.IsAt, "This is not the Detailed Collections section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Vector Surveillance Session | Aggregate Collections section")]
        public void VerifyVectorSurveillanceSessionPageAggregateCollectionsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Aggregate Collections section")
                   .AssignCategory("Vector");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVector();
            MainMenuNavigation.Vector.clickSurveillanceSession();
            Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

            SearchVectorSurvSessionPage.clearStartDateFromField();
            SearchVectorSurvSessionPage.enterStartDateFrom(365);
            SearchVectorSurvSessionPage.enterStartDateTo(-1);
            SearchVectorSurvSessionPage.clearRegionField();
            SearchVectorSurvSessionPage.clickSearch();
            Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

            SearchVectorSurvSessionPage.randomlySelectQASession();
            Assert.IsTrue(CreateVectorSurvSessionPage.AggregateCollections.IsAt, "This is not the Aggregate Collections section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Collection Data section")]
        public void VerifyVectorSurveillanceSessionPageDetailedCollectCollectionDataSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Collection Data section")
                   .AssignCategory("Vector");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVector();
            MainMenuNavigation.Vector.clickSurveillanceSession();
            Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

            //SearchVectorSurvSessionPage.clickClear();
            //SearchVectorSurvSessionPage.selectInProcessLogStatus();
            SearchVectorSurvSessionPage.clearStartDateFromField();
            SearchVectorSurvSessionPage.enterStartDateFrom(365);
            SearchVectorSurvSessionPage.enterStartDateTo(-1);
            SearchVectorSurvSessionPage.clickSearch();
            Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

            //Edit session and click Add Detailed Collections
            SearchVectorSurvSessionPage.randomlySelectQASession();
            //SearchVectorSurvSessionPage.randomlySelectBETASession();
            CreateVectorSurvSessionPage.DetailedCollections.expandDetailedCollections();
            CreateVectorSurvSessionPage.DetailedCollections.clickAddDetailedCollect();
            Assert.IsTrue(CreateVectorSurvSessionPage.DetailedCollections.CollectionData.IsAt, "This is not the Collections Data section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Vector Data section")]
        public void VerifyVectorSurveillanceSessionPageDetailedCollectVectorDataSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Vector Data section")
                   .AssignCategory("Vector");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVector();
            MainMenuNavigation.Vector.clickSurveillanceSession();
            Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

            SearchVectorSurvSessionPage.clearStartDateFromField();
            SearchVectorSurvSessionPage.enterStartDateFrom(365);
            SearchVectorSurvSessionPage.enterStartDateTo(-1);
            SearchVectorSurvSessionPage.clickSearch();
            Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

            //Edit session and click Add Detailed Collections
            //SearchVectorSurvSessionPage.randomlySelectQASession();
            SearchVectorSurvSessionPage.randomlySelectQASession();
            CreateVectorSurvSessionPage.DetailedCollections.expandDetailedCollections();
            CreateVectorSurvSessionPage.DetailedCollections.clickAddDetailedCollect();
            CreateVectorSurvSessionPage.clickVectorDataLink();
            Assert.IsTrue(CreateVectorSurvSessionPage.DetailedCollections.VectorData.IsAt, "This is not the Vector Data section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Vector Specific Data section")]
        public void VerifyVectorSurveillanceSessionPageDetailedCollectVectorSpecificDataSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Vector Specific Data section")
                   .AssignCategory("Vector");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVector();
            MainMenuNavigation.Vector.clickSurveillanceSession();
            Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

            SearchVectorSurvSessionPage.clearStartDateFromField();
            SearchVectorSurvSessionPage.enterStartDateFrom(365);
            SearchVectorSurvSessionPage.enterStartDateTo(-1);
            SearchVectorSurvSessionPage.clickSearch();
            Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

            //Edit session and click Add Detailed Collections
            SearchVectorSurvSessionPage.randomlySelectQASession();
            //SearchVectorSurvSessionPage.randomlySelectBETASession();
            CreateVectorSurvSessionPage.DetailedCollections.expandDetailedCollections();
            CreateVectorSurvSessionPage.DetailedCollections.clickAddDetailedCollect();
            CreateVectorSurvSessionPage.clickVectorSpecificDataLink();
            Assert.IsTrue(CreateVectorSurvSessionPage.DetailedCollections.VectorSpecificData.IsAt, "This is not the Vector Specific Data section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Samples section")]
        public void VerifyVectorSurveillanceSessionPageDetailedCollectionSamplesSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Samples section")
                   .AssignCategory("Vector");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVector();
            MainMenuNavigation.Vector.clickSurveillanceSession();
            Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

            SearchVectorSurvSessionPage.clearStartDateFromField();
            SearchVectorSurvSessionPage.enterStartDateFrom(365);
            SearchVectorSurvSessionPage.enterStartDateTo(-1);
            SearchVectorSurvSessionPage.clickSearch();
            Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

            //Edit session and click Add Detailed Collections
            SearchVectorSurvSessionPage.randomlySelectQASession();
            CreateVectorSurvSessionPage.DetailedCollections.expandDetailedCollections();
            CreateVectorSurvSessionPage.DetailedCollections.clickAddDetailedCollect();
            CreateVectorSurvSessionPage.clickSamplesLink();
            Assert.IsTrue(CreateVectorSurvSessionPage.DetailedCollections.Samples.IsAt, "This is not the Samples section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        //[Test]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Collection Data section")]
        //public void VerifyVectorSurveillanceSessionPageDetailedCollectCollectionDataSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Collection Data section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVector();
        //    MainMenuNavigation.Vector.clickSurveillanceSession();
        //    Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

        //    SearchVectorSurvSessionPage.clickClear();
        //    SearchVectorSurvSessionPage.selectInProcessLogStatus();
        //    SearchVectorSurvSessionPage.clickSearch();
        //    Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

        //    //Edit session and click Add Detailed Collection
        //    SearchVectorSurvSessionPage.randomlySelectQASession();
        //    SearchVectorSurvSessionPage.clickEditVector();
        //    CreateVectorSurvSessionPage.DetailedCollections.clickAddDetailedCollect();
        //    Assert.IsTrue(CreateVectorSurvSessionPage.DetailedCollections.CollectionData.IsAt, "This is not the Collections Data section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Vector Data section")]
        //public void VerifyVectorSurveillanceSessionPageDetailedCollectVectorDataSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Vector Data section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVector();
        //    MainMenuNavigation.Vector.clickSurveillanceSession();
        //    Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

        //    SearchVectorSurvSessionPage.clickClear();
        //    SearchVectorSurvSessionPage.selectInProcessLogStatus();
        //    SearchVectorSurvSessionPage.clickSearch();
        //    Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

        //    //Edit session and click Add Detailed Collection
        //    SearchVectorSurvSessionPage.randomlySelectQASession();
        //    SearchVectorSurvSessionPage.clickEditVector();
        //    CreateVectorSurvSessionPage.DetailedCollections.clickAddDetailedCollect();
        //    CreateVectorSurvSessionPage.clickVectorDataLink();
        //    Assert.IsTrue(CreateVectorSurvSessionPage.DetailedCollections.VectorData.IsAt, "This is not the Vector Data section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Vector Specific Data section")]
        //public void VerifyVectorSurveillanceSessionPageDetailedCollectVectorSpecificDataSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Vector Specific Data section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVector();
        //    MainMenuNavigation.Vector.clickSurveillanceSession();
        //    Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

        //    SearchVectorSurvSessionPage.clickClear();
        //    SearchVectorSurvSessionPage.selectInProcessLogStatus();
        //    SearchVectorSurvSessionPage.clickSearch();
        //    Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

        //    //Edit session and click Add Detailed Collection
        //    SearchVectorSurvSessionPage.randomlySelectQASession();
        //    SearchVectorSurvSessionPage.clickEditVector();
        //    CreateVectorSurvSessionPage.DetailedCollections.clickAddDetailedCollect();
        //    CreateVectorSurvSessionPage.clickVectorSpecificDataLink();
        //    Assert.IsTrue(CreateVectorSurvSessionPage.DetailedCollections.VectorSpecificData.IsAt, "This is not the Vector Specific Data section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Samples section")]
        //public void VerifyVectorSurveillanceSessionPageDetailedCollectionSamplesSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Samples section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVector();
        //    MainMenuNavigation.Vector.clickSurveillanceSession();
        //    Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

        //    SearchVectorSurvSessionPage.clickClear();
        //    SearchVectorSurvSessionPage.selectInProcessLogStatus();
        //    SearchVectorSurvSessionPage.clickSearch();
        //    Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

        //    //Edit session and click Add Detailed Collection
        //    SearchVectorSurvSessionPage.randomlySelectQASession();
        //    SearchVectorSurvSessionPage.clickEditVector();
        //    CreateVectorSurvSessionPage.DetailedCollections.clickAddDetailedCollect();
        //    CreateVectorSurvSessionPage.clickSamplesLink();
        //    Assert.IsTrue(CreateVectorSurvSessionPage.DetailedCollections.Samples.IsAt, "This is not the Samples section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}


        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Field Tests section")]
        public void VerifyVectorSurveillanceSessionPageDetailedCollectionFieldTestsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Field Tests section")
                   .AssignCategory("Vector");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVector();
            MainMenuNavigation.Vector.clickSurveillanceSession();
            Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

            SearchVectorSurvSessionPage.clearStartDateFromField();
            SearchVectorSurvSessionPage.enterStartDateFrom(120);
            SearchVectorSurvSessionPage.clickSearch();
            Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

            //Edit session and click Add Detailed Collection
            SearchVectorSurvSessionPage.randomlySelectQASession();
            CreateVectorSurvSessionPage.DetailedCollections.expandDetailedCollections();
            CreateVectorSurvSessionPage.DetailedCollections.clickAddDetailedCollect();
            CreateVectorSurvSessionPage.clickFieldTestsLink();
            Assert.IsTrue(CreateVectorSurvSessionPage.DetailedCollections.FieldTests.IsAt, "This is not the Field Tests section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Laboratory Tests section")]
        public void VerifyVectorSurveillanceSessionPageDetailedCollectionLaboratoryTestsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Laboratory Tests section")
                   .AssignCategory("Vector");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVector();
            MainMenuNavigation.Vector.clickSurveillanceSession();
            Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

            SearchVectorSurvSessionPage.clearStartDateFromField();
            SearchVectorSurvSessionPage.enterStartDateFrom(160);
            SearchVectorSurvSessionPage.clickSearch();
            Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

            //Edit session and click Add Detailed Collection
            SearchVectorSurvSessionPage.randomlySelectQASession();
            CreateVectorSurvSessionPage.DetailedCollections.expandDetailedCollections();
            CreateVectorSurvSessionPage.DetailedCollections.clickAddDetailedCollect();

            CreateVectorSurvSessionPage.clickLabTestsLink();
            Assert.IsTrue(CreateVectorSurvSessionPage.DetailedCollections.LaboratoryTests.IsAt, "This is not the Laboratory Tests section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Vector Surveillance Session | Aggregate Collections | Aggregate Information section")]
        public void VerifyVectorSurveillanceSessionPageAggregateCollectionsAggregInfoSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Aggregate Collections | Aggregate Information  section")
                   .AssignCategory("Vector");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVector();
            MainMenuNavigation.Vector.clickSurveillanceSession();
            Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

            //SearchVectorSurvSessionPage.clearStartDateFromField();
            SearchVectorSurvSessionPage.enterStartDateFrom(160);
            SearchVectorSurvSessionPage.enterStartDateTo(-1);
            SearchVectorSurvSessionPage.clickSearch();
            Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

            //Edit session and click Add Detailed Collection
            SearchVectorSurvSessionPage.randomlySelectQASession();
            CreateVectorSurvSessionPage.AggregateCollections.expandAggreCollections();
            CreateVectorSurvSessionPage.AggregateCollections.clickAddAggregateCollect();
            Assert.IsTrue(CreateVectorSurvSessionPage.AggregateCollections.AggregateInformation.IsAt, "This is not the Aggregate Information section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Vector Surveillance Session | Aggregate Collections | List of Diseases section")]
        public void VerifyVectorSurveillanceSessionPageAggregateCollectionsListOfDiseasesSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Aggregate Collections | List Of Diseases  section")
                   .AssignCategory("Vector");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVector();
            MainMenuNavigation.Vector.clickSurveillanceSession();
            Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

            SearchVectorSurvSessionPage.clearStartDateFromField();
            SearchVectorSurvSessionPage.enterStartDateFrom(160);
            SearchVectorSurvSessionPage.clickSearch();
            Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

            //Edit session and click Add Detailed Collection
            SearchVectorSurvSessionPage.randomlySelectQASession();
            CreateVectorSurvSessionPage.AggregateCollections.expandAggreCollections();
            CreateVectorSurvSessionPage.AggregateCollections.clickAddAggregateCollect();
            Assert.IsTrue(CreateVectorSurvSessionPage.AggregateCollections.ListOfDiseases.IsAt, "This is not the List Of Diseases section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        //[Test]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Field Tests section")]
        //public void VerifyVectorSurveillanceSessionPageDetailedCollectionFieldTestsSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Detailed Collection | Field Tests section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVector();
        //    MainMenuNavigation.Vector.clickSurveillanceSession();
        //    Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

        //    //earchVectorSurvSessionPage.clickClear();
        //    //SearchVectorSurvSessionPage.selectInProcessLogStatus();
        //    //SearchVectorSurvSessionPage.enterStartDateFrom();
        //    //SearchVectorSurvSessionPage.enterStartDateTo();
        //    SearchVectorSurvSessionPage.clickSearch();
        //    Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

        //    //Edit session and click Add Detailed Collections
        //    //SearchVectorSurvSessionPage.randomlySelectQASession();
        //    SearchVectorSurvSessionPage.randomlySelectBETASession();
        //    CreateVectorSurvSessionPage.DetailedCollections.expandDetailedCollections();
        //    CreateVectorSurvSessionPage.DetailedCollections.clickAddDetailedCollect();
        //    CreateVectorSurvSessionPage.clickFieldTestsLink();
        //    Assert.IsTrue(CreateVectorSurvSessionPage.DetailedCollections.FieldTests.IsAt, "This is not the Field Tests section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Vector | Surveillance Session | Aggregate Collections | Aggregate Information section")]
        //public void VerifyVectorSurveillanceSessionPageAggregateCollectionsAggregInfoSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Vector | Surveillance Session | Aggregate Collections | Aggregate Information  section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVector();
        //    MainMenuNavigation.Vector.clickSurveillanceSession();
        //    Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

        //    //SearchVectorSurvSessionPage.clickClear();
        //    //SearchVectorSurvSessionPage.selectInProcessLogStatus();
        //    //SearchVectorSurvSessionPage.enterStartDateFrom();
        //    ///SearchVectorSurvSessionPage.enterStartDateTo();
        //    SearchVectorSurvSessionPage.clickSearch();
        //    Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

        //    //Edit session and click Add Aggregate Collections
        //    //SearchVectorSurvSessionPage.randomlySelectQASession();
        //    SearchVectorSurvSessionPage.randomlySelectBETASession();
        //    CreateVectorSurvSessionPage.AggregateCollections.expandAggreCollections();
        //    CreateVectorSurvSessionPage.AggregateCollections.clickAddAggregateCollect();
        //    Assert.IsTrue(CreateVectorSurvSessionPage.AggregateCollections.AggregateInformation.IsAt, "This is not the Aggregate Information section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Vector Surveillance Session | Aggregate Collections | List of Diseases section")]
        //public void VerifyVectorSurveillanceSessionPageAggregateCollectionsListOfDiseasesSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Vector Surveillance Session | Aggregate Collections | List Of Diseases  section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVector();
        //    MainMenuNavigation.Vector.clickSurveillanceSession();
        //    Assert.IsTrue(SearchVectorSurvSessionPage.IsAt, "This is not the Search Page");

        //    //SearchVectorSurvSessionPage.clickClear();
        //    //SearchVectorSurvSessionPage.selectInProcessLogStatus();
        //    //SearchVectorSurvSessionPage.enterStartDateFrom();
        //    //SearchVectorSurvSessionPage.enterStartDateTo();
        //    SearchVectorSurvSessionPage.clickSearch();
        //    Assert.IsTrue(SearchVectorSurvSessionPage.SearchResults.IsAtSection, "This is not the Search Results section");

        //    //Edit session and click Add Aggregate Collections
        //    //SearchVectorSurvSessionPage.randomlySelectQASession();
        //    SearchVectorSurvSessionPage.randomlySelectBETASession();
        //    CreateVectorSurvSessionPage.AggregateCollections.expandAggreCollections();
        //    CreateVectorSurvSessionPage.AggregateCollections.clickAddAggregateCollect();
        //    Assert.IsTrue(CreateVectorSurvSessionPage.AggregateCollections.ListOfDiseases.IsAt, "This is not the List Of Diseases section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Laboratory | Samples tab")]
        public void VerifyLaboratorySamplesTabSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Laboratory | Samples tab")
                   .AssignCategory("Laboratory");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickLaboratory();
            MainMenuNavigation.Laboratory.clickSamples();
            Assert.IsTrue(LaboratoryPage.Samples.IsAt, "This is not the Samples tab");

            //Collapse Laboratory module and logout
            MainMenuNavigation.clickEIDSSIconBarToExitLab();
            MainMenuNavigation.clickEIDSSLogOutFromLab();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Laboratory | Testing tab")]
        public void VerifyLaboratoryTestingTabSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Laboratory | Testing tab")
                   .AssignCategory("Laboratory");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickLaboratory();
            MainMenuNavigation.Laboratory.clickTesting();
            Assert.IsTrue(LaboratoryPage.Testing.IsAt, "This is not the Testing tab");

            //Collapse Laboratory module and logout
            MainMenuNavigation.clickEIDSSIconBarToExitLab();
            MainMenuNavigation.clickEIDSSLogOutFromLab();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Laboratory | Transferred tab")]
        public void VerifyLaboratoryTransferredTabSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Laboratory | Transferred tab")
                   .AssignCategory("Laboratory");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickLaboratory();
            MainMenuNavigation.Laboratory.clickTransferred();
            Assert.IsTrue(LaboratoryPage.Transferred.IsAt, "This is not the Transferred tab");

            //Collapse Laboratory module and logout
            MainMenuNavigation.clickEIDSSIconBarToExitLab();
            MainMenuNavigation.clickEIDSSLogOutFromLab();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Laboratory | My Favorites tab")]
        public void VerifyLaboratoryMyFavoritesTabSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Laboratory | My Favorites tab")
                   .AssignCategory("Laboratory");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickLaboratory();
            MainMenuNavigation.Laboratory.clickSamples();
            Assert.IsTrue(LaboratoryPage.Samples.IsAt, "This is not the Samples tab");

            LaboratoryPage.clickMyFavoritesTab();
            Assert.IsTrue(LaboratoryPage.Favorites.IsAt, "This is not the Favorites tab");

            //Collapse Laboratory module and logout
            MainMenuNavigation.clickEIDSSIconBarToExitLab();
            MainMenuNavigation.clickEIDSSLogOutFromLab();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Laboratory | Batches tab")]
        public void VerifyLaboratoryBatchesTabSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Laboratory | Batches tab")
                   .AssignCategory("Laboratory");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickLaboratory();
            MainMenuNavigation.Laboratory.clickBatches();
            Assert.IsTrue(LaboratoryPage.Batches.IsAt, "This is not the Batches tab");

            //Collapse Laboratory module and logout
            MainMenuNavigation.clickEIDSSIconBarToExitLab();
            MainMenuNavigation.clickEIDSSLogOutFromLab();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Laboratory | Approvals tab")]
        public void VerifyLaboratoryApprovalsTabSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Laboratory | Approvals tab")
                   .AssignCategory("Laboratory");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickLaboratory();
            MainMenuNavigation.Laboratory.clickApprovals();
            Assert.IsTrue(LaboratoryPage.Approvals.IsAt, "This is not the Approvals tab");

            //Collapse Laboratory module and logout
            MainMenuNavigation.clickEIDSSIconBarToExitLab();
            MainMenuNavigation.clickEIDSSLogOutFromLab();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Laboratory | Advanced Search modal window")]
        public void VerifyLaboratoryAdvancedSearchModalWindowDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Laboratory | Approvals tab")
                   .AssignCategory("Laboratory");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickLaboratory();
            MainMenuNavigation.Laboratory.clickApprovals();

            LaboratoryPage.isApprovalsTabActive();
            Assert.IsTrue(LaboratoryPage.Approvals.IsAt, "This is not the Approvals tab");

            LaboratoryPage.clickAdvancedSearchLink();
            Assert.IsTrue(LaboratoryPage.AdvancedSearch.IsAt, "This is not the Advanced Search window");

            //Close the current window
            LaboratoryPage.AdvancedSearch.clickQuickClose();

            //Collapse Laboratory module and logout
            MainMenuNavigation.clickEIDSSIconBarToExitLab();
            MainMenuNavigation.clickEIDSSLogOutFromLab();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }



        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Veterinary Active Surveillance Campaign page")]
        public void VerifyVeterinaryActiveSurveillanceCampaignPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Veterinary Active Surveillance Campaign page")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickActiveSurvCampaigns();
            Assert.IsTrue(SearchVetActiveSurvCampPage.IsAt, "This is not the Veterinary Active Surveillance Campaign page");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Veterinary Active Surveillance Campaigns | Campaign Information section")]
        public void VerifyVeterinaryActiveSurveillanceCampaignsCampaignInfoSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Veterinary Active Surveillance Campaigns | Campaign Information section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickActiveSurvCampaigns();
            Assert.IsTrue(SearchVetActiveSurvCampPage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //SearchVetActiveSurvCampPage.clickSearch();
            SearchVetActiveSurvCampPage.clickNewCampaign();
            Assert.IsTrue(CreateVetActiveSurvCampPage.CampaignInformation.IsAt, "This is not the Campaign Information section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Veterinary Active Surveillance Campaigns | Search Criteria section")]
        public void VerifyVeterinaryActiveSurveillanceCampaignsSearchCriteriaSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Veterinary Active Surveillance Campaigns | Search Criteria section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickActiveSurvCampaigns();
            Assert.IsTrue(SearchVetActiveSurvCampPage.IsAt, "This is not the Veterinary Active Surveillance Campaign page");

            SearchVetActiveSurvCampPage.clickSearch();
            Assert.IsTrue(SearchVetActiveSurvCampPage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Veterinary Active Surveillance Campaigns | Search Results section")]
        public void VerifyVeterinaryActiveSurveillanceCampaignsSearchResultsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Veterinary Active Surveillance Campaigns | Search Results section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickActiveSurvCampaigns();
            Assert.IsTrue(SearchVetActiveSurvCampPage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            SearchVetActiveSurvCampPage.clickSearch();
            Assert.IsTrue(SearchVetActiveSurvCampPage.SearchResults.IsAt, "This is not the Search Results section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Veterinary Active Surveillance Campaigns | Species and Samples section")]
        public void VerifyVeterinaryActiveSurveillanceCampaignsSpeciesAndSamplesSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Veterinary Active Surveillance Campaigns | Species and Samples section");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickActiveSurvCampaigns();
            Assert.IsTrue(SearchVetActiveSurvCampPage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //SearchVetActiveSurvCampPage.clickSearch();
            SearchVetActiveSurvCampPage.clickNewCampaign();
            Assert.IsTrue(CreateVetActiveSurvCampPage.SpeciesAndSamples.IsAt, "This is not the Species and Samples section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Veterinary Active Surveillance Sessions | Search section")]
        public void VerifyVeterinaryActiveSurveillanceSessionsSearchPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Veterinary Active Surveillance Campaigns | Search section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickActiveSurvSessions();
            Assert.IsTrue(SearchActiveSurvSessionsPage.IsAt, "This is not the Search section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Veterinary Active Surveillance Sessions | Active Surveillance Session Results section")]
        public void VerifyVeterinaryActiveSurveillanceSessionsActiveSurvSessionResultsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Veterinary Active Surveillance Sessions | Active Surveillance Session Results section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickActiveSurvSessions();
            Assert.IsTrue(SearchActiveSurvSessionsPage.IsAt, "This is not the Search Page");

            SearchActiveSurvSessionsPage.clickSearch();
            Assert.IsTrue(SearchActiveSurvSessionsPage.SearchResults.IsAt, "This is not the Active Surveillance Session Results section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Veterinary Active Surveillance Sessions | Session Information section")]
        public void VerifyVeterinaryActiveSurveillanceSessionsSessionInformationSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Veterinary Active Surveillance Sessions | Session Information section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickActiveSurvSessions();
            Assert.IsTrue(SearchActiveSurvSessionsPage.IsAt, "This is not the Search Page");

            //SearchActiveSurvSessionsPage.clickSearch();
            SearchActiveSurvSessionsPage.clickNewSession();
            Assert.IsTrue(CreateVetActiveSurvSessionPage.SessionInformation.IsAt, "This is not the Session Information section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Veterinary Active Surveillance Sessions | Session Location section")]
        public void VerifyVeterinaryActiveSurveillanceSessionsSessionLocationSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Veterinary Active Surveillance Sessions | Session Location section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickActiveSurvSessions();
            Assert.IsTrue(SearchActiveSurvSessionsPage.IsAt, "This is not the Search Page");

            //SearchActiveSurvSessionsPage.clickSearch();
            SearchActiveSurvSessionsPage.clickNewSession();
            Assert.IsTrue(CreateVetActiveSurvSessionPage.SessionLocation.IsAt, "This is not the Session Location section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Veterinary Active Surveillance Sessions | Diseases and Species List section")]
        public void VerifyVeterinaryActiveSurveillanceSessionsDiseasesAndSpeciesListSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Veterinary Active Surveillance Sessions | Diseases and Species List section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickActiveSurvSessions();
            Assert.IsTrue(SearchActiveSurvSessionsPage.IsAt, "This is not the Search Criteria section");

            //SearchActiveSurvSessionsPage.clickSearch();
            SearchActiveSurvSessionsPage.clickNewSession();
            Assert.IsTrue(CreateVetActiveSurvSessionPage.DiseaseAndSpecies.IsAt, "This is not the Diseases and Species List section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        [Test]
        ////[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Search Farm Page | Search Results")]
        public void VerifyVeterinaryFarmSearchFarmSearchResultsPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Avian Disease Report | Search Farm | Search Results section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Avian
            SearchFarmInformationPage.SearchCriteria.selectAvianFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Search Farm Page | Search Results | Farm Review")]
        //public void VerifyVeterinaryAvianDiseaseReportSearchFarmSearchResultsFarmReviewPageDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Avian Disease Report | Search Farm | Search Results | Farm Review section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickAvianDiseaseReport();
        //    Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Search by Farm Information Page");

        //    SearchFarmInformationPage.clickEditSearchBtn();
        //    SearchFarmInformationPage.selectAvianFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    SearchFarmInformationPage.SearchResults.editFarmRecord();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
        //    Assert.IsTrue(SearchFarmInformationPage.FarmRecordReview.IsAt, "This is not the Farm Record Review Page");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Farm Information section")]
        public void VerifyVeterinaryFarmFarmInformationSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Farm Information section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Avian
            SearchFarmInformationPage.SearchCriteria.selectAvianFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            SearchFarmInformationPage.clickCreateNewFarmRecordBtn();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Farm Address section")]
        public void VerifyVeterinaryFarmFarmAddressSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Farm Address section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Avian
            SearchFarmInformationPage.SearchCriteria.selectAvianFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            //Add a new Farm
            SearchFarmInformationPage.clickCreateNewFarmRecordBtn();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmAddress.IsAt, "This is not the Farm Address section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Veterinary Disease Reports section")]
        public void VerifyVeterinaryFarmVeterinaryDiseaseReportsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Veterinary Disease Reports section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            SearchFarmInformationPage.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();
            Assert.IsTrue(CreateNewFarmRecordPage.VeterinaryDiseaseReports.IsAt, "This is not the Disease Reports section");


            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        //[Test]
        //[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Farm | Laboratory Test Samples section")]
        //public void VerifyVeterinaryFarmLaboratoryTestSamplesSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Farm | Laboratory Test Samples section")
        //           .AssignCategory("Veterinary");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickFarm();
        //    Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

        //    SearchFarmInformationPage.clickFarmSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    //SearchFarmInformationPage.clickCreateNewFarmRecordBtn();
        //    SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
        //    Assert.IsTrue(CreateNewFarmRecordPage.LaboratoryTestSamples.IsAt, "This is not the Laboratory Test Samples section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        //[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Farm | Flocks/Herds and Species section")]
        //public void VerifyVeterinaryFarmFLocksHerdsAndSpeciesSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Farm | Flocks/Herds and Species section")
        //           .AssignCategory("Veterinary");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickFarm();
        //    Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

        //    SearchFarmInformationPage.clickFarmSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    SearchFarmInformationPage.clickCreateNewFarmRecordBtn();
        //    Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

        //    CreateNewFarmRecordPage.clickFlocksHerdSpeciesLink();
        //    Assert.IsTrue(CreateNewFarmRecordPage.FlocksHeardSpecies.IsAt, "This is not the Flocks/Herds and Species section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Avian Disease Report")]
        public void VerifyVeterinaryFarmAvianDiseaseReportDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Flocks/Herds and Species section");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Avian
            SearchFarmInformationPage.SearchCriteria.selectAvianFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select a farm and edit that record
            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();

            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.IsAt, "This is not the Avian Disease Report Page");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Avian Disease Report | Disease Summary Report")]
        public void VerifyVeterinaryFarmAvianDiseaseReportDiseaseSummaryReportSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Avian Disease Report | Disease Summary Report");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Avian
            SearchFarmInformationPage.SearchCriteria.selectAvianFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select a farm and edit that record
            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.IsAt, "This is not the Avian Disease Report Page");

            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.DiseaseReportSummary.IsAt, "This is not the Disease Report Summary");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Avian Disease Report | Farm Details section")]
        public void VerifyVeterinaryFarmAvianDiseaseReportFarmDetailsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Avian Disease Report | Farm Details section");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Avian
            SearchFarmInformationPage.SearchCriteria.selectAvianFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select a farm and edit that record
            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.FarmDetails.IsAt, "This is not the Farm Details section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Avian Disease Report | Notification section")]
        public void VerifyVeterinaryFarmAvianDiseaseReportNotificationSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Avian Disease Report | Notification section");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Avian
            SearchFarmInformationPage.SearchCriteria.selectAvianFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select a farm and edit that record
            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Avian Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.IsAt, "This is not the Avian Disease Report Page");

            CreateAvianAvianDiseaseRptPage.clickNotificationLink();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.Notification.IsAt, "This is not the Notification section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Avian Disease Report | Farm/Flock/Species section")]
        public void VerifyVeterinaryFarmAvianDiseaseReportFarmFlockSpeciesSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Avian Disease Report | Farm/Flock/Species section");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Avian
            SearchFarmInformationPage.SearchCriteria.selectAvianFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select a farm and edit that record
            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Avian Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.IsAt, "This is not the Avian Disease Report Page");

            CreateAvianAvianDiseaseRptPage.clickFarmFlockSpeciesLink();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.FarmFlockSpecies.IsAt, "This is not the Farm/Flock/Species section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Avian Disease Report | Farm Epidemiological Info section")]
        public void VerifyVeterinaryFarmAvianDiseaseReportFarmEpiInfoSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Avian Disease Report | Farm Epidemiological Info section");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Avian
            SearchFarmInformationPage.SearchCriteria.selectAvianFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select a farm and edit that record
            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Avian Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.IsAt, "This is not the Avian Disease Report Page");

            CreateAvianAvianDiseaseRptPage.clickFarmEpiInfoLink();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.FarmEpiInfo.IsAt, "This is not the Farm Epidemiological Info section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        //[Test]
        //[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Farm | Avian Disease Report | Species Investigation section")]
        //public void VerifyVeterinaryFarmAvianDiseaseReportSpeciesInvestigationSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Farm | Avian Disease Report | Species Investigation section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    //Navigate to Search Farm page
        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickFarm();
        //    Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

        //    //Search for an Farm with Farm Type = Avian
        //    SearchFarmInformationPage.SearchCriteria.selectAvianFarmType();
        //    SearchFarmInformationPage.clickFarmSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    //Random select a farm and edit that record
        //    SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
        //    Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

        //    //Go to Review and add Veterinary Disease Report
        //    //Verify Avian Disease Report page displays
        //    CreateNewFarmRecordPage.clickFarmReviewLink();
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
        //    Assert.IsTrue(CreateAvianAvianDiseaseRptPage.IsAt, "This is not the Avian Disease Report Page");

        //    CreateAvianAvianDiseaseRptPage.clickSpeciesInvestLink();
        //    Assert.IsTrue(CreateAvianAvianDiseaseRptPage.SpeciesInvestigation.IsAt, "This is not the Species Investigation section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Avian Disease Report | Vaccine Information section")]
        public void VerifyVeterinaryFarmAvianDiseaseReportVaccineInformationSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Avian Disease Report | Vaccine Information section");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Avian
            SearchFarmInformationPage.SearchCriteria.selectAvianFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            ///Random select a farm and edit that record
            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Avian Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.IsAt, "This is not the Avian Disease Report Page");

            CreateAvianAvianDiseaseRptPage.clickVaccineInfoLink();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.VaccineInfo.IsAt, "This is not the Vaccine Information section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Avian Disease Report | Vaccine Information Popup box displays")]
        public void VerifyVeterinaryFarmAvianDiseaseReportVaccineInformationPopupBoxDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Avian Disease Report | Vaccine Information popup box displays");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Avian
            SearchFarmInformationPage.SearchCriteria.selectAvianFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select a farm and edit that record
            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Avian Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.IsAt, "This is not the Avian Disease Report Page");

            CreateAvianAvianDiseaseRptPage.clickNextToVaccineInfoTab();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.VaccineInfo.IsAt, "This is not the Vaccine Information section");

            //Click the Add button to invoke the diaglogue box
            CreateAvianAvianDiseaseRptPage.VaccineInfo.clickAddNewVaccine();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.VaccineInfo.VaccinationInfoDialogueBox.IsAt, "This is not the Vaccine Information section");

            //Close diaglogue box and Logout of EIDSS
            CreateAvianAvianDiseaseRptPage.VaccineInfo.VaccinationInfoDialogueBox.clickCancel();
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Farm | Avian Disease Report | Control Measures section")]
        //public void VerifyVeterinaryFarmAvianDiseaseReportControlMeasuresSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Farm | Avian Disease Report | Control Measures section")
        //           .AssignCategory("Veterinary");

        //    LoginPage.AJLoginIntoEIDSS();

        //    //Navigate to Search Farm page
        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickFarm();
        //    Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

        //    //Search for an Farm with Farm Type = Avian
        //    SearchFarmInformationPage.SearchCriteria.selectAvianFarmType();
        //    SearchFarmInformationPage.clickFarmSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
        //    Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

        //    //Go to Review and add Veterinary Disease Report
        //    //Verify Livestock Disease Report page displays
        //    CreateNewFarmRecordPage.clickFarmReviewLink();

        //    //Click add Veterinary Disease Report
        //    //Verify Livestock Disease Report page displays
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
        //    Assert.IsTrue(CreateAvianAvianDiseaseRptPage.IsAt, "This is not the Avian Disease Report Page");

        //    CreateAvianAvianDiseaseRptPage.clickContrMeasureInfoLink();
        //    Assert.IsTrue(CreateAvianAvianDiseaseRptPage.ControlMeasures.IsAt, "This is not the Control Measures section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Avian Disease Report | Samples section displays")]
        public void VerifyVeterinaryFarmAvianDiseaseReportSamplesSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Avian Disease Report | Samples section displays");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Avian
            SearchFarmInformationPage.SearchCriteria.selectAvianFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select a farm and edit that record
            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Avian Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.IsAt, "This is not the Avian Disease Report Page");

            CreateAvianAvianDiseaseRptPage.clickNextToSamplesTab();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.Samples.IsAt, "This is not the Samples section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Avian Disease Report | Penside Tests section displays")]
        public void VerifyVeterinaryFarmAvianDiseaseReportPensideTestsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Avian Disease Report | Penside Tests section displays");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Avian
            SearchFarmInformationPage.SearchCriteria.selectAvianFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select a farm and edit that record
            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.IsAt, "This is not the Avian Disease Report Page");

            CreateAvianAvianDiseaseRptPage.clickNextToPensideTestsTab();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.PensideTests.IsAt, "This is not the Penside Tests section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Avian Disease Report | Lab Test section displays")]
        public void VerifyVeterinaryFarmAvianDiseaseReportabTestSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Avian Disease Report | Lab Test section displays");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Avian
            SearchFarmInformationPage.SearchCriteria.selectAvianFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            ///Random select a farm and edit that record
            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Avian Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.IsAt, "This is not the Avian Disease Report Page");

            CreateAvianAvianDiseaseRptPage.clickLabTestsInterpretLink();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.LabTestInterpret.LabTest.IsAt, "This is not the Lab Test section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Avian Disease Report | Interpretation section displays")]
        public void VerifyVeterinaryFarmAvianDiseaseReporInterpretationSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Avian Disease Report | Interpretation section displays");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Avian
            SearchFarmInformationPage.SearchCriteria.selectAvianFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select a farm and edit that record
            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Avian Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.IsAt, "This is not the Avian Disease Report Page");

            CreateAvianAvianDiseaseRptPage.clickLabTestsInterpretLink();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.LabTestInterpret.Interpretation.IsAt, "This is not the Interpretation section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Avian Disease Report | Case Log section displays")]

        public void VerifyVeterinaryFarmAvianDiseaseReporCaseLogSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Avian Disease Report | Case Log section displays");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Avian
            SearchFarmInformationPage.SearchCriteria.selectAvianFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select a farm and edit that record
            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Avian Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.IsAt, "This is not the Avian Disease Report Page");

            CreateAvianAvianDiseaseRptPage.clickCaseLogLink();
            Assert.IsTrue(CreateAvianAvianDiseaseRptPage.CaseLog.IsAt, "This is not the Case Log section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Avian Disease Summary Report | Notification section")]
        //public void VerifyVeterinaryAvianDiseaseReportPageNotificationSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Avian Disease Report | Notification section")
        //           .AssignCategory("Veterinary");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickAvianDiseaseReport();
        //    Assert.IsTrue(SearchAvianDiseaseReportPage.IsAt, "This is not the Avian Disease Report Page");

        //    //Click Add and search for a Farm
        //    SearchAvianDiseaseReportPage.SearchCriteria.clickCreateAvianDiseaseRpt();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    //Random select a farm and edit that record
        //    SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
        //    CreateNewFarmRecordPage.clickEditRecord();

        //    //Click new Avian Disease Report and verify that the Notification section
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
        //    CreateAvianAvianDiseaseRptPage.clickNotificationLink();
        //    Assert.IsTrue(CreateAvianAvianDiseaseRptPage.Notification.IsAt, "This is not the Notification section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}


        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Avian Disease Summary Report | Search Criteria section")]
        public void VerifyVeterinaryAvianDiseaseReportPageSearchCriteriaSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Avian Disease Summary Report | Search Criteria section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickAvianDiseaseReport();
            Assert.IsTrue(SearchAvianDiseaseReportPage.SearchCriteria.IsAt, "This is not the Search Criteria section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Avian Disease Summary Report | Farm/Flock/Species section")]
        //public void VerifyVeterinaryAvianDiseaseReportPageFarmFlockSpeciesSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Avian Disease Report | Farm/Flock/Species section")
        //           .AssignCategory("Veterinary");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickAvianDiseaseReport();
        //    Assert.IsTrue(SearchAvianDiseaseReportPage.IsAt, "This is not the Avian Disease Report Page");

        //    //Click Add and search for a Farm
        //    SearchAvianDiseaseReportPage.SearchCriteria.clickCreateAvianDiseaseRpt();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    //Random select a farm and edit that record
        //    SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
        //    CreateNewFarmRecordPage.clickEditRecord();

        //    //Click new Avian Disease Report and verify that the Farm/Flock/Species section
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
        //    CreateAvianAvianDiseaseRptPage.clickFarmFlockSpeciesLink();
        //    Assert.IsTrue(CreateAvianAvianDiseaseRptPage.FarmFlockSpecies.IsAt, "This is not the Farm/Flock/Species section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Avian Disease Summary Report | Farm Epidemiological Info section")]
        //public void VerifyVeterinaryAvianDiseaseReportPageFarmEpiInfoSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Avian Disease Report | Farm Epidemiological Info section")
        //           .AssignCategory("Veterinary");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickAvianDiseaseReport();
        //    Assert.IsTrue(SearchAvianDiseaseReportPage.IsAt, "This is not the Avian Disease Report Page");

        //    //Click Add and search for a Farm
        //    SearchAvianDiseaseReportPage.SearchCriteria.clickCreateAvianDiseaseRpt();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    //Random select a farm and edit that record
        //    SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
        //    CreateNewFarmRecordPage.clickEditRecord();

        //    //Click new Avian Disease Report and verify that the Disease Summary Report section
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
        //    CreateAvianAvianDiseaseRptPage.clickFarmEpiInfoLink();
        //    Assert.IsTrue(CreateAvianAvianDiseaseRptPage.FarmEpiInfo.IsAt, "This is not the Farm Epidemiological Info section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Avian Disease Summary Report | Species Investigation section")]
        //public void VerifyVeterinaryAvianDiseaseReportPageSpeciesInvestigationSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Avian Disease Report | Species Investigation section")
        //           .AssignCategory("Veterinary");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickAvianDiseaseReport();
        //    Assert.IsTrue(SearchAvianDiseaseReportPage.IsAt, "This is not the Avian Disease Report Page");

        //    //Click Add and search for a Farm
        //    SearchAvianDiseaseReportPage.SearchCriteria.clickCreateAvianDiseaseRpt();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    //Random select a farm and edit that record
        //    SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
        //    CreateNewFarmRecordPage.clickEditRecord();

        //    //Click new Avian Disease Report and verify that the Species Investigation section
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
        //    CreateAvianAvianDiseaseRptPage.clickNextToSpeciesInvestTab();
        //    Assert.IsTrue(CreateAvianAvianDiseaseRptPage.SpeciesInvestigation.IsAt, "This is not the Species Investigation section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Avian Disease Summary Report | Vaccination Information section")]
        //public void VerifyVeterinaryAvianDiseaseReportPageVaccineInfoSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Avian Disease Report | Vaccination Information section")
        //           .AssignCategory("Veterinary");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickAvianDiseaseReport();
        //    Assert.IsTrue(SearchAvianDiseaseReportPage.IsAt, "This is not the Avian Disease Report Page");

        //    //Click Add and search for a Farm
        //    SearchAvianDiseaseReportPage.SearchCriteria.clickCreateAvianDiseaseRpt();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    //Random select a farm and edit that record
        //    SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
        //    CreateNewFarmRecordPage.clickEditRecord();

        //    //Click new Avian Disease Report and verify that the Vaccine Information section
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
        //    CreateAvianAvianDiseaseRptPage.clickVaccineInfoLink();
        //    Assert.IsTrue(CreateAvianAvianDiseaseRptPage.VaccineInfo.IsAt, "This is not the Vaccine Information section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");

        //}


        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Avian Disease Summary Report | Samples section")]
        //public void VerifyVeterinaryAvianDiseaseReportPageSamplesSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Avian Disease Report | Samples section")
        //           .AssignCategory("Veterinary");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickAvianDiseaseReport();
        //    Assert.IsTrue(SearchAvianDiseaseReportPage.IsAt, "This is not the Avian Disease Report Page");
        //    //Click Add and search for a Farm
        //    SearchAvianDiseaseReportPage.SearchCriteria.clickCreateAvianDiseaseRpt();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    //Random select a farm and edit that record
        //    SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
        //    CreateNewFarmRecordPage.clickEditRecord();

        //    //Click new Avian Disease Report and verify that the Samples section displays
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
        //    CreateAvianAvianDiseaseRptPage.clickSamplesLink();
        //    Assert.IsTrue(CreateAvianAvianDiseaseRptPage.Samples.IsAt, "This is not the Samples section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}


        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Avian Disease Summary Report | Penside Tests section")]
        //public void VerifyVeterinaryAvianDiseaseReportPagePensideTestsSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Avian Disease Report | Penside Tests section")
        //           .AssignCategory("Veterinary");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickAvianDiseaseReport();
        //    Assert.IsTrue(SearchAvianDiseaseReportPage.IsAt, "This is not the Avian Disease Report Page");

        //    //Click Add and search for a Farm
        //    SearchAvianDiseaseReportPage.SearchCriteria.clickCreateAvianDiseaseRpt();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    //Random select a farm and edit that record
        //    SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
        //    CreateNewFarmRecordPage.clickEditRecord();

        //    //Click new Avian Disease Report and verify that the Penside Tests section displays
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
        //    CreateAvianAvianDiseaseRptPage.clickPensideTestsLink();
        //    Assert.IsTrue(CreateAvianAvianDiseaseRptPage.PensideTests.IsAt, "This is not the Penside Tests section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Avian Disease Summary Report | Lab Test section")]
        //public void VerifyVeterinaryAvianDiseaseReportPageLabTestSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Avian Disease Report | Lab Test section")
        //           .AssignCategory("Veterinary");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickAvianDiseaseReport();
        //    Assert.IsTrue(SearchAvianDiseaseReportPage.IsAt, "This is not the Avian Disease Report Page");

        //    //Click Add and search for a Farm
        //    SearchAvianDiseaseReportPage.SearchCriteria.clickCreateAvianDiseaseRpt();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    //Random select a farm and edit that record
        //    SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
        //    CreateNewFarmRecordPage.clickEditRecord();

        //    //Click new Avian Disease Report and verify that the Lab Test section displays
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
        //    CreateAvianAvianDiseaseRptPage.clickLabTestsInterpretLink();
        //    Assert.IsTrue(CreateAvianAvianDiseaseRptPage.LabTestInterpret.LabTest.IsAt, "This is not the Lab Test section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Avian Disease Summary Report | Interpretation section")]
        //public void VerifyVeterinaryAvianDiseaseReportPageInterpretationSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Avian Disease Report | Interpretation section")
        //           .AssignCategory("Veterinary");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickAvianDiseaseReport();
        //    Assert.IsTrue(SearchAvianDiseaseReportPage.IsAt, "This is not the Avian Disease Report Page");

        //    //Click Add and search for a Farm
        //    SearchAvianDiseaseReportPage.SearchCriteria.clickCreateAvianDiseaseRpt();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    //Random select a farm and edit that record
        //    SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
        //    CreateNewFarmRecordPage.clickEditRecord();

        //    //Click new Avian Disease Report and verify that the Interpretation section displays
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
        //    CreateAvianAvianDiseaseRptPage.clickLabTestsInterpretLink();
        //    Assert.IsTrue(CreateAvianAvianDiseaseRptPage.LabTestInterpret.Interpretation.IsAt, "This is not the Interpretation section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        //////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Avian Disease Summary Report | Case Log section")]
        //public void VerifyVeterinaryAvianDiseaseReportPageCaseLogSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Avian Disease Report | Case Log section")
        //           .AssignCategory("Veterinary");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickAvianDiseaseReport();
        //    Assert.IsTrue(SearchAvianDiseaseReportPage.IsAt, "This is not the Avian Disease Report Page");

        //    //Click Add and search for a Farm
        //    SearchAvianDiseaseReportPage.SearchCriteria.clickCreateAvianDiseaseRpt();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    //Random select a farm and edit that record
        //    SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
        //    CreateNewFarmRecordPage.clickEditRecord();

        //    //Click new Avian Disease Report and verify that the Samples section displays
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
        //    CreateAvianAvianDiseaseRptPage.clickNextToCaseLogTab();
        //    Assert.IsTrue(CreateAvianAvianDiseaseRptPage.CaseLog.IsAt, "This is not the Case Log section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}


        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Livestock Disease Report page")]
        public void VerifyVeterinaryFarmLivestockDiseaseReportDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Livestock Disese Report page")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select a farm and edit that record
            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            //CreateNewFarmRecordPage.clickEditRecord();

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();

            //Click new Livestock Disease Report and verify that the Livestock Disease Report Displays
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.IsAt, "This is not the Livestock Disease Report");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Livestock Disease Report | Disease Summary Report")]
        public void VerifyVeterinaryFarmLivestockDiseaseReportDiseaseSummaryReportSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Livestock Disease Report | Disease Summary Report")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();

            //Click add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.IsAt, "This is not the Livestock Disease Report Page");

            Assert.IsTrue(CreateLivestockDiseaseReportPage.DiseaseReportSummary.IsAt, "This is not the Disease Report Summary");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Livestock Disease Report | Farm Details section")]
        public void VerifyVeterinaryFarmLivestockDiseaseReportFarmDetailsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Livestock Disease Report | Farm Details section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();

            //Click add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.IsAt, "This is not the Livestock Disease Report Page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Livestock Disease Report | Notification section")]
        public void VerifyVeterinaryFarmLivestockDiseaseReportNotificationSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Livestock Disease Report | Notification section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Avian
            SearchFarmInformationPage.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();

            //Click add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.IsAt, "This is not the Livestock Disease Report Page");

            CreateLivestockDiseaseReportPage.clickNextToNotificationTab();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.Notification.IsAt, "This is not the Notification section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Livestock Disease Report | Farm/Flock/Species section")]
        public void VerifyVeterinaryFarmLivestockDiseaseReportFarmFlockSpeciesSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Livestock Disease Report | Farm/Flock/Species section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();

            //Click add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.IsAt, "This is not the Livestock Disease Report Page");

            CreateLivestockDiseaseReportPage.clickNextToFarmFlockSpeciesTab();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.FarmHeardSpecies.IsAt, "This is not the Farm/Herd/Species section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Livestock Disease Report | Farm Epidemiological Info section")]
        public void VerifyVeterinaryFarmLivestockDiseaseReportFarmEpiInfoSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Livestock Disease Report | Farm Epidemiological Info section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();

            //Click add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.IsAt, "This is not the Livestock Disease Report Page");

            CreateLivestockDiseaseReportPage.clickNextToFarmEpiInfoTab();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.FarmEpiInfo.IsAt, "This is not the Farm Epidemiological Info section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        //[Test]
        //[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Farm | Livestock Disease Report | Species Investigation section")]
        //public void VerifyVeterinaryFarmLivestockDiseaseReportSpeciesInvestigationSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Farm | Livestock Disease Report | Species Investigation section")
        //           .AssignCategory("Veterinary");

        //    LoginPage.AJLoginIntoEIDSS();

        //    //Navigate to Search Farm page
        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickFarm();
        //    Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

        //    //Search for an Farm with Farm Type = Livestock
        //    SearchFarmInformationPage.SearchCriteria.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickFarmSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
        //    Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

        //    //Go to Review and add Veterinary Disease Report
        //    //Verify Livestock Disease Report page displays
        //    CreateNewFarmRecordPage.clickFarmReviewLink();

        //    //Click add Veterinary Disease Report
        //    //Verify Livestock Disease Report page displays
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.IsAt, "This is not the Livestock Disease Report Page");

        //    CreateLivestockDiseaseReportPage.clickSpeciesInvestLink();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.SpeciesInvestigation.IsAt, "This is not the Species Investigation section");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Livestock Disease Report | Vaccine Information section")]
        public void VerifyVeterinaryFarmLivestockDiseaseReportVaccineInformationSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Livestock Disease Report | Vaccine Information section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();

            //Click add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.IsAt, "This is not the Livestock Disease Report Page");

            CreateLivestockDiseaseReportPage.clickVaccineInfoLink();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.VaccineInfo.IsAt, "This is not the Vaccine Information section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Livestock Disease Report | Control Measures section")]
        public void VerifyVeterinaryFarmLivestockDiseaseReportControlMeasuresSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Livestock Disease Report | Control Measures section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();

            //Click add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.IsAt, "This is not the Livestock Disease Report Page");

            CreateLivestockDiseaseReportPage.clickContrMeasureInfoLink();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.ControlMeasures.IsAt, "This is not the Control Measures section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Livestock Disease Report | Animals Popup box displays")]
        public void VerifyVeterinaryFarmLivestockDiseaseReportAnimalsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Livestock Disease Report | Animals section displays")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();

            //Click add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.IsAt, "This is not the Livestock Disease Report Page");

            CreateLivestockDiseaseReportPage.clickAnimalsLink();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.Animals.IsAt, "This is not the Animals section");

            //Close diaglogue box and Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Livestock Disease Report | Vaccine Information Popup box displays")]
        public void VerifyVeterinaryFarmLivestockDiseaseReportVaccineInformationPopupBoxDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Livestock Disease Report | Vaccine Information popup box displays")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();

            //Click add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.IsAt, "This is not the Livestock Disease Report Page");

            CreateLivestockDiseaseReportPage.clickVaccineInfoLink();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.VaccineInfo.IsAt, "This is not the Vaccine Information section");

            //Click the Add button to invoke the Vaccine Information diaglogue box
            //Verify dialogue box displays correctly
            CreateLivestockDiseaseReportPage.VaccineInfo.clickAddNewVaccine();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.VaccineInfo.VaccinationInfoDialogueBox.IsAt, "This is not the Vaccine Information section");

            //Close diaglogue box and Logout of EIDSS
            CreateLivestockDiseaseReportPage.VaccineInfo.VaccinationInfoDialogueBox.clickCancel();
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Livestock Disease Report | Samples section displays")]
        public void VerifyVeterinaryFarmLivestockDiseaseReportSamplesSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Livestock Disease Report | Samples section displays")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();

            //Click add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.IsAt, "This is not the Livestock Disease Report Page");

            CreateLivestockDiseaseReportPage.clickSamplesLink();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.Samples.IsAt, "This is not the Samples section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Livestock Disease Report | Penside Tests section displays")]
        public void VerifyVeterinaryFarmLivestockDiseaseReportPensideTestsSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Livestock Disease Report | Penside Tests section displays")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();

            //Click add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.IsAt, "This is not the Livestock Disease Report Page");

            CreateLivestockDiseaseReportPage.clickPensideTestsLink();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.PensideTests.IsAt, "This is not the Penside Tests section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Livestock Disease Report | Lab Test section displays")]
        public void VerifyVeterinaryFarmLivestockDiseaseReportLabTestSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Livestock Disease Report | Lab Test section displays")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();

            //Click add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.IsAt, "This is not the Livestock Disease Report Page");

            CreateLivestockDiseaseReportPage.clickLabTestsInterpretLink();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.LabTestInterpret.LabTest.IsAt, "This is not the Lab Test section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Livestock Disease Report | Interpretation section displays")]
        public void VerifyVeterinaryFarmLivestockDiseaseReportInterpretationSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Livestock Disease Report | Interpretation section displays")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();

            //Click add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.IsAt, "This is not the Livestock Disease Report Page");

            CreateLivestockDiseaseReportPage.clickLabTestsInterpretLink();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.LabTestInterpret.Interpretation.IsAt, "This is not the Interpretation section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Farm | Livestock Disease Report | Case Log section displays")]
        public void VerifyVeterinaryFarmLivestockDiseaseReporCaseLogSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Farm | Livestock Disease Report | Case Log section displays")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            //Navigate to Search Farm page
            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickFarm();
            Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Farm Page");

            //Search for an Farm with Farm Type = Livestock
            SearchFarmInformationPage.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.clickFarmSearchBtn();
            Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select a farm and edit that record
            SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(CreateNewFarmRecordPage.FarmInformation.IsAt, "This is not the Farm Information section");

            //Go to Review and add Veterinary Disease Report
            //Verify Livestock Disease Report page displays
            CreateNewFarmRecordPage.clickFarmReviewLink();
            CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.IsAt, "This is not the Livestock Disease Report Page");

            CreateLivestockDiseaseReportPage.clickCaseLogLink();
            Assert.IsTrue(CreateLivestockDiseaseReportPage.CaseLog.IsAt, "This is not the Case Log section");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        //[Test]
        //////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Livestock Disease Report | Search Farm Page | Search Results")]
        //public void VerifyVeterinaryLivestockDiseaseReportSearchFarmSearchResultsPageDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Livestock Disease Report | Search Farm Page | Search Results");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickLivestockDiseaseReport();
        //    Assert.IsTrue(SearchLivestockDiseaseReportPage.IsAt, "This is not the Livestock Disease Report page");

        //    SearchLivestockDiseaseReportPage.SearchParameters.clickCreateLivestockDiseaseRpt();
        //    SearchLivestockDiseaseReportPage.SearchParameters.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}


        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Livestock Disease Summary Report | Farm Details section")]
        //public void VerifyVeterinaryLivestockDiseaseReportPageFarmDetailsSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Livestock Disease Summary Report | Farm Details section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickLivestockDiseaseReport();
        //    Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Search by Farm Information Page");

        //    //SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    SearchFarmInformationPage.clickEditSearchBtn();
        //    SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    SearchFarmInformationPage.SearchResults.editFarmRecord();
        //    Assert.IsTrue(CreateNewFarmRecordPage.IsAt, "This is not the Farm Page");

        //    CreateNewFarmRecordPage.clickEditRecord();
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.FarmDetails.IsAt, "This is not the Farm Details section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Livestock Disease Summary Report | Notification section")]
        //public void VerifyVeterinaryLivestockDiseaseReportPageNotificationSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Livestock Disease Summary Report | Notification section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickLivestockDiseaseReport();
        //    Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Search by Farm Information Page");

        //    //SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    SearchFarmInformationPage.clickEditSearchBtn();
        //    SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    SearchFarmInformationPage.SearchResults.editFarmRecord();
        //    Assert.IsTrue(CreateNewFarmRecordPage.IsAt, "This is not the Farm Page");

        //    CreateNewFarmRecordPage.clickEditRecord();
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.DiseaseReportSummary.IsAt, "This is not the Disease Report Summary page");

        //    CreateLivestockDiseaseReportPage.clickNotificationLink();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.Notification.IsAt, "This is not the Notification section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Livestock Disease Summary Report | Farm/Herd/Species section")]
        //public void VerifyVeterinaryLivestockDiseaseReportPageFarmHerdSpeciesSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Livestock Disease Summary Report | Farm/Herd/Species section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickLivestockDiseaseReport();
        //    Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Search by Farm Information Page");

        //    //SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    SearchFarmInformationPage.clickEditSearchBtn();
        //    SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    SearchFarmInformationPage.SearchResults.editFarmRecord();
        //    Assert.IsTrue(CreateNewFarmRecordPage.IsAt, "This is not the Farm Page");

        //    CreateNewFarmRecordPage.clickEditRecord();
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.DiseaseReportSummary.IsAt, "This is not the Disease Report Summary page");

        //    CreateLivestockDiseaseReportPage.clickFarmHerdSpeciesLink();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.FarmHeardSpecies.IsAt, "This is not the Farm/Herd/Species section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Livestock Disease Summary Report | Farm Epidemiological Info section")]
        //public void VerifyVeterinaryLivestockDiseaseReportPageFarmEpiInfoSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Livestock Disease Summary Report | Farm Epidemiological section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickLivestockDiseaseReport();
        //    Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Search by Farm Information Page");

        //    //SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    SearchFarmInformationPage.clickEditSearchBtn();
        //    SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    SearchFarmInformationPage.SearchResults.editFarmRecord();
        //    Assert.IsTrue(CreateNewFarmRecordPage.IsAt, "This is not the Farm Page");

        //    CreateNewFarmRecordPage.clickEditRecord();
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.DiseaseReportSummary.IsAt, "This is not the Disease Report Summary page");

        //    CreateLivestockDiseaseReportPage.clickFarmEpiInfoLink();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.FarmEpiInfo.IsAt, "This is not the Farm Epidemiological Info section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Livestock Disease Summary Report | Species Investigation section")]
        //public void VerifyVeterinaryLivestockDiseaseReportPageSpeciesInvestigationSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Livestock Disease Summary Report | Species Investigation section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickLivestockDiseaseReport();
        //    Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Search by Farm Information Page");

        //    //SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    SearchFarmInformationPage.clickEditSearchBtn();
        //    SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    SearchFarmInformationPage.SearchResults.editFarmRecord();
        //    Assert.IsTrue(CreateNewFarmRecordPage.IsAt, "This is not the Farm Page");

        //    CreateNewFarmRecordPage.clickEditRecord();
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.DiseaseReportSummary.IsAt, "This is not the Disease Report Summary page");

        //    CreateLivestockDiseaseReportPage.clickSpeciesInvestLink();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.SpeciesInvestigation.IsAt, "This is not the Species Investigation section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}


        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Livestock Disease Summary Report | Vaccination Information section")]
        //public void VerifyVeterinaryLivestockDiseaseReportPageVaccineInfoSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Livestock Disease Summary Report | Vaccination Information section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickLivestockDiseaseReport();
        //    Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Search by Farm Information Page");

        //    //SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    SearchFarmInformationPage.clickEditSearchBtn();
        //    SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    SearchFarmInformationPage.SearchResults.editFarmRecord();
        //    Assert.IsTrue(CreateNewFarmRecordPage.IsAt, "This is not the Farm Page");

        //    CreateNewFarmRecordPage.clickEditRecord();
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.DiseaseReportSummary.IsAt, "This is not the Disease Report Summary page");

        //    CreateLivestockDiseaseReportPage.clickVaccineInfoLink();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.VaccineInfo.IsAt, "This is not the Vaccination Information section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Livestock Disease Summary Report | Animals section")]
        //public void VerifyVeterinaryLivestockDiseaseReportPageAnimalsSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Livestock Disease Summary Report | Animals section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickLivestockDiseaseReport();
        //    Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Search by Farm Information Page");

        //    //SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");


        //    SearchFarmInformationPage.clickEditSearchBtn();
        //    SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    SearchFarmInformationPage.SearchResults.editFarmRecord();
        //    Assert.IsTrue(CreateNewFarmRecordPage.IsAt, "This is not the Farm Page");

        //    CreateNewFarmRecordPage.clickEditRecord();
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.DiseaseReportSummary.IsAt, "This is not the Disease Report Summary page");

        //    CreateLivestockDiseaseReportPage.clickAnimalsLink();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.Animals.IsAt, "This is not the Animals section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}


        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Livestock Disease Summary Report | Samples section")]
        //public void VerifyVeterinaryLivestockDiseaseReportPageSamplesSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Livestock Disease Summary Report | Samples section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickLivestockDiseaseReport();
        //    Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Search by Farm Information Page");

        //    //SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    SearchFarmInformationPage.clickEditSearchBtn();
        //    SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    SearchFarmInformationPage.SearchResults.editFarmRecord();
        //    Assert.IsTrue(CreateNewFarmRecordPage.IsAt, "This is not the Farm Page");

        //    CreateNewFarmRecordPage.clickEditRecord();
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.DiseaseReportSummary.IsAt, "This is not the Disease Report Summary page");

        //    CreateLivestockDiseaseReportPage.clickSamplesLink();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.Samples.IsAt, "This is not the Samples section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}


        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Livestock Disease Summary Report | Penside Tests section")]
        //public void VerifyVeterinaryLivestockDiseaseReportPagePensideTestsSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Livestock Disease Summary Report | Penside Tests section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickLivestockDiseaseReport();
        //    Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Search by Farm Information Page");

        //    //SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    SearchFarmInformationPage.clickEditSearchBtn();
        //    SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    SearchFarmInformationPage.SearchResults.editFarmRecord();
        //    Assert.IsTrue(CreateNewFarmRecordPage.IsAt, "This is not the Farm Page");

        //    CreateNewFarmRecordPage.clickEditRecord();
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.DiseaseReportSummary.IsAt, "This is not the Disease Report Summary page");

        //    CreateLivestockDiseaseReportPage.clickPensideTestsLink();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.PensideTests.IsAt, "This is not the Penside Tests section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Livestock Disease Summary Report | Lab Test section")]
        //public void VerifyVeterinaryLivestockDiseaseReportPageLabTestSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Livestock Disease Summary Report | Lab Test section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickLivestockDiseaseReport();
        //    Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Search by Farm Information Page");

        //    //SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    SearchFarmInformationPage.SearchResults.editFarmRecord();
        //    Assert.IsTrue(CreateNewFarmRecordPage.IsAt, "This is not the Farm Page");

        //    SearchFarmInformationPage.clickEditSearchBtn();
        //    SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    SearchFarmInformationPage.SearchResults.editFarmRecord();
        //    Assert.IsTrue(CreateNewFarmRecordPage.IsAt, "This is not the Farm Page");

        //    CreateNewFarmRecordPage.clickEditRecord();
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.DiseaseReportSummary.IsAt, "This is not the Disease Report Summary page");

        //    CreateLivestockDiseaseReportPage.clickLabTestsInterpretLink();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.LabTestInterpret.LabTest.IsAt, "This is not the Lab Test section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Livestock Disease Summary Report | Interpretation section")]
        //public void VerifyVeterinaryLivestockDiseaseReportPageInterpretationSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Livestock Disease Summary Report | Interpretation section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickLivestockDiseaseReport();
        //    Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Search by Farm Information Page");

        //    //SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    SearchFarmInformationPage.SearchResults.editFarmRecord();
        //    Assert.IsTrue(CreateNewFarmRecordPage.IsAt, "This is not the Farm Page");

        //    SearchFarmInformationPage.clickEditSearchBtn();
        //    SearchFarmInformationPage.selectLivestockFarmType();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    SearchFarmInformationPage.SearchResults.editFarmRecord();
        //    Assert.IsTrue(CreateNewFarmRecordPage.IsAt, "This is not the Farm Page");

        //    CreateNewFarmRecordPage.clickEditRecord();
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewLivestockDiseaseReport();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.DiseaseReportSummary.IsAt, "This is not the Disease Report Summary page");

        //    CreateLivestockDiseaseReportPage.clickLabTestsInterpretLink();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.LabTestInterpret.Interpretation.IsAt, "This is not the Interpretation section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Livestock Disease Summary Report | Case Log section")]
        //public void VerifyVeterinaryLivestockDiseaseReportPageCaseLogSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Livestock Disease Summary Report | Case Log section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickVeterinary();
        //    MainMenuNavigation.Veterinary.clickLivestockDiseaseReport();
        //    Assert.IsTrue(SearchFarmInformationPage.IsAt, "This is not the Search by Farm Information Page");

        //    //Click Add and search for a Farm
        //    SearchAvianDiseaseReportPage.SearchCriteria.clickCreateAvianDiseaseRpt();
        //    SearchFarmInformationPage.clickSearchBtn();
        //    Assert.IsTrue(SearchFarmInformationPage.SearchResults.IsAt, "This is not the Search Results Page");

        //    //Random select a farm and edit that record
        //    SearchFarmInformationPage.SearchResults.randomSelectFromFarmResults();
        //    CreateNewFarmRecordPage.clickEditRecord();

        //    //Click new Avian Disease Report and verify that the Samples section displays
        //    CreateNewFarmRecordPage.VeterinaryDiseaseReports.clickNewAvianDiseaseReport();
        //    CreateAvianAvianDiseaseRptPage.clickNextToCaseLogTab();
        //    Assert.IsTrue(CreateAvianAvianDiseaseRptPage.CaseLog.IsAt, "This is not the Case Log section");

        //    CreateLivestockDiseaseReportPage.clickCaseLogLink();
        //    Assert.IsTrue(CreateLivestockDiseaseReportPage.CaseLog.IsAt, "This is not the Case Log section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}


        [Test]
        ////[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Veterinary Aggregate | Veterinary Aggregate Cases Section")]
        public void VerifyVeterinaryAggregateCasesSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Veterinary Aggregate | Veterinary Aggregate Cases section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickAggregateReport();
            Assert.IsTrue(SearchVetAggrDiseaseReportPage.IsAt, "This is not the Veterinary Aggregate Disease Report page");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Veterinary Aggregate | Veterinary Aggregate Case | Search Form")]
        public void VerifyVeterinaryAggregateSearchSectionDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Veterinary Aggregate | Veterinary Aggregate Case | Search Form section")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickAggregateReport();
            Assert.IsTrue(SearchVetAggrDiseaseReportPage.SearchCriteria.IsAtSection, "This is not the Search Criteria section");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Veterinary Aggregate | Veterinary Aggregate Case | Veterinary Aggregate Disease Report Details")]
        public void VerifyVeterinaryAggregateVeterinaryAggregateDiseaseReportDetailsPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Veterinary Aggregate | Veterinary Aggregate Case | Veterinary Aggregate Case Detals page")
                   .AssignCategory("Veterinary");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickVeterinary();
            MainMenuNavigation.Veterinary.clickAggregateReport();
            Assert.IsTrue(SearchVetAggrDiseaseReportPage.IsAt, "This is not the Veterinary Aggregate Disease Report page ");

            //Click add Veterinary Aggregate Disease Report
            SearchVetAggrDiseaseReportPage.SearchCriteria.clickNewVACBtn();
            Assert.IsTrue(CreateVetAggrDiseaseReportPage.IsAt, "This is not the Veterinary Aggregate Disease Report Details");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Employee List Page and it displays successfully")]
        public void VerifyAdminEmployeesListPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Employee List Page and it displays successfully")
                   .AssignCategory("Administration");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.Administration.clickEmployees();
            Assert.IsTrue(EmployeeListPage.IsAt, "Employee List page does not display");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Employee Details Page and it displays successfully")]
        public void VerifyAdminEmployeeDetailsPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Employee Details Page and it displays successfully")
                   .AssignCategory("Administration");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.Administration.clickEmployees();
            Assert.IsTrue(EmployeeListPage.IsAt, "This is not Employee List Page");

            EmployeeListPage.clickAddNewEmployee();
            Assert.IsTrue(EmployeeDetailsPage.IsAt, "Employee Details page does not display");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Employee Details | Personal Information tab and it displays successfully")]
        public void VerifyAdminEmployeeDetailsPersonalInfoTabDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Employee Details | Personal Information tab and it displays successfully")
                   .AssignCategory("Administration");

            //Start execution of test for ExtentReport
            // test = extent.StartTest("Verify user can navigate to the Employee Details | Login tab and it displays successfully");
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.Administration.clickEmployees();
            Assert.IsTrue(EmployeeListPage.IsAt, "This is not Employee List Page");

            EmployeeListPage.clickAddNewEmployee();
            Assert.IsTrue(EmployeeDetailsPage.IsAt, "Employees Details page does not display");

            //Verify Personal Information displays by default
            Assert.IsTrue(EmployeeDetailsPage.PersonalInformation.doesPersonalInfoTabDisplay, "Personal Information section does not display");

            MainMenuNavigation.clickLogOut();
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Employee Details | Login tab and it displays successfully")]
        public void VerifyAdminEmployeeDetailsLoginTabDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Employee Details | Login tab and it displays successfully")
                   .AssignCategory("Administration");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.Administration.clickEmployees();
            Assert.IsTrue(EmployeeListPage.IsAt, "This is not Employee List Page");

            EmployeeListPage.clickAddNewEmployee();
            Assert.IsTrue(EmployeeDetailsPage.IsAt, "Employee Details Page does not display");

            //Click the Login tab
            //Verify that it displays
            EmployeeDetailsPage.clickLoginTab();
            Assert.IsTrue(EmployeeDetailsPage.Login.IsAt, "Login section does not display");

            MainMenuNavigation.clickLogOut();
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Employee Details | Groups tab and it displays successfully")]
        public void VerifyAdminEmployeeDetailsGroupsTabDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Employee Details | Groups tab and it displays successfully")
                   .AssignCategory("Administration");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.Administration.clickEmployees();
            Assert.IsTrue(EmployeeListPage.IsAt, "This is not Employee List Page");

            EmployeeListPage.clickAddNewEmployee();
            Assert.IsTrue(EmployeeDetailsPage.IsAt, "Employee Details page does not display");

            //Click the Groups tab
            //Verify that it displays
            EmployeeDetailsPage.clickGroupsTab();
            Assert.IsTrue(EmployeeDetailsPage.Groups.IsAt, "Groups section does not display");

            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Employee Details | System Functions tab and it displays successfully")]
        public void VerifyAdminEmployeeDetailsSysFunctionsTabDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Employee Details | System Functions tab and it displays successfully")
                   .AssignCategory("Administration");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.Administration.clickEmployees();
            Assert.IsTrue(EmployeeListPage.IsAt, "This is not Employee List Page");

            EmployeeListPage.clickAddNewEmployee();
            Assert.IsTrue(EmployeeDetailsPage.IsAt, "Employee Details page does not display");

            //Click the Groups tab
            //Verify that it displays
            EmployeeDetailsPage.clickSystemFunctionsTab();
            Assert.IsTrue(EmployeeDetailsPage.SystemFunctions.IsAt, "System Functions section does not display");

            MainMenuNavigation.clickLogOut();
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Organization List Page displays")]
        public void VerifyAdminOrganizationsListPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Organizations | Organization List page displays successfully")
                   .AssignCategory("Administration");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.Administration.clickOrganizations();
            Assert.IsTrue(OrgListPage.IsAt, "This is not the Organization List Page");

            MainMenuNavigation.clickLogOut();
            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Organization Details Page displays")]
        public void VerifyAdminOrganizationDetailsPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Organizations | Organization Details page displays successfully")
                   .AssignCategory("Administration");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.Administration.clickOrganizations();
            Assert.IsTrue(OrgListPage.IsAt, "This is not the Organization List Page");

            OrgListPage.clickNewOrg();
            Assert.IsTrue(OrgDetailsPage.IsAt, "This is not the Organization Detail Page");

            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
            //extent.EndTest(test);
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Organization Details | Departments Page displays")]
        public void VerifyAdminOrganizationDetailsDepartmentsPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Organizations | Departments page displays successfully")
                   .AssignCategory("Administration");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.Administration.clickOrganizations();
            Assert.IsTrue(OrgListPage.IsAt, "This is not the Organization List Page");

            OrgListPage.clickNewOrg();
            Assert.IsTrue(OrgDetailsPage.IsAt, "This is not the Organization Detail Page");

            //Click the Departments tab
            //Verify tab displays
            OrgDetailsPage.clickDepartments();
            Assert.IsTrue(OrgDetailsPage.Departments.IsAt, "This is not the Departments Page");

            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
            //extent.EndTest(test);
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Settlement List Page")]
        public void VerifyAdminSettlementListPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Settlements | Settlement List page displays successfully")
                   .AssignCategory("Administration");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.Administration.clickSettlements();
            Assert.IsTrue(SettlementListPage.IsAt, "This is not the Settlement List Page");

            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
            //extent.EndTest(test);
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Settlement Details Page")]
        public void VerifyAdminSettlementDetailsPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Settlement Details Page displays")
                   .AssignCategory("Administration");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.Administration.clickSettlements();
            Assert.IsTrue(SettlementListPage.IsAt, "This is not the Settlement List Page");

            SettlementListPage.clickNewButton();
            Assert.IsTrue(SettlementDetailPage.IsAt, "This is not the Settlement Details Page");

            MainMenuNavigation.clickLogOut();
            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
            //extent.EndTest(test);
        }


        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Statistical Data List Page")]
        public void VerifyAdminStatisticalDataListPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Statistical Data List Page displays")
                   .AssignCategory("Administration");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.Administration.clickStatisticalData();
            Assert.IsTrue(StatisticalDataListPage.IsAt, "This is not the Statistical Data List Page");

            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
            //extent.EndTest(test);
        }

        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Statistical Data Details Page")]
        public void VerifyAdminStatisticalDataDetailsPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Statistical Data Details Page displays")
                   .AssignCategory("Administration");

            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.Administration.clickStatisticalData();
            Assert.IsTrue(StatisticalDataListPage.IsAt, "This is not the Statistical Data List Page");

            StatisticalDataListPage.clickNewStatData();
            Assert.IsTrue(StatisticalDataDetailsPage.IsAt, "This is not the Statistical Data Details Page");

            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        [Test]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Reference Editor | Base Reference Editor page")]
        public void VerifyAdminReferenceEditorBaseReferenceEditorPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Reference Editor | Base Reference Editor page");
            test.AssignCategory("Reference Editor");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.clickReferenceEditor();
            MainMenuNavigation.ReferenceEditor.clickBaseRefEditor();
            Assert.IsTrue(BaseReferenceEditorPage.IsAt, "This is not the Base Reference Editor page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Reference Editor | Clinical Diagnoses Editor page")]
        //public void VerifyAdminReferenceEditorClinicalDiagnosesEditorPageDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Reference Editor | Clinical Diagnosis Editor page");

        //    //Login to EIDSS
        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickReferenceEditor();
        //    MainMenuNavigation.ReferenceEditor.clickClinicalDiagEditor();
        //    Assert.IsTrue(ClinicalDiagEditorPage.IsAt, "This is not the Clinical Diagnoses Editor page");

        //    //Logout of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //Log status and end test for report
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Reference Editor | Measures List page")]
        public void VerifyAdminReferenceEditorMeasuresListPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Reference Editor | Measures List page")
                   .AssignCategory("Reference Editor");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.clickReferenceEditor();
            MainMenuNavigation.ReferenceEditor.clickMeasuresEditor();
            Assert.IsTrue(MeasuresEditorPage.IsAt, "This is not the Measures List page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Reference Editor | Sample Types List page")]
        public void VerifyAdminReferenceEditorSampleTypesListPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Reference Editor | Sample Types List page");
            test.AssignCategory("Reference Editor");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.clickReferenceEditor();
            MainMenuNavigation.ReferenceEditor.clickSampleTypesEditor();
            Assert.IsTrue(SampleTypesEditorPage.IsAt, "This is not the Sample Types List page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Reference Editor | Vector Species Types List page")]
        public void VerifyAdminReferenceEditorVectorSpeciesTypesListPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Reference Editor | Vector Species Types List page");
            test.AssignCategory("Reference Editor");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.clickReferenceEditor();
            MainMenuNavigation.ReferenceEditor.clickVectorSpeciesTypesEditor();
            Assert.IsTrue(VectorSpeciesTypesEditorPage.IsAt, "This is not the Vector Species Types List page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Reference Editor | Vector Types List page")]
        public void VerifyAdminReferenceEditorVectorTypesListPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Reference Editor | Vector Types List page");
            test.AssignCategory("Reference Editor");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.clickReferenceEditor();
            MainMenuNavigation.ReferenceEditor.clickVectorSpeciesTypesEditor();
            Assert.IsTrue(VectorSpeciesTypesEditorPage.IsAt, "This is not the Vector Species Types List page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Reference Editor | Species Type List page")]
        public void VerifyAdminReferenceEditorSpeciesTypesListPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Reference Editor | Species Type List page");
            test.AssignCategory("Reference Editor");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.clickReferenceEditor();
            MainMenuNavigation.ReferenceEditor.clickSpeciesTypesEditor();
            Assert.IsTrue(SpeciesTypesEditorPage.IsAt, "This is not the Species Type List page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Reference Editor | Generic Statistical Types List page")]
        public void VerifyAdminReferenceEditorGenericStatTypesListPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Reference Editor | Generic Statistical Types List page");
            test.AssignCategory("Reference Editor");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();
            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.clickReferenceEditor();
            MainMenuNavigation.ReferenceEditor.clickGenericStatTypesEditor();
            Assert.IsTrue(GenericStatTypesEditorPage.IsAt, "This is not the Generic Statistical Types List page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Reference Editor | Report Disease Groups List page")]
        public void VerifyAdminReferenceEditorReportDiseaseGroupsListPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Reference Editor | Report Disease Groups List page");
            test.AssignCategory("Reference Editor");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.clickReferenceEditor();
            MainMenuNavigation.ReferenceEditor.clickReportDiseasesGroups();
            Assert.IsTrue(ReportDiseasesGroupsEditorPage.IsAt, "This is not the Report Disease Groups List page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        //[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Reference Editor | Diseases List page")]
        public void VerifyAdminReferenceEditorDiseasesListPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Reference Editor | Diseases List page");
            test.AssignCategory("Reference Editor");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.clickReferenceEditor();
            MainMenuNavigation.ReferenceEditor.clickDiseasesEditor();
            Assert.IsTrue(DiseasesPage.IsAt, "This is not the Diseases List page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        ////[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Reference Editor | Age Groups List page")]
        public void VerifyAdminReferenceEditorAgeGroupsEditorPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Reference Editor | Age Group List page");
            test.AssignCategory("Reference Editor");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.clickReferenceEditor();
            MainMenuNavigation.ReferenceEditor.clickAgeGroupsEditor();
            Assert.IsTrue(AgeGroupsEditorPage.IsAt, "This is not the Age Group List page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        ////[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Reference Editor | Case Classification List page")]
        public void VerifyAdminReferenceEditorCaseClassificationEditorPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Reference Editor | Case Classification List page");
            test.AssignCategory("Reference Editor");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.clickReferenceEditor();
            MainMenuNavigation.ReferenceEditor.clickCaseClassificationEditor();
            Assert.IsTrue(CaseClassificationEditorPage.IsAt, "This is not the Case Classification List page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        ////[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Configurations | Aggregate Settings page")]
        public void VerifyConfigAggregateSettingsPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Configurations | Aggregate Settings page");
            test.AssignCategory("Configurations");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickConfigurations();
            MainMenuNavigation.Configurations.clickAggregateSettings();
            Assert.IsTrue(AggregrateSettingsPage.IsAt, "This is not the Aggregate Settings page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        ////[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Configurations | Vector Type-Collection Method Matrix page")]
        public void VerifyConfigVectorTypeCollectMethodMatrixPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Configurations | Vector Type-Collection Method Matrix page");
            test.AssignCategory("Configurations");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickConfigurations();
            MainMenuNavigation.Configurations.clickVectorTypeCollectMethodMatrix();
            Assert.IsTrue(VectorTypeCollectMethodMatrixPage.IsAt, "This is not the Vector Type-Collection Method Matrix page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        ////[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Configurations | Parameter Type Editor page")]
        public void VerifyConfigParameterTypeEditorPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Configurations | Parameter Type Editor page");
            test.AssignCategory("Configurations");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickConfigurations();
            MainMenuNavigation.Configurations.clickParameterTypesEditor();
            Assert.IsTrue(ParameterTypesEditorPage.IsAt, "This is not the Parameter Type Editor page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        ////[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Configurations | Disease-Age Group Matrix page")]
        public void VerifyConfigDiseaseAgeGroupMatrixPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Configurations | Disease-Age Group Matrix page");
            test.AssignCategory("Configurations");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickConfigurations();
            MainMenuNavigation.Configurations.clickDiseaseAgeGroupMatrix();
            Assert.IsTrue(DiseaseAgeGroupMatrixPage.IsAt, "This is not the Disease-Age Group Matrix page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        ////[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Configurations | Report Disease Group - Disease Matrix page")]
        public void VerifyConfigReportDiseaseGroupMatrixPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Configurations | Report Disease Group - Disease Matrix page");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickConfigurations();
            MainMenuNavigation.Configurations.clickReportDiagnosisGroupMatrix();
            Assert.IsTrue(ReportDiagGroupDiagMatrixPage.IsAt, "This is not the Report Disease Group - Disease Matrix page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        ////[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Configurations | Disease Group - Disease Matrix page")]
        public void VerifyConfigDiseaseGroupDiseaseMatrixPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Configurations | Disease Group - Disease Matrix page");
            test.AssignCategory("Configurations");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickConfigurations();
            MainMenuNavigation.Configurations.clickDiseaseGroupDiseaseMatrix();
            Assert.IsTrue(DiseaseGroupDiseaseMatrixPage.IsAt, "This is not the Disease Group - Disease Matrix page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        [Test]
        ////[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Configurations | Custom Report Rows page")]
        public void VerifyConfigCustomReportRowsPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Configurations | Custom Report Rows page");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickConfigurations();
            MainMenuNavigation.Configurations.clickCustomReportRows();
            Assert.IsTrue(CustomReportRowsPage.IsAt, "This is not the Custom Report Rows page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        [Test]
        ////[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Configurations | Data Archiving Settings page")]
        public void VerifyConfigDataArchivingSettingsPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Configurations | Data Archiving Settings page");
            test.AssignCategory("Configurations");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickAdministration();
            MainMenuNavigation.Configurations.clickDataArchivingSettings();
            Assert.IsTrue(DataArchiveSettingsPage.IsAt, "This is not the Data Archiving Settings page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        ////[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Configurations | Disease - Penside Test Matrix page")]
        public void VerifyConfigDiseasePensideTestMatrixPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Configurations | Disease - Penside Test Matrix page");
            test.AssignCategory("Configurations");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickConfigurations();
            MainMenuNavigation.Configurations.clickDiseasePensideTestMatrix();
            Assert.IsTrue(DiseasePensideTestMatrixPage.IsAt, "This is not the Disease - Penside Test Matrix page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        ////[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Configurations | Species - Animal Age Matrix page")]
        public void VerifyConfigSpeciesAnimalAgeMatrixPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Configurations | Species - Animal Age Matrix page");
            test.AssignCategory("Configurations");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickConfigurations();
            MainMenuNavigation.Configurations.clickSpeciesAnimalAgeMatrix();
            Assert.IsTrue(SpeciesAnimalAgeMatrixPage.IsAt, "This is not the Species - Animal Age Matrix page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        ////[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Configurations | Test - Test Result Matrix page")]
        public void VerifyConfigTestTestResultMatrixPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Configurations | Test - Test Result Matrix page");
            test.AssignCategory("Configurations");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickConfigurations();
            MainMenuNavigation.Configurations.clickTestTestResultMatrix();
            Assert.IsTrue(TestResultMatrixPage.IsAt, "This is not the Test - Test Result Matrix page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        ////[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Configurations | Vector Type - Field Tests Matrix page")]
        public void VerifyConfigVectorTypeFieldTestsMatrixPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Configurations | Vector Type - Field Tests Matrix page");
            test.AssignCategory("Configurations");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickConfigurations();
            MainMenuNavigation.Configurations.clickVectorTypeFieldTestMatrix();
            Assert.IsTrue(VectorTypeFieldTestMatrixPage.IsAt, "This is not the Vector Type - Field Test Matrix page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        [Test]
        ////[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Configurations | Vector Type - Sample Type Matrix page")]
        public void VerifyConfigVectorTypeSampleTypeMatrixPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Configurations | Vector Type - Sample Type Matrix page");
            test.AssignCategory("Configurations");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickConfigurations();
            MainMenuNavigation.Configurations.clickVectorTypeSampleMatrix();
            Assert.IsTrue(VectorTypeSampleMatrixPage.IsAt, "This is not the Vector Type - Sample Type Matrix page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }

        [Test]
        ////[Ignore("Ignore a test")]
        [Category("SmokeTest")]
        [Description("Verify user can navigate to the Configurations | Sample Type - Derivative Type Matrix page")]
        public void VerifyConfigSampleTypeDerivativeTypeMatrixPageDisplays()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can navigate to the Configurations | Sample Type - Derivative Type Matrix page");
            test.AssignCategory("Configurations");

            //Login to EIDSS
            LoginPage.AJLoginIntoEIDSS();

            MainMenuNavigation.clickConfigurations();
            MainMenuNavigation.Configurations.clickSampleTypeDerivativeMatrix();
            Assert.IsTrue(SampleTypeDerivTypeMatrixPage.IsAt, "This is not the Sample Type - Derivative Type Matrix page");

            //Logout of EIDSS
            MainMenuNavigation.clickLogOut();

            //Log status and end test for report
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        //NOT IMPLEMENTED
        //[Test]
        //public void VerifySystemPreferencesPageDisplays()
        //{
        //    MainMenuNavigation.Options.Dashboard.System.clickSystemPreferences();
        //    Assert.IsTrue(SystemPreferencesPage.isAt, "This is not the System Preferences Page");
        //}

        //[Test]
        ////[Ignore("Ignore a test")]
        //[Category("SmokeTest")]
        //[Description("Verify user can navigate to the Laboratory | Samples section")]
        //public void VerifyLaboratorySamplesSectionDisplays()
        //{
        //    //Start execution of test for ExtentReport
        //    test = extent.StartTest("Verify user can navigate to the Human | Person | Person Employment/School Information section");

        //    LoginPage.AJLoginIntoEIDSS();

        //    MainMenuNavigation.clickLaboratory();
        //    MainMenuNavigation.Human.clickPersonMenuItem();
        //    Assert.IsTrue(SearchPersonPage.IsAt, "This is not the Person Page");

        //    SearchPersonDiseaseReportPage.clickCreateNewPersonRecord();
        //    Assert.IsTrue(CreateNewPersonPage.PersonInformation.IsAt, "This is not the Person Information section");

        //    CreateNewPersonPage.clickPersonAddress();
        //    CreateNewPersonPage.clickNext();
        //    Assert.IsTrue(CreateNewPersonPage.PersonEmployment.IsAt, "This is not the Person Employment/School section");

        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    test.Log(LogStatus.Pass, "Test passes successfully.");
        //}
    }
}