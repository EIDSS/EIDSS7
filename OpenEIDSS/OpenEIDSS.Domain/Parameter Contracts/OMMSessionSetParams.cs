using System;
using System.Collections.Generic;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    public sealed class OMMSessionSetParams
    {
        public string langId { get; set; }
        public long? idfOutbreak { get; set; }
        public long? idfsDiagnosisOrDiagnosisGroup { get; set; }
        public long? idfsOutbreakStatus { get; set; }
        public long? OutbreakTypeId { get; set; }
        public long? outbreakLocationidfsCountry { get; set; }
        public long? outbreakLocationidfsRegion { get; set; }
        public long? outbreakLocationidfsRayon { get; set; }
        public long? outbreakLocationidfsSettlement { get; set; }
        public DateTime? datStartDate { get; set; }
        public DateTime? datCloseDate { get; set; }
        public string strOutbreakID { get; set; }
        public string strDescription { get; set; }
        public int intRowStatus { get; set; }
        public DateTime? datModificationForArchiveDate { get; set; }
        public long? idfPrimaryCaseOrSession { get; set; }
        public long idfsSite { get; set; }
        public string strMaintenanceFlag { get; set; }
        public string strReservedAttribute { get; set; }
        public List<OMMParameters> OutbreakParameters { get; set; }
    }

    public sealed class OMMParameters
    {
        public long OutbreakSpeciesParameterUID { get; set; }
        public long idfOutbreak { get; set; }
        public long OutbreakSpeciesTypeID { get; set; }
        public int? CaseMonitoringDuration { get; set; }
        public int? CaseMonitoringFrequency { get; set; }
        public int? ContactTracingDuration { get; set; }
        public int? ContactTracingFrequency { get; set; }
        public int? intRowStatus { get; set; }
        public string AuditCreateUser { get; set; }
        public DateTime? AuditCreateDTM { get; set; }
        public string AuditUpdateUser { get; set; }
        public DateTime? AuditUpdateDTM { get; set; }
        public long? CaseQuestionaireTemplateID { get; set; }
        public long? CaseMonitoringTemplateID { get; set; }
        public long? ContactTracingTemplateID { get; set; }
    }
}