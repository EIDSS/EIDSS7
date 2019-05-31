
--*************************************************************
-- Name 				:	USP_HUM_HUMAN_DISEASE_DEL
-- Description			:	delete human disease record
--          
-- Author               :	Jeff Johnson
-- Revision History
--Name  Date		Change Detail
--JWJ	20180508	created
--
--
---exec USP_HUM_HUMAN_DISEASE_DEL yourTlbHumanCaseId
--*************************************************************
CREATE PROCEDURE [dbo].[USP_HUM_HUMAN_DISEASE_DEL]
(
	@LangID			NVARCHAR(50), 
	@idfHumanCase	BIGINT  -- tlbHumanCase.idfHumanCase Primary Key
)
AS
DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			UPDATE dbo.tlbHumanCase
			SET intRowStatus = 1						
			WHERE	idfHumanCase = @idfHumanCase
			AND		intRowStatus = 0
			
			IF @@TRANCOUNT > 0 
				COMMIT
			
			SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMsg'
	END TRY
	BEGIN CATCH
			IF @@Trancount = 1 
				THROW;
				
	END CATCH
END