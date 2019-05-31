using OpenEIDSS.Extensions.Attributes;
using OpenEIDSS.Data;
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
using System.Data.SqlClient;
using Newtonsoft.Json;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// Provides functionality to administer Organizations
    /// </summary>
    [RoutePrefix("api/Admin")]
   
    public class ObjectAccessController : ApiController
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(ObjectAccessController));

        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// Contructor
        /// </summary>
        public ObjectAccessController() : base()
        {

        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfEmployee">A unique identifier of an employee</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetObjectAccessDetail")]
        [ResponseType(typeof(int))]
        [CacheHttpGetAttribute(0, 0, false)]
        public IHttpActionResult ObjectAccessGetDetail(string languageId,long idfEmployee)
        {
            log.Info("Entering  ObjectAccessGetDetail Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = _repository.ObjectAccessGetDetail (languageId,idfEmployee);
                if (result == null)
                {
                    log.Info("Exiting  ObjectAccessGetDetail With Not Found");
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
                log.Error("SQL Error in ObjectAccessGetDetail Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ObjectAccessGetDetail" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ObjectAccessGetDetail");
            return Ok(returnResult);
        }

        /// <summary>
        /// Deletes Access by Id
        /// </summary>
        /// <param name="idfObjectAccess">id of element to delete</param>
        /// <param name="idfEmployee">id of element to delete</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("DeleteObjectAccess")]
        [ResponseType(typeof(int))]
        public IHttpActionResult DeleteObjectAccess(long idfObjectAccess, long idfEmployee)
        {
            
            log.Info("Entering  DeleteObjectAccess Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = _repository.AdminUsrObjectaccessDel(idfObjectAccess,idfEmployee);
                if (result == null)
                {
                    log.Info("Exiting  DeleteObjectAccess With Not Found");
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
                log.Error("SQL Error in DeleteObjectAccess Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in DeleteObjectAccess" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  DeleteObjectAccess");
            return Ok(returnResult);
        }


        /// <summary>
        /// Sets Object Access
        /// </summary>
        /// <param name="objectAccessSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [ResponseType(typeof(List<Domain.AdminUsrObjectaccessSetModel>))]
        public IHttpActionResult SetObjectAccess([FromBody] ObjectAccessSetParams objectAccessSetParams)
        {
            log.Info("Entering  SetObjectAccess Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                long ? idfObjectAccess;
                var result = _repository.AdminUsrObjectaccessSet(
                    out idfObjectAccess,
                    objectAccessSetParams.idfsObjectOperation, 
                    objectAccessSetParams.idfsObjectType, 
                    objectAccessSetParams.idfsObjectId, 
                    objectAccessSetParams.idfEmployee, 
                    objectAccessSetParams.isAllow, 
                    objectAccessSetParams.isDeny);
                if (result == null)
                {
                    log.Info("Exiting  ObjectAccessSetParams With Not Found");
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
                log.Error("SQL Error in ObjectAccessSetParams Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in ObjectAccessSetParams" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  ObjectAccessSetParams");
            return Ok(returnResult);
        }



    }

}
