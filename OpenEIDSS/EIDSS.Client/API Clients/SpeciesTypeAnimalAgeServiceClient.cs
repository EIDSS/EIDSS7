using EIDSS.Client.Abstracts;
using Newtonsoft.Json;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Domain.Return_Contracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Text;
using System.Threading.Tasks;

namespace EIDSS.Client.API_Clients
{
    public class SpeciesTypeAnimalAgeServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(SpeciesTypeAnimalAgeServiceClient));

        public SpeciesTypeAnimalAgeServiceClient() :base()
        {

        }

        public async Task<List<ConfSpeciestypeanimalagematrixGetlistModel>> GetConfSpeciestypeanimalagematrices(string languageId)
        {
            log.Info("GetConfSpeciestypeanimalagematrices is called");
            APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
            try
            {
                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-GET-SPECIESTYPEANIMALAGE"));

                builder.Query = string.Format("languageId={0}", Convert.ToString(languageId));

                var response = await this._apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetConfSpeciesTypeAnimalAgeMatrices error");
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfSpeciestypeanimalagematrixGetlistModel>();
                }
                log.Info("GetConfSpeciesTypeAnimalAgeMatrices returned");
                return JsonConvert.DeserializeObject<List<ConfSpeciestypeanimalagematrixGetlistModel>>(aPIReturnResult.data);
            }
            catch (Exception ex)
            {
                log.Error("GetConfSpeciestypeanimalagematrices error", ex);
                throw;
            }
        }

        public async Task<List<ConfSpeciestypeanimalagematrixSetModel>> SetConfSpeciesTypeAnimalAgeMatrix(ConfSpeciestypeanimalagematrixSetParams speciestypeanimalagematrixSetParams)
        {
            log.Info("SetConfSpeciesTypeAnimalAgeMatrix is called");
            APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(speciestypeanimalagematrixSetParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-SET-SPECIESTYPEANIMALAGE"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("SetConfSpeciesTypeAnimalAgeMatrix error");
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfSpeciestypeanimalagematrixSetModel>();
                }
                log.Info("SetConfSpeciesTypeAnimalAgeMatrix returned");
                return JsonConvert.DeserializeObject<List<ConfSpeciestypeanimalagematrixSetModel>>(aPIReturnResult.data);
            }
            catch (Exception ex)
            {
                log.Error("SetConfSpeciesTypeAnimalAgeMatrix error", ex);
                throw;
            }
        }

        public async Task<List<ConfSpeciestypeanimalagematrixDelModel>> DelConfSpeciesTypeAnimalAgeMatrix(long idfSpeciesTypeToAnimalAge, bool deleteAnyway)
        {
            log.Info("DelConfSpeciesTypeAnimalAgeMatrix is called");
            APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
            try
            {
                //Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-DEL-SPECIESTYPEANIMALAGE"));

                builder.Query = string.Format("idfSpeciesTypeToAnimalAge={0}&deleteAnyway={1}", new[] { Convert.ToString(idfSpeciesTypeToAnimalAge), Convert.ToString(deleteAnyway) });

                var response = await this._apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("DelConfSpeciesTypeAnimalAgeMatrix error");
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfSpeciestypeanimalagematrixDelModel>();
                }
                log.Info("DelConfSpeciesTypeAnimalAgeMatrix returned");
                return JsonConvert.DeserializeObject<List<ConfSpeciestypeanimalagematrixDelModel>>(aPIReturnResult.data);
            }
            catch (Exception ex)
            {
                log.Error("DelConfSpeciesTypeAnimalAgeMatrix error", ex);
                throw;
            }
        }
    }
}
