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
    public class VectorTypeServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(VectorTypeServiceClient));

        /// <summary>
        /// Creates a new instance of this class.
        /// </summary>
        public VectorTypeServiceClient() : base()
        {

        }

        public async Task<List<RefVectortypereferenceGetListModel>> RefVectorTypeGetList(string languageId)
        {
            log.Info("RefVectorTypeGetList begins");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {

                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-REF-VECTORTYPELIST"))
                {
                    Query = string.Format("languageId={0}", new[] { Convert.ToString(languageId) })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);                 
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter}); 
                
                if(aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefVectortypereferenceGetListModel>();
                }

                log.Info("RefVectorTypeGetList returned");
                return JsonConvert.DeserializeObject<List<RefVectortypereferenceGetListModel>>(aPIReturnResult.Results);

            }
            catch (Exception ex)
            {
                log.Error("RefVectorTypeGetList failed", ex);
                throw ex;
            }
        }

        public async Task<List<RefVectortypereferenceSetModel>> RefVectorTypeSet(RefVectorTypeSetParams vectorTypeSetParams)
        {
            log.Info("RefVectorTypeSet begins");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {

                //Serialize the request parameters
                var content = CreateRequestContent(vectorTypeSetParams);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("ADMIN-POST-REF-VECTORTYPESET"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });

                if(aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefVectortypereferenceSetModel>();
                }

                log.Info("RefVectorTypeSet returned");

                return JsonConvert.DeserializeObject<List<RefVectortypereferenceSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("RefVectorTypeSet failed", ex);
                throw ex;
            }
        }

        public async Task<List<RefVectortypereferenceDelModel>> RefVectorTypeDel(long idfsVectorType, bool deleteAnyway)
        {
            log.Info("RefVectorTypeDel is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-DEL-REF-VECTORTYPE"))
                {
                    Query = string.Format("idfsVectorType={0}&deleteAnyway={1}", new[] { Convert.ToString(idfsVectorType), Convert.ToString(deleteAnyway) })
                };

                var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });

                if(aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefVectortypereferenceDelModel>();
                }

                log.Info("RefVectorTypeDel returned");

                return JsonConvert.DeserializeObject<List<RefVectortypereferenceDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("RefVectorTypeDel failed", e);
                throw e;
            }
        }
    }
}
