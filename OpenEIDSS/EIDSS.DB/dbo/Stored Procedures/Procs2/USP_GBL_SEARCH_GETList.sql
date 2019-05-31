
--*************************************************************
-- Name 				: USP_GBL_SEARCH_GETList
-- Description			: Search DB to get fields for given value
--          
-- Author               : Maheshwar Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************
  
CREATE PROCEDURE [dbo].[USP_GBL_SEARCH_GETList]
	(
	@SearchColumnValue	NVARCHAR(4000)
	)
AS

DECLARE @returnCode	INT = 0 
DECLARE	@returnMsg	NVARCHAR(max) = 'SUCCESS' 

BEGIN
	BEGIN TRY

		BEGIN

			CREATE TABLE #Results (ColumnName nvarchar(370), ColumnValue nvarchar(3630))

			SET NOCOUNT ON

			DECLARE	@TableName		NVARCHAR(256) 
					,@ColumnName	NVARCHAR(128)
					,@SearchStr		NVARCHAR(110)
					,@SearchValue	SQL_VARIANT

			SET @TableName = ''

			WHILE @TableName IS NOT NULL

				BEGIN

					SET @ColumnName = ''
					SET @TableName = 
						(
						SELECT 
							MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
						FROM
							INFORMATION_SCHEMA.TABLES
						WHERE
							TABLE_TYPE = 'BASE TABLE'
							AND 
							QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
							AND 
							OBJECTPROPERTY	(
									OBJECT_ID	(
												QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
												), 'IsMSShipped'
											) = 0
						)

					WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)

						BEGIN
							SET @ColumnName =
										(
										SELECT 
											MIN(QUOTENAME(COLUMN_NAME))
										FROM
											INFORMATION_SCHEMA.COLUMNS
										WHERE
											TABLE_SCHEMA = PARSENAME(@TableName, 2)
											AND 
											TABLE_NAME  = PARSENAME(@TableName, 1)
											AND 
											DATA_TYPE IN ('CHAR', 'VARCHAR', 'NCHAR', 'NVARCHAR')
											AND 
											QUOTENAME(COLUMN_NAME) > @ColumnName
										)

							IF (@ColumnName IS NOT NULL)
								BEGIN

									DECLARE GLBCURSOR CURSOR FOR
									Select [Value] From dbo.fnsysSplitList(@SearchColumnValue, 0, '+')

									OPEN GLBCURSOR
					
									FETCH NEXT FROM GLBCURSOR INTO @SearchValue

									WHILE @@FETCH_STATUS = 0  
										BEGIN
											SET @SearchStr = QUOTENAME('%' + CAST(@SearchValue AS NVARCHAR(50)) + '%','''')
											INSERT INTO 
												#Results
											EXEC
												(
												'SELECT ''' + @ColumnName + ''', LEFT(' + @ColumnName + ', 3630) 
												FROM ' + @TableName + ' (NOLOCK) ' +
												' WHERE ' + @ColumnName + ' LIKE ' + @SearchStr
												)
											FETCH NEXT FROM GLBCURSOR INTO @SearchValue
										END  

									CLOSE GLBCURSOR  
									DEALLOCATE GLBCURSOR  

								END
						END 
				END

			SELECT 
				DISTINCT
				ColumnName
				--, ColumnValue 
			FROM 
				#Results

			DROP TABLE #Results

		END

		SELECT @returnCode, @returnMsg

	END TRY  

	BEGIN CATCH 

		SET @returnMsg = 
			'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
			+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
			+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
			+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
			+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
			+ ' ErrorMessage: '+ ERROR_MESSAGE()

		SET @returnCode = ERROR_NUMBER()

		SELECT @returnCode, @returnMsg

	END CATCH
END