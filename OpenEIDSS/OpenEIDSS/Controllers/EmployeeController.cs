using Newtonsoft.Json;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Domain.Return_Contracts;
using OpenEIDSS.Extensions.Attributes;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Net;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// Provides functionality to administer employees.
    /// </summary>
    [RoutePrefix("api/Admin")]
    public class EmployeeController : ApiController
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(EmployeeController));

        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// 
        /// </summary>
        public EmployeeController() : base()
        {

        }

        /// <summary>
        /// Returns a list of employees
        /// </summary>
        /// <param name="adminEmployeeGetListParams">Request OBject Parameter</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("GetEmployees")]
        [ResponseType(typeof(List<AdminEmployeeGetlistModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public IHttpActionResult GetEmployees(AdminEmployeeGetListParams  adminEmployeeGetListParams)
        {
            log.Info("Entering  GetEmployees Params:");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = _repository.AdminEmployeeGetlist(
                    adminEmployeeGetListParams.LanguageID,
                    adminEmployeeGetListParams.EmployeeID,
                    adminEmployeeGetListParams.FirstOrGivenName,
                    adminEmployeeGetListParams.SecondName,
                    adminEmployeeGetListParams.FamilyName,
                    adminEmployeeGetListParams.ContactPhone,
                    adminEmployeeGetListParams.OrganizationAbbreviatedName,
                    adminEmployeeGetListParams.OrganizationFullName,
                    adminEmployeeGetListParams.EIDSSOrganizationID,
                    adminEmployeeGetListParams.OrganizationID,
                    adminEmployeeGetListParams.PositionTypeName,
                    adminEmployeeGetListParams.PositionTypeID);

                if (result == null)
                {
                    log.Info("Exiting  GetEmployees With Not Found");
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
                log.Error("SQL Error in GetEmployees Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetEmployees" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetEmployees");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a list of employees
        /// </summary>
        /// <param name="adminEmployeeGetListParams">Request OBject Parameter</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("GetEmployeesAsync")]
        [ResponseType(typeof(List<AdminEmpGetlistModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> AdminEmpGetlistAsync(AdminEmployeeGetListParams adminEmployeeGetListParams)
        {
            log.Info("Entering  AdminEmpGetlistAsync");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.AdminEmployeeGetlistAsync(
                    adminEmployeeGetListParams.LanguageID,
                    adminEmployeeGetListParams.EmployeeID,
                    adminEmployeeGetListParams.FirstOrGivenName,
                    adminEmployeeGetListParams.SecondName,
                    adminEmployeeGetListParams.FamilyName,
                    adminEmployeeGetListParams.ContactPhone,
                    adminEmployeeGetListParams.OrganizationAbbreviatedName,
                    adminEmployeeGetListParams.OrganizationFullName,
                    adminEmployeeGetListParams.EIDSSOrganizationID,
                    adminEmployeeGetListParams.OrganizationID,
                    adminEmployeeGetListParams.PositionTypeName,
                    adminEmployeeGetListParams.PositionTypeID);

                if (result == null)
                {
                    log.Info("Exiting  AdminEmpGetlistAsync With Not Found");
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
                log.Error("SQL Error in AdminEmpGetlistAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in AdminEmpGetlistAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  AdminEmpGetlistAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get details of a person by language and person identifier
        /// </summary>
        /// <param name="personId"></param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetGBLPersonDetailsAsync")]
        [ResponseType(typeof(List<GblPersonGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetGBLPersonDetailsAsync(int personId, string languageId)
        {
            log.Info("Entering GetGBLPersonDetailsAsync");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.GblPersonGetDetailAsync(personId, languageId);
                if (result == null)
                {
                    log.Info("Exiting  GetGBLPersonDetailsAsync With Not Found");
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
                log.Error("SQL Error in GetGBLPersonDetailsAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetGBLPersonDetailsAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetGBLPersonDetailsAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Get details of a person by language and person identifier
        /// </summary>
        /// <param name="personId"></param>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetGBLPersonDetails")]
        [ResponseType(typeof(List<GblPersonGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public IHttpActionResult GetGBLPersonDetails(int personId, string languageId)
        {
            log.Info("Entering  GetGBLPersonDetails");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result =  _repository.GblPersonGetDetail(personId, languageId);
                if (result == null)
                {
                    log.Info("Exiting  GetGBLPersonDetails With Not Found");
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
                log.Error("SQL Error in GetGBLPersonDetails Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetGBLPersonDetails" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  GetGBLPersonDetails");
            return Ok(returnResult);
        }

        /// <summary>
        /// Saves an employee
        /// </summary>
        /// <param name="adminSetEmployeeParams">JSON Request Object</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("AdminEmpSetAsync")]
        [ResponseType(typeof(List<AdminEmpSetModel>))]
        public async Task<IHttpActionResult> AdminEmpSetAsync(AdminSetEmployeeParams adminSetEmployeeParams)
        {
            log.Info("Entering  AdminEmpSetAsync");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await  _repository.AdminEmpSetAsync(
                 adminSetEmployeeParams.personId,
                adminSetEmployeeParams.staffPositionId,
                adminSetEmployeeParams.institutionId,
                adminSetEmployeeParams.departmentId,
                adminSetEmployeeParams.familyName,
                adminSetEmployeeParams.firstName,
                adminSetEmployeeParams.secondName,
                adminSetEmployeeParams.contactPhone,
                adminSetEmployeeParams.barcode,
                adminSetEmployeeParams.siteId,
                adminSetEmployeeParams.user);

                if (result == null)
                {
                    log.Info("Exiting  AdminEmpSetAsync With Not Found");
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
                log.Error("SQL Error in AdminEmpSetAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in AdminEmpSetAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  AdminEmpSetAsync");
            return Ok(returnResult);
        }

        /// <summary>
        /// Saves an employee
        /// </summary>
        /// <param name="adminSetEmployeeParams">JSON Request Object</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("AdminEmpSet")]
        [ResponseType(typeof(List<AdminEmpSetModel>))]
        public async Task<IHttpActionResult> AdminEmpSet(AdminSetEmployeeParams adminSetEmployeeParams)
        {
            log.Info("Entering  AdminEmpSet Params:");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.AdminEmpSetAsync(
                 adminSetEmployeeParams.personId,
                adminSetEmployeeParams.staffPositionId,
                adminSetEmployeeParams.institutionId,
                adminSetEmployeeParams.departmentId,
                adminSetEmployeeParams.familyName,
                adminSetEmployeeParams.firstName,
                adminSetEmployeeParams.secondName,
                adminSetEmployeeParams.contactPhone,
                adminSetEmployeeParams.barcode,
                adminSetEmployeeParams.siteId,
                adminSetEmployeeParams.user);

                if (result == null)
                {
                    log.Info("Exiting  AdminEmpSet With Not Found");
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
                log.Error("SQL Error in AdminEmpSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in AdminEmpSet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  AdminEmpSet");
            return Ok(returnResult);
        }

        /// <summary>
        /// Delete an employee
        /// </summary>
        /// <param name="personId">Unique Id of a Person</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("DeleteEmployee")]
        [ResponseType(typeof(List<AdminEmpDelModel>))]
        public IHttpActionResult AdminDeleteEmployee(long personId)
        {
            log.Info("Entering  AdminDeleteEmployee Params:");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = _repository.AdminEmpDel(personId);
                if (result == null)
                {
                    log.Info("Exiting  AdminDeleteEmployee With Not Found");
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
                log.Error("SQL Error in AdminDeleteEmployee Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in AdminDeleteEmployee" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  AdminDeleteEmployee");
            return Ok(returnResult);
        }

        /// <summary>
        /// Delete an employee
        /// </summary>
        /// <param name="personId">Unique Id of a Person</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("DeleteEmployeeAsync")]
        [ResponseType(typeof(List<AdminEmpDelModel>))]
        public async Task<IHttpActionResult> AdminEmpDelAsync(long personId)
        {
            log.Info("Entering AdminEmpDelAsync");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.AdminEmpDelAsync(personId);
                if (result == null)
                {
                    log.Info("Exiting  AdminEmpDelAsync With Not Found");
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
                log.Error("SQL Error in AdminEmpDelAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in AdminEmpDelAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("Exiting  AdminEmpDelAsync");
            return Ok(returnResult);
        }
    }
}
