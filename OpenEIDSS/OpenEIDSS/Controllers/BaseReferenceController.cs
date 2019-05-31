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
    /// Provides the ability to configure 
    /// </summary>
    [RoutePrefix("api/SystemConfig")]
    public class BaseReferenceController : ApiController
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(BaseReferenceController));
        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// 
        /// </summary>
        public BaseReferenceController() : base()
        {

        }

        /// <summary>
        /// Returns a List Of Base Reference Types
        /// </summary>
        /// <param name="referenceId">BaseReferenceTypeId</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet,Route("GetBaseReferenceTypes")]
        //[CacheHttpGetAttribute(0, 0, false)]
        [ResponseType(typeof(List<AdminBaserefGetListModel>))]
        public async Task<IHttpActionResult> GetBaseReferenceTypes(int referenceId = 000000)
        {
            log.Info("GetBaseReferenceTypes is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
              
                var result = await _repository.AdminBaserefGetListAsync(referenceId, string.Empty);
                if (result == null)
                {
                    log.Info("Exiting  GetBaseReferenceTypes With Not Found");
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
                log.Error("SQL Error in GetBaseReferenceTypes Procedure" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetBaseReferenceTypes failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("BaseReferenceTypes returned");
            return Ok(returnResult);
        }

        /// <summary>Creates and Updates a base reference</summary>
        /// <param name="baseReferenceSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("BaseReferenceSet")]
        //[CacheHttpGetAttribute(0, 0, false)]
        [ResponseType(typeof(List<RefBasereferenceSetModel>))]
        public async Task<IHttpActionResult> BaseReferenceSet(AdminBaseReferenceSetParams baseReferenceSetParams)
        {
            log.Info("BaseReferenceSet is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.RefBasereferenceSetAsync(
                    baseReferenceSetParams.idfsBaseReference,
                    baseReferenceSetParams.idfsReferenceType, 
                    baseReferenceSetParams.languageId, 
                    baseReferenceSetParams.strDefault, 
                    baseReferenceSetParams.strName, 
                    baseReferenceSetParams.intHACode, 
                    baseReferenceSetParams.intOrder
                    );
                if (result == null)
                {
                    log.Info("Exiting BaseReferenceSet With Not Found");
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
                log.Error("SQL Error in BaseReferenceSet Procedure" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("BaseReferenceSet failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("BaseReferenceSet returned");
            return Ok(returnResult);
        }

        /// <summary>Deletes a base reference</summary>
        /// <param name="idfsBaseReference"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("BaseReferenceDel")]
        [ResponseType(typeof(List<RefBasereferenceDelModel>))]
        public async Task<IHttpActionResult> BaseReferenceDel(long idfsBaseReference)
        {
            log.Info("BaseReferenceSet is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.RefBasereferenceDelAsync(idfsBaseReference);
                if (result == null)
                {
                    log.Info("Exiting BaseReferenceSet With Not Found");
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
                log.Error("SQL Error in BaseReferenceSet Procedure" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("BaseReferenceSet failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("BaseReferenceSet returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a List Of Base Reference Types
        /// </summary>
        /// <param name="idfsReferenceType">BaseReferenceTypeId</param>
        /// <param name="languageId"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetBaseReferences")]
        //[CacheHttpGetAttribute(0, 0, false)]
        [ResponseType(typeof(List<RefBasereferenceGetListModel>))]
        public async Task<IHttpActionResult> GetBaseReferences(long idfsReferenceType, string languageId)
        {
            log.Info("GetBaseReferences is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.RefBasereferenceGetListAsync(idfsReferenceType, languageId);
                if (result == null)
                {
                    log.Info("Exiting GetBaseReferences With Not Found");
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
                log.Error("SQL Error in GetBaseReferences Procedure" + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetBaseReferences failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("GetBaseReferences returned");
            return Ok(returnResult);
        }
    }
}
