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
    public class SampleTypeDerivativeServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(SampleTypeDerivativeServiceClient));

        public SampleTypeDerivativeServiceClient() : base()
        {

        }

        public async Task<List<ConfSampletypederivativematrixGetlistModel>> GetConfSampleTypeDerivativeMatrices(string languageId)
        {
            log.Info("GetConfSampleTypeDerivativeMatrices is called");
            APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
            try
            {
                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-GET-SAMPLETYPEDERIVATIVE"));

                builder.Query = string.Format("languageId={0}", Convert.ToString(languageId));

                var response = await this._apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("GetConfSampleTypeDerivativeMatrices error");
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfSampletypederivativematrixGetlistModel>();
                }
                log.Info("GetConfSampleTypeDerivativeMatrices returned");
                return JsonConvert.DeserializeObject<List<ConfSampletypederivativematrixGetlistModel>>(aPIReturnResult.data);
            }
            catch (Exception ex)
            {
                log.Error("GetConfSampletypederivativematrices error", ex);
                throw;
            }
        }

        public async Task<List<ConfSampletypederivativematrixSetModel>> SetConfSampleTypeDerivativeMatrix(ConfSampleTypDerivativeSetParams confSampleTypDerivativeSetParams)
        {
            log.Info("SetConfSampleTypeDerivativeMatrix is called");
            APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(confSampleTypDerivativeSetParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-SET-SAMPLETYPEDERIVATIVE"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("SetConfSampleTypeDerivativeMatrix error");
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfSampletypederivativematrixSetModel>();
                }
                log.Info("SetConfSampleTypeDerivativeMatrix returned");
                return JsonConvert.DeserializeObject<List<ConfSampletypederivativematrixSetModel>>(aPIReturnResult.data);
            }
            catch (Exception ex)
            {
                log.Error("SetConfSampleTypeDerivativeMatrix error", ex);
                throw;
            }
        }

        public async Task<List<ConfSampletypederivativematrixDelModel>> DelConfSampleTypeDerivativeMatrix(long idfDerivativeForSampleType, bool deleteAnyway)
        {
            log.Info("DelConfSampleTypeDerivativeMatrix is called");
            APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
            try
            {
                //Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-DEL-SAMPLETYPEDERIVATIVE"));

                builder.Query = string.Format("idfDerivativeForSampleType={0}&deleteAnyway={1}", new[] { Convert.ToString(idfDerivativeForSampleType), Convert.ToString(deleteAnyway) });

                var response = await this._apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error("DelConfSampleTypeDerivativeMatrix error");
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfSampletypederivativematrixDelModel>();
                }
                log.Info("DelConfSampleTypeDerivativeMatrix returned");
                return JsonConvert.DeserializeObject<List<ConfSampletypederivativematrixDelModel>>(aPIReturnResult.data);
            }
            catch (Exception ex)
            {
                log.Error("DelConfSampleTypeDerivativeMatrix error", ex);
                throw;
            }
        }
    }
}
