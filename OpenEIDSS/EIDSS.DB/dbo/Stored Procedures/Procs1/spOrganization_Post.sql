




create        PROCEDURE dbo.spOrganization_Post 
	@idfOffice AS BIGINT,
	@EnglishName AS NVARCHAR(200),
	@name AS NVARCHAR(200),
	@EnglishFullName AS NVARCHAR(200),
	@FullName AS NVARCHAR(200),
	@idfLocation AS BIGINT,
	@strContactPhone AS NVARCHAR(200),
	@idfsCurrentCustomization  AS BIGINT = NULL,
	@intHACode AS INT,
	@strOrganizationID AS NVARCHAR(100),
	@LangID As nvarchar(50),
	@intOrder AS INT
AS
IF ISNULL(@strOrganizationID, N'') <> N''
BEGIN
	IF EXISTS (SELECT * FROM tlbOffice WHERE strOrganizationID = @strOrganizationID AND idfOffice<>@idfOffice AND intRowStatus = 0)
		 RAISERROR ('errNonUniqueOrganizationID', 16, 1)
END
DECLARE @idfsOfficeName bigint
DECLARE @idfsOfficeAbbreviation bigint
DECLARE @NewRecord BIT
SELECT 
	@idfsOfficeName = idfsOfficeName,
	@idfsOfficeAbbreviation = idfsOfficeAbbreviation
FROM 
	tlbOffice 
WHERE 
	idfOffice=@idfOffice
IF @@ROWCOUNT=0
BEGIN
	exec spsysGetNewID @idfsOfficeName OUTPUT
	exec spsysGetNewID @idfsOfficeAbbreviation OUTPUT
	SET @NewRecord = 1
END

IF @idfsCurrentCustomization IS NULL
BEGIN
	SET @idfsCurrentCustomization = dbo.fnCustomizationPackage()
END

IF @LangID = 'en'
BEGIN
	SET @EnglishName = @name
	SET @EnglishFullName = @FullName 
END
EXEC spBaseReference_SysPost @idfsOfficeName, 19000046, @LangID, @EnglishFullName, @FullName, 0 --'rftInstitutionName'
EXEC spBaseReference_SysPost @idfsOfficeAbbreviation, 19000045, @LangID, @EnglishName, @name, 0, @intOrder --'rftInstitutionAbbr'

IF @NewRecord=1
BEGIN
	IF @idfOffice IS NULL
			exec spsysGetNewID @idfOffice OUTPUT

	
INSERT INTO tlbOffice
           (
			idfOffice
           ,idfsOfficeName
           ,idfsOfficeAbbreviation
           ,idfCustomizationPackage
           ,idfLocation
           ,idfsSite
           ,strContactPhone
		   ,intHACode
		   ,strOrganizationID
			)
     VALUES
           (
			@idfOffice
           ,@idfsOfficeName
           ,@idfsOfficeAbbreviation
           ,@idfsCurrentCustomization
           ,@idfLocation
           ,dbo.fnSiteID()
           ,@strContactPhone
		   ,@intHACode
		   ,@strOrganizationID
           )

END
ELSE
BEGIN
	UPDATE tlbOffice
	SET 	
		strContactPhone=@strContactPhone,
		idfLocation = @idfLocation,
		intHACode = @intHACode,
		strOrganizationID = @strOrganizationID
	WHERE 
		idfOffice=@idfOffice
END












