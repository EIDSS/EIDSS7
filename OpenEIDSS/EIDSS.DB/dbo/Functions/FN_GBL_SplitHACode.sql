
--*************************************************************
-- Name 				: FN_GBL_SplitHACode
-- Description			: The function splits the inTHACode passed in as a parameter returns a table
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
--@intHACode Code List
--0		None
--2		Human
--4		Exophyte
--8		Plant
--16	Soil
--32	Livestock
--64	Avian
--128	Vector
--256	Syndromic
--510	All			-- All will not work.
--
-- Testing code:
-- SELECT * FROM [dbo].[fnSplitHACode] (130,510)
--*************************************************************
CREATE FUNCTION [dbo].[FN_GBL_SplitHACode]
	(
	 @HACode		BIGINT
	,@HACodeMax		BIGINT = 510
	)
RETURNS TABLE
AS
	RETURN
	(
		--SELECT	0 AS intHACode 
		--UNION
		SELECT	intHACode 
		FROM 	trtHACodeList 
		WHERE	intHACode & @HACodeMax > 0
		AND 	intHACode & ISNULL(@HACode, @HACodeMax) > 0
		AND		intHACode <> @HACodeMax
	)

