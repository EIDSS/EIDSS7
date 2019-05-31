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
    /// Client service that contains vector module related functionality that is utilized across multiple functional areas.
    /// </summary>
    public class VectorServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(VectorServiceClient));

        /// <summary>
        /// Creates a new instance of this class.
        /// </summary>
        public VectorServiceClient() : base()
        {
        }

        /// <summary>
        /// Returns a list of vector surveillance sessions.
        /// </summary>
        /// <param name="parameters"></param>
        /// <returns></returns>
        public async Task<List<VctsSurveillanceSessionGetListModel>> GetVectorSurveillanceSessionListAsync(VectorSurveillanceSessionGetListParams parameters)
        {
            log.Info("GetVectorSurveillanceSessionListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {


                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("VectorSurveillanceSessionGetListAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                log.Info("GetVectorSurveillanceSessionListAsync returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctsSurveillanceSessionGetListModel>();
                }
                return JsonConvert.DeserializeObject<List<VctsSurveillanceSessionGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetVectorSurveillanceSessionListAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Returns a record count of vector surveillance sessions.
        /// </summary>
        /// <param name="parameters"></param>
        /// <returns></returns>
        public async Task<List<VctsSurveillanceSessionGetCountModel>> GetVectorSurveillanceSessionListCountAsync(VectorSurveillanceSessionGetListParams parameters)
        {
            log.Info("GetVectorSurveillanceSessionListCountAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {


                var content = CreateRequestContent(parameters);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("VectorSurveillanceSessionGetListCountAsync"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                log.Info("GetVectorSurveillanceSessionListCountAsync returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctsSurveillanceSessionGetCountModel>();
                }
                return JsonConvert.DeserializeObject<List<VctsSurveillanceSessionGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetVectorSurveillanceSessionListCountAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Get VSS Detail
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfVectorSurveillanceSession"></param>
        /// <returns></returns>
        public async Task<List<VctsVssessionGetDetailModel>> VectorSurveillanceSessionGetDetail(string languageId, long idfVectorSurveillanceSession)
        {
            log.Info("VectorSurveillanceSessionGetDetail is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VectorSurveillanceSessionGetDetail"))
                {
                    Query = string.Format("languageId={0}&idfVectorSurveillanceSession={1}", new[] { languageId, Convert.ToString(idfVectorSurveillanceSession) })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctsVssessionGetDetailModel>();
                }

                log.Info("VectorSurveillanceSessionGetDetail returned");
                return JsonConvert.DeserializeObject<List<VctsVssessionGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("VectorSurveillanceSessionGetDetail failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Get VSS Detailed Collection List
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfVectorSurveillanceSession"></param>
        /// <returns></returns>
        public async Task<List<VctsVectGetDetailModel>> VectorSurveillanceSessionDetailedCollectionGetList(string languageId, long idfVectorSurveillanceSession)
        {
            log.Info("VectorSurveillanceSessionDetailedCollectionGetList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VectorSurveillanceSessionDetailedCollectionGetList"))
                {
                    Query = string.Format("languageId={0}&idfVectorSurveillanceSession={1}", new[] { languageId, Convert.ToString(idfVectorSurveillanceSession) })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctsVectGetDetailModel>();
                }

                log.Info("VectorSurveillanceSessionDetailedCollectionGetList returned");
                return JsonConvert.DeserializeObject<List<VctsVectGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("VectorSurveillanceSessionDetailedCollectionGetList failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Get VSS Aggregate Collection List
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfVectorSurveillanceSession"></param>
        /// <returns></returns>
        public async Task<List<VctsVecSessionSummaryGetListModel>> VectorSurveillanceSessionAggregateCollectionGetList(string languageId, long idfVectorSurveillanceSession)
        {
            log.Info("VectorSurveillanceSessionAggregateCollectionGetList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VectorSurveillanceSessionAggregateCollectionGetList"))
                {
                    Query = string.Format("languageId={0}&idfVectorSurveillanceSession={1}", new[] { languageId, Convert.ToString(idfVectorSurveillanceSession) })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctsVecSessionSummaryGetListModel>();
                }

                log.Info("VectorSurveillanceSessionAggregateCollectionGetList returned");
                return JsonConvert.DeserializeObject<List<VctsVecSessionSummaryGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("VectorSurveillanceSessionAggregateCollectionGetList failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Get VSS Detailed Collection Detail
        /// </summary>
        /// <param name="idfVector"></param>
        /// <param name="idfVectorSurveillanceSession"></param>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<VctsVectCollectionGetDetailModel>> VectorSurveillanceSessionDetailedCollectionGetDetail(long idfVector, long idfVectorSurveillanceSession, string languageId)
        {
            log.Info("VctsVectCollectionGetDetail is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VectorSurveillanceSessionDetailedCollectionGetDetail"))
                {
                    Query = string.Format("idfVector={0}&idfVectorSurveillanceSession={1}&languageId={2}", new[] { Convert.ToString(idfVector), Convert.ToString(idfVectorSurveillanceSession), languageId })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctsVectCollectionGetDetailModel>();
                }

                log.Info("VctsVectCollectionGetDetail returned");
                return JsonConvert.DeserializeObject<List<VctsVectCollectionGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("VctsVectCollectionGetDetail failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Get VSS Detailed Collection - Samples List
        /// </summary>
        /// <param name="idfVector"></param>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<VctsSampleGetListModel>> VectorSurveillanceSessionDetailedCollectionSampleGetList(long idfVector, string languageId)
        {
            log.Info("VectorSurveillanceSessionDetailedCollectionSampleGetList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VectorSurveillanceSessionDetailedCollectionSampleGetList"))
                {
                    Query = string.Format("idfVector={0}&languageId={1}", new[] { Convert.ToString(idfVector), languageId })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctsSampleGetListModel>();
                }

                log.Info("VectorSurveillanceSessionDetailedCollectionSampleGetList returned");
                return JsonConvert.DeserializeObject<List<VctsSampleGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("VectorSurveillanceSessionDetailedCollectionSampleGetList failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Get VSS Detailed Collection - Field Tests List
        /// </summary>
        /// <param name="idfVector"></param>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<VctsFieldtestGetListModel>> VectorSurveillanceSessionDetailedCollectionFieldTestsGetList(long idfVector, string languageId)
        {
            log.Info("VectorSurveillanceSessionDetailedCollectionFieldTestsGetList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VectorSurveillanceSessionDetailedCollectionFieldTestsGetList"))
                {
                    Query = string.Format("idfVector={0}&languageId={1}", new[] { Convert.ToString(idfVector), languageId })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctsFieldtestGetListModel>();
                }

                log.Info("VectorSurveillanceSessionDetailedCollectionFieldTestsGetList returned");
                return JsonConvert.DeserializeObject<List<VctsFieldtestGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("VectorSurveillanceSessionDetailedCollectionFieldTestsGetList failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Get VSS Detailed Collection Lab Test List
        /// </summary>
        /// <param name="idfVector"></param>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<VctsLabtestGetListModel>> VectorSurveillanceSessionDetailedCollectionLabTestsGetList(long idfVector, long idfVectorSurveillanceSession, string languageId)
        {
            log.Info("VectorSurveillanceSessionDetailedCollectionLabTestsGetList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VectorSurveillanceSessionDetailedCollectionLabTestsGetList"))
                {
                    Query = string.Format("idfVector={0}&idfVectorSurveillanceSession={1}&languageId={2}", new[] { Convert.ToString(idfVector), Convert.ToString(idfVectorSurveillanceSession), languageId })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctsLabtestGetListModel>();
                }

                log.Info("VectorSurveillanceSessionDetailedCollectionLabTestsGetList returned");
                return JsonConvert.DeserializeObject<List<VctsLabtestGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("VectorSurveillanceSessionDetailedCollectionLabTestsGetList failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Get VSS Aggregate Collection Detail
        /// </summary>
        /// <param name="idfVector"></param>
        /// <param name="idfVectorSurveillanceSession"></param>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<VctsVecSessionSummaryGetDetailModel>> VectorSurveillanceSessionAggregateCollectionGetDetail(long idfsVsSessionSummary, long idfVectorSurveillanceSession, string languageId)
        {
            log.Info("VctsVecSessionSummaryGetDetail is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VectorSurveillanceSessionAggregateCollectionGetDetail"))
                {
                    Query = string.Format("idfsVsSessionSummary={0}&idfVectorSurveillanceSession={1}&languageId={2}", new[] { Convert.ToString(idfsVsSessionSummary), Convert.ToString(idfVectorSurveillanceSession), languageId })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctsVecSessionSummaryGetDetailModel>();
                }

                log.Info("VctsVecSessionSummaryGetDetail returned");
                return JsonConvert.DeserializeObject<List<VctsVecSessionSummaryGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("VctsVecSessionSummaryGetDetail failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Get VSS Aggregate Collection - Diagnosis List
        /// </summary>
        /// <param name="idfsVsSessionSummary"></param>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<VctsSessionsummarydiagnosisGetDetailModel>> VectorSurveillanceSessionAggregateCollectionDiagnosisGetList(long idfsVsSessionSummary, string languageId)
        {
            log.Info("VectorSurveillanceSessionAggregateCollectionDiagnosisGetList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VectorSurveillanceSessionAggregateCollectionDiagnosisGetList"))
                {
                    Query = string.Format("idfsVsSessionSummary={0}&languageId={1}", new[] { Convert.ToString(idfsVsSessionSummary), languageId })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctsSessionsummarydiagnosisGetDetailModel>();
                }

                log.Info("VectorSurveillanceSessionAggregateCollectionDiagnosisGetList returned");
                return JsonConvert.DeserializeObject<List<VctsSessionsummarydiagnosisGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("VectorSurveillanceSessionAggregateCollectionDiagnosisGetList failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Get VSS Save
        /// </summary>
        /// <param></param>VectorSurveillanceSessionSetParams</param>
        /// <returns>VctsVecSessionSetModel</returns>
        public async Task<List<VctsVecSessionSetModel>> VectorSurveillanceSessionSaveDetail(VectorSurveillanceSessionSetParams vectorSurveillanceSessionParams)
        {
            log.Info("VectorSurveillanceSessionSaveDetail is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object.  This will serialize the parms using our formatter!
                var content = this.CreateRequestContent<VectorSurveillanceSessionSetParams>(vectorSurveillanceSessionParams);

                HttpResponseMessage response = await _apiclient.PostAsync(Settings.GetResourceValue("VectorSurveillanceSessionSave"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctsVecSessionSetModel>();
                }

                log.Info("VectorSurveillanceSessionSaveDetail returned");
                return JsonConvert.DeserializeObject<List<VctsVecSessionSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("VectorSurveillanceSessionSaveDetail failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Delete VSS Detail
        /// </summary>
        /// <param name="idfVectorSurveillanceSession"></param>
        /// <returns></returns>
        public async Task<List<VctsVecSessionDelModel>> VectorSurveillanceSessionDeleteDetail(long idfVectorSurveillanceSession)
        {
            log.Info("VectorSurveillanceSessionDeleteDetail is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("VectorSurveillanceSessionDelete"))
                {
                    Query = string.Format("idfVectorSurveillanceSession={0}", new[] { Convert.ToString(idfVectorSurveillanceSession) })
                };

                HttpResponseMessage response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<VctsVecSessionDelModel>();
                }

                log.Info("VectorSurveillanceSessionDeleteDetail returned");
                return JsonConvert.DeserializeObject<List<VctsVecSessionDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("VectorSurveillanceSessionDeleteDetail failed", e);
                throw e;
            }
        }
    }
}
