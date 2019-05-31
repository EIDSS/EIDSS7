using EIDSS.Client.Abstracts;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Domain.Return_Contracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Text;
using System.Threading.Tasks;

namespace EIDSS.Client.API_Clients
{
    /// <summary>
    /// Client service that interacts with outbreak specific functionality within the EISSS Api.
    /// </summary>
    public class OutbreakServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(OutbreakServiceClient));

        static string SessionId { get; set; }

        public OutbreakServiceClient(string strSessionId = "") : base()
        {
            SessionId = strSessionId;
        }

        public async Task<List<OmmContactSetModel>> OmmContactSetAsync(OMMContactSetParams parameters) //USP_OMM_Contact_Set
        {
            log.Info("OmmContactSetAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object.  This will serialize the parms using our formatter!
                var content = this.CreateRequestContent<OMMContactSetParams>(parameters);

                var response = _apiclient.PostAsync(this.Settings.GetResourceValue("OmmContactSetAsync"), content).Result;
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmContactSetModel>();
                }
                log.Info("OmmContactSetAsync returned");
                return JsonConvert.DeserializeObject<List<OmmContactSetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("OmmContactSetAsync failed", e);
                throw e;
            }
        }

        public async Task<List<OmmCaseSetModel>> OmmCaseSetAsync(OmmCaseSetParams parameters) //USP_OMM_Case_Set
        {
            log.Info("OmmCaseSetAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object.  This will serialize the parms using our formatter!
                var content = this.CreateRequestContent<OmmCaseSetParams>(parameters);

                var response = _apiclient.PostAsync(this.Settings.GetResourceValue("OmmCaseSetAsync"), content).Result;
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmCaseSetModel>();
                }
                log.Info("OmmCaseSetAsync returned");
                return JsonConvert.DeserializeObject<List<OmmCaseSetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("OmmCaseSetAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Retrieves a list of outbreak cases 
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use. </param>
        /// <returns></returns>
        public async Task<List<OmmCaseGetListModel>> OmmCaseGetListAsync(OmmCaseGetListParams parameters, bool bRefresh) //USP_OMM_Case_GetList
        {
            log.Info("OmmCaseGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                if (bRefresh)
                {
                    _apiclient.DefaultRequestHeaders.Add("CacheAction", "ADD");
                }
                else
                {
                    _apiclient.DefaultRequestHeaders.Add("CacheAction", "GET");
                }

                _apiclient.DefaultRequestHeaders.Add("CacheKey", SessionId + "OmmCaseGetListAsync");

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OmmCaseGetListAsync"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();

                log.Info("OmmCaseGetListAsync returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmCaseGetListModel>();
                }
                return JsonConvert.DeserializeObject<List<OmmCaseGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("OmmCaseGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Retrieves a list of outbreak contacts 
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use. </param>
        /// <returns></returns>
        public async Task<List<OmmContactGetListModel>> OmmContactGetListAsync(OmmContactGetListParams parameters) //USP_OMM_Contact_GetList
        {
            log.Info("OmmContactGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);
                //_apiclient.BaseAddress = new System.Uri("http://localhost/");


                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OmmContactGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                log.Info("OmmContactGetListAsync returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmContactGetListModel>();
                }
                return JsonConvert.DeserializeObject<List<OmmContactGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("OmmContactGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Retrieves a list of parameters for a given outbreak session
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use. </param>
        /// <returns></returns>
        public async Task<List<OmmSessionParametersGetListModel>> OmmSessionParametersGetListAsync(OmmSessionParametersGetListParams parameters) //USP_OMM_Session_Parameters_GetList
        {
            log.Info("OmmSessionParametersGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OmmSessionParametersGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                log.Info("OmmSessionParametersGetListAsync returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmSessionParametersGetListModel>();
                }
                return JsonConvert.DeserializeObject<List<OmmSessionParametersGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("OmmSessionParametersGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="outbreakId"></param>
        /// <returns></returns>
        public async Task<List<OmmSessionGetDetailModel>> OmmSessionGetDetailAsync(OmmSessionGetDetailParams parameters) //USP_OMM_Session_GetDetail
        {
            log.Info("OmmSessionGetDetailAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                var content = this.CreateRequestContent<OmmSessionGetDetailParams>(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OmmSessionGetDetailAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                log.Info("OmmSessionGetDetailAsync returned");
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmSessionGetDetailModel>();
                }
                return JsonConvert.DeserializeObject<List<OmmSessionGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("OmmSessionGetDetailAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Retrieves a list of outbreak cases 
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use. </param>
        /// <returns></returns>
        public async Task<List<OmmSessionGetListModel>> OmmSessionGetListAsync(OmmSessionGetListParams parameters, bool bRefresh = false) //USP_OMM_Session_GetList
        {
            log.Info("OmmSessionGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                if (bRefresh)
                {
                    _apiclient.DefaultRequestHeaders.Add("CacheAction", "ADD");
                }
                else
                {
                    _apiclient.DefaultRequestHeaders.Add("CacheAction", "GET");
                }

                _apiclient.DefaultRequestHeaders.Add("CacheKey", SessionId + "OmmSessionGetListAsync");

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OmmSessionGetList"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                log.Info("OmmSessionGetListAsync returned");
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmSessionGetListModel>();
                }
                return JsonConvert.DeserializeObject<List<OmmSessionGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("OmmSessionGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="outbreakNoteId"></param>
        /// <returns></returns>
        public async Task<List<OmmSessionNoteGetDetailModel>> OmmSessionNoteGetDetailAsync(OMMSessionNoteGetDetailsParams parameters) //USP_OMM_Session_Note_GetDetail
        {
            log.Info("OmmSessionNoteGetDetailAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OmmSessionNoteGetDetailAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                log.Info("OmmSessionNoteGetDetailAsync returned");
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmSessionNoteGetDetailModel>();
                }
                return JsonConvert.DeserializeObject<List<OmmSessionNoteGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("OmmSessionNoteGetDetailAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Retrieves a list of outbreak session note list 
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use. </param>
        /// <returns></returns>
        public async Task<List<OmmSessionNoteGetListModel>> OmmSessionNoteGetListAsync(OMMSessionNoteGetListParams parameters, bool bRefresh = false) //USP_OMM_Session_Note_GetList
        {
            log.Info("OmmSessionNoteGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                if (bRefresh)
                {
                    _apiclient.DefaultRequestHeaders.Add("CacheAction", "ADD");
                }
                else
                {
                    _apiclient.DefaultRequestHeaders.Add("CacheAction", "GET");
                }

                _apiclient.DefaultRequestHeaders.Add("CacheKey", SessionId + "OmmSessionNoteGetListAsync");

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OmmSessionNoteGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                log.Info("OmmSessionNoteGetListAsync returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmSessionNoteGetListModel>();
                }
                return JsonConvert.DeserializeObject<List<OmmSessionNoteGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("OmmSessionNoteGetListAsync failed", e);
                throw e;
            }
        }

        public async Task<List<OmmSessionNoteSetModel>> OmmSessionNoteSet(OMMSessionNoteSetParams parameters) //USP_OMM_SESSION_Note_Set
        {
            log.Info("OmmSessionNoteSet is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object.  This will serialize the parms using our formatter!
                var content = this.CreateRequestContent<OMMSessionNoteSetParams>(parameters);

                var response = _apiclient.PostAsync(this.Settings.GetResourceValue("OMMSessionNoteSet"), content).Result;
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmSessionNoteSetModel>();
                }
                log.Info("OmmSessionNoteSet returned");
                return JsonConvert.DeserializeObject<List<OmmSessionNoteSetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("OmmSessionNoteSet failed", e);
                throw e;
            }
        }

        public async Task<List<OmmSessionSetModel>> OmmSessionSetAsync(OMMSessionSetParams parameters) //USP_OMM_SESSION_Set
        {
            log.Info("OmmSessionSetAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object.  This will serialize the parms using our formatter!
                var content = this.CreateRequestContent<OMMSessionSetParams>(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OmmSessionSetAsync"), content).ConfigureAwait(false);

                //var response = _apiclient.PostAsync(this.Settings.GetResourceValue("OmmSessionSetAsync"), content).Result;
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmSessionSetModel>();
                }
                log.Info("OmmSessionSetAsync returned");
                return JsonConvert.DeserializeObject<List<OmmSessionSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("OmmSessionSetAsync failed", e);
                throw e;
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="idfOutbreakNote"></param>
        /// <returns></returns>
        public async Task<List<OmmNoteFileGetModel>> OmmNoteFileGetAsync(OmmNoteFileParams parameters) //USP_OMM_Note_File_Get
        {
            log.Info("OmmNoteFileGetAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                var content = this.CreateRequestContent<OmmNoteFileParams>(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OmmNoteFileGetAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                log.Info("OmmNoteFileGetAsync returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmNoteFileGetModel>();
                }
                return JsonConvert.DeserializeObject<List<OmmNoteFileGetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("OmmNoteFileGetAsync failed", e);
                throw e;
            }
        }

        public async Task<SPReturnResult> OmmSessionDeleteAsync(long idfOutbreak) //USP_OMM_Session_Del
        {
            log.Info("OmmSessionDeleteAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("OmmSessionDeleteAsync"))
                {
                    Query = string.Format("idfOutbreak={0}", new[] { Convert.ToString(idfOutbreak) })
                };

                var response = _apiclient.DeleteAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });

                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                }
                log.Info("OmmSessionDeleteAsync returned");
                return JsonConvert.DeserializeObject<SPReturnResult>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("OmmSessionDeleteAsync failed", e);
                throw e;
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="langID"></param>
        /// <param name="outbOUtbreakCaseContactUIDreakId"></param>
        /// <returns></returns>
        public async Task<List<OmmContactGetDetailModel>> OmmContactGetDetailAsync(OmmContactGetDetailParams parameters) //USP_OMM_Contact_GetDetail
        {
            log.Info("OmmContactGetDetailAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                var content = this.CreateRequestContent<OmmContactGetDetailParams>(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OmmContactGetDetailAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                log.Info("OmmContactGetDetailAsync returned");
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmContactGetDetailModel>();
                }
                return JsonConvert.DeserializeObject<List<OmmContactGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("OmmContactGetDetailAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="langID"></param>
        /// <param name="OutbreakCaseReportUID"></param>
        /// <param name="HumanActualAddlInfoUID"></param>
        /// <returns></returns>
        public async Task<List<OmmCaseGetDetailModel>> OmmCaseGetDetailAsync(OmmCaseGetDetailParams parameters) //USP_OMM_Case_GetDetail
        {
            log.Info("OmmCaseGetDetailAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                var content = this.CreateRequestContent<OmmCaseGetDetailParams>(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OmmCaseGetDetailAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                log.Info("OmmCaseGetDetailAsync returned");
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmCaseGetDetailModel>();
                }
                return JsonConvert.DeserializeObject<List<OmmCaseGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("OmmCaseGetDetailAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="langID"></param>
        /// <param name="idfHumanActual"></param>
        /// <returns></returns>
        public async Task<List<OmmCaseSummaryGetDetailModel>> OmmCaseSummaryGetDetailAsync(OmmCaseSummaryGetDetailParams parameters) //USP_OMM_CaseSummary_GetDetail
        {
            log.Info("OmmCaseSummaryGetDetailAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                var content = this.CreateRequestContent<OmmCaseSummaryGetDetailParams>(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OmmCaseSummaryGetDetailAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                log.Info("OmmCaseSummaryGetDetailAsync returned");
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmCaseSummaryGetDetailModel>();
                }
                return JsonConvert.DeserializeObject<List<OmmCaseSummaryGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("OmmCaseSummaryGetDetailAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Retrieves a list of case herd/species
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use. </param>
        /// <returns></returns>
        public async Task<List<OmmHerdGetListModel>> OmmHerdGetListAsync(OmmHerdSpeciesGetListParams parameters, bool bRefresh) //USP_OMM_Herd_GetList
        {
            log.Info("OmmHerdGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OmmHerdGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                log.Info("OmmHerdGetListAsync returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmHerdGetListModel>();
                }
                return JsonConvert.DeserializeObject<List<OmmHerdGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("OmmHerdGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Retrieves a list of case herd/species
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use. </param>
        /// <returns></returns>
        public async Task<List<OmmSpeciesGetListModel>> OmmSpeciesGetListAsync(OmmHerdSpeciesGetListParams parameters, bool bRefresh) //USP_OMM_Species_GetList
        {
            log.Info("OmmSpeciesGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OmmSpeciesGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                log.Info("OmmSpeciesGetListAsync returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmSpeciesGetListModel>();
                }
                return JsonConvert.DeserializeObject<List<OmmSpeciesGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("OmmSpeciesGetListAsync failed", e);
                throw e;
            }
        }

        public async Task<List<OmmHerdSpeciesSetModel>> OmmHerdSpeciesSetAsync(OmmHerdSpeciesSetParams parameters) //USP_OMM_HerdSpecies_Set
        {
            log.Info("OmmSessionSetAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object.  This will serialize the parms using our formatter!
                var content = this.CreateRequestContent<OmmHerdSpeciesSetParams>(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OmmHerdSpeciesSetAsync"), content).ConfigureAwait(false);

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmHerdSpeciesSetModel>();
                }
                log.Info("OmmSessionSetAsync returned");
                return JsonConvert.DeserializeObject<List<OmmHerdSpeciesSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("OmmSessionSetAsync failed", e);
                throw e;
            }

        }

        public async Task<List<OmmVeterinaryDiseaseSetModel>> OmmVeterinaryDiseaseSetAsync(OmmVeterinaryDiseaseSetParams parameters) //USP_OMM_VETERINARY_DISEASE_SET
        {
            log.Info("OmmVeterinaryDiseaseSetAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object.  This will serialize the parms using our formatter!
                var content = this.CreateRequestContent<OmmVeterinaryDiseaseSetParams>(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OmmVeterinaryDiseaseSetAsync"), content).ConfigureAwait(false);

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<OmmVeterinaryDiseaseSetModel>();
                }
                log.Info("OmmVeterinaryDiseaseSetAsync returned");
                return JsonConvert.DeserializeObject<List<OmmVeterinaryDiseaseSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("OmmVeterinaryDiseaseSetAsync failed", e);
                throw e;
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="langID"></param>
        /// <param name="OutbreakCaseReportUID"></param>
        /// <returns></returns>
        public async Task<OmmVetCaseGetDetailResult> OmmVetCaseGetDetailAsync(OmmCaseGetDetailParams parameters) //USP_OMM_Vet_Case_GetDetail
        {
            log.Info("OmmVetCaseGetDetailAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                var content = this.CreateRequestContent<OmmCaseGetDetailParams>(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OmmVetCaseGetDetailAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                log.Info("OmmVetCaseGetDetailAsync returned");
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new OmmVetCaseGetDetailResult();
                }

                //var payload = JsonConvert.DeserializeObject<Newtonsoft.Json.Linq.JObject>(aPIReturnResult.Results);
                //return payload.First.First.First.ToObject<OmmVetCaseGetDetailResult>();

                #region good

                //var payload = JObject.Parse(aPIReturnResult.Results);

                //var super = payload["OmmVetCaseGetDetailModel"].ToObject<List<OmmVetCaseGetDetailResult>>();
                #endregion

                List<OmmVetCaseGetDetailResult> super = JObject.Parse(aPIReturnResult.Results)["OmmVetCaseGetDetailModel"].ToObject<List<OmmVetCaseGetDetailResult>>();

                var children = JObject.Parse(aPIReturnResult.Results)["OmmVetCaseGetDetailModel"];

                var herdsorflocks = JsonConvert.DeserializeObject<List<OmmVetHerds>>(FindResultSet(ref children, "herdsorflocks"));
                var species = JsonConvert.DeserializeObject<List<OmmVetSpecies>>(FindResultSet(ref children, "species"));
                var animalsinvestigations = JsonConvert.DeserializeObject<List<OmmVetAnimalInvestigation>>(FindResultSet(ref children, "animalsinvestigations"));
                var vaccinations = JsonConvert.DeserializeObject<List<OmmVetVaccination>>(FindResultSet(ref children, "vaccinations"));
                var samples = JsonConvert.DeserializeObject<List<OmmVetSample>>(FindResultSet(ref children, "samples"));
                var pensidetests = JsonConvert.DeserializeObject<List<OmmVetPensideTest>>(FindResultSet(ref children, "pensidetests"));
                var labtests = JsonConvert.DeserializeObject<List<OmmVetLabTest>>(FindResultSet(ref children, "labtests"));
                
                super.FirstOrDefault().HerdsOrFlocks = herdsorflocks;
                super.FirstOrDefault().Species = species;
                super.FirstOrDefault().AnimalsInvestigations = animalsinvestigations;
                super.FirstOrDefault().Vaccinations = vaccinations;
                super.FirstOrDefault().Samples = samples;
                super.FirstOrDefault().PensideTests = pensidetests;
                super.FirstOrDefault().LabTests = labtests;

                return super.FirstOrDefault();
            }
            catch (Exception e)
            {
                log.Error("OmmVetCaseGetDetailAsync failed", e);
                throw e;
            }
        }

        private string FindResultSet(ref JToken children, string strName)
        {
            string hstr = "";

            foreach (var x in children.Children())
            {
                foreach (var y in x.Children())
                    if (y.Path.ToLower().Contains(strName))
                    {
                        var start = y.ToString().IndexOf("[");
                        var end = y.ToString().IndexOf("]") + 1;
                        if (start > 0 && end > 0)
                        {
                            hstr = y.ToString().Substring(start, end - start);

                            hstr = hstr.Replace("\\\"", "\"");
                        }
                        break;
                    }
            }

            return hstr;
        }
    }
}