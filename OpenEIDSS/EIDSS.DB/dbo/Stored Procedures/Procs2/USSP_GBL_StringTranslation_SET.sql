
----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Name 				: USSP_GBL_StringTranslation_SET
-- Description			: Insert/UPDATE Base Reference Data
--          
-- Author               : Mark Wilson
-- 
-- Revision History
-- Name				Date		Change Detail
-- Mark Wilson    10-Nov-2017   Convert EIDSS 6 to EIDSS 7 standards and 
--                              added table name to USP_GBL_NEWID_GET call
--Lamont Mitchell 01-02-19		Replaced Error Details in Catch and added Throw,  Aliased ReturnCode And ReturnMessage
-- Testing code:
/*
--Example of a call of procedure:
DECLARE @ReferenceID bigint
DECLARE @LangID nvarchar(50)
DECLARE @DefaultName varchar(200)
DECLARE @NationalName nvarchar(200)

EXECUTE USP_GBL_StringTranslation_SET
   @ReferenceID,
   @LangID,
   @DefaultName,
   @NationalName
*/

CREATE PROCEDURE [dbo].[USSP_GBL_StringTranslation_SET] 
	@ReferenceID bigint, --##PARAM @ReferenceID - ID of base reference record
	@LangID  nvarchar(50), --##PARAM @LangID - language of translation
	@DefaultName varchar(200), --##PARAM @DefaultName - translation in English
	@NationalName  nvarchar(200) --##PARAM @NationalName - translation in language defined by @LangID
AS
DECLARE @returnCode							INT = 0;
DECLARE	@returnMsg							NVARCHAR(MAX) = 'SUCCESS';

BEGIN
	BEGIN TRY
		IF EXISTS(
			SELECT	idfsBaseReference 
			FROM	trtStringNameTranslation 
			WHERE	idfsBaseReference = @ReferenceID and idfsLanguage = dbo.FN_GBL_LANGUAGECODE_GET(@LangID))
			BEGIN
				UPDATE	trtStringNameTranslation
				SET		strTextString = @NationalName
				WHERE 	idfsBaseReference = @ReferenceID 
				AND		idfsLanguage = dbo.FN_GBL_LANGUAGECODE_GET(@LangID)
				AND		ISNULL(@NationalName, N'') <> ISNULL(strTextString, N'') COLLATE SQL_Latin1_General_CP1_CS_AS
			END
		ELSE IF ISNULL(@NationalName,N'')<>N''
			BEGIN
				INSERT INTO trtStringNameTranslation(
					strTextString, 
					idfsLanguage, 
					idfsBaseReference
					)
				VALUES(
					@NationalName, 
					dbo.FN_GBL_LANGUAGECODE_GET(@LangID),
					@ReferenceID
					)
			END
		IF @LangID <> 'en' and ISNULL(@DefaultName, N'') <> N''
			IF EXISTS(
				SELECT	idfsBaseReference 
				FROM	trtStringNameTranslation 
				WHERE idfsBaseReference = @ReferenceID and idfsLanguage = 10049003) --en
				BEGIN
					UPDATE	trtStringNameTranslation
					SET		strTextString = @DefaultName
					WHERE 	idfsBaseReference = @ReferenceID 
					AND		idfsLanguage = 10049003 --en
					AND		ISNULL(@DefaultName, N'') <> ISNULL(strTextString, N'')	 COLLATE SQL_Latin1_General_CP1_CS_AS
				END
			ELSE
				BEGIN
					INSERT INTO trtStringNameTranslation(
						strTextString, 
						idfsLanguage, 
						idfsBaseReference
						)
					VALUES(
						@DefaultName, 
						10049003, --'en',
						@ReferenceID
						)
				END

			--SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
	END TRY  
	BEGIN CATCH 
		IF @@Trancount = 1 
			ROLLBACK;
THROW
	END CATCH;
END



