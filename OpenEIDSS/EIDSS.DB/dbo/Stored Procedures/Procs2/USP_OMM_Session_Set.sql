USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_OMM_Session_Set]    Script Date: 5/10/2019 6:57:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--*************************************************************
-- Name: [USP_OMM_Session_Set]
-- Description: Insert/Update for Campaign Monitoring Session
--          
-- Author: Doug Albanese
-- Revision History
--		Name       Date       Change Detail
--    
--*************************************************************
ALTER PROCEDURE [dbo].[USP_OMM_Session_Set]
(    
	@LangID										NVARCHAR(50), 
	@idfOutbreak								BIGINT = NULL,
	@idfsDiagnosisOrDiagnosisGroup				BIGINT = NULL,
	@idfsOutbreakStatus							BIGINT = NULL,
	@OutbreakTypeId								BIGINT = NULL,
	@outbreakLocationidfsCountry				BIGINT = NULL,
	@outbreakLocationidfsRegion					BIGINT = NULL,
	@outbreakLocationidfsRayon					BIGINT = NULL,
	@outbreakLocationidfsSettlement				BIGINT = NULL,
	@datStartDate								DATETIME = NULL,
	@datCloseDate								DATETIME = NULL,
	@strOutbreakID								NVARCHAR(200) = NULL,
	@strDescription								NVARCHAR(2000) = NULL,
	@intRowStatus								INT = 0,
	@datModificationForArchiveDate				DATETIME = NULL,
	@idfPrimaryCaseOrSession					BIGINT = NULL,
	@idfsSite									BIGINT,
	@strMaintenanceFlag							NVARCHAR(20) = NULL,
	@strReservedAttribute						NVARCHAR(MAX) = NULL,
	@outbreakParameters							NVARCHAR(MAX) = NULL
)
AS

BEGIN    

	DECLARE	@returnCode						INT = 0;
	DECLARE @returnMsg						NVARCHAR(MAX) = 'SUCCESS';

	--reset locations to null
	IF @outbreakLocationidfsRegion = -1 SET @outbreakLocationidfsRegion = NULL
	IF @outbreakLocationidfsRayon = -1 SET @outbreakLocationidfsRayon = NULL
	IF @outbreakLocationidfsSettlement = -1 SET @outbreakLocationidfsSettlement = NULL

	IF @idfsSite IS NULL
		BEGIN
			SELECT @returnCode as ReturnCode, @returnMsg as ReturnMessage, @idfOutbreak as idfOutbreak
		END
	ELSE
		BEGIN

			DECLARE @outbreakLocation				BIGINT = NULL

			DECLARE		@OutbreakSpeciesParameterUID	BIGINT
			DECLARE		@OutbreakSpeciesTypeID			BIGINT
			DECLARE		@ParameterSpeciesTypes			TABLE (
				OutbreakSpeciesTypeID			BIGINT
			)

			Declare @SupressSelect table
			( retrunCode int,
				returnMsg varchar(200)
			)

			SELECT 
				TOP 1
				@outbreakLocation = idfGeoLocation
			FROM 
				tlbGeolocation
			WHERE
				(idfsCountry = @outbreakLocationidfsCountry OR @outbreakLocationidfsCountry IS NULL) AND
				(idfsRayon = @outbreakLocationidfsRayon OR @outbreakLocationidfsRayon IS NULL) AND
				(idfsRegion = @outbreakLocationidfsRegion OR @outbreakLocationidfsRegion IS NULL) AND
				(idfsSettlement = @outbreakLocationidfsSettlement OR @outbreakLocationidfsSettlement IS NULL) 

			IF @outbreakLocation = NULL or @outbreakLocation IS NULL
				BEGIN

					--INSERT INTO @SupressSelect
					EXEC dbo.USP_GBL_ADDRESS_SET 	@outbreakLocation OUTPUT,
													null,
													null,
													null,
													@outbreakLocationidfsCountry,
													@outbreakLocationidfsRegion,
													@outbreakLocationidfsRayon,
													@outbreakLocationidfsSettlement,
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

					/* In this case, supression causes the variable, @outbreakLocation, to be null.*/
					SELECT 
						TOP 1
						@outbreakLocation = idfGeoLocation
					FROM 
						tlbGeolocation
					WHERE
						(idfsCountry = @outbreakLocationidfsCountry OR @outbreakLocationidfsCountry IS NULL) AND
						(idfsRayon = @outbreakLocationidfsRayon OR @outbreakLocationidfsRayon IS NULL) AND
						(idfsRegion = @outbreakLocationidfsRegion OR @outbreakLocationidfsRegion IS NULL) AND
						(idfsSettlement = @outbreakLocationidfsSettlement OR @outbreakLocationidfsSettlement IS NULL) 

				END
	
			BEGIN TRY
					SET @returnCode					= 0;
					SET @returnMsg					= 'SUCCESS';

					DECLARE  @convertedParameters TABLE (
						OutbreakSpeciesParameterUID		BIGINT,
						idfOutbreak						BIGINT,
						OutbreakSpeciesTypeID			BIGINT NULL,
						CaseMonitoringDuration			INT NULL,
						CaseMonitoringFrequency			INT NULL,
						ContactTracingDuration			INT NULL,
						ContactTracingFrequency			INT NULL,
						intRowStatus					INT,
						AuditCreateUser					VARCHAR,
						AuditCreateDTM					DATETIME2,
						AuditUpdateUser					VARCHAR NULL,
						AuditUpdateDTM					DATETIME2 NULL
					)

					INSERT INTO @convertedParameters 
					SELECT 
						* 
					FROM OPENJSON(@outbreakParameters) 
					WITH (
						OutbreakSpeciesParameterUID		BIGINT, 
						idfOutbreak						BIGINT, 
						OutbreakSpeciesTypeID			BIGINT, 
						CaseMonitoringDuration			INT, 
						CaseMonitoringFrequency			INT, 
						ContactTracingDuration			INT, 
						ContactTracingFrequency			INT, 
						intRowStatus					INT, 
						AuditCreateUser					VARCHAR, 
						AuditCreateDTM					DATETIME2, 
						AuditUpdateUser					VARCHAR, 
						AuditUpdateDTM					DATETIME2
					) 
			
					IF EXISTS (SELECT * FROM dbo.tlbOutbreak WHERE idfOutbreak = @idfOutbreak)
						BEGIN
							UPDATE		dbo.tlbOutbreak
							SET 
										idfsDiagnosisOrDiagnosisGroup=@idfsDiagnosisOrDiagnosisGroup,
										idfsOutbreakStatus=@idfsOutbreakStatus,
										OutbreakTypeID=@OutbreakTypeID,
										idfGeoLocation=@outbreakLocation,
										datStartDate=@datStartDate,
										datFinishDate=@datCloseDate,
										strOutbreakID=@strOutbreakID,
										strDescription=@strDescription,
										intRowStatus=COALESCE(@intRowStatus,0),
										datModificationForArchiveDate=@datModificationForArchiveDate,
										idfPrimaryCaseOrSession=@idfPrimaryCaseOrSession,
										idfsSite=@idfsSite,
										strMaintenanceFlag=@strMaintenanceFlag,
										strReservedAttribute=@strReservedAttribute
							WHERE
										idfOutbreak=@idfOutbreak
						END
					ELSE
						BEGIN
							IF ISNULL(@idfOutbreak,-1)<0
								BEGIN
									INSERT INTO @SupressSelect
									EXEC	dbo.USP_GBL_NEXTKEYID_GET 'tlbOutbreak', @idfOutbreak OUTPUT;
								END
					
							IF LEFT(ISNULL(@strOutbreakID, '(new)'),5) = '(new)'
								BEGIN
									INSERT INTO @SupressSelect
									EXEC	dbo.USP_GBL_NextNumber_GET 'Outbreak Session', @strOutbreakID OUTPUT , NULL; --N'AS Session'
								END

							INSERT INTO	dbo.tlbOutbreak
							(
										idfOutbreak,
										idfsDiagnosisOrDiagnosisGroup,
										idfsOutbreakStatus,
										OutbreakTypeID,
										idfGeoLocation,
										datStartDate,
										datFinishDate,
										strOutbreakID,
										strDescription,
										intRowStatus,
										datModificationForArchiveDate,
										idfPrimaryCaseOrSession,
										idfsSite,
										strMaintenanceFlag,
										strReservedAttribute
							)
							VALUES
							(
										@idfOutbreak,
										@idfsDiagnosisOrDiagnosisGroup,
										@idfsOutbreakStatus,
										@OutbreakTypeId,
										@outbreakLocation,
										@datStartDate,
										@datCloseDate,
										@strOutbreakID,
										@strDescription,
										COALESCE(@intRowStatus,0),
										@datModificationForArchiveDate,
										@idfPrimaryCaseOrSession,
										@idfsSite,
										@strMaintenanceFlag,
										@strReservedAttribute
							)
						END
	
					UPDATE @convertedParameters
					SET idfOutbreak = @idfOutbreak

					INSERT INTO @SupressSelect
					EXEC USP_OMM_Session_Parameters_Del @idfOutbreak

					INSERT INTO @ParameterSpeciesTypes
					SELECT		
								DISTINCT OutbreakSpeciesTypeID AS OutbreakSpeciesTypeID
					FROM 
								@convertedParameters

					--Modifications to a Table Variable prevents Adding a column. Code was modified to produce this feild
					--Now we need to get a FK for each row and insert it one at a time so that the "Next Key" generation will be proper.
					WHILE (SELECT COUNT(OutbreakSpeciesTypeID) FROM @ParameterSpeciesTypes) > 0  
						BEGIN 
							--Identify the first Outbreak Species Type so that we can modify one row at a time.
							--Using table variable with species types only
							SELECT	
									TOP 1 @OutbreakSpeciesTypeID = OutbreakSpeciesTypeID
							FROM
									@ParameterSpeciesTypes

							INSERT INTO @SupressSelect
							EXEC	dbo.USP_GBL_NEXTKEYID_GET 'OutbreakSpeciesParameter', @OutbreakSpeciesParameterUID OUTPUT;
							
							--Update the JSON data that was converted over to a table variable
							UPDATE	
									@convertedParameters
							SET		
									OutbreakSpeciesParameterUID = @OutbreakSpeciesParameterUID
							WHERE	
									OutbreakSpeciesTypeID = @OutbreakSpeciesTypeID

							--Because USP_GBL_NEXTKEYID_GET will need to have the record in the destination table, we will have to insert it now,
							--so that the next key will be generated.
							INSERT INTO 		OutbreakSpeciesParameter
											(
												OutbreakSpeciesParameterUID,
												idfOutbreak,
												OutbreakSpeciesTypeID,
												CaseMonitoringDuration,
												CaseMonitoringFrequency,
												ContactTracingDuration,
												ContactTracingFrequency,
												intRowStatus,
												AuditCreateUser,
												AuditCreateDTM,
												AuditUpdateUser,
												AuditUpdateDTM
											)
							SELECT 
												OutbreakSpeciesParameterUID,
												idfOutbreak,
												OutbreakSpeciesTypeID,
												CaseMonitoringDuration,
												CaseMonitoringFrequency,
												ContactTracingDuration,
												ContactTracingFrequency,
												intRowStatus,
												AuditCreateUser,
												AuditCreateDTM,
												AuditUpdateUser,
												AuditUpdateDTM
							FROM 
									@convertedParameters
							WHERE
									OutbreakSpeciesTypeID = @OutbreakSpeciesTypeID

							--Delete the Species type that we have been working with so that the loop will decrement and fall out when 0.
							DELETE FROM 
									@ParameterSpeciesTypes
							WHERE
									OutbreakSpeciesTypeID = @OutbreakSpeciesTypeID
						END  

			END TRY
			BEGIN CATCH
				IF @@TRANCOUNT = 1 
					ROLLBACK;
		
				SET		@returnCode = ERROR_NUMBER();
				SET		@returnMsg = 
							'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
							+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
							+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
							+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
							+ ' ErrorLine: ' +  CONVERT(VARCHAR, ISNULL(ERROR_LINE(), ''))
							+ ' ErrorMessage: '+ ERROR_MESSAGE();

				;throw;
			END CATCH

			SELECT @returnCode as ReturnCode, @returnMsg as ReturnMessage, @idfOutbreak as idfOutbreak
		END
END