using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Domain.Return_Contracts;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// Provides functionality that cuts across many operational areas, but specifically relates to reference type data.
    /// ...
    /// </summary>
    [RoutePrefix("api/Reference")]
    public class ReferenceController : ApiController
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(ReferenceController));

        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// Creates a new instance of this class.
        /// </summary>
        public ReferenceController()
        {
        }

        #region Age Group Methods

        /// <summary>
        /// Returns a list of age group reference records for a given language.
        /// </summary>
        /// <param name="languageId">A standard ISO 639-1 Language Code used to restrict data to a specific country</param>
        /// <returns></returns>
        [HttpGet, Route("AgeGroupList")]
        [ResponseType(typeof(List<RefAgegroupGetListModel>))]
        public async Task<IHttpActionResult> GetAgeGroupList(string languageId)
        {
            try
            {
                log.Info("GetAgeGroupList is called");
                var result = await _repository.RefAgegroupGetListAsync(languageId);

                if (result == null)
                    return NotFound();

                log.Info("GetAgeGroupList returned");
                return Ok(result);
            }
            catch (Exception e)
            {
                log.Error("GetAgeGroupList failed", e);
                return InternalServerError(e);
            }
        }

        /// <summary>
        /// Returns a boolean value indicating if the age group can be deleted.
        /// </summary>
        /// <param name="ageGroupTypeId">The reference type ID for the age group type</param>
        /// <returns></returns>
        [HttpGet, Route("CanDeleteAgeGroup")]
        [ResponseType(typeof(RefAgegroupCandelModel))]
        public async Task<IHttpActionResult> CanDeleteAgeGroup(long ageGroupTypeId)
        {
            try
            {
                log.Info("CanDeleteAgeGroup is called");
                var result = await _repository.RefAgegroupCandelAsync(ageGroupTypeId);

                if (result == null)
                    return NotFound();

                log.Info("CanDeleteAgeGroup returned");
                return Ok(result);
            }
            catch (Exception e)
            {
                log.Error("CanDeleteAgeGroup failed", e);
                return InternalServerError(e);
            }
        }

        /// <summary>
        /// Returns a boolean value indicating if the age group exists.
        /// </summary>
        /// <param name="name">The name of the age group type</param>
        /// <returns></returns>
        [HttpGet, Route("DoesAgeGroupExist")]
        [ResponseType(typeof(RefAgegroupDoesexistModel))]
        public async Task<IHttpActionResult> DoesAgeGroupExist(string name)
        {
            try
            {
                log.Info("DoesAgeGroupExist is called");
                var result = await _repository.RefAgegroupDoesexistAsync(name);

                if (result == null)
                    return NotFound();

                log.Info("DoesAgeGroupExist returned");
                return Ok(result);
            }
            catch (Exception e)
            {
                log.Error("DoesAgeGroupExist failed", e);
                return InternalServerError(e);
            }
        }

        /// <summary>
        /// Adds and updates age group reference records for the administration module.
        /// </summary>
        /// <param name="parameters">A collection of parameters that represents the data to post.</param>
        /// <returns></returns>
        [HttpPost, Route("AgeGroupSet")]
        [ResponseType(typeof(SPReturnResult))]
        public IHttpActionResult AgeGroupSet([FromBody]AgeGroupSetParam parameters)
        {
            SPReturnResult resultCode = null;
            try
            {
                log.Info("AgeGroupSet is called");

                var result = _repository.RefAgegroupSet(
                    out long? ageGroupId,
                    parameters.DefaultName,
                    parameters.NationalName,
                    parameters.LowerBoundary,
                    parameters.UpperBoundary,
                    parameters.AgeTypeID,
                    parameters.LanguageId,
                    parameters.Order);

                resultCode = new SPReturnResult(result);
            }
            catch (Exception e)
            {
                log.Error("AgeGroupSet failed", e);
                return InternalServerError(e);
            }
            log.Info("AgeGroupSet returned");
            return Ok(resultCode);
        }

        #endregion
    }
}
