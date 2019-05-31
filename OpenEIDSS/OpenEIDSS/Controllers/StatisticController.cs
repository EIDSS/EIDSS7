using Newtonsoft.Json;
using OpenEIDSS.Extensions.Attributes;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Domain.Return_Contracts;
using OpenEIDSS.Extensions;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
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
    /// API responsible for Statistic Information
    /// </summary>
    [RoutePrefix("api/Admin")]

    public class StatisticController : ApiController
    {

        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(StatisticController));
        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// Instantiates a new Instance Of Class -- Contructor 
        /// </summary>
        /// 
        public StatisticController() : base()
        {
        }

        /// <summary>
        /// Returns A list of Statistics
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsStatisticalDataType">id of DataType</param>
        /// <param name="idfsArea">Area Id</param>
        /// <param name="datStatisticStartDateFrom">Start Date</param>
        /// <param name="datStatisticStartDateTo">End Date</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet,Route("GetStatList")]
        [ResponseType(typeof(List<Domain.AdminStatGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetStatList(string languageId, long? idfsStatisticalDataType, long ? idfsArea, DateTime? datStatisticStartDateFrom, DateTime? datStatisticStartDateTo)
        {
            log.Info("Entering  GetStatList");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await  _repository.AdminStatGetListAsync(languageId,idfsStatisticalDataType,idfsArea,datStatisticStartDateFrom,datStatisticStartDateTo);

                if (result == null )
                {
                    log.Info("Exiting  GetStatList With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                    log.Info("Exiting  GetStatList Not found ");
                }
                else
                {

                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                    log.Info("Exiting  GetStatList ");
                }
                  
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in GetStatList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetStatList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            return Json(returnResult);
        }


        /// <summary>
        /// Retruns an Area Type
        /// </summary>
        /// <param name="area"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet,Route("StatGetAreaType")]
        [ResponseType(typeof(List<Domain.StatisticGetAreaTypeModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> StatGetAreaType(long? area)
        {
            log.Info("Entering  StatGetAreaType");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result =  await _repository.StatisticGetAreaTypeAsync(area);

                if (result == null)
                {
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                    log.Info("Exiting  StatGetAreaType NOT FOUND ");
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                    log.Info("Exiting  StatGetAreaType ");
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in StatGetAreaType Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in StatGetAreaType" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            return Json(returnResult);
        }




        /// <summary>
        /// Deltes a Statistic
        /// </summary>
        /// <param name="id"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("DeleteStat")]
        [ResponseType(typeof(int))]
        public async Task<IHttpActionResult> DeleteStats(long id)
        {
            log.Info("Entering  DeleteStats");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.StatisticDeleteAsync(id);
                if (result == null)
                {
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                    log.Info("Exiting  DeleteStats NOT FOUND");
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                    log.Info("Exiting  DeleteStats ");
                }

            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in DeleteStats Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in DeleteStats" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            return Json(returnResult);
        }




        /// <summary>
        /// Returns  a Statistic DataType
        /// </summary>
        /// <param name="idfsStatisticDataType">id of Datatype</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet,Route("StatGetDataType")]
        [ResponseType(typeof(List<Domain.StatisticGetDataTypeModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> StatsGetDataType(long idfsStatisticDataType)
        {
            log.Info("Entering  StatsGetDataType");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.StatisticGetDataTypeAsync(idfsStatisticDataType);
                if (result == null)
                {
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                    log.Info("Exiting  StatsGetDataType NOT FOUND");
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                    log.Info("Exiting  StatsGetDataType ");
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in StatsGetDataType Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in StatsGetDataType" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            return Json(returnResult);
        }
    


        /// <summary>
        /// Returns details about a Statistic
        /// </summary>
        /// <param name="idfStatistic">Statistic Id</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost,Route("GetStatsDetail")]
        [ResponseType(typeof(List<Domain.AdminStatGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult>StatsGetDetail(long idfStatistic, string languageId)
        {
            log.Info("Entering  StatsGetDetail");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.AdminStatGetDetailAsync(idfStatistic, languageId);
                if (result == null)
                {
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                    log.Info("Exiting  StatsGetDetail NOT FOUND ");
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                    log.Info("Exiting  StatsGetDetail ");
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in StatsGetDetail Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in StatsGetDetail" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            return Json(returnResult);
        }


        /// <summary>
        /// Return Details about a Statistic Type
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
        [HttpPost,Route("GetStatTypeDetail")]
        [ResponseType(typeof(List<Domain.RefStatisticTypeGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> StatsTypeGetDetail(string languageId)
        {
            log.Info("Entering  StatsTypeGetDetail");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.StatisticTypeGetDetailAsync(languageId);

                if (result == null)
                {
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                    log.Info("Exiting  StatsTypeGetDetail NOT FOUND");
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                    log.Info("Exiting  StatsTypeGetDetail ");
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in StatsTypeGetDetail Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in StatsTypeGetDetail" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            return Json(returnResult);
        }



        /// <summary>
        /// Sets Saves a Statistic
        /// </summary>
        /// <param name="adminSetStatParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost,Route("SetStat")]
        [ResponseType(typeof(List<Domain.AdminStatSetModel>))]
        
        public async Task<IHttpActionResult> SetStat([FromBody] AdminSetStatParams adminSetStatParams)
        {
            log.Info("Entering SetStat");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.AdminStatSetAsync(
                    adminSetStatParams.idfStatistic,
                    adminSetStatParams.idfsStatisticDataType,
                    adminSetStatParams.idfsMainBaseReference,
                    adminSetStatParams.idfsStatisticAreaType,
                    adminSetStatParams.idfsStatisticPeriodType,
                    adminSetStatParams.locationUserControlidfsCountry,
                    adminSetStatParams.locationUserControlidfsRegion,
                    adminSetStatParams.idfsUserControlidfsRayon,
                    adminSetStatParams.datStatisticStartDate,
                    adminSetStatParams.datStatisticFinishDate,
                    adminSetStatParams.varValue,
                    adminSetStatParams.idfsStatisticalAgeGroup,
                    adminSetStatParams.idfsParameterName
                    );
                if (result == null)
                {
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                    log.Info("Exiting  SetStat NOT FOUND ");
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                    log.Info("Exiting  SetStat");
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in SetStat Proc" + ex.Procedure, ex);
                return InternalServerError(ex);
            }
            catch (Exception ex)
            {
                log.Error("Error in SetStat" + ex.Message, ex);
                return InternalServerError(ex);
            }

            return Json(returnResult);
        }       


        /// <summary>
        /// Returns List of Reference Statistical Data Types
        /// </summary>
        /// <param name="lagnuageId"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("RefStatisticdatatypeGetList")]
        [ResponseType(typeof(List<Domain.RefStatisticdatatypeGetListModel>))]
        //[CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> RefStatisticdatatypeGetList(string lagnuageId)
        {
            log.Info("Entering  RefStatisticdatatypeGetList");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.RefStatisticdatatypeGetListAsync(lagnuageId);
                if (result == null)
                {
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                    log.Info("Exiting  RefStatisticdatatypeGetList NOT FOUND");
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                    log.Info("Exiting  RefStatisticdatatypeGetList");
                }
                  
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in RefStatisticdatatypeGetList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefStatisticdatatypeGetList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            return Json(returnResult);
        }

        /// <summary>
        /// Sets , Saves a Reference Data Type
        /// </summary>
        /// <param name="referenceStatDataTypeSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("RefStatisticdatatypeSet")]
        [ResponseType(typeof(List<RefStatisticdatatypeSetModel>))]
        public async Task<IHttpActionResult> RefStatisticdatatypeSet(ReferenceStatDataTypeSetParams  referenceStatDataTypeSetParams)
        {
            log.Info("Entering  RefStatisticdatatypeSet");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.RefStatisticdatatypeSetAsync(
                    referenceStatDataTypeSetParams.idfsStatisticDataType,
                    referenceStatDataTypeSetParams.strDefault,
                    referenceStatDataTypeSetParams.strName,
                    referenceStatDataTypeSetParams.idfsReferenceType,
                    referenceStatDataTypeSetParams.idfsStatisticPeriodType,
                    referenceStatDataTypeSetParams.idfsStatisticAreaType,
                    referenceStatDataTypeSetParams.blnRelatedWithAgeGroup,
                    referenceStatDataTypeSetParams.languageId);
                if (result == null)
                {
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                    log.Info("Exiting  RefStatisticdatatypeSet NOT FOUND");
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                    log.Info("Exiting  RefStatisticdatatypeSet");
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in RefStatisticdatatypeSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefStatisticdatatypeSet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            return Json(returnResult);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="idfsStatisticDataType"></param>
        /// <param name="deleteAnyway"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("RefStatisticdatatypeDel")]
        [ResponseType(typeof(List<RefStatisticdatatypeDelModel>))]
        public async Task<IHttpActionResult> RefStatisticdatatypeDel(long idfsStatisticDataType, bool deleteAnyway)
        {
            log.Info("Entering  RefStatisticdatatypeDel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
               
                var result = await _repository.RefStatisticdatatypeDelAsync(idfsStatisticDataType, deleteAnyway);
                if (result == null)
                {
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                    log.Info("Exiting  RefStatisticdatatypeDel NOT FOUND");
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                    log.Info("Exiting  RefStatisticdatatypeDel");
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in RefStatisticdatatypeDel Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefStatisticdatatypeDel" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            return Json(returnResult);
        }
    }
}

