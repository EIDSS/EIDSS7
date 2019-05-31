using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Return_Contracts
{
    /// <summary>
    /// Result returned from a call to the OMMSessionSet service method that specifies the state of the call.
    /// </summary>
    public class OMMSessionNoteSetResult : SPReturnResult
    {
        /// <summary>
        /// The idfOutbreakNote returned from a call to the USP_OMM_SESSION_Note_Set stored procecure
        /// </summary>
        public long? OutbreakNoteId { get; set; }

        /// <summary>
        /// Instantiates a new instance of the OMMSessionSetResult class and sets the result code and outbreak note id
        /// </summary>
        /// <param name="resultCode"></param>
        /// <param name="idfOutbreakNote"></param>
        public OMMSessionNoteSetResult(int resultCode, long? idfOutbreakNote) : base(resultCode)
        {
            this.OutbreakNoteId = idfOutbreakNote;
        }
    }
}