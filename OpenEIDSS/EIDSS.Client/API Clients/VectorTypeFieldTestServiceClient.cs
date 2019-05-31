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
	public class VectorTypeFieldTestServiceClient : APIClientBase
	{
		static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(VectorTypeFieldTestServiceClient));

		public VectorTypeFieldTestServiceClient() : base()
		{

		}

		public async Task<List<ConfVectortypefieldtestmatrixGetlistModel>> GetConfVectorTypeFieldTestMatrices(string languageId, long idfsVectorType)
		{
			log.Info("GetConfVectorTypeFieldTestMatrices is called");
			APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
			try
			{
				// Create a uri and set the query string parms...
				UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-GET-VECTORTYPEFIELDTEST"));

				builder.Query = string.Format("languageId={0}&idfsVectorType={1}", new[] { Convert.ToString(languageId), Convert.ToString(idfsVectorType) });

				var response = await this._apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Info("GetConfVectorTypeFieldTestMatrices error");
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfVectortypefieldtestmatrixGetlistModel>();
				}
				log.Info("GetConfVectorTypeFieldTestMatrices returned");
				return JsonConvert.DeserializeObject<List<ConfVectortypefieldtestmatrixGetlistModel>>(aPIReturnResult.data);
			}
			catch (Exception ex)
			{
				log.Error("GetConfVectorTypeFieldTestMatrices error", ex);
				throw;
			}
		}

		public async Task<List<ConfVectortypefieldtestmatrixSetModel>> SetConfVectorTypeFieldTestMatrix(ConfVectortypefieldtestmatrixSetParams vectortypefieldtestmatrixSetParams)
		{
			log.Info("SetConfVectorTypeFieldTestMatrix is called");
			APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
			try
			{
				//Serialize the request parameters
				var content = CreateRequestContent(vectortypefieldtestmatrixSetParams);

				// Call the service.
				var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-SET-VECTORTYPEFIELDTEST"), content).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfVectortypefieldtestmatrixSetModel>();
				}
				log.Info("SetConfVectorTypeFieldTestMatrix returned");
				return JsonConvert.DeserializeObject<List<ConfVectortypefieldtestmatrixSetModel>>(aPIReturnResult.data);
			}
			catch (Exception ex)
			{
				log.Error("SetConfVectorTypeFieldTestMatrix error", ex);
				throw;
			}
		}

		public async Task<List<ConfVectortypefieldtestmatrixDelModel>> DelConfVectorTypeFieldTestMatrix(long idfPensideTestTypeForVectorType, bool deleteAnyWay)
		{
			log.Info("DelConfVectorTypeFieldTestMatrix is called");
			APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();

			try
			{
				// Create a uri and set the query string parms...
				UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-DEL-VECTORTYPEFIELDTEST"));

				builder.Query = string.Format("idfPensideTestTypeForVectorType={0}&deleteAnyWay={1}", new[] { Convert.ToString(idfPensideTestTypeForVectorType), Convert.ToString(deleteAnyWay) });

				var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfVectortypefieldtestmatrixDelModel>();
				}
				log.Info("DelConfVectorTypeFieldTestMatrix returned");
				return JsonConvert.DeserializeObject<List<ConfVectortypefieldtestmatrixDelModel>>(aPIReturnResult.data);
			}
			catch (Exception e)
			{
				log.Error("DelConfVectorTypeFieldTestMatrix failed", e);
				throw e;
			}
		}
	}
}
