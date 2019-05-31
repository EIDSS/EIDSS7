using OpenEIDSS.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using WebApi.OutputCache.V2;
using System.Collections;
using System.Collections.Generic;
using OpenEIDSS.Domain;
using System.Data.SqlClient;
using OpenEIDSS.Extensions.Attributes;
using Newtonsoft.Json;
using OpenEIDSS.Domain.Return_Contracts;
using OpenEIDSS.Domain.Parameter_Contracts;
using System.Web.Http.Cors;
using System;
using EIDSS.Client.API_Clients;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// Responsible for Notifications and Alerts
    /// </summary>
    [RoutePrefix("api/Configuration")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class NotificationController : ApiController
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(NotificationController));
        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// Instantiates a new Instance Of Class -- Contructor 
        /// </summary>
        public NotificationController()
        {

        }
        /// <summary>
        /// Returns List of Subscription Event Types for Notifications
        /// </summary>
        /// <param name="strLanguageId"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfGetEventSubcriptionTypesGetModel>))]
        [HttpGet, Route("GetEventSubscriptionTypes")]
        public async Task<IHttpActionResult> GetEventSubriptionTypes(string languageId)
        {
            log.Info("GetEventSubscriptionTypes is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfGetEventSubcriptionTypesGetAsync(languageId);
                if (result == null)
                {
                    log.Info("Exiting  GetEventSubscriptionTypes With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {


                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in GetEventSubscriptionTypes Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetEventSubscriptionTypes" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetEventSubscriptionTypes");
            return Ok(returnResult);
        }
    }
}
