using Newtonsoft.Json;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Return_Contracts;
using OpenEIDSS.Extensions.Attributes;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Net;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    [RoutePrefix("api/Dashboard")]
    public class DashBoardController : ApiController
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(DashBoardController));
        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// Instantiates a new Instance Of Class -- Contructor 
        /// </summary>
        /// 
        public DashBoardController()
        {

        }

        /// <summary>
        /// exec USP_DAS_DASHBOARD_GETList 'en', 3449750000000, 'Icon'
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="personId">Unique identifier of a person</param>
        /// <param name="dashboardItemType">Dashboard Item type filter</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetDashboardLinks")]
        [ResponseType(typeof(List<DasDashboardGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetDashboardLinks(string languageId, long personId, string dashboardItemType)
        {
            log.Info("Entering  GetDashboardLinks Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.DasDashboardGetListAsync(languageId, personId, dashboardItemType);
                if (result == null)
                {
                    log.Info("Exiting  GetDashboardLinks With Not Found");
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
                log.Error("SQL Error in GetDashboardLinks Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetDashboardLinks" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetDashboardLinks");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a list of laboratory module approvals for the lab chief user group. 
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country.</param>
        /// <param name="siteID">An EIDSS internal identifier for the site the lab chief is associated with.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetDashboardMyApprovalsAsync")]
        [ResponseType(typeof(List<DasApprovalsGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetDashboardMyApprovalsListAsync(string languageID, long siteID)
        {
            log.Info("Entering  GetDashboardMyApprovalsListAsync");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.DasApprovalsGetListAsync(languageID, siteID);
                if (result == null)
                {
                    log.Info("Exiting  GetDashboardMyApprovalsListAsync With Not Found");
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
                log.Error("SQL Error in GetDashboardMyApprovalsListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetDashboardMyApprovalsListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetDashboardMyApprovalsListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a List Of Investigations by PersonId
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfPerson">Unique Identifier of a Person</param>
        /// <param name="paginationSet">Pagination set number</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetMyInvestigations")]
        [ResponseType(typeof(List<DasMyinvestigationsGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetMyInvestigations(string languageId, long idfPerson, int paginationSet)
        {
            log.Info("Entering  GetMyInvestigations Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                var result = await _repository.DasMyinvestigationsGetListAsync(languageId, idfPerson, paginationSet, pageSize, maxPagesPerFetch);
                if (result == null)
                {
                    log.Info("Exiting  GetMyInvestigations With Not Found");
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
                log.Error("SQL Error in GetMyInvestigations Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetMyInvestigations" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetMyInvestigations");
            return Ok(returnResult);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="idfPerson"></param>
        /// <returns></returns>
        [HttpGet, Route("GetMyInvestigationsCount")]
        [ResponseType(typeof(List<DasMyinvestigationsGetcountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetMyInvestigationsCount(long idfPerson)
        {
            log.Info("Entering  GetMyInvestigationsCount Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.DasMyinvestigationsGetcountAsync(idfPerson);
                if (result == null)
                {
                    log.Info("Exiting  GetMyInvestigationsCount With Not Found");
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
                log.Error("SQL Error in GetMyInvestigationsCount Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetMyInvestigationsCount" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetMyInvestigationsCount");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a list of Investigations by Country
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="paginationSet"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetInvestigationsByCountry")]
        [ResponseType(typeof(List<DasInvestigationsGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetInvestigationsByCountry(string languageId, int? paginationSet)
        {
            log.Info("Entering  GetInvestigationsByCountry Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                var result = await  _repository.DasInvestigationsGetListAsync(languageId,paginationSet,pageSize,maxPagesPerFetch);
                if (result == null)
                {
                    log.Info("Exiting  GetInvestigationsByCountry With Not Found");
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
                log.Error("SQL Error in GetInvestigationsByCountry Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetInvestigationsByCountry" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetInvestigationsByCountry");
            return Ok(returnResult);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet, Route("GetInvestigationsCount")]
        [ResponseType(typeof(List<DasInvestigationsGetcountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetInvestigationsCount()
        {
            log.Info("Entering  GetInvestigationsCount Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.DasInvestigationsGetcountAsync();
                if (result == null)
                {
                    log.Info("Exiting  GetInvestigationsCount With Not Found");
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
                log.Error("SQL Error in GetInvestigationsCount Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetInvestigationsCount" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetInvestigationsCount");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a list of Notifications by person Id
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfPerson">A unique identifier of a person</param>
        /// <param name="paginationSet"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetMyNotifications")]
        [ResponseType(typeof(List<DasMynotificationsGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetMyNotifications(string languageId, long idfPerson, int? paginationSet)
        {
            log.Info("Entering  GetMyNotifications Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;
                var result = await _repository.DasMynotificationsGetListAsync(languageId, idfPerson,paginationSet,pageSize,maxPagesPerFetch);
                if (result == null)
                {
                    log.Info("Exiting  GetMyNotifications With Not Found");
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
                log.Error("SQL Error in GetMyNotifications Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetMyNotifications" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetMyNotifications");
            return Ok(returnResult);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="idfPerson"></param>
        /// <returns></returns>
        [HttpGet, Route("GetMyNotificationsCount")]
        [ResponseType(typeof(List<DasMynotificationsGetcountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetMyNotificationsCount(long idfPerson)
        {
            log.Info("Entering  GetMyNotificationsCount Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.DasMynotificationsGetcountAsync(idfPerson);
                if (result == null)
                {
                    log.Info("Exiting  GetMyNotificationsCount With Not Found");
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
                log.Error("SQL Error in GetMyNotificationsCount Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetMyNotificationsCount" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetMyNotificationsCount");
            return Ok(returnResult);
        }


        /// <summary>
        /// Returns a list of Investigations by Country
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="paginationSet"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetAllNotifications")]
        [ResponseType(typeof(List<DasNotificationsGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetAllNotifications(string languageId,int? paginationSet)
        {
            log.Info("Entering  GetAllNotifications Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;
                var result = await _repository.DasNotificationsGetListAsync(languageId,paginationSet,pageSize,maxPagesPerFetch);
                if (result == null)
                {
                    log.Info("GetAllNotifications Not Found");
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
                log.Error("SQL Error in GetAllNotifications Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetAllNotifications" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetMyNotifications");
            return Ok(returnResult);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet, Route("GetAllNotificationsCount")]
        [ResponseType(typeof(List<DasNotificationsGetcountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetAllNotificationsCount()
        {
            log.Info("Entering  GetAllNotifications Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.DasNotificationsGetcountAsync();
                if (result == null)
                {
                    log.Info("GetAllNotifications Not Found");
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
                log.Error("SQL Error in GetAllNotifications Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetAllNotifications" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetMyNotifications");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a list of Unaccessioned Samples
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="organizationID">An EIDSS internal identifier for the sent to organization.</param>
        /// <param name="siteID">An EIDSS internal identifier for the laboratory the sample was sent to.</param>
        /// <param name="paginationSet">Determines the portion of the database to return in a result set from 0 to 100 records per pagination set.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetUnaccessionedSamplesListAsync")]
        [ResponseType(typeof(List<DasUnaccessionedsamplesGetListModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetUnaccessionedSamplesListAsync(string languageID, long? organizationID, long? siteID, int paginationSet)
        {
            log.Info("Entering  GetUnaccessionedSamplesListAsync");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                var result = await _repository.DasUnaccessionedsamplesGetListAsync(languageID, organizationID, siteID, paginationSet, pageSize, maxPagesPerFetch);
                if (result == null)
                {
                    log.Info("GetUnaccessionedSamplesListAsync Not Found");
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
                log.Error("SQL Error in GetUnaccessionedSamplesListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetUnaccessionedSamplesListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetUnaccessionedSamplesListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a count of unaccessioned samples for a specific organization or site.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="organizationID">An EIDSS internal identifier for the sent to organization.</param>
        /// <param name="siteID">An EIDSS internal identifier for the laboratory the sample was sent to.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetUnaccessionedSamplesListCountAsync")]
        [ResponseType(typeof(List<DasUnaccessionedSampleGetCountModel>))]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetUnaccessionedSamplesListCountAsync(string languageID, long? organizationID, long? siteID)
        {
            log.Info("Entering  GetUnaccessionedSamplesListCountAsync");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.DasUnaccessionedSampleGetCountAsync(languageID, organizationID, siteID);
                if (result == null)
                {
                    log.Info("GetUnaccessionedSamplesListCountAsync Not Found");
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
                log.Error("SQL Error in GetUnaccessionedSamplesListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetUnaccessionedSamplesListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetUnaccessionedSamplesListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a list of Users
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="paginationSet"></param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of response objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>
        [ResponseType(typeof(List<DasUsersGetListModel>))]
        [HttpGet, Route("GetUsers")]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetUsers(string languageId, int? paginationSet)
        {
            log.Info("Entering  GetUsers Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                var result = await _repository.DasUsersGetListAsync(languageId,paginationSet,pageSize,maxPagesPerFetch);
                if (result == null)
                {
                    log.Info("GetUsers Not Found");
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
                log.Error("SQL Error in GetUsers Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetUsers" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetUsers");
            return Ok(returnResult);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [ResponseType(typeof(List<DasUsersGetCountModel>))]
        [HttpGet, Route("GetUsersCount")]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetUsersCount()
        {
            log.Info("Entering  GetUsersCount Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.DasUsersGetCountAsync();
                if (result == null)
                {
                    log.Info("GetUsersCount Not Found");
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
                log.Error("SQL Error in GetUsersCount Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetUsersCount" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetUsersCount");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a List of Collections
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfPerson">Person Id</param>
        /// <param name="paginationSet"></param>
        /// <param name="pageSize"></param>
        /// <param name="maxPagesPerFetch"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<DasMycollectionsGetListModel>))]
        [HttpGet, Route("GetMyCollections")]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetMyCollections(string languageId, long idfPerson, int? paginationSet)
        {
            log.Info("Entering GetMyCollections");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                var result = await _repository.DasMycollectionsGetListAsync(languageId, idfPerson,paginationSet,pageSize,maxPagesPerFetch);
                if (result == null)
                {
                    log.Info("GetMyCollections ot Found");
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
                log.Error("SQL Error in GetMyCollections Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetMyCollections" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetMyCollections");
            return Ok(returnResult);

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfPerson"></param>
        /// <returns></returns>
        [ResponseType(typeof(List<DasMycollectionsGetcountModel>))]
        [HttpGet, Route("GetMyCollectionsCount")]
        [CacheHttpGet(0, 0, false)]
        public async Task<IHttpActionResult> GetMyCollectionsCount(string languageId, long idfPerson)
        {
            log.Info("Entering GetMyCollections");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.DasMycollectionsGetcountAsync(languageId, idfPerson);
                if (result == null)
                {
                    log.Info("GetMyCollectionsCount not Found");
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
                log.Error("SQL Error in GetMyCollectionsCount Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetMyCollectionsCount" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetMyCollections");
            return Ok(returnResult);

        }
    }
}
