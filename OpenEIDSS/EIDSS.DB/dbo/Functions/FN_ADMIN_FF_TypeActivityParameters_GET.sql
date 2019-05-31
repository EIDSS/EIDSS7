

-- ================================================================================================
-- Name: FN_ADMIN_FF_TypeActivityParameters_GET
-- Description: Retreives FN_ADMIN_FF_TypeActivityParameters_GET
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE FUNCTION [dbo].[FN_ADMIN_FF_TypeActivityParameters_GET]
(
	@idfsParameter Bigint
)
RETURNS BIGINT
BEGIN
	DECLARE @Result Bigint, 
			@idfsSection Bigint, 
			@blnGrid Bit, 
			@matrixType bigint

	SELECT TOP 1 @matrixType = idfsMatrixType 
	FROM dbo.trtMatrixType MT
	INNER JOIN dbo.ffParameter P On MT.idfsFormType = P.idfsFormType
	WHERE P.idfsParameter = @idfsParameter;
				
	IF (@matrixType is not null and @matrixType > 0) 
	BEGIN
		SET @Result = @matrixType
	END 
	ELSE
	BEGIN
		SELECT @idfsSection = P.[idfsSection], 
			   @blnGrid = [blnGrid]
		FROM dbo.ffParameter P
		LEFT JOIN dbo.ffSection S On P.idfsSection = S.idfsSection And (S.intRowStatus = 0)
		WHERE idfsParameter = @idfsParameter
		AND (P.intRowStatus = 0);					
	
		SELECT @Result = CASE
							WHEN (@idfsSection Is Null  or @blnGrid = 0) THEN 0			
							WHEN @blnGrid = 1 THEN 1
							END;
	END;	
	RETURN @Result
END

