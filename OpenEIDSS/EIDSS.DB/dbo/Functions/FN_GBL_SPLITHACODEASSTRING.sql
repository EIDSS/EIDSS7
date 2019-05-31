
--*************************************************************
-- Name 				: FN_GBL_SPLITHACODEASSTRING
-- Description			: The function splits the inTHACode passed in as a parameter returns a string
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
-- SELECT * FROM [dbo].[fnSplitHACode] (130,510)
--*************************************************************
CREATE FUNCTION [dbo].[FN_GBL_SPLITHACODEASSTRING]
	(
	 @HACode		BIGINT
	,@HACodeMax		BIGINT = 510
	)
RETURNS VARCHAR(200)
AS
BEGIN
	DECLARE	@returnString NVARCHAR(20) ='' 
	DECLARE @strIntHACode NVARCHAR(20) ='' 
	DECLARE	intHACodeCustor CURSOR
	FOR
		SELECT	intHACode 
		FROM 	trtHACodeList 
		WHERE	intHACode & @HACodeMax > 0
		AND 	intHACode & ISNULL(@HACode, @HACodeMax) > 0
		AND		intHACode <> @HACodeMax
	IF @HACODE <> 0 OR @HACode IS NOT NULL
		BEGIN
			-- Open Cusros
			OPEN intHACodeCustor;

			FETCH 
			NEXT 
			FROM intHACodeCustor 
			INTO @strIntHACode

			WHILE @@FETCH_STATUS = 0
			BEGIN
		
				SET @returnString = @returnString + @strIntHACode + ',' 

				FETCH 
				NEXT FROM intHACodeCustor 
				INTO @strIntHACode;
			END;

			CLOSE intHACodeCustor;
			DEALLOCATE intHACodeCustor;

			SET @returnString = LEFT(@returnString, LEN(@returnString)-1)
		END
	ELSE
		BEGIN
			SET @returnString = ''
		END

	RETURN @returnString
END
