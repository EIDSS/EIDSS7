using OpenEIDSS.Extensions.Attributes;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Extensions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using WebApi.OutputCache.V2;
using OpenEIDSS.Domain.Return_Contracts;
using Newtonsoft.Json;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    /// 
    [RoutePrefix("api/Admin")]
    public class DepartmentController : ApiController
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(DepartmentController));

        private IEIDSSRepository _repository = new EIDSSRepository();


        /// <summary>
        /// Returns a Department(s) / Department lookup
        /// </summary>
        /// <param name="languageId"></param>
        /// <param name="organizationId">unique identifier of an organization</param>
        /// <param name="id"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetDepartment")]
        [CacheHttpGetAttribute(0, 0, false)]
        [ResponseType(typeof(List<DepartmentGetLookupModel>))]
        public async Task<IHttpActionResult> GetDeparment(string languageId, long? organizationId,long? id)
        {
            log.Info("Entering GetDeparment");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result =await _repository.DepartmentGetLookupAsync(languageId, organizationId, id);
                if (result == null)
                {
                    log.Info("GetDeparment not Found");
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
                log.Error("SQL Error in GetDeparment Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetDeparment" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetDeparment");
            return Ok(returnResult);
        }

        /// <summary>
        /// Saves/ Creates a Department
        /// </summary>
        /// <param name="departmentSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("SetDeparment")]
        [ResponseType(typeof(List<int>))]
        public  IHttpActionResult SetDepartment([FromBody] DepartmentSetParams departmentSetParams)
        {
            log.Info("Entering SetDepartment");
            try
            {
                var result = _repository.DepartmentSet(
                    departmentSetParams.action,
                    departmentSetParams.idfDepartment,
                    departmentSetParams.idfOrganization,
                    departmentSetParams.defaultName,
                    departmentSetParams.name,
                    departmentSetParams.idfsCountry,
                    departmentSetParams.langId,
                    departmentSetParams.user
                    );
                if (result !=0)
                {
                    log.Info("Exiting SetDepartment NOT FOUND");
                    return NotFound();
                }
                log.Info("Exiting SetDepartment");
                return Ok(result);
            }
            catch (Exception ex)
            {
                log.Error("Error SetDepartment " + ex.Message, ex);
                return InternalServerError(ex);
            }
        }


        /// <summary>
        /// Deletes a Department
        /// </summary>
        /// <param name="id"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("DeleteDeparment")]
        [ResponseType(typeof(List<int>))]
        public IHttpActionResult DeleteDepartment(long id)
        {
            log.Info("Entering DeleteDepartment");
            try
            {
                var result = _repository.DepartmentDelete(id);
                    
                if (result !=0)
                {
                    log.Info("Exiting DeleteDepartment NOT FOUND");
                    return NotFound();
                }
                log.Info("Exiting DeleteDepartment");
                return Ok(result);
            }
            catch (Exception ex)
            {
                log.Error("Error DeleteDepartment " + ex.Message, ex);
                return InternalServerError(ex);
            }
        }


    }
}
