using NUnit.Framework;
using NUnit.Framework.Interfaces;
using NUnit.Framework.Api;
using RelevantCodes.ExtentReports;
using System.Diagnostics;
using EIDSS7Test.Selenium;

namespace EIDSS7Test.Reports
{
    public class ReportingTasks
    {
        private ExtentReports _extent;
        private ExtentTest _test;

        /// <summary>
        /// Initializes a new instance of the<see cref="ReportingTasks"/> class.
        /// </summary>
        /// <param name = "extentInstance" > The extent instance.</param>
        public ReportingTasks(ExtentReports extentInstance)
        {
            _extent = extentInstance;
        }

        /// <summary>
        /// Initializes the test for reporting.
        /// runs at the beginning of every test
        /// </summary>
        //public void InitializeTest()
        //{
        //    _test = _extent.StartTest(TestContext.CurrentContext.Test.Name);
        //}

        /// <summary>
        /// Finalizes the test.
        /// Runs at the end of every test
        /// </summary>
        public void FinalizeTest()
        {
            //var status = TestContext.CurrentContext.Result.StackTrace;
            //var stacktrace = string.IsNullOrEmpty(TestContext.CurrentContext.Result.StackTrace)
            //    ? ""
            //    : string.Format("<pre>{0}</pre>", TestContext.CurrentContext.Result.Message);
            var status = TestContext.CurrentContext.Result.Outcome.Status;

            var message = string.IsNullOrEmpty(TestContext.CurrentContext.Result.Message)
                ? string.Empty
                : $"<pre>{TestContext.CurrentContext.Result.Message}</pre>";

            var stacktrace = string.IsNullOrEmpty(TestContext.CurrentContext.Result.StackTrace)
                    ? string.Empty
                    : $"<pre>{TestContext.CurrentContext.Result.StackTrace}</pre>";
            LogStatus logstatus;

            switch (status)
            {
                case TestStatus.Failed:
                    logstatus = LogStatus.Fail;
                    break;
                case TestStatus.Inconclusive:
                    logstatus = LogStatus.Warning;
                    break;
                case TestStatus.Skipped:
                    logstatus = LogStatus.Skip;
                    break;
                default:
                    logstatus = LogStatus.Pass;
                    break;
            }
            _test.Log(logstatus, "Test ended with " + logstatus + stacktrace);
            _extent.EndTest(_test);
            _extent.Flush();
        }

        /// <summary>
        /// Cleans up reporting.
        /// Runs after all the test finishes
        /// </summary>
        public void CleanUpReporting()
        {
            //Driver.Instance.Close();
        }

        public enum Proc
        {
            ie,
            cr,
            ff,
            edge,
            opera
        }

        private static void KillProcess(Proc webProcess)
        {
            switch (webProcess)
            {
                case Proc.cr:
                    KillProcessByName("chromedriver");
                    KillProcessByName("Chrome.Instance");
                    KillProcessByName("chrome");
                    break;
                case Proc.ie:
                    KillProcessByName("iexplore");
                    KillProcessByName("IEDriverServer");
                    break;
                case Proc.ff:
                    KillProcessByName("firefox");
                    break;
                case Proc.edge:
                    KillProcessByName("Microsoft.Edge");
                    break;
                case Proc.opera:
                    KillProcessByName("operadriver");
                    KillProcessByName("opera");
                    break;
            }
        }

        private static void KillProcessByName(string processName)
        {
            foreach (Process process in Process.GetProcessesByName(processName))
            { process.Kill(); }
        }
    }
}
