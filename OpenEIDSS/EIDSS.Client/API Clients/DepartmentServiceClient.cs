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
    public class DepartmentServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(DepartmentServiceClient));

        public DepartmentServiceClient() : base()
        {
        }


       
 
        public async Task< List<DepartmentGetLookupModel>> GetDepartment(string languageId, long? organizationId, long? id)
        {
            log.Info("GetDepartment is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-GETDEPARTMENT"))
                {
                    Query = string.Format("languageId={0}", new[] { Convert.ToString(languageId) })
                };

                var response =  _apiclient.GetAsync(builder.Uri).Result;
                response.EnsureSuccessStatusCode();
                log.Info("GetDepartment returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<DepartmentGetLookupModel>();
                }
                return JsonConvert.DeserializeObject<List<DepartmentGetLookupModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetDepartment failed", e);
                throw e;
            }
        }

      
        public async Task<int> SetDepartment(DepartmentSetParams departmentSetParams)
        {
            log.Info("SetDepartment is called");
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(departmentSetParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("ADMIN-POST-SETDEPARTMENT"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();
                log.Info("SetDepartment returned");

                return await response.Content.ReadAsAsync<int>(new List<MediaTypeFormatter> { Formatter });
            }
            catch (Exception e)
            {
                log.Error("SetDepartment failed", e);
                throw e;
            }
        }


      
        public async Task<int> DeleteDepartment(long id)
        {
            log.Info("DeleteDepartment is called");
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-DEL-DELETEDEPARTMENT"))
                {
                    Query = string.Format("id={0}", new[] { Convert.ToString(id) })
                };

                var response =  _apiclient.DeleteAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                log.Info("DeleteDepartment returned");

                return await response.Content.ReadAsAsync<int>(new List<MediaTypeFormatter> { Formatter });
            }
            catch (Exception e)
            {
                log.Error("DeleteDepartment failed", e);
                throw e;
            }
        }
    }
}
