using EIDSS7Test.Selenium;
using EIDSS7Test.Reports;
using NUnit.Framework;
using RelevantCodes.ExtentReports;
using System.Diagnostics;
using System.Threading;
using System;
using NUnit.Framework.Interfaces;

namespace EIDSS7Test.BaseScripts
{
    public class TestBase
    {
        private static ReportingTasks _reportingTasks;
        public static ExtentReports extent;
        public static ExtentTest test;
        private static Random rnd = new Random();

        [OneTimeSetUp]
        ///<summary>
        ///Run Before every Test and setup Tests.
        ///</summary>
        public void TestSetup()
        {
            BeginExecution();
            Driver.Initialize(Browser.Chrome);
            LoginPage.GoTo();
            Driver.Instance.WaitForPageToLoad();
            Thread.Sleep(120);
        }

        public static void BeginExecution()
        {
            //ExtentReports extentReports = ReportingManager.Instance;
            //extentReports.LoadConfig(Directory.GetParent(TestContext.CurrentContext.TestDirectory).Parent.FullName + "\\extent-config.xml");
            ////Note we have hardcoded the browser, we will deal with this later
            //extentReports.AddSystemInfo("Browser", "Firefox");
            //_reportingTasks = new ReportingTasks(extentReports);

            //To obtain the current solution path/project path
            string pth = System.Reflection.Assembly.GetCallingAssembly().CodeBase;
            string actualPath = pth.Substring(0, pth.LastIndexOf("bin"));
            string projectPath = new Uri(actualPath).LocalPath;

            //Append the html report file to current project path
            string reportPath = projectPath + "HTMLReports\\" + "EIDSSv70_EIDSSInteg_" + DateTime.Now.ToString("ddd, ddMMMyyyy HHmm") + ".html";

            //Boolean value for replacing exisisting report
            extent = new ExtentReports(reportPath, true);

            //Add QA system info to html report
            extent.AddSystemInfo("Sr. Principal Systems Test Engineer:", "Eva B. Tate")
                .AddSystemInfo("Environment:", "https://192.255.51.83:4000/EIDSSDevelopment/login.aspx")
                .AddSystemInfo("Build:", "65.4")
                .AddSystemInfo("Browser:", "Chrome")
                .AddSystemInfo("Username:", "demo");

            //Adding config.xml file
            extent.LoadConfig(projectPath + "extent-Config.xml"); //Get the config.xml file from http://extentreports.com
        }

        public void AfterClass()
        {
            //StackTrace details for failed Testcases
            var status = TestContext.CurrentContext.Result.Outcome.Status;
            var stackTrace = " + TestContext.CurrentContext.Result.StackTrace + ";
            var errorMessage = TestContext.CurrentContext.Result.Message;

            if (status == TestStatus.Failed)
            {
                //string screenShotPath = Driver.Capture(Driver.Instance, "ScreenShotName");
                //test.Log(LogStatus.Fail, "Snapshot below: " + test.AddScreenCapture(screenShotPath));
                test.Log(LogStatus.Fail, status + errorMessage);
                test.Log(LogStatus.Fail, stackTrace + errorMessage);
                Driver.Instance.Navigate().GoToUrl((string)Driver.BaseAddress);
            }

            //End test report
            extent.EndTest(test);
        }


        [TearDown]
        public void TestCleanUp()
        {
            AfterClass();

            Process[] allProcesses = Process.GetProcesses();
            foreach (var process in allProcesses)
            {
                if (process.MainWindowTitle != "")
                {
                    //string s = process.ProcessName.ToLower();
                    //if (s == "iexplore")
                    //{
                    //    KillProcessByName("iexplore");
                    //    KillProcessByName("IEDriverServer");
                    //    break;
                    //}
                    //if (s == "chrome")  //Uncomment when running in headless mode
                    //{
                    //    KillProcessByName("chrome");
                    //    KillProcessByName("chromeDriver.Instance");
                    //    KillProcessByName("chromedriver");
                    //    break;
                    //}
                    //if (s == "firefox")
                    //{
                    //    KillProcessByName("firefox");
                    //    KillProcessByName("geckodriver");
                    //    break;
                    //}
                    //else if (s == "MicrosoftEdge")
                    //{
                    //    KillProcessByName("MicrosoftWebDriver");
                    //    KillProcessByName("MicrosoftEdgeCP");
                    //    KillProcessByName("MicrosoftEdge");
                    //    break;
                    //}
                    //else if (s == "opera")
                    //{
                    //    KillProcessByName("opera");
                    //    KillProcessByName("operadriver");
                    //    break;
                    //}
                }
            }
        }


        [OneTimeTearDown]
        public void End()
        {
            extent.Flush();
            extent.Close();
            ExitExecution();
        }

        private static void KillProcessByName(string processName)
        {
            foreach (Process process in Process.GetProcessesByName(processName))
            { process.Kill(); }
        }


        /// <summary>
        /// Finish Execution of tests
        /// </summary>
        public static void ExitExecution()
        {
            _reportingTasks.CleanUpReporting();

        }
    }
}
