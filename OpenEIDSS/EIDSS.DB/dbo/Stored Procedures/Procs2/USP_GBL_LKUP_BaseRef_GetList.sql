
--*************************************************************
-- Name 				: USP_GBL_LKUP_BaseRef_GetList
-- Description			: List filered values from tlbBaseReferene table
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name		Date		Change Detail
-- Maheshwar Deo	05/27/2018	Fixed issue with script when parameter @intHACode is 0
-- Maheshwar Deo	05/30/2018	Fixed issue with script for second table
--
--@intHACode Code List
--0		None
--2		Human
--4		Exophyte
--8		Plant
--16	Soil
--32	Livestock
--64	Avian
--128	Vector
--256	Syndromic
--510	All	
--
-- Testing code:
-- Exec USP_GBL_BaseRef_LKUP 'EN', 'Diagnosis', 128
--*************************************************************

CREATE PROCEDURE [dbo].[USP_GBL_LKUP_BaseRef_GetList] 
(
	@LangID				NVARCHAR(50)		
	,@ReferenceTypeName VARCHAR(400)	= NULL
	,@intHACode			BIGINT			= 0		--None 
)
AS

	DECLARE @HACodeMax	BIGINT = 510
	DECLARE @ReturnMsg	VARCHAR(MAX) = 'Success'
	DECLARE @ReturnCode	BIGINT = 0

	BEGIN TRY  	

	IF (@intHACode = 0)
		BEGIN
			SELECT 
			DISTINCT
			TOP 100 PERCENT
				trtBaseReference.idfsBaseReference
				,trtBaseReference.idfsReferenceType
				,trtBaseReference.strBaseReferenceCode
				,trtBaseReference.strDefault
				,ISNULL(trtStringNameTranslation.strTextString, trtBaseReference.strDefault) AS [name]
				,trtBaseReference.intHACode
				,trtBaseReference.intOrder
				,trtBaseReference.intRowStatus
				,trtBaseReference.blnSystem
				,trtReferenceType.intDefaultHACode
				,'0' AS strHACode
			FROM	trtBaseReference
			INNER JOIN trtReferenceType ON 
					trtReferenceType.idfsReferenceType = trtBaseReference.idfsReferenceType
					AND
					trtReferenceType.strReferenceTypeName = CASE ISNULL(@ReferenceTypeName, '') WHEN '' THEN trtReferenceType.strReferenceTypeName ELSE @ReferenceTypeName END
			LEFT JOIN trtStringNameTranslation ON	
					trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference 
			AND 
					trtStringNameTranslation.idfsLanguage = dbo.FN_GBL_LanguageCode_Get(@LangID)
			WHERE	
				ISNULL(trtBaseReference.intHACode, 0) = 0
				And
				ISNULL(trtBaseReference.intRowStatus, 0) = 0	
			ORDER BY 
				trtBaseReference.intOrder
				,[name]
		END		
	ELSE
		BEGIN
			SELECT 
			DISTINCT
			TOP 100 PERCENT
				trtBaseReference.idfsBaseReference
				,trtBaseReference.idfsReferenceType
				,trtBaseReference.strBaseReferenceCode
				,trtBaseReference.strDefault
				,ISNULL(trtStringNameTranslation.strTextString, trtBaseReference.strDefault) AS [name]
				,trtBaseReference.intHACode
				,trtBaseReference.intOrder
				,trtBaseReference.intRowStatus
				,trtBaseReference.blnSystem
				,trtReferenceType.intDefaultHACode
				,dbo.FN_GBL_SPLITHACODEASSTRING(trtBaseReference.intHACode, 510) AS strHACode
			FROM 
				trtBaseReference
				INNER JOIN trtReferenceType ON 
					trtReferenceType.idfsReferenceType = trtBaseReference.idfsReferenceType
					AND
					trtReferenceType.strReferenceTypeName = CASE ISNULL(@ReferenceTypeName, '') WHEN '' THEN trtReferenceType.strReferenceTypeName ELSE @ReferenceTypeName END
				LEFT JOIN trtStringNameTranslation ON	
					trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference 
					AND 
					trtStringNameTranslation.idfsLanguage = dbo.FN_GBL_LanguageCode_Get(@LangID)
				INNER JOIN (SELECT intHACode From dbo.FN_GBL_SplitHACode(IsNull(@intHACode, 0), @HACodeMax)) HACodeList On
					(HACodeList.intHACode IN (SELECT intHACode From dbo.FN_GBL_SplitHACode(IsNull(trtBaseReference.intHACode, 0), @HACodeMax)) AND HACodeList.intHACode > 0)
				INNER JOIN trtHACodeList ON
					HACodeList.intHACode = trtHACodeList.intHACode
			WHERE	
				ISNULL(trtBaseReference.intRowStatus, 0) = 0	
			ORDER BY 
				trtBaseReference.intOrder
				,[name]
		END

		--Get the HACode for the selected category (Reference Type)
		Declare @intHACodeForCategory BIGINT

		--Fix: until HACodeMask is defined in trtReferenceType table
		--@intHACodeForCategory = ISNULL(intHACodeMask, 510)
		Select 
			@intHACodeForCategory = (CASE WHEN ISNULL(intHACodeMask, 510) > ISNULL(intDefaultHACode, 510) THEN ISNULL(intHACodeMask, 510) ELSE ISNULL(intDefaultHACode, 510) END)
		From 
			trtReferenceType 
		Where 
			trtReferenceType.strReferenceTypeName = CASE ISNULL(@ReferenceTypeName, '') WHEN '' THEN trtReferenceType.strReferenceTypeName ELSE @ReferenceTypeName END

		--Get the filterd list of HA Code for the HA Code for given category (reference type)
		SELECT  
			th.intHACode,
			th.strNote
		FROM
			dbo.trtHACodeList th
		WHERE
			th.intRowStatus = 0
			And
			th.intHACode In (Select intHAcode From dbo.FN_GBL_SplitHACode(@intHACodeForCategory, 510))

		SELECT @ReturnCode, @ReturnMsg

	END TRY  

	BEGIN CATCH 

		BEGIN
			SET @ReturnCode = ERROR_NUMBER()
			SET @ReturnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()

			SELECT @ReturnCode, @ReturnMsg
		END

	END CATCH;
