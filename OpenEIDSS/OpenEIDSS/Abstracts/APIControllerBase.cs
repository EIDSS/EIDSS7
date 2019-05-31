using OpenEIDSS.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;

namespace OpenEIDSS.Abstracts
{
    /// <summary>
    /// 
    /// </summary>
    public class APIControllerBase : ApiController 
    {
        // logging...
        static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(APIControllerBase));

        private IEIDSSRepository repository;
        private long _eidssuserid;

        protected IEIDSSRepository _repository
        {
            get { return repository; }
        }

        private long EIDSSUserID
        {
            get { return _eidssuserid; }
        }

        /// <summary>
        /// Initializes a new instance of the class.
        /// </summary>
        public APIControllerBase() : base()
        {
            repository = new EIDSSRepository();
            //_init();
        }

        /// <summary>
        /// Initializes a new instance of the class.
        /// </summary>
        /// <param name="connectionString"></param>
        public APIControllerBase( string connectionString )
        {
            repository = new EIDSSRepository(connectionString);
            //_init();
        }

        /// <summary>
        /// </summary>
        private void _init()
        {
            IEnumerable<string> headerValues;
            if( Request != null && Request.Headers.TryGetValues("USERID", out headerValues))
                _eidssuserid = Convert.ToInt64(headerValues.FirstOrDefault());
            else _eidssuserid = 0;
        }

    }
}