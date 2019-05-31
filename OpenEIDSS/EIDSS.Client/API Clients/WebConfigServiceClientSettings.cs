using EIDSS.Client.Abstracts;
using Newtonsoft.Json;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Domain.Return_Contracts;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Threading.Tasks;

namespace EIDSS.Client.API_Clients
{
    public class WebConfigServiceClientSettings : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(WebConfigServiceClientSettings));

        public WebConfigServiceClientSettings() : base()
        {
        }

        public string GetEnvironment()
        {
            log.Info("GetEnvironment is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            var serverUri = string.Empty;
            try
            {
                serverUri = Settings.ServerUri;
            }
            catch (Exception e)
            {
                log.Error("GetEnvironment failed", e);
                throw e;
            }
            return serverUri;
        }

    }
}
