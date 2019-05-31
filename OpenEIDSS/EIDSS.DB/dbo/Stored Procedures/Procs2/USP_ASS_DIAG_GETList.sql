--*************************************************************
-- Name 				: USP_ASS_DIAG_GETList
-- Description			: Selects diagnosis for Active Surveillance Monitoring Session form
--						: This SP does not return the error is dataset. The error is raised to be caught in caller (SP) error handler
-- Author               : Maheshwar Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************
  
CREATE PROCEDURE [dbo].[USP_ASS_DIAG_GETList]
	(
	@idfMonitoringSession	AS	BIGINT		--##PARAM @@idfMonitoringSession - Active Surveillance Session ID  
	)  
AS  

BEGIN

	BEGIN TRY  	

		SELECT   
			idfMonitoringSessionToDiagnosis   
			,idfMonitoringSession  
			,idfsDiagnosis   
			,idfsSpeciesType
			,intOrder  
			,idfsSampleType
		FROM 
			tlbMonitoringSessionToDiagnosis  
		WHERE  
			idfMonitoringSession = @idfMonitoringSession  
			AND 
			intRowStatus = 0  
		ORDER BY 
			intOrder  

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