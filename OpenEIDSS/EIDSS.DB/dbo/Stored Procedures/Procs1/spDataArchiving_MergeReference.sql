
CREATE PROCEDURE [dbo].[spDataArchiving_MergeReference](
	@TargetServer NVARCHAR(100)
	, @TargetDataBase NVARCHAR(100)
	, @ReferenceTable ListOfTable READONLY
	)
AS
 

SET XACT_ABORT ON
SET NOCOUNT ON

--BEGIN TRAN

PRINT N'Merge reference'
PRINT N'----------------'

DECLARE @TableName NVARCHAR(200) = '', @IDColumnName NVARCHAR(200) = '', @IDColumnName2 NVARCHAR(200) = '', @Column varchar(200) = ''
DECLARE @Sql NVARCHAR(MAX) = ''
DECLARE @blnRowStatus BIT = 0


--- table
DECLARE _T CURSOR FOR
	SELECT 
		NameTable
	FROM @ReferenceTable
	ORDER BY OrderTable
OPEN _T

FETCH NEXT FROM _T into @TableName


WHILE @@FETCH_STATUS = 0
	BEGIN		
	
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
				USING dbo.' + @TableName + N' AS [source]'
			
			
			
			--- primary key	
			DECLARE _PK CURSOR FOR
			SELECT 
				a.COLUMN_NAME
			FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS a
			inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS b
			ON a.CONSTRAINT_NAME = b.CONSTRAINT_NAME
			WHERE b.CONSTRAINT_TYPE = 'PRIMARY KEY'
				AND a.TABLE_NAME = @TableName
			OPEN _PK

			FETCH NEXT FROM _PK INTO @IDColumnName

			IF @IDColumnName <> N''
			SET @Sql += N'
				ON ([target].' + @IDColumnName + N' = [source].' + @IDColumnName + N')'

			WHILE @@FETCH_STATUS = 0
				BEGIN 
					SET @IDColumnName2 = N''

					FETCH NEXT FROM _PK into @IDColumnName2
					
					IF @IDColumnName2 <> N''
					SET @Sql += N'
						AND ([target].' + @IDColumnName2 + N' = [source].' + @IDColumnName2 + N')'
				END 

			CLOSE _PK
			DEALLOCATE _PK
			
			--update only if count non-PK fields > 0
			IF (
					SELECT
						COUNT(a.COLUMN_NAME)
					FROM INFORMATION_SCHEMA.COLUMNS as a
					WHERE a.TABLE_NAME = @TableName
						AND a.DATA_TYPE not in ('text', 'ntext', 'image', 'xml', 'varbinary', 'geometry', 'uniqueidentifier')
						AND a.COLUMN_NAME NOT IN (
													SELECT 
														a.COLUMN_NAME
													FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS a
													inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS b
													ON a.CONSTRAINT_NAME = b.CONSTRAINT_NAME
													WHERE b.CONSTRAINT_TYPE = 'PRIMARY KEY'
														AND a.TABLE_NAME = @TableName
												)
				) > 0
			BEGIN
				
				SET @Sql += N'	
					WHEN MATCHED AND ('	
					
				--условия проверки отличия
				DECLARE _C1 CURSOR FAST_FORWARD FOR
				SELECT
					a.COLUMN_NAME
				FROM INFORMATION_SCHEMA.COLUMNS as a
				WHERE a.TABLE_NAME = @TableName
					AND a.DATA_TYPE not in ('text', 'ntext', 'image', 'xml', 'varbinary', 'geometry', 'uniqueidentifier')
					AND a.COLUMN_NAME NOT IN (
													SELECT 
														a.COLUMN_NAME
													FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS a
													inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS b
													ON a.CONSTRAINT_NAME = b.CONSTRAINT_NAME
													WHERE b.CONSTRAINT_TYPE = 'PRIMARY KEY'
														AND a.TABLE_NAME = @TableName
												)
				ORDER BY ORDINAL_POSITION	
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
								SET '	
				
				
				--update fields
				DECLARE _C2 CURSOR FAST_FORWARD FOR
				SELECT
					a.COLUMN_NAME
				from INFORMATION_SCHEMA.COLUMNS as a
				WHERE a.TABLE_NAME = @TableName
					AND a.DATA_TYPE not in ('uniqueidentifier')
					AND a.COLUMN_NAME NOT IN (
													SELECT 
														a.COLUMN_NAME
													FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS a
													inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS b
													ON a.CONSTRAINT_NAME = b.CONSTRAINT_NAME
													WHERE b.CONSTRAINT_TYPE = 'PRIMARY KEY'
														AND a.TABLE_NAME = @TableName
												)
				ORDER BY ORDINAL_POSITION	
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
					WHEN NOT MATCHED
						THEN
							INSERT ('
				
			
			--insert fields
			DECLARE _C3 CURSOR FAST_FORWARD FOR
			SELECT
				a.COLUMN_NAME
			from INFORMATION_SCHEMA.COLUMNS as a
			WHERE a.TABLE_NAME = @TableName
			ORDER BY ORDINAL_POSITION	
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
				a.COLUMN_NAME
			from INFORMATION_SCHEMA.COLUMNS as a
			WHERE a.TABLE_NAME = @TableName
			ORDER BY ORDINAL_POSITION	
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
					
			
			SET @blnRowStatus = 0
			
			--delete
			DECLARE _C5 CURSOR FAST_FORWARD FOR
			SELECT
				a.COLUMN_NAME
			from INFORMATION_SCHEMA.COLUMNS as a
			WHERE a.TABLE_NAME = @TableName
			ORDER BY ORDINAL_POSITION	
			OPEN _C5
			
			FETCH NEXT FROM _C5 INTO @Column
			
			WHILE @@FETCH_STATUS = 0
				BEGIN
				
				IF @Column = 'intRowStatus' AND @blnRowStatus = 0
					BEGIN
						SET @blnRowStatus = 1
										
						SET @Sql += N'
						AND intRowStatus = 0
						THEN
							UPDATE SET intRowStatus = 1
		--					OUTPUT $action, Inserted.*, Deleted.*
							;				
				PRINT ''' + @TableName + N' merged:'' + CAST(@@ROWCOUNT AS VARCHAR(10)) + N'' rows''
				PRINT ''''	
							'
					END
				
				FETCH NEXT FROM _C5 INTO @Column
				
				END
			
			CLOSE _C5
			DEALLOCATE _C5
			
			IF @blnRowStatus = 0
			SET @Sql += N'
						THEN
							DELETE
		--					OUTPUT $action, Inserted.*, Deleted.*
							;
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
							
		FETCH NEXT FROM _T into @TableName
	END
CLOSE _T
DEALLOCATE _T


PRINT N'----------------'
PRINT N'Merge reference - end'
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
