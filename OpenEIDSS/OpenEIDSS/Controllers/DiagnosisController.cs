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
    /// API for managing Diagnosis
    /// </summary>
    [RoutePrefix("api/Admin")]
    public class DiagnosisController : ApiController
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(DiagnosisController));
        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// 
        /// </summary>
        public DiagnosisController() : base()
        {


        }


        /// <summary>
        /// Returns Reference Diagnosis List
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("DiagnosisReferenceGetList")]
        [ResponseType(typeof(List<Domain.RefDiagnosisreferenceGetListModel>))]
        //[CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> RefDiagnosisreferenceGetList(string languageId)
        {
            log.Info("Entering  RefDiagnosisreferenceGetList");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.RefDiagnosisreferenceGetListAsync(languageId);
                if (result == null)
                {
                    log.Info("Exiting  RefDiagnosisreferenceGetList With Not Found");
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
                log.Error("SQL Error in RefDiagnosisreferenceGetList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefDiagnosisreferenceGetList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  RefDiagnosisreferenceGetList");
            return Ok(returnResult);
        }




        /// <summary>
        /// Sets, Save Reference Diagnosis
        /// </summary>
        /// <param name="referenceDiagnosisSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("DiagnosisReferenceSet")]
        [ResponseType(typeof(List<RefDiagnosisreferenceSetModel>))]
        public async Task<IHttpActionResult> RefDiagnosisreferenceSet(ReferenceDiagnosisSetParams referenceDiagnosisSetParams)
        {
            log.Info("Entering  RefDiagnosisreferenceSet");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                
                var result = await _repository.RefDiagnosisreferenceSetAsync(
                    referenceDiagnosisSetParams.idfsDiagnosis,
                    referenceDiagnosisSetParams.strDefault,
                    referenceDiagnosisSetParams.strName,
                    referenceDiagnosisSetParams.strOieCode,
                    referenceDiagnosisSetParams.strIdc10,
                    referenceDiagnosisSetParams.intHaCode,
                    referenceDiagnosisSetParams.idfsUsingType, 
                    referenceDiagnosisSetParams.strPensideTest, 
                    referenceDiagnosisSetParams.strLabTest, 
                    referenceDiagnosisSetParams.strSampleType,
                    referenceDiagnosisSetParams.blnZoonotic, 
                    referenceDiagnosisSetParams.blnSyndrome, 
                    referenceDiagnosisSetParams.langId,
                    referenceDiagnosisSetParams.intOrder);
                if (result == null)
                {
                    log.Info("Exiting  RefDiagnosisreferenceSet With Not Found");
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
                log.Error("SQL Error in RefDiagnosisreferenceSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefDiagnosisreferenceSet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  RefDiagnosisreferenceSet");
            return Ok(returnResult);
        }

        /// <summary>
        /// Deletes Reference Diagnosis
        /// </summary>
        /// <param name="idfsDiagnosis"></param>
        /// <param name="deleteAnyway"></param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of response objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>
        [HttpDelete, Route("RefDiagnosisreferenceDel")]
        [ResponseType(typeof(List<RefDiagnosisreferenceDelModel>))]
        public async Task<IHttpActionResult> RefDiagnosisreferenceDel(long idfsDiagnosis, bool deleteAnyway)
        {
            log.Info("Entering  RefDiagnosisreferenceDel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.RefDiagnosisreferenceDelAsync(idfsDiagnosis,deleteAnyway);
                if (result == null)
                {
                    log.Info("Exiting  RefDiagnosisreferenceDel With Not Found");
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
                log.Error("SQL Error in RefDiagnosisreferenceDel Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefDiagnosisreferenceDel" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  RefDiagnosisreferenceDel");
            return Ok(returnResult);
        }
    }
}
