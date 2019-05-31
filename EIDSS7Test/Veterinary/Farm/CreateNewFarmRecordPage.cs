using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Threading;

namespace EIDSS7Test.Veterinary.Farm
{
    public class CreateNewFarmRecordPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();
        public static string farmNM;
        public static string farmID;
        public static string street;

        private static By titleFormTitle = By.TagName("h2");
        private static By subtitleFormTitle = By.TagName("h3");
        private static By btnEditRecord = By.XPath("/html/body/form/div[3]/div/div[2]/div/div/div[1]/div/div[3]/div[1]/div/div[1]/section[1]/div[1]/div[1]/div/div[2]/a/span");
        private static By btnContinue = By.Id(CommonCtrls.GeneralContent + "btnNextSection");
        private static By btnCancel = By.XPath("/html/body/form/div[3]/div/div[2]/div/div[1]/div/div[2]/div/div[2]/div/button");
        private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmit");
        private static By linkReturnToDash = By.LinkText("Return to Dashboard");
        private static By linkReturnToFarmRecord = By.LinkText("Return to Farm Record");
        private static By linkFlocksHerdsSpecies = By.LinkText("Flocks/Herds and Species");
        private static By linkFarmReview = By.LinkText("Farm Review");

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
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Farm") &&
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

        public static void clickEditRecord()
        {
            SetMethods.clickObjectButtons(btnEditRecord);
        }

        public static void clickContinue()
        {
            selectElement(btnContinue);
        }

        public static void clickCancel()
        {
            selectElement(btnCancel);
        }

        public static void clickSubmit()
        {
            selectElement(btnSubmit);
        }

        public static void clickFarmReviewLink()
        {
            SetMethods.clickObjectButtons(linkFarmReview);
        }

        public static void clickFlocksHerdSpeciesLink()
        {
            selectElement(linkFlocksHerdsSpecies);
        }
        public static bool doesRecordAddedSuccessfulPopupDisplay()
        {
            try
            {
                string text = Driver.Instance.SwitchTo().Alert().Text;
                return true;
            }
            catch
            {
                return false;
            }
        }

        public static void clickReturnToDashboard()
        {
            selectElement(linkReturnToDash);
        }

        public static void clickReturnToFarmRecord()
        {
            selectElement(linkReturnToFarmRecord);
        }

        private static void selectElement(By el)
        {
            try
            {
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(el));
                element.Click();
                Driver.Wait(TimeSpan.FromMinutes(5));
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", el);
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(el));
                element.Click();
                Driver.Wait(TimeSpan.FromMinutes(5));
            }
        }

        private static void enterFarmObject(string objectName, By el)
        {
            try
            {
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(el));
                element.EnterText(objectName);
                Driver.Wait(TimeSpan.FromMinutes(5));
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
        }

        public class FarmInformation
        {
            private static By txtFarmID = By.Id(CommonCtrls.GeneralContent + "txtstrFarmCode");
            private static By txtFarmName = By.Id(CommonCtrls.GeneralContent + "txtstrInternationalName");
            private static By rdoAvianFarmType = By.Id(CommonCtrls.GeneralContent + "rdbFarmTypeAvian");
            private static By rdoLivestockFarmType = By.Id(CommonCtrls.GeneralContent + "rdbFarmTypeLivestock");
            private static By txtFarmOwnerID = By.Id(CommonCtrls.GeneralContent + "txtSearchidfHumanActualID");
            private static By ddlFarmOwnerName = By.Id(CommonCtrls.GeneralContent + "ddlidfHumanActual");
            private static IList<IWebElement> farmOwnerOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfHumanActual']/option")); } }
            private static By txtContactPhone = By.Id(CommonCtrls.GeneralContent + "txtstrContactPhone");
            private static By txtFax = By.Id(CommonCtrls.GeneralContent + "txtstrFax");
            private static By txtEmail = By.Id(CommonCtrls.GeneralContent + "txtstrEmail");

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
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Farm Information") &&
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

            private static void enterRandomPhone(By el)
            {
                string phone = SetMethods.GetRandomTelNo();
                SetMethods.enterObjectValue(el, phone);
            }

            public static void selectAvianFarmType()
            {
                selectElement(rdoAvianFarmType);
            }

            public static void selectLivestockFarmType()
            {
                selectElement(rdoLivestockFarmType);
            }

            public static void enterFarmName(string nm)
            {
                int rNum = rnd.Next(1000, 10000000);
                farmNM = nm + rNum;
                enterFarmObject(farmNM, txtFarmName);
            }

            public static void enterContactPhone()
            {
                enterRandomPhone(txtContactPhone);
            }

            public static void enterFaxNumber()
            {
                enterRandomPhone(txtFax);
            }

            public static void enterEmail()
            {
                var phoneTxt = wait.Until(ExpectedConditions.ElementToBeClickable(txtEmail));
                Driver.Wait(TimeSpan.FromMinutes(10));
                phoneTxt.EnterText(farmNM + "@gmail.com");
            }
        }

        public class FarmAddress
        {
            private static By ddlRegion = By.Id(CommonCtrls.FarmAddressContent + "ddlFarmAddressidfsRegion");
            private static IList<IWebElement> regionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.FarmAddressContent + "ddlFarmAddressidfsRegion']/option")); } }
            private static By ddlRayon = By.Id(CommonCtrls.FarmAddressContent + "ddlFarmAddressidfsRayon");
            private static IList<IWebElement> rayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.FarmAddressContent + "ddlFarmAddressidfsRayon']/option")); } }
            private static By ddlTownVillage = By.Id(CommonCtrls.FarmAddressContent + "ddlFarmAddressidfsSettlement");
            private static IList<IWebElement> townVillOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.FarmAddressContent + "ddlFarmAddressidfsSettlement']/option")); } }
            private static By txtBuilding = By.Id(CommonCtrls.FarmAddressContent + "txtFarmAddressstrBuilding");
            private static By txtStreet = By.Id(CommonCtrls.FarmAddressContent + "txtFarmAddressstrStreetName");
            private static By txtHouse = By.Id(CommonCtrls.FarmAddressContent + "txtFarmAddressstrHouse");
            private static By txtApartment = By.Id(CommonCtrls.FarmAddressContent + "txtFarmAddressstrApartment");
            private static By txtLatitude = By.Id(CommonCtrls.FarmAddressContent + "txtFarmAddressstrLatitude");
            private static By txtLongitude = By.Id(CommonCtrls.FarmAddressContent + "txtFarmAddressstrLongitude");
            private static By txtElevation = By.Id(CommonCtrls.FarmAddressContent + "txtFarmAddressstrElevation");
            private static By btnPersonSearch = By.Id(CommonCtrls.GeneralContent + "btnPersonSearch");

            public static bool IsAt
            {
                get
                {
                    //Scroll to the middle of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 250)", "");
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
                            Driver.Wait(TimeSpan.FromMinutes(15));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Farm Information") &&
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

            public static void randomSelectRegion()
            {
                SetMethods.randomSelectObjectElement(ddlRegion, regionOptions);
            }

            public static void randomSelectRayon()
            {
                SetMethods.randomSelectObjectElement(ddlRayon, rayonOptions);
            }

            public static void randomSelectTownOrVillage()
            {
                SetMethods.randomSelectObjectElement(ddlTownVillage, townVillOptions);
            }

            public static void randomEnterAddress(string addr)
            {
                int rNum = rnd.Next(10000, 99999);
                street = rNum + addr;
                SetMethods.enterObjectValue(txtStreet, street);
            }

            public static void enterHouseNumber()
            {
                SetMethods.enterObjectValue(txtHouse, street);
            }

            public static void enterBuildingNumber()
            {
                SetMethods.enterObjectValue(txtBuilding, street);
            }

            public static void enterAptNumber()
            {
                SetMethods.enterObjectValue(txtApartment, street);
            }

            public static void enterRandomLatitude()
            {
                try
                {
                    var lat = wait.Until(ExpectedConditions.ElementToBeClickable(txtLatitude));
                    lat.EnterDoubleAmount(Convert.ToDouble("-41." + SetMethods.RandomDoubleNum()));
                }
                catch
                {
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", txtLatitude);
                    var lat = wait.Until(ExpectedConditions.ElementToBeClickable(txtLatitude));
                    lat.EnterDoubleAmount(Convert.ToDouble("-41." + SetMethods.RandomDoubleNum()));
                }
            }

            public static void enterRandomLongitude()
            {
                try
                {
                    var lon = wait.Until(ExpectedConditions.ElementToBeClickable(txtLongitude));
                    lon.EnterDoubleAmount(Convert.ToDouble("35." + SetMethods.RandomDoubleNum()));
                }
                catch
                {
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", txtLongitude);
                    var lon = wait.Until(ExpectedConditions.ElementToBeClickable(txtLongitude));
                    lon.EnterDoubleAmount(Convert.ToDouble("-41." + SetMethods.RandomDoubleNum()));
                }
            }
        }


        public class VeterinaryDiseaseReports
        {
            //private static By btnNewLivestockDiseaseRpt = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lnbNewLivestockDiseaseReport']/span[2]");
            private static By btnNewLivestockDiseaseRpt = By.Id(CommonCtrls.AddUpdateFarmContent + "btnAddVeterinaryDiseaseReport");
            private static By btnNewAvianDiseaseRpt = By.Id(CommonCtrls.AddUpdateFarmContent + "btnAddVeterinaryDiseaseReport");
            private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.AddUpdateFarmContent + "divSelectablePreviewVeterinaryDiseaseReportList']/div[1]/div/div[1]/h3");
            //*[@id="EIDSSBodyCPH_ucAddUpdateFarm_divSelectablePreviewVeterinaryDiseaseReportList']/div[1]/div/div[1]/h3

            public static bool IsAt
            {
                get
                {
                    //Scroll to the middle of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 700)", "");
                    Driver.Instance.WaitForPageToLoad();
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
                            Driver.Wait(TimeSpan.FromMinutes(1000));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Disease Reports") &&
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

            public static void clickNewLivestockDiseaseReport()
            {
                //Scroll to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 700)", "");
                Driver.Wait(TimeSpan.FromMinutes(20));
                SetMethods.clickObjectButtons(btnNewLivestockDiseaseRpt);
                Thread.Sleep(1000);
            }

            public static void clickNewAvianDiseaseReport()
            {
                //Scroll to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 700)", "");
                Driver.Wait(TimeSpan.FromMinutes(20));
                SetMethods.clickObjectButtons(btnNewAvianDiseaseRpt);
                Thread.Sleep(1000);
            }

        }


        public class LaboratoryTestSamples
        {
            private static By btnNewLabTestSample = By.LinkText("New Laboratory Test Sample");
            private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.AddUpdateFarmContent + "divSelectablePreviewSampleTestResultList']/div[1]/div/div[1]/h3");
            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 700)", "");
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
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Laboratory Test Samples") &&
                                Driver.Instance.FindElement(subtitleFormTitle).Displayed)
                                return true;
                            else
                                Assert.Fail("This is not the correct title");
                            return false;
                        }
                    }
                    else
                    {
                        Assert.Fail("This is not the correct title");
                        return false;
                    }
                }
            }

            public static void clickNewLabTestSample()
            {
                SetMethods.clickObjectButtons(btnNewLabTestSample);
            }
        }

        public class FlocksHeardSpecies
        {
            private static By linkNewHerd = By.LinkText("New Herd");
            private static By farmHerdSpeciesSection = By.Id(CommonCtrls.AddUpdateFarmContent + "hdgFlocksHerdsSpecies");


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
                            if (Driver.Instance.FindElement(farmHerdSpeciesSection).Text.Contains("Flocks/Herds and Species") &&
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
    }
}