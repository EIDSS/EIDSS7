--*************************************************************
-- Name 				: USP_GBL_ASSESSION_GETList
-- Description			: SELECTs data for Human Active Surveillance Monitoring Sessions
--							based on search criteria provided
--                      
-- Author: M.Jessee
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Michael Jessee	05/04/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_GBL_ASSESSION_GETList]
(  
	@MonitoringSessionstrID					AS	NVARCHAR(200), -- strMonitoringSessionId
	@MonitoringSessionidfsStatus			AS	BIGINT,
	@MonitoringSessionDatEnteredFrom		AS	DATETIME,
	@MonitoringSessionDatEnteredTo			AS	DATETIME,
	@MonitoringSessionidfsRegion			AS	BIGINT,
	@MonitoringSessionidfsRayon				AS	BIGINT,
--	@MonitoringSessionidfsSettlement		AS	BIGINT,
	@MonitoringSessionidfsDiagnosis			AS	BIGINT,
	@MonitoringSessionstrCampaignID			AS	NVARCHAR(50), 
 	@LangID									AS	NVARCHAR(50), --##PARAM @LangID - language ID  
	@SessionModule							AS  NVARCHAR(100) -- expected values are: Vet , Human
)  
AS  
DECLARE @returnMsg VARCHAR(MAX) = 'Success'
DECLARE @returnCode BIGINT = 0
	DECLARE @SessionCategory NVARCHAR (100)

BEGIN

	BEGIN TRY  	

			--	set session category value based on input campaign module

		SET @SessionCategory =
			CASE UPPER ( @SessionModule )
				WHEN UPPER ( 'Human' ) THEN  'Human Active Surveillance Session'
				WHEN UPPER ( 'Vet'	 ) THEN  'Veterinary Active Surveillance Session'
				ELSE '-1'
				END
		IF @SessionCategory = '-1' 
			BEGIN
				RAISERROR ('Invalid Session Module', 16, 1)
				RETURN 
			END


		-- Monitoring Sesion List
		SELECT	tms.idfMonitoringSession,
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
				Campaign.strCampaignID,
				tms.idfPersonEnteredBy,
				ISNULL(person.strFirstName, '') + ' ' + ISNULL(person.strFamilyName, '') AS Officer,
				tms.idfsSite,
				SiteName.EnglishName,
				tms.SessionCategoryID
		FROM	dbo.tlbMonitoringSession tms
		LEFT JOIN	dbo.FN_GBL_ReferenceRepair(@LangId,19000117) MonitoringSessionStatus 
		ON			MonitoringSessionStatus.idfsReference = tms.idfsMonitoringSessionStatus
		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000019) Diagnosis
		ON			Diagnosis.idfsReference = tms.idfsDiagnosis
		LEFT JOIN	FN_GBL_GIS_REFERENCE(@LangID,19000002) Rayon
		ON			Rayon.idfsReference = tms.idfsRayon
		LEFT JOIN	FN_GBL_GIS_REFERENCE(@LangID,19000003) Region
		ON			Region.idfsReference = tms.idfsRegion
		LEFT JOIN	FN_GBL_GIS_REFERENCE(@LangID,19000004) Settlement
		ON			Settlement.idfsReference = tms.idfsSettlement
		LEFT JOIN	dbo.tlbCampaign Campaign
		ON			Campaign.idfCampaign = tms.idfCampaign
		LEFT JOIN	dbo.tlbPerson person 
		ON			person.idfPerson = tms.idfPersonEnteredBy
		LEFT JOIN	dbo.FN_GBL_INSTITUTION(@LangID) AS  SiteName 
		ON			SiteName.idfsSite= tms.idfsSite 
		WHERE		
		(							
					(CASE WHEN @MonitoringSessionstrID IS NULL THEN 1 WHEN ISNULL(tms.strMonitoringSessionID,'') LIKE '%' + @MonitoringSessionstrID +'%' THEN 1 WHEN tms.strMonitoringSessionID = @MonitoringSessionstrID THEN 1 ELSE 0 END = 1)
			AND		(CASE WHEN @MonitoringSessionidfsStatus IS NULL THEN 1 WHEN ISNULL(tms.idfsMonitoringSessionStatus,'') = @MonitoringSessionidfsStatus  THEN 1 WHEN tms.idfsMonitoringSessionStatus = @MonitoringSessionidfsStatus THEN 1 ELSE 0 END = 1)
			AND		(CASE WHEN @MonitoringSessionidfsDiagnosis IS NULL THEN 1 WHEN ISNULL(tms.idfsDiagnosis,'') = @MonitoringSessionidfsDiagnosis THEN 1 WHEN tms.idfsDiagnosis = @MonitoringSessionidfsDiagnosis THEN 1 ELSE 0 END = 1)
			AND		(CASE WHEN @MonitoringSessionidfsRegion IS NULL THEN 1 WHEN ISNULL(tms.idfsRegion,'') = @MonitoringSessionidfsRegion THEN 1 WHEN tms.idfsRegion = @MonitoringSessionidfsRegion THEN 1 ELSE 0 END = 1)
			AND		(CASE WHEN @MonitoringSessionidfsRayon IS NULL THEN 1 WHEN ISNULL(tms.idfsRayon,'') = @MonitoringSessionidfsRayon  THEN 1 WHEN tms.idfsRayon = @MonitoringSessionidfsRayon THEN 1 ELSE 0 END = 1)
			AND		(CASE WHEN @MonitoringSessionstrCampaignID IS NULL THEN 1 WHEN ISNULL(Campaign.strCampaignID,'') LIKE '%' + @MonitoringSessionstrCampaignID + '%'  THEN 1 WHEN Campaign.strCampaignID = @MonitoringSessionstrCampaignID THEN 1 ELSE 0 END = 1)
			AND		tms.datEnteredDate >= CASE ISNULL(@MonitoringSessionDatEnteredFrom, '') 
										WHEN '' THEN tms.datEnteredDate ELSE @MonitoringSessionDatEnteredFrom END
			AND		tms.datEnteredDate <= CASE ISNULL(@MonitoringSessionDatEnteredTo, '') 
										WHEN '' THEN tms.datEnteredDate ELSE @MonitoringSessionDatEnteredTo END
			AND		tms.intRowStatus = 0  
			AND		tms.SessionCategoryID = ( SELECT idfsReference from dbo.FN_GBL_ReferenceRepair('en',19000169) where strDefault = @SessionCategory )
		)
		

		SELECT @returnCode, @returnMsg
	END TRY  

	BEGIN CATCH 
		SET @returnMsg = 
			'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
			+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
			+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
			+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
			+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
			+ ' ErrorMessage: '+ ERROR_MESSAGE()

		SET @returnCode = ERROR_NUMBER()
		SELECT @returnCode, @returnMsg
	END CATCH
END


