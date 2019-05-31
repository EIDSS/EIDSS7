
--*************************************************************
-- Name: [USP_OMM_Contact_Set]
-- Description: Insert/Update for Outbreak Case
--          
-- Author: Doug Albanese
-- Revision History
--		Name       Date       Change Detail
--    
--*************************************************************
CREATE PROCEDURE [dbo].[USP_OMM_Contact_Set]
(    
	@LangID										NVARCHAR(50), 
	@OutbreakCaseContactUID						BIGINT = -1,
	@OutBreakCaseReportUID						BIGINT = NULL,
	@ContactRelationshipTypeID					BIGINT = NULL,
	@DateOfLastContact							DATETIME = NULL,
	@contactLocationidfsCountry					BIGINT = NULL,
	@contactLocationidfsRegion					BIGINT = NULL,
	@contactLocationidfsRayon					BIGINT = NULL,
	@contactLocationidfsSettlement				BIGINT = NULL,
	@strStreetName								NVARCHAR(200) = NULL,
	@strPostCode								NVARCHAR(200) = NULL,
	@strBuilding								NVARCHAR(200) = NULL,
	@strHouse									NVARCHAR(200) = NULL,
	@strApartment								NVARCHAR(200) = NULL,
	@strAddressString							NVARCHAR(200) = NULL,
	@Phone										NVARCHAR(200) = NULL,
	@PlaceOfLastContact							NVARCHAR(200) = NULL,
	@CommentText								NVARCHAR(500) = NULL,
	@ContactStatusID							BIGINT = NULL,
	@intRowStatus								INT = 0,
	@AuditUser									VARCHAR(100),
	@AuditDTM									DATETIME,
	@FunctionCall								INT = 0
)
AS

BEGIN    

	DECLARE	@returnCode						INT = 0;
	DECLARE @returnMsg						NVARCHAR(MAX) = 'SUCCESS';
	DECLARE @contactLocation				BIGINT = NULL
	DECLARE @idfHumanCase					BIGINT = NULL

	Declare @SupressSelect table
	( retrunCode int,
		returnMsg varchar(200)
	)

	SELECT 
		TOP 1
		@contactLocation = idfGeoLocation
	FROM 
		tlbGeolocation
	WHERE
		(idfsCountry = @contactLocationidfsCountry OR @contactLocationidfsCountry IS NULL) AND
		(idfsRayon = @contactLocationidfsRayon OR @contactLocationidfsRayon IS NULL) AND
		(idfsRegion = @contactLocationidfsRegion OR @contactLocationidfsRegion IS NULL) AND
		(idfsSettlement = @contactLocationidfsSettlement OR @contactLocationidfsSettlement IS NULL) 

	IF @contactLocation = NULL or @contactLocation IS NULL
		BEGIN

			INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_ADDRESS_SET 	@contactLocation,
											null,
											null,
											null,
											@contactLocationidfsCountry,
											@contactLocationidfsRegion,
											@contactLocationidfsRayon,
											@contactLocationidfsSettlement,
											null,
											null,
											null,
											null,
											null,
											null,
											null,
											null,
											null,
											null,
											null,
											null,
											null,
											null,
											@returnCode,
											@returnMsg

			/* In this case, supression causes the variable, @contactLocation, to be null.*/
			SELECT 
				TOP 1
				@contactLocation = idfGeoLocation
			FROM 
				tlbGeolocation
			WHERE
				(idfsCountry = @contactLocationidfsCountry OR @contactLocationidfsCountry IS NULL) AND
				(idfsRayon = @contactLocationidfsRayon OR @contactLocationidfsRayon IS NULL) AND
				(idfsRegion = @contactLocationidfsRegion OR @contactLocationidfsRegion IS NULL) AND
				(idfsSettlement = @contactLocationidfsSettlement OR @contactLocationidfsSettlement IS NULL) 

		END

	BEGIN TRY
			IF @OutbreakCaseContactUID = -1
				BEGIN
					INSERT INTO @SupressSelect
					EXEC	dbo.USP_GBL_NEXTKEYID_GET 'OutbreakCaseContact', @OutbreakCaseContactUID OUTPUT;

					DECLARE @tempOutbreakCaseContact		TABLE
					(
						OutbreakCaseContactUID				BIGINT,
						OutbreakCaseReportUID				BIGINT,
						ContactTypeId						BIGINT,
						ContactedHumanCasePersonID			BIGINT,
						idfHuman							BIGINT,
						AuditCreateUser						VARCHAR(100),
						AuditCreateDTM						DATETIME
					)

					--First we need the idfHumanCase from the recently created Case record
					SELECT
							@idfHumanCase = idfHumanCase
					FROM
							dbo.OutbreakCaseReport
					WHERE
							OutBreakCaseReportUID = @OutBreakCaseReportUID
					
					--Now query the contact table from the source and create a record set to insert into the outbreak case contact table
					INSERT INTO @tempOutbreakCaseContact
						(
							OutbreakCaseContactUID,
							OutbreakCaseReportUID,
							ContactTypeId,
							ContactedHumanCasePersonID,
							idfHuman,
							AuditCreateUser,
							AuditCreateDTM
						)

					SELECT 
							NULL					AS OutbreakCaseContactUID,	
							@OutBreakCaseReportUID	AS OutBreakCaseReportUID,
							idfsPersonContactType	AS ContactTypeId,
							idfContactedCasePerson	AS ContactedHumanCasePersonID,
							idfHuman				AS idfHuman,
							@AuditUser				AS AuditCreateUser,
							@AuditDTM				AS AuditCreateDTM
					FROM
							tlbContactedCasePerson
					WHERE
							idfHumanCase = @idfHumanCase

					--Now we need to get a FK for each row and insert it one at a time so that the "Next Key" generation will be proper.
					WHILE (SELECT COUNT(OutBreakCaseReportUID) FROM @tempOutbreakCaseContact WHERE OutbreakCaseContactUID IS NULL) > 0  
						BEGIN 
							DECLARE @ContactedHumanCasePersonID					BIGINT = NULL
							--Identify the first Outbreak Case Contact so that we can modify one row at a time.
							SELECT	
									TOP 1 @ContactedHumanCasePersonID = ContactedHumanCasePersonID
							FROM
									@tempOutbreakCaseContact
							WHERE
									OutbreakCaseContactUID IS NULL

							INSERT INTO @SupressSelect
							EXEC	dbo.USP_GBL_NEXTKEYID_GET 'OutbreakCaseContact', @OutbreakCaseContactUID OUTPUT;
							
							UPDATE	
									@tempOutbreakCaseContact
							SET		
									OutbreakCaseContactUID = @OutbreakCaseContactUID
							WHERE	
									ContactedHumanCasePersonID = @ContactedHumanCasePersonID
									
							INSERT INTO	dbo.OutbreakCaseContact
							(
									OutbreakCaseContactUID,
									OutBreakCaseReportUID,
									ContactTypeID,
									ContactedHumanCasePersonID,
									idfHuman,
									AuditCreateUser,
									AuditCreateDTM
							)
							SELECT 
									OutbreakCaseContactUID,	
									OutBreakCaseReportUID,
									ContactTypeId,
									ContactedHumanCasePersonID,
									idfHuman,
									AuditCreateUser,
									AuditCreateDTM
							FROM
									@tempOutbreakCaseContact
							WHERE
									ContactedHumanCasePersonID = @ContactedHumanCasePersonID
						END 
				END
			ELSE
				BEGIN
						UPDATE		OutbreakCaseContact
						SET 
									ContactRelationshipTypeID = @ContactRelationshipTypeID,
									DateOfLastContact = @DateOfLastContact,
									PlaceOfLastContact = @PlaceOfLastContact,
									CommentText = @CommentText,
									ContactStatusID = @ContactStatusID,
									intRowStatus = @intRowStatus,
									AuditUpdateUser = @AuditUser,
									AuditUpdateDTM = @AuditDTM
						WHERE
									OutbreakCaseContactUID=@OutbreakCaseContactUID


						IF @contactLocation IS NOT NULL
							BEGIN
								DECLARE @idfHuman				BIGINT = NULL

								select @idfHuman = idfHuman	FROM OutbreakCaseContact	WHERE OutbreakCaseContactUID = @OutbreakCaseContactUID
							
								UPDATE			
												tlbGeoLocation
								SET				strHouse = @strHouse,
												strBuilding = @strBuilding,
												strAddressString = @strAddressString,
												strPostCode = @strPostCode,
												strApartment = @strApartment
								WHERE
												idfGeoLocation = @contactLocation

								--the Update here is done to objects outside of outbreak...outlined by the use case
								UPDATE			
												tlbHuman
								SET				
												idfCurrentResidenceAddress = @contactLocation,
												strHomePhone = @Phone
								WHERE			
												idfHuman = @idfHuman
							END
					END
				
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT = 1 
			ROLLBACK;
		;throw;
	END CATCH

	if (@FunctionCall= 0)
		BEGIN
			SELECT	@returnCode as returnCode, @returnMsg as returnMsg
		END
	
END