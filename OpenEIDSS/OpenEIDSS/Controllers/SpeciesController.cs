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
using Newtonsoft.Json;
using OpenEIDSS.Domain.Return_Contracts;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// API responsible fo Species Functionality
    /// </summary>
    [RoutePrefix("api/Admin")]
    public class SpeciesController : ApiController
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(SpeciesController));
        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// 
        /// </summary>
        public SpeciesController() :base()
        {

        }


        /// <summary>
        /// Returns SpeciesType Reference List
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
        [HttpGet, Route("RefSpeciestypeGetList")]
        [ResponseType(typeof(List<Domain.RefSpeciestypeGetListModel>))]
        //[CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> RefSpeciestypeGetList(string languageId)
        {
            log.Info("Entering  RefSpeciestypeGetList");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.RefSpeciestypeGetListAsync(languageId);
                if (result == null)
                {
                    log.Info("Exiting  RefSpeciestypeGetList With Not Found");
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
                log.Error("SQL Error in RefSpeciestypeGetList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefSpeciestypeGetList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  RefSpeciestypeGetList");
            return Ok(returnResult);
        }

        /// <summary>
        /// Set, save a Reference Species Type
        /// </summary>
        /// <param name="speciesTypeReferenceSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("RefSpeciesTypeSet")]
        [ResponseType(typeof(List<Domain.RefSpeciestypeSetModel>))]
        //[CacheOutput(ClientTimeSpan = Constants.ClientDefaultCachingTimeoutSecs, ServerTimeSpan = Constants.ServerDefaultCachingTimeoutSecs)]
        public async Task<IHttpActionResult> RefSpeciestypereferenceSet(RefSpeciesTypeReferenceSetParams speciesTypeReferenceSetParams)
        {
            log.Info("Entering RefSpeciesTypeSet");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.RefSpeciestypeSetAsync(
                    speciesTypeReferenceSetParams.idfsSpeciesType,
                    speciesTypeReferenceSetParams.strDefault,
                    speciesTypeReferenceSetParams.strName,
                    speciesTypeReferenceSetParams.strCode,
                    speciesTypeReferenceSetParams.intHaCode,
                    speciesTypeReferenceSetParams.intOrder,
                    speciesTypeReferenceSetParams.languageId);
                if (result == null)
                {
                    log.Info("Exiting  RefSpeciestypereferenceSet With Not Found");
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
                log.Error("SQL Error in RefSpeciestypereferenceSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefSpeciestypereferenceSet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  RefSpeciestypereferenceSet");
            return Ok(returnResult);
        }

        /// <summary>
        /// Deletes A Reference Species Type
        /// </summary>
        /// <param name="idfsSpeciesType"></param>
        /// <param name="deleteAnyway"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("RefSpeciesTypeDel")]
        [ResponseType(typeof(List<Domain.RefSpeciestypeDelModel>))]
        public async Task< IHttpActionResult> RefSpecietypeDel(long idfsSpeciesType, bool deleteAnyway)
        {
            log.Info("Entering  RefSpecietypeDel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                
                var result = await _repository.RefSpeciestypeDelAsync(idfsSpeciesType, deleteAnyway);
                if (result == null)
                {
                    log.Info("Exiting  RefSpecietypeDel With Not Found");
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
                log.Error("SQL Error in RefSpecietypeDel Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefSpecietypeDel" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  RefSpecietypeDel");
            return Ok(returnResult);
        }
    }
}

