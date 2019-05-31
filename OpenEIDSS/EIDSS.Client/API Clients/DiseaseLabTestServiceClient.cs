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
    public class DiseaseLabTestServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(DiseaseLabTestServiceClient));

        public DiseaseLabTestServiceClient() : base()
        {

        }

        public async Task<List<ConfDiseaselabtestmatrixGetlistModel>> GetConfDiseaselabtestmatrices(string languageId)
        {
            log.Info("GetConfDiseaselabtestmatrices is called");
            APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
            try
            {
                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-GET-DISEASELABTEST"));

                builder.Query = string.Format("languageId={0}", Convert.ToString(languageId));

                var response = await this._apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetConfDiseaseLabTestMatrices error");
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfDiseaselabtestmatrixGetlistModel>();
                }
                log.Info("GetConfDiseaseLabTestMatrices returned");
                return JsonConvert.DeserializeObject<List<ConfDiseaselabtestmatrixGetlistModel>>(aPIReturnResult.data);
            }
            catch (Exception ex)
            {
                log.Error("GetConfDiseaselabtestmatrices error", ex);
                throw;
            }
        }

        public async Task<List<ConfDiseaselabtestmatrixSetModel>> SetConfDiseaseLabTestMatrix(ConfDiseaselabtestmatrixSetParams diseaselabtestmatrixSetParams)
        {
            log.Info("SetConfDiseaseLabTestMatrix is called");
            APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(diseaselabtestmatrixSetParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-SET-DISEASELABTEST"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("SetConfDiseaseLabTestMatrix error");
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfDiseaselabtestmatrixSetModel>();
                }
                log.Info("SetConfDiseaseLabTestMatrix returned");
                return JsonConvert.DeserializeObject<List<ConfDiseaselabtestmatrixSetModel>>(aPIReturnResult.data);
            }
            catch (Exception ex)
            {
                log.Error("SetConfDiseaseLabTestMatrix error", ex);
                throw;
            }
        }

        public async Task<List<ConfDiseaselabtestmatrixDelModel>> DelConfDiseaseLabTestMatrix(long idfTestForDisease, bool deleteAnyway)
        {
            log.Info("DelConfDiseaseLabTestMatrix is called");
            APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
            try
            {
                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-DEL-DISEASELABTEST"));

                builder.Query = string.Format("idfTestForDisease={0}&deleteAnyway={1}", new[] { Convert.ToString(idfTestForDisease), Convert.ToString(deleteAnyway) });

                var response = await this._apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("DelConfDiseaseLabTestMatrix error");
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfDiseaselabtestmatrixDelModel>();
                }
                log.Info("DelConfDiseaseLabTestMatrix returned");
                return JsonConvert.DeserializeObject<List<ConfDiseaselabtestmatrixDelModel>>(aPIReturnResult.data);
            }
            catch (Exception ex)
            {
                log.Error("DelConfDiseaseLabTestMatrix error", ex);
                throw;
            }
        }

    }
}
