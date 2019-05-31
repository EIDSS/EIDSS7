-- ================================================================================================
-- Name: USP_VCT_CAMPAIGN_GETCount
--
-- Description: Gets counts for active surveillance campaign search use case VASUC04.
--          
-- Revision History:
-- Name               Date       Change Detail
-- ------------------ ---------- -----------------------------------------------------------------
-- Stephen Long       05/01/2019 Initial release for API.
--
-- Testing code:
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VCT_CAMPAIGN_GETCount] (
	@LanguageID AS NVARCHAR(50),
	@EIDSSCampaignID AS NVARCHAR(200) = NULL,
	@CampaignName AS NVARCHAR(200) = NULL,
	@CampaignTypeID AS BIGINT = NULL,
	@CampaignStatusTypeID AS BIGINT = NULL,
	@StartDateFrom AS DATETIME = NULL,
	@StartDateTo AS DATETIME = NULL,
	@DiseaseID AS BIGINT = NULL
	)
AS
BEGIN
	DECLARE @ReturnMessage VARCHAR(MAX) = 'Success',
		@ReturnCode BIGINT = 0;

	BEGIN TRY
		SELECT COUNT(*) AS RecordCount,
			(
				SELECT COUNT(NULLIF(c2.idfCampaign, 0))
				FROM dbo.tlbCampaign c2
				WHERE intRowStatus = 0 
				AND c2.CampaignCategoryID = 10168002
				) AS TotalCount
		FROM dbo.tlbCampaign c
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000115) campaignStatus
			ON c.idfsCampaignStatus = campaignStatus.idfsReference
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000116) campaignType
			ON c.idfsCampaignType = campaignType.idfsReference
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) disease
			ON c.idfsDiagnosis = disease.idfsReference
				AND disease.intRowStatus = 0
		WHERE c.intRowStatus = 0
			AND (c.CampaignCategoryID = 10168002)
			AND (
				(strCampaignName = @CampaignName)
				OR (@CampaignName IS NULL)
				)
			AND (
				(idfsCampaignType = @CampaignTypeID)
				OR (@CampaignTypeID IS NULL)
				)
			AND (
				(idfsCampaignStatus = @CampaignStatusTypeID)
				OR @CampaignStatusTypeID IS NULL
				)
			AND ( 
				(idfsDiagnosis = @DiseaseID) 
				OR (@DiseaseID IS NULL)
				)
			AND (
				(
					datCampaignDateStart BETWEEN @StartDateFrom
						AND @StartDateTo
					)
				OR (@StartDateFrom IS NULL)
				)
			AND (
				(strCampaignID LIKE '%' + @EIDSSCampaignID + '%')
				OR (@EIDSSCampaignID IS NULL)
				);
	END TRY

	BEGIN CATCH
		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH
END
