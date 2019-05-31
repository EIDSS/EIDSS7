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
    public class DiagnosisServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(DiagnosisServiceClient));

        public DiagnosisServiceClient() : base()
        {
        }
 
        /// <summary>
        /// Returns Dianosis Reference List
        /// </summary>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<RefDiagnosisreferenceGetListModel>> RefDiagnosisreferenceGetList(string languageId)
        {
            log.Info("RefDiagnosisreferenceGetList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-DIAGNOSISREFLIST"))
                {
                    Query = string.Format("languageId={0}", new[] { Convert.ToString(languageId) })
                };

                var response =  _apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                log.Info("RefDiagnosisreferenceGetList returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefDiagnosisreferenceGetListModel>();
                }
                return JsonConvert.DeserializeObject<List<RefDiagnosisreferenceGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("RefDiagnosisreferenceGetList failed", e);
                throw e;
            }
        }
        
        public async Task<List<RefDiagnosisreferenceSetModel>> RefDiagnosisreferenceSet(ReferenceDiagnosisSetParams referenceDiagnosisSetParams)
        {
            log.Info("RefDiagnosisreferenceSet is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(referenceDiagnosisSetParams);
                    
                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("ADMIN-POST-REFDIAGNOSISSET"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefDiagnosisreferenceSetModel>();
                }
                
                log.Info("RefDiagnosisreferenceSet returned");
                return JsonConvert.DeserializeObject<List<RefDiagnosisreferenceSetModel>>(aPIReturnResult.Results);
            }

            catch (Exception e)
            {
                log.Error("RefDiagnosisreferenceSet failed", e);
                throw e;
            }
        }

       /// <summary>
       /// deletes Diagnosis 
       /// </summary>
       /// <param name="idfsDiagnosis"></param>
       /// <returns></returns>
        public async Task<List<RefDiagnosisreferenceDelModel>> RefDiagnosisreferenceDel(long idfsDiagnosis, bool deleteAnyway)
        {
            log.Info("RefDiagnosisreferenceDel is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-DEL-DIAGNOSISDEL"))
                {
                    Query = string.Format("idfsDiagnosis={0}&deleteAnyway={1}", new[] { Convert.ToString(idfsDiagnosis), Convert.ToString(deleteAnyway) })
                };

                var response =  _apiclient.DeleteAsync(builder.Uri).Result;
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK )
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefDiagnosisreferenceDelModel>();
                }
                log.Info("RefDiagnosisreferenceDel returned");
                return JsonConvert.DeserializeObject<List<RefDiagnosisreferenceDelModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("RefDiagnosisreferenceDel failed", e);
                throw e;
            }
        }
    }
}
