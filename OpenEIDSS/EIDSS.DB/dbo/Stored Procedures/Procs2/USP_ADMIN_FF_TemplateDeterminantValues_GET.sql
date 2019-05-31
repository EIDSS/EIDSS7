
-- ================================================================================================
-- Name: USP_ADMIN_FF_TemplateDeterminantValues_GET
-- Description: Return list of Template Determinant Values.
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_TemplateDeterminantValues_GET]
(
	@LangID NVARCHAR(50) = NULL
	,@idfsFormTemplate BIGINT = NULL	
)
AS
BEGIN	
	SET NOCOUNT ON;

	IF (@LangID IS NULL)
		SET @LangID = 'en';
	DECLARE 
		@langid_int BIGINT,
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX) 

	BEGIN TRY
		SET @langid_int = dbo.fnGetLanguageCode(@LangID);

		SELECT DV.idfDeterminantValue
			   ,FT.idfsFormTemplate
		       ,FT.idfsFormType
		       ,ISNULL(DV.idfsBaseReference, DV.idfsGISBaseReference) AS [DeterminantValue]
		       ,CASE WHEN (DV.idfsBaseReference IS NOT NULL)
					 THEN (SELECT [strDefault]
						   FROM dbo.trtBaseReference
						   WHERE [idfsBaseReference] = DV.idfsBaseReference
								 AND [intRowStatus] = 0)
		       		 ELSE
		       			  (SELECT [strDefault]
						   FROM dbo.gisBaseReference
						   WHERE [idfsGISBaseReference] = DV.idfsGISBaseReference
								 AND DV.intRowStatus = 0)
		       		END AS [DeterminantDefaultName]
		       ,CASE WHEN (DV.idfsBaseReference IS NOT NULL)
					 THEN (SELECT [strTextString]
						   FROM dbo.[trtStringNameTranslation]
						   WHERE [idfsBaseReference] = DV.idfsBaseReference
								 AND idfsLanguage = @langid_int 
								 AND [intRowStatus] = 0)
		       		 ELSE
		       			   (SELECT [strTextString]
						    FROM dbo.[gisStringNameTranslation]
						    WHERE [idfsGISBaseReference] = DV.idfsGISBaseReference
							      AND idfsLanguage = @langid_int
							      AND intRowStatus = 0)
		       		 END AS [DeterminantNationalName]			       		
		       ,[idfsBaseReference]
		       ,[idfsGISBaseReference]
		       ,CASE WHEN (DV.idfsBaseReference IS NOT NULL)
					 THEN (SELECT idfsReferenceType
						   FROM dbo.trtBaseReference
						   WHERE [idfsBaseReference] = DV.idfsBaseReference
						         AND [intRowStatus] = 0)
		       		 ELSE
		       			  (SELECT idfsGISReferenceType
						   FROM dbo.gisBaseReference
						   WHERE [idfsGISBaseReference] = DV.idfsGISBaseReference
								 AND DV.intRowStatus = 0)
		       		 END AS [DeterminantType]
		       ,CASE WHEN (DV.idfsBaseReference IS NOT NULL)
					 THEN (SELECT strReferenceTypeName
						   FROM dbo.trtReferenceType
						   WHERE [idfsReferenceType] IN (SELECT TOP 1 idfsReferenceType
														 FROM dbo.trtBaseReference
														 WHERE [idfsBaseReference] = DV.idfsBaseReference
														       AND [intRowStatus] = 0)
								 AND [intRowStatus] = 0)
		       		 ELSE 
						  (SELECT strGISReferenceTypeName
						   FROM dbo.gisReferenceType
						   WHERE [idfsGISReferenceType] IN (SELECT TOP 1 idfsGISReferenceType
															FROM dbo.gisBaseReference
															WHERE [idfsGISBaseReference] = DV.idfsGISBaseReference
																  AND DV.intRowStatus = 0)
								 AND intRowStatus = 0)
		       		 END AS [DeterminantTypeDefaultName]
		       ,ISNULL(CASE WHEN (DV.idfsBaseReference IS NOT NULL)
							THEN (SELECT [strTextString]
								  FROM dbo.[trtStringNameTranslation]
								  WHERE idfsLanguage = @langid_int
										AND [idfsBaseReference] IN (SELECT TOP 1 idfsReferenceType
																	FROM dbo.trtReferenceType
																	WHERE [idfsReferenceType] IN (SELECT TOP 1 idfsReferenceType
																								  FROM dbo.trtBaseReference
																								  WHERE [idfsBaseReference] = DV.idfsBaseReference
																										AND [intRowStatus] = 0)
																		  AND [intRowStatus] = 0)
										AND [intRowStatus] = 0)
		       				 ELSE 
								 (SELECT strTextString
								  FROM dbo.trtStringNameTranslation
								  WHERE idfsBaseReference = 10003001
										AND idfsLanguage = @langid_int
										AND [intRowStatus] = 0)
		       				 END 
		       	,CASE WHEN (DV.idfsBaseReference IS NOT NULL)
					  THEN (SELECT strReferenceTypeName
							FROM dbo.trtReferenceType
							WHERE [idfsReferenceType] IN (SELECT TOP 1 idfsReferenceType
														  FROM dbo.trtBaseReference
														  WHERE [idfsBaseReference] = DV.idfsBaseReference
																AND [intRowStatus] = 0) 
								  AND [intRowStatus] = 0)
		       		  ELSE
		       			   (SELECT strGISReferenceTypeName
						    FROM dbo.gisReferenceType
							WHERE idfsGISReferenceType = 19000001
								  AND intRowStatus = 0)
		       		  END) AS [DeterminantTypeNationalName]
		FROM dbo.[ffFormTemplate] FT
		INNER JOIN dbo.[ffDeterminantValue] DV
		ON FT.idfsFormTemplate = DV.idfsFormTemplate
		   AND DV.[intRowStatus]=0 
		WHERE ((FT.idfsFormTemplate = @idfsFormTemplate)
			   OR (@idfsFormTemplate IS NULL))				
			  AND FT.[intRowStatus] = 0
		ORDER BY [DeterminantNationalName]

		COMMIT TRANSACTION;
	END TRY 
	BEGIN CATCH   
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH;
END

