using OpenEIDSS.Extensions.Attributes;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Extensions;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using WebApi.OutputCache.V2;
using OpenEIDSS.Domain.Return_Contracts;
using System.Net;
using Newtonsoft.Json;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    [RoutePrefix("api/Test")]
    public class TestController : ApiController
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(TestController));

        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// Returns Test Matrix
        /// </summary>
        /// <param name="languageid"></param>
        /// <param name="idfsTestResolution"></param>
        /// <param name="idfsTestName"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfTesttotestresultmatrixGetlistModel>))]
        [HttpGet, Route("ConfTesttotestresultmatrixGetlistAsync")]
        public async Task<IHttpActionResult> ConfTesttotestresultmatrixGetlistAsync(string languageid,long idfsTestResolution, long idfsTestName)
        {
            log.Info("ConfTesttotestresultmatrixGetlistAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfTesttotestresultmatrixGetlistAsync(languageid, idfsTestResolution, idfsTestName);
                if (result == null)
                {
                    log.Info("Exiting  ConfTesttotestresultmatrixGetlistAsync With Not Found");
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
                log.Error("SQL Error in ConfTesttotestresultmatrixGetlistAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfTesttotestresultmatrixGetlistAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfTesttotestresultmatrixGetlistAsync");
            return Ok(returnResult);
        }



        
        /// <summary>
        /// Deletes Test Matrix
        /// </summary>
        /// <param name="idfsTestResultRelation"></param>
        /// <param name="idfsTestResult"></param>
        /// <param name="idfsTestName"></param>
        /// <param name="deleteAnyway"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfTesttotestresultmatrixDelModel>))]
        [HttpDelete, Route("ConfTesttotestresultmatrixDel")]
        public async Task<IHttpActionResult> ConfTesttotestresultmatrixDel(long idfsTestResultRelation, long idfsTestName, long idfsTestResult, bool deleteAnyway)
        {
            log.Info("ConfTesttotestresultmatrixDel is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfTesttotestresultmatrixDelAsync(idfsTestResultRelation, idfsTestName, idfsTestResult, deleteAnyway);
                if (result == null)
                {
                    log.Info("Exiting  ConfTesttotestresultmatrixDel With Not Found");
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
                log.Error("SQL Error in ConfTesttotestresultmatrixDel Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfTesttotestresultmatrixDel" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfTesttotestresultmatrixDel");
            return Ok(returnResult);
        }
        

        /// <summary>
        /// Creates a  Test Matrix
        /// </summary>
        /// <param name="confTesttotestresultmatrixSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfTesttotestresultmatrixSetModel>))]
        [HttpPost, Route("ConfTesttotestresultmatrixSet")]
        public async Task<IHttpActionResult> ConfTesttotestresultmatrixSet(ConfTesttotestresultmatrixSetParams confTesttotestresultmatrixSetParams)
        {
            log.Info("ConfTesttotestresultmatrixSet is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfTesttotestresultmatrixSetAsync(
                    confTesttotestresultmatrixSetParams.idfsTestResultRelation,
                    confTesttotestresultmatrixSetParams.idfsTestName,
                    confTesttotestresultmatrixSetParams.idfsTestResult,
                    confTesttotestresultmatrixSetParams.blnIndicative

                    );
                if (result == null)
                {
                    log.Info("Exiting  ConfTesttotestresultmatrixSet With Not Found");
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
                log.Error("SQL Error in ConfTesttotestresultmatrixSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfTesttotestresultmatrixSet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfTesttotestresultmatrixSet");
            return Ok(returnResult);
        }

    }
}
