
CREATE PROCEDURE [dbo].[spDataArchiving_MergeMatrixReference](
	@TargetServer NVARCHAR(100)
	, @TargetDataBase NVARCHAR(100)
	)
AS


DECLARE @ListOfTables TABLE (
	[TableName] [nvarchar](200) NULL,
	[TableOrder] [int] NULL,
	[TableField1] [nvarchar] (200) NULL,
	[TableField2] [nvarchar] (200) NULL,
	[TableField3] [nvarchar] (200) NULL,
	[TableField4] [nvarchar] (200) NULL,
	[ChildTable] [nvarchar](200) NULL,
	[ChildField1] [nvarchar] (200) NULL,
	[ChildField2] [nvarchar] (200) NULL,
	[ChildField3] [nvarchar] (200) NULL
)

INSERT INTO @ListOfTables
VALUES	
	('trtCollectionMethodForVectorType' , 1, 'idfsCollectionMethod', 'idfsVectorType', NULL, NULL, 'trtCollectionMethodForVectorTypeToCP', 'idfCollectionMethodForVectorType', 'idfCustomizationPackage', NULL)
	, ('trtDerivativeForSampleType', 2, 'idfsSampleType', 'idfsDerivativeType', NULL, NULL, 'trtDerivativeForSampleTypeToCP', 'idfDerivativeForSampleType', 'idfCustomizationPackage', NULL)
	, ('trtDiagnosisAgeGroupToDiagnosis', 3, 'idfsDiagnosis', 'idfsDiagnosisAgeGroup', NULL, NULL, 'trtDiagnosisAgeGroupToDiagnosisToCP', 'idfDiagnosisAgeGroupToDiagnosis', 'idfCustomizationPackage', NULL)
	, ('trtDiagnsosisAgeGroupToStatisticalAgeGroup', 4, 'idfsDiagnosisAgeGroup', 'idfsStatisticalAgeGroup', NULL, NULL, NULL, NULL, NULL, NULL)
	, ('trtFFObjectForCustomReport', 5, 'idfsCustomReportType', 'strFFObjectAlias', NULL, NULL, 'trtFFObjectToDiagnosisForCustomReport', 'idfFFObjectForCustomReport', 'idfsDiagnosis', NULL)
	, ('trtMaterialForDisease', 6, 'idfsSampleType', 'idfsDiagnosis', NULL, NULL, 'trtMaterialForDiseaseToCP', 'idfMaterialForDisease', 'idfCustomizationPackage', NULL)
	, ('trtPensideTestForDisease', 7, 'idfsPensideTestName', 'idfsDiagnosis', NULL, NULL, 'trtPensideTestForDiseaseToCP', 'idfPensideTestForDisease', 'idfCustomizationPackage', NULL)	
	, ('trtPensideTestTypeForVectorType', 8, 'idfsPensideTestName', 'idfsVectorType', NULL, NULL, 'trtPensideTestTypeForVectorTypeToCP', 'idfPensideTestTypeForVectorType', 'idfCustomizationPackage', NULL)	
	, ('trtSampleTypeForVectorType', 9, 'idfsSampleType', 'idfsVectorType', NULL, NULL, 'trtSampleTypeForVectorTypeToCP', 'idfSampleTypeForVectorType', 'idfCustomizationPackage', NULL)	
	, ('trtSpeciesTypeToAnimalAge', 10, 'idfsSpeciesType', 'idfsAnimalAge', NULL, NULL, 'trtSpeciesTypeToAnimalAgeToCP', 'idfSpeciesTypeToAnimalAge', 'idfCustomizationPackage', NULL)
	, ('trtTestForDisease', 11, 'idfsTestName', 'idfsDiagnosis', NULL, NULL, 'trtTestForDiseaseToCP', 'idfTestForDisease', 'idfCustomizationPackage', NULL)
	, ('trtTestTypeForCustomReport', 12, 'idfsCustomReportType', 'idfsTestName', NULL, NULL, NULL, NULL, NULL, NULL)
	, ('tstObjectAccess', 13, 'idfsObjectOperation', 'idfsObjectID', 'idfActor', 'idfsOnSite', NULL, NULL, NULL, NULL)
	--, ('tstSiteRelation', 14, 'idfsSenderSite', 'idfsReceiverSite', NULL, NULL, NULL, NULL, NULL, NULL)
	--, ('tlbAggrMatrixVersion', 15, 'idfVersion', 'idfRow', 'idfsParameter', NULL, NULL, NULL, NULL, NULL)
	, ('tasSearchFieldsWithRelatedValues', 16, 'idfsSearchField', 'idfsRelatedSearchField', NULL, NULL, NULL, NULL, NULL, NULL)
	, ('trtReportRows', 17, 'idfsCustomReportType', 'idfsDiagnosisOrReportDiagnosisGroup', NULL, NULL, NULL, NULL, NULL, NULL)
	, ('trtSpeciesToGroupForCustomReport', 18, 'idfsCustomReportType', 'idfsSpeciesGroup', 'idfsSpeciesType', NULL, NULL, NULL, NULL, NULL)
	, ('trtSpeciesContentInCustomReport', 19, 'idfsCustomReportType', 'idfsSpeciesOrSpeciesGroup', 'idfsReportAdditionalText', NULL, NULL, NULL, NULL, NULL)
	, ('ffDeterminantValue', 20, 'idfsFormTemplate', 'idfsBaseReference', 'idfsGISBaseReference', NULL, NULL, NULL, NULL, NULL)
	, ('ffSectionDesignOption', 21, 'idfsLanguage', 'idfsFormTemplate', 'idfsSection', NULL, NULL, NULL, NULL, NULL)
	, ('ffParameterDesignOption', 22, 'idfsParameter', 'idfsLanguage', 'idfsFormTemplate', NULL, NULL, NULL, NULL, NULL)
	, ('ffParameterForFunction', 23, 'idfsParameter', 'idfsFormTemplate', 'idfsRule', NULL, NULL, NULL, NULL, NULL)
	, ('ffParameterForAction', 20, 'idfsParameter', 'idfsFormTemplate', 'idfsRuleAction', 'idfsRule', NULL, NULL, NULL, NULL)



SET XACT_ABORT ON
SET NOCOUNT ON

--BEGIN TRAN


	PRINT N'Merge matrix reference'
	PRINT N'----------------'

	DECLARE @TableName NVARCHAR(200) = N''
		, @TableField1 NVARCHAR(200) = N'', @TableField2 NVARCHAR(200) = N'', @TableField3 NVARCHAR(200) = N'', @TableField4 NVARCHAR(200) = N''
		, @Column NVARCHAR(200) = N''
		, @ChildTableName NVARCHAR(200) = N''
		, @ChildTableField1 NVARCHAR(200) = N'', @ChildTableField2 NVARCHAR(200) = N'', @ChildTableField3 NVARCHAR(200) = N''
	DECLARE @Sql NVARCHAR(MAX) = N''
	DECLARE @blnRowStatus BIT = 0

	DECLARE @TablePKList TABLE (
		[TablePKField] [nvarchar] (200) NULL
		)
	DECLARE @TableNotPKFieldsList TABLE (
		[TableField] [nvarchar] (200) NULL,
		[FieldOrder] [int] NULL
		)
	DECLARE @TableAllFieldsList TABLE (
		[TableField] [nvarchar] (200) NULL,
		[FieldOrder] [int] NULL
	)
	DECLARE @ChildTableAllFieldsList TABLE (
		[TableField] [nvarchar] (200) NULL,
		[FieldOrder] [int] NULL
	)
	DECLARE @ChildTableForUpdateFieldsList TABLE (
		[TableField] [nvarchar] (200) NULL,
		[FieldOrder] [int] NULL
	)


	--- table
	DECLARE _T CURSOR FOR
		SELECT 
			TableName
			, TableField1
			, TableField2
			, TableField3
			, TableField4
			, ChildTable
			, ChildField1
			, ChildField2
			, ChildField3
		FROM @ListOfTables
		ORDER BY TableOrder
	OPEN _T

	FETCH NEXT FROM _T into @TableName, @TableField1, @TableField2, @TableField3, @TableField4, @ChildTableName, @ChildTableField1, @ChildTableField2, @ChildTableField3


	WHILE @@FETCH_STATUS = 0
		BEGIN		
			
		DELETE FROM @TablePKList
		
		INSERT INTO @TablePKList
		SELECT
			a.COLUMN_NAME
		FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS a
		JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS b
		ON a.CONSTRAINT_NAME = b.CONSTRAINT_NAME
		WHERE b.CONSTRAINT_TYPE = 'PRIMARY KEY'
			AND a.TABLE_NAME = @TableName
			
		
		DELETE FROM @TableNotPKFieldsList
		
		INSERT INTO @TableNotPKFieldsList
		SELECT
			a.COLUMN_NAME
			, ORDINAL_POSITION
		FROM INFORMATION_SCHEMA.COLUMNS as a
		WHERE a.TABLE_NAME = @TableName
			AND a.DATA_TYPE not in ('text', 'ntext', 'image', 'xml', 'varbinary', 'geometry', 'uniqueidentifier')
			AND a.COLUMN_NAME NOT IN (ISNULL(@TableField1, ''), ISNULL(@TableField2, ''), ISNULL(@TableField3, '')
				, ISNULL(@TableField4, ''))
			AND a.COLUMN_NAME NOT IN (SELECT TablePKField FROM @TablePKList)
		ORDER BY ORDINAL_POSITION
		
		
		DELETE FROM @TableAllFieldsList
			
		INSERT INTO @TableAllFieldsList
		SELECT
			a.COLUMN_NAME
			, ORDINAL_POSITION
		from INFORMATION_SCHEMA.COLUMNS as a
		WHERE a.TABLE_NAME = @TableName
		ORDER BY ORDINAL_POSITION
		
		
		DELETE FROM @ChildTableAllFieldsList
			
		INSERT INTO @ChildTableAllFieldsList
		SELECT
			a.COLUMN_NAME
			, ORDINAL_POSITION
		from INFORMATION_SCHEMA.COLUMNS as a
		WHERE a.TABLE_NAME = @ChildTableName
		ORDER BY ORDINAL_POSITION
		

		DELETE FROM @ChildTableForUpdateFieldsList
			
		INSERT INTO @ChildTableForUpdateFieldsList
		SELECT
			a.COLUMN_NAME
			, ORDINAL_POSITION
		from INFORMATION_SCHEMA.COLUMNS as a
		WHERE a.TABLE_NAME = @ChildTableName
			AND a.DATA_TYPE NOT IN ('uniqueidentifier')
			AND a.COLUMN_NAME NOT IN (ISNULL(@ChildTableField1, ''), ISNULL(@ChildTableField2, ''), ISNULL(@ChildTableField3, ''))
			AND a.COLUMN_NAME NOT IN (
										SELECT
											a.COLUMN_NAME
										FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS a
										JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS b
										ON a.CONSTRAINT_NAME = b.CONSTRAINT_NAME
										WHERE b.CONSTRAINT_TYPE = 'PRIMARY KEY'
											AND a.TABLE_NAME = @ChildTableName	
									)
		ORDER BY ORDINAL_POSITION
		
		
		
		
	/*merge основной таблицы*/
			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@TableName) AND type in (N'U'))	
			BEGIN	
				SET @Sql = N'
				SET QUOTED_IDENTIFIER ON
				'	
				
				SET @Sql += N'
					IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''' + @TableName + N''') AND type in (N''U''))
						AND EXISTS (SELECT * FROM ' + @TargetServer + N'.' + @TargetDataBase + N'.sys.objects WHERE object_id = OBJECT_ID(N''' + @TableName + N''') AND type in (N''U''))
						AND EXISTS (SELECT * FROM ' + @TargetServer + N'.' + @TargetDataBase + N'.sys.all_columns WHERE object_id = OBJECT_ID(N''' + @TableName + N''') AND is_identity = 1)
					SET IDENTITY_INSERT ' + @TargetDataBase + N'.dbo.' + @TableName + N' ON
					
				'		
					
				SET @Sql += N'
					
					IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''' + @TableName + N''') AND type in (N''U''))
						AND EXISTS (SELECT * FROM ' + @TargetServer + N'.' + @TargetDataBase + N'.sys.objects WHERE object_id = OBJECT_ID(N''' + @TableName + N''') AND type in (N''U''))
					MERGE ' + @TargetServer + N'.' + @TargetDataBase + N'.dbo.' + @TableName + N' AS [target]
					USING dbo.' + @TableName + N' AS [source] ON'
				
				IF @TableField1 <> N''
				SET @Sql += N'
						ISNULL([target].' + @TableField1 + N', '''') = ISNULL([source].' + @TableField1 + N', '''')'
					
				IF @TableField2 <> N''
				SET @Sql += N'
						AND ISNULL([target].' + @TableField2 + N', '''') = ISNULL([source].' + @TableField2 + N', '''')'
					
				IF @TableField3 <> N''
				SET @Sql += N'
						AND ISNULL([target].' + @TableField3 + N', '''') = ISNULL([source].' + @TableField3 + N', '''')'
					
				IF @TableField4 <> N''
				SET @Sql += N'
						AND ISNULL([target].' + @TableField4 + N', '''') = ISNULL([source].' + @TableField4 + N', '''')'
				
					
				--update only if count non-PK fields > 0
				IF (
						SELECT
							COUNT(TableField)
						FROM @TableNotPKFieldsList
					) > 0
				BEGIN
					
					SET @Sql += N'	
					WHEN MATCHED AND ('	
						
					--условия проверки отличия
					DECLARE _C1 CURSOR FAST_FORWARD FOR
					SELECT
						TableField
					FROM @TableNotPKFieldsList
					ORDER BY FieldOrder	
					OPEN _C1
					
					FETCH NEXT FROM _C1 INTO @Column
					
					SET @Sql += N'
										ISNULL([target].' + @Column + N', '''') <> ISNULL([source].' + @Column + N', '''')'
					
					WHILE @@FETCH_STATUS = 0
						BEGIN			
							SET @Column = ''			
							
							FETCH NEXT FROM _C1 INTO @Column
							
							IF @Column <> N''
							SET @Sql += N'
										OR ISNULL([target].' + @Column + N', '''') <> ISNULL([source].' + @Column + N', '''')'
						END
					CLOSE _C1
					DEALLOCATE _C1
					
					SET @Sql += N'	
									)'	
										
					
					SET @Sql += N'	
						THEN
							UPDATE
								SET'	
					
					
					--update fields
					DECLARE _C2 CURSOR FAST_FORWARD FOR
					SELECT
						TableField
					FROM @TableNotPKFieldsList
					ORDER BY FieldOrder	
					OPEN _C2
					
					FETCH NEXT FROM _C2 INTO @Column
					
					SET @Sql += N'
									' + @Column + N' = [source].' + @Column
					
					WHILE @@FETCH_STATUS = 0
						BEGIN			
							SET @Column = N''			
							
							FETCH NEXT FROM _C2 INTO @Column
							
							IF @Column <> N''
							SET @Sql += N'
									, ' + @Column + N' = [source].' + @Column
						END
					CLOSE _C2
					DEALLOCATE _C2
				
				END
				
				SET @Sql += N'	
					WHEN NOT MATCHED AND ((SELECT COUNT(*) FROM ' + @TargetServer + N'.' + @TargetDataBase + N'.dbo.' + @TableName + N' AS TT'
				
				
				--- primary key	
					DECLARE _PK CURSOR FOR
					SELECT 
						TablePKField 
					FROM @TablePKList
					OPEN _PK

					FETCH NEXT FROM _PK INTO @Column
					
					IF @Column <> N''
					SET @Sql += N'
									WHERE TT.' + @Column + N' = [source].' + @Column

					WHILE @@FETCH_STATUS = 0
						BEGIN 
							SET @Column = N''

							FETCH NEXT FROM _PK into @Column
							
							IF @Column <> N''
							SET @Sql += N'
										AND TT.' + @Column + N' = [source].' + @Column
						END 

					CLOSE _PK
					DEALLOCATE _PK

						
				SET @Sql += N')=0)
						THEN
							INSERT ('
					
				
				--insert fields
				DECLARE _C3 CURSOR FAST_FORWARD FOR
				SELECT
					TableField
				FROM @TableAllFieldsList
				ORDER BY FieldOrder	
				OPEN _C3
				
				FETCH NEXT FROM _C3 INTO @Column
				
				SET @Sql += N'
										' + @Column
				
				WHILE @@FETCH_STATUS = 0
					BEGIN			
						SET @Column = N''			
						
						FETCH NEXT FROM _C3 INTO @Column
						
						IF @Column <> N''
						SET @Sql += N'
										, ' + @Column
					END
				CLOSE _C3
				DEALLOCATE _C3
				
				SET @Sql += N'	
									)
							VALUES ('
				
				
				--insert fields value
				DECLARE _C4 CURSOR FAST_FORWARD FOR
				SELECT
					TableField
				FROM @TableAllFieldsList
				ORDER BY FieldOrder		
				OPEN _C4
				
				FETCH NEXT FROM _C4 INTO @Column
				
				SET @Sql += N'
										[source].' + @Column
				
				WHILE @@FETCH_STATUS = 0
					BEGIN			
						SET @Column = N''			
						
						FETCH NEXT FROM _C4 INTO @Column
						
						IF @Column <> N''
						SET @Sql += N'
										, [source].' + @Column
					END
				CLOSE _C4
				DEALLOCATE _C4
						
				SET @Sql += N'	
									)
					WHEN NOT MATCHED BY SOURCE'
						
				

				IF EXISTS (SELECT * FROM @TableAllFieldsList WHERE TableField = 'intRowStatus')				
				SET @Sql += N'
						AND [target].intRowStatus = 0
						THEN
							UPDATE SET intRowStatus = 1
							;'
				ELSE
				SET @Sql += N'
						THEN
							DELETE
							;'
				
				SET @Sql += N'

					PRINT ''' + @TableName + N' merged:'' + CAST(@@ROWCOUNT AS VARCHAR(10)) + N'' rows''
					PRINT ''''		
								'
								
				SET @Sql += N'
					IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''' + @TableName + N''') AND type in (N''U''))
						AND EXISTS (SELECT * FROM ' + @TargetServer + N'.' + @TargetDataBase + N'.sys.objects WHERE object_id = OBJECT_ID(N''' + @TableName + N''') AND type in (N''U''))
						AND EXISTS (SELECT * FROM ' + @TargetServer + N'.' + @TargetDataBase + N'.sys.all_columns WHERE object_id = OBJECT_ID(N''' + @TableName + N''') AND is_identity = 1)
					SET IDENTITY_INSERT ' + @TargetDataBase + N'.dbo.' + @TableName + N' OFF
					
				'
			
				BEGIN TRY		
					EXEC (@Sql)	
				--	PRINT (@Sql)
				END TRY
				BEGIN CATCH
					IF @@ERROR <> 0
					BEGIN
						--ROLLBACK TRAN
						CLOSE _T
						DEALLOCATE _T
						RETURN 1
					END
				END CATCH
				
			END
			
			
			
				
		
		
	/*insert дополнительной таблицы*/
			IF @ChildTableName <> N'' AND EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@ChildTableName) AND type in (N'U'))	
			BEGIN	
				SET @Sql = N'
				SET QUOTED_IDENTIFIER ON
				'			
				
				SET @Sql += N'
					IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''' + @ChildTableName + N''') AND type in (N''U''))
						AND EXISTS (SELECT * FROM ' + @TargetServer + N'.' + @TargetDataBase + N'.sys.objects WHERE object_id = OBJECT_ID(N''' + @ChildTableName + N''') AND type in (N''U''))
						AND EXISTS (SELECT * FROM ' + @TargetServer + N'.' + @TargetDataBase + N'.sys.all_columns WHERE object_id = OBJECT_ID(N''' + @ChildTableName + N''') AND is_identity = 1)
					SET IDENTITY_INSERT ' + @TargetDataBase + N'.dbo.' + @ChildTableName + N' ON
					
				'
					
				SET @Sql += N'
					
					IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''' + @ChildTableName + N''') AND type in (N''U''))
						AND EXISTS (SELECT * FROM ' + @TargetServer + N'.' + @TargetDataBase + N'.sys.objects WHERE object_id = OBJECT_ID(N''' + @ChildTableName + N''') AND type in (N''U''))
					BEGIN
						
					INSERT INTO ' + @TargetServer + N'.' + @TargetDataBase + N'.dbo.' + @ChildTableName
				
				SET @Sql += N'	
					('
								
					--insert fields
					DECLARE _C3 CURSOR FAST_FORWARD FOR
					SELECT
						TableField
					FROM @ChildTableAllFieldsList
					ORDER BY FieldOrder	
					OPEN _C3
					
					FETCH NEXT FROM _C3 INTO @Column
					
					SET @Sql += N'
						' + @Column
					
					WHILE @@FETCH_STATUS = 0
						BEGIN			
							SET @Column = N''			
							
							FETCH NEXT FROM _C3 INTO @Column
							
							IF @Column <> N''
							SET @Sql += N'
						, ' + @Column
						END
					CLOSE _C3
					DEALLOCATE _C3				

					
				SET @Sql += N'	
					)'
					
				SET @Sql += N'	
					SELECT'
					
					--insert fields
					DECLARE _C3 CURSOR FAST_FORWARD FOR
					SELECT
						TableField
					FROM @ChildTableAllFieldsList
					ORDER BY FieldOrder	
					OPEN _C3
					
					FETCH NEXT FROM _C3 INTO @Column
					
					IF @Column IN (SELECT TablePKField FROM @TablePKList)
					SET @Sql += N'
						[target_parent].' + @Column
					ELSE
					SET @Sql += N'
						[source].' + @Column
					
					WHILE @@FETCH_STATUS = 0
						BEGIN			
							SET @Column = N''			
							
							FETCH NEXT FROM _C3 INTO @Column
							
							IF @Column <> N'' AND @Column IN (SELECT TablePKField FROM @TablePKList)
							SET @Sql += N'
						, [target_parent].' + @Column
							ELSE
								IF @Column <> N''
						SET @Sql += N'
						, [source].' + @Column
						END
					CLOSE _C3
					DEALLOCATE _C3
					
					
				SET @Sql += N'	
					FROM dbo.' + @ChildTableName + N' AS [source]'
				SET @Sql += N'	
					JOIN dbo.' + @TableName + N' AS [source_parent] ON'
				
					--- primary key	
					DECLARE _PK CURSOR FOR
					SELECT 
						TablePKField 
					FROM @TablePKList
					OPEN _PK

					FETCH NEXT FROM _PK INTO @Column
					
					IF @Column <> N''
					SET @Sql += N'
						[source_parent].' + @Column + N' = [source].' + @Column

					WHILE @@FETCH_STATUS = 0
						BEGIN 
							SET @Column = N''

							FETCH NEXT FROM _PK into @Column
							
							IF @Column <> N''
							SET @Sql += N'
								AND [source_parent].' + @Column + N' = [source].' + @Column
						END 

					CLOSE _PK
					DEALLOCATE _PK
					
				SET @Sql += N'	
					JOIN ' + @TargetServer + N'.' + @TargetDataBase + N'.dbo.' + @TableName + N' AS [target_parent] ON'	
					
				IF @TableField1 <> N''
				SET @Sql += N'
						[target_parent].' + @TableField1 + N' = [source_parent].' + @TableField1
					
				IF @TableField2 <> N''
				SET @Sql += N'
						AND [target_parent].' + @TableField2 + N' = [source_parent].' + @TableField2
					
				IF @TableField3 <> N''
				SET @Sql += N'
						AND [target_parent].' + @TableField3 + N' = [source_parent].' + @TableField3
					
				IF @TableField4 <> N''
				SET @Sql += N'
						AND [target_parent].' + @TableField4 + N' = [source_parent].' + @TableField4
					
						
				SET @Sql += N'	
					LEFT JOIN ' + @TargetServer + N'.' + @TargetDataBase + N'.dbo.' + @ChildTableName + N' AS [target] ON'
						
				IF @ChildTableField1 <> N'' AND @ChildTableField1 IN (SELECT TablePKField FROM @TablePKList)
				SET @Sql += N'
						[target].' + @ChildTableField1 + N' = [target_parent].' + @ChildTableField1
				ELSE IF @ChildTableField1 <> N''
				SET @Sql += N'
						[target].' + @ChildTableField1 + N' = [source].' + @ChildTableField1
						
				
				IF @ChildTableField2 <> N'' AND @ChildTableField2 IN (SELECT TablePKField FROM @TablePKList)
				SET @Sql += N'
						AND [target].' + @ChildTableField2 + N' = [target_parent].' + @ChildTableField2	
				ELSE IF @ChildTableField2 <> N''
				SET @Sql += N'
						AND [target].' + @ChildTableField2 + N' = [source].' + @ChildTableField2
						
				IF @ChildTableField3 <> N'' AND @ChildTableField3 IN (SELECT TablePKField FROM @TablePKList)
				SET @Sql += N'
						AND [target].' + @ChildTableField3 + N' = [target_parent].' + @ChildTableField3	
				ELSE IF @ChildTableField3 <> N''
				SET @Sql += N'
						AND [target].' + @ChildTableField3 + N' = [source].' + @ChildTableField3
						
				SET @Sql += N'	
					WHERE [target].' + @ChildTableField1 + N' IS NULL'
				
				SET @Sql += N'
					
					
					END
					PRINT ''' + @ChildTableName + N' insert:'' + CAST(@@ROWCOUNT AS VARCHAR(10)) + N'' rows''
					PRINT ''''		
								'
								
				SET @Sql += N'
					IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''' + @ChildTableName + N''') AND type in (N''U''))
						AND EXISTS (SELECT * FROM ' + @TargetServer + N'.' + @TargetDataBase + N'.sys.objects WHERE object_id = OBJECT_ID(N''' + @ChildTableName + N''') AND type in (N''U''))
						AND EXISTS (SELECT * FROM ' + @TargetServer + N'.' + @TargetDataBase + N'.sys.all_columns WHERE object_id = OBJECT_ID(N''' + @ChildTableName + N''') AND is_identity = 1)
					SET IDENTITY_INSERT ' + @TargetDataBase + N'.dbo.' + @ChildTableName + N' ON
					
				'
			
				BEGIN TRY		
					EXEC (@Sql)	
				--	PRINT (@Sql)
				END TRY
				BEGIN CATCH
					IF @@ERROR <> 0
					BEGIN
						--ROLLBACK TRAN
						CLOSE _T
						DEALLOCATE _T
						RETURN 1
					END
				END CATCH
				
			END
			
			
		
		
		
			
	/*update дополнительной таблицы*/
			IF @ChildTableName <> N'' 
				AND EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@ChildTableName) AND type in (N'U'))
				AND EXISTS (SELECT * FROM @ChildTableForUpdateFieldsList)	
			BEGIN	
				SET @Sql = N'
				SET QUOTED_IDENTIFIER ON
				'			
					
				SET @Sql += N'
					
					IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''' + @ChildTableName + N''') AND type in (N''U''))
						AND EXISTS (SELECT * FROM ' + @TargetServer + N'.' + @TargetDataBase + N'.sys.objects WHERE object_id = OBJECT_ID(N''' + @ChildTableName + N''') AND type in (N''U''))
					BEGIN
						
					UPDATE ' + @TargetServer + N'.' + @TargetDataBase + N'.dbo.' + @ChildTableName
				
				SET @Sql += N'	
					SET	'
								
					--update fields
					DECLARE _C3 CURSOR FAST_FORWARD FOR
					SELECT
						TableField
					FROM @ChildTableForUpdateFieldsList
					ORDER BY FieldOrder	
					OPEN _C3
					
					FETCH NEXT FROM _C3 INTO @Column
					
					SET @Sql += N'
						' + @Column + ' = [source].' + @Column
					
					WHILE @@FETCH_STATUS = 0
						BEGIN			
							SET @Column = N''			
							
							FETCH NEXT FROM _C3 INTO @Column
							
							IF @Column <> N''
							SET @Sql += N'
						, ' + @Column + ' = [source].' + @Column
						END
					CLOSE _C3
					DEALLOCATE _C3				
							
					
				SET @Sql += N'	
					FROM dbo.' + @ChildTableName + N' AS [source]'
				SET @Sql += N'	
					JOIN dbo.' + @TableName + N' AS [source_parent] ON'
				
					--- primary key	
					DECLARE _PK CURSOR FOR
					SELECT 
						TablePKField 
					FROM @TablePKList
					OPEN _PK

					FETCH NEXT FROM _PK INTO @Column
					
					IF @Column <> N''
					SET @Sql += N'
						[source_parent].' + @Column + N' = [source].' + @Column

					WHILE @@FETCH_STATUS = 0
						BEGIN 
							SET @Column = N''

							FETCH NEXT FROM _PK into @Column
							
							IF @Column <> N''
							SET @Sql += N'
								AND [source_parent].' + @Column + N' = [source].' + @Column
						END 

					CLOSE _PK
					DEALLOCATE _PK
					
				SET @Sql += N'	
					JOIN ' + @TargetServer + N'.' + @TargetDataBase + N'.dbo.' + @TableName + N' AS [target_parent] ON'	
					
				IF @TableField1 <> N''
				SET @Sql += N'
						[target_parent].' + @TableField1 + N' = [source_parent].' + @TableField1
					
				IF @TableField2 <> N''
				SET @Sql += N'
						AND [target_parent].' + @TableField2 + N' = [source_parent].' + @TableField2
					
				IF @TableField3 <> N''
				SET @Sql += N'
						AND [target_parent].' + @TableField3 + N' = [source_parent].' + @TableField3
					
				IF @TableField4 <> N''
				SET @Sql += N'
						AND [target_parent].' + @TableField4 + N' = [source_parent].' + @TableField4
					
						
				SET @Sql += N'	
					JOIN ' + @TargetServer + N'.' + @TargetDataBase + N'.dbo.' + @ChildTableName + N' AS [target] ON'
						
				IF @ChildTableField1 <> N'' AND @ChildTableField1 IN (SELECT TablePKField FROM @TablePKList)
				SET @Sql += N'
						[target].' + @ChildTableField1 + N' = [target_parent].' + @ChildTableField1
				ELSE IF @ChildTableField1 <> N''
				SET @Sql += N'
						[target].' + @ChildTableField1 + N' = [source].' + @ChildTableField1
				
				IF @ChildTableField2 <> N'' AND @ChildTableField2 IN (SELECT TablePKField FROM @TablePKList)
				SET @Sql += N'
						AND [target].' + @ChildTableField2 + N' = [target_parent].' + @ChildTableField2	
				ELSE IF @ChildTableField2 <> N''
				SET @Sql += N'
						AND [target].' + @ChildTableField2 + N' = [source].' + @ChildTableField2
						
				IF @ChildTableField3 <> N'' AND @ChildTableField3 IN (SELECT TablePKField FROM @TablePKList)
				SET @Sql += N'
						AND [target].' + @ChildTableField3 + N' = [target_parent].' + @ChildTableField3	
				ELSE IF @ChildTableField3 <> N''
				SET @Sql += N'
						AND [target].' + @ChildTableField3 + N' = [source].' + @ChildTableField3

				
					--different fields
					DECLARE _C3 CURSOR FAST_FORWARD FOR
					SELECT
						TableField
					FROM @ChildTableForUpdateFieldsList
					ORDER BY FieldOrder	
					OPEN _C3
					
					FETCH NEXT FROM _C3 INTO @Column
					
					SET @Sql += N'
						AND ([target].' + @Column + ' <> [source].' + @Column
					
					WHILE @@FETCH_STATUS = 0
						BEGIN			
							SET @Column = N''			
							
							FETCH NEXT FROM _C3 INTO @Column
							
							IF @Column <> N''
							SET @Sql += N'
						OR [target].' + @Column + ' <> [source].' + @Column
						END
						
					SET @Sql += N')'				
					CLOSE _C3
					DEALLOCATE _C3
				
				SET @Sql += N'
					
					
					END
					PRINT ''' + @ChildTableName + N' update:'' + CAST(@@ROWCOUNT AS VARCHAR(10)) + N'' rows''
					PRINT ''''		
								'
			
				BEGIN TRY		
					EXEC (@Sql)	
				--	PRINT (@Sql)
				END TRY
				BEGIN CATCH
					IF @@ERROR <> 0
					BEGIN
						--ROLLBACK TRAN
						CLOSE _T
						DEALLOCATE _T
						RETURN 1
					END
				END CATCH
				
			END






	/*delete дополнительной таблицы*/
			IF @ChildTableName <> N'' 
				AND EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@ChildTableName) AND type in (N'U'))
			BEGIN	
				SET @Sql = N'
				SET QUOTED_IDENTIFIER ON
				'			
					
				SET @Sql += N'
					
					IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''' + @ChildTableName + N''') AND type in (N''U''))
						AND EXISTS (SELECT * FROM ' + @TargetServer + N'.' + @TargetDataBase + N'.sys.objects WHERE object_id = OBJECT_ID(N''' + @ChildTableName + N''') AND type in (N''U''))
					BEGIN'
					
				IF EXISTS (SELECT * FROM @ChildTableAllFieldsList WHERE TableField = 'intRowStatus')	
				SET @Sql += N'
							
					UPDATE [target]
					SET	intRowStatus = 0'
				ELSE	
				SET @Sql += N'
				
					DELETE FROM [target]'							
					
				SET @Sql += N'	
					FROM ' + @TargetServer + N'.' + @TargetDataBase + N'.dbo.' + @ChildTableName + N' AS [target]'
				SET @Sql += N'	
					JOIN ' + @TargetServer + N'.' + @TargetDataBase + N'.dbo.' + @TableName + N' AS [target_parent] ON'
				
					--- primary key	
					DECLARE _PK CURSOR FOR
					SELECT 
						TablePKField 
					FROM @TablePKList
					OPEN _PK

					FETCH NEXT FROM _PK INTO @Column
					
					IF @Column <> N''
					SET @Sql += N'
						[target_parent].' + @Column + N' = [target].' + @Column

					WHILE @@FETCH_STATUS = 0
						BEGIN 
							SET @Column = N''

							FETCH NEXT FROM _PK into @Column
							
							IF @Column <> N''
							SET @Sql += N'
								AND [target_parent].' + @Column + N' = [target].' + @Column
						END 

					CLOSE _PK
					DEALLOCATE _PK
					
				SET @Sql += N'	
					LEFT JOIN dbo.' + @TableName + N' AS [source_parent] ON'	
					
				IF @TableField1 <> N''
				SET @Sql += N'
						[source_parent].' + @TableField1 + N' = [target_parent].' + @TableField1
					
				IF @TableField2 <> N''
				SET @Sql += N'
						AND [source_parent].' + @TableField2 + N' = [target_parent].' + @TableField2
					
				IF @TableField3 <> N''
				SET @Sql += N'
						AND [source_parent].' + @TableField3 + N' = [target_parent].' + @TableField3
					
				IF @TableField4 <> N''
				SET @Sql += N'
						AND [source_parent].' + @TableField4 + N' = [target_parent].' + @TableField4
					
						
				SET @Sql += N'	
					LEFT JOIN dbo.' + @ChildTableName + N' AS [source] ON'
					
					--- primary key	
					DECLARE _PK CURSOR FOR
					SELECT 
						TablePKField 
					FROM @TablePKList
					OPEN _PK

					FETCH NEXT FROM _PK INTO @Column
					
					IF @Column <> N''
					SET @Sql += N'
						[source].' + @Column + N' = [source_parent].' + @Column

					WHILE @@FETCH_STATUS = 0
						BEGIN 
							SET @Column = N''

							FETCH NEXT FROM _PK into @Column
							
							IF @Column <> N''
							SET @Sql += N'
								AND [source].' + @Column + N' = [source_parent].' + @Column
						END 

					CLOSE _PK
					DEALLOCATE _PK
						
				SET @Sql += N'	
					WHERE [source].' + @ChildTableField1 + N' IS NULL'
				
				SET @Sql += N'
					
					
					END
					PRINT ''' + @ChildTableName + N' delete:'' + CAST(@@ROWCOUNT AS VARCHAR(10)) + N'' rows''
					PRINT ''''		
								'
			
				BEGIN TRY		
					EXEC (@Sql)	
				--	PRINT (@Sql)
				END TRY
				BEGIN CATCH
					IF @@ERROR <> 0
					BEGIN
						--ROLLBACK TRAN
						CLOSE _T
						DEALLOCATE _T
						RETURN 1
					END
				END CATCH
				
			END			
			
								
			FETCH NEXT FROM _T into @TableName, @TableField1, @TableField2, @TableField3, @TableField4, @ChildTableName, @ChildTableField1, @ChildTableField2, @ChildTableField3
		END
	CLOSE _T
	DEALLOCATE _T


	PRINT N'----------------'
	PRINT N'Merge matrix reference - end'
	PRINT N''

IF @@ERROR <> 0
--BEGIN	
--	ROLLBACK TRAN
	RETURN 1
--END
ELSE
--BEGIN
--	COMMIT TRAN
	RETURN 0
--END




SET NOCOUNT OFF
SET XACT_ABORT OFF
