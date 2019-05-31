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
//    public class AccessionInSample
//    {
//        private static IWebElement titleFormTitle { get { return Driver.Instance.FindElement(By.TagName("h1")); } }
//        private static IWebElement formHeader3 { get { return Driver.Instance.FindElement(By.TagName("h3")); } }
//        private static IWebElement formHeader4 { get { return Driver.Instance.FindElement(By.TagName("h4")); } }
//        private static IWebElement linkTestingDetails { get { return Driver.Instance.FindElement(By.LinkText("Testing Details")); } }
//        private static IWebElement linkLabTests { get { return Driver.Instance.FindElement(By.LinkText("Lab Tests")); } }
//        private static IWebElement linkAmendHistory { get { return Driver.Instance.FindElement(By.LinkText("Testing Details")); } }
//        private static IWebElement linkReviewResults { get { return Driver.Instance.FindElement(By.LinkText("Testing Details")); } }
//        private static IWebElement lblLabSampleID { get { return Driver.Instance.FindElement(By.Name("Lab Sample ID")); } }
//        private static IWebElement readOnlyLabSampleID { get { return Driver.Instance.FindElement(By.Id("txtLabSampleID")); } }
//        private static IWebElement lblSampleCollection { get { return Driver.Instance.FindElement(By.Name("Sample Condition")); } }
//        private static IWebElement ddlSampleCondition{ get { return Driver.Instance.FindElement(By.Id("ddlSampleCondition")); } }
//        private static IWebElement listbxSampleCondition { get { return Driver.Instance.FindElement(By.Id("ddlSampleCondition_listbox")); } }
//        private static IWebElement datDateAccessionIn { get { return Driver.Instance.FindElement(By.Id("txtDateAccessionIn")); } }
//        private static IWebElement lblComments { get { return Driver.Instance.FindElement(By.Name("Comments")); } }
//        private static IWebElement txtComments { get { return Driver.Instance.FindElement(By.Id("txtComments")); } }




//        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));



//        public static bool IsAt
//        {
//            get
//            {
//                Driver.TakeScreenShot(titleFormTitle,"AccessionInSamplePage");
//                if (titleFormTitle.Displayed)
//                {                    
//                    wait.Until(ExpectedConditions.ElementToBeClickable(titleFormTitle));
//                    Driver.Wait(TimeSpan.FromMinutes(5));
//                    return titleFormTitle.Text == "Accession In Sample";
//                }
//                else
//                {
//                    return false;
//                }
//            }
//        }


//        public static void clickLabTestsLink()
//        {
//            wait.Until(ExpectedConditions.ElementToBeClickable(linkLabTests));
//            linkLabTests.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }
//        public static void clickTestingDetailsLink()
//        {
//            wait.Until(ExpectedConditions.ElementToBeClickable(linkTestingDetails));
//            linkTestingDetails.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }
//        public static void clickAmendHistoryLink()
//        {
//            wait.Until(ExpectedConditions.ElementToBeClickable(linkAmendHistory));
//            linkAmendHistory.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }
//        public static void clickReviewResultsLink()
//        {
//            wait.Until(ExpectedConditions.ElementToBeClickable(linkReviewResults));
//            linkReviewResults.Click();
//            Driver.Wait(TimeSpan.FromMinutes(5));
//        }


//    }
//}
