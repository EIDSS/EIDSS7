
-- ================================================================================================
-- Name: USP_DAS_UNACCESSIONEDSAMPLES_GETList
--
-- Description: Returns a list of unaccessioned samples based on the language selected and the 
-- current site of the current user
--
-- Author: Ricky Moss
-- 
-- Revision History:
-- Name                  Date       Change Detail
-- --------------------- ---------- --------------------------------------------------------------
-- Ricky Moss            11/30/2018 Initial release
-- Stephen Long          02/25/2019 Updated to sync up with the lab sample get list.  Simplified 
--                                  joins on the disease links.  Added pagination set.
--
-- Testing Code:
-- exec USP_DAS_UNACCESSIONEDSAMPLES_GETList 'en', 1
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_DAS_UNACCESSIONEDSAMPLES_GETList] (
	@LanguageID NVARCHAR(50),
	@OrganizationID BIGINT = NULL,
	@SiteID BIGINT = NULL, 
	@PaginationSet INT = 1,
	@PageSize INT = 10,
	@MaxPagesPerFetch INT = 10
	)
AS
BEGIN
	BEGIN TRY
		SELECT m.idfMaterial AS SampleID,
			m.strCalculatedCaseID AS EIDSSReportSessionID,
			m.strCalculatedHumanName AS PatientFarmOwnerName,
			m.strFieldBarcode AS EIDSSLocalFieldSampleID,
			sampleType.name AS SampleTypeName,
			(
				CASE 
					WHEN (NOT ISNULL(m.idfMonitoringSession, '') = '')
						THEN msDisease.name
					WHEN (NOT ISNULL(m.idfHumanCase, '') = '')
						THEN hdrDisease.name
					WHEN (NOT ISNULL(m.idfVetCase, '') = '')
						THEN vdrDisease.name
					WHEN (NOT ISNULL(m.DiseaseID, '') = '')
						THEN sampleDisease.name
					ELSE ''
					END
				) AS DiseaseName
		FROM dbo.tlbMaterial m
		LEFT JOIN dbo.tlbHumanCase AS hc
			ON hc.idfHumanCase = m.idfHumanCase
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS hdrDisease
			ON hdrDisease.idfsReference = hc.idfsFinalDiagnosis
		LEFT JOIN dbo.tlbVetCase AS vc
			ON vc.idfVetCase = m.idfVetCase
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS vdrDisease
			ON vdrDisease.idfsReference = vc.idfsFinalDiagnosis
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS sampleDisease
			ON sampleDisease.idfsReference = m.DiseaseID
		LEFT JOIN dbo.tlbMonitoringSession AS ms
			ON ms.idfMonitoringSession = m.idfMonitoringSession
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS msDisease
			ON msDisease.idfsReference = ms.idfsDiagnosis
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000087) AS sampleType
			ON sampleType.idfsReference = m.idfsSampleType
		WHERE (m.blnAccessioned = 0)
			AND ((
				(m.idfSendToOffice = @OrganizationID)
				OR (@OrganizationID IS NULL)
				)
			OR (
				(m.idfsSite = @SiteID OR m.idfsCurrentSite = @SiteID)
				OR (@SiteID IS NULL)
				))
			AND (m.idfsSampleType <> '10320001')
			AND (m.idfsSampleStatus IS NULL)
			AND (m.intRowStatus = 0)
		GROUP BY m.idfMaterial,
			m.strFieldBarcode,
			sampleType.name,
			m.strCalculatedCaseID,
			m.strCalculatedHumanName,
			m.idfMonitoringSession,
			m.idfHumanCase,
			m.idfVetCase,
			m.DiseaseID,
			sampleDisease.name,
			msDisease.name,
			hdrDisease.name,
			vdrDisease.name
		ORDER BY m.strCalculatedCaseID OFFSET(@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS

		FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END