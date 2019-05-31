--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		05/02/2017
-- Last modified by:		Joan Li
-- Description:				05/02/2017: Created based on V6 spValidateForeignKeys : rename for V7
--                          Input: tablename,rootid, rootobjectname; Output: 
--                          05/02/2017: change name to: usp_ValidateForeignKeys

-- Testing code:
/*
----testing code:
EXEC usp_ValidateForeignKeys 'tlbHuman', NULL, NULL
*/

--=====================================================================================================
--##SUMMARY root procedure for foreign key validation

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS dataset with incorrect records

CREATE PROCEDURE [dbo].[usp_ValidateForeignKeys]
	@TableName VARCHAR(500),	--##PARAM @TableName - table name
	@RootId BIGINT = NULL,	--##PARAM @RootId - id of record in the table
	@RootObjectName NVARCHAR(500) = NULL --##PARAM @RootId - object name (avian, livestock for vetcase for example)
AS

DECLARE @ConstraintName NVARCHAR(500)
	, @TableName1 NVARCHAR(500)
	, @ColumnName1 NVARCHAR(500)
	, @TableName2 NVARCHAR(500)
	, @ColumnName2 NVARCHAR(500)
	, @PKColumnName NVARCHAR(500)
	, @RootTableName NVARCHAR(500)
	, @AdditionalParameter NVARCHAR(500)
	, @AdditionalJoin NVARCHAR(2000)
	, @RootTablePKField NVARCHAR(500)
	, @RootTableStrIdName NVARCHAR(500)
	, @Sql NVARCHAR(MAX) = ''
	, @RowStatus BIT = 0
	
SELECT 
	@RowStatus = COUNT(*) 
FROM sys.[columns] c 
JOIN sys.tables t ON 
	t.[object_id] = c.[object_id] 
	AND t.name = @TableName 
WHERE c.name = 'intRowStatus'
	

IF (
	SELECT 
		COUNT(*) 
	FROM tstCheckTables tct 
	JOIN tstCheckConstraints tcc ON 
		tcc.idfCheckTable = tct.idfCheckTable 
	WHERE strRootTableName = @TableName 
		AND ISNULL(tct.strRootObjectType, '') = ISNULL(@RootObjectName, '') 
		AND tct.intTypeValidation = 1 /*foreign key validation*/
	) > 0
BEGIN
	
	DECLARE _T CURSOR FOR
		SELECT
			tcc.strConstraintName
			, tcc.strTableName1
			, tcc.strColumnName1
			, tcc.strTableName2
			, tcc.strColumnName2
			, a.COLUMN_NAME
			, tct.strRootTableName
			, tcc.strAdditionalParameter
			, tcc.strAdditionalJoin
			, a2.COLUMN_NAME
			, tct.strRootTableStrId
		FROM tstCheckTables tct
		JOIN tstCheckConstraints tcc ON
			tcc.idfCheckTable = tct.idfCheckTable
		JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS a ON
			a.TABLE_NAME = tcc.strTableName1  collate Cyrillic_General_CI_AS
		JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS b ON 
			a.CONSTRAINT_NAME = b.CONSTRAINT_NAME
			AND b.CONSTRAINT_TYPE = 'PRIMARY KEY'
			
		JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS a2 ON
			a2.TABLE_NAME = tct.strRootTableName  collate Cyrillic_General_CI_AS
		JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS b2 ON 
			a2.CONSTRAINT_NAME = b2.CONSTRAINT_NAME
			AND b2.CONSTRAINT_TYPE = 'PRIMARY KEY'
					
		WHERE tct.strRootTableName = @TableName
			AND ISNULL(tct.strRootObjectType, '') = ISNULL(@RootObjectName, '')
			AND tct.intTypeValidation = 1 /*foreign key validation*/
	OPEN _T

	FETCH NEXT FROM _T into @ConstraintName
							, @TableName1
							, @ColumnName1
							, @TableName2
							, @ColumnName2
							, @PKColumnName
							, @RootTableName
							, @AdditionalParameter
							, @AdditionalJoin
							, @RootTablePKField
							, @RootTableStrIdName

	IF @TableName1 <> @TableName2 
		AND ISNULL(@AdditionalJoin, '') NOT LIKE 'JOIN ' + @TableName2 + ' %'	
	BEGIN
				
		SET @Sql = '
			SELECT
				''' + @TableName1 + ''' AS			[Table Name]
				, ''' + ISNULL(@RootObjectName, '') + ''' AS	
													[RootObjectName]
				, ''' + @ConstraintName + ''' AS	[Constraint Name]
				, ''where ' + @ColumnName1 + ' = '' + CAST(' + @TableName1 + '.' + @ColumnName1 + ' AS VARCHAR) AS 
													[Where]
				, ' + @TableName1 + '.' + @PKColumnName + ' AS		[ID]
				, ''' + @RootTableName + ''' AS		[RootTableName]
				, ' + ISNULL(/*CASE WHEN @AdditionalJoin IS NULL THEN @TableName1 ELSE*/ @RootTableName /*END*/ + '.' + @RootTablePKField, '''''') + ' AS			
													[RootID]
				, ' + ISNULL(/*CASE WHEN @AdditionalJoin IS NULL THEN @TableName1 ELSE*/ @RootTableName /*END*/ + '.' + @RootTableStrIdName, '''''') + ' AS	
													[StrRootId]
				, ''' + @ColumnName1 + ''' AS		[InvalidFieldName]
				, CAST(' + @TableName1 + '.' + @ColumnName1 + ' AS VARCHAR) AS		
													[InvalidFieldValue]'
													
		SET @Sql += '											
				, ''SELECT * FROM ' + @TableName1 + ' 
				' + ISNULL(@AdditionalJoin, '') + '
				WHERE ' + @TableName1 + '.' + @PKColumnName + ' = '' + CAST(' + @TableName1 + '.' + @PKColumnName + ' AS NVARCHAR(30)) AS
													[Query]'						
													
		SET @Sql += '											
			FROM ' + @TableName1 + '
			LEFT JOIN ' + @TableName2 + ' ON
				' + @TableName2 + '.' + @ColumnName2 + ' = ' + @TableName1 + '.' + @ColumnName1
				
		SET @Sql += '
			' + ISNULL(@AdditionalJoin, '')
				
		SET @Sql += '
			WHERE ' + @TableName1 + '.' + @ColumnName1 + ' IS NOT NULL 
				AND ' + @TableName2 + '.' + @ColumnName2 + ' IS NULL'
				
		IF @RowStatus = 1
		SET @Sql += '
				AND ' + @TableName1 + '.intRowStatus = 0'
				
		IF @AdditionalParameter IS NOT NULL
			SET @Sql += '
				AND ' + @AdditionalParameter
				
		IF @RootId IS NOT NULL
			IF @AdditionalJoin IS NULL
				SET @Sql += '
				AND ' + @TableName1 + '.' + CASE WHEN @TableName1 = @RootTableName THEN @RootTablePKField ELSE @ColumnName1 END + ' = ' + CAST(@RootId AS NVARCHAR(50))
			ELSE
				SET @Sql += ' 
				AND ' + @RootTableName + '.' + @RootTablePKField + ' = ' + CAST(@RootId AS NVARCHAR(50))
	
	END
	ELSE 
		BEGIN 
		
			SET @Sql = '
				SELECT
					''' + @TableName1 + ''' AS			[Table Name]
					, ''' + ISNULL(@RootObjectName, '') + ''' AS	
														[RootObjectName]
					, ''' + @ConstraintName + ''' AS	[Constraint Name]
					, ''where ' + @ColumnName1 + ' = '' + CAST(t1.' + @ColumnName1 + ' AS VARCHAR) AS 
														[Where]
					, t1.' + @PKColumnName + ' AS		[ID]
					, ''' + @RootTableName + ''' AS		[RootTableName]
					, ' + ISNULL(CASE WHEN @AdditionalJoin IS NULL THEN 't1' ELSE @RootTableName END + '.' + @RootTablePKField, '''''') + ' AS			
														[RootID]
					, ' + ISNULL(CASE WHEN @AdditionalJoin IS NULL THEN 't1' ELSE @RootTableName END + '.' + @RootTableStrIdName, '''''') + ' AS	
														[StrRootId]
					, ''' + @ColumnName1 + ''' AS		[InvalidFieldName]
					, CAST(t1.' + @ColumnName1 + ' AS VARCHAR) AS		
														[InvalidFieldValue]'
													
		SET @Sql += '											
				, ''SELECT * FROM ' + @TableName1 + ' 
				' + ISNULL(@AdditionalJoin, '') + '
				WHERE ' + @TableName1 + '.' + @PKColumnName + ' = '' + CAST(t1.' + @PKColumnName + ' AS NVARCHAR(30)) AS
													[Query]'						
													
		SET @Sql += '					
				FROM ' + @TableName1 + ' AS t1
				LEFT JOIN ' + @TableName2 + ' AS t2 ON
					t2.' + @ColumnName2 + ' = t1.' + @ColumnName1
					
			SET @Sql += '
				' + ISNULL(@AdditionalJoin, '')
					
			SET @Sql += '
				WHERE t1.' + @ColumnName1 + ' IS NOT NULL
					AND t2.' + @ColumnName2 + ' IS NULL'
					
			IF @RowStatus = 1
			SET @Sql += '
					AND t1.intRowStatus = 0'
					
			IF @AdditionalParameter IS NOT NULL
				SET @Sql += '
					AND ' + @AdditionalParameter
					
			IF @RootId IS NOT NULL
				IF @AdditionalJoin IS NULL
					SET @Sql += '
					AND t1.' + CASE WHEN @TableName1 = @RootTableName THEN @RootTablePKField ELSE @ColumnName1 END + ' = ' + CAST(@RootId AS NVARCHAR(50))
				ELSE
					SET @Sql += ' 
					AND ' + @RootTableName + '.' + @RootTablePKField + ' = ' + CAST(@RootId AS NVARCHAR(50))

		END

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @TableName1 = ''
		
		FETCH NEXT FROM _T into @ConstraintName
								, @TableName1
								, @ColumnName1
								, @TableName2
								, @ColumnName2
								, @PKColumnName
								, @RootTableName
								, @AdditionalParameter
								, @AdditionalJoin
								, @RootTablePKField
								, @RootTableStrIdName
		
		IF @TableName1 <> ''
		BEGIN
			
			IF @TableName1 <> @TableName2 
				AND ISNULL(@AdditionalJoin, '') NOT LIKE 'JOIN ' + @TableName2 + ' %'	
			BEGIN	
			
					SET @Sql += '	
					
				UNION ALL
									 
				SELECT
					''' + @TableName1 + ''' AS			[Table Name]
					, ''' + ISNULL(@RootObjectName, '') + ''' AS	
														[RootObjectName]
					, ''' + @ConstraintName + ''' AS	[Constraint Name]
					, ''where ' + @ColumnName1 + ' = '' + CAST(' + @TableName1 + '.' + @ColumnName1 + ' AS VARCHAR) AS 
														[Where]
					, ' + @TableName1 + '.' + @PKColumnName + '
					, ''' + @RootTableName + ''' AS		[RootTableName]
					, ' + ISNULL(/*CASE WHEN @AdditionalJoin IS NULL THEN @TableName1 ELSE*/ @RootTableName /*END*/ + '.' + @RootTablePKField, '''''') + ' AS			
														[RootID]
					, ' + ISNULL(/*CASE WHEN @AdditionalJoin IS NULL THEN @TableName1 ELSE*/ @RootTableName /*END*/ + '.' + @RootTableStrIdName, '''''') + ' AS	
														[StrRootId]
					, ''' + @ColumnName1 + ''' AS		[InvalidFieldName]
					, CAST(' + @TableName1 + '.' + @ColumnName1 + ' AS VARCHAR) AS		
														[InvalidFieldValue]'
													
			SET @Sql += '											
					, ''SELECT * FROM ' + @TableName1 + ' 
					' + ISNULL(@AdditionalJoin, '') + '
					WHERE ' + @TableName1 + '.' + @PKColumnName + ' = '' + CAST(' + @TableName1 + '.' + @PKColumnName + ' AS NVARCHAR(30)) AS
														[Query]'						
														
			SET @Sql += '					
					FROM ' + @TableName1 + '
					LEFT JOIN ' + @TableName2 + ' ON
						' + @TableName2 + '.' + @ColumnName2 + ' = ' + @TableName1 + '.' + @ColumnName1
					
			SET @Sql += '
				' + ISNULL(@AdditionalJoin, '')
					
			SET @Sql += '
				WHERE ' + @TableName1 + '.' + @ColumnName1 + ' IS NOT NULL
					AND ' + @TableName2 + '.' + @ColumnName2 + ' IS NULL'
					
			IF @RowStatus = 1
			SET @Sql += '
					AND ' + @TableName1 + '.intRowStatus = 0'
					
			IF @AdditionalParameter IS NOT NULL
				SET @Sql += '
					AND ' + @AdditionalParameter
					
			IF @RootId IS NOT NULL
				IF @AdditionalJoin IS NULL
					SET @Sql += '
					AND ' + @TableName1 + '.' + CASE WHEN @TableName1 = @RootTableName THEN @RootTablePKField ELSE @ColumnName1 END + ' = ' + CAST(@RootId AS NVARCHAR(50))
				ELSE
					SET @Sql += ' 
					AND ' + @RootTableName + '.' + @RootTablePKField + ' = ' + CAST(@RootId AS NVARCHAR(50))
			
			END
			ELSE
				BEGIN 
				
					SET @Sql += '
					
						UNION ALL
					
						SELECT
							''' + @TableName1 + ''' AS			[Table Name]
							, ''' + ISNULL(@RootObjectName, '') + ''' AS	
																[RootObjectName]
							, ''' + @ConstraintName + ''' AS	[Constraint Name]
							, ''where ' + @ColumnName1 + ' = '' + CAST(t1.' + @ColumnName1 + ' AS VARCHAR) AS 
																[Where]
							, t1.' + @PKColumnName + ' AS		[ID]
							, ''' + @RootTableName + ''' AS		[RootTableName]
							, ' + ISNULL(CASE WHEN @AdditionalJoin IS NULL THEN 't1' ELSE @RootTableName END + '.' + @RootTablePKField, '''''') + ' AS			
																[RootID]
							, ' + ISNULL(CASE WHEN @AdditionalJoin IS NULL THEN 't1' ELSE @RootTableName END + '.' + @RootTableStrIdName, '''''') + ' AS	
																[StrRootId]
							, ''' + @ColumnName1 + ''' AS		[InvalidFieldName]
							, CAST(t1.' + @ColumnName1 + ' AS VARCHAR) AS		
																[InvalidFieldValue]'
													
					SET @Sql += '											
							, ''SELECT * FROM ' + @TableName1 + ' 
							' + ISNULL(@AdditionalJoin, '') + '
							WHERE ' + @TableName1 + '.' + @PKColumnName + ' = '' + CAST(t1.' + @PKColumnName + ' AS NVARCHAR(30)) AS
																[Query]'						
																
					SET @Sql += '					
									FROM ' + @TableName1 + ' AS t1
									LEFT JOIN ' + @TableName2 + ' AS t2 ON
										t2.' + @ColumnName2 + ' = t1.' + @ColumnName1
							
					SET @Sql += '
						' + ISNULL(@AdditionalJoin, '')
							
					SET @Sql += '
						WHERE t1.' + @ColumnName1 + ' IS NOT NULL 
							AND t2.' + @ColumnName2 + ' IS NULL'
							
					IF @RowStatus = 1
					SET @Sql += '
							AND t1.intRowStatus = 0'
							
					IF @AdditionalParameter IS NOT NULL
						SET @Sql += '
							AND ' + @AdditionalParameter
							
					IF @RootId IS NOT NULL
						IF @AdditionalJoin IS NULL
							SET @Sql += '
							AND t1.' + CASE WHEN @TableName1 = @RootTableName THEN @RootTablePKField ELSE @ColumnName1 END + ' = ' + CAST(@RootId AS NVARCHAR(50))
						ELSE
							SET @Sql += ' 
							AND ' + @RootTableName + '.' + @RootTablePKField + ' = ' + CAST(@RootId AS NVARCHAR(50))

				END
				
		END
	END
	CLOSE _T
	DEALLOCATE _T
	
	exec(@Sql)
END
ELSE
		SELECT
			''		AS [Table Name]
			, ''	AS [RootObjectName]
			, ''	AS [Constraint Name]
			, ''	AS [Where]
			, ''	AS [ID]
			, ''	AS [RootTableName]
			, ''	AS [RootID]
			, ''	AS [StrRootId]
			, ''	AS [InvalidFieldName]
			, ''	AS [InvalidFieldValue]
			, ''	AS [Query]
		FROM tstCheckTables
		WHERE strRootTableName = '123'


