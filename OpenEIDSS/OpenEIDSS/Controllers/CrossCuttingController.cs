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
using System.Web.Http.Results;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// Provides functionality that cuts across many operational areas, including administration, flexible forms, locations, person, laboratory, etc.
    /// ...
    /// </summary>
    [RoutePrefix("api/Common")]
    public class CrossCuttingController : ApiController
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(CrossCuttingController));

        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// Creates a new instance of this class.
        /// </summary>
        public CrossCuttingController() : base()
        {
        }

        #region Location Methods

        /// <summary>
        /// Returns an instance of a country representative of CountryGetLookupModel
        /// </summary>
        /// <param name="countryId">An EIDSS specific identifier that identifies a country</param>s
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("Country")]
        [ResponseType(typeof(CountryGetLookupModel))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetCountry(long countryId)
        {
            log.Info("GetCountry is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
               
                var result = await GetCountryListAsync() as OkNegotiatedContentResult<List<CountryGetLookupModel>>;
                if (result == null)
                {
                    log.Info("Exiting  GetCountry With Not Found");
                    returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
                    returnResult.ErrorCode = HttpStatusCode.BadRequest;
                }
                else
                {
                    var country = result.Content.FirstOrDefault(f => f.idfsCountry == countryId);
                    if (country == null)
                    {
                        returnResult.ErrorMessage = HttpStatusCode.NoContent.ToString();
                        returnResult.ErrorCode = HttpStatusCode.NoContent;
                    }
                    else
                    {
                        returnResult.ErrorCode = HttpStatusCode.OK;
                        returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
                        returnResult.Results = JsonConvert.SerializeObject(country);
                    }
                }
            }
            catch (SqlException ex)
            {
                log.Error("SQL Error in GetCountry Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("GetCountry failed", ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("GetCountry returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrieves a list of all countries supported by this instance of the application.
        /// </summary>
        /// <param name="langId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [Route("CountryList")]
        [CacheHttpGetAttribute(0, 0, false)]
        [ResponseType(typeof(List<CountryGetLookupModel>))]
        public IHttpActionResult GetCountryList(string langId = "en-US")
        {
            log.Info("GetCountryList is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = _repository.CountryGetLookup(langId);
                if (result == null)
                {
                    log.Info("Exiting  GetCountryList With Not Found");
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
                log.Error("SQL Error in GetCountryList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetCountryList failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("GetCountryList returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Asynchronously returns a list of all countries supported by this instance of the application.
        /// </summary>
        /// <param name="langId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("CountryListAsync")]
        [CacheHttpGetAttribute(0, 0, false)]
        [ResponseType(typeof(List<CountryGetLookupModel>))]
        public async Task<IHttpActionResult> GetCountryListAsync(string langId = "en-US")
        {
            log.Info("GetCountryListAsync is called ");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.CountryGetLookupAsync(langId);
                if (result == null)
                {
                    log.Info("Exiting  GetCountryListAsync With Not Found");
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
                log.Error("SQL Error in GetCountryListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetCountryListAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("GetCountryListAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Asynchronously returns a list of regions selected by a country or a single region.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="countryId">An EIDSS internal identifier for the country record.</param>
        /// <param name="regionId">An EIDSS internal identifier for the region record.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("RegionGetListAsync")]
        [CacheHttpGetAttribute(0, 0, false)]
        [ResponseType(typeof(List<RegionGetLookupModel>))]
        public async Task<IHttpActionResult> GetRegionListAsync([Required]string languageId = "en-US", [Required]long? countryId = null, long? regionId = null)
        {
            log.Info("GetRegionListAsync is called ");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.RegionGetLookupAsync(languageId, countryId, regionId);
                if (result == null)
                {
                    log.Info("Exiting  GetRegionListAsync With Not Found");
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
                log.Error("SQL Error in HttpStatusCode Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetRegionListAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("GetRegionListAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Asynchronously returns a list of rayons selected by a region or a single rayon.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="regionId">An EIDSS internal identifier for the region record.</param>
        /// <param name="rayonId">An EIDSS internal identifier for the rayon record.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("RayonGetListAsync")]
        [ResponseType(typeof(List<RayonGetLookupModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetRayonListAsync([Required]string languageId = "en-US", long? regionId = null, long? rayonId = null)
        {
            log.Info("GetRayonListAsync is called ");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.RayonGetLookupAsync(languageId, regionId, rayonId);
                if (result == null)
                {
                    log.Info("Exiting  GetRayonListAsync With Not Found");
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
                log.Error("SQL Error in GetRayonListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetRayonListAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("GetRayonListAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Asynchronously returns a list of settlements selected by a rayon or a single settlement.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="rayonId">An EIDSS internal identifier for the rayon record.</param>
        /// <param name="settlementId">An EIDSS internal identifier for the settlement record.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("SettlementGetListAsync")]
        [ResponseType(typeof(List<SettlementGetLookupModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetSettlementListAsync([Required]string languageId = "en-US", long? rayonId = null, long? settlementId = null)
        {
            log.Info("GetSettlementListAsync is called ");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {

                var result = await _repository.SettlementGetLookupAsync(languageId, rayonId, settlementId);
                if (result == null)
                {
                    log.Info("Exiting  GetSettlementListAsync With Not Found");
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
                log.Error("SQL Error in GetSettlementListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetSettlementListAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("GetSettlementListAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Asynchronously returns a list of postal codes selected by a settlement.
        /// </summary>
        /// <param name="settlementId">An EIDSS internal identifier for the settlement.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("PostalCodeGetListAsync")]
        [ResponseType(typeof(List<PostalCodeGetLookupModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetPostalCodeListAsync(long? settlementId)
        {
            log.Info("GetPostalCodeListAsync is called ");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.PostalCodeGetLookupAsync(settlementId);
                if (result == null)
                {
                    log.Info("Exiting  GetPostalCodeListAsync With Not Found");
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
                log.Error("SQL Error in GetPostalCodeListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetPostalCodeListAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("GetPostalCodeListAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a list of rayons given the language culture and optionally the region.
        /// </summary>
        /// <param name="langId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="regionId">An EIDSS specific region identifier used to restrict results</param>
        /// <param name="id"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("RayonList")]
        [ResponseType(typeof(List<RayonGetLookupModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetRayonList(string langId, long? regionId, long? id)
        {
            log.Info("GetRayonList is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.RayonGetLookupAsync(langId, regionId = null, id = null);
                if (result == null)
                {
                    log.Info("Exiting  GetRayonList With Not Found");
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
                log.Error("SQL Error in GetRayonList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetRayonList failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("GetRayonList returned");
            return Ok(returnResult);
        }

        #endregion

        #region Flexible Form Methods

        //USP_ADMIN_FF_ParameterFixedPresetValue_SET
        //USP_ADMIN_FF_ParameterFixedPresetValue_DEL

        //USP_ADMIN_FF_ParameterTypes_SET



        /// <summary>
        /// Adds Flexible Forms Parameters
        /// </summary>
        /// <param name="adminActivityFFFormsSetParams"></param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of response objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>
        [HttpPost, Route("FlexibleFormParameterTypeSet")]
        [ResponseType(typeof(List<AdminFfActivityParametersSetModel>))]
        public async Task<IHttpActionResult> FlexibleFormParameterTypeSet(AdminActivityFFFormsSetParams adminActivityFFFormsSetParams)
        {
            log.Info("FlexibleFormParameterTypeSet is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.AdminFfActivityParametersSetAsync(
                    adminActivityFFFormsSetParams.idfsParameter,
                    adminActivityFFFormsSetParams.idfObservation, 
                    adminActivityFFFormsSetParams.idfsFormTemplate,
                    adminActivityFFFormsSetParams.varValue,
                    adminActivityFFFormsSetParams.isDynamicParameter,
                    adminActivityFFFormsSetParams.idfRow,
                    adminActivityFFFormsSetParams.idfActivityParameters
                    );

                if (result == null)
                {
                    log.Info("Exiting  FlexibleFormParameterTypeSet With Not Found");
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
                log.Error("SQL Error in FlexibleFormParameterTypeSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("FlexibleFormParameterTypeSet failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("FlexibleFormParameterTypeSet returned");
            return Ok(returnResult);
        }




        /*
        //USP_ADMIN_FF_ParameterTypes_DEL
        /// <summary>
        /// Deletes an Parameter Type if not currently being used
        /// </summary>
        /// <param name="idfsParameterType">A unique idenfier that identifies the campaign to delete.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        //[HttpPost, Route("FlexibleFormParameterTypeDelete")]
        //[ResponseType(typeof(List<AdminFfParameterTypesDelModel>))]
        //public async Task<IHttpActionResult> FlexibleFormParameterTypeDelete(long idfsParameterType)
        //{
        //    log.Info("FlexibleFormParameterTypeDelete is called");
        //    APIReturnResult returnResult = new APIReturnResult();
        //    try
        //    {
        //        var result = await _repository.AdminFfParameterTypesDelAsync(idfsParameterType);
        //        if (result == null)
        //        {
        //            log.Info("Exiting  FlexibleFormParameterTypeDelete With Not Found");
        //            returnResult.ErrorMessage = HttpStatusCode.BadRequest.ToString();
        //            returnResult.ErrorCode = HttpStatusCode.BadRequest;
        //        }
        //        else
        //        {
        //            returnResult.ErrorCode = HttpStatusCode.OK;
        //            returnResult.ErrorMessage = HttpStatusCode.OK.ToString();
        //            returnResult.Results = JsonConvert.SerializeObject(result);
        //        }
        //    }
        //    catch (SqlException ex)
        //    {
        //        log.Error("SQL Error in FlexibleFormParameterTypeDelete Procedure: " + ex.Procedure, ex);
        //        returnResult.ErrorMessage = ex.Message;
        //        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        //    }
        //    catch (Exception e)
        //    {
        //        log.Error("FlexibleFormParameterTypeDelete failed", e);
        //        returnResult.ErrorMessage = e.Message;
        //        returnResult.ErrorCode = HttpStatusCode.InternalServerError;
        //    }
        //    log.Info("FlexibleFormParameterTypeDelete returned");
        //    return Ok(returnResult);
        //}
        */

        /// <summary>
        /// Retrieves a list of fixed preset values with optional filter idfsParameterType
        /// </summary>
        /// <param name="langId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsParameterType">An EIDSS specific parameter type identifier used to restrict results</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [Route("FlexibleFormsParameterFixedPresetValueList")]
        [ResponseType(typeof(List<AdminFfParameterFixedPresetValueGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetFlexibleFormsParameterFixedPresetValueList(string langId, long? idfsParameterType)
        {
            log.Info("GetFlexibleFormsParameterFixedPresetValueList is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.AdminFfParameterFixedPresetValueGetListAsync(idfsParameterType, langId);
                if(result == null)
                {
                    log.Info("Exiting  FlexibleFormParameterTypeDelete With Not Found");
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
                log.Error("SQL Error in FlexibleFormParameterTypeDelete Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("FlexibleFormParameterTypeDelete failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("FlexibleFormParameterTypeDelete returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrieves a list of flexible forms parameter  types using searchstring against defaultname, national name
        /// </summary>
        /// <param name="langId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="searchString">An EIDSS specific search filter that is used against Default Name, National Name </param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("FlexibleFormsParameterTypeFilterAsync")]
        [ResponseType(typeof(List<AdminFfParameterTypesFilterModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetFlexibleFormsParameterTypeFilterAsync(string langId, string searchString)
        {
            log.Info("GetFlexibleFormsParameterTypeFilterAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.AdminFfParameterTypesFilterAsync(langId, searchString);
                if (result == null)
                {
                    log.Info("Exiting  GetFlexibleFormsParameterTypeFilterAsync With Not Found");
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
                log.Error("SQL Error in GetFlexibleFormsParameterTypeFilterAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetFlexibleFormsParameterTypeFilterAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("GetFlexibleFormsParameterTypeFilterAsync returned");
            return Ok(returnResult);
        }


        /// <summary>
        /// Retrieves a list of flexible forms parameter  types given the reference type filering identifier
        /// </summary>
        /// <param name="langId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsParameterType">An EIDSS specific parameter type identifier used to restrict results</param>
        /// <param name="onlyLists">Restricts the search to display list based data only</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("FlexibleFormsParameterTypeListAsync")]
        [ResponseType(typeof(List<AdminFfParameterTypesGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetFlexibleFormsParameterTypeListAsync( string langId, long? idfsParameterType, bool? onlyLists  )
        {
            log.Info("GetFlexibleFormsParameterTypeGetListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.AdminFfParameterTypesGetListAsync(langId, idfsParameterType, onlyLists);
                if (result == null)
                {
                    log.Info("Exiting  GetFlexibleFormsParameterTypeGetListAsync With Not Found");
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
                log.Error("SQL Error in GetFlexibleFormsParameterTypeGetListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetFlexibleFormsParameterTypeGetListAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("GetFlexibleFormsParameterTypeGetListAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrieves a list of flexible forms Parameter reference types
        /// </summary>
        /// <param name="langId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [Route("FlexibleFormsReferenceTypesListAsync")]
        [ResponseType(typeof(List<AdminFfParameterReferenceTypesGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetFlexibleFormsReferenceTypesListAsync(string langId)
        {
            log.Info("GetFlexibleFormsReferenceTypesListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.AdminFfParameterReferenceTypesGetListAsync(langId);
                log.Info("GetFlexibleFormsReferenceTypesListAsync returned");
                if (result == null)
                {
                    log.Info("Exiting  GetFlexibleFormsParameterTypeFilterAsync With Not Found");
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
                log.Error("SQL Error in GetFlexibleFormsReferenceTypesListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetFlexibleFormsReferenceTypesListAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("GetFlexibleFormsReferenceTypesListAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrieves a list of flexible forms parameter type references dropdown filtered by idfsReferenceType
        /// </summary>
        /// <param name="langId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="idfsReferenceType"></param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of response objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>
        [Route("FlexibleFormsReferenceTypesDetailsAsync")]
        [ResponseType(typeof(List<AdminFfParameterReferenceTypesGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetFlexibleFormsReferenceTypesDetailAsync(string langId, long? idfsReferenceType )
        {
            log.Info("GetFlexibleFormsReferenceTypesDetailAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.AdminFfParameterReferenceTypesGetDetailAsync(langId, idfsReferenceType);
                if (result == null)
                {
                    log.Info("Exiting  GetFlexibleFormsReferenceTypesDetailAsync With Not Found");
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
                log.Error("SQL Error in GetFlexibleFormsReferenceTypesDetailAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetFlexibleFormsReferenceTypesDetailAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("GetFlexibleFormsReferenceTypesDetailAsync returned");
            return Ok(returnResult);
        }




        /// <summary>
        /// Returns Id of Flexible Form Template
        /// </summary>
        /// <param name="idfsDiagnosis"></param>
        /// <param name="idfsFormType"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("AdminFlexibleFormTemplateGet")]
        [ResponseType(typeof(List<AdminFfFormTemplateGetModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> AdminFlexibleFormTemplateGet(long idfsDiagnosis, long? idfsFormType)
        {
            log.Info("AdminFlexibleFormTemplateGet is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.AdminFfFormTemplateGetAsync(idfsDiagnosis, idfsFormType);
                if (result == null)
                {
                    log.Info("Exiting  AdminFlexibleFormTemplateGet With Not Found");
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
                log.Error("SQL Error in AdminFlexibleFormTemplateGet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("AdminFlexibleFormTemplateGet failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("AdminFlexibleFormTemplateGet returned");
            return Ok(returnResult);
        }


        /// <summary>
        /// Sets A Flexible Form Label
        /// </summary>
        /// <param name="adminFFLabelSetParams">JSON Request Object</param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of response objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>
        [Route("AdminFlexibleFormsLabelSet")]
        [ResponseType(typeof(List<AdminFfLabelSetModel>))]
        public async Task<IHttpActionResult> AdminFlexibleFormsLabelSet(AdminFFLabelSetParams adminFFLabelSetParams)
        {
            log.Info("AdminFlexibleFormsLabelSet is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
             
                var result = await _repository.AdminFfLabelSetAsync(
                    adminFFLabelSetParams.langId, 
                    adminFFLabelSetParams.idfsFormTemplate, 
                    adminFFLabelSetParams.idfsSection, 
                    adminFFLabelSetParams.intLeft, 
                    adminFFLabelSetParams.intTop, 
                    adminFFLabelSetParams.intWidth, 
                    adminFFLabelSetParams.intHeight, 
                    adminFFLabelSetParams.intFontStyle, 
                    adminFFLabelSetParams.intFontSize, 
                    adminFFLabelSetParams.intColor, 
                    adminFFLabelSetParams.defaultText, 
                    adminFFLabelSetParams.nationalText
                    );

                if (result == null)
                {
                    log.Info("AdminFlexibleFormsLabelSet Not Found");
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
                log.Error("SQL Error in AdminFlexibleFormsLabelSet Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("AdminFlexibleFormsLabelSet failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("AdminFlexibleFormsLabelSet returned");
            return Ok(returnResult);
        }




        #endregion

        //TODO: DOES THIS NEED TO MOVE TO THE BASE REFERENCE CONTROLLER?? - SHL
        /// <summary>
        /// Returns a list of base reference records for a given language, reference type and accessory code.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="referenceTypeName">An EIDSS specific reference type</param>
        /// <param name="accessoryCode"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("BaseReferenceList")]
        [ResponseType(typeof(List<GblLkupBaseRefGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetBaseReferenceList([Required]string languageId, [Required]string referenceTypeName, int accessoryCode)
        {
            log.Info("GetBaseReferenceList is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.GblLkupBaseRefGetListAsync(languageId, referenceTypeName, accessoryCode);
                if (result == null)
                {
                    log.Info("GetBaseReferenceList  Not Found");
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
                log.Error("SQL Error in GetBaseReferenceList Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetBaseReferenceList failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("GetBaseReferenceList returned");
            return Ok(returnResult);
        }

        #region Organization Methods

        /// <summary>
        /// Returns a list of organization records for a given language, organization, organization type, accessory code or location.
        /// </summary>
        /// <param name="parameters"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>

        [HttpPost, Route("OrganizationGetListAsync")]
        [ResponseType(typeof(List<GblOrganizationGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetOrganizationListAsync([FromBody] OrganizationGetListParams parameters)
        {
            log.Info("GetOrganizationListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                int pageSize = 10;
                int maxPagesPerFetch = 10;

                var result = await _repository.GblOrganizationGetListAsync(
                    parameters.LanguageID, 
                    parameters.OrganizationID, 
                    parameters.EIDSSOrganizationID, 
                    parameters.OrganizationAbbreviatedName, 
                    parameters.OrganizationFullName, 
                    parameters.AccessoryCode, 
                    parameters.SiteID, 
                    parameters.RegionID, 
                    parameters.RayonID, 
                    parameters.SettlementID, 
                    parameters.OrganizationTypeID,
                    parameters.PaginationSetNumber,
                    pageSize,
                    maxPagesPerFetch);
                if (result == null)
                {
                    log.Info("GetOrganizationListAsync  Not Found");
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
                log.Error("SQL Error in GetOrganizationListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetOrganizationListAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("GetOrganizationListAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Returns a count for a list of organization records for a given language, organization, organization type, accessory code or location.
        /// </summary>
        /// <param name="parameters"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("OrganizationGetListCountAsync")]
        [ResponseType(typeof(List<GblOrganizationGetCountModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetOrganizationListCountAsync([FromBody] OrganizationGetListParams parameters)
        {
            log.Info("GetOrganizationListCountAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.GblOrganizationGetCountAsync(
                    parameters.LanguageID,
                    parameters.OrganizationID,
                    parameters.EIDSSOrganizationID,
                    parameters.OrganizationAbbreviatedName,
                    parameters.OrganizationFullName,
                    parameters.AccessoryCode,
                    parameters.SiteID,
                    parameters.RegionID,
                    parameters.RayonID,
                    parameters.SettlementID,
                    parameters.OrganizationTypeID);

                if (result == null)
                {
                    log.Info("Exiting  GetOrganizationListCountAsync With Not Found");
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
                log.Error("SQL Error in GetOrganizationListCountAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetOrganizationListCountAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("GetOrganizationListCountAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrives a list of laboratory samples designated as favorites by a user and stored in the user profile settings.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 language code used to restrict data to a specific country.</param>
        /// <param name="organizationTypeID">An EIDSS interal user identifier for the organization type (hospital, laboratory, etc) to be returned.</param>
        /// <returns>
        /// On success a 200 OK status is returned along with a collection of response objects.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>

        [HttpGet, Route("OrganizationByTypeGetListAsync")]
        [ResponseType(typeof(List<GblOrganizationByTypeGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetOrganizationByTypeListAsync([Required]string languageID, [Required]long organizationTypeID)
        {
            log.Info("GetOrganizationByTypeListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                // Call the database.
                var result = await _repository.GblOrganizationByTypeGetListAsync(languageID, organizationTypeID);

                if (result == null)
                {
                    log.Info("Exiting  GetOrganizationByTypeListAsync With Not Found");
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
                log.Error("SQL Error in GetOrganizationByTypeListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetOrganizationByTypeListAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("GetOrganizationByTypeListAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Adds and updates organization records for the administration and laboratory modules.
        /// </summary>
        /// <param name="parameters">A collection of parameters that represents the data to post.</param>
        /// <returns>
        /// On success a 200 OK status is returned along with a response object.
        /// On failure a 500 Internal Server Error is returned along with details of the failure.
        /// A 404 Not Found status code is returned when no results could be found.
        /// </returns>
        [HttpPost, Route("OrganizationSave")]
        [ResponseType(typeof(OrganizationSetResult))]
        public IHttpActionResult SaveOrganization([FromBody]OrganizationSetParam parameters)
        {
            log.Info("SaveOrganization is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = _repository.GblOrganizationSet(
                    parameters.LangId,
                    out long? organizationId,
                    parameters.EnglishName,
                    parameters.EnglishFullName,
                    parameters.Name,
                    parameters.FullName,
                    parameters.ContactPhone,
                    parameters.CurrentCustomizationId,
                    parameters.AccessoryCode,
                    parameters.OrganizationCode,
                    parameters.OrderNumber,
                    out long? locationId,
                    parameters.CountryId,
                    parameters.RegionId,
                    parameters.RayonId,
                    parameters.SettlementId,
                    parameters.Apartment,
                    parameters.Building,
                    parameters.StreetName,
                    parameters.House,
                    parameters.PostalCode,
                    parameters.ForeignAddressIndicator,
                    parameters.ForeignAddress,
                    parameters.Latitude,
                    parameters.Longitude,
                    parameters.SharedLocationIndicator);
                if (result == null)
                {
                    log.Info("SaveOrganization Not Found");
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
                log.Error("SQL Error in SaveOrganization Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("SaveOrganization failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("GetFlexibleFormsParameterTypeFilterAsync returned");
            return Ok(returnResult);
        }

        #endregion

        #region Department Methods

        /// <summary>
        /// Returns a list of departments for a given language, organization and/or department identifiers.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="organizationId">An EIDSS internal identifier for the organization</param>
        /// <param name="departmentId">An EIDSS internal identifier for the department/functional area</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("DepartmentGetListAsync")]
        [ResponseType(typeof(List<GblDepartmentGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetDepartmentListAsync([Required]string languageId, long? organizationId, long? departmentId)
        {
            log.Info("GetDepartmentListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.GblDepartmentGetListAsync(languageId, organizationId, departmentId);
                if (result == null)
                {
                    log.Info("GetDepartmentListAsync  Not Found");
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
                log.Error("SQL Error in GetDepartmentListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetDepartmentListAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("GetDepartmentListAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Adds and updates department records for the administration and laboratory modules.
        /// </summary>
        /// <param name="parameters">A collection of parameters that represents the data to post.</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpPost, Route("DepartmentSave")]
        [ResponseType(typeof(DepartmentSetResult))]
        public IHttpActionResult SaveDepartment([FromBody]DepartmentSetParam parameters)
        {
            log.Info("SaveDepartment is called");

            SPReturnResult resultCode = null;

            try
            {
                var result = _repository.GblDepartmentSet(
                    parameters.LanguageId,
                    out long? departmentId,
                    parameters.OrganizationId,
                    parameters.DefaultName,
                    parameters.NationalName,
                    parameters.CountryID,
                    parameters.UserName,
                    parameters.Action);

                resultCode = new SPReturnResult(result);
            }
            catch (Exception e)
            {
                log.Error("SaveDepartment failed", e);
                return InternalServerError(e);
            }

            log.Info("SaveDepartment returned");
            return Ok(resultCode);
        }

        #endregion

        #region Sample Methods

        /// <summary>
        /// Retrives a list of sample records by disease report, monitoring session identifiers.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="humanDiseaseReportID">An EIDSS Identifier for the human disease report</param>
        /// <param name="veterinaryDiseaseReportID">An EIDSS Identifier for the veterinary disease report</param>
        /// <param name="rootSampleID">An EIDSS identifier for the root sample</param>
        /// <param name="monitoringSessionID">An EIDSS identifier for the active surveillance monitoring session</param>
        /// <param name="vectorSessionID">An EIDSS identifier for the vector surveillance session</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("SampleGetListAsync")]
        [ResponseType(typeof(List<GblSampleGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetSampleListAsync([Required]string languageID, long? humanDiseaseReportID, long? veterinaryDiseaseReportID, long? rootSampleID, long? monitoringSessionID, long? vectorSessionID)
        {
            log.Info("GetSampleListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.GblSampleGetListAsync(languageID, humanDiseaseReportID, veterinaryDiseaseReportID, rootSampleID, monitoringSessionID, vectorSessionID);
                if (result == null)
                {
                    log.Info("Exiting  GetSampleListAsync With Not Found");
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
                log.Error("SQL Error in GetSampleListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetSampleListAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("GetSampleListAsync returned");
            return Ok(returnResult);
        }

        #endregion

        #region Test Methods

        /// <summary>
        /// Retrives a list of test records by disease report, monitoring session and sample identifiers.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="humanDiseaseReportID">An EIDSS internal identifier for the human disease report</param>
        /// <param name="veterinaryDiseaseReportID">An EIDSS internal identifier for the veterinary disease report</param>
        /// <param name="monitoringSessionID">An EIDSS internal identifier for the active surveillance monitoring session</param>
        /// <param name="vectorSessionID">An EIDSS internal identifier for the vector surveillance session</param>
        /// <param name="sampleID">An EIDSS internal identifier for the sample</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("TestGetListAsync")]
        [ResponseType(typeof(List<GblTestGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetTestListAsync([Required]string languageID, long? humanDiseaseReportID, long? veterinaryDiseaseReportID, long? monitoringSessionID, long? vectorSessionID, long? sampleID)
        {
            log.Info("GetTestListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.GblTestGetListAsync(languageID, humanDiseaseReportID, veterinaryDiseaseReportID, monitoringSessionID, vectorSessionID, sampleID);
                if (result == null)
                {
                    log.Info("Exiting  GetTestListAsync With Not Found");
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
                log.Error("SQL Error in GetTestListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetTestListAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("GetTestListAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrives a list of test interpretation records by disease report, monitoring session and test identifiers.
        /// </summary>
        /// <param name="languageID">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="humanDiseaseReportID">An EIDSS internal identifier for the human disease report</param>
        /// <param name="veterinaryDiseaseReportID">An EIDSS internal identifier for the veterinary disease report</param>
        /// <param name="monitoringSessionID">An EIDSS internal identifier for the active surveillance monitoring session</param>
        /// <param name="vectorSessionID">An EIDSS internal identifier for the vector surveillance session</param>
        /// <param name="testID">An EIDSS internal identifier for the test</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("TestInterpretationGetListAsync")]
        [ResponseType(typeof(List<GblTestInterpretationGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetTestInterpretationListAsync([Required]string languageID, long? humanDiseaseReportID, long? veterinaryDiseaseReportID, long? monitoringSessionID, long? vectorSessionID, long? testID)
        {
            log.Info("GetTestInterpretationListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.GblTestInterpretationGetListAsync(languageID, humanDiseaseReportID, veterinaryDiseaseReportID, monitoringSessionID, vectorSessionID, testID);
                if (result == null)
                {
                    log.Info("Exiting  GetTestInterpretationListAsync With Not Found");
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
                log.Error("SQL Error in GetTestInterpretationListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetTestInterpretationListAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("GetTestInterpretationListAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Retrives a list of test by disease records.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="diseaseIdList">A list of EIDSS internal identifiers for the diseases associated with a test</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("TestByDiseaseGetListAsync")]
        [ResponseType(typeof(List<GblTestDiseaseGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetTestByDiseaseListAsync([Required]string languageId, [Required]string diseaseIdList)
        {
            log.Info("GetTestByDiseaseListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.GblTestDiseaseGetListAsync(languageId, diseaseIdList);
                if (result == null)
                {
                    log.Info("Exiting  GetTestByDiseaseListAsync With Not Found");
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
                log.Error("SQL Error in GetTestByDiseaseListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetTestByDiseaseListAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("GetTestByDiseaseListAsync returned");
            return Ok(returnResult);
        }

        #endregion

        #region Global Methods

        /// <summary>
        /// Gets information about a user based on SiteId and UserId  
        /// </summary>
        /// <param name="siteId"></param>
        /// <param name="userId"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("GetGlobalSiteDetails")]
        [ResponseType(typeof(List<GblSiteGetDetailModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetGlobalSiteDetails(int siteId, long? userId)
        {
            log.Info("Entering  GetGlobalSiteDetails");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.GblSiteGetDetailAsync(siteId, userId);
                if (result == null)
                {
                    log.Info("Exiting  GetGlobalSiteDetails With Not Found");
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
                log.Error("SQL Error in GetGlobalSiteDetails Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetGlobalSiteDetails failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("GetGlobalSiteDetails returned");
            return Ok(returnResult);

        }
        #endregion

        #region Notification Methods

        /// <summary>
        /// Retrives a list of notification records by notification object, site, and user identifiers.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <param name="notificationObjectTypeID">An EIDSS Identifier for the notification object type</param>
        /// <param name="siteID">An EIDSS Identifier for the site</param>
        /// <param name="targetSiteID">An EIDSS identifier for the target site</param>
        /// <param name="userID">An EIDSS identifier for the user</param>
        /// <param name="targetUserID">An EIDSS identifier for the target user</param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage , Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns>
        [HttpGet, Route("NotificationGetListAsync")]
        [ResponseType(typeof(List<GblNotificationGetListModel>))]
        [CacheHttpGetAttribute(0, 0, false)]
        public async Task<IHttpActionResult> GetNotificationListAsync([Required]string languageId, long? notificationObjectTypeID, long? siteID, long? targetSiteID, long? userID, long? targetUserID)
        {
            log.Info("GetNotificationListAsync is called");
            APIReturnResult returnResult = new APIReturnResult();
            try
            {
                var result = await _repository.GblNotificationGetListAsync(languageId, notificationObjectTypeID, siteID, targetSiteID, userID, targetUserID);
                if (result == null)
                {
                    log.Info("Exiting  GetNotificationListAsync With Not Found");
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
                log.Error("SQL Error in GetNotificationListAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception e)
            {
                log.Error("GetNotificationListAsync failed", e);
                returnResult.ErrorMessage = e.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }

            log.Info("GetNotificationListAsync returned");
            return Ok(returnResult);
        }

        /// <summary>
        /// Inserts/updates a notification record.
        /// </summary>
        /// <param name="parameters"></param>
        /// <returns>
        /// Returns and JSON OBJECT APIReturnResult with Properties: ReturnCode, ReturnMessage, Results
        /// ReturnCode = 200 is  success  OK status is returned along with a collection of response objects.
        /// ReturnCode = 500 is  failure  Internal Server Error is returned along with details of the failure.
        /// ReturnCode = 404 is  failure  Not Found status code is returned when no results could be found.
        /// ReturnMessage = Response message returned to client
        /// Results = JSON List of ResponseType Objects retrieved from Query
        /// </returns> 
        [HttpPost, Route("NotificationSaveAsync")]
        [ResponseType(typeof(List<GblNotificationSetModel>))]
        public async Task<IHttpActionResult> SaveNotificationAsync([FromBody] NotificationSetParameters parameters)
        {
            log.Info("SaveNotificationAsync is called");
            APIReturnResult returnResult = new APIReturnResult();

            try
            {
                var result = await _repository.GblNotificationSetAsync(parameters.LanguageID,
                    parameters.NotificationID,
                    parameters.NotificationTypeID,
                    parameters.UserID,
                    parameters.NotificationObjectID,
                    parameters.NotificationObjectTypeID,
                    parameters.TargetUserID,
                    parameters.TargetSiteID,
                    parameters.TargetSiteTypeID,
                    parameters.SiteID,
                    parameters.Payload,
                    parameters.LoginSite
                  );

                if (result == null)
                {
                    log.Info("Exiting  SaveNotificationAsync With Not Found");
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
                log.Error("SQL Error in SaveNotificationAsync Procedure: " + ex.Procedure, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            catch (Exception ex)
            {
                log.Error("Error in SaveNotificationAsync" + ex.Message, ex);
                returnResult.ErrorMessage = ex.Message;
                returnResult.ErrorCode = HttpStatusCode.InternalServerError;
            }
            log.Info("Exiting  SaveNotificationAsync");
            return Ok(returnResult);
        }

        #endregion
    }
}
