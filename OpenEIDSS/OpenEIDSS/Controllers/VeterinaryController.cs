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
    /// Provides veterinary specific functionality including farm, livestock, avian, aberration analysis, etc
    /// </summary>
    [RoutePrefix("api/Veterinary")]
    public class VeterinaryController : ApiController
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(VeterinaryController));

        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// Creates a new instance of this class.
        /// </summary>
        public VeterinaryController() : base()
        {
        }

        #region Campaign Methods

        /// <summary>
        /// Gets a record count of active surveillance campaigns matching the search criteria, as well as, the total record count.
        /// </summary>
        /// <param name="parameters"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("VeterinaryCampaignGetCountAsync")]
        [ResponseType(typeof(List<VctCampaignGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetCampaignCountAsync([FromBody] CampaignGetListParameters parameters)
        {
            log.Info("GetCampaignCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VctCampaignGetCountAsync(
                    parameters.LanguageID,
                    parameters.EIDSSCampaignID,
                    parameters.CampaignName,
                    parameters.CampaignTypeID,
                    parameters.CampaignStatusTypeID,
                    parameters.StartDateFrom,
                    parameters.StartDateTo,
                    parameters.DiseaseID);

                log.Info("GetCampaignCountAsync returned");
                if (result == null)
                {
                    log.Info("Exiting  GetCampaignCountAsync With Not Found");
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
                log.Error("SQL Error in GetCampaignCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetCampaignCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetCampaignCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a list of active surveillance campaign records matching user provided search criteria.
        /// </summary>
        /// <param name="parameters"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("VeterinaryCampaignGetListAsync")]
        [ResponseType(typeof(List<VctCampaignGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetCampaignListAsync([FromBody] CampaignGetListParameters parameters)
        {
            log.Info("GetCampaignListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                var result = await _repository.VctCampaignGetListAsync(
                    parameters.LanguageID,
                    parameters.EIDSSCampaignID,
                    parameters.CampaignName,
                    parameters.CampaignTypeID,
                    parameters.CampaignStatusTypeID,
                    parameters.StartDateFrom,
                    parameters.StartDateTo,
                    parameters.DiseaseID, 
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                log.Info("GetCampaignListAsync returned");
                if (result == null)
                {
                    log.Info("Exiting  GetCampaignListAsync With Not Found");
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
                log.Error("SQL Error in GetCampaignListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetCampaignListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetCampaignListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a single active surveillance campaign record based on a user provided campaign ID.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="campaignID"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VeterinaryCampaignGetDetailAsync")]
        [ResponseType(typeof(List<VctCampaignGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetCampaignDetailAsync([Required]string languageID, [Required]long campaignID)
        {
            log.Info("GetCampaignDetailAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VctCampaignGetDetailAsync(
                    languageID,
                    campaignID);

                if (result == null)
                {
                    log.Info("Exiting  GetCampaignDetailAsync With Not Found");
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
                log.Error("SQL Error in GetCampaignDetailAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetCampaignDetailAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("GetCampaignDetailAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Adds and updates an active surveillance campaign including sample type to species type records. 
        /// </summary>
        /// <param name="parameters">A collection of parameters that represents the data to post.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("VeterinaryCampaignSaveAsync")]
        [ResponseType(typeof(List<VctCampaignSetModel>))]
        public async Task<IHttpActionResult> SaveCampaignAsync([FromBody]CampaignSetParameters parameters)
        {
            log.Info("SaveCampaignAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VctCampaignSetAsync(
                    parameters.LanguageID,
                    parameters.CampaignID,
                    parameters.CampaignTypeID,
                    parameters.CampaignStatusTypeID,
                    parameters.CampaignStartDate,
                    parameters.CampaignEndDate,
                    parameters.EIDSSCampaignID,
                    parameters.CampaignName,
                    parameters.CampaignAdministrator,
                    parameters.Conclusion,
                    parameters.DiseaseID,
                    parameters.SiteID,
                    parameters.CampaignCategoryTypeID,
                    parameters.AuditUserName,
                    parameters.RowStatus,
                    JsonConvert.SerializeObject(parameters.SpeciesToSampleTypeCombinations), 
                    JsonConvert.SerializeObject(parameters.MonitoringSessions));

                if (result == null)
                {
                    log.Info("Exiting  SaveCampaignAsync With Not Found");
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
                log.Error("SQL Error in SaveCampaignAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in SaveCampaignAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  SaveCampaignAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Deletes an active surveillance campaign.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country.</param>
        /// <param name="campaignID">A internal key that identifies the campaign to delete.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpDelete, Route("VeterinaryCampaignDeleteAsync")]
        [ResponseType(typeof(List<VctCampaignDelModel>))]
        public async Task<IHttpActionResult> DeleteCampaignAsync([Required]string languageID, [Required]long campaignID)
        {
            log.Info("DeleteCampaignAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VctCampaignDelAsync(languageID, campaignID);

                if (result == null)
                {
                    log.Info("Exiting  DeleteCampaignAsync With Not Found");
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
                log.Error("SQL Error in DeleteCampaignAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in DeleteCampaignAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  DeleteCampaignAsync");
            return Ok(returnResult);
        }

        #endregion

        #region Monitoring Session Methods

        /// <summary>
        /// Gets a record count of active surveillance monitoring sessions matching the search criteria, as well as, the total record count.
        /// </summary>
        /// <param name="parameters"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("VeterinaryMonitoringSessionGetCountAsync")]
        [ResponseType(typeof(List<VctMonitoringSessionGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetMonitoringSessionCountAsync([FromBody] MonitoringSessionGetListParameters parameters)
        {
            log.Info("GetMonitoringSessionCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VctMonitoringSessionGetCountAsync(
                    parameters.LanguageID,
                    parameters.EIDSSSessionID,
                    parameters.SessionStatusTypeID,
                    parameters.DateEnteredFrom,
                    parameters.DateEnteredTo,
                    parameters.RegionID,
                    parameters.RayonID,
                    parameters.DiseaseID,
                    parameters.EIDSSCampaignID, 
                    parameters.CampaignID);

                if (result == null)
                {
                    log.Info("Exiting  GetMonitoringSessionCountAsync With Not Found");
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
                log.Error("SQL Error in GetMonitoringSessionCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetMonitoringSessionCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetMonitoringSessionCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a list of active surveillance monitoring sessions matching user provided search criteria.
        /// </summary>
        /// <param name="parameters"></param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of response objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>
        [HttpPost, Route("VeterinaryMonitoringSessionGetListAsync")]
        [ResponseType(typeof(List<VctMonitoringSessionGetListModel>))]
        public async Task<IHttpActionResult> GetMonitoringSessionListAsync([FromBody] MonitoringSessionGetListParameters parameters)
        {
            log.Info("GetMonitoringSessionListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                var result = await _repository.VctMonitoringSessionGetListAsync(
                    parameters.LanguageID,
                    parameters.EIDSSSessionID,
                    parameters.SessionStatusTypeID,
                    parameters.DateEnteredFrom,
                    parameters.DateEnteredTo,
                    parameters.RegionID,
                    parameters.RayonID,
                    parameters.DiseaseID,
                    parameters.EIDSSCampaignID,
                    parameters.CampaignID, 
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetMonitoringSessionListAsync With Not Found");
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
                log.Error("SQL Error in GetMonitoringSessionListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetMonitoringSessionListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetMonitoringSessionListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a single active surveillance monitoring session record based on user provided monitoring session ID.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="monitoringSessionID"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VeterinaryMonitoringSessionGetDetailAsync")]
        [ResponseType(typeof(List<VctMonitoringSessionGetDetailModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetMonitoringSessionDetailAsync([Required]string languageID, [Required]long monitoringSessionID)
        {
            log.Info("GetMonitoringSessionDetailAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VctMonitoringSessionGetDetailAsync(languageID, monitoringSessionID);

                if (result == null)
                {
                    log.Info("Exiting  GetMonitoringSessionDetailAsync With Not Found");
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
                log.Error("SQL Error in GetMonitoringSessionDetailAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetMonitoringSessionDetailAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("GetMonitoringSessionDetailAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Adds and updates a veterinary monitoring session report including farm (snapshot), herd, species, 
        /// animal, sample type to species, sample, test, test interpretation, actions, and summary records. 
        /// for the veterinary module.
        /// </summary>
        /// <param name="parameters">A collection of parameters that represents the data to post.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("VeterinaryMonitoringSessionSaveAsync")]
        [ResponseType(typeof(VctMonitoringSessionSetModel))]
        public async Task<IHttpActionResult> SaveMonitoringSessionAsync([FromBody]MonitoringSessionSetParameters parameters)
        {
            log.Info("SaveMonitoringSessionAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VctMonitoringSessionSetAsync(
                    parameters.LanguageID,
                    parameters.MonitoringSessionID,
                    parameters.MonitoringSessionStatusTypeID,
                    parameters.CountryID,
                    parameters.RegionID,
                    parameters.RayonID,
                    parameters.SettlementID,
                    parameters.EnteredByPersonID,
                    parameters.CampaignID,
                    parameters.CampaignName,
                    parameters.CampaignTypeID,
                    parameters.SiteID,
                    parameters.EnteredDate,
                    parameters.EIDSSSessionID,
                    parameters.StartDate,
                    parameters.EndDate,
                    parameters.CampaignStartDate,
                    parameters.CampaignEndDate,
                    parameters.DiseaseID,
                    parameters.SessionCategoryTypeID,
                    parameters.RowStatus,
                    parameters.AvianOrLivestock,
                    JsonConvert.SerializeObject(parameters.DiseaseCombinations),
                    JsonConvert.SerializeObject(parameters.Farms), 
                    JsonConvert.SerializeObject(parameters.HerdsOrFlocks), 
                    JsonConvert.SerializeObject(parameters.Species),
                    JsonConvert.SerializeObject(parameters.Animals),
                    JsonConvert.SerializeObject(parameters.SpeciesToSampleTypeCombinations),
                    JsonConvert.SerializeObject(parameters.Samples),
                    JsonConvert.SerializeObject(parameters.Tests),
                    JsonConvert.SerializeObject(parameters.TestInterpretations),
                    JsonConvert.SerializeObject(parameters.Actions),
                    JsonConvert.SerializeObject(parameters.Summaries),
                    parameters.AuditUserName);

                if (result == null)
                {
                    log.Info("Exiting  SaveMonitoringSessionAsync With Not Found");
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
                log.Error("SQL Error in SaveMonitoringSessionAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in SaveMonitoringSessionAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  SaveMonitoringSessionAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Deletes an active surveillance campaign.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="monitoringSessionID">A system assigned internal unique key that identifies the monitoring session to delete.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpDelete, Route("VeterinaryMonitoringSessionDeleteAsync")]
        [ResponseType(typeof(List<VctMonitoringSessionDelModel>))]
        public async Task<IHttpActionResult> DeleteMonitoringSessionAsync([Required]string languageID, [Required]long monitoringSessionID)
        {
            log.Info("DeleteMonitoringSessionAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VctMonitoringSessionDelAsync(languageID, monitoringSessionID);
                if (result == null)
                {
                    log.Info("Exiting  DeleteMonitoringSessionAsync With Not Found");
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
                log.Error("SQL Error in DeleteMonitoringSessionAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in DeleteMonitoringSessionAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  DeleteMonitoringSessionAsync");
            return Ok(returnResult);
        }

        #endregion

        #region Disease Report Methods

        /// <summary>
        /// Gets a record count of veterinary disease reports matching the search criteria, as well as, the total record count.
        /// </summary>
        /// <param name="parameters"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("VeterinaryDiseaseReportListCountAsync")]
        [ResponseType(typeof(List<VetDiseaseReportGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetDiseaseReportListCountAsync([FromBody] VeterinaryDiseaseReportGetListParameters parameters)
        {
            log.Info("GetDiseaseReportListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VetDiseaseReportGetCountAsync(
                    parameters.LanguageID,
                    parameters.VeterinaryDiseaseReportID,
                    parameters.MonitoringSessionID,
                    parameters.FarmMasterID,
                    parameters.DiseaseID,
                    parameters.ReportStatusTypeID,
                    parameters.RegionID,
                    parameters.RayonID,
                    parameters.DateEnteredFrom,
                    parameters.DateEnteredTo,
                    parameters.ClassificationTypeID,
                    parameters.EIDSSReportID,
                    parameters.ReportTypeID,
                    parameters.SpeciesTypeID,
                    parameters.OutbreakCasesIndicator,
                    parameters.DiagnosisDateFrom, 
                    parameters.DiagnosisDateTo, 
                    parameters.InvestigationDateFrom, 
                    parameters.InvestigationDateTo,
                    parameters.LocalOrFieldSampleID, 
                    parameters.TotalAnimalQuantityFrom, 
                    parameters.TotalAnimalQuantityTo, 
                    parameters.SiteID);

                log.Info("GetDiseaseReportListCountAsync returned");
                if (result == null)
                {
                    log.Info("Exiting  GetDiseaseReportListCountAsync With Not Found");
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
                log.Error("SQL Error in GetDiseaseReportListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetDiseaseReportListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetDiseaseReportListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a list of veterinary disease reports matching user provided search criteria.
        /// </summary>
        /// <param name="parameters"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("VeterinaryDiseaseReportListAsync")]
        [ResponseType(typeof(List<VetDiseaseReportGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetDiseaseReportListAsync([FromBody] VeterinaryDiseaseReportGetListParameters parameters)
        {
            log.Info("GetDiseaseReportListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                var result = await _repository.VetDiseaseReportGetListAsync(
                    parameters.LanguageID,
                    parameters.VeterinaryDiseaseReportID,
                    parameters.MonitoringSessionID,
                    parameters.FarmMasterID,
                    parameters.DiseaseID,
                    parameters.ReportStatusTypeID,
                    parameters.RegionID,
                    parameters.RayonID,
                    parameters.DateEnteredFrom,
                    parameters.DateEnteredTo,
                    parameters.ClassificationTypeID,
                    parameters.EIDSSReportID,
                    parameters.ReportTypeID, 
                    parameters.SpeciesTypeID,
                    parameters.OutbreakCasesIndicator,
                    parameters.DiagnosisDateFrom,
                    parameters.DiagnosisDateTo,
                    parameters.InvestigationDateFrom,
                    parameters.InvestigationDateTo,
                    parameters.LocalOrFieldSampleID,
                    parameters.TotalAnimalQuantityFrom,
                    parameters.TotalAnimalQuantityTo,
                    parameters.SiteID,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                log.Info("GetDiseaseReportListAsync returned");
                if (result == null)
                {
                    log.Info("Exiting  GetDiseaseReportListAsync With Not Found");
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
                log.Error("SQL Error in GetDiseaseReportListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetDiseaseReportListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetDiseaseReportListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Adds and updates a veterinary disease report including farm (snapshot), herd, species, 
        /// animal, vaccination, laboratory sample, penside test, test, test interpretation, report log records 
        /// for the veterinary module.
        /// </summary>
        /// <param name="parameters">A collection of parameters that represents the data to post.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("VeterinaryDiseaseReportSaveAsync")]
        [ResponseType(typeof(List<VetDiseaseReportSetModel>))]
        public async Task<IHttpActionResult> SaveDiseaseReportAsync([FromBody]VeterinaryDiseaseReportSetParameters parameters)
        {
            log.Info("SaveDiseaseReportAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VetDiseaseReportSetAsync(
                    parameters.LanguageID,
                    parameters.VeterinaryDiseaseReportID,
                    parameters.FarmID,
                    parameters.FarmMasterID,
                    parameters.FarmOwnerID,
                    parameters.DiseaseID,
                    parameters.EnteredByPersonID,
                    parameters.ReportedByPersonID,
                    parameters.InvestigatedByPersonID,
                    parameters.SiteID,
                    parameters.InitialReportDate,
                    parameters.AssignedDate,
                    parameters.InvestigationDate,
                    parameters.EIDSSFieldAccessionID,
                    parameters.RowStatus,
                    parameters.ReportedByOrganizationID,
                    parameters.InvestigatedByOrganizationID,
                    parameters.ReportTypeID,
                    parameters.ClassificationTypeID,
                    parameters.OutbreakID,
                    parameters.EnteredDate,
                    parameters.EIDSSReportID,
                    parameters.ReportStatusTypeID,
                    parameters.MonitoringSessionID,
                    parameters.ReportCategoryTypeID,
                    parameters.FarmSickAnimalQuantity,
                    parameters.FarmTotalAnimalQuantity,
                    parameters.FarmDeadAnimalQuantity,
                    parameters.OriginalVeterinaryDiseaseReportID,
                    parameters.FarmEpidemiologicalObservationID,
                    parameters.ControlMeasuresObservationID,
                    JsonConvert.SerializeObject(parameters.HerdsOrFlocks),
                    JsonConvert.SerializeObject(parameters.Species),
                    JsonConvert.SerializeObject(parameters.Animals),
                    JsonConvert.SerializeObject(parameters.Vaccinations),
                    JsonConvert.SerializeObject(parameters.Samples),
                    JsonConvert.SerializeObject(parameters.PensideTests),
                    JsonConvert.SerializeObject(parameters.Tests),
                    JsonConvert.SerializeObject(parameters.TestInterpretations),
                    JsonConvert.SerializeObject(parameters.VeterinaryDiseaseReportLogs));

                if (result == null)
                {
                    log.Info("Exiting  SaveDiseaseReportAsync With Not Found");
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
                log.Error("SQL Error in SaveDiseaseReportAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in SaveDiseaseReportAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  SaveDiseaseReportAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a single veterinary disease report record based on user provided report ID.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country.</param>
        /// <param name="veterinaryDiseaseReportID">An internal identifier that identifies the veterinary disease report.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VeterinaryDiseaseReportGetDetailAsync")]
        [ResponseType(typeof(List<VetDiseaseReportGetDetailModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetDiseaseReportDetailAsync([Required]string languageID, [Required]long veterinaryDiseaseReportID)
        {
            log.Info("GetDiseaseReportDetailAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VetDiseaseReportGetDetailAsync(
                    languageID,
                    veterinaryDiseaseReportID);

                if (result == null)
                {
                    log.Info("Exiting  GetDiseaseReportDetailAsync With Not Found");
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
                log.Error("SQL Error in GetDiseaseReportDetailAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetDiseaseReportDetailAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("GetDiseaseReportDetailAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Deletes a veterinary disease report.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country.</param>
        /// <param name="veterinaryDiseaseReportID">A system assigned internal unique key that identifies the veterinary disease report to delete.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpDelete, Route("VeterinaryDiseaseReportDeleteAsync")]
        [ResponseType(typeof(List<VetDiseaseReportDelModel>))]
        public async Task<IHttpActionResult> DeleteDiseaseReportAsync([Required]string languageID, [Required]long veterinaryDiseaseReportID)
        {
            log.Info("DeleteDiseaseReportAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VetDiseaseReportDelAsync(languageID, veterinaryDiseaseReportID);
                if (result == null)
                {
                    log.Info("Exiting  DeleteDiseaseReportAsync With Not Found");
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
                log.Error("SQL Error in DeleteDiseaseReportAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in DeleteDiseaseReportAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  DeleteDiseaseReportAsync");
            return Ok(returnResult);
        }

        #endregion

        #region Vaccination Methods

        /// <summary>
        /// Retrives a list of vaccination records by veterinary disease report or species identifiers.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country.</param>
        /// <param name="veterinaryDiseaseReportID">An internal system Identifier for the veterinary disease report.</param>
        /// <param name="speciesID">An internal system identifier for the farm species record.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VaccinationGetListAsync")]
        [ResponseType(typeof(List<VetVaccinationGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetVaccinationListAsync([Required]string languageID, long? veterinaryDiseaseReportID, long? speciesID)
        {
            log.Info("GetVaccinationListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VetVaccinationGetListAsync(languageID, veterinaryDiseaseReportID, speciesID);
                if (result == null)
                {
                    log.Info("Exiting  GetVaccinationListAsync With Not Found");
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
                log.Error("SQL Error in GetVaccinationListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetVaccinationListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetVaccinationListAsync");
            return Ok(returnResult);
        }

        #endregion

        #region Animal Methods

        /// <summary>
        /// Gets a list of animal records by disease report, active surveillance monitoring session, species, laboratory sample or observation identifiers.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country.</param>
        /// <param name="veterinaryDiseaseReportID">An internal identifier for the veterinary disease report record.</param>
        /// <param name="monitoringSessionID">An identifier for the veterinary active surveillance monitoring session record.</param>
        /// <param name="speciesID">An internal identifier for the farm species record.</param>
        /// <param name="sampleID">An internal identifier for the laboratory sample record.</param>
        /// <param name="observationID">An internal identifier for the flexible form observation link.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("AnimalGetListAsync")]
        [ResponseType(typeof(List<VetAnimalGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetAnimalListAsync([Required]string languageID, long? veterinaryDiseaseReportID, long? monitoringSessionID, long? speciesID, long? sampleID, long? observationID)
        {
            log.Info("GetAnimalListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VetAnimalGetListAsync(languageID, speciesID, observationID, sampleID, veterinaryDiseaseReportID, monitoringSessionID);
                if (result == null)
                {
                    log.Info("Exiting  GetAnimalListAsync With Not Found");
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
                log.Error("SQL Error in GetAnimalListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetAnimalListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetAnimalListAsync");
            return Ok(returnResult);
        }

        #endregion

        #region Penside Test Methods

        /// <summary>
        /// Gets a list of penside test records by veterinary disease report or sample identifiers.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country.</param>
        /// <param name="veterinaryDiseaseReportID">An internal identifier for the veterinary disease report.</param>
        /// <param name="sampleID">An internal identifier for the laboratory sample record.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("PensideTestGetListAsync")]
        [ResponseType(typeof(List<VetPensideTestGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetPensideTestListAsync([Required]string languageID, long? veterinaryDiseaseReportID, long? sampleID)
        {
            log.Info("GetPensideTestListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VetPensideTestGetListAsync(languageID, veterinaryDiseaseReportID, sampleID);
                if (result == null)
                {
                    log.Info("Exiting  GetPensideTestListAsync With Not Found");
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
                log.Error("SQL Error in GetPensideTestListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetPensideTestListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetPensideTestListAsync");
            return Ok(returnResult);
        }

        #endregion

        #region Disease Report Log Methods

        /// <summary>
        /// Gets a list of disease report log records for a veterinary disease report.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country.</param>
        /// <param name="veterinaryDiseaseReportID">An internal identifier for the veterinary disease report.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("DiseaseReportLogGetListAsync")]
        [ResponseType(typeof(List<VetDiseaseReportLogGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetDiseaseReportLogListAsync([Required]string languageID, [Required]long veterinaryDiseaseReportID)
        {
            log.Info("GetDiseaseReportLogListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VetDiseaseReportLogGetListAsync(languageID, veterinaryDiseaseReportID);
                if (result == null)
                {
                    log.Info("Exiting  GetDiseaseReportLogListAsync With Not Found");
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
                log.Error("SQL Error in GetDiseaseReportLogListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetDiseaseReportLogListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetDiseaseReportLogListAsync");
            return Ok(returnResult);
        }

        #endregion

        #region Campaign Species To Sample Type Methods

        /// <summary>
        /// Gets a list of campaign species to sample type records for an active surveillance campaign.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country.</param>
        /// <param name="campaignID">An internal identifier for the active surveillance monitoring session.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VeterinaryCampaignSpeciesToSampleTypeGetListAsync")]
        [ResponseType(typeof(List<VctCampaignSpeciesToSampleTypeGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetCampaignSpeciesToSampleTypeListAsync([Required]string languageID, [Required]long campaignID)
        {
            log.Info("GetCampaignSpeciesToSampleTypeListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VctCampaignSpeciesToSampleTypeGetListAsync(languageID, campaignID);
                if (result == null)
                {
                    log.Info("Exiting  GetCampaignSpeciesToSampleTypeListAsync With Not Found");
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
                log.Error("SQL Error in GetCampaignSpeciesToSampleTypeListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetCampaignSpeciesToSampleTypeListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetCampaignSpeciesToSampleTypeListAsync");
            return Ok(returnResult);
        }

        #endregion

        #region Monitoring Session To Disease Methods

        /// <summary>
        /// Gets a list of monitoring session to disease records for an active surveillance monitoring session.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country.</param>
        /// <param name="monitoringSessionID">An internal identifier for the active surveillance monitoring session.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VeterinaryMonitoringSessionToDiseaseGetListAsync")]
        [ResponseType(typeof(List<VctMonitoringSessionToDiseaseGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetMonitoringSessionToDiseaseListAsync([Required]string languageID, [Required]long monitoringSessionID)
        {
            log.Info("GetMonitoringSessionToDiseaseListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VctMonitoringSessionToDiseaseGetListAsync(languageID, monitoringSessionID);
                if (result == null)
                {
                    log.Info("Exiting  GetMonitoringSessionToDiseaseListAsync With Not Found");
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
                log.Error("SQL Error in GetMonitoringSessionToDiseaseListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetMonitoringSessionToDiseaseListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetMonitoringSessionToDiseaseListAsync");
            return Ok(returnResult);
        }

        #endregion

        #region Monitoring Session Species To Sample Type Methods

        /// <summary>
        /// Gets a list of monitoring session species to sample type records for an active surveillance monitoring session.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country.</param>
        /// <param name="monitoringSessionID">An internal identifier for the active surveillance monitoring session.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VeterinaryMonitoringSessionSpeciesToSampleTypeGetListAsync")]
        [ResponseType(typeof(List<VctMonitoringSessionSpeciesToSampleTypeGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetMonitoringSessionSpeciesToSampleTypeListAsync([Required]string languageID, [Required]long monitoringSessionID)
        {
            log.Info("GetMonitoringSessionSpeciesToSampleTypeListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VctMonitoringSessionSpeciesToSampleTypeGetListAsync(languageID, monitoringSessionID);
                if (result == null)
                {
                    log.Info("Exiting  GetMonitoringSessionSpeciesToSampleTypeListAsync With Not Found");
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
                log.Error("SQL Error in GetMonitoringSessionSpeciesToSampleTypeListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetMonitoringSessionSpeciesToSampleTypeListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetMonitoringSessionSpeciesToSampleTypeListAsync");
            return Ok(returnResult);
        }

        #endregion

        #region Monitoring Session Action Methods

        /// <summary>
        /// Gets a list of monitoring session action records for an active surveillance monitoring session.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country.</param>
        /// <param name="monitoringSessionID">An internal identifier for the active surveillance monitoring session.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("MonitoringSessionActionGetListAsync")]
        [ResponseType(typeof(List<VctMonitoringSessionActionGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetMonitoringSessionActionListAsync([Required]string languageID, [Required]long monitoringSessionID)
        {
            log.Info("GetMonitoringSessionActionListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VctMonitoringSessionActionGetListAsync(languageID, monitoringSessionID);
                if (result == null)
                {
                    log.Info("Exiting  GetMonitoringSessionActionListAsync With Not Found");
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
                log.Error("SQL Error in GetMonitoringSessionActionListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetMonitoringSessionActionListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
        
            log.Info("Exiting  GetMonitoringSessionActionListAsync");
            return Ok(returnResult);
        }

        #endregion

        #region Monitoring Session Summary Methods

        /// <summary>
        /// Gets a list of monitoring session summary/aggregate information records for an active surveillance monitoring session.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country.</param>
        /// <param name="monitoringSessionID">An internal identifier for the active surveillance monitoring session.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("MonitoringSessionSummaryGetListAsync")]
        [ResponseType(typeof(List<VctMonitoringSessionSummaryGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetMonitoringSessionSummaryListAsync([Required]string languageID, [Required]long monitoringSessionID)
        {
            log.Info("GetMonitoringSessionSummaryListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.VctMonitoringSessionSummaryGetListAsync(languageID, monitoringSessionID);
                if (result == null)
                {
                    log.Info("Exiting  GetMonitoringSessionSummaryListAsync With Not Found");
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
                log.Error("SQL Error in GetMonitoringSessionSummaryListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetMonitoringSessionSummaryListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetMonitoringSessionSummaryListAsync");
            return Ok(returnResult);
        }

        #endregion
    }
}