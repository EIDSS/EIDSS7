
-- ================================================================================================
-- Name: USP_GBL_NEXTKEYID_PRE_GET
-- Description: Gets a new ID (primary key) value for a given table. May be called directly or by 
-- USP_GBL_NEXTKEYID_GET.
-- 
-- Revision History:
-- Name               Date       Change 
-- ------------------ ---------- -------------------------------------------------------------
-- Joan Li            04/18/2017 Initial release.
-- Joan Li            04/25/2018 Just return the highest id in one table or 0 for no records in 
--                               the table let calling SP or app to add desired increment number.
-- Steven Verner      11/26/2018 Removed stored procedures dependence on the #temp table because the 
--                               POCO generator doesn't work with it.
-- Stephen Long       11/27/2018 Modified sqlstring to return next value within the sql string as an 
--                               output param as was returning 0 each time. Added rev log.
/*
----testing code:
DECLARE	@return_value int,
		@idfsKey bigint
EXEC	@return_value = [dbo].[USP_GBL_NEXTKEYID_PRE_GET]
		@tableName = N'trtBaseReference',
		@idfsKey = @idfsKey OUTPUT
SELECT	@idfsKey as N'@idfsKey'
SELECT	'Return Value' = @return_value
GO
*/
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_GBL_NEXTKEYID_PRE_GET_NEW] 
(
	@tableName			VARCHAR(100),
	@idfsKey			BIGINT = 0 OUTPUT,
	@IsReturnCodesDisabled BIT = 0
)
AS
--========================================
--only for test DDL, need to block for USP
--========================================
----DECLARE @tableName VARCHAR(100), @idfsKey BIGINT
----SET @tableName='tstSite'----'trtReferenceType'
--========================================
DECLARE @returnCode		INT = 0
DECLARE @returnMsg		NVARCHAR(max) = 'Success'
DECLARE @sqlString		NVARCHAR(max) 
DECLARE @keyfldname		VARCHAR(100)
DECLARE @keyValue		BIGINT 

BEGIN
	BEGIN TRY   
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
				----PRINT 'old @keyValue: ' + CONVERT(VARCHAR,@keyValue)
				----SET @keyValue=@keyValue+1 ----jl: let calling app to decide increment gap
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
		----PRINT 'final out put: ' + CONVERT(VARCHAR,@keyValue)

		If @IsReturnCodesDisabled = 0
		  SELECT	@returnCode 'ReturnCode', @returnMsg 'ReturnMessage';
	END TRY  
	BEGIN CATCH 
		BEGIN
			SET @returnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
				+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR, ISNULL(ERROR_LINE(), ''))
				+ ' ErrorMessage: ' + ERROR_MESSAGE();
			SET @returnCode = ERROR_NUMBER();

		If @IsReturnCodesDisabled = 0
		  SELECT	@returnCode 'ReturnCode', @returnMsg 'ReturnMessage';
	  END
	END CATCH;
END
