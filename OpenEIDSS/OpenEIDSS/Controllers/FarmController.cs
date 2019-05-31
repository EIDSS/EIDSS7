using Newtonsoft.Json;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Domain.Return_Contracts;
using OpenEIDSS.Extensions.Attributes;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data.SqlClient;
using System.Net;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// Provides the ability to configure 
    /// </summary>
    [RoutePrefix("api/Farm")]
    public class FarmController : ApiController
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(FarmController));
        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// 
        /// </summary>
        public FarmController() : base()
        {

        }

        #region Farm (Snapshot) Methods

        /// <summary>
        /// Gets a single farm snapshot record based on user provided farm master ID.  This is not the farm master (actual) record.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="farmID"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("FarmGetDetailAsync")]
        [ResponseType(typeof(List<VetFarmGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetFarmDetailAsync([Required]string languageID, [Required]long farmID)
        {
            log.Info("GetFarmDetailAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VetFarmGetDetailAsync(
                    languageID,
                    farmID);

                if (result == null)
                {
                    log.Info("Exiting  GetFarmDetailAsync With Not Found");
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
                log.Error("SQL Error in GetFarmDetailAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetFarmDetailAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("GetFarmDetailAsync returned");
            return Ok(returnResult);
        }

        #endregion

        #region Farm (Master) Methods

        /// <summary>
        /// Gets a list of farm master records based on user provided filter criteria.
        /// </summary>
        /// <param name="parameters">Collection of filter parameters to filter the farm master list results.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("FarmMasterGetListAsync")]
        [ResponseType(typeof(List<VetFarmMasterGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetFarmMasterListAsync(FarmGetListParameters parameters)
        {
            log.Info("GetFarmMasterListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                var result = await _repository.VetFarmMasterGetListAsync(
                    parameters.LanguageID,
                    parameters.FarmMasterID,
                    parameters.EIDSSFarmID,
                    parameters.FarmTypeID,
                    parameters.FarmName,
                    parameters.FarmOwnerFirstName,
                    parameters.FarmOwnerLastName,
                    parameters.EIDSSFarmOwnerID,
                    parameters.FarmOwnerID,
                    parameters.RegionID,
                    parameters.RayonID,
                    parameters.SettlementTypeID,
                    parameters.SettlementID,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetFarmMasterListAsync With Not Found");
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
                log.Error("SQL Error in GetFarmMasterListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetFarmMasterListAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("GetFarmMasterListAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrives a count of farm master records meeting the search criteria.
        /// </summary>
        /// <param name="parameters">A collection of parameters</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("FarmMasterGetListCountAsync")]
        [ResponseType(typeof(List<VetFarmMasterGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetFarmMasterListCountAsync([FromBody]FarmGetListParameters parameters)
        {
            log.Info("GetFarmMasterListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.VetFarmMasterGetCountAsync(
                    parameters.LanguageID,
                    parameters.FarmMasterID,
                    parameters.EIDSSFarmID,
                    parameters.FarmTypeID,
                    parameters.FarmName,
                    parameters.FarmOwnerFirstName,
                    parameters.FarmOwnerLastName,
                    parameters.EIDSSFarmOwnerID,
                    parameters.FarmOwnerID,
                    parameters.RegionID,
                    parameters.RayonID,
                    parameters.SettlementTypeID,
                    parameters.SettlementID);

                if (result == null)
                {
                    log.Info("Exiting  GetFarmMasterListCountAsync With Not Found");
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
                log.Error("SQL Error in GetFarmMasterListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFarmMasterListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetFarmMasterListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a single farm master record based on user provided farm master ID.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="farmMasterID"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("FarmMasterGetDetailAsync")]
        [ResponseType(typeof(List<VetFarmMasterGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetFarmMasterDetailAsync([Required]string languageID, [Required]long farmMasterID)
        {
            log.Info("GetFarmMasterDetailAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VetFarmMasterGetDetailAsync(
                    languageID,
                    farmMasterID);

                if (result == null)
                {
                    log.Info("Exiting  GetFarmMasterDetailAsync With Not Found");
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
                log.Error("SQL Error in GetFarmMasterDetailAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetFarmMasterDetailAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("GetFarmMasterDetailAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a list of farm and associated herds or flocks and species based on user provided filter criteria.
        /// </summary>
        /// <param name="parameters">Collection of filter parameters to filter the farm, herd or flock and species hierarchy results.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("FarmHerdSpeciesGetListAsync")]
        [ResponseType(typeof(List<VetFarmHerdSpeciesGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetFarmHerdSpeciesListAsync(FarmHerdSpeciesGetListParameters parameters)
        {
            log.Info("GetFarmHerdSpeciesListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VetFarmHerdSpeciesGetListAsync(
                    parameters.LanguageID,
                    parameters.VeterinaryDiseaseReportID,
                    parameters.MonitoringSessionID,
                    parameters.FarmID,
                    parameters.FarmMasterID,
                    parameters.EIDSSFarmID);

                if (result == null)
                {
                    log.Info("Exiting  GetFarmHerdSpeciesListAsync With Not Found");
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
                log.Error("SQL Error in GetFarmHerdSpeciesListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetFarmHerdSpeciesListAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("GetFarmHerdSpeciesListAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Adds and updates a farm record primarily for the EIDSS veterinary module.
        /// </summary>
        /// <param name="parameters"> A collection of parameters that represents the data to post.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is success OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is failure Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is failure Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("FarmMasterSaveAsync")]
        [ResponseType(typeof(List<VetFarmMasterSetModel>))]
        public async Task<IHttpActionResult> SaveFarmMasterAsync([FromBody]FarmMasterSetParameters parameters)
        {
            log.Info("SaveFarmMasterAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.VetFarmMasterSetAsync(
                    parameters.LanguageID,
                    parameters.FarmMasterID, 
                    parameters.FarmTypeID, 
                    parameters.FarmOwnerID, 
                    parameters.FarmName, 
                    parameters.EIDSSFarmID, 
                    parameters.OwnershipStructureTypeID,
                    parameters.Fax, 
                    parameters.Email,
                    parameters.Phone, 
                    parameters.FarmAddressID, 
                    parameters.ForeignAddressIndicator, 
                    parameters.FarmAddressidfsCountry, 
                    parameters.FarmAddressidfsRegion, 
                    parameters.FarmAddressidfsRayon, 
                    parameters.FarmAddressidfsSettlement, 
                    parameters.FarmAddressstrStreetName, 
                    parameters.FarmAddressstrApartment, 
                    parameters.FarmAddressstrBuilding, 
                    parameters.FarmAddressstrHouse, 
                    parameters.FarmAddressidfsPostalCode, 
                    parameters.FarmAddressstrLatitude, 
                    parameters.FarmAddressstrLongitude,
                    JsonConvert.SerializeObject(parameters.HerdsOrFlocks),
                    JsonConvert.SerializeObject(parameters.Species));

                if (result == null)
                {
                    log.Info("Exiting  SaveFarmMasterAsync With Not Found");
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
                log.Error("SQL Error in SaveFarmMasterAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in SaveFarmMasterAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  SaveFarmMasterAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Deletes a farm master record.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="farmMasterID">A system assigned internal unique key that identifies the farm to delete.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpDelete, Route("FarmMasterDeleteAsync")]
        [ResponseType(typeof(List<VetFarmMasterDelModel>))]
        public async Task<IHttpActionResult> DeleteFarmMasterAsync(string languageID, long farmMasterID)
        {
            log.Info("DeleteFarmMasterAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VetFarmMasterDelAsync(languageID, farmMasterID);
                if (result == null)
                {
                    log.Info("Exiting  DeleteFarmMasterAsync With Not Found");
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
                log.Error("SQL Error in DeleteFarmMasterAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in DeleteFarmMasterAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  DeleteFarmMasterAsync");
            return Ok(returnResult);
        }

        #endregion
    }
}