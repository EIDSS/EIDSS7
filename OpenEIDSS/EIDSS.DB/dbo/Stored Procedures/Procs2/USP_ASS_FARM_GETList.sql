--*************************************************************
-- Name 				: USP_ASS_FARM_GETList
-- Description			: Selects Farm for Active Surveillance Monitoring Session form
--						: This SP does not return the error is dataset. The error is raised to be caught in caller (SP) error handler
-- Author               : Maheshwar Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************
  
CREATE PROCEDURE [dbo].[USP_ASS_FARM_GETList]
	(
	@idfMonitoringSession	AS	BIGINT		--##PARAM @@idfMonitoringSession - Active Surveillance Session ID  
	)  
AS  

BEGIN

	BEGIN TRY  	

		SELECT 
			idfFarm  
			,tlbFarm.idfFarmActual as idfRootFarm  
			,strFarmCode  
			,strNationalName  
			,dbo.FN_GBL_ConcatFullName(tlbHuman.strLastName ,tlbHuman.strFirstName ,tlbHuman.strSecondName) AS strOwnerName  
			,idfsOwnershipStructure  
			,idfsLivestockProductionType  
		   ,tlbFarm.idfMonitoringSession 
		   ,CAST (0 AS bit) AS blnNewFarm  
		FROM 
			tlbFarm  
			LEFT OUTER JOIN tlbHuman ON 
				tlbHuman.idfHuman=tlbFarm.idfHuman 
				AND  
				tlbHuman.intRowStatus = 0  
		WHERE
			tlbFarm.idfMonitoringSession = @idfMonitoringSession  
			AND 
			tlbFarm.intRowStatus = 0  

	END TRY  

	BEGIN CATCH 

		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;  

		SELECT   
			@ErrorMessage = ERROR_MESSAGE()
			,@ErrorSeverity = ERROR_SEVERITY()
			,@ErrorState = ERROR_STATE()

		RAISERROR 
			(
			@ErrorMessage,	-- Message text.  
			@ErrorSeverity, -- Severity.  
			@ErrorState		-- State.  
			); 
	END CATCH
END