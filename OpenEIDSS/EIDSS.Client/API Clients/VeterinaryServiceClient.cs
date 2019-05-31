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
    public class VeterinaryServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(VeterinaryServiceClient));

        public VeterinaryServiceClient() : base()
        {
        }

        #region Campaign Methods

        /// <summary>
        /// Gets a list of active surveillance campaign records matching user provided search criteria.
        /// </summary>
        /// <param name="parameters">A collection of search parameters</param>
        /// <returns></returns>
        public async Task<List<VctCampaignGetListModel>> GetCampaignListAsync(CampaignGetListParameters parameters)
        {
            log.Info("GetCampaignListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("VeterinaryCampaignGetListAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctCampaignGetListModel>();
                }

                log.Info("GetCampaignListAsync returned");
                return JsonConvert.DeserializeObject<List<VctCampaignGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetCampaignListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a record count of active surveillance campaigns matching the search criteria, as well as, the total record count.
        /// </summary>
        /// <param name="parameters">A collection of search parameters</param>
        /// <returns></returns>
        public async Task<List<VctCampaignGetCountModel>> GetCampaignCountAsync(CampaignGetListParameters parameters)
        {
            log.Info("GetCampaignCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("VeterinaryCampaignGetCountAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctCampaignGetCountModel>();
                }

                log.Info("GetCampaignCountAsync returned");
                return JsonConvert.DeserializeObject<List<VctCampaignGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetCampaignCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a single active surveillance campaign record based on a user provided campaign ID.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="veterinaryDiseaseReportID"></param>
        /// <returns></returns>
        public async Task<List<VctCampaignGetDetailModel>> GetCampaignDetailAsync(string languageID, long campaignID)
        {
            log.Info("GetCampaignDetailAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VeterinaryCampaignGetDetailAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    Query = string.Format("languageID={0}&campaignID={1}",

                    new[] { languageID, Convert.ToString(campaignID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctCampaignGetDetailModel>();
                }

                log.Info("GetCampaignDetailAsync returned");
                return JsonConvert.DeserializeObject<List<VctCampaignGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetCampaignDetailAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Processes new and existing updates active surveillance campaign information.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="CampaignSetParameters"/>.</param>
        /// <returns>Returns an SPReturnResult instance that specifies the completion of the operation <see cref="VctCampaignSetModel"/>.</returns>
        public async Task<List<VctCampaignSetModel>> SaveCampaignAsync(CampaignSetParameters parameters)
        {
            log.Info("SaveCampaignAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("VeterinaryCampaignSaveAsync"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctCampaignSetModel>();
                }

                log.Info("SaveCampaignAsync returned");
                return JsonConvert.DeserializeObject<List<VctCampaignSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("SaveCampaignAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Deletes an active surevillance campaign.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country.</param>
        /// <param name="campaignID">A system assigned internal unique key that identifies the monitoring session to delete.</param>
        /// <returns></returns>
        public async Task<List<VctCampaignDelModel>> DeleteCampaignAsync(string languageID, long campaignID)
        {
            log.Info("DeleteCampaignAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VeterinaryCampaignDeleteAsync"))
                {
                    Query = string.Format("languageID={0}&campaignID={1}", new[] { Convert.ToString(languageID), Convert.ToString(campaignID) })
                };

                var response = _apiclient.DeleteAsync(builder.Uri).Result;

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                response.EnsureSuccessStatusCode();
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctCampaignDelModel>();
                }

                log.Info("DeleteCampaignAsync returned");
                return JsonConvert.DeserializeObject<List<VctCampaignDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("DeleteCampaignAsync failed", e);
                throw e;
            }
        }

        #endregion

        #region Monitoring Session Methods

        /// <summary>
        /// Active Surveillance Monitoring Session Search
        /// </summary>
        /// <param name="parameters">A collection of search parameters</param>
        /// <returns></returns>
        public async Task<List<VctMonitoringSessionGetListModel>> GetMonitoringSessionListAsync(MonitoringSessionGetListParameters parameters)
        {
            log.Info("GetMonitoringSessionListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("VeterinaryMonitoringSessionGetListAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctMonitoringSessionGetListModel>();
                }

                log.Info("GetMonitoringSessionListAsync returned");
                return JsonConvert.DeserializeObject<List<VctMonitoringSessionGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetMonitoringSessionListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Veterinary Monitoring Session Search Record Count
        /// </summary>
        /// <param name="parameters">A collection of search parameters</param>
        /// <returns></returns>
        public async Task<List<VctMonitoringSessionGetCountModel>> GetMonitoringSessionCountAsync(MonitoringSessionGetListParameters parameters)
        {
            log.Info("GetMonitoringSessionCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("VeterinaryMonitoringSessionGetCountAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctMonitoringSessionGetCountModel>();
                }

                log.Info("GetMonitoringSessionCountAsync returned");
                return JsonConvert.DeserializeObject<List<VctMonitoringSessionGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetMonitoringSessionCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="monitoringSessionID"></param>
        /// <returns></returns>
        public async Task<List<VctMonitoringSessionGetDetailModel>> GetMonitoringSessionDetailAsync(string languageID, long monitoringSessionID)
        {
            log.Info("GetMonitoringSessionDetailAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VeterinaryMonitoringSessionGetDetailAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    Query = string.Format("languageID={0}&monitoringSessionID={1}",

                    new[] { languageID, Convert.ToString(monitoringSessionID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctMonitoringSessionGetDetailModel>();
                }

                log.Info("GetMonitoringSessionDetailAsync returned");
                return JsonConvert.DeserializeObject<List<VctMonitoringSessionGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetMonitoringSessionDetailAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Processes new and existing updates active surveillance monitoring session information.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="MonitoringSessionSetParams"/>.</param>
        /// <returns>Returns an SPReturnResult instance that specifies the completion of the operation <see cref="VctMonitoringSessionSetModel"/>.</returns>
        public async Task<List<VctMonitoringSessionSetModel>> SaveMonitoringSessionAsync(MonitoringSessionSetParameters parameters)
        {
            log.Info("SaveMonitoringSessionAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("VeterinaryMonitoringSessionSaveAsync"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctMonitoringSessionSetModel>();
                }

                log.Info("SaveMonitoringSessionAsync returned");
                return JsonConvert.DeserializeObject<List<VctMonitoringSessionSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("SaveMonitoringSessionAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Deletes an active surevillance monitoring session.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="monitoringSessionID">A system assigned internal unique key that identifies the monitoring session to delete.</param>
        /// <returns></returns>
        public async Task<List<VctMonitoringSessionDelModel>> DeleteMonitoringSessionAsync(string languageID, long monitoringSessionID)
        {
            log.Info("DeleteMonitoringSessionAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VeterinaryMonitoringSessionDeleteAsync"))
                {
                    Query = string.Format("languageID={0}&monitoringSessionID={1}", new[] { Convert.ToString(languageID), Convert.ToString(monitoringSessionID) })
                };

                var response = _apiclient.DeleteAsync(builder.Uri).Result;

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                response.EnsureSuccessStatusCode();
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctMonitoringSessionDelModel>();
                }

                log.Info("DeleteMonitoringSessionAsync returned");
                return JsonConvert.DeserializeObject<List<VctMonitoringSessionDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("DeleteMonitoringSessionAsync failed", e);
                throw e;
            }
        }

        #endregion

        #region Disease Report Methods

        /// <summary>
        /// Veterinary Disease Report Search
        /// </summary>
        /// <param name="parameters">A collection of search parameters</param>
        /// <returns></returns>
        public async Task<List<VetDiseaseReportGetListModel>> GetVeterinaryDiseaseReportListAsync(VeterinaryDiseaseReportGetListParameters parameters)
        {
            log.Info("GetVeterinaryDiseaseReportListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("VeterinaryDiseaseReportGetListAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VetDiseaseReportGetListModel>();
                }

                log.Info("GetVeterinaryDiseaseReportListAsync returned");
                return JsonConvert.DeserializeObject<List<VetDiseaseReportGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetVeterinaryDiseaseReportListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Veterinary Disease Report Search Record Count
        /// </summary>
        /// <param name="parameters">A collection of search parameters</param>
        /// <returns></returns>
        public async Task<List<VetDiseaseReportGetCountModel>> GetVeterinaryDiseaseReportListCountAsync(VeterinaryDiseaseReportGetListParameters parameters)
        {
            log.Info("GetVeterinaryDiseaseReportListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("VeterinaryDiseaseReportGetListCountAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VetDiseaseReportGetCountModel>();
                }

                log.Info("GetVeterinaryDiseaseReportListCountAsync returned");
                return JsonConvert.DeserializeObject<List<VetDiseaseReportGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetVeterinaryDiseaseReportListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="veterinaryDiseaseReportID"></param>
        /// <returns></returns>
        public async Task<List<VetDiseaseReportGetDetailModel>> GetVeterinaryDiseaseReportDetailAsync(string languageID, long veterinaryDiseaseReportID)
        {
            log.Info("GetVeterinaryDiseaseReportDetailAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VeterinaryDiseaseReportGetDetailAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    Query = string.Format("languageID={0}&veterinaryDiseaseReportID={1}",

                    new[] { languageID, Convert.ToString(veterinaryDiseaseReportID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VetDiseaseReportGetDetailModel>();
                }

                log.Info("GetVeterinaryDiseaseReportDetailAsync returned");
                return JsonConvert.DeserializeObject<List<VetDiseaseReportGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetVeterinaryDiseaseReportDetailAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Processes new and existing updates veterinary disease report information.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="VeterinaryDiseaseReportSetParameters"/>.</param>
        /// <returns>Returns an SPReturnResult instance that specifies the completion of the operation <see cref="VetDiseaseReportSetModel"/>.</returns>
        public async Task<List<VetDiseaseReportSetModel>> SaveVeterinaryDiseaseReportAsync(VeterinaryDiseaseReportSetParameters parameters)
        {
            log.Info("SaveVeterinaryDiseaseReportAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("VeterinaryDiseaseReportSaveAsync"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VetDiseaseReportSetModel>();
                }

                log.Info("SaveVeterinaryDiseaseReportAsync returned");
                return JsonConvert.DeserializeObject<List<VetDiseaseReportSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("SaveVeterinaryDiseaseReportAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Deletes a veterinary disease report.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="veterinaryDiseaseReportID">A system assigned internal unique key that identifies the veterinary disease report to delete.</param>
        /// <returns></returns>
        public async Task<List<VetDiseaseReportDelModel>> DeleteVeterinaryDiseaseReportAsync(string languageID, long veterinaryDiseaseReportID)
        {
            log.Info("DeleteVeterinaryDiseaseReport is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VeterinaryDiseaseReportDeleteAsync"))
                {
                    Query = string.Format("languageID={0}&veterinaryDiseaseReportID={1}", new[] { Convert.ToString(languageID), Convert.ToString(veterinaryDiseaseReportID) })
                };

                var response = _apiclient.DeleteAsync(builder.Uri).Result;

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                response.EnsureSuccessStatusCode();
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VetDiseaseReportDelModel>();
                }

                log.Info("DeleteVeterinaryDiseaseReport returned");
                return JsonConvert.DeserializeObject<List<VetDiseaseReportDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("DeleteVeterinaryDiseaseReport failed", e);
                throw e;
            }
        }

        #endregion

        #region Animal Methods

        /// <summary>
        /// Gets a list of animals associated with veterinary disease report and monitoring session records.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="speciesID"></param>
        /// <param name="sampleID"></param>
        /// <param name="veterinaryDiseaseReportID"></param>
        /// <param name="monitoringSessionID"></param>
        /// <param name="observationID"></param>
        /// <returns></returns>
        public async Task<List<VetAnimalGetListModel>> GetAnimalListAsync(string languageID, long? veterinaryDiseaseReportID, long? monitoringSessionID, long? speciesID, long? sampleID, long? observationID)
        {
            log.Info("GetAnimalListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("AnimalGetListAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Veterinary/AnimalGetListAsync?languageID={0}&veterinaryDiseaseReportID={1}&monitoringSessionID={2}&speciesID={3}&sampleID={4}&observationID={5}
                    Query = string.Format("languageID={0}&veterinaryDiseaseReportID={1}&monitoringSessionID={2}&speciesID={3}&sampleID={4}&observationID={5}", new[] { languageID, Convert.ToString(veterinaryDiseaseReportID), Convert.ToString(monitoringSessionID), Convert.ToString(speciesID), Convert.ToString(sampleID), Convert.ToString(observationID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VetAnimalGetListModel>();
                }

                log.Info("GetAnimalListAsync returned");
                return JsonConvert.DeserializeObject<List<VetAnimalGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetAnimalListAsync failed", e);
                throw e;
            }
        }

        #endregion

        #region Vaccination Methods

        /// <summary>
        /// Gets a list of vaccinations associated with veterinary disease report records.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="veterinaryDiseaseReportID"></param>
        /// <param name="speciesID"></param>
        /// <returns></returns>
        public async Task<List<VetVaccinationGetListModel>> GetVaccinationListAsync(string languageID, long? veterinaryDiseaseReportID, long? speciesID)
        {
            log.Info("GetVaccinationListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VaccinationGetListAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Veterinary/VaccinationGetListAsync?languageID={0}&veterinaryDiseaseReportID={1}&speciesID={2}
                    Query = string.Format("languageID={0}&veterinaryDiseaseReportID={1}&speciesID={2}", new[] { languageID, Convert.ToString(veterinaryDiseaseReportID), Convert.ToString(speciesID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VetVaccinationGetListModel>();
                }

                log.Info("GetVaccinationListAsync returned");
                return JsonConvert.DeserializeObject<List<VetVaccinationGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetVaccinationListAsync failed", e);
                throw e;
            }
        }

        #endregion

        #region Penside Test Methods

        /// <summary>
        /// Gets a list of penside tests associated with veterinary disease report records.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="veterinaryDiseaseReportID"></param>
        /// <param name="sampleID"></param>
        /// <returns></returns>
        public async Task<List<VetPensideTestGetListModel>> GetPensideTestListAsync(string languageID, long? veterinaryDiseaseReportID, long? sampleID)
        {
            log.Info("GetPensideTestListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("PensideTestGetListAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Veterinary/PensideTestGetListAsync?languageID={0}&veterinaryDiseaseReportID={1}&sampleID={2}
                    Query = string.Format("languageID={0}&veterinaryDiseaseReportID={1}&sampleID={2}", new[] { languageID, Convert.ToString(veterinaryDiseaseReportID), Convert.ToString(sampleID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VetPensideTestGetListModel>();
                }

                log.Info("GetPensideTestListAsync returned");
                return JsonConvert.DeserializeObject<List<VetPensideTestGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetPensideTestListAsync failed", e);
                throw e;
            }
        }

        #endregion

        #region Disease Report Log Methods

        /// <summary>
        /// Gets a list of disease report logs associated with veterinary disease report records.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="veterinaryDiseaseReportID"></param>
        /// <returns></returns>
        public async Task<List<VetDiseaseReportLogGetListModel>> GetDiseaseReportLogListAsync(string languageID, long? veterinaryDiseaseReportID)
        {
            log.Info("GetDiseaseReportLogListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VeterinaryDiseaseReportLogGetListAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Veterinary/DiseaseReportLogGetListAsync?languageID={0}&veterinaryDiseaseReportID={1}
                    Query = string.Format("languageID={0}&veterinaryDiseaseReportID={1}", new[] { languageID, Convert.ToString(veterinaryDiseaseReportID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VetDiseaseReportLogGetListModel>();
                }

                log.Info("GetDiseaseReportLogListAsync returned");
                return JsonConvert.DeserializeObject<List<VetDiseaseReportLogGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetDiseaseReportLogListAsync failed", e);
                throw e;
            }
        }

        #endregion

        #region Campaign Species To Sample Type Methods

        /// <summary>
        /// Gets a list of species to sample types associated with active surveillance campaign records.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="monitoringSessionID"></param>
        /// <returns></returns>
        public async Task<List<VctCampaignSpeciesToSampleTypeGetListModel>> GetCampaignSpeciesToSampleTypeListAsync(string languageID, long campaignID)
        {
            log.Info("GetCampaignSpeciesToSampleTypeListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VeterinaryCampaignSpeciesToSampleTypeGetListAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Veterinary/CampaignSpeciesToSampleTypeGetListAsync?languageID={0}&monitoringSessionID={1}
                    Query = string.Format("languageID={0}&campaignID={1}", new[] { languageID, Convert.ToString(campaignID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctCampaignSpeciesToSampleTypeGetListModel>();
                }

                log.Info("GetCampaignSpeciesToSampleTypeListAsync returned");
                return JsonConvert.DeserializeObject<List<VctCampaignSpeciesToSampleTypeGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetCampaignSpeciesToSampleTypeListAsync failed", e);
                throw e;
            }
        }

        #endregion

        #region Monitoring Session To Disease Methods

        /// <summary>
        /// Gets a list of monitoring session to diseases associated with active surveillance monitoring session records.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="monitoringSessionID"></param>
        /// <returns></returns>
        public async Task<List<VctMonitoringSessionToDiseaseGetListModel>> GetMonitoringSessionToDiseaseListAsync(string languageID, long monitoringSessionID)
        {
            log.Info("GetMonitoringSessionToDiseaseListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VeterinaryMonitoringSessionToDiseaseGetListAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Veterinary/MonitoringSessionToDiseaseGetListAsync?languageID={0}&monitoringSessionID={1}
                    Query = string.Format("languageID={0}&monitoringSessionID={1}", new[] { languageID, Convert.ToString(monitoringSessionID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctMonitoringSessionToDiseaseGetListModel>();
                }

                log.Info("GetMonitoringSessionSpeciesToSampleTypeListAsync returned");
                return JsonConvert.DeserializeObject<List<VctMonitoringSessionToDiseaseGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetMonitoringSessionToDiseaseListAsync failed", e);
                throw e;
            }
        }

        #endregion

        #region Monitoring Session Species To Sample Type Methods

        /// <summary>
        /// Gets a list of species to sample types associated with active surveillance monitoring session records.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="monitoringSessionID"></param>
        /// <returns></returns>
        public async Task<List<VctMonitoringSessionSpeciesToSampleTypeGetListModel>> GetMonitoringSessionSpeciesToSampleTypeListAsync(string languageID, long monitoringSessionID)
        {
            log.Info("GetMonitoringSessionSpeciesToSampleTypeListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VeterinaryMonitoringSessionSpeciesToSampleTypeGetListAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Veterinary/MonitoringSessionSpeciesToSampleTypeGetListAsync?languageID={0}&monitoringSessionID={1}
                    Query = string.Format("languageID={0}&monitoringSessionID={1}", new[] { languageID, Convert.ToString(monitoringSessionID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctMonitoringSessionSpeciesToSampleTypeGetListModel>();
                }

                log.Info("GetMonitoringSessionSpeciesToSampleTypeListAsync returned");
                return JsonConvert.DeserializeObject<List<VctMonitoringSessionSpeciesToSampleTypeGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetMonitoringSessionSpeciesToSampleTypeListAsync failed", e);
                throw e;
            }
        }

        #endregion

        #region Monitoring Session Action Methods

        /// <summary>
        /// Gets a list of actions associated with active surveillance monitoring session records.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="monitoringSessionID"></param>
        /// <returns></returns>
        public async Task<List<VctMonitoringSessionActionGetListModel>> GetMonitoringSessionActionListAsync(string languageID, long monitoringSessionID)
        {
            log.Info("GetMonitoringSessionActionListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VeterinaryMonitoringSessionActionGetListAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Veterinary/MonitoringSessionActionGetListAsync?languageID={0}&monitoringSessionID={1}
                    Query = string.Format("languageID={0}&monitoringSessionID={1}", new[] { languageID, Convert.ToString(monitoringSessionID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctMonitoringSessionActionGetListModel>();
                }

                log.Info("GetMonitoringSessionActionListAsync returned");
                return JsonConvert.DeserializeObject<List<VctMonitoringSessionActionGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetMonitoringSessionActionListAsync failed", e);
                throw e;
            }
        }

        #endregion

        #region Monitoring Session Summary Methods

        /// <summary>
        /// Gets a list of summaries/aggregate information associated with active surveillance monitoring session records.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="monitoringSessionID"></param>
        /// <returns></returns>
        public async Task<List<VctMonitoringSessionSummaryGetListModel>> GetMonitoringSessionSummaryListAsync(string languageID, long monitoringSessionID)
        {
            log.Info("GetMonitoringSessionSummaryListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VeterinaryMonitoringSessionActionGetListAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Veterinary/MonitoringSessionSummaryGetListAsync?languageID={0}&monitoringSessionID={1}
                    Query = string.Format("languageID={0}&monitoringSessionID={1}", new[] { languageID, Convert.ToString(monitoringSessionID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctMonitoringSessionSummaryGetListModel>();
                }

                log.Info("GetMonitoringSessionSummaryListAsync returned");
                return JsonConvert.DeserializeObject<List<VctMonitoringSessionSummaryGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetMonitoringSessionSummaryListAsync failed", e);
                throw e;
            }
        }

        #endregion
    }
}
