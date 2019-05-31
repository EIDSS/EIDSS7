using OpenEIDSS.Data;
using OpenEIDSS.Domain;
using OpenEIDSS.Domain.Parameter_Contracts;
using OpenEIDSS.Domain.Return_Contracts;
using OpenEIDSS.Extensions;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
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
    public class LoggingController : ApiController
    {

        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(LoggingController));
        private IEIDSSRepository _repository = new EIDSSRepository();

        /// <summary>
        /// 
        /// </summary>
        public LoggingController()
        {
        }



    }
}
