using EIDSS7Test.Navigation;
using EIDSS7Test.Selenium;
using EIDSS7Test.Outbreaks;
using EIDSS7Test.BaseScripts;
using EIDSS7Test.Database;
using NUnit.Framework;
using EIDSS7Test.HumanCases.CreateNewPerson;
using RelevantCodes.ExtentReports;
//using AventStack.ExtentReports;
using System.Data;
using EIDSS7Test.Veterinary.Farm;
using EIDSS7Test.Administration.Organizations;


namespace EIDSS7Test.EIDSSTests
{
    [TestFixture]
    public class OutbreakTests : TestBase
    {
        [Test]
        [Category("Regression")]
        [Description("Verify user can create an Outbreak Session for Human")]

        public void VerifyUserCanCreateAnOutbreakSessionForHuman()
        {
            //Start execution of //test for ExtentReport
            //test = extent.CreateTest("Verify user can create an Outbreak Session for Human");

            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS();

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            //Click create Outbreak
            SearchOutbreakPage.clickCreateOutbreak();
            Assert.IsTrue(CreateOutbreakPage.OutbreakInfo.IsAt, "This is not the Outbreak Information section");

            //Enter Outbreak information for Human
            //Verify Species Affected = Human is automatically checked
            CreateOutbreakPage.OutbreakInfo.randomSelectRegion();
            CreateOutbreakPage.isFieldEnabled(CreateOutbreakPage.OutbreakInfo.ddlRayon);
            CreateOutbreakPage.OutbreakInfo.randomSelectRayon();
            CreateOutbreakPage.OutbreakInfo.enterOutbreakType("Human");
            CreateOutbreakPage.OutbreakInfo.enterOutbreakStatus("In Progress");
            CreateOutbreakPage.OutbreakInfo.randomSelectDisease();
            CreateOutbreakPage.OutbreakInfo.isHumanSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isHumanSpeciesAffectedChecked();
            CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedUnChecked();
            CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedUnChecked();
            CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isVectorSpeciesAffectedUnChecked();
            CreateOutbreakPage.OutbreakInfo.isVectorSpeciesAffectedDisabled();

            //Enter Outbreak Parameters for Human
            CreateOutbreakPage.OutbreakParameters.HumanParameters.randomEnterCaseMonitorDuration();
            CreateOutbreakPage.OutbreakParameters.HumanParameters.randomEnterCaseMonitorFrequency();
            CreateOutbreakPage.OutbreakParameters.HumanParameters.randomEnterContactTracingDuration();
            CreateOutbreakPage.OutbreakParameters.HumanParameters.randomEnterContactTracingFrequency();

            //Answer "No" to continue to questionnaire
            //Click Submit
            CreateOutbreakPage.OutbreakParameters.clickQuestionnaireNO();
            CreateOutbreakPage.clickSubmit();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.IsAt, "This is not the Outbreak Session page");

            //Verify Outbreak ID was generated
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.getOutbreakIDValue();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.isOutbreakSessionIDPopulated();
            Assert.AreEqual(SetMethods.errorString, CreateOutbreakPage.getElementValue, "Values do not match.");

            //Log out of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            //test.Log(Status.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("Regression")]
        [Description("Verify user can cancel an Outbreak Session")]

        public void VerifyUserCanCancelAnOutbreakSession()
        {
            //Start execution of //test for ExtentReport
            //test = extent.CreateTest("Verify user can cancel an Outbreak Session");

            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS();

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            //Click create Outbreak
            SearchOutbreakPage.clickCreateOutbreak();
            Assert.IsTrue(CreateOutbreakPage.OutbreakInfo.IsAt, "This is not the Outbreak Information section");

            //Enter Outbreak information for Human
            //Verify Species Affected = Human is automatically checked
            CreateOutbreakPage.OutbreakInfo.randomSelectRegion();
            CreateOutbreakPage.isFieldEnabled(CreateOutbreakPage.OutbreakInfo.ddlRayon);
            CreateOutbreakPage.OutbreakInfo.randomSelectRayon();
            CreateOutbreakPage.OutbreakInfo.enterOutbreakType("Human");
            CreateOutbreakPage.OutbreakInfo.enterOutbreakStatus("In Progress");
            CreateOutbreakPage.OutbreakInfo.randomSelectDisease();
            CreateOutbreakPage.OutbreakInfo.isHumanSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isHumanSpeciesAffectedChecked();
            CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedUnChecked();
            CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedUnChecked();
            CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isVectorSpeciesAffectedUnChecked();
            CreateOutbreakPage.OutbreakInfo.isVectorSpeciesAffectedDisabled();

            //Click Cancel
            //Verify user is returned to the Outbreak Management page
            CreateOutbreakPage.clickCancel();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            //Log out of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            //test.Log(Status.Pass, "Test passes successfully.");
        }

        //[Test]
        //[Category("Regression")]
        //[Description("Verify user can cancel an Outbreak Session")]

        //public void VerifyUserCanCancelAnOutbreakSession()
        //{
        //    //Start execution of //test for ExtentReport
        //    //test = extent.CreateTest("Verify user can cancel an Outbreak Session");

        //    //Log into EIDSS
        //    LoginPage.DEVLoginIntoEIDSS();

        //    //Navigate to Search Outbreak page
        //    MainMenuNavigation.clickOutbreaks();
        //    MainMenuNavigation.Outbreaks.clickOutbreak();
        //    Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

        //    //Click create Outbreak
        //    SearchOutbreakPage.clickCreateOutbreak();
        //    Assert.IsTrue(CreateOutbreakPage.OutbreakInfo.IsAt, "This is not the Outbreak Information section");

        //    //Enter Outbreak information for Human
        //    //Verify Species Affected = Human is automatically checked
        //    CreateOutbreakPage.OutbreakInfo.randomSelectRegion();
        //    CreateOutbreakPage.isFieldEnabled(CreateOutbreakPage.OutbreakInfo.ddlRayon);
        //    CreateOutbreakPage.OutbreakInfo.randomSelectRayon();
        //    CreateOutbreakPage.OutbreakInfo.enterOutbreakType("Human");
        //    CreateOutbreakPage.OutbreakInfo.enterOutbreakStatus("In Progress");
        //    CreateOutbreakPage.OutbreakInfo.randomSelectDisease();
        //    CreateOutbreakPage.OutbreakInfo.isHumanSpeciesAffectedDisabled();
        //    CreateOutbreakPage.OutbreakInfo.isHumanSpeciesAffectedChecked();
        //    CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedUnChecked();
        //    CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedDisabled();
        //    CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedUnChecked();
        //    CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedDisabled();
        //    CreateOutbreakPage.OutbreakInfo.isVectorSpeciesAffectedUnChecked();
        //    CreateOutbreakPage.OutbreakInfo.isVectorSpeciesAffectedDisabled();

        //    //Click Cancel
        //    //Verify user is returned to the Outbreak Management page
        //    CreateOutbreakPage.clickCancel();
        //    Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

        //    //Log out of EIDSS
        //    MainMenuNavigation.clickLogOut();

        //    //End the report and log the status
        //    //test.Log(Status.Pass, "Test passes successfully.");
        //}



        [Test]
        [Category("Regression")]
        [Description("Verify user can create an Outbreak Session for Avian and Livestock")]

        public void VerifyUserCanCreateAnOutbreakSessionForAvianAndLivestock()
        {
            //Start execution of //test for ExtentReport
            //test = extent.CreateTest("Verify user can create an Outbreak Session for Avian and Livestock");

            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS();

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            //Click create Outbreak
            SearchOutbreakPage.clickCreateOutbreak();
            Assert.IsTrue(CreateOutbreakPage.OutbreakInfo.IsAt, "This is not the Outbreak Information section");

            //Enter Outbreak information for Human
            //Verify Species Affected = Human is automatically checked
            CreateOutbreakPage.OutbreakInfo.randomSelectRegion();
            CreateOutbreakPage.isFieldEnabled(CreateOutbreakPage.OutbreakInfo.ddlRayon);
            CreateOutbreakPage.OutbreakInfo.randomSelectRayon();
            CreateOutbreakPage.OutbreakInfo.enterOutbreakType("Veterinary");
            CreateOutbreakPage.OutbreakInfo.enterOutbreakStatus("In Progress");
            CreateOutbreakPage.OutbreakInfo.enterDisease("Botulism");
            CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedChecked();
            CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedChecked();

            //Enter Outbreak Parameters for Avian
            CreateOutbreakPage.OutbreakParameters.AvianParameters.randomEnterCaseMonitorDuration();
            CreateOutbreakPage.OutbreakParameters.AvianParameters.randomEnterCaseMonitorFrequency();
            CreateOutbreakPage.OutbreakParameters.AvianParameters.randomEnterContactTracingDuration();
            CreateOutbreakPage.OutbreakParameters.AvianParameters.randomEnterContactTracingFrequency();

            //Enter Outbreak Parameters for Livestock
            CreateOutbreakPage.OutbreakParameters.LivestockParameters.randomEnterCaseMonitorDuration();
            CreateOutbreakPage.OutbreakParameters.LivestockParameters.randomEnterCaseMonitorFrequency();
            CreateOutbreakPage.OutbreakParameters.LivestockParameters.randomEnterContactTracingDuration();
            CreateOutbreakPage.OutbreakParameters.LivestockParameters.randomEnterContactTracingFrequency();

            //Answer "No" to continue to questionnaire
            //Click Submit
            CreateOutbreakPage.OutbreakParameters.clickQuestionnaireNO();
            CreateOutbreakPage.clickSubmit();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.IsAt, "This is not the Outbreak Session page");

            //Verify Outbreak ID was generated
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.getOutbreakIDValue();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.isOutbreakSessionIDPopulated();
            Assert.AreEqual(SetMethods.errorString, CreateOutbreakPage.getElementValue, "Values do not match.");

            //Log out of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            //test.Log(Status.Pass, "Test passes successfully.");
        }


        [Test]
        [Category("Regression")]
        [Description("Verify user can create an Outbreak Session for Avian")]
        public void VerifyUserCanCreateAnOutbreakSessionForAvian()
        {
            //Start execution of //test for ExtentReport
            //test = extent.CreateTest("Verify user can create an Outbreak Session for Avian");

            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS();

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            //Generate .CSV file with valid Organizations
            EIDSSParameterData.GetOrganizationQueryResults();
            EIDSSParameterData.GetOrganizationData();

            //Click create Outbreak
            SearchOutbreakPage.clickCreateOutbreak();
            Assert.IsTrue(CreateOutbreakPage.OutbreakInfo.IsAt, "This is not the Outbreak Information section");

            //Enter Outbreak information for Human
            //Verify Species Affected = Human is automatically checked
            CreateOutbreakPage.OutbreakInfo.randomSelectRegion();
            CreateOutbreakPage.isFieldEnabled(CreateOutbreakPage.OutbreakInfo.ddlRayon);
            CreateOutbreakPage.OutbreakInfo.randomSelectRayon();
            CreateOutbreakPage.OutbreakInfo.enterOutbreakType("Veterinary");
            CreateOutbreakPage.OutbreakInfo.enterOutbreakStatus("In Progress");
            CreateOutbreakPage.OutbreakInfo.enterDisease("Botulism");
            CreateOutbreakPage.OutbreakInfo.isHumanSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isHumanSpeciesAffectedUnChecked();
            CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedChecked();
            CreateOutbreakPage.OutbreakInfo.clickLivestockCheckbox();
            CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedUnChecked();
            CreateOutbreakPage.OutbreakInfo.isVectorSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isVectorSpeciesAffectedUnChecked();

            //Enter Outbreak Parameters for Avian
            CreateOutbreakPage.OutbreakParameters.AvianParameters.randomEnterCaseMonitorDuration();
            CreateOutbreakPage.OutbreakParameters.AvianParameters.randomEnterCaseMonitorFrequency();
            CreateOutbreakPage.OutbreakParameters.AvianParameters.randomEnterContactTracingDuration();
            CreateOutbreakPage.OutbreakParameters.AvianParameters.randomEnterContactTracingFrequency();

            //Answer "No" to continue to questionnaire
            //Click Submit
            CreateOutbreakPage.OutbreakParameters.clickQuestionnaireNO();
            CreateOutbreakPage.clickSubmit();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.IsAt, "This is not the Outbreak Session page");

            //Verify Outbreak ID was generated
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.getOutbreakIDValue();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.isOutbreakSessionIDPopulated();
            Assert.AreEqual(SetMethods.errorString, CreateOutbreakPage.getElementValue, "Values do not match.");

            //Log out of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            //test.Log(Status.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("Regression")]
        [Description("Verify user can create an Livestock Disease Report for an Outbreak Session")]
        public void VerifyENDtoENDUserCanCreateAnLivestockDiseaseReportForOutbreakSession()
        {
            //Start execution of test for ExtentReport
            test = extent.StartTest("Verify user can create an Livestock Disease Report for an Outbreak Session")
                   .AssignCategory("Outbreak");

            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS();

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            //Execute query to get list of Organizations from DB
            EIDSSParameterData.GetEmployeeAndOrgQueryResults();
            EIDSSParameterData.GetEmployeeOrgData();

            //Navigate to the Advanced Search page
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
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.clickClear();
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.selectLivestockFarmType();
            SearchFarmInformationPage.OutbreakSearchFarm.SearchCriteria.clickSearch();
            Assert.IsTrue(SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.IsAt, "This is not the Search Results Page");

            //Random select the Farm
            SearchFarmInformationPage.OutbreakSearchFarm.SearchResults.randomSelectFromFarmResults();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Notification.IsAt, "This is not the Notification section");

            //Enter data in Notification section
            OutbreakVetDiseaseRptPage.Notification.enterDateOfNotification();
            OutbreakVetDiseaseRptPage.Notification.enterNotifiySentByFacility(EIDSSParameterData.abbrv);
            OutbreakVetDiseaseRptPage.Notification.enterNotifiySentByName(EIDSSParameterData.lastname);
            OutbreakVetDiseaseRptPage.Notification.enterNotifiyRecvdByFacility(EIDSSParameterData.abbrv);
            OutbreakVetDiseaseRptPage.Notification.enterNotifiyRecvdByName(EIDSSParameterData.lastname);

            //Enter data in the Location section
            OutbreakVetDiseaseRptPage.clickNext();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Location.IsAt, "This is not the Location section");
            OutbreakVetDiseaseRptPage.Location.enterRegion("Tbilisi");
            OutbreakVetDiseaseRptPage.Location.enterRayon("Didgori");
            OutbreakVetDiseaseRptPage.Location.enterSettlement("Settle979779779");
            OutbreakVetDiseaseRptPage.Location.enterStreet("Dragon Breathe");
            OutbreakVetDiseaseRptPage.Location.enterHouseNumber();
            OutbreakVetDiseaseRptPage.Location.enterBuildingNumber();
            OutbreakVetDiseaseRptPage.Location.enterAptNumber();
            OutbreakVetDiseaseRptPage.Location.enterLatitude();
            OutbreakVetDiseaseRptPage.Location.enterLongitude();

            //Enter data in the Herd/Flock/Species section
            OutbreakVetDiseaseRptPage.clickNext();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.HerdFlockSpeciesInfo.IsAt, "This is not the Herd/Flock/Species section");
            OutbreakVetDiseaseRptPage.HerdFlockSpeciesInfo.clickLivestockTypeOfCase();
            OutbreakVetDiseaseRptPage.HerdFlockSpeciesInfo.clickAddRecord();
            OutbreakVetDiseaseRptPage.HerdFlockSpeciesInfo.clickAddSpecies();
            OutbreakVetDiseaseRptPage.HerdFlockSpeciesInfo.randomSelectSpecies();
            OutbreakVetDiseaseRptPage.HerdFlockSpeciesInfo.enterTotalNumberOfAnimals(400);
            OutbreakVetDiseaseRptPage.HerdFlockSpeciesInfo.enterTotalNumberOfDeadAnimals(150);
            OutbreakVetDiseaseRptPage.HerdFlockSpeciesInfo.enterTotalNumberOfSickAnimals(250);
            OutbreakVetDiseaseRptPage.HerdFlockSpeciesInfo.enterStartOfSignsDate();
            OutbreakVetDiseaseRptPage.HerdFlockSpeciesInfo.enterNotes();
            OutbreakVetDiseaseRptPage.HerdFlockSpeciesInfo.clickUpdateRecord();
            OutbreakVetDiseaseRptPage.HerdFlockSpeciesInfo.getHerdCodeFromGrid();
            OutbreakVetDiseaseRptPage.HerdFlockSpeciesInfo.getCurTotalNumberOfSpecies();

            //Enter data in the Clinical Information section
            OutbreakVetDiseaseRptPage.clickNext();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.ClinicalInfo.IsAt, "This is not the Clinical Information section");
            OutbreakVetDiseaseRptPage.ClinicalInfo.getCurrentSpeciesFromGrid();
            OutbreakVetDiseaseRptPage.ClinicalInfo.selectHerdFromList();
            OutbreakVetDiseaseRptPage.ClinicalInfo.selectSpeciesFromList();
            OutbreakVetDiseaseRptPage.ClinicalInfo.enterAnimalID("A-");
            OutbreakVetDiseaseRptPage.ClinicalInfo.randomSelectAnimalAge();
            OutbreakVetDiseaseRptPage.ClinicalInfo.randomSelectSex();
            OutbreakVetDiseaseRptPage.ClinicalInfo.randomSelectAnimalStatus();
            OutbreakVetDiseaseRptPage.ClinicalInfo.enterNotes();
            OutbreakVetDiseaseRptPage.ClinicalInfo.clickAdd();

            //Enter data in the Vaccination Information section
            OutbreakVetDiseaseRptPage.clickNext();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.VaccinationInfo.IsAt, "This is not the Vaccination Information section");
            OutbreakVetDiseaseRptPage.VaccinationInfo.randomSelectDisease();
            OutbreakVetDiseaseRptPage.VaccinationInfo.selectSpeciesFromList();
            OutbreakVetDiseaseRptPage.VaccinationInfo.enterNoOfAnimalsVaccinated();
            OutbreakVetDiseaseRptPage.VaccinationInfo.randomSelectType();
            OutbreakVetDiseaseRptPage.VaccinationInfo.randomSelectRoute();
            OutbreakVetDiseaseRptPage.VaccinationInfo.enterLotNumber("LOT # ");
            OutbreakVetDiseaseRptPage.VaccinationInfo.enterManufacturer();
            OutbreakVetDiseaseRptPage.VaccinationInfo.enterNotes();
            OutbreakVetDiseaseRptPage.VaccinationInfo.clickAdd();

            //Enter data in the Outbreak Investigation section
            OutbreakVetDiseaseRptPage.clickNext();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.OutbreakInvest.IsAt, "This is not the Outbreak Investigation section");

            ////Search for an Organization
            OutbreakVetDiseaseRptPage.OutbreakInvest.clickInvestorOrgLookup();
            OrgListPage.OutbreakSrchCriteria.clickClearOrg();
            OrgListPage.OutbreakSrchCriteria.enterOrgAbbreviation(EIDSSParameterData.abbrv);

            //Click Search and randomly select an organization
            OrgListPage.OutbreakSrchCriteria.clickSearch();
            //Assert.IsTrue(OrgListPage.OutbreakSrchResults.IsAt, "This is not the Search Results section");
            //OrgListPage.OutbreakSrchResults.randomSelectOrgID();
            OrgListPage.OutbreakSrchResults.selectFirstOrgID();

            //Enter the remainder of information
            //OutbreakVetDiseaseRptPage.OutbreakInvest.enterInvestigatorOrganization(EIDSSParameterData.org);
            OutbreakVetDiseaseRptPage.OutbreakInvest.enterInvestigatorName(EIDSSParameterData.lastname);
            OutbreakVetDiseaseRptPage.OutbreakInvest.enterDateOfInvestiation();
            OutbreakVetDiseaseRptPage.OutbreakInvest.randomSelectCaseStatus();
            OutbreakVetDiseaseRptPage.OutbreakInvest.randomSelectCaseClassification();
            OutbreakVetDiseaseRptPage.OutbreakInvest.clickPrimaryCase();
            OutbreakVetDiseaseRptPage.OutbreakInvest.enterAdditionalComments();

            //Enter data in the Case Monitoring section
            //NOTE:  This section is driven by Flex Forms so has limited fields.
            //This section is also hidden if no data is entered in the Case Monitoring Duration fields
            OutbreakVetDiseaseRptPage.clickNext();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.CaseMonitoring.IsAt, "This is not the Case Monitoring section");
            OutbreakVetDiseaseRptPage.CaseMonitoring.enterAdditionalComments();
            OutbreakVetDiseaseRptPage.CaseMonitoring.clickInvestOrgLookup();
            //Assert.IsTrue(OrgListPage.OutbreakSrchCriteria.IsAt, "This is not the Search Organization page");

            //Search for an Investigator Organization
            OrgListPage.OutbreakSrchCriteria.clickClearOrg();
            OrgListPage.OutbreakSrchCriteria.enterOrgAbbreviation(EIDSSParameterData.abbrv);
            OrgListPage.OutbreakSrchCriteria.clickSearch();
            OrgListPage.OutbreakSrchResults.selectFirstOrgID();

            //Enter Investigator Name and click Add
            OutbreakVetDiseaseRptPage.CaseMonitoring.enterInvestigatorName(EIDSSParameterData.lastname);
            OutbreakVetDiseaseRptPage.CaseMonitoring.clickAddCaseMonitoring();

            //Navigate to Contacts section
            OutbreakVetDiseaseRptPage.clickContactsLink();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Contacts.IsAt, "This is not the Contacts section");

            //Search for and select a Contact
            OutbreakVetDiseaseRptPage.Contacts.clickContactNameLookup();
            SearchPersonPage.clickClear();
            SearchPersonPage.SearchCriteria.enterPartialPersonalID("PER");
            SearchPersonPage.clickSearch();
            SearchPersonPage.SearchResults.randomSelectPersonFromGrid();

            //Enter the rest of the data in the Contacts section
            OutbreakVetDiseaseRptPage.Contacts.randomSelectRelation();
            OutbreakVetDiseaseRptPage.Contacts.enterDateOfLastContact();
            OutbreakVetDiseaseRptPage.Contacts.enterPlaceOfLastContact(" Kung Fu Treachery Drive");
            OutbreakVetDiseaseRptPage.Contacts.randomSelectContactStatus();
            OutbreakVetDiseaseRptPage.Contacts.enterContactComments();
            OutbreakVetDiseaseRptPage.Contacts.clickAddContact();
            //OutbreakVetDiseaseRptPage.Contacts.doesNewRecordShowInGrid(); //NOTE:  This step currently fails because Add button does not work

            //Go to Samples section
            OutbreakVetDiseaseRptPage.clickNext();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Samples.IsAt, "This is not the Samples section");
            OutbreakVetDiseaseRptPage.Samples.clickAddSamples();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.Samples.SamplesPopupWndw.IsAt, "This is not the Samples popup window");

            //Enter data in fields Add Sample fields
            OutbreakVetDiseaseRptPage.Samples.SamplesPopupWndw.randomSelectSampleType();
            OutbreakVetDiseaseRptPage.Samples.SamplesPopupWndw.enterFieldSampleID("FLD-");
            OutbreakVetDiseaseRptPage.Samples.SamplesPopupWndw.enterSpecies(SetMethods.refValue4);
            OutbreakVetDiseaseRptPage.Samples.SamplesPopupWndw.enterAnimalID("A-");
            OutbreakVetDiseaseRptPage.Samples.SamplesPopupWndw.enterCollectionDate();
            OutbreakVetDiseaseRptPage.Samples.SamplesPopupWndw.enterCollectedByOrg(EIDSSParameterData.abbrv);
            OutbreakVetDiseaseRptPage.Samples.SamplesPopupWndw.enterCollectedByOffice(EIDSSParameterData.lastname);
            OutbreakVetDiseaseRptPage.Samples.SamplesPopupWndw.enterSentToOrg(EIDSSParameterData.abbrv);
            OutbreakVetDiseaseRptPage.Samples.SamplesPopupWndw.clickSaveSample();
            OutbreakVetDiseaseRptPage.Samples.getCurrSampleTypeFromGrid();
            OutbreakVetDiseaseRptPage.Samples.getCurrFieldSampleFromGrid();

            //Navigate to Penside Tests section
            OutbreakVetDiseaseRptPage.clickNext();
            Assert.IsTrue(OutbreakVetDiseaseRptPage.PensideTests.IsAt, "This is not the Penside Tests section");
            OutbreakVetDiseaseRptPage.PensideTests.enterFieldSamples();
            OutbreakVetDiseaseRptPage.PensideTests.randomSelectTestName();
            OutbreakVetDiseaseRptPage.PensideTests.randomSelectTestResult();
            OutbreakVetDiseaseRptPage.PensideTests.clickAddPensideTest();

            //Navigate to Lab Tests & Interpretation section
            OutbreakVetDiseaseRptPage.clickLabTestsInterpretLink();
            OutbreakVetDiseaseRptPage.LabTestInterpret.clickAddLabTests();
            OutbreakVetDiseaseRptPage.LabTestInterpret.LabTestsPopupWndw.enterLabSampleID("LBL");
            OutbreakVetDiseaseRptPage.LabTestInterpret.LabTestsPopupWndw.enterSampleType();
            OutbreakVetDiseaseRptPage.LabTestInterpret.LabTestsPopupWndw.enterFieldSampleID();
            OutbreakVetDiseaseRptPage.LabTestInterpret.LabTestsPopupWndw.randomSelectTestDisease();
            OutbreakVetDiseaseRptPage.LabTestInterpret.LabTestsPopupWndw.randomSelectTestName();
            OutbreakVetDiseaseRptPage.LabTestInterpret.LabTestsPopupWndw.randomSelectTestCategory();
            OutbreakVetDiseaseRptPage.LabTestInterpret.LabTestsPopupWndw.enterTestStatus("Probable");
            OutbreakVetDiseaseRptPage.LabTestInterpret.LabTestsPopupWndw.enterResultDate();
            OutbreakVetDiseaseRptPage.LabTestInterpret.LabTestsPopupWndw.clickSave();

            //Click Next and Submit
            OutbreakVetDiseaseRptPage.clickNext();
            OutbreakVetDiseaseRptPage.clickSubmit();

            //Log out of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            test.Log(LogStatus.Pass, "Test passes successfully.");
        }


        [Test]
        [Category("Regression")]
        [Description("Verify user can create an Outbreak Session for Livestock")]
        public void VerifyUserCanCreateAnOutbreakSessionForLivestock()
        {
            //Start execution of //test for ExtentReport
            //test = extent.CreateTest("Verify user can create an Outbreak Session for Livestock");

            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS();

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            //Click create Outbreak
            SearchOutbreakPage.clickCreateOutbreak();
            Assert.IsTrue(CreateOutbreakPage.OutbreakInfo.IsAt, "This is not the Outbreak Information section");

            //Enter Outbreak information for Human
            //Verify Species Affected = Human is automatically checked
            CreateOutbreakPage.OutbreakInfo.randomSelectRegion();
            CreateOutbreakPage.isFieldEnabled(CreateOutbreakPage.OutbreakInfo.ddlRayon);
            CreateOutbreakPage.OutbreakInfo.randomSelectRayon();
            CreateOutbreakPage.OutbreakInfo.enterOutbreakType("Veterinary");
            CreateOutbreakPage.OutbreakInfo.enterOutbreakStatus("In Progress");
            CreateOutbreakPage.OutbreakInfo.enterDisease("Botulism");
            CreateOutbreakPage.OutbreakInfo.isHumanSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isHumanSpeciesAffectedUnChecked();
            CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.clickAvianCheckbox();
            CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedUnChecked();
            CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedChecked();
            CreateOutbreakPage.OutbreakInfo.isVectorSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isVectorSpeciesAffectedUnChecked();

            //Enter Outbreak Parameters for Livestock
            CreateOutbreakPage.OutbreakParameters.LivestockParameters.randomEnterCaseMonitorDuration();
            CreateOutbreakPage.OutbreakParameters.LivestockParameters.randomEnterCaseMonitorFrequency();
            CreateOutbreakPage.OutbreakParameters.LivestockParameters.randomEnterContactTracingDuration();
            CreateOutbreakPage.OutbreakParameters.LivestockParameters.randomEnterContactTracingFrequency();

            //Answer "No" to continue to questionnaire
            //Click Submit
            CreateOutbreakPage.OutbreakParameters.clickQuestionnaireNO();
            CreateOutbreakPage.clickSubmit();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.IsAt, "This is not the Outbreak Session page");

            //Verify Outbreak ID was generated
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.getOutbreakIDValue();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.isOutbreakSessionIDPopulated();
            Assert.AreEqual(SetMethods.errorString, CreateOutbreakPage.getElementValue, "Values do not match.");

            //Log out of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            //test.Log(Status.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("Regression")]
        [Description("Verify user can create an Outbreak Session for Zoonotic")]
        public void VerifyUserCanCreateAnOutbreakSessionForZoonotic()
        {
            //Start execution of //test for ExtentReport
            //test = extent.CreateTest("Verify user can create an Outbreak Session for Zoonotic");

            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS();

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            //Click create Outbreak
            SearchOutbreakPage.clickCreateOutbreak();
            Assert.IsTrue(CreateOutbreakPage.OutbreakInfo.IsAt, "This is not the Outbreak Information section");

            //Enter Outbreak information for Zoonotic
            //Verify all affected species are automatically checked
            CreateOutbreakPage.OutbreakInfo.randomSelectRegion();
            CreateOutbreakPage.isFieldEnabled(CreateOutbreakPage.OutbreakInfo.ddlRayon);
            CreateOutbreakPage.OutbreakInfo.randomSelectRayon();
            CreateOutbreakPage.OutbreakInfo.enterOutbreakType("Zoonotic");
            CreateOutbreakPage.OutbreakInfo.enterOutbreakStatus("In Progress");
            CreateOutbreakPage.OutbreakInfo.randomSelectDisease();
            CreateOutbreakPage.OutbreakInfo.isHumanSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isHumanSpeciesAffectedChecked();
            CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedChecked();
            CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedChecked();
            CreateOutbreakPage.OutbreakInfo.isVectorSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isVectorSpeciesAffectedChecked();

            //Enter Outbreak Parameters for Human
            CreateOutbreakPage.OutbreakParameters.HumanParameters.randomEnterCaseMonitorDuration();
            CreateOutbreakPage.OutbreakParameters.HumanParameters.randomEnterCaseMonitorFrequency();
            CreateOutbreakPage.OutbreakParameters.HumanParameters.randomEnterContactTracingDuration();
            CreateOutbreakPage.OutbreakParameters.HumanParameters.randomEnterContactTracingFrequency();

            //Enter Outbreak Parameters for Avian
            CreateOutbreakPage.OutbreakParameters.AvianParameters.randomEnterCaseMonitorDuration();
            CreateOutbreakPage.OutbreakParameters.AvianParameters.randomEnterCaseMonitorFrequency();
            CreateOutbreakPage.OutbreakParameters.AvianParameters.randomEnterContactTracingDuration();
            CreateOutbreakPage.OutbreakParameters.AvianParameters.randomEnterContactTracingFrequency();

            //Enter Outbreak Parameters for Livestock
            CreateOutbreakPage.OutbreakParameters.LivestockParameters.randomEnterCaseMonitorDuration();
            CreateOutbreakPage.OutbreakParameters.LivestockParameters.randomEnterCaseMonitorFrequency();
            CreateOutbreakPage.OutbreakParameters.LivestockParameters.randomEnterContactTracingDuration();
            CreateOutbreakPage.OutbreakParameters.LivestockParameters.randomEnterContactTracingFrequency();

            //Enter Outbreak Parameters for Zoonotic
            CreateOutbreakPage.OutbreakParameters.ZoonoticParameters.randomEnterCaseMonitorDuration();
            CreateOutbreakPage.OutbreakParameters.ZoonoticParameters.randomEnterCaseMonitorFrequency();
            CreateOutbreakPage.OutbreakParameters.ZoonoticParameters.randomEnterContactTracingDuration();
            CreateOutbreakPage.OutbreakParameters.ZoonoticParameters.randomEnterContactTracingFrequency();

            //Answer "No" to continue to questionnaire
            //Click Submit
            CreateOutbreakPage.OutbreakParameters.clickQuestionnaireNO();
            CreateOutbreakPage.clickSubmit();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.IsAt, "This is not the Outbreak Session page");

            //Verify Outbreak ID was generated
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.getOutbreakIDValue();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.isOutbreakSessionIDPopulated();
            Assert.AreEqual(SetMethods.errorString, CreateOutbreakPage.getElementValue, "Values do not match.");

            //Log out of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            //test.Log(Status.Pass, "Test passes successfully.");
        }


        [Test]
        [Category("Regression")]
        [Description("Verify user can create an Outbreak Session for Zoonotic - Human and Vector")]
        public void VerifyUserCanCreateAnOutbreakSessForZoonHumanAndVector()
        {
            //Start execution of //test for ExtentReport
            //test = extent.CreateTest("Verify user can create an Outbreak Session for Zoonotic - Human and Vector");

            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS();

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            //Click create Outbreak
            SearchOutbreakPage.clickCreateOutbreak();
            Assert.IsTrue(CreateOutbreakPage.OutbreakInfo.IsAt, "This is not the Outbreak Information section");

            //Enter Outbreak information for Zoonotic
            //Verify all affected species are automatically checked
            CreateOutbreakPage.OutbreakInfo.randomSelectRegion();
            CreateOutbreakPage.isFieldEnabled(CreateOutbreakPage.OutbreakInfo.ddlRayon);
            CreateOutbreakPage.OutbreakInfo.randomSelectRayon();
            CreateOutbreakPage.OutbreakInfo.enterOutbreakType("Zoonotic");
            CreateOutbreakPage.OutbreakInfo.enterOutbreakStatus("In Progress");
            CreateOutbreakPage.OutbreakInfo.randomSelectDisease();
            CreateOutbreakPage.OutbreakInfo.isHumanSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isHumanSpeciesAffectedChecked();
            CreateOutbreakPage.OutbreakInfo.clickAvianCheckbox();
            CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedUnChecked();
            CreateOutbreakPage.OutbreakInfo.clickLivestockCheckbox();
            CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedUnChecked();
            CreateOutbreakPage.OutbreakInfo.isVectorSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isVectorSpeciesAffectedChecked();

            //Enter Outbreak Parameters for Human
            CreateOutbreakPage.OutbreakParameters.HumanParameters.randomEnterCaseMonitorDuration();
            CreateOutbreakPage.OutbreakParameters.HumanParameters.randomEnterCaseMonitorFrequency();
            CreateOutbreakPage.OutbreakParameters.HumanParameters.randomEnterContactTracingDuration();
            CreateOutbreakPage.OutbreakParameters.HumanParameters.randomEnterContactTracingFrequency();

            //Enter Outbreak Parameters for Zoonotic
            CreateOutbreakPage.OutbreakParameters.ZoonoticParameters.randomEnterCaseMonitorDuration();
            CreateOutbreakPage.OutbreakParameters.ZoonoticParameters.randomEnterCaseMonitorFrequency();
            CreateOutbreakPage.OutbreakParameters.ZoonoticParameters.randomEnterContactTracingDuration();
            CreateOutbreakPage.OutbreakParameters.ZoonoticParameters.randomEnterContactTracingFrequency();

            //Answer "No" to continue to questionnaire
            //Click Submit
            CreateOutbreakPage.OutbreakParameters.clickQuestionnaireNO();
            CreateOutbreakPage.clickSubmit();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.IsAt, "This is not the Outbreak Session page");

            //Verify Outbreak ID was generated
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.getOutbreakIDValue();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.isOutbreakSessionIDPopulated();
            Assert.AreEqual(SetMethods.errorString, CreateOutbreakPage.getElementValue, "Values do not match.");

            //Log out of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            //test.Log(Status.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("Regression")]
        [Description("Verify user can create an Outbreak Session for Zoonotic - Avian and Vector")]
        public void VerifyUserCanCreateAnOutbreakSessForZoonAvianAndVector()
        {
            //Start execution of //test for ExtentReport
            //test = extent.CreateTest("Verify user can create an Outbreak Session for Zoonotic - Avian and Vector");

            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS();

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            //Click create Outbreak
            SearchOutbreakPage.clickCreateOutbreak();
            Assert.IsTrue(CreateOutbreakPage.OutbreakInfo.IsAt, "This is not the Outbreak Information section");

            //Enter Outbreak information for Zoonotic
            //Verify all affected species are automatically checked
            CreateOutbreakPage.OutbreakInfo.randomSelectRegion();
            CreateOutbreakPage.isFieldEnabled(CreateOutbreakPage.OutbreakInfo.ddlRayon);
            CreateOutbreakPage.OutbreakInfo.randomSelectRayon();
            CreateOutbreakPage.OutbreakInfo.enterOutbreakType("Zoonotic");
            CreateOutbreakPage.OutbreakInfo.enterOutbreakStatus("In Progress");
            CreateOutbreakPage.OutbreakInfo.randomSelectDisease();
            CreateOutbreakPage.OutbreakInfo.clickHumanCheckbox();
            CreateOutbreakPage.OutbreakInfo.isHumanSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isHumanSpeciesAffectedUnChecked();
            CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedChecked();
            CreateOutbreakPage.OutbreakInfo.clickLivestockCheckbox();
            CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedUnChecked();
            CreateOutbreakPage.OutbreakInfo.isVectorSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isVectorSpeciesAffectedChecked();

            //Enter Outbreak Parameters for Avian
            CreateOutbreakPage.OutbreakParameters.AvianParameters.randomEnterCaseMonitorDuration();
            CreateOutbreakPage.OutbreakParameters.AvianParameters.randomEnterCaseMonitorFrequency();
            CreateOutbreakPage.OutbreakParameters.AvianParameters.randomEnterContactTracingDuration();
            CreateOutbreakPage.OutbreakParameters.AvianParameters.randomEnterContactTracingFrequency();

            //Enter Outbreak Parameters for Zoonotic
            CreateOutbreakPage.OutbreakParameters.ZoonoticParameters.randomEnterCaseMonitorDuration();
            CreateOutbreakPage.OutbreakParameters.ZoonoticParameters.randomEnterCaseMonitorFrequency();
            CreateOutbreakPage.OutbreakParameters.ZoonoticParameters.randomEnterContactTracingDuration();
            CreateOutbreakPage.OutbreakParameters.ZoonoticParameters.randomEnterContactTracingFrequency();

            //Answer "No" to continue to questionnaire
            //Click Submit
            CreateOutbreakPage.OutbreakParameters.clickQuestionnaireNO();
            CreateOutbreakPage.clickSubmit();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.IsAt, "This is not the Outbreak Session page");

            //Verify Outbreak ID was generated
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.getOutbreakIDValue();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.isOutbreakSessionIDPopulated();
            Assert.AreEqual(SetMethods.errorString, CreateOutbreakPage.getElementValue, "Values do not match.");

            //Log out of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            //test.Log(Status.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("Regression")]
        [Description("Verify user can create an Outbreak Session for Zoonotic - Livestock and Vector")]
        public void VerifyUserCanCreateAnOutbreakSessForZoonLivestockAndVector()
        {
            //Start execution of //test for ExtentReport
            //test = extent.CreateTest("Verify user can create an Outbreak Session for Zoonotic - Livestock and Vector");

            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS();

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            //Click create Outbreak
            SearchOutbreakPage.clickCreateOutbreak();
            Assert.IsTrue(CreateOutbreakPage.OutbreakInfo.IsAt, "This is not the Outbreak Information section");

            //Enter Outbreak information for Zoonotic
            //Verify all affected species are automatically checked
            CreateOutbreakPage.OutbreakInfo.randomSelectRegion();
            CreateOutbreakPage.isFieldEnabled(CreateOutbreakPage.OutbreakInfo.ddlRayon);
            CreateOutbreakPage.OutbreakInfo.randomSelectRayon();
            CreateOutbreakPage.OutbreakInfo.enterOutbreakType("Zoonotic");
            CreateOutbreakPage.OutbreakInfo.enterOutbreakStatus("In Progress");
            CreateOutbreakPage.OutbreakInfo.randomSelectDisease();
            CreateOutbreakPage.OutbreakInfo.clickHumanCheckbox();
            CreateOutbreakPage.OutbreakInfo.isHumanSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isHumanSpeciesAffectedUnChecked();
            CreateOutbreakPage.OutbreakInfo.clickAvianCheckbox();
            CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isAvianSpeciesAffectedUnChecked();
            CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isLivestockSpeciesAffectedChecked();
            CreateOutbreakPage.OutbreakInfo.isVectorSpeciesAffectedDisabled();
            CreateOutbreakPage.OutbreakInfo.isVectorSpeciesAffectedChecked();

            //Enter Outbreak Parameters for Livestock
            CreateOutbreakPage.OutbreakParameters.LivestockParameters.randomEnterCaseMonitorDuration();
            CreateOutbreakPage.OutbreakParameters.LivestockParameters.randomEnterCaseMonitorFrequency();
            CreateOutbreakPage.OutbreakParameters.LivestockParameters.randomEnterContactTracingDuration();
            CreateOutbreakPage.OutbreakParameters.LivestockParameters.randomEnterContactTracingFrequency();

            //Enter Outbreak Parameters for Vector
            CreateOutbreakPage.OutbreakParameters.ZoonoticParameters.randomEnterCaseMonitorDuration();
            CreateOutbreakPage.OutbreakParameters.ZoonoticParameters.randomEnterCaseMonitorFrequency();
            CreateOutbreakPage.OutbreakParameters.ZoonoticParameters.randomEnterContactTracingDuration();
            CreateOutbreakPage.OutbreakParameters.ZoonoticParameters.randomEnterContactTracingFrequency();

            //Answer "No" to continue to questionnaire
            //Click Submit
            CreateOutbreakPage.OutbreakParameters.clickQuestionnaireNO();
            CreateOutbreakPage.clickSubmit();
            Assert.IsTrue(CreateOutbreakPage.OutbreakSession.IsAt, "This is not the Outbreak Session page");

            //Verify Outbreak ID was generated
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.getOutbreakIDValue();
            CreateOutbreakPage.OutbreakSession.OutbreakSummary.isOutbreakSessionIDPopulated();
            Assert.AreEqual(SetMethods.errorString, CreateOutbreakPage.getElementValue, "Values do not match.");

            //Log out of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            //test.Log(Status.Pass, "Test passes successfully.");
        }


        [Test]
        [Category("Regression")]
        [Description("Verify error message displays if Zoonotic Vector is selected with no Human, Avian or Livestock")]
        public void VerifyErrorMsgDisplaysIfZoonVectorSelectedWithNoOtherSelection()
        {
            //Start execution of //test for ExtentReport
            //test = extent.CreateTest("Verify error message displays if Zoonotic Vector is selected with no Human, Avian or Livestock");

            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS();

            //Navigate to Outbreak Management page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            //Click create Outbreak
            SearchOutbreakPage.clickCreateOutbreak();
            Assert.IsTrue(CreateOutbreakPage.OutbreakInfo.IsAt, "This is not the Outbreak Information section");

            //Enter Outbreak information for Zoonotic
            //Verify all affected species are automatically checked
            CreateOutbreakPage.OutbreakInfo.enterOutbreakType("Zoonotic");
            CreateOutbreakPage.OutbreakInfo.enterOutbreakStatus("In Progress");
            CreateOutbreakPage.OutbreakInfo.randomSelectDisease();
            CreateOutbreakPage.OutbreakInfo.clickHumanCheckbox();
            CreateOutbreakPage.OutbreakInfo.clickAvianCheckbox();
            CreateOutbreakPage.OutbreakInfo.clickLivestockCheckbox();
            CreateOutbreakPage.OutbreakInfo.doesSpeciesAffectedErrorMsgDisplay();
            Assert.AreEqual(SetMethods.errorString, CreateOutbreakPage.OutbreakInfo.speciesAffectMsg);

            //Log out of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            //test.Log(Status.Pass, "Test passes successfully.");
        }


        [Test]
        public void VerifyErrorMsgDisplayIfOutbreakStartDateIsMissing()
        {
            //Start execution of //test for ExtentReport
            //test = extent.CreateTest("Verify error message displays when outbreak Start Date is missing");

            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS();

            //Navigate to Outbreak Management page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            //Click create Outbreak
            SearchOutbreakPage.clickCreateOutbreak();
            Assert.IsTrue(CreateOutbreakPage.OutbreakInfo.IsAt, "This is not the Outbreak Information section");

            //Remove Start Date
            //Verify error message displays
            CreateOutbreakPage.OutbreakInfo.clearDateField();
            CreateOutbreakPage.OutbreakInfo.doesStartDateErrorMessageDisplay();
            Assert.AreEqual(SetMethods.errorString, CreateOutbreakPage.OutbreakInfo.outbreakStartDte, "Error messages do not match.");

            //Log out of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            //test.Log(Status.Pass, "Test passes successfully.");
        }


        [Test]
        [Category("Regression")]
        [Description("Verify error message displays if Outbreak Status is missing")]
        public void VerifyErrorMsgDisplayIfOutbreakStatusIsMissing()
        {
            //Start execution of //test for ExtentReport
            //test = extent.CreateTest("Verify error message displays if Outbreak Status is missing");

            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS();

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            //Click create Outbreak
            SearchOutbreakPage.clickCreateOutbreak();
            Assert.IsTrue(CreateOutbreakPage.OutbreakInfo.IsAt, "This is not the Outbreak Information section");

            //Enter Outbreak information for Zoonotic
            //Verify all affected species are automatically checked
            CreateOutbreakPage.OutbreakInfo.enterOutbreakType("Human");
            CreateOutbreakPage.OutbreakInfo.randomSelectDisease();

            //Answer "No" to continue to questionnaire
            //Click Submit
            CreateOutbreakPage.OutbreakParameters.clickQuestionnaireNO();
            CreateOutbreakPage.clickSubmit();
            CreateOutbreakPage.OutbreakInfo.doesOutbreakStatusErrorMsgDisplay();
            Assert.AreEqual(SetMethods.errorString, CreateOutbreakPage.OutbreakInfo.outbreakStatMsg, "Error messages do not match.");

            //Log out of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            //test.Log(Status.Pass, "Test passes successfully.");
        }

        [Test]
        [Category("Regression")]
        [Description("Verify error message displays if Outbreak Disease is missing")]
        public void VerifyErrorMsgDisplayIfOutbreakDiseaseIsMissing()
        {
            //Start execution of //test for ExtentReport
            //test = extent.CreateTest("Verify error message displays if Outbreak Disease is missing");

            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS();

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Outbreaks.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management Page");

            //Click create Outbreak
            SearchOutbreakPage.clickCreateOutbreak();
            Assert.IsTrue(CreateOutbreakPage.OutbreakInfo.IsAt, "This is not the Outbreak Information section");

            //Enter Outbreak information for Zoonotic
            //Verify all affected species are automatically checked
            CreateOutbreakPage.OutbreakInfo.enterOutbreakType("Veterinary");
            CreateOutbreakPage.OutbreakInfo.enterOutbreakStatus("In Progress");

            //Answer "No" to continue to questionnaire
            //Click Submit
            CreateOutbreakPage.OutbreakParameters.clickQuestionnaireNO();
            CreateOutbreakPage.clickSubmit();
            CreateOutbreakPage.OutbreakInfo.doesDiseaseErrorMsgDisplay();
            Assert.AreEqual(SetMethods.errorString, CreateOutbreakPage.OutbreakInfo.outbreakDiseaseMsg, "Error messages do not match.");

            //Log out of EIDSS
            MainMenuNavigation.clickLogOut();

            //End the report and log the status
            //test.Log(Status.Pass, "Test passes successfully.");
        }


        [Test]
        public void VerifyUserCanDeleteAnOutbreak()
        {
            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS(); ;

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Create.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Search Outbreak page");
        }


        [Test]
        public void VerifyUserCanAssociateAnOubreakWithAPersonCase()
        {
            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS(); ;

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Create.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Search Outbreak page");
        }

        [Test]
        public void VerifyUserCanAssociateAnOubreakWithAVeterinaryCase()
        {
            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS(); ;

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Create.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Search Outbreak page");
        }

        [Test]
        public void VerifyUserCanAssociateAnOubreakWithAVectSurveillanceCase()
        {
            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS(); ;

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Create.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Search Outbreak page");
        }

        [Test]
        public void VerifyUserCanAdvanceSearchByOutbreakID()
        {
            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS(); ;

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Create.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List page");

            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.Search.IsAt, "This is not the Search section");

            //Search for an Outbreak session

        }

        [Test]
        public void VerifyUserCanAdvanceSearchByOutbreakType()
        {
            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS(); ;

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Create.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List page");

            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.Search.IsAt, "This is not the Search section");

            //Search for an Outbreak session

        }

        [Test]
        public void VerifyUserCanAdvanceSearchByDisease()
        {
            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS(); ;

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Create.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List page");

            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.Search.IsAt, "This is not the Search section");

            //Search for an Outbreak session

        }

        [Test]
        public void VerifyUserCanAdvanceSearchByStartDateFrom()
        {
            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS(); ;

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Create.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List page");

            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.Search.IsAt, "This is not the Search section");

            //Search for an Outbreak session

        }

        [Test]
        public void VerifyUserCanAdvanceSearchByStartDateFromAndTo()
        {
            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS(); ;

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Create.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List page");

            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.Search.IsAt, "This is not the Search section");

            //Search for an Outbreak session

        }

        [Test]
        public void VerifyUserCanAdvanceSearchByOutbreakStatus()
        {
            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS(); ;

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Create.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List page");

            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.Search.IsAt, "This is not the Search section");

            //Search for an Outbreak session

        }

        [Test]
        public void VerifyUserCanAdvanceSearchByRegion()
        {
            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS(); ;

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Create.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List page");

            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.Search.IsAt, "This is not the Search section");

            //Search for an Outbreak session

        }

        [Test]
        public void VerifyUserCanAdvanceSearchByRegionAndRayon()
        {
            //Log into EIDSS
            LoginPage.DEVLoginIntoEIDSS(); ;

            //Navigate to Search Outbreak page
            MainMenuNavigation.clickOutbreaks();
            MainMenuNavigation.Create.clickOutbreak();
            Assert.IsTrue(SearchOutbreakPage.IsAt, "This is not the Outbreak Management List page");

            SearchOutbreakPage.clickAdvancedSearch();
            Assert.IsTrue(SearchOutbreakPage.SearchOutbreak.Search.IsAt, "This is not the Search section");

            //Search for an Outbreak session

        }
    }
}
