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
	public class ReportDiseaseGroupDiseaseServiceClient : APIClientBase
	{
		static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(ReportDiseaseGroupDiseaseServiceClient));

		public ReportDiseaseGroupDiseaseServiceClient() : base()
		{

		}

		public async Task<List<ConfReportdiseasegroupdiseasematrixGetlistModel>> GetConfReportdiseasegroupdiseaseList(string langId, long idfsCustomReportType, long idfsReportDiagnosisGroup)
		{
			log.Info("GetConfReportdiseasegroupdiseaseList is called");
			APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
			try
			{
				// Create a uri and set the query string parms...
				UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-GET-REPORTDISEASEGROUPDISEASE"));

				builder.Query = string.Format("langId={0}&idfsCustomReportType={1}&idfsReportDiagnosisGroup={2}", new[] { Convert.ToString(langId), Convert.ToString(idfsCustomReportType), Convert.ToString(idfsReportDiagnosisGroup) });

				var response = await this._apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfReportdiseasegroupdiseasematrixGetlistModel>();
				}
				log.Info("GetConfReportdiseasegroupdiseaseList returned");
				return JsonConvert.DeserializeObject<List<ConfReportdiseasegroupdiseasematrixGetlistModel>>(aPIReturnResult.data);
			}
			catch (Exception ex)
			{
				log.Error("GetConfReportdiseasegroupdiseaseList error", ex);
				throw ex;
			}
		}

		public async Task<List<ConfReportdiseasegroupdiseasematrixDelModel>> DelConfReportdiseasegroupdisease(long idfDiagnosisToGroupForReportType, bool deleteAnyway)
		{
			log.Info("DelConfReportdiseasegroupdisease is called");
			APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
			try
			{
				// Create a uri and set the query string parms...
				UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CONF-DEL-REPORTDISEASEGROUPDISEASE"));

				builder.Query = string.Format("idfDiagnosisToGroupForReportType={0}&deleteAnyway={1}", new[] { Convert.ToString(idfDiagnosisToGroupForReportType), Convert.ToString(deleteAnyway) });

				var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);
				response.EnsureSuccessStatusCode();
				aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter });
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfReportdiseasegroupdiseasematrixDelModel>();
				}
				log.Info("DelConfReportdiseasegroupdisease returned");
				return JsonConvert.DeserializeObject<List<ConfReportdiseasegroupdiseasematrixDelModel>>(aPIReturnResult.data);
			}
			catch (Exception ex)
			{
				log.Error("DelConfReportdiseasegroupdisease error", ex);
				throw;
			}
		}

		public async Task<List<ConfReportdiseasegroupdiseasematrixSetModel>> SetConfReportdiseasegroupdisease(ConfReportdiseasegroupdiseasematrixSetParams reportdiseasegroupdiseaseParams)
		{
			log.Info("SetConfReportdiseasegroupdisease is called");
			APIReturnResultDataTables aPIReturnResult = new APIReturnResultDataTables();
			try
			{
				//Serialize the request parameters
				var content = CreateRequestContent(reportdiseasegroupdiseaseParams);

				// Call the service.
				var response = await _apiclient.PostAsync(Settings.GetResourceValue("CONF-SET-REPORTDISEASEGROUPDISEASE"), content).ConfigureAwait(false);

				response.EnsureSuccessStatusCode();
				log.Info("SetConfReportdiseasegroupdisease returned");
				aPIReturnResult = response.Content.ReadAsAsync<APIReturnResultDataTables>(new List<MediaTypeFormatter> { Formatter }).Result;
				if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
				{
					log.Error(aPIReturnResult.ErrorMessage);
					return new List<ConfReportdiseasegroupdiseasematrixSetModel>();
				}
				log.Info("SetConfReportdiseasegroupdisease returned");
				return JsonConvert.DeserializeObject<List<ConfReportdiseasegroupdiseasematrixSetModel>>(aPIReturnResult.data);
			}
			catch (Exception e)
			{
				log.Error("SetConfReportdiseasegroupdisease failed", e);
				throw e;
			}
		}
	}
}