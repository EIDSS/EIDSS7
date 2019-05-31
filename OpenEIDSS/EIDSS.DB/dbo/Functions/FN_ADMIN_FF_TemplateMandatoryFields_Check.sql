
-- ================================================================================================
-- Name: FN_ADMIN_FF_TemplateMandatoryFields_Check
-- Description: 
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE FUNCTION [dbo].[FN_ADMIN_FF_TemplateMandatoryFields_Check] 
(
	@idfsFormTemplate BIGINT	
)
RETURNS @ResultTable TABLE
(
	[Result] BIT
)
AS
BEGIN
	
	DECLARE
		@Result BIT

	SET @Result = 0
	
	IF EXISTS(SELECT TOP 1 1 
			  FROM dbo.ffParameterForTemplate
			  WHERE idfsEditMode = 10068003 
					AND idfsFormTemplate = @idfsFormTemplate)
		SET @Result = 1
		
	INSERT INTO @ResultTable([Result]) 
	VALUES (@Result);	

	RETURN;
END
