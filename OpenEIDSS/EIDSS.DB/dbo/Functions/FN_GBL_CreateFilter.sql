
--*************************************************************
-- Name 				: FN_GBL_CreateFilter
-- Description			: Create a where clause string to be consumed by caller to filter data
--          
-- Author               : Maheshwar Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************

CREATE FUNCTION [dbo].[FN_GBL_CreateFilter]
(
	@SearchField	NVARCHAR(400)
	,@SearchValues	NVARCHAR(4000)
)

Returns NVARCHAR(MAX)

AS

BEGIN

	DECLARE @sql			NVARCHAR(MAX) = ''
			,@nl			CHAR(2) = CHAR(13) + CHAR(10)
			,@SearchValue	SQL_VARIANT						-- fnsysSplitList returns "value" as SQL_VARIANT.
			,@StartLoop		INT = 0

	IF @SearchValues IS NOT NULL
			BEGIN

				DECLARE GLBCURSOR CURSOR FOR
				Select [Value] From dbo.fnsysSplitList(@SearchValues, 0, '+')

				OPEN GLBCURSOR
					
				FETCH NEXT FROM GLBCURSOR INTO @SearchValue

				SELECT @sql += ' AND ('
				SET @StartLoop = 0
				WHILE @@FETCH_STATUS = 0  
					BEGIN
						IF @StartLoop <> 0 SELECT @sql += ' OR '
						SET @StartLoop = @StartLoop + 1
						SELECT @sql += @SearchField + ' LIKE ''%' + CAST(@SearchValue AS NVARCHAR(50)) + '%'''
						FETCH NEXT FROM GLBCURSOR INTO @SearchValue
					END  

				CLOSE GLBCURSOR  
				DEALLOCATE GLBCURSOR  

				SELECT @sql += ')' + @nl

			END

     RETURN @sql

END

