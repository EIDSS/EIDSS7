-- ================================================================================================
-- Name: USP_VCT_CAMPAIGN_GETDetail
--
-- Description: Gets data for active surveillance campaign use cases VASUC01 and VASUC06.
--          
-- Revision History:
-- Name               Date       Change Detail
-- ------------------ ---------- -----------------------------------------------------------------
-- Stephen Long       04/30/2019 Initial release for API.
--
-- Testing code:
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VCT_CAMPAIGN_GETDetail] (
	@LanguageID AS NVARCHAR(50),
	@CampaignID AS BIGINT
	)
AS
BEGIN
	DECLARE @ReturnMessage VARCHAR(MAX) = 'Success',
		@ReturnCode BIGINT = 0;

	BEGIN TRY
		SELECT tc.idfCampaign AS CampaignID,
			idfsCampaignType AS CampaignTypeID,
			campaignType.name AS CampaignTypeName,
			idfsCampaignStatus AS CampaignStatusTypeID,
			campaignStatus.name AS CampaignStatusTypeName,
			tc.idfsDiagnosis AS DiseaseID,
			disease.name AS DiseaseName,
			speciesType.name AS SpeciesTypeName,
			cts.idfsSampleType AS SampleTypeID,
			sampleType.name AS SampleTypeName,
			tc.datCampaignDateStart AS CampaignStartDate,
			tc.datCampaignDateEND AS CampaignEndDate,
			tc.strCampaignID AS EIDSSCampaignID,
			tc.strCampaignName AS CampaignName,
			tc.strCampaignAdministrator AS CampaignAdministrator,
			tc.strConclusion AS Conclusion
		FROM dbo.tlbCampaign tc
		LEFT JOIN dbo.CampaignToSampleType cts
			ON cts.idfCampaign = tc.idfCampaign
				AND cts.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000115) campaignStatus
			ON tc.idfsCampaignStatus = campaignStatus.idfsReference
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000116) campaignType
			ON tc.idfsCampaignType = campaignType.idfsReference
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) disease
			ON tc.idfsDiagnosis = disease.idfsReference
				AND disease.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000087) sampleType
			ON sampleType.idfsReference = cts.idfsSampleType
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000086) speciesType
			ON speciesType.idfsReference = cts.idfsSpeciesType
		WHERE tc.idfCampaign = @CampaignID
			AND tc.intRowStatus = 0;
	END TRY

	BEGIN CATCH
		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH
END
