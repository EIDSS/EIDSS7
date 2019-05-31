using EIDSS.Client.Abstracts;
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
    public class OrganizationServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(OrganizationServiceClient));

        public OrganizationServiceClient() : base()
        {
        }


        /// <summary>
        /// Returns Organization List
        /// </summary>
        /// <param name="adminOrgGetListParams">JSON OBJECT AdminOrgGetListParams</param>
        /// <returns></returns>
        public async Task<List<AdminOrgGetListModel>> AdminGetOrgList(AdminOrgGetListParams adminOrgGetListParams)
        {
            log.Info("AdminGetOrgList is called");
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(adminOrgGetListParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("ADMIN-POST-GETORGLIST"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();
                log.Info("AdminGetOrgList returned");

                return await response.Content.ReadAsAsync<List<AdminOrgGetListModel>>(new List<MediaTypeFormatter> { Formatter });
            }
            catch (Exception e)
            {
                log.Error("AdminGetOrgList failed", e);
                throw e;
            }
        }

       
        /// <summary>
        /// Return Organization Details
        /// </summary>
        /// <param name="officeId"></param>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<AdminOrgGetDetailModel>> AdminGetOrgDetail(long officeId, string languageId)
        {
            log.Info("AdminGetOrgDetail is called");
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-GET-ORGGETDETAIL"))
                {
                    Query = string.Format("officeId={0}&languageId={1}", new[] { Convert.ToString(officeId), Convert.ToString(languageId) })
                };

                var response = await _apiclient.GetAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                log.Info("AdminGetOrgDetail returned");

                return await response.Content.ReadAsAsync<List<AdminOrgGetDetailModel>>(new List<MediaTypeFormatter> { Formatter });
            }
            catch (Exception e)
            {
                log.Error("AdminGetOrgDetail failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Set Organization
        /// </summary>
        /// <param name="adminOrganizationSetParams"></param>
        /// <returns></returns>
        public async Task<int> AdminOrgSet(AdminOrganizationSetParams adminOrganizationSetParams)
        {
            log.Info("AdminOrgSet is called");
            try
            {
                //Serialize the request parameters
                var content = CreateRequestContent(adminOrganizationSetParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("ADMIN-POST-SETORG"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();
                log.Info("AdminOrgSet returned");

                return await response.Content.ReadAsAsync<int>(new List<MediaTypeFormatter> { Formatter });
            }
            catch (Exception e)
            {
                log.Error("AdminOrgSet failed", e);
                throw e;
            }
        }

    
        /// <summary>
        /// Delete Organization
        /// </summary>
        /// <param name="idfOffice"></param>
        /// <returns></returns>
        public async Task<int> AdminDeleteOrganization(long idfOffice)
        {
            log.Info("AdminDeleteOrganization is called");
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-DEL-DELETEORG"))
                {
                    Query = string.Format("idfOffice={0}", new[] { Convert.ToString(idfOffice) })
                };

                var response = await _apiclient.DeleteAsync(builder.Uri).ConfigureAwait(false);

                // Throw an exception if the call didn't succeed.
                response.EnsureSuccessStatusCode();

                log.Info("AdminDeleteOrganization returned");

                return await response.Content.ReadAsAsync<int>(new List<MediaTypeFormatter> { Formatter });
            }
            catch (Exception e)
            {
                log.Error("AdminDeleteOrganization failed", e);
                throw e;
            }
        }
    }

}
