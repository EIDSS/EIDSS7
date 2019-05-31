



--##SUMMARY Allows to create new reference or change the parameters of the existing one
--##SUMMARY If NULL is passed as @DefaultName, @NationalName,  @HACode or @Order parameter, the corresponded field value in 
--##SUMMARY trtBaseReference table is not changed.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 5.12.2009

--##RETURNS Doesn't use

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


EXECUTE spBaseReference_SysPost
   @ReferenceID
  ,@ReferenceType
  ,@LangID
  ,@DefaultName
  ,@NationalName
  ,@HACode
  ,@Order
  ,@System

*/

CREATE PROCEDURE [dbo].[spBaseReference_SysPost] 
	@ReferenceID BIGINT, --##PARAM @ReferenceID - reference ID
	@ReferenceType BIGINT, --##PARAM @ReferenceType - reference Type ID
	@LangID  nvarchar(50), --##PARAM @LangID - language ID
	@DefaultName VARCHAR(200), --##PARAM @DefaultName - default reference name, used if there is no refernece translation
	@NationalName  NVARCHAR(200), --##PARAM @NationalName - reference name in the language defined by @LangID
	@HACode INT = NULL, --##PARAM @HACode - bit mask for reference using
	@Order INT = NULL, --##PARAM @Order - reference record order for sorting
	@System BIT = 0 --##PARAM @System
AS
Begin
IF EXISTS (SELECT idfsBaseReference FROM trtBaseReference WHERE idfsBaseReference = @ReferenceID )
BEGIN
	UPDATE trtBaseReference
	SET
		idfsReferenceType = @ReferenceType, 
		strDefault = ISNULL(@DefaultName,strDefault),
		intHACode = ISNULL(@HACode,intHACode),
		intOrder = ISNULL(@Order,intOrder),
		blnSystem = ISNULL(@System,blnSystem)
	WHERE 
		idfsBaseReference = @ReferenceID
 		--AND ISNULL(strDefault,N'')<>ISNULL(@DefaultName,N'')	
END
ELSE
BEGIN
	INSERT INTO trtBaseReference(
		idfsBaseReference, 
		idfsReferenceType, 
		intHACode, 
		strDefault,
		intOrder,
		blnSystem
		)
	VALUES(
		@ReferenceID, --idfsBaseReference
		@ReferenceType, --idfsReferenceType
		@HACode, --intHACode
		@DefaultName, --strDefault
		@Order,
		@System
	)
	Declare @idfCustomizationPackage bigint
	SELECT @idfCustomizationPackage = dbo.fnCustomizationPackage()
	IF @idfCustomizationPackage IS NOT NULL AND @idfCustomizationPackage <> 51577300000000 --The USA
	BEGIN
		EXEC spsysBaseReferenceToCP_Post @ReferenceID, @idfCustomizationPackage
	END

	
END
IF (@LangID=N'en')
BEGIN
	IF EXISTS(SELECT idfsBaseReference FROM trtStringNameTranslation WHERE idfsBaseReference=@ReferenceID AND idfsLanguage=dbo.fnGetLanguageCode(N'en'))
		EXEC spStringTranslation_Post @ReferenceID, @LangID, @DefaultName, @DefaultName
END
ELSE
BEGIN
	EXEC spStringTranslation_Post @ReferenceID, @LangID, @DefaultName, @NationalName
END

End






