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
	public class VectorTypeCollectionMethodMatrixServiceClient : APIClientBase
	{

		static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(VectorTypeCollectionMethodMatrixServiceClient));

		public VectorTypeCollectionMethodMatrixServiceClient() : base()
		{

		}

		public async Task<List<ConfVectortypecollectionmethodmatrixGetlistModel>> GetConfVectorTypeCollectionMethodMatrices(string languageId, long idfsVectorType)
		{
			log.Info("GetConfVectorTypeCollectionMethodMatrices is called");
			APIReturnResult aPIReturnResult = new APIReturnResult();
			try
			{
				// Create a uri and set the query string parms...
				UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("CONF-GET-VECTORTYPECOLLECTIONMETHOD"))
				{
					Query = string.Format("languageId={0}&idfsVectorType={1}", new[] { Convert.ToString(languageId), Convert.ToString(idfsVectorType) })
				};

				var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();

				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfVectortypecollectionmethodmatrixGetlistModel>();
				}

				log.Info("RefVectorSubTypeGetList returned");
				return JsonConvert.DeserializeObject<List<ConfVectortypecollectionmethodmatrixGetlistModel>>(aPIReturnResult.Results);
			}
			catch (Exception ex)
			{
				log.Error("GetConfVectorTypeCollectionMethodMatrices error:", ex);
				throw ex;
			}
		}
		
		public async Task<List<ConfVectortypecollectionmethodmatrixSetModel>> SetConfVectorTypeCollectionMethodMatrix(VectorTyeCollectionMatrixSetParams vectorTypeCollectionMethodSetParams)
		{
			log.Info("SetConfVectorTypeCollectionMethodMatrix begins");
			APIReturnResult aPIReturnResult = new APIReturnResult();

			try
			{
				//Serialize the request parameters
				var content = CreateRequestContent(vectorTypeCollectionMethodSetParams);

				var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-SET-VECTORTYPECOLLECTIONMETHOD"), content).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();

				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfVectortypecollectionmethodmatrixSetModel>();
				}

				log.Info("SetConfVectorTypeCollectionMethodMatrix returned");
				return JsonConvert.DeserializeObject<List<ConfVectortypecollectionmethodmatrixSetModel>>(aPIReturnResult.Results);
			}
			catch (Exception ex)
			{
				log.Error("SetConfVectorTypeCollectionMethodMatrix failed", ex);
				throw ex;
			}
		}

		public async Task<List<ConfVectortypecollectionmethodmatrixDelModel>> DelConfVectorTypeCollectionMethodMatrix(long idfCollectionMethodForVectorType)
		{
			log.Info("DelConfVectorTypeCollectionMethodMatrix begins");
			APIReturnResult aPIReturnResult = new APIReturnResult();

			try
			{
				UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("CONF-DEL-VECTORTYPECOLLECTIONMETHOD"))
				{
					Query = string.Format("idfCollectionMethodForVectorType={0}", Convert.ToString(idfCollectionMethodForVectorType))
				};

				var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();

				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfVectortypecollectionmethodmatrixDelModel>();
				}

				log.Info("DelConfVectorTypeCollectionMethodMatrix returned");
				return JsonConvert.DeserializeObject<List<ConfVectortypecollectionmethodmatrixDelModel>>(aPIReturnResult.Results);
			}
			catch (Exception ex)
			{
				log.Error("DelConfVectorTypeCollectionMethodMatrix failed", ex);
				throw ex;
			}
		}
	}
}
