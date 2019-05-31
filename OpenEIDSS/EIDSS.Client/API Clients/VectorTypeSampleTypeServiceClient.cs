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
	public class VectorTypeSampleTypeServiceClient : APIClientBase
	{
		static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(VectorTypeSampleTypeServiceClient));

		public VectorTypeSampleTypeServiceClient() : base()
		{

		}

		public async Task<List<ConfVectortypesampletypematrixGetlistModel>> GetConfVectorTypeSampleTypeMatrices(string languageId, long idfsVectorType)
		{
			log.Info("GetConfVectorTypeSampleTypeMatrices is called");
			APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
			try
			{
				// Create a uri and set the query string parms...
				UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-GET-VECTORTYPESAMPLETYPE"));

				builder.Query = string.Format("languageId={0}&idfsVectorType={1}", new[] { Convert.ToString(languageId), Convert.ToString(idfsVectorType) });

				var response = await this._apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Info("GetConfVectorTypeSampleTypeMatrices error");
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfVectortypesampletypematrixGetlistModel>();
				}
				log.Info("GetConfVectorTypeSampleTypeMatrices returned");
				return JsonConvert.DeserializeObject<List<ConfVectortypesampletypematrixGetlistModel>>(aPIReturnResult.data);
			}
			catch (Exception ex)
			{
				log.Error("GetConfVectorTypeSampleTypeMatrices error", ex);
				throw;
			}
		}

		public async Task<List<ConfVectortypesampletypematrixSetModel>> SetConfVectorTypeSampleTypeMatrix(ConfVectortypesampletypematrixSetParams diseaseGroupDiseaseMatrixSetParams)
		{
			log.Info("SetConfVectorTypeSampleTypeMatrix is called");
			APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
			try
			{
				//Serialize the request parameters
				var content = CreateRequestContent(diseaseGroupDiseaseMatrixSetParams);

				// Call the service.
				var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-SET-VECTORTYPESAMPLETYPE"), content).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfVectortypesampletypematrixSetModel>();
				}
				log.Info("SetConfVectorTypeSampleTypeMatrix returned");
				return JsonConvert.DeserializeObject<List<ConfVectortypesampletypematrixSetModel>>(aPIReturnResult.data);
			}
			catch (Exception ex)
			{
				log.Error("SetConfVectorTypeSampleTypeMatrix error", ex);
				throw;
			}
		}

		public async Task<List<ConfVectortypesampletypematrixDelModel>> DelConfVectorTypeSampleTypematrix(long idfSampleTypeForVectorType, bool deleteAnyWay)
		{
			log.Info("DelConfVectorTypeSampleTypematrix is called");
			APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();

			try
			{
				// Create a uri and set the query string parms...
				UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-DEL-VECTORTYPESAMPLETYPE"));

				builder.Query = string.Format("idfSampleTypeForVectorType={0}&deleteAnyWay={1}", new[] { Convert.ToString(idfSampleTypeForVectorType), Convert.ToString(deleteAnyWay) });

				var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfVectortypesampletypematrixDelModel>();
				}
				log.Info("DelConfVectorTypeSampleTypematrix returned");
				return JsonConvert.DeserializeObject<List<ConfVectortypesampletypematrixDelModel>>(aPIReturnResult.data);
			}
			catch (Exception e)
			{
				log.Error("DelConfVectorTypeSampleTypematrix failed", e);
				throw e;
			}
		}
	}
}
