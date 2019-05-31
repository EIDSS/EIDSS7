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
    public class FarmServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(FarmServiceClient));

        public FarmServiceClient() : base()
        {
        }

        #region Farm (Snapshot) Methods

        /// <summary>
        /// Gets a single farm snapshot record.  This is not the farm master (actual) record.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="farmID"></param>
        /// <returns></returns>
        public async Task<List<VetFarmGetDetailModel>> GetFarmDetailAsync(string languageID, long farmID)
        {
            log.Info("GetFarmDetailAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("FarmGetDetailAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    Query = string.Format("languageID={0}&farmID={1}",

                    new[] { languageID, Convert.ToString(farmID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VetFarmGetDetailModel>();
                }

                log.Info("GetFarmDetailAsync returned");
                return JsonConvert.DeserializeObject<List<VetFarmGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetFarmDetailAsync failed", e);
                throw e;
            }
        }

        #endregion

        #region Farm (Master) Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="farmMasterID"></param>
        /// <returns></returns>
        public async Task<List<VetFarmMasterGetDetailModel>> GetFarmMasterDetailAsync(string languageID, long farmMasterID)
        {
            log.Info("GetFarmMasterDetailAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("FarmMasterGetDetailAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    Query = string.Format("languageID={0}&farmMasterID={1}",

                    new[] { languageID, Convert.ToString(farmMasterID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VetFarmMasterGetDetailModel>();
                }

                log.Info("GetFarmMasterDetailAsync returned");
                return JsonConvert.DeserializeObject<List<VetFarmMasterGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetFarmMasterDetailAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of farms.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="FarmGetListParameters"/>.</param>
        /// <returns>Returns a list of <see cref="VetFarmMasterGetListModel"/>.</returns>
        public async Task<List<VetFarmMasterGetListModel>> FarmMasterGetListAsync(FarmGetListParameters parameters)
        {
            log.Info("FarmMasterGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("FarmMasterGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VetFarmMasterGetListModel>();
                }

                log.Info("FarmMasterGetListAsync returned");
                return JsonConvert.DeserializeObject<List<VetFarmMasterGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("FarmMasterGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of farms meeting search criteria.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="FarmGetListParameters"/>.</param>
        /// <returns>Returns a List of <see cref="VetFarmMasterGetCountModel"</see>/></returns>
        public async Task<List<VetFarmMasterGetCountModel>> FarmMasterGetListCountAsync(FarmGetListParameters parameters)
        {
            log.Info("FarmMasterGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("FarmMasterGetListCountAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VetFarmMasterGetCountModel>();
                }

                log.Info("FarmMasterGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<VetFarmMasterGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("FarmMasterGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of a farm's associated herds or flocks and species for the hierachical display.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="FarmHerdSpeciesGetListParameters"/>.</param>
        /// <returns>Returns a list of <see cref="VetFarmHerdSpeciesGetListModel"/>.</returns>
        public async Task<List<VetFarmHerdSpeciesGetListModel>> FarmHerdSpeciesGetListAsync(FarmHerdSpeciesGetListParameters parameters)
        {
            log.Info("FarmHerdSpeciesGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("FarmHerdSpeciesGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VetFarmHerdSpeciesGetListModel>();
                }

                log.Info("FarmHerdSpeciesGetListAsync returned");
                return JsonConvert.DeserializeObject<List<VetFarmHerdSpeciesGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("FarmHerdSpeciesGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Processes new and existing updates to farm master information.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="FarmMasterSetParameters"/>.</param>
        /// <returns>Returns an SPReturnResult instance that specifies the completion of the operation <see cref="VetFarmMasterSetModel"/>.</returns>
        public async Task<List<VetFarmMasterSetModel>> SaveFarmMasterAsync(FarmMasterSetParameters parameters)
        {
            log.Info("SaveFarmMasterAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("FarmMasterSaveAsync"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VetFarmMasterSetModel>();
                }

                log.Info("SaveFarmMasterAsync returned");
                return JsonConvert.DeserializeObject<List<VetFarmMasterSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("SaveFarmMasterAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Deletes a farm record.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="farmMasterID">A system assigned internal unique key that identifies the farm to delete.</param>
        /// <returns></returns>
        public async Task<List<VetFarmMasterDelModel>> DeleteFarmMasterAsync(string languageID, long farmMasterID)
        {
            log.Info("DeleteFarmMasterAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("FarmMasterDeleteAsync"))
                {
                    Query = string.Format("languageID={0}&farmMasterID={1}", new[] { Convert.ToString(languageID), Convert.ToString(farmMasterID) })
                };

                var response = _apiclient.DeleteAsync(builder.Uri).Result;

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                response.EnsureSuccessStatusCode();
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VetFarmMasterDelModel>();
                }

                log.Info("DeleteFarmMasterAsync returned");
                return JsonConvert.DeserializeObject<List<VetFarmMasterDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("DeleteFarmMasterAsync failed", e);
                throw e;
            }
        }

        #endregion
    }
}