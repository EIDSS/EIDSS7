-- ================================================================================================
-- Name: USP_VCT_MONITORING_SESSION_GETCount
--
-- Description: Gets a count for active surveillance monitoring sessions based on search criteria 
-- provided.
--
-- Revision History:
-- Name            Date       Change Detail
-- --------------- ---------- --------------------------------------------------------------------
-- Stephen Long    12/31/2018 Initial release.
-- Stephen Long    05/01/2019 Removed additional field parameters to sync with use case, and 
--                            added campaign and monitoring session ID parameters.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VCT_MONITORING_SESSION_GETCount] (
	@LanguageID NVARCHAR(50),
	@EIDSSSessionID NVARCHAR(200) = NULL,
	@SessionStatusTypeID BIGINT = NULL,
	@DateEnteredFrom DATETIME = NULL,
	@DateEnteredTo DATETIME = NULL,
	@RegionID BIGINT = NULL,
	@RayonID BIGINT = NULL,
	@DiseaseID BIGINT = NULL,
	@EIDSSCampaignID NVARCHAR(200) = NULL,
	@CampaignID BIGINT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT COUNT(*) AS RecordCount,
			(
				SELECT COUNT(NULLIF(ms2.idfMonitoringSession, 0))
				FROM dbo.tlbMonitoringSession ms2
				WHERE intRowStatus = 0
					AND ms2.SessionCategoryID = 10169002
				) AS TotalCount
		FROM dbo.tlbMonitoringSession ms
		LEFT JOIN dbo.tlbCampaign c
			ON c.idfCampaign = ms.idfCampaign
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000117) AS sessionStatus
			ON sessionStatus.idfsReference = ms.idfsMonitoringSessionStatus
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS disease
			ON disease.idfsReference = ms.idfsDiagnosis
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000002) AS rayon
			ON rayon.idfsReference = ms.idfsRayon
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000003) AS region
			ON region.idfsReference = ms.idfsRegion
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000004) AS settlement
			ON settlement.idfsReference = ms.idfsSettlement
		LEFT JOIN dbo.tlbPerson AS p
			ON p.idfPerson = ms.idfPersonEnteredBy
		LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS siteName
			ON siteName.idfsSite = ms.idfsSite
		WHERE ms.intRowStatus = 0
			AND ms.SessionCategoryID = 10169002
			AND (
				(ms.idfCampaign = @CampaignID)
				OR (@CampaignID IS NULL)
				)
			AND (
				(ms.idfsMonitoringSessionStatus = @SessionStatusTypeID)
				OR (@SessionStatusTypeID IS NULL)
				)
			AND (
				(ms.idfsDiagnosis = @DiseaseID)
				OR (@DiseaseID IS NULL)
				)
			AND (
				(ms.idfsRegion = @RegionID)
				OR (@RegionID IS NULL)
				)
			AND (
				(ms.idfsRayon = @RayonID)
				OR (@RayonID IS NULL)
				)
			AND (
				(
					ms.datEnteredDate BETWEEN @DateEnteredFrom
						AND @DateEnteredTo
					)
				OR (
					@DateEnteredFrom IS NULL
					OR @DateEnteredTo IS NULL
					)
				)
			AND (
				(ms.strMonitoringSessionID LIKE '%' + @EIDSSSessionID + '%')
				OR (@EIDSSSessionID IS NULL)
				)
			AND (
				(c.strCampaignID LIKE '%' + @EIDSSCampaignID + '%')
				OR (@EIDSSCampaignID IS NULL)
				);
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;
END;
