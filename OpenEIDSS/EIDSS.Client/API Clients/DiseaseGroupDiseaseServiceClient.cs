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
	public class DiseaseGroupDiseaseServiceClient : APIClientBase
	{
		static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(DiseaseGroupDiseaseServiceClient));

		public DiseaseGroupDiseaseServiceClient() : base()
		{

		}

		public async Task<List<ConfDiseasegroupdiseasematrixGetlistModel>> ConfDiseasegroupdiseasematrixGetlist(string languageId, long idfsDiagnosisgroup)
		{
			log.Info("ConfDiseasegroupdiseasematrixGetlist is called");
			APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
			try
			{
				// Create a uri and set the query string parms...
				UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-GET-DISEASEGROUPDISEASE"));

				builder.Query = string.Format("languageId={0}&idfsDiagnosisgroup={1}", new[] { Convert.ToString(languageId), Convert.ToString(idfsDiagnosisgroup) });

				var response = await this._apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfDiseasegroupdiseasematrixGetlistModel>();
				}
				log.Info("ConfDiseasegroupdiseasematrixGetlist returned");
				return JsonConvert.DeserializeObject<List<ConfDiseasegroupdiseasematrixGetlistModel>>(aPIReturnResult.data);
			}
			catch (Exception ex)
			{
				log.Error("ConfDiseasegroupdiseasematrixGetlist error", ex);
				throw;
			}
		}

		public async Task<List<ConfDiseasegroupdiseasematrixSetModel>> ConfDiseasegroupdiseasematrixSet(DiseaseGroupDiseaseMatrixSetParams diseaseGroupDiseaseMatrixSetParams)
		{
			log.Info("ConfDiseasegroupdiseasematrixSet is called");
			APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
			try
			{
				//Serialize the request parameters
				var content = CreateRequestContent(diseaseGroupDiseaseMatrixSetParams);

				// Call the service.
				var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-SET-DISEASEGROUPDISEASE"), content).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfDiseasegroupdiseasematrixSetModel>();
				}
				log.Info("ConfDiseasegroupdiseasematrixSet returned");
				return JsonConvert.DeserializeObject<List<ConfDiseasegroupdiseasematrixSetModel>>(aPIReturnResult.data);
			}
			catch (Exception ex)
			{
				log.Error("ConfDiseasegroupdiseasematrixSet error", ex);
				throw;
			}
		}


		public async Task<List<ConfDiseasegroupdiseasematrixDelModel>> ConfDiseasegroupdiseasematrixDel(long idfDiagnosisAgeGroupToDiagnosis, bool deleteAnyWay)
		{
			log.Info("ConfDiseasegroupdiseasematrixDel is called");
			APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();

			try
			{
				// Create a uri and set the query string parms...
				UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-DEL-DISEASEGROUPDISEASE"));

				builder.Query = string.Format("idfDiagnosisAgeGroupToDiagnosis={0}&deleteAnyWay={1}", new[] { Convert.ToString(idfDiagnosisAgeGroupToDiagnosis), Convert.ToString(deleteAnyWay) });

				var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfDiseasegroupdiseasematrixDelModel>();
				}
				log.Info("ConfDiseasegroupdiseasematrixDel returned");
				return JsonConvert.DeserializeObject<List<ConfDiseasegroupdiseasematrixDelModel>>(aPIReturnResult.data);
			}
			catch (Exception e)
			{
				log.Error("ConfDiseasegroupdiseasematrixDel failed", e);
				throw e;
			}
		}
	}
}
