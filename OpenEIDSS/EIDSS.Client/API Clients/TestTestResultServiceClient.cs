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
	public class TestTestResultServiceClient : APIClientBase
	{
		static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(TestTestResultServiceClient));

		public TestTestResultServiceClient() : base()
		{

		}

		public async Task<List<ConfTesttotestresultmatrixGetlistModel>> GetConfTesttotestresultmatrices(string languageId, long idfsTestResolution, long idfsTestName)
		{
			log.Info("GetConfTesttotestresultmatricesAsync is called");
			APIReturnResult aPIReturnResult = new APIReturnResult();
			try
			{
				// Create a uri and set the query string parms...
				UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-GET-TESTTESTRESULT"));

				builder.Query = string.Format("languageId={0}&idfsTestResolution={1}&idfsTestName={2}", new[] { Convert.ToString(languageId), Convert.ToString(idfsTestResolution),  Convert.ToString(idfsTestName) });

				var response = await this._apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfTesttotestresultmatrixGetlistModel>();
				}
				log.Info("GetConfTesttotestresultmatricesAsync returned");
				return JsonConvert.DeserializeObject<List<ConfTesttotestresultmatrixGetlistModel>>(aPIReturnResult.Results);
			}
			catch (Exception ex)
			{
				log.Error("GetConfTesttotestresultmatricesAsync error", ex);
				throw;
			}
		}

		public async Task<List<ConfTesttotestresultmatrixSetModel>> SetConfTesttoTestResultMatrix(ConfTesttotestresultmatrixSetParams confTesttoTestResultMatrixSetParams)
		{
			log.Info("SetConfTesttoTestResultMatrix is called");
			APIReturnResult aPIReturnResult = new APIReturnResult();
			try
			{

				//Serialize the request parameters
				var content = CreateRequestContent(confTesttoTestResultMatrixSetParams);

				// Call the service.
				var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-SET-TESTTESTRESULT"), content).ConfigureAwait(false);

				response.EnsureSuccessStatusCode();
				aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfTesttotestresultmatrixSetModel>();
				}
				log.Info("SetConfTesttoTestResultMatrix returned");
				return JsonConvert.DeserializeObject<List<ConfTesttotestresultmatrixSetModel>>(aPIReturnResult.Results);
			}
			catch (Exception e)
			{
				log.Error("SetConfTesttoTestResultMatrix failed", e);
				throw e;
			}
		}

		public async Task<List<ConfTesttotestresultmatrixDelModel>> DelConfTesttoTestResultMatrix(long idfsTestResultRelation, long idfsTestName, long idfsTestResult, bool deleteAnyway)
		{
			log.Info("DelConfTesttoTestResultMatrix is called");
			APIReturnResult aPIReturnResult = new APIReturnResult();

			try
			{
				// Create a uri and set the query string parms...
				UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-DEL-TESTTESTRESULT"));

				builder.Query = string.Format("idfsTestResultRelation={0}&idfsTestName={1}&idfsTestResult={2}&deleteAnyway={3}", new[] { Convert.ToString(idfsTestResultRelation), Convert.ToString(idfsTestName), Convert.ToString(idfsTestResult), Convert.ToString(deleteAnyway) });

				var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfTesttotestresultmatrixDelModel>();
				}
				log.Info("DelConfDiseaseAgeGroupMatrixList returned");
				return JsonConvert.DeserializeObject<List<ConfTesttotestresultmatrixDelModel>>(aPIReturnResult.Results);
			}
			catch (Exception e)
			{
				log.Error("DelConfTesttoTestResultMatrix failed", e);
				throw e;
			}
		}
	}
}
