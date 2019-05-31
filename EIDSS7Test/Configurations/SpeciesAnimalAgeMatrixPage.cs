using System;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using EIDSS7Test.Selenium;
using EIDSS7Test.Common;
using NUnit.Framework;
using System.Collections.Generic;

namespace EIDSS7Test.Configurations
{
    public class SpeciesAnimalAgeMatrixPage
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(30));
        private static By titleFormTitle = By.TagName("h2");
        private static By lblSpecies_1 = By.Id(CommonCtrls.GeneralContent + "gvSpeciesTypeAnimalAgeMatrix_lblstrSpeciesType_0");
        private static By lblAnimalAge_1 = By.Id(CommonCtrls.GeneralContent + "gvSpeciesTypeAnimalAgeMatrix_lblstrAnimalAge_0");
        private static By cancelMsg = By.Id(CommonCtrls.GeneralContent + "lbl_Cancel");
        private static By successMsg = By.Id(CommonCtrls.GeneralContent + "lblSuccess");
        private static By btnCancelYES = By.Id(CommonCtrls.GeneralContent + "btnCancelYes");
        private static By btnCancelNO = By.Id(CommonCtrls.GeneralContent + "btnCancelNo");
        private static By btnSuccessOK = By.Id(CommonCtrls.GeneralContent + "btnSuccessOK");


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
                        if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Species Type-Animal Age Matrix") &&
                            Driver.Instance.FindElement(titleFormTitle).Displayed)
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
                    Assert.Fail("This is not the correct title");
                    return false;
                }
            }
        }


        public static void clickCancelYES()
        {
            SetMethods.clickObjectButtons(btnCancelYES);
        }

        public static void clickCancelNO()
        {
            SetMethods.clickObjectButtons(btnCancelNO);
        }


        public class STAAPopupWndw
        {
            private static By titleFormTitle = By.TagName("h4");
            private static By ddlSpeciesType = By.Id(CommonCtrls.GeneralContent + "ddlidfsSpeciesType");
            private static IList<IWebElement> speciesTypeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsSpeciesType']/option")); } }
            private static By btnAddSpeciesType = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "btnAddSpeciesType']/span");
            private static By ddlAnimalAge = By.Id(CommonCtrls.GeneralContent + "ddlidfsSpeciesType");
            private static IList<IWebElement> animalAgeOpts { get { return Driver.Instance.FindElements(By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "ddlidfsAnimalAge']/option")); } }
            private static By btnAddAnimalAge = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "btnAddAnimalAge']/span");
            private static By btnSubmit = By.Id(CommonCtrls.GeneralContent + "btnSubmitSpeciesTypeAnimalAge");
            private static By btnCancel = By.Id(CommonCtrls.GeneralContent + "btnCancelSpeciesTypeAnimalAge");


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
                            if (Driver.Instance.FindElement(titleFormTitle).Text.Contains("Species Type-Animal Age Matrix") &&
                                Driver.Instance.FindElement(titleFormTitle).Displayed)
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
                        Assert.Fail("This is not the correct title");
                        return false;
                    }
                }
            }

            public static void randomSelectSpecies()
            {
                SetMethods.randomSelectObjectElement(ddlSpeciesType, speciesTypeOpts);
            }

            public static void addNewSpeciesType()
            {
                SetMethods.clickObjectButtons(btnAddSpeciesType);
            }

            public static void randomSelectAnimalAge()
            {
                SetMethods.randomSelectObjectElement(ddlAnimalAge, animalAgeOpts);
            }

            public static void addNewAnimalAge()
            {
                SetMethods.clickObjectButtons(btnAddAnimalAge);
            }

            public static void clickSubmit()
            {
                SetMethods.clickObjectButtons(btnSubmit);
            }

            public static void clickCancel()
            {
                SetMethods.clickObjectButtons(btnCancel);
            }

        }
    }
}
