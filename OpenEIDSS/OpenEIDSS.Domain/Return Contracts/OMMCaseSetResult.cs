using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Return_Contracts
{
    /// <summary>
    /// Result returned from a call to the OMMCaseSetAsync service method that specifies the state of the call.
    /// </summary>
    public class OMMCaseSetResult : SPReturnResult
    {
        /// <summary>
        /// The OutBreakCaseReportUID returned from a call to the USP_OMM_Case_Set stored procecure
        /// </summary>
        public long? OutBreakCaseReportUID { get; set; }

        /// <summary>
        /// The strOutbreakCaseID returned from a call to the USP_OMM_Case_Set stored procecure
        /// </summary>
        public string strOutbreakCaseID { get; set; }

        /// <summary>
        /// Instantiates a new instance of the OMMCaseSetResult class and sets the result code and outbreak note id
        /// </summary>
        /// <param name="resultCode"></param>
        /// <param name="resultMessage"></param>
        /// <param name="OutBreakCaseReportUID"></param>
        public OMMCaseSetResult(int resultCode, long? OutBreakCaseReportUID, string strOutbreakCaseID) : base(resultCode)
        {
            this.OutBreakCaseReportUID = OutBreakCaseReportUID;
            this.strOutbreakCaseID = strOutbreakCaseID;
        }
    }
}
