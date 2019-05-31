using NUnit.Framework;
using RelevantCodes.ExtentReports;
using System;

namespace EIDSS7Test.Reports
{
    public class ReportingManager
    {
        /// <summary>
        /// Create new instance of Extent report
        /// </summary>
        private static readonly ExtentReports instance = new ExtentReports(TestContext.CurrentContext.TestDirectory + "\\EIDSS7Test" + DateTime.Now.ToString("ddd, ddMMMyyyy HHmm") + ".html");

        static ReportingManager() { }
        private ReportingManager() { }

        /// <summary>
        /// Property to return the instance of the report.
        /// </summary>
        /// <value>
        /// The instance.
        /// </value>
        public static ExtentReports Instance
        {
            get
            {
                return instance;
            }
        }
    }
}
