using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Domain.Return_Contracts;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using Newtonsoft.Json;
using OpenEIDSS.Extensions.Attributes;
using System.Net;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// Provides outbreak specific functionality.
    /// </summary>
    [RoutePrefix("api/Outbreak")]
    public class OutbreakController : ApiController
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(OutbreakController));
        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// 
        /// </summary>
        public OutbreakController()
        {
        }

        /// <summary>
        /// Obtains the parameter listing for a given Outbreak Session.
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
        [CacheHttpGetAttribute(0, 0, false)]
        [HttpPost, Route("OmmSessionParametersGetListAsync")]
        [ResponseType(typeof(List<OmmSessionGetDetailModel>))]
        public async Task<IHttpActionResult> GetOmmSessionParametersGetListAsync(OmmSessionParametersGetListParams parms)
        {
            log.Info("GetOmmSessionParametersGetListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                // Call the database.
                var result = await _repository.OmmSessionParametersGetListAsync(
                    parms.langId,
                    parms.idfOutbreak
                );
                if (result == null)
                {
                    log.Info("Exiting  GetOmmSessionParametersGetListAsync With Not Found");
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
                log.Error("SQL Error in GetOmmSessionParametersGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetOmmSessionParametersGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetOmmSessionParametersGetListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Obtains the note details pertaining to one Session.
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
        [CacheHttpGetAttribute(0, 0, false)]
        [HttpPost, Route("OmmSessionNoteGetDetailAsync")]
        [ResponseType(typeof(List<OmmSessionNoteGetDetailModel>))]
        public async Task<IHttpActionResult> GetOmmSessionNoteGetDetailAsync(OMMSessionNoteGetDetailsParams parms)
        {
            log.Info("GetOmmSessionNoteGetDetailAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.OmmSessionNoteGetDetailAsync(
                    parms.langId,
                    parms.idfOutbreakNote
                );
                if (result == null)
                {
                    log.Info("Exiting  GetOmmSessionNoteGetDetailAsync With Not Found");
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
                log.Error("SQL Error in GetOmmSessionNoteGetDetailAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetOmmSessionNoteGetDetailAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetOmmSessionNoteGetDetailAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Obtains the details pertaining to one Outbreak Session.
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
        [CacheHttpGetAttribute(0, 0, false)]
        [HttpPost, Route("OmmSessionGetDetailAsync")]
        [ResponseType(typeof(List<OmmSessionGetDetailModel>))]
        public async Task<IHttpActionResult> GetOmmSessionGetDetailAsync(OmmSessionGetDetailParams parms)
        {
            log.Info("GetOmmSessionGetDetailAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                // Call the database.
                var result = await _repository.OmmSessionGetDetailAsync(
                    parms.langId,
                    parms.idfOutbreak
                );
                if (result == null)
                {
                    log.Info("Exiting  GetOmmSessionGetDetailAsync With Not Found");
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
                log.Error("SQL Error in GetOmmSessionGetDetailAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetOmmSessionGetDetailAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetOmmSessionGetDetailAsync");
            return Ok(returnResult);
        }






        /// <summary>
        /// Obtains a listing of Cases for a given Outbreak...either full or filtered search.
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
        [CacheHttpGetAttribute(0, 0, false)]
        [HttpPost, Route("OmmCaseGetListAsync")]
        [ResponseType(typeof(List<OmmCaseGetListModel>))]
        public IHttpActionResult GetOmmCaseGetListAsync(OmmCaseGetListParams parms)
        {
            log.Info("GetOmmCaseGetListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                // Call the database.
                var result = _repository.OmmCaseGetList(
                    parms.langId,
                    parms.idfOutbreak,
                    parms.QuickSearch,
                    parms.HumanMasterID, 
                    parms.VetMasterID);

                if (result == null)
                {
                    log.Info("Exiting  GetOmmCaseGetListAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString() + " " + DateTime.Now.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in GetOmmCaseGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetOmmCaseGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetOmmCaseGetListAsync");
            return Ok(returnResult);
        }






        /// <summary>
        /// Obtains a listing of Outbreaks (or Sessions)...either full or filtered search.
        /// </summary>
        /// <param name="parms"></param>
        /// <returns>
        /// On success a 200 OK status is returned along with a response object.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>
        [CacheHttpGetAttribute(0, 0, false)]
        [HttpPost, Route("OmmSessionGetList")]
        [ResponseType(typeof(List<OmmSessionGetListModel>))]
        public async Task<IHttpActionResult> GetOmmSessionGetList(OmmSessionGetListParams parms)
        {
            log.Info("GetOmmSessionGetList is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                // Call the database.
                var result = await _repository.OmmSessionGetListAsync(
                    parms.langId,
                    parms.strOutbreakID,
                    parms.outbreakTypeId,
                    parms.searchDiagnosesGroup,
                    parms.startDateFrom,
                    parms.startDateTo,
                    parms.idfsOutbreakStatus,
                    parms.idfsRegion,
                    parms.idfsRayon,
                    parms.quickSearch,
                    parms.paginationSet,
                    parms.pageSize,
                    parms.maxPagesPerFetch
                );
                if (result == null)
                {
                    log.Info("Exiting  GetOmmSessionGetList With Not Found");
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
                log.Error("SQL Error in GetOmmSessionGetList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetOmmSessionGetList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetOmmSessionGetList");
            return Ok(returnResult);
        }




        /// <summary>
        /// Obtains a listing of Outbreaks (or Sessions)...either full or filtered search. (Async Method)
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
        [CacheHttpGetAttribute(0, 0, false)]
        [HttpPost, Route("OMMSessionNoteGetListAsync")]
        [ResponseType(typeof(List<OmmSessionNoteGetListModel>))]
        public async Task<IHttpActionResult> GetOMMSessionNoteListAsync(OMMSessionNoteGetListParams parms)
        {
            log.Info("GetOMMSessionNoteListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                // Call the database.
                var result = await _repository.OmmSessionNoteGetListAsync(
                    parms.langId,
                    parms.idfOutbreak
                );
                if (result == null)
                {
                    log.Info("Exiting  GetOMMSessionNoteListAsync With Not Found");
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
                log.Error("SQL Error in GetOMMSessionNoteListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetOMMSessionNoteListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetOMMSessionNoteListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Inserts a new or updates an existing session note
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
        [HttpPost, Route("OmmSessionNoteSet")]
        [ResponseType(typeof(List<OmmSessionNoteSetModel>))]
        public async Task<IHttpActionResult> SetOmmSessionNote(OMMSessionNoteSetParams parms)
        {
            log.Info("SetOmmSessionNote is called");
            APIReturnResult returnResult = new APIReturnResult();
            long? idfOutbreakNote;
            
            try
            {
                idfOutbreakNote = parms.idfOutbreakNote;

                var result = await this._repository.OmmSessionNoteSetAsync(
                    parms.langId,
                    idfOutbreakNote,
                    parms.idfOutbreak,
                    parms.strNote,
                    parms.idfPerson,
                    parms.intRowStatus,
                    parms.strMaintenanceFlag,
                    parms.strReservedAttribute,
                    parms.updatePriorityId,
                    parms.updateRecordTitle,
                    parms.uploadFileName,
                    parms.uploadFileDescription,
                    parms.uploadFileObject,
                    parms.DeleteAttachment);
                if (result == null)
                {
                    log.Info("Exiting  SetOmmSessionNote With Not Found");
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
                log.Error("SQL Error in SetOmmSessionNote Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in SetOmmSessionNote" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  SetOmmSessionNote");
            return Ok(returnResult);
        }


        /// <summary>
        /// Inserts a new or updates an existing outbreak session
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
        [HttpPost, Route("OmmSessionSetAsync")]
        [ResponseType(typeof(List<OmmSessionSetModel>))]
        public async Task<IHttpActionResult> SetOmmSessionAsync(OMMSessionSetParams parms)
        {
            log.Info("SetOmmSession is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                //Descepancy between VB and C# value passing
                //Must reset date fields to to null, if using default value of DateTime.MinValue
                if (parms.datStartDate == DateTime.MinValue) { parms.datStartDate = null; }
                if (parms.datCloseDate == DateTime.MinValue) { parms.datCloseDate = null; }
                if (parms.datModificationForArchiveDate == DateTime.MinValue) { parms.datModificationForArchiveDate = null; }

                var result = await _repository.OmmSessionSetAsync(
                    parms.langId,
                    parms.idfOutbreak,
                    parms.idfsDiagnosisOrDiagnosisGroup,
                    parms.idfsOutbreakStatus,
                    parms.OutbreakTypeId,
                    parms.outbreakLocationidfsCountry,
                    parms.outbreakLocationidfsRegion,
                    parms.outbreakLocationidfsRayon,
                    parms.outbreakLocationidfsSettlement,
                    parms.datStartDate,
                    parms.datCloseDate,
                    parms.strOutbreakID,
                    parms.strDescription,
                    parms.intRowStatus,
                    parms.datModificationForArchiveDate,
                    parms.idfPrimaryCaseOrSession,
                    parms.idfsSite,
                    parms.strMaintenanceFlag,
                    parms.strReservedAttribute,
                    JsonConvert.SerializeObject(parms.OutbreakParameters));

                if (result == null)
                {
                    log.Info("Exiting  SetOmmSessionAsync With Not Found");
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
                log.Error("SQL Error in SetOmmSessionAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in SetOmmSessionAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  SetOmmSessionAsync");
            return Ok(returnResult);
        }



        /// <summary>
        /// Obtains the parameter listing for a given Outbreak Session.
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
        [CacheHttpGetAttribute(0, 0, false)]
        [HttpPost, Route("OmmNoteFileGetAsync")]
        [ResponseType(typeof(List<OmmNoteFileGetModel>))]
        public async Task<IHttpActionResult> GetOmmNoteFileAsync(OmmNoteFileParams parms)
        {
            log.Info("GetOmmNoteFileAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                // Call the database.
                var result = await _repository.OmmNoteFileGetAsync(
                    parms.idfOutbreakNote
                );
                if (result == null)
                {
                    log.Info("Exiting  GetOmmNoteFileAsync With Not Found");
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
                log.Error("SQL Error in GetOmmNoteFileAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetOmmNoteFileAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetOmmNoteFileAsync");
            return Ok(returnResult);
        }



        /// <summary>
        /// Inserts a new or updates an existing session note
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
        [HttpPost, Route("OMMCaseSetAsync")]
        [ResponseType(typeof(OmmCaseSetModel))]
        public async Task<IHttpActionResult> SetOMMCaseAsync(OmmCaseSetParams parms)
        {
            log.Info("SetOMMCaseAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.OmmCaseSetAsync(
                    parms.langId,
                    parms.CaseReportUID,
                    parms.idfOutbreak,
                    parms.strOutbreakCaseID,
                    parms.idfHumanCase,
                    parms.idfVetCase,
                    parms.diseaseID,
                    parms.CaseObservationID,
                    parms.CaseMonitoringObservationID,
                    //Outbreak Case Details
                    parms.CaseClassificationID,
                    parms.intRowStatus,
                    parms.User,
                    parms.DTM,
                    //Human Disease Creation
                    parms.idfHumanActual,
                    parms.idfsDiagnosisOrDiagnosisGroup,
                    //Human Disease Notification
                    parms.datNotificationDate,
                    parms.idfSentByOffice,
                    parms.strSentByFirstName,
                    parms.strSentByLastName,
                    parms.idfReceivedByOffice,
                    parms.strReceivedByFirstName,
                    parms.strReceivedByLastName,
                    //Human Disease Location
                    parms.idfsLocationCountry,
                    parms.idfsLocationRegion,
                    parms.idfsLocationRayon,
                    parms.idfsLocationSettlement,
                    parms.intLocationLatitude,
                    parms.intLocationLongitude,
                    parms.strStreet,
                    parms.strHouse,
                    parms.strBuilding,
                    parms.strApartment,
                    parms.strPostalCode,
                    //Human Clinical Information
                    parms.CaseStatusID,
                    parms.datOnSetDate,
                    parms.datFinalDiagnosisDate,
                    parms.strHospitalizationPlace,
                    parms.datHospitalizationDate,
                    parms.datDischargeDate,
                    parms.strAntibioticName,
                    parms.strDosage,
                    parms.datFirstAdministeredDate,
                    JsonConvert.SerializeObject(parms.Vaccinations),
                    parms.strClinicalComments,
                    parms.idfsYNSpecIFicVaccinationAdministered,
                    parms.StartDateofInvestigation,
                    //Outbreak Investigation
                    parms.idfInvestigatedByOffice,
                    parms.idfInvestigatedByPerson,
                    parms.datInvestigationStartDate,
                    parms.IsPrimaryCaseFlag,
                    parms.strOutbreakInvestigationComments,
                    //Case Monitoring
                    parms.datMonitoringDate,
                    parms.CaseMonitoringAdditionalComments,
                    parms.CaseInvestigatorOrganization,
                    parms.CaseInvestigatorName,
                    //Case Contacts
                    JsonConvert.SerializeObject(parms.CaseContacts),
                    //Case Samples
                    JsonConvert.SerializeObject(parms.Samples),
                    parms.AccessionDate,
                    parms.SampleConditionReceived,
                    parms.VaccinationName,
                    parms.datDateOfVaccination

            );
                if (result == null)
                {
                    log.Info("Exiting  SetOMMCaseAsync With Not Found");
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
                log.Error("SQL Error in SetOMMCaseAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in SetOMMCaseAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  SetOMMCaseAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Inserts a new or updates an existing session note
        /// </summary>
        /// <param name="idfOutbreak"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("OMMSessionDeleteAsync")]
        [ResponseType(typeof(OmmSessionDelModel))]
        public async Task<IHttpActionResult> DelOMMSessionAsync(long idfOutbreak)
        {
            //OmmSessionDelAsync
            log.Info("DelOMMSessionAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.OmmSessionDelAsync(idfOutbreak);
                

                if (result == null)
                {
                    log.Info("Exiting DelOMMSessionAsync With Not Found");
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
                log.Error("SQL Error in DelOMMSessionAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in DelOMMSessionAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  DelOMMSessionAsync");
            return Ok(returnResult);
        }



        /// <summary>
        /// Inserts a new or updates an existing session note
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
        [HttpPost, Route("OMMContactSetAsync")]
        [ResponseType(typeof(List<OMMSessionSetResult>))]
        public async Task<IHttpActionResult> SetOMMContactAsync(OMMContactSetParams parms)
        {
            log.Info("SetOMMContactAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.OmmContactSetAsync(
                    parms.langId,
                    parms.OutbreakCaseContactUID,
                    parms.OutbreakCaseReportUID,
                    parms.ContactRelationshipTypeID,
                    parms.DateOfLastContact,
                    parms.contactLocationidfsCountry,
                    parms.contactLocationidfsRegion,
                    parms.contactLocationidfsRayon,
                    parms.contactLocationidfsSettlement,
                    parms.strStreetName,
                    parms.strPostCode,
                    parms.strBuilding,
                    parms.strHouse,
                    parms.strApartment,
                    parms.strAddressString,
                    parms.phone,
                    parms.PlaceOfLastContact,
                    parms.CommentText,
                    parms.ContactStatusID,
                    parms.intRowStatus,
                    parms.AuditUser,
                    parms.AuditDTM,
                    0, //function call
                    parms.ContactTracingObservationID);

                if (result == null)
                {
                    log.Info("Exiting  SetOMMContactAsync With Not Found");
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
                log.Error("SQL Error in SetOMMContactAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in SetOMMContactAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  SetOMMContactAsync");
            return Ok(returnResult);
        }



        /// <summary>
        /// Obtains the Contact listing for a given Outbreak Case.
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
        [CacheHttpGetAttribute(0, 0, false)]
        [HttpPost, Route("OmmContactGetListAsync")]
        [ResponseType(typeof(List<OmmContactGetListModel>))]
        public async Task<IHttpActionResult> GetOmmContactListAsync(OmmContactGetListParams parms)
        {
            log.Info("GetOmmOutbreakContactListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                // Call the database.
                var result = await _repository.OmmContactGetListAsync(
                    parms.langId,
                    parms.OutbreakCaseReportUID,
                    parms.QuickSearch,
                    parms.FollowUp,
                    parms.paginationSet,
                    parms.pageSize,
                    parms.maxPagesPerFetch
                );
                if (result == null)
                {
                    log.Info("Exiting  GetOmmOutbreakContactListAsync With Not Found");
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
                log.Error("SQL Error in GetOmmOutbreakContactListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetOmmOutbreakContactListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetOmmOutbreakContactListAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Obtains the details pertaining to one Outbreak Session.
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
        [CacheHttpGetAttribute(0, 0, false)]
        [HttpPost, Route("OmmContactGetDetailAsync")]
        [ResponseType(typeof(List<OmmContactGetDetailModel>))]
        public async Task<IHttpActionResult> GetOmmContactGetDetailAsync(OmmContactGetDetailParams parms)
        {
            log.Info("GetOmmSessionGetDetailAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                // Call the database.
                var result = await _repository.OmmContactGetDetailAsync(
                    parms.langId,
                    parms.OutbreakCaseContactUID
                );
                if (result == null)
                {
                    log.Info("Exiting  GetOmmContactGetDetailAsync With Not Found");
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
                log.Error("SQL Error in GetOmmContactGetDetailAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetOmmContactGetDetailAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetOmmContactGetDetailAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Obtains the details pertaining to one Outbreak Case.
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
        [CacheHttpGetAttribute(0, 0, false)]
        [HttpPost, Route("OmmCaseGetDetailAsync")]
        [ResponseType(typeof(List<OmmCaseGetDetailModel>))]
        public async Task<IHttpActionResult> GetOmmCaseGetDetailAsync(OmmCaseGetDetailParams parms)
        {
            log.Info("GetOmmCaseGetDetailAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                // Call the database.
                var result = await _repository.OmmCaseGetDetailAsync(
                    parms.langId,
                    parms.OutbreakCaseReportUID
                );
                if (result == null)
                {
                    log.Info("Exiting  GetOmmCaseGetDetailAsync With Not Found");
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
                log.Error("SQL Error in GetOmmCaseGetDetailAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetOmmCaseGetDetailAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetOmmCaseGetDetailAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Obtains the details pertaining to one Outbreak Case.
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
        [CacheHttpGetAttribute(0, 0, false)]
        [HttpPost, Route("OmmVetCaseGetDetailAsync")]
        [ResponseType(typeof(List<OmmVetCaseGetDetailModel>))]
        public async Task<IHttpActionResult> GetOmmVetCaseGetDetailAsync(OmmCaseGetDetailParams parms)
        {
            log.Info("GetOmmVetCaseGetDetailAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
            
                   // Call the database.
                   var result = await _repository.OmmVetCaseGetDetailAsync(
                    parms.langId,
                    parms.OutbreakCaseReportUID
                );

                if (result == null)
                {
                    log.Info("Exiting  GetOmmVetCaseGetDetailAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = result.FirstOrDefault().Results;
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in GetOmmVetCaseGetDetailAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetOmmVetCaseGetDetailAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetOmmVetCaseGetDetailAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Obtains the details pertaining to the summary of one Outbreak Case.
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
        [CacheHttpGetAttribute(0, 0, false)]
        [HttpPost, Route("OmmCaseSummaryGetDetailAsync")]
        [ResponseType(typeof(List<OmmCaseSummaryGetDetailModel>))]
        public async Task<IHttpActionResult> GetOmmCaseSummaryGetDetailAsync(OmmCaseSummaryGetDetailParams parms)
        {
            log.Info("GetOmmCaseSummaryGetDetailAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                // Call the database.
                var result = await _repository.OmmCaseSummaryGetDetailAsync(
                    parms.langId,
                    parms.idfHumanActual,
                    parms.idfFarmActual
                );
                if (result == null)
                {
                    log.Info("Exiting  GetOmmCaseSummaryGetDetailAsync With Not Found");
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
                log.Error("SQL Error in GetOmmCaseSummaryGetDetailAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetOmmCaseSummaryGetDetailAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetOmmCaseSummaryGetDetailAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Obtains the Contact listing for a given Outbreak Case.
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
        [CacheHttpGetAttribute(0, 0, false)]
        [HttpPost, Route("OmmHerdGetListAsync")]
        [ResponseType(typeof(List<OmmHerdGetListModel>))]
        public async Task<IHttpActionResult> GetListOmmHerdAsync(OmmHerdSpeciesGetListParams parms)
        {
            log.Info("GetListOmmHerdAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                // Call the database.
                var result = await _repository.OmmHerdGetListAsync(
                    parms.langId,
                    parms.idfFarmActual
                );
                if (result == null)
                {
                    log.Info("Exiting  GetListOmmHerdAsync With Not Found");
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
                log.Error("SQL Error in GetListOmmHerdAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetListOmmHerdAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetListOmmHerdAsync");
            return Ok(returnResult);
        }

        // <summary>
        /// Obtains the Contact listing for a given Outbreak Case.
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
        [CacheHttpGetAttribute(0, 0, false)]
        [HttpPost, Route("OmmSpeciesGetListAsync")]
        [ResponseType(typeof(List<OmmSpeciesGetListModel>))]
        public async Task<IHttpActionResult> GetListOmmSpeciesAsync(OmmHerdSpeciesGetListParams parms)
        {
            log.Info("GetListOmmSpeciesAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                // Call the database.
                var result = await _repository.OmmSpeciesGetListAsync(
                    parms.langId,
                    parms.idfFarmActual
                );
                if (result == null)
                {
                    log.Info("Exiting  GetListOmmSpeciesAsync With Not Found");
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
                log.Error("SQL Error in GetListOmmSpeciesAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetListOmmSpeciesAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetListOmmSpeciesAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Inserts a new or updates an existing outbreak session
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
        [HttpPost, Route("OmmHerdSpeciesSetAsync")]
        [ResponseType(typeof(List<OmmHerdSpeciesSetModel>))]
        public async Task<IHttpActionResult> SetOmmHerdSpeciesAsync(OmmHerdSpeciesSetParams parms)
        {
            log.Info("SetOmmHerdSpeciesAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                //Descepancy between VB and C# value passing
                //Must reset date fields to to null, if using default value of DateTime.MinValue

                var result = await this._repository.OmmHerdSpeciesSetAsync(
                    parms.langId,
                    parms.idfFarmActual,
                    JsonConvert.SerializeObject(parms.Herds),
                    JsonConvert.SerializeObject(parms.Species)
                );

                if (result == null)
                {
                    log.Info("Exiting  SetOmmHerdSpeciesAsync With Not Found");
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
                log.Error("SQL Error in SetOmmHerdSpeciesAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in SetOmmHerdSpeciesAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  SetOmmHerdSpeciesAsync");
            return Ok(returnResult);
        }

        #region Veterinary

        /// <summary>
        /// Inserts a new or Veterinary Disease
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
        [HttpPost, Route("OmmVeterinaryDiseaseSetAsync")]
        [ResponseType(typeof(List<OmmVeterinaryDiseaseSetModel>))]
        public async Task<IHttpActionResult> OmmVeterinaryDiseaseSetAsync(OmmVeterinaryDiseaseSetParams parms)
        {
            log.Info("OmmVeterinaryDiseaseSetAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                //Descepancy between VB and C# value passing
                //Must reset date fields to to null, if using default value of DateTime.MinValue

                var result = await this._repository.OmmVeterinaryDiseaseSetAsync(
                     parms.languageId,
                     parms.veterinaryDiseaseReportId,
                     parms.farmId,
                     parms.farmMasterId,
                     parms.farmOwnerId,
                     parms.diseaseId,
                     parms.personEnteredById,
                     parms.personReportedById,
                     parms.personInvestigatedById,
                     parms.siteId,
                     parms.reportDate,
                     parms.assignedDate,
                     parms.investigationDate,
                     parms.eidssFieldAccessionId,
                     parms.rowStatus,
                     parms.reportedByOrganizationId,
                     parms.investigatedByOrganizationId,
                     parms.reportTypeId,
                     parms.classificationTypeId,
                     parms.outbreakId,
                     parms.enteredDate,
                     parms.eidssReportId,
                     parms.statusTypeId,
                     parms.monitoringSessionId,
                     parms.reportCategoryTypeId,
                     parms.farmTotalAnimalQuantity,
                     parms.farmSickAnimalQuantity,
                     parms.farmDeadAnimalQuantity,
                     parms.originalVeterinaryDiseaseReportId,
                     parms.farmEpidemiologicalObservationId,
                     parms.controlMeasuresObservationId,
                     JsonConvert.SerializeObject(parms.herdsOrFlocks),
                     JsonConvert.SerializeObject(parms.species),
                     JsonConvert.SerializeObject(parms.clinicalInformation),
                     JsonConvert.SerializeObject(parms.animalInvestigations),
                     JsonConvert.SerializeObject(parms.contacts),
                     JsonConvert.SerializeObject(parms.vaccinations),
                     JsonConvert.SerializeObject(parms.samples),
                     JsonConvert.SerializeObject(parms.pensideTests),
                     JsonConvert.SerializeObject(parms.tests),
                     JsonConvert.SerializeObject(parms.testInterpretations),
                     JsonConvert.SerializeObject(parms.reportLogs),
                     parms.idfReportedByOffice,
                     parms.idfPersonReportedBy,
                     parms.idfReceivedByOffice,
                     parms.idfReceivedByPerson,
                     parms.isPrimaryCaseFlag,
                     parms.outbreakCaseStatusId,
                     parms.outbreakCaseClassificationID, 
                     parms.idfsCountry,
                     parms.idfsRegion,
                     parms.idfsRayon,
                     parms.idfsSettlementType,
                     parms.idfsSettlement,
                     parms.strStreetName,
                     parms.strHouse,
                     parms.strBuilding, 
                     parms.strApartment,
                     parms.strPostCode,
                     parms.dblLatitude, 
                     parms.dblLongitude,
                     parms.caseMonitoring);

                if (result == null)
                {
                    log.Info("Exiting  OmmVeterinaryDiseaseSetAsync With Not Found");
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
                log.Error("SQL Error in OmmVeterinaryDiseaseSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in OmmVeterinaryDiseaseSetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  OmmVeterinaryDiseaseSetAsync");
            return Ok(returnResult);
        }

        #endregion
    }
}