----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Name 				: USSP_ADMIN_BASEREF_SET
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
--
-- Testing code:
/*
Example of procedure call:

DECLARE @idfsBasereference bigint
DECLARE @idfsReferenceType bigint
DECLARE @LangID nvarchar(50)
DECLARE @DefaultName varchar(200)
DECLARE @NationalName nvarchar(200)
DECLARE @HACode int
DECLARE @Order int
DECLARE @System bit


EXECUTE USP_GBL_BaseReference_SET
   @idfsBasereference
  ,@idfsReferenceType
  ,@LangID
  ,@DefaultName
  ,@NationalName
  ,@HACode
  ,@Order
  ,@System

*/
----------------------------------------------------------------------------
----------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USSP_ADMIN_BASEREF_SET] 
(
	@LangId								NVARCHAR(50),
	@idfsBasereference					BIGINT OUTPUT, 
	@idfsReferenceType					BIGINT, 
	@DefaultName						VARCHAR(2000), -- Default reference name, used if there is no reference translation
	@NationalName						NVARCHAR(2000), -- Reference name in the language defined by @LangID
	@HACode								INT = NULL, 
	@Order								INT = NULL, -- Reference record order for sorting
	@System								BIT = 0,
	@strMaINTenanceFlag					NVARCHAR(20),
	@RecordAction						NCHAR(1)
)
AS
BEGIN
	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;

	BEGIN TRY
		-- SPECIAL SCENARIO Check if Reference type exists already even the Action is Insert
		-- Update existing intHACODE to add the newly passed HA Code
		IF @RecordAction = 'I' 
			BEGIN
				SELECT @idfsBasereference = (	SELECT	idfsBasereference
												FROM	dbo.trtBaseReference
												WHERE	strDefault = @DefaultName
												AND		idfsReferenceType = @idfsReferenceType
												AND		intRowStatus = 0 
											)
				IF @idfsBasereference IS NOT NULL 	
					BEGIN
						UPDATE	dbo.trtBaseReference
						SET		intHACode = ISNULL(intHACODE,0) + @HACode
						WHERE	idfsBaseReference =  @idfsBasereference

						-- Reset the record action flag to bypass insert/update in case of this special scenario
						SET @RecordAction = ''
					END
			END

		IF @RecordAction = 'U' 
			BEGIN
				UPDATE						dbo.trtBaseReference
				SET
											idfsReferenceType = @idfsReferenceType,
											strDefault = ISNULL(@DefaultName, strDefault),
											intHACode = ISNULL(@HACode, intHACode),
											intOrder = ISNULL(@Order, intOrder),
											blnSystem = ISNULL(@System, blnSystem),
											strMaintenanceFlag = ISNULL(@strMaintenanceFlag,strMaintenanceFlag)

				WHERE						idfsBaseReference = @idfsBasereference;
			END
		ELSE
			BEGIN
				EXEC						dbo.USP_GBL_NEXTKEYID_GET 'trtBaseReference', @idfsBasereference OUTPUT;

				INSERT INTO					dbo.trtBaseReference
				(
											idfsBaseReference, 
											idfsReferenceType, 
											intHACode, 
											strDefault,
											intOrder,
											blnSystem,
											strMaintenanceFlag

				)
  				VALUES
				(
											@idfsBasereference, 
											@idfsReferenceType, 
											@HACode, 
											@DefaultName, 
											@Order,
											@System,
											@strMaintenanceFlag
				);
				DECLARE @idfCustomizationPackage BIGINT;
				SELECT @idfCustomizationPackage = dbo.FN_GBL_CustomizationPackage_GET();
		
				IF @idfCustomizationPackage IS NOT NULL AND @idfCustomizationPackage <> 51577300000000 --The USA
				BEGIN
					EXEC					dbo.USP_GBL_BaseReferenceToCP_SET @idfsBasereference, @idfCustomizationPackage;
				END
			END
    
		-- Insert/update into trtstringNameTranslation for english
		BEGIN
				EXEC					dbo.USSP_GBL_StringTranslation_SET @idfsBasereference, 'en', @DefaultName, @DefaultName;
		END

		-- If National Name provided, insert/update into trtStringNameTranslatin
		IF @LangID iS NOT NULL and @NationalName IS NOT NULL
			BEGIN
				EXEC						dbo.USSP_GBL_StringTranslation_SET @idfsBasereference, @LangID, @DefaultName, @NationalName;
			END

		SELECT						@returnCode, @returnMsg;
	END TRY  
	BEGIN CATCH 
		THROW;

		SELECT						@returnCode, @returnMsg;
	END CATCH;
END

