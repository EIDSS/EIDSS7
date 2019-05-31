using Newtonsoft.Json;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Extensions;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using WebApi.OutputCache.V2;
using System.Data.SqlClient;
using OpenEIDSS.Extensions.Attributes;
using System.Net;
using OpenEIDSS.Domain.Return_Contracts;
using OpenEIDSS.Abstracts;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// Controller Responsible for the functionality of Human Disease
    /// </summary>
    /// 
    [RoutePrefix("api/Human")]
    public class HumanDiseaseController : APIControllerBase
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(HumanDiseaseController));

        /// <summary>
        /// 
        /// </summary>
        public HumanDiseaseController()
        {
        }

        /// <summary>
        /// Gets a list of human disease reports based on user provided filter criteria.
        /// </summary>
        /// <param name="parameters">Collection of filter parameters to filter the human disease report list results.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 

        [HttpPost, Route("HumanDiseaseReportGetListAsync")]
        [ResponseType(typeof(List<HumDiseaseReportGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetHumanDiseaseReportListAsync([FromBody] HumanDiseaseReportGetListParams parameters)
        {
            log.Info("GetHumanDiseaseReportListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                var result = await _repository.HumDiseaseReportGetListAsync(
                    parameters.LanguageID,
                    parameters.HumanDiseaseReportID,
                    parameters.LegacyHumanDiseaseReportID,
                    parameters.PatientID,
                    parameters.EIDSSPersonID,
                    parameters.DiseaseID,
                    parameters.ReportStatusTypeID,
                    parameters.RegionID,
                    parameters.RayonID,
                    parameters.HumanDiseaseReportDateEnteredFrom,
                    parameters.HumanDiseaseReportDateEnteredTo,
                    parameters.ClassificationTypeID,
                    parameters.HospitalizationStatusTypeID,
                    parameters.EIDSSReportID,
                    parameters.PatientFirstOrGivenName,
                    parameters.PatientMiddleName,
                    parameters.PatientLastOrSurname,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);
                if (result == null)
                {
                    log.Info("Exiting  GetHumanDiseaseReportListAsync With Not Found");
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
                log.Error("SQL Error in GetHumanDiseaseReportListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetHumanDiseaseReportListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetHumanDiseaseReportListAsync");
            return Ok(returnResult);
        }




        /// <summary>
        /// Advanced Search Gets a list of human disease reports based on user provided filter criteria.
        /// </summary>
        /// <param name="parameters">Collection of filter parameters to filter the human disease report list results.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 

        [HttpPost, Route("GetHumanDiseaseAdvanceSearchReport")]
        [ResponseType(typeof(List<HumDiseaseAdvanceSearchReportGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetHumanDiseaseAdvanceReportListAsync([FromBody] HumanDiseaseAdvanceSearchParams parameters)
        {
            log.Info("GetHumanDiseaseAdvanceReportListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                var result = await _repository.HumDiseaseAdvanceSearchReportGetListAsync(
                    parameters.languageId,
                    parameters.humanDiseaseReportId,
                    parameters.legacyId,
                    parameters.patientId,
                    parameters.eidssPersonId,
                    parameters.diseaseId,
                    parameters.reportStatusTypeId,
                    parameters.regionId,
                    parameters.rayonId,
                    parameters.dateEnteredFrom,
                    parameters.dateEnteredTo,
                    parameters.classificationTypeId,
                    parameters.hospitalizationStatusTypeId,
                    parameters.eidssReportId,
                    parameters.patientFirstOrGivenName,
                    parameters.patientMiddleName,
                    parameters.patientLastOrSurname,
                    parameters.paginationSet,
                    parameters.pageSize,
                    parameters.maxPagesPerFetch,
                    parameters.sentByFacility,
                    parameters.receivedByFacility,
                    parameters.diagnosisDateFrom,
                    parameters.diagnosisDatTo,
                    parameters.localSampleId,
                    parameters.dataEntrySite,
                    parameters.dateOfSymptomsOnset,
                    parameters.notificationDate,
                    parameters.dateOfFinalCaseClassification,
                    parameters.locationOfExposureRegion,
                    parameters.locationOfExposureRayon
                    );
                if (result == null)
                {
                    log.Info("Exiting  GetHumanDiseaseAdvanceReportListAsync With Not Found");
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
                log.Error("SQL Error in GetHumanDiseaseAdvanceReportListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetHumanDiseaseAdvanceReportListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetHumanDiseaseAdvanceReportListAsync");
            return Ok(returnResult);
        }





        /// <summary>
        /// Gets a count of human disease reports based on user provided filter criteria.
        /// </summary>
        /// <param name="parameters">Collection of filter parameters to filter the human disease report list results.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpPost, Route("HumanDiseaseReportGetListCountAsync")]
        [ResponseType(typeof(List<HumDiseaseReportGetCountModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetHumanDiseaseReportListCountAsync([FromBody] HumanDiseaseReportGetListParams parameters)
        {
            log.Info("GetHumanDiseaseReportListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.HumDiseaseReportGetCountAsync(
                    parameters.LanguageID,
                    parameters.HumanDiseaseReportID,
                    parameters.LegacyHumanDiseaseReportID,
                    parameters.PatientID,
                    parameters.EIDSSPersonID,
                    parameters.DiseaseID,
                    parameters.ReportStatusTypeID,
                    parameters.RegionID,
                    parameters.RayonID,
                    parameters.HumanDiseaseReportDateEnteredFrom,
                    parameters.HumanDiseaseReportDateEnteredTo,
                    parameters.ClassificationTypeID,
                    parameters.HospitalizationStatusTypeID,
                    parameters.EIDSSReportID,
                    parameters.PatientFirstOrGivenName,
                    parameters.PatientMiddleName,
                    parameters.PatientLastOrSurname);
                if (result == null)
                {
                    log.Info("Exiting  GetHumanDiseaseReportListCountAsync With Not Found");
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
                log.Error("SQL Error in GetHumanDiseaseReportListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetHumanDiseaseReportListCountAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetHumanDiseaseReportListCountAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Gets a list of Human diseases
        /// </summary>
        /// <param name="humanDiseaseGelListParams">
        /// Json request parameter
        /// </param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpPost, Route("GetHumanDiseaseList")]
        [CacheHttpGetAttribute(0, 0, false)]
        [ResponseType(typeof(List<HumDiseaseGetListModel>))]
        public async Task<IHttpActionResult> GetHumanDiseaseList([FromBody] HumanDiseaseGetListParams humanDiseaseGelListParams)
        {
            log.Info("Entering GetDiseaseList");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.HumDiseaseGetListAsync(
                    humanDiseaseGelListParams.LangID,
                    humanDiseaseGelListParams.SearchHumanCaseId,
                    humanDiseaseGelListParams.SearchLegacyCaseID,
                    humanDiseaseGelListParams.SearchPatientId,
                    humanDiseaseGelListParams.SearchPersonEIDSSId,
                    humanDiseaseGelListParams.SearchDiagnosis,
                    humanDiseaseGelListParams.SearchReportStatus,
                    humanDiseaseGelListParams.SearchRegion,
                    humanDiseaseGelListParams.SearchRayon,
                    humanDiseaseGelListParams.SearchHDRDateEnteredFrom,
                    humanDiseaseGelListParams.SearchHDRDateEnteredTo,
                    humanDiseaseGelListParams.SearchCaseClassification,
                    humanDiseaseGelListParams.SearchDiagnosisDateFrom,
                    humanDiseaseGelListParams.SearchDiagnosisDateTo,
                    humanDiseaseGelListParams.SearchIdfsHospitalizationStatus,
                    humanDiseaseGelListParams.SearchLegacyCaseID,
                    humanDiseaseGelListParams.SearchStrPersonFirstName,
                    humanDiseaseGelListParams.SearchStrPersonMiddleName,
                    humanDiseaseGelListParams.SearchStrPersonLastName
                    );
                if (result == null)
                {
                    log.Info("Exiting  GetHumanDiseaseList With Not Found");
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
                log.Error("SQL Error in GetHumanDiseaseList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetHumanDiseaseList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetHumanDiseaseList");
            return Ok(returnResult);
        }



        /// <summary>
        /// Creates a Human Disease Record
        /// </summary>
        /// <param name="humanDiseaseSetParams">
        /// 
        /// Json Request Parameter
        /// </param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpPost, Route("SetHumanDisease")]
        [ResponseType(typeof(List<HumHumanDiseaseSetModel>))]
        public async Task<IHttpActionResult> HumanDiseaseSet([FromBody] HumanDiseaseSetParams humanDiseaseSetParams)
        {
            log.Info("Entering HumanDiseaseSet");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
               
                var result = await _repository.HumHumanDiseaseSetAsync(
                    humanDiseaseSetParams.idfHumanCase,
                    humanDiseaseSetParams.idfHumanCaseRelatedTo,
                    humanDiseaseSetParams.idfHuman,
                    humanDiseaseSetParams.idfHumanActual,
                    humanDiseaseSetParams.strHumanCaseId,
                    humanDiseaseSetParams.idfsFinalDiagnosis,
                    humanDiseaseSetParams.datDateOfDiagnosis,
                    humanDiseaseSetParams.datNotificationDate,
                    humanDiseaseSetParams.idfsFinalState,
                    humanDiseaseSetParams.idfSentByOffice,
                    humanDiseaseSetParams.strSentByFirstName,
                    humanDiseaseSetParams.strSentByPatronymicName,
                    humanDiseaseSetParams.strSentByLastName,
                    humanDiseaseSetParams.idfSentByPerson,
                    humanDiseaseSetParams.idfReceivedByOffice,
                    humanDiseaseSetParams.strReceivedByFirstName,
                    humanDiseaseSetParams.strReceivedByPatronymicName,
                    humanDiseaseSetParams.strReceivedByLastName,
                    humanDiseaseSetParams.idfReceivedByPerson,
                    humanDiseaseSetParams.idfsHospitalizationStatus,
                    humanDiseaseSetParams.idfHospital,
                    humanDiseaseSetParams.strCurrentLocation,
                    humanDiseaseSetParams.datOnSetDate,
                    humanDiseaseSetParams.idfsInitialCaseStatus,
                    humanDiseaseSetParams.idfsYNPreviouslySoughtCare,
                    humanDiseaseSetParams.datFirstSoughtCareDate,
                    humanDiseaseSetParams.idfSougtCareFacility,
                    humanDiseaseSetParams.idfsNonNotIFiableDiagnosis,
                    humanDiseaseSetParams.idfsYNHospitalization,
                    humanDiseaseSetParams.datHospitalizationDate,
                    humanDiseaseSetParams.datDischargeDate,
                    humanDiseaseSetParams.strHospitalName,
                    humanDiseaseSetParams.idfsYNAntimicrobialTherapy,
                    humanDiseaseSetParams.strAntibioticName,
                    humanDiseaseSetParams.strDosage,
                    humanDiseaseSetParams.datFirstAdministeredDate,
                    humanDiseaseSetParams.strAntibioticComments,
                    humanDiseaseSetParams.idfsYNSpecIFicVaccinationAdministered,
                    humanDiseaseSetParams.idfInvestigatedByOffice,
                    humanDiseaseSetParams.startDateOfInvestigation,
                    humanDiseaseSetParams.idfsYNRelatedToOutbreak,
                    humanDiseaseSetParams.idfOutbreak,
                    humanDiseaseSetParams.idfsYNExposureLocationKnown,
                    humanDiseaseSetParams.idfPointGeoLocation,
                    humanDiseaseSetParams.datExposureDate,
                    humanDiseaseSetParams.strLocationDescription,
                    humanDiseaseSetParams.idfsLocationCountry,
                    humanDiseaseSetParams.idfsLocationRegion,
                    humanDiseaseSetParams.idfsLocationRayon,
                    humanDiseaseSetParams.idfsLocationSettlement,
                    humanDiseaseSetParams.intLocationLatitude,
                    humanDiseaseSetParams.intLocationLongitude,
                    humanDiseaseSetParams.idfsLocationGroundType,
                    humanDiseaseSetParams.intLocationDistance,
                    humanDiseaseSetParams.idfsFinalCaseStatus,
                    humanDiseaseSetParams.idfsOutcome,
                    humanDiseaseSetParams.datDateofDeath,
                    humanDiseaseSetParams.idfsCaseProgressStatus,
                    humanDiseaseSetParams.idfPersonEnteredBy,
                    humanDiseaseSetParams.strClinicalNotes,
                    humanDiseaseSetParams.idfsYNSpecimenCollected,
                    humanDiseaseSetParams.DiseaseReportTypeID,
                    humanDiseaseSetParams.blnClinicalDiagBasis,
                    humanDiseaseSetParams.blnLabDiagBasis,
                    humanDiseaseSetParams.blnEpiDiagBasis,
                    humanDiseaseSetParams.dateofClassification,
                    humanDiseaseSetParams.strSummaryNotes,
                    humanDiseaseSetParams.idfEpiObservation, 
                    humanDiseaseSetParams.idfCSObservation,
                    JsonConvert.SerializeObject(humanDiseaseSetParams.SamplesParameters),
                    JsonConvert.SerializeObject(humanDiseaseSetParams.TestsParameters),
                    JsonConvert.SerializeObject(humanDiseaseSetParams.AntiviralTherapiesParameters),
                    JsonConvert.SerializeObject(humanDiseaseSetParams.VaccinationsParameters),
                    JsonConvert.SerializeObject(humanDiseaseSetParams.ContactsParameters)
                          );

                if (result == null)
                {
                    log.Info("Exiting  HumanDiseaseSet With Not Found");
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
                log.Error("SQL Error in HumanDiseaseSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumanDiseaseSet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  HumanDiseaseSet");
            return Ok(returnResult);

        }



        /// <summary>
        /// Gets Details of A Human Disease
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfHumanActual"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpGet, Route("GetHumanDetail")]
        [ResponseType(typeof(List<HumHumanGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetHumanDetail(string languageId, long? idfHumanActual)
        {
            log.Info("Entering GetHumanDetail");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.HumHumanGetDetailAsync(languageId, idfHumanActual);
                if (result == null)
                {
                    log.Info("Exiting  GetHumanDetail With Not Found");
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
                log.Error("SQL Error in GetHumanDetail Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetHumanDetail" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetHumanDetail");
            return Ok(returnResult);
        }


        /// <summary>
        /// Returns a List of Human Disease Antiviral therapies
        /// </summary>
        /// <param name="idfHumanCase">Human Case Id</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns></returns>
        [HttpGet, Route("HumDiseaseAntiviraltherapiesGetListAsync")]
        [ResponseType(typeof(List<HumDiseaseAntiviraltherapiesGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> HumDiseaseAntiviraltherapiesGetListAsync(long idfHumanCase, string languageId)
        {
            log.Info("Entering HumDiseaseAntiviraltherapiesGetListAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.HumDiseaseAntiviraltherapiesGetListAsync(idfHumanCase, languageId);
                if (result == null)
                {
                    log.Info("Exiting  HumDiseaseAntiviraltherapiesGetListAsync With Not Found");
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
                log.Error("SQL Error in HumDiseaseAntiviraltherapiesGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumDiseaseAntiviraltherapiesGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  HumDiseaseAntiviraltherapiesGetListAsync");
            return Ok(returnResult);
        }
        /// <summary>
        /// Returns a List of Human Disease Antiviral therapies
        /// </summary>
        /// <param name="idfHumanCase">Human Case Id</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpGet, Route("HumDiseaseAntiviraltherapiesGetList")]
        [ResponseType(typeof(List<HumDiseaseAntiviraltherapiesGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> HumDiseaseAntiviraltherapiesGetList(long idfHumanCase, string languageId)
        {
            log.Info("Entering HumDiseaseAntiviraltherapiesGetListAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await  _repository.HumDiseaseAntiviraltherapiesGetListAsync(idfHumanCase, languageId);
                if (result == null)
                {
                    log.Info("Exiting  HumDiseaseAntiviraltherapiesGetList With Not Found");
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
                log.Error("SQL Error in HumDiseaseAntiviraltherapiesGetList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumDiseaseAntiviraltherapiesGetList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  HumDiseaseAntiviraltherapiesGetList");
            return Ok(returnResult);
        }


        /// <summary>
        /// Returns a List of Human Disease Antiviral therapies
        /// </summary>
        /// <param name="humanDiseaseAntViralTherapySetParmas">Human Case Id</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpPost, Route("HumDiseaseAntiviraltherapiesSet")]
        [ResponseType(typeof(List<HumDiseaseAntiviraltherapiesGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> HumDiseaseAntiviraltherapiesSet(HumanDiseaseAntViralTherapySetParmas humanDiseaseAntViralTherapySetParmas)
        {
            log.Info("Entering HumDiseaseAntiviraltherapiesGetListAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.HumDiseaseAntiviraltherapySetAsync(
                  
                    humanDiseaseAntViralTherapySetParmas.idfAntimicrobialTherapy,
                    humanDiseaseAntViralTherapySetParmas.idfHumanCase,
                    humanDiseaseAntViralTherapySetParmas.datFirstAdministeredDate,
                    humanDiseaseAntViralTherapySetParmas.strAntimicrobialTherapyName,
                    humanDiseaseAntViralTherapySetParmas.strDosage
                    );
                if (result == null)
                {
                    log.Info("Exiting  HumDiseaseAntiviraltherapiesGetList With Not Found");
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
                log.Error("SQL Error in HumDiseaseAntiviraltherapiesGetList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumDiseaseAntiviraltherapiesGetList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  HumDiseaseAntiviraltherapiesGetList");
            return Ok(returnResult);
        }















        /// <summary>
        /// Retuns a list Human Disease Vaccinations
        /// </summary>
        /// <param name="idfHumanCase">Human Case Id</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpGet, Route("HumDiseaseVaccinationsGetList")]
        [ResponseType(typeof(List<HumDiseaseVaccinationsGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> HumDiseaseVaccinationsGetList(long idfHumanCase, string languageId)
        {
            log.Info("Entering HumDiseaseVaccinationsGetList");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.HumDiseaseVaccinationsGetListAsync(idfHumanCase, languageId);
                if (result == null)
                {
                    log.Info("Exiting  HumDiseaseVaccinationsGetList With Not Found");
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
                log.Error("SQL Error in HumDiseaseVaccinationsGetList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumDiseaseVaccinationsGetList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  HumDiseaseVaccinationsGetList");
            return Ok(returnResult);
        }


        /// <summary>
        /// Retuns a list Human Disease Vaccinations
        /// </summary>
        /// <param name="idfHumanCase">Human Case Id</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpGet, Route("HumDiseaseVaccinationsGetListAsync")]
        [ResponseType(typeof(List<HumDiseaseVaccinationsGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> HumDiseaseVaccinationsGetListAsync(long idfHumanCase, string languageId)
        {
            log.Info("Entering HumDiseaseVaccinationsGetList");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.HumDiseaseVaccinationsGetListAsync(idfHumanCase, languageId);
                if (result == null)
                {
                    log.Info("Exiting  HumDiseaseVaccinationsGetListAsync With Not Found");
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
                log.Error("SQL Error in HumDiseaseVaccinationsGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumDiseaseVaccinationsGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  HumDiseaseVaccinationsGetListAsync");
            return Ok(returnResult);
        }



        /// <summary>
        /// Retuns a list Human Disease Vaccinations
        /// </summary>
        /// <param name="humanDiseaseVaccinationSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpPost, Route("HumHumanDiseaseVaccinationSet")]
        [ResponseType(typeof(List<HumHumanDiseaseVaccinationSetModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> HumHumanDiseaseVaccinationSet(HumanDiseaseVaccinationSetParams humanDiseaseVaccinationSetParams)
        {
            log.Info("Entering HumDiseaseVaccinationsGetList");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.HumHumanDiseaseVaccinationSetAsync(
                    humanDiseaseVaccinationSetParams.humanDiseaseReportVaccinationUid,
                    humanDiseaseVaccinationSetParams.idfHumanCase,
                    humanDiseaseVaccinationSetParams.vaccinationName,
                    humanDiseaseVaccinationSetParams.vaccinationDate
                    );
                if (result == null)
                {
                    log.Info("Exiting  HumDiseaseVaccinationsGetListAsync With Not Found");
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
                log.Error("SQL Error in HumDiseaseVaccinationsGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumDiseaseVaccinationsGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  HumDiseaseVaccinationsGetListAsync");
            return Ok(returnResult);
        }




        /// <summary>
        /// Retuns a list Human Disease Vaccinations
        /// </summary>
        /// <param name="humanDiseaseContactsSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpGet, Route("HumDiseaseContactsSetAsync")]
        [ResponseType(typeof(List<HumDiseaseContactsSetModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> HumDiseaseContactsSetAsync(HumanDiseaseContactsSetParams humanDiseaseContactsSetParams)
        {
            log.Info("Entering HumDiseaseContactsSetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.HumDiseaseContactsSetAsync(
                    humanDiseaseContactsSetParams.idfContactedCasePerson,
                    humanDiseaseContactsSetParams.idfsPersonContactType,
                    humanDiseaseContactsSetParams.idfHuman,
                    humanDiseaseContactsSetParams.idfHumanCase,
                    humanDiseaseContactsSetParams.datDateOfLastContact,
                    humanDiseaseContactsSetParams.strPlaceInfo,
                    humanDiseaseContactsSetParams.intRowStatus,
                    humanDiseaseContactsSetParams.rowguid,
                    humanDiseaseContactsSetParams.strComments,
                    humanDiseaseContactsSetParams.strMaintenanceFlag,
                    humanDiseaseContactsSetParams.strReservedAttribute
                    );
                if (result == null)
                {
                    log.Info("Exiting  HumDiseaseContactsSetAsync With Not Found");
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
                log.Error("SQL Error in HumDiseaseContactsSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in HumDiseaseContactsSetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  HumDiseaseContactsSetAsync");
            return Ok(returnResult);
        }






        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="searchHumanCaseId"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpGet, Route("GetHumanDiseaseDetail")]
        [ResponseType(typeof(List<HumDiseaseGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetHumanDiseaseDetail(string languageId, long? searchHumanCaseId)
        {
            log.Info("Entering GetHumanDiseaseDetail");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.HumDiseaseGetDetailAsync(languageId, searchHumanCaseId);
                if (result == null)
                {
                    log.Info("Exiting  GetHumanDiseaseDetail With Not Found");
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
                log.Error("SQL Error in GetHumanDiseaseDetail Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetHumanDiseaseDetail" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetHumanDiseaseDetail");
            return Ok(returnResult);
        }


        /// <summary>
        /// Deletes a Human Disease
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfHumanCase"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpDelete, Route("DeleteHumanDisease")]
        [ResponseType(typeof(List<HumHumanDiseaseDelModel>))]
        public IHttpActionResult DeleteHumanDisease(string languageId, long? idfHumanCase)
        {
            log.Info("Entering DeleteHumanDisease");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
              
                var result = _repository.HumHumanDiseaseDel(languageId,  idfHumanCase);
                if (result == null)
                {
                    log.Info("Exiting  DeleteHumanDisease With Not Found");
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
                log.Error("SQL Error in DeleteHumanDisease Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in DeleteHumanDisease" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  DeleteHumanDisease");
            return Ok(returnResult);
        }


        /// <summary>
        /// Returns Human Samples
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfHumanCase"></param>
        /// <param name="searchDiagnosis"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpGet, Route("GetHumanSamples")]
        [ResponseType(typeof(List<HumSamplesGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetHumanSamplesList(string languageId, long? idfHumanCase, long? searchDiagnosis)
        {
            log.Info("Entering GetHumanSamples");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.HumSamplesGetListAsync(languageId, idfHumanCase, searchDiagnosis);
                if (result == null)
                {
                    log.Info("Exiting  GetHumanSamplesList With Not Found");
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
                log.Error("SQL Error in GetHumanSamplesList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetHumanSamplesList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetHumanSamplesList");
            return Ok(returnResult);
        }




        /// <summary>
        /// Returns human Disease contact list
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfHumanCase"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpGet, Route("GetHumanDiseaseContacts")]
        [ResponseType(typeof(List<HumDiseaseContactsGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetHumanDiseaseContacts(string languageId, long? idfHumanCase)
        {
            log.Info("Entering GetHumanDiseaseContacts");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.HumDiseaseContactsGetListAsync(idfHumanCase, languageId);
                if (result == null)
                {
                    log.Info("Exiting  GetHumanDiseaseContacts With Not Found");
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
                log.Error("SQL Error in GetHumanDiseaseContacts Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetHumanDiseaseContacts" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetHumanDiseaseContacts");
            return Ok(returnResult);
        }



        /// <summary>
        /// Saves a Human disease Contact
        /// </summary>
        /// <param name="setContactParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("SetHumanDiseaseContacts")]
        [ResponseType(typeof(List<HumDiseaseContactsSetModel>))]
        public  IHttpActionResult SetHumanDiseaseContacts([FromBody] HumanDiseaseSetContactParams  setContactParams)
        {
            log.Info("Entering SetHumanDiseaseContacts");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = _repository.HumDiseaseContactsSet(
                    setContactParams.idfContactedCasePerson, 
                    setContactParams.idfsPersonContactType, 
                    setContactParams.idfHuman, 
                    setContactParams.idfHumanCase, 
                    setContactParams.datDateOfLastContact, 
                    setContactParams.strPlaceInfo, 
                    setContactParams.intRowStatus, 
                    setContactParams.rowguid, 
                    setContactParams.strComments, 
                    setContactParams.strMaintenanceFlag, 
                    setContactParams.strReservedAttribute
                    );

                if (result == null)
                {
                    log.Info("Exiting  SetHumanDiseaseContacts With Not Found");
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
                log.Error("SQL Error in SetHumanDiseaseContacts Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in SetHumanDiseaseContacts" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  SetHumanDiseaseContacts");
            return Ok(returnResult);
        }


        /// <summary>
        /// Returns a List of Human Tests
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfHumanCase"></param>
        /// <param name="searchDiagnosis"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetHumanDiseaseTest")]
        [ResponseType(typeof(List<HumTestsGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetHumanDiseaseTests(string languageId, long? idfHumanCase,long? searchDiagnosis)
        {
            log.Info("Entering GetHumanDiseaseTest");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.HumTestsGetListAsync(languageId, idfHumanCase, searchDiagnosis);
                if (result == null)
                {
                    log.Info("Exiting  GetHumanDiseaseTests With Not Found");
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
                log.Error("SQL Error in GetHumanDiseaseTests Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetHumanDiseaseTests" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetHumanDiseaseTests");
            return Ok(returnResult);
        }




        #region Penside



        //USP_CONF_DISEASEPENSIDETESTMATRIX_SET



        /// <summary>
        /// Creates Penside Matrix
        /// </summary>
        /// <param name="confDiseasePendisideSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("ConfDiseasepensidetestmatrixSetAsync")]
        [ResponseType(typeof(List<ConfDiseasepensidetestmatrixSetModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> ConfDiseasepensidetestmatrixSetAsync(ConfDiseasePendisideSetParams confDiseasePendisideSetParams)
        {
            log.Info("Entering ConfDiseasepensidetestmatrixSetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfDiseasepensidetestmatrixSetAsync(
                    confDiseasePendisideSetParams.idfPensideTestForDisease,
                    confDiseasePendisideSetParams.idfsDiagnosis,
                    confDiseasePendisideSetParams.idfsPensideTestName
                    );
                if (result == null)
                {
                    log.Info("Exiting  ConfDiseasepensidetestmatrixSetAsync With Not Found");
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
                log.Error("SQL Error in ConfDiseasepensidetestmatrixSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfDiseasepensidetestmatrixSetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfDiseasepensidetestmatrixSetAsync");
            return Ok(returnResult);
        }




        /// <summary>
        /// Returns a List of Penside Matrix
        /// </summary>
        /// <param name="languageid"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("ConfDiseasepensidetestmatrixGetListAsync")]
        [ResponseType(typeof(List<ConfDiseasepensidetestmatrixGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> ConfDiseasepensidetestmatrixGetListAsync(string languageid)
        {
            log.Info("Entering ConfDiseasepensidetestmatrixGetListModel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfDiseasepensidetestmatrixGetListAsync(languageid);
                if (result == null)
                {
                    log.Info("Exiting  ConfDiseasepensidetestmatrixGetListModel With Not Found");
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
                log.Error("SQL Error in ConfDiseasepensidetestmatrixGetListModel Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfDiseasepensidetestmatrixGetListModel" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfDiseasepensidetestmatrixGetListModel");
            return Ok(returnResult);
        }





        /// <summary>
        /// Deletes a Penside Matrix
        /// </summary>
        /// <param name="idfPensideTestForDisease"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("ConfDiseasepensidetestmatrixDelAsync")]
        [ResponseType(typeof(List<ConfDiseasepensidetestmatrixDelModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> ConfDiseasepensidetestmatrixDelAsync(long idfPensideTestForDisease)
        {
            log.Info("Entering ConfDiseasepensidetestmatrixDelAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfDiseasepensidetestmatrixDelAsync(idfPensideTestForDisease);
                if (result == null)
                {
                    log.Info("Exiting  ConfDiseasepensidetestmatrixDelAsync With Not Found");
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
                log.Error("SQL Error in ConfDiseasepensidetestmatrixDelAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfDiseasepensidetestmatrixDelAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfDiseasepensidetestmatrixDelAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Deletes a age group diagnosis
        /// /// </summary>
        /// <param name="idfDiagnosisAgeGroupToDiagnosis"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("ConfDiseaseagegroupmatrixDelAsync")]
        [ResponseType(typeof(List<ConfDiseaseagegroupmatrixDelModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> ConfDiseaseagegroupmatrixDelAsync(long idfDiagnosisAgeGroupToDiagnosis)
        {
            log.Info("Entering ConfDiseaseagegroupmatrixDelAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfDiseaseagegroupmatrixDelAsync(idfDiagnosisAgeGroupToDiagnosis);
                if (result == null)
                {
                    log.Info("Exiting  ConfDiseaseagegroupmatrixDelAsync With Not Found");
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
                log.Error("SQL Error in ConfDiseaseagegroupmatrixDelAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfDiseaseagegroupmatrixDelAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfDiseaseagegroupmatrixDelAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Saves a Disease Matrix Age Group
        /// /// </summary>
        /// <param name="confDiseaseagegroupmatrixSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("ConfDiseaseagegroupmatrixSetAsync")]
        [ResponseType(typeof(List<ConfDiseaseagegroupmatrixSetModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> ConfDiseaseagegroupmatrixSetAsync(ConfDiseaseagegroupmatrixSetParams confDiseaseagegroupmatrixSetParams)
        {
            log.Info("Entering ConfDiseaseagegroupmatrixSetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfDiseaseagegroupmatrixSetAsync(
                    confDiseaseagegroupmatrixSetParams.idfDiagnosisAgeGroupToDiagnosis,
                    confDiseaseagegroupmatrixSetParams.idfsDiagnosis,
                    confDiseaseagegroupmatrixSetParams.idfsDiagnosisAgeGroup

                    );
                if (result == null)
                {
                  
                    log.Info("Exiting  ConfDiseaseagegroupmatrixSetAsync With Not Found");
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
                log.Error("SQL Error in ConfDiseaseagegroupmatrixSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfDiseaseagegroupmatrixSetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfDiseaseagegroupmatrixSetAsync");
            return Ok(returnResult);
        }



        /// <summary>
        /// Returns an Age Group Matrix
        /// </summary>
        /// <param name="idfsDiagnosis"></param>
        /// <param name="languageId"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("ConfDiseaseagegroupmatrixGetlistAsync")]
        [ResponseType(typeof(List<ConfDiseaseagegroupmatrixGetlistModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> ConfDiseaseagegroupmatrixGetlistAsync(long idfsDiagnosis, string languageId)
        {
            log.Info("Entering ConfDiseaseagegroupmatrixGetlistAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.ConfDiseaseagegroupmatrixGetlistAsync(languageId, idfsDiagnosis);
                if (result == null)
                {

                    log.Info("Exiting  ConfDiseaseagegroupmatrixGetlistAsync With Not Found");
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
                log.Error("SQL Error in ConfDiseaseagegroupmatrixSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfDiseaseagegroupmatrixGetlistAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfDiseaseagegroupmatrixGetlistAsync");
            return Ok(returnResult);
        }
   


        #endregion
    }
}
