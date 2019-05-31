-- ================================================================================================
-- Name: USP_VCT_CAMPAIGN_GETList
--
-- Description: Gets data for active surveillance campaign search use case VASUC04.
--          
-- Revision History:
-- Name               Date       Change Detail
-- ------------------ ---------- -----------------------------------------------------------------
-- Stephen Long       04/30/2019 Initial release for API.
-- Stephen Long       05/22/2019 Added date entered for duplicate check on VASUC01.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VCT_CAMPAIGN_GETList] (
	@LanguageID AS NVARCHAR(50),
	@EIDSSCampaignID AS NVARCHAR(200) = NULL,
	@CampaignName AS NVARCHAR(200) = NULL,
	@CampaignTypeID AS BIGINT = NULL,
	@CampaignStatusTypeID AS BIGINT = NULL,
	@StartDateFrom AS DATETIME = NULL,
	@StartDateTo AS DATETIME = NULL,
	@DiseaseID AS BIGINT = NULL,
	@PaginationSet INT = 1,
	@PageSize INT = 10,
	@MaxPagesPerFetch INT = 10
	)
AS
BEGIN
	DECLARE @ReturnMessage VARCHAR(MAX) = 'Success',
		@ReturnCode BIGINT = 0;

	BEGIN TRY
		SELECT c.idfCampaign AS CampaignID,
			idfsCampaignType AS CampaignTypeID,
			campaignType.name AS CampaignTypeName,
			idfsCampaignStatus AS CampaignStatusTypeID,
			campaignStatus.name AS CampaignStatusTypeName,
			c.idfsDiagnosis AS DiseaseID,
			disease.name AS DiseaseName,
			SpeciesList = STUFF((
					SELECT ', ' + speciesType.name
					FROM dbo.CampaignToSampleType cts
					INNER JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000086) AS speciesType
						ON speciesType.idfsReference = cts.idfsSpeciesType
					WHERE cts.idfCampaign = c.idfCampaign
					GROUP BY speciesType.name
					FOR XML PATH(''),
						TYPE
					).value('.[1]', 'NVARCHAR(MAX)'), 1, 2, ''),
			SampleTypesList = STUFF((
					SELECT ', ' + sampleType.name
					FROM dbo.CampaignToSampleType cts
					INNER JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000087) AS sampleType
						ON sampleType.idfsReference = cts.idfsSampleType
					WHERE cts.idfCampaign = c.idfCampaign
					GROUP BY sampleType.name
					FOR XML PATH(''),
						TYPE
					).value('.[1]', 'NVARCHAR(MAX)'), 1, 2, ''),
			c.datCampaignDateStart AS CampaignStartDate,
			c.datCampaignDateEND AS CampaignEndDate,
			c.strCampaignID AS EIDSSCampaignID,
			c.strCampaignName AS CampaignName,
			c.strCampaignAdministrator AS CampaignAdministrator, 
			c.AuditCreateDTM AS EnteredDate 
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
				) 
		ORDER BY c.strCampaignID,
			c.strCampaignName,
			c.idfsDiagnosis,
			c.datCampaignDateStart OFFSET(@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS

		FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY;
	END TRY

	BEGIN CATCH
		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH
END
