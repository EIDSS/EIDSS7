
--*************************************************************
-- Name 				: USP_ADMIN_STAT_GetDetail
-- Description			: Get Settlement details
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--EXECUTE USP_ADMIN_STAT_GetDetail 73890000000,'en'
--*************************************************************

CREATE PROCEDURE [dbo].[USP_ADMIN_STAT_GetDetail]
(
 @idfStatistic	BIGINT,		--##PARAM @idfStatistic - statistic record ID
 @LangID		NVARCHAR(50) --##PARAM @LangID - languageID
)
AS
BEGIN
	DECLARE @returnCode INT = 0
	DECLARE @returnMsg VARCHAR(MAX) = 'Success'

	BEGIN TRY  	

		SELECT * FROM dbo.FN_ADMIN_STAT_GetList(@LangID)
		WHERE 
			idfStatistic = @idfStatistic

		SELECT @returnCode, @returnMsg
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
				
			SELECT @returnCode, @returnMsg
		END

	END CATCH;
END

