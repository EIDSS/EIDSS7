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
    public class GlobalServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(AgeGroupServiceClient));

        public GlobalServiceClient() :base()
        { }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="haCode"></param>
        /// <returns></returns>
        public async Task<List<AccessoryCodeGetLookupModel>> GetAccessoryCodeGetLookupAsync(string languageId, int? haCode)
        {
            log.Info("GetAccessoryCodeGetLookupModels is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-GBL-ACCESSORYCODELOOKUPLIST"))
                {
                    Query = string.Format("languageId={0}&haCode={1}", new[] { Convert.ToString(languageId), Convert.ToString(haCode) })
                };

                var response = _apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                log.Info("GetAccessoryCodeGetLookupModels returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AccessoryCodeGetLookupModel>();
                }
                return JsonConvert.DeserializeObject<List<AccessoryCodeGetLookupModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GetAccessoryCodeGetLookupModels", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="haCodeMask"></param>
        /// <returns></returns>
        public async Task<List<HaCodeGetCheckListModel>> GetHaCodes(string languageId, int? haCodeMask)
        {
            log.Info("GetHaCodeGetChecks is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-GBL-HACODES"))
                {
                    Query = string.Format("languageId={0}&haCodeMask={1}", new[] { Convert.ToString(languageId), Convert.ToString(haCodeMask) })
                };

                var response = _apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                log.Info("GetHaCodeGetChecks returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<HaCodeGetCheckListModel>();
                }
                return JsonConvert.DeserializeObject<List<HaCodeGetCheckListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetHaCodeGetChecks error", e);
                throw e;
            }
        }

        public async Task<List<GblLkupMonthGetListModel>> GetMonthLookup(string languageId)
        {
            log.Info("GetMonthLookup is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-GBL-MONTHLOOKUP"))
                {
                    Query = string.Format("languageId={0}", new[] { Convert.ToString(languageId)})
                };

                var response = _apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                log.Info("GetMonthLookup returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<GblLkupMonthGetListModel>();
                }
                return JsonConvert.DeserializeObject<List<GblLkupMonthGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetMonthLookup error", e);
                throw e;
            }
        }


        public async Task<List<AdminLkupReferenceTypeGetlistModel>> GetReferenceTypes(string languageId)
        {
            log.Info("GetReferenceTypes is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-GBL-REFERENCETYPE"))
                {
                    Query = string.Format("languageId={0}", new[] { Convert.ToString(languageId) })
                };

                var response = _apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                log.Info("GetReferenceTypes returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminLkupReferenceTypeGetlistModel>();
                }
                return JsonConvert.DeserializeObject<List<AdminLkupReferenceTypeGetlistModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetReferenceTypes error", e);
                throw e;
            }
        }

    }
}
