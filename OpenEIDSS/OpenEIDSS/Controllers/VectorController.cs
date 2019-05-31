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
    [RoutePrefix("api/Vector")]
    public class VectorController : ApiController
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(VectorController));

        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// 
        /// </summary>
        public VectorController() : base()
        {
        }

        /// <summary>
        /// Returns List of Reference Vector Types
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfVectorSurveillanceSession">Unique Id for Vector Surveillance Session</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VectorSurveillanceSessionGetDetail")]
        [ResponseType(typeof(List<Domain.VctsVssessionGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> VectorSurveillanceSessionGetDetail(long idfVectorSurveillanceSession, string languageId)
        {
            log.Info("Entering  VectorSurveillanceSessionGetDetail");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
               
                var result = await _repository.VctsVssessionGetDetailAsync(idfVectorSurveillanceSession,languageId);
                if (result == null)
                {
                    log.Info("Exiting  VectorSurveillanceSessionGetDetail Not FOund");
                    return NotFound();
                }
                if (result == null)
                {
                    log.Info("Exiting  VectorSurveillanceSessionGetDetail With Not Found");
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
                log.Error("SQL Error in VectorSurveillanceSessionGetDetail Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VectorSurveillanceSessionGetDetail" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VectorSurveillanceSessionGetDetail");
            return Ok(returnResult);
        }


        /// <summary>
        /// Returns a list of Vector Surveillance Params
        /// </summary>
        /// <param name="vectorSurveillanceGetListParams">Request Paramater Object</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("VectorSurveillanceSessionGetList")]
        [ResponseType(typeof(List<Domain.VctsVssessionGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> VectorSurveillanceSessionGetList(VectorSurveillanceSessionGetListParams vectorSurveillanceGetListParams)
        {
            log.Info("Entering  VectorSurveillanceSessionGetList");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
              
                var result = await _repository.VctsVssessionGetListAsync(
                    vectorSurveillanceGetListParams.LanguageID,
                    vectorSurveillanceGetListParams.EIDSSSessionID,
                    vectorSurveillanceGetListParams.FieldSessionID,
                    vectorSurveillanceGetListParams.SessionStatusTypeID,
                    vectorSurveillanceGetListParams.VectorType,
                    vectorSurveillanceGetListParams.SpeciesTypeID,
                    vectorSurveillanceGetListParams.DiseaseID,
                    vectorSurveillanceGetListParams.DiseaseGroup,
                    vectorSurveillanceGetListParams.RegionID,
                    vectorSurveillanceGetListParams.RayonID,
                    vectorSurveillanceGetListParams.SettlementID,
                    vectorSurveillanceGetListParams.StartDateFrom,
                    vectorSurveillanceGetListParams.StartDateTo,
                    vectorSurveillanceGetListParams.CloseDateFrom,
                    vectorSurveillanceGetListParams.CloseDateTo,
                    vectorSurveillanceGetListParams.OutbreakID,
                    vectorSurveillanceGetListParams.SiteID);
                if (result == null)
                {
                    log.Info("Exiting  VectorSurveillanceSessionGetList With Not Found");
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
                log.Error("SQL Error in VectorSurveillanceSessionGetList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VectorSurveillanceSessionGetList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VectorSurveillanceSessionGetList");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a list of vector surveillance session records.
        /// </summary>
        /// <param name="parameters">Request Paramater Object</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("VectorSurveillanceSessionGetListAsync")]
        [ResponseType(typeof(List<VctsSurveillanceSessionGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetVectorSurveillanceSessionListAsync([FromBody]VectorSurveillanceSessionGetListParams parameters)
        {
            log.Info("GetVectorSurveillanceSessionListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
           

                int pageSize = 10;
                int maxPagesPerFetch = 10;

                var result = await _repository.VctsSurveillanceSessionGetListAsync(
                    parameters.LanguageID,
                    parameters.EIDSSSessionID,
                    parameters.FieldSessionID,
                    parameters.SessionStatusTypeID,
                    parameters.VectorType,
                    parameters.SpeciesTypeID,
                    parameters.DiseaseID,
                    parameters.DiseaseGroup,
                    parameters.RegionID,
                    parameters.RayonID,
                    parameters.SettlementID,
                    parameters.StartDateFrom,
                    parameters.StartDateTo,
                    parameters.CloseDateFrom,
                    parameters.CloseDateTo,
                    parameters.OutbreakID,
                    parameters.SiteID, 
                    parameters.PaginationSetNumber, 
                    pageSize, 
                    maxPagesPerFetch);
                if (result == null)
                {
                    log.Info("Exiting  GetVectorSurveillanceSessionListAsync With Not Found");
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
                log.Error("SQL Error in GetVectorSurveillanceSessionListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetVectorSurveillanceSessionListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetVectorSurveillanceSessionListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a count of vector surveillance session records.
        /// </summary>
        /// <param name="parameters">Request Paramater Object</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>

        [HttpPost, Route("VectorSurveillanceSessionGetListCountAsync")]
        [ResponseType(typeof(List<VctsSurveillanceSessionGetCountModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetVectorSurveillanceSessionListCountAsync([FromBody]VectorSurveillanceSessionGetListParams parameters)
        {
            log.Info("GetVectorSurveillanceSessionListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.VctsSurveillanceSessionGetCountAsync(
                    parameters.LanguageID,
                    parameters.EIDSSSessionID,
                    parameters.FieldSessionID,
                    parameters.SessionStatusTypeID,
                    parameters.VectorType,
                    parameters.SpeciesTypeID,
                    parameters.DiseaseID,
                    parameters.DiseaseGroup,
                    parameters.RegionID,
                    parameters.RayonID,
                    parameters.SettlementID,
                    parameters.StartDateFrom,
                    parameters.StartDateTo,
                    parameters.CloseDateFrom,
                    parameters.CloseDateTo,
                    parameters.OutbreakID,
                    parameters.SiteID);
                if (result == null)
                {
                    log.Info("Exiting  GetVectorSurveillanceSessionListCountAsync With Not Found");
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
                log.Error("SQL Error in GetVectorSurveillanceSessionListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetVectorSurveillanceSessionListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetVectorSurveillanceSessionListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="vectorSurveillanceSessionSetParams">Request Paramater Object</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("VctsVecSessionSet")]
        [ResponseType(typeof(List<Domain.VctsVecSessionSetModel>))]
        public IHttpActionResult VctsVecSessionSet(VectorSurveillanceSessionSetParams vectorSurveillanceSessionSetParams)
        {
            log.Info("Entering  VctsVecSessionSet");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = _repository.VctsVecSessionSetAsync(

                    vectorSurveillanceSessionSetParams.idfVectorSurveillanceSession,
                    vectorSurveillanceSessionSetParams.strSessionId,
                    vectorSurveillanceSessionSetParams.strFieldSessionId,
                    vectorSurveillanceSessionSetParams.idfsVectorSurveillanceStatus,
                    vectorSurveillanceSessionSetParams.datStartDate,
                    vectorSurveillanceSessionSetParams.datCloseDate,
                    vectorSurveillanceSessionSetParams.idfOutbreak,
                    vectorSurveillanceSessionSetParams.intCollectionEffort,
                    vectorSurveillanceSessionSetParams.datModificationForArchiveDate,
                    vectorSurveillanceSessionSetParams.idfGeoLocation,
                    vectorSurveillanceSessionSetParams.idfsGeolocationType,
                    vectorSurveillanceSessionSetParams.idfsCountry,
                    vectorSurveillanceSessionSetParams.idfsRegion,
                    vectorSurveillanceSessionSetParams.idfsRayon,
                    vectorSurveillanceSessionSetParams.idfsSettlement,
                    vectorSurveillanceSessionSetParams.dblLatitude,
                    vectorSurveillanceSessionSetParams.dblLongitude,
                    vectorSurveillanceSessionSetParams.strDescription,
                    vectorSurveillanceSessionSetParams.idfsGroundType,
                    vectorSurveillanceSessionSetParams.dblDistance,
                    vectorSurveillanceSessionSetParams.dblDirection,
                    vectorSurveillanceSessionSetParams.strStreetName,
                    vectorSurveillanceSessionSetParams.blnForeignAddress,
                    vectorSurveillanceSessionSetParams.strForeignAddress,
                    vectorSurveillanceSessionSetParams.blnGeoLocationShared);
                   
                if (result == null)
                {
                    log.Info("Exiting  VctsVecSessionSet With Not Found");
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
                log.Error("SQL Error in VctsVecSessionSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsVecSessionSet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsVecSessionSet");
            return Ok(returnResult);
        }


        /// <summary>
        /// Deletes a Vetor Surveillance Session
        /// </summary>
        /// <param name="idfVectorSurveillanceSession">Unique Id for Surveillance Session</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("VctsVecSessionDel")]
        [ResponseType(typeof(List<Domain.VctsVecSessionDelModel>))]
        public async Task<IHttpActionResult> VctsVecSessionDel(long idfVectorSurveillanceSession)
        {
            log.Info("Entering  VctsVecSessionDel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result =  await _repository.VctsVecSessionDelAsync(idfVectorSurveillanceSession);
                if (result == null)
                {
                    log.Info("Exiting  VctsVecSessionDel With Not Found");
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
                log.Error("SQL Error in VctsVecSessionDel Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsVecSessionDel" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsVecSessionDel");
            return Ok(returnResult);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="idfVectorSurveillanceSession">Unique Id for Surveillance Session</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VctsVectGetDetail")]
        [ResponseType(typeof(List<Domain.VctsVectGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> VctsVectGetDetail(long idfVectorSurveillanceSession,string languageId)
        {
            log.Info("Entering  VctsVectGetDetail");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.VctsVectGetDetailAsync(idfVectorSurveillanceSession, languageId);
                if (result == null)
                {
                    log.Info("Exiting  VctsVectGetDetail With Not Found");
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
                log.Error("SQL Error in VctsVectGetDetail Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsVectGetDetail" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsVectGetDetail");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns A list of Session Summary Objects
        /// </summary>
        /// <param name="idfVectorSurveillanceSession">Unique Id for Surveillance Session</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VctsVecSessionSummaryGetList")]
        [ResponseType(typeof(List<Domain.VctsVecSessionSummaryGetListModel>))]
        public async Task<IHttpActionResult> VctsVecSessionSummaryGetList(long idfVectorSurveillanceSession, string languageId)
        {
            log.Info("Entering  VctsVecSessionSummaryGetList");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.VctsVecSessionSummaryGetListAsync(idfVectorSurveillanceSession, languageId);
                if (result == null)
                {
                    log.Info("Exiting  VctsVecSessionSummaryGetList With Not Found");
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
                log.Error("SQL Error in VctsVecSessionSummaryGetList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsVecSessionSummaryGetList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsVecSessionSummaryGetList");
            return Ok(returnResult);
        }


        /// <summary>
        /// Retuns a List of detail Session summary objects
        /// </summary>
        /// <param name="idfsVsSessionSummary">Summary Id</param>
        /// <param name="idfVectorSurveillanceSession">Unique Id for Surveillance Session</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VctsVecSessionSummaryGetDetail")]
        [ResponseType(typeof(List<Domain.VctsVecSessionSummaryGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> VctsVecSessionSummaryGetDetail(long? idfsVsSessionSummary,long? idfVectorSurveillanceSession, string languageId)
        {
            log.Info("Entering  VctsVecSessionSummaryGetDetail");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.VctsVecSessionSummaryGetDetailAsync(idfsVsSessionSummary,idfVectorSurveillanceSession, languageId);
                if (result == null)
                {
                    log.Info("Exiting  VctsVecSessionSummaryGetDetail With Not Found");
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
                log.Error("SQL Error in VctsVecSessionSummaryGetDetail Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsVecSessionSummaryGetDetail" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsVecSessionSummaryGetDetail");
            return Ok(returnResult);
        }


        /// <summary>
        /// Returns a list of Session Summary Diagnosis Objects
        /// </summary>
        /// <param name="idfsVsSessionSummary">Summary Id</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VctsSessionsummarydiagnosisGetDetail")]
        [ResponseType(typeof(List<Domain.VctsSessionsummarydiagnosisGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> VctsSessionsummarydiagnosisGetDetail(long? idfsVsSessionSummary,  string languageId)
        {
            log.Info("Entering  VctsSessionsummarydiagnosisGetDetail");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.VctsSessionsummarydiagnosisGetDetailAsync(idfsVsSessionSummary,  languageId);
                if (result == null)
                {
                    log.Info("Exiting  VctsSessionsummarydiagnosisGetDetail With Not Found");
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
                log.Error("SQL Error in VctsSessionsummarydiagnosisGetDetail Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsSessionsummarydiagnosisGetDetail" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsSessionsummarydiagnosisGetDetail");
            return Ok(returnResult);
        }


        /// <summary>
        /// Sets, Saves Session Summary Diagnosis
        /// </summary>
        /// <param name="vctsSessionsummarydiagnosisSetParams">Request Object Parameter</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("VctsSessionsummarydiagnosisSet")]
        [ResponseType(typeof(List<Domain.VctsSessionsummarydiagnosisSetModel>))]
        public IHttpActionResult VctsSessionsummarydiagnosisSet(VctsSessionsummarydiagnosisSetParams vctsSessionsummarydiagnosisSetParams)
        {
            log.Info("Entering  VctsSessionsummarydiagnosisSet");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                long? idfsVsSessionSummaryDiagnosis;
                var result = _repository.VctsSessionsummarydiagnosisSet(
                    out idfsVsSessionSummaryDiagnosis,
                    vctsSessionsummarydiagnosisSetParams.idfsVsSessionSummary,
                    vctsSessionsummarydiagnosisSetParams.idfsDiagnosis,
                    vctsSessionsummarydiagnosisSetParams.intPositiveQuantity);
                if (result == null)
                {
                    log.Info("Exiting  VctsSessionsummarydiagnosisSet With Not Found");
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
                log.Error("SQL Error in VctsSessionsummarydiagnosisSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsSessionsummarydiagnosisSet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsSessionsummarydiagnosisSet");
            return Ok(returnResult);
        }


        /// <summary>
        /// Sets, Saves VCTS Session Summary
        /// </summary>
        /// <param name="vctsSessionsummarySetParams">Reqest object parameter</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("VctsSessionsummarySet")]
        [ResponseType(typeof(List<Domain.VctsSessionsummarySetModel>))]
        public IHttpActionResult VctsSessionsummarySet(VctsSessionsummarySetParams vctsSessionsummarySetParams)
        {
            log.Info("Entering  VctsSessionsummarySet");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                long? idfsVsSessionSummary;
                string strVsSessionSummaryId;
                
                var result = _repository.VctsSessionsummarySet(
                    out idfsVsSessionSummary,
                    vctsSessionsummarySetParams.idfDiagnosisVectorSurveillanceSession,
                    out strVsSessionSummaryId,
                    vctsSessionsummarySetParams.diagnosisidfGeoLocation,
                    vctsSessionsummarySetParams.lucAggregateCollectiondblAccuracy,
                    vctsSessionsummarySetParams.lucAggregateCollectionidfsGroundType,
                    vctsSessionsummarySetParams.lucAggregateCollectionidfsGeolocationType,
                    vctsSessionsummarySetParams.lucAggregateCollectionidfsCountry,
                    vctsSessionsummarySetParams.lucAggregateCollectionidfsRegion,
                    vctsSessionsummarySetParams.lucAggregateCollectionidfsRayon,
                    vctsSessionsummarySetParams.lucAggregateCollectionidfsSettlement,
                    vctsSessionsummarySetParams.lucAggregateCollectionstrApartment,
                    vctsSessionsummarySetParams.lucAggregateCollectionstrBuilding,
                    vctsSessionsummarySetParams.lucAggregateCollectionstrStreetName,
                    vctsSessionsummarySetParams.lucAggregateCollectionstrHouse,
                    vctsSessionsummarySetParams.lucAggregateCollectionstrPostCode,
                    vctsSessionsummarySetParams.lucAggregateCollectionstrDescription,
                    vctsSessionsummarySetParams.lucAggregateCollectiondblDistance,
                    vctsSessionsummarySetParams.lucAggregateCollectionstrLatitude,
                    vctsSessionsummarySetParams.lucAggregateCollectionstrLongitude,
                    vctsSessionsummarySetParams.lucAggregateCollectiondblAccuracy,
                    vctsSessionsummarySetParams.lucAggregateCollectiondblAlignment,
                    vctsSessionsummarySetParams.blnForeignAddress,
                    vctsSessionsummarySetParams.strForeignAddress,
                    vctsSessionsummarySetParams.blnGeoLocationShared,
                    vctsSessionsummarySetParams.datSummaryCollectionDateTime,
                    vctsSessionsummarySetParams.summaryInfoSpecies,
                    vctsSessionsummarySetParams.summaryInfoSex,
                    vctsSessionsummarySetParams.poolsVectors);
                if (result == null)
                {
                    log.Info("Exiting  VctsSessionsummarySet With Not Found");
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
                log.Error("SQL Error in VctsSessionsummarySet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsSessionsummarySet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsSessionsummarySet");
            return Ok(returnResult);
        }


        /// <summary>
        /// Deletes A VctsSessionsummary
        /// </summary>
        /// <param name="idfsVsSessionSummary"></param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of response objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>
        [HttpDelete, Route("VctsSessionsummaryDel")]
        [ResponseType(typeof(List<Domain.VctsSessionsummaryDelModel>))]
        public async Task<IHttpActionResult> VctsSessionsummaryDel(long idfsVsSessionSummary)
        {
            log.Info("Entering  VctsSessionsummaryDel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.VctsSessionsummaryDelAsync(idfsVsSessionSummary);
                if (result == null)
                {
                    log.Info("Exiting  VctsSessionsummaryDel With Not Found");
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
                log.Error("SQL Error in VctsSessionsummaryDel Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsSessionsummaryDel" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsSessionsummaryDel");
            return Ok(returnResult);
        }



        /// <summary>
        /// Saves , Sets VctsVectSet
        /// </summary>
        /// <param name="vctsVectSetParams">Request Object Parameter</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("VctsVectSet")]
        [ResponseType(typeof(List<Domain.VctsVectSetModel>))]
        public IHttpActionResult VctsVectSet(VctsVectSetParams vctsVectSetParams)
        {
            log.Info("Entering  VctsVectSet");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                long? idfVector;
                string strVectorId;
          
                
                var result = _repository.VctsVectSet(
                    out idfVector,
                    vctsVectSetParams.idfsDetailedVectorSurveillanceSession,
                    vctsVectSetParams.idfHostVector,
                    out strVectorId,
                    vctsVectSetParams.strFieldVectorId,
                    vctsVectSetParams.idfDetailedLocation,
                    vctsVectSetParams.lucDetailedCollectionidfsResidentType,
                    vctsVectSetParams.lucDetailedCollectionidfsGroundType,
                    vctsVectSetParams.lucDetailedCollectionidfsGeolocationType,
                    vctsVectSetParams.lucDetailedCollectionidfsCountry,
                    vctsVectSetParams.lucDetailedCollectionidfsRegion,
                    vctsVectSetParams.lucDetailedCollectionidfsRayon,
                    vctsVectSetParams.lucDetailedCollectionidfsSettlement,
                    vctsVectSetParams.lucDetailedCollectionstrApartment,
                    vctsVectSetParams.lucDetailedCollectionstrBuilding,
                    vctsVectSetParams.lucDetailedCollectionstrStreetName,
                    vctsVectSetParams.lucDetailedCollectionstrHouse,
                    vctsVectSetParams.lucDetailedCollectionstrPostCode,
                    vctsVectSetParams.lucDetailedCollectionstrDescription,
                    vctsVectSetParams.lucDetailedCollectiondblDistance,
                    vctsVectSetParams.lucDetailedCollectionstrLatitude,
                    vctsVectSetParams.lucDetailedCollectionstrLongitude,
                    vctsVectSetParams.lucDetailedCollectiondblAccuracy,
                    vctsVectSetParams.lucDetailedCollectiondblAlignment,
                    vctsVectSetParams.blnForeignAddress,
                    vctsVectSetParams.strForeignAddress,
                    vctsVectSetParams.blnGeoLocationShared,
                    vctsVectSetParams.intDetailedElevation,
                    vctsVectSetParams.detailedSurroundings,
                    vctsVectSetParams.strGeoReferenceSource,
                    vctsVectSetParams.idfCollectedByOffice,
                    vctsVectSetParams.idfCollectedByPerson,
                    vctsVectSetParams.datCollectionDateTime,
                    vctsVectSetParams.idfsCollectionMethod,
                    vctsVectSetParams.idfsBasisOfRecord,
                    vctsVectSetParams.idfDetailedVectorType,
                    vctsVectSetParams.idfsVectorSubType,
                    vctsVectSetParams.intQuantity,
                    vctsVectSetParams.idfsSex,
                    vctsVectSetParams.idfIdentIFiedByOffice,
                    vctsVectSetParams.idfIdentIFiedByPerson,
                    vctsVectSetParams.datIdentIFiedDateTime,
                    vctsVectSetParams.idfsIdentIFicationMethod,
                    vctsVectSetParams.idfObservation,
                    vctsVectSetParams.idfsFormTemplate,
                    vctsVectSetParams.idfsDayPeriod,
                    vctsVectSetParams.strComment,
                    vctsVectSetParams.idfsEctoparASitesCollected);
                if (result == null)
                {
                    log.Info("Exiting  VctsVectSet With Not Found");
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
                log.Error("SQL Error in VctsVectSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsVectSet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsVectSet");
            return Ok(returnResult);
        }


        /// <summary>
        /// Deletes a Vector
        /// </summary>
        /// <param name="idfVector">Vector Id</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("VctsVectDel")]
        [ResponseType(typeof(List<Domain.VctsVectDelModel>))]
        public async Task<IHttpActionResult> VctsVectDel(long idfVector)
        {
            log.Info("Entering  VctsVectDel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
            
                
                var result = await _repository.VctsVectDelAsync(idfVector);
                if (result == null)
                {
                    log.Info("Exiting  VctsVectDel With Not Found");
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
                log.Error("SQL Error in VctsVectDel Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsVectDel" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsVectDel");
            return Ok(returnResult);
        }


        /// <summary>
        /// Sets, Saves a vector Structure
        /// </summary>
        /// <param name="vctsVectStructuredSetParams">Request Object Parameter</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("VctsVectStructuredSet")]
        [ResponseType(typeof(List<Domain.VctsVectStructuredSetModel>))]
        public async Task<IHttpActionResult> VctsVectStructuredSet(VctsVectStructuredSetParams  vctsVectStructuredSetParams)
        {
            log.Info("Entering  VctsVectStructuredSet");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                
                var result = await _repository.VctsVectStructuredSetAsync(
                    vctsVectStructuredSetParams.langId,
                    vctsVectStructuredSetParams.idfVector, 
                    vctsVectStructuredSetParams.idfsDetailedVectorSurveillanceSession,
                    vctsVectStructuredSetParams.idfHostVector,
                    vctsVectStructuredSetParams.strVectorId,
                    vctsVectStructuredSetParams.strFieldVectorId,
                    vctsVectStructuredSetParams.idfDetailedLocation,
                    vctsVectStructuredSetParams.lucDetailedCollectionidfsResidentType,
                    vctsVectStructuredSetParams.lucDetailedCollectionidfsGroundType,
                    vctsVectStructuredSetParams.lucDetailedCollectionidfsGeolocationType, 
                    vctsVectStructuredSetParams.lucDetailedCollectionidfsCountry, 
                    vctsVectStructuredSetParams.lucDetailedCollectionidfsRegion, 
                    vctsVectStructuredSetParams.lucDetailedCollectionidfsRayon, 
                    vctsVectStructuredSetParams.lucDetailedCollectionidfsSettlement, 
                    vctsVectStructuredSetParams.lucDetailedCollectionstrApartment, 
                    vctsVectStructuredSetParams.lucDetailedCollectionstrBuilding, 
                    vctsVectStructuredSetParams.lucDetailedCollectionstrStreetName, 
                    vctsVectStructuredSetParams.lucDetailedCollectionstrHouse, 
                    vctsVectStructuredSetParams.lucDetailedCollectionstrPostCode, 
                    vctsVectStructuredSetParams.lucDetailedCollectionstrDescription, 
                    vctsVectStructuredSetParams.lucDetailedCollectiondblDistance, 
                    vctsVectStructuredSetParams.lucDetailedCollectionstrLatitude, 
                    vctsVectStructuredSetParams.lucDetailedCollectionstrLongitude, 
                    vctsVectStructuredSetParams.lucDetailedCollectiondblAccuracy,
                    vctsVectStructuredSetParams.lucDetailedCollectiondblAlignment,
                    vctsVectStructuredSetParams.blnForeignAddress,
                    vctsVectStructuredSetParams.strForeignAddress,
                    vctsVectStructuredSetParams.blnGeoLocationShared,
                    vctsVectStructuredSetParams.intDetailedElevation,
                    vctsVectStructuredSetParams.detailedSurroundings,
                    vctsVectStructuredSetParams.strGeoReferenceSource,
                    vctsVectStructuredSetParams.idfCollectedByOffice,
                    vctsVectStructuredSetParams.idfCollectedByPerson,
                    vctsVectStructuredSetParams.datCollectionDateTime,
                    vctsVectStructuredSetParams.idfsCollectionMethod,
                    vctsVectStructuredSetParams.idfsBasisOfRecord,
                    vctsVectStructuredSetParams.idfDetailedVectorType,
                    vctsVectStructuredSetParams.idfsVectorSubType,
                    vctsVectStructuredSetParams.intQuantity,
                    vctsVectStructuredSetParams.idfsSex,
                    vctsVectStructuredSetParams.idfIdentIFiedByOffice,
                    vctsVectStructuredSetParams.idfIdentIFiedByPerson,
                    vctsVectStructuredSetParams.datIdentIFiedDateTime,
                    vctsVectStructuredSetParams.idfsIdentIFicationMethod,
                    vctsVectStructuredSetParams.idfObservation,
                    vctsVectStructuredSetParams.idfsFormTemplate,
                    vctsVectStructuredSetParams.idfsDayPeriod,
                    vctsVectStructuredSetParams.strComment,
                    vctsVectStructuredSetParams.idfsEctoparASitesCollected,
                    vctsVectStructuredSetParams.sample,
                    vctsVectStructuredSetParams.fieldTest);
                if (result == null)
                {
                    log.Info("Exiting  VctsVectStructuredSet With Not Found");
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
                log.Error("SQL Error in VctsVectStructuredSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsVectStructuredSet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsVectStructuredSet");
            return Ok(returnResult);
        }



        /// <summary>
        /// Sets, saves a Vector Sample
        /// </summary>
        /// <param name="vctsVectSamplesSetParams">Request Object Parameter</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("VctsVectSamplesSet")]
        [ResponseType(typeof(int))]
        public async Task<IHttpActionResult> VctsVectSamplesSet(VctsVectSamplesSetParams vctsVectSamplesSetParams)
        {
            log.Info("Entering  VctsVectSamplesSet");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.VctsVectSamplesSetAsync(
                    vctsVectSamplesSetParams.languageId,
                    vctsVectSamplesSetParams.idfMaterial,
                    vctsVectSamplesSetParams.strFieldBarcode,
                    vctsVectSamplesSetParams.idfsSampleType,
                    vctsVectSamplesSetParams.idfVectorSurveillanceSession,
                    vctsVectSamplesSetParams.idfVector,
                    vctsVectSamplesSetParams.idfSendToOffice,
                    vctsVectSamplesSetParams.idfFieldCollectedByOffice);
                if (result == null)
                {
                    log.Info("Exiting  VctsVectSamplesSet With Not Found");
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
                log.Error("SQL Error in VctsVectSamplesSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsVectSamplesSet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsVectSamplesSet");
            return Ok(returnResult);
        }

        /// <summary>
        /// Deletes a Vector Sample
        /// </summary>
        /// <param name="idfMaterial">Material Id </param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("VctsSampleDel")]
        [ResponseType(typeof(List<Domain.VctsSampleDelModel>))]
        public async Task< IHttpActionResult> VctsSampleDel(long? idfMaterial)
        {
            log.Info("Entering  VctsSampleDel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
               
                
                var result = await _repository.VctsSampleDelAsync(idfMaterial);
                if (result == null)
                {
                    log.Info("Exiting  VctsSampleDel With Not Found");
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
                log.Error("SQL Error in VctsSampleDel Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsSampleDel" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsSampleDel");
            return Ok(returnResult);
        }


        /// <summary>
        /// Returns a list of Vector Samples
        /// </summary>
        /// <param name="idfVector">Vector Id</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VctsSampleGetList")]
        [ResponseType(typeof(List<Domain.VctsSampleGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> VctsSampleGetList(long idfVector, string languageId)
        {
            log.Info("Entering  VctsSampleGetList");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

             
                var result = await _repository.VctsSampleGetListAsync(idfVector,languageId);
                if (result == null)
                {
                    log.Info("Exiting  VctsSampleGetList With Not Found");
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
                log.Error("SQL Error in VctsSampleGetList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsSampleGetList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsSampleGetList");
            return Ok(returnResult);
        }


        /// <summary>
        /// Returns a List Of Sample Detail
        /// </summary>
        /// <param name="idfMaterial">Material Id</param>
        /// <param name="idfVector">Vector Id</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VctsSampleGetDetail")]
        [ResponseType(typeof(List<Domain.VctsSampleGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> VctsSampleGetDetail(long idfMaterial,long idfVector, string languageId)
        {
            log.Info("Entering  VctsSampleGetDetail");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.VctsSampleGetDetailAsync(idfMaterial, idfVector, languageId);
                if (result == null)
                {
                    log.Info("Exiting  VctsSampleGetDetail With Not Found");
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
                log.Error("SQL Error in VctsSampleGetDetail Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsSampleGetDetail" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsSampleGetDetail");
            return Ok(returnResult);
        }


        /// <summary>
        /// Sets, Saves Field Test
        /// </summary>
        /// <param name="vctsVectFieldtestSetParams">Request Object Parameter</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("VctsVectFieldtestSet")]
        [ResponseType(typeof(int))]
        public async Task<IHttpActionResult> VctsVectFieldtestSet(VctsVectFieldtestSetParams vctsVectFieldtestSetParams)
        {
            log.Info("Entering  VctsVectFieldtestSet");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await  _repository.VctsVectFieldtestSetAsync(
                    vctsVectFieldtestSetParams.strFieldBarCode,
                    vctsVectFieldtestSetParams.langId,
                    vctsVectFieldtestSetParams.idfTesting,
                    vctsVectFieldtestSetParams.idfsTestName,
                    vctsVectFieldtestSetParams.idfsTestCategory,
                    vctsVectFieldtestSetParams.idfTestedByOffice,
                    vctsVectFieldtestSetParams.idfsTestResult,
                    vctsVectFieldtestSetParams.idfTestedByPerson,
                    vctsVectFieldtestSetParams.idfsDiagnosis);
                if (result == null)
                {
                    log.Info("Exiting  VctsVectFieldtestSet With Not Found");
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
                log.Error("SQL Error in VctsVectFieldtestSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsVectFieldtestSet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsVectFieldtestSet");
            return Ok(returnResult);
        }

        /// <summary>
        /// Deletes a Field Test
        /// </summary>
        /// <param name="idfTesting"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("VctsFieldtestDel")]
        [ResponseType(typeof(List<Domain.VctsFieldtestDelModel>))]
        public async Task<IHttpActionResult> VctsFieldtestDel(long idfTesting)
        {
            log.Info("Entering  VctsFieldtestDel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                
                var result = await _repository.VctsFieldtestDelAsync(idfTesting);
                if (result == null)
                {
                    log.Info("Exiting  VctsFieldtestDel With Not Found");
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
                log.Error("SQL Error in VctsFieldtestDel Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsFieldtestDel" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsFieldtestDel");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a list of Field Test Objects
        /// </summary>
        /// <param name="idfVector">Vector Id</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VctsFieldtestGetList")]
        [ResponseType(typeof(List<Domain.VctsFieldtestGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> VctsFieldtestGetList(long idfVector, string languageId)
        {
            log.Info("Entering  VctsFieldtestGetList");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                
                var result = await  _repository.VctsFieldtestGetListAsync(idfVector,languageId);
                if (result == null)
                {
                    log.Info("Exiting  VctsFieldtestGetList With Not Found");
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
                log.Error("SQL Error in VctsFieldtestGetList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsFieldtestGetList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsFieldtestGetList");
            return Ok(returnResult);
        }


        /// <summary>
        /// Returns Field Test Details
        /// </summary>
        /// <param name="idfTesting">Testing Id</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VctsFieldtestGetDetail")]
        [ResponseType(typeof(List<Domain.VctsFieldtestGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> VctsFieldtestGetDetail(int idfTesting, string languageId)
        {
            log.Info("Entering  VctsFieldtestGetDetail");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.VctsFieldtestGetDetailAsync(idfTesting, languageId);
                if (result == null)
                {
                    log.Info("Exiting  VctsFieldtestGetDetail With Not Found");
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
                log.Error("SQL Error in VctsFieldtestGetDetail Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsFieldtestGetDetail" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsFieldtestGetDetail");
            return Ok(returnResult);
        }



        /// <summary>
        /// Returns Collection Details
        /// </summary>
        /// <param name="idfVector">Vector Id</param>
        /// <param name="idfVectorSurveillanceSession">Surveillance Session Id</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VctsVectCollectionGetDetail")]
        [ResponseType(typeof(List<Domain.VctsVectCollectionGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> VctsVectCollectionGetDetail(long idfVector, long idfVectorSurveillanceSession, string languageId)
        {
            log.Info("Entering  VctsVectCollectionGetDetail");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
               
                var result = await _repository.VctsVectCollectionGetDetailAsync(idfVector,idfVectorSurveillanceSession, languageId);
                if (result == null)
                {
                    log.Info("Exiting  VctsVectCollectionGetDetail With Not Found");
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
                log.Error("SQL Error in VctsVectCollectionGetDetail Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsVectCollectionGetDetail" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsVectCollectionGetDetail");
            return Ok(returnResult);
        }

        /// <summary>
        /// Saves  Vector Type Collection Matrix Parameters
        /// </summary>
        /// <param name="vectorTyeCollectionMatrixSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("ConfVectortypecollectionmethodmatrixSetAsync")]
        [ResponseType(typeof(List<Domain.ConfVectortypecollectionmethodmatrixSetModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> ConfVectortypecollectionmethodmatrixSetAsync(VectorTyeCollectionMatrixSetParams vectorTyeCollectionMatrixSetParams)
        {
            log.Info("Entering  ConfVectortypecollectionmethodmatrixSetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.ConfVectortypecollectionmethodmatrixSetAsync(
                    vectorTyeCollectionMatrixSetParams.idfCollectionMethodForVectorType,
                    vectorTyeCollectionMatrixSetParams.idfsVectorType,
                    vectorTyeCollectionMatrixSetParams.idfsCollectionMethod);
                if (result == null)
                {
                    log.Info("Exiting  ConfVectortypecollectionmethodmatrixSetAsync With Not Found");
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
                log.Error("SQL Error in ConfVectortypecollectionmethodmatrixSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfVectortypecollectionmethodmatrixSetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfVectortypecollectionmethodmatrixSetAsync");
            return Ok(returnResult);
        }







        /// <summary>
        /// 
        /// </summary>
        /// <param name="idfCollectionMethodForVectorType"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("ConfVectortypecollectionmethodmatrixDelAsync")]
        [ResponseType(typeof(List<Domain.ConfVectortypecollectionmethodmatrixDelModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> ConfVectortypecollectionmethodmatrixDelAsync(long idfCollectionMethodForVectorType)
        {
            log.Info("Entering  ConfVectortypecollectionmethodmatrixDelAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {


                var result = await _repository.ConfVectortypecollectionmethodmatrixDelAsync(idfCollectionMethodForVectorType);
                if (result == null)
                {
                    log.Info("Exiting  ConfVectortypecollectionmethodmatrixDelAsync With Not Found");
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
                log.Error("SQL Error in ConfVectortypecollectionmethodmatrixDelAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfVectortypecollectionmethodmatrixDelAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfVectortypecollectionmethodmatrixDelAsync");
            return Ok(returnResult);
        }





        /// <summary>
        /// Deletes Vectortype Matrix
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfsVectorType"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("ConfVectortypecollectionmethodmatrixGetlistAsync")]
        [ResponseType(typeof(List<Domain.ConfVectortypecollectionmethodmatrixGetlistModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> ConfVectortypecollectionmethodmatrixGetlistAsync(string languageId, long idfsVectorType)
        {
            log.Info("Entering  ConfVectortypecollectionmethodmatrixGetlistModel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {


                var result = await _repository.ConfVectortypecollectionmethodmatrixGetlistAsync(languageId, idfsVectorType);
        
                if (result == null)
                {
                    log.Info("Exiting  ConfVectortypecollectionmethodmatrixGetlistModel With Not Found");
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
                log.Error("SQL Error in ConfVectortypecollectionmethodmatrixGetlistModel Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfVectortypecollectionmethodmatrixGetlistModel" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfVectortypecollectionmethodmatrixGetlistModel");
            return Ok(returnResult);
        }




        /// <summary>
        /// Returns Vector Lab
        /// </summary>
        /// <param name="idfVector"></param>
        /// <param name="idfVectorSurveillanceSession"></param>
        /// <param name="languageId"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VctsLabtestGetList")]
        [ResponseType(typeof(List<VctsLabtestGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> VctsLabtestGetList(long idfVector, long idfVectorSurveillanceSession, string languageId)
        {
            log.Info("Entering  ConfVectortypecollectionmethodmatrixGetlistModel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {


                var result = await _repository.VctsLabtestGetListAsync(idfVector, idfVectorSurveillanceSession, languageId);

                if (result == null)
                {
                    log.Info("Exiting  VctsLabtestGetList  With Not Found");
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
                log.Error("SQL Error in VctsLabtestGetList  Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VctsLabtestGetList " + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VctsLabtestGetList ");
            return Ok(returnResult);
        }





        /*
        ///// <summary>
        ///// Returns a List of Lab Test 
        ///// </summary>
        ///// <param name="userId">User Id</param>
        ///// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        ///// <param name="sampleID">An EIDSS internal identifier for the associated sample.</param>
        ///// <param name="paginationSetNumber">Limits the amount of data returned to 100 records at a time.</param>
        ///// <returns>
        ///// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        ///// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        ///// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        ///// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        ///// ReturnMessage = Response message returned to client
        ///// Results = JSON List of ResponseType Objects retrieved from Query
        ///// </returns>
        ////[HttpGet, Route("LabTestGetList")]
        ////[ResponseType(typeof(List<Domain.LabTestGetListModel>))]
        ////[CacheHttpGetAttribute(0, 0, false)]
        ////public async Task<IHttpActionResult> LabTestGetList(string languageId, long userId, long? sampleID, int paginationSetNumber)
        ////{
        ////    log.Info("Entering  LabTestGetList");
        ////    APIReturnResult returnResult = new APIReturnResult();
        ////    try
        ////    {


        ////        int pageSize = 10;
        ////        int maxPagesPerFetch = 10;

        ////        var result = await _repository.LabTestGetListAsync(languageId, userId, sampleID, paginationSetNumber, pageSize, maxPagesPerFetch);
        ////        if (result == null)
        ////        {
        ////            log.Info("Exiting  LabTestGetList With Not Found");
        ////            returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
        ////            returnResult.ErrorCode = HttpStatusCode.BadRequest;
        ////        }
        ////        else
        ////        {
        ////            returnResult.ErrorCode = HttpStatusCode.OK;
        ////            returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
        ////            returnResult.Results = JsonConvert.SerializeObject(result);
        ////        }
        ////    }
        ////    catch (SqlException ex)
        ////    {
        ////        log.Error("SQL Error in LabTestGetList Procedure: " + ex.Procedure, ex);
        ////        returnResult.ErrorMessage = ex.Message;
        ////        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        ////    }
        ////    catch (Exception ex)
        ////    {
        ////        log.Error("Error in LabTestGetList" + ex.Message, ex);
        ////        returnResult.ErrorMessage = ex.Message;
        ////        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        ////    }
        ////    log.Info("Exiting  LabTestGetList");
        ////    return Ok(returnResult);
        ////}
        ///
        */
    }
}












    
