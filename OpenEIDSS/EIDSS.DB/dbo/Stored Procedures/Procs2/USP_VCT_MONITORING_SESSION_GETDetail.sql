-- ================================================================================================
-- Name: USP_VCT_MONITORING_SESSION_GETDetail
--
-- Description:	Get active surveillance monitoring session detail (one record) for the veterinary 
-- surveillance session edit/enter and other use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     05/02/2019 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VCT_MONITORING_SESSION_GETDetail] (
	@LanguageID NVARCHAR(50),
	@MonitoringSessionID BIGINT
	)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;

		DECLARE @ReturnMessage VARCHAR(MAX) = 'SUCCESS';
		DECLARE @ReturnCode BIGINT = 0;

		SELECT ms.idfMonitoringSession AS VeterinaryMonitoringSessionID,
			ms.strMonitoringSessionID AS EIDSSSessionID,
			ms.idfsMonitoringSessionStatus AS SessionStatusTypeID,
			MonitoringSessionStatus.name AS SessionStatusTypeName,
			ms.idfsDiagnosis AS DiseaseID,
			disease.name AS DiseaseName,
			ms.datEnteredDate AS EnteredDate,
			ms.datStartDate AS StartDate,
			ms.datEndDate AS EndDate,
			ms.idfsCountry AS CountryID,
			ms.idfsRegion AS RegionID,
			region.name AS RegionName,
			ms.idfsRayon AS RayonID,
			rayon.name AS RayonName,
			ms.idfsSettlement AS SettlementID,
			settlement.name AS SettlementName,
			ms.idfPersonEnteredBy AS EnteredByPersonID,
			ISNULL(p.strFamilyName, N'') + ISNULL(', ' + p.strFirstName, '') + ISNULL(' ' + p.strSecondName, '') AS EnteredByPersonName,
			ms.idfsSite AS SiteID,
			siteName.name AS SiteName,
			ms.LegacySessionID AS AvianOrLivestock,
			c.idfCampaign AS CampaignID,
			c.strCampaignName AS CampaignName,
			c.idfsCampaignType AS CampaignTypeID,
			campaignType.name AS CampaignTypeName
		FROM dbo.tlbMonitoringSession ms
		LEFT JOIN dbo.tlbCampaign AS c
			ON c.idfCampaign = ms.idfCampaign
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000116) AS campaignType
			ON c.idfsCampaignType = campaignType.idfsReference
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000117) AS monitoringSessionStatus
			ON monitoringSessionStatus.idfsReference = ms.idfsMonitoringSessionStatus
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS disease
			ON disease.idfsReference = ms.idfsDiagnosis
		LEFT JOIN dbo.FN_GBL_GIS_REFERENCE(@LanguageID, 19000001) AS country
			ON country.idfsReference = ms.idfsCountry
		LEFT JOIN dbo.FN_GBL_GIS_REFERENCE(@LanguageID, 19000002) AS rayon
			ON rayon.idfsReference = ms.idfsRayon
		LEFT JOIN dbo.FN_GBL_GIS_REFERENCE(@LanguageID, 19000003) AS region
			ON Region.idfsReference = ms.idfsRegion
		LEFT JOIN dbo.FN_GBL_GIS_REFERENCE(@LanguageID, 19000004) AS settlement
			ON settlement.idfsReference = ms.idfsSettlement
		LEFT JOIN dbo.tlbPerson p
			ON p.idfPerson = ms.idfPersonEnteredBy
		LEFT JOIN dbo.FN_GBL_INSTITUTION(@LanguageID) AS SiteName
			ON siteName.idfsSite = ms.idfsSite
		WHERE ms.idfMonitoringSession = @MonitoringSessionID
			AND ms.intRowStatus = 0;
	END TRY

	BEGIN CATCH
		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH
END
