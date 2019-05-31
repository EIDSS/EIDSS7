--*************************************************************
-- Name 				: USSP_HUM_DISEASE_CONTACT_SET
-- Description			: set Human Disease Report Contacts by HDID
--          
-- Author               : HAP
-- Revision History
--		Name		Date       Change Detail
-- ---------------- ---------- --------------------------------
-- JWJ				20190119		created 

--
-- Testing code:
-- EXEC USSP_HUMAN_DISEASE_CONTACT_SET (enter your params here) 
--*************************************************************
CREATE PROCEDURE [dbo].[USSP_HUMAN_DISEASE_CONTACT_SET] 
(		 
	@idfHumanCase BIGINT = NULL,
	@ContactsParameters		NVARCHAR(MAX) = NULL	
)
AS
BEGIN

DECLARE @SupressSelect table
			( retrunCode int,
			  returnMessage varchar(200)
			)

   DECLARE @idfContactedCasePerson bigint = null
		   ,@idfsPersonContactType bigint = null
           ,@idfHuman bigint = null
		   ,@idfHumanActual bigint = null 
           ,@datDateOfLastContact datetime = null
           ,@strPlaceInfo nvarchar(200) = null
           ,@intRowStatus int = 0
           ,@rowguid uniqueIdentifier = NEWID()
           ,@strComments nvarchar(500) = null
           ,@strMaintenanceFlag nvarchar(20) = null
           ,@strReservedAttribute nvarchar(max) = null
		   ,@strFirstName nvarchar(200) = null
		   ,@strSecondName nvarchar(200) = null
           ,@strLastName nvarchar(200) = null
           ,@strContactPersonFullName nvarchar(200) = null
           ,@strPersonContactType nvarchar(200) = null
           ,@datDateOfBirth DateTime2 = null
           ,@idfsHumanGender bigint = null
           ,@idfCitizenship bigint = null
           ,@idfsCountry bigint = null
           ,@idfsRegion bigint = null
           ,@strContactPhone nvarchar(20) = null
           ,@idfContactPhoneType bigint = null

	DECLARE @returnMsg				VARCHAR(MAX) = 'Success';
	DECLARE @returnCode				BIGINT = 0;

	DECLARE @ContactsTemp Table(	     
			idfContactedCasePerson bigint null
		   ,idfsPersonContactType bigint  null
           ,idfHuman bigint null
		   ,idfHumanActual bigint null 
           ,idfHumanCase bigint null
           ,datDateOfLastContact datetime null
           ,strPlaceInfo nvarchar(200) null
           ,intRowStatus int 
           ,rowguid uniqueIdentifier  null
           ,strComments nvarchar(500) null
           ,strMaintenanceFlag nvarchar(20) null
           ,strReservedAttribute nvarchar(max) null
		   ,strFirstName nvarchar(200) null
		   ,strSecondName nvarchar(200) null
           ,strLastName nvarchar(200) null
           ,strContactPersonFullName nvarchar(200) null
           ,strPersonContactType nvarchar(200) null
           ,datDateOfBirth DateTime2 null
           ,idfsHumanGender bigint null
           ,idfCitizenship bigint null
           ,idfsCountry bigint null
           ,idfsRegion bigint null
           ,strContactPhone nvarchar(20) null
           ,idfContactPhoneType bigint null
		   )
	
	BEGIN TRY  
		WHILE EXISTS (SELECT * FROM @ContactsTemp)
			BEGIN
				SELECT TOP 1
					@idfContactedCasePerson = idfContactedCasePerson
				   ,@idfsPersonContactType = idfsPersonContactType
				   ,@idfHuman = idfHuman
				   ,@idfHumanActual = idfHumanActual
				   ,@datDateOfLastContact = datDateOfLastContact
				   ,@strPlaceInfo = strPlaceInfo
				   ,@intRowStatus = intRowStatus
				   ,@rowguid = rowguid
				   ,@strComments = strComments
				   ,@strMaintenanceFlag = strMaintenanceFlag
				   ,@strReservedAttribute = strReservedAttribute
				   ,@strFirstName = strFirstName
				   ,@strSecondName = strSecondName
				   ,@strLastName = strLastName
				   ,@strContactPersonFullName = strContactPersonFullName
				   ,@strPersonContactType= strPersonContactType
				   ,@datDateOfBirth = datDateOfBirth
				   ,@idfsHumanGender = idfsHumanGender
				   ,@idfCitizenship = idfCitizenship
				   ,@idfsCountry = idfsCountry
				   ,@idfsRegion = idfsRegion
				   ,@strContactPhone = strContactPhone
				   ,@idfContactPhoneType = idfContactPhoneType
				FROM @ContactsTemp

		IF NOT EXISTS (SELECT idfContactedCasePerson 
							FROM dbo.tlbContactedCasePerson 
							WHERE idfContactedCasePerson = @idfContactedCasePerson 
								AND	intRowStatus = 0)
			BEGIN

				INSERT INTO @SupressSelect
				-- Get next key value
				EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbContactedCasePerson', @idfContactedCasePerson OUTPUT

				INSERT INTO [dbo].[tlbContactedCasePerson]
					   (
						   idfContactedCasePerson,
						   idfsPersonContactType
						   ,idfHuman
						   ,idfHumanCase
						   ,datDateOfLastContact
						   ,strPlaceInfo
						   ,intRowStatus
						   ,rowguid
						   ,strComments
						   ,strMaintenanceFlag
						   ,strReservedAttribute
					   )
				 VALUES
					   (
							@idfContactedCasePerson
							,@idfsPersonContactType 
							,@idfHuman 
							,@idfHumanCase
							,@datDateOfLastContact
							,@strPlaceInfo 
							,@intRowStatus
							,@rowguid 
							,@strComments 
							,@strMaintenanceFlag 
							,@strReservedAttribute 
					   )

			END
		Else
			BEGIN
				UPDATE dbo.tlbContactedCasePerson
				SET 
					   idfsPersonContactType = @idfsPersonContactType
					   ,idfHuman = @idfHuman
					   ,idfHumanCase = @idfHumanCase
					   ,datDateOfLastContact = @datDateOfLastContact
					   ,strPlaceInfo = @strPlaceInfo
					   ,intRowStatus = @intRowStatus
					   ,rowguid = @rowguid
					   ,strComments = @strComments
					   ,strMaintenanceFlag = @strMaintenanceFlag
					   ,strReservedAttribute = @strReservedAttribute
				WHERE idfContactedCasePerson = @idfContactedCasePerson 
					AND	intRowStatus = 0
			END

			SET ROWCOUNT 1
					DELETE FROM @ContactsTemp
					SET ROWCOUNT 0

		END		--end loop, WHILE EXISTS (SELECT * FROM @SamplesTemp)
			--SELECT @returnCode 'ReturnCode', @returnMsg 'ResturnMessage';
		END TRY  
	BEGIN CATCH 
		THROW
	END CATCH;
END
