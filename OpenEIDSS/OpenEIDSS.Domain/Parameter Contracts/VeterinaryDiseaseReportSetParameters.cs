using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace OpenEIDSS.Domain.Parameter_Contracts
{
    /// <summary>
    /// Body parameters used with a call to the VeterinaryController.SaveVeterinaryDiseaseReport service method.
    /// </summary>
    public sealed class VeterinaryDiseaseReportSetParameters
    {
        [Required]
        public string LanguageID { get; set; }
        public long? VeterinaryDiseaseReportID { get; set; }
        public long? FarmID { get; set; }
        [Required]
        public long FarmMasterID { get; set; }
        public long? FarmOwnerID { get; set; }
        [Required]
        public long DiseaseID { get; set; }
        [Required]
        public long EnteredByPersonID { get; set; }
        public long? ReportedByPersonID { get; set; }
        public long? InvestigatedByPersonID { get; set; }
        [Required]
        public long SiteID { get; set; }
        public DateTime? InitialReportDate { get; set; }
        public DateTime? AssignedDate { get; set; }
        public DateTime? InvestigationDate { get; set; }
        public DateTime? DiagnosisDate { get; set; }
        public string EIDSSFieldAccessionID { get; set; }
        [Required]
        public int RowStatus { get; set; }
        public long? ReportedByOrganizationID { get; set; }
        public long? InvestigatedByOrganizationID { get; set; }
        public long? ReportTypeID { get; set; }
        public long? ClassificationTypeID { get; set; }
        public long? OutbreakID { get; set; }
        [Required]
        public DateTime EnteredDate { get; set; }
        public string EIDSSReportID { get; set; }
        public long? ReportStatusTypeID { get; set; }
        public long? MonitoringSessionID { get; set; }
        public long? ReportCategoryTypeID { get; set; }
        public int? FarmSickAnimalQuantity { get; set; }
        public int? FarmTotalAnimalQuantity { get; set; }
        public int? FarmDeadAnimalQuantity { get; set; }
        public long? OriginalVeterinaryDiseaseReportID { get; set; }
        public long? FarmEpidemiologicalObservationID { get; set; }
        public long? ControlMeasuresObservationID { get; set; }
        public List<HerdParameters> HerdsOrFlocks { get; set; }
        public List<SpeciesParameters> Species { get; set; }
        public List<AnimalParameters> Animals { get; set; }
        public List<VeterinaryVaccinationParameters> Vaccinations { get; set; }
        public List<VeterinarySampleParameters> Samples { get; set; }
        public List<PensideTestParameters> PensideTests { get; set; }
        public List<LabTestParameters> Tests { get; set; }
        public List<TestInterpretationParameters> TestInterpretations { get; set; }
        public List<VeterinaryDiseaseReportLogParameters> VeterinaryDiseaseReportLogs { get; set; }
    }
}