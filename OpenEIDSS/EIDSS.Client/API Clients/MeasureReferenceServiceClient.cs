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
    public class MeasureReferenceServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(MeasureReferenceServiceClient));
        
        public MeasureReferenceServiceClient() : base()
        { }

        public async Task<List<RefMeasurelistGetListModel>> RefMeasureTypeGetList(string languageId)
        {
            log.Info("RefMeasureTypeGetList begins");

            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-MEASURETYPELIST"))
                {
                    Query = string.Format("languageId={0}", new[] { Convert.ToString(languageId) })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefMeasurelistGetListModel>();
                }

                log.Info("RefMeasureTypeGetList returned");
                return JsonConvert.DeserializeObject<List<RefMeasurelistGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("RefMeasureTypeGetList failed", ex);
                throw ex;
            }
        }

        public async Task<List<RefMeasurereferenceGetListModel>> RefMeasureReferenceGetList(string languageId, long idfsActionList)
        {
            log.Info("RefMeasureReferenceGetList begins");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-MEASUREREFERENCELIST"))
                {
                    Query = string.Format("languageId={0}&idfsActionList={1}", new[] { Convert.ToString(languageId), Convert.ToString(idfsActionList) })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefMeasurereferenceGetListModel>();
                }

                log.Info("RefMeasureReferenceGetList returned");
                return JsonConvert.DeserializeObject<List<RefMeasurereferenceGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("RefMeasureReferenceGetList failed", ex);
                throw ex;
            }
        }

        public async Task<List<RefMeasurereferenceSetModel>> RefMeasureReferenceSet(RefMeasureReferenceSetParams measureReferenceSetParams)
        {
            log.Info("RefMeasureReferenceSet begins");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {

                //Serialize the request parameters
                var content = CreateRequestContent(measureReferenceSetParams);                
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("ADMIN-POST-REF-MEASEUREREFERENCESET"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefMeasurereferenceSetModel>();
                }
                log.Info("RefMeasureReferenceSet returned");

                return JsonConvert.DeserializeObject<List<RefMeasurereferenceSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("RefMeasureReferenceSet failed", ex);
                throw ex;
            }
        }

        public async Task<List<RefMeasurerefefenceDelModel>> RefMeasureRefefenceDel(long idfsAction, long idfsMeasureList, bool deleteAnyway)
        {
            log.Info("RefMeasureRefefenceDel is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-DEL-REF-MEASEUREREFERENCEDEL"))
                {
                    Query = string.Format("idfsAction={0}&idfsMeasureList={1}&deleteAnyway={2}", new[] { Convert.ToString(idfsAction), Convert.ToString(idfsMeasureList), Convert.ToString(deleteAnyway) })
                };

                var response = _apiclient.DeleteAsync(builder.Uri).Result;
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefMeasurerefefenceDelModel>();
                }


                log.Info("RefMeasureRefefenceDel returned");
                return JsonConvert.DeserializeObject<List<RefMeasurerefefenceDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("RefMeasureRefefenceDel failed", e);
                throw e;
            }
        }
    }
}
