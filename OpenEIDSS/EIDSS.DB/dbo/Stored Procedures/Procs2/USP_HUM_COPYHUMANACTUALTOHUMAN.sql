--*************************************************************
-- Name 				:	USP_HUM_COPYHUMANACTUALTOHUMAN
-- Description			:	Copies information FROM tlbHumanActual INTO tlbHuman
--							IF @idfHumanActual IS NULL or record with @idfHumaN
--							doesn't exist in tlbHuman, new record IS created in tlbHuman.
-- AuthOR               :	Mandar Kulkarni
-- Revision HistORy
--		Name       Date       Change Detail
--      Lamont Mitchell 1/11/19 Supressed Results and Aliased Output Columns
--      Lamont Mitchell	1/11/19 Supressed GBL_GEOLOCATION_COPY
--	    Harold Pryor    2/13/19 Supressed additional GBL_GEOLOCATION_COPY
--
 --BEGIN tran
 --EXEC USP_HUM_COPYHUMANACTUALTOHUMAN @idfHumanActual, @idfHuman OUT
--*************************************************************
CREATE PROCEDURE [dbo].[USP_HUM_COPYHUMANACTUALTOHUMAN]
(
	@idfHumanActual	BIGINT = NULL,			
	@idfHuman		BIGINT = NULL OUTPUT,	
	@returnCode		INT = 0 OUTPUT,
	@returnMsg		NVARCHAR(max) = 'SUCCESS' OUTPUT
)
AS

DECLARE	@idfCurrentResidenceAddress	BIGINT	
DECLARE	@idfEmployerAddress			BIGINT
DECLARE	@idfRegistrationAddress		BIGINT
DECLARE @idfSchoolAddress			BIGINT
DECLARE	@idfRootCurrentResidenceAddress BIGINT
DECLARE	@idfRootEmployerAddress		BIGINT
DECLARE	@idfRootRegistrationAddress	BIGINT
DECLARE @idfRootSchoolAddress		BIGINT
	Declare @SupressSelect table
			( retrunCode int,
			  returnMessage varchar(200)
			)
BEGIN
	BEGIN TRY
			SELECT	@idfCurrentResidenceAddress= idfCurrentResidenceAddress 
					,@idfEmployerAddress = idfEmployerAddress
					,@idfRegistrationAddress = idfRegistrationAddress
			FROM tlbHumanActual WHERE idfHumanActual = @idfHumanActual

			IF @idfHuman IS NULL
				INSERT INTO @SupressSelect
				EXEC USP_GBL_NEXTKEYID_GET 'tlbHuman', @idfHuman OUTPUT

			-- Get id for root idfCurrentResidenceAddress
			SET	@idfRootCurrentResidenceAddress = NULL
			SELECT		@idfRootCurrentResidenceAddress	= tlbHuman.idfCurrentResidenceAddress
			FROM		tlbHuman
			WHERE		tlbHuman.idfHuman = @idfHuman

			IF @idfRootCurrentResidenceAddress IS NULL AND NOT @idfCurrentResidenceAddress IS NULL
				BEGIN
					INSERT INTO @SupressSelect
					EXEC USP_GBL_NEXTKEYID_GET 'tlbGeoLocation', @idfRootCurrentResidenceAddress OUTPUT
					INSERT INTO @SupressSelect
					-- Copy addresses for root human
					EXEC USP_GBL_GEOLOCATION_COPY	
							@idfCurrentResidenceAddress,
							@idfRootCurrentResidenceAddress,
							0,
							@returnCode,
							@returnMsg

					IF @returnCode <> 0 
						BEGIN
							SET @returnMsg = 'Failed to copy current residence address'
							SELECT @returnCode, @returnMsg
							RETURN
						END
				END

			-- Get id for root idfEmployerAddress
			SET	@idfRootEmployerAddress = NULL
			SELECT		@idfRootEmployerAddress	= tlbHuman.idfEmployerAddress
			FROM		tlbHuman
			WHERE		tlbHuman.idfHuman = @idfHuman

			IF @idfRootEmployerAddress IS NULL AND NOT @idfEmployerAddress IS NULL
				BEGIN
				    INSERT INTO @SupressSelect
					EXEC USP_GBL_NEXTKEYID_GET 'tlbGeoLocation', @idfRootEmployerAddress OUTPUT

					INSERT INTO @SupressSelect
					-- Copy addresses for employer
					EXEC USP_GBL_GEOLOCATION_COPY	
							@idfEmployerAddress,
							@idfRootEmployerAddress,
							0,
							@returnCode,
							@returnMsg

					IF @returnCode <> 0 
						BEGIN
							SET @returnMsg = 'Failed to copy employer address'
							SELECT @returnCode, @returnMsg
							RETURN
						END
				END

			-- Get id for root idfRegistrationAddress
			SET	@idfRootRegistrationAddress = NULL
			SELECT		@idfRootRegistrationAddress	= tlbHuman.idfRegistrationAddress
			FROM		tlbHuman
			WHERE		tlbHuman.idfHumanActual = @idfHuman

			IF @idfRootRegistrationAddress IS NULL AND NOT @idfRegistrationAddress IS NULL
				BEGIN
					INSERT INTO @SupressSelect
					EXEC USP_GBL_NEXTKEYID_GET 'tlbGeoLocation', @idfRootRegistrationAddress OUTPUT

					INSERT INTO @SupressSelect
					-- Copy registration addresses 
					EXEC USP_GBL_GEOLOCATION_COPY	
							@idfRegistrationAddress,
							@idfRootRegistrationAddress,
							0,
							@returnCode,
							@returnMsg

					IF @returnCode <> 0 
						BEGIN
							SET @returnMsg = 'Failed to copy registration address'
							SELECT @returnCode, @returnMsg
							RETURN
						END
				END


			IF EXISTS	(
							SELECT	*
							FROM	dbo.tlbHuman
							WHERE	idfHuman = @idfHuman
						)
				BEGIN
					UPDATE	dbo.tlbHuman 
					SET		idfHumanActual				=   @idfHumanActual,
							idfsOccupationType			=	ha.idfsOccupationType,
							idfsNationality				=	ha.idfsNationality,
							idfsHumanGender				=	ha.idfsHumanGender,
							idfCurrentResidenceAddress	=	@idfRootCurrentResidenceAddress,
							idfEmployerAddress			=	@idfRootEmployerAddress,
							idfRegistrationAddress		=	@idfRootRegistrationAddress,
							datDateofBirth				=	ha.datDateofBirth,
							datDateOfDeath				=	ha.datDateOfDeath,
							strLastName					=	ha.strLastName,
							strSecondName				=	ha.strSecondName,
							strFirstName				=	ha.strFirstName,
							strRegistrationPhone		=	ha.strRegistrationPhone,
							strEmployerName				=	ha.strEmployerName,
							strHomePhone				=	ha.strHomePhone,
							strWorkPhone				=	ha.strWorkPhone,				
							idfsPersonIDType			=	ha.idfsPersonIDType,
							strPersonID					=	ha.strPersonID
							,datModIFicationDate		=	ha.datModIFicationDate
					FROM	tlbHuman h
					INNER JOIN tlbHumanActual ha ON ha.idfHumanActual = ha.idfHumanActual
					WHERE	h.idfHuman = @idfHuman
				END
			ELSE 
				 BEGIN
					INSERT INTO	dbo.tlbHuman
					(	
						idfHuman,
						idfHumanActual,
						idfsOccupationType,
						idfsNationality,
						idfsHumanGender,
						idfCurrentResidenceAddress,
						idfEmployerAddress,
						idfRegistrationAddress,
						datDateofBirth,
						datDateOfDeath,
						strLastName,
						strSecondName,
						strFirstName,
						strRegistrationPhone,
						strEmployerName,
						strHomePhone,
						strWorkPhone,
						idfsPersonIDType,
						strPersonID
						,datEnteredDate
						,datModIFicationDate
						,intRowStatus
			
					)
				 SELECT
						@idfHuman,
						@idfHumanActual,
						idfsOccupationType,
						idfsNationality,
						idfsHumanGender,
						@idfRootCurrentResidenceAddress,
						@idfRootEmployerAddress,
						@idfRootRegistrationAddress,
						datDateofBirth,
						datDateOfDeath,
						strLastName,
						strSecondName,
						strFirstName,
						strRegistrationPhone,
						strEmployerName,
						strHomePhone,
						strWorkPhone,
						idfsPersonIDType,
						strPersonID,
						datEnteredDate,
						datModIFicationDate,
						0
				FROM dbo.tlbHumanActual
				WHERE idfHumanActual = @idfHumanActual
			END

			-- Insert/Update Additional Info

			-- Get id for root idfSchoolAddress
			SET	@idfRootSchoolAddress = NULL
			SELECT		@idfRootSchoolAddress	= HumanAddlInfo.SchoolAddressID
			FROM		dbo.HumanAddlInfo
			WHERE		HumanAddlInfo.HumanAdditionalInfo = @idfHuman

			IF @idfRootSchoolAddress IS NULL AND NOT @idfSchoolAddress IS NULL
				BEGIN
					INSERT INTO @SupressSelect
					EXEC USP_GBL_NEXTKEYID_GET 'tlbGeoLocation', @idfRootSchoolAddress OUTPUT

					INSERT INTO @SupressSelect
					-- Copy addresses for root human
					EXEC USP_GBL_GEOLOCATION_COPY	
							@idfSchoolAddress,
							@idfRootSchoolAddress,
							0,
							@returnCode,
							@returnMsg

					IF @returnCode <> 0 
						BEGIN
							SET @returnMsg = 'Failed to copy employer address'
							SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
							RETURN
						END
				END

			IF EXISTS	(
							SELECT	*
							FROM	dbo.HumanAddlInfo
							WHERE	HumanAdditionalInfo = @idfHuman
						)
				BEGIN
					UPDATE	dbo.HumanAddlInfo
					SET		ReportedAge = haai.ReportedAge,
							ReportedAgeUOMID = haai.ReportedAgeUOMID,
							ReportedAgeDTM = haai.ReportedAgeDTM,
							PassportNbr = haai.PassportNbr,
							IsEmployedID = haai.IsEmployedID,
							EmployerPhoneNbr = haai.EmployerPhoneNbr,
							EmployedDTM = haai.EmployedDTM,
							IsStudentID = haai.IsStudentID,
							SchoolPhoneNbr = haai.SchoolPhoneNbr,
							SchoolAddressID = haai.SchoolAddressID,
							SchoolLastAttendDTM = haai.SchoolLastAttendDTM,
							ContactPhoneCountryCode = haai.ContactPhoneCountryCode,
							ContactPhoneNbr = haai.ContactPhoneNbr,
							ContactPhoneNbrTypeID = haai.ContactPhoneNbrTypeID,
							ContactPhone2CountryCode = haai.ContactPhone2CountryCode,
							ContactPhone2Nbr = haai.ContactPhone2Nbr,
							ContactPhone2NbrTypeID = haai.ContactPhone2NbrTypeID,
							AltAddressID = haai.AltAddressID,
							SchoolName = haai.SchoolName
					FROM	dbo.HumanAddlInfo hai
					INNER JOIN dbo.humanActualAddlInfo haai ON hai.HumanAdditionalInfo = haai.HumanActualAddlInfoUID
					WHERE	hai.HumanAdditionalInfo = @idfHuman
				END
			ELSE 
				 BEGIN
					INSERT INTO	dbo.HumanAddlInfo
						(	
							HumanAdditionalInfo,
							ReportedAge,
							ReportedAgeUOMID,
							ReportedAgeDTM,
							PassportNbr,
							IsEmployedID,
							EmployerPhoneNbr,
							EmployedDTM,
							IsStudentID,
							SchoolPhoneNbr,
							SchoolAddressID,
							SchoolLastAttendDTM,
							ContactPhoneCountryCode,
							ContactPhoneNbr,
							ContactPhoneNbrTypeID,
							ContactPhone2CountryCode,
							ContactPhone2Nbr,
							ContactPhone2NbrTypeID,
							SchoolName,
							intRowStatus
						)
				 SELECT
						@idfHuman,
						ReportedAge,
						ReportedAgeUOMID,
						ReportedAgeDTM,
						PassportNbr,
						IsEmployedID,
						EmployerPhoneNbr,
						EmployedDTM,
						IsStudentID,
						SchoolPhoneNbr,
						@idfRootSchoolAddress,
						SchoolLastAttendDTM,
						ContactPhoneCountryCode,
						ContactPhoneNbr,
						ContactPhoneNbrTypeID,
						ContactPhone2CountryCode,
						ContactPhone2Nbr,
						ContactPhone2NbrTypeID,
						SchoolName,
						intRowStatus
				FROM dbo.humanActualAddlInfo
				WHERE HumanActualAddlInfoUID = @idfHumanActual
			END
	
	END TRY
	BEGIN CATCH
	THROW;
	END CATCH
END

