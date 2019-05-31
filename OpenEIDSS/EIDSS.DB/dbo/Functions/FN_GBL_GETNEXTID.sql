-- =============================================
-- Author:		LAMONT MITCHELL
-- Create date: 1/16/19
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[FN_GBL_GETNEXTID]
(
	-- Add the parameters for the function here
 @tableName VARCHAR(100),
 @idfsKey	BIGINT 
)
RETURNS BIGINT
AS
BEGIN
DECLARE @returnCode		INT = 0
DECLARE @returnMsg		NVARCHAR(max) = 'Success'
DECLARE @sqlString		NVARCHAR(max) 
DECLARE @keyfldname		VARCHAR(100)
DECLARE @keyValue		BIGINT 


 
		DECLARE @temp	TABLE (DBNAME VARCHAR(100), ROW_NUM INT, TABLE_NAME VARCHAR(100), COLUMN_NAME VARCHAR(100), Key_Ordinal INT);
		--DECLARE @tmpKey TABLE (lastKey bigint )

		--IF OBJECT_ID('tempdb..#tmpkey') IS NOT NULL DROP TABLE #tmpkey
		--IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
		--CREATE TABLE  #tmpkey  (lastkey BIGINT)
		INSERT INTO		@temp
		SELECT			DB_NAME() AS DBNAME
						,ROW_NUMBER() OVER (ORDER BY o.name) AS ROW_NUM
						,o.name AS TABLE_NAME
						,c.name AS COLUMN_NAME
						,ic.key_ordinal
		--INTO @temp
		FROM			sys.indexes i
						INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id=ic.index_id
						INNER JOIN sys.COLUMNs c ON ic.object_id = c.object_id AND ic.column_id=c.column_id
						INNER JOIN sys.objects o ON i.object_id = o.object_id
		WHERE			i.is_primary_key=1
		AND				LEFT(o.name, 1) NOT IN ('_')
		AND				o.name = @tableName
		AND				i.type_desc IN('CLUSTERED')
		ORDER BY		o.name, i.name, ic.key_ordinal;

		SELECT @sqlstring = 'DECLARE @tempKey BIGINT ' + CHAR(10) + CHAR(13) +
							'DECLARE @tmpKey TABLE (lastKey BIGINT) ' + CHAR(10) + CHAR(13) +
							'SET @tempKey = (SELECT TOP 1 ' + COLUMN_NAME + ' FROM  '+ TABLE_NAME + ' ORDER BY '+ COLUMN_NAME +' DESC) ' + CHAR(10) + CHAR(13) +
							'INSERT INTO @tmpKey (lastKey) VALUES (@tempKey) ' + CHAR(10) + CHAR(13) + 
							'SELECT @nextKey = lastKey FROM @tmpKey ' FROM @temp;

		--PRINT @sqlstring
		EXECUTE		sys.sp_executesql @sqlstring, N'@nextKey BIGINT OUTPUT', @nextKey = @keyValue OUTPUT;
			
		--SET @keyValue=(SELECT lastkey FROM @tmpkey )
		IF NOT @keyvalue IS NULL
			BEGIN
				SET @keyValue = @keyValue;
				----PRINT 'new @keyValue: ' + CONVERT(VARCHAR,@keyValue)
			END
		ELSE
			BEGIN
				----SET @keyvalue =1  
				SET @keyvalue = 0;    ---jl: let calling app know there are no records            
				----PRINT 'new @keyValue for no records table: ' + CONVERT(VARCHAR,@keyValue)
            END
			
		SELECT		@idfsKey = @keyvalue;
		
		return @idfsKey;
	

END
