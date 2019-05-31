using OpenEIDSS.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using WebApi.OutputCache.V2;
using System.Collections;
using System.Collections.Generic;
using OpenEIDSS.Domain;
using System.Data.SqlClient;
using OpenEIDSS.Extensions.Attributes;
using Newtonsoft.Json;
using OpenEIDSS.Domain.Return_Contracts;
using OpenEIDSS.Domain.Parameter_Contracts;
using System.Web.Http.Cors;
using System;
using EIDSS.Client.API_Clients;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// Class provides functionality for Aggregate Settings CRUD Methods
    /// </summary>
    [RoutePrefix("api/Configuration")]
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class SystemConfigController : ApiController
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(SystemConfigController));
        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// Instantiates a new Instance Of Class -- Contructor 
        /// </summary>
        public SystemConfigController()
        {

        }

        /// <summary>
        /// Adds Aggregate Settings
        /// </summary>
        /// <param name="aggregateSettingsList"> List of AggregateSettingsModel.  Each save stores 1 or more settings </param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("AddAggSettings")]
        [ResponseType(typeof(ConfAggregateSettingSetModel))]
        public async Task<IHttpActionResult> AddAggregateSettingsAsync([FromBody] List<AggregateSettingsModel> aggregateSettingsList)
        {
            APIReturnResult returnResult = new APIReturnResult();
            log.Info("Entering  AddAggSettings Params:");
            try
            {
                List<ConfAggregateSettingSetModel> resultList = new List<ConfAggregateSettingSetModel>();
                foreach (var item in aggregateSettingsList)
                {
                    var res = await _repository.ConfAggregateSettingSetAsync(long.Parse(item.IdfsAggrCaseType), long.Parse(item.IdfCustomizationPackage), long.Parse(item.IdfsStatisticAreaType), long.Parse(item.IdfsStatisticPeriodType), string.Empty);
                    if (res == null)
                    {
                        returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                        returnResult.ErrorCode = HttpStatusCode.BadRequest;
                        break;
                    }
                    else if (res[0].ReturnMessage.ToUpper() != "SUCCESS")
                    {
                        returnResult.ErrorCode = HttpStatusCode.NoContent;
                        returnResult.ErrorMessage = res[0].ReturnMessage;
                        resultList.Add(new ConfAggregateSettingSetModel() { ReturnCode = 1, ReturnMessage = "FAILED" });

                    }
                    else
                    {
                        returnResult.ErrorCode = HttpStatusCode.OK;
                        resultList.Add(new ConfAggregateSettingSetModel() { ReturnCode = 0, ReturnMessage = "SUCCESS" });
                    }
                }
                returnResult.Results = JsonConvert.SerializeObject(resultList);
            }
            catch (SqlException ex)
            {
                log.Error("Error in AddAggSettings: Proc:" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;

            }
            catch (System.Exception ex)
            {
                log.Error("Error in AddAggSettings: " + ex.Message);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  AddAggSettings Params:");
            return Json(returnResult);
        }

        /// <summary>
        /// Returns a list of Aggregate settings based on Aggregate Case Type and CustomizationPackage
        /// </summary>
        /// <param name="idfCustomizationPackage"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetAggregateSettingsList")]
        [ResponseType(typeof(List<ConfAggregateSettingGetListModel>))]

        public async Task<IHttpActionResult> GetAggregateSettingsListAsync(long idfCustomizationPackage)
        {
            APIReturnResult returnResult = new APIReturnResult();

            try
            {

                log.Info("Entering  GetAggregateSettingsList");
                var result = await _repository.ConfAggregateSettingGetListAsync(idfCustomizationPackage);
                if (result == null)
                {
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
                log.Error("Error in GetAggregateSettingsList: Proc:" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;

            }
            catch (System.Exception ex)
            {
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
                log.Error("Error in GetAggregateSettingsList: " + ex.Message);

            }
            log.Info("Exiting  GetAggregateSettingsList");
            return Json(returnResult);
        }
        
        #region Human Aggregate Matrix 

        /// <summary>
        /// Returns a list of Aggregate Case Versions. Null will return All Versions
        /// </summary>
        /// <param name="idfVersion"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("ConfAggregateCaseMatrixVersionGet")]
        [ResponseType(typeof(List<ConfHumanAggregateCaseMatrixVersionGetModel>))]
        public async Task<IHttpActionResult> ConfAggregateCaseMatrixVersionGet(long? idfVersion = null)
        {
            APIReturnResult returnResult = new APIReturnResult();

            try
            {

                log.Info("Entering  ConfAggregateCaseMatrixVersionGet");
                var result = await _repository.ConfHumanAggregateCaseMatrixVersionGetAsync(idfVersion);
                if (result == null)
                {
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
                log.Error("Error in ConfAggregateCaseMatrixVersionGet: Proc:" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;

            }
            catch (System.Exception ex)
            {
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
                log.Error("Error in ConfAggregateCaseMatrixVersionGet: " + ex.Message);

            }
            log.Info("Exiting  ConfAggregateCaseMatrixVersionGet");
            return Json(returnResult);
        }

        /// <summary>
        /// Returns a list of Aggregate Case Versions By matrix Type
        /// </summary>
        /// <param name="matrixType"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("ConfAggregateCaseMatrixVersionGetByType")]
        [ResponseType(typeof(List<ConfHumanAggregateCaseMatrixVersionByMatrixTypeGetModel>))]
        public async Task<IHttpActionResult> ConfAggregateCaseMatrixVersionGetByType(long? matrixType = null)
        {
            APIReturnResult returnResult = new APIReturnResult();

            try
            {

                log.Info("Entering  ConfAggregateCaseMatrixVersionGetByType");
                var result = await _repository.ConfHumanAggregateCaseMatrixVersionByMatrixTypeGetAsync(matrixType);
                if (result == null)
                {
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
                log.Error("Error in ConfAggregateCaseMatrixVersionGetByType: Proc:" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;

            }
            catch (System.Exception ex)
            {
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
                log.Error("Error in ConfAggregateCaseMatrixVersionGetByType: " + ex.Message);

            }
            log.Info("Exiting  ConfAggregateCaseMatrixVersionGetByType");
            return Json(returnResult);
        }

        /// <summary>
        /// Returns a list of Aggregate Case Version from Matrix Report  Configuration
        /// </summary>
        /// <param name="idfVersion"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        /// 
        [HttpGet, Route("ConfAdminAggregateHumanCaseMatrixReportGet")]
        [ResponseType(typeof(List<ConfAdminAggregateHumanCaseMatrixReportGetModel>))]
        public async Task<IHttpActionResult> ConfAdminAggregateHumanCaseMatrixReportGetAsync(long? idfVersion = null)
        {
            APIReturnResult returnResult = new APIReturnResult();

            try
            {

                log.Info("Entering  ConfHumanAggregateCaseMatrixReportGet");
                var result = await _repository.ConfAdminAggregateHumanCaseMatrixReportGetAsync(idfVersion);
                if (result == null)
                {
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
                log.Error("Error in ConfHumanAggregateCaseMatrixReportGet: Proc:" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;

            }
            catch (System.Exception ex)
            {
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
                log.Error("Error in ConfHumanAggregateCaseMatrixReportGet: " + ex.Message);

            }
            log.Info("Exiting  ConfHumanAggregateCaseMatrixReportGet");
            return Json(returnResult);
        }





        /// <summary>
        /// Returns a list of Vet Aggregate  Version from Matrix Report  Configuration
        /// </summary>
        /// <param name="idfVersion"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        ///
        [HttpGet, Route("ConfAdminAggregateVetCaseMatrixReportGet")]
        [ResponseType(typeof(List<ConfAdminAggregateVetCaseMatrixReportGetModel>))]
        public async Task<IHttpActionResult> ConfAdminAggregateVetCaseMatrixReportGetAsync(long? idfVersion = null)
        {
            APIReturnResult returnResult = new APIReturnResult();

            try
            {

                log.Info("Entering  ConfAdminAggregateVetCaseMatrixReportGetAsync");
                var result = await _repository.ConfAdminAggregateVetCaseMatrixReportGetAsync(idfVersion);
                if (result == null)
                {
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
                log.Error("Error in ConfAdminAggregateVetCaseMatrixReportGetAsync: Proc:" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;

            }
            catch (System.Exception ex)
            {
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
                log.Error("Error in ConfAdminAggregateVetCaseMatrixReportGetAsync: " + ex.Message);

            }
            log.Info("Exiting  ConfAdminAggregateVetCaseMatrixReportGetAsync");
            return Json(returnResult);
        }






        /// <summary>
        /// Returns a list of Aggregate Case Versions. Null will return All Versions
        /// </summary>
        /// <param name="aggregateCaseVerionPostParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("ConfAggregateCaseMatrixVersionPost")]
        [ResponseType(typeof(List<ConfHumanAggregateCaseMatrixVersionPostModel>))]
        public async Task<IHttpActionResult> ConfAggregateCaseMatrixVersionPost(AggregateCaseVerionPostParams aggregateCaseVerionPostParams)
        {
            log.Info("Entering  ConfAggregateCaseMatrixVersionPost");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfHumanAggregateCaseMatrixVersionPostAsync(
                aggregateCaseVerionPostParams.idfVersion,
                aggregateCaseVerionPostParams.idfsMatrixType,
                aggregateCaseVerionPostParams.datStartDate,
                aggregateCaseVerionPostParams.matrixName,
                aggregateCaseVerionPostParams.blnIsActive,
                aggregateCaseVerionPostParams.blnIsDefault
                );
                if (result == null)
                {
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
                log.Error("Error in ConfAggregateCaseMatrixVersionPost: Proc:" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;

            }
            catch (System.Exception ex)
            {
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
                log.Error("Error in ConfAggregateCaseMatrixVersionPost: " + ex.Message);

            }
            log.Info("Exiting  ConfAggregateCaseMatrixVersionPost");
            return Json(returnResult);
        }

        /// <summary>
        ///Saves a Muman Diseases to a Matrix Version
        /// </summary>
        /// <param name="humanCaseMtxReportPostParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("ConfHumanAggregateCaseMatrixReportPost")]
        [ResponseType(typeof(List<ConfHumanAggregateCaseMatrixReportPostModel>))]
        public async Task<IHttpActionResult> ConfHumanAggregateCaseMatrixReportPost([FromBody] List<HumanCaseMtxReportPostParams> humanCaseMtxReportPostParams)
        {
            log.Info("Entering  ConfAggregateCaseMatrixDiseasePost");
            APIReturnResult returnResult = new APIReturnResult();
            List<ConfHumanAggregateCaseMatrixReportJsonPostModel> result = new List<ConfHumanAggregateCaseMatrixReportJsonPostModel>();
            try
            {

                result = await _repository.ConfHumanAggregateCaseMatrixReportJsonPostAsync(
                                      humanCaseMtxReportPostParams[0].idfAggrHumanCaseMtx,
                                      humanCaseMtxReportPostParams[0].idfVersion,
                                      JsonConvert.SerializeObject(humanCaseMtxReportPostParams)
                                  );




                if (result == null)
                {
                    returnResult.ErrorMessage = "The API was reached, but there is a  retrieving data from the data reporistory: " + HttpStatusCode.BadRequest.ToString();
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
                log.Error("Error in ConfHumanAggregateCaseMatrixReportPost: Proc:" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;

            }
            catch (System.Exception ex)
            {
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
                log.Error("Error in ConfHumanAggregateCaseMatrixReportPost: " + ex.Message);

            }
            log.Info("Exiting  ConfHumanAggregateCaseMatrixReportPost");
            return Json(returnResult);
        }






        /// <summary>
        ///Saves a Vet Diseases to a Matrix Version
        /// </summary>
        /// <param name="vetCaseMtxReportPostParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("ConfVetAggregateCaseMatrixReportPost")]
        [ResponseType(typeof(List<ConfVEtAggregateCaseMatrixReportJsonPostModel>))]
        public async Task<IHttpActionResult> ConfVetAggregateCaseMatrixReportPost([FromBody] List<VetCaseMtxReportPostParams> vetCaseMtxReportPostParams)
        {
            log.Info("Entering  ConfVetAggregateCaseMatrixReportPost");
            APIReturnResult returnResult = new APIReturnResult();
            List<ConfVEtAggregateCaseMatrixReportJsonPostModel> result = new List<ConfVEtAggregateCaseMatrixReportJsonPostModel>();
            try
            {

                result = await _repository.ConfVEtAggregateCaseMatrixReportJsonPostAsync(
                                      vetCaseMtxReportPostParams[0].idfAggrVetCaseMTX,
                                      vetCaseMtxReportPostParams[0].idfVersion,
                                      JsonConvert.SerializeObject(vetCaseMtxReportPostParams)
                                  );




                if (result == null)
                {
                    returnResult.ErrorMessage = "The API was reached, but there is a  retrieving data from the data reporistory: " + HttpStatusCode.BadRequest.ToString();
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
                log.Error("Error in ConfVetAggregateCaseMatrixReportPost: Proc:" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;

            }
            catch (System.Exception ex)
            {
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
                log.Error("Error in ConfVetAggregateCaseMatrixReportPost: " + ex.Message);

            }
            log.Info("Exiting  ConfVetAggregateCaseMatrixReportPost");
            return Json(returnResult);
        }

        /// <summary>
        /// Deletes Vet Aggregate Case Matrix Record
        /// </summary>
        /// <param name="idfAggrHumanCaseMtx"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfVetAggregateCaseMatrixReportRecordDeleteModel>))]
        [HttpDelete, Route("ConfVetAggregateCaseMatrixReportDelete")]
        public async Task<IHttpActionResult> ConfVetAggregateCaseMatrixReportDelete(long idfAggrHumanCaseMtx)
        {
            log.Info("ConfVetAggregateCaseMatrixReportDelete is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfVetAggregateCaseMatrixReportRecordDeleteAsync(idfAggrHumanCaseMtx);
                if (result == null)
                {
                    log.Info("Exiting  ConfVetAggregateCaseMatrixReportDelete With Not Found");
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
                log.Error("SQL Error in ConfVetAggregateCaseMatrixReportDelete Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfVetAggregateCaseMatrixReportDelete" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfVetAggregateCaseMatrixReportDelete");
            return Ok(returnResult);
        }




        /// <summary>
        /// Saves Diseases for Human Case Report Version
        /// </summary>
        /// <param name="humanCaseMtxReportPostParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("ConfHumanAggregateCaseMatrixReportDeleteModel")]
        [ResponseType(typeof(List<ConfHumanAggregateCaseMatrixReportDeleteModel>))]
        public async Task<IHttpActionResult> ConfHumanAggregateCaseMatrixDelete(HumanCaseMtxReportPostParams humanCaseMtxReportPostParams)
        {
            log.Info("Entering  ConfHumanAggregateCaseMatrixReportDeleteModel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfHumanAggregateCaseMatrixReportDeleteAsync(
                humanCaseMtxReportPostParams.idfAggrHumanCaseMtx,
                humanCaseMtxReportPostParams.idfVersion,
                humanCaseMtxReportPostParams.idfsDiagnosis,
                humanCaseMtxReportPostParams.intNumRow
                );
                if (result == null)
                {
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
                log.Error("Error in ConfHumanAggregateCaseMatrixReportDeleteModel: Proc:" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;

            }
            catch (System.Exception ex)
            {
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
                log.Error("Error in ConfHumanAggregateCaseMatrixReportDeleteModel: " + ex.Message);

            }
            log.Info("Exiting  ConfHumanAggregateCaseMatrixReportDeleteModel");
            return Json(returnResult);
        }

        /// <summary>
        /// 
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
        [HttpGet, Route("GetHumanAggregateCaseMatrix")]
        public async Task<IHttpActionResult> GetHumanAggregateCaseMatrix(long idfsBaseReference, int intHaCode, string strLanguageId)
        {
            log.Info("GetHumanAggregateCaseMatrix is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.GblDiseaseMtxGetAsync(idfsBaseReference, intHaCode, strLanguageId);
                if (result == null)
                {
                    log.Info("Exiting  GetHumanAggregateCaseMatrix With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    List<GblDiseaseMtxGetModel> resultList = new List<GblDiseaseMtxGetModel>();
                    GblDiseaseMtxGetModel mtxitem = new GblDiseaseMtxGetModel();
                    foreach (var item in result)
                    {
                        mtxitem.strDefault = String.IsNullOrEmpty(item.strDefault) ? String.Empty : item.strDefault;
                        mtxitem.strIDC10 = String.IsNullOrEmpty(item.strIDC10) ? String.Empty : item.strIDC10;
                        mtxitem.idfsBaseReference = item.idfsBaseReference;
                        resultList.Add(mtxitem);
                    }

                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(resultList);
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
                log.Error("Error in GetHumanCaseMatriGetHumanAggregateCaseMatrixxAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetHumanAggregateCaseMatrix");
            return Ok(returnResult);
        }

        /// <summary>
        /// Deletes Human Aggregate Case Matrix Version Headers
        /// </summary>
        /// <param name="idfVersion"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfHumanAggregateCaseMatrixVersionDeleteModel>))]
        [HttpDelete, Route("DeleteHumanCaseMatrixVersion")]
        public async Task<IHttpActionResult> ConfHumanAggregateCaseMatrixVersionDeleteAsync(long idfVersion)
        {
            log.Info("ConfHumanAggregateCaseMatrixVersionDeleteAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfHumanAggregateCaseMatrixVersionDeleteAsync(idfVersion);
                if (result == null)
                {
                    log.Info("Exiting  ConfHumanAggregateCaseMatrixVersionDeleteAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfHumanAggregateCaseMatrixVersionDeleteAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfHumanAggregateCaseMatrixVersionDeleteAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfHumanAggregateCaseMatrixVersionDeleteAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Deletes Human Aggregate Case Matrix Record
        /// </summary>
        /// <param name="idfAggrHumanCaseMtx"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfHumanAggregateCaseMatrixReportRecordDeleteModel>))]
        [HttpDelete, Route("ConfHumanAggregateCaseMatrixReportDelete")]
        public async Task<IHttpActionResult> ConfHumanAggregateCaseMatrixReportDelete(long idfAggrHumanCaseMtx)
        {
            log.Info("ConfHumanAggregateCaseMatrixReportDelete is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfHumanAggregateCaseMatrixReportRecordDeleteAsync(idfAggrHumanCaseMtx);
                if (result == null)
                {
                    log.Info("Exiting  ConfHumanAggregateCaseMatrixReportDelete With Not Found");
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
                log.Error("SQL Error in ConfHumanAggregateCaseMatrixReportDelete Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfHumanAggregateCaseMatrixReportDelete" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfHumanAggregateCaseMatrixReportDelete");
            return Ok(returnResult);
        }


      


      

        #endregion

        #region Vetinary Diagnostic Investgation

        /// <summary>
        /// Returns List of Vet Diagnosis 
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
        [ResponseType(typeof(List<ConfGetVetDiseaseListGetModel>))]
        [HttpGet, Route("GetVetDiagnosisList")]
        public async Task<IHttpActionResult> GetVetDiagnosisList(long idfsBaseReference, int intHaCode, string strLanguageId)
        {
            log.Info("GetVetDiagnosisList is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfGetVetDiseaseListGetAsync(idfsBaseReference, intHaCode, strLanguageId);
                if (result == null)
                {
                    log.Info("Exiting  GetVetDiagnosisList With Not Found");
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
                log.Error("SQL Error in GetVetDiagnosisList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetVetDiagnosisList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetVetDiagnosisList");
            return Ok(returnResult);
        }
        #endregion

        #region Vetinary Diagnostic Investgation

        /// <summary>
        /// Returns List of Species
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
        [ResponseType(typeof(List<ConfGetSpeciesListGetModel>))]
        [HttpGet, Route("GetSpeciesList")]
        public async Task<IHttpActionResult> GetSpeciesList(long idfsBaseReference, int intHaCode, string strLanguageId)
        {
            log.Info("GetSpeciesList is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfGetSpeciesListGetAsync(idfsBaseReference, intHaCode, strLanguageId);
                if (result == null)
                {
                    log.Info("Exiting  GetSpeciesList With Not Found");
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
                log.Error("SQL Error in GetSpeciesList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetSpeciesList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetSpeciesList");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns List of Investigation Types
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
        [ResponseType(typeof(List<ConfGetInvestigationTypesGetModel>))]
        [HttpGet, Route("GetInvestigationTypes")]
        public async Task<IHttpActionResult> GetInvestigationTypes(long idfsBaseReference, int intHaCode, string strLanguageId)
        {
            log.Info("GetInvestigationTypes is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfGetInvestigationTypesGetAsync(idfsBaseReference, intHaCode, strLanguageId);
                if (result == null)
                {
                    log.Info("Exiting  GetInvestigationTypes With Not Found");
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
                log.Error("SQL Error in GetInvestigationTypes Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetInvestigationTypes" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetInvestigationTypes");
            return Ok(returnResult);
        }

        #endregion

        #region Disease Group Matrix


        /// <summary>
        /// Deletes Disease Group Matrix
        /// </summary>
        /// <param name="idfDiagnosisAgeGroupToDiagnosis"></param>
        /// <param name="deleteAnyWay"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfDiseasegroupdiseasematrixDelModel>))]
        [HttpDelete, Route("DiseaseGroupDiseaseMatrixDelete")]
        public async Task<IHttpActionResult> ConfDiseasegroupdiseasematrixDelAsync(long idfDiagnosisAgeGroupToDiagnosis, bool deleteAnyWay)
        {
            log.Info("ConfDiseasegroupdiseasematrixDelAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfDiseasegroupdiseasematrixDelAsync(idfDiagnosisAgeGroupToDiagnosis, deleteAnyWay);
                if (result == null)
                {
                    log.Info("Exiting  ConfDiseasegroupdiseasematrixDelAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfDiseasegroupdiseasematrixDelAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfDiseasegroupdiseasematrixDelAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfDiseasegroupdiseasematrixDelAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns Disease Group Matrix
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfsDiagnosisgroup"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfDiseasegroupdiseasematrixGetlistModel>))]
        [HttpGet, Route("GetDiseaseGroupDiseaseMatrix")]
        public async Task<IHttpActionResult> ConfDiseasegroupdiseasematrixGetlistAsync(string languageId, long idfsDiagnosisgroup)
        {
            log.Info("ConfDiseaseagegroupmatrixGetlistAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfDiseasegroupdiseasematrixGetlistAsync(languageId, idfsDiagnosisgroup);
                if (result == null)
                {
                    log.Info("Exiting  ConfDiseasegroupdiseasematrixGetlistAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfDiseasegroupdiseasematrixGetlistAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfDiseasegroupdiseasematrixGetlistAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfDiseasegroupdiseasematrixGetlistAsync");
            return Ok(returnResult);
        }



        /// <summary>
        /// Sets Disease Group Matrix
        /// </summary>
        /// <param name="diseaseGroupDiseaseMatrixSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfDiseasegroupdiseasematrixSetModel>))]
        [HttpPost, Route("PostDiseaseGroupDiseaseMatrix")]
        public async Task<IHttpActionResult> ConfDiseasegroupdiseasematrixSetAsync(DiseaseGroupDiseaseMatrixSetParams diseaseGroupDiseaseMatrixSetParams)
        {
            log.Info("ConfDiseasegroupdiseasematrixSetAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfDiseasegroupdiseasematrixSetAsync(
                    diseaseGroupDiseaseMatrixSetParams.idfDiagnosisToDiagnosisGroup,
                    diseaseGroupDiseaseMatrixSetParams.idfsDiagnosisGroup,
                    diseaseGroupDiseaseMatrixSetParams.idfsDiagnosis
                    );
                if (result == null)
                {
                    log.Info("Exiting  ConfDiseasegroupdiseasematrixSetAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfDiseasegroupdiseasematrixSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfDiseasegroupdiseasematrixSetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfDiseasegroupdiseasematrixSetAsync");
            return Ok(returnResult);
        }


        #endregion

        #region Custom Report

       
        /// <summary>
        /// Deletes a Custom Report
        /// </summary>
        /// <param name="ifdfreportRows"></param>
        /// <param name="deleteAnyWay"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfCustomreportDelModel>))]
        [HttpDelete, Route("ConfCustomreportDelAsync")]
        public async Task<IHttpActionResult> ConfCustomreportDelAsync(long ifdfreportRows, bool deleteAnyWay)
        {
            log.Info("ConfCustomreportDelAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfCustomreportDelAsync(ifdfreportRows, deleteAnyWay);
                if (result == null)
                {
                    log.Info("Exiting  ConfCustomreportDelAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfCustomreportDelAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfCustomreportDelAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfCustomreportDelAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Returns  a Custom Report
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfsCustomReportType"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfCustomreportGetlistModel>))]
        [HttpGet, Route("ConfCustomreportGetlistAsync")]
        public async Task<IHttpActionResult> ConfCustomreportGetlistAsync(string languageId, long idfsCustomReportType)
        {
            log.Info("ConfCustomreportGetlistAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfCustomreportGetlistAsync(languageId, idfsCustomReportType);
                if (result == null)
                {
                    log.Info("Exiting  ConfCustomreportGetlistAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfCustomreportGetlistAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfCustomreportGetlistAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfCustomreportGetlistAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns  a Custom Report
        /// </summary>
        /// <param name="customReportSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfCustomreportSetModel>))]
        [HttpPost, Route("ConfCustomreportSetAsync")]
        public async Task<IHttpActionResult> ConfCustomreportSetAsync(CustomReportSetParams customReportSetParams)
        {
            log.Info("ConfCustomreportGetlistAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfCustomreportSetAsync(
                    customReportSetParams.idfReportRows,
                    customReportSetParams.idfsCustomReportType,
                    customReportSetParams.idfsDiagnosisOrReportDiagnosisGroup,
                    customReportSetParams.idfsReportAdditionalText,
                    customReportSetParams.idfsIcdReportAdditionalText
                    );
                if (result == null)
                {
                    log.Info("Exiting  ConfCustomreportSetAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfCustomreportSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfCustomreportSetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfCustomreportSetAsync");
            return Ok(returnResult);
        }
        #endregion
        
        #region Disease Group Matrix

       

        /// <summary>
        /// Deletes  A Disease Group Matrix Report
        /// </summary>
        /// <param name="idfDiagnosisToGroupForReportType"></param>
        /// <param name="deleteAnyWay"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfReportdiseasegroupdiseasematrixDelModel>))]
        [HttpDelete, Route("ConfReportdiseasegroupdiseasematrixDelAsync")]
        public async Task<IHttpActionResult> ConfReportdiseasegroupdiseasematrixDelAsync(long idfDiagnosisToGroupForReportType,bool deleteAnyWay)
        {
            log.Info("ConfReportdiseasegroupdiseasematrixDelAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfReportdiseasegroupdiseasematrixDelAsync(idfDiagnosisToGroupForReportType, deleteAnyWay);
                  
                if (result == null)
                {
                    log.Info("Exiting  ConfReportdiseasegroupdiseasematrixDelAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfReportdiseasegroupdiseasematrixDelAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfReportdiseasegroupdiseasematrixDelAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfReportdiseasegroupdiseasematrixDelAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Returns  A Disease Group Matrix Report
        /// </summary>
        /// <param name="langId"></param>
        /// <param name="idfsCustomReportType"></param>
        /// <param name="idfsReportDiagnosisGroup"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfReportdiseasegroupdiseasematrixGetlistModel>))]
        [HttpGet, Route("ConfReportdiseasegroupdiseasematrixGetlistAsync")]
        public async Task<IHttpActionResult> ConfReportdiseasegroupdiseasematrixGetlistAsync(string langId, long? idfsCustomReportType, long? idfsReportDiagnosisGroup)
        {
            log.Info("ConfReportdiseasegroupdiseasematrixDelAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfReportdiseasegroupdiseasematrixGetlistAsync( langId,  idfsCustomReportType,  idfsReportDiagnosisGroup);

                if (result == null)
                {
                    log.Info("Exiting  ConfReportdiseasegroupdiseasematrixGetlistAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfReportdiseasegroupdiseasematrixGetlistAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfReportdiseasegroupdiseasematrixGetlistAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfReportdiseasegroupdiseasematrixGetlistAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Creates  A Disease Group Matrix Report
        /// </summary>
        /// <param name="confReportdiseasegroupdiseasematrixSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfReportdiseasegroupdiseasematrixSetModel>))]
        [HttpPost, Route("ConfReportdiseasegroupdiseasematrixSetAsync")]
        public async Task<IHttpActionResult> ConfReportdiseasegroupdiseasematrixSetAsync(ConfReportdiseasegroupdiseasematrixSetParams confReportdiseasegroupdiseasematrixSetParams)
        {
            log.Info("ConfReportdiseasegroupdiseasematrixSetAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {


                var result = await _repository.ConfReportdiseasegroupdiseasematrixSetAsync(
                    confReportdiseasegroupdiseasematrixSetParams.idfDiagnosisToGroupForReportType,
                    confReportdiseasegroupdiseasematrixSetParams.idfsCustomReportType,
                    confReportdiseasegroupdiseasematrixSetParams.idfsReportDiagnosisGroup,
                    confReportdiseasegroupdiseasematrixSetParams.idfsDiagnosis);
                    

                if (result == null)
                {
                    log.Info("Exiting  ConfReportdiseasegroupdiseasematrixSetAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfReportdiseasegroupdiseasematrixSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfReportdiseasegroupdiseasematrixSetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfReportdiseasegroupdiseasematrixSetAsync");
            return Ok(returnResult);
        }
        #endregion

        #region Vector Sample Type Matrix

        
        /// <summary>
        /// Returns  A  Vector Type Sample Type Matrix
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
        [ResponseType(typeof(List<ConfVectortypesampletypematrixGetlistModel>))]
        [HttpGet, Route("ConfVectortypesampletypematrixGetlistAsync")]
        public async Task<IHttpActionResult> ConfVectortypesampletypematrixGetlistAsync(string languageId, long idfsVectorType)
        {
            log.Info("ConfVectortypesampletypematrixGetlistAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfVectortypesampletypematrixGetlistAsync(languageId, idfsVectorType);
                if (result == null)
                {
                    log.Info("Exiting  ConfVectortypesampletypematrixGetlistAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfVectortypesampletypematrixGetlistAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfVectortypesampletypematrixGetlistAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfVectortypesampletypematrixGetlistAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Deletes  A  Vector Type Sample Type Matrix
        /// </summary>
        /// <param name="idfSampleTypeForVectorType"></param>
        /// <param name="deleteAnyway"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfVectortypesampletypematrixDelModel>))]
        [HttpDelete, Route("ConfVectortypesampletypematrixDelAsync")]
        public async Task<IHttpActionResult> ConfVectortypesampletypematrixDelAsync(long idfSampleTypeForVectorType, bool deleteAnyway)
        {
            log.Info("ConfVectortypesampletypematrixDelAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfVectortypesampletypematrixDelAsync(idfSampleTypeForVectorType, deleteAnyway);
                if (result == null)
                {
                    log.Info("Exiting  ConfVectortypesampletypematrixDelAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfVectortypesampletypematrixDelAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfVectortypesampletypematrixDelAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfVectortypesampletypematrixDelAsync");
            return Ok(returnResult);
        }



        /// <summary>
        /// Creates  A  Vector Type Sample Type Matrix
        /// </summary>
        /// <param name="confVectortypesampletypematrixSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfVectortypesampletypematrixSetModel>))]
        [HttpPost, Route("ConfVectortypesampletypematrixSetAsync")]
        public async Task<IHttpActionResult> ConfVectortypesampletypematrixSetAsync(ConfVectortypesampletypematrixSetParams confVectortypesampletypematrixSetParams)
        {
            log.Info("ConfVectortypesampletypematrixDelAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfVectortypesampletypematrixSetAsync(
                    confVectortypesampletypematrixSetParams.idfSampleTypeForVectorType, 
                    confVectortypesampletypematrixSetParams.idfsVectorType, 
                    confVectortypesampletypematrixSetParams.idfsSampleType
                    );
                if (result == null)
                {
                    log.Info("Exiting  ConfVectortypesampletypematrixSetAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfVectortypesampletypematrixSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfVectortypesampletypematrixSetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfVectortypesampletypematrixSetAsync");
            return Ok(returnResult);
        }

        #endregion

        #region Vector Type Field Test Matrix

      


        /// <summary>
        /// Creates  A  Vector Type Field Test Matrix
        /// </summary>
        /// <param name="confVectortypefieldtestmatrixSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfVectortypefieldtestmatrixSetModel>))]
        [HttpPost, Route("ConfVectortypefieldtestmatrixSetAsync")]
        public async Task<IHttpActionResult> ConfVectortypefieldtestmatrixSetAsync(ConfVectortypefieldtestmatrixSetParams confVectortypefieldtestmatrixSetParams)
        {
            log.Info("ConfVectortypefieldtestmatrixSetAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            { 
                var result = await _repository.ConfVectortypefieldtestmatrixSetAsync(
                    confVectortypefieldtestmatrixSetParams.idfPensideTestTypeForVectorType,
                    confVectortypefieldtestmatrixSetParams.idfsVectorType,
                    confVectortypefieldtestmatrixSetParams.idfsPensideTestName
                    );
                   
                if (result == null)
                {
                    log.Info("Exiting  ConfVectortypefieldtestmatrixSetAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfVectortypefieldtestmatrixSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfVectortypefieldtestmatrixSetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfVectortypefieldtestmatrixSetAsync");
            return Ok(returnResult);
        }




        /// <summary>
        /// Returns List of  Vector Type Field Test Matrix
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
        [ResponseType(typeof(List<ConfVectortypefieldtestmatrixGetlistModel>))]
        [HttpGet, Route("ConfVectortypefieldtestmatrixGetlistAsync")]
        public async Task<IHttpActionResult> ConfVectortypefieldtestmatrixGetlistAsync(string languageId, long idfsVectorType)
        {

            log.Info("ConfVectortypefieldtestmatrixGetlistAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfVectortypefieldtestmatrixGetlistAsync(languageId,idfsVectorType );
                if (result == null)
                {
                    log.Info("Exiting  ConfVectortypefieldtestmatrixGetlistAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfVectortypefieldtestmatrixGetlistAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfVectortypefieldtestmatrixGetlistAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfVectortypefieldtestmatrixGetlistAsync");
            return Ok(returnResult);
        }




        /// <summary>
        /// Deletes  Vector Type Field Test Matrix
        /// </summary>
        /// <param name="idfPensideTestTypeForVectorType"></param>
        /// <param name="deleteAnyway"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfVectortypefieldtestmatrixDelModel>))]
        [HttpDelete, Route("ConfVectortypefieldtestmatrixDelAsync")]
        public async Task<IHttpActionResult> ConfVectortypefieldtestmatrixDelAsync(long idfPensideTestTypeForVectorType, bool deleteAnyway)
        {

            log.Info("ConfVectortypefieldtestmatrixDelAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfVectortypefieldtestmatrixDelAsync(idfPensideTestTypeForVectorType, deleteAnyway);
                if (result == null)
                {
                    log.Info("Exiting  ConfVectortypefieldtestmatrixDelAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfVectortypefieldtestmatrixDelAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfVectortypefieldtestmatrixDelAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfVectortypefieldtestmatrixDelAsync");
            return Ok(returnResult);
        }



        #endregion

        #region Age Group Statistical Matrix

       

        /// <summary>
        /// Deletes  AgeGroup Statistical Matrix
        /// </summary>
        /// <param name="idfDiagnosisAgeGroupToStatisticalAgeGroup"></param>
        /// <param name="deleteAnyway"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfAgegroupstatisticalagegroupmatrixDelModel>))]
        [HttpDelete, Route("ConfAgegroupstatisticalagegroupmatrixDelAsync")]
        public async Task<IHttpActionResult> ConfAgegroupstatisticalagegroupmatrixDelAsync(long idfDiagnosisAgeGroupToStatisticalAgeGroup, bool deleteAnyway)
        {

            log.Info("ConfAgegroupstatisticalagegroupmatrixDelAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfAgegroupstatisticalagegroupmatrixDelAsync(idfDiagnosisAgeGroupToStatisticalAgeGroup, deleteAnyway);
                if (result == null)
                {
                    log.Info("Exiting  ConfAgegroupstatisticalagegroupmatrixDelAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfAgegroupstatisticalagegroupmatrixDelAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfAgegroupstatisticalagegroupmatrixDelAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfAgegroupstatisticalagegroupmatrixDelAsync");
            return Ok(returnResult);
        }




        /// <summary>
        /// Returns  AgeGroup Statistical Matrix
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfsDiagnosisAgeGroup"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfAgegroupstatisticalagegroupmatrixGetlistModel>))]
        [HttpGet, Route("ConfAgegroupstatisticalagegroupmatrixGetlistAsync")]
        public async Task<IHttpActionResult> ConfAgegroupstatisticalagegroupmatrixGetlistAsync(string languageId,long idfsDiagnosisAgeGroup)
        {
            log.Info("ConfAgegroupstatisticalagegroupmatrixGetlistAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfAgegroupstatisticalagegroupmatrixGetlistAsync(languageId, idfsDiagnosisAgeGroup);
                if (result == null)
                {
                    log.Info("Exiting  ConfAgegroupstatisticalagegroupmatrixGetlistAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfAgegroupstatisticalagegroupmatrixGetlistAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfAgegroupstatisticalagegroupmatrixGetlistAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfAgegroupstatisticalagegroupmatrixGetlistAsync");
            return Ok(returnResult);
        }




        /// <summary>
        /// Creates  AgeGroup Statistical Matrix
        /// </summary>
        /// <param name="confAgegroupstatisticalagegroupmatrixSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfAgegroupstatisticalagegroupmatrixSetModel>))]
        [HttpPost, Route("ConfAgegroupstatisticalagegroupmatrixSetAsync")]
        public async Task<IHttpActionResult> ConfAgegroupstatisticalagegroupmatrixSetAsync(ConfAgegroupstatisticalagegroupmatrixSetParams confAgegroupstatisticalagegroupmatrixSetParams)
        {
            log.Info("ConfAgegroupstatisticalagegroupmatrixSetAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {

                var result = await _repository.ConfAgegroupstatisticalagegroupmatrixSetAsync(
                    confAgegroupstatisticalagegroupmatrixSetParams.idfDiagnosisAgeGroupToStatisticalAgeGroup, 
                    confAgegroupstatisticalagegroupmatrixSetParams.idfsDiagnosisAgeGroup, 
                    confAgegroupstatisticalagegroupmatrixSetParams.idfsStatisticalAgeGroup
                    );
                if (result == null)
                {
                    log.Info("Exiting  ConfAgegroupstatisticalagegroupmatrixSetAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfAgegroupstatisticalagegroupmatrixSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfAgegroupstatisticalagegroupmatrixSetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfAgegroupstatisticalagegroupmatrixSetAsync");
            return Ok(returnResult);
        }

        #endregion

        #region SampleTypeMatrix

        /// <summary>
        /// Creates Sample Type Matrix
        /// </summary>
        /// <param name="confDiseasesampletypematrixSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfDiseasesampletypematrixSetModel>))]
        [HttpPost, Route("ConfDiseasesampletypematrixSetAsync")]
        public async Task<IHttpActionResult> ConfDiseasesampletypematrixSetAsync(ConfDiseasesampletypematrixSetParams confDiseasesampletypematrixSetParams)
        {
            log.Info("ConfDiseasesampletypematrixSetAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfDiseasesampletypematrixSetAsync(
                    confDiseasesampletypematrixSetParams.idfMaterialForDisease,
                    confDiseasesampletypematrixSetParams.idfsDiagnosis,
                    confDiseasesampletypematrixSetParams.idfsSampleType
                    );
                if (result == null)
                {
                    log.Info("Exiting  ConfDiseasesampletypematrixSetAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfDiseasesampletypematrixSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfDiseasesampletypematrixSetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfDiseasesampletypematrixSetAsync");
            return Ok(returnResult);
        }




        /// <summary>
        /// Returns  Sample Type Matrix
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
        [ResponseType(typeof(List<ConfDiseasesampletypematrixGetlistModel>))]
        [HttpGet, Route("ConfDiseasesampletypematrixGetlistAsync")]
        public async Task<IHttpActionResult> ConfDiseasesampletypematrixGetlistAsync(string languageId )
        {
            log.Info("ConfDiseasesampletypematrixGetlistAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
               
                var result = await _repository.ConfDiseasesampletypematrixGetlistAsync(languageId);
                if (result == null)
                {
                    log.Info("Exiting  ConfDiseasesampletypematrixGetlistAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfDiseasesampletypematrixGetlistAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfDiseasesampletypematrixGetlistAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfDiseasesampletypematrixGetlistAsync");
            return Ok(returnResult);
        }



        /// <summary>
        /// Deletes  Sample Type Matrix
        /// </summary>
        /// <param name="idfMaterialForDisease"></param>
        /// <param name="deleteAnyway"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfDiseasesampletypematrixDelModel>))]
        [HttpDelete, Route("ConfDiseasesampletypematrixDelAsync")]
        public async Task<IHttpActionResult> ConfDiseasesampletypematrixDelAsync(long? idfMaterialForDisease, bool deleteAnyway)
        {
            log.Info("ConfDiseasesampletypematrixDelAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {

                var result = await _repository.ConfDiseasesampletypematrixDelAsync(idfMaterialForDisease,deleteAnyway);
                if (result == null)
                {
                    log.Info("Exiting  ConfDiseasesampletypematrixDelAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfDiseasesampletypematrixDelAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfDiseasesampletypematrixDelAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfDiseasesampletypematrixDelAsync");
            return Ok(returnResult);
        }

        #endregion

        #region DiseaseLabTest


        /// <summary>
        /// Deletes  LabTest Matrix
        /// </summary>
        /// <param name="idfTestforDisease"></param>
        /// <param name="deleteAnyway"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfDiseaselabtestmatrixDelModel>))]
        [HttpDelete, Route("ConfDiseaselabtestmatrixDelAsync")]
        public async Task<IHttpActionResult> ConfDiseaselabtestmatrixDelAsync(long? idfTestforDisease, bool deleteAnyway)
        {
            log.Info("ConfDiseaselabtestmatrixDelAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfDiseaselabtestmatrixDelAsync(idfTestforDisease, deleteAnyway);
                if (result == null)
                {
                    log.Info("Exiting  ConfDiseaselabtestmatrixDelAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfDiseaselabtestmatrixDelAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfDiseaselabtestmatrixDelAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfDiseaselabtestmatrixDelAsync");
            return Ok(returnResult);
        }





        /// <summary>
        /// Returns  LabTest Matrix
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
        [ResponseType(typeof(List<ConfDiseaselabtestmatrixGetlistModel>))]
        [HttpGet, Route("ConfDiseaselabtestmatrixGetlistAsync")]
        public async Task<IHttpActionResult> ConfDiseaselabtestmatrixGetlistAsync(string languageId)
        {
            log.Info("ConfDiseaselabtestmatrixGetlistAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            { //USP_CONF_DISEASELABTESTMATRIX_GETLIST
                var result = await _repository.ConfDiseaselabtestmatrixGetlistAsync(languageId);
                if (result == null)
                {
                    log.Info("Exiting  ConfDiseaselabtestmatrixGetlistAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfDiseaselabtestmatrixGetlistAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfDiseaselabtestmatrixGetlistAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfDiseaselabtestmatrixGetlistAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Creates  LabTest Matrix
        /// </summary>
        /// <param name="confDiseaselabtestmatrixSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfDiseaselabtestmatrixSetModel>))]
        [HttpPost, Route("ConfDiseaselabtestmatrixSetAsync")]
        public async Task<IHttpActionResult> ConfDiseaselabtestmatrixSetAsync(ConfDiseaselabtestmatrixSetParams confDiseaselabtestmatrixSetParams)
        {
            log.Info("ConfDiseaselabtestmatrixSetAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            { 
                var result = await _repository.ConfDiseaselabtestmatrixSetAsync(
                    confDiseaselabtestmatrixSetParams.idfTestForDisease,
                    confDiseaselabtestmatrixSetParams.idfsDiagnosis,
                    confDiseaselabtestmatrixSetParams.idfsSampleType,
                    confDiseaselabtestmatrixSetParams.idfsTestName,
                    confDiseaselabtestmatrixSetParams.idfsTestCategory
                    );
                if (result == null)
                {
                    log.Info("Exiting  ConfDiseaselabtestmatrixSetAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfDiseaselabtestmatrixSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfDiseaselabtestmatrixSetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfDiseaselabtestmatrixSetAsync");
            return Ok(returnResult);
        }


        #endregion

        #region Species Type Animal Age Matrix

        /// <summary>
        /// Creates a Configuration Species Type Animal Age Matrix
        /// </summary>
        /// <param name="confSpeciestypeanimalagematrixSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfSpeciestypeanimalagematrixSetModel>))]
        [HttpPost, Route("ConfSpeciestypeanimalagematrixSetAsync")]
        public async Task<IHttpActionResult> ConfSpeciestypeanimalagematrixSetAsync(ConfSpeciestypeanimalagematrixSetParams confSpeciestypeanimalagematrixSetParams)
        { 
            log.Info("ConfSpeciestypeanimalagematrixSetAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfSpeciestypeanimalagematrixSetAsync(
                    confSpeciestypeanimalagematrixSetParams.idfSpeciesTypeToAnimalAge, 
                    confSpeciestypeanimalagematrixSetParams.idfsSpeciesType, 
                    confSpeciestypeanimalagematrixSetParams.idfsAnimalAge);

                if (result == null)
                {
                    log.Info("Exiting  ConfSpeciestypeanimalagematrixSetAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfSpeciestypeanimalagematrixSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfSpeciestypeanimalagematrixSetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting ConfSpeciestypeanimalagematrixSetAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a Species Type Animal Age Matrix
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
        [ResponseType(typeof(List<ConfSpeciestypeanimalagematrixGetlistModel>))]
        [HttpGet, Route("ConfSpeciestypeanimalagematrixGetlistAsync")]
        public async Task<IHttpActionResult> ConfSpeciestypeanimalagematrixGetlistAsync(string languageId)
        {
            log.Info("ConfSpeciestypeanimalagematrixGetlistAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {

                var result = await _repository.ConfSpeciestypeanimalagematrixGetlistAsync(languageId);
                if (result == null)
                {
                    log.Info("Exiting  ConfSpeciestypeanimalagematrixGetlistAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfSpeciestypeanimalagematrixGetlistAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfSpeciestypeanimalagematrixGetlistAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting ConfSpeciestypeanimalagematrixGetlistAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Deletes a Species type animal age matrix
        /// </summary>
        /// <param name="idfSpeciesTypeToAnimalAge"></param>
        /// <param name="deleteAnyway"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfSpeciestypeanimalagematrixDelModel>))]
        [HttpDelete, Route("ConfSpeciestypeanimalagematrixDelAsync")]
        public async Task<IHttpActionResult> ConfSpeciestypeanimalagematrixDelAsync(long idfSpeciesTypeToAnimalAge, bool deleteAnyway)
        {
            log.Info("ConfSpeciestypeanimalagematrixDelAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {

                var result = await _repository.ConfSpeciestypeanimalagematrixDelAsync(idfSpeciesTypeToAnimalAge, deleteAnyway);
                if (result == null)
                {
                    log.Info("Exiting  ConfSpeciestypeanimalagematrixDelAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfSpeciestypeanimalagematrixDelAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfSpeciestypeanimalagematrixDelAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting ConfSpeciestypeanimalagematrixDelAsync");
            return Ok(returnResult);
        }

        #endregion

        #region Sample Type Derivative Matrix


        /// <summary>
        /// Creates a Sample Type Derivative Matrix
        /// </summary>
        /// <param name="confSampleTypDerivativeSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfSampletypederivativematrixSetModel>))]
        [HttpPost, Route("ConfSampletypederivativematrixSetAsync")]
        public async Task<IHttpActionResult> ConfSampletypederivativematrixSetAsync(ConfSampleTypDerivativeSetParams confSampleTypDerivativeSetParams   )
        {
            log.Info("ConfSampletypederivativematrixSetAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {
                var result = await _repository.ConfSampletypederivativematrixSetAsync(
                    confSampleTypDerivativeSetParams.idfDerivativeForSampleType, 
                    confSampleTypDerivativeSetParams.idfsSampleType, 
                    confSampleTypDerivativeSetParams. idfsDerivativeType
                    );

                if (result == null)
                {
                    log.Info("Exiting  ConfSampletypederivativematrixSetAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfSampletypederivativematrixSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfSampletypederivativematrixSetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting ConfSampletypederivativematrixSetAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Retrieves a Sample Type Derivative Matrix
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
        [ResponseType(typeof(List<ConfSampletypederivativematrixGetlistModel>))]
        [HttpGet, Route("ConfSampletypederivativematrixGetlistAsync")]
        public async Task<IHttpActionResult> ConfSampletypederivativematrixGetlistAsync(string languageId)
        {
            log.Info("ConfSampletypederivativematrixGetlistAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {

                var result = await _repository.ConfSampletypederivativematrixGetlistAsync(languageId);
                if (result == null)
                {
                    log.Info("Exiting  ConfSampletypederivativematrixGetlistAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfSampletypederivativematrixGetlistAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfSpeciestypeanimalagematrixGetlistAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting ConfSampletypederivativematrixGetlistAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Deletes a Sample Type Derivative Matrix
        /// </summary>
        /// <param name="idfDerivativeForSampleType"></param>
        /// <param name="deleteAnyway"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfSampletypederivativematrixDelModel>))]
        [HttpDelete, Route("ConfSampletypederivativematrixDelAsync")]
        public async Task<IHttpActionResult> ConfSampletypederivativematrixDelAsync(long idfDerivativeForSampleType, bool deleteAnyway)
        {
            log.Info("ConfSampletypederivativematrixDelAsync is called");
            APIReturnResultDataTables returnResult = new APIReturnResultDataTables();
            try
            {

                var result = await _repository.ConfSampletypederivativematrixDelAsync(idfDerivativeForSampleType, deleteAnyway);
                if (result == null)
                {
                    log.Info("Exiting  ConfSampletypederivativematrixDelAsync With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.data = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in ConfSampletypederivativematrixDelAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfSampletypederivativematrixDelAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting ConfSampletypederivativematrixDelAsync");
            return Ok(returnResult);
        }


        #endregion


        #region Prophylactic Matrix

        /// <summary>
        /// Deletes Prophylactic Matrix Record
        /// </summary>
        /// <param name="idfAggrProphylacticActionMTX"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfProphylacticMatrixReportRecordDeleteModel>))]
        [HttpDelete, Route("ConfProphylacticMatrixReportRecordDelete")]
        public async Task<IHttpActionResult> ConfProphylacticMatrixReportRecordDeleteAsync(long idfAggrProphylacticActionMTX)
        {
            log.Info("ConfProphylacticMatrixReportRecordDeleteModel is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfProphylacticMatrixReportRecordDeleteAsync(idfAggrProphylacticActionMTX);
                if (result == null)
                {
                    log.Info("Exiting  ConfProphylacticMatrixReportRecordDeleteModel With Not Found");
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
                log.Error("SQL Error in ConfProphylacticMatrixReportRecordDeleteModel Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfProphylacticMatrixReportRecordDeleteModel" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfProphylacticMatrixReportRecordDeleteModel");
            return Ok(returnResult);
        }



        /// <summary>
        ///Returns a Prophylactic Action to a Matrix Version
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
        [HttpGet, Route("ConfGetProphylacticMeasuresGetAsync")]
        [ResponseType(typeof(List<ConfGetProphylacticMeasuresGetModel>))]
        public async Task<IHttpActionResult> ConfGetProphylacticMeasuresGetAsync(long idfsBaseReference, int intHaCode, string strLanguageId)
        {
            log.Info("Entering  ConfGetProphylacticMeasuresGetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            List<ConfGetProphylacticMeasuresGetModel> result = new List<ConfGetProphylacticMeasuresGetModel>();
            try
            {

                result = await _repository.ConfGetProphylacticMeasuresGetAsync(idfsBaseReference, intHaCode, strLanguageId);

                if (result == null)
                {
                    returnResult.ErrorMessage = "The API was reached, but there is a  retrieving data from the data reporistory: " + HttpStatusCode.BadRequest.ToString();
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
                log.Error("Error in ConfGetProphylacticMeasuresGetAsync: Proc:" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;

            }
            catch (System.Exception ex)
            {
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
                log.Error("Error in ConfGetProphylacticMeasuresGetAsync: " + ex.Message);

            }
            log.Info("Exiting  ConfGetProphylacticMeasuresGetAsync");
            return Json(returnResult);
        }




        /// <summary>
        ///Saves a Prophylactic Action to a Matrix Version
        /// </summary>
        /// <param name="postParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("ConfProphylacticActionMtxReportPost")]
        [ResponseType(typeof(List<ConFtlbAggrProphylacticActionMtxReportJsonPostModel>))]
        public async Task<IHttpActionResult> ConfProphylacticActionMtxReportJsonPostAsync([FromBody] List<ProphylacticMtxReportPostParams> postParams)
        {
            log.Info("Entering  ConfProphylacticActionMtxReportJsonPostAsync");
            APIReturnResult returnResult = new APIReturnResult();
            List<ConFtlbAggrProphylacticActionMtxReportJsonPostModel> result = new List<ConFtlbAggrProphylacticActionMtxReportJsonPostModel>();
            try
            {

                result = await _repository.ConFtlbAggrProphylacticActionMtxReportJsonPostAsync(
                                      postParams[0].idfAggrProphylacticActionMTX,
                                      postParams[0].idfVersion,
                                      JsonConvert.SerializeObject(postParams)
                                  );

                if (result == null)
                {
                    returnResult.ErrorMessage = "The API was reached, but there is a  retrieving data from the data reporistory: " + HttpStatusCode.BadRequest.ToString();
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
                log.Error("Error in ConfProphylacticActionMtxReportJsonPostAsync: Proc:" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;

            }
            catch (System.Exception ex)
            {
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
                log.Error("Error in ConfProphylacticActionMtxReportJsonPostAsync: " + ex.Message);

            }
            log.Info("Exiting  ConfProphylacticActionMtxReportJsonPostAsync");
            return Json(returnResult);
        }


        /// <summary>
        /// Returns a list of Phrophylactic Matrix Report  Configurations
        /// </summary>
        /// <param name="idfVersion"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        ///
        [HttpGet, Route("ConfAdminProphylacticMatrixReportGet")]
        [ResponseType(typeof(List<ConfAdminProphylacticMatrixReportGetGetModel>))]
        public async Task<IHttpActionResult> ConfAdminProphylacticMatrixReportGetGetAsync(long? idfVersion = null)
        {
            APIReturnResult returnResult = new APIReturnResult();

            try
            {

                log.Info("Entering  ConfAdminProphylacticMatrixReportGetGetAsync");
                var result = await _repository.ConfAdminProphylacticMatrixReportGetGetAsync(idfVersion);
                if (result == null)
                {
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
                log.Error("Error in ConfAdminProphylacticMatrixReportGetGetAsync: Proc:" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;

            }
            catch (System.Exception ex)
            {
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
                log.Error("Error in ConfAdminProphylacticMatrixReportGetGetAsync: " + ex.Message);

            }
            log.Info("Exiting  ConfAdminProphylacticMatrixReportGetGetAsync");
            return Json(returnResult);
        }


        #endregion


        #region Sanitary Matrix


        /// <summary>
        /// Deletes Sanitary Matrix Record
        /// </summary>
        /// <param name="idfAggrSanitaryActionMTX"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfSanitaryMatrixReportRecordDeleteModel>))]
        [HttpDelete, Route("ConfSanitaryReportRecordDeleteAsync")]
        public async Task<IHttpActionResult> ConfSanitaryMatrixReportRecordDeleteAsync(long idfAggrSanitaryActionMTX)
        {
            log.Info("ConfVetDiagnosisMatrixReportRecordDeleteAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfSanitaryMatrixReportRecordDeleteAsync(idfAggrSanitaryActionMTX);
                if (result == null)
                {
                    log.Info("Exiting  ConfSanitaryMatrixReportRecordDeleteAsync With Not Found");
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
                log.Error("SQL Error in ConfSanitaryMatrixReportRecordDeleteAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfSanitaryMatrixReportRecordDeleteAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfSanitaryMatrixReportRecordDeleteAsync");
            return Ok(returnResult);
        }



        /// <summary>
        /// Returns Sanitary Matrix Record
        /// </summary>
        /// <param name="idfVersion"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfAdminSanitaryMatrixReportGetGetModel>))]
        [HttpDelete, Route("ConfAdminSanitaryMatrixReportGet")]
        public async Task<IHttpActionResult> ConfAdminSanitaryMatrixReportGet(long idfVersion)
        {
            log.Info("ConfAdminSanitaryMatrixReportGet is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfAdminSanitaryMatrixReportGetGetAsync(idfVersion);
                if (result == null)
                {
                    log.Info("Exiting  ConfAdminSanitaryMatrixReportGet With Not Found");
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
                log.Error("SQL Error in ConfAdminSanitaryMatrixReportGet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfAdminSanitaryMatrixReportGet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfAdminSanitaryMatrixReportGet");
            return Ok(returnResult);
        }



        /// <summary>
        ///Saves a Sanitary to a Matrix Version
        /// </summary>
        /// <param name="postParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("ConfAggrSanitaryActionMtxReportPost")]
        [ResponseType(typeof(List<ConfAggrSanitaryActionMtxReportJsonPostModel>))]
        public async Task<IHttpActionResult> ConfAggrSanitaryActionMtxReportJsonPost([FromBody] List<SanitaryMtxReportPostParams> postParams)
        {
            log.Info("Entering  ConfAggrSanitaryActionMtxReportJsonPost");
            APIReturnResult returnResult = new APIReturnResult();
            List<ConfAggrSanitaryActionMtxReportJsonPostModel> result = new List<ConfAggrSanitaryActionMtxReportJsonPostModel>();
            try
            {

                result = await _repository.ConfAggrSanitaryActionMtxReportJsonPostAsync(
                                      postParams[0].idfAggrSanitaryActionMTX,
                                      postParams[0].idfVersion,
                                      JsonConvert.SerializeObject(postParams)
                                  );

                if (result == null)
                {
                    returnResult.ErrorMessage = "The API was reached, but there is a  retrieving data from the data reporistory: " + HttpStatusCode.BadRequest.ToString();
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
                log.Error("Error in ConfAggrSanitaryActionMtxReportJsonPost: Proc:" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;

            }
            catch (System.Exception ex)
            {
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
                log.Error("Error in ConfAggrSanitaryActionMtxReportJsonPost: " + ex.Message);

            }
            log.Info("Exiting  ConfAggrSanitaryActionMtxReportJsonPost");
            return Json(returnResult);
        }



        /// <summary>
        /// Returns a list of Sanitary Matrix Report  Configurations
        /// </summary>
        /// <param name="idfVersion"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        ///
        [HttpGet, Route("ConfAdminSanitaryMatrixReportGetGetAsync")]
        [ResponseType(typeof(List<ConfAdminSanitaryMatrixReportGetGetModel>))]
        public async Task<IHttpActionResult> ConfAdminSanitaryMatrixReportGetGetAsync(long? idfVersion = null)
        {
            APIReturnResult returnResult = new APIReturnResult();

            try
            {

                log.Info("Entering  ConfAdminSanitaryMatrixReportGetGetAsync");
                var result = await _repository.ConfAdminSanitaryMatrixReportGetGetAsync(idfVersion);
                if (result == null)
                {
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
                log.Error("Error in ConfAdminSanitaryMatrixReportGetGetAsync: Proc:" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;

            }
            catch (System.Exception ex)
            {
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
                log.Error("Error in ConfAdminSanitaryMatrixReportGetGetAsync: " + ex.Message);

            }
            log.Info("Exiting  ConfAdminSanitaryMatrixReportGetGetAsync");
            return Json(returnResult);
        }




        /// <summary>
        ///Returns a List of Sanitary Action Types
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
        [HttpGet, Route("GetSanitaryActionTypes")]
        [ResponseType(typeof(List<ConfGetSanitaryActionsGetModel>))]
        public async Task<IHttpActionResult> GetSanitaryActionTypes(long idfsBaseReference, int intHaCode, string strLanguageId)
        {
            log.Info("Entering  GetSanitaryActionTypes");
            APIReturnResult returnResult = new APIReturnResult();
            List<ConfGetSanitaryActionsGetModel> result = new List<ConfGetSanitaryActionsGetModel>();
            try
            {

                result = await _repository.ConfGetSanitaryActionsGetAsync(idfsBaseReference, intHaCode, strLanguageId);

                if (result == null)
                {
                    returnResult.ErrorMessage = "The API was reached, but there is a  retrieving data from the data reporistory: " + HttpStatusCode.BadRequest.ToString();
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
                log.Error("Error in GetSanitaryActionTypes: Proc:" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;

            }
            catch (System.Exception ex)
            {
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
                log.Error("Error in GetSanitaryActionTypes: " + ex.Message);

            }
            log.Info("Exiting  GetSanitaryActionTypes");
            return Json(returnResult);
        }



        

        #endregion



        #region Vet Diagnosis Matrix

        /// <summary>
        /// Deletes Vetinary Diagnosis investigation Matrix Record
        /// </summary>
        /// <param name="idfAggrDiagnosticActionMTX"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<ConfVetDiagnosisMatrixReportRecordDeleteModel>))]
        [HttpDelete, Route("ConfVetDiagnosisMatrixReportRecordDeleteAsync")]
        public async Task<IHttpActionResult> ConfVetDiagnosisMatrixReportRecordDeleteAsync(long idfAggrDiagnosticActionMTX)
        {
            log.Info("ConfVetDiagnosisMatrixReportRecordDeleteAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.ConfVetDiagnosisMatrixReportRecordDeleteAsync(idfAggrDiagnosticActionMTX);
                if (result == null)
                {
                    log.Info("Exiting  ConfVetDiagnosisMatrixReportRecordDeleteAsync With Not Found");
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
                log.Error("SQL Error in ConfVetDiagnosisMatrixReportRecordDeleteAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ConfVetDiagnosisMatrixReportRecordDeleteAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ConfVetDiagnosisMatrixReportRecordDeleteAsync");
            return Ok(returnResult);
        }

        /// <summary>
        ///Saves a Dianostic Action to a Matrix Version
        /// </summary>
        /// <param name="postParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("ConfAggrDiagnosticActionMtxReportPost")]
        [ResponseType(typeof(List<ConfAggrDiagnosticActionMtxReportJsonPostModel>))]
        public async Task<IHttpActionResult> ConfAggrDiagnosticActionMtxReportJsonPostAsync([FromBody] List<VetDiagnosisInvestigationMtxReportPostParams> postParams)
        {
            log.Info("Entering  ConfAggrDiagnosticActionMtxReportJsonPostAsync");
            APIReturnResult returnResult = new APIReturnResult();
            List<ConfAggrDiagnosticActionMtxReportJsonPostModel> result = new List<ConfAggrDiagnosticActionMtxReportJsonPostModel>();
            try
            {

                result = await _repository.ConfAggrDiagnosticActionMtxReportJsonPostAsync(
                                      postParams[0].idfAggrDiagnosticActionMTX,
                                      postParams[0].idfVersion,
                                      JsonConvert.SerializeObject(postParams)
                                  );

                if (result == null)
                {
                    returnResult.ErrorMessage = "The API was reached, but there is a  retrieving data from the data reporistory: " + HttpStatusCode.BadRequest.ToString();
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
                log.Error("Error in ConfAggrDiagnosticActionMtxReportJsonPostAsync: Proc:" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;

            }
            catch (System.Exception ex)
            {
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
                log.Error("Error in ConfAggrDiagnosticActionMtxReportJsonPostAsync: " + ex.Message);

            }
            log.Info("Exiting  ConfAggrDiagnosticActionMtxReportJsonPostAsync");
            return Json(returnResult);
        }


        /// <summary>
        /// Returns a list of Vet Diagnosis Invesitgation Matrix Report  Configurations
        /// </summary>
        /// <param name="idfVersion"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        ///
        [HttpGet, Route("ConfAdminVetDiagnosisInvesitgationMatrixReportGet")]
        [ResponseType(typeof(List<ConfAdminVetDiagnosisInvesitgationMatrixReportGetModel>))]
        public async Task<IHttpActionResult> ConfAdminVetDiagnosisInvesitgationMatrixReportGetAsync(long? idfVersion = null)
        {
            APIReturnResult returnResult = new APIReturnResult();

            try
            {

                log.Info("Entering  ConfAdminVetDiagnosisInvesitgationMatrixReportGetAsync");
                var result = await _repository.ConfAdminVetDiagnosisInvesitgationMatrixReportGetAsync(idfVersion);
                if (result == null)
                {
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
                log.Error("Error in ConfAdminVetDiagnosisInvesitgationMatrixReportGetAsync: Proc:" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;

            }
            catch (System.Exception ex)
            {
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
                log.Error("Error in ConfAdminVetDiagnosisInvesitgationMatrixReportGetAsync: " + ex.Message);

            }
            log.Info("Exiting  ConfAdminVetDiagnosisInvesitgationMatrixReportGetAsync");
            return Json(returnResult);
        }

        #endregion



        /// <summary>
        /// Fetches the current API version.
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpGet, Route("API_Version")]
        public IHttpActionResult Version()
        {
            // Get the EIDSS.Client assembly...
            var asm = System.Reflection.Assembly.GetAssembly(typeof(CrossCuttingServiceClient));
            var result = asm.GetName().Version.ToString();

            return Ok(result);
        }

    }
}
