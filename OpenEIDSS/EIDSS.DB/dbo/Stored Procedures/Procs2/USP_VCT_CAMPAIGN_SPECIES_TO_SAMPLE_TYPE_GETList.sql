-- ================================================================================================
-- Name: USP_VCT_CAMPAIGN_SPECIES_TO_SAMPLE_TYPE_GETList
--
-- Description:	Get active surveillance campaign to sample type list for the veterinary module 
-- active surveillance campaign edit/set up use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     05/03/2019 Initial release
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_VCT_CAMPAIGN_SPECIES_TO_SAMPLE_TYPE_GETList] (
	@LanguageID NVARCHAR(50),
	@CampaignID BIGINT = NULL
	)
AS
BEGIN
	BEGIN TRY
		SELECT cst.CampaignToSampleTypeUID AS CampaignToSampleTypeID,
			cst.idfCampaign AS CampaignID,
			cst.idfsSpeciesType AS SpeciesTypeID,
			speciesType.name AS SpeciesTypeName,
			cst.idfsSampleType AS SampleTypeID,
			sampleType.name AS SampleTypeName,
			cst.intOrder AS OrderNumber,
			cst.intRowStatus AS RowStatus,
			cst.intPlannedNumber AS PlannedNumber,
			'R' AS RowAction
		FROM dbo.CampaignToSampleType cst
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000086) AS speciesType
			ON speciesType.idfsReference = cst.idfsSpeciesType
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000087) AS sampleType
			ON sampleType.idfsReference = cst.idfsSampleType
		WHERE cst.idfCampaign = @CampaignID
			AND cst.intRowStatus = 0;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;
END
GO


