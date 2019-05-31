//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Net.Mail;
//using System.Text;
//using EIDSS7Test.Selenium;
//using OpenQA.Selenium.Support.UI;
//using OpenQA.Selenium;
//using OpenQA.Selenium.Support.PageObjects;
//using System.Threading;
//using NUnit.Framework;


//namespace EIDSS7Test.Laboratory
//{
//    public class LaboratorySection
//    {

//        //View Samples Section
//        private static IWebElement titleFormTitle { get { return Driver.Instance.FindElement(By.TagName("h1")); } }
//        private static IWebElement formHeader3 { get { return Driver.Instance.FindElement(By.TagName("h3")); } }
//        private static IWebElement formHeader4 { get { return Driver.Instance.FindElement(By.TagName("h4")); } }

//        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));
//        private static IWebElement lblSampleStatus { get { return Driver.Instance.FindElement(By.Name("Sample Status")); } }
//        private static IWebElement radAll { get { return Driver.Instance.FindElement(By.Id("rdoAll")); } }
//        private static IWebElement radUnaccessioned { get { return Driver.Instance.FindElement(By.Id("rdoUnaccessioned")); } }
//        private static IWebElement radAccessionIn { get { return Driver.Instance.FindElement(By.Id("rdoAccessionIn")); } }
//        private static IWebElement lblSampleType { get { return Driver.Instance.FindElement(By.Name("Sample Status")); } }
//        private static IWebElement ddlSampleType { get { return Driver.Instance.FindElement(By.Id("ddlSampleType")); } }
//        private static IWebElement listbxSampleType { get { return Driver.Instance.FindElement(By.Id("ddlSampleType_listbox")); } }
//        private static IWebElement lblCaseType { get { return Driver.Instance.FindElement(By.Name("Case Type")); } }
//        private static IWebElement lblHuman { get { return Driver.Instance.FindElement(By.Name("Human")); } }
//        private static IWebElement chkboxHuman { get { return Driver.Instance.FindElement(By.Id("cboHuman")); } }
//        private static IWebElement lblVetLivestock { get { return Driver.Instance.FindElement(By.Name("Vet - Livestock")); } }
//        private static IWebElement chkboxVetLivestock { get { return Driver.Instance.FindElement(By.Id("cboVetLivestock")); } }
//        private static IWebElement lblVetAvian{ get { return Driver.Instance.FindElement(By.Name("Vet - Avian")); } }
//        private static IWebElement chkboxVetAvian { get { return Driver.Instance.FindElement(By.Id("cboVetAvian")); } }
//        private static IWebElement lblVector { get { return Driver.Instance.FindElement(By.Name("Vector")); } }
//        private static IWebElement chkboxVector { get { return Driver.Instance.FindElement(By.Id("cboVector")); } }
//        private static IWebElement lblRegion { get { return Driver.Instance.FindElement(By.Name("Region")); } }
//        private static IWebElement ddlRegion { get { return Driver.Instance.FindElement(By.Id("ddlRegion")); } }
//        private static IWebElement listbxRegion { get { return Driver.Instance.FindElement(By.Id("ddlRegion_listbox")); } }
//        private static IWebElement lblRayon { get { return Driver.Instance.FindElement(By.Name("Rayon")); } }
//        private static IWebElement ddlRayon { get { return Driver.Instance.FindElement(By.Id("ddlRayon")); } }
//        private static IWebElement listbxRayon { get { return Driver.Instance.FindElement(By.Id("ddlRayon_listbox")); } }
//        private static IWebElement btnFilter { get { return Driver.Instance.FindElement(By.Id("btnFilter")); } }
//        private static IWebElement btnClear { get { return Driver.Instance.FindElement(By.Id("btnClear")); } }
//        private static IWebElement btnAccessionIn { get { return Driver.Instance.FindElement(By.Id("btnAccessionIn")); } }

//        //Sample Results section
//        private static IWebElement lblCaseSession { get { return Driver.Instance.FindElement(By.Name("Case/Session")); } }
//        private static IWebElement lblPatientFarm { get { return Driver.Instance.FindElement(By.Name("Patient/Farm")); } }
//        private static IWebElement lblLocalFieldSampleID { get { return Driver.Instance.FindElement(By.Name("Local/Field Sample ID")); } }
//        private static IWebElement lblSampleResultsType{ get { return Driver.Instance.FindElement(By.Name("Sample Type")); } }
//        private static IWebElement lblTestDiagnosis { get { return Driver.Instance.FindElement(By.Name("Test/Diagnosis")); } }
//        private static IWebElement lblRay { get { return Driver.Instance.FindElement(By.Name("Rayon")); } }
//        private static IWebElement checkboxSampleResults { get { return Driver.Instance.FindElement(By.Id("cboSampleResults")); } }


//        //Laboratory Task Section
//        private static IWebElement linkIntakeNewSample { get { return Driver.Instance.FindElement(By.LinkText("Intake a new sample")); } }
//        private static IWebElement linkTrackSample { get { return Driver.Instance.FindElement(By.LinkText("Track a sample")); } }
//        private static IWebElement linkEnterSampleTesting { get { return Driver.Instance.FindElement(By.LinkText("Enter sample testing results")); } }
//        private static IWebElement linkInterpretSampleTesting { get { return Driver.Instance.FindElement(By.LinkText("Interpret sample testing results")); } }
//        private static IWebElement linkDestroySample { get { return Driver.Instance.FindElement(By.LinkText("Destroy a sample")); } }
//        private static IWebElement linkTransferSample { get { return Driver.Instance.FindElement(By.LinkText("Transfer a sample")); } }
//        private static IWebElement linkSearchHumanCases { get { return Driver.Instance.FindElement(By.LinkText("Search Human Cases")); } }
//        private static IWebElement linkSearchVetCases { get { return Driver.Instance.FindElement(By.LinkText("Search Vet Cases")); } }



//        public static bool IsAt
//        {
//            get
//            {
//                Driver.TakeScreenShot(titleFormTitle, "LaboratorySectionPage");
//                if (titleFormTitle.Displayed)
//                {                    
//                    wait.Until(ExpectedConditions.ElementToBeClickable(titleFormTitle));
//                    Driver.Wait(TimeSpan.FromMinutes(5));
//                    return titleFormTitle.Text == "Laboratory Section";
//                }
//                else
//                {
//                    return false;
//                }
//            }
//        }

//        public static void selectAllSampleStatus()
//        {
//            Driver.Wait(TimeSpan.FromMinutes(5));
//            radAll.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }

//        public static void selectUnaccessSampleStatus()
//        {
//            Driver.Wait(TimeSpan.FromMinutes(5));
//            radUnaccessioned.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }

//        public static void selectAccessInSampleStatus()
//        {
//            Driver.Wait(TimeSpan.FromMinutes(5));
//            radAccessionIn.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }

//        public static void randomSelectSampleType()
//        {
//            var type = ddlSampleType;
//            wait.Until(ExpectedConditions.ElementToBeClickable(type));
//            Driver.Wait(TimeSpan.FromMinutes(10));
//            type.Click();
//            IList<IWebElement> lists = listbxSampleType.FindElements(By.TagName("li"));
//            SetMethods.SelectRandomOptionFromDropdown(lists);
//        }

//        public static void selectHumanCaseType()
//        {
//            Driver.Wait(TimeSpan.FromMinutes(5));
//            chkboxHuman.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }

//        public static void selectVetLivestockCaseType()
//        {
//            Driver.Wait(TimeSpan.FromMinutes(5));
//            chkboxVetLivestock.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }

//        public static void selectVetAvianCaseType()
//        {
//            Driver.Wait(TimeSpan.FromMinutes(5));
//            chkboxVetAvian.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }

//        public static void selectVectorCaseType()
//        {
//            Driver.Wait(TimeSpan.FromMinutes(5));
//            chkboxVector.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }

//        public static void randomSelectRegion()
//        {
//            var region = ddlRegion;
//            wait.Until(ExpectedConditions.ElementToBeClickable(region));
//            Driver.Wait(TimeSpan.FromMinutes(10));
//            region.Click();
//            IList<IWebElement> lists = listbxRegion.FindElements(By.TagName("li"));
//            SetMethods.SelectRandomOptionFromDropdown(lists);
//        }

//        public static void randomSelectRayon()
//        {
//            var rayon = ddlRayon;
//            wait.Until(ExpectedConditions.ElementToBeClickable(rayon));
//            Driver.Wait(TimeSpan.FromMinutes(10));
//            rayon.Click();
//            IList<IWebElement> lists = listbxRayon.FindElements(By.TagName("li"));
//            SetMethods.SelectRandomOptionFromDropdown(lists);
//        }

//        public static void clickFilterButton()
//        {
//            Driver.Wait(TimeSpan.FromMinutes(5));
//            btnFilter.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }

//        public static void clickClearButton()
//        {
//            Driver.Wait(TimeSpan.FromMinutes(5));
//            btnClear.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }

//        public static void clickIntakeNewSample()
//        {
//            Driver.Wait(TimeSpan.FromMinutes(5));
//            linkIntakeNewSample.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }

//        public static void clickTrackSample()
//        {
//            Driver.Wait(TimeSpan.FromMinutes(5));
//            linkTrackSample.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }

//        public static void enterSampleResults()
//        {
//            Driver.Wait(TimeSpan.FromMinutes(5));
//            linkEnterSampleTesting.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }

//        public static void interpretSampleResults()
//        {
//            Driver.Wait(TimeSpan.FromMinutes(5));
//            linkIntakeNewSample.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }

//        public static void destroySample()
//        {
//            Driver.Wait(TimeSpan.FromMinutes(5));
//            linkDestroySample.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }

//        public static void transferSample()
//        {
//            Driver.Wait(TimeSpan.FromMinutes(5));
//            linkTrackSample.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }

//        public static void searchHumanCases()
//        {
//            Driver.Wait(TimeSpan.FromMinutes(5));
//            linkSearchHumanCases.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }

//        public static void searchVetCases()
//        {
//            Driver.Wait(TimeSpan.FromMinutes(5));
//            linkSearchVetCases.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }



//        public class RegisterNewSample
//        {
//            private static IWebElement txtCalculatedCaseID { get { return Driver.Instance.FindElement(By.Id("txtCalculatedCaseID")); } }
//            private static IWebElement txtSampleTypeFiltered { get { return Driver.Instance.FindElement(By.Id("txtSampleTypeFiltered")); } }
//            private static IWebElement listbxSampleTypeFiltered { get { return Driver.Instance.FindElement(By.Id("txtSampleTypeFiltered_Listbox")); } }
//            private static IWebElement intNewSample { get { return Driver.Instance.FindElement(By.Id("intNewSample")); } }
//            private static IWebElement btnAdd{ get { return Driver.Instance.FindElement(By.Id("btnAdd")); } }
//            private static IWebElement btnClose { get { return Driver.Instance.FindElement(By.Id("btnClose")); } }


//            public static bool IsAt
//            {
//                get
//                {
//                    Driver.TakeScreenShot(titleFormTitle, "RegisterNewSamplePage");
//                    if (titleFormTitle.Displayed)
//                    {                        
//                        wait.Until(ExpectedConditions.ElementToBeClickable(titleFormTitle));
//                        Driver.Wait(TimeSpan.FromMinutes(5));
//                        return titleFormTitle.Text == "Register a new sample";
//                    }
//                    else
//                    {
//                        return false;
//                    }
//                }
//            }

//            public static void clickAdd()
//            {
//                wait.Until(ExpectedConditions.ElementToBeClickable(btnAdd));
//                btnAdd.Click();
//                Driver.Wait(TimeSpan.FromMinutes(5));
//            }

//            public static void clickClose()
//            {
//                wait.Until(ExpectedConditions.ElementToBeClickable(btnClose));
//                btnClose.Click();
//                Driver.Wait(TimeSpan.FromMinutes(5));
//            }





//        }
//    }
//}
