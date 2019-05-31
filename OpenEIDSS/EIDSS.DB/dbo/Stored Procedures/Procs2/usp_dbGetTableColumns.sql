

CREATE PROCEDURE [dbo].[usp_dbGetTableColumns] 
     @table_name SYSNAME
     ,@column_name SYSNAME = ''
WITH EXECUTE AS OWNER 
AS
      IF (@column_name = '')
             BEGIN
                SELECT 
					ORDINAL_POSITION
					,COLUMN_NAME
					,COLUMN_DEFAULT
					,IS_NULLABLE
					,DATA_TYPE
					,CHARACTER_MAXIMUM_LENGTH
                FROM
					INFORMATION_SCHEMA.COLUMNS 
                WHERE
					TABLE_SCHEMA = 'dbo' 
                    AND
                    TABLE_NAME = @table_name
                ORDER BY 
					ORDINAL_POSITION 
             END
      ELSE
             BEGIN
                SELECT 
					ORDINAL_POSITION
					,COLUMN_NAME
					,COLUMN_DEFAULT
					,IS_NULLABLE
					,DATA_TYPE
					,CHARACTER_MAXIMUM_LENGTH
                FROM
					INFORMATION_SCHEMA.COLUMNS 
				WHERE 
					TABLE_SCHEMA = 'dbo' 
                    AND
                    TABLE_NAME = @table_name
                    AND
                    COLUMN_NAME = @column_name
                ORDER BY 
					ORDINAL_POSITION 
             END
