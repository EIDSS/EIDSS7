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
    public class ReferenceServiceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(ReferenceServiceClient));

        public ReferenceServiceClient() : base()
        {
        }

        /// <summary>
        /// Get Age Group Reference List
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns></returns>
        public async Task<List<RefAgegroupGetListModel>> GetAgeGroupList(string languageId)
        {
            log.Info("GetAgeGroupList is called");

            try
            {
                var content = CreateRequestContent(languageId);

                // call the service...
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("AgeGroupGetList"), content).ConfigureAwait(false);

                // throw an exception if the call didn't succeed...
                response.EnsureSuccessStatusCode();

                log.Info("GetAgeGroupList returned");

                // read the response into the required container using the required formatter.
                return await response.Content.ReadAsAsync<List<RefAgegroupGetListModel>>(new List<MediaTypeFormatter> { Formatter });
            }
            catch (Exception e)
            {
                log.Error("GetAgeGroupList failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Can Delete Age Group
        /// </summary>
        /// <param name="ageGroupTypeId">The system internal identifier for the age group type</param>
        /// <returns></returns>
        public RefAgegroupCandelModel CanDeleteAgeGroup(long ageGroupTypeId)
        {
            log.Info("CanDeleteAgeGroup is called");

            try
            {
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("CanDeleteAgeGroup"));

                builder.Query = string.Format("ageGroupTypeId={0}", Convert.ToString(ageGroupTypeId));

                var response = this._apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                log.Info("CanDeleteAgeGroup returned");

                return response.Content.ReadAsAsync<RefAgegroupCandelModel>(new List<MediaTypeFormatter> { this.Formatter }).Result;
            }
            catch (Exception e)
            {
                log.Error("CanDeleteAgeGroup failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Does Age Group Exist
        /// </summary>
        /// <param name="name">The default name for the age group type</param>
        /// <returns></returns>
        public RefAgegroupDoesexistModel DoesAgeGroupExist(string name)
        {
            log.Info("DoesAgeGroupExist is called");

            try
            {
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("DoesAgeGroupExist"));

                builder.Query = string.Format("name={0}", name);

                var response = this._apiclient.GetAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();

                log.Info("DoesAgeGroupExist returned");

                return response.Content.ReadAsAsync<RefAgegroupDoesexistModel>(new List<MediaTypeFormatter> { this.Formatter }).Result;
            }
            catch (Exception e)
            {
                log.Error("DoesAgeGroupExist failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Processes new and existing updates to age group record information.
        /// </summary>
        /// <param name="parms"></param>
        /// <returns>Returns an SPReturnResult Instance that specifies the completion of the operation.</returns>
        public SPReturnResult SetAgeGroupRecord(AgeGroupSetParam parms)
        {
            log.Info("SetAgeGroupRecord is called");
            SPReturnResult results = null;

            try
            {
                var content = this.CreateRequestContent(parms);

                var response = _apiclient.PostAsync(this.Settings.GetResourceValue("AgeGroupSet"), content).Result;

                results = response.Content.ReadAsAsync<SPReturnResult>(new List<MediaTypeFormatter> { this.Formatter }).Result;
            }
            catch (Exception e)
            {
                log.Error("SetAgeGroupRecord failed", e);
                throw e;
            }

            log.Info("SetAgeGroupRecord returned");

            return results;
        }
    }
}
