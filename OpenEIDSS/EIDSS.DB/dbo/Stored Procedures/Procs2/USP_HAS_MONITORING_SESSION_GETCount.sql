
-- ================================================================================================
-- Name: USP_HAS_MONITORING_SESSION_GETCount
--
-- Description: Gets a count of human monitoring sessions based on search criteria provided.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     12/31/2018 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_HAS_MONITORING_SESSION_GETCount]
(
 	@LanguageID					NVARCHAR(50),
	@EIDSSSessionID				NVARCHAR(200),
	@StatusTypeID				BIGINT,
	@DateEnteredFrom			DATETIME,
	@DateEnteredTo				DATETIME,
	@RegionID					BIGINT,
	@RayonID					BIGINT,
	@DiseaseID					BIGINT,
	@EIDSSCampaignID			NVARCHAR(50)
)  
AS  
BEGIN

	BEGIN TRY  	
		SET NOCOUNT ON;

		SELECT					COUNT(*) AS RecordCount 
		FROM					dbo.tlbMonitoringSession ms
		LEFT JOIN				dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000117) AS statusType 
		ON						statusType.idfsReference = ms.idfsMonitoringSessionStatus
		LEFT JOIN				dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS disease
		ON						disease.idfsReference = ms.idfsDiagnosis
		LEFT JOIN				dbo.FN_GBL_GIS_REFERENCE(@LanguageID, 19000002) AS rayon
		ON						rayon.idfsReference = ms.idfsRayon
		LEFT JOIN				dbo.FN_GBL_GIS_REFERENCE(@LanguageID, 19000003) AS region
		ON						region.idfsReference = ms.idfsRegion
		LEFT JOIN				dbo.FN_GBL_GIS_REFERENCE(@LanguageID, 19000004) AS settlement
		ON						settlement.idfsReference = ms.idfsSettlement
		LEFT JOIN				dbo.tlbCampaign AS campaign
		ON						campaign.idfCampaign = ms.idfCampaign
		LEFT JOIN				dbo.tlbPerson AS person 
		ON						person.idfPerson = ms.idfPersonEnteredBy
		LEFT JOIN				dbo.FN_GBL_INSTITUTION(@LanguageID) AS siteRef 
		ON						siteRef.idfsSite= ms.idfsSite 
		WHERE		
		(							
								(CASE WHEN @EIDSSSessionID IS NULL THEN 1 WHEN ISNULL(ms.strMonitoringSessionID,'') LIKE '%' + @EIDSSSessionID +'%' THEN 1 WHEN ms.strMonitoringSessionID = @EIDSSSessionID THEN 1 ELSE 0 END = 1)
			AND					(CASE WHEN @StatusTypeID IS NULL THEN 1 WHEN ISNULL(ms.idfsMonitoringSessionStatus,'') = @StatusTypeID  THEN 1 WHEN ms.idfsMonitoringSessionStatus = @StatusTypeID THEN 1 ELSE 0 END = 1)
			AND					(CASE WHEN @DiseaseID IS NULL THEN 1 WHEN ISNULL(ms.idfsDiagnosis,'') = @DiseaseID THEN 1 WHEN ms.idfsDiagnosis = @DiseaseID THEN 1 ELSE 0 END = 1)
			AND					(CASE WHEN @RegionID IS NULL THEN 1 WHEN ISNULL(ms.idfsRegion,'') = @RegionID THEN 1 WHEN ms.idfsRegion = @RegionID THEN 1 ELSE 0 END = 1)
			AND					(CASE WHEN @RayonID IS NULL THEN 1 WHEN ISNULL(ms.idfsRayon,'') = @RayonID  THEN 1 WHEN ms.idfsRayon = @RayonID THEN 1 ELSE 0 END = 1)
			AND					(CASE WHEN @EIDSSCampaignID IS NULL THEN 1 WHEN ISNULL(Campaign.strCampaignID,'') LIKE '%' + @EIDSSCampaignID + '%'  THEN 1 WHEN Campaign.strCampaignID = @EIDSSCampaignID THEN 1 ELSE 0 END = 1)
			AND					ms.datEnteredDate >= CASE ISNULL(@DateEnteredFrom, '') WHEN '' THEN ms.datEnteredDate ELSE @DateEnteredFrom END
			AND					ms.datEnteredDate <= CASE ISNULL(@DateEnteredTo, '') WHEN '' THEN ms.datEnteredDate ELSE @DateEnteredTo END
			AND					ms.intRowStatus = 0  
			AND					ms.SessionCategoryID = 10169001
		);
	END TRY  
	BEGIN CATCH 
		;THROW;
	END CATCH
END
