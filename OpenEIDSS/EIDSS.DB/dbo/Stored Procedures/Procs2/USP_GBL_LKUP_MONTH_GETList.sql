--*************************************************************
-- Name 				: USP_GBL_LKUP_MONTH_GETList
-- Description			: Returns the list of month names
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
-- Testing code:
/*
----testing code:
SELECT a.idfsReference, a.name, a.LongName FROM dbo.FN_GBL_Reference_GETList('en',19000132) 
*/
--====================================================================================================
CREATE PROCEDURE [dbo].[USP_GBL_LKUP_MONTH_GETList]
( 
	@LangID NVARCHAR(50) --##PARAM @LangID - language ID
)	
AS
DECLARE @returnMsg VARCHAR(MAX) = 'Success'
DECLARE @returnCode BIGINT = 0
BEGIN

	BEGIN TRY  
			SELECT	a.idfsReference, 
					a.strDefault, 
					a.strTextString 
			FROM	dbo.FN_GBL_Reference_GETList('en',19000132) a
			WHERE	a.intOrder > 0
			ORDER BY a.intOrder

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
			SELECT @returnCode, @returnMsg
		END

	END CATCH; 
END
