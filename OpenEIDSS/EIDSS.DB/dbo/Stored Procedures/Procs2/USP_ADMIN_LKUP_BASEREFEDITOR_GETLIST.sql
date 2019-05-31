--*************************************************************
-- Name 				: USP_ADMIN_LKUP_BASEREFEDITOR_GETLIST
-- Description			: Get Base Editor Lookup values
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--EXECUTE USP_ADMIN_LKUP_BASEREFEDITOR_GETLIST 
--*************************************************************

CREATE  PROCEDURE [dbo].[USP_ADMIN_LKUP_BASEREFEDITOR_GETLIST] 
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
			INNER JOIN	FN_GBL_ReferenceRepair(@LangId, 19000076) tr
			ON			tb.idfsBaseReference  = tr.idfsReference
			WHERE		(tb.intHACode = 0 OR tb.intHACODE IS NULL)
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


