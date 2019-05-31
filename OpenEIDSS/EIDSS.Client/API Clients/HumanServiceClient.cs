using EIDSS.Client.Abstracts;
using Newtonsoft.Json;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Domain.Return_Contracts;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Threading.Tasks;

namespace EIDSS.Client.API_Clients
{
    public class HumanServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(HumanServiceClient));

        public HumanServiceClient() : base()
        {
            
        }

        #region Human Active Surveillance Methods

        /// <summary>
        /// Retrieves human active surveillance details.
        /// </summary>
        /// <param name="langId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfCampaign"></param>
        /// <returns></returns>
        public async Task<List<GblAscampaignGetDetailModel>> HumanActiveSurveillanceGetDetail(string langId, long? idfCampaign)
        {
            log.Info("HumanActiveSurveillanceGetDetail is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("HUAS-GETDETAIL"))
                {
                    Query = string.Format("langId={0}&idfCampaign={1}", new[] { Convert.ToString(langId), Convert.ToString(idfCampaign) })
                };

                var response = await _apiclient.GetAsync(builder.Uri);

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<GblAscampaignGetDetailModel>();
                }
                log.Info("HumanActiveSurveillanceGetDetail returned");
                return JsonConvert.DeserializeObject<List<GblAscampaignGetDetailModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("HumanActiveSurveillanceGetDetail failed", e);
                throw e;
            }
        }

        public async Task<List<GblAscampaignGetListModel>> HumanActiveSurveillanceCampaignListAsync(HumanActiveSurveillanceGetListParams  humanActiveSurveillanceGetListParams)
        {

            log.Info("HumanActiveSurveillanceCampaignListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parms using our formatter! Beautiful!
                var content = CreateRequestContent(humanActiveSurveillanceGetListParams);

                var response = _apiclient.PostAsync(Settings.GetResourceValue("HUAS-POST-GET-CAMPAIGNLIST"), content).Result;

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<GblAscampaignGetListModel>();
                }
                log.Info("HumanActiveSurveillanceCampaignListAsync returned");
                return JsonConvert.DeserializeObject<List<GblAscampaignGetListModel>>(aPIReturnResult.Results);


            }
            catch (Exception e)
            {
                log.Error("HumanActiveSurveillanceCampaignListAsync failed", e);
                throw e;
            }

        }

        public async Task<SPReturnResult> HumanActiveSurveillanceCampaignDelete(long idfCampaign)
        {
            log.Info("HumanActiveSurveillanceCampaignDelete is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("HUAS-DEL-CAMPAIGN"))
                {
                    Query = string.Format("idfCampaign={0}", new[] { Convert.ToString(idfCampaign) })
                };

                var response =  _apiclient.DeleteAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    //return new Task<SPReturnResult>;
                }
                log.Info("HumanActiveSurveillanceCampaignDelete returned");
                return JsonConvert.DeserializeObject<SPReturnResult>(aPIReturnResult.Results);


                //return await response.Content.ReadAsAsync<SPReturnResult>(new List<MediaTypeFormatter> { Formatter });
            }
            catch (Exception e)
            {
                log.Error("HumanActiveSurveillanceCampaignDelete failed", e);
                throw e;
            }
        }
     
        public async Task<List<GblAscampaignSetModel>> HumanActiveSurveillanceCampaignSet(HumanActiveSurveillanceCampaignSetParams humanActiveSurveillanceCampaignSetParams)
        {
            log.Info("HumanActiveSurveillanceCampaignSet is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parms using our formatter! Beautiful!
                var content = CreateRequestContent(humanActiveSurveillanceCampaignSetParams);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HUAS-POST-SET-CAMPAIGN"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<GblAscampaignSetModel>();
                }
                log.Info("HumanActiveSurveillanceCampaignSet returned");
                return JsonConvert.DeserializeObject<List<GblAscampaignSetModel>>(aPIReturnResult.Results);

               
            }
            catch (Exception e)
            {
                log.Error("HumanActiveSurveillanceCampaignSet failed", e);
                throw e;
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="parms"></param>
        /// <returns></returns>
        public async Task<List<GblAscampaignGetListModel>> HumanActiveSurveillanceGetList(HumanActiveSurveillanceGetListParams parms)
        {
            log.Info("HumanActiveSurveillanceGetList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                var response = await _apiclient.GetAsync(Settings.GetResourceValue("HUAS-GETLIST")).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<GblAscampaignGetListModel>();
                }
                log.Info("HumanActiveSurveillanceGetList returned");
                return JsonConvert.DeserializeObject<List<GblAscampaignGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("HumanActiveSurveillanceGetList failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Human Monitoring Session Search
        /// </summary>
        /// <param name="parameters">A collection of search parameters</param>
        /// <returns></returns>
        public async Task<List<HasMonitoringSessionGetListModel>> GetHumanMonitoringSessionListAsync(MonitoringSessionGetListParameters parameters)
        {
            try
            {
                log.Info("GetHumanMonitoringSessionListAsync is called");
                APIReturnResult aPIReturnResult = new APIReturnResult();

                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HumanMonitoringSessionGetListAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HasMonitoringSessionGetListModel>();
                }
                log.Info("GetHumanMonitoringSessionListAsync returned");
                return JsonConvert.DeserializeObject<List<HasMonitoringSessionGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetHumanMonitoringSessionListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Veterinary Monitoring Session Search Record Count
        /// </summary>
        /// <param name="parameters">A collection of search parameters</param>
        /// <returns></returns>
        public async Task<List<HasMonitoringSessionGetCountModel>> GetHumanMonitoringSessionListCountAsync(MonitoringSessionGetListParameters parameters)
        {
            try
            {
                log.Info("GetHumanMonitoringSessionListCountAsync is called");
                APIReturnResult aPIReturnResult = new APIReturnResult();

                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HumanMonitoringSessionGetListCountAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HasMonitoringSessionGetCountModel>();
                }
                log.Info("GetHumanMonitoringSessionListCountAsync returned");
                return JsonConvert.DeserializeObject<List<HasMonitoringSessionGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetHumanMonitoringSessionListCountAsync failed", e);
                throw e;
            }
        }

        #endregion

        #region Human Methods

        /// <summary>
        /// Search for patients and farm owners associated with disease reports or monitoring sessions.
        /// </summary>
        /// <param name="parameters">A collection of search parameters</param>
        /// <returns></returns>
        public async Task<List<HumHumanGetListModel>> GetHumanListAsync(HumanGetListParams parameters)
        {
            log.Info("GetHumanListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HumanGetListAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumHumanGetListModel>();
                }

                log.Info("GetHumanListAsync returned");
                return JsonConvert.DeserializeObject<List<HumHumanGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetHumanListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of a search query for patients and farm owners associated with disease reports or monitoring sessions.
        /// </summary>
        /// <param name="parameters">A collection of search parameters</param>
        /// <returns></returns>
        public async Task<List<HumHumanGetCountModel>> GetHumanListCountAsync(HumanGetListParams parameters)
        {
            log.Info("GetHumanListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HumanGetListCountAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumHumanGetCountModel>();
                }

                log.Info("GetHumanListCountAsync returned");
                return JsonConvert.DeserializeObject<List<HumHumanGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetHumanListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Search for patients and farm owners associated with disease reports or monitoring sessions.
        /// </summary>
        /// <param name="parameters">A collection of search parameters</param>
        /// <returns></returns>
        public async Task<List<HumHumanMasterGetListModel>> GetHumanMasterListAsync(HumanGetListParams parameters)
        {
            log.Info("GetHumanMasterListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HumanMasterGetListAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumHumanMasterGetListModel>();
                }

                log.Info("GetHumanMasterListAsync returned");
                return JsonConvert.DeserializeObject<List<HumHumanMasterGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetHumanMasterListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of a search query for patients and farm owners associated with disease reports or monitoring sessions.
        /// </summary>
        /// <param name="parameters">A collection of search parameters</param>
        /// <returns></returns>
        public async Task<List<HumHumanMasterGetCountModel>> GetHumanMasterListCountAsync(HumanGetListParams parameters)
        {
            log.Info("GetHumanMasterListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HumanMasterGetListCountAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumHumanMasterGetCountModel>();
                }

                log.Info("GetHumanMasterListCountAsync returned");
                return JsonConvert.DeserializeObject<List<HumHumanMasterGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetHumanMasterListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="humanMasterId"></param>
        /// <returns></returns>
        public async Task<List<HumHumanMasterGetDetailModel>> GetHumanMasterDetailAsync(string languageId, long humanMasterId)
        {
            log.Info("GetHumanMasterDetailAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("HumanMasterGetDetailAsync"))
                {
                    Query = string.Format("languageId={0}&humanMasterId={1}", new[] { languageId, Convert.ToString(humanMasterId) })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumHumanMasterGetDetailModel>();
                }

                log.Info("GetHumanMasterDetailAsync returned");
                return JsonConvert.DeserializeObject<List<HumHumanMasterGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetHumanDetailAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Processes new and existing updates to human master record information.
        /// </summary>
        /// <param name="parameters"></param>
        /// <returns>Returns a HumanMasterSetModel Instance that specifies the completion of the operation.</returns>
        public async Task<List<HumHumanMasterSetModel>> SaveHumanMasterAsync(HumanSetParam parameters)
        {
            log.Info("SaveHumanMasterAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parms using our formatter! Beautiful!
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HumanMasterSaveAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumHumanMasterSetModel>();
                }

                log.Info("SaveHumanMasterAsync returned");
                return JsonConvert.DeserializeObject<List<HumHumanMasterSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("SaveHumanMasterAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Deletes a human master record
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="humanMasterId"></param>
        /// <returns></returns>
        public async Task<List<HumHumanSetModel>> DeleteHumanMasterAsync(string languageId, long humanMasterId)
        {
            log.Info("DeleteHumanMasterAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("HumanMasterDeleteAsync"))
                {
                    Query = string.Format("languageId={0}&humanMasterId={1}", new[] { languageId, Convert.ToString(humanMasterId) })
                };

                var response = _apiclient.DeleteAsync(builder.Uri).Result;

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                response.EnsureSuccessStatusCode();
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumHumanSetModel>();
                }
                log.Info("DeleteHumanMasterAsync returned");
                return JsonConvert.DeserializeObject<List<HumHumanSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("DeleteHumanMasterAsync failed", e);
                throw e;
            }
        }
        #endregion

        #region Human Disease Report Methods

        /// <summary>
        /// Human Disease Report Search Record Count
        /// </summary>
        /// <param name="parameters">A collection of search parameters</param>
        /// <returns></returns>
        public async Task<List<HumDiseaseReportGetCountModel>> GetHumanDiseaseReportListCountAsync(HumanDiseaseReportGetListParams parameters)
        {
            log.Info("GetHumanDiseaseReportListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HumanDiseaseReportGetListCountAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumDiseaseReportGetCountModel>();
                }
                log.Info("GetHumanDiseaseReportListCountAsync returned");
                return JsonConvert.DeserializeObject<List<HumDiseaseReportGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetHumanDiseaseReportListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Human Disease Report Search
        /// </summary>
        /// <param name="parameters">A collection of search parameters</param>
        /// <returns></returns>
        public async Task<List<HumDiseaseReportGetListModel>> GetHumanDiseaseReportListAsync(HumanDiseaseReportGetListParams parameters)
        {
            log.Info("GetHumanDiseaseReportListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HumanDiseaseReportGetListAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumDiseaseReportGetListModel>();
                }
                log.Info("GetHumanDiseaseReportListAsync returned");
                return JsonConvert.DeserializeObject<List<HumDiseaseReportGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetHumanDiseaseReportListAsync failed", e);
                throw e;
            }
        }


        /// <summary>
        /// Human Disease  Report  Advance Search
        /// </summary>
        /// <param name="parameters">A collection of search parameters</param>
        /// <returns></returns>
        public async Task<List<HumDiseaseAdvanceSearchReportGetListModel>> GetHumanDiseaseAdvanceSearchReportListAsync(HumanDiseaseAdvanceSearchParams parameters)
        {
            log.Info("GetHumanDiseaseAdvanceSearchReportListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HUM-DISEASEREPORT-ADV-SEARCH-GETLIST"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumDiseaseAdvanceSearchReportGetListModel>();
                }
                log.Info("GetHumanDiseaseAdvanceSearchReportListAsync returned");
                return JsonConvert.DeserializeObject<List<HumDiseaseAdvanceSearchReportGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetHumanDiseaseAdvanceSearchReportListAsync failed", e);
                throw e;
            }
        }






        





        /// <summary>
        /// Gets Human Disease List
        /// </summary>
        /// <param name="humanDiseaseGetListParams">HumanDiseaseGetListParams object from contracts</param>
        /// <returns>List Of HumDiseaseGetListModel</returns>
        public async Task<List<HumDiseaseGetListModel>> GetHumanDiseaseList(HumanDiseaseGetListParams humanDiseaseGetListParams)
        {
            log.Info("GetHumanDiseaseList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(humanDiseaseGetListParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HUM-GetDiseaseList"), content).ConfigureAwait(false);

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                response.EnsureSuccessStatusCode();
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumDiseaseGetListModel>();
                }
                log.Info("GetHumanDiseaseList returned");
                return JsonConvert.DeserializeObject<List<HumDiseaseGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetHumanDiseaseList failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Get Details about a Human Disease
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfHumanActual">Actual Human Id</param>
        /// <returns></returns>
        public async Task<List<HumDiseaseGetDetailModel>> GetHumanDiseaseDetail(string languageId, long? searchHumanCaseId)
        {
            log.Info("GetHumanDiseaseDetail is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("HUM-GetDiseaseDetail"))
                {
                    Query = string.Format("languageId={0}&searchHumanCaseId={1}", new[] { Convert.ToString(languageId), Convert.ToString(searchHumanCaseId) })
                };

                var response =  _apiclient.GetAsync(builder.Uri).Result;

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                response.EnsureSuccessStatusCode();
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumDiseaseGetDetailModel>();
                }
                log.Info("GetHumanDiseaseDetail returned");
                return JsonConvert.DeserializeObject<List<HumDiseaseGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetHumanDiseaseDetail failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Saves a Human Disease Record
        /// </summary>
        /// <param name="humanDiseaseSetParams"></param>
        /// <returns></returns>
        public async Task<List<HumHumanDiseaseSetModel>> SetHumanDisease(HumanDiseaseSetParams humanDiseaseSetParams)
        {
            log.Info("SetHumanDisease is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(humanDiseaseSetParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HUM-SetDisease"), content).ConfigureAwait(false);

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                response.EnsureSuccessStatusCode();
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumHumanDiseaseSetModel>();
                }
                log.Info("SetHumanDisease returned");
                return JsonConvert.DeserializeObject<List<HumHumanDiseaseSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("SetHumanDisease failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Deletes a Human Disease
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfHumanCase"></param>
        /// <returns></returns>
        public async Task<List<HumHumanDiseaseDelModel>> DeleteHumanDisease(string languageId, long? idfHumanCase)
        {
            log.Info("DeleteHumanDisease is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("HUM-DeleteDisease"))
                {
                    Query = string.Format("languageId={0}&idfHumanCase={1}", new[] { Convert.ToString(languageId), Convert.ToString(idfHumanCase) })
                };

                var response =  _apiclient.DeleteAsync(builder.Uri).Result;

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                response.EnsureSuccessStatusCode();
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumHumanDiseaseDelModel>();
                }
                log.Info("DeleteHumanDisease returned");
                return JsonConvert.DeserializeObject<List<HumHumanDiseaseDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("DeleteHumanDisease failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Returns a list of Human Samples
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfHumanCase"></param>
        /// <param name="searchDiagnosis"></param>
        /// <returns></returns>
        public async Task<List<HumSamplesGetListModel>> GetHumanSamples(string languageId, long? idfHumanCase, long? searchDiagnosis)
        {
            log.Info("GetHumanSamples is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("HUM-GetSamples"))
                {
                    Query = string.Format("languageId={0}&idfHumanCase={1}&searchDiagnosis={2}", new[] { Convert.ToString(languageId), Convert.ToString(idfHumanCase), Convert.ToString(searchDiagnosis) })
                };

                var response =  _apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                log.Info("GetHumanSamples returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                response.EnsureSuccessStatusCode();
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumSamplesGetListModel>();
                }
                log.Info("GetHumanSamples returned");
                return JsonConvert.DeserializeObject<List<HumSamplesGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetHumanSamples failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Returns Human Disease Contacts
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfHumanCase"></param>
        /// <returns></returns>
        public async Task<List<HumDiseaseContactsGetListModel>> GetHumanDiseaseContacts(string languageId, long? idfHumanCase)
        {
            log.Info("GetHumanDiseaseContacts is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("HUM-GetDiseaseContacts"))
                {
                    Query = string.Format("languageId={0}&idfHumanCase={1}", new[] { Convert.ToString(languageId), Convert.ToString(idfHumanCase) })
                };

                var response =  _apiclient.GetAsync(builder.Uri).Result;

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                response.EnsureSuccessStatusCode();
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumDiseaseContactsGetListModel>();
                }
                log.Info("GetHumanDiseaseContacts returned");
                return JsonConvert.DeserializeObject<List<HumDiseaseContactsGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetHumanDiseaseContacts failed", e);
                throw e;
            }
        }

        public async Task<List<HumDiseaseContactsSetModel>> SetHumanDiseaseContacts(HumanDiseaseSetContactParams humanDiseaseSetContactParams)
        {
            log.Info("SetHumanDiseaseContacts is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(humanDiseaseSetContactParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HUM-SetDiseaseContacts"), content).ConfigureAwait(false);

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                response.EnsureSuccessStatusCode();
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumDiseaseContactsSetModel>();
                }
                log.Info("SetHumanDiseaseContacts returned");
                return JsonConvert.DeserializeObject<List<HumDiseaseContactsSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("SetHumanDiseaseContacts failed", e);
                throw e;
            }
        }

        public async Task<List<HumTestsGetListModel>> GetHumanDiseaseTests(string languageId, long? idfHumanCase, long? searchDiagnosis)
        {
            log.Info("GetHumanDiseaseTests is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("HUM-GetDiseaseTests"))
                {
                    Query = string.Format("languageId={0}&idfHumanCase={1}&searchDiagnosis={2}", new[] { Convert.ToString(languageId), Convert.ToString(idfHumanCase), Convert.ToString(searchDiagnosis), })
                };

                var response = _apiclient.GetAsync(builder.Uri).Result;

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                response.EnsureSuccessStatusCode();
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumTestsGetListModel>();
                }
                log.Info("GetHumanDiseaseTests returned");
                return JsonConvert.DeserializeObject<List<HumTestsGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetHumanDiseaseTests failed", e);
                throw e;
            }
        }

        public async Task<List<HumDiseaseVaccinationsGetListModel>> HumDiseaseVaccinationsGetListAsync(string languageId, long? idfHumanCase)
        {
            log.Info("HumDiseaseVaccinationsGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("HUM-GetHUMDISEASEVAC-ASYNC"))
                {
                    Query = string.Format("languageId={0}&idfHumanCase={1}", new[] { Convert.ToString(languageId), Convert.ToString(idfHumanCase) })
                };

                var response = _apiclient.GetAsync(builder.Uri).Result;

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                response.EnsureSuccessStatusCode();
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumDiseaseVaccinationsGetListModel>();
                }
                log.Info("HumDiseaseVaccinationsGetListAsync returned");
                return JsonConvert.DeserializeObject<List<HumDiseaseVaccinationsGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("HumDiseaseVaccinationsGetListAsync failed", e);
                throw e;
            }
        }

        public async Task<List<HumHumanDiseaseVaccinationSetModel>> SetHumDiseaseVaccination(HumanDiseaseVaccinationSetParams humanDiseaseVaccinationSetParams)
        {
            log.Info("SetHumDiseaseVaccination is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(humanDiseaseVaccinationSetParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HUM-SetDiseaseVaccination"), content).ConfigureAwait(false);

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                response.EnsureSuccessStatusCode();
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumHumanDiseaseVaccinationSetModel>();
                }
                log.Info("SetHumDiseaseVaccination returned");
                return JsonConvert.DeserializeObject<List<HumHumanDiseaseVaccinationSetModel>>(aPIReturnResult.Results);
            }            
            catch (Exception e)
            {
                log.Error("SetHumDiseaseVaccination failed", e);
                throw e;
            }
        }

        public async Task<List<HumDiseaseAntiviraltherapiesGetListModel>> HumDiseaseAntiviraltherapiesGetListAsync(string languageId, long? idfHumanCase)
        {
            log.Info("HumDiseaseAntiviraltherapiesGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("HUM-GetHUMDISANTIVIRAL-ASYNC"))
                {
                    Query = string.Format("languageId={0}&idfHumanCase={1}", new[] { Convert.ToString(languageId), Convert.ToString(idfHumanCase) })
                };

                var response = _apiclient.GetAsync(builder.Uri).Result;

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                response.EnsureSuccessStatusCode();
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumDiseaseAntiviraltherapiesGetListModel>();
                }
                log.Info("HumDiseaseAntiviraltherapiesGetListAsync returned");
                return JsonConvert.DeserializeObject<List<HumDiseaseAntiviraltherapiesGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("HumDiseaseAntiviraltherapiesGetListAsync failed", e);
                throw e;
            }
        }

        public async Task<List<HumDiseaseAntiviraltherapySetModel>> SetHumDiseaseAntiviraltherapy(HumanDiseaseAntViralTherapySetParmas humanDiseaseAntViralTherapySetParmas)
        {
            log.Info("SetHumDiseaseAntiviraltherapy is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(humanDiseaseAntViralTherapySetParmas);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HUM-SetDiseaseantiviralTherapy"), content).ConfigureAwait(false);

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                response.EnsureSuccessStatusCode();
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumDiseaseAntiviraltherapySetModel>();
                }
                log.Info("SetHumDiseaseAntiviraltherapy returned");
                return JsonConvert.DeserializeObject<List<HumDiseaseAntiviraltherapySetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("SetHumDiseaseAntiviraltherapy failed", e);
                throw e;
            }
        }
        
        public async Task<List<HumDiseasePersoninformationGetDetailModel>> GetHumDiseasePersoninformationDetailAsync(string languageId, long? idfHuman, long? idfHumanActual)
        {
            log.Info("GetHumDiseasePersoninformationDetailAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("Hum-GetDiseasePersoninformationDetailAsync"))
                {
                    Query = string.Format("languageId={0}&idfHuman={1}&idfHumanActual={2}", new[] { languageId, Convert.ToString(idfHuman), Convert.ToString(idfHumanActual) })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumDiseasePersoninformationGetDetailModel>();
                }

                log.Info("GetHumDiseasePersoninformationDetailAsync returned");
                return JsonConvert.DeserializeObject<List<HumDiseasePersoninformationGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetHumDiseasePersoninformationDetailAsync", e);
                throw e;
            }
        }

        #endregion

        #region Human Aggregate Methods
        public async Task<List<HumanAggregateCaseDeleteModel>> HumanAggregateCaseDeleteAsync(long id)
        {
            log.Info("HumanAggregateCaseDeleteAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("HUM-AGGCASE-DELETE"))
                {
                    Query = string.Format("id={0}", new[] { Convert.ToString(id) })
                };

                var response = _apiclient.DeleteAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                log.Info("HumanAggregateCaseDeleteAsync returned");


                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HumanAggregateCaseDeleteModel>();
                }
                log.Info("HumanAggregateCaseDeleteAsync returned");
                return JsonConvert.DeserializeObject<List<HumanAggregateCaseDeleteModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("HumanAggregateCaseDeleteAsync failed", e);
                throw e;
            }
        }


        public async Task<List<RepHumOrganizationSelectLookupModel>> RepHumOrganizationSelectLookupAsync(string languageId, long id)
        {
            log.Info("RepHumOrganizationSelectLookupAsync is called");
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("HUM-REPORGSEL-LKUP"))
                {
                    Query = string.Format("languageId={languageId}&id={id}", new[] { Convert.ToString(languageId), Convert.ToString(id) })
                };

                var response = _apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                log.Info("RepHumOrganizationSelectLookupAsync returned");

                return await response.Content.ReadAsAsync<List<RepHumOrganizationSelectLookupModel>>(new List<MediaTypeFormatter> { Formatter });
            }
            catch (Exception e)
            {
                log.Error("RepHumOrganizationSelectLookupAsync failed", e);
                throw e;
            }
        }



        public async Task<List<AggregateSettingsSelectDetailModel>> AggregateSettingsSelectDetailAsync(long? idfsAggCaseType)
        {
            log.Info("AggregateSettingsSelectDetailAsync is called");
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("HUM-AGGSETTINGDETAIL"))
                {
                    Query = string.Format("idfsAggCaseType={idfsAggCaseType}", new[] { Convert.ToString(idfsAggCaseType)})
                };

                var response = _apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                log.Info("AggregateSettingsSelectDetailAsync returned");

                return await response.Content.ReadAsAsync<List<AggregateSettingsSelectDetailModel>>(new List<MediaTypeFormatter> { Formatter });
            }
            catch (Exception e)
            {
                log.Error("AggregateSettingsSelectDetailAsync failed", e);
                throw e;
            }
        }


        


        public async Task<List<AggCaseGetlistModel>> AggCaseGetlistAsync(AggCaseGetListParams  aggCaseGetListParams)
        {
            log.Info("AggCaseGetlistAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(aggCaseGetListParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HUM-AGGCASE-GETLIST"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AggCaseGetlistModel>();
                }
                log.Info("AggCaseGetlistAsync returned");
                return JsonConvert.DeserializeObject<List<AggCaseGetlistModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("AggCaseGetlistAsync failed", e);
                throw e;
            }
        }





        public async Task<List<AggCaseSetModel>> AggCaseSetAsync(AggCaseSetParams  aggCaseSetParams)
        {
            log.Info("AggCaseSetAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(aggCaseSetParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HUM-AGGCASE-SET"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AggCaseSetModel>();
                }
                log.Info("AggCaseSetAsync returned");
                return JsonConvert.DeserializeObject<List<AggCaseSetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("AggCaseSetAsync failed", e);
                throw e;
            }
        }


        public async Task<List<IliAggregateGetListModel>> ILIAggCaseGetlistAsync(string languageId, string strFormId, long idfAggregateHeader, long siteId, long idfHospital, System.DateTime datStartDate, System.DateTime datFinishDate)
        {
            log.Info("AggCaseGetlistAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("HUM-ILIAGGCASE-GETLIST"))

                {
                   Query = string.Format("languageId={0}&strFormId={1}&idfAggregateHeader={2}&siteId={3}&idfHospital={4}&datStartDate={5}&datFinishDate={6}", new[] { Convert.ToString(languageId), Convert.ToString(strFormId), Convert.ToString(idfAggregateHeader), Convert.ToString(siteId), Convert.ToString(idfHospital), Convert.ToString(datStartDate), Convert.ToString(datFinishDate) })

                };


                var response = _apiclient.GetAsync(builder.Uri).Result;
                response.EnsureSuccessStatusCode();
              
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<IliAggregateGetListModel>();
                }
                log.Info("AggCaseSetAsync returned");
                return JsonConvert.DeserializeObject<List<IliAggregateGetListModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("ILIAggCaseGetlistAsync failed", e);
                throw e;
            }
        }

        public async Task<List<IliAggregateSetModel>> ILIAggCaseSetAsync(ILIAggregateSetParams iliaggCaseSetParams)
        {
            log.Info("ILIAggCaseSetAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(iliaggCaseSetParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("HUM-ILIAGGCASE-SET"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<IliAggregateSetModel>();
                }
                log.Info("AggCaseSetAsync returned");
                return JsonConvert.DeserializeObject<List<IliAggregateSetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("ILIAggCaseSetAsync failed", e);
                throw e;
            }
        }


        public async Task<List<IliAggregateDeleteModel>> ILIAggregateCaseDeleteAsync(long idfAggregateDetail, long idfAggregateHeader)
        {
            log.Info("ILIAggregateCaseDeleteAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("HUM-ILIAGGCASE-DELETE"))
                {
                    Query = string.Format("idfAggregateDetail={0}&idfAggregateHeader={1}", new[] { Convert.ToString(idfAggregateDetail), Convert.ToString(idfAggregateHeader) })
                };

                var response = _apiclient.DeleteAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                log.Info("ILIAggregateCaseDeleteAsync returned");


                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<IliAggregateDeleteModel>();
                }
                log.Info("ILIAggregateCaseDeleteAsync returned");
                return JsonConvert.DeserializeObject<List<IliAggregateDeleteModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("ILIAggregateCaseDeleteAsync failed", e);
                throw e;
            }
        }


        public async Task<List<GblDiseaseMtxGetModel>> HumanAggCaseGetMTXlistAsync(long idfsBaseReference, int intHaCode, string strLanguageId)
        {
            log.Info("HumanAggCaseGetMTXlistAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("CONF-AGGCASEMTX-GETLIST"))
                {
                    Query = string.Format("idfsBaseReference={0}&intHaCode={1}&strLanguageId={2}", new[] { Convert.ToString(idfsBaseReference), Convert.ToString(intHaCode), Convert.ToString(strLanguageId) })
                };

                var response =  _apiclient.GetAsync(builder.Uri).Result;
                response.EnsureSuccessStatusCode();
                // Call the service.
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<GblDiseaseMtxGetModel>();
                }
                log.Info("HumanAggCaseGetMTXlistAsync returned");
                return JsonConvert.DeserializeObject<List<GblDiseaseMtxGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("HumanAggCaseGetMTXlistAsync failed", e);
                throw e;
            }
        }



        public async Task<List<ConfHumanAggregateCaseMatrixVersionPostModel>> HumanAggReportSaveVersion(AggregateCaseVerionPostParams aggregateCaseVerionPostParams)
        {
            log.Info("HumanAggReportSaveVersion is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(aggregateCaseVerionPostParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-AGGCASEMTX-VERSION-POST"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfHumanAggregateCaseMatrixVersionPostModel>();
                }
                log.Info("HumanAggReportSaveVersion returned");
                return JsonConvert.DeserializeObject<List<ConfHumanAggregateCaseMatrixVersionPostModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("HumanAggReportSaveVersion failed", e);
                throw e;
            }
        }




        #endregion
    }
}

