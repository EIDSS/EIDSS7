
--*************************************************************
-- Name 				: USP_ADMIN_LKUP_ReferenceType_GETLIST
-- Description			: Get Reference Type Lookup values
--          
-- Author               : Mark Wilson
-- Updated original code from USP_ADMIN_LKUP_BASEREFEDITOR_GETLIST
-- to filter based on bitwise & 4 on intStandard column
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--EXECUTE USP_ADMIN_LKUP_ReferenceType_GETLIST 
--*************************************************************

CREATE  PROCEDURE [dbo].[USP_ADMIN_LKUP_ReferenceType_GETLIST] 
(
 @LangId	NVARCHAR(20) = 'en'
)
AS 

	DECLARE @returnCode INT = 0;
	DECLARE @returnMsg  NVARCHAR(max) = 'SUCCESS'

	BEGIN TRY  	

			SELECT		tb.strDefault, 
						tr.name,
						tb.idfsBaseReference, 
						tb.idfsReferenceType,
						tb.blnSystem
			FROM		trtBaseReference tb
			INNER JOIN	FN_GBL_ReferenceRepair(@LangId, 19000076) tr ON	tb.idfsBaseReference  = tr.idfsReference
			LEFT JOIN dbo.trtReferenceType RT ON RT.idfsReferenceType = tb.idfsBaseReference
			WHERE	(RT.intStandard & 4) <> 0 
			AND tb.intRowStatus = 0

			ORDER BY	tb.strDefault
			
			SELECT @returnCode, @returnMsg

	END TRY 
	 
	BEGIN CATCH 

		BEGIN
			SET @returnCode = ERROR_NUMBER()
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


