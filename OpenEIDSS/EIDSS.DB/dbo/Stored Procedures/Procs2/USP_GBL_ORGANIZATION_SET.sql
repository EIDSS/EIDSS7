
-- ================================================================================================
-- Name: usp_GBL_ORGANIZATION_SET
--
-- Description: Processes add and updates transactions for an organization record.  Used by the 
-- administration and laboratory and potentially other modules/use cases.
--          
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     11/16/2018 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_GBL_ORGANIZATION_SET] 
(
	@LanguageID										NVARCHAR(50),
	@OrganizationID									BIGINT OUTPUT,
	@EnglishName									NVARCHAR(200),
	@EnglishFullName								NVARCHAR(200),
	@Name											NVARCHAR(200),
	@FullName										NVARCHAR(200),
	@ContactPhone									NVARCHAR(200),
	@CurrentCustomizationID							BIGINT = NULL,
	@AccessoryCode									INT,
	@OrganizationCode								NVARCHAR(100),
	@OrderNumber									INT,
	@LocationID										BIGINT OUTPUT, 
	@CountryID										BIGINT,
	@RegionID										BIGINT,
	@RayonID										BIGINT,
	@SettlementID									BIGINT,
	@Apartment										NVARCHAR(200),
	@Building										NVARCHAR(200),
	@StreetName										NVARCHAR(200),
	@House											NVARCHAR(200),
	@PostalCode										NVARCHAR(200),
	@ForeignAddressIndicator						BIT = 0,
	@ForeignAddress									NVARCHAR(200),
    @Latitude										FLOAT = NULL,
    @Longitude										FLOAT = NULL, 
	@SharedLocationIndicator						BIT = 1
)
AS 
BEGIN
	SET XACT_ABORT, NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION
			IF ISNULL(@OrganizationCode, N'') <> N''
				BEGIN
					IF EXISTS(SELECT * FROM dbo.tlbOffice WHERE strOrganizationID = @OrganizationCode AND idfOffice <> @OrganizationID AND intRowStatus = 0)
						 RAISERROR('errNonUniqueOrganizationID', 16, 1);
				END

				DECLARE @OrganizationNameID			BIGINT,
					@OrganizationAbbreviationID		BIGINT,
					@NewRecordIndicator				BIT;

				SELECT								@OrganizationNameID = idfsOfficeName,
													@OrganizationAbbreviationID = idfsOfficeAbbreviation
				FROM 								dbo.tlbOffice 
				WHERE 								idfOffice = @OrganizationID;
				
				IF @@ROWCOUNT = 0
				BEGIN
					EXECUTE							dbo.USP_GBL_NEXTKEYID_GET 'trtBaseReference', @OrganizationNameID OUTPUT;
					EXECUTE 						dbo.USP_GBL_NEXTKEYID_GET 'trtBaseReference', @OrganizationAbbreviationID OUTPUT;
					SET								@NewRecordIndicator = 1;
				END

				IF @CurrentCustomizationID IS NULL
					BEGIN
						SET							@CurrentCustomizationID = dbo.FN_GBL_CustomizationPackage_GET();
					END

				IF UPPER(@LanguageID) = 'EN'
					BEGIN
						SET							@EnglishName = @Name;
						SET							@EnglishFullName = @FullName;
					END

				EXECUTE								dbo.USP_GBL_BaseReference_SET @OrganizationNameID, 19000046, @LanguageID, @EnglishFullName, @FullName, 0;
				EXECUTE								dbo.USP_GBL_BaseReference_SET @OrganizationAbbreviationID, 19000045, @LanguageID, @EnglishName, @name, 0, @OrderNumber;
				
				-- Set the Address 
				EXECUTE								dbo.USP_GBL_ADDRESS_SET
													@LocationID OUTPUT,
													NULL,
													NULL,
													NULL,
													@CountryID,
													@RegionID,
													@RayonID,
													@SettlementID,
													@Apartment,
													@Building,
													@StreetName,
													@House,
													@PostalCode,
													NULL,
													NULL,
													@Latitude,
													@Longitude,
													NULL,
													NULL,
													@ForeignAddressIndicator,
													@ForeignAddress,
													@SharedLocationIndicator;

				IF @NewRecordIndicator = 1
					BEGIN
						IF @OrganizationID IS NULL
							EXECUTE					dbo.USP_GBL_NEXTKEYID_GET 'tlbOffice', @OrganizationID OUTPUT;

							--IF @OrganizationCode IS NULL 
							--	EXECUTE				dbo.USP_GBL_NextNumber_GET 'EIDSS Organization', @OrganizationCode OUTPUT, NULL;

							INSERT					INTO dbo.tlbOffice
							(
													idfOffice,
													idfsOfficeName,
													idfsOfficeAbbreviation,
													idfCustomizationPackage,
													idfLocation,
													idfsSite,
													strContactPhone,
													intHACode,
													strOrganizationID
							)
							VALUES
							(
													@OrganizationID,
													@OrganizationNameID,
													@OrganizationAbbreviationID,
													@CurrentCustomizationID,
													@LocationID,
													dbo.FN_GBL_SITEID_GET(),
													@ContactPhone,
													@AccessoryCode,
													@OrganizationCode
							);

					END
				ELSE 
					BEGIN
						UPDATE			dbo.tlbOffice
						SET 	
										strContactPhone = @ContactPhone,
										idfLocation = @LocationID,
										intHACode = @AccessoryCode,
										strOrganizationID = @OrganizationCode
						WHERE			idfOffice = @OrganizationID;
					END

		IF @@TRANCOUNT > 0
			COMMIT;
	END TRY
	BEGIN CATCH
		IF @@Trancount > 0 
			ROLLBACK;
				
		THROW;
	END CATCH
END
