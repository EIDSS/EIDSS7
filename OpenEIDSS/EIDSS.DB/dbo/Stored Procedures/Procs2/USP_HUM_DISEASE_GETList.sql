--*************************************************************
-- Name 				: USP_HUM_DISEASE_GETList
-- Description			: List Human Disease Report
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name		Date       Change Detail
-- ---------------- ---------- --------------------------------
-- Stephen Long     03/26/2018 Added the person reported by 
--                             name for the farm use case.
-- JWJ	20180417 Added extra col to return:  tlbHuman.idfHumanActual
--		added alias for region rayon to make them unique in results
--		added report status to results 
--
-- Harold Pryor   10/22/2018   Added input search parameters SearchStrPersonFirstName, 
--                             SearchStrPersonMiddleName, and SearchStrPersonLastName
-- Harold Pryor   10/31/2018   Added input search parameters SearchLegacyCaseID and	
--                             added strLocation (region, rayon) field to list result set
-- Harold Pryor   11/12/2018   Changed @SearchLegacyCaseID parameter from BIGINT to NVARCHAR(200)
--
-- Testing code:
-- EXEC USP_HUM_DISEASE_GETList 'en'
-- EXEC USP_HUM_DISEASE_GETList 'en', @SearchStrCaseId = 'H'
--*************************************************************
CREATE PROCEDURE [dbo].[USP_HUM_DISEASE_GETList] 
	@LangID								AS NVARCHAR(50), 
	@SearchHumanCaseId					AS BIGINT = NULL, 
	@SearchLegacyCaseID			        AS NVARCHAR(200) = NULL, 
	@SearchPatientId					AS BIGINT = NULL,
	@SearchPersonEIDSSId				AS NVARCHAR(MAX) = NULL,
	@SearchDiagnosis					AS BIGINT = NULL,
	@SearchReportStatus					AS BIGINT = NULL,
	@SearchRegion						AS BIGINT = NULL,
	@SearchRayon						AS BIGINT = NULL,
	@SearchHDRDateEnteredFrom			AS DATETIME = NULL,
	@SearchHDRDateEnteredTo				AS DATETIME = NULL,
	@SearchCaseClassification			AS BIGINT = NULL,
	@SearchDiagnosisDateFrom			AS DATETIME = NULL,
	@SearchDiagnosisDateTo				AS DATETIME = NULL,
	@SearchIdfsHospitalizationStatus	AS BIGINT = NULL,
	@SearchStrCaseId					AS NVARCHAR(200) = NULL,
	@SearchStrPersonFirstName		    AS NVARCHAR(200) = NULL,
	@SearchStrPersonMiddleName		    AS NVARCHAR(200) = NULL,
	@SearchStrPersonLastName			AS NVARCHAR(200) = NULL
AS
BEGIN
	DECLARE @returnMsg					VARCHAR(MAX) = 'Success';
	DECLARE @returnCode					BIGINT = 0;

	BEGIN TRY  	
		SELECT							hc.idfHumanCase,
										hc.idfHuman,
										hc.datTentativeDiagnosisDate,
										hc.datEnteredDate,
										hc.idfsFinalDiagnosis,
										diagnosis.Name AS Diagnosis,
										hc.datFinalDiagnosisDate,
										hc.idfsCaseProgressStatus,	
										hc.idfPointGeoLocation,
										region.idfsReference AS idfsRefRegion,
										region.name as strRegion,
										rayon.idfsReference AS idfsRefRayon,
										rayon.name as strRayon,
										region.name + ', ' + rayon.name AS strLocation,
										hc.idfsInitialCaseStatus,			
										ISNULL(FinalCaseClassification.name, InitialCaseClassification.name) AS strClassification,
										hc.idfsFinalCaseStatus,			
										FinalCaseClassification.name,
										h.strPersonId,
										ISNULL(h.strLastName, N'') + ', ' + ISNULL(' ' + h.strFirstName, '') + ISNULL(' ' + h.strSecondName, '') AS strPersonName,
										hc.idfPersonEnteredBy,
										ISNULL(haPersonEnteredBy.strLastName, N'') + ISNULL(' ' + haPersonEnteredBy.strFirstName, '') + ISNULL(' ' + haPersonEnteredBy.strSecondName, '') AS strPersonReportedByName,
										hc.datOnSetDate,
										hc.datModificationDate,
										h.idfHumanActual,
										Reportstatus.name as reportStatus, 
										haPersonEnteredBy.strEmployerName,
										hc.strCaseId,										
										ISNULL(haPersonEnteredBy.strLastName, N'') + ISNULL(' ' + haPersonEnteredBy.strFirstName, '') + ISNULL(' ' + haPersonEnteredBy.strSecondName, '') AS  strPersonEnteredByName,
										hc.LegacyCaseID  
		FROM							dbo.tlbHumanCase hc
		LEFT JOIN						dbo.tlbHuman AS h
		ON								h.idfHuman = hc.idfHuman AND h.intRowStatus = 0 
		LEFT JOIN						dbo.tlbHumanActual AS ha
		ON								ha.idfHumanActual = h.idfHumanActual AND ha.intRowStatus = 0
		LEFT JOIN						dbo.tlbGeoLocation gl
		ON								gl.idfGeoLocation = hc.idfPointGeoLocation AND gl.intRowStatus = 0 
		LEFT JOIN						FN_GBL_GIS_REFERENCE(@LangID, 19000002) Rayon
		ON								Rayon.idfsReference = gl.idfsRayon
		LEFT JOIN						FN_GBL_GIS_REFERENCE(@LangID, 19000003) Region
		ON								Region.idfsReference = gl.idfsRegion
		LEFT JOIN						FN_GBL_ReferenceRepair(@LangID, 19000019) Diagnosis
		ON								diagnosis.idfsReference = hc.idfsFinalDiagnosis
		LEFT JOIN						FN_GBL_ReferenceRepair(@LangID, 19000011) InitialCaseClassification
		ON								InitialCaseClassification.idfsReference = hc.idfsInitialCaseStatus
		LEFT JOIN						FN_GBL_ReferenceRepair(@LangID, 19000011) FinalCaseClassification
		ON								FinalCaseClassification.idfsReference = hc.idfsFinalCaseStatus
		LEFT JOIN						FN_GBL_ReferenceRepair(@LangID, 19000111) Reportstatus
		ON								Reportstatus.idfsReference = hc.idfsCaseProgressStatus 
		LEFT JOIN						dbo.tlbHumanActual AS haPersonEnteredBy 
		ON								haPersonEnteredBy.idfHumanActual = hc.idfPersonEnteredBy AND haPersonEnteredBy.intRowStatus = 0
		WHERE							((hc.idfHumanCase = @SearchHumanCaseId) OR (@SearchHumanCaseId IS NULL))		
		AND                             (
											(ISNULL(hc.LegacyCaseID, '') = CASE ISNULL(@SearchLegacyCaseID, '') WHEN '' THEN ISNULL(hc.LegacyCaseID, '') ELSE @SearchLegacyCaseID END) 
											OR (CHARINDEX(@SearchLegacyCaseID, ISNULL(hc.LegacyCaseID, '')) > 0)
										)
		AND								((ha.idfHumanActual = @SearchPatientId) OR (@SearchPatientId IS NULL))
		AND								((h.strPersonId = @SearchPersonEIDSSId) OR (@SearchPersonEIDSSId IS NULL))
		AND								(
											(ISNULL(hc.strCaseID, '') = CASE ISNULL(@SearchStrCaseId, '') WHEN '' THEN ISNULL(hc.strCaseID, '') ELSE @SearchStrCaseId END) 
											OR (CHARINDEX(@SearchStrCaseId, ISNULL(hc.strCaseID, '')) > 0)
										)
		AND								((idfsFinalDiagnosis = @SearchDiagnosis) OR (@SearchDiagnosis IS NULL))
		AND								((idfsCaseProgressStatus = @SearchReportStatus) OR (@SearchReportStatus IS NULL))
		AND								((gl.idfsRegion = @SearchRegion) OR (@SearchRegion is null))
		AND								((gl.idfsRayon = @SearchRayon) OR (@SearchRayon is null))
		AND								((hc.datEnteredDate >= CASE ISNULL(@SearchHDRDateEnteredFrom, '1/1/2050') 
											WHEN '1/1/2050' THEN isnull(hc.datEnteredDate,'1/1/2050') ELSE @SearchHDRDateEnteredFrom END)
											OR (ISNULL(@SearchHDRDateEnteredFrom,'') = ''))
		AND								((hc.datEnteredDate <= CASE ISNULL(@SearchHDRDateEnteredTo, '1/1/1901') 
											WHEN '1/1/1901' THEN ISNULL(hc.datEnteredDate, '1/1/1901') ELSE @SearchHDRDateEnteredTo END)
											OR (ISNULL(@SearchHDRDateEnteredTo,'') = ''))
		AND								((idfsFinalCaseStatus = @SearchCaseClassification) OR (@SearchCaseClassification IS NULL))
		AND								((idfsHospitalizationStatus = @SearchIdfsHospitalizationStatus) OR (@SearchIdfsHospitalizationStatus IS NULL))	
		AND								(
											(ISNULL(h.strFirstName, '') = CASE ISNULL(@SearchStrPersonFirstName, '') WHEN '' THEN ISNULL(h.strFirstName, '') ELSE @SearchStrPersonFirstName END) 
											OR (CHARINDEX(@SearchStrPersonFirstName, ISNULL(h.strFirstName, '')) > 0)
										)
		
		AND								(		
											(ISNULL(h.strSecondName, '') = CASE ISNULL(@SearchStrPersonMiddleName, '') WHEN '' THEN ISNULL(h.strSecondName, '') ELSE @SearchStrPersonMiddleName END) 
											OR (CHARINDEX(@SearchStrPersonMiddleName, ISNULL(h.strSecondName, '')) > 0)
										)
		
		AND								(
											(ISNULL(h.strLastName, '') = CASE ISNULL(@SearchStrPersonLastName, '') WHEN '' THEN ISNULL(h.strLastName, '') ELSE @SearchStrPersonLastName END) 
											OR (CHARINDEX(@SearchStrPersonLastName, ISNULL(h.strLastName, '')) > 0)
										)
		
		AND								hc.intRowStatus = 0
		ORDER BY hc.idfHumanCase, diagnosis.Name, hc.datEnteredDate, Reportstatus.name

		SELECT @returnCode 'ReturnCode', @returnMsg 'ResturnMessage';
	END TRY  

	BEGIN CATCH 
		THROW;
	END CATCH;
END
