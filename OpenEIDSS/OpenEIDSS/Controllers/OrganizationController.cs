using OpenEIDSS.Extensions.Attributes;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using WebApi.OutputCache.V2;
using OpenEIDSS.Domain.Return_Contracts;
using Newtonsoft.Json;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// Provides functionality to administer Organizations
    /// </summary>
    [RoutePrefix("api/Admin")]
   
    public class OrganizationController : ApiController
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(OrganizationController));

        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// Contructor
        /// </summary>
        public OrganizationController() : base()
        {

        }


        /// <summary>
        /// Returns a list of  Organizations
        /// </summary>
        /// <param name="adminOrgGetListParams">JSON Request Object Parameter</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetOrganizationList")]
        [ResponseType(typeof(List<AdminOrgGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async  Task<IHttpActionResult> AdminGetOrgList(AdminOrgGetListParams adminOrgGetListParams)
        {

            log.Info("Entering  AdminGetOrgList Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.AdminOrgGetListAsync(
                    adminOrgGetListParams.languageId,
                    adminOrgGetListParams.orgId,
                    adminOrgGetListParams.organizationId,
                    adminOrgGetListParams.organizationName,
                    adminOrgGetListParams.organizationFullName,
                    adminOrgGetListParams.haCode,
                    adminOrgGetListParams.siteId,
                    adminOrgGetListParams.regionId,
                    adminOrgGetListParams.rayonId,
                    adminOrgGetListParams.settlementId,
                    adminOrgGetListParams.organizationTypeId);
                if (result == null)
                {
                    log.Info("AdminGetOrgList With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in AdminGetOrgList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in AdminGetOrgList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  AdminGetOrgList");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get Details of an Organization
        /// </summary>
        /// <param name="officeId"></param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetOrganizationDetail")]
        [ResponseType(typeof(List<AdminOrgGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> AdminGetOrgDetail(long officeId, string languageId)
        {
            log.Info("Entering  AdminGetOrgDetail Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.AdminOrgGetDetailAsync(officeId, languageId);
                if (result == null)
                {
                    log.Info("AdminGetOrgDetail With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in AdminGetOrgDetail Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in AdminGetOrgDetail" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  AdminGetOrgDetail");
            return Ok(returnResult);
        }

        /// <summary>
        /// Create Organization
        /// </summary>
        /// <param name="adminOrganizationSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("SetOrganization")]
        [ResponseType(typeof(List<AdminOrgSetModel>))]
        public async Task<IHttpActionResult> AdminOrgSet([FromBody]AdminOrganizationSetParams adminOrganizationSetParams)
        {
            log.Info("Entering  AdminOrgSet Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                long? officeId = adminOrganizationSetParams.idfOffice;
                long? idfGeoLocation = adminOrganizationSetParams.idfGeoLocation;

                var result = await _repository.AdminOrgSetAsync(
                    adminOrganizationSetParams.officeId,
                    adminOrganizationSetParams.EnglishName,
                    adminOrganizationSetParams.name,
                    adminOrganizationSetParams.EnglishFullName,
                    adminOrganizationSetParams.FullName,
                    adminOrganizationSetParams.strContactPhone,
                    adminOrganizationSetParams.idfsCurrentCustomization,
                    adminOrganizationSetParams.intHACode,
                    adminOrganizationSetParams.strOrganizationID,
                    adminOrganizationSetParams.LangID,
                    adminOrganizationSetParams.intOrder,
                    adminOrganizationSetParams.idfGeoLocation,
                    adminOrganizationSetParams.LocationUserControlidfsCountry,
                    adminOrganizationSetParams.LocationUserControlidfsRegion,
                    adminOrganizationSetParams.LocationUserControlidfsRayon,
                    adminOrganizationSetParams.LocationUserControlidfsSettlement,
                    adminOrganizationSetParams.LocationUserControlstrApartment,
                    adminOrganizationSetParams.LocationUserControlstrBuilding,
                    adminOrganizationSetParams.LocationUserControlstrStreetName,
                    adminOrganizationSetParams.LocationUserControlstrHouse,
                    adminOrganizationSetParams.strPostCode,
                    adminOrganizationSetParams.blnForeignAddress,
                    adminOrganizationSetParams.strForeignAddress,
                    adminOrganizationSetParams.LocationUserControldblLongitude,
                    adminOrganizationSetParams.LocationUserControldblLongitude,
                    adminOrganizationSetParams.blnGeoLocationShared
                    );
                if (result == null)
                {
                    log.Info("AdminOrgSet With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in AdminOrgSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in AdminOrgSet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  AdminOrgSet");
            return Ok(returnResult);
        }

        /// <summary>
        /// Deletes an organization
        /// </summary>
        /// <param name="idfOffice">Office Id</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<OrganizationDeleteModel>))]
        [HttpPost, Route("DeleteOrganization")]
        public async Task<IHttpActionResult> AdminDeleteOrganization(long idfOffice)
        {
            log.Info("Entering  AdminDeleteOrganization Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
              
                var result = await _repository.OrganizationDeleteAsync(idfOffice);
                if (result == null)
                {
                    log.Info("AdminDeleteOrganization With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in AdminDeleteOrganization Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in AdminDeleteOrganization" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  AdminDeleteOrganization");
            return Ok(returnResult);
        }
    }

}
