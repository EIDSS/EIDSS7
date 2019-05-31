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
    public class StatisticDataTypeServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(StatisticDataTypeServiceClient));

        public StatisticDataTypeServiceClient() : base()
        { }

        public async Task<List<RefStatisticdatatypeGetListModel>> RefStatisticDataTypeGetList(string languageId)
        {
            log.Info("RefStatisticalDataTypeGetList begins");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-REF-STATISTICDATATYPELIST"))
                {
                    Query = string.Format("lagnuageId={0}", new[] { Convert.ToString(languageId) })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();
                log.Info("RefStatisticalDataTypeGetList returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefStatisticdatatypeGetListModel>();
                }

                return JsonConvert.DeserializeObject<List<RefStatisticdatatypeGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("RefStatisticalDataTypeGetList failed", ex);
                throw;
            }
        }

        public async Task<List<RefStatisticdatatypeSetModel>> RefStatisticDataTypeSet(ReferenceStatDataTypeSetParams statDataTypeSetParams)
        {
            log.Info("RefStatisticalDataTypeSet begins");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {

                //Serialize the request parameters
                var content = CreateRequestContent(statDataTypeSetParams);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("ADMIN-POST-REF-STATISTICDATAYPESET"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();
                log.Info("RefStatisticalDataTypeSet returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefStatisticdatatypeSetModel>();
                }

                return JsonConvert.DeserializeObject<List<RefStatisticdatatypeSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("RefStatisticalDataTypeSet failed", ex);
                throw ex;
            }
        }

        public async Task<List<RefStatisticdatatypeDelModel>> RefStatisticalDataTypeDel(long idfsStatisticDataType, bool? deleteAnyway)
        {
            log.Info("RefStatisticalDataTypeDel begins");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {

                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-DEL-REF-STATISTICDATADEL"))
                {
                    Query = string.Format("idfsStatisticDataType={0}&deleteAnyway={1}", new[] { Convert.ToString(idfsStatisticDataType), Convert.ToString(deleteAnyway) })
                };

                var response = _apiclient.DeleteAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                log.Info("RefStatisticalDataTypeDel returned");
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefStatisticdatatypeDelModel>();
                }

                return JsonConvert.DeserializeObject<List<RefStatisticdatatypeDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("RefStatisticalDataTypeDel failed", ex);
                throw ex;

            }
        }
                                                 
  public async Task<List<AdminStatGetListModel>> StatGetList(string languageId, long? idfsStatisticalDataType, long? idfsArea, DateTime? datStatisticStartDateFrom, DateTime? datStatisticStartDateTo)
        {
            log.Info("StatGetList begins");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-STATLIST"))
                {                    
                    Query = string.Format("languageId={0}&idfsStatisticalDataType={1}&idfsArea={2}&datStatisticStartDateFrom={3}&datStatisticStartDateTo={4}", new[] { Convert.ToString(languageId), Convert.ToString(idfsStatisticalDataType), Convert.ToString(idfsArea), Convert.ToString(datStatisticStartDateFrom), Convert.ToString(datStatisticStartDateTo) })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();
                log.Info("StatGetList returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminStatGetListModel>();
                }

                return JsonConvert.DeserializeObject<List<AdminStatGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("StatGetList failed", ex);
                throw;
            }
        }
    }
}
