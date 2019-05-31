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
    public class VectorSubTypeServiceClient : APIClientBase
    {

        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(VectorTypeServiceClient));

        public VectorSubTypeServiceClient() : base()
        {

        }

        public async Task<List<RefVectorSubTypeGetListModel>> RefVectorSubTypeGetList(string languageId, long idfsVectorType)
        {
            log.Info("RefVectorSubTypeGetList begins");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {

                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-REF-VECTORSUBTYPELIST"))
                {
                    Query = string.Format("languageId={0}&idfsVectorType={1}", new[] { Convert.ToString(languageId), Convert.ToString(idfsVectorType) })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefVectorSubTypeGetListModel>();
                }

                log.Info("RefVectorSubTypeGetList returned");
                return JsonConvert.DeserializeObject<List<RefVectorSubTypeGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("RefVectorSubTypeGetList failed", ex);
                throw ex;
            }
        }

        public async Task<List<RefVectorSubTypeSetModel>> RefVectorSubTypeSet(ReferenceVectorSubTypeSetParams vectorSubTypeSetParams)
        {
            log.Info("RefVectorSubTypeSet begins");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {            
                //Serialize the request parameters
                var content = CreateRequestContent(vectorSubTypeSetParams);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("ADMIN-POST-REF-VECTORSUBTYPESET"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if(aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefVectorSubTypeSetModel>();
                }

                log.Info("RefVectorSubTypeSet returned");
                return JsonConvert.DeserializeObject<List<RefVectorSubTypeSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("RefVectorSubTypeSet failed", ex);
                throw ex;
            }
        }

        public async Task<List<RefVectorSubTypeDelModel>> RefVectorSubTypeDel(long idfsVectorSubType, bool deleteAnyway)
        {
            log.Info("RefVectorSubTypeDel begins");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            { 
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-DEL-REF-VECTORSUBTYPEDEL"))
                {
                    Query = string.Format("idfsVectorSubType={0}&deleteAnyway={1}", new[] { Convert.ToString(idfsVectorSubType), Convert.ToString(deleteAnyway) })
                };

                var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefVectorSubTypeDelModel>();
                }

                log.Info("RefVectorSubTypeDel returned");
                return JsonConvert.DeserializeObject<List<RefVectorSubTypeDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("RefVectorSubTypeDel failed", ex);
                throw ex;
            }
        }
    }
}
