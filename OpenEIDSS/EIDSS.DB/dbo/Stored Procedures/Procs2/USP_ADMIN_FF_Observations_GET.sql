
-- ================================================================================================
-- Name: USP_ADMIN_FF_Observations_GET
-- Description: Retrieves the list of Observations
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Stephen Long    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Observations_GET]
(
	@observationList NVARCHAR(MAX)	
)
AS
BEGIN

	DECLARE
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX)       
	
	BEGIN TRY
	   SELECT idfObservation
			  ,idfsFormTemplate
	   FROM dbo.tlbObservation
	   WHERE idfObservation IN (SELECT CAST([Value] AS BIGINT)
								FROM [dbo].[fnsysSplitList](@observationList, NULL, NULL))
			 AND intRowStatus = 0;
			 
		COMMIT TRANSACTION;
	END TRY 
	BEGIN CATCH   
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH; 
END

