/*******************************************************
NAME						: USP_ADMIN_BASEREF_GETList		


Description					: Returns List Of Base Reference Types

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					11/15/2018							Initial Created
			Lamont Mitchell					4/1/2019							Changed Description
*******************************************************/
CREATE PROCEDURE [dbo].[USP_ADMIN_BASEREF_GETList]
	@referenceType							INT,
	@LangID									NVARCHAR(50)
AS
BEGIN
	
	DECLARE @returnMsg						VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode						BIGINT = 0;
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	BEGIN TRY
		
		SELECT 
			[idfsBaseReference], 
			[idfsReferenceType], 
			[strBaseReferenceCode], 
			[strDefault], 
			[intHACode], 
			[intOrder], 
			[blnSystem], 
			[intRowStatus], 
			[rowguid], 
			[strMaintenanceFlag], 
			[strReservedAttribute]
		FROM  dbo.trtBaseReference
		WHERE [idfsReferenceType] = @referenceType
		SELECT @returnCode, @returnMsg
	END TRY
	BEGIN CATCH
			BEGIN
				SET @returnCode = ERROR_NUMBER()
				SET @returnMsg =    'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
									+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
									+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
									+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
									+ ' ErrorLine: ' +  CONVERT(VARCHAR, ISNULL(ERROR_LINE(), ''))
									+ ' ErrorMessage: ' + ERROR_MESSAGE();
				SELECT @returnCode, @returnMsg
			END
		
	END CATCH
END
