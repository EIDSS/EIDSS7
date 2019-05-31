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
    public class SpeciesTypeClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(AgeGroupServiceClient));

        public SpeciesTypeClient() : base()
        { }

        public async Task<List<RefSpeciestypeGetListModel>> RefSpeciesTypeGetList(string languageId)
        {
            log.Info("RefSpeciesTypeGetList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-REF-SPECIESTYPELIST"))
                {
                    Query = string.Format("languageId={0}", new[] { Convert.ToString(languageId) })
                };

                var response = _apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                log.Info("RefSpeciesTypeGetList returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefSpeciestypeGetListModel>();
                }
                return JsonConvert.DeserializeObject<List<RefSpeciestypeGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("RefSpeciesTypeGetList", e);
                throw e;
            }
        }

        public async Task<List<RefSpeciestypeSetModel>> RefSpeciesTypeSet(RefSpeciesTypeReferenceSetParams adminReferenceSpeciesTypeSetParams)
        {
            log.Info("RefSpeciesTypeSet is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                //Serialize the request parameters
                var content = CreateRequestContent(adminReferenceSpeciesTypeSetParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("ADMIN-POST-REF-SPECIESTYPESET"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();
                log.Info("RefSpeciesTypeSet returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefSpeciestypeSetModel>();
                }
                return JsonConvert.DeserializeObject<List<RefSpeciestypeSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("RefSpeciesTypeSet failed", e);
                throw e;
            }
        }

        public async Task<List<RefSpeciestypeDelModel>> RefSpeciesTypeDel(long idfsSpeciesType, bool deleteAnyway)
        {
            log.Info("RefSpeciesTypeDel is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-DEL-REF-SPECIESTYPE"))
                {
                    Query = string.Format("idfsSpeciesType={0}&deleteAnyway={1}", new[] { Convert.ToString(idfsSpeciesType), Convert.ToString(deleteAnyway) })
                };

                var response = _apiclient.DeleteAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                log.Info("RefSpeciesTypeDel returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefSpeciestypeDelModel>();
                }
                return JsonConvert.DeserializeObject<List<RefSpeciestypeDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("RefSpeciesTypeDel failed", e);
                throw e;
            }
        }
    }
}
