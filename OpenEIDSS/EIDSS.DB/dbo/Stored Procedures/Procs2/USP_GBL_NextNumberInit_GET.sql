
----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Name 				: USP_GBL_NextNumberInit_GET
-- Description			: Get Next Number - copied 6.1 code to V7
--                        Generates the next number for barcodes, etc.
--          
-- Author               : Mark Wilson
-- 
-- Revision History
-- Name				Date		Change Detail
--
--
-- Testing code:
--
--  DECLARE @RC int
--	EXEC @RC = dbo.USP_GBL_NextNumberInit_GET 10057006, N'Box Barcode', N'B', N'', 0, 4 

----------------------------------------------------------------------------
----------------------------------------------------------------------------
CREATE   PROCEDURE [dbo].[USP_GBL_NextNumberInit_GET]( 
		@idfsNumberName BIGINT,
		@strDocumentName NVARCHAR(200),
		@strPrefix NVARCHAR(50), 
		@strSuffix NVARCHAR(50), 
		@intNumberValue INT,
		@intMinNumberLength INT,
		@blnUseHASCodeSite TINYINT = null
)

AS
BEGIN 
	  IF NOT EXISTS (SELECT idfsNumberName FROM tstNextNumbers WHERE idfsNumberName = @idfsNumberName)
	  BEGIN

 		 IF ISNULL(@strDocumentName,N'') = N''
		 BEGIN	
			SELECT @strDocumentName = NAME FROM dbo.FN_GBL_Reference_List_GET('en',19000057) --NextNumbers 
			WHERE idfsReference = @idfsNumberName
		 END

 			 IF NOT EXISTS (SELECT * FROM dbo.trtBaseReference WHERE idfsBaseReference = @idfsNumberName)
				EXECUTE USP_GBL_BaseReference_SET
						@idfsNumberName,
						19000057, -- Numbering Schema Document Type 
						'en',
						@strDocumentName,
						@strDocumentName,
						NULL,
						NULL	
 
			 INSERT INTO tstNextNumbers(
				idfsNumberName, 
				strDocumentName,
				strPrefix, 
				strSuffix, 
				intNumberValue,
				intMinNumberLength,
				blnUsePrefix,
				blnUseSiteID,
				blnUseYear,
				blnUseHACSCodeSite,
				blnUseAlphaNumericValue,
				intYear
				)
			VALUES(
				@idfsNumberName, 
				@strDocumentName,
				@strPrefix, 
				@strSuffix, 
				@intNumberValue,
				@intMinNumberLength,
				1, --blnUsePrefix,
				1, --blnUseSiteID,
				1, --blnUseYear,
				isnull(@blnUseHASCodeSite,0),
				1, --blnUseAlphaNumericValue,
				Year(getdate())
				)

	  END

	  IF NOT EXISTS(SELECT * FROM dbo.trtBaseReference WHERE idfsBaseReference = @idfsNumberName)
		 EXECUTE USP_GBL_BaseReference_SET
				 @idfsNumberName,
				 19000057, --Numbering Schema Document Type 
				 'en',
				 @strDocumentName,
				 @strDocumentName,
				 NULL,
				 NULL	

	  RETURN 0

END -- END Stored Procedure
