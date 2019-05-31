
--*************************************************************
-- Name 				: USP_GBL_LKUP_VtrSubTyp_GetList
-- Description			: List Vector Sub Types, filered on Vector Type
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
-- EXEC [USP_GBL_LKUP_VtrSubTyp_GetList] 'EN', 6619310000000 -- Code for Fleas
--*************************************************************

CREATE PROCEDURE [dbo].[USP_GBL_LKUP_VtrSubTyp_GetList] 

	@LangID				NVARCHAR(50)		
	,@idfsVectorType	bigint

AS

	DECLARE @LogErrMsg VARCHAR(MAX)
	SELECT @LogErrMsg = ''

	BEGIN TRY  	

		SELECT 
			trtBaseReference.idfsBaseReference
			,trtBaseReference.idfsReferenceType
			,ISNULL(trtStringNameTranslation.strTextString, trtBaseReference.strDefault) AS [name]
			,trtBaseReference.strDefault
			,trtBaseReference.intHACode
			,trtBaseReference.intOrder
			,trtBaseReference.intRowStatus
			,trtBaseReference.blnSystem
		FROM 
			trtBaseReference
			INNER JOIN TrtVectorSubType ON
				trtBaseReference.idfsBaseReference = TrtVectorSubType.idfsVectorSubType
				AND
				TrtVectorSubType.idfsVectorType = @idfsVectorType
			LEFT JOIN trtStringNameTranslation ON	
				trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference 
				AND 
				trtStringNameTranslation.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
		ORDER BY
			trtBaseReference.intOrder
			,[name]
	END TRY  

	BEGIN CATCH 

		BEGIN
			SET @LogErrMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()

			SELECT @LogErrMsg
		END

	END CATCH; 

