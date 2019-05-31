using System;
using System.Drawing.Imaging;
using OpenQA.Selenium;


namespace EIDSS7Test.Reports
{
    public class GetScreenShot
    {
        public static string Capture(IWebDriver driver, string screenShotName)
        {
            ITakesScreenshot ts = (ITakesScreenshot)driver;
            Screenshot screenshot = ts.GetScreenshot();
            string pth = System.Reflection.Assembly.GetCallingAssembly().CodeBase;
            string actualPath = pth.Substring(0, pth.LastIndexOf("bin"));
            string projectPath = new Uri(actualPath).LocalPath;
            string finalpth = projectPath + "HTMLReports\\snapshots\\" + screenShotName + ".png";
            string localpath = new Uri(finalpth).LocalPath;
            //screenshot.SaveAsFile(localpath, ScreenshotImageFormat.Png);
            screenshot.SaveAsFile(localpath, ImageFormat.Png);
            return localpath;
        }
    }
}
