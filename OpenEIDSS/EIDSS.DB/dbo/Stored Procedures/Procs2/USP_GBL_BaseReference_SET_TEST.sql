----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Name 				: USP_GBL_BaseReference_SET
-- Description			: Insert/Update Base Reference Data
--          
-- Author               : Mark Wilson
-- 
-- Revision History
-- Name				Date		Change Detail
-- Mark Wilson    10-Nov-2017   Convert EIDSS 6 to EIDSS 7 standards and 
--                              added table name to USP_GBL_NEWID_GET call
--
-- Stephen Long		05/03/2018	Added return code and try catch block.
-- Lamont Mitchell  01/02/19    Aliased Return Code and Message Added @ReferenceID as and output in the Select statment , removed as output parameter 
-- Testing code:
/*
Example of procedure call:

DECLARE @ReferenceID bigint
DECLARE @ReferenceType bigint
DECLARE @LangID nvarchar(50)
DECLARE @DefaultName varchar(200)
DECLARE @NationalName nvarchar(200)
DECLARE @HACode int
DECLARE @Order int
DECLARE @System bit


EXECUTE USP_GBL_BaseReference_SET
   @ReferenceID
  ,@ReferenceType
  ,@LangID
  ,@DefaultName
  ,@NationalName
  ,@HACode
  ,@Order
  ,@System

*/

----------------------------------------------------------------------------
----------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GBL_BaseReference_SET_TEST] 
	@ReferenceID						BIGINT = NULL , 
	@ReferenceType						BIGINT, 
	@LangID								NVARCHAR(50), 
	@DefaultName						VARCHAR(200), -- Default reference name, used if there is no reference translation
	@NationalName						NVARCHAR(200), -- Reference name in the language defined by @LangID
	@HACode								INT = NULL, -- Bit mask for reference using
	@Order								INT = NULL, -- Reference record order for sorting
	@System								BIT = 0
AS
BEGIN
	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;
	Declare @SupressSelect table
	( 
		retrunCode int,
		returnMessage varchar(200)
	)
	BEGIN TRY
		IF EXISTS (SELECT idfsBaseReference FROM dbo.trtBaseReference WHERE idfsBaseReference = @ReferenceID AND intRowStatus = 0)
		BEGIN
			UPDATE						dbo.trtBaseReference
			SET
										idfsReferenceType = @ReferenceType, 
										strDefault = ISNULL(@DefaultName, strDefault),
										intHACode = ISNULL(@HACode, intHACode),
										intOrder = ISNULL(@Order, intOrder),
										blnSystem = ISNULL(@System, blnSystem)
			WHERE						idfsBaseReference = @ReferenceID;
		END
		ELSE
		BEGIN
		    INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'trtBaseReference', @ReferenceID OUTPUT;

			INSERT INTO					dbo.trtBaseReference
			(
										idfsBaseReference, 
										idfsReferenceType, 
										intHACode, 
										strDefault,
										intOrder,
										blnSystem
			)
  			VALUES
			(
										@ReferenceID, 
										@ReferenceType, 
										@HACode, 
										@DefaultName, 
										@Order,
										@System
			);
			DECLARE @idfCustomizationPackage BIGINT;
			SELECT @idfCustomizationPackage = dbo.FN_GBL_CustomizationPackage_GET();
		
			IF @idfCustomizationPackage IS NOT NULL AND @idfCustomizationPackage <> 51577300000000 --The USA
			BEGIN
				EXEC					dbo.USP_GBL_BaseReferenceToCP_SET @ReferenceID, @idfCustomizationPackage;
			END
		END
    
		IF (@LangID = N'en')
		BEGIN
			IF EXISTS(SELECT idfsBaseReference FROM dbo.trtStringNameTranslation WHERE idfsBaseReference=@ReferenceID AND idfsLanguage = dbo.FN_GBL_LanguageCode_GET(N'en'))
				EXEC					dbo.USSP_GBL_StringTranslation_SET @ReferenceID, @LangID, @DefaultName, @DefaultName;
		END
		ELSE
		BEGIN
			INSERT INTO @SupressSelect
			EXEC						dbo.USSP_GBL_StringTranslation_SET @ReferenceID, @LangID, @DefaultName, @NationalName;
		END

		SELECT							@returnCode 'ReturnCode', @returnMsg 'ReturnMessage',@ReferenceID 'ReferenceID';
	END TRY  
	BEGIN CATCH 
	THROW;
	END CATCH;
END

--Select * from trtBaseReference

--EXEC USP_GBL_BaseReference_SET_TEST 55540680000129,19000146,'T','BLAH Test','Lamont Test National',NULL,NULL,0

--Select * from trtStringNameTranslation