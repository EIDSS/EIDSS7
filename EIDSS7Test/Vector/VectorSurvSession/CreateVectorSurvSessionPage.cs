using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using System.Threading;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Linq;

namespace EIDSS7Test.Vector.CreateVectorSurvSession
{
    public class CreateVectorSurvSessionPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();
        public static String longCommentString = "jljjououaofuoufouaoufoiaofjnlznkznknfnnfanfaf08097975927491710810890418jfajflaflanflaknf,anf,mjflkjaljfj0808080&$^#@%#$$%&^*&(ljljljfljlsjfljowuoqu7r97(^%%$&lnlnalfnlanflalkfkjalfjlahlaljflajfljfjolau&(&(&9796827972959775972597275927927597927592597797579";
        public static string[] avianDiseases = new string[] { "H5N1", "H7N9", "HPAI H5g", "H7N8", "H7N2", "H5" };
        public static string[] humanDiseases = new string[] { "Streptococcus pneumoniae", "Salmonella", "Salmonella Typhimurium", "Group B Streptococcus", "Babesiosis", "Bacterial Vaginosis", "Capillariasis", "Microcephaly", "Ebola" };
        public static string[] farmDiseases = new string[] { "Anthrax", "Brucellosis", "Campylobacteriosis", "Contagious ecthyma", "Cryptosporidiosis", "Leptospirosis", "African Swine Fever", "Glanders", "Camelpox", "Tularemia - General" };
        public static string[] geoRefSources = new string[] { "ArcMap", "PCI Geomatica", "ERDAS Image", "ArcGIS" };
        public static string fieldSessionID;
        public static string sessionID = null;
        public static string street = null;
        public static string outBreakID = null;
        public static string vectortype = null;
        public static string vectorStatus = null;
        public static string errorString = null;

        private static By HeaderFormTitle = By.TagName("h1");
        private static By titleFormTitle = By.TagName("h2");
        private static By subtitleFormTitle = By.XPath("//*[contains(@class, 'panel-heading')][contains(text(), 'Location')]");
        private static By txtSessionID = By.Id(CommonCtrls.GeneralContent + "txtSessionID");
        private static By txtFieldSessionID = By.Id(CommonCtrls.GeneralContent + "txtstrFieldSessionID");
        private static By ddlOutbreakID = By.Id(CommonCtrls.GeneralContent + "ddlstrOutbreakID_ddlAllItems");
        private static By datStartDate = By.Id(CommonCtrls.GeneralContent + "txtdatStartDate");
        private static By datCloseDate = By.Id(CommonCtrls.GeneralContent + "txtdatCloseDate");
        private static By txtCollectionEffort = By.Id(CommonCtrls.GeneralContent + "txtintCollectionEffort");
        private static By ddlStatus = By.Id(CommonCtrls.GeneralContent + "ddlidfsVectorSurveillanceStatus");
        private static IList<IWebElement> statusOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsVectorSurveillanceStatus']/option")); } }
        private static By txtDescripton = By.Id(CommonCtrls.GeneralContent + "txtstrDescription");
        private static By radAddrExact = By.Id(CommonCtrls.GeneralContent + "rblidfsGeoLocationType_0");
        private static By radAddrRelative = By.Id(CommonCtrls.GeneralContent + "rblidfsGeoLocationType_1");
        private static By radAddrForeign = By.Id(CommonCtrls.GeneralContent + "rblidfsGeoLocationType_2");
        private static By radAddrNational = By.Id(CommonCtrls.GeneralContent + "rblidfsGeoLocationType_3");
        private static By ddlCountry = By.Id(CommonCtrls.VectorLuDetailCollect + "ddllucDetailedCollectionidfsCountry");
        private static IList<IWebElement> countryOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.VectorLuDetailCollect + "ddllucDetailedCollectionidfsCountry']/option")); } }
        public static By ddlRegion = By.Id(CommonCtrls.VectorLuDetailCollect + "ddllucDetailedCollectionidfsRegion");
        private static IList<IWebElement> regionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.VectorLuDetailCollect + "ddllucDetailedCollectionidfsRegion']/option")); } }
        public static By ddlRayon = By.Id(CommonCtrls.VectorLuDetailCollect + "ddllucDetailedCollectionidfsRayon");
        private static IList<IWebElement> rayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.VectorLuDetailCollect + "ddllucDetailedCollectionidfsRayon']/option")); } }
        public static By ddlTownOrVillage = By.Id(CommonCtrls.VectorLuDetailCollect + "ddllucDetailedCollectionidfsSettlement");
        private static IList<IWebElement> townOrVillageOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.VectorLuDetailCollect + "ddllucDetailedCollectionidfsSettlement']/option")); } }
        private static By txtStreet = By.Id(CommonCtrls.VectorTxtLocContent + "strStreetName");
        private static By txtBuilding = By.Id(CommonCtrls.VectorTxtLocContent + "strBuilding");
        private static By txtHouse = By.Id(CommonCtrls.VectorTxtLocContent + "strHouse");
        private static By txtApartment = By.Id(CommonCtrls.VectorTxtLocContent + "strApartment");
        private static By ddlPostalCode = By.Id(CommonCtrls.VectorDdlLocContent + "idfsPostalCode");
        private static By ddlGroundType = By.Id(CommonCtrls.GeneralContent + "ddlGroundType");
        private static IList<IWebElement> groundTypeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationContent + "ddlGroundType']/option")); } }
        private static By txtDistance = By.Id(CommonCtrls.GeneralContent + "txtDistance");
        private static By txtDirection = By.Id(CommonCtrls.GeneralContent + "txtDirection");
        private static By txtLatitude = By.Id(CommonCtrls.VectorTxtLocContent + "strLatitude");
        private static By txtLongitude = By.Id(CommonCtrls.VectorTxtLocContent + "strLongitude");
        private static By txtLocDescription = By.Id(CommonCtrls.GeneralContent + "txtLocationDescription");
        private static By txtForeignAddrType = By.Id(CommonCtrls.GeneralContent + "txtForeignAddressType");
        private static By btnCancel = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "createVectorSurveillance']/div/button");
        private static By btnVectorSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmitVector");
        private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmit");
        private static By btnSaveReview = By.Id(CommonCtrls.GeneralContent + "btnAddVector");
        private static By btnPopupOK = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "errorVSS']/div/div/div[3]/button");
        private static By startDateError = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lblErr']");
        private static By countryError = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "lblErr']");
        public static String startDateErrorMsg = "Please at least select status and start date parameters.";
        public static String countryErrorMsg = "Please select address country location parameter.";
        private static By linkCollectionData = By.LinkText("Collection Data");
        private static By linkVectorData = By.LinkText("Vector Data");
        private static By linkVectorSpecificData = By.LinkText("Vector Specific Data");
        private static By linkSamplesData = By.LinkText("Samples");
        private static By linkFieldTests = By.LinkText("Field Tests");
        private static By linkLabTests = By.LinkText("Laboratory Tests");
        private static By linkReview = By.LinkText("Review");
        private static By linkReturnToDash = By.Id(CommonCtrls.GeneralContent + "btnRtD");
        private static By linkReturnToVSS = By.Id(CommonCtrls.GeneralContent + "btnRTSR");
        private static By txtstrSuccessSessionID = By.Id(CommonCtrls.GeneralContent + "lblSuccess");


        //FLD6100023
        public static bool IsAt
        {
            get
            {
                if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                     || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                {
                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Page cannot be displayed");
                    return false;
                }
                else if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Error:"))
                {
                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                    return false;
                }
                else if (Driver.Instance.FindElements(titleFormTitle).Count > 0)
                {
                    {
                        Driver.Wait(TimeSpan.FromMinutes(45));
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Vector Surveillance Session") &&
                            Driver.Instance.FindElement(titleFormTitle).Displayed)
                            return true;
                        else
                            //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("This is not the correct title");
                        return false;
                    }
                }
                else
                {
                    //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("This is not the correct title");
                    return false;
                }
            }
        }

        public static void doesPopupSessionSavedSuccessMessageDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(txtstrSuccessSessionID);
        }

        public static void doesMissingCountryErrorMessageDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(countryError);
        }

        public static void doesMissingStartDateErrorMessageDisplay()
        {
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, -1500)", "");
            SetMethods.doesValidationErrorMessageDisplay(startDateError);
        }

        public static void clickCollectionDataLink()
        {
            SetMethods.clickObjectButtons(linkCollectionData);
        }

        public static void clickVectorDataLink()
        {
            SetMethods.clickObjectButtons(linkVectorData);
        }

        public static void clickVectorSpecificDataLink()
        {
            SetMethods.clickObjectButtons(linkVectorSpecificData);
        }

        public static void clickSamplesLink()
        {
            SetMethods.clickObjectButtons(linkSamplesData);
        }

        public static void clickFieldTestsLink()
        {
            SetMethods.clickObjectButtons(linkFieldTests);
        }

        public static void clickLabTestsLink()
        {
            SetMethods.clickObjectButtons(linkLabTests);
        }

        public static void clickReviewLink()
        {
            SetMethods.clickObjectButtons(linkReview);
        }

        public static void clickCancel()
        {
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1500)", "");
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clickSubmit()
        {
            Thread.Sleep(2000);
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1500)", "");
            SetMethods.clickObjectButtons(btnSubmit);
        }


        public static void clickVectorSubmit()
        {
            Thread.Sleep(2000);
            ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1500)", "");
            SetMethods.clickObjectButtons(btnVectorSubmit);
        }

        public static void clickSaveAndReview()
        {
            SetMethods.clickObjectButtons(btnSaveReview);
        }

        public static void clickPopupOK()
        {
            SetMethods.clickObjectButtons(btnPopupOK);
        }

        public class SessionSummary
        {
            private static By subtitleFormTitle = By.XPath("//*[contains(@class, 'heading')][contains(text(), 'Session Summary')]");
            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    Thread.Sleep(1000);
                    if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found")
                         || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                    {
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                    else if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Error:"))
                    {
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("An HTTP error occurred.  Page Not found.  Please try again.");
                        return false;
                    }
                    else if (Driver.Instance.FindElements(subtitleFormTitle).Count > 0)
                    {
                        {
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Session Summary") &&
                                Driver.Instance.FindElement(subtitleFormTitle).Displayed)
                                return true;
                            else
                                //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                Assert.Fail("This is not the correct title");
                            return false;
                        }
                    }
                    else
                    {
                        //Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("This is not the correct title");
                        return false;
                    }
                }
            }

            public static void clearSessionStartDate()
            {
                SetMethods.clearField(datStartDate);
            }

            public static void clickReturnToDashboard()
            {
                //Switch to new window
                string newWindowHandle = Driver.Instance.WindowHandles.Last();
                var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);

                SetMethods.clickObjectButtons(linkReturnToDash);
            }

            public static void clickReturnToVSS()
            {
                //Switch to new window
                string newWindowHandle = Driver.Instance.WindowHandles.Last();
                var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);

                SetMethods.clickObjectButtons(linkReturnToVSS);
            }

            public static String enterRandomSessionID(String session)
            {
                int rNum = rnd.Next(0, 100000000);
                string ID = session + rNum;
                SetMethods.enterStringObjectValue(txtSessionID, ID);
                return sessionID = ID;
            }

            public static String enterRandomFieldSessionID(String session)
            {
                int rNum = rnd.Next(0, 100000000);
                string ID = session + rNum;
                SetMethods.enterStringObjectValue(txtFieldSessionID, ID);
                return fieldSessionID = ID;
            }

            public static void getVectorSessionID()
            {
                try
                {
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0,-500)");
                    Thread.Sleep(100);
                    var sesID = wait.Until(ExpectedConditions.ElementIsVisible(txtSessionID)).GetAttribute("value");
                    sessionID = sesID;
                }
                catch
                {
                    var sesID = wait.Until(ExpectedConditions.ElementIsVisible(txtSessionID)).GetAttribute("value");
                    sessionID = sesID;
                }
            }

            public static String getVectorSessionID2()
            {
                var sesID = wait.Until(ExpectedConditions.ElementIsVisible(txtstrSuccessSessionID));
                String lastpart = sesID.Text.Split(' ').Last().TrimEnd('.');
                return sessionID = lastpart;
            }

            public static String enterRandomOutbreakID(String outbreak)
            {
                int rNum = rnd.Next(0, 100000000);
                string ID = outbreak + rNum;
                SetMethods.enterStringObjectValue(ddlOutbreakID, ID);
                return outBreakID = outbreak;
            }

            public static void enterStartDate()
            {
                SetMethods.enterCurrentDate(datStartDate);
            }

            public static void enterRandomCloseDate()
            {
                SetMethods.enterCurrentDate(datCloseDate);
            }

            public static void enterRandomCollectionEfforts()
            {
                int rNum = rnd.Next(1, 360);
                SetMethods.enterIntObjectValue(txtCollectionEffort, rNum);
            }

            public static void selectClosedStatus()
            {
                SetMethods.enterObjectValue(ddlStatus, "Closed");
            }

            public static void selectInProcessStatus()
            {
                SetMethods.enterObjectValue(ddlStatus, "In Process");
            }

            public static String getVSSStatus()
            {
                Driver.Wait(TimeSpan.FromMinutes(1000));
                IWebElement dropDown = Driver.Instance.FindElement(ddlStatus);
                SelectElement selectedVal = new SelectElement(dropDown);
                var element2 = selectedVal.SelectedOption.Text;
                Driver.Wait(TimeSpan.FromMinutes(1000));
                return vectorStatus = element2;
            }
        }

        public class Location
        {
            private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "vectorLocationHeader']");
            private static By btnShowVectorLocation = By.Id(CommonCtrls.GeneralContent + "btnShowVectorLocation");
            private static By ddlCountry = By.Id(CommonCtrls.VectorDdlLocContent + "idfsCountry");
            private static IList<IWebElement> countryOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.VectorDdlLocContent + "idfsCountry']/option")); } }
            public static By ddlRegion = By.Id(CommonCtrls.VectorDdlLocContent + "idfsRegion");
            private static IList<IWebElement> regionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.VectorDdlLocContent + "idfsRegion']/option")); } }
            public static By ddlRayon = By.Id(CommonCtrls.VectorDdlLocContent + "idfsRayon");
            private static IList<IWebElement> rayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.VectorDdlLocContent + "idfsRayon']/option")); } }
            public static By ddlTownOrVillage = By.Id(CommonCtrls.VectorDdlLocContent + "idfsSettlement");
            private static IList<IWebElement> townOrVillageOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.VectorDdlLocContent + "idfsSettlement']/option")); } }
            private static By txtStreet = By.Id(CommonCtrls.VectorTxtLocContent + "strStreetName");
            private static By txtBuilding = By.Id(CommonCtrls.VectorTxtLocContent + "strBuilding");
            private static By txtHouse = By.Id(CommonCtrls.VectorTxtLocContent + "strHouse");
            private static By txtApartment = By.Id(CommonCtrls.VectorTxtLocContent + "strApartment");
            private static By ddlPostalCode = By.Id(CommonCtrls.VectorDdlLocContent + "idfsPostalCode");
            private static By ddlGroundType = By.Id(CommonCtrls.GeneralContent + "ddlGroundType");
            private static IList<IWebElement> groundTypeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.LocationContent + "ddlGroundType']/option")); } }
            private static By txtDistance = By.Id(CommonCtrls.GeneralContent + "txtDistance");
            private static By txtDirection = By.Id(CommonCtrls.GeneralContent + "txtDirection");
            private static By txtLatitude = By.Id(CommonCtrls.VectorTxtLocContent + "strLatitude");
            private static By txtLongitude = By.Id(CommonCtrls.VectorTxtLocContent + "strLongitude");
            private static By txtLocDescription = By.Id(CommonCtrls.GeneralContent + "txtLocationDescription");

            public static bool IsAt
            {
                get
                {
                    //Scroll to the bottom of the page
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
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Location") &&
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


            public static void expandVectorLocation()
            {
                SetMethods.clickObjectButtons(btnShowVectorLocation);
            }

            private static void selectNullValueToClear(By element, string value, IList<IWebElement> list)
            {
                var obj = wait.Until(ExpectedConditions.ElementIsVisible(element));
                Driver.Wait(TimeSpan.FromMinutes(10));
                obj.Click();

                foreach (var el in list)
                {
                    if (el.Text.Contains(value))
                    {
                        el.Click();
                        Driver.Wait(TimeSpan.FromMinutes(10));
                    }
                    break;
                }
            }

            public static void clearCountry()
            {
                SetMethods.clearDropdownList(ddlCountry);
                Thread.Sleep(2000);
            }

            public static void enterVectorDescription()
            {
                SetMethods.enterObjectValue(txtDescripton, longCommentString);
            }


            public static void selectExactAddress()
            {
                SetMethods.clickObjectButtons(radAddrExact);
            }

            public static void selectRelativeAddress()
            {
                SetMethods.clickObjectButtons(radAddrRelative);
            }

            public static void selectForeignAddress()
            {
                SetMethods.clickObjectButtons(radAddrForeign);
            }

            public static void selectNationalAddress()
            {
                SetMethods.clickObjectButtons(radAddrNational);
            }

            public static void randomSelectCountry()
            {
                //Scroll to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 800)", "");
                SetMethods.randomSelectObjectElement(ddlCountry, countryOptions);
            }

            public static Boolean isFieldEnabled(By element)
            {
                try
                {
                    var rayon = wait.Until(ExpectedConditions.ElementToBeClickable(element));
                    rayon.GetAttribute("enabled");
                    Driver.Wait(TimeSpan.FromMinutes(30));
                    return true;
                }
                catch (Exception)
                {
                    Console.WriteLine("Field is not enabled");
                    return false;
                }
            }

            public static void randomSelectRegion()
            {
                //Scroll to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1500)", "");
                Thread.Sleep(1000);
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlRegion, regionOptions);
            }

            public static void enterCountryRegion(string reg)
            {
                SetMethods.enterStringObjectValue(ddlRegion, reg);
            }

            public static void randomSelectRayon()
            {
                //Scroll to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1500)", "");
                Thread.Sleep(1000);
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlRayon, rayonOptions);
            }

            public static void enterCountryRayon(string ray)
            {
                SetMethods.enterStringObjectValue(ddlRayon, ray);
            }

            public static void randomSelectTownOrVillage()
            {
                //Scroll to the bottom of the page
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1500)", "");
                Thread.Sleep(1000);
                SetMethods.randomSelectObjectElement(ddlTownOrVillage, townOrVillageOptions);
            }

            public static void enterCountrySettlement(string reg)
            {
                SetMethods.enterStringObjectValue(ddlTownOrVillage, reg);
            }

            public static String enterStreetAddress(string addr)
            {
                int rNum = rnd.Next(1, 99999);
                street = rNum + addr;
                SetMethods.enterStringObjectValue(txtStreet, street);
                return street;
            }

            public static void enterHouseNumber()
            {
                SetMethods.enterStringObjectValue(txtHouse, street);
            }

            public static void enterBuildingNumber()
            {
                SetMethods.enterStringObjectValue(txtHouse, street);
            }

            public static void enterAptNumber()
            {
                SetMethods.enterStringObjectValue(txtHouse, street);
            }

            public static void enterPostalCode()
            {
                int rNum = rnd.Next(10000, 99999);
                SetMethods.enterIntObjectValue(ddlPostalCode, rNum);
            }

            public static void randomlySelectGroundType()
            {
                SetMethods.RandomSelectDropdownListObjectWithRetry(ddlGroundType, groundTypeOptions);
            }

            public static void enterGroundType(String type)
            {
                SetMethods.enterObjectValue(ddlGroundType, type);
            }

            public static void enterDistance(double min, double max)
            {
                double rNum = rnd.NextDouble() * (max - min) + min;
                SetMethods.enterDoubleObjectValue(txtDistance, rNum);
            }

            public static void enterDirection(double min, double max)
            {
                double rNum = rnd.NextDouble() * (max - min) + min;
                SetMethods.enterDoubleObjectValue(txtDirection, rNum);
            }


            public static void enterRandomLatitude()
            {
                SetMethods.enterRandomMinLatitude(txtLatitude);
            }

            public static void enterRandomLongitude()
            {
                SetMethods.enterRandomMinLongitude(txtLongitude);
            }

            public static void enterDescriptionOfLocation()
            {
                SetMethods.enterObjectValue(txtLocDescription, longCommentString);
                Thread.Sleep(1000);
            }

            public static void enterForeignAddress()
            {
                SetMethods.enterObjectValue(txtForeignAddrType, longCommentString);
                Thread.Sleep(1000);
            }
        }

        public class DetailedCollections
        {
            //private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "DetCollection']/div[1]/h3");
            private static By subtitleFormTitle = By.XPath("//*[contains(text(), 'Detailed Collections')]");
            private static By btnShowDetailCollect = By.Id(CommonCtrls.GeneralContent + "btnShowVectorDetailedCollections");
            private static By btnAddDetailCollect = By.Id(CommonCtrls.GeneralContent + "btnNewDetailedCollection");
            private static By linkCollectionData = By.LinkText("Collection Data");
            private static By linkVectorData = By.LinkText("Vector Data");
            private static By linkVectorSpecificData = By.LinkText("Vector-specific Data");
            private static By linkSamples = By.LinkText("Samples");
            private static By linkFieldTests = By.LinkText("Field Tests");
            private static By linkReviewCollection = By.LinkText("Review Collection");
            private static By vectorTypeErrorMsg = By.Id(CommonCtrls.GeneralContent + "ctl69");
            private static By countryErrorMsg = By.Id(CommonCtrls.GeneralContent + "ctl02");
            private static By regionErrorMsg = By.Id(CommonCtrls.VectorLuDetailCollect + "ctl05");
            private static By rayonErrorMsg = By.Id(CommonCtrls.VectorLuDetailCollect + "ctl10");
            private static By collectByOfficeErrorMsg = By.Id(CommonCtrls.GeneralContent + "ctl102");
            private static By collectDateErrorMsg = By.Id(CommonCtrls.GeneralContent + "ctl109");

            public static bool IsAt
            {
                get
                {
                    Driver.Instance.WaitForPageToLoad();
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1500)", "");
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
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Detailed Collections") &&
                                Driver.Instance.FindElement(subtitleFormTitle).Displayed)
                                return true;
                            else
                                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("Page cannot be displayed");
                            return false;
                        }
                    }
                    else
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                }
            }

            public static void expandDetailedCollections()
            {
                SetMethods.clickObjectButtons(btnShowDetailCollect);
            }

            public static void clickAddDetailedCollect()
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1200)", "");
                SetMethods.clickObjectButtons(btnAddDetailCollect);
                Thread.Sleep(5000);
            }

            public class CollectionData
            {
                private static By subtitleFormTitle = By.Id(CommonCtrls.GeneralContent + "vectorGeneral");
                private static By txtFieldID = By.Id(CommonCtrls.GeneralContent + "txtstrFieldVectorID");
                private static By ddlVectorType = By.Id(CommonCtrls.GeneralContent + "ddlidfDetailedVectorType");
                private static IList<IWebElement> vecTypeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfDetailedVectorType']/option")); } }
                private static By txtDescripton = By.Id(CommonCtrls.GeneralContent + "txtDetailedLocationDescription");
                private static By rdoDiffSessLocationYes = By.Id(CommonCtrls.GeneralContent + "rdbDifferentLocationfromSessionYes");
                private static By rdoDiffSessLocationNo = By.Id(CommonCtrls.GeneralContent + "rdbDifferentLocationfromSessionNo");
                private static By txtElevation = By.Id(CommonCtrls.GeneralContent + "txtintDetailedElevation");
                private static By ddlSurroundings = By.Id(CommonCtrls.GeneralContent + "ddlDetailedSurroundings");
                private static IList<IWebElement> surroundOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlDetailedSurroundings']/option")); } }
                private static By txtGEOReference = By.Id(CommonCtrls.GeneralContent + "txtstrGEOReferenceSource");
                private static By ddlBasisOfRecord = By.Id(CommonCtrls.GeneralContent + "ddlidfsBasisofRecord");
                private static IList<IWebElement> basisOfRecOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsBasisofRecord']/option")); } }
                private static By ddlCollectByInstit = By.Id(CommonCtrls.GeneralContent + "ddlidfCollectedByOffice");
                private static IList<IWebElement> collectByInstitOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfCollectedByOffice']/option")); } }
                private static By ddlCollectByPerson = By.Id(CommonCtrls.GeneralContent + "ddlidfCollectedByPerson");
                private static IList<IWebElement> collectByPerOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfCollectedByPerson']/option")); } }
                private static By datCollectionDate = By.Id(CommonCtrls.GeneralContent + "txtdatCollectionDateTime");
                private static By ddlCollectionTime = By.Id(CommonCtrls.GeneralContent + "ddlidfsDayPeriod");
                private static IList<IWebElement> collectTimeOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsDayPeriod']/option")); } }
                private static By ddlCollectionMethod = By.Id(CommonCtrls.GeneralContent + "ddlidfsCollectionMethod");
                private static IList<IWebElement> collectMethodOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsCollectionMethod']/option")); } }
                private static By ddlEctoCollected = By.Id(CommonCtrls.GeneralContent + "ddlidfsEctoparasitesCollected");
                private static IList<IWebElement> ectoCollectOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsEctoparasitesCollected']/option")); } }


                public static bool IsAt
                {
                    get
                    {
                        Driver.Instance.WaitForPageToLoad();
                        Thread.Sleep(1000);
                        //Scroll to the top of the page
                        ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0,-1500)", "");
                        try
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
                                    Driver.Wait(TimeSpan.FromMinutes(45));
                                    if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Collection Data") &&
                                        Driver.Instance.FindElement(subtitleFormTitle).Displayed)
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

                public static void randomSelectVectorType()
                {
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, -800)", "");
                    SetMethods.randomSelectObjectElement(ddlVectorType, vecTypeOptions);
                }

                public static void enterVectorType(string value)
                {
                    SetMethods.enterStringObjectValue(ddlVectorType, value);
                    Thread.Sleep(1000);
                }

                private static void getElementID(By element1, string element2)
                {
                    var ID = Driver.Instance.FindElement(element1).GetAttribute("value");
                    Driver.Wait(TimeSpan.FromMinutes(20));
                    element2 = ID.ToString();
                }

                public static String getVectorType()
                {
                    Driver.Wait(TimeSpan.FromMinutes(1000));
                    IWebElement dropDown = Driver.Instance.FindElement(ddlVectorType);
                    SelectElement selectedVal = new SelectElement(dropDown);
                    var element2 = selectedVal.SelectedOption.Text;
                    Driver.Wait(TimeSpan.FromMinutes(1000));
                    return vectortype = element2;
                }

                public static void clearCountryField()
                {
                    SetMethods.clearDropdownList(ddlCountry);
                }

                public static void randomSelectRayon()
                {
                    SetMethods.RandomSelectDropdownListObjectWithRetry(ddlRayon, rayonOptions);
                    Thread.Sleep(1000);
                }

                public static void enterCountryRayon(string reg)
                {
                    SetMethods.enterStringObjectValue(ddlRayon, reg);
                    Thread.Sleep(1000);
                }

                public static void randomSelectSettlement()
                {
                    SetMethods.randomSelectObjectElement(ddlTownOrVillage, townOrVillageOptions);
                    Thread.Sleep(1000);
                }

                public static void randomSelectRegion()
                {
                    SetMethods.randomSelectObjectElement(ddlRegion, regionOptions);
                    Thread.Sleep(1000);
                }

                public static void enterCountryRegion(string reg)
                {
                    SetMethods.enterStringObjectValue(ddlRegion, reg);
                    Thread.Sleep(2000);
                }

                public static void randomSelectCollectedByInstitution()
                {
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1200)", "");
                    SetMethods.randomSelectObjectElement(ddlCollectByInstit, collectByInstitOptions);
                    Thread.Sleep(1000);
                }

                public static void enterCollectByInstit(string reg)
                {
                    SetMethods.enterStringObjectValue(ddlCollectByInstit, reg);
                    Thread.Sleep(2000);
                }

                public static void enterCollectedDate()
                {
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1200)", "");
                    SetMethods.enterCurrentDate(datCollectionDate);
                }

                public static void enterCollectionTime(string value)
                {
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1200)", "");
                    SetMethods.enterStringObjectValue(ddlCollectionTime, value);
                }

                public static void randomSelectCollectionMethod()
                {
                    SetMethods.RandomSelectDropdownListObjectWithRetry(ddlCollectionMethod, collectMethodOptions);
                }

                public static void wasEctoparasitesCollected(string value)
                {
                    SetMethods.enterStringObjectValue(ddlEctoCollected, value);
                }


                public static void doesVectorTypeErrorMsgDisplay()
                {
                    SetMethods.doesValidationErrorMessageDisplay(vectorTypeErrorMsg);
                }

                public static void doesCountryErrorMsgDisplay()
                {
                    SetMethods.doesValidationErrorMessageDisplay(countryErrorMsg);
                }

                public static void doesRegionErrorMsgDisplay()
                {
                    SetMethods.doesValidationErrorMessageDisplay(regionErrorMsg);
                }

                public static void doesRayonErrorMsgDisplay()
                {
                    SetMethods.doesValidationErrorMessageDisplay(rayonErrorMsg);
                }

                public static void doesCollectedByInstErrorMsgDisplay()
                {
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1200)", "");
                    SetMethods.doesValidationErrorMessageDisplay(collectByOfficeErrorMsg);
                }

                public static void doesCollectionDateErrorMsgDisplay()
                {
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 1200)", "");
                    SetMethods.doesValidationErrorMessageDisplay(collectDateErrorMsg);
                }

                public static void enterDescriptOfLocation()
                {
                    SetMethods.enterObjectValue(txtDescripton, longCommentString);
                    Thread.Sleep(1000);
                }

                public static void enterElevation()
                {
                    SetMethods.enterRandomElevation(txtElevation);
                }

                public static void randomSelectSurroundings()
                {
                    SetMethods.RandomSelectDropdownListObjectWithRetry(ddlSurroundings, surroundOptions);
                }

                public static void enterGEOReferenceSource()
                {
                    string source = geoRefSources[new Random().Next(0, geoRefSources.Length)];
                    SetMethods.enterStringObjectValue(txtGEOReference, source);
                }

                public static void selectBasisOfRecord(string value)
                {
                    SetMethods.enterStringObjectValue(ddlBasisOfRecord, value);
                }
            }

            public class VectorData
            {
                private static By subtitleFormTitle = By.Id(CommonCtrls.GeneralContent + "vectorData");
                private static By txtQuantity = By.Id(CommonCtrls.GeneralContent + "txtintQuantity");
                private static By ddlSpecies = By.Id(CommonCtrls.GeneralContent + "ddlidfsVectorSubType");
                private static IList<IWebElement> speciesOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsVectorSubType']/option")); } }
                private static By ddlSex = By.Id(CommonCtrls.GeneralContent + "ddlidfsSex");
                private static IList<IWebElement> sexOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsSex']/option")); } }
                private static By ddlIdentityByOffice = By.Id(CommonCtrls.GeneralContent + "ddlidfIdentifiedByOffice");
                private static IList<IWebElement> identityByOfficeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfIdentifiedByOffice']/option")); } }
                private static By ddlIdentityByPerson = By.Id(CommonCtrls.GeneralContent + "ddlidfIdentifiedByPerson");
                private static IList<IWebElement> identityByPersonOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfIdentifiedByPerson']/option")); } }
                private static By ddlIdentityMethod = By.Id(CommonCtrls.GeneralContent + "ddlidfsIdentificationMethod");
                private static IList<IWebElement> identityMethodOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsIdentificationMethod']/option")); } }
                private static By datIdentityDate = By.Id(CommonCtrls.GeneralContent + "txtdatIdentifiedDateTime");
                private static By quanityErrorMsg = By.Id(CommonCtrls.LocationUsrContent + "ctl125");
                private static By speciesErrorMsg = By.Id(CommonCtrls.LocationUsrContent + "ctl127");

                public static bool IsAt
                {
                    get
                    {
                        Driver.Instance.WaitForPageToLoad();
                        Thread.Sleep(1000);
                        //Scroll to the bottom of the page
                        //((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 250)", "");
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
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Vector Data") &&
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

                public static void enterQuantity()
                {
                    int rNum = rnd.Next(1, 50);
                    SetMethods.enterIntObjectValue(txtQuantity, rNum);
                    Thread.Sleep(1000);
                }

                public static void randomSelectSpecies()
                {
                    SetMethods.RandomSelectDropdownListObjectWithRetry(ddlSpecies, speciesOpts);
                    Thread.Sleep(1000);
                }

                public static void enterSpeciesSex(string value)
                {
                    SetMethods.enterStringObjectValue(ddlSex, value);
                }

                public static void enterSpecies(String value)
                {
                    SetMethods.enterStringObjectValue(ddlSpecies, value);
                }

                public static void randomSelectIdentifiedByOffice()
                {
                    SetMethods.RandomSelectDropdownListObjectWithRetry(ddlIdentityByOffice, identityByOfficeOpts);
                }

                public static void randomSelectIdentifiedByPerson()
                {
                    SetMethods.RandomSelectDropdownListObjectWithRetry(ddlIdentityByPerson, identityByPersonOpts);
                }

                public static void randomSelectIdentifyingMethod()
                {
                    SetMethods.RandomSelectDropdownListObjectWithRetry(ddlIdentityMethod, identityMethodOpts);
                }

                public static void randomEnterIdentifyingDate()
                {
                    SetMethods.enterCurrentDate(datIdentityDate);
                }

                public static void enterIdentifiedByOffice(string reg)
                {
                    SetMethods.enterStringObjectValue(ddlIdentityByOffice, reg);
                    Thread.Sleep(2000);
                }

            }

            public class VectorSpecificData
            {
                private static By subtitleFormTitle = By.XPath("//*[contains(text(), 'Vector Specific Data')]");

                public static bool IsAt
                {
                    get
                    {
                        //Scroll to the bottom of the page
                        //((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 250)", "");
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
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Vector Specific Data") &&
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

            }

            public class Samples
            {
                private static By subtitleFormTitle = By.Id(CommonCtrls.GeneralContent + "vectorSamples");
                private static By btnAddSample = By.Id(CommonCtrls.GeneralContent + "addSamplebtn");
                private static By tblSampleResults = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "gvSamples']/tbody");
                private static IList<IWebElement> tblRows { get { return Driver.Instance.FindElements(By.TagName("tr")); } }
                private static IList<IWebElement> tblColumns { get { return Driver.Instance.FindElements(By.TagName("td")); } }

                public static bool IsAt
                {
                    get
                    {
                        Driver.Instance.WaitForPageToLoad();
                        Thread.Sleep(1000);
                        //Scroll to the bottom of the page
                        //((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 250)", "");
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
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Samples") &&
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

                public static void clickAddSample()
                {
                    SetMethods.clickObjectButtons(btnAddSample);
                    Thread.Sleep(3000);
                }


                public static void doesNewSampleDisplayInGrid()
                {
                    //Scroll to bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 500)", "");
                    Thread.Sleep(120);

                    if (tblColumns.Count > 0)
                    {
                        foreach (var col in tblColumns)
                        {
                            Driver.Wait(TimeSpan.FromMinutes(10));
                            if (col.Text.Contains(fieldSessionID))
                            {
                                Console.WriteLine(sessionID + " displays in list successfully");
                                break;
                            }
                            else if (!col.Text.Contains(fieldSessionID))
                            {
                                Console.WriteLine("No data available.");
                            }
                            break;
                        }
                    }
                    else
                    {
                        //Fails test if name does not display in list
                        Assert.Fail(fieldSessionID + " record does not display.");
                    }
                }

                public class SamplesPopupDialog
                {
                    private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "modalAddSampleLabel']");
                    private static By txtSampleFieldSampleID = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "txtAddSampleFieldSampleID']");
                    private static By ddlSampleType = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddSampleSampleType']");
                    private static IList<IWebElement> sampleTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddSampleSampleType']/option")); } }
                    private static By ddlSentToOrganization = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddSampleSenttoOrganization']");
                    private static IList<IWebElement> sentToOrgOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddSampleSenttoOrganization']/option")); } }
                    private static By ddlCollectByInstitution = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddSampleCollectedByInstitution']");
                    private static IList<IWebElement> collectByInstitOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddSampleCollectedByInstitution']/option")); } }
                    private static By btnClose = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "btnSampleClose']");
                    private static By btnSaveSample = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "btn_SaveSample']");
                    private static By datReadOnlyCollectDate = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "txtAddSampleCollectionDate']");
                    private static By txtReadOnlyComment = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "txtAddSampleComment']");
                    private static By datReadOnlyAccessionDate = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "txtAddSampleAccessionDate']");
                    private static By txtReadOnlySampleCondRcvd = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "txtstrCondition']");


                    public static bool IsAt
                    {
                        get
                        {
                            //Switch to new window
                            //string newWindowHandle = Driver.Instance.WindowHandles.Last();
                            //var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);
                            Driver.Instance.SwitchTo().Window(Driver.Instance.WindowHandles.Last());

                            Driver.Instance.WaitForPageToLoad();
                            Thread.Sleep(1000);
                            //Scroll to the bottom of the page
                            //((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 250)", "");
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
                                    if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Sample") &&
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

                    public static void enterFieldSampleID()
                    {
                        SetMethods.enterStringObjectValue(txtSampleFieldSampleID, fieldSessionID);
                    }

                    public static void randomSelectSampleType()
                    {
                        SetMethods.RandomSelectDropdownListObjectWithRetry(ddlSampleType, sampleTypeOpts);
                    }

                    public static void randomSelectSentToOrganization()
                    {
                        SetMethods.RandomSelectDropdownListObjectWithRetry(ddlSentToOrganization, sentToOrgOpts);
                    }

                    public static void randomSelectCollectedByInstitution()
                    {
                        SetMethods.RandomSelectDropdownListObjectWithRetry(ddlCollectByInstitution, collectByInstitOpts);
                    }

                    public static void clickClose()
                    {
                        SetMethods.clickObjectButtons(btnClose);

                        //Switch to new window
                        string newWindowHandle = Driver.Instance.WindowHandles.Last();
                        var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);
                    }

                    public static void clickSaveSample()
                    {
                        SetMethods.clickObjectButtons(btnSaveSample);

                        //Switch to new window
                        string newWindowHandle = Driver.Instance.WindowHandles.Last();
                        var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);
                    }
                }

            }

            public class FieldTests
            {
                private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "vectorFieldTests']");
                private static By btnAddFieldTest = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "addFieldTestbtn']");

                public static bool IsAt
                {
                    get
                    {
                        Driver.Instance.WaitForPageToLoad();
                        Thread.Sleep(1000);
                        //Scroll to the bottom of the page
                        //((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 250)", "");
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
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Field Tests") &&
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

                //public static bool isFieldSampleIDPopulated
                //{

                //}

                //public static bool isCollectionDatePopulated
                //{

                //}

                public static void clickAddFieldTest()
                {
                    SetMethods.clickObjectButtons(btnAddFieldTest);

                    //Switch to new window
                    string newWindowHandle = Driver.Instance.WindowHandles.Last();
                    var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);
                }

                public class FieldTestsPopupDialogue
                {
                    private static By ddlFieldSampleID = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddFieldTestFieldSampleID']");
                    private static By ddlReadOnlySampleType = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddFieldTestFieldSampleType']");
                    private static IList<IWebElement> sampleTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddFieldTestFieldSampleType']/option")); } }
                    private static By datReadOnlyCollectionDate = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "txtAddFieldTestCollectionDate']");
                    private static By datResultDate = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "txtAddFieldTestResultDate']");
                    private static By ddlTestName = By.Id(CommonCtrls.GeneralContent + "ddlAddFieldTestTestName");
                    private static IList<IWebElement> testNameOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddFieldTestTestName']/option")); } }
                    private static By ddlTestCategory = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddFieldTestTestCategory']");
                    private static IList<IWebElement> testCategoryOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddFieldTestTestCategory']/option")); } }
                    private static By ddlTestedByInstitution = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddFieldTestTestedByInstitution']");
                    private static IList<IWebElement> testByInstitOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddFieldTestTestedByInstitution']/option")); } }
                    private static By ddlTestedByPerson = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddFieldTestTestedBy']");
                    private static IList<IWebElement> testByPersonOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddFieldTestTestedBy']/option")); } }
                    private static By ddlTestResult = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddFieldTestTestResult']");
                    private static IList<IWebElement> testResultOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddFieldTestTestResult']/option")); } }
                    private static By ddlDisease = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddFieldTestDisease']");
                    private static IList<IWebElement> diseaseOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlAddFieldTestDisease']/option")); } }
                    private static By btnCloseFieldTest = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "btnFieldTestClose']");
                    private static By btnSaveFieldTest = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "btn_SaveFieldTest']");
                    private static By btnDeleteFieldTest = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "btnTryFieldTestDelete']");
                    private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "modalAddFieldTestLabel']");


                    public static bool IsAt
                    {
                        get
                        {
                            Driver.Instance.WaitForPageToLoad();
                            Thread.Sleep(1000);
                            //Scroll to the bottom of the page
                            //((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 250)", "");
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
                                    if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Field Test") &&
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


                    public static void enterResultDate()
                    {
                        SetMethods.enterDateBack7Days(datResultDate);
                    }

                    public static void randomSelectTestName()
                    {
                        SetMethods.RandomSelectDropdownListObjectWithRetry(ddlTestName, testNameOpts);
                    }

                    public static void randomSelectTestCategory()
                    {
                        SetMethods.RandomSelectDropdownListObjectWithRetry(ddlTestCategory, testCategoryOpts);
                    }

                    public static void randomSelectTestedByInstitution()
                    {
                        SetMethods.RandomSelectDropdownListObjectWithRetry(ddlTestedByInstitution, testByInstitOpts);
                    }

                    public static void enterTestedByInstitution(string value)
                    {
                        SetMethods.enterStringObjectValue(ddlTestedByInstitution, value);
                    }

                    public static void randomSelectTestedByPerson()
                    {
                        SetMethods.RandomSelectDropdownListObjectWithRetry(ddlTestedByPerson, testByPersonOpts);
                    }

                    public static void enterTestedByPerson(string value)
                    {
                        SetMethods.enterStringObjectValue(ddlTestedByPerson, value);
                    }

                    public static void randomSelectTestResult()
                    {
                        SetMethods.RandomSelectDropdownListObjectWithRetry(ddlTestResult, testResultOpts);
                    }

                    public static void randomSelectDisease()
                    {
                        SetMethods.RandomSelectDropdownListObjectWithRetry(ddlDisease, diseaseOpts);
                    }

                    public static void clickCloseFieldTest()
                    {
                        SetMethods.clickObjectButtons(btnCloseFieldTest);

                        //Switch to new window
                        string newWindowHandle = Driver.Instance.WindowHandles.Last();
                        var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);
                    }

                    public static void clickSaveFieldTest()
                    {
                        SetMethods.clickObjectButtons(btnSaveFieldTest);

                        //Switch to new window
                        string newWindowHandle = Driver.Instance.WindowHandles.Last();
                        var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);
                    }

                    public static void clickDeleteFieldTest()
                    {
                        SetMethods.clickObjectButtons(btnDeleteFieldTest);

                        //Switch to new window
                        string newWindowHandle = Driver.Instance.WindowHandles.Last();
                        var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);
                    }
                }
            }

            public class LaboratoryTests
            {
                private static By subtitleFormTitle = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "vectorLabTests']/div/div[1]/div/div/h3");

                public static bool IsAt
                {
                    get
                    {
                        //Scroll to the bottom of the page
                        //((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 250)", "");
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
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Laboratory Test") &&
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
            }
        }

        public class AggregateCollections
        {
            private static By subtitleFormTitle = By.XPath("//*[contains(text(), 'Aggregate Collections')]");
            private static By btnAddAggregateCollect = By.Id(CommonCtrls.GeneralContent + "btnAddNewAggregateCollection");
            private static By btnShowAggrCollect = By.Id(CommonCtrls.GeneralContent + "btnShowVectorAggregateCollections");

            public static bool IsAt
            {
                get
                {
                    //Scroll to the bottom of the page
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 500)", "");
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
                            Driver.Wait(TimeSpan.FromMinutes(45));
                            if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Aggregate Collections") &&
                                Driver.Instance.FindElement(subtitleFormTitle).Displayed)
                                return true;
                            else
                                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("Page cannot be displayed");
                            return false;
                        }
                    }
                    else
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page cannot be displayed");
                        return false;
                    }
                }
            }

            public static void expandAggreCollections()
            {
                SetMethods.clickObjectButtons(btnShowAggrCollect);
            }

            public static void clickAddAggregateCollect()
            {
                try
                {
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 700)", "");
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    SetMethods.clickObjectButtons(btnAddAggregateCollect);
                    Thread.Sleep(2000);
                }
                catch
                {
                    Driver.Wait(TimeSpan.FromMinutes(10));
                    SetMethods.clickObjectButtons(btnAddAggregateCollect);
                    Thread.Sleep(2000);
                }
            }

            public class AggregateInformation
            {
                private static By subtitleFormTitle = By.XPath("//*[contains(text(), 'Aggregate Information')]");
                public static bool IsAt
                {
                    get
                    {
                        //Scroll to the bottom of the page
                        //((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 500)", "");
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
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("Aggregate Information") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
                                    return true;
                                else
                                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                Assert.Fail("Page cannot be displayed");
                                return false;
                            }
                        }
                        else
                        {
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("Page cannot be displayed");
                            return false;
                        }
                    }
                }

            }

            public class ListOfDiseases
            {
                private static By subtitleFormTitle = By.XPath("//*[contains(text(), 'List of Diseases')]");

                public static bool IsAt
                {
                    get
                    {
                        //Scroll to the bottom of the page
                        ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("window.scrollBy(0, 500)", "");
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
                                Driver.Wait(TimeSpan.FromMinutes(45));
                                if (Driver.Instance.FindElement(subtitleFormTitle).Text.Contains("List of Diseases") &&
                                    Driver.Instance.FindElement(subtitleFormTitle).Displayed)
                                    return true;
                                else
                                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                                Assert.Fail("Page cannot be displayed");
                                return false;
                            }
                        }
                        else
                        {
                            Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                            Assert.Fail("Page cannot be displayed");
                            return false;
                        }
                    }
                }
            }
        }
    }
}