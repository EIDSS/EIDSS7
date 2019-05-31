using OpenEIDSS.Extensions.Attributes;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using WebApi.OutputCache.V2;
using OpenEIDSS.Domain.Return_Contracts;
using Newtonsoft.Json;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    [RoutePrefix("api/Global")]
    public class GlobalController : ApiController
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(GlobalController));

        private IEIDSSRepository _repository = new EIDSSRepository();
        
        /// <summary>
        /// 
        /// </summary>
        public GlobalController()
        {

        }


        /// <summary>
        /// Returns Accessory Code
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="haCode"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("AccessoryCodeGetLookupAsync")]
        [ResponseType(typeof(List<AccessoryCodeGetLookupModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> AccessoryCodeGetLookupAsync(string languageId, int ? haCode)
        {
            log.Info("Entering  AccessoryCodeGetLookupAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.AccessoryCodeGetLookupAsync(languageId, haCode);
                if (result == null)
                {
                    log.Info("Exiting  AccessoryCodeGetLookupAsync With Not Found");
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
                log.Error("SQL Error in AccessoryCodeGetLookupAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in AccessoryCodeGetLookupAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  AccessoryCodeGetLookupAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// CHecks HA Codes
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="haCodeMask"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("HaCodeGetCheckListAsync")]
        [ResponseType(typeof(List<HaCodeGetCheckListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> HaCodeGetCheckListAsync(string languageId, int? haCodeMask)
        {
            log.Info("Entering  HaCodeGetCheckListAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.HaCodeGetCheckListAsync(languageId, haCodeMask);
                if (result == null)
                {
                    log.Info("Exiting  HaCodeGetCheckListAsync With Not Found");
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
                log.Error("SQL Error in HaCodeGetCheckListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HaCodeGetCheckListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  HaCodeGetCheckListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a Month List
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        ///d status code is returned when no results could be found. </returns>
         [HttpGet, Route("GblLkupMonthGetListAsync")]
        [ResponseType(typeof(List<GblLkupMonthGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GblLkupMonthGetListAsync(string languageId)
        {
            log.Info("Entering  GblLkupMonthGetListAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.GblLkupMonthGetListAsync(languageId);
                if (result == null)
                {
                    log.Info("Exiting  GblLkupMonthGetListAsync With Not Found");
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
                log.Error("SQL Error in GblLkupMonthGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GblLkupMonthGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GblLkupMonthGetListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a Month List
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>d status code is returned when no results could be found.
        [HttpGet, Route("GetReferenceTypes")]
        [ResponseType(typeof(List<AdminLkupReferenceTypeGetlistModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetReferenceTypes(string languageId)
        {
            log.Info("Entering  GetReferenceTypes");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.AdminLkupReferenceTypeGetlistAsync(languageId);
                if (result == null)
                {
                    log.Info("Exiting  GetReferenceTypes With Not Found");
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
                log.Error("SQL Error in GetReferenceTypes Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetReferenceTypes" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetReferenceTypes");
            return Ok(returnResult);
        }


    }
}
