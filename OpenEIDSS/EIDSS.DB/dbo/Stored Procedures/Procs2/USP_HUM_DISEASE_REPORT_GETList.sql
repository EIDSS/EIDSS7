
-- ================================================================================================
-- Name: USP_HUM_DISEASE_REPORT_GETList
--
-- Description: List Human Disease Report
--          
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Mandar Kulkarni             Initial release.
-- Stephen Long     03/26/2018 Added the person reported by name for the farm use case.
-- JWJ	            04/17/2018 Added extra col to return:  tlbHuman.idfHumanActual. Added alias 
--                             for region rayon to make them unique in results added report status 
--                             to results 
-- Harold Pryor     10/22/2018 Added input search parameters SearchStrPersonFirstName, 
--                             SearchStrPersonMiddleName, and SearchStrPersonLastName
-- Harold Pryor     10/31/2018 Added input search parameters SearchLegacyCaseID and	
--                             added strLocation (region, rayon) field to list result set
-- Harold Pryor     11/12/2018 Changed @SearchLegacyCaseID parameter from BIGINT to NVARCHAR(200)
-- Stephen Long     12/19/2018 Added pagination logic.
--
-- Testing code:
-- EXEC USP_HUM_DISEASE_REPORT_GETList 'en'
-- EXEC USP_HUM_DISEASE_REPORT_GETList 'en', @EIDSSReportID = 'H'
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_HUM_DISEASE_REPORT_GETList] 
	@LanguageID							NVARCHAR(50), 
	@HumanDiseaseReportID				BIGINT = NULL, 
	@LegacyID					        NVARCHAR(200) = NULL, 
	@PatientID							BIGINT = NULL,
	@EIDSSPersonID						NVARCHAR(200) = NULL,
	@DiseaseID							BIGINT = NULL,
	@ReportStatusTypeID					BIGINT = NULL,
	@RegionID							BIGINT = NULL,
	@RayonID							BIGINT = NULL,
	@DateEnteredFrom					DATETIME = NULL,
	@DateEnteredTo						DATETIME = NULL,
	@ClassificationTypeID				BIGINT = NULL,
	@HospitalizationStatusTypeID		BIGINT = NULL,
	@EIDSSReportID						NVARCHAR(200) = NULL,
	@PatientFirstOrGivenName		    NVARCHAR(200) = NULL,
	@PatientMiddleName					NVARCHAR(200) = NULL,
	@PatientLastOrSurname				NVARCHAR(200) = NULL, 
	@PaginationSet						INT = 1, 
	@PageSize							INT = 10,
	@MaxPagesPerFetch					INT = 10
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT							hc.idfHumanCase AS HumanDiseaseReportID,
										hc.idfHuman AS PatientID,
										hc.datTentativeDiagnosisDate AS TentativeDiagnosisDate,
										hc.datEnteredDate AS EnteredDate,
										hc.idfsFinalDiagnosis AS DiseaseID,
										disease.Name AS DiseaseName,
										hc.datFinalDiagnosisDate AS FinalDiagnosisDate,
										hc.idfsCaseProgressStatus AS ReportStatusTypeID,	
										hc.idfPointGeoLocation AS PatientGeoLocationID,
										region.idfsReference AS RegionID,
										region.name AS RegionName,
										rayon.idfsReference AS RayonID,
										rayon.name AS RayonName,
										region.name + ', ' + rayon.name AS PatientLocation,
										hc.idfsInitialCaseStatus AS InitialStatusTypeID,			
										ISNULL(finalClassification.name, initialClassification.name) AS ClassificationTypeName,
										hc.idfsFinalCaseStatus AS FinalStatusTypeID,			
										finalClassification.name AS FinalClassificationTypeName,
										haai.EIDSSPersonID AS EIDSSPersonID,
										h.strPersonID AS PersonalID, 
										ISNULL(h.strLastName, N'') + ', ' + ISNULL(' ' + h.strFirstName, '') + ISNULL(' ' + h.strSecondName, '') AS PatientName,
										hc.idfPersonEnteredBy AS PersonEnteredByID,
										ISNULL(p.strFamilyName, N'') + ISNULL(' ' + p.strFirstName, '') + ISNULL(' ' + p.strSecondName, '') AS PersonEnteredByName,
										hc.datOnSetDate AS DateOfOnset,
										hc.datModificationDate AS ModificationDate,
										h.idfHumanActual AS HumanMasterID,
										reportstatus.name AS ReportStatusTypeName, 
										ha.strEmployerName AS EmployerName,
										hc.strCaseId AS EIDSSReportID,										
										hc.LegacyCaseID  
		FROM							dbo.tlbHumanCase hc
		LEFT JOIN						dbo.tlbHuman AS h
		ON								h.idfHuman = hc.idfHuman AND h.intRowStatus = 0 
		LEFT JOIN						dbo.tlbHumanActual AS ha
		ON								ha.idfHumanActual = h.idfHumanActual AND ha.intRowStatus = 0
		LEFT JOIN						dbo.HumanActualAddlInfo AS haai 
		ON								haai.HumanActualAddlInfoUID = ha.idfHumanActual AND haai.intRowStatus = 0 
		LEFT JOIN						dbo.tlbGeoLocation gl
		ON								gl.idfGeoLocation = hc.idfPointGeoLocation AND gl.intRowStatus = 0 
		LEFT JOIN						FN_GBL_GIS_REFERENCE(@LanguageID, 19000002) AS rayon
		ON								rayon.idfsReference = gl.idfsRayon
		LEFT JOIN						FN_GBL_GIS_REFERENCE(@LanguageID, 19000003) AS region
		ON								region.idfsReference = gl.idfsRegion
		LEFT JOIN						FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS disease
		ON								disease.idfsReference = hc.idfsFinalDiagnosis
		LEFT JOIN						FN_GBL_ReferenceRepair(@LanguageID, 19000011) AS initialClassification
		ON								initialClassification.idfsReference = hc.idfsInitialCaseStatus
		LEFT JOIN						FN_GBL_ReferenceRepair(@LanguageID, 19000011) AS finalClassification
		ON								finalClassification.idfsReference = hc.idfsFinalCaseStatus
		LEFT JOIN						FN_GBL_ReferenceRepair(@LanguageID, 19000111) AS reportStatus
		ON								reportStatus.idfsReference = hc.idfsCaseProgressStatus 
		LEFT JOIN						dbo.tlbPerson AS p 
		ON								p.idfPerson = hc.idfPersonEnteredBy AND p.intRowStatus = 0
		WHERE							((hc.idfHumanCase = @HumanDiseaseReportID) OR (@HumanDiseaseReportID IS NULL))		
		AND                             (
											(ISNULL(hc.LegacyCaseID, '') = CASE ISNULL(@LegacyID, '') WHEN '' THEN ISNULL(hc.LegacyCaseID, '') ELSE @LegacyID END) 
											OR (CHARINDEX(@LegacyID, ISNULL(hc.LegacyCaseID, '')) > 0)
										)
		AND								((ha.idfHumanActual = @PatientID) OR (@PatientID IS NULL))
		AND								((h.strPersonId = @EIDSSPersonID) OR (@EIDSSPersonID IS NULL))
		AND								(
											(ISNULL(hc.strCaseID, '') = CASE ISNULL(@EIDSSReportID, '') WHEN '' THEN ISNULL(hc.strCaseID, '') ELSE @EIDSSReportID END) 
											OR (CHARINDEX(@EIDSSReportID, ISNULL(hc.strCaseID, '')) > 0)
										)
		AND								((idfsFinalDiagnosis = @DiseaseID) OR (@DiseaseID IS NULL))
		AND								((idfsCaseProgressStatus = @ReportStatusTypeID) OR (@ReportStatusTypeID IS NULL))
		AND								((gl.idfsRegion = @RegionID) OR (@RegionID is null))
		AND								((gl.idfsRayon = @RayonID) OR (@RayonID is null))
		AND								((hc.datEnteredDate >= CASE ISNULL(@DateEnteredFrom, '1/1/2050') 
											WHEN '1/1/2050' THEN isnull(hc.datEnteredDate,'1/1/2050') ELSE @DateEnteredFrom END)
											OR (ISNULL(@DateEnteredFrom,'') = ''))
		AND								((hc.datEnteredDate <= CASE ISNULL(@DateEnteredTo, '1/1/1901') 
											WHEN '1/1/1901' THEN ISNULL(hc.datEnteredDate, '1/1/1901') ELSE @DateEnteredTo END)
											OR (ISNULL(@DateEnteredTo,'') = ''))
		AND								((idfsFinalCaseStatus = @ClassificationTypeID) OR (@ClassificationTypeID IS NULL))
		AND								((idfsHospitalizationStatus = @HospitalizationStatusTypeID) OR (@HospitalizationStatusTypeID IS NULL))	
		AND								(
											(ISNULL(h.strFirstName, '') = CASE ISNULL(@PatientFirstOrGivenName, '') WHEN '' THEN ISNULL(h.strFirstName, '') ELSE @PatientFirstOrGivenName END) 
											OR (CHARINDEX(@PatientFirstOrGivenName, ISNULL(h.strFirstName, '')) > 0)
										)
		
		AND								(		
											(ISNULL(h.strSecondName, '') = CASE ISNULL(@PatientMiddleName, '') WHEN '' THEN ISNULL(h.strSecondName, '') ELSE @PatientMiddleName END) 
											OR (CHARINDEX(@PatientMiddleName, ISNULL(h.strSecondName, '')) > 0)
										)
		
		AND								(
											(ISNULL(h.strLastName, '') = CASE ISNULL(@PatientLastOrSurname, '') WHEN '' THEN ISNULL(h.strLastName, '') ELSE @PatientLastOrSurname END) 
											OR (CHARINDEX(@PatientLastOrSurname, ISNULL(h.strLastName, '')) > 0)
										)
		
		AND								hc.intRowStatus = 0
		                                and hc.idfsFinalDiagnosis is not null
		ORDER BY						hc.idfHumanCase, disease.Name, hc.datEnteredDate, reportStatus.name 
										OFFSET (@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS
										FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY;
	END TRY  
	BEGIN CATCH 
		BEGIN
			;THROW;
		END
	END CATCH;
END
