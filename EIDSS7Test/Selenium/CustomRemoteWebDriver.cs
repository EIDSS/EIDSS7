using OpenQA.Selenium.Remote;
using System;
using System.Collections.Generic;
using System.IO;

namespace EIDSS7Test.Selenium
{
    public class CustomRemoteWebDriver : RemoteWebDriver
    {
        public static bool newSession = false;
        public static string capPath = @"C:\NGDEV\EIDSS7\EIDSS7Test\sessionCap";
        public static string sessiondIdPath = @"C:\NGDEV\EIDSS7\EIDSS7Test\sessionID";

        //Override constructor
        public CustomRemoteWebDriver(Uri remoteAddress, DesiredCapabilities desiredCapabilities)
            : base(remoteAddress, desiredCapabilities)
        {


        }

        /// Store for the name property.
        /// 
        /// A  value representing the command to execute.
        /// A  containing the names and values of the parameters of the command.
        /// 
        /// A  containing information about the success or failure of the command and any data returned by the command.
        /// 
        protected override Response Execute(string driverCommandToExecute, Dictionary<string, object> parameters)
        {
            if (driverCommandToExecute == DriverCommand.NewSession)
            {
                if (!newSession)
                {
                    var sidText = File.ReadAllText(sessiondIdPath);

                    return new Response
                    {
                        SessionId = sidText,

                    };
                }
                else
                {
                    var response = base.Execute(driverCommandToExecute, parameters);

                    File.WriteAllText(sessiondIdPath, response.SessionId);
                    return response;
                }
            }
            else
            {
                var response = base.Execute(driverCommandToExecute, parameters);
                return response;
            }
        }
    }
}
