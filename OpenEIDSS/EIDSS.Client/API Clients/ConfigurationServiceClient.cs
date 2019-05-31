using EIDSS.Client.Abstracts;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Domain.Return_Contracts;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Threading.Tasks;

using Newtonsoft.Json;
namespace EIDSS.Client.API_Clients
{
    /// <summary>
    /// Client service that contains common functionality that is utilized across multiple functional areas
    /// </summary>
    public class ConfigurationServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(ConfigurationServiceClient));

        /// <summary>
        /// Creates a new instance of this class.
        /// </summary>
        public ConfigurationServiceClient() : base()
        {
        }

        /// <summary>
        /// Returns a List Of Base ReferenceTypes
        /// </summary>
        /// <param name="referneceId"></param>
        /// <returns></returns>
        public async Task<List<ConfAggregateSettingSetModel>> SaveAggregateSettings(List<AggregateSettingsSetParam> aggregateSettingsSetParam)
        {
            log.Info("AddAggregateSetting is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the content object. This will serialize the parms using our formatter! Beautiful!
                var content = CreateRequestContent(aggregateSettingsSetParam);
                var response = _apiclient.PostAsync(Settings.GetResourceValue("CONFIG-SAVE-AGGR-SETTINGS"), content).Result;
                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfAggregateSettingSetModel>();
                }
                return JsonConvert.DeserializeObject<List<ConfAggregateSettingSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("AddAggregateSetting failed", e);
                throw e;
            }
        }
        public List<ConfAggregateSettingGetListModel> GetAggregateSettings(long idfCustomizationPackage)

        {
            log.Info("GetAggregateSettings is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("CONFIG-GET-AGGR-SETTINGS"))
                {
                    Query = string.Format("idfCustomizationPackage={0}", new[] { Convert.ToString(idfCustomizationPackage) })
                };

                var response = _apiclient.GetAsync(builder.Uri).Result;
                response.EnsureSuccessStatusCode();
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetAggregateSettings Returned " + aPIReturnResult.ErrorMessage);
                    return new List<ConfAggregateSettingGetListModel>();
                }
                log.Info("GetAggregateSettings returned");
                return JsonConvert.DeserializeObject<List<ConfAggregateSettingGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetAggregateSettings failed", e);
                throw e;
            }
        }

        public List<AdminConfDataArchiveSettingsGetModel> GetDataArchiveSettings()
        {

            log.Info("GetDataArchiveSettings is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("CONFIG-GET-GETARCHIVE-SETTINGS"));
                var response = _apiclient.GetAsync(builder.Uri).Result;
                response.EnsureSuccessStatusCode();
                log.Info("GetDataArchiveSettings returned");
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetAggregateSettings Returned " + aPIReturnResult.ErrorMessage);
                    return new List<AdminConfDataArchiveSettingsGetModel>();
                }
                return JsonConvert.DeserializeObject<List<AdminConfDataArchiveSettingsGetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetDataArchiveSettings failed", e);
                throw e;
            }
        }

        public async Task<List<AdminConfDataArchiveSettingsSetModel>> SaveDataArchiveSettings(AdminArchiveSettingsSetParams adminArchiveSettingsSetParams)
        {
            log.Info("SaveDataArchiveSettings is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(adminArchiveSettingsSetParams);
                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONFIG-POST-SAVEARCHIVE-SETTINGS"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                log.Info("SaveDataArchiveSettings returned");
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("SaveDataArchiveSettings Returned " + aPIReturnResult.ErrorMessage);
                    return new List<AdminConfDataArchiveSettingsSetModel>();
                }
                return JsonConvert.DeserializeObject<List<AdminConfDataArchiveSettingsSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("SaveDataArchiveSettings failed", e);
                throw e;
            }
        }

        #region Matrixes

        
       
        public List<ConfHumanAggregateCaseMatrixVersionByMatrixTypeGetModel> GetMatrixVersionByType(long? idfsMatrixType)
        {

            log.Info("GetMatrixVersionByType is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("CONF-AGGCASEMTX-VERSIONBYTYPE-GETLIST"))
                {
                    Query = string.Format("matrixType={0}", new[] { Convert.ToString(idfsMatrixType) })
                };
            
                var response = _apiclient.GetAsync(builder.Uri).Result;
                response.EnsureSuccessStatusCode();
                log.Info("GetMatrixVersionByType returned");
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetMatrixVersionByType Returned " + aPIReturnResult.ErrorMessage);
                    return new List<ConfHumanAggregateCaseMatrixVersionByMatrixTypeGetModel>();
                }
                return JsonConvert.DeserializeObject<List<ConfHumanAggregateCaseMatrixVersionByMatrixTypeGetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetMatrixVersionByType failed", e);
                throw e;
            }
        }

        public List<ConfHumanAggregateCaseMatrixVersionGetModel> GetMatrixVersions()

        {

            log.Info("GetHumanAggregateCaseReportVersion is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("CONF-AGGCASEMTX-VERSION-GETLIST-OVERLOAD"));
              

                var response = _apiclient.GetAsync(builder.Uri).Result;
                response.EnsureSuccessStatusCode();
                log.Info("GetHumanAggregateCaseReportVersion returned");
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetHumanAggregateCaseReportVersion Returned " + aPIReturnResult.ErrorMessage);
                    return new List<ConfHumanAggregateCaseMatrixVersionGetModel>();
                }
                return JsonConvert.DeserializeObject<List<ConfHumanAggregateCaseMatrixVersionGetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetHumanAggregateCaseReportVersion failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Saves Human Aggregate Case Report Matrix
        /// </summary>
        /// <param name="adminArchiveSettingsSetParams"></param>
        /// <returns></returns>
        public async Task<List<ConfHumanAggregateCaseMatrixReportPostModel>> SaveHumanAggregateCaseReportMatrix(List<HumanCaseMtxReportPostParams> humanCaseMtxReportPostParams)
        {
            var r = JsonConvert.SerializeObject(humanCaseMtxReportPostParams);
            log.Info("SaveHumanAggregateCaseReportMatrix is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters
               
                var content = CreateRequestContent(humanCaseMtxReportPostParams);
                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-AGGCASEMTXREPORT-POST"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                log.Info("SaveHumanAggregateCaseReportMatrix returned");
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfHumanAggregateCaseMatrixReportPostModel>();
                }
                log.Info("HumanAggReportSaveVersion returned");
                return JsonConvert.DeserializeObject<List<ConfHumanAggregateCaseMatrixReportPostModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("SaveHumanAggregateCaseReportMatrix failed", e);
                throw e;
            }
        }


        /// <summary>
        /// Saves VET Aggregate Case Report Matrix
        /// </summary>
        /// <param name="adminArchiveSettingsSetParams"></param>
        /// <returns></returns>
        public async Task<List<ConfVetAggregateCaseMatrixReportPostModel>> SaveVetAggregateCaseReportMatrix(List<VetCaseMtxReportPostParams> vetCaseMtxReportPostParams)
        {
            var r = JsonConvert.SerializeObject(vetCaseMtxReportPostParams);
            log.Info("SaveVetAggregateCaseReportMatrix is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters

                var content = CreateRequestContent(vetCaseMtxReportPostParams);
                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-VETAGGCASEMTXREPORT-POST"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                log.Info("SaveVetAggregateCaseReportMatrix returned");
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfVetAggregateCaseMatrixReportPostModel>();
                }
                log.Info("SaveVetAggregateCaseReportMatrix returned");
                return JsonConvert.DeserializeObject<List<ConfVetAggregateCaseMatrixReportPostModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("SaveVetAggregateCaseReportMatrix failed", e);
                throw e;
            }
        }









        public async Task<List<ConfAggrDiagnosticActionMtxReportJsonPostModel>> SaveVetDiagnosisAggregateCaseReportMatrix(List<VetDiagnosisInvestigationMtxReportPostParams> postParams)
        {
            var r = JsonConvert.SerializeObject(postParams);
            log.Info("SaveVetDiagnosisAggregateCaseReportMatrix is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters

                var content = CreateRequestContent(postParams);
                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-VETDIAGNOSISMTX-POST"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                log.Info("SaveVetDiagnosisAggregateCaseReportMatrix returned");
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfAggrDiagnosticActionMtxReportJsonPostModel>();
                }
                log.Info("SaveVetDiagnosisAggregateCaseReportMatrix returned");
                return JsonConvert.DeserializeObject<List<ConfAggrDiagnosticActionMtxReportJsonPostModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("SaveVetDiagnosisAggregateCaseReportMatrix failed", e);
                throw e;
            }
        }






        public async Task<List<ConFtlbAggrProphylacticActionMtxReportJsonPostModel>> SaveProphylacticReportMatrix(List<ProphylacticMtxReportPostParams> postParams)
        {
            var r = JsonConvert.SerializeObject(postParams);
            log.Info("SaveProphylacticDiagnosisAggregateCaseReportMatrix is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters

                var content = CreateRequestContent(postParams);
                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-PROPHYLACTICMTX-POST"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                log.Info("SaveProphylacticDiagnosisAggregateCaseReportMatrix returned");
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConFtlbAggrProphylacticActionMtxReportJsonPostModel>();
                }
                log.Info("SaveProphylacticDiagnosisAggregateCaseReportMatrix returned");
                return JsonConvert.DeserializeObject<List<ConFtlbAggrProphylacticActionMtxReportJsonPostModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("SaveProphylacticDiagnosisAggregateCaseReportMatrix failed", e);
                throw e;
            }
        }



        /// <summary>
        /// Saves Sanitary Action Matrix
        /// </summary>
        /// <param name="postParams"></param>
        /// <returns></returns>
        public async Task<List<ConfAggrSanitaryActionMtxReportJsonPostModel>> SaveSanitaryMatrixReport(List<SanitaryMtxReportPostParams> postParams)
        {
            var r = JsonConvert.SerializeObject(postParams);
            log.Info("SaveProphylacticDiagnosisAggregateCaseReportMatrix is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters

                var content = CreateRequestContent(postParams);
                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-SANITARYMTX-POST"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                log.Info("SaveProphylacticDiagnosisAggregateCaseReportMatrix returned");
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfAggrSanitaryActionMtxReportJsonPostModel>();
                }
                log.Info("SaveProphylacticDiagnosisAggregateCaseReportMatrix returned");
                return JsonConvert.DeserializeObject<List<ConfAggrSanitaryActionMtxReportJsonPostModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("SaveProphylacticDiagnosisAggregateCaseReportMatrix failed", e);
                throw e;
            }
        }






        /// <summary>
        /// Returns Sanitary Action Types
        /// </summary>
        /// <param name="idfsBaseReference"></param>
        /// <param name="intHaCode"></param>
        /// <param name="strLanguageId"></param>
        /// <returns></returns>
        public async Task<List<ConfGetSanitaryActionsGetModel>> GetSanitaryActionTypes(long idfsBaseReference, int intHaCode, string strLanguageId)
        {
            log.Info("GetSanitaryActionTypes is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("CONF-SANITARYTYPES-GETLIST"))
                {
                    Query = string.Format("idfsBaseReference={0}&intHaCode={1}&strLanguageId={2}", new[] { Convert.ToString(idfsBaseReference), Convert.ToString(intHaCode), Convert.ToString(strLanguageId) })
                };

                var response = _apiclient.GetAsync(builder.Uri).Result;
                response.EnsureSuccessStatusCode();
                // Call the service.
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfGetSanitaryActionsGetModel>();
                }
                log.Info("GetSanitaryActionTypes returned");
                return JsonConvert.DeserializeObject<List<ConfGetSanitaryActionsGetModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("GetSanitaryActionTypes failed", e);
                throw e;
            }
        }







        /// <summary>
        /// Saves a Human Matrix Version
        /// </summary>
        /// <param name="aggregateCaseVerionPostParams"></param>
        /// <returns></returns>
        public async Task<List<ConfHumanAggregateCaseMatrixVersionPostModel>> HumanAggReportSaveVersion(AggregateCaseVerionPostParams aggregateCaseVerionPostParams)
        {
            log.Info("HumanAggReportSaveVersion is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(aggregateCaseVerionPostParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-AGGCASEMTX-VERSION-POST"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfHumanAggregateCaseMatrixVersionPostModel>();
                }
                log.Info("HumanAggReportSaveVersion returned");
                return JsonConvert.DeserializeObject<List<ConfHumanAggregateCaseMatrixVersionPostModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("HumanAggReportSaveVersion failed", e);
                throw e;
            }
        }



        /// <summary>
        /// Saves a Vet Matrix Version
        /// </summary>
        /// <param name="aggregateCaseVerionPostParams"></param>
        /// <returns></returns>
        public async Task<List<ConfHumanAggregateCaseMatrixVersionPostModel>> VetAggReportSaveVersion(AggregateCaseVerionPostParams aggregateCaseVerionPostParams)
        {
            log.Info("VetAggReportSaveVersion is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(aggregateCaseVerionPostParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-AGGCASEMTX-VERSION-POST"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfHumanAggregateCaseMatrixVersionPostModel>();
                }
                log.Info("VetAggReportSaveVersion returned");
                return JsonConvert.DeserializeObject<List<ConfHumanAggregateCaseMatrixVersionPostModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("VetAggReportSaveVersion failed", e);
                throw e;
            }
        }



        /// <summary>
        /// Saves A Vet Aggreagate Matrix Version
        /// </summary>
        /// <param name="aggregateCaseVerionPostParams"></param>
        /// <returns></returns>
        public async Task<List<ConfHumanAggregateCaseMatrixVersionPostModel>> VeterinaryAggReportSaveVersion(AggregateCaseVerionPostParams aggregateCaseVerionPostParams)
        {
            log.Info("VeterinaryAggReportSaveVersion is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(aggregateCaseVerionPostParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-AGGCASEMTX-VERSION-POST"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfHumanAggregateCaseMatrixVersionPostModel>();
                }
                log.Info("VeterinaryAggReportSaveVersion returned");
                return JsonConvert.DeserializeObject<List<ConfHumanAggregateCaseMatrixVersionPostModel>>(aPIReturnResult.Results);

            }
            catch (Exception e)
            {
                log.Error("VeterinaryAggReportSaveVersion failed", e);
                throw e;
            }
        }












        /// <summary>
        /// Deletes A Matrix Record
        /// </summary>
        /// <param name="idfAggrHumanCaseMtx"></param>
        /// <returns></returns>
        public async Task<List<ConfHumanAggregateCaseMatrixReportDeleteModel>> HumanAggReportDeleteMatrixRecord(long idfAggrHumanCaseMtx)
        {
            log.Info("HumanAggReportDeleteMatrixRecord is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("CONF-AGGCASEMTX-RECORD-DELETE"))
                {
                    Query = string.Format("idfAggrHumanCaseMtx={0}", new[] { Convert.ToString(idfAggrHumanCaseMtx) })
                };

                var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("HumanAggReportDeleteMatrixRecord Returned " + aPIReturnResult.ErrorMessage);
                    return new List<ConfHumanAggregateCaseMatrixReportDeleteModel>();
                }
                log.Info("HumanAggReportDeleteMatrixRecord returned");
                return JsonConvert.DeserializeObject<List<ConfHumanAggregateCaseMatrixReportDeleteModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("HumanAggReportDeleteMatrixRecord failed", e);
                throw e;
            }
        }




        /// <summary>
        /// Deletes A Matrix Record
        /// </summary>
        /// <param name="idfAggrHumanCaseMtx"></param>
        /// <returns></returns>
        public async Task<List<ConfVetAggregateCaseMatrixReportRecordDeleteModel>> VetAggReportDeleteMatrixRecord(long idfAggrHumanCaseMtx)
        {
            log.Info("VetAggReportDeleteMatrixRecord is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("CONF-VETAGGCASEMTX-RECORD-DELETE"))
                {
                    Query = string.Format("idfAggrHumanCaseMtx={0}", new[] { Convert.ToString(idfAggrHumanCaseMtx) })
                };

                var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("VetAggReportDeleteMatrixRecord Returned " + aPIReturnResult.ErrorMessage);
                    return new List<ConfVetAggregateCaseMatrixReportRecordDeleteModel>();
                }
                log.Info("VetAggReportDeleteMatrixRecord returned");
                return JsonConvert.DeserializeObject<List<ConfVetAggregateCaseMatrixReportRecordDeleteModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("VetAggReportDeleteMatrixRecord failed", e);
                throw e;
            }
        }



        /// <summary>
        /// Deletes A Vet Diagnosis Investigation Matrix Record
        /// </summary>
        /// <param name="idfAggrHumanCaseMtx"></param>
        /// <returns></returns>
        public async Task<List<ConfVetDiagnosisMatrixReportRecordDeleteModel>> VetDiagnosisDeleteMatrixRecord(long idfAggrDiagnosticActionMTX)
        {
            log.Info("VetDiagnosisDeleteMatrixRecord is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("CONF-VETDIAGNOSISRECORD-DELETE"))
                {
                    Query = string.Format("idfAggrDiagnosticActionMTX={0}", new[] { Convert.ToString(idfAggrDiagnosticActionMTX) })
                };

                var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("VetDiagnosisDeleteMatrixRecord Returned " + aPIReturnResult.ErrorMessage);
                    return new List<ConfVetDiagnosisMatrixReportRecordDeleteModel>();
                }
                log.Info("VetDiagnosisDeleteMatrixRecord returned");
                return JsonConvert.DeserializeObject<List<ConfVetDiagnosisMatrixReportRecordDeleteModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("VetDiagnosisDeleteMatrixRecord failed", e);
                throw e;
            }
        }




        /// <summary>
        /// Deletes A Sanitary Matrix Record
        /// </summary>
        /// <param name="idfAggrHumanCaseMtx"></param>
        /// <returns></returns>
        public async Task<List<ConfSanitaryMatrixReportRecordDeleteModel>> SanitaryDeleteMatrixRecord(long idfAggrSanitaryActionMTX)
        {
            
            log.Info("SanitaryDeleteMatrixRecord is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
               
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("CONF-SANITARYRECORD-DELETE"))
                {
                    Query = string.Format("idfAggrSanitaryActionMTX={0}", new[] { Convert.ToString(idfAggrSanitaryActionMTX) })
                };

                var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("SanitaryDeleteMatrixRecord Returned " + aPIReturnResult.ErrorMessage);
                    return new List<ConfSanitaryMatrixReportRecordDeleteModel>() { new ConfSanitaryMatrixReportRecordDeleteModel() { ReturnMessage = aPIReturnResult.ErrorMessage } };
                }
                log.Info("SanitaryDeleteMatrixRecord returned");
                return JsonConvert.DeserializeObject<List<ConfSanitaryMatrixReportRecordDeleteModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("SanitaryDeleteMatrixRecord failed", e);
                return new List<ConfSanitaryMatrixReportRecordDeleteModel>() { new ConfSanitaryMatrixReportRecordDeleteModel() { ReturnMessage = e.Message} };
                //throw e;
            }
        }


        /// <summary>
        /// Deletes A Prohylactic Matrix Record
        /// </summary>
        /// <param name="idfAggrHumanCaseMtx"></param>
        /// <returns></returns>
        public async Task<List<ConfProphylacticMatrixReportRecordDeleteModel>> ProphylacticDeleteMatrixRecord(long idfAggrProphylacticActionMTX)
        {
            log.Info("ProphylacticDeleteMatrixRecord is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("CONF-PROPHYLATICRECORD-DELETE"))
                {
                    Query = string.Format("idfAggrProphylacticActionMTX={0}", new[] { Convert.ToString(idfAggrProphylacticActionMTX) })
                };

                var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("ProphylacticDeleteMatrixRecord Returned " + aPIReturnResult.ErrorMessage);
                    return new List<ConfProphylacticMatrixReportRecordDeleteModel>();
                }
                log.Info("ProphylacticDeleteMatrixRecord returned");
                return JsonConvert.DeserializeObject<List<ConfProphylacticMatrixReportRecordDeleteModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("ProphylacticDeleteMatrixRecord failed", e);
                throw e;
            }
        }



        /// <summary>
        /// Returns Prophylactic Measure Types for a given  language, reference type and accessory code.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="referenceTypeName">An EIDSS specific reference type</param>
        /// <param name="accessoryCode"></param>
        /// <returns></returns>
        public async Task<List<ConfGetProphylacticMeasuresGetModel>> GetProphylacticMeasureTypes(string languageId, int accessoryCode, long idfsBaseReference)
        {
            log.Info("GetInvestigationTypes is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("CONF-PROPHYLACTICMEASURETYPES-GET"))
                {
                    // Create query string.
                    Query = string.Format("strLanguageId={0}&idfsBaseReference={1}&intHaCode={2}", new[] { languageId, Convert.ToString(idfsBaseReference), Convert.ToString(accessoryCode) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetInvestigationTypes Returned " + aPIReturnResult.ErrorMessage);
                    return new List<ConfGetProphylacticMeasuresGetModel>();
                }

                log.Info("GetInvestigationTypes returned");
                return JsonConvert.DeserializeObject<List<ConfGetProphylacticMeasuresGetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetInvestigationTypes failed", e);
                throw e;
            }
        }




        /// <summary>
        /// Returns Vet Diagnosis for a given language, reference type and accessory code.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="referenceTypeName">An EIDSS specific reference type</param>
        /// <param name="accessoryCode"></param>
        /// <returns></returns>
        public async Task<List<ConfGetVetDiseaseListGetModel>> GetVetDiagnosisList(string languageId, int accessoryCode, string referenceTypeName)
        {
            log.Info("GetVetDiagnosisList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("CONF-GET-VET-DIAGNOSIS"))
                {
                    // Create query string.
                    Query = string.Format("strLanguageId={0}&idfsBaseReference={1}&intHaCode={2}", new[] { languageId, Convert.ToString(referenceTypeName), Convert.ToString(accessoryCode) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetVetDiagnosisList Returned " + aPIReturnResult.ErrorMessage);
                    return new List<ConfGetVetDiseaseListGetModel>();
                }

                log.Info("GetVetDiagnosisList returned");
                return JsonConvert.DeserializeObject<List<ConfGetVetDiseaseListGetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetVetDiagnosisList failed", e);
                throw e;
            }
        }


      
        /// <summary>
        /// Returns Species List for a given language, reference type and accessory code.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="referenceTypeName">An EIDSS specific reference type</param>
        /// <param name="accessoryCode"></param>
        /// <returns></returns>
        public async Task<List<ConfGetSpeciesListGetModel>> GetSpeciesList(string languageId, int accessoryCode, string referenceTypeName)
        {
            log.Info("GetSpeciesList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("CONF-GET-SPECIES"))
                {
                    // Create query string.
                    Query = string.Format("strLanguageId={0}&idfsBaseReference={1}&intHaCode={2}", new[] { languageId, Convert.ToString(referenceTypeName), Convert.ToString(accessoryCode) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetSpeciesList Returned " + aPIReturnResult.ErrorMessage);
                    return new List<ConfGetSpeciesListGetModel>();
                }

                log.Info("GetSpeciesList returned");
                return JsonConvert.DeserializeObject<List<ConfGetSpeciesListGetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetSpeciesList failed", e);
                throw e;
            }
        }




        /// <summary>
        /// Returns Investigation Types for a given  language, reference type and accessory code.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="referenceTypeName">An EIDSS specific reference type</param>
        /// <param name="accessoryCode"></param>
        /// <returns></returns>
        public async Task<List<ConfGetInvestigationTypesGetModel>> GetInvestigationTypes(string languageId, int accessoryCode, string referenceTypeName)
        {
            log.Info("GetInvestigationTypes is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create the builder.
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("CONF-GET-IVESTIGATION-TYPES"))
                {
                    // Create query string.
                    Query = string.Format("strLanguageId={0}&idfsBaseReference={1}&intHaCode={2}", new[] { languageId, Convert.ToString(referenceTypeName), Convert.ToString(accessoryCode) })
                };

                // Call the service.
                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetInvestigationTypes Returned " + aPIReturnResult.ErrorMessage);
                    return new List<ConfGetInvestigationTypesGetModel>();
                }

                log.Info("GetInvestigationTypes returned");
                return JsonConvert.DeserializeObject<List<ConfGetInvestigationTypesGetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetInvestigationTypes failed", e);
                throw e;
            }
        }
        #endregion
    }

}


