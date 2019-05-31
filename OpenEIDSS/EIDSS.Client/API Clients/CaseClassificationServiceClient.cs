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
    public class CaseClassificationServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(CaseClassificationServiceClient));

        public CaseClassificationServiceClient() : base()
        {
        }

       
        /// <summary>
        /// Returns Case Classification
        /// </summary>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<RefCaseclassificationGetListModel>>  GetRefCaseClassification(string languageId)
        {
            log.Info("GetRefCaseClassification is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-CASECLASSIFICATIONLIST"))
                {
                    Query = string.Format("languageId={0}", new[] { Convert.ToString(languageId) })
                };

                var response =  _apiclient.GetAsync(builder.Uri).Result;
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefCaseclassificationGetListModel>();
                }
                log.Info("GetRefCaseClassification is returned");
                return JsonConvert.DeserializeObject<List<RefCaseclassificationGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetRefCaseClassification failed", e);
                throw e;
            }
        }



        /// <summary>
        /// Saves Case Classification
        /// </summary>
        /// <param name="adminCaseClassificationSetParams">JSON object AdminCaseClassificationSetParams </param>
        /// <returns></returns>
        public async Task<List<RefCaseclassificationSetModel>> CaseClassificationSet(AdminCaseClassificationSetParams adminCaseClassificationSetParams)
        {
            log.Info("CaseClassificationSet is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(adminCaseClassificationSetParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("ADMIN-POST-CASECLASSIFICATION"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefCaseclassificationSetModel>();
                }
                log.Info("CaseClassificationSet is returned");
                return JsonConvert.DeserializeObject<List<RefCaseclassificationSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("CaseClassificationSet failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Deletes Case Classification
        /// </summary>
        /// <param name="idfsCaseClassification"></param>
        /// <returns></returns>
        public async Task<List<RefCaseclassificationDelModel>> RefCaseClassificationDel(long idfsCaseClassification, bool deleteAnyway)
        {
            log.Info("RefCaseClassificationDel is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-DEL-CASECLASSIFICATION"))
                {
                    Query = string.Format("idfsCaseClassification={0}&deleteAnyway={1}", new[] { Convert.ToString(idfsCaseClassification), Convert.ToString(deleteAnyway) })
                };

                var response = _apiclient.DeleteAsync(builder.Uri).Result;
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefCaseclassificationDelModel>();
                }
                log.Info("RefCaseClassificationDel is returned");
                return JsonConvert.DeserializeObject<List<RefCaseclassificationDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("RefCaseClassificationDel failed", e);
                throw e;
            }
        }
    }
}
