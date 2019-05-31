
--=====================================================================================================
-- Created by:    Mandar Kulkarni
-- Last modified date:  11/08/2017
-- Description:    SP to get a new ID (primary key) value for a given table
--                JL: calling USP_GBL_NEXTKEYID_PRE_GET to get highest KEYID and add increment number
/*
----testing code:
DECLARE	@return_value int,
		@idfsKey bigint
EXEC	@return_value = [dbo].[USP_GBL_NEXTKEYID_GET]
		@tableName = N'lkupconfigparm',
		@idfsKey = @idfsKey OUTPUT
*/
--=====================================================================================================
CREATE PROCEDURE [dbo].[USP_GBL_NEXTKEYID_GET_NEW] 
(
 @tableName VARCHAR(100),
 @idfsKey	BIGINT = 0 OUTPUT,
 @IsReturnCodesDisabled BIT = 0
)
AS
DECLARE @returnCode		INT = 0
DECLARE @returnMsg		NVARCHAR(max) = 'Success'
DECLARE @sqlString		NVARCHAR(max) 
DECLARE @increamentBy	INT = 1;

------==================================================
------for local debug 
----DECLARE  @tableName VARCHAR(100), @idfsKey	BIGINT 
--------SET @tableName='trtBaseReference'
----SET @tableName='lkupconfigparm'
------==================================================
BEGIN

	BEGIN TRY  
		----prepare next ID based on returned highest id
		EXEC [dbo].[USP_GBL_NEXTKEYID_PRE_GET_NEW] @tableName, @idfsKey OUTPUT, @IsReturnCodesDisabled
		----PRINT '@idfsKey returned: '+ CONVERT(VARCHAR(20),@idfsKey) 

		SET @idfsKey=@idfsKey+@increamentBy
		----PRINT '@idfsKey for next: '+ CONVERT(VARCHAR(20),@idfsKey) 
        

		  -- Check if table name exists in the Primary Keys table
		  IF EXISTS (SELECT * FROM dbo.LKUPNextKey WHERE tableName = @tableName)

			  -- If table row exists, update info
			   BEGIN
					-- update the last key value in the table for the next time.
					UPDATE	dbo.LKUPNextKey
					SET		LastUsedKey = @idfsKey,
							AuditUpdateDTM=GETDATE()
					WHERE	tableName = @tableName
				
				if @IsReturnCodesDisabled = 0	
				SELECT	@returnCode 'ReturnCode', @returnMsg 'ReturnMessage';
			   END
		  ELSE 
			  -- If table row does not exists, insert  a new row. 
			   BEGIN
				
					INSERT
					INTO	dbo.LKUPNextKey
							(
							 TableName,
							 LastUsedKey,
							 intRowStatus
							 )
					VALUES
							(
							 @tableName,
							 @idfsKey,
							 0
							 )
			   END

			if @IsReturnCodesDisabled = 0	
		    SELECT	@returnCode 'ReturnCode', @returnMsg 'ReturnMessage'

	 END TRY  

	 BEGIN CATCH 
		  BEGIN
			   SET @returnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()
			   SET @returnCode = ERROR_NUMBER()
    
			  if @IsReturnCodesDisabled = 0		
			  SELECT	@returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
		  END
	 END CATCH;
END

