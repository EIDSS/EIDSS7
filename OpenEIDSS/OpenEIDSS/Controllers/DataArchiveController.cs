using OpenEIDSS.Extensions.Attributes;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Extensions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using WebApi.OutputCache.V2;
using OpenEIDSS.Domain.Return_Contracts;
using Newtonsoft.Json;
using System.Data.SqlClient;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// API responsible for Data Archive Settings Functionality
    /// </summary>
    [RoutePrefix("api/Configuration")]
    public class DataArchiveController : ApiController
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(DataArchiveController));
        private IEIDSSRepository _repository = new EIDSSRepository();
        /// <summary>
        /// Creates a new instance of this class.
        /// </summary>
        public DataArchiveController() : base()
        {
        }



        /// <summary>
        /// Returns Data Archive Settings for the System
        /// </summary>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetDataArchiveSettings")]
      
        public async Task<IHttpActionResult> GetDataArchiveSettingsList()
        {
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                log.Info("Entering  GetDataArchiveSettingsList");
                var result = await _repository.AdminConfDataArchiveSettingsGetAsync();
                if (result == null )
                {
                    log.Info("Exiting  GetDataArchiveSettingsList With Not Found");
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
                log.Error("SQL Error in GetDataArchiveSettingsList PROC: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetDataArchiveSettingsList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError; 
            }
            log.Info("Exiting  GetDataArchiveSettingsList");
            return Json(returnResult);
        }


        /// <summary>
        /// Saves Settings For Data Archiving for the System
        /// </summary>
        /// <param name="adminArchiveSettingsSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("SaveDataArchiveSettings")]
        [ResponseType(typeof(List<AdminConfDataArchiveSettingsSetModel>))]
        public IHttpActionResult SaveDataArchiveSettings(AdminArchiveSettingsSetParams adminArchiveSettingsSetParams)
        {
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                log.Info("Entering  SaveDataArchiveSettings");
                var result = _repository.AdminConfDataArchiveSettingsSet(
                    adminArchiveSettingsSetParams.archiveSettingUid,
                    adminArchiveSettingsSetParams.archiveBeginDate,
                    adminArchiveSettingsSetParams.archiveScheduledStartTime,
                    adminArchiveSettingsSetParams.dataAgeforArchiveInYears,
                    adminArchiveSettingsSetParams.archiveFrequencyInDays,
                    adminArchiveSettingsSetParams.auditCreateUser);
                if (result == null)
                {
                    log.Info("Exiting  SaveDataArchiveSettings With not Found");
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
                log.Error("SQL Error in SaveDataArchiveSettings PROC: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in SaveDataArchiveSettings" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  SaveDataArchiveSettings");
            return Ok(returnResult);
        }
    }
}
