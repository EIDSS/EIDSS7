
-- ================================================================================================
-- Name: USP_ADMIN_FF_Determinants_GET
-- Description: Retrieves the list of Determinants 
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru   11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Determinants_GET] 
(
	@LangID NVARCHAR(50) = NULL
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
		SET @langid_int = dbo.FN_GBL_LanguageCode_GET(@LangID);
	
		DECLARE @table AS TABLE 
		(
			[idfsBaseReference] BIGINT
			,[idfsReferenceType] BIGINT
			,[DefaultName] NVARCHAR(200)
			,[NationalName] NVARCHAR(400)
			,[DefaultTypeName] NVARCHAR(200)
			,[NationalTypeName] NVARCHAR(400)	
		)
	
		INSERT INTO @table
			(	
				[idfsBaseReference]
				,[idfsReferenceType]
				,[DefaultName]
				,[NationalName]
			)	
		SELECT GBR.[idfsGISBaseReference]
			   ,GBR.[idfsGISReferenceType]
			   ,GBR.[strDefault]
			   ,ISNULL(GSNT.strTextString, GBR.[strDefault])
		FROM dbo.gisBaseReference GBR
		LEFT JOIN dbo.gisStringNameTranslation GSNT
		ON GBR.idfsGISBaseReference = GSNT.idfsGISBaseReference
		   AND GSNT.idfsLanguage = @langid_int
		WHERE GBR.idfsGISReferenceType = 19000001 -- Country
			  AND GBR.intRowStatus = 0
	
		INSERT INTO @table
			(	
				[idfsBaseReference]
				,[idfsReferenceType]
				,[DefaultName]
				,[NationalName]
			)	
		SELECT BR.[idfsBaseReference]
			   ,BR.[idfsReferenceType]
			   ,BR.[strDefault]
			   ,ISNULL(SNT.strTextString, BR.[strDefault])
		FROM dbo.trtBaseReference BR 
		LEFT JOIN dbo.trtStringNameTranslation SNT
		ON BR.idfsBaseReference = SNT.idfsBaseReference
		   AND SNT.idfsLanguage = @langid_int
		   AND SNT.[intRowStatus] = 0
		WHERE BR.idfsReferenceType = 19000019 -- Diagnosis
			  AND BR.[intRowStatus] = 0
		
	   INSERT INTO @table
			(	
				[idfsBaseReference]
				,[idfsReferenceType]
				,[DefaultName]
				,[NationalName]
			)	
		SELECT BR.[idfsBaseReference]
			   ,BR.[idfsReferenceType]
			   ,BR.[strDefault]
			   ,ISNULL(SNT.strTextString, BR.[strDefault])
		FROM dbo.trtBaseReference BR 
		LEFT JOIN dbo.trtStringNameTranslation SNT
		ON BR.idfsBaseReference = SNT.idfsBaseReference
		   AND SNT.idfsLanguage = @langid_int
		   AND SNT.[intRowStatus] = 0
		WHERE BR.idfsReferenceType = 19000097 -- Tests
			  AND BR.[intRowStatus] = 0

		INSERT INTO @table
			(	
				[idfsBaseReference]
				,[idfsReferenceType]
				,[DefaultName]
				,[NationalName]
			)	
		SELECT BR.[idfsBaseReference]
			   ,BR.[idfsReferenceType]
			   ,BR.[strDefault]
			   ,ISNULL(SNT.strTextString, BR.[strDefault])
		FROM dbo.trtBaseReference BR 
		LEFT JOIN dbo.trtStringNameTranslation SNT
		ON BR.idfsBaseReference = SNT.idfsBaseReference
		   AND SNT.idfsLanguage = @langid_int
		   AND SNT.[intRowStatus] = 0
		WHERE BR.idfsReferenceType = 19000140 -- Vector Types
			  AND BR.[intRowStatus] = 0
	
	    DECLARE
	    	@DefaultTypeName NVARCHAR(200),
	    	@NationalTypeName NVARCHAR(400)
   	    
	    -- Country
	    SELECT @DefaultTypeName = strGISReferenceTypeName
	    FROM dbo.gisReferenceType
	    WHERE idfsGISReferenceType = 19000001
	    	 AND intRowStatus = 0
	    
	    SELECT @NationalTypeName = strTextString
	    FROM dbo.trtStringNameTranslation
	    WHERE idfsBaseReference = 10003001
	    	 AND idfsLanguage = @langid_int
	    	 AND [intRowStatus] = 0
	    
	    UPDATE @table
	    SET DefaultTypeName = @DefaultTypeName
   	       ,NationalTypeName = ISNULL(@NationalTypeName, @DefaultTypeName)
	    WHERE [idfsReferenceType] = 19000001
	    --------------------------------------------
	    SELECT @DefaultTypeName = strReferenceTypeName
	    FROM dbo.trtReferenceType
	    WHERE idfsReferenceType = 19000097
	    	 AND [intRowStatus] = 0 
	    SELECT @NationalTypeName = strTextString
	    FROM dbo.trtStringNameTranslation
	    WHERE idfsBaseReference = 19000097
	    	 AND idfsLanguage = @langid_int
	    	 AND [intRowStatus] = 0
	    
	    UPDATE @table
	    SET DefaultTypeName = @DefaultTypeName
	        ,NationalTypeName = ISNULL(@NationalTypeName, @DefaultTypeName)
	    WHERE [idfsReferenceType] = 19000097
	    --------------------------------------------
	    SELECT @DefaultTypeName = strReferenceTypeName
	    FROM dbo.trtReferenceType
	    WHERE idfsReferenceType = 19000019
	    	 AND [intRowStatus] = 0 
	    SELECT @NationalTypeName = strTextString
	    FROM dbo.trtStringNameTranslation
	    WHERE idfsBaseReference = 19000019
	    	 AND idfsLanguage = @langid_int
	    	 AND [intRowStatus] = 0
	    
	    UPDATE @table
	    SET DefaultTypeName = @DefaultTypeName
   	       ,NationalTypeName = ISNULL(@NationalTypeName, @DefaultTypeName)
	    WHERE [idfsReferenceType] = 19000019	
	    --------------------------------------------
	    SELECT @DefaultTypeName = strReferenceTypeName
	    FROM dbo.trtReferenceType
	    WHERE idfsReferenceType = 19000140
	    AND [intRowStatus] = 0 
	    SELECT @NationalTypeName = strTextString
	    FROM dbo.trtStringNameTranslation
	    WHERE idfsBaseReference = 19000140
	    	 AND idfsLanguage = @langid_int
	    	 AND [intRowStatus] = 0
	    
	    UPDATE @table
	    SET DefaultTypeName = @DefaultTypeName
   	       ,NationalTypeName = ISNULL(@NationalTypeName, @DefaultTypeName)
	    WHERE [idfsReferenceType] = 19000140	
   	    
	    SELECT [idfsBaseReference]
	    	  ,[idfsReferenceType]
	    	  ,[DefaultName]
	    	  ,[NationalName]
	    	  ,[DefaultTypeName]
	    	  ,[NationalTypeName]
	    FROM @table
	    ORDER BY [idfsReferenceType]
	    	    ,[NationalName]
	    	    ,[DefaultName]
	    
	    COMMIT TRANSACTION;
	END TRY 
	BEGIN CATCH   
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH;
END

