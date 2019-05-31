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
    public class SampleTypeServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(SampleTypeServiceClient));

        public SampleTypeServiceClient() : base()
        {

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<RefSampleTypeReferenceGetListModel>> GetRefSampleType(string languageId)
        {
            log.Info("GetRefSampleType is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-SAMPLETYPELIST"))
                {
                    Query = string.Format("languageId={0}", new[] { Convert.ToString(languageId) })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();
                log.Info("GetRefSampleType returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefSampleTypeReferenceGetListModel>();
                }
                return JsonConvert.DeserializeObject<List<RefSampleTypeReferenceGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetRefSampleType failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="adminSampleTypeSetParams"></param>
        /// <returns></returns>
        public async Task<List<RefSampletypereferenceSetModel>> SampleTypeSet(AdminSampleReferenceTypeSet adminSampleTypeSetParams)
        {
            log.Info("SampleTypeSet is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(adminSampleTypeSetParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("ADMIN-POST-SAMPLETYPE"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();
                log.Info("SampleTypeSet returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefSampletypereferenceSetModel>();
                }
                return JsonConvert.DeserializeObject<List<RefSampletypereferenceSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("SampleTypeSet failed", e);
                throw e;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="idfsSampleType"></param>
        /// <returns></returns>
        public async Task<List<RefSampletypereferenceDelModel>> RefSampleTypeDel(long idfsSampleType, bool deleteAnyway)
        {
            log.Info("RefSampleTypeDel is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-DEL-SAMPLETYPE"))
                {
                    Query = string.Format("idfsSampleType={0}&deleteAnyway={1}", new[] { Convert.ToString(idfsSampleType), Convert.ToString(deleteAnyway) })
                };

                var response = _apiclient.DeleteAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                log.Info("RefSampleTypeDel returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefSampletypereferenceDelModel>();
                }
                return JsonConvert.DeserializeObject<List<RefSampletypereferenceDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("RefSampleTypeDel failed", e);
                throw e;
            }
        }
    }
}
