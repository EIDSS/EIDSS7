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
    /// API responsible for Statistic Measurement Info
    /// </summary>
    [RoutePrefix("api/Admin")]

    public class MeasureReferenceController : ApiController
    {

        static readonly ILog log = log4net.LogManager.GetLogger(typeof(MeasureReferenceController));
        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// Instantiates a new Instance Of Class -- Contructor 
        /// </summary>
        /// 
        public MeasureReferenceController() : base()
        {
        }

        /// <summary>
        /// Deletes Reference
        /// </summary>
        /// <param name="idfsAction">Action Id</param>
        /// <param name="idfsMeasureList"></param>
        /// <param name="deleteAnyway"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>

        [HttpDelete, Route("MeasureReferenceDel")]
        [ResponseType(typeof(List<Domain.RefMeasurerefefenceDelModel>))]
        public IHttpActionResult MeasureReferenceDel(long idfsAction, long idfsMeasureList, bool deleteAnyway)
        {
            log.Info("Entering  MeasureReferenceDel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result =  _repository.RefMeasurerefefenceDel(idfsAction,idfsMeasureList,deleteAnyway);
                if (result == null)
                {
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                    log.Info("Exiting  MeasureReferenceDel Not Found");
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                    log.Info("Exiting  MeasureReferenceDel");
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in MeasureReferenceDel Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in MeasureReferenceDel" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            return Json(returnResult);
        }


        /// <summary>
        /// Returns Reference Measurement List
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

        [HttpGet, Route("RefMeasurelistGetList")]
        [ResponseType(typeof(List<Domain.RefMeasurelistGetListModel>))]
        //[CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> RefMeasurelistGetList(string languageId)
        {
            APIReturnResult returnResult = new APIReturnResult();
            log.Info("Entering  RefMeasurelistGetList");
            try
            {
                var result = await _repository.RefMeasurelistGetListAsync(languageId);
                if (result == null)
                {
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                    log.Info("Exiting  RefMeasurelistGetList Not Found");
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                    log.Info("Exiting  RefMeasurelistGetList");
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in RefMeasurelistGetList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefMeasurelistGetList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            return Json(returnResult);
        }


        /// <summary>
        /// Returns Measure Reference List by Action List
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsActionList"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>

        [HttpGet, Route("RefMeasurereferenceGetList")]
        [CacheHttpGetAttribute(0, 0, false)]
        [ResponseType(typeof(List<Domain.RefMeasurereferenceGetListModel>))]
        public async Task<IHttpActionResult> RefMeasurereferenceGetList(string languageId, long ? idfsActionList)
        {
            log.Info("Entering  RefMeasurereferenceGetList");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.RefMeasurereferenceGetListAsync(languageId,idfsActionList);
                if (result == null)
                {
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                    log.Info("Exiting  RefMeasurereferenceGetList Not Found");
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                    log.Info("Exiting  RefMeasurereferenceGetList");
                }
                    
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in RefMeasurereferenceGetList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefMeasurereferenceGetList" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            return Json(returnResult);
        }

        /// <summary>
        /// Sets, saves a MeasureReference
        /// </summary>
        /// <param name="refMeasureReferenceSetParams"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("RefMeasurereferenceSet")]
        [ResponseType(typeof(List<RefMeasurereferenceSetModel>))]
        public  async Task<IHttpActionResult> RefMeasurereferenceSet(RefMeasureReferenceSetParams refMeasureReferenceSetParams)
        {
            log.Info("Entering  RefMeasurereferenceSet");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
               
                var result = await _repository.RefMeasurereferenceSetAsync(
                    refMeasureReferenceSetParams.idfsBaseReference,
                    refMeasureReferenceSetParams.idfsReferenceType,
                    refMeasureReferenceSetParams.strDefault,
                    refMeasureReferenceSetParams.strName,
                    refMeasureReferenceSetParams.strActionCode,
                    refMeasureReferenceSetParams.intOrder,
                    refMeasureReferenceSetParams.languageId);
                if (result == null)
                {
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                    log.Info("Exiting  RefMeasurereferenceSet NOT FOUND");
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                    log.Info("Exiting  RefMeasurereferenceSet");
                }
                    
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in RefMeasurereferenceSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in RefMeasurereferenceSet" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            return Json(returnResult);
        }
    }
}
