using EIDSS.Client.Abstracts;
using Newtonsoft.Json;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Domain.Return_Contracts;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Threading.Tasks;

namespace EIDSS.Client.API_Clients
{
    public class ReportDiagnosisGroupServiceClient : APIClientBase
    {

        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(ReportDiagnosisGroupServiceClient));

        public ReportDiagnosisGroupServiceClient() : base()
        { }

        public async Task<List<RefReportDiagnosisGroupGetListModel>> RefReportDiagnosisGroupGetList(string languageId)
        {
            log.Info("RefReportDiagnosisGroupGetList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-REF-REPORTDIAGNOSISGROUPLIST"))
                {
                    Query = string.Format("languageId={0}", new[] { Convert.ToString(languageId) })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefReportDiagnosisGroupGetListModel>();
                }

                log.Info("RefReportDiagnosisGroupGetList returned");
                return JsonConvert.DeserializeObject<List<RefReportDiagnosisGroupGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("RefReportDiagnosisGroupGetList failed", e);
                throw e;
            }
        }

        public async Task<List<RefReportdiagnosisgroupDelModel>> RefReportDiagnosisGroupDel(long idfsReportDiagnosisGroup, bool deleteAnyway)
        {
            log.Info("RefReportDiagnosisGroupDel is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-DEL-REF-REPORTDIAGNOSISGROUPGROUP"))
                {
                    Query = string.Format("idfsReportDiagnosisGroup={0}&deleteAnyway={1}", new[] { Convert.ToString(idfsReportDiagnosisGroup), Convert.ToString(deleteAnyway) })
                };

                var response = _apiclient.DeleteAsync(builder.Uri).Result;
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefReportdiagnosisgroupDelModel>();
                }
                log.Info("RefReportDiagnosisGroupDel returned");

                return JsonConvert.DeserializeObject<List<RefReportdiagnosisgroupDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("RefReportDiagnosisGroupDel failed", e);
                throw e;
            }
        }

        public async Task<List<RefReportdiagnosisgroupSetModel>> RefReportDiagnosisGroupSet(RefReporDiagnosisTypeSetParams adminRefReportDiagnosisGroupSetParams)
        {
            log.Info("RefReportDiagnosisGroupSet is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {

                //Serialize the request parameters
                var content = CreateRequestContent(adminRefReportDiagnosisGroupSetParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("ADMIN-POST-REF-REPORTDIAGNOSISGROUPSET"), content).ConfigureAwait(false);
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefReportdiagnosisgroupSetModel>();
                }
                log.Info("RefReportDiagnosisGroupSet returned");

                return JsonConvert.DeserializeObject<List<RefReportdiagnosisgroupSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("RefReportDiagnosisGroupSet failed", e);
                throw e;
            }
        }
    }
}
