using OpenEIDSS.Extensions.Attributes;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Extensions;
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
    /// API for managing Case Classification Info
    /// </summary>
    [RoutePrefix("api/Admin")]
    public class CaseClassificationController : ApiController
    {



        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(CaseClassificationController));
        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// 
        /// </summary>
        public CaseClassificationController() : base()
        {
        }


        /// <summary>
        /// Returns Reference Case Classification
        /// </summary>
        /// <param name="languageId"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("CaseClassificationLookup")]
        [ResponseType(typeof(List<Domain.RefCaseclassificationGetListModel>))]
        //[CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetRefCaseClassification(string languageId)
        {
            log.Info("Entering  GetRefCaseClassification");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
               
                var result = await _repository.RefCaseclassificationGetListAsync(languageId);
                if (result == null)
                {
                    log.Info("Exiting  GetRefCaseClassification With Not Found");
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
                log.Error("SQL Error in GetRefCaseClassification PROC" + ex.Procedure, ex);
                return InternalServerError(ex);
            }
            catch (Exception ex)
            {
                log.Error("Error in GetRefCaseClassification" + ex.Message, ex);
                return InternalServerError(ex);
            }
            log.Info("Exiting  GetRefCaseClassification");
            return Ok(returnResult);
        }

        /// <summary>
        /// Set,Save Reference Case Classification
        /// </summary>
        /// <param name="adminCaseClassificationSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("CaseClassificationSet")]
        [ResponseType(typeof(List<RefCaseclassificationSetModel>))]
        [CacheOutput(ClientTimeSpan = Constants.ClientDefaultCachingTimeoutSecs, ServerTimeSpan = Constants.ServerDefaultCachingTimeoutSecs)]
        public async Task<IHttpActionResult> RefCaseClassificationSet(AdminCaseClassificationSetParams  adminCaseClassificationSetParams)
        {
            log.Info("Entering  GetRefCaseClassification");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.RefCaseclassificationSetAsync(
                    adminCaseClassificationSetParams.idfsCaseClassification,
                    adminCaseClassificationSetParams.strDefault,
                    adminCaseClassificationSetParams.strName,
                    adminCaseClassificationSetParams.blnInitialHumanCaseClassification,
                    adminCaseClassificationSetParams.blnFinalHumanCaseClassification,
                    adminCaseClassificationSetParams.languageId,
                    adminCaseClassificationSetParams.intOrder,
                    adminCaseClassificationSetParams.intHaCode
                    );
              
                if (result == null)
                {
                    log.Info("Exiting  GetRefCaseClassification With Not Found");
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
                log.Error("SQL Error in GetRefCaseClassification Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetRefCaseClassification" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetRefCaseClassification");
            return Ok(returnResult);
        }

        /// <summary>
        /// Deletes Reference Case Classification
        /// </summary>
        /// <param name="idfsCaseClassification"></param>
        /// <param name="deleteAnyway"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("RefCaseClassificationDel")]
        [ResponseType(typeof(List<RefCaseclassificationDelModel>))]
        public async Task<IHttpActionResult> RefCaseClassificationDel(long idfsCaseClassification, bool deleteAnyway)
        {
            log.Info("Entering  RefCaseClassificationDel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
            
                var result = await _repository.RefCaseclassificationDelAsync(idfsCaseClassification, deleteAnyway);
                if (result == null)
                {
                    log.Info("Exiting  RefCaseClassificationDel With Not Found");
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
                log.Error("SQL Error in RefCaseClassificationDel Procedure" + ex.Procedure, ex);
                return InternalServerError(ex);
            }
            catch (Exception ex)
            {
                log.Error("Error in RefCaseClassificationDel" + ex.Message, ex);
                return InternalServerError(ex);
            }
            log.Info("Exiting  RefCaseClassificationDel");
            return Ok(returnResult);
        }
    }
}
