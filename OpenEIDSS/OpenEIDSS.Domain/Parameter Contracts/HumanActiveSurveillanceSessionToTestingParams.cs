using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class HumanActiveSurveillanceSessionToTestingParams
    {
        public string langId {get; set;}
        public  long? idfsTestName {get; set;}
        public long? idfsTesting { get; set; }
        public  long? idfsTestCategory {get; set;}
        public  long? idfsTestResult {get; set;}
        public  long? idfsTestStatus {get; set;}
        public  long? idfsDiagnosis {get; set;}
        public  long? idfMaterial {get; set;}
        public  long? idfBatchTest {get; set;}
        public  long? idfObservation {get; set;}
        public  int? intTestNumber {get; set;}
        public  string strNote {get; set;}
        public  int? intRowStatus {get; set;}
        public  System.DateTime? datStartedDate {get; set;}
        public  System.DateTime? datConcludedDate {get; set;}
        public  long? idfTestedByOffice {get; set;}
        public  long? idfTestedByPerson {get; set;}
        public  long? idfResultEnteredByOffice {get; set;}
        public  long? idfResultEnteredByPerson {get; set;}
        public  long? idfValidatedByOffice {get; set;}
        public  long? idfValidatedByPerson {get; set;}
        public  bool? blnReadOnly {get; set;}
        public  bool? blnNonLaboratoryTest {get; set;}
        public  bool? blnExternalTest {get; set;}
        public  long? idfPerformedByOffice {get; set;}
        public  System.DateTime? datReceivedDate {get; set;}
        public  string strContactPerson {get; set;}
        public  string strMaintenanceFlag {get; set;}
        public  string recordAction { get; set; }

    }
}
