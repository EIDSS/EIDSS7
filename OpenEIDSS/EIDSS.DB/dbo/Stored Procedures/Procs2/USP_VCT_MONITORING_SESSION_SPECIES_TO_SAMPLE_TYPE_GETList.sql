-- ================================================================================================
-- Name: USP_VCT_MONITORING_SESSION_SPECIES_TO_SAMPLE_TYPE_GETList
--
-- Description:	Get active surveillance monitoring session to sample type list for the veterinary 
-- module active surveillance edit/set up use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     05/17/2018 Initial release
-- Stephen Long     05/03/2019 Updated for API; removed maintenance flag.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VCT_MONITORING_SESSION_SPECIES_TO_SAMPLE_TYPE_GETList] (
	@LanguageID NVARCHAR(50),
	@MonitoringSessionID BIGINT = NULL
	)
AS
BEGIN
	BEGIN TRY
		SELECT mst.MonitoringSessionToSampleType AS MonitoringSessionToSampleTypeID,
			mst.idfMonitoringSession AS MonitoringSessionID,
			mst.idfsSpeciesType AS SpeciesTypeID,
			speciesType.name AS SpeciesTypeName,
			mst.idfsSampleType AS SampleTypeID,
			sampleType.name AS SampleTypeName,
			mst.intOrder AS OrderNumber,
			mst.intRowStatus AS RowStatus,
			'R' AS RowAction
		FROM dbo.MonitoringSessionToSampleType mst
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000086) AS speciesType
			ON speciesType.idfsReference = mst.idfsSpeciesType
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000087) AS sampleType
			ON sampleType.idfsReference = mst.idfsSampleType
		WHERE mst.idfMonitoringSession = @MonitoringSessionID
			AND mst.intRowStatus = 0;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;
END
GO


