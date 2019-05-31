
-- ================================================================================================
-- Name: USP_HUM_HUMAN_SET
--
-- Description: Insert or update a human record.
--          
-- Revision History
-- Name            Date       Change Detail
-- --------------- ---------- --------------------------------------------------------------------
-- Mandar Kulkarni            Initial release.
-- Stephen Long    08/23/2018 Added output to strEIDSSPersonID
-- Stephen Long	   09/28/2018 Added employer, human alt, school 
--                            foreign address string, human alt 
--                            foreign address boolean.
-- Stephen Long    12/17/2018 Add update to human records for open disease reports.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_HUM_HUMAN_SET]
(
	@HumanMasterID						BIGINT OUTPUT,
	@PersonalIDType						BIGINT = NULL,
	@EIDSSPersonID						NVARCHAR(200) = '(new)' OUTPUT,
	@PersonalID							NVARCHAR(100) = NULL,
	@FirstOrGivenName					NVARCHAR(200) = NULL,
	@SecondName							NVARCHAR(200) = NULL,
	@LastOrSurname						NVARCHAR(200),
	@DateOfBirth						DATETIME = NULL,
	@DateOfDeath						DATETIME = NULL, 
	@ReportedAge						INT = NULL,
	@ReportAgeUOMID						BIGINT = NULL,
	@GenderTypeID						BIGINT = NULL,
	@OccupationTypeID					BIGINT = NULL, 
	@CitizenshipID						BIGINT = NULL,
	@PassportNumber						NVARCHAR(20) = NULL,
	@IsEmployedTypeID					BIGINT = NULL,
	@EmployerName						NVARCHAR(200) = NULL,
	@EmployedDateLastPresent			DATETIME = NULL,
	@EmployerForeignAddressIndicator	BIT = NULL,
	@EmployerForeignAddressString		NVARCHAR(200) = NULL, 
	@EmployerGeoLocationID				BIGINT = NULL,
	@EmployerCountryID					BIGINT = NULL,
	@EmployerRegionID					BIGINT = NULL,
	@EmployerRayonID					BIGINT = NULL,
	@EmployerSettlementID				BIGINT = NULL,
	@EmployerStreetName					NVARCHAR(200) = NULL,
	@EmployerApartment					NVARCHAR(200) = NULL,
	@EmployerBuilding					NVARCHAR(200) = NULL,
	@EmployerHouse						NVARCHAR(200) = NULL,
	@EmployerPostalCode					NVARCHAR(200) = NULL,
	@EmployerPhone						NVARCHAR(100) = NULL,
	@IsStudentTypeID					BIGINT = NULL,
	@SchoolName							NVARCHAR(200) = NULL,
	@SchoolDateLastAttended				DATETIME = NULL,
	@SchoolForeignAddressIndicator		BIT = NULL,
	@SchoolForeignAddressString			NVARCHAR(200) = NULL, 
	@SchoolGeoLocationID				BIGINT = NULL,
	@SchoolCountryID					BIGINT = NULL,
	@SchoolRegionID						BIGINT = NULL,
	@SchoolRayonID						BIGINT = NULL,
	@SchoolSettlementID					BIGINT = NULL,
	@SchoolStreetName					NVARCHAR(200) = NULL,
	@SchoolApartment					NVARCHAR(200) = NULL,
	@SchoolBuilding						NVARCHAR(200) = NULL,
	@SchoolHouse						NVARCHAR(200) = NULL,
	@SchoolPostalCode					NVARCHAR(200) = NULL,
	@SchoolPhone						NVARCHAR(100) = NULL,
	@HumanGeoLocationID					BIGINT,
	@HumanCountryID						BIGINT,
	@HumanRegionID						BIGINT,
	@HumanRayonID						BIGINT,
	@HumanSettlementID					BIGINT = NULL,
	@HumanStreetName					NVARCHAR(200) = NULL,
	@HumanApartment						NVARCHAR(200) = NULL,
	@HumanBuilding						NVARCHAR(200) = NULL,
	@HumanHouse							NVARCHAR(200) = NULL,
	@HumanPostalCode					NVARCHAR(200) = NULL,
	@HumanLatitude						FLOAT = NULL,
	@HumanLongitude						FLOAT = NULL,
	@HumanElevation						FLOAT = NULL,
	@HumanAltGeoLocationID				BIGINT = NULL,
	@HumanAltForeignAddressIndicator	BIT = NULL,
	@HumanAltForeignAddressString		NVARCHAR(200) = NULL, 
	@HumanAltCountryID					BIGINT = NULL,
	@HumanAltRegionID					BIGINT = NULL,
	@HumanAltRayonID					BIGINT = NULL,
	@HumanAltSettlementID				BIGINT = NULL,
	@HumanAltStreetName					NVARCHAR(200) = NULL,
	@HumanAltApartment					NVARCHAR(200) = NULL,
	@HumanAltBuilding					NVARCHAR(200) = NULL,
	@HumanAltHouse						NVARCHAR(200) = NULL,
	@HumanAltPostalCode					NVARCHAR(200),
	@HumanAltLatitude					FLOAT = NULL,
	@HumanAltLongitude					FLOAT = NULL,
	@HumanAltElevation					FLOAT = NULL,
	@RegistrationPhone					NVARCHAR(200),
	@HomePhone							NVARCHAR(200),
	@WorkPhone							NVARCHAR(200),
	@ContactPhoneCountryCode			INT,
	@ContactPhone						NVARCHAR(200),
	@ContactPhoneTypeID					BIGINT,
	@ContactPhone2CountryCode			INT,
	@ContactPhone2						NVARCHAR(200),
	@ContactPhone2TypeID				BIGINT
 )
AS
BEGIN
	DECLARE @ReturnCode					AS INT, 
		@ReturnMessage					AS NVARCHAR(MAX);
	BEGIN TRY
		BEGIN TRANSACTION
				
		-- Set Employer Address 
		IF (@EmployerCountryID IS NOT NULL AND @EmployerRayonID IS NOT NULL AND @EmployerRegionID IS NOT NULL) OR @EmployerForeignAddressIndicator = 1
			EXECUTE						dbo.USP_GBL_ADDRESS_SET
										@EmployerGeoLocationID OUTPUT,
										NULL,
										NULL,
										NULL,
										@EmployerCountryID,
										@EmployerRegionID,
										@EmployerRayonID,
										@EmployerSettlementID,
										@EmployerApartment,
										@EmployerBuilding,
										@EmployerStreetName,
										@EmployerHouse,
										@EmployerPostalCode,
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
		IF (@SchoolCountryID IS NOT NULL AND @SchoolRayonID IS NOT NULL AND @SchoolRegionID IS NOT NULL) OR @SchoolForeignAddressIndicator = 1
			EXECUTE						dbo.USP_GBL_ADDRESS_SET
										@SchoolGeoLocationID OUTPUT,
										NULL,
										NULL,
										NULL,
										@SchoolCountryID,
										@SchoolRegionID,
										@SchoolRayonID,
										@SchoolSettlementID,
										@SchoolApartment,
										@SchoolBuilding,
										@SchoolStreetName,
										@SchoolHouse,
										@SchoolPostalCode,
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

		-- Set Current Address 
		IF @HumanCountryID IS NOT NULL AND @HumanRayonID IS NOT NULL AND @HumanRegionID IS NOT NULL
			EXECUTE						dbo.USP_GBL_ADDRESS_SET
										@HumanGeoLocationID OUTPUT,
										NULL,
										NULL,
										NULL,
										@HumanCountryID,
										@HumanRegionID,
										@HumanRayonID,
										@HumanSettlementID,
										@HumanApartment,
										@HumanBuilding,
										@HumanStreetName,
										@HumanHouse,
										@HumanPostalCode,
										NULL,
										NULL, 
										@HumanLatitude,
										@HumanLongitude,
										NULL,
										NULL,
										0,
										NULL,
										1,
										@ReturnCode OUTPUT,
										@ReturnMessage OUTPUT;

		-- Set Alternate Address
		IF (@HumanAltCountryID IS NOT NULL AND @HumanAltRayonID IS NOT NULL AND @HumanAltRegionID IS NOT NULL) OR @HumanAltForeignAddressIndicator = 1
			EXECUTE						dbo.USP_GBL_ADDRESS_SET
										@HumanAltGeoLocationID OUTPUT,
										NULL,
										NULL,
										NULL,
										@HumanAltCountryID,
										@HumanAltRegionID,
										@HumanAltRayonID,
										@HumanAltSettlementID,
										@HumanAltApartment,
										@HumanAltBuilding,
										@HumanAltStreetName,
										@HumanAltHouse,
										@HumanAltPostalCode,
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

		IF NOT EXISTS (SELECT * FROM dbo.tlbHumanActual WHERE idfHumanActual = @HumanMasterID AND intRowStatus = 0)
			BEGIN
				EXECUTE					dbo.USP_GBL_NEXTKEYID_GET 'tlbHumanActual', @HumanMasterID OUTPUT;

				INSERT INTO				dbo.tlbHumanActual
				(
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
										intRowStatus
				)
				VALUES
				(	
										@HumanMasterID,
										@CitizenshipID,
										@GenderTypeID,
										@HumanGeoLocationID,
										@OccupationTypeID,
										@EmployerGeoLocationID,
										@HumanAltGeoLocationID,
										@DateOfBirth,
										@DateOfDeath,
										@FirstOrGivenName,
										@SecondName,
										@LastOrSurname,
										@RegistrationPhone,
										@EmployerName,
										@HomePhone,
										@WorkPhone,
										@PersonalIDType,
										@PersonalID,
										0
				);

				EXECUTE					dbo.USP_GBL_NextNumber_GET 'EIDSS Person', @EIDSSPersonID OUTPUT, NULL;

				INSERT INTO				dbo.HumanActualAddlInfo
				(
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
				VALUES
				(
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
			END
		ELSE
			BEGIN
				UPDATE					dbo.tlbHumanActual
				SET						idfsNationality = @CitizenshipID,
										idfsHumanGender = @GenderTypeID,
										idfCurrentResidenceAddress = @HumanGeoLocationID,
										idfsOccupationType = @OccupationTypeID,
										idfEmployerAddress= @EmployerGeoLocationID,
										idfRegistrationAddress = @HumanAltGeoLocationID,
										datDateofBirth = @DateOfBirth,
										datDateofDeath = @DateOfDeath,
										strFirstName = @FirstOrGivenName,
										strSecondName = @SecondName,
										strLastName = @LastOrSurname,
										strRegistrationPhone = @RegistrationPhone,
										strEmployerName = @EmployerName,
										strHomePhone = @HomePhone,
										strWorkPhone = @WorkPhone,
										idfsPersonIDType =@PersonalIDType,
										strPersonID = @PersonalID
				WHERE					idfHumanActual = @HumanMasterID;

				UPDATE					dbo.HumanActualAddlinfo
				SET						ReportedAge = @ReportedAge,
										ReportedAgeUOMID =@ReportAgeUOMID,
										PassportNbr = @PassportNumber,
										IsEmployedID = @IsEmployedTypeID,
										EmployerPhoneNbr = @EmployerPhone,
										EmployedDTM = @EmployedDateLastPresent,
										IsStudentID = @IsStudentTypeID,
										SchoolName = @SchoolName,
										SchoolPhoneNbr = @SchoolPhone,
										SchoolAddressId = @SchoolGeoLocationID,
										SchoolLastAttendDTM = @SchoolDateLastAttended,
										ContactPhoneCountryCode = @ContactPhoneCountryCode ,
										ContactPhoneNbr = @ContactPhone,
										ContactPhoneNbrTypeID = @ContactPhoneTypeID,
										ContactPhone2CountryCode = @ContactPhone2CountryCode,
										ContactPhone2Nbr = @ContactPhone2,
										ContactPhone2NbrTypeID = @ContactPhone2TypeID
				WHERE					HumanActualAddlInfoUID = @HumanMasterID;

				DECLARE @RowsToProcess  INT,
					@CurrentRow			INT,
					@SelectHumanID		INT;
				DECLARE @Human			TABLE (RowID INT NOT NULL PRIMARY KEY IDENTITY(1, 1), HumanID BIGINT);  
				INSERT INTO				@Human (HumanID) SELECT hc.idfHuman FROM dbo.tlbHumanCase hc INNER JOIN dbo.tlbHuman AS h ON h.idfHuman = hc.idfHuman WHERE h.idfHumanActual = @HumanMasterID AND hc.idfsCaseProgressStatus = 10109001;
				SET						@RowsToProcess = @@ROWCOUNT;

				SET						@CurrentRow = 0;
				WHILE					@CurrentRow < @RowsToProcess
				BEGIN
					SET					@CurrentRow = @CurrentRow + 1;
					SELECT				@SelectHumanID = HumanID FROM @Human WHERE RowID = @CurrentRow;
					EXECUTE				dbo.USP_HUM_COPYHUMANACTUALTOHUMAN @HumanMasterID, @SelectHumanID, @ReturnCode, @ReturnMessage;
				END
			END

		IF @@TRANCOUNT > 0 AND @ReturnCode = 0
			COMMIT;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK;

			;THROW;
	END CATCH
END
