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
    /// <summary>
    /// Client service that interacts with laboratory specific functionality within the EISSS API.
    /// </summary>
    public class LaboratoryServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(LaboratoryServiceClient));

        public LaboratoryServiceClient() : base()
        {
        }

        /// <summary>
        /// Get details about a single laboratory sample record.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country.</param>
        /// <param name="sampleID">The sample identifier of the record to get details on.</param>
        /// <returns>Returns a list of <see cref="LabSampleGetDetailModel"/>.</returns>
        public async Task<List<LabSampleGetDetailModel>> LaboratorySampleGetDetailAsync(string languageID, long sampleID)
        {
            log.Info("LaboratorySampleGetDetailAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("LaboratorySampleGetDetailAsync"))
                {
                    Query = string.Format("languageId={0}&sampleID={1}", new[] { Convert.ToString(languageID), Convert.ToString(sampleID) })
                };

                var response = _apiclient.GetAsync(builder.Uri).Result;
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabSampleGetDetailModel>();
                }

                log.Info("LaboratorySampleGetDetailAsync returned");
                return JsonConvert.DeserializeObject<List<LabSampleGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratorySampleGetDetailAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of laboratory samples that are un-accessioned or accessioned within the last 14 calendar days.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratorySampleGetListParameters"/>.</param>
        /// <returns>Returns a list of <see cref="LabSampleGetListModel"/>.</returns>
        public async Task<List<LabSampleGetListModel>> LaboratorySampleGetListAsync(LaboratorySampleGetListParameters parameters)
        {
            log.Info("LaboratorySampleGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratorySampleGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabSampleGetListModel>();
                }

                log.Info("LaboratorySampleGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabSampleGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratorySampleGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of laboratory samples that are un-accessioned or accessioned within the last 14 calendar days.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratorySampleGetListParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabSampleGetCountModel"</see>/></returns>
        public async Task<List<LabSampleGetCountModel>> LaboratorySampleGetListCountAsync(LaboratorySampleGetListParameters parameters)
        {
            log.Info("LaboratorySampleGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratorySampleGetListCountAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabSampleGetCountModel>();
                }

                log.Info("LaboratorySampleGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<LabSampleGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratorySampleGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of laboratory samples based on user provided search criteria.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabSampleSearchGetListModel"</see>/></returns>
        public async Task<List<LabSampleSearchGetListModel>> LaboratorySampleSearchGetListAsync(LaboratorySearchParameters parameters)
        {
            log.Info("LaboratorySampleSearchGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratorySampleSearchGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabSampleSearchGetListModel>();
                }

                log.Info("LaboratorySampleSearchGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabSampleSearchGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratorySampleSearchGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of laboratory samples based on user provided search criteria.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabSampleSearchGetCountModel"</see>/></returns>
        public async Task<List<LabSampleSearchGetCountModel>> LaboratorySampleSearchGetListCountAsync(LaboratorySearchParameters parameters)
        {
            log.Info("LaboratorySampleSearchGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratorySampleSearchGetListCountAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabSampleSearchGetCountModel>();
                }

                log.Info("LaboratorySampleSearchGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<LabSampleSearchGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratorySampleSearchGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of laboratory samples based on a user provided search string.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratoryAdvancedSearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabSampleAdvancedSearchGetListModel"</see>/></returns>
        public async Task<List<LabSampleAdvancedSearchGetListModel>> LaboratorySampleAdvancedSearchGetListAsync(LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("LaboratorySampleAdvancedSearchGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratorySampleAdvancedSearchGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabSampleAdvancedSearchGetListModel>();
                }

                log.Info("LaboratorySampleAdvancedSearchGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabSampleAdvancedSearchGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratorySampleAdvancedSearchGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of laboratory samples based on a user provided search string.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratoryAdvancedSearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabSampleAdvancedSearchGetCountModel"</see>/></returns>
        public async Task<List<LabSampleAdvancedSearchGetCountModel>> LaboratorySampleAdvancedSearchGetListCountAsync(LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("LaboratorySampleAdvancedSearchGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratorySampleAdvancedSearchGetListCountAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabSampleAdvancedSearchGetCountModel>();
                }

                log.Info("LaboratorySampleAdvancedSearchGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<LabSampleAdvancedSearchGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratorySampleAdvancedSearchGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of laboratory sample favorites for a given user.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 language code used to restrict data to a specific country.</param>
        /// <param name="userID">An EIDSS user identifier for which favorites are retrieved.</param>
        /// <param name="paginationSetNumber"></param>
        /// <returns>Returns a List of <see cref="LabFavoriteGetListModel"</see>/></returns>
        public async Task<List<LabFavoriteGetListModel>> LaboratoryFavoriteGetListAsync(string languageID, long? userID, int paginationSetNumber)
        {
            log.Info("LaboratoryFavoriteGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("LaboratoryFavoriteGetListAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Lab/LaboratoryFavoriteGetListAsync?languageID={0}&userID={1}&paginationSetNumber={2}
                    Query = string.Format("languageID={0}&userID={1}&paginationSetNumber={2}", new[] { languageID, Convert.ToString(userID), Convert.ToString(paginationSetNumber) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabFavoriteGetListModel>();
                }

                log.Info("LaboratoryFavoriteGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabFavoriteGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e )
            {
                log.Error("LaboratoryFavoriteGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of laboratory sample favorites for the given user.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 language code used to restrict data to a specific country.</param>
        /// <param name="userID">An EIDSS user identifier for which favorites are retrieved.</param>
        /// <returns>Returns a List of <see cref="LabFavoriteGetCountModel"</see>/></returns>
        public async Task<List<LabFavoriteGetCountModel>> LaboratoryFavoriteGetListCountAsync(string languageID, long? userID)
        {
            log.Info("LaboratoryFavoriteGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("LaboratoryFavoriteGetListCountAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Lab/LaboratoryFavoriteGetListCountAsync?languageID={0}&userID={1}
                    Query = string.Format("languageID={0}&userID={1}", new[] { languageID, Convert.ToString(userID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabFavoriteGetCountModel>();
                }

                log.Info("LaboratoryFavoriteGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<LabFavoriteGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryFavoriteGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of laboratory my favorites based on user provided search criteria.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabFavoriteSearchGetListModel"</see>/></returns>
        public async Task<List<LabFavoriteSearchGetListModel>> LaboratoryFavoriteSearchGetListAsync(LaboratorySearchParameters parameters)
        {
            log.Info("LaboratoryFavoriteSearchGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryFavoriteSearchGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabFavoriteSearchGetListModel>();
                }

                log.Info("LaboratoryFavoriteSearchGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabFavoriteSearchGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryFavoriteSearchGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of laboratory my favorites based on user provided search criteria.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabFavoriteSearchGetCountModel"</see>/></returns>
        public async Task<List<LabFavoriteSearchGetCountModel>> LaboratoryFavoriteSearchGetListCountAsync(LaboratorySearchParameters parameters)
        {
            log.Info("LaboratoryFavoriteSearchGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryFavoriteSearchGetListCountAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabFavoriteSearchGetCountModel>();
                }

                log.Info("LaboratoryFavoriteSearchGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<LabFavoriteSearchGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryFavoriteSearchGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of laboratory my favorites based on a user provided search string.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratoryAdvancedSearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabSampleAdvancedSearchGetListModel"</see>/></returns>
        public async Task<List<LabFavoriteAdvancedSearchGetListModel>> LaboratoryFavoriteAdvancedSearchGetListAsync(LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("LaboratoryFavoriteAdvancedSearchGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryFavoriteAdvancedSearchGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabFavoriteAdvancedSearchGetListModel>();
                }

                log.Info("LaboratoryFavoriteAdvancedSearchGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabFavoriteAdvancedSearchGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryFavoriteAdvancedSearchGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of laboratory my favorites based on a user provided search string.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratoryAdvancedSearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabFavoriteAdvancedSearchGetCountModel"</see>/></returns>
        public async Task<List<LabFavoriteAdvancedSearchGetCountModel>> LaboratoryFavoriteAdvancedSearchGetListCountAsync(LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("LaboratoryFavoriteAdvancedSearchGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryFavoriteAdvancedSearchGetListCountAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabFavoriteAdvancedSearchGetCountModel>();
                }

                log.Info("LaboratoryFavoriteAdvancedSearchGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<LabFavoriteAdvancedSearchGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryFavoriteAdvancedSearchGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Processes new and existing updates to laboratory sample, test, transfer, batch test and favorite information.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratorySetParameters"/>.</param>
        /// <returns>Returns an SPReturnResult instance that specifies the completion of the operation <see cref="LabSetModel"/>.</returns>
        public async Task<List<LabSetModel>> SaveLaboratoryAsync(LaboratorySetParameters parameters)
        {
            log.Info("SaveLaboratoryAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratorySaveAsync"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabSetModel>();
                }

                log.Info("SaveLaboratoryAsync returned");
                return JsonConvert.DeserializeObject<List<LabSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("SaveLaboratoryAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of tests associated with laboratory sample records.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratoryTestGetListParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabTestGetListModel"</see>/></returns>
        public async Task<List<LabTestGetListModel>> LaboratoryTestGetListAsync(LaboratoryTestGetListParameters parameters)
        {
            log.Info("LaboratoryTestGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryTestGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabTestGetListModel>();
                }

                log.Info("LaboratoryTestGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabTestGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryTestGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of tests associated with laboratory sample records.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratoryTestGetListParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabTestGetCountModel"</see>/></returns>
        public async Task<List<LabTestGetCountModel>> LaboratoryTestGetListCountAsync(LaboratoryTestGetListParameters parameters)
        {
            log.Info("LaboratoryTestGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryTestGetListCountAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabTestGetCountModel>();
                }

                log.Info("LaboratoryTestGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<LabTestGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryTestGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of laboratory tests based on user provided search criteria.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabTestSearchGetListModel"</see>/></returns>
        public async Task<List<LabTestSearchGetListModel>> LaboratoryTestSearchGetListAsync(LaboratorySearchParameters parameters)
        {
            log.Info("LaboratoryTestSearchGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryTestSearchGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabTestSearchGetListModel>();
                }

                log.Info("LaboratoryTestSearchGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabTestSearchGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryTestSearchGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of laboratory tests based on user provided search criteria.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabTestSearchGetCountModel"</see>/></returns>
        public async Task<List<LabTestSearchGetCountModel>> LaboratoryTestSearchGetListCountAsync(LaboratorySearchParameters parameters)
        {
            log.Info("LaboratoryTestSearchGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryTestSearchGetListCountAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabTestSearchGetCountModel>();
                }

                log.Info("LaboratoryTestSearchGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<LabTestSearchGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryTestSearchGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of laboratory tests based on a user provided search string.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratoryAdvancedSearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabTestAdvancedSearchGetListModel"</see>/></returns>
        public async Task<List<LabTestAdvancedSearchGetListModel>> LaboratoryTestAdvancedSearchGetListAsync(LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("LaboratoryTestAdvancedSearchGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryTestAdvancedSearchGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabTestAdvancedSearchGetListModel>();
                }

                log.Info("LaboratoryTestAdvancedSearchGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabTestAdvancedSearchGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryTestAdvancedSearchGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of laboratory tests based on a user provided search string.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratoryAdvancedSearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabTestAdvancedSearchGetCountModel"</see>/></returns>
        public async Task<List<LabTestAdvancedSearchGetCountModel>> LaboratoryTestAdvancedSearchGetListCountAsync(LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("LaboratoryTestAdvancedSearchGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryTestAdvancedSearchGetListCountAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabTestAdvancedSearchGetCountModel>();
                }

                log.Info("LaboratoryTestAdvancedSearchGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<LabTestAdvancedSearchGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryTestAdvancedSearchGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of batch test records associated with laboratory sample records.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratoryBatchGetListParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabBatchGetListModel"</see>/></returns>
        public async Task<List<LabBatchGetListModel>> LaboratoryBatchGetListAsync(LaboratoryBatchGetListParameters parameters)
        {
            log.Info("LaboratoryBatchGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryBatchGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabBatchGetListModel>();
                }

                log.Info("LaboratoryBatchGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabBatchGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryBatchGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of batch test records associated with laboratory sample records.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratoryBatchGetListParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabBatchGetListModel"</see>/></returns>
        public async Task<List<LabBatchGetCountModel>> LaboratoryBatchGetListCountAsync(LaboratoryBatchGetListParameters parameters)
        {
            log.Info("LaboratoryBatchGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryBatchGetListCountAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabBatchGetCountModel>();
                }

                log.Info("LaboratoryBatchGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<LabBatchGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryBatchGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of laboratory batch tests based on a user provided search string.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratoryAdvancedSearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabTestAdvancedSearchGetListModel"</see>/></returns>
        public async Task<List<LabBatchAdvancedSearchGetListModel>> LaboratoryBatchAdvancedSearchGetListAsync(LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("LaboratoryBatchAdvancedSearchGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryBatchAdvancedSearchGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabBatchAdvancedSearchGetListModel>();
                }

                log.Info("LaboratoryBatchAdvancedSearchGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabBatchAdvancedSearchGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryBatchAdvancedSearchGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of laboratory batch tests based on a user provided search string.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratoryAdvancedSearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabBatchAdvancedSearchGetCountModel"</see>/></returns>
        public async Task<List<LabBatchAdvancedSearchGetCountModel>> LaboratoryBatchAdvancedSearchGetListCountAsync(LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("LaboratoryBatchAdvancedSearchGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryBatchAdvancedSearchGetListCountAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabBatchAdvancedSearchGetCountModel>();
                }

                log.Info("LaboratoryBatchAdvancedSearchGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<LabBatchAdvancedSearchGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryBatchAdvancedSearchGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of transfer records for associated laboratory sample records.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratoryTransferGetListParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabTransferGetListModel"</see>/></returns>
        public async Task<List<LabTransferGetListModel>> LaboratoryTransferGetListAsync(LaboratoryTransferGetListParameters parameters)
        {
            log.Info("LaboratoryTransferGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryTransferGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabTransferGetListModel>();
                }

                log.Info("LaboratoryTransferGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabTransferGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryTransferGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of transfer records for associated laboratory sample records.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratoryTransferGetListParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabTransferGetCountModel"</see>/></returns>
        public async Task<List<LabTransferGetCountModel>> LaboratoryTransferGetListCountAsync(LaboratoryTransferGetListParameters parameters)
        {
            log.Info("LaboratoryTransferGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryTransferGetListCountAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabTransferGetCountModel>();
                }

                log.Info("LaboratoryTransferGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<LabTransferGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryTransferGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of laboratory transfers based on user provided search criteria.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabTransferSearchGetListModel"</see>/></returns>
        public async Task<List<LabTransferSearchGetListModel>> LaboratoryTransferSearchGetListAsync(LaboratorySearchParameters parameters)
        {
            log.Info("LaboratoryTransferSearchGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryTransferSearchGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabTransferSearchGetListModel>();
                }

                log.Info("LaboratoryTransferSearchGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabTransferSearchGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryTransferSearchGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of laboratory transfers based on user provided search criteria.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabTransferSearchGetCountModel"</see>/></returns>
        public async Task<List<LabTransferSearchGetCountModel>> LaboratoryTransferSearchGetListCountAsync(LaboratorySearchParameters parameters)
        {
            log.Info("LaboratoryTransferSearchGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryTransferSearchGetListCountAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabTransferSearchGetCountModel>();
                }

                log.Info("LaboratoryTransferSearchGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<LabTransferSearchGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryTransferSearchGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of laboratory samples based on a user provided search string.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratoryAdvancedSearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabTransferAdvancedSearchGetListModel"</see>/></returns>
        public async Task<List<LabTransferAdvancedSearchGetListModel>> LaboratoryTransferAdvancedSearchGetListAsync(LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("LaboratoryTransferAdvancedSearchGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryTransferAdvancedSearchGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabTransferAdvancedSearchGetListModel>();
                }

                log.Info("LaboratoryTransferAdvancedSearchGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabTransferAdvancedSearchGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryTransferAdvancedSearchGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of laboratory samples based on a user provided search string.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratoryAdvancedSearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabTransferAdvancedSearchGetCountModel"</see>/></returns>
        public async Task<List<LabTransferAdvancedSearchGetCountModel>> LaboratoryTransferAdvancedSearchGetListCountAsync(LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("LaboratoryTransferAdvancedSearchGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryTransferAdvancedSearchGetListCountAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabTransferAdvancedSearchGetCountModel>();
                }

                log.Info("LaboratoryTransferAdvancedSearchGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<LabTransferAdvancedSearchGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryTransferAdvancedSearchGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of approval records associated with laboratory sample and test records.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratoryApprovalGetListParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabApprovalGetListModel"</see>/></returns>
        public async Task<List<LabApprovalGetListModel>> LaboratoryApprovalGetListAsync(LaboratoryApprovalGetListParameters parameters)
        {
            log.Info("LaboratoryApprovalGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryApprovalGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabApprovalGetListModel>();
                }

                log.Info("LaboratoryApprovalGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabApprovalGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryApprovalGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of approval records associated with laboratory sample and test records.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratoryApprovalGetListParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabApprovalGetCountModel"</see>/></returns>
        public async Task<List<LabApprovalGetCountModel>> LaboratoryApprovalGetListCountAsync(LaboratoryApprovalGetListParameters parameters)
        {
            log.Info("LaboratoryApprovalGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryApprovalGetListCountAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabApprovalGetCountModel>();
                }

                log.Info("LaboratoryApprovalGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<LabApprovalGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryApprovalGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of laboratory approvals based on user provided search criteria.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabApprovalSearchGetListModel"</see>/></returns>
        public async Task<List<LabApprovalSearchGetListModel>> LaboratoryApprovalSearchGetListAsync(LaboratorySearchParameters parameters)
        {
            log.Info("LaboratoryApprovalSearchGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryApprovalSearchGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabApprovalSearchGetListModel>();
                }

                log.Info("LaboratoryApprovalSearchGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabApprovalSearchGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryApprovalSearchGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of laboratory approvals based on user provided search criteria.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratorySearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabApprovalSearchGetCountModel"</see>/></returns>
        public async Task<List<LabApprovalSearchGetCountModel>> LaboratoryApprovalSearchGetListCountAsync(LaboratorySearchParameters parameters)
        {
            log.Info("LaboratoryApprovalSearchGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryApprovalSearchGetListCountAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabApprovalSearchGetCountModel>();
                }

                log.Info("LaboratoryApprovalSearchGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<LabApprovalSearchGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryApprovalSearchGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of laboratory approvals based on a user provided search string.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratoryAdvancedSearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabApprovalAdvancedSearchGetListModel"</see>/></returns>
        public async Task<List<LabApprovalAdvancedSearchGetListModel>> LaboratoryApprovalAdvancedSearchGetListAsync(LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("LaboratoryApprovalAdvancedSearchGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryApprovalAdvancedSearchGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabApprovalAdvancedSearchGetListModel>();
                }

                log.Info("LaboratoryApprovalAdvancedSearchGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabApprovalAdvancedSearchGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryApprovalAdvancedSearchGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a count of laboratory approvals based on a user provided search string.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratoryAdvancedSearchParameters"/>.</param>
        /// <returns>Returns a List of <see cref="LabApprovalAdvancedSearchGetCountModel"</see>/></returns>
        public async Task<List<LabApprovalAdvancedSearchGetCountModel>> LaboratoryApprovalAdvancedSearchGetListCountAsync(LaboratoryAdvancedSearchParameters parameters)
        {
            log.Info("LaboratoryApprovalAdvancedSearchGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryApprovalAdvancedSearchGetListCountAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabApprovalAdvancedSearchGetCountModel>();
                }

                log.Info("LaboratoryApprovalAdvancedSearchGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<LabApprovalAdvancedSearchGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryApprovalAdvancedSearchGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of test amendments associated with laboratory test records.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 language code used to restrict data to a specific country.</param>
        /// <param name="testID">An EIDSS internal identifier for the test record.</param>
        /// <returns>Returns a List of <see cref="LabTestAmendmentGetListModel"</see>/></returns>
        public async Task<List<LabTestAmendmentGetListModel>> LaboratoryTestAmendmentGetListAsync(string languageID, long testID)
        {
            log.Info("LaboratoryTestAmendmentGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("LaboratoryTestAmendmentGetListAsync"))
                {
                    // Replace the parmeter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Lab/LaboratoryTestAmendmentGetListAsync?languageId={0}&testID={1}
                    Query = string.Format("languageID={0}&testID={1}", new[] { languageID, Convert.ToString(testID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabTestAmendmentGetListModel>();
                }

                log.Info("LaboratoryTestAmendmentGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabTestAmendmentGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryTestAmendmentGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Retrieves a list of freezer storage types for laboratory samples.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratoryFreezerGetListParams"/>.</param>
        /// <returns>Returns a List of <see cref="LabFreezerGetListModel"</see>/></returns>
        public async Task<List<LabFreezerGetListModel>> LaboratoryFreezerGetListAsync(LaboratoryFreezerGetListParams parameters)
        {
            log.Info("LaboratoryFreezerGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent<LaboratoryFreezerGetListParams>(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryFreezerGetListAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabFreezerGetListModel>();
                }

                log.Info("LaboratoryFreezerGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabFreezerGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryFreezerGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Retrieves a count of freezer storage types for laboratory samples.
        /// </summary>
        /// <param name="parameters">The parameter collection that indicates the search and filtering criteria to use <see cref="LaboratoryFreezerGetListParams"/>.</param>
        /// <returns>Returns a List of <see cref="LabFreezerGetCountModel"</see>/></returns>
        public async Task<List<LabFreezerGetCountModel>> LaboratoryFreezerGetListCountAsync(LaboratoryFreezerGetListParams parameters)
        {
            log.Info("LaboratoryFreezerGetListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent<LaboratoryFreezerGetListParams>(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryFreezerGetListCountAsync"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabFreezerGetCountModel>();
                }

                log.Info("LaboratoryFreezerGetListCountAsync returned");
                return JsonConvert.DeserializeObject<List<LabFreezerGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryFreezerGetListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of freezer subdivisions associated with a freezer.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 language code used to restrict data to a specific country.</param>
        /// <param name="freezerID">An EIDSS internal identifier for which freezer subdivisions will be retrieved.</param>
        /// <param name="organizationID">An EIDSS internal identifier for the organization/site a freezer subdivision is associated with.</param>
        /// <returns>Returns a List of <see cref="LabFreezerSubdivisionGetListModel"</see>/></returns>
        public async Task<List<LabFreezerSubdivisionGetListModel>> LaboratoryFreezerSubdivisionGetListAsync(string languageID, long? freezerID, long? organizationID)
        {
            log.Info("LaboratoryFreezerSubdivisionGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("LaboratoryFreezerSubdivisionGetListAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Lab/LaboratoryFreezerSubdivisionGetListAsync?languageID={0}&freezerID={1}&organizationID={2}
                    Query = string.Format("languageID={0}&freezerID={1}&organizationID={2}", new[] { languageID, Convert.ToString(freezerID), Convert.ToString(organizationID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabFreezerSubdivisionGetListModel>();
                }

                log.Info("LaboratoryFreezerSubdivisionGetListAsync returned");
                return JsonConvert.DeserializeObject<List<LabFreezerSubdivisionGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("LaboratoryFreezerSubdivisionGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Processes new and existing updates to laboratory freezer and freezer subdivision information.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="LaboratoryFreezerSetParams"/>.</param>
        /// <returns>Returns an SPReturnResult instance that specifies the completion of the operation <see cref="LabFreezerSetModel"/>.</returns>
        public async Task<List<LabFreezerSetModel>> SaveLaboratoryFreezerAsync(LaboratoryFreezerSetParams parameters)
        {
            log.Info("SaveLaboratoryFreezerAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("LaboratoryFreezerSaveAsync"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<LabFreezerSetModel>();
                }

                log.Info("SaveLaboratoryFreezerAsync returned");
                return JsonConvert.DeserializeObject<List<LabFreezerSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("SaveLaboratoryFreezerAsync failed", e);
                throw e;
            }
        }
    }
}