using EIDSS.Client.Abstracts;
using Newtonsoft.Json;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Return_Contracts;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Threading.Tasks;

namespace EIDSS.Client.API_Clients
{
    /// <summary>
    /// Client service that contains Dashboard Functionality
    public class DashBoardServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(DashBoardServiceClient));

        /// <summary>
        /// Creates a new instance of this class.
        /// </summary>
        public DashBoardServiceClient() : base()
        {
        }

        #region Links

        /// <summary>
        /// Retrieves an Async List of Dashboard Links 
        /// </summary>
        /// <param name="languageId">Lanugage ID </param>
        /// <param name="personId">Person Id</param>
        /// <param name="dashboardItemType">Dashboard Item Type</param>
        /// <returns> List OF DasDashboardGetListModel </returns>
        public async Task<List<DasDashboardGetListModel>> GetDashBoardLinks(string languageId, long personId, string dashboardItemType)
        {
            log.Info("GetDashBoardLinksAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("DAS-GETDASHBOARD-LINKS"));

                builder.Query = string.Format("languageId={0}&personId={1}&dashboardItemType={2}", Convert.ToString(languageId), Convert.ToString(personId), Convert.ToString(dashboardItemType));

                // call the service...
                var response = await this._apiclient.GetAsync(builder.Uri).ConfigureAwait(false);
                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<DasDashboardGetListModel>();
                }

                log.Info("GetDashBoardLinksAsync returned");
                return JsonConvert.DeserializeObject<List<DasDashboardGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("GetDashBoardLinksAsync failed", e);
                throw e;
            }
        }

        #endregion

        #region Users
        
        /// <summary>
        /// Get an asynchromous list of users for the EIDSS applications
        /// </summary>
        /// <param name="languageId">identifier of the language for the application</param>
        /// <returns>A list of users</returns>
        public async Task<List<DasUsersGetListModel>> GetDashboardUsersList(string languageId, int paginationSet)
        {
            log.Info("GetDashboardUsersListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                log.Info("GetDashboardUsersList is called");

                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("DAS-GETDASHBOARD-USERS"));

                builder.Query = string.Format("languageId={0}&paginationSet={1}", new[] { Convert.ToString(languageId), Convert.ToString(paginationSet)});

                var response = this._apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<DasUsersGetListModel>();
                }

                log.Info("GetDashboardUsersListAsync returned");
                return JsonConvert.DeserializeObject<List<DasUsersGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("Error calling GetDashboardUsersList : " + ex.Message);
                throw ex;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public async Task<List<DasUsersGetCountModel>> GetDashboardUsersCount()
        {
            log.Info("GetDashboardUsersCount is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                log.Info("GetDashboardUsersCount is called");

                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("DAS-GETDASHBOARD-USERS-COUNT"));

                var response = this._apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<DasUsersGetCountModel>();
                }

                log.Info("GetDashboardUsersCount returned");
                return JsonConvert.DeserializeObject<List<DasUsersGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("Error calling GetDashboardCount : " + ex.Message);
                throw ex;
            }
        }

        #endregion

        #region Notifications

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<DasNotificationsGetListModel>> GetDashboardNotificationsList(string languageId, int paginationSet)
        {
            log.Info("GetDashboardNotificationsListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                log.Info("GetDashboardNotificationsList is called");

                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("DAS-GETDASHBOARD-NOTIFICATIONS"));

                builder.Query = string.Format("languageId={0}&paginationSet={1}", new[] { Convert.ToString(languageId), Convert.ToString(paginationSet)});

                var response = this._apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<DasNotificationsGetListModel>();
                }

                log.Info("GetDashboardNotificationsListAsync returned");
                return JsonConvert.DeserializeObject<List<DasNotificationsGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("Error calling GetDashboardNotificationsList : " + ex.Message);
                throw ex;
            }
        }

        public async Task<List<DasNotificationsGetcountModel>> GetDasNotificationsCount()
        {
            log.Info("GetDasNotificationsCount is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("DAS-GETDASHBOARD-NOTIFICATIONS-COUNT"));

                var response = this._apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<DasNotificationsGetcountModel>();
                }

                log.Info("GetDashboardMyNotificationsListAsync returned");
                return JsonConvert.DeserializeObject<List<DasNotificationsGetcountModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("Error calling GetDasMynotificationsCount : " + ex.Message);
                throw ex;
            }
        }

        #endregion

        #region My Notifications

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfsPerson"></param>
        /// <returns></returns>
        public async Task<List<DasMynotificationsGetListModel>> GetDashboardMyNotificationsList(string languageId, long idfsPerson, int paginationSet)
        {
            log.Info("GetDashboardMyNotificationsListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                log.Info("GetDashboardMyNotificationsList is called");

                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("DAS-GETDASHBOARD-NOTIFICATIONS"));

                builder.Query = string.Format("languageId={0}&idfsPerson{1}&idfsPerson={1}&paginationSet={1}", new[] { Convert.ToString(languageId), Convert.ToString(idfsPerson), Convert.ToString(paginationSet) });

                var response = this._apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<DasMynotificationsGetListModel>();
                }

                log.Info("GetDashboardMyNotificationsListAsync returned");
                return JsonConvert.DeserializeObject<List<DasMynotificationsGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("Error calling GetDashboardNotificationsList : " + ex.Message);
                throw ex;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="idfsPerson"></param>
        /// <returns></returns>
        public async Task<List<DasMynotificationsGetcountModel>> GetDasMynotificationsCount(long idfsPerson)
        {
            log.Info("GetDasMynotificationsCount is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("DAS-GETDASHBOARD-MYNOTIFICATIONS-COUNT")) {
                    Query = string.Format("idfsPerson={0}", Convert.ToString(idfsPerson))
                };

                var response = this._apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<DasMynotificationsGetcountModel>();
                }

                log.Info("GetDashboardMyNotificationsListAsync returned");
                return JsonConvert.DeserializeObject<List<DasMynotificationsGetcountModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("Error calling GetDasMynotificationsCount : " + ex.Message);
                throw ex;
            }
        }

        #endregion

        #region Investigations

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<DasInvestigationsGetListModel>> GetDashboardInvestigationsList(string languageId, int paginationSet)
        {
            log.Info("GetDashboardInvestigationsListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                log.Info("GetDashboardInvestigationsList is called");

                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("DAS-GETDASHBOARD-INVESTIGATIONS"));

                builder.Query = string.Format("languageId={0}&paginationSet={1}", new[] { Convert.ToString(languageId), Convert.ToString(paginationSet) });

                var response = this._apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<DasInvestigationsGetListModel>();
                }

                log.Info("GetDashboardInvestigationsListAsync returned");
                return JsonConvert.DeserializeObject<List<DasInvestigationsGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("Error calling GetDashboardInvestigationsList : " + ex.Message);
                throw ex;
            }
        }
        
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public async Task<List<DasInvestigationsGetcountModel>> GetDashboardInvestigationsCount()
        {

            try
            {
                log.Info("GetDashboardInvestigationsCount is called");
                APIReturnResult aPIReturnResult = new APIReturnResult();

                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("DAS-GETDASHBOARD-INVESTIGATIONS-COUNT"));
                
                var response = this._apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<DasInvestigationsGetcountModel>();
                }

                log.Info("GetDashboardInvestigationsCount returned");
                return JsonConvert.DeserializeObject<List<DasInvestigationsGetcountModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("Error calling GetDashboardInvestigationsCount : " + ex.Message);
                throw ex;
            }
        }

        #endregion

        #region My Investigations

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfsPerson"></param>
        /// <param name="paginationSet"></param>
        /// <returns></returns>
        public async Task<List<DasMyinvestigationsGetListModel>> GetDashboardMyInvestigationsList(string languageId, long idfPerson, int paginationSet)
        {
            log.Info("GetDashboardMyInvestigationsList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("DAS-GETDASHBOARD-MYINVESTIGATIONS"));

                builder.Query = string.Format("languageId={0}&idfPerson={1}&paginationSet={2}", new[] { Convert.ToString(languageId), Convert.ToString(idfPerson), Convert.ToString(paginationSet) });

                var response = this._apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<DasMyinvestigationsGetListModel>();
                }

                log.Info("GetDashboardMyInvestigationsList returned");
                return JsonConvert.DeserializeObject<List<DasMyinvestigationsGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("Error calling GetDashboardMyInvestigationsList : " + ex.Message);
                throw ex;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="idfsPerson"></param>
        /// <returns></returns>
        public async Task<List<DasMyinvestigationsGetcountModel>> GetDashboardMyInvestigationCount(long idfsPerson)
        {
            try
            { 
            log.Info("GetDashboardMyInvestigationsList is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("DAS-GETDASHBOARD-MYINVESTIGATIONS-COUNT"));

                builder.Query = string.Format("idfPerson={0}", Convert.ToString(idfsPerson));

                var response = this._apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<DasMyinvestigationsGetcountModel>();
                }

                log.Info("GetDashboardMyInvestigationsList returned");
                return JsonConvert.DeserializeObject<List<DasMyinvestigationsGetcountModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("Error calling GetDashboardMyInvestigationsList : " + ex.Message);
                throw ex;
            }
        }
 
        #endregion

        #region My Approvals

        /// <summary>
        /// Get a list of approvals for users in the lab chief role.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public List<DasApprovalsGetListModel> GetDashboardMyApprovalsList(string languageID, long siteID)
        {
            try
            {
                log.Info("GetDashboardMyApprovalsList is called");

                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("DAS-GETDASHBOARD-MY-APPROVALS"));

                builder.Query = string.Format("languageID={0}&siteID={1}", Convert.ToString(languageID), Convert.ToString(siteID));

                var response = _apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                log.Info("GetDashboardMyApprovalsList returned");

                return response.Content.ReadAsAsync<List<DasApprovalsGetListModel>>(new List<MediaTypeFormatter> { Formatter }).Result;
            }
            catch (Exception ex)
            {
                log.Error("Error calling GetDashboardMyApprovalsList : " + ex.Message);
                throw ex;
            }
        }

        /// <summary>
        /// Get a list of approvals for users in the lab chief role.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public async Task<List<DasApprovalsGetListModel>> GetDashboardMyApprovalsListAsync(string languageID, long siteID)
        {
            log.Info("GetDashboardMyApprovalsListAsync is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();

            try
            {
                log.Info("GetDashboardMyApprovalsListAsync is called");

                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("DAS-GETDASHBOARD-MY-APPROVALS"));

                builder.Query = string.Format("languageID={0}&siteID={1}", Convert.ToString(languageID), Convert.ToString(siteID));

                var response = _apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<DasApprovalsGetListModel>();
                }

                log.Info("GetDashboardMyApprovalsListAsync returned");
                return JsonConvert.DeserializeObject<List<DasApprovalsGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("Error calling GetDashboardMyApprovalsListAsync: " + ex.Message);
                throw ex;
            }
        }

        #endregion

        #region Unaccessioned Samples

        /// <summary>
        /// Gets a list of unaccessioned samples for the dashboard grid view available to laboratory technicians.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="organizationID"></param>
        /// <param name="siteID"></param>
        /// <param name="paginationSet"></param>
        /// <returns></returns>
        public List<DasUnaccessionedsamplesGetListModel> GetDashboardUnaccessionedSamplesList(string languageID, long? organizationID, long? siteID, int paginationSet)
        {
            try
            {
                log.Info("GetDashboardUnaccessionedSamplesList is called");

                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("DAS-GETDASHBOARD-UNACCESSIONED-SAMPLES"));

                builder.Query = string.Format("languageID={0}&amp;organizationID={1}&amp;siteID={2}&amp;paginationSet={3}", Convert.ToString(languageID), Convert.ToString(organizationID), Convert.ToString(siteID), Convert.ToString(paginationSet));

                var response = _apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                log.Info("GetDashboardUnaccessionedSamplesList returned");

                return response.Content.ReadAsAsync<List<DasUnaccessionedsamplesGetListModel>>(new List<MediaTypeFormatter> { Formatter }).Result;
            }
            catch (Exception ex)
            {
                log.Error("Error calling GetDashboardUnaccessionedSamplesList : " + ex.Message);
                throw ex;
            }
        }

        /// <summary>
        /// Gets a count of unaccessioned samples for the dashboard grid view available to laboratory technicians.  Used to support pagination.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="organizationID"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public async Task<List<DasUnaccessionedSampleGetCountModel>> GetDashboardUnaccessionedSamplesListCountAsync(string languageID, long? organizationID, long? siteID)
        {
            try
            {
                log.Info("GetDashboardUnaccessionedSamplesListCountAsync is called");
                APIReturnResult aPIReturnResult = new APIReturnResult();

                log.Info("GetDashboardUnaccessionedSamplesListCountAsync is called");

                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("DAS-GETDASHBOARD-UNACCESSIONED-SAMPLES-COUNT"));

                builder.Query = string.Format("languageID={0}&organizationID={1}&siteID={2}", Convert.ToString(languageID), Convert.ToString(organizationID), Convert.ToString(siteID));

                var response = _apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<DasUnaccessionedSampleGetCountModel>();
                }

                log.Info("GetDashboardUnaccessionedSamplesListCountAsync returned");
                return JsonConvert.DeserializeObject<List<DasUnaccessionedSampleGetCountModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("Error calling GetDashboardUnaccessionedSamplesListCountAsync : " + ex.Message);
                throw ex;
            }
        }

        /// <summary>
        /// Gets a list of unaccessioned samples for the dashboard grid view available to laboratory technicians.
        /// </summary>
        /// <param name="languageID"></param>
        /// <param name="organizationID"></param>
        /// <param name="siteID"></param>
        /// <param name="paginationSet"></param>
        /// <returns></returns>
        public async Task<List<DasUnaccessionedsamplesGetListModel>> GetDashboardUnaccessionedSamplesListAsync(string languageID, long? organizationID, long? siteID, int paginationSet)
        {
            try
            {
                log.Info("GetDashboardUnaccessionedSamplesListAsync is called");
                APIReturnResult aPIReturnResult = new APIReturnResult();

                log.Info("GetDashboardUnaccessionedSamplesListAsync is called");

                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("DAS-GETDASHBOARD-UNACCESSIONED-SAMPLES"));

                builder.Query = string.Format("languageID={0}&organizationID={1}&siteID={2}&paginationSet={3}", Convert.ToString(languageID), Convert.ToString(organizationID), Convert.ToString(siteID), Convert.ToString(paginationSet));

                var response = _apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<DasUnaccessionedsamplesGetListModel>();
                }

                log.Info("GetDashboardUnaccessionedSamplesListAsync returned");
                return JsonConvert.DeserializeObject<List<DasUnaccessionedsamplesGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("Error calling GetDashboardUnaccessionedSamplesListAsync : " + ex.Message);
                throw ex;
            }
        }

        #endregion

        #region Collections

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="idfPerson"></param>
        /// <returns></returns>
        public async Task<List<DasMycollectionsGetListModel>> GetDashboardCollectionsList(string languageId, long idfPerson, int paginationSet)
        {
            try
            {
                log.Info("GetDashboardCollectionsListAsync is called");
                APIReturnResult aPIReturnResult = new APIReturnResult();

                log.Info("GetDashboardCollectionsList is called");

                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("DAS-GET-GETMYCOLLECTIONS"));

                builder.Query = string.Format("languageId={0}&idfPerson={1}&paginationSet={2}", new[] { Convert.ToString(languageId), Convert.ToString(idfPerson), Convert.ToString(paginationSet) });

                var response = this._apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<DasMycollectionsGetListModel>();
                }

                log.Info("GetDashboardCollectionsListAsync returned");
                return JsonConvert.DeserializeObject<List<DasMycollectionsGetListModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("Error calling GetDashboardCollectionsList : " + ex.Message);
                throw ex;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="idfPerson"></param>
        /// <returns></returns>
        public async Task<List<DasMycollectionsGetcountModel>> GetDashboardCollectionsCount(string languageId, long idfPerson)
        {
            try
            {
                log.Info("GetDashboardCollectionsCount is called");
                APIReturnResult aPIReturnResult = new APIReturnResult();

                log.Info("GetDashboardCollectionsCount is called");

                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("DAS-GET-GETMYCOLLECTIONS-COUNT"));

                builder.Query = string.Format("languageId={0}&idfPerson={1}", new[] { languageId, Convert.ToString(idfPerson) });

                var response = this._apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<DasMycollectionsGetcountModel>();
                }

                log.Info("GetDashboardCollectionsCount returned");
                return JsonConvert.DeserializeObject<List<DasMycollectionsGetcountModel>>(aPIReturnResult.Results);
            }
            catch (Exception ex)
            {
                log.Error("Error calling GetDashboardCollectionsCount : " + ex.Message);
                throw ex;
            }
        }

        #endregion
    }
}