--*************************************************************
-- Name 				: USP_ADMIN_ORG_SET
-- Description			: SET Postal Code
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************

CREATE PROCEDURE [dbo].[USP_ADMIN_ORG_SET] 
(
	@idfOffice							BIGINT = NULL,
	@EnglishName						NVARCHAR(200),
	@name								NVARCHAR(200),
	@EnglishFullName					NVARCHAR(200),
	@FullName							NVARCHAR(200),
	@strContactPhone					NVARCHAR(200),
	@idfsCurrentCustomization			BIGINT = NULL,
	@intHACode							INT,
	@strOrganizationID					NVARCHAR(100),
	@LangID								NVARCHAR(50),
	@intOrder							INT,
	@idfGeoLocation						BIGINT = null,  -- #Params for Address SP
	@LocationUserControlidfsCountry		BIGINT,
	@LocationUserControlidfsRegion		BIGINT,
	@LocationUserControlidfsRayon		BIGINT,
	@LocationUserControlidfsSettlement	BIGINT,
	@LocationUserControlstrApartment	NVARCHAR(200),
	@LocationUserControlstrBuilding		NVARCHAR(200),
	@LocationUserControlstrStreetName	NVARCHAR(200),
	@LocationUserControlstrHouse		NVARCHAR(200),
	@strPostCode						NVARCHAR(200),
	@blnForeignAddress					BIT = 0,
	@strForeignAddress					NVARCHAR(200),
    @LocationUserControldblLatitude		FLOAT = NULL,--##PARAM dblLatitude - Latitude 
    @LocationUserControldblLongitude	FLOAT = NULL,--##PARAM dblLongitude  - Longitude 
	@blnGeoLocationShared				BIT = 1
)
AS
DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
Declare @SupressSelect table
( 
	retrunCode int,
	returnMessage varchar(200)
)
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			IF ISNULL(@strOrganizationID, N'') <> N''
				BEGIN
					IF EXISTS (SELECT * FROM tlbOffice WHERE strOrganizationID = @strOrganizationID AND idfOffice<>@idfOffice AND intRowStatus = 0)
						 RAISERROR ('errNonUniqueOrganizationID', 16, 1)
				END

				DECLARE @idfsOfficeName BIGINT
				DECLARE @idfsOfficeAbbreviation BIGINT
				DECLARE @NewRecord BIT

				SELECT	@idfsOfficeName = idfsOfficeName,
						@idfsOfficeAbbreviation = idfsOfficeAbbreviation
				FROM 	dbo.tlbOffice 
				WHERE 	idfOffice=@idfOffice
				
				IF @@ROWCOUNT=0
				BEGIN
					INSERT INTO @SupressSelect
					EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'trtBaseReference', @idfsOfficeName OUTPUT
					INSERT INTO @SupressSelect
					EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'trtBaseReference', @idfsOfficeAbbreviation OUTPUT
					SET @NewRecord = 1
				END

				IF @idfsCurrentCustomization IS NULL
					BEGIN
						SET @idfsCurrentCustomization = dbo.FN_GBL_CustomizationPackage_GET()
					END

				IF @LangID = 'en'
					BEGIN
						SET @EnglishName = @name
						SET @EnglishFullName = @FullName 
					END

				EXECUTE dbo.USP_GBL_BaseReference_SET @idfsOfficeName, 19000046, @LangID, @EnglishFullName, @FullName, 0 --'rftInstitutionName'
				EXECUTE dbo.USP_GBL_BaseReference_SET @idfsOfficeAbbreviation, 19000045, @LangID, @EnglishName, @name, 0, @intOrder --'rftInstitutionAbbr'
				
				-- Set the Address 
				EXECUTE dbo.USP_GBL_ADDRESS_SET
											@idfGeoLocation OUTPUT,
											NULL,
											NULL,
											NULL,
											@LocationUserControlidfsCountry,
											@LocationUserControlidfsRegion,
											@LocationUserControlidfsRayon,
											@LocationUserControlidfsSettlement,
											@LocationUserControlstrApartment,
											@LocationUserControlstrBuilding,
											@LocationUserControlstrStreetName,
											@LocationUserControlstrHouse,
											@strPostCode,
											NULL,
											NULL,
											@LocationUserControldblLatitude,
											@LocationUserControldblLongitude,
											NULL,
											NULL,
											@blnForeignAddress,
											@strForeignAddress,
											@blnGeoLocationShared,
											@returnCode OUTPUT,
											@returnMsg OUTPUT

				IF @NewRecord=1 AND @returnCode = 0
					BEGIN
						IF @idfOffice IS NULL
							EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbOffice', @idfOffice OUTPUT
	
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
									   ,@idfGeoLocation
									   ,dbo.FN_GBL_SITEID_GET()
									   ,@strContactPhone
									   ,@intHACode
									   ,@strOrganizationID
									   )

					END
				ELSE IF @returnCode = 0
					BEGIN
						UPDATE tlbOffice
						SET 	
							strContactPhone=@strContactPhone,
							idfLocation = @idfGeoLocation,
							intHACode = @intHACode,
							strOrganizationID = @strOrganizationID
						WHERE 
							idfOffice=@idfOffice
					END
		IF @@TRANCOUNT > 0 AND @returnCode =0
			COMMIT

		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage',@idfOffice 'idfOffice',@idfGeoLocation 'idfGeoLocation'
	END TRY

	BEGIN CATCH
			IF @@Trancount = 1 
				ROLLBACK;
			THROW;

	END CATCH

END











