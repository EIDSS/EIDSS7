
CREATE PROCEDURE [dbo].[usp_dbGetProcParams] 
     @proc_name SYSNAME 
WITH EXECUTE AS OWNER 
AS 
BEGIN 
       SELECT 
             ORDINAL_POSITION
             ,PARAMETER_MODE
             ,[PARAMETER_NAME] = COALESCE(PARAMETER_NAME, '<no params>') 
             ,[DATA_TYPE] = COALESCE(UPPER(DATA_TYPE) 
             + 
             CASE 
             WHEN DATA_TYPE IN ('NUMERIC', 'DECIMAL') THEN  
                    '(' + CAST(NUMERIC_PRECISION AS VARCHAR)  
                    + ', ' + CAST(NUMERIC_SCALE AS VARCHAR) + ')'  
             WHEN RIGHT(DATA_TYPE, 4) = 'CHAR' THEN 
                    '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' 
             ELSE 
                    '' 
             END
             + 
             CASE PARAMETER_MODE  
             WHEN 
                    'INOUT' THEN ' OUTPUT' 
             ELSE 
                    ' ' 
             END, '-'),
             CHARACTER_MAXIMUM_LENGTH 
     FROM  
             INFORMATION_SCHEMA.PARAMETERS 
     WHERE 
             SPECIFIC_SCHEMA = 'dbo' 
             AND
             SPECIFIC_NAME = @proc_name
     ORDER BY  
             ORDINAL_POSITION 
END


