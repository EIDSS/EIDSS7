--*************************************************************
-- Name 				: USP_VCT_ASSESSION_GETDetail
-- Description			: SELECTs data for Active Surveillance Campaign form
--          
-- Author               : Maheshwar Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************
  
CREATE PROCEDURE [dbo].[USP_VCT_ASSESSION_GETDetail]
	(
	@idfMonitoringSession	AS	BIGINT		--##PARAM @@idfMonitoringSession - Active Surveillance Session ID  
 	,@LangID				AS NVARCHAR(50)	--##PARAM @LangID - language ID  
	)  
AS  

DECLARE @returnMsg VARCHAR(MAX) = 'Success'
DECLARE @returnCode BIGINT = 0

BEGIN

	BEGIN TRY  	

		-- 0- Session  
		SELECT	
			idfMonitoringSession  
			,tlbMonitoringSession.strMonitoringSessionID AS SetMonitoringSessionstrSessionID
			,tlbMonitoringSession.idfsMonitoringSessionStatus AS SetMonitoringidfsSessionStatus
			,tlbMonitoringSession.idfsCountry AS SetMonitoringSessionidfsCountry
			,tlbMonitoringSession.idfsRegion AS SetMonitoringSessionidfsRegion
			,tlbMonitoringSession.idfsRayon AS SetMonitoringSessionidfsRayon
			,tlbMonitoringSession.idfsSettlement AS SetMonitoringSessionidfsSettlement
			
			--For location control
			,ISNULL(tlbMonitoringSession.idfsCountry, '') AS idfsCountry
			,ISNULL(tlbMonitoringSession.idfsRegion, '') AS idfsRegion
			,ISNULL(tlbMonitoringSession.idfsRayon, '') AS idfsRayon
			,ISNULL(tlbMonitoringSession.idfsSettlement, '') AS idfsSettlement

			,tlbMonitoringSession.idfPersonEnteredBy  as SetMonitoringSessionidfPersonEnteredBy
			,tlbMonitoringSession.idfCampaign AS SetMonitoringSessionidfCampaign
			,tlbMonitoringSession.idfsSite 
			,tlbMonitoringSession.datEnteredDate AS SetMonitoringSessiondatEnteredDate
			,tlbMonitoringSession.datStartDate AS SetMonitoringSessiondatStartDate
			,tlbMonitoringSession.datEndDate AS SetMonitoringSessiondatEndDate
			,tlbMonitoringSession.idfsDiagnosis AS SetMonitoringSessionidfsDiagnosis
			,CONVERT(UNIQUEIDENTIFIER, tlbMonitoringSession.strReservedAttribute) AS uidOfflineCaseID
			,tlbCampaign.strCampaignID 
			,tlbCampaign.idfCampaign 
			,tlbCampaign.idfsDiagnosis AS idfsDiagnosis
			,tlbCampaign.idfsCampaignStatus
			,tlbCampaign.strCampaignName 
			,CampaignType.[name] As CampaignType
			,tlbCampaign.idfsCampaignType AS SessionSetCampaignType  
			,tlbCampaign.datCampaignDateStart  
			,tlbCampaign.datCampaignDateEnd  
			,tlbMonitoringSession.datModificationForArchiveDate
			,tstSite.strSiteName AS SessionSetSite   
		FROM	
			tlbMonitoringSession  
			LEFT JOIN tlbCampaign ON 
				tlbCampaign.idfCampaign = tlbMonitoringSession.idfCampaign  
			INNER JOIN dbo.FN_GBL_ReferenceRepair(@LangId, 19000116) CampaignType  ON
				CampaignType.idfsReference = tlbCampaign.idfsCampaignType
			LEFT OUTER JOIN tstSite ON
				tlbCampaign.idfsSite = tstSite.idfsSite
		WHERE
			tlbMonitoringSession.idfMonitoringSession = @idfMonitoringSession  
			AND 
			tlbMonitoringSession.intRowStatus = 0  
  
		--1 Diagnosis  
		EXEC USP_ASS_DIAG_GETList @idfMonitoringSession    
  
		--2 Farms  
		EXEC USP_ASS_FARM_GETList @idfMonitoringSession

		--3 Farm Tree  
		EXEC USP_ASS_FARMTREE_GETDetail @idfMonitoringSession  
  
		--4 Animals  
		EXEC USP_ASS_ANIMAL_GETDetail @idfMonitoringSession  

		--5 Actions  
		EXECUTE USP_ASS_ACTION_GETDetail @idfMonitoringSession  

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
