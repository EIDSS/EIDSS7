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
    public class AgeGroupServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(AgeGroupServiceClient));

        public AgeGroupServiceClient() : base()
        {
        }

        public async Task<List<RefAgegroupGetListModel>> RefAgegroupGetList(string languageId)
        {
            log.Info("RefAgegroupGetList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-REF-AGEGROUPLIST"))
                {
                    Query = string.Format("languageId={0}", new[] { Convert.ToString(languageId) })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();
                log.Info("RefAgegroupGetList returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefAgegroupGetListModel>();
                }
                return JsonConvert.DeserializeObject<List<RefAgegroupGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("RefAgegroupGetList failed", e);
                throw e;
            }
        }

        public async Task<List<RefAgegroupDelModel>> RefAgegroupDel(long idfsAgeGroup, bool deleteAnyway)
        {
            log.Info("RefAgegroupDel is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-DEL-REF-AGEGROUP"))
                {
                    Query = string.Format("idfsAgeGroup={0}&deleteAnyway={1}", new[] { Convert.ToString(idfsAgeGroup), Convert.ToString(deleteAnyway) })
                };

                var response = _apiclient.DeleteAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                log.Info("RefAgegroupDel returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefAgegroupDelModel>();
                }
                log.Info("RefAgegroupDel returned");
                return JsonConvert.DeserializeObject<List<RefAgegroupDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("RefAgegroupDel failed", e);
                throw e;
            }
        }
        
        public async Task<List<RefAgegroupSetModel>> RefAgegroupSet(AdminReferenceAgeGroupSetParams adminReferenceAgeGroupSetParams)
        {
            log.Info("RefAgegroupSet is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                //Serialize the request parameters
                var content = CreateRequestContent(adminReferenceAgeGroupSetParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("ADMIN-POST-REF-AGEGROUPSET"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();
                log.Info("RefAgegroupSet returned");
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefAgegroupSetModel>();
                }
                log.Info("RefAgegroupSet returned");
                return JsonConvert.DeserializeObject<List<RefAgegroupSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("RefAgegroupSet failed", e);
                throw e;
            }
        }
    }
}
