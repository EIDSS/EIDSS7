--*****************************************************************************
-- Name: USP_VCT_ASMONITORINGSESSIONS_GETList
-- Description: SELECTs data for Active Surveillance Monitoring Sessions
-- based on search criteria provided
--
-- Author: Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
-- Stephen Long    06/06/2018 Added campaign id parameter and additional 
--                            where clause check.
--
-- Testing code:
--*************************************************************
CREATE PROCEDURE [dbo].[USP_VCT_ASMONITORINGSESSIONS_GETList]
(  
	@MonitoringSessionstrID					NVARCHAR(200) = NULL, -- strMonitoringSessionId
	@SessionCategoryID						BIGINT = NULL,
	@MonitoringSessionidfsStatus			BIGINT = NULL,
	@MonitoringSessionDatEnteredFrom		DATETIME = NULL,
	@MonitoringSessionDatEnteredTo			DATETIME = NULL,
	@MonitoringSessionidfsRegion			BIGINT = NULL,
	@MonitoringSessionidfsRayon				BIGINT = NULL,
	@MonitoringSessionidfsDiagnosis			BIGINT = NULL,
	@idfCampaign							BIGINT = NULL, 
 	@LangID									NVARCHAR(50) 
)  
AS  
DECLARE @returnMsg							VARCHAR(MAX) = 'Success'
DECLARE @returnCode							BIGINT = 0

BEGIN
	BEGIN TRY  	
		SELECT								tms.idfMonitoringSession,
											tms.strMonitoringSessionID,
											tms.idfsMonitoringSessionStatus,
											MonitoringSessionStatus.name AS MonitoringSessionStatus,
											tms.idfsDiagnosis,
											Diagnosis.name AS Diagnosis, 
											tms.datEnteredDate,
											tms.datStartDate,
											tms.datEndDate,
											tms.idfsRegion,
											Region.name AS Region,
											tms.idfsRayon,
											Rayon.name AS Rayon, 
											tms.idfsSettlement,
											Settlement.name AS Town,
											tms.idfPersonEnteredBy,
											ISNULL(p.strFirstName, '') + ' ' + ISNULL(p.strFamilyName, '') AS Officer,
											tms.idfsSite,
											SiteName.EnglishName
		FROM								dbo.tlbMonitoringSession tms
		LEFT JOIN							dbo.FN_GBL_ReferenceRepair(@LangID, 19000117) MonitoringSessionStatus ON
											MonitoringSessionStatus.idfsReference = tms.idfsMonitoringSessionStatus
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000019) Diagnosis
		ON									Diagnosis.idfsReference = tms.idfsDiagnosis
		LEFT JOIN							FN_GBL_GIS_REFERENCE(@LangID, 19000002) Rayon
		ON									Rayon.idfsReference = tms.idfsRayon
		LEFT JOIN							FN_GBL_GIS_REFERENCE(@LangID,19000003) Region
		ON									Region.idfsReference = tms.idfsRegion
		LEFT JOIN							FN_GBL_GIS_REFERENCE(@LangID,19000004) Settlement
		ON									Settlement.idfsReference = tms.idfsSettlement
		LEFT JOIN							dbo.tlbPerson p ON
											p.idfPerson = tms.idfPersonEnteredBy
		LEFT JOIN							dbo.FN_GBL_INSTITUTION(@LangID) AS  SiteName ON 
											SiteName.idfsSite= tms.idfsSite 
		WHERE								((tms.strMonitoringSessionID LIKE CASE ISNULL(@MonitoringSessionstrID, '') WHEN '' THEN strMonitoringSessionID ELSE '%' + @MonitoringSessionstrID +'%' END) OR @MonitoringSessionstrID IS NULL)
		AND									((tms.idfsMonitoringSessionStatus = CASE ISNULL(@MonitoringSessionidfsStatus, '') WHEN '' THEN idfsMonitoringSessionStatus ELSE @MonitoringSessionidfsStatus END) OR @MonitoringSessionidfsStatus IS NULL)
		AND									((tms.idfsDiagnosis = CASE ISNULL(@MonitoringSessionidfsDiagnosis, '') WHEN '' THEN tms.idfsDiagnosis ELSE @MonitoringSessionidfsDiagnosis END) OR @MonitoringSessionidfsDiagnosis IS NULL)
		AND									((tms.idfsRegion = CASE ISNULL(@MonitoringSessionidfsRegion, '') WHEN '' THEN tms.idfsRegion ELSE @MonitoringSessionidfsRegion END) OR @MonitoringSessionidfsRegion IS NULL)
		AND									((tms.idfsRayon = CASE ISNULL(@MonitoringSessionidfsRayon, '') WHEN '' THEN tms.idfsRayon ELSE @MonitoringSessionidfsRayon END) OR @MonitoringSessionidfsRayon IS NULL)
		AND									tms.datEnteredDate >= CASE ISNULL(@MonitoringSessionDatEnteredFrom, '') 
												WHEN '' THEN tms.datEnteredDate ELSE @MonitoringSessionDatEnteredFrom END
		AND									tms.datEnteredDate <= CASE ISNULL(@MonitoringSessionDatEnteredTo, '') 
												WHEN '' THEN tms.datEnteredDate ELSE @MonitoringSessionDatEnteredTo END
		AND									tms.intRowStatus = 0  
		AND									((tms.SessionCategoryID = @SessionCategoryID) OR (@SessionCategoryID IS NULL)) 
		AND									((tms.idfCampaign = @idfCampaign) OR (@idfCampaign IS NULL));
  
		SELECT								@returnCode, @returnMsg;
	END TRY  
	BEGIN CATCH 
		SET									@returnMsg = 'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
												+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
												+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
												+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
												+ ' ErrorLine: ' + CONVERT(VARCHAR, ISNULL(ERROR_LINE(), ''))
												+ ' ErrorMessage: '+ ERROR_MESSAGE();

		SET									@returnCode = ERROR_NUMBER();
		SELECT								@returnCode, @returnMsg;
	END CATCH
END


