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
    /// Client service that contains common functionality that is utilized across multiple functional areas
    /// </summary>
    public class CrossCuttingServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(CrossCuttingServiceClient));

        /// <summary>
        /// Creates a new instance of this class.
        /// </summary>
        public CrossCuttingServiceClient() : base()
        {
        }

        /// <summary>
        /// Retrieves a single Country object given its identifier.
        /// </summary>
        /// <param name="countryId">An EIDSS identifier that specifies the country for which details will be retrieved</param>
        /// <returns>Returns a <see cref="CountryGetLookupModel"/></returns>
        public CountryGetLookupModel GetCountry(long countryId)
        {
            log.Info("GetCountry is called");

            // Create a uri and set the query string parms...
            UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("Country"));

            builder.Query = string.Format("countryId={0}", Convert.ToString(countryId));

            var response = this._apiclient.GetAsync(builder.Uri).Result;

            response.EnsureSuccessStatusCode();

            log.Info("GetCountry returned");

            return response.Content.ReadAsAsync<CountryGetLookupModel>(
                new List<MediaTypeFormatter> { this.Formatter }).Result;
        }

        /// <summary>
        /// Asyncronously retrieves a list of CountryGetLookupModel objects.
        /// </summary>
        /// <returns>Returns a list of <see cref="CountryGetLookupModel"/> objects</returns>
        public async Task<List<CountryGetLookupModel>> GetCountryListAsync(string langId)
        {
            log.Info("GetCountryListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CountryListAsync"));

                builder.Query = string.Format("langId='{0}'", langId);

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetCountryListAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<CountryGetLookupModel>();
                }
                return JsonConvert.DeserializeObject<List<CountryGetLookupModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetCountryListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Syncronously retrieves a list of <see cref="CountryGetLookupModel" objects/>
        /// </summary>
        /// <returns></returns>
        public async Task<List<CountryGetLookupModel>> GetCountryList(string langId)
        {
            log.Info("GetCountry is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CountryList"));

                builder.Query = string.Format("langId='{0}'", langId);

                var response = _apiclient.GetAsync(builder.Uri).Result;
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetCountryList Returned " + aPIReturnResult.ErrorMessage);
                    return new List<CountryGetLookupModel>();
                }

                log.Info("GetCountryList returned");
                return JsonConvert.DeserializeObject<List<CountryGetLookupModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetCountryList failed", e);
                throw e;
            }

            #region GOOD SYNC CODE!!! (old school)

            //log.Info("GetCountryList is called");

            //List<CountryGetLookupModel> results = null;


            //HttpWebRequest request = WebRequest.CreateHttp( this.Settings.GetResourceURI("CountryList"));

            //request.Method = "GET";
            //request.ContentType = this.Formatter.SupportedMediaTypes[0].MediaType;

            //try
            //{
            //    var response = request.GetResponse() as HttpWebResponse;

            //    if (response.StatusCode == HttpStatusCode.OK)
            //        results = this.HandleJSONResponse<List<CountryGetLookupModel>>(response);
            //}
            //catch (Exception e)
            //{
            //    throw e;
            //}


            //log.Info("GetCountryList returned");
            //return results;

            #endregion
        }

        /// <summary>
        /// Asyncronously retrieves a list of RegionGetLookupModel objects.
        /// </summary>
        /// <returns>Returns a list of <see cref="RegionGetLookupModel"/> objects</returns>
        public async Task<List<RegionGetLookupModel>> GetRegionListAsync(string languageId, long? countryId, long? regionId)
        {
            log.Info("GetRegionListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create a uri and set the query string parmameters.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("RegionGetListAsync"));

                builder.Query = string.Format("languageId={0}&countryId={1}&regionId={2}", languageId, countryId, regionId);

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
                
                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetRegionListAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<RegionGetLookupModel>();
                }

                log.Info("GetRegionListAsync returned");
                return JsonConvert.DeserializeObject<List<RegionGetLookupModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetRegionListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Asyncronously retrieves a list of RayonGetLookupModel objects.
        /// </summary>
        /// <returns>Returns a list of <see cref="RayonGetLookupModel"/> objects</returns>
        public async Task<List<RayonGetLookupModel>> GetRayonListAsync(string languageId, long? regionId, long? rayonId)
        {
            log.Info("GetRayonListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create a uri and set the query string parmameters.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("RayonGetListAsync"));

                builder.Query = string.Format("languageId={0}&regionId={1}&rayonId={2}", languageId, regionId, rayonId);

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetRayonListAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<RayonGetLookupModel>();
                }

                log.Info("GetRayonListAsync returned");
                return JsonConvert.DeserializeObject<List<RayonGetLookupModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetRayonListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Asyncronously retrieves a list of SettlementTypeGetLookupModel objects.
        /// </summary>
        /// <param name="languageId"></param>
        /// <returns>Returns a list of <see cref="SettlementTypeGetLookupModel"/> objects</returns>
        public async Task<List<SettlementTypeGetLookupModel>> GetSettlementTypeListAsync(string languageId)
        {
            log.Info("GetSettlementTypeListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create a uri and set the query string parmameters.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("SettlementTypeGetListAsync"));

                builder.Query = string.Format("languageId={0}", languageId);

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetSettlementTypeListAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<SettlementTypeGetLookupModel>();
                }

                log.Info("GetSettlementTypeListAsync returned");
                return JsonConvert.DeserializeObject<List<SettlementTypeGetLookupModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetSettlementTypeListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Asyncronously retrieves a list of SettlementGetLookupModel objects.
        /// </summary>
        /// <returns>Returns a list of <see cref="SettlementGetLookupModel"/> objects</returns>
        public async Task<List<SettlementGetLookupModel>> GetSettlementListAsync(string languageId, long? rayonId, long? settlementId)
        {
            log.Info("GetSettlementListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create a uri and set the query string parmameters.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("SettlementGetListAsync"));

                builder.Query = string.Format("languageId={0}&rayonId={1}&settlementId={2}", languageId, rayonId, settlementId);

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetSettlementListAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<SettlementGetLookupModel>();
                }

                log.Info("GetSettlementListAsync returned");
                return JsonConvert.DeserializeObject<List<SettlementGetLookupModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetSettlementListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Asyncronously retrieves a list of PostalCodeGetLookupModel objects.
        /// </summary>
        /// <returns>Returns a list of <see cref="PostalCodeGetLookupModel"/> objects</returns>
        public async Task<List<PostalCodeGetLookupModel>> GetPostalCodeListAsync(long? settlementId)
        {
            log.Info("GetPostalCodeListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create a uri and set the query string parmameters.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("PostalCodeGetListAsync"));

                builder.Query = string.Format("settlementId={0}", settlementId);

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetPostalCodeListAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<PostalCodeGetLookupModel>();
                }

                log.Info("GetPostalCodeListAsync returned");
                return JsonConvert.DeserializeObject<List<PostalCodeGetLookupModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetPostalCodeListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Retrieves a list of fixed preset values for the given reference type
        /// </summary>
        /// <param name="langId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsParameterType">An EIDSS specific parameter type identifier used to restrict results</param>
        /// <returns></returns>
        public async Task<List<FfGetParameterFixedPresetValueModel>> GetFlexibleFormsParameterFixedPresetValueAsync(string langId, long? idfsParameterType)
        {
            log.Info("GetFlexibleFormsParameterFixedPresetValue is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FlexibleFormsParameterFixedPresetValue"));

                // Create query string...
                builder.Query = string.Format("langId={0}&idfsParameterType={1}", new[] { langId, Convert.ToString(idfsParameterType) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetFlexibleFormsParameterFixedPresetValueAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<FfGetParameterFixedPresetValueModel>();
                }

                log.Info("GetFlexibleFormsParameterFixedPresetValueAsync returned");
                return JsonConvert.DeserializeObject<List<FfGetParameterFixedPresetValueModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetFlexibleFormsParameterFixedPresetValue failed", e);
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
        public async Task<List<FfGetParameterReferenceTypeModel>> GetFlexibleParameterReferenceTypeAsync(string langId, long? idfsParameterType, bool? onlyLists)
        {
            log.Info("GetFlexibleParameterReferenceTypeAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FlexibleFormsParameterReferenceTypeAsync"));

                // Create query string...
                builder.Query = string.Format("langId={0}&idfsParameterType={1}&onlyLists={2}", new[] { langId, Convert.ToString(idfsParameterType), Convert.ToString(onlyLists) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetFlexibleParameterReferenceTypeAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<FfGetParameterReferenceTypeModel>();
                }

                log.Info("GetFlexibleParameterReferenceTypeAsync returned");
                return JsonConvert.DeserializeObject<List<FfGetParameterReferenceTypeModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetFlexibleParameterReferenceTypeAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Retrieves a list of flexible forms parameter types based on the filter entered by the user. 
        /// </summary>
        /// <param name="langId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsParameterType">An EIDSS specific parameter type identifier used to restrict results</param>
        /// <returns></returns>
        public async Task<List<AdminFfParameterTypesFilterModel>> GetFlexibleFormParamterTypeSearchAsync(string langId, string searchString)
        {
            log.Info("GetFlexibleFormParamterTypeSearchAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FlexibleFormsParameterTypeFilterAsync"));

                // Create query string...
                builder.Query = string.Format("langId={0}&searchString={1}", new[] { langId, searchString });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetFlexibleFormParamterTypeSearchAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<AdminFfParameterTypesFilterModel>();
                }

                log.Info("GetFlexibleFormParamterTypeSearchAsync returned");
                return JsonConvert.DeserializeObject<List<AdminFfParameterTypesFilterModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetFlexibleFormParamterTypeSearchAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Retrieves a list of flexible forms referece types
        /// </summary>
        /// <param name="langId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns></returns>
        public async Task<List<FfGetReferenceTypesModel>> GetFlexibleFormsReferenceTypesAsync(string langId)
        {
            log.Info("GetFlexibleFormsReferenceTypesAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FlexibleFormsReferenceTypesAsync"));

                // Create query string...
                builder.Query = string.Format("langId={0}", new[] { langId });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetFlexibleFormsReferenceTypesAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<FfGetReferenceTypesModel>();
                }

                log.Info("GetFlexibleFormsReferenceTypesAsync returned");
                return JsonConvert.DeserializeObject<List<FfGetReferenceTypesModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetFlexibleFormsReferenceTypesAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Retrieves a list of flexible forms reference types
        /// </summary>
        /// <param name="langId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsReferenceType">An EIDSS specific reference type identifier used to restrict results</param>
        /// <returns>Returns a </returns>
        public async Task<List<FfGetReferenceTypesListModel>> GetFlexibleFormsReferenceTypesListAsync(string langId, long? idfsReferenceType)
        {
            log.Info("GetFlexibleFormsReferenceTypesListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("FlexibleFormsReferenceTypesListAsync"));

                // Create query string...
                builder.Query = string.Format("langId={0}&idfsReferenceType={1}", new[] { langId, Convert.ToString(idfsReferenceType) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetFlexibleFormsReferenceTypesListAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<FfGetReferenceTypesListModel>();
                }

                log.Info("GetFlexibleFormsReferenceTypesListAsync returned");
                return JsonConvert.DeserializeObject<List<FfGetReferenceTypesListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetFlexibleFormsReferenceTypesListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Returns a list of rayons given the language culture and optionally the region.
        /// </summary>
        /// <param name="langId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="regionId">An EIDSS specific region identifier used to restrict results</param>
        /// <param name="id"></param>
        /// <returns></returns>
        public async Task<List<RayonGetLookupModel>> GetRayonList( string langId, long? regionId, long? id )
        {
            log.Info("GetRayonList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("RayonList"));

                // Create query string...
                builder.Query = string.Format("langId={0}&regionId={1}&id={2}", new[] { langId, Convert.ToString(regionId), Convert.ToString(id) });

                // call the service...
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetRayonList Returned " + aPIReturnResult.ErrorMessage);
                    return new List<RayonGetLookupModel>();
                }

                log.Info("GetRayonList returned");
                return JsonConvert.DeserializeObject<List<RayonGetLookupModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetRayonList failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Returns a list of base reference records for a given language, reference type and accessory code.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="referenceTypeName">An EIDSS specific reference type</param>
        /// <param name="accessoryCode"></param>
        /// <returns></returns>
        public async Task<List<GblLkupBaseRefGetListModel>> GetBaseReferenceList(string languageId, string referenceTypeName, int accessoryCode)
        {
            log.Info("GetBaseReferenceList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("BaseReferenceList"))
                {
                    // Create query string.
                    Query = string.Format("languageId={0}&referenceTypeName={1}&accessoryCode={2}", new[] { languageId, Convert.ToString(referenceTypeName), Convert.ToString(accessoryCode) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetBaseReferenceList Returned " + aPIReturnResult.ErrorMessage);
                    return new List<GblLkupBaseRefGetListModel>();
                }

                log.Info("GetBaseReferenceList returned");
                return JsonConvert.DeserializeObject<List<GblLkupBaseRefGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetBaseReferenceList failed", e);
                throw e;
            }
        }

        public async Task<List<AdminFfFormTemplateGetModel>> GET_FF_TEMPLATE(long idfsDiagnosis, long? idfsFormType)
        {
            log.Info("FF-FORMTEMPLATE-GET is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("FF-FORMTEMPLATE-GET"))
                {
                    // Create query string.
                    Query = string.Format("idfsDiagnosis={0}&idfsFormType={1}", new[] { Convert.ToString(idfsDiagnosis), Convert.ToString(idfsFormType) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("FF-FORMTEMPLATE-GET Returned " + aPIReturnResult.ErrorMessage);
                    return new List<AdminFfFormTemplateGetModel>();
                }

                log.Info("FF-FORMTEMPLATE-GET returned");
                return JsonConvert.DeserializeObject<List<AdminFfFormTemplateGetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("FF-FORMTEMPLATE-GET failed", e);
                throw e;
            }
        }


        /// <summary>
        /// Returns information about a site based on siteId and userId
        /// </summary>
        /// <param name="siteId">Site Id returned from Login.vb Stored In Session Variable</param>
        /// <param name="userId">User Id returned from Login.vb Stored in Session Variable</param>
        /// <returns></returns>
        public async Task<List<GblSiteGetDetailModel>> GetGlobalSiteDetails(long siteId, long userId)
        {
            log.Info("GetGlobalSiteDetails is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("GLOBAL-GETSITE-DETAILS"))
                {
                    // Create query string.
                    Query = string.Format("siteId={0}&userId={1}", new[] { Convert.ToString(siteId), Convert.ToString(userId) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetGlobalSiteDetails Returned " + aPIReturnResult.ErrorMessage);
                    return new List<GblSiteGetDetailModel>();
                }
                return JsonConvert.DeserializeObject<List<GblSiteGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetGlobalSiteDetails failed", e);
                throw e;
            }
        }

        #region Organization Methods

        /// <summary>
        /// Returns a list of organization records for a given language, organization, organization type, accessory code or location.
        /// </summary>
        /// <param name="parameters">A collection of search parameters</param>
        /// <returns></returns>
        public async Task<List<GblOrganizationGetListModel>> GetOrganizationListAsync(OrganizationGetListParams parameters)
        {
            log.Info("GetOrganizationListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OrganizationGetListAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                log.Info("GetOrganizationListAsync returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetOrganizationListAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<GblOrganizationGetListModel>();
                }

                log.Info("GetOrganizationListAsync returned");
                return JsonConvert.DeserializeObject<List<GblOrganizationGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetOrganizationListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Returns a count for a list of organization records for a given language, organization, organization type, accessory code or location.
        /// </summary>
        /// <param name="parameters">A collection of search parameters</param>
        /// <returns></returns>
        public async Task<List<GblOrganizationGetCountModel>> GetOrganizationListCountAsync(OrganizationGetListParams parameters)
        {
            log.Info("GetOrganizationListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("OrganizationGetListCountAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                log.Info("GetOrganizationListCountAsync returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetOrganizationListCountAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<GblOrganizationGetCountModel>();
                }

                log.Info("GetOrganizationListCountAsync returned");
                return JsonConvert.DeserializeObject<List<GblOrganizationGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetOrganizationListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Retrieves a list of laboratory sample favorites for the given user.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 language code used to restrict data to a specific country.</param>
        /// <param name="organizationTypeID">An EIDSS user identifier for which organization types (hospital, laboratory) are to be returned.</param>
        /// <returns>Returns a List of <see cref="GblOrganizationByTypeGetListModel"</see>/></returns>
        public async Task<List<GblOrganizationByTypeGetListModel>> OrganizationByTypeGetListAsync(string languageID, long organizationTypeID)
        {
            log.Info("OrganizationByTypeGetListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("OrganizationByTypeGetListAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Lab/LaboratoryFavoriteGetListAsync?languageID={0}&organizationTypeID={1}
                    Query = string.Format("languageID={0}&organizationTypeID={1}", new[] { languageID, Convert.ToString(organizationTypeID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                log.Info("OrganizationByTypeGetListAsync returned");

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("OrganizationByTypeGetListAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<GblOrganizationByTypeGetListModel>();
                }

                log.Info("OrganizationByTypeGetListAsync returned");
                return JsonConvert.DeserializeObject<List<GblOrganizationByTypeGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("OrganizationByTypeGetListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Saves new and existing updates to organization record information.
        /// </summary>
        /// <param name="parameters">Data elements that make up the organization record to save.</param>
        /// <returns>Returns an SPReturnResult Instance that specifies the completion of the operation.</returns>
        public SPReturnResult SaveOrganizationRecord(OrganizationSetParam parameters)
        {
            log.Info("SaveOrganizationRecord is called");
            SPReturnResult results = null;

            try
            {
                // Create the content object. This will serialize the parms using our formatter! Beautiful!
                var content = CreateRequestContent(parameters);

                var response = _apiclient.PostAsync(Settings.GetResourceValue("OrganizationSave"), content).Result;

                results = response.Content.ReadAsAsync<SPReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
            }
            catch (Exception e)
            {
                log.Error("SaveOrganizationRecord failed", e);
                throw e;
            }

            log.Info("SaveOrganizationRecord returned");

            return results;
        }

        #endregion

        #region Department Methods

        /// <summary>
        /// Returns a list of department (functional area) records for a given language, organization or specific department.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="organizationId">An EIDSS system assigned internal identifier for the organization</param>
        /// <param name="departmentId">An EIDSS system assigned internal identifier for the department</param>
        /// <returns></returns>
        public async Task<List<GblDepartmentGetListModel>> GetDepartmentListAsync(string languageId, long? organizationId, long? departmentId)
        {
            log.Info("GetDepartmentListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("DepartmentGetListAsync"))
                {
                    // Create query string.
                    Query = string.Format("languageId={0}&organizationId={1}&departmentId={2}", new[] { languageId, Convert.ToString(organizationId), Convert.ToString(departmentId) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetDepartmentListAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<GblDepartmentGetListModel>();
                }

                log.Info("GetOrganizationListCountAsync returned");
                return JsonConvert.DeserializeObject<List<GblDepartmentGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetDepartmentListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Saves new and existing updates to department record information.
        /// </summary>
        /// <param name="parameters">Data elements that make up the department record to save.</param>
        /// <returns>Returns an SPReturnResult Instance that specifies the completion of the operation.</returns>
        public SPReturnResult SaveDepartmentRecord(DepartmentSetParam parameters)
        {
            log.Info("SaveDepartmentRecord is called");
            SPReturnResult results = null;

            try
            {
                // Create the content object. This will serialize the parms using our formatter! Beautiful!
                var content = CreateRequestContent(parameters);

                var response = _apiclient.PostAsync(Settings.GetResourceValue("DepartmentSave"), content).Result;

                results = response.Content.ReadAsAsync<SPReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
            }
            catch (Exception e)
            {
                log.Error("SaveDepartmentRecord failed", e);
                throw e;
            }

            log.Info("SaveDepartmentRecord returned");

            return results;
        }

        #endregion

        #region Sample Methods

        /// <summary>
        /// Gets a list of samples associated with disease report or monitoring session records.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="humanDiseaseReportID">EIDSS identifier for a specific human disease report</param>
        /// <param name="veterinaryDiseaseReportID">EIDSS identifier for a specific veterinary disease report</param>
        /// <param name="rootSampleID">EIDSS identifier for a specific root sample</param>
        /// <param name="monitoringSessionID">EIDSS identifier for a specific monitoring session</param>
        /// <param name="vectorSessionID">EIDSS identifier for a specific vector session</param>
        /// <returns></returns>
        public async Task<List<GblSampleGetListModel>> GetSampleListAsync(string languageID, long? humanDiseaseReportID, long? veterinaryDiseaseReportID, long? rootSampleID, long? monitoringSessionID, long? vectorSessionID)
        {
            log.Info("GetSampleListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("SampleGetListAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Common/SampleGetListAsync?languageID={0}&humanDiseaseReportID={1}&veterinaryDiseaseReportID={2}&rootSampleID={3}&monitoringSessionID={4}&vectorSessionID={5}
                    Query = string.Format("languageID={0}&humanDiseaseReportID={1}&veterinaryDiseaseReportID={2}&rootSampleID={3}&monitoringSessionID={4}&vectorSessionID={5}", new[] { languageID, Convert.ToString(humanDiseaseReportID), Convert.ToString(veterinaryDiseaseReportID), Convert.ToString(rootSampleID), Convert.ToString(monitoringSessionID), Convert.ToString(vectorSessionID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetSampleListAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<GblSampleGetListModel>();
                }

                log.Info("GetSampleListAsync returned");
                return JsonConvert.DeserializeObject<List<GblSampleGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetSampleListAsync failed", e);
                throw e;
            }
        }

        #endregion

        #region Test Methods

        /// <summary>
        /// Gets a list of tests associated with disease report or monitoring session records.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="humanDiseaseReportID">EIDSS identifier for a specific human disease report</param>
        /// <param name="veterinaryDiseaseReportID">EIDSS identifier for a specific veterinary disease report</param>
        /// <param name="monitoringSessionID">EIDSS identifier for a specific monitoring session</param>
        /// <param name="vectorSessionID">EIDSS identifier for a specific vector session</param>
        /// <param name="sampleID">EIDSS identifier for a specific sample</param>
        /// <returns></returns>
        public async Task<List<GblTestGetListModel>> GetTestListAsync(string languageID, long? humanDiseaseReportID, long? veterinaryDiseaseReportID, long? monitoringSessionID, long? vectorSessionID, long? sampleID)
        {
            log.Info("GetTestListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("TestGetListAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Common/TestGetListAsync?languageID={0}&humanDiseaseReportID={1}&veterinaryDiseaseReportID={2}&monitoringSessionID={3}&vectorSessionID={4}&sampleID={5}
                    Query = string.Format("languageId={0}&humanDiseaseReportID={1}&veterinaryDiseaseReportID={2}&monitoringSessionID={3}&vectorSessionID={4}&sampleID={5}", new[] { languageID, Convert.ToString(humanDiseaseReportID), Convert.ToString(veterinaryDiseaseReportID), Convert.ToString(monitoringSessionID), Convert.ToString(vectorSessionID), Convert.ToString(sampleID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetSampleListAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<GblTestGetListModel>();
                }

                log.Info("GetTestListAsync returned");
                return JsonConvert.DeserializeObject<List<GblTestGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetTestListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of test interpretations associated with disease report or monitoring session records.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="humanDiseaseReportID">EIDSS identifier for a specific human disease report</param>
        /// <param name="veterinaryDiseaseReportID">EIDSS identifier for a specific veterinary disease report</param>
        /// <param name="monitoringSessionID">EIDSS identifier for a specific monitoring session</param>
        /// <param name="vectorSessionID">EIDSS identifier for a specific vector session</param>
        /// <param name="testID">EIDSS identifier for a specific test</param>
        /// <returns></returns>
        public async Task<List<GblTestInterpretationGetListModel>> GetTestInterpretationListAsync(string languageID, long? humanDiseaseReportID, long? veterinaryDiseaseReportID, long? monitoringSessionID, long? vectorSessionID, long? testID)
        {
            log.Info("GetTestInterpretationListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
        
            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("TestInterpretationGetListAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Common/TestInterpretationGetListAsync?languageID={0}&humanDiseaseReportID={1}&veterinaryDiseaseReportID={2}&monitoringSessionID={3}&vectorSessionID={4}&testID={5}
                    Query = string.Format("languageID={0}&humanDiseaseReportID={1}&veterinaryDiseaseReportID={2}&monitoringSessionID={3}&vectorSessionID={4}&testID={5}", new[] { languageID, Convert.ToString(humanDiseaseReportID), Convert.ToString(veterinaryDiseaseReportID), Convert.ToString(monitoringSessionID), Convert.ToString(vectorSessionID), Convert.ToString(testID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetTestInterpretationListAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<GblTestInterpretationGetListModel>();
                }

                log.Info("GetTestInterpretationListAsync returned");
                return JsonConvert.DeserializeObject<List<GblTestInterpretationGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetTestInterpretationListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Gets a list of test names and categories by disease.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="diseaseIdList">A list of EIDSS internal identifiers of diseases to filter out tests by</param>
        /// <returns></returns>
        public async Task<List<GblTestDiseaseGetListModel>> GetTestByDiseaseListAsync(string languageId, string diseaseIdList)
        {
            log.Info("GetTestByDiseaseListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("TestByDiseaseGetListAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Common/TestByDiseaseGetListAsync?languageId={0}&diseaseIdList={1}
                    Query = string.Format("languageId={0}&diseaseIdList={1}", new[] { languageId, diseaseIdList })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetTestByDiseaseListAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<GblTestDiseaseGetListModel>();
                }

                log.Info("GetTestByDiseaseListAsync returned");
                return JsonConvert.DeserializeObject<List<GblTestDiseaseGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetTestByDiseaseListAsync failed", e);
                throw e;
            }
        }

        #endregion

        #region Notification Methods

        /// <summary>
        /// Retrives a list of notification records by notification object, site, and user identifiers.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="notificationObjectTypeID">An EIDSS Identifier for the notification object type</param>
        /// <param name="siteID">An EIDSS Identifier for the site</param>
        /// <param name="targetSiteID">An EIDSS identifier for the target site</param>
        /// <param name="userID">An EIDSS identifier for the user</param>
        /// <param name="targetUserID">An EIDSS identifier for the target user</param>
        /// <returns></returns>
        public async Task<List<GblNotificationGetListModel>> GetNotificationListAsync(string languageID, long? notificationObjectTypeID, long? siteID, long? targetSiteID, long? userID, long? targetUserID)
        {
            log.Info("GetNotificationListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("NotificationGetListAsync"))
                {
                    // Replace the parameter tokens with the actual values and the URL.
                    // http://server/OpenEIDSS/api/Common/NotificationGetListAsync?languageID={0}&notificationObjectTypeID={1}&siteID={2}&targetSiteID={3}&userID={4}&targetUserID={5}
                    Query = string.Format("languageID={0}&notificationObjectTypeID={1}&siteID={2}&targetSiteID={3}&userID={4}&targetUserID={5}", new[] { languageID, Convert.ToString(notificationObjectTypeID), Convert.ToString(siteID), Convert.ToString(targetSiteID), Convert.ToString(userID), Convert.ToString(targetUserID) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetNotificationListAsync Returned " + aPIReturnResult.ErrorMessage);
                    return new List<GblNotificationGetListModel>();
                }

                log.Info("GetNotificationListAsync returned");
                return JsonConvert.DeserializeObject<List<GblNotificationGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetNotificationListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Processes new and existing updates to a notification record.
        /// </summary>
        /// <param name="parameters">A collection of parameters <see cref="NotificationSetParameters"/>.</param>
        /// <returns>Returns an SPReturnResult instance that specifies the completion of the operation <see cref="GblNotificationSetModel"/>.</returns>
        public async Task<List<GblNotificationSetModel>> SaveNotificationAsync(NotificationSetParameters parameters)
        {
            log.Info("SaveNotificationAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parameters using the formatter.
                var content = CreateRequestContent(parameters);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("NotificationSaveAsync"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<GblNotificationSetModel>();
                }

                log.Info("SaveNotificationAsync returned");
                return JsonConvert.DeserializeObject<List<GblNotificationSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("SaveNotificationAsync failed", e);
                throw e;
            }
        }

        #endregion
    }
}
