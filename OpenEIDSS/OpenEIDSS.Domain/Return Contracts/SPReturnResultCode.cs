using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Return_Contracts
{
    /// <summary>
    /// Stored procedure return results container that contains the status code of the execution for stored procedures
    /// that change the state of the system; e.g., Update and Delete SPs.
    /// </summary>
    public class SPReturnResult
    {
        /// <summary>
        /// An integer that indicates the state of the call.  If the value returned = 0, the call succeeded, otherwise
        /// the value will contain the error code that was generated during execution.
        /// </summary>
        public int ReturnCode { get; set; }

        /// <summary>
        /// Specifies the results of the call.  When the call succeeds, this message should specify "SUCCESS", however when a failure occurs, this property should contain the error that occurred in the database.
        /// </summary>
        public string ReturnMessage { get; set; }

        /// <summary>
        /// Indicates whether the call succeeded.  This is determined by the value of the return code.
        /// </summary>
        public bool IsSuccess { get { return (ReturnCode == 0); } }

        /// <summary>
        /// Instantiates a new instance of the SPReturnResult class
        /// </summary>
        /// <param name="resultCode"></param>
        public SPReturnResult( int resultCode )
        {
            this.ReturnCode = resultCode;
        }
    }
}
