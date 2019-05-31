using EIDSS.Client.Abstracts;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Domain.Return_Contracts;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace EIDSS.Client.API_Clients
{
    /// <summary>
    /// Client service that contains common functionality that is utilized across flexible forms and templates. 
    /// </summary>
    public class FlexibleFormServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(CrossCuttingServiceClient));

        /// <summary>
        /// Creates a new instance of this class.
        /// </summary>
        public FlexibleFormServiceClient() : base()
        {
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="observationList"></param>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<AdminFfActivityParametersGetModel>> GET_FF_ActivityParameters(string observationList, string languageId)
        {
            log.Info("GET_FF_ActivityParameters is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-ACTIVITYPARAMETERS-GET"));

                // Create query string...
                builder.Query = string.Format("observationList={0}&languageId={1}", new[] { observationList, languageId });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfActivityParametersGetModel>();
                }

                log.Info("GET_FF_ActivityParameters returned");
                return JsonConvert.DeserializeObject<List<AdminFfActivityParametersGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_ActivityParameters failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="observationList"></param>
        /// <returns></returns>
        public async Task<List<AdminFfObservationsGetModel>> GET_FF_Observation(string observationList)
        {
            log.Info("GET_FF_Observation is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-OBSERVATION-GET"));

                // Create query string...
                builder.Query = string.Format("observationList={0}", new[] { observationList });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();


                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfObservationsGetModel>();
                }

                log.Info("GET_FF_Observation returned");
                return JsonConvert.DeserializeObject<List<AdminFfObservationsGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_Observation failed", e);
                throw e;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfsFormTemplate"></param>
        /// <returns></returns>
        public async Task<List<AdminFfLabelsGetModel>> GET_FF_Label(string languageId, long? idfsFormTemplate)
        {
            log.Info("GET_FF_Label is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-LABEL-GET"));

                // Create query string...
                builder.Query = string.Format("idfsFormTemplate={0}&languageId={1}", new[] { languageId, Convert.ToString(idfsFormTemplate) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfLabelsGetModel>();
                }

                log.Info("GET_FF_Label returned");
                return JsonConvert.DeserializeObject<List<AdminFfLabelsGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_Label failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfsFormTemplate"></param>
        /// <returns></returns>
        public async Task<List<AdminFfLinesGetModel>> GET_FF_Lines(string languageId, long? idfsFormTemplate)
        {
            log.Info("GET_FF_Lines is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-LINES-GET"));

                // Create query string...
                builder.Query = string.Format("idfsFormTemplate={0}&languageId={1}", new[] { languageId, Convert.ToString(idfsFormTemplate) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfLinesGetModel>();
                }

                log.Info("GET_FF_Lines returned");
                return JsonConvert.DeserializeObject<List<AdminFfLinesGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_Lines failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<AdminFfDeterminantsGetModel>> GET_FF_Determinants(string languageId)
        {
            log.Info("GET_FF_Determinants is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-DETERMINANTS-GET"));

                // Create query string...
                builder.Query = string.Format("languageId={0}", new[] { languageId });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfDeterminantsGetModel>();
                }

                log.Info("GET_FF_Determinants returned");
                return JsonConvert.DeserializeObject<List<AdminFfDeterminantsGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_Determinants failed", e);
                throw e;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="idfsFormType"></param>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<AdminFfDeterminantTypesGetModel>> GET_FF_DeterminantTypes(long? idfsFormType, string languageId)
        {
            log.Info("GET_FF_DeterminantTypes is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-DETERMINANTTYPES-GET"));

                // Create query string...
                builder.Query = string.Format("idfsFormType={0}&languageId={1}", new[] { Convert.ToString(idfsFormType), languageId });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfDeterminantTypesGetModel>();
                }

                log.Info("GET_FF_DeterminantTypes returned");
                return JsonConvert.DeserializeObject<List<AdminFfDeterminantTypesGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_DeterminantTypes failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<AdminFfParameterEditorsGetModel>> GET_FF_ParameterEditors(string languageId)
        {
            log.Info("GET_FF_ParameterEditor is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-PARAMETEREDITORS-GET"));

                // Create query string...
                builder.Query = string.Format("languageId={0}", new[] { languageId });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfParameterEditorsGetModel>();
                }

                log.Info("GET_FF_ParameterEditor returned");
                return JsonConvert.DeserializeObject<List<AdminFfParameterEditorsGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_ParameterEditor failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfsSection"></param>
        /// <param name="idfsFormType"></param>
        /// <returns></returns>
        public async Task<List<AdminFfParametersGetModel>> GET_FF_Parameters(string languageId, long? idfsSection, long? idfsFormType)
        {
            log.Info("GET_FF_ParameterEditor is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-PARAMETERS-GET"));

                // Create query string...
                builder.Query = string.Format("languageId={0}&idfsSection={1}&idfsFormType={2}", new[] { languageId, Convert.ToString(idfsSection), Convert.ToString(idfsFormType) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfParametersGetModel>();
                }

                log.Info("GET_FF_ParameterEditor returned");
                return JsonConvert.DeserializeObject<List<AdminFfParametersGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_ParameterEditor failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="blnReturnTable"></param>
        /// <param name="idfsBaseReference"></param>
        /// <param name="idfsFormType"></param>
        /// <param name="idfsGisBaseReference"></param>
        /// <returns></returns>
        public async Task<List<AdminFfActualTemplateGetModel>> GET_FF_ActualTemplate(long? idfsGisBaseReference, long? idfsBaseReference, long? idfsFormType, bool blnReturnTable)
        {
            log.Info("FF-GET_FF-ActualTemplate-GET is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-ACTUALTEMPLATE-GET"));

                // Create query string...
                builder.Query = string.Format("idfsGisBaseReference={0}&idfsBaseReference={1}&idfsFormType={2}&blnReturnTable={3}", new[] { Convert.ToString(idfsGisBaseReference), Convert.ToString(idfsBaseReference), Convert.ToString(idfsFormType), Convert.ToString(blnReturnTable) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfActualTemplateGetModel>();
                }

                log.Info("GET_FF_ActualTemplate returned");
                return JsonConvert.DeserializeObject<List<AdminFfActualTemplateGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_ActualTemplate failed", e);
                throw e;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfsSection"></param>
        /// <param name="idfsFormType"></param>
        /// <returns></returns>
        public async Task<List<AdminFfParentSectionsGetModel>> GET_FF_ParentSections(string languageId, long? idfsSection)
        {
            log.Info("FF-GET_FF_ParentSections-GET is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-PARENTSECTION-GET"));

                // Create query string...
                builder.Query = string.Format("languageId={0}&idfsSection={1}", new[] { languageId, Convert.ToString(idfsSection) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfParentSectionsGetModel>();
                }

                log.Info("GET_FF_ParentSections returned");
                return JsonConvert.DeserializeObject<List<AdminFfParentSectionsGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_ParentSections failed", e);
                throw e;
            }
        }



        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfsParameter"></param>
        /// <param name="idfsParameterType"></param>
        /// <param name="intHaCode"></param>
        /// <returns></returns>
        public async Task<List<AdminFfParameterSelectListGetModel>> GET_FF_ParametersSelectList(string languageId, long? idfsParameter, long? idfsParameterType, long? intHaCode)
        {
            log.Info("GET_FF_ParametersSelectList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-PARAMETERSSELECTLIST-GET"));

                // Create query string...
                builder.Query = string.Format("languageId={0}&idfsParameter={1}&idfsParameterType={2}&intHaCode={3}", new[] { languageId, Convert.ToString(idfsParameter), Convert.ToString(idfsParameterType), Convert.ToString(intHaCode) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfParameterSelectListGetModel>();
                }

                log.Info("GET_FF_ParametersSelectList returned");
                return JsonConvert.DeserializeObject<List<AdminFfParameterSelectListGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_ParametersSelectList failed", e);
                throw e;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfsParameterType"></param>
        /// <param name="idfsFormType"></param>
        /// <param name="intHaCode"></param>
        /// <returns></returns>
        public async Task<List<AdminFfParameterSelectListSimpleGetModel>> GET_FF_ParametersSelectListSimple(string languageId, long? idfsParameterType, long? idfsFormType, long? intHaCode)
        {
            log.Info("GET_FF_ParametersSelectListSimple is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-PARAMETERSSELECTLISTSIMPLE-GET"));

                // Create query string...
                builder.Query = string.Format("languageId={0}&idfsParameterType={1}&idfsFormType={2}&intHaCode={3}", new[] { languageId, Convert.ToString(idfsParameterType), Convert.ToString(idfsFormType), Convert.ToString(intHaCode) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                log.Info("GET_FF_ParametersSelectListSimple returned");

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfParameterSelectListSimpleGetModel>();
                }

                log.Info("GET_FF_ParametersSelectList returned");
                return JsonConvert.DeserializeObject<List<AdminFfParameterSelectListSimpleGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_ParametersSelectListSimple failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="idfObservation"></param>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<AdminFfParametersDeletedFromTemplateGetModel>> GET_FF_ParametersDeletedFromTemplate(long? idfObservation, string languageId)
        {
            log.Info("GET_FF_ParametersDeletedFromTemplate is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-PARAMETERSDELETEDFROMTEMPLATE-GET"));

                // Create query string...
                builder.Query = string.Format("idfObservation={0}&languageId={1}", new[] { Convert.ToString(idfObservation), languageId });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfParametersDeletedFromTemplateGetModel>();
                }

                log.Info("GET_FF_ParametersDeletedFromTemplate returned");
                return JsonConvert.DeserializeObject<List<AdminFfParametersDeletedFromTemplateGetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GET_FF_ParametersDeletedFromTemplate failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="strSearch"></param>
        /// <param name="strSearchSection"></param>
        /// <returns></returns>
        public async Task<List<AdminFfParametersSearchGetModel>> GET_FF_ParametersSearch(string languageId, string strSearch, string strSearchSection)
        {
            log.Info("GET_FF_ParametersSearch is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-PARAMETERSSEARCH-GET"));

                // Create query string...
                builder.Query = string.Format("languageId={0}&strSearch={1}&strSearchSection={2}", new[] { languageId, strSearch, strSearchSection });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfParametersSearchGetModel>();
                }

                log.Info("GET_FF_ParametersSearch returned");
                return JsonConvert.DeserializeObject<List<AdminFfParametersSearchGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_ParametersSearch failed", e);
                throw e;
            }
        }

        /// <summary>
        /// FFSetActivityParametersAsync
        /// </summary>
        /// <returns></returns>
        public async Task<List<AdminFfActivityParametersSetModel>> SET_FF_ActivityParameters(AdminFfSetActivityParameters parameters)
        //long? idfsParameter, long idfObservation, long? idfsFormTemplate, string varValue, bool isDynamicParameter, long? idfRow, long? idfActivityParameters)
        {
            log.Info("SET_FF_ActivityParameters is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the content object. This will serialize the parameters using the formatter.
                //var content = CreateRequestContent(parameters);
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-ACTIVITYPARAMETERS-SET"));

                var content = CreateRequestContent(parameters);

                //var response = await _apiclient.PostAsync(Settings.GetResourceValue("FF-ACTIVITYPARAMETERS-SET"), content).ConfigureAwait(false);
                var response = await _apiclient.PostAsync(builder.Uri, content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfActivityParametersSetModel>();
                }

                log.Info("SET_FF_ActivityParameters returned");
                return JsonConvert.DeserializeObject<List<AdminFfActivityParametersSetModel>>(aPIReturnResult.Results);

                //// Create the builder...
                //UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI(""));

                //// Create query string...
                //builder.Query = string.Format("idfsParameter={0}&idfObservation={1}&idfsFormTemplate={2}&varValue={3}&isDynamicParameter={4}&idfRow={5}&idfActivityParameters={6}", new[] { Convert.ToString(idfsParameter), Convert.ToString(idfObservation), Convert.ToString(idfsFormTemplate), varValue, Convert.ToString(isDynamicParameter), Convert.ToString(idfRow), Convert.ToString(idfActivityParameters) });

                //// call the service...
                //var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                //// throw an exception if the call didn't succeed...
                //response.EnsureSuccessStatusCode();

                //aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                //if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                //{
                //    log.Error(aPIReturnResult.ErrorMessage);
                //    return new List<AdminFfActivityParametersSetModel>();
                //}

                //return JsonConvert.DeserializeObject<List<AdminFfActivityParametersSetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("SET_FF_ActivityParameters failed", e);
                throw e;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public async Task<List<AdminFfRulesGetModel>> GET_FF_Rules(string langId, long? idfsFormTemplate)
        {
            log.Info("GET_FF_Rules is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-RULES-GET"));

                // Create query string...
                builder.Query = string.Format("observationList={0}&languageId={1}", new[] { langId, Convert.ToString(idfsFormTemplate) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfRulesGetModel>();
                }

                log.Info("GET_FF_Rules returned");
                return JsonConvert.DeserializeObject<List<AdminFfRulesGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_Rules failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfsFormType"></param>
        /// <param name="idfsSection"></param>
        /// <param name="idfsParentSection"></param>
        /// <returns></returns>
        public async Task<List<AdminFfSectionsGetModel>> GET_FF_Sections(string languageId, long? idfsFormType, long? idfsSection, long? idfsParentSection)
        {
            log.Info("GET_FF_Sections is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-SECTIONS-GET"));

                // Create query string...
                builder.Query = string.Format("languageId={0}&idfsFormType={1}&idfsSection={2}&idfsParentSection={3}", new[] { languageId, Convert.ToString(idfsFormType), Convert.ToString(idfsSection), Convert.ToString(idfsParentSection) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfSectionsGetModel>();
                }

                log.Info("GET_FF_Sections returned");
                return JsonConvert.DeserializeObject<List<AdminFfSectionsGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_Sections failed", e);
                throw e;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="idfsSection"></param>
        /// <param name="idfsFormTemplate"></param>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<AdminFfSectionTemplateGetModel>> GET_FF_SectionTemplate(long? idfsSection, long? idfsFormTemplate, string languageId)
        {
            log.Info("GET_FF_SectionTemplate is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-SECTIONTEMPLATE-GET"));

                // Create query string...
                builder.Query = string.Format("idfsSection={0}&idfsFormTemplate={1}&languageId={2}", new[] { Convert.ToString(idfsSection), Convert.ToString(idfsFormTemplate), languageId });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfSectionTemplateGetModel>();
                }

                log.Info("GET_FF_SectionTemplate returned");
                return JsonConvert.DeserializeObject<List<AdminFfSectionTemplateGetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GET_FF_SectionTemplate failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfsFormTemplate"></param>
        /// <param name="idfsFormType"></param>
        /// <returns></returns>
        public async Task<List<AdminFfTemplatesGetModel>> GET_FF_Templates(string languageId, long? idfsFormTemplate, long? idfsFormType)
        {

            log.Info("GET_FF_Templates is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-TEMPLATES-GET"));

                // Create query string...
                builder.Query = string.Format("languageId={0}&idfsFormTemplate={1}&idfsFormType={2}", new[] { languageId, Convert.ToString(idfsFormTemplate), Convert.ToString(idfsFormType) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfTemplatesGetModel>();
                }

                log.Info("GET_FF_Templates returned");
                return JsonConvert.DeserializeObject<List<AdminFfTemplatesGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_Templates failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfsFormTemplate"></param>
        /// <returns></returns>
        public async Task<List<AdminFfTemplateDeterminantValuesGetModel>> GET_FF_TemplateDeterminants(string languageId, long? idfsFormTemplate)
        {
            log.Info("GET_FF_TemplateDeterminants is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-TEMPLATEDETERMINANTS-GET"));

                // Create query string...
                builder.Query = string.Format("languageId={0}&idfsFormTemplate={1}", new[] { languageId, Convert.ToString(idfsFormTemplate) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();


                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfTemplateDeterminantValuesGetModel>();
                }

                log.Info("GET_FF_TemplateDeterminants returned");
                return JsonConvert.DeserializeObject<List<AdminFfTemplateDeterminantValuesGetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GET_FF_TemplateDeterminants failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="idfsParameter"></param>
        /// <param name="idfsFormTemplate"></param>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<AdminFfParameterTemplateGetModel>> GET_FF_ParameterTemplates(long? idfsParameter, long? idfsFormTemplate, string languageId)
        {
            log.Info("GET_FF_ParameterTemplates is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-PARAMETERTEMPLATES-GET"));

                // Create query string...
                builder.Query = string.Format("idfsParameter={0}&idfsFormTemplate={1}&languageId={2}", new[] { Convert.ToString(idfsParameter), Convert.ToString(idfsFormTemplate), languageId });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                log.Info("GET_FF_ParameterTemplates returned");

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfParameterTemplateGetModel>();
                }

                log.Info("GET_FF_TemplateDeterminants returned");
                return JsonConvert.DeserializeObject<List<AdminFfParameterTemplateGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_ParameterTemplates failed", e);
                throw e;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfsParameter"></param>
        /// <returns></returns>
        public async Task<List<AdminFfTemplatesByParameterGetModel>> GET_FF_TemplateByParameter(string languageId, long? idfsParameter)
        {
            log.Info("GET_FF_TemplateByParameter is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-TEMPLATEBYPARAMETER-GET"));

                // Create query string...
                builder.Query = string.Format("languageId={0}&idfsParameter={1}", new[] { languageId, Convert.ToString(idfsParameter) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfTemplatesByParameterGetModel>();
                }

                log.Info("GET_FF_TemplateByParameter returned");
                return JsonConvert.DeserializeObject<List<AdminFfTemplatesByParameterGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_TemplateByParameter failed", e);
                throw e;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfsFormType"></param>
        /// <returns></returns>
        public async Task<List<AdminFfFormTypesGetModel>> GET_FF_FormType(string languageId, long? idfsFormType)
        {
            log.Info("GET_FF_FormType is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-FORMTYPE-GET"));

                // Create query string...
                builder.Query = string.Format("languageId={0}&idfsFormType={1}", new[] { languageId, Convert.ToString(idfsFormType) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfFormTypesGetModel>();
                }

                log.Info("GET_FF_FormType returned");
                return JsonConvert.DeserializeObject<List<AdminFfFormTypesGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_FormType failed", e);
                throw e;
            }
        }

        // Custom Code
        /// <summary>
        /// Retrieves a list of flexible forms parameter types based on the filter entered by the user. 
        /// </summary>
        /// <param name="idfsParameterType">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns></returns>
        public async Task<List<AdminFfParameterTypesDelModel>> DeleteFlexibleFormParameterTypeDelete(long idfsParameterType)
        {
            log.Info("FlexibleFormParameterTypeDelete is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FlexibleFormParameterTypeDelete"));

                // Create query string...
                builder.Query = string.Format("idfsParameterTypes={0}", idfsParameterType);
                var stringContent = new StringContent("{ \"idfsParameterTypes\": \"" + idfsParameterType + "\" }", System.Text.Encoding.UTF8, "application/json");

                // call the service...
                var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("FlexibleFormParameterTypeDelete Returned " + aPIReturnResult.ErrorMessage);
                    return new List<AdminFfParameterTypesDelModel>();
                }

                log.Info("FlexibleFormParameterTypeDelete returned");
                return JsonConvert.DeserializeObject<List<AdminFfParameterTypesDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("FlexibleFormParameterTypeDelete failed", e);
                throw e;
            }
        }

        public async Task<List<AdminFfParameterTypesSetModel>> CreateOrUpdateFlexibleFormParameterType(AdminFfParameterTypesSetParams adminFfParameterTypesSetParams)
        {
            log.Info("AdminFlexibleFormParameterTypesCreateOrUpdate is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("AdminFlexibleFormParameterTypesCreateOrUpdate"));

                // Create the content object. This will serialize the parms using our formatter! Beautiful!

                var content = CreateRequestContent(adminFfParameterTypesSetParams);

                var response = await _apiclient.PostAsync(builder.Uri, content).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("AdminFlexibleFormParameterTypesCreateOrUpdate Returned " + aPIReturnResult.ErrorMessage);
                    return new List<AdminFfParameterTypesSetModel>();
                }

                log.Info("AdminFlexibleFormParameterTypesCreateOrUpdate returned");
                return JsonConvert.DeserializeObject<List<AdminFfParameterTypesSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("AdminFlexibleFormParameterTypesCreateOrUpdate failed", e);
                throw e;
            }
        }

        public async Task<List<AdminFfParameterFixedPresetValueSetModel>> CreateOrUpdateFfParameterFixedPresetValue(AdminFfParameterFixedPresetValueSet adminFfParameterTypesSetParams)
        {
            log.Info("AdminFfParameterFixedPresetValueSetAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("AdminFfParameterFixedPresetValueSet"));

                var content = CreateRequestContent(adminFfParameterTypesSetParams);

                var response = await _apiclient.PostAsync(builder.Uri, content).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("AdminFfParameterFixedPresetValueSetAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<AdminFfParameterFixedPresetValueSetModel>();
                }

                log.Info("AdminFfParameterFixedPresetValueSetAsync returned");
                return JsonConvert.DeserializeObject<List<AdminFfParameterFixedPresetValueSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("AdminFfParameterFixedPresetValueSetAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Retrieves a list of flexible forms parameter types based on the filter entered by the user. 
        /// </summary>
        /// <param name="idfsParameterType">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns></returns>
        public async Task<List<AdminFfParameterFixedPresetValueDelModel>> DeleteFlexibleFormParameterFixedPresetValue(long? idfsParameterFixedPresetValue)
        {
            log.Info("FlexibleFormParameterFixedPresetValueDelete is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FlexibleFormParameterFixedPresetValueDelete"));

                // Create query string...
                builder.Query = string.Format("idfParameterFixedPresetValue={0}", idfsParameterFixedPresetValue);

                // call the service...
                var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("FlexibleFormParameterFixedPresetValueDelete Returned " + aPIReturnResult.ErrorMessage);
                    return new List<AdminFfParameterFixedPresetValueDelModel>();
                }

                log.Info("FlexibleFormParameterFixedPresetValueDelete returned");
                return JsonConvert.DeserializeObject<List<AdminFfParameterFixedPresetValueDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("FlexibleFormParameterFixedPresetValueDelete failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Retrieves a list of flexible forms parameter reference types given the reference type filering identifier
        /// </summary>
        /// <param name="langId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsParameterType">An EIDSS specific parameter type identifier used to restrict results</param>
        /// <param name="onlyLists">Restricts the search to display list based data only</param>
        /// <returns></returns>
        public async Task<List<AdminFfParameterTypesGetListModel>> GetFFParameterReferenceType(string langId, long? idfsParameterType, bool? onlyLists)
        {
            log.Info("GetFFParameterReferenceType is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FlexibleFormsParameterReferenceTypeAsync"));

                // Create query string...
                builder.Query = string.Format("langId={0}&idfsParameterType={1}&onlyLists={2}", new[] { langId, Convert.ToString(idfsParameterType), Convert.ToString(onlyLists) });
                //builder.Query = string.Format("langId={0}&idfsParameterType={1}&onlyLists={2}", new[] { langId, null, null });
                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetFFParameterReferenceType Returned " + aPIReturnResult.ErrorMessage);
                    return new List<AdminFfParameterTypesGetListModel>();
                }

                log.Info("GetFFParameterReferenceType returned");
                return JsonConvert.DeserializeObject<List<AdminFfParameterTypesGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetFFParameterReferenceType failed", e);
                throw e;
            }
        }


        public async Task<List<AdminFfSectionsSetModel>> SetFfSections(AdminFfSectionSetParams adminFfSectionSetParams)
        {
            log.Info("AdminFfSectionsSet is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("AdminFfSectionsSet"));

                // Create the content object. This will serialize the parms using our formatter! Beautiful!

                var content = CreateRequestContent(adminFfSectionSetParams);

                var response = await _apiclient.PostAsync(builder.Uri, content).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("AdminFfSectionsSet Returned " + aPIReturnResult.ErrorMessage);
                    return new List<AdminFfSectionsSetModel>();
                }

                log.Info("AdminFfSectionsSet returned");
                return JsonConvert.DeserializeObject<List<AdminFfSectionsSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("AdminFfSectionsSet failed", e);
                throw e;
            }
        }

        public async Task<int> DeleteSection(long? idfsSection)
        {
            log.Info("AdminFfSectionDel is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("AdminFfSectionDel"));

                // Create query string...
                builder.Query = string.Format("idfsSection={0}", idfsSection);

                // call the service...
                var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("AdminFfSectionDel Returned " + aPIReturnResult.ErrorMessage);
                    return 0;
                }

                log.Info("AdminFfSectionDel returned");
                return 1;
            }
            catch (Exception e)
            {
                log.Error("AdminFfSectionDel failed", e);
                throw e;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="intHaCode"></param>
        /// <param name="idfsCodeName"></param>
        /// <returns></returns>
        public async Task<List<AdminFfHaCodeListGetModel>> GETFFHaCodeList(string langId, long? intHaCode, long? idfsCodeName)
        {
            log.Info("FFHaCodeListGet is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FFHaCodeListGet"));

                // Create query string...
                builder.Query = string.Format("langId={0}&intHaCode={1}&idfsCodeName={2}", new[] { langId, Convert.ToString(intHaCode), Convert.ToString(idfsCodeName) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfHaCodeListGetModel>();
                }

                log.Info("FFHaCodeListGet returned");
                return JsonConvert.DeserializeObject<List<AdminFfHaCodeListGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("FFHaCodeListGet failed", e);
                throw e;
            }
        }

        public async Task<List<AdminFfParametersSetModel>> SET_FF_PARAMETERS(AdminFfParametersSetParams adminFfParametersSetParams)
        {
            log.Info("SET_FF_PARAMETERS is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-PARAMETERS-SET"));

                // Create the content object. This will serialize the parms using our formatter! Beautiful!

                var content = CreateRequestContent(adminFfParametersSetParams);

                var response = await _apiclient.PostAsync(builder.Uri, content).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("SET_FF_PARAMETERS Returned " + aPIReturnResult.ErrorMessage);
                    return new List<AdminFfParametersSetModel>();
                }

                log.Info("SET_FF_PARAMETERS returned");
                return JsonConvert.DeserializeObject<List<AdminFfParametersSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("SET_FF_PARAMETERS failed", e);
                throw e;
            }
        }

        public async Task<List<AdminFfParameterDelModel>> AdminFfSectionDelAsync(long idfsParameter)
        {
            log.Info("DelFfParameters is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-PARAMETERS-DEL"));

                // Create query string...
                builder.Query = string.Format("idfsParameter={0}", idfsParameter);
                // call the service...
                var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("DelFfParameters Returned " + aPIReturnResult.ErrorMessage);
                    return new List<AdminFfParameterDelModel>();
                }

                log.Info("DelFfParameters returned");
                return JsonConvert.DeserializeObject<List<AdminFfParameterDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("DelFfParameters failed", e);
                throw e;
            }
        }

        public async Task<List<AdminFfTemplateSetModel>> SET_FF_TEMPLATE(AdminFfTemplateSetParams adminFfTemplateSetParams)
        {
            log.Info("SET_FF_TEMPLATE is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-TEMPLATE-SET"));

                // Create the content object. This will serialize the parms using our formatter! Beautiful!

                var content = CreateRequestContent(adminFfTemplateSetParams);

                var response = await _apiclient.PostAsync(builder.Uri, content).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("SET_FF_TEMPLATE Returned " + aPIReturnResult.ErrorMessage);
                    return new List<AdminFfTemplateSetModel>();
                }

                log.Info("SET_FF_TEMPLATE returned");
                return JsonConvert.DeserializeObject<List<AdminFfTemplateSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("SET_FF_TEMPLATE failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="idfsFormTemplate"></param>
        /// <returns></returns>
        public async Task<List<AdminFfTemplateDelModel>> DEL_FF_TEMPLATE(long idfsFormTemplate)
        {
            log.Info("DEL_FF_TEMPLATE is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-TEMPLATE-DEL"));

                // Create query string...
                //builder.Query = string.Format("idfsFormTemplate={0}", new[] { idfsFormTemplate });
                builder.Query = string.Format("idfsFormTemplate={0}", idfsFormTemplate);


                // call the service...
                var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfTemplateDelModel>();
                }

                log.Info("GET_FF_ParametersDeletedFromTemplate returned");
                return JsonConvert.DeserializeObject<List<AdminFfTemplateDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("DEL_FF_TEMPLATE failed", e);
                throw e;
            }
        }

        public async Task<List<AdminFfAggregateMatrixVersionGetListModel>> GET_FF_AGGREGATEMATRIX(string languageId, long? idfMatrix)
        {
            log.Info("FF-AGGREGATEMATRIX-GET is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-AGGREGATEMATRIX-GET"));

                // Create query string...
                builder.Query = string.Format("languageId={0}&idfMatrix={1}", new[] { Convert.ToString(languageId), Convert.ToString(idfMatrix) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfAggregateMatrixVersionGetListModel>();
                }

                log.Info("FF-AGGREGATEMATRIX-GET returned");
                return JsonConvert.DeserializeObject<List<AdminFfAggregateMatrixVersionGetListModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("FF-AGGREGATEMATRIX-GET failed", e);
                throw e;
            }
        }
        public async Task<List<GblObservationSetModel>> SET_FF_GBLOBSERVATION(GblObservationSetParams gblObservationSetParams)
        {
            log.Info("SET_FF_GBLOBSERVATION is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-GBLOBSERVATION-SET"));

                // Create the content object. This will serialize the parms using our formatter! Beautiful!

                var content = CreateRequestContent(gblObservationSetParams);

                var response = await _apiclient.PostAsync(builder.Uri, content).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("SET_FF_GBLOBSERVATION Returned " + aPIReturnResult.ErrorMessage);
                    return new List<GblObservationSetModel>();
                }

                log.Info("SET_FF_GBLOBSERVATION returned");
                return JsonConvert.DeserializeObject<List<GblObservationSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("SET_FF_GBLOBSERVATION failed", e);
                throw e;
            }
        }
        public async Task<List<AdminFfPredefinedStubGetModel>> GET_FF_PREDEFINEDSTUB(long matrixId, string versionList, string langId, long? idfsFormTemplate)
        {
            log.Info("GET_FF_PREDEFINEDSTUB is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FF-PREDEFINEDSTUB-GET"));

                // Create query string...
                builder.Query = string.Format("matrixId={0}&versionList={1}&langId={2}&idfsFormTemplate={3}", new[] { Convert.ToString(matrixId), Convert.ToString(versionList), Convert.ToString(langId), Convert.ToString(idfsFormTemplate) });
                //matrixId={matrixId}&amp;versionList={versionList}&amp;languageId={languageId}&amp;idfsFormTemplate={idfsFormTemplate}
                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminFfPredefinedStubGetModel>();
                }

                log.Info("GET_FF_PREDEFINEDSTUB returned");
                return JsonConvert.DeserializeObject<List<AdminFfPredefinedStubGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GET_FF_PREDEFINEDSTUB failed", e);
                throw e;
            }
        }
    }
}
