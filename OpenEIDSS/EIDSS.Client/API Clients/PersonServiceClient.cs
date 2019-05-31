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
    public class PersonServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(HumanServiceClient));

        public PersonServiceClient() : base()
        {
        }

        



        /// <summary>
        /// Deletes A Person
        /// </summary>
        /// <param name="parameters">A collection of search parameters</param>
        /// <returns></returns>
        public async Task<List<GblPersonDeleteModel>> DeletePerson(long idfPerson)
        {
            log.Info("DeletePerson is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("GLOBAL-DEL-PERSON"))
                {
                    Query = string.Format("idfPerson={0}", new[] { Convert.ToString(idfPerson) })
                };

                var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<GblPersonDeleteModel>();
                }

                log.Info("DeletePerson returned");
                return JsonConvert.DeserializeObject<List<GblPersonDeleteModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("DeletePerson failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Update HumanMasterID for a list of Disease reports
        /// </summary>
        /// <param name="SurvivorHumanMasterID">Survivor's human master id</param>
        /// <param name="SupersededHumanMasterID">Superseded's human master id</param>
        /// <returns></returns>
        public async Task<List<AdminDeduplicationPersonidHumanDiseaseSetModel>> DedupePersonIdHumanDiseaseAsync( PersonDedupeSetParams parms)
        {
            log.Info("DedupePersonIdHumanDiseaseAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parms using our formatter! Beautiful!
                var content = CreateRequestContent(parms);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("DD-PERSONID-HUMANDISEASE"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });

                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminDeduplicationPersonidHumanDiseaseSetModel>();
                }
                log.Info("DedupePersonIdHumanDiseaseAsync returned");
                return JsonConvert.DeserializeObject<List<AdminDeduplicationPersonidHumanDiseaseSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("DedupePersonIdHumanDiseaseAsync failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Update HumanMasterID for a list of Farms
        /// </summary>
        /// <param name="SurvivorHumanMasterID">Survivor's human master id</param>
        /// <param name="SupersededHumanMasterID">Superseded's human master id</param>
        /// <returns></returns>
        public async Task<List<AdminDeduplicationPersonidFarmSetModel>> DedupePersonIdFarmAsync( PersonDedupeSetParams parms)
        {
            log.Info("DedupePersonIdFarmAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create the content object. This will serialize the parms using our formatter! Beautiful!
                var content = CreateRequestContent(parms);

                var response = await _apiclient.PostAsync(Settings.GetResourceValue("DD-PERSONID-FARM"), content).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });

                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminDeduplicationPersonidFarmSetModel>();
                }
                log.Info("DedupePersonIdFarmAsync returned");
                return JsonConvert.DeserializeObject<List<AdminDeduplicationPersonidFarmSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("DedupePersonIdFarmAsync failed", e);
                throw e;
            }
        }


    }
}

