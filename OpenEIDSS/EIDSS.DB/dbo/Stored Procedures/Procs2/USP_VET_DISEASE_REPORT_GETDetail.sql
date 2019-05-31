-- ================================================================================================
-- Name: USP_VET_DISEASE_REPORT_GETDetail
--
-- Description:	Get disease detail (one record) for the veterinary edit/enter and other use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/18/2019 Initial release.
-- Stephen Long     04/29/2019 Added connected disease report fields for use case VUC11 and VUC12.
-- Stephen Long     05/26/2019 Added farm epidemiological observation ID to select list.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VET_DISEASE_REPORT_GETDetail] (
	@LanguageID AS NVARCHAR(50),
	@VeterinaryDiseaseReportID AS BIGINT = NULL
	)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;

		DECLARE @ReturnMessage VARCHAR(MAX) = 'SUCCESS';
		DECLARE @ReturnCode BIGINT = 0;

		SELECT vc.idfVetCase AS VeterinaryDiseaseReportID,
			vc.idfFarm AS FarmID,
			vc.idfsFinalDiagnosis AS DiseaseID,
			disease.Name AS DiseaseName,
			vc.idfPersonEnteredBy AS EnteredByPersonID,
			ISNULL(personEnteredBy.strFamilyName, N'') + ISNULL(', ' + personEnteredBy.strFirstName, '') + ISNULL(' ' + personEnteredBy.strSecondName, '') AS EnteredByPersonName,
			vc.idfPersonReportedBy AS ReportedByPersonID,
			ISNULL(personReportedBy.strFamilyName, N'') + ISNULL(', ' + personReportedBy.strFirstName, '') + ISNULL(' ' + personReportedBy.strSecondName, '') AS ReportedByPersonName,
			vc.idfPersonInvestigatedBy AS InvestigatedByPersonID,
			ISNULL(personInvestigatedBy.strFamilyName, N'') + ISNULL(', ' + personInvestigatedBy.strFirstName, '') + ISNULL(' ' + personInvestigatedBy.strSecondName, '') AS InvestigatedByPersonName,
			f.idfObservation AS FarmEpidemiologicalObservationID, 
			vc.idfObservation AS ControlMeasuresObservationID,
			vc.idfsSite AS SiteID,
			s.strSiteName AS SiteName,
			vc.datReportDate AS ReportDate,
			vc.datAssignedDate AS AssignedDate,
			vc.datInvestigationDate AS InvestigationDate,
			vc.datFinalDiagnosisDate AS DiagnosisDate,
			vc.strFieldAccessionID AS EIDSSFieldAccessionID,
			vc.idfsYNTestsConducted AS TestsConductedIndicator,
			vc.intRowStatus AS RowStatus,
			vc.idfReportedByOffice AS ReportedByOrganizationID,
			reportedByOrganization.name AS ReportedByOrganizationName,
			vc.idfInvestigatedByOffice AS InvestigatedByOrganizationID,
			investigatedByOrganization.name AS InvestigatedByOrganizationName, 
			vc.idfsCaseReportType AS ReportTypeID,
			reportType.name AS ReportTypeName,
			vc.idfsCaseClassification AS ClassificationTypeID,
			classification.name AS ClassificationTypeName,
			vc.idfOutbreak AS OutbreakID,
			o.strOutbreakID AS EIDSSOutbreakID, 
			vc.datEnteredDate AS EnteredDate,
			vc.strCaseID AS EIDSSReportID,
			vc.LegacyCaseID AS LegacyID, 
			vc.idfsCaseProgressStatus AS ReportStatusTypeID,
			reportStatus.name AS ReportStatusTypeName,
			vc.datModificationForArchiveDate AS ModifiedDate,
			vc.idfParentMonitoringSession AS ParentMonitoringSessionID, 
			ms.strMonitoringSessionID AS EIDSSParentMonitoringSessionID, 
			vrr.RelatedToVetDiseaseReportID AS RelatedToVeterinaryDiseaseReportID,
			vcr.strCaseID AS RelatedToVeterinaryDiseaseEIDSSReportID
		FROM dbo.tlbVetCase vc
		LEFT JOIN dbo.tlbFarm AS f
			ON f.idfFarm = vc.idfFarm 
		LEFT JOIN dbo.FN_PERSON_SELECTLIST(@LanguageID) AS personInvestigatedBy
			ON personInvestigatedBy.idfEmployee = vc.idfPersonInvestigatedBy
		LEFT JOIN dbo.FN_PERSON_SELECTLIST(@LanguageID) AS personEnteredBy
			ON personEnteredBy.idfEmployee = vc.idfPersonEnteredBy
		LEFT JOIN dbo.FN_PERSON_SELECTLIST(@LanguageID) AS personReportedBy
			ON personReportedBy.idfEmployee = vc.idfPersonReportedBy
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS disease
			ON disease.idfsReference = vc.idfsFinalDiagnosis
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000011) AS classification
			ON classification.idfsReference = vc.idfsCaseClassification
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000111) AS reportStatus
			ON reportStatus.idfsReference = vc.idfsCaseProgressStatus
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000144) AS reportType
			ON reportType.idfsReference = vc.idfsCaseReportType
		LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS reportedByOrganization
			ON reportedByOrganization.idfOffice = vc.idfReportedByOffice
		LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS investigatedByOrganization
			ON investigatedByOrganization.idfOffice = vc.idfInvestigatedByOffice
		LEFT JOIN dbo.tstSite AS s
			ON s.idfsSite = vc.idfsSite 
		LEFT JOIN dbo.tlbOutbreak AS o 
			ON o.idfOutbreak = vc.idfOutbreak AND o.intRowStatus = 0
		LEFT JOIN dbo.tlbMonitoringSession AS ms
			ON ms.idfMonitoringSession = vc.idfParentMonitoringSession AND ms.intRowStatus = 0
		LEFT JOIN dbo.VetDiseaseReportRelationship AS vrr
			ON vrr.VetDiseaseReportID = vc.idfVetCase
				AND vrr.intRowStatus = 0
				AND vrr.RelationshipTypeID = 10503001
		LEFT JOIN dbo.tlbVetCase AS vcr
			ON vcr.idfVetCase = vrr.RelatedToVetDiseaseReportID
				AND vc.intRowStatus = 0
		WHERE vc.idfVetCase = @VeterinaryDiseaseReportID;
	END TRY

	BEGIN CATCH
		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH;
END
GO


