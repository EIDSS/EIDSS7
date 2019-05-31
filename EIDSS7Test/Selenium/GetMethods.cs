using System.Linq;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;

namespace EIDSS7Test.Selenium
{
    public class GetMethods
    {
        //Get values from controls
        public static string GetText(IWebElement element)
        {
            return element.GetAttribute("value");
        }


        public static string GetTextFromDropDown(IWebElement element)
        {
            return new SelectElement(element).AllSelectedOptions.SingleOrDefault().Text;
        }
    }
}
