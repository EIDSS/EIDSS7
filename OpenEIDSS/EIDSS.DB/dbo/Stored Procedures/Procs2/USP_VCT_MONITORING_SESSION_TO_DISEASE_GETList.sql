-- ================================================================================================
-- Name: USP_VCT_MONITORING_SESSION_TO_DISEASE_GETList
--
-- Description:	Get active surveillance monitoring session to disease list for the veterinary 
-- module active surveillance edit/set up use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     05/21/2019 Initial release
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VCT_MONITORING_SESSION_TO_DISEASE_GETList] (
	@LanguageID NVARCHAR(50),
	@MonitoringSessionID BIGINT = NULL
	)
AS
BEGIN
	BEGIN TRY
		SELECT msd.idfMonitoringSessionToDiagnosis AS MonitoringSessionToDiseaseID,
			msd.idfMonitoringSession AS MonitoringSessionID,
			msd.idfsDiagnosis AS DiseaseID,
			disease.name AS DiseaseName,
			msd.idfsSpeciesType AS SpeciesTypeID,
			speciesType.name AS SpeciesTypeName,
			msd.idfsSampleType AS SampleTypeID,
			sampleType.name AS SampleTypeName,
			msd.intOrder AS OrderNumber,
			msd.intRowStatus AS RowStatus,
			'R' AS RowAction
		FROM dbo.tlbMonitoringSessionToDiagnosis msd
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS disease
			ON disease.idfsReference = msd.idfsDiagnosis
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000086) AS speciesType
			ON speciesType.idfsReference = msd.idfsSpeciesType
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000087) AS sampleType
			ON sampleType.idfsReference = msd.idfsSampleType
		WHERE msd.idfMonitoringSession = @MonitoringSessionID
			AND msd.intRowStatus = 0;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;
END
GO


