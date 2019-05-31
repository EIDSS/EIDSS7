using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Return_Contracts
{
    public sealed class HumanActiveSurveillanceSessionToMaterialResult : SPReturnResult
    {
        /// <summary>
        /// The Mmaterial identifier returned when a call is made to the USSP_GBL_MATERIAL_SET stored procedure.
        /// </summary>
        public long? MaterialId { get; set; }

        public HumanActiveSurveillanceSessionToMaterialResult( int resultCode, long? idfMaterial ) :base(resultCode)
        {
            this.MaterialId = idfMaterial;
        }
    }
}
