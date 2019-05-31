using OpenEIDSS.Domain.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public class AggCaseSetParams
    {
        [Optional]
        public long? idfAggrCase{get;set;}
        public string strCaseId{get;set;}
        [Optional]
        public long? idfsAggrCaseType{get;set;}
        [Optional]
        public long? idfsAdministrativeUnit{get;set;}
        [Optional]
        public long? idfReceivedByOffice{get;set;}
        [Optional]
        public long? idfReceivedByPerson{get;set;}
        [Optional]
        public long? idfSentByOffice{get;set;}
        [Optional]
        public long? idfSentByPerson{get;set;}
        [Optional]
        public long? idfEnteredByOffice{get;set;}
        [Optional]
        public long? idfEnteredByPerson{get;set;}
        [Optional]
        public long? idfCaseObservation{get;set;}
        [Optional]
        public long? idfsCaseObservationFormTemplate{get;set;}
        [Optional]
        public long? idfDiagnosticObservation{get;set;}
        [Optional]
        public long? idfsDiagnosticObservationFormTemplate{get;set;}
        [Optional]
        public long? idfProphylacticObservation{get;set;}
        [Optional]
        public long? idfsProphylacticObservationFormTemplate{get;set;}
        [Optional]
        public long? idfSanitaryObservation{get;set;}
        [Optional]
        public long? idfVersion{get;set;}
        [Optional]
        public long? idfDiagnosticVersion{get;set;}
        [Optional]
        public long? idfProphylacticVersion{get;set;}
        [Optional]
        public long? idfSanitaryVersion{get;set;}
        [Optional]
        public long? idfsSanitaryObservationFormTemplate{get;set;}
        [Optional]
        public System.DateTime? datReceivedByDate{get;set;}
        [Optional]
        public System.DateTime? datSentByDate{get;set;}
        [Optional]
        public System.DateTime? datEnteredByDate{get;set;}
        [Optional]
        public System.DateTime? datStartDate{get;set;}
        [Optional]
        public System.DateTime? datFinishDate{get;set;}
        [Optional]
        public System.DateTime? datModificationForArchiveDate { get; set; }
    }
}
