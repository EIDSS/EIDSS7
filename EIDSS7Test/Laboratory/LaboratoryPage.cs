using EIDSS7Test.Selenium;
using EIDSS7Test.Common;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using System;
using System.Collections.Generic;
using System.Threading;
using NUnit.Framework;
using System.Linq;

namespace EIDSS7Test.Laboratory
{
    public class LaboratoryPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(320));
        private static Random rnd = new Random();
        private static By titleFormTitle = By.TagName("h2");
        private static By HeaderFormTitle = By.TagName("h1");
        private static IWebElement tabSamplesActive = Driver.Instance.FindElement(By.XPath("//*[@id='liSamples']"));
        private static IWebElement tabTestingActive = Driver.Instance.FindElement(By.XPath("//*[@id='liTesting']"));
        private static IWebElement tabFavoritesActive = Driver.Instance.FindElement(By.XPath("//*[@id='liMyFavorites']"));
        private static IWebElement tabBatchesActive = Driver.Instance.FindElement(By.XPath("//*[@id='liBatches']"));
        private static IWebElement tabApprovalsActive = Driver.Instance.FindElement(By.XPath("//*[@id='liApprovals']"));
        private static IWebElement tabTransferredActive = Driver.Instance.FindElement(By.XPath("//*[@id='liTransferred']"));
        private static By linkSamplesTab = By.Id(CommonCtrls.GeneralContent + "lblSamples");
        private static By linkTestingTab = By.Id(CommonCtrls.GeneralContent + "lblTesting");
        private static By linkTransferredTab = By.Id(CommonCtrls.GeneralContent + "lblTransferred");
        private static By linkMyFavoritesTab = By.Id(CommonCtrls.GeneralContent + "lblMyFavorites");
        private static By linkBatchesTab = By.Id(CommonCtrls.GeneralContent + "lblBatches");
        private static By linkApprovalsTab = By.Id(CommonCtrls.GeneralContent + "lblApprovals");
        private static By linkAdvancedSearch = By.LinkText("Advanced Search");


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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Laboratory") &&
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

        public static bool isAttributePresent(IWebElement element, string attribute)
        {
            //Boolean result = false;

            Thread.Sleep(1000);
            if (element.GetAttribute(attribute) != null)
            {
                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail("The wrong tab is active.");
                return false;
            }
            else
            {
                return true;
            }
        }

        public static void clickSamplesTab()
        {
            SetMethods.clickObjectButtons(linkSamplesTab);
        }

        public static void clickTestingTab()
        {
            SetMethods.clickObjectButtons(linkTestingTab);
        }

        public static void clickTransferredTab()
        {
            SetMethods.clickObjectButtons(linkTransferredTab);
        }

        public static void clickMyFavoritesTab()
        {
            SetMethods.clickObjectButtons(linkMyFavoritesTab);
        }

        public static void clickBatchesTab()
        {
            SetMethods.clickObjectButtons(linkBatchesTab);
        }

        public static void clickApprovalsTab()
        {
            SetMethods.clickObjectButtons(linkApprovalsTab);
        }

        public static void clickAdvancedSearchLink()
        {
            SetMethods.clickObjectButtons(linkAdvancedSearch);
        }

        public class AdvancedSearch
        {
            private static By titleFormTitle = By.Id("hdgAdvancedSearch");
            private static By txtLabSampleID = By.Id(CommonCtrls.LabSrchSampleContent + "txtEIDSSLaboratorySampleID");
            private static By txtLocalFieldID = By.Id(CommonCtrls.LabSrchSampleContent + "txtEIDSSLocalFieldID");
            private static By ddlSampleType = By.Id(CommonCtrls.LabSrchSampleContent + "ddlSampleTypeID");
            private static IList<IWebElement> listOfSampleTypes { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[3]/div[20]/div[1]/div[2]/div[1]/div[1]/div[5]/div[2]/div[1]/select[1]/option")); } }
            private static By lstBoxSampleStatus = By.Id(CommonCtrls.LabSrchSampleContent + "lbxSampleStatusTypeID");
            private static IList<IWebElement> listOfSampleStats { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[3]/div[20]/div[1]/div[2]/div[1]/div[1]/div[7]/div[2]/select[1]/option")); } }
            private static By datAccessDateFrom = By.Id(CommonCtrls.LabSrchSampleContent + "txtAccessionDateFrom");
            private static By datAccessDateTo = By.Id(CommonCtrls.LabSrchSampleContent + "txtAccessionDateTo");
            private static By ddlRptSessionType = By.Id(CommonCtrls.LabSrchSampleContent + "ddlReportSessionType");
            private static IList<IWebElement> listOfRptSessTypes { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[3]/div[20]/div[1]/div[2]/div[1]/div[1]/div[9]/div[2]/div[1]/select[1]/optionn")); } }
            private static By ddlSurveillType = By.Id(CommonCtrls.LabSrchSampleContent + "ddlSurveillanceTypeID");
            private static IList<IWebElement> listOfSurvTypes { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[3]/div[20]/div[1]/div[2]/div[1]/div[1]/div[11]/div[2]/div[1]/select[1]/option")); } }

            private static By txtRptCampSessID = By.Id(CommonCtrls.LabSrchSampleContent + "txtEIDSSReportCampaignSessionID");
            private static By ddlDisease = By.Id(CommonCtrls.LabSrchSampleContent + "ddlDiseaseID");
            private static IList<IWebElement> listOfDiseases { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[3]/div[20]/div[1]/div[2]/div[1]/div[1]/div[15]/div[2]/select[1]/option")); } }
            private static By txtPerson = By.Id(CommonCtrls.LabSrchSampleContent + "txtPatientName");
            private static By txtFarmOwner = By.Id(CommonCtrls.LabSrchSampleContent + "txtFarmOwnerName");
            private static By ddlSpecies = By.Id(CommonCtrls.LabSrchSampleContent + "ddlSpeciesTypeID");
            private static IList<IWebElement> listOfSpecies { get { return Driver.Instance.FindElements(By.XPath("	/html[1]/body[1]/form[1]/div[3]/div[3]/div[20]/div[1]/div[2]/div[1]/div[1]/div[21]/div[2]/div[1]/select[1]/option")); } }
            private static By ddlOrgSentTo = By.Id(CommonCtrls.LabSrchSampleContent + "ddlOrganizationSentToID");
            private static IList<IWebElement> listOfOrgsSentTo { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[3]/div[20]/div[1]/div[2]/div[1]/div[1]/div[23]/div[2]/div[1]/select[1]/option")); } }
            private static By ddlOrgTransfTo = By.Id(CommonCtrls.LabSrchSampleContent + "ddlOrganizationTransferredToID");
            private static IList<IWebElement> listOTransOrgsTo { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[3]/div[20]/div[1]/div[2]/div[1]/div[1]/div[25]/div[2]/div[1]/select[1]/option")); } }
            private static By txtTransferID = By.Id(CommonCtrls.LabSrchSampleContent + "txtEIDSSTransferID");
            private static By ddlResultsRcvdFrom = By.Id(CommonCtrls.LabSrchSampleContent + "ddlResultsReceivedFromID");
            private static IList<IWebElement> listOfResultsRcvd { get { return Driver.Instance.FindElements(By.XPath(" /html[1]/body[1]/form[1]/div[3]/div[3]/div[20]/div[1]/div[2]/div[1]/div[1]/div[29]/div[2]/div[1]/select[1]/option")); } }
            private static By ddlTestName = By.Id(CommonCtrls.LabSrchSampleContent + "ddlTestNameTypeID");
            private static IList<IWebElement> listOfTestNames { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[3]/div[20]/div[1]/div[2]/div[1]/div[1]/div[31]/div[2]/div[1]/select[1]/option")); } }
            private static By ddlTestStatus = By.Id(CommonCtrls.LabSrchSampleContent + "ddlTestStatusTypeID");
            private static IList<IWebElement> listOfTestStats { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[3]/div[20]/div[1]/div[2]/div[1]/div[1]/div[33]/div[2]/div[1]/select[1]/option")); } }
            private static By ddlTestResults = By.Id(CommonCtrls.LabSrchSampleContent + "ddlTestResultTypeID");
            private static IList<IWebElement> listOfTestResults { get { return Driver.Instance.FindElements(By.XPath("/html[1]/body[1]/form[1]/div[3]/div[3]/div[20]/div[1]/div[2]/div[1]/div[1]/div[35]/div[2]/div[1]/select[1]/option")); } }
            private static By datTestResultsDateFrom = By.Id(CommonCtrls.LabSrchSampleContent + "txtTestResultDateFrom");
            private static By datTestResultsDateTo = By.Id(CommonCtrls.LabSrchSampleContent + "txtTestResultDateTo");
            private static By btnCancel = By.Id("btnCancel");
            private static By btnSearch = By.Id(CommonCtrls.LabSrchSampleContent + "btnSearch");
            private static By btnClear = By.Id(CommonCtrls.LabSrchSampleContent + "btnClear");
            private static By btnQuickClose = By.XPath("//*[@id='divSearchSampleModal']/div/div[1]/button");

            public static bool IsAt
            {
                get
                {
                    try
                    {
                        //Switch to new window
                        string newWindowHandle = Driver.Instance.WindowHandles.Last();
                        var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);

                        Driver.Instance.WaitForPageToLoad();
                        Thread.Sleep(2000);
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
                                if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Advanced Search") &&
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

            public static void clickCancel()
            {
                SetMethods.clickObjectButtons(btnCancel);
            }

            public static void clickClear()
            {
                SetMethods.clickObjectButtons(btnClear);
            }

            public static void clickSearch()
            {
                SetMethods.clickObjectButtons(btnSearch);
            }

            public static void clickQuickClose()
            {
                SetMethods.clickObjectButtons(btnQuickClose);
            }

        }


        public class Samples
        {
            private static By titleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lblSamples']");

            public static bool IsAt
            {
                get
                {
                    try
                    {
                        Driver.Instance.WaitForPageToLoad();
                        Thread.Sleep(2000);
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
                                if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("SAMPLES") &&
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

            public static void isSampleTabActive()
            {
                isAttributePresent(tabSamplesActive, "active");
            }
        }

        public class Testing
        {
            private static By titleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lblTesting']");

            public static bool IsAt
            {
                get
                {
                    try
                    {
                        Driver.Instance.WaitForPageToLoad();
                        Thread.Sleep(2000);
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
                                if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("TESTING") &&
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

            public static void isTestingTabActive()
            {
                isAttributePresent(tabTestingActive, "active");
            }

        }

        public class Transferred
        {
            private static By titleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lblTransferred']");

            public static bool IsAt
            {
                get
                {
                    try
                    {
                        Driver.Instance.WaitForPageToLoad();
                        Thread.Sleep(2000);
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
                                if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("TRANSFERRED") &&
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

            public static void isTransferredTabActive()
            {
                isAttributePresent(tabTransferredActive, "active");
            }
        }

        public class Favorites
        {
            private static By titleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lblMyFavorites']");

            public static bool IsAt
            {
                get
                {
                    try
                    {
                        Driver.Instance.WaitForPageToLoad();
                        Thread.Sleep(2000);
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
                                if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("MY FAVORITES") &&
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

            public static void isMyFavoritesTabActive()
            {
                isAttributePresent(tabFavoritesActive, "active");
            }
        }

        public class Batches
        {
            private static By titleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lblBatches']");

            public static bool IsAt
            {
                get
                {
                    try
                    {
                        Driver.Instance.WaitForPageToLoad();
                        Thread.Sleep(2000);
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
                                if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("BATCHES") &&
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

            public static void isBatchesTabActive()
            {
                isAttributePresent(tabBatchesActive, "active");
            }
        }

        public class Approvals
        {
            private static By titleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lblApprovals']");

            public static bool IsAt
            {
                get
                {
                    try
                    {
                        Driver.Instance.WaitForPageToLoad();
                        Thread.Sleep(2000);
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
                                if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("APPROVALS") &&
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
        }

        public static void isApprovalsTabActive()
        {
            isAttributePresent(tabApprovalsActive, "active");
        }
    }
}