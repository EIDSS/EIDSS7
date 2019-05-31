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
    public class DiseasePensideTestMatrixServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(DiseasePensideTestMatrixServiceClient));

        public DiseasePensideTestMatrixServiceClient() : base()
        {

        }

        /// <summary>
        /// Returns a list of Disease to Penside Test Matrices
        /// </summary>
        /// <param name="languageId">unique language</param>
        /// <returns></returns>
        public async Task<List<ConfDiseasepensidetestmatrixGetListModel>> GetConfDiseasePensideTestMatrixList(string languageId)
        {
            log.Info("GetConfDiseasePensideTestMatrixList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-GET-DISEASEPENSIDETEST"));

                builder.Query = string.Format("languageId={0}", Convert.ToString(languageId));

                var response = await this._apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfDiseasepensidetestmatrixGetListModel>();
                }
                log.Info("GetConfDiseasePensideTestMatrixList returned");
                return JsonConvert.DeserializeObject<List<ConfDiseasepensidetestmatrixGetListModel>>(aPIReturnResult.Results);
            } 
            catch (Exception ex)
            {
                log.Error("GetConfDiseasePensideTestMatrixList error", ex);
                throw;
            }
        }

		/// <summary>
		/// 
		/// </summary>
		/// <param name="idfPensideTestforDisease"></param>
		/// <returns></returns>
        public async Task<List<ConfDiseasepensidetestmatrixDelModel>> DelConfDiseasePensideTestMatrix(long idfPensideTestforDisease)
        {
            log.Info("DelConfDiseasePensideTestMatrix is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-DEL-DISEASEPENSIDETEST"));

                builder.Query = string.Format("idfPensideTestforDisease={0}", Convert.ToString(idfPensideTestforDisease));

                var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfDiseasepensidetestmatrixDelModel>();
                }
                log.Info("DelConfDiseasePensideTestMatrixList returned");
                return JsonConvert.DeserializeObject<List<ConfDiseasepensidetestmatrixDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("DelConfDiseasePensideTestMatrix error", ex);
                throw;
            }
        }

        public async Task<List<ConfDiseasepensidetestmatrixSetModel>> SetConfDiseasePensideTestMatrix(ConfDiseasePendisideSetParams confDiseasePensideTestParams)
        {
            log.Info("ConfDiseasePensideTestMatrixSet is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                //Serialize the request parameters
                var content = CreateRequestContent(confDiseasePensideTestParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-SET-DISEASEPENSIDETEST"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();
                log.Info("ConfDiseasePensideTestMatrixSet returned");
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<ConfDiseasepensidetestmatrixSetModel>();
                }
                log.Info("ConfDiseasePensideTestMatrixSet returned");
                return JsonConvert.DeserializeObject<List<ConfDiseasepensidetestmatrixSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("ConfDiseasePensideTestMatrixSet failed", e);
                throw e;
            }

        }
    }
}
