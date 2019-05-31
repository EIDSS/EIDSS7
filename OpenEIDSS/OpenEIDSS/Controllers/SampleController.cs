using Newtonsoft.Json;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Domain.Return_Contracts;
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

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// API responsible fo Sample Type Functionality
    /// </summary>
    [RoutePrefix("api/Admin")]
    public class SampleController : ApiController
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(SpeciesController));
        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// 
        /// </summary>
        public SampleController() : base()
        {

        }

        /// <summary>
        /// Returns a list of Sample Type
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
        [HttpGet, Route("RefSampleTypeGetList")]
        [ResponseType(typeof(List<Domain.RefSampleTypeReferenceGetListModel>))]
        //[CacheOutput(ClientTimeSpan = Constants.ClientDefaultCachingTimeoutSecs, ServerTimeSpan = Constants.ServerDefaultCachingTimeoutSecs)]
        public async Task<IHttpActionResult> RefSampleTypeGetList(string languageId)
        {
            log.Info("Entering RefSampleTypeGetList");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.RefSampleTypeReferenceGetListAsync(languageId);
                if (result == null)
                {
                    log.Info("RefSampleTypeGetList With Not Found");
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
                log.Error("SQL Error in RefSampleTypeGetList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefSampleTypeGetList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  RefSampleTypeGetList");
            return Ok(returnResult);

        }

        /// <summary>
        /// Saves a Regference SampleType
        /// </summary>
        /// <param name="adminSampleReferenceTypeSet"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("SetReferenceSampleType")]
        [ResponseType(typeof(List<RefSampletypereferenceSetModel>))]
        //[CacheOutput(ClientTimeSpan = Constants.ClientDefaultCachingTimeoutSecs, ServerTimeSpan = Constants.ServerDefaultCachingTimeoutSecs)]
        public async Task<IHttpActionResult> SetReferenceSampleType(AdminSampleReferenceTypeSet adminSampleReferenceTypeSet)
        {
            log.Info("Entering  SetReferenceSampleType");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.RefSampletypereferenceSetAsync(
                    adminSampleReferenceTypeSet.idfsSampleType,
                    adminSampleReferenceTypeSet.strDefault,
                    adminSampleReferenceTypeSet.strName,
                    adminSampleReferenceTypeSet.strSampleCode,
                    adminSampleReferenceTypeSet.intHaCode,
                    adminSampleReferenceTypeSet.intOrder,
                    adminSampleReferenceTypeSet.laguageId
                    );
                if (result == null)
                {
                    log.Info("SetReferenceSampleType With Not Found");
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
                log.Error("SQL Error in SetReferenceSampleType Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in SetReferenceSampleType" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  SetReferenceSampleType");
            return Ok(returnResult);

        }

        /// <summary>
        /// Deletes Reference SampleType
        /// </summary>
        /// <param name="idfsSampleType"></param>
        /// <param name="deleteAnyway"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("RefSampletypereferenceDelete")]
        [ResponseType(typeof(List<RefSampletypereferenceDelModel>))]
        public async Task<IHttpActionResult> RefSampletypereferenceDelete(long idfsSampleType, bool deleteAnyway)
        {
            log.Info("Entering  RefSampletypereferenceDelete");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.RefSampletypereferenceDelAsync(idfsSampleType, deleteAnyway);
                if (result == null | result.Count == 0)
                    return NotFound();
                log.Info("Exiting  RefSampletypereferenceDelete");
                if (result == null)
                {
                    log.Info("RefSampletypereferenceDelete With Not Found");
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
                log.Error("SQL Error in RefSampletypereferenceDelete Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefSampletypereferenceDelete" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  RefSampletypereferenceDelete");
            return Ok(returnResult);


        }
    }
}
