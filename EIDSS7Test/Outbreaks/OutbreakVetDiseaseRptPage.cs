using EIDSS7Test.Common;
using EIDSS7Test.Selenium;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using System;
using System.Collections.Generic;
using System.Threading;

namespace EIDSS7Test.Outbreaks
{
    public class OutbreakVetDiseaseRptPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(320));
        private static Random rnd = new Random();
        private static string[] manufacturers = new string[] { "Gerber", "State Farm", "Geico", "Progressive", "The General", "High As H%$%^ Medical", "2500% Increase Medical", "You can't afford these meds Medical", "Dr. Death Medical" };
        public static String longCommentString = "jljjououaofuoufouaoufoiaofjnlznkznknfnnfanfaf08097975927491710810890418jfajflaflanflaknf,anf,mjflkjaljfj0808080&$^#@%#$$%&^*&(ljljljfljlsjfljowuoqu7r97(^%%$&lnlnalfnlanflalkfkjalfjlahlaljflajfljfjolau&(&(&9796827972959775972597275927927597927592597797579";
        public static String ExtLongString = "jljjououaofuoufouaoufoiaofjnlznkznknfnnfanfaf08097975927491710810890418jfajflaflanflaknf,anf,mjflkjaljfj0808080&$^#@%#$$%&^*&(ljljljfljlsjfljowuoqu7r97(^%%$&lnlnalfnlanflalkfkjalfjlahlaljflajfljfjolau&(&(&9796827972959775972597275927927597927592597797579" +
            "jljjououaofuoufouaoufoiaofjnlznkznknfnnfanfaf08097975927491710810890418jfajflaflanflaknf,anf,mjflkjaljfj0808080&$^#@%#$$%&^*&(ljljljfljlsjfljowuoqu7r97(^%%$&lnlnalfnlanflalkfkjalfjlahlaljflajfljfjolau&(&(&9796827972959775972597275927927597927592597797579" +
            "jljjououaofuoufouaoufoiaofjnlznkznknfnnfanfaf08097975927491710810890418jfajflaflanflaknf,anf,mjflkjaljfj0808080&$^#@%#$$%&^*&(ljljljfljlsjfljowuoqu7r97(^%%$&lnlnalfnlanflalkfkjalfjlahlaljflajfljfjolau&(&(&9796827972959775972597275927927597927592597797579" +
            "jljjououaofuoufouaoufoiaofjnlznkznknfnnfanfaf08097975927491710810890418jfajflaflanflaknf,anf,mjflkjaljfj0808080&$^#@%#$$%&^*&(ljljljfljlsjfljowuoqu7r97(^%%$&lnlnalfnlanflalkfkjalfjlahlaljflajfljfjolau&(&(&9796827972959775972597275927927597927592597797579";
        public static string street;
        public static string outBreakID;
        private static By HeaderFormTitle = By.TagName("h2");
        private static By titleFormTitle = By.Id(CommonCtrls.GeneralContent + "h2");
        private static By linkNotification = By.LinkText("Notification");
        private static By linkLocation = By.LinkText("Location");
        private static By linkHerdFlockSpeciesInfo = By.LinkText("Herd/Flock/Species Info");
        private static By linkClinicalInfo = By.LinkText("Clinical Information");
        private static By linkVaccineInfo = By.LinkText("Vaccination Information");
        private static By linkOutbreakInvest = By.LinkText("Outbreak Investigation");
        private static By linkCaseMonitor = By.LinkText("Case Monitoring");
        private static By linkContacts = By.LinkText("Contacts");
        private static By linkSamples = By.LinkText("Samples");
        private static By linkPensideTests = By.LinkText("Penside Tests");
        private static By linkLabTestInterp = By.LinkText("Lab Test/Interpretation");
        private static By linkReview = By.LinkText("Review/Submit");
        private static By btnPrevious = By.Id(CommonCtrls.GeneralContent + "btnVetPreviousCaseEntry");
        private static By btnSubmit = By.Id("bSubmit");
        private static By btnNext = By.Id(CommonCtrls.GeneralContent + "btnVetNextCaseEntry");
        private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnVetCancelCaseEntry");
        public static string getElementValue;
        private static int rNum = rnd.Next(1, 365);
        private static int numValue = rnd.Next(1, 99999);
        public static string notifySFacility = null;
        public static string notifySName = null;
        public static string notifyRFacility = null;
        public static string notifyRName = null;

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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Outreak Case Summary") &&
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

        public static void clickSubmit()
        {
            //Scroll to the bottom of the page
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
            SetMethods.clickObjectButtons(btnSubmit);
        }

        public static void clickCancel()
        {
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clickNext()
        {
            SetMethods.clickObjectButtons(btnNext);
        }

        public static void clickPrevious()
        {
            SetMethods.clickObjectButtons(btnPrevious);
        }

        public static void clickNotificationLink()
        {
            SetMethods.clickObjectButtons(linkNotification);
        }

        public static void clickLocationLink()
        {
            SetMethods.clickObjectButtons(linkLocation);
        }

        public static void clickHerdFlockSpeciesLink()
        {
            SetMethods.clickObjectButtons(linkHerdFlockSpeciesInfo);
        }

        public static void clickClinicalInfoLink()
        {
            SetMethods.clickObjectButtons(linkClinicalInfo);
        }

        public static void clickVaccineInfoLink()
        {
            SetMethods.clickObjectButtons(linkVaccineInfo);
        }

        public static void clickOutbreakInvestLink()
        {
            SetMethods.clickObjectButtons(linkOutbreakInvest);
        }

        public static void clickCaseMonitoringLink()
        {
            SetMethods.clickObjectButtons(linkCaseMonitor);
        }

        public static void clickContactsLink()
        {
            SetMethods.clickObjectButtons(linkContacts);
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

        public class Notification
        {
            private static By subTitleFormTitle = By.Id(CommonCtrls.GeneralContent + "H14");
            private static By datDateOfNotify = By.Id("cidatVetNotificationDate");
            private static By txtNotifySentByFacility = By.Id("txtVetNotificationSentByFacilty");
            private static By txtNotifySentByName = By.Id("txtVetNotificationSentByName");
            private static By txtNotifyRecvdByFacility = By.Id("txtVetNotificationReceivedByFacilty");
            private static By txtNotifyRecvdByName = By.Id("txtVetNotificationReceivedByName");
            public static string notifySFacility = null;
            public static string notifySName = null;
            public static string notifyRFacility = null;
            public static string notifyRName = null;

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
                    else if (Driver.Instance.FindElements(subTitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subTitleFormTitle).Text.Contains("Notification") &&
                                Driver.Instance.FindElement(subTitleFormTitle).Displayed)
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

            public static void enterDateOfNotification()
            {
                SetMethods.enterCurrentDate(datDateOfNotify);
            }

            public static void enterNotifiySentByFacility(String value)
            {
                SetMethods.enterObjectValue(txtNotifySentByFacility, value);
                notifySFacility = value;
            }

            public static void enterNotifiySentByName(String value)
            {
                SetMethods.enterObjectValue(txtNotifySentByName, value);
            }

            public static void enterNotifiyRecvdByFacility(String value)
            {
                SetMethods.enterObjectValue(txtNotifyRecvdByFacility, value);
                notifyRFacility = value;
            }

            public static void enterNotifiyRecvdByName(String value)
            {
                SetMethods.enterObjectValue(txtNotifyRecvdByName, value);
            }
        }

        public class Location
        {
            private static By subTitleFormTitle = By.Id(CommonCtrls.GeneralContent + "H15");
            private static By ddlRegion = By.Id(CommonCtrls.OutbrVetCaseLocContent + "ddlidfsRegion");
            private static IList<IWebElement> regionOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.OutbrVetCaseLocContent + "ddlidfsRegion']/option")); } }

            private static By ddlRayon = By.Id(CommonCtrls.OutbrVetCaseLocContent + "ddlidfsRayon");
            private static IList<IWebElement> rayonOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.OutbrVetCaseLocContent + "ddlidfsRayon']/option")); } }
            private static By ddlSettleType = By.Id(CommonCtrls.OutbrVetCaseLocContent + "ddlSettlementType");
            private static IList<IWebElement> settleTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.OutbrVetCaseLocContent + "ddlSettlementType']/option")); } }
            private static By ddlSettlement = By.Id(CommonCtrls.OutbrVetCaseLocContent + "ddlidfsSettlement");
            private static IList<IWebElement> settleOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.OutbrVetCaseLocContent + "ddlidfsSettlement']/option")); } }
            private static By txtStreet = By.Id(CommonCtrls.OutbrVetCaseLocContent + "txtstrStreetName");
            private static By txtBuilding = By.Id(CommonCtrls.OutbrVetCaseLocContent + "txtstrBuilding");
            private static By txtHouse = By.Id(CommonCtrls.OutbrVetCaseLocContent + "txtstrHouse");
            private static By txtApt = By.Id(CommonCtrls.OutbrVetCaseLocContent + "txtstrApartment");
            private static By ddlPostalCode = By.Id(CommonCtrls.OutbrVetCaseLocContent + "ddlidfsPostalCode");
            private static By txtLatitude = By.Id(CommonCtrls.OutbrVetCaseLocContent + "txtstrLatitude");
            private static By txtLongitude = By.Id(CommonCtrls.OutbrVetCaseLocContent + "txtstrLongitude");

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
                    else if (Driver.Instance.FindElements(subTitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subTitleFormTitle).Text.Contains("Location") &&
                                Driver.Instance.FindElement(subTitleFormTitle).Displayed)
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
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlRegion, regionOpts);
                Thread.Sleep(1000);
            }

            public static void enterRegion(string value)
            {
                SetMethods.enterObjectValue(ddlRegion, value);
            }

            public static void randomSelectRayon()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlRayon, rayonOpts);
                Thread.Sleep(1000);
            }

            public static void enterRayon(string value)
            {
                SetMethods.enterObjectValue(ddlRayon, value);
            }

            public static void randomSelectSettlementType()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlSettleType, settleTypeOpts);
                Thread.Sleep(1000);
            }

            public static void enterSettlementType(String value)
            {
                SetMethods.enterObjectValue(ddlSettleType, value);
                Thread.Sleep(1000);
            }
            public static void randomSelectSettlement()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlSettlement, settleOpts);
                Thread.Sleep(1000);
            }

            public static void enterSettlement(String value)
            {
                SetMethods.enterObjectValue(ddlSettlement, value);
            }


            public static String enterStreet(string addr)
            {
                street = rNum + "-" + addr;
                SetMethods.enterObjectValue(txtStreet, street);
                return street;
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
                SetMethods.enterObjectValue(txtApt, street);
            }

            public static void enterPostalCode()
            {
                SetMethods.enterIntObjectValue(ddlPostalCode, rNum);
            }

            public static void enterLongitude()
            {
                SetMethods.enterRandomMinLongitude(txtLongitude);
            }

            public static void enterLatitude()
            {
                SetMethods.enterRandomMinLatitude(txtLatitude);
            }



        }

        public class HerdFlockSpeciesInfo
        {
            private static By subTitleFormTitle = By.Id(CommonCtrls.GeneralContent + "H26");
            private static By rdoLivestock = By.Id(CommonCtrls.GeneralContent + "rblTypeOfCase2_0");
            private static By rdoAvian = By.Id(CommonCtrls.GeneralContent + "rblTypeOfCase2_1");
            private static By btnAdd = By.Id(CommonCtrls.GeneralContent + "btnVetAddHerd");
            private static By btnUpdateSpecies = By.Id(CommonCtrls.GeneralContent + "btnVetUpdateSpecies");
            private static By btnAddSpecies = By.Id("lbAddSpecies");
            private static By lblHerdCode = By.Id("txtstrHerdCode");
            private static By ddlSpecies = By.Id("ddlVetSpeciesType");
            private static IList<IWebElement> speciesOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='ddlVetSpeciesType']/option")); } }
            private static By txtIntTotal = By.Id("intTotalAnimalQty");
            private static By txtIntDead = By.Id("intDeadAnimalQty");
            private static By txtIntSick = By.Id("intSickAnimalQty");
            private static By datStartOfSigns = By.Id("datStartOfSignsDate");
            private static By txtNote = By.Id("strNote");

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
                    else if (Driver.Instance.FindElements(subTitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subTitleFormTitle).Text.Contains("Species Information") &&
                                Driver.Instance.FindElement(subTitleFormTitle).Displayed)
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

            public static void getHerdCodeFromGrid()
            {
                SetMethods.GetNewvalue(lblHerdCode);
            }

            public static void getCurrentSpeciesFromGrid()
            {
                SetMethods.GetNewvalue4(ddlSpecies);
            }

            public static void getCurTotalNumberOfSpecies()
            {
                SetMethods.GetCurrentValue2(txtIntTotal);
            }

            public static void clickLivestockTypeOfCase()
            {
                SetMethods.clickObjectButtons(rdoLivestock);
            }

            public static void clickAddRecord()
            {
                SetMethods.clickObjectButtons(btnAdd);
            }

            public static void clickAddSpecies()
            {
                SetMethods.clickObjectButtons(btnAddSpecies);
            }

            public static void clickUpdateRecord()
            {
                SetMethods.clickObjectButtons(btnUpdateSpecies);
            }

            public static void randomSelectSpecies()
            {
                SetMethods.randomSelectObjectElement(ddlSpecies, speciesOpts);
            }

            public static void enterSpecies(string value)
            {
                SetMethods.enterObjectValue(ddlSpecies, value);
            }

            public static void enterTotalNumberOfAnimals(int value)
            {
                SetMethods.enterIntObjectValue(txtIntTotal, value);
            }

            public static void enterTotalNumberOfDeadAnimals(int value)
            {
                SetMethods.enterIntObjectValue(txtIntDead, value);
            }

            public static void enterTotalNumberOfSickAnimals(int value)
            {
                SetMethods.enterIntObjectValue(txtIntSick, value);
            }

            public static void enterStartOfSignsDate()
            {
                SetMethods.enterCurrentDate(datStartOfSigns);
            }

            public static void enterNotes()
            {
                SetMethods.enterObjectValue(txtNote, longCommentString);
            }

        }

        public class ClinicalInfo
        {
            private static By subTitleFormTitle = By.Id(CommonCtrls.GeneralContent + "H17");
            private static By rdoCliniSignsYES = By.Id(CommonCtrls.GeneralContent + "blVCISigns_0");
            private static By rdoCliniSignsNO = By.Id(CommonCtrls.GeneralContent + "blVCISigns_1");
            private static By rdoCliniSignsUnk = By.Id(CommonCtrls.GeneralContent + "blVCISigns_2");
            private static By btnAdd = By.Id(CommonCtrls.GeneralContent + "btnVCIAdd");
            private static By btnUpdateSpecies = By.Id(CommonCtrls.GeneralContent + "btnVetUpdateSpecies");
            private static By btnAddSpecies = By.Id("lbAddSpecies");
            private static By txtHerdSpeciesName = By.Id(CommonCtrls.GeneralContent + "gvClinicalInvestigations_txtHerdSpeciesName_0");
            private static By txtAnimalID = By.Id(CommonCtrls.GeneralContent + "txtVCIAnimalID");
            private static By ddlStatus = By.Id(CommonCtrls.GeneralContent + "gvClinicalInvestigations_ddlClinicalStatus_0");
            private static IList<IWebElement> statusOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvClinicalInvestigations_ddlClinicalStatus_0']/option")); } }
            private static By ddlHerdID = By.Id(CommonCtrls.GeneralContent + "ddlVCIHerdID");
            private static IWebElement ddlHerdID2 { get { return Driver.Instance.FindElement(By.Id(CommonCtrls.GeneralContent + "ddlVCIHerdID")); } }
            private static IList<IWebElement> herdOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVCIHerdID']/option")); } }
            private static By ddlSpecies = By.Id(CommonCtrls.GeneralContent + "ddlVCISpecies");
            private static IWebElement ddlSpecies2 { get { return Driver.Instance.FindElement(By.Id(CommonCtrls.GeneralContent + "ddlVCISpecies")); } }
            private static IList<IWebElement> speciesOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVCISpecies']/option")); } }
            private static By ddlAge = By.Id(CommonCtrls.GeneralContent + "ddlVCIAge");
            private static IList<IWebElement> ageOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVCIAge']/option")); } }
            private static By ddlSex = By.Id(CommonCtrls.GeneralContent + "ddlVCISex");
            private static IList<IWebElement> sexOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVCISex']/option")); } }
            private static By ddlAnimalStatus = By.Id(CommonCtrls.GeneralContent + "ddlVCIStatus");
            private static IList<IWebElement> animalStatOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVCIStatus']/option")); } }
            private static By txtNote = By.Id(CommonCtrls.GeneralContent + "txtVCINote");
            private static By txtIntTotal = By.Id("intTotalAnimalQty");
            private static By txtIntDead = By.Id("intDeadAnimalQty");
            private static By txtIntSick = By.Id("intSickAnimalQty");
            private static By datStartOfSigns = By.Id("datStartOfSignsDate");
            private static By lblAnimalID = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvAnimalInvestigation']/tbody/tr/td[3]");


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
                    else if (Driver.Instance.FindElements(subTitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subTitleFormTitle).Text.Contains("Clinical Information") &&
                                Driver.Instance.FindElement(subTitleFormTitle).Displayed)
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

            public static void getCurrentSpeciesFromGrid()
            {
                SetMethods.GetCurrentValue(txtHerdSpeciesName);
            }

            public static void getCurAnimalID()
            {
                SetMethods.GetCurrentValue2(lblAnimalID);
            }

            public static void clickAdd()
            {
                SetMethods.clickObjectButtons(btnAdd);
            }

            public static void randomSelectClinicalStatus()
            {
                SetMethods.randomSelectObjectElement(ddlStatus, statusOpts);
            }

            public static void enterHerd()
            {
                SetMethods.enterObjectValue(ddlHerdID, SetMethods.refValue2);
            }

            public static void selectHerdFromList()
            {
                SetMethods.SelectDropDown(ddlHerdID2, SetMethods.refValue2);
            }

            public static void enterSpecies()
            {
                SetMethods.enterObjectValue(ddlSpecies, SetMethods.refValue4);
            }

            public static void selectSpeciesFromList()
            {
                SetMethods.SelectDropDown(ddlSpecies2, SetMethods.refValue1);
            }

            public static void enterAnimalID(string value)
            {
                SetMethods.enterObjectValue(txtAnimalID, value + rNum);
            }

            public static void randomSelectAnimalAge()
            {
                SetMethods.randomSelectObjectElement(ddlAge, ageOpts);
            }

            public static void randomSelectSex()
            {
                SetMethods.randomSelectObjectElement(ddlSex, sexOpts);
            }

            public static void randomSelectAnimalStatus()
            {
                SetMethods.randomSelectObjectElement(ddlAnimalStatus, animalStatOpts);
            }

            public static void enterNotes()
            {
                SetMethods.enterStringObjectValue(txtNote, ExtLongString);
            }
        }

        public class VaccinationInfo
        {
            private static By subTitleFormTitle = By.Id(CommonCtrls.GeneralContent + "H18");
            private static By txtLotNumber = By.Id(CommonCtrls.GeneralContent + "txtVetVaccinationLotNumber");
            private static By txtManufacturer = By.Id(CommonCtrls.GeneralContent + "txtVetVaccinationManufacturer");
            private static By txtComments = By.Id(CommonCtrls.GeneralContent + "txtVetVaccinationComments");
            private static By btnAdd = By.Id(CommonCtrls.GeneralContent + "btnVetVaccinationAdd");
            private static By datVaccineDate = By.Id("ciVetVaccinationDate");
            private static By txtVaccinated = By.Id(CommonCtrls.GeneralContent + "nsVetVaccinationVaccinated");
            private static By ddlDisease = By.Id(CommonCtrls.GeneralContent + "ddlVetVaccinationDiseaseName");
            private static IList<IWebElement> diseaseOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVetVaccinationDiseaseName']/option")); } }
            private static By ddlType = By.Id(CommonCtrls.GeneralContent + "ddlVetvaccinationType");
            private static IList<IWebElement> typeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVetvaccinationType']/option")); } }
            private static IWebElement ddlSpecies2 { get { return Driver.Instance.FindElement(By.Id(CommonCtrls.GeneralContent + "ddlVetVaccinationSpecies")); } }
            private static By ddlSpecies = By.Id(CommonCtrls.GeneralContent + "ddlVetVaccinationSpecies");
            private static IList<IWebElement> speciesOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVetVaccinationSpecies']/option")); } }
            private static By ddlRoute = By.Id(CommonCtrls.GeneralContent + "ddlVetVaccinationRoute");
            private static IList<IWebElement> routeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVetVaccinationRoute']/option")); } }
            private static By tlbVetVaccines = By.Id(CommonCtrls.GeneralContent + "gvVetVaccinations");

            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(subTitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subTitleFormTitle).Text.Contains("Vaccination Information") &&
                                Driver.Instance.FindElement(subTitleFormTitle).Displayed)
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

            public static void clickAdd()
            {
                SetMethods.clickObjectButtons(btnAdd);
            }

            public static void enterVaccinatedDate()
            {
                SetMethods.enterCurrentDate(datVaccineDate);
            }

            public static void randomSelectType()
            {
                SetMethods.randomSelectObjectElement(ddlType, typeOpts);
            }

            public static void randomSelectDisease()
            {
                SetMethods.randomSelectObjectElement(ddlDisease, diseaseOpts);
            }

            public static void enterSpecies()
            {
                SetMethods.enterObjectValue(ddlSpecies, SetMethods.refValue4);
            }

            public static void selectSpeciesFromList()
            {
                SetMethods.SelectDropDown(ddlSpecies2, SetMethods.refValue1);
            }

            public static void enterNoOfAnimalsVaccinated()
            {
                SetMethods.enterObjectValue(txtVaccinated, SetMethods.refValue8);
            }

            public static void randomSelectRoute()
            {
                SetMethods.randomSelectObjectElement(ddlRoute, routeOpts);
            }

            public static void enterLotNumber(string value)
            {
                SetMethods.enterObjectValue(txtLotNumber, value + rNum);
            }

            public static void enterManufacturer()
            {
                string meds = manufacturers[new Random().Next(0, manufacturers.Length)];
                SetMethods.enterObjectValue(txtManufacturer, meds);
            }

            public static void enterNotes()
            {
                SetMethods.enterStringObjectValue(txtComments, ExtLongString);
            }
        }

        public class OutbreakInvest
        {
            private static By subTitleFormTitle = By.Id(CommonCtrls.GeneralContent + "H16");
            private static By ctrlInvestOrgLookup = By.Id(CommonCtrls.GeneralContent + "imgstrVetInvestigatorOrganization");
            private static By datDateOfInvest = By.Id("ciVetdatStartingDateOfInvestigation");
            private static By txtInvestOrg = By.Id("txtstrVetInvestigatorOrganization");
            private static By txtInvestName = By.Id("txtstrVetInvestigatorName");
            private static By chkPrimaryCase = By.Id(CommonCtrls.GeneralContent + "chkVetPrimaryCase");
            private static By ddlCaseStatus = By.Id(CommonCtrls.GeneralContent + "ddlVetCaseStatus");
            private static IList<IWebElement> caseStatOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVetCaseStatus']/option")); } }
            private static By ddlCaseClass = By.Id(CommonCtrls.GeneralContent + "ddlVetCaseClassification");
            private static IList<IWebElement> caseClassOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVetCaseClassification']/option")); } }
            private static By txtAdditiComments = By.Id("txtVetAdditionalComments");

            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(subTitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subTitleFormTitle).Text.Contains("Outbreak Investigation") &&
                                Driver.Instance.FindElement(subTitleFormTitle).Displayed)
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

            public static void clickInvestorOrgLookup()
            {
                SetMethods.clickObjectButtons(ctrlInvestOrgLookup);
            }

            public static void enterDateOfInvestiation()
            {
                SetMethods.enterCurrentDate(datDateOfInvest);
            }

            public static void enterInvestigatorOrganization(String value)
            {
                SetMethods.enterObjectValue(txtInvestOrg, value + numValue);
                notifySFacility = value + numValue;
            }

            public static void enterInvestigatorName(String value)
            {
                SetMethods.enterObjectValue(txtInvestName, notifySFacility + value);
            }

            public static void enterCaseStatus(String value)
            {
                SetMethods.enterObjectValue(ddlCaseStatus, value);
            }

            public static void randomSelectCaseStatus()
            {
                SetMethods.randomSelectObjectElement(ddlCaseStatus, caseStatOpts);
            }

            public static void enterCaseClassification(String value)
            {
                SetMethods.enterObjectValue(ddlCaseClass, value);
            }

            public static void randomSelectCaseClassification()
            {
                SetMethods.randomSelectObjectElement(ddlCaseClass, caseClassOpts);
            }

            public static void clickPrimaryCase()
            {
                SetMethods.clickObjectButtons(chkPrimaryCase);
            }

            public static void enterAdditionalComments()
            {
                SetMethods.enterObjectValue(txtAdditiComments, ExtLongString);
            }
        }

        public class CaseMonitoring
        {
            private static By subTitleFormTitle = By.Id(CommonCtrls.GeneralContent + "H21");
            private static By txtInvestOrg = By.Id("tx2VetMonitoringInvestigatorOrganization");
            private static By ctrlInvestOrgLookup = By.Id(CommonCtrls.GeneralContent + "imVetMonitoringInvestigatorOrganization");
            private static By txtInvestName = By.Id("tx2VetMonitoringInvestigatorName");
            private static By ctrlInvestNameLookup = By.Id(CommonCtrls.GeneralContent + "imVetMonitoringInvestigatorName");
            private static By txtAdditiComments = By.Id("tx2VetAdditionalComments");
            private static By btnAdd = By.Id("btnVetAddCaseMonitoring");

            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(subTitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subTitleFormTitle).Text.Contains("Case Monitoring") &&
                                Driver.Instance.FindElement(subTitleFormTitle).Displayed)
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

            public static void clickAddCaseMonitoring()
            {
                SetMethods.clickObjectButtons(btnAdd);
            }

            public static void enterInvestigatorOrganization(String value)
            {
                SetMethods.enterObjectValue(txtInvestOrg, value + numValue);
                notifySFacility = value + numValue;
            }

            public static void clickInvestOrgLookup()
            {
                SetMethods.clickObjectButtons(ctrlInvestOrgLookup);
                Thread.Sleep(1000);
            }


            public static void enterInvestigatorName(String value)
            {
                SetMethods.enterObjectValue(txtInvestName, notifySFacility + value);
            }

            public static void clickInvestNameLookup()
            {
                SetMethods.clickObjectButtons(ctrlInvestNameLookup);
            }

            public static void enterAdditionalComments()
            {
                SetMethods.enterObjectValue(txtAdditiComments, ExtLongString);
            }

        }

        public class Contacts
        {
            private static By subTitleFormTitle = By.Id(CommonCtrls.GeneralContent + "H19");
            private static By txtContactName = By.Id("tx2VetContactName");
            private static By ctrlContactNmLookup = By.Id(CommonCtrls.GeneralContent + "imVetContactName");
            private static By datDateOfLastCnt = By.Id("ciVetdatDateOfLastContact");
            private static By ddlRelation = By.Id("ddlVetContactRelationshipType");
            private static IList<IWebElement> relationOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='ddlVetContactRelationshipType']/option")); } }
            private static By txtPlaceOfLastContact = By.Id("tx2VetPlaceOfLastContact");
            private static By ddlContactStatus = By.Id("ddlVetContactStatus");
            private static IList<IWebElement> cntStatOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='ddlVetContactStatus']/option")); } }
            private static By txtInvestName = By.Id("txtVetNotificationSentByName");
            private static By txtContactComments = By.Id("txtVetstrContactComments");
            private static By tlbVetCaseContacts = By.Id(CommonCtrls.GeneralContent + "gvVetCaseContacts");
            private static IList<IWebElement> lblContactNames { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvVetCaseContacts']/tbody/tr/td[2]")); } }
            private static By btnAddContact = By.Id("bBatchAddVetContact");

            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(subTitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subTitleFormTitle).Text.Contains("Contacts") &&
                                Driver.Instance.FindElement(subTitleFormTitle).Displayed)
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

            public static void doesNewRecordShowInGrid()
            {
                SetMethods.isElementPresent(lblContactNames, SetMethods.refValue4);
            }

            public static void clickAddContact()
            {
                SetMethods.clickObjectButtons(btnAddContact);
            }

            public static void getValueFromContactName()
            {
                SetMethods.GetNewvalue(txtContactName);
            }

            public static void clickContactNameLookup()
            {
                SetMethods.clickObjectButtons(ctrlContactNmLookup);
                Thread.Sleep(1000);
            }

            public static void enterDateOfLastContact()
            {
                SetMethods.enterCurrentDate(datDateOfLastCnt);
            }

            public static void randomSelectRelation()
            {
                //Scroll to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, -500)", "");
                SetMethods.randomSelectObjectElement(ddlRelation, relationOpts);
            }

            public static void enterContactRelation(string value)
            {
                SetMethods.enterObjectValue(ddlRelation, value);
            }

            public static void randomSelectContactStatus()
            {
                SetMethods.randomSelectObjectElement(ddlContactStatus, cntStatOpts);
            }

            public static void enterContactStatus(string value)
            {
                SetMethods.enterObjectValue(ddlContactStatus, value);
            }

            public static void enterPlaceOfLastContact(String value)
            {
                SetMethods.enterObjectValue(txtPlaceOfLastContact, rNum + value);
            }

            public static void enterContactComments()
            {
                SetMethods.enterObjectValue(txtContactComments, ExtLongString);
            }

        }

        public class Samples
        {
            private static By subTitleFormTitle = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "upSample']/div/div[1]/div/div[1]/h3");
            private static By btnAddSamples = By.Id(CommonCtrls.GeneralContent + "btnAddVetSample2");
            private static By lblFieldSampleID = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvVetSamples']/tbody/tr[1]/td[2]");
            private static By lblSampleType = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvVetSamples']/tbody/tr[1]/td[1]");

            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(subTitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subTitleFormTitle).Text.Contains("Samples") &&
                                Driver.Instance.FindElement(subTitleFormTitle).Displayed)
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

            public static void clickAddSamples()
            {
                SetMethods.clickObjectButtons(btnAddSamples);
            }

            public static void getCurrFieldSampleFromGrid()
            {
                SetMethods.GetNewValue7(lblFieldSampleID);
            }

            public static void getCurrSampleTypeFromGrid()
            {
                SetMethods.GetNewValue8(lblSampleType);
            }


            public class SamplesPopupWndw
            {
                private static By subTitleFormTitle = By.XPath("//*[@id='outbreakVetSample']/div/div/div[1]/h4");
                private static By ddlSampleType = By.Id(CommonCtrls.GeneralContent + "ddlVetSampleTypeID");
                private static IList<IWebElement> sampleTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVetSampleTypeID']/option")); } }
                private static By txtFieldSampleID = By.Id(CommonCtrls.GeneralContent + "txtVetSampleFieldId");
                private static By ddlSpecies = By.Id(CommonCtrls.GeneralContent + "ddlSampleSpeciesID");
                private static IList<IWebElement> speciesOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlSampleSpeciesID']/option")); } }
                private static By ddlAnimalID = By.Id(CommonCtrls.GeneralContent + "ddlVetAnimalId");
                private static IList<IWebElement> animalOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVetAnimalId']/option")); } }
                private static By datCollectDate = By.Id("cidatVetSampleCollectionDate");
                private static By txtCollectOrg = By.Id("txtSampleCollectedByOrganizationID");
                private static By ctrlCollectOrgLookup = By.Id(CommonCtrls.GeneralContent + "imgSampleCollectedByOrganizationID");
                private static By txtCollectOfficer = By.Id("txtSampleCollectedByPersonID");
                private static By ctrlCollectPerLookup = By.Id(CommonCtrls.GeneralContent + "txtSampleCollectedByPersonID");
                private static By txtSentToOrg = By.Id("txtSampleSentToOrganizationID");
                private static By ctrlSentToOrgLookup = By.Id(CommonCtrls.GeneralContent + "txtSampleSentToOrganizationID");
                private static By btnSaveSample = By.Id(CommonCtrls.GeneralContent + "btnVetSampleSave");
                private static By btnCancelSample = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "divSampleForm']/div[6]/button");


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
                        else if (Driver.Instance.FindElements(subTitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subTitleFormTitle).Text.Contains("Samples") &&
                                    Driver.Instance.FindElement(subTitleFormTitle).Displayed)
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

                public static void clickSaveSample()
                {
                    SetMethods.clickObjectButtons(btnSaveSample);
                }

                public static void clickCancel()
                {
                    SetMethods.clickObjectButtons(btnCancel);
                }

                public static void randomSelectSampleType()
                {
                    SetMethods.randomSelectObjectElement(ddlSampleType, sampleTypeOpts);
                }

                public static void enterFieldSampleID(String value)
                {
                    SetMethods.enterObjectValue(txtFieldSampleID, value + rNum);
                }

                public static void enterSpecies(String value)
                {
                    SetMethods.enterObjectValue(ddlSpecies, value);
                }

                public static void enterAnimalID(String value)
                {
                    SetMethods.enterObjectValue(ddlAnimalID, value);
                }

                public static void enterCollectionDate()
                {
                    SetMethods.enterCurrentDate(datCollectDate);
                }

                public static void enterCollectedByOrg(String value)
                {
                    SetMethods.enterObjectValue(txtCollectOrg, value);
                }

                public static void clickCollectOrgLookup()
                {
                    SetMethods.clickObjectButtons(ctrlCollectOrgLookup);
                }

                public static void enterCollectedByOffice(String value)
                {
                    SetMethods.enterObjectValue(txtCollectOfficer, value);
                }

                public static void clickCollectByOfficerLookup()
                {
                    SetMethods.clickObjectButtons(ctrlCollectPerLookup);
                }

                public static void enterSentToOrg(String value)
                {
                    SetMethods.enterObjectValue(txtSentToOrg, value);
                }

                public static void clickSentToOrgLookup()
                {
                    SetMethods.clickObjectButtons(ctrlSentToOrgLookup);
                }

            }
        }

        public class PensideTests
        {
            private static By subTitleFormTitle = By.Id(CommonCtrls.GeneralContent + "H23");
            private static By ddlFieldSamples = By.Id("ddlVetFieldSampleId");
            private static IList<IWebElement> fieldSamplesOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='ddlVetFieldSampleId]/option")); } }
            private static By ddlTestName = By.Id("ddlVetTestName");
            private static IList<IWebElement> testNameOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='ddlVetTestName']/option")); } }
            private static By ddlResult = By.Id("ddlVetResult");
            private static IList<IWebElement> resultOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='ddlVetResult']/option")); } }
            private static By btnAdd = By.Id("btnAddPensideText");
            private static IList<IWebElement> btnEdits { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-edit']")); } }
            private static By btnEdit = By.XPath("//a[@class='btn glyphicon glyphicon-edit']");
            private static IList<IWebElement> btnDeletes { get { return Driver.Instance.FindElements(By.XPath("//a[@class='btn glyphicon glyphicon-trash']")); } }


            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(subTitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subTitleFormTitle).Text.Contains("Penside Tests") &&
                                Driver.Instance.FindElement(subTitleFormTitle).Displayed)
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

            public static void enterFieldSamples()
            {
                SetMethods.enterObjectValue(ddlFieldSamples, SetMethods.refValue7);
            }

            public static void randomSelectTestName()
            {
                SetMethods.randomSelectObjectElement(ddlTestName, testNameOpts);
            }

            public static void randomSelectTestResult()
            {
                SetMethods.randomSelectObjectElement(ddlResult, resultOpts);
            }

            public static void clickAddPensideTest()
            {
                SetMethods.clickObjectButtons(btnAdd);
            }
        }

        public class LabTestInterpret
        {
            private static By subTitleFormTitle = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "upTestsAndTestInterpretations']/div[1]/div[1]/div/div[1]/h3");
            private static By rdoLabTestsYES = By.Id(CommonCtrls.GeneralContent + "rblVetLabTestsInterpretations_0");
            private static By rdoLabTestsNO = By.Id(CommonCtrls.GeneralContent + "rblVetLabTestsInterpretations_1");
            private static By rdoLabTestsUNK = By.Id(CommonCtrls.GeneralContent + "rblVetLabTestsInterpretations_2");
            private static By btnAddLabTests = By.Id(CommonCtrls.GeneralContent + "btnAddVetLabTest2");

            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                        || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        Assert.Fail("Page cannot be displayed");
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        return false;
                    }
                    else if (Driver.Instance.FindElements(subTitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subTitleFormTitle).Text.Contains("Lab Tests & Interpretations") &&
                                Driver.Instance.FindElement(subTitleFormTitle).Displayed)
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

            public static void clickLabTestsYES()
            {
                SetMethods.clickObjectButtons(rdoLabTestsYES);
            }

            public static void clickLabTestsNO()
            {
                SetMethods.clickObjectButtons(rdoLabTestsNO);
            }

            public static void clickLabTestsUNK()
            {
                SetMethods.clickObjectButtons(rdoLabTestsUNK);
            }

            public static void clickAddLabTests()
            {
                SetMethods.clickObjectButtons(btnAddLabTests);
            }

            public class LabTestsPopupWndw
            {
                private static By subTitleFormTitle = By.XPath("//*[@id='outbreakVetLabTest']/div/div/div[1]/h4");
                private static By txtLabSampleID = By.Id(CommonCtrls.GeneralContent + "txtVetLabSampleId");
                private static By txtSampleType = By.Id(CommonCtrls.GeneralContent + "txtVetLabSampleType");
                private static By ddlFieldSampleID = By.Id(CommonCtrls.GeneralContent + "ddlVetLabFieldSampleId");
                private static IList<IWebElement> fieldSamplesOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVetLabFieldSampleId']/option")); } }
                private static By ddlTestDisease = By.Id(CommonCtrls.GeneralContent + "ddlVetLabTestDisease");
                private static IList<IWebElement> testDiseaseOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVetLabTestDisease']/option")); } }
                private static By ddlTestName = By.Id(CommonCtrls.GeneralContent + "ddlVetLabTestName");
                private static IList<IWebElement> testNameOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVetLabTestName']/option")); } }
                private static By ddlTestCategory = By.Id(CommonCtrls.GeneralContent + "ddlVetLabTestCategory");
                private static IList<IWebElement> testCatOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVetLabTestCategory']/option")); } }
                private static By txtTestStatus = By.Id(CommonCtrls.GeneralContent + "txtVetLabTestStatus");
                private static By datResultDate = By.Id(CommonCtrls.GeneralContent + "ciVetLabdatResultDate");
                private static By ddlResultObserve = By.Id(CommonCtrls.GeneralContent + "ddlVetLabResultObservation");
                private static IList<IWebElement> resultObsOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlVetLabResultObservation']/option")); } }
                private static By btnSave = By.Id(CommonCtrls.GeneralContent + "btnVetAddLabTest");
                private static By btnCancel = By.XPath("//button[@title='btnVetCancelLabTest']");

                public static bool IsAt
                {
                    get
                    {
                        Driver.Instance.WaitForPageToLoad();
                        if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                            || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                        {
                            Assert.Fail("Page cannot be displayed");
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            return false;
                        }
                        else if (Driver.Instance.FindElements(subTitleFormTitle).Count > 0)
                        {
                            {
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subTitleFormTitle).Text.Contains("Lab Tests") &&
                                    Driver.Instance.FindElement(subTitleFormTitle).Displayed)
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

                public static void clickSave()
                {
                    SetMethods.clickObjectButtons(btnSave);
                }

                public static void clickCancel()
                {
                    SetMethods.clickObjectButtons(btnCancel);
                }

                public static void enterLabSampleID(string value)
                {
                    SetMethods.enterObjectValue(txtLabSampleID, value + rNum);
                }

                public static void enterSampleType()
                {
                    SetMethods.enterObjectValue(txtSampleType, SetMethods.refValue8);
                }

                public static void enterFieldSampleID()
                {
                    SetMethods.enterObjectValue(ddlFieldSampleID, SetMethods.refValue7);
                }

                public static void randomSelectTestDisease()
                {
                    SetMethods.randomSelectObjectElement(ddlTestDisease, testDiseaseOpts);
                }
                public static void randomSelectTestName()
                {
                    SetMethods.randomSelectObjectElement(ddlTestName, testNameOpts);
                }

                public static void randomSelectTestCategory()
                {
                    SetMethods.randomSelectObjectElement(ddlTestCategory, testCatOpts);
                }

                public static void enterTestStatus(string value)
                {
                    SetMethods.enterObjectValue(txtTestStatus, value);
                }

                public static void enterResultDate()
                {
                    SetMethods.enterCurrentDate(datResultDate);
                }

                public static void randomSelectResultObservation()
                {
                    SetMethods.randomSelectObjectElement(ddlResultObserve, resultObsOpts);
                }

            }

        }
    }
}
