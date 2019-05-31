using OpenEIDSS.Extensions.Attributes;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Extensions;
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
    /// Provides Vector  functionality
    /// </summary>
    [RoutePrefix("api/Admin")]
    public class VectorAdminController : ApiController
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(VectorAdminController));

        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// Constructor
        /// </summary>
        public VectorAdminController() :base()
        {

        }


        /// <summary>
        /// Returns List of Reference Vector Types
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("RefVectortypereferenceGetList")]
        [ResponseType(typeof(List<Domain.RefVectortypereferenceGetListModel>))]
        //[CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> RefVectortypereferenceGetList(string languageId)
        {
            log.Info("Entering  RefVectortypereferenceGetList");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
             
                var result = await  _repository.RefVectortypereferenceGetListAsync(languageId);
                if (result == null)
                {
                    log.Info("Exiting  RefVectortypereferenceGetList With Not Found");
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
                log.Error("SQL Error in RefVectortypereferenceGetList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefVectortypereferenceGetList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  RefVectortypereferenceGetList");
            return Ok(returnResult);
        }


        /// <summary>
        /// Sets, Save Reference Vector Types
        /// </summary>
        /// <param name="refVectorTypeSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("RefVectortypereferenceSet")]
        [ResponseType(typeof(List<RefVectortypereferenceSetModel>))]
        public async Task<IHttpActionResult> RefVectortypereferenceSet(RefVectorTypeSetParams refVectorTypeSetParams)
        {
            log.Info("Entering  RefVectortypereferenceSet");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.RefVectortypereferenceSetAsync(
                    refVectorTypeSetParams.idfsVectorType,
                    refVectorTypeSetParams.strDefault,
                    refVectorTypeSetParams.strName,
                    refVectorTypeSetParams.strCode,
                    refVectorTypeSetParams.bitCollectionByPool,
                    refVectorTypeSetParams.intOrder,
                    refVectorTypeSetParams.languageId
                   );
                if (result == null)
                {
                    log.Info("Exiting  RefVectortypereferenceSet With Not Found");
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
                log.Error("SQL Error in RefVectortypereferenceSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefVectortypereferenceSet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  RefVectortypereferenceSet");
            return Ok(returnResult);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="idfsVectorType"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VectorTypeReferenceInUse")]
        [ResponseType(typeof(List<Domain.RefVectorSubTypeCandelModel>))]
        public async Task<IHttpActionResult> VectorTypeReferenceInUse(long idfsVectorType)
        {
            log.Info("Entering  VectorTypeReferenceInUse");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
               
                var result = await _repository.RefVectortypereferenceCandelAsync(idfsVectorType);
                if (result == null)
                {
                    log.Info("Exiting  VectorTypeReferenceInUse With Not Found");
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
                log.Error("SQL Error in VectorTypeReferenceInUse Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VectorTypeReferenceInUse" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VectorTypeReferenceInUse");
            return Ok(returnResult);
        }


        /// <summary>
        /// Delete VectorType Reference
        /// </summary>
        /// <param name="idfsVectorType">VectorType Id</param>
        /// <param name="deleteAnyway">Delete Anyway</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("RefVectorTypeReferenceDel")]
        [ResponseType(typeof(List<RefVectortypereferenceDelModel>))]
        public async Task<IHttpActionResult> RefVectorTypeReferenceDel(long? idfsVectorType, bool? deleteAnyway)
        {

            log.Info("Entering  VectorTypeReferenceDelete");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.RefVectortypereferenceDelAsync(idfsVectorType, deleteAnyway);
                if (result == null | result.Count == 0)
                {
                    log.Info("Exiting  VectorTypeReferenceDelete With Not Found");
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
                log.Error("SQL Error in VectorTypeReferenceDelete Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VectorTypeReferenceDelete" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VectorTypeReferenceDelete");
            return Ok(returnResult);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="name"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("VectorTypeReferenceDoesExist")]
        [ResponseType(typeof(List<Domain.RefVectortypeDoesexistModel>))]
        public async Task<IHttpActionResult> VectorTypeReferenceDoesExist(string name)
        {
            log.Info("Entering  VectorTypeReferenceDoesExist");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.RefVectortypeDoesexistAsync(name);
                if (result == null)
                {
                    log.Info("Exiting  VectorTypeReferenceDoesExist With Not Found");
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
                log.Error("SQL Error in VectorTypeReferenceDoesExist Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in VectorTypeReferenceDoesExist" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  VectorTypeReferenceDoesExist");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a list of Vector Subsets
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsVectorType"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("RefVectorsubtypeGetList")]
        [ResponseType(typeof(List<Domain.RefVectorSubTypeGetListModel>))]
        //[CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> RefVectorsubtypeGetList(string languageId,long? idfsVectorType)
        {
            log.Info("Entering  RefVectorsubtypeGetList");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
              
                var result = await _repository.RefVectorSubTypeGetListAsync(languageId,idfsVectorType);
                if (result == null)
                {
                    log.Info("Exiting  RefVectorsubtypeGetList With Not Found");
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
                log.Error("SQL Error in RefVectorsubtypeGetList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefVectorsubtypeGetList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  RefVectorsubtypeGetList");
            return Ok(returnResult);
        }


        /// <summary>
        /// Sets , Saves a Vector Subset
        /// </summary>
        /// <param name="referenceVectorSubTypeSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("RefVectorsubtypeSet")]
        [ResponseType(typeof(List<RefVectorSubTypeSetModel>))]
        public async Task<IHttpActionResult> RefVectorsubtypeSet(ReferenceVectorSubTypeSetParams referenceVectorSubTypeSetParams)
        {
            APIReturnResult returnResult = new APIReturnResult();
            log.Info("Entering  RefVectorsubtypeSet");
            try
            {
                
                var result = await _repository.RefVectorSubTypeSetAsync(
                    referenceVectorSubTypeSetParams.idfsVectorSubType,
                    referenceVectorSubTypeSetParams.idfsVectorType,
                    referenceVectorSubTypeSetParams.strName,
                    referenceVectorSubTypeSetParams.strDefault,
                    referenceVectorSubTypeSetParams.strCode,
                    referenceVectorSubTypeSetParams.intOrder,
                    referenceVectorSubTypeSetParams.languageId
                    );
                if (result == null)
                {
                    log.Info("Exiting  RefVectorsubtypeSet With Not Found");
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
                log.Error("SQL Error in RefVectorsubtypeSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefVectorsubtypeSet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  RefVectorsubtypeSet");
            return Ok(returnResult);
        }
               
        /// <summary>
        /// Delete VectorSubType
        /// </summary>
        /// <param name="idfsVectorSubType">VectorSubType Id</param>
        /// <param name="deleteAnyway"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("RefVectorsubtypeDel")]
        [ResponseType(typeof(List<Domain.RefVectorSubTypeDelModel>))]
        public async Task<IHttpActionResult> RefVectorsubtypeDel(long idfsVectorSubType, bool deleteAnyway)
        {
            log.Info("Entering  RefVectorsubtypeDel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await  _repository.RefVectorSubTypeDelAsync(idfsVectorSubType, deleteAnyway);
                if (result == null)
                {
                    log.Info("Exiting  RefVectorsubtypeDel With Not Found");
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
                log.Error("SQL Error in RefVectorsubtypeDel Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefVectorsubtypeDel" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  RefVectorsubtypeDel");
            return Ok(returnResult);

        }
    }
}
