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
	public class DiseaseAgeGroupServiceMatrixClient : APIClientBase
	{
		static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(DiseaseAgeGroupServiceMatrixClient));

		public DiseaseAgeGroupServiceMatrixClient() : base()
		{

		}

		/// <summary>
		/// Returns a list of Disease to Penside Test Matrices
		/// </summary>
		/// <param name="languageId">unique language</param>
		/// <returns></returns>
		public async Task<List<ConfDiseaseagegroupmatrixGetlistModel>> GetConfDiseaseAgeGroupMatrixList(string languageId, long idfsDiagnosis)
		{
			log.Info("GetConfDiseaseAgeGroupMatrixList is called");
			APIReturnResult aPIReturnResult = new APIReturnResult();
			try
			{
				// Create a uri and set the query string parms...
				UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-GET-DISEASEAGEGROUP"));

				builder.Query = string.Format("languageId={0}&idfsDiagnosis={1}", new[] { Convert.ToString(languageId), Convert.ToString(idfsDiagnosis) });

				var response = await this._apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfDiseaseagegroupmatrixGetlistModel>();
				}
				log.Info("GetConfDiseaseAgeGroupMatrixList returned");
				return JsonConvert.DeserializeObject<List<ConfDiseaseagegroupmatrixGetlistModel>>(aPIReturnResult.Results);
			}
			catch (Exception ex)
			{
				log.Error("GetConfDiseaseAgeGroupMatrixList error", ex);
				throw;
			}
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="idfDiagnosisAgeGroupforDiagnosis"></param>
		/// <returns></returns>
		public async Task<List<ConfDiseaseagegroupmatrixDelModel>> DelConfDiseaseAgeGroupMatrix(long idfDiagnosisAgeGroupToDiagnosis)
		{
			log.Info("DelConfDiseaseAgeGroupMatrix is called");
			APIReturnResult aPIReturnResult = new APIReturnResult();
			try
			{
				// Create a uri and set the query string parms...
				UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-DEL-DISEASEAGEGROUP"));

				builder.Query = string.Format("idfDiagnosisAgeGroupToDiagnosis={0}", Convert.ToString(idfDiagnosisAgeGroupToDiagnosis));

				var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfDiseaseagegroupmatrixDelModel>();
				}
				log.Info("DelConfDiseaseAgeGroupMatrixList returned");
				return JsonConvert.DeserializeObject<List<ConfDiseaseagegroupmatrixDelModel>>(aPIReturnResult.Results);
			}
			catch (Exception ex)
			{
				log.Error("DelConfDiseaseAgeGroupMatrix error", ex);
				throw;
			}
		}

		public async Task<List<ConfDiseaseagegroupmatrixSetModel>> SetConfDiseaseAgeGroupMatrix(ConfDiseaseagegroupmatrixSetParams confDiseaseAgeGroupParams)
		{
			log.Info("ConfDiseaseAgeGroupMatrixSet is called");
			APIReturnResult aPIReturnResult = new APIReturnResult();
			try
			{

				//Serialize the request parameters
				var content = CreateRequestContent(confDiseaseAgeGroupParams);

				// Call the service.
				var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-SET-DISEASEAGEGROUP"), content).ConfigureAwait(false);

				response.EnsureSuccessStatusCode();
				log.Info("ConfDiseaseAgeGroupMatrixSet returned");
				aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfDiseaseagegroupmatrixSetModel>();
				}
				log.Info("ConfDiseaseAgeGroupMatrixSet returned");
				return JsonConvert.DeserializeObject<List<ConfDiseaseagegroupmatrixSetModel>>(aPIReturnResult.Results);
			}
			catch (Exception e)
			{
				log.Error("ConfDiseaseAgeGroupMatrixSet failed", e);
				throw e;
			}

		}
	}
}
