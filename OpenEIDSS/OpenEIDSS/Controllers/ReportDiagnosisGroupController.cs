using Newtonsoft.Json;
using OpenEIDSS.Extensions.Attributes;
using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Domain.Return_Contracts;
using OpenEIDSS.Extensions;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using WebApi.OutputCache.V2;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    [RoutePrefix("api/Admin")]
    public class ReportDiagnosisGroupController : ApiController
    {
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(DiagnosisController));
        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// 
        /// </summary>
        public ReportDiagnosisGroupController() : base()
        { }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="languageId"></param>
        /// <returns></returns>
        /// On success a 200 OK status is returned along with a collection of response objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        [HttpGet, Route("RefReportDiagnosisGroupGetList")]
        [ResponseType(typeof(List<RefReportDiagnosisGroupGetListModel>))]
        public async Task<IHttpActionResult> RefReportDiagnosisGroupGetList(string languageId)
        {
            log.Info("Entering RefReportDiagnosisGroupGetList");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.RefReportDiagnosisGroupGetListAsync(languageId);
                if (result == null)
                {
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                    log.Info("Exiting RefReportDiagnosisGroupGetList not Found");
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                    log.Info("Exiting  RefStatisticdatatypeGetList");
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in RefReportDiagnosisGroupGetList PROC" + ex.Procedure, ex);
                return InternalServerError(ex);
            }
            catch (Exception ex)
            {
                log.Error("Error in RefReportDiagnosisGroupGetList" + ex.Message, ex);
                return InternalServerError(ex);
            }
            return Json(returnResult);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="reportDiagnosisTypeSetParams"></param>
        /// <returns></returns>
        /// On success a 200 OK status is returned along with a collection of response objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        [HttpPost, Route("RefReportDiagnosisGroupSet")]
        [ResponseType(typeof(List<RefReportdiagnosisgroupSetModel>))]
        public async Task<IHttpActionResult> ReportDiagnosisGroupSet(RefReporDiagnosisTypeSetParams reportDiagnosisTypeSetParams)
        {
            log.Info("Entering RefReportDiagnosisGroupSet");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.RefReportdiagnosisgroupSetAsync(
                        reportDiagnosisTypeSetParams.idfsReportDiagnosisGroup,
                        reportDiagnosisTypeSetParams.strDefault,
                        reportDiagnosisTypeSetParams.strName,
                        reportDiagnosisTypeSetParams.strCode,
                        reportDiagnosisTypeSetParams.languageId
                    );


                if (result == null)
                {
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                    log.Info("Exiting  RefReportDiagnosisGroupSet NOT FOUND");
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                    log.Info("Exiting  RefReportDiagnosisGroupSet");
                }

            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in RefReportDiagnosisGroupSet PROC" + ex.Procedure, ex);
                return InternalServerError(ex);
            }
            catch (Exception ex)
            {
                log.Error("Error in RefReportDiagnosisGroupSet" + ex.Message, ex);
                return InternalServerError(ex);
            }
            return Json(returnResult);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="idfsReportDiagnosisGroup"></param>
        /// <param name="deleteAnyway"></param>
        /// <returns></returns>
        /// On success a 200 OK status is returned along with a collection of response objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        [HttpDelete, Route("RefReportDiagnosisGroupDel")]
        [ResponseType(typeof(List<RefReportdiagnosisgroupDelModel>))]
        public async Task<IHttpActionResult> ReportDiagnosisGroupDel(long idfsReportDiagnosisGroup, bool deleteAnyway)
        {
            log.Info("Entering  RefReportDiagnosisGroupDel");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.RefReportdiagnosisgroupDelAsync(idfsReportDiagnosisGroup, deleteAnyway);
                if (result == null)
                {
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                    log.Info("Exiting  RefReportDiagnosisGroupDel Not Found");
                }
                else
                {
                    returnResult.ErrorCode = HttpStatusCode.OK;
                    returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                    returnResult.Results = JsonConvert.SerializeObject(result);
                    log.Info("Exiting  RefReportDiagnosisGroupDel");
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in RefReportDiagnosisGroupDel PROC" + ex.Procedure, ex);
                return InternalServerError(ex);
            }
            catch (Exception ex)
            {
                log.Error("Error in RefReportDiagnosisGroupDel" + ex.Message, ex);
                return InternalServerError(ex);
            }
            return Json(returnResult);
        }
    }
}
