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
    /// <summary>
    /// Client service that contains common functionality that is utilized across multiple functional areas
    /// </summary>
    public class BaseReferenceClient : APIClientBase
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(BaseReferenceClient));

        /// <summary>
        /// Creates a new instance of this class.
        /// </summary>
        public BaseReferenceClient() : base()
        {
        }

        /// <summary>
        /// Returns a List Of Base ReferenceTypes
        /// </summary>
        /// <param name="referneceId"></param>
        /// <returns></returns>
        public List<AdminBaserefGetListModel> GetBaseReferneceTypes(long referneceId)
        {
            log.Info("GetBaseReferneceTypes is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("ADMIN-GETBASEREFERENCETYPES"));

                builder.Query = string.Format("referenceId={0}", Convert.ToString(referneceId));

                var response = this._apiclient.GetAsync(builder.Uri).Result;
                response.EnsureSuccessStatusCode();
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<AdminBaserefGetListModel>();
                }
                log.Info("GetBaseReferneceTypes returned");
                return JsonConvert.DeserializeObject<List<AdminBaserefGetListModel>>(aPIReturnResult.Results);
              
            }
            catch (Exception ex)
            {
                log.Error("Error GetBaseReferneceTypes is called: " + ex.Message);
                throw;
            }
          
        }

        /// <summary>
        /// Returns a List Of Base ReferenceTypes
        /// </summary>
        /// <param name="referneceId"></param>
        /// <returns></returns>
        public async Task<List<RefBasereferenceSetModel>> BaseReferneceSet(AdminBaseReferenceSetParams adminBaseReferenceSetParams)
        {
            log.Info("GetBaseReferneceTypes is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {

                //Serialize the request parameters
                var content = CreateRequestContent(adminBaseReferenceSetParams);

                // Call the service.
                var response = await _apiclient.PostAsync(Settings.GetResourceValue("ADMIN-POST-REF-BASEREFERENCESET"), content).ConfigureAwait(false);

                response.EnsureSuccessStatusCode();
                log.Info("RefAgegroupSet returned");
                aPIReturnResult = response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter }).Result;
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefBasereferenceSetModel>();
                }
                log.Info("RefAgegroupSet returned");
                return JsonConvert.DeserializeObject<List<RefBasereferenceSetModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("RefAgegroupSet failed", e);
                throw e;
            }

        }

        public async Task<List<RefBasereferenceDelModel>> BaseReferenceDel(long idfsBaseReference)
        {
            log.Info("RefAgegroupDel is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                UriBuilder builder = new UriBuilder(Settings.GetFullyQualifiedResourceURI("ADMIN-DEL-REF-BASEREFERENCE"))
                {
                    Query = string.Format("idfsBaseReference={0}", new[] { Convert.ToString(idfsBaseReference) })
                };

                var response = _apiclient.DeleteAsync(builder.Uri).Result;

                response.EnsureSuccessStatusCode();
                log.Info("RefAgegroupDel returned");
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefBasereferenceDelModel>();
                }
                log.Info("RefAgegroupDel returned");
                return JsonConvert.DeserializeObject<List<RefBasereferenceDelModel>>(aPIReturnResult.Results);
            }
            catch (Exception e)
            {
                log.Error("RefAgegroupDel failed", e);
                throw e;
            }
        }

        /// <summary>
        /// Returns a List Of Base ReferenceTypes
        /// </summary>
        /// <param name="idfsReferenceType"></param>
        /// <param name="languageId"></param>
        /// <returns></returns>
        public async Task<List<RefBasereferenceGetListModel>> GetBaseReferences(long idfsReferenceType, string languageId)
        {
            log.Info("GetBaseReferneceTypes is called");
            APIReturnResult aPIReturnResult = new APIReturnResult();
            try
            {
                // Create a uri and set the query string parms...
                UriBuilder builder = new UriBuilder(this.Settings.GetFullyQualifiedResourceURI("ADMIN-GET-BASEREFERENCELIST"));

                builder.Query = string.Format("idfsReferenceType={0}&languageId={1}", new[] { Convert.ToString(idfsReferenceType), Convert.ToString(languageId) });

                var response = this._apiclient.GetAsync(builder.Uri).Result;
                response.EnsureSuccessStatusCode();
                aPIReturnResult = await response.Content.ReadAsAsync<APIReturnResult>(new List<MediaTypeFormatter> { Formatter });
                if (aPIReturnResult.ErrorCode != System.Net.HttpStatusCode.OK)
                {
                    log.Error(aPIReturnResult.ErrorMessage);
                    return new List<RefBasereferenceGetListModel>();
                }
                log.Info("GetBaseReferneceTypes returned");
                return JsonConvert.DeserializeObject<List<RefBasereferenceGetListModel>>(aPIReturnResult.Results);

            }
            catch (Exception ex)
            {
                log.Error("Error GetBaseReferneceTypes is called: " + ex.Message);
                throw;
            }

        }
    }
}
