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
	public class CustomReportRowsServiceClient : APIClientBase
	{
		static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(CustomReportRowsServiceClient));

		public CustomReportRowsServiceClient() : base()
		{

		}

		public async Task<List<ConfCustomreportGetlistModel>> GetConfCustomreportsList(string languageId, long idfsCustomReportType)
		{
			log.Info("GetConfCustomreportsList is called");
			APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
			try
			{
				// Create a uri and set the query string parms...
				UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-GET-CUSTOMREPORTS"));

				builder.Query = string.Format("languageId={0}&idfsCustomReportType={1}", new[] { Convert.ToString(languageId), Convert.ToString(idfsCustomReportType) });

				var response = await this._apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfCustomreportGetlistModel>();
				}
				log.Info("GetConfCustomreportsList returned");
				return JsonConvert.DeserializeObject<List<ConfCustomreportGetlistModel>>(aPIReturnResult.data);
			}
			catch (Exception ex)
			{
				log.Error("GetConfCustomreportsList error", ex);
				throw ex;
			}
		}

		public async Task<List<ConfCustomreportDelModel>> DelConfCustomreport(long idfReportRows, bool deleteAnyway)
		{
			log.Info("DelConfCustomreport is called");
			APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
			try
			{
				// Create a uri and set the query string parms...
				UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-DEL-CUSTOMREPORTS"));

				builder.Query = string.Format("ifdfreportRows={0}&deleteAnyway={1}", new[] { Convert.ToString(idfReportRows), Convert.ToString(deleteAnyway) });

				var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfCustomreportDelModel>();
				}
				log.Info("DelConfCustomreportList returned");
				return JsonConvert.DeserializeObject<List<ConfCustomreportDelModel>>(aPIReturnResult.data);
			}
			catch (Exception ex)
			{
				log.Error("DelConfCustomreport error", ex);
				throw;
			}
		}

		public async Task<List<ConfCustomreportSetModel>> SetConfCustomreport(CustomReportSetParams customReportSetParams)
		{
			log.Info("SetConfCustomreport is called");
			APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
			try
			{
				//Serialize the request parameters
				var content = CreateRequestContent(customReportSetParams);

				// Call the service.
				var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-SET-CUSTOMREPORTS"), content).ConfigureAwait(false);

				response.EnsureSuccessStatusCode();
				log.Info("SetConfCustomreport returned");
				aPIReturnResult = response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter }).Result;
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfCustomreportSetModel>();
				}
				log.Info("SetConfCustomreport returned");
				return JsonConvert.DeserializeObject<List<ConfCustomreportSetModel>>(aPIReturnResult.data);
			}
			catch (Exception e)
			{
				log.Error("SetConfCustomreport failed", e);
				throw e;
			}

		}
	}
}
