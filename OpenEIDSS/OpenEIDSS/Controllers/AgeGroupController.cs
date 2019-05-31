using log4net;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using WebApi.OutputCache.V2;
using OpenEIDSS.Extensions.Attributes;
using System.Data.SqlClient;
using OpenEIDSS.Extensions;
using OpenEIDSS.Domain.Return_Contracts;
using Newtonsoft.Json;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// API for managing Age Groups
    /// </summary>
    [RoutePrefix("api/Admin")]
    public class AgeGroupController : ApiController
    {
        static readonly ILog log = log4net.LogManager.GetLogger(typeof(AgeGroupController));
        private IEIDSSRepository _repository = new EIDSSRepository();
       
        /// <summary>
        /// 
        /// </summary>
        public AgeGroupController() : base()
        {
          

        }


        /// <summary>
        /// Returns Reference Age Group List
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
        [HttpGet, Route("RefAgegroupGetList")]
        [ResponseType(typeof(List<Domain.RefAgegroupGetListModel>))]
        //[CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> RefAgegroupGetList(string languageId)
        {
            log.Info("Entering  RefAgegroupGetList");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.RefAgegroupGetListAsync(languageId);
                if (result == null)
                {
                    log.Info("Exiting  RefAgegroupGetList With Not Found");
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
                log.Error("SQL Error in RefAgegroupGetList Proc: " + ex.Procedure, ex);
                return InternalServerError(ex);
            }
            catch (Exception ex)
            {
                log.Error("Error in RefAgegroupGetList" + ex.Message, ex);
                return InternalServerError(ex);
            }
            log.Info("Exiting  RefAgegroupGetList");
            return Json(returnResult);
        }

        /// <summary> DEMO THIS
        /// Sets,Saves Reference Age Group
        /// </summary>
        /// <param name="adminReferenceAgeGroupSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("RefAgegroupSet")]
        [ResponseType(typeof(List<RefAgegroupSetModel>))]
        [CacheOutput(ClientTimeSpan = Constants.ClientDefaultCachingTimeoutSecs, ServerTimeSpan = Constants.ServerDefaultCachingTimeoutSecs)]
        public async Task<IHttpActionResult> RefAgegroupSet(AdminReferenceAgeGroupSetParams adminReferenceAgeGroupSetParams)
        {
            log.Info("Entering  RefAgegroupSet");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.RefAgegroupSetAsync(
                    adminReferenceAgeGroupSetParams.idfsAgeGroup,
                    adminReferenceAgeGroupSetParams.strDefault,
                    adminReferenceAgeGroupSetParams.strName,
                    adminReferenceAgeGroupSetParams.intLowerBoundary,
                    adminReferenceAgeGroupSetParams.intUpperBoundary,
                    adminReferenceAgeGroupSetParams.idfsAgeType,
                    adminReferenceAgeGroupSetParams.languageId,
                    adminReferenceAgeGroupSetParams.intOrder
                    );
            
                if (result == null)
                {
                    log.Info("Exiting  RefAgegroupSet With Not Found");
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
                log.Error("SQL Error in RefAgegroupSet Procedure:" + ex.Procedure, ex);
                return InternalServerError(ex);
            }
            catch (Exception ex)
            {
                log.Error("Error in RefAgegroupSet" + ex.Message, ex);
                return InternalServerError(ex);
            }
            log.Info("Exiting  RefAgegroupSet");
            return Json(returnResult);
        }


        /// <summary>
        /// Deletes Reference Age Group
        /// </summary>
        /// <param name="idfsAgeGroup">AgeGroup Id</param>
        /// <param name="deleteAnyway">Whether or not to delete the record</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("RefAgegroupDel")]
        [ResponseType(typeof(List<RefAgegroupDelModel>))]
        public async Task<IHttpActionResult> RefAgegroupDel(long idfsAgeGroup, bool? deleteAnyway)
        {
            log.Info("Entering  RefAgegroupDel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.RefAgegroupDelAsync(idfsAgeGroup, deleteAnyway);
                if (result == null)
                {
                    log.Info("Exiting  RefAgegroupDel With Not Found");
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
                log.Error("SQL Error in RefAgegroupDel Procedure" + ex.Procedure, ex);
                return InternalServerError(ex);
            }
            catch (Exception ex)
            {
                log.Error("Error in RefAgegroupDel" + ex.Message, ex);
                return InternalServerError(ex);
            }

            log.Info("Exiting  RefAgegroupDel");
            return Ok(returnResult);
        }

    }
}
