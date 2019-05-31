using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Return_Contracts
{
    public class APIReturnResult
    {
        public string ErrorMessage { get; set; }
        public HttpStatusCode ErrorCode { get; set; }
        public string Results { get; set; }

    }
    public class APIReturnResultDataTables
    {
        public string ErrorMessage { get; set; }
        public HttpStatusCode ErrorCode { get; set; }
        public string data { get; set; }

    }
}
