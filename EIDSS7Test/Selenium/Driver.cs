using System;
using System.Configuration;
using System.Linq.Expressions;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Firefox;
using OpenQA.Selenium.IE;
using OpenQA.Selenium.Safari;
using OpenQA.Selenium.Opera;
using System.Diagnostics;
using OpenQA.Selenium.Support.UI;
using OpenQA.Selenium.Remote;
using System.Drawing.Imaging;
using OpenQA.Selenium.Edge;
using System.IO;

namespace EIDSS7Test.Selenium
{
    public static class Driver
    {
        public static IWebDriver Instance;
        private static Random rnd = new Random();
        //private static ISelenium sel;

        //private static string serverPath = "Microsoft Web Driver";

        public static void Initialize(Browser browser)
        {
            switch (browser)
            {
                case Browser.Edge:
                    Instance = new EdgeDriver(@"$/EIDSS7/packages/Selenium.WebDriver.MicrosoftWebDriver.10.0.17134/driver/");
                    break;
                case Browser.Firefox:
                    try
                    {
                        Uri uri = new Uri("http://localhost:7055/hub/");
                        Instance = new RemoteWebDriver(uri, DesiredCapabilities.Firefox());
                        Console.WriteLine("Executed on remote driver");
                    }
                    catch (Exception e)
                    {
                        Instance = new FirefoxDriver();
                        Console.WriteLine("Executed on New FireFox driver" + e.Message);
                    }
                    break;
                case Browser.Chrome:
                    //var DRIVER_PATH = @"$/EIDSS7\EIDSS7Test/";
                    ChromeOptions opts = new ChromeOptions();
                    opts.AddArguments("disable-infobars");
                    opts.AddUserProfilePreference("credentials_enable_service", false);
                    opts.AddUserProfilePreference("profile.password_manager_enabled", false);
                    //opts.AddArguments("headless");                  //Uncomment if running without a browser
                    //opts.AddArguments("--window-size=1325x744");    //Uncomment if running without a browser to ensure window is maximized in memory
                    //opts.BinaryLocation = @"$/EIDSS7/EIDSS7Test/ChromiumPortable/bin/chrome.exe";
                    Instance = new ChromeDriver(opts);
                    Console.WriteLine("Executed on New Chrome driver");
                    break;
            }
        }


        public static void Close()
        {
            //Instance.Close();
        }

        public static object BaseAddress
        {
            get
            {
                Driver.Wait(TimeSpan.FromMinutes(5));
                //return ("https://eidssdev.com/EIDSS/Login.aspx");       //Old EIDSS7 US Beta
                //return ("https://eidssdev.com/Armenia/Login.aspx");       //Old EIDSS7 AM Beta
                //return ("https://eidssdev.com/Georgia/Login.aspx");       //Old EIDSS7 GA Beta
                //return ("https://eidssdev.com/Azerbaijan/Login.aspx");       //Old EIDSS7 AJ Beta
                //return ("https://192.255.51.93/Georgia/Login.aspx");         // EIDSS7 GG Beta
                //return ("https://192.255.51.93/Azerbaijan/Login.aspx");         // EIDSS7 AJ Beta
                //return ("https://192.255.51.93/Armenia/Login.aspx");         // EIDSS7 AM Beta
                //return ("https://192.255.51.93/Thailand/Login.aspx");         // EIDSS7 TH Beta
                //return ("https://192.255.51.93/Ukraine/Login.aspx");         // EIDSS7 UK Beta
                //return ("https://192.255.51.93/Kazakhstan/Login.aspx");         // EIDSS7 KZ Beta
                //return ("https://192.255.51.93/Iraq/Login.aspx");         // EIDSS7 IQ Beta
                //return ("https://192.255.51.83/eidss/Login.aspx");       //EIDSS7 QA
                //return ("https://192.255.51.83/Georgia/Login.aspx");       //Georgian QA
                //return ("https://192.255.51.83/Azerbaijan/Login.aspx");       //Azerbaijan QA
                //return ("https://192.255.51.83/Armenia/Login.aspx");       //Armenia QA
                //return ("https://192.255.51.83/Thailand/Login.aspx");       //Thailand QA
                //return ("https://192.255.51.83/Kazakhstan/Login.aspx");      //Kazakhstan QA
                //return ("https://192.255.51.83/Ukraine/Login.aspx");         //Ukraine QA
                //return ("https://192.255.51.83/Iraq/Login.aspx");       //Iraq QA
                //return ("https://192.255.51.83/eidss7/Login.aspx");
                //return ("https://localhost:61173/");          //EIDSS7 InDev Dev
                return ("https://192.255.51.83:4000/EIDSSDevelopment/Login.aspx");
                //return ("https://192.255.51.83:4100/EIDSSIntegration/Login.aspx");  //DEV Integration Env
                //return ("https://192.255.51.83:101/EIDSSDevCompatibility/Login.aspx");      //DEV Compatibility Env
                //return ("https://192.255.51.83/EIDSSQAAJMigration/Login.aspx");  //QA AJ Migration Env
                //return ("https://192.255.51.83/EIDSSQAGGMigration/Login.aspx");  //QA GG Migration Env
                //return ("http://jqueryui.com/droppable/");
                //return ("http://jqueryui.com/resizable/");
            }
        }

        public static string TakeScreenShot(By element, string fileName)
        {
            string currentDate = DateTime.Now.ToString("ddd, ddMMMyyyy");
            string highlightJavascript = @"$(arguments[0]).css({ ""border-width"" : ""2px"", ""border-style"" : ""solid"", ""border-color"" : ""red"" });";
            var jsDriver = (IJavaScriptExecutor)Instance;
            jsDriver.ExecuteScript(highlightJavascript, new object[] { element });
            Screenshot ss = ((ITakesScreenshot)Instance).GetScreenshot();
            string dir = @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7Tests\Reports\snapshots\";
            //ss.SaveAsFile(dir + currentDate + fileName + ".png", ScreenshotImageFormat.Png);
            ss.SaveAsFile(dir + currentDate + fileName + ".png", ImageFormat.Png);
            return dir;
        }

        public static string TakeScreenShot(IWebElement element, string fileName)
        {
            string currentDate = DateTime.Now.ToString("ddd, ddMMMyyyy");
            string highlightJavascript = @"$(arguments[0]).css({ ""border-width"" : ""2px"", ""border-style"" : ""solid"", ""border-color"" : ""red"" });";
            var jsDriver = (IJavaScriptExecutor)Instance;
            jsDriver.ExecuteScript(highlightJavascript, new object[] { element });
            Screenshot ss = ((ITakesScreenshot)Instance).GetScreenshot();
            string dir = @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7Tests\Reports\snapshots\";
            //ss.SaveAsFile(dir + currentDate + fileName + ".png", ScreenshotImageFormat.Png);
            ss.SaveAsFile(dir + currentDate + fileName + ".png", ImageFormat.Png);
            return dir;
        }

        public static string Capture(IWebDriver driver, string screenShotName)
        {
            ITakesScreenshot ts = (ITakesScreenshot)driver;
            Screenshot screenshot = ts.GetScreenshot();
            int rNum = rnd.Next(0000, 99999);
            string currentDate = DateTime.Now.ToString("ddd, ddMMMyyyy");
            string pth = System.Reflection.Assembly.GetCallingAssembly().CodeBase;
            string actualPath = pth.Substring(0, pth.LastIndexOf("bin"));
            string projectPath = new Uri(actualPath).LocalPath;
            string finalpth = projectPath + "HTMLReports\\snapshots\\" + screenShotName + currentDate + rNum +".png";
            string localpath = new Uri(finalpth).LocalPath;
            //screenshot.SaveAsFile(localpath, ScreenshotImageFormat.Png);
            screenshot.SaveAsFile(localpath, ImageFormat.Png);
            return localpath;
        }


        //public static void TakeScreenShotHighlight()
        //{
        //    File screenshot = ((ITakesScreenshot)Instance).GetScreenshot(out.FILE);
        //    BufferedImage fullImg = ImageIO.read(screenshot);
        //    //Get the location of element on the page
        //    Point point = ele.getLocation();
        //    //Get width and height of the element
        //    int eleWidth = ele.getSize().getWidth();
        //    int eleHeight = ele.getSize().getHeight();
        //    //Crop the entire page screenshot to get only element screenshot
        //    BufferedImage eleScreenshot = fullImg.getSubimage(point.getX(), point.getY(), eleWidth,
        //        eleHeight);
        //    ImageIO.write(eleScreenshot, "png", screenshot);
        //    //Copy the element screenshot to disk
        //    FileUtils.copyFile(screenshot, new File("c:\\partial.png"))
        //}

        public static void KillWebBrowserProcess()
        {
            Process[] allProcesses = Process.GetProcesses();
            foreach (var process in allProcesses)
            {
                if (process.MainWindowTitle != "")
                {
                    string s = process.ProcessName.ToLower();
                    if (s == "iexplore")
                    {
                        KillProcessByName("iexplore.exe");
                        break;
                    }
                    else if (s == "chrome")
                    {

                        KillProcessByName("chromedriver.exe");
                        break;
                    }
                    else if (s == "firefox")
                    {
                        KillProcessByName("firefox");
                        break;
                    }
                    else if (s == "opera")
                    {
                        KillProcessByName("opera");
                        KillProcessByName("operadriver.exe");
                        break;
                    }
                }
            }
        }

        private static void KillProcessByName(string processName)
        {
            foreach (Process process in Process.GetProcessesByName(processName))
            { process.Kill(); }
        }

        public static void ScrollIntoView(IWebElement element)
        {
            IJavaScriptExecutor js = (IJavaScriptExecutor)Driver.Instance;
            js.ExecuteScript("arguments[0].scrollIntoView()", element);
        }

        public static void Wait(TimeSpan timespan)
        {
            TimeSpan timeout = new TimeSpan(20, 20, 60, 120);
            WebDriverWait wait = new WebDriverWait(Driver.Instance, timeout);
        }

        public static void SwitchToWindow(Expression<Func<IWebDriver, bool>> predicateExp)
        {
            var predicate = predicateExp.Compile();
            foreach (var handle in Driver.Instance.WindowHandles)
            {
                Driver.Instance.SwitchTo().Window(handle);
                if (predicate(Driver.Instance))
                {
                    return;
                }
            }
            throw new ArgumentException(string.Format("Unable to find window with condition: '{0}'", predicateExp.Body));
        }


        public static void WaitForPageToLoad(this IWebDriver driver)
        {
            TimeSpan timeout = new TimeSpan(20, 20, 60, 120);
            WebDriverWait wait = new WebDriverWait(driver, timeout);

            IJavaScriptExecutor javascript = driver as IJavaScriptExecutor;
            if (javascript == null)
                throw new ArgumentException("driver", "Driver must support javascript execution");

            wait.Until((d) =>
            {
                try
                {
                    string readyState = javascript.ExecuteScript(
                    "if (document.readyState) return document.readyState;").ToString();
                    return readyState.ToLower() == "complete";
                }
                catch (InvalidOperationException e)
                {
                    //Window is no longer available
                    return e.Message.ToLower().Contains("unable to get browser");
                }
                catch (WebDriverException e)
                {
                    //Browser is no longer available
                    return e.Message.ToLower().Contains("unable to connect");
                }
                catch (Exception)
                {
                    return false;
                }
            });
        }
    }
}
