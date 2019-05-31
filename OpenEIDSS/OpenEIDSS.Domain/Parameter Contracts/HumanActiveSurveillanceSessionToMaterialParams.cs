using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OpenEIDSS.Domain.Attributes;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Parameter class that satisfies parameter values for the Human HumanActiveSurveillanceSessionToMaterial service method
    /// </summary>
    public class HumanActiveSurveillanceSessionToMaterialParams
    {
        public string langId{ get; set;}
        [Optional]
        public long? idfMaterial { get; set; }
        [Optional]
        public long? idfsSampleType{ get; set;}
        [Optional]
        public long? idfRootMaterial{ get; set;}
        [Optional]
        public long? idfParentMaterial{ get; set;}
        [Optional]
        public long? idfHuman{ get; set;}
        [Optional]
        public long? idfSpecies{ get; set;}
        [Optional]
        public long? idfAnimal{ get; set;}
        [Optional]
        public long? idfMonitoringSession{ get; set;}
        [Optional]
        public long? idfFieldCollectedByPerson{ get; set;}
        [Optional]
        public long? idfFieldCollectedByOffice{ get; set;}
        [Optional]
        public long? idfMainTest{ get; set;}
        [Optional]
        public System.DateTime? datFieldCollectionDate{ get; set;}
        [Optional]
        public System.DateTime? datFieldSentDate{ get; set;}
        public string strFieldBarcode{ get; set;}
        public string strCalculatedCaseId{ get; set;}
        public string strCalculatedHumanName{ get; set;}
        [Optional]
        public long? idfVectorSurveillanceSession{ get; set;}
        [Optional]
        public long? idfVector{ get; set;}
        [Optional]
        public long? idfSubdivision{ get; set;}
        [Optional]
        public long? idfsSampleStatus{ get; set;}
        [Optional]
        public long? idfInDepartment{ get; set;}
        [Optional]
        public long? idfDestroyedByPerson{ get; set;}
        [Optional]
        public System.DateTime? datEnteringDate{ get; set;}
        [Optional]
        public System.DateTime? datDestructionDate{ get; set;}
        public string strBarcode{ get; set;}
        public string strNote{ get; set;}
        [Optional]
        public long? idfsSite{ get; set;}
        [Optional]
        public int? intRowStatus{ get; set;}
        [Optional]
        public long? idfSendToOffice{ get; set;}
        [Optional]
        public bool? blnReadOnly{ get; set;}
        [Optional]
        public long? idfsBirdStatus{ get; set;}
        [Optional]
        public long? idfHumanCase{ get; set;}
        [Optional]
        public long? idfVetCase{ get; set;}
        [Optional]
        public System.DateTime? datAccession{ get; set;}
        [Optional]
        public long? idfsAccessionCondition{ get; set;}
        public string strCondition{ get; set;}
        [Optional]
        public long? idfAccesionByPerson{ get; set;}
        [Optional]
        public long? idfsDestructionMethod{ get; set;}
        [Optional]
        public long? idfsCurrentSite{ get; set;}
        [Optional]
        public long? idfsSampleKind{ get; set;}
        [Optional]
        public long? idfMarkedForDispositionByPerson{ get; set;}
        [Optional]
        public System.DateTime? datOutOfRepositoryDate{ get; set;}
        public string strMaintenanceFlag{ get; set;}
        public string recordAction { get; set; }

    }
}
