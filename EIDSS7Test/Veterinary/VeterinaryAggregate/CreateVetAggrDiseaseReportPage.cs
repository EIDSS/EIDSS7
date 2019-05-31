using System;
using System.Collections.Generic;
using EIDSS7Test.Selenium;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using System.Threading;
using EIDSS7Test.Common;
using NUnit.Framework;

namespace EIDSS7Test.Veterinary.VeterinaryAggregate
{
    public class CreateVetAggrDiseaseReportPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(120));
        private static Random rnd = new Random();

        private static By titleFormTitle = By.TagName("h2");
        private static By vetAggCaseDetailsSection = By.XPath(".//*[@id='" + CommonCtrls.GeneralContent + "VeterinaryAggregate']/div/div[1]/h3");
        private static By ddlTimeIntervalUnit = By.Id(CommonCtrls.GeneralContent + "ddlidfsTimeInterval");
        private static IList<IWebElement> timeIntervalOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsTimeInterval]/option")); } }
        private static By ddlAdminLevel = By.Id(CommonCtrls.GeneralContent + "ddlifdsSearchAdministrativeLevel");
        private static IList<IWebElement> adminLvlOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlifdsSearchAdministrativeLevel]/option")); } }
        private static By ddlYear = By.Id(CommonCtrls.GeneralContent + "ddlintYear");
        private static IList<IWebElement> yearOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlintYear]/option")); } }
        private static By ddlMonth = By.Id(CommonCtrls.GeneralContent + "ddlintMonth");
        private static IList<IWebElement> monthOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlintMonth']/option")); } }
        private static By ddlRegion = By.Id(CommonCtrls.VetAggrLocContent + "ddllucVeterinaryAggregateidfsRegion");
        private static IList<IWebElement> regionOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.VetAggrLocContent + "ddllucVeterinaryAggregateidfsRegion']/option")); } }
        private static By ddlRayon = By.Id(CommonCtrls.VetAggrLocContent + "ddllucVeterinaryAggregateidfsRayon");
        private static IList<IWebElement> rayonOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.VetAggrLocContent + "ddllucVeterinaryAggregateidfsRayon']/option")); } }
        private static By ddlTownOrVillage = By.Id(CommonCtrls.VetAggrLocContent + "ddllucVeterinaryAggregateidfsSettlement");
        private static IList<IWebElement> townOrVillOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.VetAggrLocContent + "ddllucVeterinaryAggregateidfsSettlement']/option")); } }
        private static By ddlSentByInstitute = By.Id(CommonCtrls.GeneralContent + "ddlidfSentByOffice");
        private static IList<IWebElement> sentByInstOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfSentByOffice']/option")); } }
        private static By ddlSentByOfficer = By.Id(CommonCtrls.GeneralContent + "ddlidfSentByPerson");
        private static IList<IWebElement> sentByOffOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfSentByPerson']/option")); } }
        private static By datSentByDate = By.Id(CommonCtrls.GeneralContent + "txtdatSentbyDate");
        private static IList<IWebElement> sentByDateOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfSentbyDate']/option")); } }
        private static By ddlRecvdByInstitute = By.Id(CommonCtrls.GeneralContent + "ddlidfReceivedByOffice");
        private static IList<IWebElement> recvdByInstOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfReceivedByOffice']/option")); } }
        private static By ddlRecvdByOfficer = By.Id(CommonCtrls.GeneralContent + "ddlidfReceivedByPerson");
        private static IList<IWebElement> recvdByOffOptions { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfReceivedByPerson']/option")); } }
        private static By datRecvdByDate = By.Id(CommonCtrls.GeneralContent + "txtdatReceivedByDate");
        private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnNotSubmit");
        private static By btnNext = By.Id(CommonCtrls.GeneralContent + "btnNext");
        private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmit");
        private static By AggrMonthError = By.Id(CommonCtrls.GeneralContent + "ctl31");
        private static By NotifySentByInstError = By.Id(CommonCtrls.GeneralContent + "valSentByOffice");
        private static By NotifySentByOfficerError = By.Id(CommonCtrls.GeneralContent + "valSentByPerson");
        private static By NotifySentByDateError = By.Id(CommonCtrls.GeneralContent + "valSentbyDate");



        public static bool IsAt
        {
            get
            {
                Thread.Sleep(5000);
                Driver.Instance.WaitForPageToLoad();
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
                else if (Driver.Instance.FindElements(vetAggCaseDetailsSection).Count > 0)
                {
                    {
                        Driver.Wait(TimeSpan.FromMinutes(45));
                        if (Driver.Instance.FindElement(vetAggCaseDetailsSection).Text.Contains("Veterinary Aggregate Disease Report Details") &&
                            Driver.Instance.FindElement(vetAggCaseDetailsSection).Displayed)
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


        private static void enterFormObject(string objectName, By el)
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

        public static void clickNext()
        {
            SetMethods.clickObjectButtons(btnNext);
        }

        public static void clickCancelVetAggr()
        {
            SetMethods.clickObjectButtons(btnCancel);
        }

        public static void clickSubmit()
        {
            SetMethods.clickObjectButtons(btnSubmit);
        }


        public static void randomTimeInterval()
        {
            SetMethods.randomSelectObjectElement(ddlTimeIntervalUnit, timeIntervalOptions);
        }

        public static void randomSelectAdminLevel()
        {
            SetMethods.randomSelectObjectElement(ddlAdminLevel, adminLvlOptions);
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
            SetMethods.randomSelectObjectElement(ddlTownOrVillage, townOrVillOptions);
        }

        public static void randomSelectSentByInstitute()
        {
            SetMethods.randomSelectObjectElement(ddlSentByInstitute, sentByInstOptions);
        }

        public static void randomSelectSentByOfficer()
        {
            SetMethods.randomSelectObjectElement(ddlSentByOfficer, sentByOffOptions);
        }

        public static void randomSelectRecvdByInstitute()
        {
            SetMethods.randomSelectObjectElement(ddlRecvdByInstitute, recvdByInstOptions);
        }

        public static void randomSelectYear()
        {
            SetMethods.randomSelectObjectElement(ddlYear, yearOptions);
        }

        public static void randomSelectMonth()
        {
            SetMethods.randomSelectObjectElement(ddlMonth, monthOptions);
        }

        public static void selectWeekTimeIntervalUnit()
        {
            SetMethods.enterObjectDropdownListValue(ddlTimeIntervalUnit, "Week");
        }

        public static void selectYearTimeIntervalUnit()
        {
            SetMethods.enterObjectDropdownListValue(ddlTimeIntervalUnit, "Year");
        }

        public static void selectMonthTimeIntervalUnit()
        {
            SetMethods.enterObjectDropdownListValue(ddlTimeIntervalUnit, "Month");
        }

        public static void selectQuarterTimeIntervalUnit()
        {
            SetMethods.enterObjectDropdownListValue(ddlTimeIntervalUnit, "Quarter");
        }

        public static void selectDayTimeIntervalUnit()
        {
            SetMethods.enterObjectDropdownListValue(ddlTimeIntervalUnit, "Day");
        }

        public static void selectCountryAdminLevel()
        {
            SetMethods.enterObjectDropdownListValue(ddlAdminLevel, "Country");
        }

        public static void selectRayonAdminLevel()
        {
            SetMethods.enterObjectDropdownListValue(ddlAdminLevel, "Rayon");
        }

        public static void selectRegionAdminLevel()
        {
            SetMethods.enterObjectDropdownListValue(ddlAdminLevel, "Region");
        }

        public static void selectCaseYear(string yr)
        {
            SetMethods.enterObjectDropdownListValue(ddlYear, yr);
        }

        public static void selectCaseMonth(string mo)
        {
            SetMethods.enterObjectDropdownListValue(ddlMonth, mo);
        }

        public static void enterSentByDate()
        {
            SetMethods.enterCurrentDate(datSentByDate);
        }

        public static void enterRecvdByDate()
        {
            SetMethods.enterFutureDate(datRecvdByDate, 7);
        }

        public static void doesAggregateMonthMissingErrorMessageDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(AggrMonthError);
        }

        public static void doesNotifySentByInstituteMissingErrorMessageDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(NotifySentByInstError);
        }

        public static void doesNotifySentByOfficerMissingErrorMessageDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(NotifySentByOfficerError);
        }

        public static void doesNotifySentByDateMissingErrorMessageDisplay()
        {
            SetMethods.doesValidationErrorMessageDisplay(NotifySentByDateError);
        }
    }
}