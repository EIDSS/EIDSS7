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
	public class AgeGroupStatisticalAgeGroupServiceClient : APIClientBase
	{
		static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(AgeGroupStatisticalAgeGroupServiceClient));

		public AgeGroupStatisticalAgeGroupServiceClient() : base()
		{

		}

		public async Task<List<ConfAgegroupstatisticalagegroupmatrixGetlistModel>> GetConfAgegroupstatisticalagegroupmatrices(string languageId, long idfsDiagnosisAgeGroup)
		{
			log.Info("GetConfAgegroupstatisticalagegroupmatrices is called");
			APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
			try
			{
				// Create a uri and set the query string parms...
				UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-GET-AGEGROUPSTATISTICALAGEGROUP"));

				builder.Query = string.Format("languageId={0}&idfsDiagnosisAgeGroup={1}", new[] { Convert.ToString(languageId), Convert.ToString(idfsDiagnosisAgeGroup) });

				var response = await this._apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error("GetConfVectorTypeFieldTestMatrices error");
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfAgegroupstatisticalagegroupmatrixGetlistModel>();
				}
				log.Info("GetConfVectorTypeFieldTestMatrices returned");
				return JsonConvert.DeserializeObject<List<ConfAgegroupstatisticalagegroupmatrixGetlistModel>>(aPIReturnResult.data);
			}
			catch (Exception ex)
			{
				log.Error("GetConfAgegroupstatisticalagegroupmatrices error", ex);
				throw;
			}
		}

		public async Task<List<ConfAgegroupstatisticalagegroupmatrixSetModel>> SetConfAgegroupstatisticalagegroupmatrix(ConfAgegroupstatisticalagegroupmatrixSetParams agegroupstatisticalagegroupmatrixSetParams)
		{
			log.Info("SetConfAgegroupstatisticalagegroupmatrix is called");
			APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
			try
			{
				//Serialize the request parameters
				var content = CreateRequestContent(agegroupstatisticalagegroupmatrixSetParams);

				// Call the service.
				var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-SET-AGEGROUPSTATISTICALAGEGROUP"), content).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error("SetConfAgegroupstatisticalagegroupmatrix error");
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfAgegroupstatisticalagegroupmatrixSetModel>();
				}
				log.Info("SetConfAgegroupstatisticalagegroupmatrix returned");
				return JsonConvert.DeserializeObject<List<ConfAgegroupstatisticalagegroupmatrixSetModel>>(aPIReturnResult.data);
			}
			catch (Exception ex)
			{
				log.Error("SetConfAgegroupstatisticalagegroupmatrix error", ex);
				throw;
			}
		}

		public async Task<List<ConfAgegroupstatisticalagegroupmatrixDelModel>> DelConfAgegroupstatisticalagegroupmatrix(long idfDiagnosisAgeGroupToStatisticalAgeGroup, bool deleteAnyway)
		{
			log.Info("DelConfAgegroupstatisticalagegroupmatrix is called");
			APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
			try
			{
				// Create a uri and set the query string parms...
				UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-DEL-AGEGROUPSTATISTICALAGEGROUP"));

				builder.Query = string.Format("idfDiagnosisAgeGroupToStatisticalAgeGroup={0}&deleteAnyway={1}", new[] { Convert.ToString(idfDiagnosisAgeGroupToStatisticalAgeGroup), Convert.ToString(deleteAnyway) });

				var response = await this._apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error("DelConfAgegroupstatisticalagegroupmatrix error");
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfAgegroupstatisticalagegroupmatrixDelModel>();
				}
				log.Info("DelConfAgegroupstatisticalagegroupmatrix returned");
				return JsonConvert.DeserializeObject<List<ConfAgegroupstatisticalagegroupmatrixDelModel>>(aPIReturnResult.data);
			}
			catch (Exception ex)
			{
				log.Error("DelConfAgegroupstatisticalagegroupmatrix error", ex);
				throw;
			}
		}
	}
}
