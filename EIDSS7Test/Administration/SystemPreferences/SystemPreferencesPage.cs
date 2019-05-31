using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;


namespace EIDSS7Test.Administration.SystemPreferences
{
    public class SystemPreferencesPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));

        private static By titleFormTitle = By.TagName("h2");
        private static By subtitleFormTitle = By.TagName("h3");
        private static By tblMain = By.Id("tblMain");
        private static By lblStartupLanguage = By.Name("Startup Language");
        private static By ddlStartupLanguage = By.Id("ddlStartupLanguage");
        private static By listbxSelectStartupLanguage = By.Id("StartupLanguage_Listbox");
        private static By lblCountry = By.Name("Country");
        private static By ddlCountry = By.Id("ddlCountry");
        private static By listbxSelectCountry = By.CssSelector("[id$=Country_listbox]");
        private static By lblBarcodePrinter = By.Name("Barcode Printer");
        private static By ddlBarcodePrinter = By.Id("ddlBarcodePrinter");
        private static IWebElement listbxSelectBarcodePrinter { get { return Driver.Instance.FindElement(By.CssSelector("[id$=BarcodePrinter_listbox]")); } }
        private static By lblDocumentPrinter = By.Name("Document Printer");
        private static By ddlDocumentPrinter = By.Id("ddlDocumentPrinter");
        private static By listbxSelectDocumentPrinter = By.CssSelector("[id$=DocumentPrinter_listbox]");
        private static By lblEPIInfoPath = By.Name("EPI Info Path");
        private static By fuEPIInfoPath = By.Id("fuEPIInfoPath");
        private static By lblDefaultMapProject = By.Name("Default Map Project");
        private static By ddlDefaultMapProject = By.Id("ddlDefaultMapProject");
        private static By listbxSelectDefaultMap = By.CssSelector("[id$=DefaultMapProject_listbox]");
        private static By lblAdditional = By.Name("Additional");
        private static By tblAdditional = By.Id("tblAdditional");
        private static By uccDefaultNumberofDaysDisplayed = By.Id("uccDefualtNumberofDaysDisplayed");
        private static IList<IWebElement> chkCheckBoxes { get { return Driver.Instance.FindElements(By.XPath("//input[@class='CheckBox']")); } }
        private static By lblShowTextInToolbar = By.Name("Show text in Toolbar");
        private static By lblShowWarning = By.Name("Show warning when big layout loading");
        private static By lblShowSaveDataPrompt = By.Name("Show save data prompt");
        private static By lblShowPrintVetrinaryMap = By.Name("Show navigator in H02 form");
        private static By lblShowStarForBlank = By.Name("Show * for blank values in AVR");
        private static By lblLabModuleSimplifiedMode = By.Name("Lab module simplified mode");
        private static By lblFilterSamplesByDiag = By.Name("Filter samples by diagnosis");
        private static By lblDefaultRegionInSearchPanel = By.Name("Default region in search panels");
        private static By lblShowWarningForFinalCase = By.Name("Show warning for final case classification");
        private static By lblDefaultNumberofDaysDisplayed = By.Name("Number of days for which data is displayed by default");
        private static By btnSave = By.Id("btnSave");
        private static By btnOK = By.Id("btnOK");
        private static By btnCancel = By.Id("btnCancel");
        private static By allLists = By.TagName("li");

        public static bool isAt
        {
            get
            {
                if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                {
                    if (Driver.Instance.FindElement(subtitleFormTitle).Displayed)
                        return true;
                    else
                        return false;
                }
                else
                {
                    return false;
                }
            }
            //get
            //{
            //    var title = wait.Until(ExpectedConditions.ElementIsVisible(titleFormTitle));
            //    if (title.Displayed)
            //    {
            //        Driver.TakeScreenShot(title, "SystemPeferencesPage");
            //        Driver.Wait(TimeSpan.FromMinutes(5));
            //        return title.Text == "System Preferences";
            //    }
            //    else
            //    {
            //        return false;
            //    }
            //}
        }

        public static void selectRandomBarcodePrinter()
        {
            var barcode = wait.Until(ExpectedConditions.ElementIsVisible(ddlBarcodePrinter));
            Driver.Wait(TimeSpan.FromMinutes(10));
            barcode.Click();
            IList<IWebElement> lists = listbxSelectBarcodePrinter.FindElements(By.TagName("li"));
            SetMethods.SelectRandomOptionFromDropdown(lists);
        }

        public static void selectRandomDocumentPrinter()
        {
            var document = wait.Until(ExpectedConditions.ElementIsVisible(ddlDocumentPrinter));
            Driver.Wait(TimeSpan.FromMinutes(10));
            document.Click();
            IList<IWebElement> lists = listbxSelectBarcodePrinter.FindElements(By.TagName("li"));
            SetMethods.SelectRandomOptionFromDropdown(lists);
        }

        public static void selectRandomDefaultMapProject()
        {
            var map = wait.Until(ExpectedConditions.ElementIsVisible(ddlDefaultMapProject));
            Driver.Wait(TimeSpan.FromMinutes(10));
            map.Click();
            IList<IWebElement> lists = listbxSelectBarcodePrinter.FindElements(By.TagName("li"));
            SetMethods.SelectRandomOptionFromDropdown(lists);
        }

        public static void clickMultipleCheckBoxes()
        {
            Random rnd = new Random();
            IList<IWebElement> getAllCheckboxes = chkCheckBoxes;
            IList<IWebElement> checkBoxes = new List<IWebElement>();
            foreach (IWebElement chkBoxes in getAllCheckboxes)
            {
                if (chkBoxes.Displayed)
                {
                    checkBoxes.Add(chkBoxes);
                }
            }

            int randomValue = rnd.Next(checkBoxes.Count);
            IWebElement value = checkBoxes[randomValue];
            value.Click();
        }

        public static void clickSave()
        {
            var element = wait.Until(ExpectedConditions.ElementIsVisible(btnSave));
            element.Click();
            Driver.Wait(TimeSpan.FromMinutes(5));
        }

        public static void clickOK()
        {
            var element = wait.Until(ExpectedConditions.ElementIsVisible(btnOK));
            element.Click();
            Driver.Wait(TimeSpan.FromMinutes(5));
        }

        public static void clickCancel()
        {
            var element = wait.Until(ExpectedConditions.ElementIsVisible(btnCancel));
            element.Click();
            Driver.Wait(TimeSpan.FromMinutes(5));
        }



    }
}
