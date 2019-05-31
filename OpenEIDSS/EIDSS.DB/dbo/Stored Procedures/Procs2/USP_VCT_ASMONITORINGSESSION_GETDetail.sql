
-- ============================================================================
-- Name: USP_VCT_ASMONITORINGSESSION_GETDetail
-- Description:	Get active surveillance monitoring session detail (one record) 
-- for the veterinary surveillance session edit/enter and other use cases.
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     05/16/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_VCT_ASMONITORINGSESSION_GETDetail]
(  
 	@LangID							NVARCHAR(50), 
	@idfMonitoringSession			BIGINT
)  
AS

DECLARE @returnMsg					VARCHAR(MAX) = 'Success';
DECLARE @returnCode					BIGINT = 0;

BEGIN
	BEGIN TRY  	
		SELECT						tms.idfMonitoringSession,
									tms.strMonitoringSessionID,
									tms.idfsMonitoringSessionStatus,
									MonitoringSessionStatus.name AS MonitoringSessionStatus,
									tms.idfsDiagnosis,
									Diagnosis.name AS Diagnosis, 
									tms.datEnteredDate,
									tms.datStartDate,
									tms.datEndDate,
									tms.idfsCountry,
									tms.idfsRegion,
									Region.name AS Region,
									tms.idfsRayon,
									Rayon.name AS Rayon, 
									tms.idfsSettlement,
									Settlement.name AS Town,
									tms.idfPersonEnteredBy,
									ISNULL(p.strFamilyName, N'') + ISNULL(', ' + p.strFirstName, '') + ISNULL(' ' + p.strSecondName, '') AS PersonEnteredByName,
									tms.idfsSite,
									SiteName.name AS SiteName, 
									tms.LegacySessionID AS AvianOrLivestock, 
									c.idfCampaign, 
									c.strCampaignName, 
									c.idfsCampaignType, 
									CampaignType.name AS CampaignType 
		FROM						dbo.tlbMonitoringSession tms 
		LEFT JOIN					dbo.tlbCampaign AS c 
		ON							c.idfCampaign = tms.idfCampaign 
		LEFT JOIN					dbo.FN_GBL_ReferenceRepair(@LangId,19000116) CampaignType 
		ON							c.idfsCampaignType = CampaignType.idfsReference
		LEFT JOIN					dbo.FN_GBL_ReferenceRepair(@LangId,19000117) MonitoringSessionStatus 
		ON							MonitoringSessionStatus.idfsReference = tms.idfsMonitoringSessionStatus
		LEFT JOIN					dbo.FN_GBL_ReferenceRepair(@LangID,19000019) Diagnosis
		ON							Diagnosis.idfsReference = tms.idfsDiagnosis
		LEFT JOIN					dbo.FN_GBL_GIS_REFERENCE(@LangID,19000001) Country
		ON							Country.idfsReference = tms.idfsCountry
		LEFT JOIN					dbo.FN_GBL_GIS_REFERENCE(@LangID,19000002) Rayon
		ON							Rayon.idfsReference = tms.idfsRayon
		LEFT JOIN					dbo.FN_GBL_GIS_REFERENCE(@LangID,19000003) Region
		ON							Region.idfsReference = tms.idfsRegion
		LEFT JOIN					dbo.FN_GBL_GIS_REFERENCE(@LangID,19000004) Settlement
		ON							Settlement.idfsReference = tms.idfsSettlement
		LEFT JOIN					dbo.tlbPerson p 
		ON							p.idfPerson = tms.idfPersonEnteredBy
		LEFT JOIN					dbo.FN_GBL_INSTITUTION(@LangID) AS SiteName 
		ON 							SiteName.idfsSite = tms.idfsSite 
		WHERE						tms.idfMonitoringSession = @idfMonitoringSession 
		AND							tms.intRowStatus = 0;
  
		SELECT						@returnCode, @returnMsg;
	END TRY  
	BEGIN CATCH 
		SET							@returnMsg = 'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
										+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
										+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
										+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
										+ ' ErrorLine: ' +  CONVERT(VARCHAR, ISNULL(ERROR_LINE(), ''))
										+ ' ErrorMessage: ' + ERROR_MESSAGE();

		SET							@returnCode = ERROR_NUMBER();
		SELECT						@returnCode, @returnMsg;
	END CATCH
END

