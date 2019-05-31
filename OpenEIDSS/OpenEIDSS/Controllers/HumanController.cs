using Newtonsoft.Json;
using OpenEIDSS.Abstracts;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Domain.Return_Contracts;
using OpenEIDSS.Extensions.Attributes;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// Provides Human specific service functionality.
    /// </summary>
    [RoutePrefix("api/Human")]
    public class HumanController : APIControllerBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(HumanController));
        //private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// Instantiates a new instance of this class.
        /// </summary>
        public HumanController() : base()
        {
        }

        #region Human Active Surveillance Methods

        /// <summary>
        /// Deletes an Active Surveillance Campaign
        /// </summary>
        /// <param name="idfCampaign">A unique idenfier that identifies the campaign to delete.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpDelete, Route("HumanActiveSurveillanceCampaignDelete")]
        [ResponseType(typeof(GblAscampaignDelModel))]
        public async Task<IHttpActionResult> HumanActiveSurveillanceCampaignDelete([Required]long idfCampaign)
        {

            log.Info("HumanActiveSurveillanceCampaignDelete is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.GblAscampaignDelAsync(idfCampaign);
                if (result == null)
                {
                    log.Info("Exiting  HumanActiveSurveillanceCampaignDelete With Not Found");
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
                log.Error("SQL Error in HumanActiveSurveillanceCampaignDelete Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumanActiveSurveillanceCampaignDelete" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  HumanActiveSurveillanceCampaignDelete");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrieves details about a Human Active Surveillance
        /// </summary>
        /// <param name="langId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfCampaign">A unique identifier that specifies the details to retrieve</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpGet, Route("HumanActiveSurveillanceCampaignDetail")]
        [ResponseType(typeof(List<GblAscampaignGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> HumanActiveSurveillanceCampaignGetDetail([Required]string langId, [Required]long idfCampaign)
        {
            log.Info("HumanActiveSurveillanceCampaignGetDetail is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.GblAscampaignGetDetailAsync(idfCampaign, langId);

                log.Info("HumanActiveSurveillanceCampaignGetDetail returned");
                if (result == null)
                {
                    log.Info("Exiting  HumanActiveSurveillanceCampaignGetDetail With Not Found");
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
                log.Error("SQL Error in HumanActiveSurveillanceCampaignGetDetail Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumanActiveSurveillanceCampaignGetDetail" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  HumanActiveSurveillanceCampaignDelete");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrieves a list of Human Active Surveillance results
        /// </summary>
        /// <param name="parms"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpPost, Route("HumanActiveSurveillanceCampaignListAsync")]
        [ResponseType(typeof(List<GblAscampaignGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> HumanActiveSurveillanceCampaignGetListAsync([FromBody] HumanActiveSurveillanceGetListParams parms)
        {
            log.Info("HumanActiveSurveillanceCampaignGetListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await this._repository.GblAscampaignGetListAsync(
                parms.campaignStrIdFilter,
                parms.campaignNameFilter,
                parms.campaignTypedFilter,
                parms.campaignStatusFilter,
                parms.startDateFromFilter,
                parms.startToFilter,
                parms.campaignDiseaseFilter,
                parms.langId,
                parms.campaignModule);
                if (result == null)
                {
                    log.Info("Exiting  HumanActiveSurveillanceCampaignGetListAsync With Not Found");
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
                log.Error("SQL Error in HumanActiveSurveillanceCampaignGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumanActiveSurveillanceCampaignGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  HumanActiveSurveillanceCampaignGetListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Updates a human active surveillance campaign
        /// </summary>
        /// <param name="parms"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpPost, Route("HumanActiveSurveillanceCampaignSet")]
        [ResponseType(typeof(List<GblAscampaignSetModel>))]
        public async Task<IHttpActionResult> HumanActiveSurveillanceCampaignSet([FromBody] HumanActiveSurveillanceCampaignSetParams parms)
        {

            long? idfCampaign = parms.idfCampaign;
            string strCampaignId = parms.strCampaignId;
            log.Info("HumanActiveSurveillanceCampaignSet is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.GblAscampaignSetAsync(
                 null,
                 parms.idfsCampaignType,
                 parms.idfsCampaignStatus,
                 parms.datCampaignDateStart,
                 parms.datCampaignDateEnd,
                 null,
                 parms.strCampaignName,
                 parms.strCampaignAdministrator,
                 parms.strComments,
                 parms.strConclusion,
                 parms.idfsDiagnosis,
                 parms.campaignCategoryId,
                 parms.datModificationForArchiveDate);
                if (result == null)
                {
                    log.Info("Exiting  HumanActiveSurveillanceCampaignSet With Not Found");
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
                log.Error("SQL Error in HumanActiveSurveillanceCampaignSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumanActiveSurveillanceCampaignSet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  HumanActiveSurveillanceCampaignSet");
            return Ok(returnResult);

        }

        /// <summary>
        /// Deletes a Human Active Surveillance Campaign to Sample Type mapping
        /// </summary>
        /// <param name="idfCampaignToSampleType">An identifier that specifies the sample type to delete.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpDelete, Route("HumanActiveSurveillanceCampaignToSampleTypeDelete")]
        [ResponseType(typeof(List<UsspGblAscampaigntosampletypeDelModel>))]
        public async Task<IHttpActionResult> HumanActiveSurveillanceCampaignToSampleTypeDelete([Required]long idfCampaignToSampleType)
        {

            log.Info("HumanActiveSurveillanceCampaignToSampleTypeDelete is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.UsspGblAscampaigntosampletypeDelAsync(idfCampaignToSampleType);
                if (result == null)
                {
                    log.Info("Exiting  HumanActiveSurveillanceCampaignToSampleTypeDelete With Not Found");
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
                log.Error("SQL Error in HumanActiveSurveillanceCampaignToSampleTypeDelete Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumanActiveSurveillanceCampaignToSampleTypeDelete" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  HumanActiveSurveillanceCampaignToSampleTypeDelete");
            return Ok(returnResult);
        }

        /// <summary>
        /// Inserts or updates a campaign to sample type mapping
        /// </summary>
        /// <param name="parms"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpPost, Route("VCTASHumanActiveSurveillanceCampaignToSampleTypeSet")]
        [ResponseType(typeof(List<VctAscampaigntosampletypeSetModel>))]
        public async Task<IHttpActionResult> VCTASHumanActiveSurveillanceCampaignToSampleTypeSet(HumanActiveSurveillanceCampaignToSampleTypeParams parms)
        {

            log.Info("VCTASHumanActiveSurveillanceCampaignToSampleTypeSet is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.VctAscampaigntosampletypeSetAsync(
                 parms.campaignToSampleTypeUid,
                 parms.idfCampaign,
                 parms.intOrder,
                 parms.idfsSpeciesType,
                 parms.intPlannedNumber,
                 parms.idfsSampleType,
                 0,
                 "");
                if (result == null)
                {
                    log.Info("Exiting  VCTASHumanActiveSurveillanceCampaignToSampleTypeSet With Not Found");
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
                log.Error("SQL Error in VCTASHumanActiveSurveillanceCampaignToSampleTypeSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VCTASHumanActiveSurveillanceCampaignToSampleTypeSet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VCTASHumanActiveSurveillanceCampaignToSampleTypeSet");
            return Ok(returnResult);
        }

        //TODO:  USSP SPROCs should not be called from the application.  Recommend removing method, or asking if another method will suffice.

        //[HttpDelete, Route("HumanActiveSurveillanceSessionActionDelete")]
        //[ResponseType(typeof(SPReturnResult))]
        //public async Task<IHttpActionResult> HumanActiveSurveillanceSessionActionDelete([Required]long idfMonitoringSessionAction)
        //{
        //    SPReturnResult returnResult = null;

        //    log.Info("HumanActiveSurveillanceSessionActionDelete is called");
        //    try
        //    {
        //        var result = await this._repository.UsspVetMonitoringsessionActionDelAsync(idfMonitoringSessionAction);

        //        if (result != null && result.Count > 0)
        //        {
        //            // If an error occured...
        //            if (result.FirstOrDefault().Column1 != 0) throw new Exception(result.FirstOrDefault().Column2);

        //            returnResult = new SPReturnResult((int)result.FirstOrDefault().Column1);
        //            returnResult.ReturnMessage = result.FirstOrDefault().Column2;

        //        }
        //        log.Info("HumanActiveSurveillanceSessionActionDelete returned");
        //        return Ok<SPReturnResult>(returnResult);
        //    }
        //    catch (Exception e)
        //    {
        //        log.Error("HumanActiveSurveillanceSessionActionDelete failed", e);
        //        return InternalServerError(e);
        //    }
        //}

        /// <summary>
        /// Deletes an Active Surveillance Session
        /// </summary>
        /// <param name="langId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfMonitoringSession">The unique identifier that identifies the session to delete.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpDelete, Route("HumanActiveSurveillanceSessionDelete")]
        [ResponseType(typeof(SPReturnResult))]
        public IHttpActionResult HumanActiveSurveillanceSessionDelete(string langId, long idfMonitoringSession)
        {

            log.Info("HumanActiveSurveillanceSessionDelete is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = _repository.GblAsmonitoringsessionDel(langId, idfMonitoringSession);
                if (result < -1)
                {
                    log.Info("Exiting  HumanActiveSurveillanceSessionDelete With Not Found");
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
                log.Error("SQL Error in HumanActiveSurveillanceSessionDelete Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumanActiveSurveillanceSessionDelete" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  HumanActiveSurveillanceSessionDelete");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrieves details about a human active surveillance session
        /// </summary>
        /// <param name="langId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfMonitoringSession">An integer that uniquely identifies the monitoring session for which details will be retrieved.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpGet, Route("HumanActiveSurveillanceSessionDetail")]
        [ResponseType(typeof(List<HasAssessionGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> HumanActiveSurveillanceSessionDetail([Required]string langId, [Required]long idfMonitoringSession)
        {
            log.Info("HumanActiveSurveillanceSessionDetail is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.HasAssessionGetDetailAsync(idfMonitoringSession, langId);
                if (result == null)
                {
                    log.Info("Exiting  HumanActiveSurveillanceSessionDetail With Not Found");
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
                log.Error("SQL Error in HumanActiveSurveillanceSessionDetail Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumanActiveSurveillanceSessionDetail" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetRefCaseClassification");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrieves a list of human active surveillance sessions
        /// </summary>
        /// <param name="parms"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpPost, Route("HumanActiveSurveillanceSessionList")]
        [ResponseType(typeof(List<GblAssessionGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> HumanActiveSurveillanceSessionGetList([FromBody] HumanActiveSurveillanceSessionGetListParams parms)
        {
            log.Info("HumanActiveSurveillanceSessionGetList is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.GblAssessionGetListAsync(
                    parms.monitoringSessionstrId,
                    parms.monitoringSessionidfsStatus,
                    parms.monitoringSessionDatEnteredFrom,
                    parms.monitoringSessionDatEnteredTo,
                    parms.monitoringSessionidfsRegion,
                    parms.monitoringSessionidfsRayon,
                    parms.monitoringSessionidfsDiagnosis,
                    parms.monitoringSessionstrCampaignId,
                    parms.langId,
                    parms.sessionModule);

                if (result == null)
                {
                    log.Info("Exiting  HumanActiveSurveillanceSessionGetList With Not Found");
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
                log.Error("SQL Error in HumanActiveSurveillanceSessionGetList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumanActiveSurveillanceSessionGetList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  HumanActiveSurveillanceSessionGetList");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a count of human monitoring sessions
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
        [HttpPost, Route("HumanMonitoringSessionListCountAsync")]
        [ResponseType(typeof(List<HasMonitoringSessionGetCountModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetHumanMonitoringSessionListCountAsync([FromBody] MonitoringSessionGetListParameters parameters)
        {
            log.Info("GetHumanMonitoringSessionListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.HasMonitoringSessionGetCountAsync(
                    parameters.LanguageID,
                    parameters.EIDSSSessionID,
                    parameters.SessionStatusTypeID,
                    parameters.DateEnteredFrom,
                    parameters.DateEnteredTo,
                    parameters.RegionID,
                    parameters.RayonID,
                    parameters.DiseaseID,
                    parameters.EIDSSCampaignID);

                if (result == null)
                {
                    log.Info("Exiting  GetHumanMonitoringSessionListCountAsync With Not Found");
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
                log.Error("SQL Error in GetHumanMonitoringSessionListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetHumanMonitoringSessionListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetHumanMonitoringSessionListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Searches for a list of veterinary monitoring sessions
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
        [HttpPost, Route("HumanMonitoringSessionListAsync")]
        [ResponseType(typeof(List<HasMonitoringSessionGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetHumanMonitoringSessionListAsync([FromBody] MonitoringSessionGetListParameters parameters)
        {
            log.Info("GetHumanMonitoringSessionListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                var result = await _repository.HasMonitoringSessionGetListAsync(
                    parameters.LanguageID,
                    parameters.EIDSSSessionID,
                    parameters.SessionStatusTypeID,
                    parameters.DateEnteredFrom,
                    parameters.DateEnteredTo,
                    parameters.RegionID,
                    parameters.RayonID,
                    parameters.DiseaseID,
                    parameters.EIDSSCampaignID,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetHumanMonitoringSessionListAsync With Not Found");
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
            catch (SqlException se)
            {
                log.Error("SQL Error in GetHumanMonitoringSessionListAsync Procedure: " + se.Procedure, se);
                returnResult.ErrorMessage = se.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetHumanMonitoringSessionListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetHumanMonitoringSessionListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Inserts or updates a surveillance session
        /// </summary>
        /// <param name="parms"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpPost, Route("HumanActiveSurveillanceSessionSet")]
        [ResponseType(typeof(HumanActiveSurveillanceSessionSetResult))]
        public IHttpActionResult HumanActiveSurveillanceSessionSet([FromBody] HumanActiveSurveillanceSessionSetParams parms)
        {
            log.Info("HumanActiveSurveillanceSessionSet is called");

            try
            {
                var resultSet = _repository.GblAssessionSet(
                    parms.dfMonitoringSession,
                    parms.idfsMonitoringSessionStatus,
                    parms.idfsCountry,
                    parms.idfsRegion,
                    parms.idfsRayon,
                    parms.idfsSettlement,
                    parms.idfPersonEnteredBy,
                    parms.idfCampaign,
                    parms.idfsDiagnosis,
                    parms.datEnteredDate,
                    parms.strMonitoringSessionId,
                    parms.datStartDate,
                    parms.datEndDate,
                    parms.sessionCategoryId,
                    parms.idfsSite);
                log.Info("HumanActiveSurveillanceSessionSet returned");
                return Ok(resultSet);
            }
            catch (Exception e)
            {
                log.Error("HumanActiveSurveillanceSessionSet failed", e);
                return InternalServerError(e);
            }
        }

        /// <summary>
        /// Inserts or Updates monitoring session actions related to a specific human active surveillance session
        /// </summary>
        /// <param name="parms"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpPost, Route("HumanActiveSurveillanceSessionToActionSet")]
        [ResponseType(typeof(HumanActiveSurveillanceSessionToActionResult))]
        public IHttpActionResult HumanActiveSurveillanceSessionToActionSet([FromBody] HumanActiveSurveillanceSessionToActionParams parms)
        {
            log.Info("HumanActiveSurveillanceSessionSet is called");
            try
            {
                var resultSet = _repository.GblAssessiontoactionSet(
                    out long? idfMonitoringSessionAction,
                    parms.idfMonitoringSession,
                    parms.idfPersonEnteredBy,
                    parms.idfsMonitoringSessionActionType,
                    parms.idfsMonitoringSessionActionStatus,
                    parms.datActionDate,
                    parms.strComments);
                log.Info("HumanActiveSurveillanceSessionSet returned");
                return Ok(resultSet);
            }
            catch (Exception e)
            {
                log.Error("HumanActiveSurveillanceSessionSet failed", e);
                return InternalServerError(e);
            }
        }

        /// <summary>
        /// Inserts or updates a human active surveillance session to campaign mapping
        /// </summary>
        /// <param name="idfMonitoringSession"></param>
        /// <param name="idfCampaign"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpPost, Route("HumanActiveSurveillanceSessionToCampaignSetAsync")]
        [ResponseType(typeof(SPReturnResult))]
        public async Task<IHttpActionResult> HumanActiveSurveillanceSessionToCampaignSetAsync([Required]long idfMonitoringSession, [Required]long idfCampaign)
        {
            log.Info("HumanActiveSurvSessionToCampaignSetAsync is called");
            try
            {
                // INVESTIGATE THE RETURN OF THIS STORED PROCEDURE!!!!!!!
                SPReturnResult result;
                var spResult = await _repository.GblAssessionassoctnSetAsync(idfMonitoringSession, idfCampaign);

                if (spResult == null)
                    return NotFound();
                // The POCO generator interprets the return of some SPs that return the @returnCode, @returnMsg columns as Column1, Column2 in the resultant generated class because 
                // the columns aren't aliased!
                result = new SPReturnResult((int)spResult.FirstOrDefault().Column1);

                log.Info("HumanActiveSurvSessionToCampaignSetAsync returned");
                return Ok(result);
            }
            catch (Exception e)
            {
                log.Error("HumanActiveSurvSessionToCampaignSetAsync failed", e);
                return InternalServerError(e);
            }
        }

        /// <summary>
        /// Deletes a Human Active Surveillance Session To Material mapping.
        /// </summary>
        /// <param name="idfmonitoringSessionToSampleType"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpDelete, Route("HumanActiveSurveillanceSessionToMaterialDelete")]
        [ResponseType(typeof(SPReturnResult))]
        public async Task<IHttpActionResult> HumanActiveSurveillanceSessionToMaterialDelete([Required]long idfmonitoringSessionToSampleType)
        {
            SPReturnResult returnResult = null;

            log.Info("HumanActiveSurveillanceSessionToMaterialDelete is called");
            try
            {
                var result = await _repository.GblAssessiontosampletypeDelAsync(idfmonitoringSessionToSampleType);

                if (result != null)
                {
                    // If an error occured...
                    if (result.FirstOrDefault().Column1 != 0) throw new Exception(result.FirstOrDefault().Column2);

                    returnResult = new SPReturnResult((int)result.FirstOrDefault().Column1)
                    {
                        ReturnMessage = result.FirstOrDefault().Column2
                    };
                }
                log.Info("HumanActiveSurveillanceSessionToMaterialDelete returned");
                return Ok(returnResult);
            }
            catch (Exception e)
            {
                log.Error("HumanActiveSurveillanceSessionToMaterialDelete failed", e);
                return InternalServerError(e);
            }
        }

        /// <summary>
        /// Inserts or Updates human active surveillance session to material mapping
        /// </summary>
        /// <param name="parms"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpPost, Route("HumanActiveSurveillanceSessionToMaterialSet")]
        [ResponseType(typeof(HumanActiveSurveillanceSessionToMaterialResult))]
        public IHttpActionResult HumanActiveSurveillanceSessionToMaterialSet([FromBody] HumanActiveSurveillanceSessionToMaterialParams parms)
        {
            log.Info("HumanActiveSurvSessionToMaterialSet is called");
            try
            {
                var resultSet = _repository.UsspGblMaterialSet(
                    parms.langId,
                    parms.idfMaterial,
                    parms.idfsSampleType,
                    parms.idfRootMaterial,
                    parms.idfParentMaterial,
                    parms.idfHuman,
                    parms.idfSpecies,
                    parms.idfAnimal,
                    parms.idfMonitoringSession,
                    parms.idfFieldCollectedByPerson,
                    parms.idfFieldCollectedByOffice,
                    parms.idfMainTest,
                    parms.datFieldCollectionDate,
                    parms.datFieldSentDate,
                    parms.strFieldBarcode,
                    parms.strCalculatedCaseId,
                    parms.strCalculatedHumanName,
                    parms.idfVectorSurveillanceSession,
                    parms.idfVector,
                    parms.idfSubdivision,
                    parms.idfsSampleStatus,
                    parms.idfInDepartment,
                    parms.idfDestroyedByPerson,
                    parms.datEnteringDate,
                    parms.datDestructionDate,
                    parms.strBarcode,
                    parms.strNote,
                    parms.idfsSite,
                    parms.intRowStatus,
                    parms.idfSendToOffice,
                    parms.blnReadOnly,
                    parms.idfsBirdStatus,
                    parms.idfHumanCase,
                    parms.idfVetCase,
                    parms.datAccession,
                    parms.idfsAccessionCondition,
                    parms.strCondition,
                    parms.idfAccesionByPerson,
                    parms.idfsDestructionMethod,
                    parms.idfsCurrentSite,
                    parms.idfsSampleKind,
                    parms.idfMarkedForDispositionByPerson,
                    parms.datOutOfRepositoryDate,
                    parms.strMaintenanceFlag,
                    parms.recordAction);
                log.Info("HumanActiveSurvSessionToMaterialSet returned");
                return Ok(resultSet);
            }
            catch (Exception e)
            {
                log.Error("HumanActiveSurvSessionToMaterialSet failed", e);
                return InternalServerError(e);
            }
        }

        /// <summary>
        /// Deletes a Human Active Surveillance to Sample mapping
        /// </summary>
        /// <param name="idfmonitoringSessionToSampleType"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpDelete, Route("HumanActiveSurveillanceSessionToSampleDelete")]
        [ResponseType(typeof(SPReturnResult))]
        public async Task<IHttpActionResult> HumanActiveSurveillanceSessionToSampleDelete([Required]long idfmonitoringSessionToSampleType)
        {
            SPReturnResult returnResult = null;

            log.Info("HumanActiveSurveillanceSessionToSampleDelete is called");
            try
            {
                var result = await this._repository.GblAssessiontosampletypeDelAsync(idfmonitoringSessionToSampleType);

                if (result != null)
                {
                    // If an error occured...
                    if (result.FirstOrDefault().Column1 != 0) throw new Exception(result.FirstOrDefault().Column2);

                    returnResult = new SPReturnResult((int)result.FirstOrDefault().Column1)
                    {
                        ReturnMessage = result.FirstOrDefault().Column2
                    };
                }
                log.Info("HumanActiveSurveillanceSessionToSampleDelete returned");
                return Ok<SPReturnResult>(returnResult);
            }
            catch (Exception e)
            {
                log.Error("HumanActiveSurveillanceSessionToSampleDelete failed", e);
                return InternalServerError(e);
            }
        }

        /// <summary>
        /// Inserts or Updates testing related to a specific human active surveillance session
        /// </summary>
        /// <param name="parms">A model collection of data.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpPost, Route("HumanActiveSurveillanceSessionToTestingSet")]
        [ResponseType(typeof(HumanActiveSurveillanceSessionToTestingResult))]
        public IHttpActionResult HumanActiveSurveillanceSessionToTestingSet([FromBody] HumanActiveSurveillanceSessionToTestingParams parms)
        {
            log.Info("HumanActiveSurveillanceSessionToTestingSet is called");
            try
            {
                var resultSet = _repository.UsspGblTestingSet(
                    parms.langId,
                    parms.idfsTesting,
                    parms.idfsTestName,
                    parms.idfsTestCategory,
                    parms.idfsTestResult,
                    parms.idfsTestStatus,
                    parms.idfsDiagnosis,
                    parms.idfMaterial,
                    parms.idfBatchTest,
                    parms.idfObservation,
                    parms.intTestNumber,
                    parms.strNote,
                    parms.intRowStatus,
                    parms.datStartedDate,
                    parms.datConcludedDate,
                    parms.idfTestedByOffice,
                    parms.idfTestedByPerson,
                    parms.idfResultEnteredByOffice,
                    parms.idfResultEnteredByPerson,
                    parms.idfValidatedByOffice,
                    parms.idfValidatedByPerson,
                    parms.blnReadOnly,
                    parms.blnNonLaboratoryTest,
                    parms.blnExternalTest,
                    parms.idfPerformedByOffice,
                    parms.datReceivedDate,
                    parms.strContactPerson,
                    parms.strMaintenanceFlag,
                    parms.recordAction);

                log.Info("HumanActiveSurveillanceSessionToTestingSet returned");
                return Ok(resultSet);
            }
            catch (Exception e)
            {
                log.Error("HumanActiveSurveillanceSessionToTestingSet failed", e);
                return InternalServerError(e);
            }
        }

        /// <summary>
        /// Deletes a Human Active Surveillance to Test mapping
        /// </summary>
        /// <param name="idfTesting">An identifier that specifies the test to delete.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpDelete, Route("HumanActiveSurveillanceSessionToTestingDelete")]
        [ResponseType(typeof(SPReturnResult))]
        public async Task<IHttpActionResult> HumanActiveSurveillanceSessionToTestingDelete([Required]long idfTesting)
        {
            SPReturnResult returnResult = null;

            log.Info("HumanActiveSurveillanceSessionToTestingDelete is called");
            try
            {
                var result = await _repository.UsspGblTestingDelAsync(idfTesting);

                if (result != null)
                {
                    // If an error occured...
                    if (result.FirstOrDefault().Column1 != 0) throw new Exception(result.FirstOrDefault().Column2);

                    returnResult = new SPReturnResult((int)result.FirstOrDefault().Column1)
                    {
                        ReturnMessage = result.FirstOrDefault().Column2
                    };
                }
                log.Info("HumanActiveSurveillanceSessionToTestingDelete returned");
                return Ok(returnResult);
            }
            catch (Exception e)
            {
                log.Error("HumanActiveSurveillanceSessionToTestingDelete failed", e);
                return InternalServerError(e);
            }
        }

        #endregion

        #region Human Methods



        /// <summary>
        /// Returns Huma Disease Person Information
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfHuman"></param>
        /// <param name="idfHumanActual"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<HumDiseasePersoninformationGetDetailModel>))]
        [HttpGet, Route("HumDiseasePersoninformationGetDetailAsync")]
        public async Task<IHttpActionResult> HumDiseasePersoninformationGetDetailAsync(string languageId, long? idfHuman,long? idfHumanActual)
        {
            log.Info("HumDiseasePersoninformationGetDetailAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.HumDiseasePersoninformationGetDetailAsync(languageId, idfHuman, idfHumanActual);
                if (result == null)
                {
                    log.Info("Exiting  HumDiseasePersoninformationGetDetailAsync With Not Found");
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
                log.Error("SQL Error in HumDiseasePersoninformationGetDetailAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumDiseasePersoninformationGetDetailAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  HumDiseasePersoninformationGetDetailAsync");
            return Ok(returnResult);
        }











        /// <summary>
        /// Gets details about a person
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="humanMasterId">The human master identifier of the record to get details on</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpGet, Route("HumanMasterGetDetailAsync")]
        [ResponseType(typeof(List<HumHumanMasterGetDetailModel>))]
        public async Task<IHttpActionResult> GetHumanMasterDetailAsync([Required]string languageId, [Required]long humanMasterId)
        {
            log.Info("GetHumanMasterDetailAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.HumHumanMasterGetDetailAsync(languageId, humanMasterId);
                if (result == null)
                {
                    log.Info("Exiting  GetHumanMasterDetailAsync With Not Found");
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
                log.Error("SQL Error in GetHumanMasterDetailAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetHumanMasterDetailAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetHumanMasterDetailAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Searches for a list of patients or farm owners associated with a disease report or monitoring session.
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
        [HttpPost, Route("HumanMasterGetListAsync")]
        [ResponseType(typeof(List<HumHumanMasterGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetHumanMasterListAsync([FromBody] HumanGetListParams parameters)
        {
            log.Info("GetHumanMasterListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                var result = await _repository.HumHumanMasterGetListAsync(
                    parameters.LanguageID,
                    parameters.EIDSSPersonID,
                    parameters.PersonalIDType,
                    parameters.PersonalID,
                    parameters.FirstOrGivenName,
                    parameters.SecondName,
                    parameters.LastOrSurname,
                    parameters.ExactDateOfBirth,
                    parameters.DateOfBirthFrom,
                    parameters.DateOfBirthTo,
                    parameters.GenderTypeID,
                    parameters.RegionID,
                    parameters.RayonID,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetHumanMasterListAsync With Not Found");
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
                log.Error("SQL Error in GetHumanMasterListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetHumanMasterListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetHumanMasterListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a count for a list of patients or farm owners associated with a disease report or monitoring session.
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
        [HttpPost, Route("HumanMasterGetListCountAsync")]
        [ResponseType(typeof(List<HumHumanMasterGetCountModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetHumanMasterListCountAsync([FromBody] HumanGetListParams parameters)
        {
            log.Info("GetHumanMasterListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.HumHumanMasterGetCountAsync(
                    parameters.LanguageID,
                    parameters.EIDSSPersonID,
                    parameters.PersonalIDType,
                    parameters.PersonalID,
                    parameters.FirstOrGivenName,
                    parameters.SecondName,
                    parameters.LastOrSurname,
                    parameters.ExactDateOfBirth,
                    parameters.DateOfBirthFrom,
                    parameters.DateOfBirthTo,
                    parameters.GenderTypeID,
                    parameters.RegionID,
                    parameters.RayonID);

                if (result == null)
                {
                    log.Info("Exiting  GetHumanMasterListCountAsync With Not Found");
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
                log.Error("SQL Error in GetHumanMasterListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetHumanMasterListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetHumanMasterListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Searches for a list of patients or farm owners associated with a disease report or monitoring session.
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
        [HttpPost, Route("HumanGetListAsync")]
        [ResponseType(typeof(List<HumHumanGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetHumanListAsync([FromBody] HumanGetListParams parameters)
        {
            log.Info("GetHumanListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                var result = await _repository.HumHumanGetListAsync(
                    parameters.LanguageID,
                    parameters.EIDSSPersonID,
                    parameters.PersonalIDType,
                    parameters.PersonalID,
                    parameters.FirstOrGivenName,
                    parameters.SecondName,
                    parameters.LastOrSurname,
                    parameters.DateOfBirthFrom,
                    parameters.DateOfBirthTo,
                    parameters.GenderTypeID,
                    parameters.RegionID,
                    parameters.RayonID,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);

                if (result == null)
                {
                    log.Info("Exiting  GetHumanListAsync With Not Found");
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
                log.Error("SQL Error in GetHumanListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetHumanListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetHumanListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a count for a list of patients or farm owners associated with a disease report or monitoring session.
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
        [HttpPost, Route("HumanGetListCountAsync")]
        [ResponseType(typeof(List<HumHumanGetCountModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetHumanListCountAsync([FromBody] HumanGetListParams parameters)
        {
            log.Info("GetHumanListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.HumHumanGetCountAsync(
                    parameters.LanguageID,
                    parameters.EIDSSPersonID,
                    parameters.PersonalIDType,
                    parameters.PersonalID,
                    parameters.FirstOrGivenName,
                    parameters.SecondName,
                    parameters.LastOrSurname,
                    parameters.DateOfBirthFrom,
                    parameters.DateOfBirthTo,
                    parameters.GenderTypeID,
                    parameters.RegionID,
                    parameters.RayonID);

                if (result == null)
                {
                    log.Info("Exiting  GetHumanListCountAsync With Not Found");
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
                log.Error("SQL Error in GetHumanListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetHumanListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetHumanListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Inserts/updates a human master record
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
        [HttpPost, Route("HumanMasterSaveAsync")]
        [ResponseType(typeof(List<HumHumanMasterSetModel>))]
        public async Task<IHttpActionResult> SaveHumanMasterAsync([FromBody] HumanSetParam parameters)
        {
            log.Info("SaveHumanMasterAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.HumHumanMasterSetAsync(
                    parameters.HumanMasterID,
                    parameters.CopyToHumanIndicator,
                    parameters.PersonalIDType,
                    parameters.EIDSSPersonID,
                    parameters.PersonalID,
                    parameters.FirstOrGivenName,
                    parameters.SecondName,
                    parameters.LastOrSurname,
                    parameters.DateOfBirth,
                    parameters.DateOfDeath,
                    parameters.ReportedAge,
                    parameters.ReportedAgeUOMID,
                    parameters.GenderTypeID,
                    parameters.OccupationTypeID,
                    parameters.CitizenshipTypeID,
                    parameters.PassportNumber,
                    parameters.IsEmployedTypeID,
                    parameters.EmployerName,
                    parameters.EmployedDateLastPresent,
                    parameters.EmployerForeignAddressIndicator,
                    parameters.EmployerForeignAddressString,
                    parameters.EmployerGeoLocationID,
                    parameters.EmployeridfsCountry,
                    parameters.EmployeridfsRegion,
                    parameters.EmployeridfsRayon,
                    parameters.EmployeridfsSettlement,
                    parameters.EmployerstrStreetName,
                    parameters.EmployerstrApartment,
                    parameters.EmployerstrBuilding,
                    parameters.EmployerstrHouse,
                    parameters.EmployeridfsPostalCode,
                    parameters.EmployerPhone,
                    parameters.IsStudentTypeID,
                    parameters.SchoolName,
                    parameters.SchoolDateLastAttended,
                    parameters.SchoolForeignAddressIndicator,
                    parameters.SchoolForeignAddressString,
                    parameters.SchoolGeoLocationID,
                    parameters.SchoolidfsCountry,
                    parameters.SchoolidfsRegion,
                    parameters.SchoolidfsRayon,
                    parameters.SchoolidfsSettlement,
                    parameters.SchoolstrStreetName,
                    parameters.SchoolstrApartment,
                    parameters.SchoolstrBuilding,
                    parameters.SchoolstrHouse,
                    parameters.SchoolidfsPostalCode,
                    parameters.SchoolPhone,
                    parameters.HumanGeoLocationID,
                    parameters.HumanidfsCountry,
                    parameters.HumanidfsRegion,
                    parameters.HumanidfsRayon,
                    parameters.HumanidfsSettlement,
                    parameters.HumanstrStreetName,
                    parameters.HumanstrApartment,
                    parameters.HumanstrBuilding,
                    parameters.HumanstrHouse,
                    parameters.HumanidfsPostalCode,
                    parameters.HumanstrLatitude,
                    parameters.HumanstrLongitude,
                    parameters.HumanstrElevation,
                    parameters.HumanAltGeoLocationID,
                    parameters.HumanAltForeignAddressIndicator,
                    parameters.HumanAltForeignAddressString,
                    parameters.HumanAltidfsCountry,
                    parameters.HumanAltidfsRegion,
                    parameters.HumanAltidfsRayon,
                    parameters.HumanAltidfsSettlement,
                    parameters.HumanAltstrStreetName,
                    parameters.HumanAltstrApartment,
                    parameters.HumanAltstrBuilding,
                    parameters.HumanAltstrHouse,
                    parameters.HumanAltidfsPostalCode,
                    parameters.HumanAltstrLatitude,
                    parameters.HumanAltstrLongitude,
                    parameters.HumanAltstrElevation,
                    parameters.RegistrationPhone,
                    parameters.HomePhone,
                    parameters.WorkPhone,
                    parameters.ContactPhoneCountryCode,
                    parameters.ContactPhone,
                    parameters.ContactPhoneTypeID,
                    parameters.ContactPhone2CountryCode,
                    parameters.ContactPhone2,
                    parameters.ContactPhone2TypeID
                  );

                if (result == null)
                {
                    log.Info("Exiting  SaveHumanMasterAsync With Not Found");
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
                log.Error("SQL Error in SaveHumanMasterAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in SaveHumanMasterAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  SaveHumanMasterAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Deletes a person
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="humanMasterId">The human master identifier of the record to delete</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpDelete, Route("HumanMasterDeleteAsync")]
        [ResponseType(typeof(List<HumHumanSetModel>))]
        public async Task<IHttpActionResult> DeleteHumanMasterAsync([Required]string languageId, [Required]long humanMasterId)
        {
            log.Info("Entering DeleteHumanMasterAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.HumHumanMasterDelAsync(languageId, humanMasterId);
                if (result == null)
                {
                    log.Info("Exiting  DeleteHumanMasterAsync With Not Found");
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
                log.Error("SQL Error in DeleteHumanMasterAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in DeleteHumanMasterAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  DeleteHumanMasterAsync");
            return Ok(returnResult);
        }

        #endregion

        #region Aggregate

        /// <summary>
        /// Deletes  Human Aggregate Case 
        /// </summary>
        /// <param name="id">Case id </param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [ResponseType(typeof(List<HumanAggregateCaseDeleteModel>))]
        [HttpDelete, Route("DeleteHumanAggregateCaseAsync")]
        public async Task<IHttpActionResult> HumanAggregateCaseDeleteAsync(long id)
        {
            log.Info("HumanAggregateCaseDeleteAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.AggCaseDeleteAsync(id);
                if (result == null)
                {
                    log.Info("Exiting  HumanAggregateCaseDeleteAsync With Not Found");
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
                log.Error("SQL Error in HumanAggregateCaseDeleteAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumanAggregateCaseDeleteAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  HumanAggregateCaseDeleteAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets Details of a Human Aggregate Case 
        /// </summary>
        /// <param name="humanAggregateDetailsGetParams">Case id </param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [ResponseType(typeof(List<AggCaseGetdetailModel>))]
        [HttpPost, Route("HumanAggregateCaseGetDetailAsync")]
        public async Task<IHttpActionResult> HumanAggregateCaseGetDetailAsync(HumanAggregateDetailsGetParams humanAggregateDetailsGetParams)
        {
            log.Info("HumanAggregateCaseGetDetailAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.AggCaseGetdetailAsync(
                     humanAggregateDetailsGetParams.langId,
                     humanAggregateDetailsGetParams.idfsAggrCaseType,
                     humanAggregateDetailsGetParams.idfAggrCase
                     //humanAggregateDetailsGetParams.strSearchCaseId,
                     //humanAggregateDetailsGetParams.idfsTimeInterval,
                     //humanAggregateDetailsGetParams.datSearchStartDate,
                     //humanAggregateDetailsGetParams.datSearchEndDate,
                     //humanAggregateDetailsGetParams.idfsAdministrativeUnit
                     );
                if (result == null)
                {
                    log.Info("Exiting  HumanAggregateCaseGetDetailAsync With Not Found");
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
                log.Error("SQL Error in HumanAggregateCaseGetDetailAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumanAggregateCaseGetDetailAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  HumanAggregateCaseGetDetailAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns  RepHumOrganizationSelectLookup Model
        /// </summary>
        /// <param name="id">Id</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<RepHumOrganizationSelectLookupModel>))]
        [HttpGet, Route("RepHumOrganizationSelectLookupAsync")]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> RepHumOrganizationSelectLookupAsync(string languageId, long id)
        {
            log.Info("RepHumOrganizationSelectLookupAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.RepHumOrganizationSelectLookupAsync(languageId, id);
                if (result == null)
                {
                    log.Info("Exiting  RepHumOrganizationSelectLookupAsync With Not Found");
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
                log.Error("SQL Error in RepHumOrganizationSelectLookupAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RepHumOrganizationSelectLookupAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  RepHumOrganizationSelectLookupAsync");
            return Ok(returnResult);

        }

        /// <summary>
        /// Returns  RepHumOrganizationSelectLookup Model
        /// </summary>
        /// <param name="aggCaseGetListParams">Request Object</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<AggCaseGetlistModel>))]
        [HttpPost, Route("AggCaseGetlistAsync")]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> AggCaseGetlistAsync(AggCaseGetListParams aggCaseGetListParams)
        {
            log.Info("AggCaseGetlistAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.AggCaseGetlistAsync(
                    aggCaseGetListParams.langId,
                    aggCaseGetListParams.idfsAggrCaseType,
                    aggCaseGetListParams.strSearchCaseId,
                    aggCaseGetListParams.idfsTimeInterval,
                    aggCaseGetListParams.datSearchStartDate,
                    aggCaseGetListParams.datSearchEndDate,
                    aggCaseGetListParams.idfsAdministrativeUnit
                    );
                if (result == null)
                {
                    log.Info("Exiting  AggCaseGetlistAsync With Not Found");
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
                log.Error("SQL Error in AggCaseGetlistAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in AggCaseGetlistAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  AggCaseGetlistAsync");
            return Ok(returnResult);

        }

        /// <summary>
        /// returns Aggregate Settings Details
        /// </summary>
        /// <param name="idfsAggCaseType">Case type Id</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<AggregateSettingsSelectDetailModel>))]
        [HttpGet, Route("AggregateSettingsSelectDetailAsync")]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> AggregateSettingsSelectDetailAsync(long? idfsAggCaseType)
        {
            log.Info("AggregateSettingsSelectDetailAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.AggregateSettingsSelectDetailAsync(idfsAggCaseType);
                if (result == null)
                {
                    log.Info("Exiting  AggregateSettingsSelectDetailAsync With Not Found");
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
                log.Error("SQL Error in AggregateSettingsSelectDetailAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in AggregateSettingsSelectDetailAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  AggregateSettingsSelectDetailAsync");
            return Ok(returnResult);
        }



        /// <summary>
        /// Saves, Sets Aggregate Case
        /// </summary>
        /// <param name="aggCaseSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<AggCaseSetModel>))]
        [HttpPost, Route("AggCaseSetAsync")]
        public async Task<IHttpActionResult> AggCaseSetAsync(AggCaseSetParams aggCaseSetParams)
        {
            log.Info("AggCaseSetAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.AggCaseSetAsync(
                    aggCaseSetParams.idfAggrCase,
                    aggCaseSetParams.strCaseId,
                    aggCaseSetParams.idfsAggrCaseType,
                    aggCaseSetParams.idfsAdministrativeUnit,
                    aggCaseSetParams.idfReceivedByOffice,
                    aggCaseSetParams.idfEnteredByPerson,
                    aggCaseSetParams.idfSentByOffice,
                    aggCaseSetParams.idfSentByPerson,
                    aggCaseSetParams.idfEnteredByOffice,
                    aggCaseSetParams.idfEnteredByPerson,
                    aggCaseSetParams.idfCaseObservation,
                    aggCaseSetParams.idfsCaseObservationFormTemplate,
                    aggCaseSetParams.idfDiagnosticObservation,
                    aggCaseSetParams.idfsDiagnosticObservationFormTemplate,
                    aggCaseSetParams.idfProphylacticObservation,
                    aggCaseSetParams.idfsProphylacticObservationFormTemplate,
                    aggCaseSetParams.idfSanitaryObservation,
                    aggCaseSetParams.idfVersion,
                    aggCaseSetParams.idfDiagnosticVersion,
                    aggCaseSetParams.idfProphylacticVersion,
                    aggCaseSetParams.idfSanitaryVersion,
                    aggCaseSetParams.idfsSanitaryObservationFormTemplate,
                    aggCaseSetParams.datReceivedByDate,
                    aggCaseSetParams.datSentByDate,
                    aggCaseSetParams.datEnteredByDate,
                    aggCaseSetParams.datStartDate,
                    aggCaseSetParams.datFinishDate,
                    aggCaseSetParams.datModificationForArchiveDate
                    );
                if (result == null)
                {
                    log.Info("Exiting  AggCaseSetAsync With Not Found");
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
                log.Error("SQL Error in AggCaseSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in AggCaseSetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  AggCaseSetAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Saves, Sets Aggregate Case
        /// </summary>
        /// <param name="idfsBaseReference"></param>
        /// <param name="intHaCode"></param>
        /// <param name="strLanguageId"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<GblDiseaseMtxGetModel>))]
        [HttpGet, Route("GetHumanCaseMatrix")]
        public async Task<IHttpActionResult> GetHumanCaseMatrixAsync(long idfsBaseReference, int intHaCode, string strLanguageId)
        {
            log.Info("GetHumanCaseMatrixAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.GblDiseaseMtxGetAsync(idfsBaseReference, intHaCode, strLanguageId);
                if (result == null)
                {
                    log.Info("Exiting  GetHumanCaseMatrixAsync With Not Found");
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
                log.Error("SQL Error in GetHumanCaseMatrixAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetHumanCaseMatrixAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetHumanCaseMatrixAsync");
            return Ok(returnResult);
        }






        #endregion




        #region ILI

        /// <summary>
        /// Returns ILI AGGREGATE
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="strFormId"></param>
        /// <param name="idfAggregateHeader"></param>
        /// <param name="siteId"></param>
        /// <param name="idfHospital"></param>
        /// <param name="datStartDate"></param>
        /// <param name="datFinishDate"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<IliAggregateGetListModel>))]
        [HttpGet, Route("IliAggregateGetListAsync")]
        public async Task<IHttpActionResult> IliAggregateGetListAsync(string languageId, string strFormId, long idfAggregateHeader, long? siteId, long? idfHospital, DateTime? datStartDate = null, DateTime? datFinishDate = null)
        {
            log.Info("IliAggregateGetListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.IliAggregateGetListAsync(languageId, strFormId, idfAggregateHeader, siteId, idfHospital, datStartDate, datFinishDate);

                if (result == null)
                {
                    log.Info("Exiting  IliAggregateGetListAsync With Not Found");
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
                log.Error("SQL Error in IliAggregateGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in IliAggregateGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  IliAggregateGetListAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Creates ILI AGGREGATE
        /// </summary>
        /// <param name="iLIAggregateSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<IliAggregateSetModel>))]
        [HttpPost, Route("IliAggregateSetAsync")]
        public async Task<IHttpActionResult> IliAggregateSetAsync(ILIAggregateSetParams iLIAggregateSetParams)
        {
            log.Info("IliAggregateSetAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                   var result = await _repository.IliAggregateSetAsync(
                    iLIAggregateSetParams.langId,
                    iLIAggregateSetParams.idfAggregateDetail,
                    iLIAggregateSetParams.idfAggregateHeader,
                    iLIAggregateSetParams.idfEnteredBy,
                    iLIAggregateSetParams.idfsSite,
                    iLIAggregateSetParams.intYear,
                    iLIAggregateSetParams.intWeek,
                    iLIAggregateSetParams.datStartDate,
                    iLIAggregateSetParams.datFinishDate,
                    iLIAggregateSetParams.idfHospital,
                    iLIAggregateSetParams.intAge0_4,
                    iLIAggregateSetParams.intAge5_14,
                    iLIAggregateSetParams.intAge15_29,
                    iLIAggregateSetParams.intAge30_64,
                    iLIAggregateSetParams.intAge65,
                    iLIAggregateSetParams.inTotalIli,
                    iLIAggregateSetParams.intTotalAdmissions,
                    iLIAggregateSetParams.intIliSamples
                    );
                if (result == null)
                {
                    log.Info("Exiting  IliAggregateSetAsync With Not Found");
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
                log.Error("SQL Error in IliAggregateSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in IliAggregateSetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  IliAggregateSetAsync");
            return Ok(returnResult);
        }









        /// <summary>
        /// Deletes ILI AGGREGATE
        /// </summary>
        /// <param name="idfAggregateDetail"></param>
        /// <param name="idfAggregateHeader"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<IliAggregateDeleteModel>))]
        [HttpDelete, Route("IliAggregateDeleteAsync")]
        public async Task<IHttpActionResult> IliAggregateDeleteAsync(long idfAggregateDetail, long idfAggregateHeader)
        {
            log.Info("IliAggregateDeleteAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.IliAggregateDeleteAsync(idfAggregateDetail, idfAggregateHeader);
                 
                if (result == null)
                {
                    log.Info("Exiting  IliAggregateDeleteAsync With Not Found");
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
                log.Error("SQL Error in IliAggregateDeleteAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in IliAggregateDeleteAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  IliAggregateDeleteAsync");
            return Ok(returnResult);
        }






        #endregion








    }
}