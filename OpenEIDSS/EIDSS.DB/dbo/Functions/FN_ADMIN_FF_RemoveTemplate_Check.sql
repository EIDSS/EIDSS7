
-- ================================================================================================
-- Name: [FN_ADMIN_FF_RemoveTemplate_Check]
-- Description: Remove Template Check.
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE FUNCTION [dbo].[FN_ADMIN_FF_RemoveTemplate_Check] 
(
	@idfsFormTemplate BIGINT	
)
RETURNS @ResultTable TABLE
(
	[ErrorMessage] NVARCHAR(400)	COLLATE database_default
)
AS
BEGIN
	
	DECLARE
		@ErrorMessage NVARCHAR(400)

	IF EXISTS(SELECT TOP 1 1
				  FROM dbo.tlbObservation 
				  WHERE idfsFormTemplate = @idfsFormTemplate 
						AND intRowStatus = 0)
			SET  @ErrorMessage = 'TemplateRemove_Has_Observation'
		
	INSERT INTO @ResultTable(ErrorMessage) 
	VALUES (@ErrorMessage);	

	RETURN;
END
