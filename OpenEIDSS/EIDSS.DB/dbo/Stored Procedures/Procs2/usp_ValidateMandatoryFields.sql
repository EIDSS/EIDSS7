

--##SUMMARY root procedure for not null key validation

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.06.2015

--##RETURNS dataset with incorrect records

/*
Example of procedure call:

EXEC spValidateMandatoryFields 'tlbHumanCase', 'Human Case', 'datEnteredDate', 'datModificationDate'
*/
CREATE PROCEDURE [dbo].[usp_ValidateMandatoryFields]
	@RootTableName VARCHAR(500),--##PARAM @TableName - table name
	@RootObjectName NVARCHAR(500), --##PARAM @RootId - object name (avian, livestock for vetcase for example)
	@CreationDateFieldName NVARCHAR(100) = NULL, --##PARAM @CreationDateFieldName - name of field of data creation
	@ModificationDateFieldName NVARCHAR(100) = NULL, --##PARAM @ModificationDateFieldName - name of field of data modification
	@CreationDateStart DATETIME = NULL, --##PARAM @CreationDateStart - start date of creation
	@CreationDateEnd DATETIME = NULL, --##PARAM @CreationDateEnd - end date of creation
	@ModificationDateStart DATETIME = NULL, --##PARAM @ModificationDateStart - start date of modification
	@ModificationDateEnd DATETIME = NULL --##PARAM @ModificationDateEnd - end date of modification
AS

	
SET @CreationDateStart = ISNULL(dbo.fnSetMinMaxTime(CAST(@CreationDateStart AS DATETIME),0), '1753-01-01 00:00:00.000')
SET @CreationDateEnd = ISNULL(dbo.fnSetMinMaxTime(CAST(@CreationDateEnd AS DATETIME),1), '9999-12-31 00:00:00.000')
SET @ModificationDateStart = ISNULL(dbo.fnSetMinMaxTime(CAST(@ModificationDateStart AS DATETIME),0), '1753-01-01 00:00:00.000')
SET @ModificationDateEnd = ISNULL(dbo.fnSetMinMaxTime(CAST(@ModificationDateEnd AS DATETIME),1), '9999-12-31 00:00:00.000')

DECLARE @CustomizationPackage BIGINT
SELECT @CustomizationPackage = dbo.fnCurrentCustomization()

DECLARE @CurrentCountryId BIGINT
SELECT @CurrentCountryId = dbo.fnCurrentCountry()

DECLARE @TableName NVARCHAR(500)
	, @ColumnName NVARCHAR(500)
	, @MandatoryFieldAlias NVARCHAR(500)
	, @PKColumnName NVARCHAR(500)
	, @AdditionalParameter NVARCHAR(500)
	, @AdditionalJoin NVARCHAR(2000)
	, @RootTablePKField NVARCHAR(500)
	, @RootTableStrIdName NVARCHAR(500)
	, @Sql NVARCHAR(MAX) = ''
	, @RowStatus BIT = 0
	, @FixQuery NVARCHAR(MAX)
	, @CanAutoFix BIT = 0
	

IF (
		SELECT 
			COUNT(*) 
		FROM tstCheckTables tct 
		JOIN tstCheckConstraints tcc ON 
			tcc.idfCheckTable = tct.idfCheckTable 
		WHERE strRootTableName = @RootTableName 
			AND ISNULL(tct.strRootObjectType, '') = ISNULL(@RootObjectName, '') 
			AND tct.intTypeValidation = 2 /*not null validation*/
	) > 0
BEGIN
	
	DECLARE _T CURSOR FOR
		SELECT
			tcc.strTableName1
			, tcc.strColumnName1
			, tcc.strMandatoryFieldAlias
			, a.COLUMN_NAME
			, tct.strRootTableName
			, tcc.strAdditionalParameter
			, tcc.strAdditionalJoin
			, a2.COLUMN_NAME
			, tct.strRootTableStrId
			, CASE WHEN c.column_id IS NULL THEN 0 ELSE 1 END
			, tcc.strFixQueryTemplate
			, tcc.blnCanAutoFix
		FROM tstCheckTables tct
		JOIN tstCheckConstraints tcc ON
			tcc.idfCheckTable = tct.idfCheckTable
		JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS a ON
			a.TABLE_NAME = tcc.strTableName1 collate Cyrillic_General_CI_AS
		JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS b ON 
			a.CONSTRAINT_NAME = b.CONSTRAINT_NAME
			AND b.CONSTRAINT_TYPE = 'PRIMARY KEY'
			
		JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS a2 ON
			a2.TABLE_NAME = tct.strRootTableName collate Cyrillic_General_CI_AS
		JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS b2 ON 
			a2.CONSTRAINT_NAME = b2.CONSTRAINT_NAME
			AND b2.CONSTRAINT_TYPE = 'PRIMARY KEY'
			
		LEFT JOIN  sys.tables t 
			JOIN sys.[columns] c ON
				c.[object_id] = t.[object_id]
				AND c.name = 'intRowStatus'
		ON t.name = tcc.strTableName1 collate Cyrillic_General_CI_AS
					
		WHERE tct.strRootTableName = @RootTableName
			AND ISNULL(tct.strRootObjectType, '') = ISNULL(@RootObjectName, '')
			AND tct.intTypeValidation = 2 /*not null validation*/
	OPEN _T

	FETCH NEXT FROM _T into @TableName
							, @ColumnName
							, @MandatoryFieldAlias
							, @PKColumnName
							, @RootTableName
							, @AdditionalParameter
							, @AdditionalJoin
							, @RootTablePKField
							, @RootTableStrIdName
							, @RowStatus
							, @FixQuery
							, @CanAutoFix
			
		SET @Sql = '
			SELECT
				''' + @TableName + ''' AS [Table Name]
				, ''' + ISNULL(@RootObjectName, '') + ''' AS [RootObjectName]
				, ''Mandatory'' AS [Constraint Name]
				, ''where ' + @TableName + '.' + @ColumnName + ' IS NULL '' AS [Where]
				, ' + @TableName + '.' + @PKColumnName + ' AS [ID]
				, ''' + @RootTableName + ''' AS [RootTableName]
				, ' + @RootTableName + '.' + @RootTablePKField + ' AS [RootID]
				, ' + ISNULL(@RootTableName + '.' + @RootTableStrIdName, '''''') + ' AS [StrRootId]
				, ''' + @ColumnName + ''' AS [InvalidFieldName]
				, ''NULL'' AS [InvalidFieldValue]'
													
		SET @Sql += '											
				, ''SELECT * FROM ' + @TableName + ' 
				' + ISNULL(@AdditionalJoin, '') + '
				WHERE ' + @TableName + '.' + @PKColumnName + ' = '' + CAST(' + @TableName + '.' + @PKColumnName + ' AS NVARCHAR(30)) AS [Query]'						
		
		IF ISNULL(@FixQuery, '') <> ''
		SET @Sql += '											
				, ''' + REPLACE(
							REPLACE(@FixQuery, '{PKId}', ''' + CAST(' + @TableName + '.' + @PKColumnName + ' AS NVARCHAR(30)) + ''')
								, '{CurrentCountryId}', '' + CAST(@CurrentCountryId AS NVARCHAR(30)) + '')								
					+ ''' AS [FixQueryTemplate]'
		ELSE
			SET @Sql += '
				, ''NULL'' AS [FixQueryTemplate]'
				
		SET @Sql += '											
				, ''' + CAST(ISNULL(@CanAutoFix, 0) AS NVARCHAR(1)) + ''' AS [CanAutoFix]'
													
		SET @Sql += '											
			FROM ' + @TableName
				
		SET @Sql += '
			' + ISNULL(@AdditionalJoin, '')
			
		IF ISNULL(@MandatoryFieldAlias, '') <> ''
		SET @Sql += '
			JOIN tstMandatoryFields ON 
				tstMandatoryFields.strFieldAlias = ' + @MandatoryFieldAlias + '
			JOIN tstMandatoryFieldsToCP ON 
				tstMandatoryFieldsToCP.idfMandatoryField = tstMandatoryFields.idfMandatoryField 
				AND tstMandatoryFieldsToCP.idfCustomizationPackage = ' + CAST(@CustomizationPackage AS NVARCHAR(30))
				
		SET @Sql += '
			WHERE ' + CASE SUBSTRING(@ColumnName, 1, 8) WHEN 'COALESCE' THEN '' ELSE @TableName + '.' END + @ColumnName + ' IS NULL'
			
		IF @RowStatus = 1
		SET @Sql += '
				AND ' + @TableName + '.intRowStatus = 0'
				
		IF @CreationDateFieldName IS NOT NULL
		SET @Sql += '
				AND ' + @RootTableName + '.' + @CreationDateFieldName + ' BETWEEN ''' + CONVERT(NVARCHAR(19), @CreationDateStart, 20) + ''' AND ''' + CONVERT(NVARCHAR(19), @CreationDateEnd, 20) + ''''
		
		IF @ModificationDateFieldName IS NOT NULL
		SET @Sql += '
				AND ' + @RootTableName + '.' + @ModificationDateFieldName + ' BETWEEN ''' + CONVERT(NVARCHAR(19), @ModificationDateStart, 20) + ''' AND ''' + CONVERT(NVARCHAR(19), @ModificationDateEnd, 20) + ''''
				
		IF @AdditionalParameter IS NOT NULL
			SET @Sql += '
				AND ' + REPLACE(@AdditionalParameter, '{PKId}', '' + @TableName + '.' + @PKColumnName + '')
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @TableName = ''
		
		FETCH NEXT FROM _T into @TableName
							, @ColumnName
							, @MandatoryFieldAlias
							, @PKColumnName
							, @RootTableName
							, @AdditionalParameter
							, @AdditionalJoin
							, @RootTablePKField
							, @RootTableStrIdName
							, @RowStatus
							, @FixQuery
							, @CanAutoFix
		
		IF @TableName <> ''
		BEGIN
			
			SET @Sql += '	
					
			UNION ALL
			
			SELECT
				''' + @TableName + ''' AS [Table Name]
				, ''' + ISNULL(@RootObjectName, '') + ''' AS [RootObjectName]
				, ''Mandatory'' AS [Constraint Name]
				, ''where ' + @TableName + '.' + @ColumnName + ' IS NULL '' AS [Where]
				, ' + @TableName + '.' + @PKColumnName + ' AS [ID]
				, ''' + @RootTableName + ''' AS [RootTableName]
				, ' + @RootTableName + '.' + @RootTablePKField + ' AS [RootID]
				, ' + ISNULL(@RootTableName + '.' + @RootTableStrIdName, '''''') + ' AS [StrRootId]
				, ''' + @ColumnName + ''' AS [InvalidFieldName]
				, ''NULL'' AS [InvalidFieldValue]'
													
		SET @Sql += '											
				, ''SELECT * FROM ' + @TableName + ' 
				' + ISNULL(@AdditionalJoin, '') + '
				WHERE ' + @TableName + '.' + @PKColumnName + ' = '' + CAST(' + @TableName + '.' + @PKColumnName + ' AS NVARCHAR(30)) AS [Query]'						
		
		IF ISNULL(@FixQuery, '') <> ''
		SET @Sql += '											
				, ''' + REPLACE(
							REPLACE(@FixQuery, '{PKId}', ''' + CAST(' + @TableName + '.' + @PKColumnName + ' AS NVARCHAR(30))+ ''')
								, '{CurrentCountryId}', '' + CAST(@CurrentCountryId AS NVARCHAR(30)) + '')
					+ '''	AS [FixQueryTemplate]'
		ELSE
			SET @Sql += '
				, ''NULL'' AS [FixQueryTemplate]'
				
		SET @Sql += '											
				, ''' + CAST(ISNULL(@CanAutoFix, 0) AS NVARCHAR(1)) + ''' AS [CanAutoFix]'
												
		SET @Sql += '											
			FROM ' + @TableName
				
		SET @Sql += '
			' + ISNULL(@AdditionalJoin, '')
			
		IF ISNULL(@MandatoryFieldAlias, '') <> ''
		SET @Sql += '
			JOIN tstMandatoryFields ON 
				tstMandatoryFields.strFieldAlias = ' + @MandatoryFieldAlias + '
			JOIN tstMandatoryFieldsToCP ON 
				tstMandatoryFieldsToCP.idfMandatoryField = tstMandatoryFields.idfMandatoryField 
				AND tstMandatoryFieldsToCP.idfCustomizationPackage = ' + CAST(@CustomizationPackage AS NVARCHAR(30))
				
		SET @Sql += '
			WHERE ' + CASE SUBSTRING(@ColumnName, 1, 8) WHEN 'COALESCE' THEN '' ELSE @TableName + '.' END + @ColumnName + ' IS NULL'
			
		IF @RowStatus = 1
		SET @Sql += '
				AND ' + @TableName + '.intRowStatus = 0'
				
		IF @CreationDateFieldName IS NOT NULL
		SET @Sql += '
				AND ' + @RootTableName + '.' + @CreationDateFieldName + ' BETWEEN ''' + CONVERT(NVARCHAR(19), @CreationDateStart, 20) + ''' AND ''' + CONVERT(NVARCHAR(19), @CreationDateEnd, 20) + ''''
		
		IF @ModificationDateFieldName IS NOT NULL
		SET @Sql += '
				AND ' + @RootTableName + '.' + @ModificationDateFieldName + ' BETWEEN ''' + CONVERT(NVARCHAR(19), @ModificationDateStart, 20) + ''' AND ''' + CONVERT(NVARCHAR(19), @ModificationDateEnd, 20) + ''''
				
		IF @AdditionalParameter IS NOT NULL
			SET @Sql += '
				AND ' + REPLACE(@AdditionalParameter, '{PKId}', '' + @TableName + '.' + @PKColumnName + '')
			
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
			, ''	AS [FixQueryTemplate]
			, ''	AS [CanAutoFix]
		FROM tstCheckTables
		WHERE strRootTableName = '123'

