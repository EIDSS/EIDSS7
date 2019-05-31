using System;
using System.Collections.Generic;
using System.Threading;
using OpenQA.Selenium;
using System.Text;
using OpenQA.Selenium.Support.UI;
using OpenQA.Selenium.Interactions;
using NUnit.Framework;
using System.Linq;
using EIDSS7Test.Common;

namespace EIDSS7Test.Selenium
{
    public static class SetMethods
    {
        private static WebDriverWait wait = new WebDriverWait(Driver.Instance, TimeSpan.FromMinutes(2000));
        private static Random rnd = new Random();
        public static String refValue1 = null;
        public static String refValue2 = null;
        public static int refValue3 = 0;
        public static int refValue5 = 0;
        public static int refValue6 = 0;
        public static String refValue4 = null;
        public static String refValue7 = null;
        public static String refValue8 = null;
        public static String refValue9 = null;
        public static String refValue10 = null;
        public static string newValue = null;
        public static string currentDate = null;
        public static string eidssCaseID = null;
        public static string otherErrorString;
        public static string errorString = null;
        public static int numberOfRows1;
        public static int numberOfRows2;
        public static int numberOfRows;
        public static IList<IWebElement> listItems1;
        public static IList<IWebElement> listItems2;
        private static By modYesMessage = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "returnToVectorSurveillanceSession']");
        private static By modNoMessage = By.XPath("//*[@id='" + CommonCtrls.GeneralContent + "vectorCancelModal']/div/div/div[3]/input");

        //Create a library of all actions that will be performed on the DOM

        ///<summary>
        ///Extended method for entering text into the control
        ///</summary>
        ///<param name="element"></param>
        ///<param name="value"></param>

        public static void EnterText(this IWebElement element, string value)
        {
            element.SendKeys(value);
        }

        ///<summary>
        ///Extended method for entering amount into the control
        ///</summary>
        ///<param name="element"></param>
        ///<param name="value"></param>
        public static void EnterAmount(this IWebElement element, int value)
        {
            element.SendKeys(value.ToString());
        }

        ///<summary>
        ///Extended method for entering double amount into the control
        ///</summary>
        ///<param name="element"></param>
        ///<param name="value"></param>
        public static void EnterDoubleAmount(this IWebElement element, double value)
        {
            element.SendKeys(value.ToString());
        }

        ///<summary>
        ///Click on a control
        ///</summary>
        ///<param name="element"></param>
        public static void Click(this IWebElement element)
        {
            element.Click();
        }

        ///<summary>
        ///Select a dropdown control
        ///</summary>
        ///<param name="element"></param>
        ///<param name="value"></param>
        public static void SelectDropDown(this IWebElement element, string value)
        {
            new SelectElement(element).SelectByText(value);
        }

        ///<summary>
        ///Extended method to select an option from the dropdown list.  If unsuccessful, try again 
        ///</summary>
        ///<param name="element"></param>
        ///<param name="elements"></param>
        public static void RandomSelectDropdownListObjectWithRetry(By element, IList<IWebElement> elements)
        {
            for (int retries = 0; retries < 3; retries++)
            {
                try
                {
                    randomSelectObjectElement(element, elements);
                    //Thread.Sleep(500);
                    break;
                }
                catch (NoSuchElementException e)
                {
                    if (retries < 1)
                    {
                        randomSelectObjectElement(element, elements);
                        //Thread.Sleep(500);
                    }
                    else
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Element could not be selected. " + e.Message);
                    }
                }
                catch (Exception e)
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("No such element exists. " + e.Message);
                }
            }
        }

        ///<summary>
        ///Extended method for random selection from listbox
        ///</summary>
        ///<param name="elements"></param>
        public static bool SelectRandomOptionFromDropdown(this IList<IWebElement> elements)
        {
            IList<IWebElement> allTags = new List<IWebElement>();

            //Check and see if tag contains text
            foreach (var tag in elements)
            {
                allTags.Add(tag);
            }

            Random rnd = new Random();
            int randomValue = rnd.Next(0, (allTags.Count) - 1);
            IWebElement value = allTags[randomValue];
            if (value.Displayed)
            {
                newValue = value.Text;
                wait.Until(ExpectedConditions.ElementToBeClickable(value));
                //Actions act = new Actions(Driver.Instance);
                //act.MoveToElement(value).DoubleClick().Click().Perform();
                value.Click();
                Thread.Sleep(2000);
            }
            else
            {
                Assert.Fail("There is no value selection");
            }
            return true;
        }

        ///<summary>
        ///Extended method for random selection from listbox
        ///that contains a group of like elements
        ///</summary>
        ///<param name="elements"></param>
        ///<param name="val"></param>
        public static bool SelectRandomOptionFromDropdownThatContains(this IList<IWebElement> elements, string val)
        {
            IList<IWebElement> allTags = new List<IWebElement>();

            //Check and see if tag contains text
            foreach (var tag in elements)
            {
                if (tag.Text.Contains(val))
                {
                    allTags.Add(tag);
                }
            }

            Random rnd = new Random();
            int randomValue = rnd.Next(0, (allTags.Count) - 1);
            IWebElement value = allTags[randomValue];
            if (value.Displayed)
            {
                newValue = value.Text;
                wait.Until(ExpectedConditions.ElementToBeClickable(value));
                //Actions act = new Actions(Driver.Instance);
                //act.MoveToElement(value).DoubleClick().Click().Perform();
                value.Click();
                Thread.Sleep(2000);
            }
            else
            {
                Assert.Fail("There is no value selection");
            }
            return true;
        }

        ///<summary>
        ///Extended method to store all related elements in list 1 to compare
        ///</summary>
        ///<param name="elements"></param>
        public static IList<IWebElement> StoreElementsInList1(IList<IWebElement> elements)
        {
            IList<IWebElement> allTags = new List<IWebElement>();
            Thread.Sleep(120);

            //Check and see if tag contains text
            foreach (var tag in elements)
            {
                Driver.Wait(TimeSpan.FromMinutes(10));
                if (tag.Text != null)
                {
                    allTags.Add(tag);
                }
            }
            return listItems1 = allTags;
        }

        ///<summary>
        ///Extended method to store all related elements in list 2 to compare
        ///</summary>
        ///<param name="elements"></param>
        public static IList<IWebElement> StoreElementsInList2(IList<IWebElement> elements)
        {
            IList<IWebElement> allTags = new List<IWebElement>();
            Thread.Sleep(120);

            //Check and see if tag contains text
            foreach (var tag in elements)
            {
                Driver.Wait(TimeSpan.FromMinutes(10));
                if (tag.Text != null)
                {
                    allTags.Add(tag);
                }
            }
            return listItems2 = allTags;
        }

        ///<summary>
        ///Extended method for random selection from listbox
        ///</summary>
        ///<param name="elements"></param>
        public static void SelectRandomMultipleOptionFromDropdown(this IList<IWebElement> elements)
        {
            IList<IWebElement> allTags = new List<IWebElement>();

            //Check and see if tag contains text
            foreach (var tag in elements)
            {
                if (tag.Text != null)
                {
                    allTags.Add(tag);
                }
            }

            foreach (IWebElement tag in allTags)
            {
                if (!tag.Selected)
                {
                    for (int i = 0; i <= 2; i++)
                    {
                        //var element = wait.Until(ExpectedConditions.ElementIsVisible(tag));
                        tag.Click();
                        Thread.Sleep(40);
                    }
                }
            }
        }


        ///<summary>
        ///Extended method for validating field error messages
        ///</summary>
        ///<param name="element"></param>
        public static void doesValidationErrorMessageDisplay(By element)
        {
            Driver.Instance.WaitForPageToLoad();
            if (Driver.Instance.FindElement(element).Displayed && Driver.Instance.FindElements(element).Count > 0)
            {
                string text = wait.Until(ExpectedConditions.ElementIsVisible(element)).Text;
                Thread.Sleep(3000);
                if (text == null)
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Message does not display.");
                }
                else
                {
                    errorString = text;
                }
            }
            else
            {
                //Fails the test if error message does not display
                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail("Cannot find the element.");
            }
        }

        ///<summary>
        ///Extended method for getting past EIDSS error message
        ///</summary>
        ///<param name="element1"></param>
        ///<param name="element2"></param>
        ///<param name="element3"></param>
        public static void doesValidationErrorMessageDisplay(By element1, By element2, By element3)
        {
            if (Driver.Instance.FindElement(element1).Displayed && Driver.Instance.FindElements(element1).Count > 0)
            {
                Driver.Wait(TimeSpan.FromMinutes(20));
                string text = wait.Until(ExpectedConditions.ElementIsVisible(element1)).Text;
                if (text == null)
                {
                    if (Driver.Instance.FindElement(element2).Displayed)
                    {
                        var el3 = wait.Until(ExpectedConditions.ElementIsVisible(element3));
                        el3.Click();

                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Delete sample record message does not display.");
                    }
                }
                else
                {
                    errorString = text;
                }
            }
            else
            {
                //Fails the test if error message does not display
                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail();
            }
        }

        ///<summary>
        ///Extended method for random selection from listbox
        ///</summary>
        ///<param name="ddlElement"></param>
        ///<param name="listbxElement"></param>
        public static void selectRandomCountryRegionRayon(By ddlElement, IWebElement listbxElement)
        {
            var rayon = wait.Until(ExpectedConditions.ElementIsVisible(ddlElement));
            Driver.Wait(TimeSpan.FromMinutes(10));
            rayon.Click();
            IList<IWebElement> lists = listbxElement.FindElements(By.TagName("li"));
            SetMethods.SelectRandomOptionFromDropdown(lists);
        }

        ///<summary>
        ///General extended method for random selection from listbox
        ///</summary>
        ///<param name="ddlElement"></param>
        ///<param name="els"></param>
        public static void randomSelectObjectElement(By ddlElement, IList<IWebElement> els)
        {
            try
            {
                Thread.Sleep(3000);
                var element = wait.Until(ExpectedConditions.ElementIsVisible(ddlElement));
                element.Click();
                SelectRandomOptionFromDropdown(els);
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", ddlElement);
                var element = wait.Until(ExpectedConditions.ElementIsVisible(ddlElement));
                element.Click();
                SelectRandomOptionFromDropdown(els);
                Thread.Sleep(2000);
            }
        }

        ///<summary>
        ///General extended method for random selection from listbox
        ///that contains a group of like elements
        ///</summary>
        ///<param name="ddlElement"></param>
        ///<param name="els"></param>
        ///<param name="val"></param>
        public static void randomSelectObjectElementThatContains(By ddlElement, IList<IWebElement> els, string val)
        {
            try
            {
                Thread.Sleep(3000);
                var element = wait.Until(ExpectedConditions.ElementIsVisible(ddlElement));
                element.Click();
                SelectRandomOptionFromDropdownThatContains(els, val);
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", ddlElement);
                var element = wait.Until(ExpectedConditions.ElementIsVisible(ddlElement));
                element.Click();
                SelectRandomOptionFromDropdownThatContains(els, val);
                Thread.Sleep(2000);
            }
        }


        ///<summary>
        ///General extended method for clearing a text field
        ///</summary>
        ///<param name="txtElement"></param>
        public static void clearField(By txtElement)
        {
            Thread.Sleep(1000);
            var element = wait.Until(ExpectedConditions.ElementIsVisible(txtElement));
            element.Clear();
            Driver.Wait(TimeSpan.FromMinutes(20));
        }

        ///<summary>
        ///General extended method for clearing a text field
        ///</summary>
        ///<param name="ddlElement"></param>
        public static void clearDropdownList(By txtElement)
        {
            var element = wait.Until(ExpectedConditions.ElementIsVisible(txtElement));
            var selectElement = new SelectElement(element);
            selectElement.SelectByIndex(0);
            Thread.Sleep(2000);
        }

        ///<summary>
        ///General extended method for random multiple selections from listbox
        ///</summary>
        ///<param name="ddlElement"></param>
        ///<param name="els"></param>
        public static void randomMultiSelectObjectElement(By ddlElement, IList<IWebElement> els)
        {
            try
            {
                var element = wait.Until(ExpectedConditions.ElementIsVisible(ddlElement));
                Driver.Wait(TimeSpan.FromMinutes(10));
                element.Click();
                SelectRandomMultipleOptionFromDropdown(els);
                Thread.Sleep(120);
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", ddlElement);
                var element = wait.Until(ExpectedConditions.ElementIsVisible(ddlElement));
                Driver.Wait(TimeSpan.FromMinutes(10));
                element.Click();
                SelectRandomMultipleOptionFromDropdown(els);
                Thread.Sleep(120);
            }
        }

        ///<summary>
        ///Extended method for clicking buttons and links
        ///</summary>
        ///<param name="ddlElement"></param>
        ///<param name="listbxElement"></param>
        public static void clickObjectButtons(By ddlElement)
        {
            try
            {
                Driver.Instance.WaitForPageToLoad();
                if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Page cannot be displayed");
                    Driver.Wait(TimeSpan.FromMinutes(45));
                }
                else
                {
                    if (!Driver.Instance.FindElement(ddlElement).Displayed)
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page object could not be found.");
                        Driver.Wait(TimeSpan.FromMinutes(45));
                    }
                    else
                    {
                        Thread.Sleep(2000);
                        var element = wait.Until(ExpectedConditions.ElementToBeClickable(ddlElement));
                        element.Click();
                        Thread.Sleep(6000);
                    }
                }
            }
            catch (Exception e)
            {
                if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Page cannot be displayed");
                }
                else
                {
                    Driver.Instance.WaitForPageToLoad();
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", ddlElement);
                    if (!Driver.Instance.FindElement(ddlElement).Displayed)
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page object could not be found.");
                        Driver.Wait(TimeSpan.FromMinutes(45));
                    }
                    else
                    {
                        //Fails the test if error message does not display
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail(e.Message);
                    }
                }
            }
        }

        ///<summary>
        ///Extended method for clicking buttons and links
        ///</summary>
        ///<param name="ddlElement"></param>
        ///<param name="listbxElement"></param>
        public static void clickActionObjectButtons(By ddlElement)
        {
            try
            {
                Driver.Instance.WaitForPageToLoad();
                if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Page cannot be displayed");
                    Driver.Wait(TimeSpan.FromMinutes(45));
                }
                else
                {
                    if (!Driver.Instance.FindElement(ddlElement).Displayed)
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page object could not be found.");
                        Driver.Wait(TimeSpan.FromMinutes(45));
                    }
                    else
                    {
                        Thread.Sleep(2000);
                        var element = wait.Until(ExpectedConditions.ElementToBeClickable(ddlElement));
                        Actions act = new Actions(Driver.Instance);
                        act.MoveToElement(element).DoubleClick().Click().Perform();
                    }
                }
            }
            catch (Exception e)
            {
                if (Driver.Instance.Title.Contains("403") || Driver.Instance.Title.Contains("This resource cannot be found") || Driver.Instance.Title.Contains("Web.config") || Driver.Instance.Title.Contains("Problem loading page"))
                {
                    Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                    Assert.Fail("Page cannot be displayed");
                }
                else
                {
                    Driver.Instance.WaitForPageToLoad();
                    ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", ddlElement);
                    if (!Driver.Instance.FindElement(ddlElement).Displayed)
                    {
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail("Page object could not be found.");
                        Driver.Wait(TimeSpan.FromMinutes(45));
                    }
                    else
                    {
                        Thread.Sleep(2000);
                        var element = wait.Until(ExpectedConditions.ElementToBeClickable(ddlElement));
                        Actions act = new Actions(Driver.Instance);
                        act.MoveToElement(element).DoubleClick().Click().Perform();
                    }
                }
            }
        }

        public static void enterDateInDays(int days, By datElement)
        {
            int rNum = days;
            currentDate = DateTime.Now.AddDays(rNum).ToString("M/d/yyyy");
            var element = wait.Until(ExpectedConditions.ElementToBeClickable(datElement));
            element.Clear();
            element.EnterText(currentDate);
        }

        ///<summary>
        ///Extended method for entering the current date
        ///</summary>
        ///<param name="datElement"></param>
        public static void enterCurrentDate(By datElement)
        {
            try
            {
                currentDate = DateTime.Now.ToString("MM/dd/yyyy");
                Driver.Wait(TimeSpan.FromMinutes(15));
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(datElement));
                Thread.Sleep(120);
                element.EnterText(currentDate);
                element.SendKeys(Keys.Tab);
                Thread.Sleep(120);
                otherErrorString = currentDate;
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", datElement);
                currentDate = DateTime.Now.ToString("MM/dd/yyyy");
                Driver.Wait(TimeSpan.FromMinutes(15));
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(datElement));
                element.EnterText(currentDate);
                element.SendKeys(Keys.Tab);
                Driver.Wait(TimeSpan.FromMinutes(5));
                otherErrorString = currentDate;
            }
        }

        ///<summary>
        ///Extended method for entering the current date
        ///</summary>
        ///<param name="datElement"></param>
        public static void enterDateBack30Days(By datElement)
        {
            try
            {
                int rDays = 30;
                currentDate = DateTime.Now.AddDays(-rDays).ToString("MM/dd/yyyy");
                Driver.Wait(TimeSpan.FromMinutes(15));
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(datElement));
                element.EnterText(currentDate);
                element.SendKeys(Keys.Tab);
                Driver.Wait(TimeSpan.FromMinutes(5));
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", datElement);
                int rDays = 30;
                DateTime.Now.AddDays(-rDays).ToString("MM/dd/yyyy");
                Driver.Wait(TimeSpan.FromMinutes(15));
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(datElement));
                element.EnterText(currentDate);
                element.SendKeys(Keys.Tab);
                Driver.Wait(TimeSpan.FromMinutes(5));
            }
        }

        ///<summary>
        ///Extended method for entering the current date
        ///</summary>
        ///<param name="datElement"></param>
        public static void enterDateBack45Days(By datElement)
        {
            try
            {
                int rDays = 45;
                currentDate = DateTime.Now.AddDays(-rDays).ToString("MM/dd/yyyy");
                Driver.Wait(TimeSpan.FromMinutes(15));
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(datElement));
                element.EnterText(currentDate);
                element.SendKeys(Keys.Tab);
                Driver.Wait(TimeSpan.FromMinutes(5));
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", datElement);
                int rDays = 45;
                DateTime.Now.AddDays(-rDays).ToString("MM/dd/yyyy");
                Driver.Wait(TimeSpan.FromMinutes(15));
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(datElement));
                element.EnterText(currentDate);
                element.SendKeys(Keys.Tab);
                Driver.Wait(TimeSpan.FromMinutes(5));
            }
        }

        ///<summary>
        ///Extended method for entering a date 7 days back
        ///</summary>
        ///<param name="datElement"></param>
        public static void enterDateBack7Days(By datElement)
        {
            try
            {
                int rDays = 7;
                currentDate = DateTime.Now.AddDays(-rDays).ToString("MM/dd/yyyy");
                Driver.Wait(TimeSpan.FromMinutes(15));
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(datElement));
                element.EnterText(currentDate);
                element.SendKeys(Keys.Tab);
                Driver.Wait(TimeSpan.FromMinutes(5));
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", datElement);
                int rDays = 45;
                DateTime.Now.AddDays(-rDays).ToString("MM/dd/yyyy");
                Driver.Wait(TimeSpan.FromMinutes(15));
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(datElement));
                element.EnterText(currentDate);
                element.SendKeys(Keys.Tab);
                Driver.Wait(TimeSpan.FromMinutes(5));
            }
        }

        ///<summary>
        ///Extended method for entering the number of days in the past
        ///</summary>
        ///<param name="datElement"></param>
        public static void enterPastDate(By datElement, int value)
        {
            try
            {
                int rDays = value;
                currentDate = DateTime.Now.AddDays(-rDays).ToString("MM/dd/yyyy");
                Driver.Wait(TimeSpan.FromMinutes(15));
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(datElement));
                element.EnterText(currentDate);
                element.SendKeys(Keys.Tab);
                Thread.Sleep(5000);
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", datElement);
                int rDays = value;
                DateTime.Now.AddDays(-rDays).ToString("MM/dd/yyyy");
                Driver.Wait(TimeSpan.FromMinutes(15));
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(datElement));
                element.EnterText(currentDate);
                element.SendKeys(Keys.Tab);
                Thread.Sleep(5000);
            }
        }

        ///<summary>
        ///Extended method for entering the number of days in the future
        ///</summary>
        ///<param name="datElement"></param>
        public static void enterFutureDate(By datElement, int value)
        {
            try
            {
                int rDays = value;
                currentDate = DateTime.Now.AddDays(+rDays).ToString("MM/dd/yyyy");
                Driver.Wait(TimeSpan.FromMinutes(15));
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(datElement));
                element.EnterText(currentDate);
                element.SendKeys(Keys.Tab);
                Driver.Wait(TimeSpan.FromMinutes(5));
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", datElement);
                int rDays = value;
                DateTime.Now.AddDays(-rDays).ToString("MM/dd/yyyy");
                Driver.Wait(TimeSpan.FromMinutes(15));
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(datElement));
                element.EnterText(currentDate);
                element.SendKeys(Keys.Tab);
                Driver.Wait(TimeSpan.FromMinutes(5));
            }
        }

        ///<summary>
        ///Extended method for entering the current date
        ///</summary>
        ///<param name="datElement"></param>
        public static void enterDate30DaysAhead(By datElement)
        {
            try
            {
                int rDays = 30;
                currentDate = DateTime.Now.AddDays(rDays).ToString("MM/dd/yyyy");
                Driver.Wait(TimeSpan.FromMinutes(15));
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(datElement));
                element.EnterText(currentDate);
                element.SendKeys(Keys.Tab);
                Driver.Wait(TimeSpan.FromMinutes(5));
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", datElement);
                int rDays = 30;
                DateTime.Now.AddDays(rDays).ToString("MM/dd/yyyy");
                Driver.Wait(TimeSpan.FromMinutes(15));
                var element = wait.Until(ExpectedConditions.ElementToBeClickable(datElement));
                element.EnterText(currentDate);
                element.SendKeys(Keys.Tab);
                Driver.Wait(TimeSpan.FromMinutes(5));
            }
        }

        ///<summary>
        ///Extended method to enter a interger element value
        ///</summary>
        ///<param name="datElement"></param>
        ///<param name="value"></param>
        public static void enterIntObjectValue(By datElement, int value)
        {
            try
            {
                var element = wait.Until(ExpectedConditions.ElementIsVisible(datElement));
                Driver.Wait(TimeSpan.FromMinutes(10));
                element.EnterAmount(value);
                element.SendKeys(Keys.Tab);
                Thread.Sleep(120);
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", datElement);
                var element = wait.Until(ExpectedConditions.ElementIsVisible(datElement));
                Driver.Wait(TimeSpan.FromMinutes(10));
                element.EnterAmount(value);
                element.SendKeys(Keys.Tab);
                Thread.Sleep(120);
            }
        }

        ///<summary>
        ///Extended method to enter a interger element value
        ///</summary>
        ///<param name="datElement"></param>
        ///<param name="value"></param>
        public static void enterDoubleObjectValue(By datElement, double value)
        {
            try
            {
                var element = wait.Until(ExpectedConditions.ElementIsVisible(datElement));
                Driver.Wait(TimeSpan.FromMinutes(10));
                element.EnterDoubleAmount(value);
                Thread.Sleep(120);
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", datElement);
                var element = wait.Until(ExpectedConditions.ElementIsVisible(datElement));
                Driver.Wait(TimeSpan.FromMinutes(10));
                element.EnterDoubleAmount(value);
                Thread.Sleep(120);
            }
        }

        ///<summary>
        ///Extended method to enter a text element value
        ///</summary>
        ///<param name="txtElement"></param>
        ///<param name="value"></param>
        public static void enterObjectValue(By txtElement, string value)
        {
            try
            {
                Thread.Sleep(2000);
                var element = wait.Until(ExpectedConditions.ElementIsVisible(txtElement));
                element.EnterText(value);
                //element.SendKeys(Keys.Enter);
                Thread.Sleep(2000);
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", txtElement);
                var element = wait.Until(ExpectedConditions.ElementIsVisible(txtElement));
                Driver.Wait(TimeSpan.FromMinutes(10));
                element.EnterText(value);
                Thread.Sleep(120);
            }
        }

        ///<summary>
        ///Extended method to select a value by typing in the dropdown list
        ///</summary>
        ///<param name="txtElement"></param>
        ///<param name="value"></param>
        public static void enterObjectDropdownListValue(By ddlElement, string value)
        {
            try
            {
                var element = wait.Until(ExpectedConditions.ElementIsVisible(ddlElement));
                Driver.Wait(TimeSpan.FromMinutes(10));
                element.Click();
                Driver.Wait(TimeSpan.FromMinutes(10));
                element.EnterText(value);
                Driver.Wait(TimeSpan.FromMinutes(10));
                element.SendKeys(Keys.Tab);
                Thread.Sleep(1000);
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", ddlElement);
                var element = wait.Until(ExpectedConditions.ElementIsVisible(ddlElement));
                Driver.Wait(TimeSpan.FromMinutes(10));
                element.Click();
                Driver.Wait(TimeSpan.FromMinutes(10));
                element.EnterText(value);
                Driver.Wait(TimeSpan.FromMinutes(10));
                element.SendKeys(Keys.Tab);
                Thread.Sleep(1000);
            }
        }

        ///<summary>
        ///Extended method to enter a text element value returned as a String
        ///</summary>
        ///<param name="txtElement"></param>
        ///<param name="value"></param>
        public static String enterStringObjectValue(By txtElement, string value)
        {
            try
            {
                var element = wait.Until(ExpectedConditions.ElementIsVisible(txtElement));
                Thread.Sleep(2000);
                element.EnterText(value);
                Thread.Sleep(2000);
                return eidssCaseID = value;
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", txtElement);
                var element = wait.Until(ExpectedConditions.ElementIsVisible(txtElement));
                Driver.Wait(TimeSpan.FromMinutes(10));
                element.EnterText(value);
                Thread.Sleep(120);
                return eidssCaseID = value;
            }
        }

        ///<summary>
        ///Extended method to enter a random Date of Birth
        ///</summary>
        ///<param name="datElement"></param>
        public static void randomEnterDOB(By datElement)
        {
            try
            {
                var DOB = wait.Until(ExpectedConditions.ElementIsVisible(datElement));
                int rNum = rnd.Next(5, 100);

                string curDate = DateTime.Now.AddYears(-rNum).ToString("MM/dd/yyyy");
                DOB.EnterText(curDate);
                Driver.Wait(TimeSpan.FromMinutes(5));
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", datElement);
                var DOB = wait.Until(ExpectedConditions.ElementIsVisible(datElement));
                int rNum = rnd.Next(-5, -100);

                string curDate = DateTime.Now.AddYears(rNum).ToString("dd/MM/yyyy");
                DOB.EnterText(curDate);
                Driver.Wait(TimeSpan.FromMinutes(5));

            }
        }

        /////<summary>
        /////Extended method to verify EIDSS error message displays
        /////</summary>
        /////<param name="element"></param>
        //public static String doesValidationErrorMessageDisplay(By element)
        //{
        //    try
        //    {
        //        if (Driver.Instance.FindElement(element).Displayed)
        //        {
        //            Driver.Wait(TimeSpan.FromMinutes(20));
        //            string text = wait.Until(ExpectedConditions.ElementIsVisible(element)).Text;
        //            errorString = text;
        //        }
        //    }
        //    catch
        //    {
        //        //Fails the test if error message does not display
        //        Assert.Fail("Message does not display.");
        //    }
        //    return errorString;
        //}

        ///<summary>
        ///Extended method to verify EIDSS error message displays
        ///</summary>
        ///<param name="element"></param>
        public static void isFieldPopulated(By element)
        {
            try
            {
                Driver.Wait(TimeSpan.FromMinutes(20));
                string text = wait.Until(ExpectedConditions.ElementIsVisible(element)).GetAttribute("value");
                errorString = text;
            }
            catch
            {
                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail();
            }
        }

        ///<summary>
        ///Extended method to verify EIDSS error message displays
        ///</summary>
        ///<param name="element"></param>
        public static void isFieldPopulatedWithText(By element)
        {
            try
            {
                Driver.Wait(TimeSpan.FromMinutes(20));
                string text = wait.Until(ExpectedConditions.ElementIsVisible(element)).Text;
                errorString = text;
            }
            catch
            {
                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail();
            }
        }

        ///<summary>
        ///Extended method to enter a random Date of Birth int value over 100
        ///</summary>
        ///<param name="datElement"></param>
        ///<param name="intElement"></param>
        public static void randomEnterDOBOver100(By datElement, int intElement)
        {
            try
            {
                var DOB = wait.Until(ExpectedConditions.ElementIsVisible(datElement));
                int rNum = rnd.Next(100, 250);
                intElement = rNum;

                string curDate = DateTime.Now.AddYears(-rNum).ToString("dd/MM/yyyy");
                DOB.EnterText(curDate);
                Driver.Wait(TimeSpan.FromMinutes(5));
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", datElement);
                var DOB = wait.Until(ExpectedConditions.ElementIsVisible(datElement));
                int rNum = rnd.Next(100, 250);
                intElement = rNum;

                string curDate = DateTime.Now.AddYears(-rNum).ToString("dd/MM/yyyy");
                DOB.EnterText(curDate);
                Driver.Wait(TimeSpan.FromMinutes(5));

            }
        }

        ///<summary>
        ///Extended method to check if field is enabled
        ///</summary>
        ///<param name="ddlElement"></param>
        public static Boolean isFieldEnabled(IWebElement ddlElement)
        {
            try
            {
                Driver.Wait(TimeSpan.FromMinutes(10));
                ddlElement.GetAttribute("enabled");
                return true;
            }
            catch (Exception)
            {
                Console.WriteLine("Field is not enabled");
                return false;
            }
        }

        ///<summary>
        ///Extended method to check if field is disabled
        ///</summary>
        ///<param name="ddlElement"></param>
        public static Boolean isFieldDisabled(IWebElement ddlElement)
        {
            try
            {
                Driver.Wait(TimeSpan.FromMinutes(10));
                ddlElement.GetAttribute("disabled");
                return true;
            }
            catch (Exception)
            {
                Console.WriteLine("Field is not disabled");
                return false;
            }
        }

        ///<summary>
        ///Extended method to check if field is enabled
        ///</summary>
        ///<param name="element"></param>
        public static Boolean isFieldEnabled(By element)
        {
            try
            {
                var text = wait.Until(ExpectedConditions.ElementToBeClickable(element)).GetAttribute("enabled");
                return true;
            }
            catch (Exception)
            {
                Assert.Fail("Field is not enabled");
                return false;
            }
        }

        ///<summary>
        ///Extended method to check if field is disabled
        ///</summary>
        ///<param name="element"></param>
        public static Boolean isFieldDisabled(By element)
        {
            try
            {
                var text = wait.Until(ExpectedConditions.ElementIsVisible(element)).GetAttribute("disabled");
                return true;
            }
            catch (Exception)
            {
                Assert.Fail("Field is not disabled");
                return false;
            }
        }

        ///<summary>
        ///Extended method for generating random double number for Latitude and Longitude
        ///</summary>
        ///<param></param>
        public static double RandomDoubleNum()
        {
            Random rnd = new Random();
            double lon = rnd.Next(516400146, 630304598);
            return lon;
        }

        public static void RandomSelectElement(IList<IWebElement> elements, IWebElement element)
        {
            Random rnd = new Random();
            int randomValue = rnd.Next(1, (elements.Count));
            element = elements[randomValue];
        }

        //public static void randomSelectElement(IList<IWebElement> elements, string element)
        //{
        //    Random rnd = new Random();
        //    int randomValue = rnd.Next(1, (elements.Count));
        //    element = elements[randomValue];
        //}

        ///<summary>
        ///Extended method for generating random phone number
        ///</summary>
        ///<param></param>
        public static string GetRandomTelNo()
        {
            StringBuilder telNo = new StringBuilder(12);
            Random rand = new Random();
            int number;
            for (int i = 0; i < 3; i++)
            {
                number = rand.Next(0, 8); // digit between 0 (incl) and 8 (excl)
                telNo = telNo.Append(number.ToString());
            }
            telNo = telNo.Append(" ");
            number = rand.Next(0, 743); // number between 0 (incl) and 743 (excl)
            telNo = telNo.Append(String.Format("{0:D3}", number));
            telNo = telNo.Append(" ");
            number = rand.Next(0, 10000); // number between 0 (incl) and 10000 (excl)
            telNo = telNo.Append(String.Format("{0:D4}", number));
            return telNo.ToString();
        }

        ///<summary>
        ///Extended method for generating random phone number
        ///</summary>
        ///<param name="driver"></param>
        public static void SwitchWindow(IWebDriver driver)
        {
            foreach (String windowName in driver.WindowHandles)
            {
                //IWebDriver popup = driver.SwitchTo().Window();
            }
        }

        ///<summary>
        ///Extended method for selecting object from dropdown list by typing in the value
        ///</summary>
        ///<param name="driver"></param>

        public static void selectObjectFromDropdownList(By element, IList<IWebElement> elements, string selStatus)
        {
            var stat = wait.Until(ExpectedConditions.ElementToBeClickable(element));
            Driver.Wait(TimeSpan.FromMinutes(10));
            stat.Click();

            foreach (var opt in elements)
            {
                if (opt.Text.Contains(selStatus))
                {
                    wait.Until(ExpectedConditions.ElementToBeClickable(opt));
                    opt.Click();
                    break;
                }
            }
        }

        public static void acceptCancelMessage()
        {
            //Switch to new window
            string newWindowHandle = Driver.Instance.WindowHandles.Last();
            var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);

            clickObjectButtons(modYesMessage);
        }

        public static void declineCencelMessage()
        {
            //Switch to new window
            string newWindowHandle = Driver.Instance.WindowHandles.Last();
            var newWindow = Driver.Instance.SwitchTo().Window(newWindowHandle);

            clickObjectButtons(modNoMessage);
        }

        public static void acceptMessage()
        {
            try
            {
                IAlert alert = Driver.Instance.SwitchTo().Alert();
                alert.Accept();
            }
            catch
            {
                Assert.Fail();
            }
        }

        public static void declineMessage()
        {
            try
            {
                IAlert alert = Driver.Instance.SwitchTo().Alert();
                alert.Dismiss(); ;
            }
            catch
            {
                Assert.Fail();
            }
        }


        ///<summary>
        ///Extended method to get number of rows in the table
        ///</summary>
        ///<param name="element"></param>
        public static int GetNumberOfRowsInTable(By element)
        {
            var table = wait.Until(ExpectedConditions.ElementIsVisible(element));
            IList<IWebElement> rows = table.FindElements(By.TagName("tr"));
            rows.RemoveAt(0);
            return numberOfRows = rows.Count;
        }

        ///<summary>
        ///Extended method to get number of rows in the table
        ///</summary>
        ///<param name="element"></param>
        public static int GetNumberOfRowsInTableBefore(By element)
        {
            var table = wait.Until(ExpectedConditions.ElementIsVisible(element));
            IList<IWebElement> rows = table.FindElements(By.TagName("tr"));
            rows.RemoveAt(0);
            return numberOfRows1 = rows.Count;
        }

        ///<summary>
        ///Extended method to get number of rows in the table
        ///</summary>
        ///<param name="element"></param>
        public static int GetNumberOfRowsInTableAfter(By element)
        {
            var table = wait.Until(ExpectedConditions.ElementIsVisible(element));
            IList<IWebElement> rows = table.FindElements(By.TagName("tr"));
            return numberOfRows2 = rows.Count;
        }

        ///<summary>
        ///Extended method calculate a random minimum latitude
        ///</summary>
        ///<param name="element"></param>
        public static void enterRandomMinLatitude(By element)
        {
            try
            {
                var el = wait.Until(ExpectedConditions.ElementIsVisible(element));
                el.EnterDoubleAmount(Convert.ToDouble("44." + SetMethods.RandomDoubleNum()));
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", element);
                var el = wait.Until(ExpectedConditions.ElementIsVisible(element));
                el.EnterDoubleAmount(Convert.ToDouble("44." + SetMethods.RandomDoubleNum()));
            }
        }

        ///<summary>
        ///Extended method calculate a random maximum latitude
        ///</summary>
        ///<param name="element"></param>
        public static void enterRandomMaxLatitude(By element)
        {
            try
            {
                var el = wait.Until(ExpectedConditions.ElementIsVisible(element));
                el.EnterDoubleAmount(Convert.ToDouble("44." + SetMethods.RandomDoubleNum()));
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", element);
                var el = wait.Until(ExpectedConditions.ElementIsVisible(element));
                el.EnterDoubleAmount(Convert.ToDouble("44." + SetMethods.RandomDoubleNum()));
            }
        }

        ///<summary>
        ///Extended method calculate a random minimum longitude
        ///</summary>
        ///<param name="element"></param>
        public static void enterRandomMinLongitude(By element)
        {
            try
            {
                var el = wait.Until(ExpectedConditions.ElementIsVisible(element));
                el.EnterDoubleAmount(Convert.ToDouble("-29." + SetMethods.RandomDoubleNum()));
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", element);
                var el = wait.Until(ExpectedConditions.ElementIsVisible(element));
                el.EnterDoubleAmount(Convert.ToDouble("-29." + SetMethods.RandomDoubleNum()));
            }
        }

        ///<summary>
        ///Extended method calculate a random maximum longitude
        ///</summary>
        ///<param name="element"></param>
        public static void enterRandomMaxLongitude(By element)
        {
            try
            {
                var el = wait.Until(ExpectedConditions.ElementIsVisible(element));
                el.EnterDoubleAmount(Convert.ToDouble("-36." + SetMethods.RandomDoubleNum()));
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", element);
                var el = wait.Until(ExpectedConditions.ElementIsVisible(element));
                el.EnterDoubleAmount(Convert.ToDouble("-36." + SetMethods.RandomDoubleNum()));
            }
        }

        ///<summary>
        ///Extended method calculate a random elevation with a range
        ///</summary>
        ///<param name="element"></param>
        public static void enterRandomElevation(By element)
        {
            try
            {
                int rNum = rnd.Next(-1000, 11000);

                var el = wait.Until(ExpectedConditions.ElementToBeClickable(element));
                el.EnterAmount(rNum);
                Driver.Wait(TimeSpan.FromMinutes(1000));
            }
            catch
            {
                ((IJavaScriptExecutor)Driver.Instance).ExecuteScript("arguments[0].scrollIntoView(true);", element);
                int rNum = rnd.Next(0, 10000);

                var el = wait.Until(ExpectedConditions.ElementToBeClickable(element));
                el.EnterAmount(rNum);
                Driver.Wait(TimeSpan.FromMinutes(1000));
            }
        }

        ///<summary>
        ///Extended method to verify that element was removed from the list
        ///</summary>
        ///<param name="element"></param>
        public static bool isElementNotPresent(IList<IWebElement> elements, string value)
        {
            if (elements.Count > 0)
            {
                foreach (IWebElement col in elements)
                {
                    if (col.Text.Contains(value))
                    {
                        //Fails test if name display in list
                        Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                        Assert.Fail(value + " was not removed from the table.");
                        break;
                    }
                }
                return false;
            }
            else
            {
                Assert.Pass(value + " was removed from the list successfully.");
            }
            return false;
        }

        ///<summary>
        ///Extended method to verify that element displays in the list
        ///</summary>
        ///<param name="element"></param>
        public static bool isElementPresent(IList<IWebElement> elements, string value)
        {
            if (elements.Count > 0)
            {
                foreach (IWebElement col in elements)
                {
                    if (col.Text.Contains(value))
                    {
                        Assert.Pass(value + " displays in the list successfully.");
                        break;
                    }
                }
                return true;
            }
            else
            {
                //Fails test if name display in list
                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
                Assert.Fail(value + " record does not display in the list.");
            }
            return false;
        }

        ///<summary>
        ///Extended method to edit a value in the grid table
        ///</summary>
        ///<param name="val"></param>
        ///<param name="value"></param>
        public static void EditRefValue(By val, String value)
        {
            int codeValue = rnd.Next(01, 99);
            SetMethods.enterObjectValue(val, value + codeValue);
            refValue2 = value + codeValue;
        }

        ///<summary>
        ///Extended method to get the current value in the grid table by attribute
        ///</summary>
        ///<param name="value"></param>
        public static void GetCurrentValue(By value)
        {
            Driver.Wait(TimeSpan.FromMinutes(20));
            string text = wait.Until(ExpectedConditions.ElementIsVisible(value)).GetAttribute("value");
            refValue1 = text;
        }

        ///<summary>
        ///Extended method to get the current value in the grid table by attribute
        ///</summary>
        ///<param name="value"></param>
        public static void GetCurrentValue2(By value)
        {
            Driver.Wait(TimeSpan.FromMinutes(20));
            string text = wait.Until(ExpectedConditions.ElementIsVisible(value)).GetAttribute("value");
            refValue8 = text;
        }

        ///<summary>
        ///Extended method to get the new value in the grid table by text
        ///</summary>
        ///<param name="value"></param>
        public static void GetNewvalue(By value)
        {
            Driver.Wait(TimeSpan.FromMinutes(20));
            string text = wait.Until(ExpectedConditions.ElementIsVisible(value)).Text;
            refValue2 = text;
        }

        ///<summary>
        ///Extended method to get the new integer value in the grid table by text and covert to integer
        ///</summary>
        ///<param name="value"></param>
        public static void GetNewIntValue2(By value)
        {
            Driver.Wait(TimeSpan.FromMinutes(20));
            string text = wait.Until(ExpectedConditions.ElementIsVisible(value)).Text;
            refValue3 = int.Parse(text);
        }

        ///<summary>
        ///Extended method to get the new integer value in the grid table by text and covert to integer
        ///</summary>
        ///<param name="value"></param>
        public static void GetNewvalue4(By value)
        {
            Driver.Wait(TimeSpan.FromMinutes(20));
            string text = wait.Until(ExpectedConditions.ElementIsVisible(value)).Text;
            refValue4 = text;
        }

        ///<summary>
        ///Extended method to get the new integer value in the grid table by text and covert to integer
        ///</summary>
        ///<param name="value"></param>
        public static void GetNewIntValue5(By value)
        {
            Driver.Wait(TimeSpan.FromMinutes(20));
            string text = wait.Until(ExpectedConditions.ElementIsVisible(value)).Text;
            refValue5 = int.Parse(text);
        }

        ///<summary>
        ///Extended method to get the new integer value in the grid table by text and covert to integer
        ///</summary>
        ///<param name="value"></param>
        public static void GetNewIntValue6(By value)
        {
            Driver.Wait(TimeSpan.FromMinutes(20));
            string text = wait.Until(ExpectedConditions.ElementIsVisible(value)).Text;
            refValue6 = int.Parse(text);
        }

        ///<summary>
        ///Extended method to get the new integer value in the grid table by text and covert to integer
        ///</summary>
        ///<param name="value"></param>
        public static String GetNewValue7(By value)
        {
            Driver.Wait(TimeSpan.FromMinutes(20));
            string text = wait.Until(ExpectedConditions.ElementIsVisible(value)).Text;
            return refValue7 = text;
        }

        ///<summary>
        ///Extended method to get the new integer value in the grid table by text and covert to integer
        ///</summary>
        ///<param name="value"></param>
        public static String GetNewValue8(By value)
        {
            Driver.Wait(TimeSpan.FromMinutes(20));
            string text = wait.Until(ExpectedConditions.ElementIsVisible(value)).Text;
            return refValue8 = text;
        }

    }
}