
--*************************************************************
-- Name: [USP_OMM_Session_Set]
-- Description: Deletion method for outbreak sessions
--          
-- Author: Doug Albanese
-- Revision History
--		Name       Date       Change Detail
--    Doug Albanese	2/6/2019	New SP for deleting Outbreaks	
--*************************************************************
CREATE PROCEDURE [dbo].[USP_OMM_Session_Del]
(    
	@idfOutbreak								BIGINT
)
AS

BEGIN
	
	DECLARE	@returnCode						INT = 0;
	DECLARE @returnMsg						NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY 

		--intRowStatus 
		-- 1 = inactive or deleted.
		-- 0 = active

		UPDATE		tlbOutbreak	
		SET			intRowStatus = 1
		WHERE		idfOutbreak = @idfOutbreak

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT = 1 
			ROLLBACK;

		;throw;
	END CATCH
	
	SELECT @returnCode as ReturnCode, @returnMsg as ReturnMessage

END