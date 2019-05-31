using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Extensions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using System.Web.Http.Results;
using WebApi.OutputCache.V2;

namespace OpenEIDSS.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    [ApiExplorerSettings(IgnoreApi = true)]
    [RoutePrefix("api/Country")]
    public class CountryController : ApiController
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(CountryController));

        private IEIDSSRepository _repository = new EIDSSRepository();

        // Synchronous sample:
        //public HttpResponseMessage GetCountryList()
        //{
        //    var list = _repository.CountryGetLookup("en-US");

        //    if (list == null)
        //        return Request.CreateResponse(HttpStatusCode.NotFound);

        //    return Request.CreateResponse<List<CountryGetLookupModel>>(HttpStatusCode.OK, list);

        //}

        //public CountryController()
        //{

        //}

        /// <summary>
        /// Creates a new instance of this class
        /// </summary>
        public CountryController()
        {
        }


    }
}
