using EIDSS.Client.Abstracts;
using EIDSS.Client.Requests;
using EIDSS.Client.Responses;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Return_Contracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace EIDSS.Client.API_Clients
{
    public class NotificationServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(NotificationServiceClient));

        /// <summary>
        /// Instantiates a new instance of the object.
        /// This contructor overrides the base constructor.
        /// </summary>
        public NotificationServiceClient() : base()
        {
        }


        public async Task<List<ConfGetEventSubcriptionTypesGetModel>>GetEventSubriptionTypes(string languageId)
        {
            log.Info("GetEventSubriptionTypes is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-EVENTSUBSCRIPTIONTYPES-GET"));

                builder.Query = string.Format("languageId={0}", Convert.ToString(languageId));

                var response =  _apiclient.GetAsync(builder.Uri).Result;
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfGetEventSubcriptionTypesGetModel>();
                }
                log.Info("GetEventSubriptionTypes returned");
                return JsonConvert.DeserializeObject<List<ConfGetEventSubcriptionTypesGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception ex)
            {
                log.Error("Error GetEventSubriptionTypes is called: " + ex.Message);
                throw;
            }

        }
    }
}
