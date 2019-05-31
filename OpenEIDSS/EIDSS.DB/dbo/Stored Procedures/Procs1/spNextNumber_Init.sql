﻿



CREATE   PROCEDURE dbo.spNextNumber_Init( 
		@idfsNumberName BIGINT,
		@strDocumentName NVARCHAR(200),
		@strPrefix NVARCHAR(50), 
		@strSuffix NVARCHAR(50), 
		@intNumberValue INT,
		@intMinNumberLength INT,
		@blnUseHACSCodeSite tinyint = null
)

AS

IF NOT EXISTS (SELECT idfsNumberName FROM tstNextNumbers WHERE idfsNumberName = @idfsNumberName)
BEGIN

	IF ISNULL(@strDocumentName,N'') = N''
	BEGIN	
		SELECT @strDocumentName = [name] from fnReference('en',19000057) --NextNumbers 
		WHERE idfsReference = @idfsNumberName
	END

	if not exists(select * from dbo.trtBaseReference where idfsBaseReference = @idfsNumberName)
		EXECUTE spBaseReference_SysPost
		   @idfsNumberName
		  ,19000057 --NextNumbers 
		  ,'en'
		  ,@strDocumentName
		  ,@strDocumentName
		  ,null
		  ,null	
 
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
	VALUES
		(
		@idfsNumberName, 
		@strDocumentName,
		@strPrefix, 
		@strSuffix, 
		@intNumberValue,
		@intMinNumberLength,
		1, --blnUsePrefix,
		1, --blnUseSiteID,
		1, --blnUseYear,
		isnull(@blnUseHACSCodeSite,0),
		1, --blnUseAlphaNumericValue,
		Year(getdate())
		)

END

	if not exists(select * from dbo.trtBaseReference where idfsBaseReference = @idfsNumberName)
		EXECUTE spBaseReference_SysPost
		   @idfsNumberName
		  ,19000057 --NextNumbers 
		  ,'en'
		  ,@strDocumentName
		  ,@strDocumentName
		  ,null
		  ,null	


RETURN 0











