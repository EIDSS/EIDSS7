using Newtonsoft.Json;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Domain.Return_Contracts;
using OpenEIDSS.Extensions.Attributes;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;

namespace OpenEIDSS.Controllers
{

    /// <summary>
    ///API Resonsible for Person Functionality
    /// </summary>
    [RoutePrefix("api/Admin")]
    public class PersonController : ApiController
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(PersonController));
        private IEIDSSRepository _repository = new EIDSSRepository();



        /// <summary>
        /// Creates a new instance of this class
        /// </summary>
        public PersonController() : base()
        {

        }

        /// <summary>
        /// Deletes a Person record
        /// </summary>
        /// <param name="idfPerson">Unique Identifier of a Person</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpDelete, Route("DeletePerson")]
        [ResponseType(typeof(List<GblPersonDeleteModel>))]
        public async Task<IHttpActionResult> DeletePerson(long idfPerson)
        {
            log.Info("Entering  DeletePerson Params:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.GblPersonDeleteAsync(idfPerson);
                log.Info("Exiting  DeletePerson Params:");
                if (result == null)
                {
                    log.Info("Exiting  DeletePerson With Not Found");
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
                log.Error("SQL Error in DeletePerson Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in DeletePerson" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  DeletePerson");
            return Ok(returnResult);
        }

        /// <summary>
        /// Update HumanMasterID for a list of Disease reports
        /// </summary>
        /// <param name="parms">A parameter contract that specifies the survivor's human master identifier and
        /// the superseded human master identifier</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("DedupePersonIdHumanDiseaseAsync")]
        [ResponseType(typeof(List<AdminDeduplicationPersonidHumanDiseaseSetModel>))]
        public async Task<IHttpActionResult> DedupePersonIdHumanDiseaseAsync([FromBody]PersonDedupeSetParams parms)
        {
            log.Info("Entering DedupePersonIdHumanDiseaseAsync:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.AdminDeduplicationPersonidHumanDiseaseSetAsync(parms.SurvivorHumanMasterID, parms.SupersededHumanMasterID);
                if (result == null)
                {
                    log.Info("Exiting DedupePersonIdHumanDiseaseAsync With Not Found");
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
                log.Error("SQL Error in DedupePersonIdHumanDiseaseAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in DedupePersonIdHumanDiseaseAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting DedupePersonIdHumanDiseaseAsync");
            return Ok(returnResult);
        }


        /// <summary>
        /// Update HumanMasterID for a list of Farms
        /// </summary>
        /// <param name="parms">A parameter contract that specifies the survivor's human master identifier and
        /// the superseded human master identifier</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("DedupePersonIdFarmAsync")]
        [ResponseType(typeof(List<AdminDeduplicationPersonidFarmSetModel>))]
        public async Task<IHttpActionResult> DedupePersonIdFarmAsync( [FromBody]PersonDedupeSetParams parms)
        {
            log.Info("Entering DedupePersonIDFarmAsync:");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                
                var result = await _repository.AdminDeduplicationPersonidFarmSetAsync(parms.SurvivorHumanMasterID, parms.SupersededHumanMasterID);
                if (result == null)
                {
                    log.Info("Exiting DedupePersonIDFarmAsync With Not Found");
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
                log.Error("SQL Error in DedupePersonIDFarmAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in DedupePersonIDFarmAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting DedupePersonIDFarmAsync");
            return Ok(returnResult);
        }
    }
}
