

-- ================================================================================================
-- Name: USP_HUM_HUMAN_MASTER_SET
--
-- Description: Insert or update a human master (actual) record.
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Stephen Long    11/28/2018 Initial release for new API.
-- Stephen Long    01/18/2019 Added entered date as a part of the insert human actual statement; 
--                            sets it to the system current date/time.  Syncs up with use case 
--                            HUC02.  Also added copy to human indicator for requirements in 
--                            laboratory module, use case 10.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_HUM_HUMAN_MASTER_SET] (
	@HumanMasterID BIGINT = NULL,
	@CopyToHumanIndicator BIT = 0, 
	@PersonalIDType BIGINT = NULL,
	@EIDSSPersonID NVARCHAR(200) = NULL,
	@PersonalID NVARCHAR(100) = NULL,
	@FirstName NVARCHAR(200) = NULL,
	@SecondName NVARCHAR(200) = NULL,
	@LastName NVARCHAR(200),
	@DateOfBirth DATETIME = NULL,
	@DateOfDeath DATETIME = NULL,
	@ReportedAge INT = NULL,
	@ReportAgeUOMID BIGINT = NULL,
	@HumanGenderTypeID BIGINT = NULL,
	@OccupationTypeID BIGINT = NULL,
	@CitizenshipTypeID BIGINT = NULL,
	@PassportNumber NVARCHAR(20) = NULL,
	@IsEmployedTypeID BIGINT = NULL,
	@EmployerName NVARCHAR(200) = NULL,
	@EmployedDateLastPresent DATETIME = NULL,
	@EmployerForeignAddressIndicator BIT = 0,
	@EmployerForeignAddressString NVARCHAR(200) = NULL,
	@EmployerGeoLocationID BIGINT = NULL,
	@EmployeridfsCountry BIGINT = NULL,
	@EmployeridfsRegion BIGINT = NULL,
	@EmployeridfsRayon BIGINT = NULL,
	@EmployeridfsSettlement BIGINT = NULL,
	@EmployerstrStreetName NVARCHAR(200) = NULL,
	@EmployerstrApartment NVARCHAR(200) = NULL,
	@EmployerstrBuilding NVARCHAR(200) = NULL,
	@EmployerstrHouse NVARCHAR(200) = NULL,
	@EmployeridfsPostalCode NVARCHAR(200) = NULL,
	@EmployerPhone NVARCHAR(100) = NULL,
	@IsStudentTypeID BIGINT = NULL,
	@SchoolName NVARCHAR(200) = NULL,
	@SchoolDateLastAttended DATETIME = NULL,
	@SchoolForeignAddressIndicator BIT = 0,
	@SchoolForeignAddressString NVARCHAR(200) = NULL,
	@SchoolGeoLocationID BIGINT = NULL,
	@SchoolidfsCountry BIGINT = NULL,
	@SchoolidfsRegion BIGINT = NULL,
	@SchoolidfsRayon BIGINT = NULL,
	@SchoolidfsSettlement BIGINT = NULL,
	@SchoolstrStreetName NVARCHAR(200) = NULL,
	@SchoolstrApartment NVARCHAR(200) = NULL,
	@SchoolstrBuilding NVARCHAR(200) = NULL,
	@SchoolstrHouse NVARCHAR(200) = NULL,
	@SchoolidfsPostalCode NVARCHAR(200) = NULL,
	@SchoolPhone NVARCHAR(100) = NULL,
	@HumanGeoLocationID BIGINT = NULL,
	@HumanidfsCountry BIGINT,
	@HumanidfsRegion BIGINT,
	@HumanidfsRayon BIGINT,
	@HumanidfsSettlement BIGINT = NULL,
	@HumanstrStreetName NVARCHAR(200) = NULL,
	@HumanstrApartment NVARCHAR(200) = NULL,
	@HumanstrBuilding NVARCHAR(200) = NULL,
	@HumanstrHouse NVARCHAR(200) = NULL,
	@HumanidfsPostalCode NVARCHAR(200) = NULL,
	@HumanstrLatitude FLOAT = NULL,
	@HumanstrLongitude FLOAT = NULL,
	@HumanstrElevation FLOAT = NULL,
	@HumanAltGeoLocationID BIGINT = NULL,
	@HumanAltForeignAddressIndicator BIT = 0,
	@HumanAltForeignAddressString NVARCHAR(200) = NULL,
	@HumanAltidfsCountry BIGINT = NULL,
	@HumanAltidfsRegion BIGINT = NULL,
	@HumanAltidfsRayon BIGINT = NULL,
	@HumanAltidfsSettlement BIGINT = NULL,
	@HumanAltstrStreetName NVARCHAR(200) = NULL,
	@HumanAltstrApartment NVARCHAR(200) = NULL,
	@HumanAltstrBuilding NVARCHAR(200) = NULL,
	@HumanAltstrHouse NVARCHAR(200) = NULL,
	@HumanAltidfsPostalCode NVARCHAR(200) = NULL,
	@HumanAltstrLatitude FLOAT = NULL,
	@HumanAltstrLongitude FLOAT = NULL,
	@HumanAltstrElevation FLOAT = NULL,
	@RegistrationPhone NVARCHAR(200) = NULL,
	@HomePhone NVARCHAR(200) = NULL,
	@WorkPhone NVARCHAR(200) = NULL,
	@ContactPhoneCountryCode INT = NULL,
	@ContactPhone NVARCHAR(200) = NULL,
	@ContactPhoneTypeID BIGINT = NULL,
	@ContactPhone2CountryCode INT = NULL,
	@ContactPhone2 NVARCHAR(200) = NULL,
	@ContactPhone2TypeID BIGINT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ReturnCode INT = 0,
		@ReturnMessage NVARCHAR(MAX) = 'SUCCESS', 
		@HumanID BIGINT = NULL;
	DECLARE @SupressSelect TABLE (
		ReturnCode INT,
		ReturnMessage NVARCHAR(MAX)
		);

	BEGIN TRY
		BEGIN TRANSACTION;

		-- Set Employer Address 
		IF (
				@EmployeridfsCountry IS NOT NULL
				AND @EmployeridfsRayon IS NOT NULL
				AND @EmployeridfsRegion IS NOT NULL
				)
			OR @EmployerForeignAddressIndicator = 1
			EXECUTE dbo.USP_GBL_ADDRESS_SET @EmployerGeoLocationID OUTPUT,
				NULL,
				NULL,
				NULL,
				@EmployeridfsCountry,
				@EmployeridfsRegion,
				@EmployeridfsRayon,
				@EmployeridfsSettlement,
				@EmployerstrApartment,
				@EmployerstrBuilding,
				@EmployerstrStreetName,
				@EmployerstrHouse,
				@EmployeridfsPostalCode,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				@EmployerForeignAddressIndicator,
				@EmployerForeignAddressString,
				1,
				@ReturnCode OUTPUT,
				@ReturnMessage OUTPUT;

		-- Set School Address 
		IF (
				@SchoolidfsCountry IS NOT NULL
				AND @SchoolidfsRayon IS NOT NULL
				AND @SchoolidfsRegion IS NOT NULL
				)
			OR @SchoolForeignAddressIndicator = 1
			EXECUTE dbo.USP_GBL_ADDRESS_SET @SchoolGeoLocationID OUTPUT,
				NULL,
				NULL,
				NULL,
				@SchoolidfsCountry,
				@SchoolidfsRegion,
				@SchoolidfsRayon,
				@SchoolidfsSettlement,
				@SchoolstrApartment,
				@SchoolstrBuilding,
				@SchoolstrStreetName,
				@SchoolstrHouse,
				@SchoolidfsPostalCode,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				@SchoolForeignAddressIndicator,
				@SchoolForeignAddressString,
				1,
				@ReturnCode OUTPUT,
				@ReturnMessage OUTPUT;

		-- Set Current Home Address 
		IF @HumanidfsCountry IS NOT NULL
			AND @HumanidfsRayon IS NOT NULL
			AND @HumanidfsRegion IS NOT NULL
			EXECUTE dbo.USP_GBL_ADDRESS_SET @HumanGeoLocationID OUTPUT,
				NULL,
				NULL,
				NULL,
				@HumanidfsCountry,
				@HumanidfsRegion,
				@HumanidfsRayon,
				@HumanidfsSettlement,
				@HumanstrApartment,
				@HumanstrBuilding,
				@HumanstrStreetName,
				@HumanstrHouse,
				@HumanidfsPostalCode,
				NULL,
				NULL,
				@HumanstrLatitude,
				@HumanstrLongitude,
				NULL,
				NULL,
				0,
				NULL,
				1,
				@ReturnCode OUTPUT,
				@ReturnMessage OUTPUT;

		-- Set Alternate Address
		IF (
				@HumanAltidfsCountry IS NOT NULL
				AND @HumanAltidfsRayon IS NOT NULL
				AND @HumanAltidfsRegion IS NOT NULL
				)
			OR @HumanAltForeignAddressIndicator = 1
			EXECUTE dbo.USP_GBL_ADDRESS_SET @HumanAltGeoLocationID OUTPUT,
				NULL,
				NULL,
				NULL,
				@HumanAltidfsCountry,
				@HumanAltidfsRegion,
				@HumanAltidfsRayon,
				@HumanAltidfsSettlement,
				@HumanAltstrApartment,
				@HumanAltstrBuilding,
				@HumanAltstrStreetName,
				@HumanAltstrHouse,
				@HumanAltidfsPostalCode,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				@HumanAltForeignAddressIndicator,
				@HumanAltForeignAddressString,
				1,
				@ReturnCode OUTPUT,
				@ReturnMessage OUTPUT;

		IF NOT EXISTS (
				SELECT *
				FROM dbo.tlbHumanActual
				WHERE idfHumanActual = @HumanMasterID
					AND intRowStatus = 0
				)
		BEGIN
			INSERT INTO @SupressSelect
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET @tableName = N'tlbHumanActual',
				@idfsKey = @HumanMasterID OUTPUT;

			INSERT INTO dbo.tlbHumanActual (
				idfHumanActual,
				idfsNationality,
				idfsHumanGender,
				idfCurrentResidenceAddress,
				idfsOccupationType,
				idfEmployerAddress,
				idfRegistrationAddress,
				datDateofBirth,
				datDateOfDeath,
				strFirstName,
				strSecondName,
				strLastName,
				strRegistrationPhone,
				strEmployerName,
				strHomePhone,
				strWorkPhone,
				idfsPersonIDType,
				strPersonID,
				datEnteredDate,
				intRowStatus
				)
			VALUES (
				@HumanMasterID,
				@CitizenshipTypeID,
				@HumanGenderTypeID,
				@HumanGeoLocationID,
				@OccupationTypeID,
				@EmployerGeoLocationID,
				@HumanAltGeoLocationID,
				@DateOfBirth,
				@DateOfDeath,
				@FirstName,
				@SecondName,
				@LastName,
				@RegistrationPhone,
				@EmployerName,
				@HomePhone,
				@WorkPhone,
				@PersonalIDType,
				@PersonalID,
				GETDATE(),
				0
				);

			INSERT INTO @SupressSelect
			EXECUTE dbo.USP_GBL_NextNumber_GET @ObjectName = N'EIDSS Person',
				@NextNumberValue = @EIDSSPersonID OUTPUT,
				@InstallationSite = NULL;

			INSERT INTO dbo.HumanActualAddlInfo (
				HumanActualAddlInfoUID,
				EIDSSPersonID,
				ReportedAge,
				ReportedAgeUOMID,
				PassportNbr,
				IsEmployedID,
				EmployerPhoneNbr,
				EmployedDTM,
				IsStudentID,
				SchoolName,
				SchoolPhoneNbr,
				SchoolAddressID,
				SchoolLastAttendDTM,
				ContactPhoneCountryCode,
				ContactPhoneNbr,
				ContactPhoneNbrTypeID,
				ContactPhone2CountryCode,
				ContactPhone2Nbr,
				ContactPhone2NbrTypeID,
				intRowStatus
				)
			VALUES (
				@HumanMasterID,
				@EIDSSPersonID,
				@ReportedAge,
				@ReportAgeUOMID,
				@PassportNumber,
				@IsEmployedTypeID,
				@EmployerPhone,
				@EmployedDateLastPresent,
				@IsStudentTypeID,
				@SchoolName,
				@SchoolPhone,
				@SchoolGeoLocationID,
				@SchoolDateLastAttended,
				@ContactPhoneCountryCode,
				@ContactPhone,
				@ContactPhoneTypeID,
				@ContactPhone2CountryCode,
				@ContactPhone2,
				@ContactPhone2TypeID,
				0
				);

			-- Create a human record from human actual for the laboratory module; register new sample.
			IF @CopyToHumanIndicator = 1
				BEGIN
					EXECUTE dbo.USP_HUM_COPYHUMANACTUALTOHUMAN @HumanMasterID, @HumanID OUTPUT, @ReturnCode OUTPUT, @ReturnMessage OUTPUT;
					IF @ReturnCode <> 0 
						BEGIN
							RETURN;
						END;
				END;
		END;
		ELSE
		BEGIN
			UPDATE dbo.tlbHumanActual
			SET idfsNationality = @CitizenshipTypeID,
				idfsHumanGender = @HumanGenderTypeID,
				idfCurrentResidenceAddress = @HumanGeoLocationID,
				idfsOccupationType = @OccupationTypeID,
				idfEmployerAddress = @EmployerGeoLocationID,
				idfRegistrationAddress = @HumanAltGeoLocationID,
				datDateofBirth = @DateOfBirth,
				datDateOfDeath = @DateOfDeath,
				strFirstName = @FirstName,
				strSecondName = @SecondName,
				strLastName = @LastName,
				strRegistrationPhone = @RegistrationPhone,
				strEmployerName = @EmployerName,
				strHomePhone = @HomePhone,
				strWorkPhone = @WorkPhone,
				idfsPersonIDType = @PersonalIDType,
				strPersonID = @PersonalID,
				datModificationDate = GETDATE()
			WHERE idfHumanActual = @HumanMasterID;

			UPDATE dbo.HumanActualAddlInfo
			SET ReportedAge = @ReportedAge,
				ReportedAgeUOMID = @ReportAgeUOMID,
				PassportNbr = @PassportNumber,
				IsEmployedID = @IsEmployedTypeID,
				EmployerPhoneNbr = @EmployerPhone,
				EmployedDTM = @EmployedDateLastPresent,
				IsStudentID = @IsStudentTypeID,
				SchoolName = @SchoolName,
				SchoolPhoneNbr = @SchoolPhone,
				SchoolAddressID = @SchoolGeoLocationID,
				SchoolLastAttendDTM = @SchoolDateLastAttended,
				ContactPhoneCountryCode = @ContactPhoneCountryCode,
				ContactPhoneNbr = @ContactPhone,
				ContactPhoneNbrTypeID = @ContactPhoneTypeID,
				ContactPhone2CountryCode = @ContactPhone2CountryCode,
				ContactPhone2Nbr = @ContactPhone2,
				ContactPhone2NbrTypeID = @ContactPhone2TypeID
			WHERE HumanActualAddlInfoUID = @HumanMasterID;
		END;

		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage,
			@HumanMasterID HumanMasterID,
			@EIDSSPersonID EIDSSPersonID, 
			@HumanID HumanID;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();
		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage,
			@HumanMasterID HumanMasterID,
			@EIDSSPersonID EIDSSPersonID, 
			@HumanID HumanID;

		THROW;
	END CATCH;
END;