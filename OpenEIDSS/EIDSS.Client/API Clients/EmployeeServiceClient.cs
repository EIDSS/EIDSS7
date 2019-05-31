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
    public class EmployeeServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(EmployeeServiceClient));

        public EmployeeServiceClient() : base()
        {
        }

        /// <summary>
        /// Get Employees
        /// </summary>
        /// <param name="adminEmployeeGetListParams">JSON Model of AdminEmployeeGetListParams</param>
        /// <returns></returns>
        public async Task<List<AdminEmployeeGetlistModel>> GetEmployees(AdminEmployeeGetListParams adminEmployeeGetListParams)
        {
            log.Info("GetEmployees is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(adminEmployeeGetListParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("ADMIN-POST-GETEMPLOYEES"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();
                log.Info("GetEmployees returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminEmployeeGetlistModel>();
                }
                return JsonConvert.DeserializeObject<List<AdminEmployeeGetlistModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetEmployees failed", e);
                throw e;
            }
        }

       /// <summary>
       /// Returns Person Details
       /// </summary>
       /// <param name="personId"></param>
       /// <param name="languageId"></param>
       /// <returns></returns>
        public async Task<List<GblPersonGetDetailModel>> GetGBLPersonDetails(int personId, string languageId)
        {
            log.Info("GetGBLPersonDetails is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-GBLPERSONDETAILS"))
                {
                    Query = string.Format("personId={0}&languageId={1}", new[] { Convert.ToString(personId), Convert.ToString(languageId) })
                };

                var response =  _apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                log.Info("GetGBLPersonDetails returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<GblPersonGetDetailModel>();
                }
                return JsonConvert.DeserializeObject<List<GblPersonGetDetailModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetGBLPersonDetails failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Set Employee
        /// </summary>
        /// <param name="adminSetEmployeeParams">JSON object AdminSetEmployeeParams</param>
        /// <returns></returns>
        public async Task<List<AdminEmpSetModel>> AdminSetEmployee(AdminSetEmployeeParams adminSetEmployeeParams)
        {
            log.Info("AdminSetEmployee is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(adminSetEmployeeParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("ADMIN-POST-SETEMPLOYEE"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();
                log.Info("AdminSetEmployee returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminEmpSetModel>();
                }
                return JsonConvert.DeserializeObject<List<AdminEmpSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("AdminSetEmployee failed", e);
                throw e;
            }
        }

       /// <summary>
       /// Deletes an Employee
       /// </summary>
       /// <param name="personId"></param>
       /// <returns></returns>
        public async Task<List<AdminEmpDelModel>> AdminDeleteEmployee(long personId)
        {
            log.Info("AdminDeleteEmployee is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-DEL-DELETEEMPLOYEE"))
                {
                    Query = string.Format("personId={0}", new[] { Convert.ToString(personId) })
                };

                var response =  _apiclient.DeleteAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                log.Info("AdminDeleteEmployee returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminEmpDelModel>();
                }
                return JsonConvert.DeserializeObject<List<AdminEmpDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("AdminDeleteEmployee failed", e);
                throw e;
            }
        }
    }
}