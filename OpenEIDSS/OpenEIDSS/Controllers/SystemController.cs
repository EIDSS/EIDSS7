using OpenEIDSS.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using WebApi.OutputCache.V2;
using System.Collections;
using System.Collections.Generic;
using OpenEIDSS.Domain;
using System.Data.SqlClient;
using OpenEIDSS.Extensions.Attributes;
using Newtonsoft.Json;
using OpenEIDSS.Domain.Return_Contracts;
using System;

namespace OpenEIDSS.Controllers
{

    /// <summary>
    /// Class provides functionality for System 
    /// </summary>
    [RoutePrefix("api/System")]
    public class SystemController : ApiController
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(SystemController));
        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// Instantiates a new Instance Of Class -- Contructor 
        /// </summary>
        public SystemController()
        {

        }

        /// <summary>
        /// Returns Stored Procedure Parameters
        /// </summary>
        /// <param name="procName">Procedure Name</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetProcParams")]
        [ResponseType(typeof(List<DbGetProcParamsModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetProcParams(string procName)
        {
            log.Info("Entering  GetProcParams");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
              
                var result = await _repository.DbGetProcParamsAsync(procName);
                if (result == null)
                {
                    log.Info("Exiting  GetProcParams With Not Found");
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
                log.Error("SQL Error in GetProcParams Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetProcParams" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetProcParams");
            return Ok(returnResult);

        }


        /// <summary>
        /// Returns Column Names
        /// </summary>
        /// <param name="tableName">Table Name</param>
        /// <param name="columnName">Column Name</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetTableColumns")]
        [ResponseType(typeof(List<DbGetProcParamsModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetTableColumns(string tableName,string columnName)
        {
            log.Info("Entering  GetTableColumns");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
               
                var result = await _repository.DbGetTableColumnsAsync(tableName,columnName);
                if (result == null)
                {
                    return NotFound();
                }
                log.Info("Exiting  GetTableColumns");
                if (result == null)
                {
                    log.Info("Exiting  GetTableColumns With Not Found");
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
                log.Error("SQL Error in GetTableColumns Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in GetTableColumns" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  GetTableColumns");
            return Ok(returnResult);

        }


    }
}
