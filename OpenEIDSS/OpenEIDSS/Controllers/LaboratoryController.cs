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

namespace EIDSS.Web.API.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    [RoutePrefix("api/Lab")]
    public class LaboratoryController : ApiController
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(LaboratoryController));
        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// Creates a new instance of this class
        /// </summary>
        public LaboratoryController() : base()
        {

        }

        /// <summary>
        /// Gets details about a sample.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country.</param>
        /// <param name="sampleID">The sample identifier of the record to get details on.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("LaboratorySampleGetDetailAsync")]
        [ResponseType(typeof(List<LabSampleGetDetailModel>))]
        public async Task<IHttpActionResult> GetLaboratorySampleDetailAsync([Required]string languageID, [Required]long sampleID)
        {
            log.Info("GetLaboratorySampleDetailAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.LabSampleGetDetailAsync(languageID, sampleID);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratorySampleDetailAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratorySampleDetailAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratorySampleDetailAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratorySampleDetailAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a list of unaccessioned laboratory samples, or ones that have accessioned in the last 14 calendar days.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratorySampleGetListParameters"/>.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("LaboratorySampleGetListAsync")]
        [ResponseType(typeof(List<LabSampleGetListModel>))]
        public async Task<IHttpActionResult> GetLaboratorySampleListAsync([FromBody]LaboratorySampleGetListParameters parameters)
        {
            log.Info("GetLaboratorySampleListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                // Call the database.
                var result = await _repository.LabSampleGetListAsync(
                    parameters.LanguageID,
                    parameters.UserID,
                    parameters.OrganizationID, 
                    parameters.SiteID,
                    parameters.SampleID,
                    parameters.ParentSampleID,
                    parameters.DaysFromAccessionDate,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratorySampleListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratorySampleListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratorySampleListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratorySampleListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a count of unaccessioned laboratory samples, or ones that have accessioned in the last 14 calendar days.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratorySampleGetListParameters"/>.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("LaboratorySampleGetListCountAsync")]
        [ResponseType(typeof(List<LabSampleGetCountModel>))]
        public async Task<IHttpActionResult> GetLaboratorySampleListCountAsync([FromBody]LaboratorySampleGetListParameters parameters)
        {
            log.Info("GetLaboratorySampleListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabSampleGetCountAsync(
                    parameters.LanguageID,
                    parameters.OrganizationID,
                    parameters.SiteID,
                    parameters.SampleID,
                    parameters.ParentSampleID,
                    parameters.DaysFromAccessionDate);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratorySampleListCountAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratorySampleListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratorySampleListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratorySampleListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a list of samples based on user provided search criteria.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("LaboratorySampleSearchGetListAsync")]
        [ResponseType(typeof(List<LabSampleSearchGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratorySampleSearchGetListAsync([FromBody]LaboratorySearchParameters parameters)
        {
            log.Info("GetLaboratorySampleSearchGetListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                // Call the database.
                var result = await _repository.LabSampleSearchGetListAsync(
                    parameters.LanguageID,
                    parameters.UserID,
                    parameters.OrganizationID,
                    parameters.SearchString,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratorySampleSearchGetListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratorySampleSearchGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratorySampleSearchGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratorySampleSearchGetListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrieves a count of samples that matched user provided search criteria.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("LaboratorySampleSearchGetListCountAsync")]
        [ResponseType(typeof(List<LabSampleSearchGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratorySampleSearchListCountAsync([FromBody]LaboratorySearchParameters parameters)
        {
            log.Info("LaboratorySampleSearchGetListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabSampleSearchGetCountAsync(
                    parameters.LanguageID,
                    parameters.OrganizationID,
                    parameters.SearchString);

                if (result == null)
                {
                    log.Info("Exiting  LaboratorySampleSearchGetListCountAsync With Not Found");
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
                log.Error("SQL Error in LaboratorySampleSearchGetListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in LaboratorySampleSearchGetListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  LaboratorySampleSearchGetListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a list of samples based on user provided search criteria.
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
        [HttpPost, Route("LaboratorySampleAdvancedSearchGetListAsync")]
        [ResponseType(typeof(List<LabSampleAdvancedSearchGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratorySampleAdvancedSearchGetListAsync([FromBody]LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("GetLaboratorySampleAdvancedSearchGetListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                // Call the database.
                var result = await _repository.LabSampleAdvancedSearchGetListAsync(
                    parameters.LanguageID,
                    parameters.UserID,
                    parameters.SiteID,
                    parameters.ReportSessionType,
                    parameters.SurveillanceTypeID,
                    parameters.SampleStatusTypeID,
                    parameters.AccessionedIndicator, 
                    parameters.EIDSSLocalFieldSampleID,
                    parameters.ExactMatchEIDSSLocalFieldSampleID,
                    parameters.EIDSSReportCampaignSessionID,
                    parameters.OrganizationSentToID,
                    parameters.OrganizationTransferredToID,
                    parameters.EIDSSTransferID,
                    parameters.ResultsReceivedFromID,
                    parameters.AccessionDateFrom,
                    parameters.AccessionDateTo,
                    parameters.EIDSSLaboratorySampleID,
                    parameters.SampleTypeID,
                    parameters.TestNameTypeID,
                    parameters.DiseaseID,
                    parameters.TestStatusTypeID,
                    parameters.TestResultTypeID,
                    parameters.TestResultDateFrom,
                    parameters.TestResultDateTo,
                    parameters.PatientName,
                    parameters.FarmOwnerName,
                    parameters.SpeciesTypeID,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratorySampleAdvancedSearchGetListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratorySampleAdvancedSearchGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratorySampleAdvancedSearchGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratorySampleAdvancedSearchGetListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a count of samples that matched user provided search criteria.
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
        [HttpPost, Route("LaboratorySampleAdvancedSearchGetListCountAsync")]
        [ResponseType(typeof(List<LabSampleAdvancedSearchGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratorySampleAdvancedSearchListCountAsync([FromBody]LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("GetLaboratorySampleAdvancedSearchListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabSampleAdvancedSearchGetCountAsync(
                    parameters.LanguageID,
                    parameters.SiteID,
                    parameters.ReportSessionType,
                    parameters.SurveillanceTypeID,
                    parameters.SampleStatusTypeID,
                    parameters.AccessionedIndicator,
                    parameters.EIDSSLocalFieldSampleID,
                    parameters.ExactMatchEIDSSLocalFieldSampleID,
                    parameters.EIDSSReportCampaignSessionID,
                    parameters.OrganizationSentToID,
                    parameters.OrganizationTransferredToID,
                    parameters.EIDSSTransferID,
                    parameters.ResultsReceivedFromID,
                    parameters.AccessionDateFrom,
                    parameters.AccessionDateTo,
                    parameters.EIDSSLaboratorySampleID,
                    parameters.SampleTypeID,
                    parameters.TestNameTypeID,
                    parameters.DiseaseID,
                    parameters.TestStatusTypeID,
                    parameters.TestResultTypeID,
                    parameters.TestResultDateFrom,
                    parameters.TestResultDateTo,
                    parameters.PatientName,
                    parameters.FarmOwnerName,
                    parameters.SpeciesTypeID);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratorySampleAdvancedSearchListCountAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratorySampleAdvancedSearchListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratorySampleAdvancedSearchListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratorySampleAdvancedSearchListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrives a list of laboratory samples designated as favorites by a user and stored in the user profile settings.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 language code used to restrict data to a specific country.</param>
        /// <param name="userID">An EIDSS interal user identifier for which favorites will be retrieved</param>
        /// <param name="paginationSetNumber">Limits the amount of data returned to 100 records at a time.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("LaboratoryFavoriteGetListAsync")]
        [ResponseType(typeof(List<LabFavoriteGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryFavoriteListAsync([Required]string languageID, long? userID, [Required]int paginationSetNumber)
        {
            log.Info("GetLaboratoryFavoriteListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                // Call the database.
                var result = await _repository.LabFavoriteGetListAsync(languageID, userID, paginationSetNumber, pageSize, maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryFavoriteListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryFavoriteListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryFavoriteListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryFavoriteListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrives a list of laboratory samples designated as favorites by a user and stored in the user profile settings.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 language code used to restrict data to a specific country.</param>
        /// <param name="userID">An EIDSS interal user identifier for which favorites will be retrieved</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("LaboratoryFavoriteGetListCountAsync")]
        [ResponseType(typeof(List<LabFavoriteGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryFavoriteListCountAsync([Required]string languageID, long? userID)
        {
            log.Info("GetLaboratoryFavoriteListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabFavoriteGetCountAsync(languageID, userID);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryFavoriteListCountAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryFavoriteListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryFavoriteListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryFavoriteListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a list of my favorites based on user provided search criteria.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("LaboratoryFavoriteSearchGetListAsync")]
        [ResponseType(typeof(List<LabFavoriteSearchGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryFavoriteSearchGetListAsync([FromBody]LaboratorySearchParameters parameters)
        {
            log.Info("GetLaboratoryFavoriteSearchGetListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                // Call the database.
                var result = await _repository.LabFavoriteSearchGetListAsync(
                    parameters.LanguageID,
                    parameters.UserID,
                    parameters.OrganizationID,
                    parameters.SearchString,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryFavoriteSearchGetListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryFavoriteSearchGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryFavoriteSearchGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryFavoriteSearchGetListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrieves a count of my favorites that matched user provided search criteria.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("LaboratoryFavoriteSearchGetListCountAsync")]
        [ResponseType(typeof(List<LabFavoriteSearchGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryFavoriteSearchListCountAsync([FromBody]LaboratorySearchParameters parameters)
        {
            log.Info("GetLaboratoryFavoriteSearchListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabFavoriteSearchGetCountAsync(
                    parameters.LanguageID,
                    parameters.OrganizationID,
                    parameters.SearchString);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryFavoriteSearchListCountAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryFavoriteSearchListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryFavoriteSearchListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryFavoriteSearchListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a list of my favorites based on user provided search criteria.
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
        [HttpPost, Route("LaboratoryFavoriteAdvancedSearchGetListAsync")]
        [ResponseType(typeof(List<LabFavoriteAdvancedSearchGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryFavoriteAdvancedSearchGetListAsync([FromBody]LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("GetLaboratoryFavoriteAdvancedSearchGetListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                // Call the database.
                var result = await _repository.LabFavoriteAdvancedSearchGetListAsync(
                    parameters.LanguageID,
                    parameters.UserID,
                    parameters.SiteID,
                    parameters.ReportSessionType,
                    parameters.SurveillanceTypeID,
                    parameters.SampleStatusTypeID,
                    parameters.AccessionedIndicator,
                    parameters.EIDSSLocalFieldSampleID,
                    parameters.ExactMatchEIDSSLocalFieldSampleID,
                    parameters.EIDSSReportCampaignSessionID,
                    parameters.OrganizationSentToID,
                    parameters.OrganizationTransferredToID,
                    parameters.EIDSSTransferID,
                    parameters.ResultsReceivedFromID,
                    parameters.AccessionDateFrom,
                    parameters.AccessionDateTo,
                    parameters.EIDSSLaboratorySampleID,
                    parameters.SampleTypeID,
                    parameters.TestNameTypeID,
                    parameters.DiseaseID,
                    parameters.TestStatusTypeID,
                    parameters.TestResultTypeID,
                    parameters.TestResultDateFrom,
                    parameters.TestResultDateTo,
                    parameters.PatientName,
                    parameters.FarmOwnerName,
                    parameters.SpeciesTypeID,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryFavoriteAdvancedSearchGetListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryFavoriteAdvancedSearchGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryFavoriteAdvancedSearchGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryFavoriteAdvancedSearchGetListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a count of my favorites that matched user provided search criteria.
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
        [HttpPost, Route("LaboratoryFavoriteAdvancedSearchGetListCountAsync")]
        [ResponseType(typeof(List<LabFavoriteAdvancedSearchGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryFavoriteAdvancedSearchListCountAsync([FromBody]LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("GetLaboratoryFavoriteAdvancedSearchListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabFavoriteAdvancedSearchGetCountAsync(
                    parameters.LanguageID,
                    parameters.UserID,
                    parameters.SiteID,
                    parameters.ReportSessionType,
                    parameters.SurveillanceTypeID,
                    parameters.SampleStatusTypeID,
                    parameters.AccessionedIndicator,
                    parameters.EIDSSLocalFieldSampleID,
                    parameters.ExactMatchEIDSSLocalFieldSampleID,
                    parameters.EIDSSReportCampaignSessionID,
                    parameters.OrganizationSentToID,
                    parameters.OrganizationTransferredToID,
                    parameters.EIDSSTransferID,
                    parameters.ResultsReceivedFromID,
                    parameters.AccessionDateFrom,
                    parameters.AccessionDateTo,
                    parameters.EIDSSLaboratorySampleID,
                    parameters.SampleTypeID,
                    parameters.TestNameTypeID,
                    parameters.DiseaseID,
                    parameters.TestStatusTypeID,
                    parameters.TestResultTypeID,
                    parameters.TestResultDateFrom,
                    parameters.TestResultDateTo,
                    parameters.PatientName,
                    parameters.FarmOwnerName,
                    parameters.SpeciesTypeID);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryFavoriteAdvancedSearchListCountAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryFavoriteAdvancedSearchListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryFavoriteAdvancedSearchListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryFavoriteAdvancedSearchListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrives a list of test records associated with laboratory samples.
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
        [HttpPost, Route("LaboratoryTestGetListAsync")]
        [ResponseType(typeof(List<LabTestGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryTestListAsync([FromBody]LaboratoryTestGetListParameters parameters)
        {
            log.Info("GetLaboratoryTestListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                // Call the database.
                var result = await _repository.LabTestGetListAsync(
                    parameters.LanguageID,
                    parameters.TestStatusTypeID,
                    parameters.UserID,
                    parameters.SampleID,
                    parameters.TestID,
                    parameters.OrganizationID,
                    parameters.SiteID,
                    parameters.BatchTestID,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryTestListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryTestListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryTestListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryTestListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrives a count of test records associated with laboratory samples.
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
        [HttpPost, Route("LaboratoryTestGetListCountAsync")]
        [ResponseType(typeof(List<LabTestGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryTestListCountAsync([FromBody]LaboratoryTestGetListParameters parameters)
        {
            log.Info("GetLaboratoryTestListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabTestGetCountAsync(
                    parameters.LanguageID,
                    parameters.TestStatusTypeID,
                    parameters.SampleID,
                    parameters.TestID,
                    parameters.OrganizationID,
                    parameters.SiteID,
                    parameters.BatchTestID);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryTestListCountAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryTestListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryTestListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryTestListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a list of tests based on user provided search criteria.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("LaboratoryTestSearchGetListAsync")]
        [ResponseType(typeof(List<LabTestSearchGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryTestSearchGetListAsync([FromBody]LaboratorySearchParameters parameters)
        {
            log.Info("GetLaboratoryTestSearchGetListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                // Call the database.
                var result = await _repository.LabTestSearchGetListAsync(
                    parameters.LanguageID,
                    parameters.UserID,
                    parameters.OrganizationID,
                    parameters.SearchString,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryTestSearchGetListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryTestSearchGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryTestSearchGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryTestSearchGetListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrieves a count of tests that matched user provided search criteria.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("LaboratoryTestSearchGetListCountAsync")]
        [ResponseType(typeof(List<LabTestSearchGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryTestSearchListCountAsync([FromBody]LaboratorySearchParameters parameters)
        {
            log.Info("LaboratoryTestSearchGetListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabTestSearchGetCountAsync(
                    parameters.LanguageID,
                    parameters.OrganizationID,
                    parameters.SearchString);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryTestSearchListCountAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryTestSearchListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryTestSearchListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryTestSearchListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a list of tests based on user provided search criteria.
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
        [HttpPost, Route("LaboratoryTestAdvancedSearchGetListAsync")]
        [ResponseType(typeof(List<LabTestAdvancedSearchGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryTestAdvancedSearchGetListAsync([FromBody]LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("GetLaboratoryTestAdvancedSearchGetListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                // Call the database.
                var result = await _repository.LabTestAdvancedSearchGetListAsync(
                    parameters.LanguageID,
                    parameters.UserID,
                    parameters.SiteID,
                    parameters.ReportSessionType,
                    parameters.SurveillanceTypeID,
                    parameters.SampleStatusTypeID,
                    parameters.AccessionedIndicator,
                    parameters.EIDSSLocalFieldSampleID,
                    parameters.ExactMatchEIDSSLocalFieldSampleID,
                    parameters.EIDSSReportCampaignSessionID,
                    parameters.OrganizationSentToID,
                    parameters.OrganizationTransferredToID,
                    parameters.EIDSSTransferID,
                    parameters.ResultsReceivedFromID,
                    parameters.AccessionDateFrom,
                    parameters.AccessionDateTo,
                    parameters.EIDSSLaboratorySampleID,
                    parameters.SampleTypeID,
                    parameters.TestNameTypeID,
                    parameters.DiseaseID,
                    parameters.TestStatusTypeID,
                    parameters.TestResultTypeID,
                    parameters.TestResultDateFrom,
                    parameters.TestResultDateTo,
                    parameters.PatientName,
                    parameters.FarmOwnerName,
                    parameters.SpeciesTypeID,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryTestAdvancedSearchGetListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryTestAdvancedSearchGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryTestAdvancedSearchGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryTestAdvancedSearchGetListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a count of tests that matched user provided search criteria.
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
        [HttpPost, Route("LaboratoryTestAdvancedSearchGetListCountAsync")]
        [ResponseType(typeof(List<LabTestAdvancedSearchGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryTestAdvancedSearchListCountAsync([FromBody]LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("GetLaboratoryTestAdvancedSearchListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabTestAdvancedSearchGetCountAsync(
                    parameters.LanguageID,
                    parameters.SiteID,
                    parameters.ReportSessionType,
                    parameters.SurveillanceTypeID,
                    parameters.SampleStatusTypeID,
                    parameters.AccessionedIndicator,
                    parameters.EIDSSLocalFieldSampleID,
                    parameters.ExactMatchEIDSSLocalFieldSampleID,
                    parameters.EIDSSReportCampaignSessionID,
                    parameters.OrganizationSentToID,
                    parameters.OrganizationTransferredToID,
                    parameters.EIDSSTransferID,
                    parameters.ResultsReceivedFromID,
                    parameters.AccessionDateFrom,
                    parameters.AccessionDateTo,
                    parameters.EIDSSLaboratorySampleID,
                    parameters.SampleTypeID,
                    parameters.TestNameTypeID,
                    parameters.DiseaseID,
                    parameters.TestStatusTypeID,
                    parameters.TestResultTypeID,
                    parameters.TestResultDateFrom,
                    parameters.TestResultDateTo,
                    parameters.PatientName,
                    parameters.FarmOwnerName,
                    parameters.SpeciesTypeID);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryTestAdvancedSearchListCountAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryTestAdvancedSearchListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryTestAdvancedSearchListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryTestAdvancedSearchListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrives a list of transfer records associated with laboratory samples.
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
        [HttpPost, Route("LaboratoryTransferGetListAsync")]
        [ResponseType(typeof(List<LabTransferGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryTransferListAsync([FromBody]LaboratoryTransferGetListParameters parameters)
        {
            log.Info("GetLaboratoryTransferListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                // Call the database.
                var result = await _repository.LabTransferGetListAsync(
                    parameters.LanguageID,
                    parameters.UserID,
                    parameters.SampleID,
                    parameters.OrganizationID,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryTransferListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryTransferListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryTransferListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryTransferListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrives a count of test records associated with laboratory samples.
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
        [HttpPost, Route("LaboratoryTransferGetListCountAsync")]
        [ResponseType(typeof(List<LabTransferGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryTransferListCountAsync([FromBody]LaboratoryTransferGetListParameters parameters)
        {
            log.Info("GetLaboratoryTransferListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabTransferGetCountAsync(
                    parameters.LanguageID,
                    parameters.SampleID,
                    parameters.OrganizationID);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryTransferListCountAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryTransferListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryTransferListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryTransferListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a list of transfers based on user provided search criteria.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("LaboratoryTransferSearchGetListAsync")]
        [ResponseType(typeof(List<LabTransferSearchGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryTransferSearchGetListAsync([FromBody]LaboratorySearchParameters parameters)
        {
            log.Info("GetLaboratoryTransferSearchGetListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                // Call the database.
                var result = await _repository.LabTransferSearchGetListAsync(
                    parameters.LanguageID,
                    parameters.UserID,
                    parameters.OrganizationID,
                    parameters.SearchString,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryTransferSearchGetListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryTransferSearchGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryTransferSearchGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryTransferSearchGetListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrieves a count of transfers that matched user provided search criteria.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("LaboratoryTransferSearchGetListCountAsync")]
        [ResponseType(typeof(List<LabTransferSearchGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryTransferSearchListCountAsync([FromBody]LaboratorySearchParameters parameters)
        {
            log.Info("GetLaboratoryTransferSearchListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabTransferSearchGetCountAsync(
                    parameters.LanguageID,
                    parameters.OrganizationID,
                    parameters.SearchString);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryTransferSearchListCountAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryTransferSearchListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryTransferSearchListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryTransferSearchListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a list of transfers based on user provided search criteria.
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
        [HttpPost, Route("LaboratoryTransferAdvancedSearchGetListAsync")]
        [ResponseType(typeof(List<LabTransferAdvancedSearchGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryTransferAdvancedSearchGetListAsync([FromBody]LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("GetLaboratoryTransferAdvancedSearchGetListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                // Call the database.
                var result = await _repository.LabTransferAdvancedSearchGetListAsync(
                    parameters.LanguageID,
                    parameters.UserID,
                    parameters.SiteID,
                    parameters.ReportSessionType,
                    parameters.SurveillanceTypeID,
                    parameters.SampleStatusTypeID,
                    parameters.AccessionedIndicator,
                    parameters.EIDSSLocalFieldSampleID,
                    parameters.ExactMatchEIDSSLocalFieldSampleID,
                    parameters.EIDSSReportCampaignSessionID,
                    parameters.OrganizationSentToID,
                    parameters.OrganizationTransferredToID,
                    parameters.EIDSSTransferID,
                    parameters.ResultsReceivedFromID,
                    parameters.AccessionDateFrom,
                    parameters.AccessionDateTo,
                    parameters.EIDSSLaboratorySampleID,
                    parameters.SampleTypeID,
                    parameters.TestNameTypeID,
                    parameters.DiseaseID,
                    parameters.TestStatusTypeID,
                    parameters.TestResultTypeID,
                    parameters.TestResultDateFrom,
                    parameters.TestResultDateTo,
                    parameters.PatientName,
                    parameters.FarmOwnerName,
                    parameters.SpeciesTypeID,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryTransferAdvancedSearchGetListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryTransferAdvancedSearchGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryTransferAdvancedSearchGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryTransferAdvancedSearchGetListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a count of transfers that matched user provided search criteria.
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
        [HttpPost, Route("LaboratoryTransferAdvancedSearchGetListCountAsync")]
        [ResponseType(typeof(List<LabTransferAdvancedSearchGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryTransferAdvancedSearchListCountAsync([FromBody]LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("GetLaboratoryTransferAdvancedSearchListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabTransferAdvancedSearchGetCountAsync(
                    parameters.LanguageID,
                    parameters.SiteID,
                    parameters.ReportSessionType,
                    parameters.SurveillanceTypeID,
                    parameters.SampleStatusTypeID,
                    parameters.AccessionedIndicator,
                    parameters.EIDSSLocalFieldSampleID,
                    parameters.ExactMatchEIDSSLocalFieldSampleID,
                    parameters.EIDSSReportCampaignSessionID,
                    parameters.OrganizationSentToID,
                    parameters.OrganizationTransferredToID,
                    parameters.EIDSSTransferID,
                    parameters.ResultsReceivedFromID,
                    parameters.AccessionDateFrom,
                    parameters.AccessionDateTo,
                    parameters.EIDSSLaboratorySampleID,
                    parameters.SampleTypeID,
                    parameters.TestNameTypeID,
                    parameters.DiseaseID,
                    parameters.TestStatusTypeID,
                    parameters.TestResultTypeID,
                    parameters.TestResultDateFrom,
                    parameters.TestResultDateTo,
                    parameters.PatientName,
                    parameters.FarmOwnerName,
                    parameters.SpeciesTypeID);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryTransferAdvancedSearchListCountAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryTransferAdvancedSearchListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryTransferAdvancedSearchListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryTransferAdvancedSearchListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrives a list of batch records associated with laboratory samples.
        /// </summary>
        /// <param name="parameters">A collection of parameters.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("LaboratoryBatchGetListAsync")]
        [ResponseType(typeof(List<LabBatchGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryBatchListAsync([FromBody]LaboratoryBatchGetListParameters parameters)
        {
            log.Info("GetLaboratoryBatchListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                // Call the database.
                var result = await _repository.LabBatchGetListAsync(
                    parameters.LanguageID,
                    parameters.UserID,
                    parameters.OrganizationID,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryBatchListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryBatchListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryBatchListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryBatchListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrives a list of batch records associated with laboratory samples.
        /// </summary>
        /// <param name="parameters">A collection of parameters.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("LaboratoryBatchGetListCountAsync")]
        [ResponseType(typeof(List<LabBatchGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryBatchListCountAsync([FromBody]LaboratoryBatchGetListParameters parameters)
        {
            log.Info("GetLaboratoryBatchListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabBatchGetCountAsync(
                    parameters.LanguageID,
                    parameters.OrganizationID);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryBatchListCountAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryBatchListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryBatchListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryBatchListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a list of batches based on user provided search criteria.
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
        [HttpPost, Route("LaboratoryBatchAdvancedSearchGetListAsync")]
        [ResponseType(typeof(List<LabBatchAdvancedSearchGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryBatchAdvancedSearchGetListAsync([FromBody]LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("GetLaboratoryBatchAdvancedSearchGetListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                // Call the database.
                var result = await _repository.LabBatchAdvancedSearchGetListAsync(
                    parameters.LanguageID,
                    parameters.UserID,
                    parameters.OrganizationID,
                    parameters.SiteID,
                    parameters.ReportSessionType,
                    parameters.SurveillanceTypeID,
                    parameters.SampleStatusTypeID,
                    parameters.AccessionedIndicator,
                    parameters.EIDSSLocalFieldSampleID,
                    parameters.ExactMatchEIDSSLocalFieldSampleID,
                    parameters.EIDSSReportCampaignSessionID,
                    parameters.OrganizationSentToID,
                    parameters.OrganizationTransferredToID,
                    parameters.EIDSSTransferID,
                    parameters.ResultsReceivedFromID,
                    parameters.AccessionDateFrom,
                    parameters.AccessionDateTo,
                    parameters.EIDSSLaboratorySampleID,
                    parameters.SampleTypeID,
                    parameters.TestNameTypeID,
                    parameters.DiseaseID,
                    parameters.TestStatusTypeID,
                    parameters.TestResultTypeID,
                    parameters.TestResultDateFrom,
                    parameters.TestResultDateTo,
                    parameters.PatientName,
                    parameters.FarmOwnerName,
                    parameters.SpeciesTypeID,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryBatchAdvancedSearchGetListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryBatchAdvancedSearchGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryBatchAdvancedSearchGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryBatchAdvancedSearchGetListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a count of batches that matched user provided search criteria.
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
        [HttpPost, Route("LaboratoryBatchAdvancedSearchGetListCountAsync")]
        [ResponseType(typeof(List<LabBatchAdvancedSearchGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryBatchAdvancedSearchListCountAsync([FromBody]LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("GetLaboratoryBatchAdvancedSearchListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabBatchAdvancedSearchGetCountAsync(
                    parameters.LanguageID,
                    parameters.UserID,
                    parameters.OrganizationID,
                    parameters.SiteID,
                    parameters.ReportSessionType,
                    parameters.SurveillanceTypeID,
                    parameters.SampleStatusTypeID,
                    parameters.AccessionedIndicator,
                    parameters.EIDSSLocalFieldSampleID,
                    parameters.ExactMatchEIDSSLocalFieldSampleID,
                    parameters.EIDSSReportCampaignSessionID,
                    parameters.OrganizationSentToID,
                    parameters.OrganizationTransferredToID,
                    parameters.EIDSSTransferID,
                    parameters.ResultsReceivedFromID,
                    parameters.AccessionDateFrom,
                    parameters.AccessionDateTo,
                    parameters.EIDSSLaboratorySampleID,
                    parameters.SampleTypeID,
                    parameters.TestNameTypeID,
                    parameters.DiseaseID,
                    parameters.TestStatusTypeID,
                    parameters.TestResultTypeID,
                    parameters.TestResultDateFrom,
                    parameters.TestResultDateTo,
                    parameters.PatientName,
                    parameters.FarmOwnerName,
                    parameters.SpeciesTypeID);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryBatchAdvancedSearchListCountAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryBatchAdvancedSearchListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryBatchAdvancedSearchListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryBatchAdvancedSearchListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrives a list of approval records associated with laboratory samples.
        /// </summary>
        /// <param name="parameters">A collection of parameters.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("LaboratoryApprovalGetListAsync")]
        [ResponseType(typeof(List<LabApprovalGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryApprovalListAsync([FromBody]LaboratoryApprovalGetListParameters parameters)
        {
            log.Info("GetLaboratoryApprovalListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                //Lab chief has requested specific approvals sort to the top and be selected for approval/rejection.
                if (parameters.SpecificApprovalTypeIndicator == true)
                    maxPagesPerFetch = 50;

                // Call the database.
                var result = await _repository.LabApprovalGetListAsync(
                    parameters.LanguageID,
                    parameters.SiteID,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryApprovalListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryApprovalListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryApprovalListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryApprovalListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrives a count of approval records associated with laboratory samples.
        /// </summary>
        /// <param name="parameters">A collection of parameters.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("LaboratoryApprovalGetListCountAsync")]
        [ResponseType(typeof(List<LabApprovalGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryApprovalListCountAsync([FromBody]LaboratoryApprovalGetListParameters parameters)
        {
            log.Info("GetLaboratoryApprovalListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabApprovalGetCountAsync(
                    parameters.LanguageID,
                    parameters.SiteID);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryApprovalListCountAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryApprovalListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryApprovalListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryApprovalListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a list of approvals based on user provided search criteria.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("LaboratoryApprovalSearchGetListAsync")]
        [ResponseType(typeof(List<LabApprovalSearchGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryApprovalSearchGetListAsync([FromBody]LaboratorySearchParameters parameters)
        {
            log.Info("GetLaboratoryApprovalSearchGetListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                // Call the database.
                var result = await _repository.LabApprovalSearchGetListAsync(
                    parameters.LanguageID,
                    parameters.UserID,
                    parameters.SiteID,
                    parameters.SearchString,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryApprovalSearchGetListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryApprovalSearchGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryApprovalSearchGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryApprovalSearchGetListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrieves a count of approvals that matched user provided search criteria.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("LaboratoryApprovalSearchGetListCountAsync")]
        [ResponseType(typeof(List<LabApprovalSearchGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryApprovalSearchListCountAsync([FromBody]LaboratorySearchParameters parameters)
        {
            log.Info("LaboratoryApprovalSearchGetListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabApprovalSearchGetCountAsync(
                    parameters.LanguageID,
                    parameters.SiteID,
                    parameters.SearchString);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryApprovalSearchListCountAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryApprovalSearchListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryApprovalSearchListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryApprovalSearchListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a list of approvals based on user provided search criteria.
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
        [HttpPost, Route("LaboratoryApprovalAdvancedSearchGetListAsync")]
        [ResponseType(typeof(List<LabApprovalAdvancedSearchGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryApprovalAdvancedSearchGetListAsync([FromBody]LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("GetLaboratoryApprovalAdvancedSearchGetListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                // Call the database.
                var result = await _repository.LabApprovalAdvancedSearchGetListAsync(
                    parameters.LanguageID,
                    parameters.UserID,
                    parameters.SiteID,
                    parameters.ReportSessionType,
                    parameters.SurveillanceTypeID,
                    parameters.SampleStatusTypeID,
                    parameters.AccessionedIndicator,
                    parameters.EIDSSLocalFieldSampleID,
                    parameters.ExactMatchEIDSSLocalFieldSampleID,
                    parameters.EIDSSReportCampaignSessionID,
                    parameters.OrganizationSentToID,
                    parameters.OrganizationTransferredToID,
                    parameters.EIDSSTransferID,
                    parameters.ResultsReceivedFromID,
                    parameters.AccessionDateFrom,
                    parameters.AccessionDateTo,
                    parameters.EIDSSLaboratorySampleID,
                    parameters.SampleTypeID,
                    parameters.TestNameTypeID,
                    parameters.DiseaseID,
                    parameters.TestStatusTypeID,
                    parameters.TestResultTypeID,
                    parameters.TestResultDateFrom,
                    parameters.TestResultDateTo,
                    parameters.PatientName,
                    parameters.FarmOwnerName,
                    parameters.SpeciesTypeID,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryApprovalAdvancedSearchGetListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryApprovalAdvancedSearchGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryApprovalAdvancedSearchGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryApprovalAdvancedSearchGetListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a count of approvals that matched user provided search criteria.
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
        [HttpPost, Route("LaboratoryApprovalAdvancedSearchGetListCountAsync")]
        [ResponseType(typeof(List<LabApprovalAdvancedSearchGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryApprovalAdvancedSearchListCountAsync([FromBody]LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("GetLaboratoryApprovalAdvancedSearchListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabApprovalAdvancedSearchGetCountAsync(
                    parameters.LanguageID,
                    parameters.UserID,
                    parameters.SiteID,
                    parameters.ReportSessionType,
                    parameters.SurveillanceTypeID,
                    parameters.SampleStatusTypeID,
                    parameters.AccessionedIndicator,
                    parameters.EIDSSLocalFieldSampleID,
                    parameters.ExactMatchEIDSSLocalFieldSampleID,
                    parameters.EIDSSReportCampaignSessionID,
                    parameters.OrganizationSentToID,
                    parameters.OrganizationTransferredToID,
                    parameters.EIDSSTransferID,
                    parameters.ResultsReceivedFromID,
                    parameters.AccessionDateFrom,
                    parameters.AccessionDateTo,
                    parameters.EIDSSLaboratorySampleID,
                    parameters.SampleTypeID,
                    parameters.TestNameTypeID,
                    parameters.DiseaseID,
                    parameters.TestStatusTypeID,
                    parameters.TestResultTypeID,
                    parameters.TestResultDateFrom,
                    parameters.TestResultDateTo,
                    parameters.PatientName,
                    parameters.FarmOwnerName,
                    parameters.SpeciesTypeID);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryApprovalAdvancedSearchListCountAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryApprovalAdvancedSearchListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryApprovalAdvancedSearchListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryApprovalAdvancedSearchListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrives a list of test amendment records associated with laboratory tests.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="testID">An EIDSS internal test identifier for which test amendment will be retrieved</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("LaboratoryTestAmendmentGetListAsync")]
        [ResponseType(typeof(List<LabTestAmendmentGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryTestAmendmentListAsync([Required]string languageID, [Required]long testID)
        {
            log.Info("GetLaboratoryTestAmendmentListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabTestAmendmentGetListAsync(languageID, testID);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryTestAmendmentListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryTestAmendmentListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryTestAmendmentListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryTestAmendmentListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrieves a list of freezers for laboratory samples.
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
        [HttpPost, Route("LaboratoryFreezerGetListAsync")]
        [ResponseType(typeof(List<LabFreezerGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryFreezerListAsync([FromBody]LaboratoryFreezerGetListParams parameters)
        {
            log.Info("GetLaboratoryFreezerListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                // Call the database.
                var result = await _repository.LabFreezerGetListAsync(
                    parameters.LanguageID,
                    parameters.OrganizationID,
                    parameters.FreezerName,
                    parameters.Note,
                    parameters.StorageTypeID,
                    parameters.Building,
                    parameters.Room,
                    parameters.SearchString,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryFreezerListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryFreezerListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryFreezerListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryFreezerListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrieves a count of freezers for laboratory samples.
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
        [HttpPost, Route("LaboratoryFreezerGetListCountAsync")]
        [ResponseType(typeof(List<LabFreezerGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetLaboratoryFreezerListCountAsync([FromBody]LaboratoryFreezerGetListParams parameters)
        {
            log.Info("GetLaboratoryFreezerListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabFreezerGetCountAsync(
                    parameters.LanguageID,
                    parameters.OrganizationID,
                    parameters.FreezerName,
                    parameters.Note,
                    parameters.StorageTypeID,
                    parameters.Building,
                    parameters.Room, 
                    parameters.SearchString);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryFreezerListCountAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryFreezerListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryFreezerListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryFreezerListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrives a list of freezer subdivision (shelves, racks and boxes) records associated with a freezer.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="freezerID">An EIDSS internal identifier for which the subdivisions will be retrieved</param>
        /// <param name="organizationID">An EIDSS internal identifier for the organization/site a freezer subdivision is associated with.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("LaboratoryFreezerSubdivisionGetListAsync")]
        [ResponseType(typeof(List<LabFreezerSubdivisionGetListModel>))]
        public async Task<IHttpActionResult> GetLaboratoryFreezerSubdivisionListAsync([Required]string languageID, long? freezerID, long? organizationID)
        {
            log.Info("GetLaboratoryFreezerSubdivisionListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabFreezerSubdivisionGetListAsync(languageID, freezerID, organizationID);

                if (result == null)
                {
                    log.Info("Exiting  GetLaboratoryFreezerSubdivisionListAsync With Not Found");
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
                log.Error("SQL Error in GetLaboratoryFreezerSubdivisionListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetLaboratoryFreezerSubdivisionListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetLaboratoryFreezerSubdivisionListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Adds and updates freezer and freezer subdivision records for the laboratory module.
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
        [HttpPost, Route("LaboratoryFreezerSaveAsync")]
        [ResponseType(typeof(List<LabFreezerSetModel>))]
        public async Task<IHttpActionResult> SaveLaboratoryFreezerAsync([FromBody]LaboratoryFreezerSetParams parameters)
        {
            log.Info("SaveLaboratoryFreezerAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabFreezerSetAsync(
                    parameters.LanguageID,
                    parameters.FreezerID,
                    parameters.StorageTypeID,
                    parameters.OrganizationID,
                    parameters.FreezerName,
                    parameters.FreezerNote,
                    parameters.EIDSSFreezerID,
                    parameters.Building,
                    parameters.Room,
                    parameters.RowStatus,
                    JsonConvert.SerializeObject(parameters.FreezerSubdivisions));

                if (result == null)
                {
                    log.Info("Exiting  SaveLaboratoryFreezerAsync With Not Found");
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
                log.Error("SQL Error in SaveLaboratoryFreezerAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in SaveLaboratoryFreezerAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  SaveLaboratoryFreezerAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Adds and updates samples, tests, test interpretations, test amendments, transfers and favorites records for the 
        /// lab module.
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
        [HttpPost, Route("LaboratorySaveAsync")]
        [ResponseType(typeof(List<LabSetModel>))]
        public async Task<IHttpActionResult> SaveLaboratoryAsync([FromBody]LaboratorySetParameters parameters)
        {
            log.Info("SaveLaboratoryAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.LabSetAsync(
                    parameters.LanguageID,
                    JsonConvert.SerializeObject(parameters.Samples),
                    JsonConvert.SerializeObject(parameters.BatchTests),
                    JsonConvert.SerializeObject(parameters.Tests),
                    JsonConvert.SerializeObject(parameters.TestAmendments),
                    JsonConvert.SerializeObject(parameters.Transfers),
                    JsonConvert.SerializeObject(parameters.FreezerBoxLocationAvailabilities),
                    JsonConvert.SerializeObject(parameters.Notifications),
                    parameters.UserID,
                    parameters.Favorites);

                if (result == null)
                {
                    log.Info("Exiting  SaveLaboratoryAsync With Not Found");
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
                log.Error("SQL Error in SaveLaboratoryAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in SaveLaboratoryAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  SaveLaboratoryAsync");
            return Ok(returnResult);
        }
    }
}
