using EIDSS.Client.Abstracts;
using OpenEIDSS.Domain;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Threading.Tasks;

namespace EIDSS.Client.API_Clients
{
    /// <summary>
    /// Client service that interacts with country specific functionality within the EIDSS Api.
    /// </summary>
    public class CountryServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(CountryServiceClient));

        public CountryServiceClient() : base()
        {
        }


    }
}
