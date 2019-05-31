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
    public class DiseaseSampleTypeServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(DiseaseSampleTypeServiceClient));

        public DiseaseSampleTypeServiceClient() : base()
        {

        }

        public async Task<List<ConfDiseasesampletypematrixGetlistModel>> GetConfDiseasesampletypematrices(string languageId)
        {
            log.Info("GetConfDiseasesampletypematrices is called");
            APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
            try
            {
                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-GET-DISEASESAMPLETYPE"));

                builder.Query = string.Format("languageId={0}", Convert.ToString(languageId));

                var response = await this._apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetConfDiseaseSampleTypeMatrices error");
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfDiseasesampletypematrixGetlistModel>();
                }
                log.Info("GetConfDiseaseSampleTypeMatrices returned");
                return JsonConvert.DeserializeObject<List<ConfDiseasesampletypematrixGetlistModel>>(aPIReturnResult.data);
            }
            catch (Exception ex)
            {
                log.Error("GetConfDiseasesampletypematrices error", ex);
                throw;
            }
        }

        public async Task<List<ConfDiseasesampletypematrixSetModel>> SetConfDiseasesampletypematrix(ConfDiseasesampletypematrixSetParams diseasesampletypematrixSetParams)
        {
            log.Info("SetConfDiseaseSampleTypeMatrix is called");
            APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(diseasesampletypematrixSetParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-SET-DISEASESAMPLETYPE"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("SetConfDiseaseSampleTypeMatrix error");
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfDiseasesampletypematrixSetModel>();
                }
                log.Info("SetConfDiseaseSampleTypeMatrix returned");
                return JsonConvert.DeserializeObject<List<ConfDiseasesampletypematrixSetModel>>(aPIReturnResult.data);
            }
            catch (Exception ex)
            {
                log.Error("SetConfDiseaseSampleTypeMatrix error", ex);
                throw;
            }
        }

        public async Task<List<ConfDiseasesampletypematrixDelModel>> DelConfDiseaseSampleTypeMatrix(long idfMaterialForDisease, bool deleteAnyway)
        {
            log.Info("DelConfDiseaseSampleTypeMatrix is called");
            APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
            try
            {
                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-DEL-DISEASESAMPLETYPE"));

                builder.Query = string.Format("idfMaterialForDisease={0}&deleteAnyway={1}", new[] { Convert.ToString(idfMaterialForDisease), Convert.ToString(deleteAnyway) });

                var response = await this._apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("DelConfDiseaseSampleTypeMatrix error");
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfDiseasesampletypematrixDelModel>();
                }
                log.Info("DelConfDiseaseSampleTypeMatrix returned");
                return JsonConvert.DeserializeObject<List<ConfDiseasesampletypematrixDelModel>>(aPIReturnResult.data);
            }
            catch (Exception ex)
            {
                log.Error("DelConfDiseaseSampleTypeMatrix error", ex);
                throw;
            }
        }
    }
}
