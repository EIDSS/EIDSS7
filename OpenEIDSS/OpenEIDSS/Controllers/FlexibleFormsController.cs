using Newtonsoft.Json;
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
    /// Provides Flexible Forms functionality.
    /// </summary>
    [RoutePrefix("api/FlexibleForms")]
    public class FlexibleFormsController : ApiController
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(FlexibleFormsController));
        private IEIDSSRepository _repository = new EIDSSRepository();


        /// <summary>
        /// Instantiates a new instance of this class.
        /// </summary>
        public FlexibleFormsController()
        {
        }

        #region Common
        /// <summary>
        /// Get HA Code List.
        /// </summary>
        /// <param name="idfsCodeName"></param>
        /// <param name="intHaCode"></param>
        /// <param name="langId"></param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFActivityParameters objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFHaCodeListAsync")]
        [ResponseType(typeof(List<AdminFfHaCodeListGetModel>))]
        public async Task<IHttpActionResult> GetFFHaCodeListAsync(string langId, long? intHaCode, long? idfsCodeName)
        {
            log.Info("FlexibleForm HaCode is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfHaCodeListGetAsync(langId, intHaCode, idfsCodeName);
                if (result == null)
                {
                    log.Info("Exiting  FlexibleForm HaCode With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                }
                //if (result == null)
                //    return NotFound();

                //log.Info("FlexibleForm GetActivityParameters returned");
                //return Ok<List<AdminFfHaCodeListGetModel>>(result);
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in FlexibleForm HaCode Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in FlexibleForm HaCode" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  FlexibleForm HaCode");
            return Ok(returnResult);
        }



        /// <summary>
        /// Get Predefined Stub List.
        /// </summary>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFActivityParameters objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFPredefinedStubAsync")]
        [ResponseType(typeof(List<AdminFfPredefinedStubGetModel>))]
        public async Task<IHttpActionResult> GetFFPredefinedStubAsync(long? matrixId, string versionList, string langId, long? idfsFormTemplate)
        {
            log.Info("FlexibleForm GetPredefinedStub is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfPredefinedStubGetAsync(matrixId, versionList, langId, idfsFormTemplate);
                if (result == null)
                {
                    log.Info(" GetPredefinedStub Not Found");
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
            catch (Exception ex)
            {
                log.Error("Error in GetFFObservationAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetPredefined Stub");
            return Ok(returnResult);
        }




        /// <summary>
        /// Get Observations List for current template.
        /// </summary>
        /// <param name="observationList"> observationList string</param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFObservationList objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFObservationAsync")]
        [ResponseType(typeof(List<AdminFfObservationsGetModel>))]
        public async Task<IHttpActionResult> GetFFObservationAsync(string observationList)
        {
            log.Info("FlexibleForm Get Label is called with following parameters:" + observationList + " as observationList");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfObservationsGetAsync(observationList);
                if (result == null)
                {
                    log.Info(" GetFFObservationAsync  Not Found");
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
                log.Error("SQL Error in GetFFObservationAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFObservationAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFObservationAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get Labels List for current template.
        /// </summary>
        /// <param name="idfsFormTemplate">Long type of idfsFormTemplate value</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFLabels objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFLabelAsync")]
        [ResponseType(typeof(List<AdminFfLabelsGetModel>))]
        public async Task<IHttpActionResult> GetFFLabelAsync(long? idfsFormTemplate, string languageId)
        {
            log.Info("FlexibleForm Get Label is called with following parameters:" + idfsFormTemplate + " as idfsFormTemplate, " + languageId + " as LanguageID");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfLabelsGetAsync(languageId, idfsFormTemplate);

                if (result == null)
                {
                    log.Info(" GetFFLabelAsync  Not Found");
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
                log.Error("SQL Error in GetFFLabelAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFLabelAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFLabelAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get FF Lines for current template.
        /// </summary>
        /// <param name="idfsFormTemplate">Long type of idfsFormTemplate value</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFHACodeType objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFLinesAsync")]
        [ResponseType(typeof(List<AdminFfLinesGetModel>))]
        public async Task<IHttpActionResult> GetFFLinesAsync(long? idfsFormTemplate, string languageId)
        {
            log.Info("FlexibleForm Get Lines is called with following parameters:" + idfsFormTemplate + " as idfsFormTemplate, " + languageId + " as LanguageID");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfLinesGetAsync(languageId, idfsFormTemplate);
                if (result == null)
                {
                    log.Info("Exiting  GetFFLinesAsync With Not Found");
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
                log.Error("SQL Error in GetFFLinesAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFLinesAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFLinesAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get Observations List.
        /// </summary>
        /// <param name="observationList"></param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFActivityParameters objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFObservationsAsync")]
        [ResponseType(typeof(List<AdminFfObservationsGetModel>))]
        public async Task<IHttpActionResult> GetFFObservationsAsync(string observationList)
        {
            log.Info("FlexibleForm GetFFObservationsAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfObservationsGetAsync(observationList);
                if (result == null)
                {
                    log.Info("Exiting  GetFFObservationsAsync With Not Found");
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
                log.Error("SQL Error in GetFFObservationsAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFObservationsAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFObservationsAsync");
            return Ok(returnResult);
        }


        #endregion

        #region Determinants 

        /// <summary>
        /// Get Template Determinant Values List.
        /// </summary>
        /// <param name="langId"></param>
        /// <param name="idfsFormTemplate"></param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFActivityParameters objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFTemplateDeterminantValuesAsync")]
        [ResponseType(typeof(List<AdminFfTemplateDeterminantValuesGetModel>))]
        public async Task<IHttpActionResult> GetFFTemplateDeterminantValuesAsync(string langId, long? idfsFormTemplate)
        {
            log.Info("FlexibleForm GetFFTemplateDeterminantValuesAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfTemplateDeterminantValuesGetAsync(langId, idfsFormTemplate);
                if (result == null)
                {
                    log.Info("Exiting  GetFFTemplateDeterminantValuesAsync With Not Found");
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
                log.Error("SQL Error in GetFFTemplateDeterminantValuesAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFTemplateDeterminantValuesAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFTemplateDeterminantValuesAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Get Determinants for the Template.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFDeterminants objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFDeterminantsAsync")]
        [ResponseType(typeof(List<AdminFfDeterminantsGetModel>))]
        public async Task<IHttpActionResult> GetFFDeterminantsAsync(string languageId)
        {
            log.Info("FlexibleForm Get Determinants is called with following parameters:" + languageId + " as LanguageID");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfDeterminantsGetAsync(languageId);
                if (result == null)
                {
                    log.Info("Exiting  GetFFDeterminantsAsync With Not Found");
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
                log.Error("SQL Error in GetFFDeterminantsAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFDeterminantsAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFDeterminantsAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get Determinant Types for the Template.
        /// </summary>
        /// <param name="idfsFormType">Long type of idfsFormType Id</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFDeterminantTypes objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFDeterminantTypesAsync")]
        [ResponseType(typeof(List<AdminFfDeterminantTypesGetModel>))]
        public async Task<IHttpActionResult> GetFFDeterminantTypesAsync(long? idfsFormType, string languageId)
        {
            log.Info("FlexibleForm Get DeterminantTypes is called with following parameters:" + idfsFormType + " as idfsFormType, " + languageId + " as LanguageID");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfDeterminantTypesGetAsync(idfsFormType, languageId);
                if (result == null)
                {
                    log.Info("Exiting  GetFFDeterminantTypesAsync With Not Found");
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
                log.Error("SQL Error in GetFFDeterminantTypesAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFDeterminantTypesAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFDeterminantTypesAsync");
            return Ok(returnResult);
        }

        #endregion

        #region Parameter

        /// <summary>
        /// Get Parameter Editors List.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFActivityParameters objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>
        [HttpGet, Route("FFParameterEditorsAsync")]
        [ResponseType(typeof(List<AdminFfParameterEditorsGetModel>))]
        public async Task<IHttpActionResult> GetFFParameterEditorsAsync(string languageId)
        {
            log.Info("FlexibleForm AdminFfParameterEditorsGetAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfParameterEditorsGetAsync(languageId);
                if (result == null)
                {
                    log.Info("Exiting  GetFFParameterEditorsAsync With Not Found");
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
                log.Error("SQL Error in GetFFParameterEditorsAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFParameterEditorsAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFParameterEditorsAsync");
            return Ok(returnResult);
        }


        /*
        /// <summary>
        /// Get Parameter Editor for the current Template .
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFParameterEditor objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>
        //[HttpGet, Route("FFParameterEditorsAsync")]
        //[ResponseType(typeof(List<AdminFfParameterEditorsGetModel>))]
        //public async Task<IHttpActionResult> GetFFParameterEditorAsync(string languageId)
        //{
        //    log.Info("FlexibleForm Get Parameter Editor is called with following parameters:" + languageId + " as languageId, ");
        //    APIReturnResult returnResult = new APIReturnResult();
        //    try
        //    {
        //        var result = await this._repository.AdminFfParameterEditorsGetAsync(languageId);
        //        if (result == null)
        //        {
        //            log.Info("Exiting  GetFFParameterEditorAsync With Not Found");
        //            returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
        //            returnResult.ErrorCode = HttpStatusCode.BadRequest;
        //        }
        //        else
        //        {
        //            returnResult.ErrorCode = HttpStatusCode.OK;
        //            returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
        //            returnResult.Results = JsonConvert.SerializeObject(result);
        //        }
        //    }
        //    catch (SqlException ex)
        //    {
        //        log.Error("SQL Error in GetFFParameterEditorAsync Procedure: " + ex.Procedure, ex);
        //        returnResult.ErrorMessage = ex.Message;
        //        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        //    }
        //    catch (Exception ex)
        //    {
        //        log.Error("Error in GetFFParameterEditorAsync" + ex.Message, ex);
        //        returnResult.ErrorMessage = ex.Message;
        //        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        //    }
        //    log.Info("Exiting  GetFFParameterEditorAsync");
        //    return Ok(returnResult);
        //}
        */


        /// <summary>
        /// Get Parameters for the current Template .
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsSection">idfsSection Section ID</param>
        /// <param name="idfsFormType">idfsFormType Form Type ID</param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFParameters objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFParametersAsync")]
        [ResponseType(typeof(List<AdminFfParametersGetModel>))]
        public async Task<IHttpActionResult> GetFFParametersAsync(string languageId, long? idfsSection, long? idfsFormType)
        {
            log.Info("FlexibleForm Get Parameters is called with following parameters:" + languageId + " as languageId, " + idfsSection + " as idfsSection, " + idfsFormType + " as idfsFormType, ");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfParametersGetAsync(languageId, idfsSection, idfsFormType);
                if (result == null)
                {
                    log.Info("Exiting  GetFFParametersAsync With Not Found");
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
                log.Error("SQL Error in GetFFParametersAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFParametersAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFParametersAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get Parameters Select List Simple for the current Template .
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsParameter">idfsParameter Parameter ID</param>
        /// <param name="idfsParameterType">idfsParameterType Type ID</param>
        /// <param name="intHaCode">intHACode for the Param</param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFParametersSelectList objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFParametersSelectListAsync")]
        [ResponseType(typeof(List<AdminFfParameterSelectListGetModel>))]
        public async Task<IHttpActionResult> GetFFParametersSelectListAsync(string languageId, long? idfsParameter, long? idfsParameterType, long? intHaCode)
        {
            log.Info("FlexibleForm Parameters Select List is called with following parameters:" + languageId + " as languageId, " + idfsParameter + " as idfsParameter, " + idfsParameterType + " as idfsParameterType, " + intHaCode + " as intHACode ");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfParameterSelectListGetAsync(languageId, idfsParameter, idfsParameterType, intHaCode);
                if (result == null)
                {
                    log.Info("Exiting  GetFFParametersSelectListAsync With Not Found");
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
                log.Error("SQL Error in GetFFParametersSelectListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFParametersSelectListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFParametersSelectListAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Get Parameters Select List Simple for the current Template .
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsParameterType">idfsParameterType Type ID</param>
        /// <param name="idfsFormType">idfsFormType Form Type ID</param>
        /// <param name="intHaCode">intHACode for the Param</param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFParametersSelectListSimple objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFParametersSelectListSimpleAsync")]
        [ResponseType(typeof(List<AdminFfParameterSelectListSimpleGetModel>))]
        public async Task<IHttpActionResult> GetFFParametersSelectListSimpleAsync(string languageId, long? idfsParameterType, long? idfsFormType, long? intHaCode)
        {
            log.Info("FlexibleForm Get Parameters is called with following parameters:" + languageId + " as languageId, " + idfsParameterType + " as idfsParameterType, " + idfsFormType + " as idfsFormType, " + intHaCode + " as intHACode ");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfParameterSelectListSimpleGetAsync(languageId, idfsParameterType, idfsFormType, intHaCode);
                if (result == null)
                {
                    log.Info("Exiting  GetFFParametersSelectListSimpleAsync With Not Found");
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
                log.Error("SQL Error in GetFFParametersSelectListSimpleAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFParametersSelectListSimpleAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFParametersSelectListSimpleAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Get Parameters Search for the current Template .
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="strSearch">string to be searched for </param>
        /// <param name="strSearchSection"> section to be searched in</param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFParameterSearch objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFParametersSearchAsync")]
        [ResponseType(typeof(List<AdminFfParametersSearchGetModel>))]
        public async Task<IHttpActionResult> GetFFParametersSearchAsync(string languageId, string strSearch, string strSearchSection)
        {
            log.Info("FlexibleForm Parameters Search from Template List is called with following parameters:" + languageId + " as languageId, " + strSearch + " as strSearch, " + strSearchSection + " as strSearchSection ");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfParametersSearchGetAsync(languageId, strSearch, strSearchSection);
                if (result == null)
                {
                    log.Info("Exiting  GetFFParametersSearchAsync With Not Found");
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
                log.Error("SQL Error in GetFFParametersSearchAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFParametersSearchAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFParametersSearchAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Get Activity Parameters List.
        /// </summary>
        /// <param name="observationList"> observationList string</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFActivityParameters objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFActivityParametersAsync")]
        [ResponseType(typeof(List<AdminFfActivityParametersGetModel>))]

        public async Task<IHttpActionResult> GetFFActivityParametersAsync(string observationList, string languageId)
        {
            log.Info("FlexibleForm GetActivityParameters is called with following parameters:" + observationList + " as Observation list, " + languageId + " as languageId");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfActivityParametersGetAsync(observationList, languageId);
                if (result == null)
                {
                    log.Info("Exiting  GetFFActivityParametersAsync With Not Found");
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
                log.Error("SQL Error in GetFFActivityParametersAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFActivityParametersAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFActivityParametersAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get Activity Parameters List.
        /// </summary>
        /// <param name="idfActivityParameters">This is always NULL - it was a OUT parameter before</param>
        /// <param name="idfRow"> This is always NULL - it was a OUT parameter before</param>
        /// <param name="idfsParameter">Parameter ID</param>
        /// <param name="idfObservation">Observation ID that is created when Human Case for this template is created.</param>
        /// <param name="idfsFormTemplate">idfsFormTemplate is the template input</param>
        /// <param name="isDynamicParameter">Boolean: is it a dynamic parameter ( We have yet to enable Dynamic parameters )</param>
        /// <param name="varValue">Not sure what this is - research TODO: Kishore Kodru</param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFActivityParameters objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpPost, Route("FFSetActivityParametersAsync")]
        [ResponseType(typeof(List<AdminFfActivityParametersSetModel>))]

        public async Task<IHttpActionResult> SetFFActivityParametersAsync(AdminFfSetActivityParameters parameters)
        {
            log.Info("FlexibleForm SetActivityParameters is called ");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfActivityParametersSetAsync(parameters.idfsParameter, parameters.idfObservation, parameters.idfsFormTemplate, parameters.varValue, parameters.isDynamicParameter, parameters.idfRow, parameters.idfActivityParameters);
                if (result == null)
                {
                    log.Info("Exiting  SetFFActivityParametersAsync With Not Found");
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
                log.Error("SQL Error in SetFFActivityParametersAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in SetFFActivityParametersAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  SetFFActivityParametersAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get Activity Parameters List.
        /// </summary>
        /// <param name="idfRow"> This is always NULL - it was a OUT parameter before</param>
        /// <param name="idfsParameter">Parameter ID</param>
        /// <param name="idfObservation">Observation ID that is created when Human Case for this template is created.</param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFActivityParameters objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpDelete, Route("FFDelActivityParametersAsync")]
        [ResponseType(typeof(List<AdminFfActivityParametersDelModel>))]
        public async Task<IHttpActionResult> DeleteFFActivityParametersAsync(long idfsParameter, long idfObservation, long idfRow)
        {
            log.Info("FlexibleForm DeleteActivityParameters is called ");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfActivityParametersDelAsync(idfsParameter, idfObservation, idfRow);
                if (result == null)
                {
                    log.Info("Exiting  DeleteActivityParameters With Not Found");
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
                log.Error("SQL Error in DeleteActivityParameters Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in DeleteActivityParameters" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  DeleteActivityParameters");
            return Ok(returnResult);
        }

        #endregion

        #region Rules

        /// <summary>
        /// Get Rule Constant List.
        /// </summary>
        /// <param name="idfsRule"></param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFActivityParameters objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFRuleConstantAsync")]
        [ResponseType(typeof(List<AdminFfRuleConstantGetModel>))]
        public async Task<IHttpActionResult> GetFFRuleConstantAsync(long? idfsRule)
        {
            log.Info("FlexibleForm GetFFRuleConstantAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfRuleConstantGetAsync(idfsRule);
                if (result == null)
                {
                    log.Info("Exiting  GetFFRuleConstantAsync With Not Found");
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
                log.Error("SQL Error in GetFFRuleConstantAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFRuleConstantAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFRuleConstantAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Get Rule Parameter For Action List.
        /// </summary>
        /// <param name="idfsRule"></param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFActivityParameters objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFRuleParameterForActionAsync")]
        [ResponseType(typeof(List<AdminFfRuleParameterForActionGetModel>))]
        public async Task<IHttpActionResult> GetFFRuleParameterForActionAsync(long? idfsRule)
        {
            log.Info("FlexibleForm AdminFfRuleParameterForActionGetAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfRuleParameterForActionGetAsync(idfsRule);
                if (result == null)
                {
                    log.Info("Exiting  GetFFRuleParameterForActionAsync With Not Found");
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
                log.Error("SQL Error in GetFFRuleParameterForActionAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFRuleParameterForActionAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFRuleParameterForActionAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get Rule Functions List.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="count"></param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFActivityParameters objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFRuleFunctionsAsync")]
        [ResponseType(typeof(List<AdminFfRuleFunctionsGetModel>))]
        public async Task<IHttpActionResult> GetFFRuleFunctionsAsync(int? count, string languageId)
        {
            log.Info("FlexibleForm AdminFfRuleFunctionsGetAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfRuleFunctionsGetAsync(count, languageId);
                if (result == null)
                {
                    log.Info("Exiting  GetFFRuleFunctionsAsync With Not Found");
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
                log.Error("SQL Error in GetFFRuleFunctionsAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFRuleFunctionsAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFRuleFunctionsAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get Rule Parameter For Function List.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfRule"></param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFActivityParameters objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFRuleParameterForFunctionAsync")]
        [ResponseType(typeof(List<AdminFfRuleParameterForFunctionGetModel>))]
        public async Task<IHttpActionResult> GetFFRuleParameterForFunctionAsync(string languageId, long? idfRule)
        {
            log.Info("FlexibleForm GetFFRuleParameterForFunctionAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfRuleParameterForFunctionGetAsync(languageId, idfRule);
                if (result == null)
                {
                    log.Info("Exiting  GetFFRuleParameterForFunctionAsync With Not Found");
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
                log.Error("SQL Error in GetFFRuleParameterForFunctionAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFRuleParameterForFunctionAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFRuleParameterForFunctionAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get Rules for current template.
        /// </summary>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of FFObservationList objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("FFRulesAsync")]
        [ResponseType(typeof(List<AdminFfRulesGetModel>))]
        public async Task<IHttpActionResult> GetFFRulesAsync(string langId, long? idfsFormTemplate)
        {
            log.Info("FlexibleForm Get Rules for Template is called with following parameters:" + idfsFormTemplate + " as idfsFormTemplate and langID");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfRulesGetAsync(langId, idfsFormTemplate);
                if (result == null)
                {
                    log.Info("Exiting  GetFFRulesAsync With Not Found");
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
                log.Error("SQL Error in GetFFRulesAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFRulesAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFRulesAsync");
            return Ok(returnResult);
        }

        #endregion

        #region Section

        /// <summary>
        /// Get List of Sections.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsFormType"> idfsFormType key</param>
        /// <param name="idfsSection"> idfsSection key</param>
        /// <param name="idfsParentSection"> idfsParentSection key</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>

        [HttpGet, Route("FFSectionsAsync")]
        [ResponseType(typeof(List<AdminFfSectionsGetModel>))]
        public async Task<IHttpActionResult> GetFFSectionsAsync(string languageId, long? idfsFormType, long? idfsSection, long? idfsParentSection)
        {
            log.Info("FlexibleForm Section is called with following parameters:" + languageId + " as languageId, " + idfsFormType + " as idfsFormType" + idfsSection + " as idfsSection" + idfsParentSection + " as idfsParentSection");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfSectionsGetAsync(languageId, idfsFormType, idfsSection, idfsParentSection);
                if (result == null)
                {
                    log.Info("Exiting  GetFFSectionsAsync With Not Found");
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
                log.Error("SQL Error in GetFFSectionsAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFSectionsAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFSectionsAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Get List of Sections with in a Template.
        /// </summary>
        /// <param name="idfsSection"> idfsSection key</param>
        /// <param name="idfsFormTemplate"> idfsFormTemplate key</param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>

        [HttpGet, Route("FFSectionTemplateAsync")]
        [ResponseType(typeof(List<AdminFfSectionTemplateGetModel>))]
        public async Task<IHttpActionResult> GetFFSectionTemplateAsync(long? idfsSection, long? idfsFormTemplate, string languageId)
        {
            log.Info("FlexibleForm Section Templates is called with following parameters:" + languageId + " as languageId, " + idfsFormTemplate + " as idfsFormTemplate" + idfsSection + " as idfsSection");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfSectionTemplateGetAsync(idfsSection, idfsFormTemplate, languageId);
                if (result == null)
                {
                    log.Info("Exiting  GetFFSectionTemplateAsync With Not Found");
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
                log.Error("SQL Error in GetFFSectionTemplateAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFSectionTemplateAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFSectionTemplateAsync");
            return Ok(returnResult);
        }





        /// <summary>
        /// Returns Flexible Forms  Parent Sections
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfsSection"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("AdminFFGetParentSectionsAsync")]
        [ResponseType(typeof(List<AdminFfParentSectionsGetModel>))]
        public async Task<IHttpActionResult> AdminFfParentSectionsGetAsync(string languageId, long? idfsSection)
        {
            log.Info("Starting  AdminFfParentSectionsGetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfParentSectionsGetAsync(idfsSection, languageId);
                if (result == null)
                {
                    log.Info("Exiting  AdminFfParentSectionsGetAsync With Not Found");
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
                log.Error("SQL Error in AdminFfParentSectionsGetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in AdminFfParentSectionsGetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  AdminFfParentSectionsGetAsync");
            return Ok(returnResult);
        }

        #endregion

        #region Template

        /// <summary>
        /// Get Form Template List.
        /// </summary>
        /// <param name="idfsDiagnosis"></param>
        /// <param name="idfsFormType"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>

        [HttpGet, Route("FFFormTemplateAsync")]
        [ResponseType(typeof(List<AdminFfFormTemplateGetModel>))]
        public async Task<IHttpActionResult> GetFFFormTemplateAsync(long? idfsDiagnosis, long? idfsFormType)
        {
            log.Info("FlexibleForm GetActivityParameters is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfFormTemplateGetAsync(idfsDiagnosis, idfsFormType);
                if (result == null)
                {
                    log.Info("Exiting  GetFFFormTemplateAsync With Not Found");
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
                log.Error("SQL Error in GetFFFormTemplateAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFFormTemplateAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFFormTemplateAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get Parameter Types Get List.
        /// </summary>
        /// <param name="langId"></param>
        /// <param name="idfsParameterType"></param>
        /// <param name="onlyLists"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>

        [HttpGet, Route("FFParameterTypesGetListAsync")]
        [ResponseType(typeof(List<AdminFfParameterTypesGetListModel>))]
        public async Task<IHttpActionResult> GetFFParameterTypesGetListAsync(string langId, long? idfsParameterType, bool? onlyLists)
        {
            log.Info("FlexibleForm GetFFParameterTypesGetListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfParameterTypesGetListAsync(langId, idfsParameterType, onlyLists);
                if (result == null)
                {
                    log.Info("Exiting  GetFFParameterTypesGetListAsync With Not Found");
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
                log.Error("SQL Error in GetFFParameterTypesGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFParameterTypesGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFParameterTypesGetListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get Parameter Reference Type being used.
        /// </summary>
        /// <param name="langId"> langId </param>
        /// <param name="idfsParameterType"></param>
        /// <param name="onlyLists"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("FFGetParameterReferenceType")]
        [ResponseType(typeof(List<FfGetParameterReferenceTypeModel>))]
        public IHttpActionResult GetFFParameterReferenceType(string langId, long? idfsParameterType, bool? onlyLists)
        {
            log.Info("GetFFParameterReferenceType is called with following parameters:" + langId + " as langId, " + idfsParameterType + " as idfsParameterType, " + onlyLists + " as onlyLists");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = _repository.FfGetParameterReferenceType(langId, idfsParameterType, onlyLists);
                if (result == null)
                {
                    log.Info("Exiting  GetFFParameterReferenceType With Not Found");
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
                log.Error("SQL Error in GetFFParameterReferenceType Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFParameterReferenceType" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFParameterReferenceType");
            return Ok(returnResult);
        }
        /// <summary>
        /// Get Parameter Deleted From Template Get List.
        /// </summary>
        /// <param name="langId"></param>
        /// <param name="idfObservation"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>

        [HttpGet, Route("FFParametersDeletedFromTemplateAsync")]
        [ResponseType(typeof(List<AdminFfParametersDeletedFromTemplateGetModel>))]
        public async Task<IHttpActionResult> GetFFParametersDeletedFromTemplateAsync(long? idfObservation, string langId)
        {
            log.Info("FlexibleForm Parameters Deleted From Template is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfParametersDeletedFromTemplateGetAsync(idfObservation, langId);
                if (result == null)
                {
                    log.Info("Exiting  GetFFParameterTypesGetListAsync With Not Found");
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
                log.Error("SQL Error in GetFFParameterTypesGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFParameterTypesGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFParameterTypesGetListAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get List of Templates .
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsFormTemplate"> idfsFormTemplate key</param>
        /// <param name="idfsFormType"> idfsFormType key</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>

        [HttpGet, Route("FFTemplatesAsync")]
        [ResponseType(typeof(List<AdminFfTemplatesGetModel>))]
        public async Task<IHttpActionResult> GetFFTemplatesAsync(string languageId, long? idfsFormTemplate, long? idfsFormType)
        {
            log.Info("FlexibleForm Templates is called with following parameters:" + languageId + " as languageId, " + idfsFormTemplate + " as idfsFormTemplate" + idfsFormType + " as idfsFormType");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfTemplatesGetAsync(languageId, idfsFormTemplate, idfsFormType);
                if (result == null)
                {
                    log.Info("Exiting  GetFFTemplatesAsync With Not Found");
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
                log.Error("SQL Error in GetFFTemplatesAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFTemplatesAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFTemplatesAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get Template Determinant value.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsFormTemplate"> idfsFormTemplate key</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>

        [HttpGet, Route("FFTemplateDeterminantsAsync")]
        [ResponseType(typeof(List<AdminFfTemplateDeterminantValuesGetModel>))]
        public async Task<IHttpActionResult> GetFFTemplateDeterminantsAsync(string languageId, long? idfsFormTemplate)
        {
            log.Info("FlexibleForm Template Determinants is called with following parameters:" + languageId + " as languageId, " + idfsFormTemplate + " as idfsFormTemplate");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfTemplateDeterminantValuesGetAsync(languageId, idfsFormTemplate);
                if (result == null)
                {
                    log.Info("Exiting  GetFFTemplateDeterminantsAsync With Not Found");
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
                log.Error("SQL Error in GetFFTemplateDeterminantsAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFTemplateDeterminantsAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFTemplateDeterminantsAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get List of Parameters by Templates .
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsFormTemplate"> idfsFormTemplate key</param>
        /// <param name="idfsParameter"> idfsFormType key</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>

        [HttpGet, Route("FFParameterTemplatesAsync")]
        [ResponseType(typeof(List<AdminFfParameterTemplateGetModel>))]
        public async Task<IHttpActionResult> GetFFParameterTemplatesAsync(long? idfsParameter, long? idfsFormTemplate, string languageId)
        {
            log.Info("FlexibleForm Parameter Templates is called with following parameters:" + languageId + " as languageId, " + idfsFormTemplate + " as idfsFormTemplate" + idfsParameter + " as idfsParameter");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfParameterTemplateGetAsync(idfsParameter, idfsFormTemplate, languageId);
                if (result == null)
                {
                    log.Info("Exiting  GetFFParameterTemplatesAsync With Not Found");
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
                log.Error("SQL Error in GetFFParameterTemplatesAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFParameterTemplatesAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFParameterTemplatesAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get Current Form Template .
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsParameter"> idfs Parameter key</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>

        [HttpGet, Route("FFTemplateByParameterAsync")]
        [ResponseType(typeof(List<AdminFfTemplatesByParameterGetModel>))]
        public async Task<IHttpActionResult> GetFFTemplateByParameterAsync(string languageId, long? idfsParameter)
        {
            log.Info("FlexibleForm Templates By Parameter is called with following parameters:" + languageId + " as languageId, " + idfsParameter + " as idfsParameter");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfTemplatesByParameterGetAsync(languageId, idfsParameter);
                if (result == null)
                {
                    log.Info("Exiting  GetFFTemplateByParameterAsync With Not Found");
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
                log.Error("SQL Error in GetFFTemplateByParameterAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFTemplateByParameterAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFTemplateByParameterAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get Current Form Template .
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsFormType"> idfsFormType key</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>

        [HttpGet, Route("FFFormTypeAsync")]
        [ResponseType(typeof(List<AdminFfFormTypesGetModel>))]
        public async Task<IHttpActionResult> GetFFFormTypeAsync(string languageId, long? idfsFormType)
        {
            log.Info("FlexibleForm Get Form Type is called with following parameters:" + languageId + " as languageId, " + idfsFormType + " as idfsFormType");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfFormTypesGetAsync(languageId, idfsFormType);
                if (result == null)
                {
                    log.Info("Exiting  GetFFFormTypeAsync With Not Found");
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
                log.Error("SQL Error in GetFFFormTypeAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFFormTypeAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFFormTypeAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Get Current Form Template .
        /// </summary>
        /// <param name="idfsDiagnosis"> idfsDiagnosis key</param>
        /// <param name="idfsFormType"> idfsFormType key</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>

        [HttpGet, Route("FFFormTemplateAsync")]
        [ResponseType(typeof(List<AdminFfFormTemplateGetModel>))]
        public async Task<IHttpActionResult> GetFFActualTemplateAsync(long? idfsDiagnosis, long? idfsFormType)
        {
            log.Info("GetFFActualTemplateAsync Get Actual Template is called with following parameters:" + idfsDiagnosis + " as idfsDiagnosis, " + idfsFormType + " as idfsFormType");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfFormTemplateGetAsync(idfsDiagnosis, idfsFormType);
                if (result == null)
                {
                    log.Info("Exiting  GetFFActualTemplateAsync With Not Found");
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
                log.Error("SQL Error in GetFFActualTemplateAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFActualTemplateAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFActualTemplateAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get Actual Template being used.
        /// </summary>
        /// <param name="idfsGisBaseReference"> idfsGisBaseReference key</param>
        /// <param name="blnReturnTable"></param>
        /// <param name="idfsBaseReference"></param>
        /// <param name="idfsFormType"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>

        [HttpGet, Route("FFActualTemplateAsync")]
        [ResponseType(typeof(List<AdminFfActualTemplateGetModel>))]
        public async Task<IHttpActionResult> GetFFActualTemplateAsync(long? idfsGisBaseReference, long? idfsBaseReference, long? idfsFormType, bool blnReturnTable)
        {
            log.Info("GetFFActualTemplateAsync Template is called with following parameters:" + idfsGisBaseReference + " as idfsGisBasereference, " + idfsBaseReference + " as idfsBasereference, " + idfsFormType + " as idfsFormType");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfActualTemplateGetAsync(idfsGisBaseReference, idfsBaseReference, idfsFormType, blnReturnTable);
                if (result == null)
                {
                    log.Info("Exiting  GetFFActualTemplateAsync With Not Found");
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
                log.Error("SQL Error in GetFFActualTemplateAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetFFActualTemplateAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetFFActualTemplateAsync");
            return Ok(returnResult);
        }


        #endregion

        #region Aggregate Matrix

        /// <summary>
        /// Returns Flexible Forms Aggregate Matrix
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfMatrix"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("AdminFFGetAggregateMatrix")]
        [ResponseType(typeof(List<AdminFfSectionTemplateGetModel>))]
        public async Task<IHttpActionResult> AdminFfAggregateMatrixVersionGetListAsync(string languageId, long? idfMatrix)
        {
            log.Info("Starting  AdminFfAggregateMatrixVersionGetListAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfAggregateMatrixVersionGetListAsync(languageId, idfMatrix);
                if (result == null)
                {
                    log.Info("Exiting  AdminFfAggregateMatrixVersionGetListAsync With Not Found");
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
                log.Error("SQL Error in AdminFfAggregateMatrixVersionGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in AdminFfAggregateMatrixVersionGetListAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  AdminFfAggregateMatrixVersionGetListAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Returns Flexible Forms  Current Aggregate Matrix Version
        /// </summary>
        /// <param name="idfMatrixType"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("AdminFFGetCurrentAggregateMatrixVersion")]
        [ResponseType(typeof(List<AdminFfCurrentMatrixVersionGetModel>))]
        public async Task<IHttpActionResult> AdminFfCurrentMatrixVersionGetAsync(long idfMatrixType)
        {
            log.Info("Starting  AdminFfCurrentMatrixVersionGetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfCurrentMatrixVersionGetAsync(idfMatrixType);
                if (result == null)
                {
                    log.Info("Exiting  AdminFfCurrentMatrixVersionGetAsync With Not Found");
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
                log.Error("SQL Error in AdminFfCurrentMatrixVersionGetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in AdminFfCurrentMatrixVersionGetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  AdminFfCurrentMatrixVersionGetAsync");
            return Ok(returnResult);
        }


        //TODO: POCO ERROR to be fixed. 
        ///// <summary>
        ///// Get Section for aggregate Case List.
        ///// </summary>
        ///// <returns>
        ///// On success a 200 OK status is returned along with a collection of FFActivityParameters objects.
        ///// On failure a 500 Internal Server Error is returned along with details of the failure.
        ///// A 404 Not Found status code is returned when no results could be found.
        ///// </returns>

        //[HttpGet, Route("FFSectionForAggregateCaseAsync")]
        //[ResponseType(typeof(List<AdminffSection>))]
        //public async Task<IHttpActionResult> GetFFSectionForAggregateCaseAsync(long? idfsFormTemplate, long? idfsFormType, out long? idfsSection, out long? idfsMatrixType)
        //{
        //    log.Info("FlexibleForm GetActivityParameters is called");
        //    try
        //    {
        //        var result = await this._repository.AdminFfSectionForAggregateCaseGet(idfsFormTemplate, idfsFormType, idfsSection, idfsMatrixType);

        //        if (result == null)
        //            return NotFound();

        //        log.Info("FlexibleForm GetActivityParameters returned");
        //        return Ok<List<AdminFfSectionForAggregateCaseGetModel>>(result);
        //    }
        //    catch (Exception e)
        //    {
        //        log.Info("FlexibleForm GetActivityParameters failed");
        //        return InternalServerError(e);
        //    }
        //}


        #endregion

        #region Module Specific
        /// <summary>
        /// Returns Flexible Forms  Human Aggregate Matrix
        /// </summary>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("AdminFFGetAggregateHumanCaseMatrixAsync")]
        [ResponseType(typeof(List<AdminFfCurrentMatrixVersionGetModel>))]
        public async Task<IHttpActionResult> AdminFfAggregateHumanCaseMatrixGetAsync()
        {
            log.Info("Starting  AdminFfAggregateHumanCaseMatrixGetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfAggregateHumanCaseMatrixGetAsync();
                if (result == null)
                {
                    log.Info("AdminFfAggregateHumanCaseMatrixGetAsync Not Found");
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
                log.Error("SQL Error in AdminFfAggregateHumanCaseMatrixGetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in AdminFfAggregateHumanCaseMatrixGetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  AdminFfAggregateHumanCaseMatrixGetAsync");
            return Ok(returnResult);
        }

        #endregion




        /// <summary>
        /// Sets Global Observation
        /// </summary>
        /// <param name="gblObservationSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("GlobalObservationSet")]
        [ResponseType(typeof(List<GblObservationSetModel>))]
        public async Task<IHttpActionResult> GlobalObservationSet(GblObservationSetParams gblObservationSetParams)
        {
            log.Info("Starting  GlobalObservationSet");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.GblObservationSetAsync(
                    gblObservationSetParams.idfObservation,
                    gblObservationSetParams.idfsFormTemplate,
                    gblObservationSetParams.intRowStatus,
                    gblObservationSetParams.strMaintenanceFlag,
                    gblObservationSetParams.idfsSite
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
                log.Info("SQL GlobalObservationSet Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("GlobalObservationSet Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  GetAggregateSettingsList");
            return Json(returnResult);
        }






        /// <summary>
        /// Set Activity Parameter Types
        /// </summary>
        /// <param name="parameter"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("AdminFfActivityParametersSetAsync")]
        [ResponseType(typeof(List<AdminFfParameterTypesDelModel>))]
        public async Task<IHttpActionResult> AdminFfActivityParametersSetAsync(AdminFfActivityParametersSetParams parameter)
        {
            log.Info("Starting  AdminFfActivityParametersSetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfActivityParametersSetAsync
                    (parameter.idfsParameter,
                    parameter.idfObservation,
                    parameter.idfsFormTemplate,
                    parameter.varValue,
                    parameter.isDynamicParameter,
                    parameter.idfRow,
                    parameter.idfActivityParameters
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
                log.Info("SQL AdminFfActivityParametersSetAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfActivityParametersSetAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfActivityParametersSetAsync");
            return Json(returnResult);
        }







        /// <summary>
        /// Set Admin Parameters
        /// </summary>
        /// <param name="parameter"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("AdminFfParametersSetAsync")]
        [ResponseType(typeof(List<AdminFfParametersSetModel>))]
        public async Task<IHttpActionResult> AdminFfParametersSetAsync(AdminFfParametersSetParams parameter)
        {
            log.Info("Starting  AdminFfParametersSetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfParametersSetAsync(
                    parameter.idfsSection,
                    parameter.idfsFormType,
                    parameter.intScheme,
                    parameter.idfsParameterType,
                    parameter.idfsEditor,
                    parameter.intHaCode,
                    parameter.intOrder,
                    parameter.strNote,
                    parameter.defaultName,
                    parameter.nationalName,
                    parameter.defaultLongName,
                    parameter.nationalLongName,
                    parameter.langId,
                    parameter.intLeft,
                    parameter.intTop,
                    parameter.intWidth,
                    parameter.intHeight,
                    parameter.intLabelSize
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
                log.Info("SQL AdminFfParametersSetAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfParametersSetAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfParametersSetAsync");
            return Json(returnResult);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="idfsParameter"></param>
        /// <returns></returns>
        [HttpDelete, Route("AdminFfParameterDel")]
        [ResponseType(typeof(List<AdminFfParameterDelModel>))]
        public async Task<IHttpActionResult> AdminFfParameterDel(long idfsParameter)
        {
            log.Info("Starting  AdminFfParameterDel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfParameterDelAsync(idfsParameter);
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
                log.Info("SQL AdminFfParameterDel Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfParameterDel Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfParameterDel");
            return Json(returnResult);
        }































        /// <summary>
        /// Delete Parameter
        /// </summary>
        /// <param name="idfsParameter"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("AdminFfParameterDelAsync")]
        [ResponseType(typeof(List<AdminFfParameterDelModel>))]
        public async Task<IHttpActionResult> AdminFfParameterDelAsync(long idfsParameter)
        {
            log.Info("Starting  AdminFfParameterDelAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfParameterDelAsync(idfsParameter);
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
                log.Info("SQL AdminFfParameterDelAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfParameterDelAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfParameterDelAsync");
            return Json(returnResult);
        }

        /// <summary>
        /// Set Parameter Design Options
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
        [HttpPost, Route("AdminFfParameterDesignOptionsSetAsync")]
        [ResponseType(typeof(List<AdminFfParameterDesignOptionsSetModel>))]
        public async Task<IHttpActionResult> AdminFfParameterDesignOptionsSetAsync(AdminFfParameterDesignOptionsSetParams parameters)
        {
            log.Info("Starting  AdminFfParameterDesignOptionsSetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfParameterDesignOptionsSetAsync(
                    parameters.idfsParameter,
                    parameters.idfsFormTemplate,
                    parameters.intLeft, parameters.intTop,
                    parameters.intWidth,
                    parameters.intHeight,
                    parameters.intScheme,
                    parameters.intLabelSize,
                    parameters.intOrder,
                    parameters.langId
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
                log.Info("SQL AdminFfParameterDesignOptionsSetAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfParameterDesignOptionsSetAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfParameterDesignOptionsSetAsync");
            return Json(returnResult);
        }


        /// <summary>
        /// Delete Fixed Preset 
        /// </summary>
        /// <param name="idfParameterFixedPresetValue"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("AdminFfParameterFixedPresetValueDelAsync")]
        [ResponseType(typeof(List<AdminFfParameterFixedPresetValueDelModel>))]
        public async Task<IHttpActionResult> AdminFfParameterFixedPresetValueDelAsync(long idfParameterFixedPresetValue)
        {
            log.Info("Starting  AdminFfParameterFixedPresetValueDelAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfParameterFixedPresetValueDelAsync(idfParameterFixedPresetValue);
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
                log.Info("SQL AdminFfParameterFixedPresetValueDelAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfParameterFixedPresetValueDelAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfParameterFixedPresetValueDelAsync");
            return Json(returnResult);
        }


        /// <summary>
        /// Set Fixed Preset 
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
        [HttpPost, Route("AdminFfParameterFixedPresetValueSetAsync")]
        [ResponseType(typeof(List<AdminFfParameterFixedPresetValueSetModel>))]
        public async Task<IHttpActionResult> AdminFfParameterFixedPresetValueSetAsync(AdminFfParameterFixedPresetValueSet parameters)
        {
            log.Info("Starting  AdminFfParameterFixedPresetValueSetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfParameterFixedPresetValueSetAsync(parameters.idfsParameterType, parameters.defaultName, parameters.nationalName, parameters.langId, parameters.intOrder, parameters.idfsParameterFixedPresetValue);
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
                log.Info("SQL AdminFfParameterFixedPresetValueSetAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfParameterFixedPresetValueSetAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfParameterFixedPresetValueSetAsync");
            return Json(returnResult);
        }



        /// <summary>
        /// Delete Parameter Template
        /// </summary>
        /// <param name="idfsParameter"></param>
        /// <param name="idfsFormTemplate"></param>
        /// <param name="langId"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("AdminFfParameterTemplateDelAsync")]
        [ResponseType(typeof(List<AdminFfParameterTemplateDelModel>))]
        public async Task<IHttpActionResult> AdminFfParameterTemplateDelAsync(long? idfsParameter, long? idfsFormTemplate, string langId)
        {
            log.Info("Starting  AdminFfParameterTemplateDelAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfParameterTemplateDelAsync(idfsParameter, idfsFormTemplate, langId);
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
                log.Info("SQL AdminFfParameterTemplateDelAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfParameterTemplateDelAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfParameterTemplateDelAsync");
            return Json(returnResult);
        }




        /// <summary>
        /// Set Parameter Template 
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
        [HttpPost, Route("AdminFfParameterTemplateSetAsync")]
        [ResponseType(typeof(List<AdminFfParameterTemplateSetModel>))]
        public async Task<IHttpActionResult> AdminFfParameterTemplateSetAsync(AdminFfParameterTemplateSet parameters)
        {
            log.Info("Starting  AdminFfParameterTemplateSetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfParameterTemplateSetAsync(
                    parameters.idfsParameter,
                    parameters.idfsFormTemplate,
                    parameters.langId,
                    parameters.idfsEditMode,
                    parameters.intLeft,
                    parameters.intTop,
                    parameters.intWidth,
                    parameters.intHeight,
                    parameters.intScheme,
                    parameters.intLabelSize,
                    parameters.intOrder,
                    parameters.blnFreeze
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
                log.Info("SQL AdminFfParameterTemplateSetAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfParameterTemplateSetAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfParameterTemplateSetAsync");
            return Json(returnResult);
        }


        /// <summary>
        /// Admin FF Rule Delete 
        /// </summary>
        /// <param name="idfsrule"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("AdminFfRuleDelAsync")]
        [ResponseType(typeof(List<AdminFfRuleDelModel>))]
        public async Task<IHttpActionResult> AdminFfRuleDelAsync(long idfsrule)
        {
            log.Info("Starting  AdminFfRuleDelAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfRuleDelAsync(idfsrule);
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
                log.Info("SQL AdminFfRuleDelAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfRuleDelAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfRuleDelAsync");
            return Json(returnResult);
        }



        /// <summary>
        /// Admin FF Rule Constant Delete 
        /// </summary>
        /// <param name="idfsrule"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("AdminFfRuleConstantDelAsync")]
        [ResponseType(typeof(List<AdminFfRuleConstantDelModel>))]
        public async Task<IHttpActionResult> AdminFfRuleConstantDelAsync(long idfsrule)
        {
            log.Info("Starting  AdminFfRuleConstantDelAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfRuleConstantDelAsync(idfsrule);
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
                log.Info("SQL AdminFfRuleConstantDelAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfRuleConstantDelAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfRuleConstantDelAsync");
            return Json(returnResult);
        }


        /// <summary>
        /// Admin Rule Parameter For Action Delete
        /// </summary>
        /// <param name="idfsrule"></param>
        /// <param name="idfsParameter"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("AdminFfRuleParameterForActionDelAsync")]
        [ResponseType(typeof(List<AdminFfRuleParameterForActionDelModel>))]
        public async Task<IHttpActionResult> AdminFfRuleParameterForActionDelAsync(long idfsrule, long idfsParameter)
        {
            log.Info("Starting  AdminFfRuleParameterForActionDelAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfRuleParameterForActionDelAsync(idfsrule, idfsParameter);
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
                log.Info("SQL AdminFfRuleParameterForActionDelAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfRuleParameterForActionDelAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfRuleParameterForActionDelAsync");
            return Json(returnResult);
        }





        /// <summary>
        /// Admin Rule Parameter For Action Set
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
        [HttpPost, Route("AdminFfRuleParameterForActionSetAsync")]
        [ResponseType(typeof(List<AdminFfRuleParameterForActionDelModel>))]
        public async Task<IHttpActionResult> AdminFfRuleParameterForActionSetAsync(AdminFfRuleParameterForActionSetParams parameters)
        {
            log.Info("Starting  AdminFfRuleParameterForActionSetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfRuleParameterForActionSetAsync(parameters.idfsRule, parameters.idfsFormTemplate, parameters.idfsParameter, parameters.idfsRuleAction);
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
                log.Info("SQL AdminFfRuleParameterForActionSetAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfRuleParameterForActionSetAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfRuleParameterForActionSetAsync");
            return Json(returnResult);
        }



        /// <summary>
        /// Admin Rule Parameter For Fuction Delete
        /// </summary>
        /// <param name="idfsRule"></param>
        /// <param name="idfsParameter"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("AdminFfRuleParameterForFunctionDelAsync")]
        [ResponseType(typeof(List<AdminFfRuleParameterForActionDelModel>))]
        public async Task<IHttpActionResult> AdminFfRuleParameterForFunctionDelAsync(long idfsRule, long idfsParameter)
        {
            log.Info("Starting  AdminFfRuleParameterForFunctionDelAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfRuleParameterForFunctionDelAsync(idfsRule, idfsParameter);
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
                log.Info("SQL AdminFfRuleParameterForFunctionDelAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfRuleParameterForFunctionDelAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfRuleParameterForFunctionDelAsync");
            return Json(returnResult);
        }









        ///// <summary>
        ///// Admin Rule Set
        ///// </summary>
        ///// <param name="idfsrule"></param>
        ///// <param name="idfsParameter"></param>
        ///// <returns>
        ///// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        ///// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        ///// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        ///// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        ///// ReturnMessage = Response message returned to client
        ///// Results = JSON List of ResponseType Objects retrieved from Query
        ///// </returns>
        //[HttpDelete, Route("AdminFfRulesSetAsync")]
        //[ResponseType(typeof(List<AdminFfRulesSetModel>))]
        //public async Task<IHttpActionResult> AdminFfRulesSetAsync(AdminFfRulesSetParams parameters)
        //{

        //    log.Info("Starting  AdminFfRulesSetAsync");
        //    APIReturnResult returnResult = new APIReturnResult();
        //    try
        //    {
        //        var result = await this._repository.AdminFfRulesSetAsync(parameters.idfsFormTemplate, parameters.idfsCheckPoint, parameters.idfsRuleFunction, parameters.defaultName, parameters.nationalName, parameters.messageText, parameters.messageNationalText, parameters.blnNot, parameters.langId, parameters.idfsRuleMessage).;
        //        if (result == null)
        //        {
        //            returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
        //            returnResult.ErrorCode = HttpStatusCode.BadRequest;
        //        }
        //        else
        //        {
        //            returnResult.ErrorCode = HttpStatusCode.OK;
        //            returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
        //            returnResult.Results = JsonConvert.SerializeObject(result);
        //        }
        //    }
        //    catch (SqlException ex)
        //    {
        //        log.Info("SQL AdminFfRulesSetAsync Failed Proc" + ex.Procedure, ex);
        //        returnResult.ErrorMessage = ex.Message;
        //        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        //    }
        //    catch (Exception ex)
        //    {
        //        log.Info("AdminFfRulesSetAsync Failed", ex);
        //        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        //        returnResult.ErrorMessage = ex.Message;
        //    }
        //    log.Info("Exiting  AdminFfRulesSetAsync");
        //    return Json(returnResult);
        //}




        /// <summary>
        /// Admin Rule Parameter For Action Delete
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
        [HttpDelete, Route("AdminFfRuleParameterForFunctionSetAsync")]
        [ResponseType(typeof(List<AdminFfRuleParameterForFunctionSetModel>))]
        public async Task<IHttpActionResult> AdminFfRuleParameterForFunctionSetAsync(AdminFfRuleParameterForFunctionSetAsyncParams parameters)
        {
            log.Info("Starting  AdminFfRuleParameterForFunctionSetModel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfRuleParameterForFunctionSetAsync(
                    parameters.idfsParameter,
                    parameters.idfsFormTemplate,
                    parameters.idfsRule,
                    parameters.intOrder
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
                log.Info("SQL AdminFfRuleParameterForFunctionSetModel Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfRuleParameterForFunctionSetModel Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfRuleParameterForFunctionDelModel");
            return Json(returnResult);
        }



        ///// <summary>
        ///// Admin Line Set
        ///// </summary>
        ///// <param name="parameters"></param>
        ///// <returns>
        ///// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        ///// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        ///// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        ///// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        ///// ReturnMessage = Response message returned to client
        ///// Results = JSON List of ResponseType Objects retrieved from Query
        ///// </returns>
        //[HttpPost, Route("AdminFfLineSet")]
        //[ResponseType(typeof(List<AdminFfLineSetModel>))]
        //public async Task<IHttpActionResult> AdminFfLineSetAsync(AdminFfLineSetParams parameters)
        //{
        //    log.Info("Starting  AdminFfLineSet");
        //    APIReturnResult returnResult = new APIReturnResult();
        //    try
        //    {
        //        /// <param name="idfsrule"></param>
        //        var result = await this._repository.AdminFfLineSet(parameters.idfsDecorElementType, parameters.langId, parameters.idfsFormTemplate, parameters.idfsSection, parameters.intLeft, parameters.intTop, parameters.intWidth, parameters.intHeight, parameters.blnOrientation, parameters.idfDecorElement);
        //            );
        //        if (result == null)
        //        {
        //            returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
        //            returnResult.ErrorCode = HttpStatusCode.BadRequest;
        //        }
        //        else
        //        {
        //            returnResult.ErrorCode = HttpStatusCode.OK;
        //            returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
        //            returnResult.Results = JsonConvert.SerializeObject(result);
        //        }
        //    }
        //    catch (SqlException ex)
        //    {
        //        log.Info("SQL AdminFfLineSet Failed Proc" + ex.Procedure, ex);
        //        returnResult.ErrorMessage = ex.Message;
        //        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        //    }
        //    catch (Exception ex)
        //    {
        //        log.Info("AdminFfLineSet Failed", ex);
        //        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        //        returnResult.ErrorMessage = ex.Message;
        //    }
        //    log.Info("Exiting  AdminFfLineSet");
        //    return Json(returnResult);
        //}












        /// <summary>
        /// Delete Parameter Types
        /// </summary>
        /// <param name="idfsParameterTypes"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("AdminFfParameterTypesDelAsync")]
        [ResponseType(typeof(List<AdminFfParameterTypesDelModel>))]
        public async Task<IHttpActionResult> AdminFfParameterTypesDelAsync(long idfsParameterTypes)
        {
            log.Info("Starting  AdminFfParameterTypesDelAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                /// <param name="idfsrule"></param>
                var result = await this._repository.AdminFfParameterTypesDelAsync(idfsParameterTypes);
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
                log.Info("SQL AdminFfParameterTypesDelAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfParameterTypesDelAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfParameterTypesDelAsync");
            return Json(returnResult);
        }


        /// <summary>
        /// Delete Parameter Types
        /// </summary>
        /// <param name="parameter"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("AdminFfParameterTypesSetAsync")]
        [ResponseType(typeof(List<AdminFfParameterTypesDelModel>))]
        public async Task<IHttpActionResult> AdminFfParameterTypesSetAsync(AdminFfParameterTypesSetParams parameter)
        {
            log.Info("Starting  AdminFfParameterTypesSetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfParameterTypesSetAsync(
                    parameter.defaultName,
                    parameter.nationalName,
                    parameter.idfsReferenceType,
                    parameter.langId
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
                log.Info("SQL AdminFfParameterTypesSetAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfParameterTypesSetAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfParameterTypesSetAsync");
            return Json(returnResult);
        }



        /// <summary>
        /// Delete Parameter Types
        /// </summary>
        /// <param name="parameter"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("AdminFfRuleConstantSetAsync")]
        [ResponseType(typeof(List<AdminFfRuleConstantSetModel>))]
        public async Task<IHttpActionResult> AdminFfRuleConstantSetAsync(AdminFfRuleConstantSetParams parameter)
        {
            log.Info("Starting  AdminFfParameterTypesSetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
            
                var result = await this._repository.AdminFfRuleConstantSetAsync(parameter.idfsRule, parameter.varConstant);
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
                log.Info("SQL AdminFfRuleConstantSetAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfRuleConstantSetAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfRuleConstantSetAsync");
            return Json(returnResult);
        }



        /// <summary>
        /// Delete Admin Section
        /// </summary>
        /// <param name="idfsSection"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("AdminFfSectionDelAsync")]
        public async Task<IHttpActionResult> AdminFfSectionDelAsync(long? idfsSection)
        {
            log.Info("Starting  AdminFfSectionDelAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = _repository.AdminFfSectionDel(idfsSection);
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
                log.Info("SQL AdminFfSectionDelAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfSectionDelAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfSectionDelAsync");
            return Json(returnResult);
        }

















        //$/EIDSS-Shared/SQL Scripts/EIDSS7_DB_ObjectsScript/USP_ADMIN_FF_RuleParameterForFunction_DEL.sql











        ///// <summary>
        ///// Delete Admin Section
        ///// </summary>
        ///// <param name="parameter"></param>
        ///// <returns>
        ///// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        ///// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        ///// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        ///// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        ///// ReturnMessage = Response message returned to client
        ///// Results = JSON List of ResponseType Objects retrieved from Query
        ///// </returns>
        //[HttpPost, Route("AdminFfRuleConstantSetAsync")]
        //[ResponseType(typeof(List<AdminFfSectionDelAsync>))]
        //public async Task<IHttpActionResult> AdminFfSectionDelAsync(long parameter)
        //{
        //    log.Info("Starting  AdminFfSectionDelAsync");
        //    APIReturnResult returnResult = new APIReturnResult();
        //    try
        //    {
        //        var result = await this._repository.AdminFfSectionDelAsync(parameter.idfsRule, parameter.varConstant);
        //        if (result == null)
        //        {
        //            returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
        //            returnResult.ErrorCode = HttpStatusCode.BadRequest;
        //        }
        //        else
        //        {
        //            returnResult.ErrorCode = HttpStatusCode.OK;
        //            returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
        //            returnResult.Results = JsonConvert.SerializeObject(result);
        //        }
        //    }
        //    catch (SqlException ex)
        //    {
        //        log.Info("SQL AdminFfSectionDelAsync Failed Proc" + ex.Procedure, ex);
        //        returnResult.ErrorMessage = ex.Message;
        //        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        //    }
        //    catch (Exception ex)
        //    {
        //        log.Info("AdminFfSectionDelAsync Failed", ex);
        //        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        //        returnResult.ErrorMessage = ex.Message;
        //    }
        //    log.Info("Exiting  AdminFfSectionDelAsync");
        //    return Json(returnResult);
        //}

        ///// <summary>
        ///// Set Admin Section
        ///// </summary>
        ///// <param name="parameter"></param>
        ///// <returns>
        ///// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        ///// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        ///// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        ///// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        ///// ReturnMessage = Response message returned to client
        ///// Results = JSON List of ResponseType Objects retrieved from Query
        ///// </returns>
        //[HttpPost, Route("AdminffSectionSetAsync")]
        //[ResponseType(typeof(List<AdminffSectionSetAsync>))]
        //public async Task<IHttpActionResult> AdminffSectionSetAsync(DASDSAD)
        //{
        //    log.Info("Starting  AdminFfSectionDelAsync");
        //    APIReturnResult returnResult = new APIReturnResult();
        //    try
        //    {
        //        var result = await this._repository.AdminffSectionSetAsync(asfdff);
        //        if (result == null)
        //        {
        //            returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
        //            returnResult.ErrorCode = HttpStatusCode.BadRequest;
        //        }
        //        else
        //        {
        //            returnResult.ErrorCode = HttpStatusCode.OK;
        //            returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
        //            returnResult.Results = JsonConvert.SerializeObject(result);
        //        }
        //    }
        //    catch (SqlException ex)
        //    {
        //        log.Info("SQL AdminffSectionSetAsync Failed Proc" + ex.Procedure, ex);
        //        returnResult.ErrorMessage = ex.Message;
        //        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        //    }
        //    catch (Exception ex)
        //    {
        //        log.Info("AdminffSectionSetAsync Failed", ex);
        //        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        //        returnResult.ErrorMessage = ex.Message;
        //    }
        //    log.Info("Exiting  AdminffSectionSetAsync");
        //    return Json(returnResult);
        //}





        /// <summary>
        /// Delete Admin Section
        /// </summary>
        /// <param name="adminFfSectionDesignOptionsSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("AdminFfSectionDesignOptionsSetAsync")]
        [ResponseType(typeof(List<AdminFfSectionDesignOptionsSetModel>))]
        public async Task<IHttpActionResult> AdminFfSectionDesignOptionsSetAsync(AdminFfSectionDesignOptionsSetParams adminFfSectionDesignOptionsSetParams)
        {
            log.Info("Starting  AdminFfSectionDesignOptionsSetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfSectionDesignOptionsSetAsync(
                    adminFfSectionDesignOptionsSetParams.idfsSection,
                    adminFfSectionDesignOptionsSetParams.idfsFormTemplate,
                    adminFfSectionDesignOptionsSetParams.intLeft,
                    adminFfSectionDesignOptionsSetParams.intTop,
                    adminFfSectionDesignOptionsSetParams.intWidth,
                    adminFfSectionDesignOptionsSetParams.intHeight,
                    adminFfSectionDesignOptionsSetParams.intCaptionHeight,
                    adminFfSectionDesignOptionsSetParams.langId,
                    adminFfSectionDesignOptionsSetParams.intOrder
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
                log.Info("SQL AdminFfSectionDesignOptionsSetAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfSectionDesignOptionsSetAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfSectionDesignOptionsSetAsync");
            return Json(returnResult);
        }




        /// <summary>
        /// Delete Admin Section
        /// </summary>
        /// <param name="idfsSection"></param>
        /// <param name="idfsFormTemplate"></param>
        /// <param name="langId"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("AdminFfSectionTemplateDelAsync")]
        [ResponseType(typeof(List<AdminFfSectionTemplateDelModel>))]
        public async Task<IHttpActionResult> AdminFfSectionTemplateDelAsync(long? idfsSection, long? idfsFormTemplate, string langId)
        {
            log.Info("Starting  AdminFfSectionTemplateDelAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfSectionTemplateDelAsync(idfsSection, idfsFormTemplate, langId);
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
                log.Info("SQL AdminFfSectionTemplateDelAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfSectionTemplateDelAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfSectionTemplateDelAsync");
            return Json(returnResult);
        }





        /// <summary>
        /// Admin Template Section Set
        /// </summary>
        /// <param name="adminFfSectionTemplateSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("AdminFfSectionTemplateSetAsync")]
        [ResponseType(typeof(List<AdminFfSectionTemplateSetModel>))]
        public async Task<IHttpActionResult> AdminFfSectionTemplateSetAsync(AdminFfSectionTemplateSetParams adminFfSectionTemplateSetParams)
        {
            log.Info("Starting  AdminFfSectionTemplateSetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfSectionTemplateSetAsync(
                    adminFfSectionTemplateSetParams.idfsSection,
                    adminFfSectionTemplateSetParams.idfsFormTemplate,
                    adminFfSectionTemplateSetParams.blnFreeze,
                    adminFfSectionTemplateSetParams.langId,
                    adminFfSectionTemplateSetParams.intLeft,
                    adminFfSectionTemplateSetParams.intTop,
                    adminFfSectionTemplateSetParams.intWidth,
                    adminFfSectionTemplateSetParams.intHeight,
                    adminFfSectionTemplateSetParams.intCaptionHeight,
                    adminFfSectionTemplateSetParams.intOrder);
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
                log.Info("SQL AdminFfSectionTemplateSetAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfSectionTemplateSetAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfSectionTemplateSetAsync");
            return Json(returnResult);
        }



        /// <summary>
        /// Admin Section Set
        /// </summary>
        /// <param name="adminFfSectionSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("AdminFfSectionsSet")]
        [ResponseType(typeof(List<AdminFfSectionsSetModel>))]
        public async Task<IHttpActionResult> AdminFfSectionsSet(AdminFfSectionSetParams adminFfSectionSetParams)
        {
            log.Info("Starting  AdminFfSectionsSet");
            APIReturnResult returnResult = new APIReturnResult();
            long? idfSection = 0;

            if (adminFfSectionSetParams.idfsSection != null && adminFfSectionSetParams.idfsSection != 0)
            {
                idfSection = adminFfSectionSetParams.idfsSection;
            }
            try
            {
                var result = this._repository.AdminFfSectionsSet(
                    adminFfSectionSetParams.idfsParentSection,
                    adminFfSectionSetParams.idfsFormType,
                    adminFfSectionSetParams.DefaultName,
                    adminFfSectionSetParams.NationalName,
                    adminFfSectionSetParams.langId,
                    adminFfSectionSetParams.intOrder,
                    adminFfSectionSetParams.blnGrid,
                    adminFfSectionSetParams.blnFixedRowset,
                    adminFfSectionSetParams.idfsMatrixType, out idfSection);
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
                log.Info("SQL AdminFfSectionsSet Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfSectionsSet Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfSectionsSet");
            return Json(returnResult);
        }


        /// <summary>
        /// Delete Recursive Template
        /// </summary>
        /// <param name="idfsSection"></param>
        /// <param name="idfsFormTemplate"></param>
        /// <param name="langId"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("AdminFfSectionTemplateRecursiveDelAsync")]
        [ResponseType(typeof(List<AdminFfSectionTemplateRecursiveDelModel>))]
        public async Task<IHttpActionResult> AdminFfSectionTemplateRecursiveDelAsync(long? idfsSection, long? idfsFormTemplate, string langId)
        {
            log.Info("Starting  AdminFfSectionTemplateRecursiveDelAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfSectionTemplateRecursiveDelAsync(idfsSection, idfsFormTemplate, langId);
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
                log.Info("SQL AdminFfSectionTemplateRecursiveDelAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfSectionTemplateRecursiveDelAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfSectionTemplateRecursiveDelAsync");
            return Json(returnResult);
        }




        ///// <summary>
        ///// Set Recursive Template
        ///// </summary>
        ///// <param name="adminFfSectionTemplateRecursiveSetParams"></param>
        ///// <returns>
        ///// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        ///// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        ///// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        ///// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        ///// ReturnMessage = Response message returned to client
        ///// Results = JSON List of ResponseType Objects retrieved from Query
        ///// </returns>
        //[HttpPost, Route("AdminFfSectionTemplateRecursiveSetAsync")]
        //[ResponseType(typeof(List<AdminFfSectionTemplateRecursiveSetModel>))]
        //public async Task<IHttpActionResult> AdminFfSectionTemplateRecursiveSetAsync(AdminFfSectionTemplateRecursiveSetParams adminFfSectionTemplateRecursiveSetParams)
        //{
        //    log.Info("Starting  AdminFfSectionTemplateRecursiveSetAsync");
        //    APIReturnResult returnResult = new APIReturnResult();
        //    try
        //    {
        //        var result = await this._repository.AdminFfSectionTemplateRecursiveSetAsync(
        //            adminFfSectionTemplateRecursiveSetParams.idfsSection, 
        //            adminFfSectionTemplateRecursiveSetParams.idfsFormTemplate, 
        //            adminFfSectionTemplateRecursiveSetParams.blnFreeze, 
        //            adminFfSectionTemplateRecursiveSetParams.langId, 
        //            adminFfSectionTemplateRecursiveSetParams.intLeft, 
        //            adminFfSectionTemplateRecursiveSetParams.intTop, 
        //            adminFfSectionTemplateRecursiveSetParams.intWidth, 
        //            adminFfSectionTemplateRecursiveSetParams.intHeight, 
        //            adminFfSectionTemplateRecursiveSetParams.intOrder
        //            );
        //        if (result == null)
        //        {
        //            returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
        //            returnResult.ErrorCode = HttpStatusCode.BadRequest;
        //        }
        //        else
        //        {
        //            returnResult.ErrorCode = HttpStatusCode.OK;
        //            returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
        //            returnResult.Results = JsonConvert.SerializeObject(result);
        //        }
        //    }
        //    catch (SqlException ex)
        //    {
        //        log.Info("SQL AdminFfSectionTemplateRecursiveSetAsync Failed Proc" + ex.Procedure, ex);
        //        returnResult.ErrorMessage = ex.Message;
        //        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        //    }
        //    catch (Exception ex)
        //    {
        //        log.Info("AdminFfSectionTemplateRecursiveSetAsync Failed", ex);
        //        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        //        returnResult.ErrorMessage = ex.Message;
        //    }
        //    log.Info("Exiting  AdminFfSectionTemplateRecursiveSetAsync");
        //    return Json(returnResult);
        //}





        /// <summary>
        /// Delete Admin Template
        /// </summary>
        /// <param name="idfsFormTemplate"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("AdminFfTemplateDelAsync")]
        [ResponseType(typeof(List<AdminFfTemplateDelModel>))]
        public async Task<IHttpActionResult> AdminFfTemplateDelAsync(long idfsFormTemplate)
        {
            log.Info("Starting  AdminFfTemplateDelAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfTemplateDelAsync(idfsFormTemplate);
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
                log.Info("SQL AdminFfTemplateDelAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfTemplateDelAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfTemplateDelAsync");
            return Json(returnResult);
        }



        /// <summary>
        /// Admin Set Template
        /// </summary>
        /// <param name="adminFfTemplateSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("AdminFfTemplateSetAsync")]
        [ResponseType(typeof(List<AdminFfTemplateSetModel>))]
        public async Task<IHttpActionResult> AdminFfTemplateSetAsync(AdminFfTemplateSetParams adminFfTemplateSetParams)
        {
            log.Info("Starting  AdminFfTemplateSetAsync");
            APIReturnResult returnResult = new APIReturnResult();
            long? idfsFormTemplate;
            try
            {
                var result = this._repository.AdminFfTemplateSet(
                    adminFfTemplateSetParams.idfsFormType, adminFfTemplateSetParams.defaultName, adminFfTemplateSetParams.nationalName, adminFfTemplateSetParams.strNote, adminFfTemplateSetParams.langId, adminFfTemplateSetParams.blnUni, out idfsFormTemplate);
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
                log.Info("SQL AdminFfTemplateSetAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfTemplateSetAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfTemplateSetAsync");
            return Json(returnResult);
        }







        ///// <summary>
        ///// Delete Template Design Options
        ///// </summary>
        ///// <param name="idfsFormTemplate"></param>
        ///// <param name="langid"></param>
        ///// <returns>
        ///// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        ///// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        ///// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        ///// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        ///// ReturnMessage = Response message returned to client
        ///// Results = JSON List of ResponseType Objects retrieved from Query
        ///// </returns>
        //[HttpDelete, Route("AdminFfTemplateDesignOptionsDelAsync")]
        //[ResponseType(typeof(List<AdminFfTemplateDesignOptionsDelModel>))]
        //public async Task<IHttpActionResult> AdminFfTemplateDesignOptionsDelAsync(long idfsFormTemplate,long langid)
        //{
        //    log.Info("Starting  AdminFfTemplateDesignOptionsDelAsync");
        //    APIReturnResult returnResult = new APIReturnResult();
        //    try
        //    {
        //        var result = await this._repository.AdminFfTemplateDesignOptionsDelAsync(idfsFormTemplate, langid);
        //        if (result == null)
        //        {
        //            returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
        //            returnResult.ErrorCode = HttpStatusCode.BadRequest;
        //        }
        //        else
        //        {
        //            returnResult.ErrorCode = HttpStatusCode.OK;
        //            returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
        //            returnResult.Results = JsonConvert.SerializeObject(result);
        //        }
        //    }
        //    catch (SqlException ex)
        //    {
        //        log.Info("SQL AdminFfTemplateDesignOptionsDelAsync Failed Proc" + ex.Procedure, ex);
        //        returnResult.ErrorMessage = ex.Message;
        //        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        //    }
        //    catch (Exception ex)
        //    {
        //        log.Info("AdminFfTemplateDesignOptionsDelAsync Failed", ex);
        //        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        //        returnResult.ErrorMessage = ex.Message;
        //    }
        //    log.Info("Exiting  AdminFfTemplateDesignOptionsDelAsync");
        //    return Json(returnResult);
        //}



        /// <summary>
        /// Delete Determinant Values
        /// </summary>
        /// <param name="idfsDeterminantValue"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("AdminFfTemplateDeterminantValuesDelAsync")]
        [ResponseType(typeof(List<AdminFfTemplateDeterminantValuesDelModel>))]
        public async Task<IHttpActionResult> AdminFfTemplateDeterminantValuesDelAsync(long idfsDeterminantValue)
        {
            log.Info("Starting  AdminFfTemplateDeterminantValuesDelAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfTemplateDeterminantValuesDelAsync(idfsDeterminantValue);
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
                log.Info("SQL AdminFfTemplateDeterminantValuesDelAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfTemplateDeterminantValuesDelAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfTemplateDeterminantValuesDelAsync");
            return Json(returnResult);
        }




        ///// <summary>
        ///// Set Determinant Values 
        ///// </summary>
        ///// <param name="adminFfTemplateDeterminantValuesSetParams"></param>
        ///// <returns>
        ///// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        ///// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        ///// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        ///// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        ///// ReturnMessage = Response message returned to client
        ///// Results = JSON List of ResponseType Objects retrieved from Query
        ///// </returns>
        //[HttpPost, Route("AdminFfTemplateDeterminantValuesSetAsync")]
        //[ResponseType(typeof(List<AdminFfTemplateDeterminantValuesSetModel>))]
        //public async Task<IHttpActionResult> AdminFfTemplateDeterminantValuesSetAsync(AdminFfTemplateDeterminantValuesSetParams adminFfTemplateDeterminantValuesSetParams)
        //{
        //    log.Info("Starting  AdminFfTemplateDeterminantValuesSetAsync");
        //    APIReturnResult returnResult = new APIReturnResult();
        //    try
        //    {
        //        var result = await this._repository.AdminFfTemplateDeterminantValuesSetAsync(
        //            adminFfTemplateDeterminantValuesSetParams.idfsFormTemplate,
        //            adminFfTemplateDeterminantValuesSetParams.idfsBaseReference,
        //            adminFfTemplateDeterminantValuesSetParams.idfsGisBaseReference,
        //            adminFfTemplateDeterminantValuesSetParams.idfDeterminantValue
        //            );
        //        if (result == null)
        //        {
        //            returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
        //            returnResult.ErrorCode = HttpStatusCode.BadRequest;
        //        }
        //        else
        //        {
        //            returnResult.ErrorCode = HttpStatusCode.OK;
        //            returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
        //            returnResult.Results = JsonConvert.SerializeObject(result);
        //        }
        //    }
        //    catch (SqlException ex)
        //    {
        //        log.Info("SQL AdminFfTemplateDeterminantValuesSetAsync Failed Proc" + ex.Procedure, ex);
        //        returnResult.ErrorMessage = ex.Message;
        //        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        //    }
        //    catch (Exception ex)
        //    {
        //        log.Info("AdminFfTemplateDeterminantValuesSetAsync Failed", ex);
        //        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        //        returnResult.ErrorMessage = ex.Message;
        //    }
        //    log.Info("Exiting  AdminFfTemplateDeterminantValuesSetAsync");
        //    return Json(returnResult);
        //}




        /// <summary>
        /// Delete Label
        /// </summary>
        /// <param name="idfDecorElement"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("AdminFfLabelDelAsync")]
        [ResponseType(typeof(List<AdminFfLabelDelModel>))]
        public async Task<IHttpActionResult> AdminFfLabelDelAsync(long idfDecorElement)
        {
            log.Info("Starting  AdminFfLabelDelAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfLabelDelAsync(idfDecorElement);
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
                log.Info("SQL AdminFfLabelDelAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfLabelDelAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfLabelDelAsync");
            return Json(returnResult);
        }



        /// <summary>
        /// Delete Line
        /// </summary>
        /// <param name="idfDecorElement"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("AdminFfLineDelAsync")]
        [ResponseType(typeof(List<AdminFfLineDelModel>))]
        public async Task<IHttpActionResult> AdminFfLineDelAsync(long idfDecorElement)
        {
            log.Info("Starting  AdminFfSectionDelAsync");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await this._repository.AdminFfLineDelAsync(idfDecorElement);
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
                log.Info("SQL AdminFfLineDelAsync Failed Proc" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Info("AdminFfLineDelAsync Failed", ex);
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
                returnResult.ErrorMessage = ex.Message;
            }
            log.Info("Exiting  AdminFfLineDelAsync");
            return Json(returnResult);
        }





    }
}

