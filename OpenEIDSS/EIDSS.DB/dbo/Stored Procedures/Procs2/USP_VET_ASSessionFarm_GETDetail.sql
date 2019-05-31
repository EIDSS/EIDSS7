
 

-- ============================================================================
-- Name: USP_VET_ASSessionFarm_SET
-- Description:	Selects data for Active Surveillance Monitoring Session form 
-- 
--                      
-- Author: M.Jessee
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Michael Jessee	05/04/2018 Initial release.
-- ============================================================================

  
  
/*  
--Example of procedure call:  
DECLARE @idfMonitoringSession bigint  
SET @idfMonitoringSession=706800000000  
EXECUTE USP_VET_ASSessionFarm_GETDetail   
 @idfMonitoringSession  
  
*/  
  
  
  
CREATE         PROCEDURE [dbo].[USP_VET_ASSessionFarm_GETDetail](  
 @idfMonitoringSession AS BIGINT--##PARAM @iidfMonitoringSession - AS session ID  
 --,@LangID AS nvarchar(50)--##PARAM @LangID - language ID  
)  
AS  


DECLARE @returnMsg VARCHAR(MAX) = 'Success'
DECLARE @returnCode BIGINT = 0

BEGIN

	BEGIN TRY  	


			--0 Farms  
			SELECT idfFarm  
			   ,tlbFarm.idfFarmActual AS idfRootFarm  
				,strFarmCode  
				,strNationalName  
				,dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName ,tlbHuman.strSecondName) as strOwnerName  
				,idfsOwnershipStructure  
				,idfsLivestockProductionType  
			   ,@idfMonitoringSession AS idfMonitoringSession 
			   ,CAST (0 AS BIT) AS blnNewFarm  
			   ,isnull(CAST ((SELECT COUNT(*) FROM tlbFarm i WHERE i.idfFarm = tlbFarm.idfFarm and i.idfMonitoringSession = @idfMonitoringSession and i.intRowStatus = 0) AS BIT),0) AS blnIsDetailsFarm
			   ,isnull(CAST ((SELECT COUNT(*) FROM tlbMonitoringSessionSummary i WHERE i.idfFarm = tlbFarm.idfFarm and i.idfMonitoringSession = @idfMonitoringSession and i.intRowStatus = 0) AS BIT),0) AS blnIsSummaryFarm
			   ,tlbFarm.idfHuman AS idfOwner
			FROM tlbFarm  
			LEFT OUTER JOIN tlbHuman   
			 ON tlbHuman.idfHuman=tlbFarm.idfHuman and  
				tlbHuman.intRowStatus = 0  
			WHERE  
			 tlbFarm.idfFarm in (
				SELECT DISTINCT idfFarm FROM 
					(
						SELECT idfFarm 
						FROM tlbFarm 
						WHERE tlbFarm.idfMonitoringSession = @idfMonitoringSession
						and tlbFarm.intRowStatus = 0
						UNION all 
						SELECT idfFarm 
						FROM  tlbMonitoringSessionSummary
						WHERE tlbMonitoringSessionSummary.idfMonitoringSession = @idfMonitoringSession
						and tlbMonitoringSessionSummary.intRowStatus = 0
					) f
				)
			 and tlbFarm.intRowStatus = 0  
   
 
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

