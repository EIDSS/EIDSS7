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
    /// API resonsible for Settlement functionality
    /// </summary>
    [RoutePrefix("api/Admin")]
    public class SettlementController : ApiController
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(SettlementController));
        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// Instantiates a new Instance Of Class -- Contructor 
        /// </summary>
        /// 
        public SettlementController() : base()
        {

        }


        /// <summary>
        /// Returns a Lit of Settlements
        /// </summary>
        /// <param name="settlementGetListParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("GetSettlementList")]
        [ResponseType(typeof(List<AdminStleGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetSettlementList([FromBody]SettlementGetListParams settlementGetListParams)
        {
            log.Info("Entering  GetSettlementList ");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.AdminStleGetListAsync(
                    settlementGetListParams.langId,
                    settlementGetListParams.idfsSettlement,
                    settlementGetListParams.idfsSettlementType,
                    settlementGetListParams.defaultName,
                    settlementGetListParams.strNationalName,
                    settlementGetListParams.idfsRegion,
                    settlementGetListParams.idfsRayon,
                    settlementGetListParams.latMin,
                    settlementGetListParams.latMax,
                    settlementGetListParams.lngMin,
                    settlementGetListParams.lngMax,
                    settlementGetListParams.elemMin,
                    settlementGetListParams.eleMax
                    );
                if (result == null)
                {
                    log.Info(" GetSettlementList With Not Found");
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
                log.Error("SQL Error in GetSettlementList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetSettlementList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetSettlementList");
            return Ok(returnResult);
        }


        /// <summary>
        /// Resturns details of a Settlement
        /// </summary>
        /// <param name="idfsSettlementId">Unique Id of settlement</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetSettlementDetail")]
        [ResponseType(typeof(List<AdminStleGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetSettlementDetail(string idfsSettlementId, string languageId)
        {
            log.Info("Entering  GetSettlementDetail ");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.AdminStleGetDetailAsync(idfsSettlementId, languageId);
                if (result == null)
                {
                    log.Info(" GetSettlementDetail With Not Found");
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
                log.Error("SQL Error in GetSettlementDetail Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetSettlementDetail" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetSettlementDetail");
            return Ok(returnResult);
        }

        /// <summary>
        /// Creates a Settlement
        /// </summary>
        /// <param name="adminSetSettlementParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("SetSettlement")]
        [ResponseType(typeof(List<AdminStleSetModel>))]
        public async Task<IHttpActionResult> SetSettlement([FromBody] AdminSetSettlementParams adminSetSettlementParams)
        {
            log.Info("Entering  SetSettlement ");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.AdminStatSetAsync(
                    adminSetSettlementParams.idfsStatistic,
                    adminSetSettlementParams.idfsStatisticalAgeGroup,
                    adminSetSettlementParams.idfsMainBaseReference,
                    adminSetSettlementParams.idfsStatisticAreaType,
                    adminSetSettlementParams.idfsStatisticPeriodType,
                    adminSetSettlementParams.locationUserControlidfsCountry,
                    adminSetSettlementParams.locationUserControlidfsRegion,
                    adminSetSettlementParams.locationUserControlidfsRayon,
                    adminSetSettlementParams.datStatisticStartDate,
                    adminSetSettlementParams.datStatisticFinishDate,
                    adminSetSettlementParams.varValue,
                    adminSetSettlementParams.idfsStatisticalAgeGroup,
                    adminSetSettlementParams.idfsParameterName
                    );
                if (result == null)
                {
                    log.Info(" SetSettlement With Not Found");
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
                log.Error("SQL Error in SetSettlement Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in SetSettlement" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  SetSettlement");
            return Ok(returnResult);
            
        }


        /// <summary>
        /// Deletes a settlement
        /// </summary>
        /// <param name="idfsSettlement">Unique Id of a Settlement</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("DeleteSettlement")]
        [ResponseType(typeof(List<AdminStleDelModel>))]
        public async Task<IHttpActionResult> DeleteSettlement(long idfsSettlement)
        {
            log.Info("Entering  DeleteSettlement ");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.AdminStleDelAsync(idfsSettlement);
                if (result == null)
                {
                    log.Info(" DeleteSettlement With Not Found");
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
                log.Error("SQL Error in DeleteSettlement Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in DeleteSettlement" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  DeleteSettlement");
            return Ok(returnResult);
        }


        /// <summary>
        /// Returns settlement type by language
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
        [HttpGet, Route("GetSettlementType")]
        [ResponseType(typeof(List<SettlementTypeGetLookupModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetSettlementType(string languageId)
        {
            log.Info("Entering  GetSettlementType ");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await  _repository.SettlementTypeGetLookupAsync(languageId);
                if (result == null)
                {
                    log.Info(" GetSettlementType With Not Found");
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
                log.Error("SQL Error in GetSettlementType Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetSettlementType" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetSettlementType");
            return Ok(returnResult);
        }


        /// <summary>
        /// Returns Settlements by langguage,rayon and id
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="rayonId">Unique Id of Rayon</param>
        /// <param name="id"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetSettlementLookUp")]
        [ResponseType(typeof(List<SettlementGetLookupModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetSettlementLookUp(string languageId, long? rayonId,long? id)
        {
            log.Info("Entering  GetSettlementLookUp ");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.SettlementGetLookupAsync(languageId, rayonId, id);
                if (result == null | result.Count == 0)
                    return NotFound();
                log.Info("Exiting  GetSettlementLookUp");
                if (result == null)
                {
                    log.Info(" GetSettlementLookUp With Not Found");
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
                log.Error("SQL Error in GetSettlementLookUp Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetSettlementLookUp" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetSettlementLookUp");
            return Ok(returnResult);
        }



    }
}
