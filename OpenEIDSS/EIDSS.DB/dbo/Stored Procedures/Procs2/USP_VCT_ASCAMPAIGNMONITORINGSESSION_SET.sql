
--*************************************************************
-- Name: USP_VCT_ASCAMPAIGNMONITORINGSESSION_SET]
-- Description: Insert/Update for Campaign Monitoring Session
--          
-- Author: Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
-- Stephen Long    05/07/2018 Added structured type parameters
--    
--*************************************************************
CREATE PROCEDURE [dbo].[USP_VCT_ASCAMPAIGNMONITORINGSESSION_SET]
(    
	@LangID										NVARCHAR(50), 
	@idfMonitoringSession						BIGINT OUTPUT,
	@idfsMonitoringSessionStatus				BIGINT = NULL, 
	@MonitoringSessionAddressidfsCountry		BIGINT = NULL,
	@MonitoringSessionAddressidfsRegion			BIGINT = NULL,
	@MonitoringSessionAddressidfsRayon			BIGINT = NULL,
	@MonitoringSessionAddressidfsSettlement		BIGINT = NULL,
	@idfPersonEnteredBy							BIGINT = NULL,
	@idfCampaign								BIGINT = NULL,
	@strCampaignName							NVARCHAR(50),
	@idfsCampaignType							BIGINT = NULL,
	@idfsSite									BIGINT, 
	@datEnteredDate								DATETIME = NULL,
	@strMonitoringSessionID						NVARCHAR(50) = '(new)' OUTPUT,
	@datStartDate								DATETIME = NULL,
	@datEndDate									DATETIME = NULL,
	@datCampaignDateStart						DATETIME = NULL,
	@datCampaignDateEnd							DATETIME = NULL,
	@idfsDiagnosis								BIGINT = NULL,
	@SessionCategoryID							BIGINT = NULL, -- 10169001 Human Active Surveillance Session, 10169002 Veterinary Active Surveillance Session
	@intRowStatus								INT, 
	@AvianOrLivestock							NVARCHAR(50) OUTPUT, 
	@Farms										tlbFarmHerdSpeciesGetListSPType READONLY, 
	@Herds										tlbFarmHerdSpeciesGetListSPType READONLY, 
	@Species									tlbFarmHerdSpeciesGetListSPType READONLY, 
	@Animals									tlbAnimalGetListSPType READONLY, 
	@SpeciesAndSamples							tlbMonitoringSessionToSampleTypeGetListSPType READONLY, 
	@Samples									tlbMaterialGetListSPType READONLY, 
	@Tests										tlbTestingGetListSPType READONLY, 
	@Interpretations							tlbTestValidationGetListSPType READONLY, 
	@Actions									tlbMonitoringSessionActionGetListSPType READONLY, 
	@Summaries									tlbMonitoringSessionSummaryGetListSPType READONLY 
)     
AS    
DECLARE	@returnCode								INT = 0;
DECLARE @returnMsg								NVARCHAR(MAX) = 'SUCCESS';

DECLARE											@FarmsTemp dbo.tlbFarmHerdSpeciesGetListSPType;
INSERT INTO										@FarmsTemp SELECT * FROM @Farms;
DECLARE											@HerdsTemp dbo.tlbFarmHerdSpeciesGetListSPType;
INSERT INTO										@HerdsTemp SELECT * FROM @Herds;
DECLARE											@SpeciesTemp dbo.tlbFarmHerdSpeciesGetListSPType;
INSERT INTO										@SpeciesTemp SELECT * FROM @Species;
DECLARE											@AnimalsTemp dbo.tlbAnimalGetListSPType;
INSERT INTO										@AnimalsTemp SELECT * FROM @Animals;
DECLARE											@SpeciesAndSamplesTemp dbo.tlbMonitoringSessionToSampleTypeGetListSPType;
INSERT INTO										@SpeciesAndSamplesTemp SELECT * FROM @SpeciesAndSamples;
DECLARE											@SamplesTemp dbo.tlbMaterialGetListSPType;
INSERT INTO										@SamplesTemp SELECT * FROM @Samples;
DECLARE											@LabTestsTemp dbo.tlbTestingGetListSPType;
INSERT INTO										@LabTestsTemp SELECT * FROM @Tests;
DECLARE											@InterpretationsTemp dbo.tlbTestValidationGetListSPType;
INSERT INTO										@InterpretationsTemp SELECT * FROM @Interpretations;
DECLARE											@ActionsTemp dbo.tlbMonitoringSessionActionGetListSPType;
INSERT INTO										@ActionsTemp SELECT * FROM @Actions;
DECLARE											@SummariesTemp dbo.tlbMonitoringSessionSummaryGetListSPType;
INSERT INTO										@SummariesTemp SELECT * FROM @Summaries;

DECLARE @idfFarmTempID							BIGINT,
	@idfFarm									BIGINT, 
	@idfFarmActual								BIGINT, 
    @strFarmCode								NVARCHAR(200) = NULL,
    @intSickAnimalQty							INT = NULL,
    @intTotalAnimalQty							INT = NULL,
    @intDeadAnimalQty							INT = NULL,
	---------------
	@idfHerdTempID								BIGINT,
	@idfHerd									BIGINT, 
	@idfHerdActual								BIGINT = NULL, 
    @strHerdCode								NVARCHAR(200) = NULL,
    @strNote									NVARCHAR(2000) = NULL, 
	@strMaintenanceFlag							NVARCHAR(20) = NULL, 
	---------------
	@idfSpeciesTempID							BIGINT,
	@idfSpecies									BIGINT, 
	@idfSpeciesActual							BIGINT = NULL, 
    @idfsSpeciesType							BIGINT,
    @datStartOfSignsDate						DATETIME = NULL,
    @strAverageAge								NVARCHAR(200) = NULL,
	------------------
	@idfAnimalTempID							BIGINT, 
	@idfAnimal									BIGINT = NULL, 
	@idfsAnimalGender							BIGINT = NULL, 
	@idfsAnimalCondition						BIGINT = NULL, 
	@idfsAnimalAge								BIGINT = NULL, 
	@strAnimalCode								NVARCHAR(200) = NULL, 
	@strName									NVARCHAR(200) = NULL, 
	@strColor									NVARCHAR(200) = NULL,
	@strDescription								NVARCHAR(200) = NULL, 
	------------------
	@MonitoringSessionToSampleTypeTempID		BIGINT, 
	@MonitoringSessionToSampleType				BIGINT, 
	@intOrder									INT, 
	------------------
	@idfMaterialTempID							BIGINT, 
	@idfMaterial								BIGINT, 
	@idfsSampleType								BIGINT = NULL, 
	@idfRootMaterial							BIGINT = NULL, 
	@idfParentMaterial							BIGINT = NULL, 
	@idfFieldCollectedByPerson					BIGINT = NULL, 
	@idfFieldCollectedByOffice					BIGINT = NULL, 
	@idfMainTest								BIGINT = NULL, 
	@datFieldCollectionDate						DATETIME = NULL, 
	@datFieldSentDate							DATETIME = NULL, 
	@strFieldBarcode							NVARCHAR(200) = NULL, 
	@idfsSampleStatus							BIGINT = NULL, 
	@idfInDepartment							BIGINT = NULL, 
	@idfDestroyedByPerson						BIGINT = NULL, 
	@datEnteringDate							DATETIME = NULL, 
	@datDestructionDate							DATETIME = NULL, 
	@strBarcode									NVARCHAR(200) = NULL, 
	@idfSendToOffice							BIGINT = NULL, 
	@blnReadOnly								BIT = NULL, 
	@idfsBirdStatus								BIGINT = NULL, 
	@datAccession								DATETIME = NULL, 
	@idfsAccessionCondition						BIGINT = NULL, 
	@strCondition								NVARCHAR(200) = NULL, 
	@idfAccesionByPerson						BIGINT = NULL, 
	@idfsDestructionMethod						BIGINT = NULL, 
	@idfsCurrentSite							BIGINT = NULL, 
	@idfsSampleKind								BIGINT = NULL, 
	@idfMarkedForDispositionByPerson			BIGINT = NULL, 
	@datOutOfRepositoryDate						DATETIME = NULL, 
	@idfObservation								BIGINT = NULL, 
	@idfVetCase									BIGINT = NULL,
	------------------
	@idfTesting									BIGINT, 
	@idfTestingTempID							BIGINT, 
	@idfsTestName								BIGINT = NULL, 
	@idfsTestCategory							BIGINT = NULL, 
	@idfsTestResult								BIGINT = NULL, 
	@idfsTestStatus								BIGINT, 
	@idfBatchTest								BIGINT = NULL, 
	@idfObservationLabTests						BIGINT, 
	@intTestNumber								INT = NULL, 
	@datStartedDate								DATETIME = NULL, 
	@datConcludedDate							DATETIME = NULL, 
	@idfResultEnteredByOffice					BIGINT = NULL, 
	@idfResultEnteredByPerson					BIGINT = NULL, 
	@idfValidatedByOffice						BIGINT = NULL, 
	@idfValidatedByPerson						BIGINT = NULL, 
	@blnNonLaboratoryTest						BIT, 
	@blnExternalTest							BIT = NULL, 
	@idfPerformedByOffice						BIGINT = NULL, 
	@datReceivedDate							DATETIME = NULL, 
	@strContactPerson							NVARCHAR(200) = NULL,
	@idfTestedByPerson							BIGINT = NULL,
	@idfTestedByOffice							BIGINT = NULL,
	------------------
	@idfTestValidation							BIGINT, 
	@idfTestValidationTempID					BIGINT, 
	@idfsInterpretedStatus						BIGINT = NULL, 
	@idfInterpretedByOffice						BIGINT = NULL, 
	@idfInterpretedByPerson						BIGINT = NULL, 
	@idfTestingInterpretations					BIGINT, 
	@blnValidateStatus							BIT = NULL, 
	@blnCaseCreated								BIT = NULL, 
	@strValidateComment							NVARCHAR(200) = NULL,
	@strInterpretedComment						NVARCHAR(200) = NULL,
	@datValidationDate							DATETIME = NULL, 
	@datInterpretationDate						DATETIME = NULL, 
	------------------
	@idfMonitoringSessionActionTempID			BIGINT,
	@idfMonitoringSessionAction					BIGINT, 
    @idfsMonitoringSessionActionType			BIGINT,
    @idfsMonitoringSessionActionStatus			BIGINT,
    @datActionDate								DATETIME = NULL, 
	@strComments								NVARCHAR(500) = NULL, 
	@RecordAction								NCHAR(1),
	@RecordID									BIGINT = NULL, 
	------------------
	@idfMonitoringSessionSummaryTempID			BIGINT,
	@idfMonitoringSessionSummary				BIGINT, 
	@idfsAnimalSex								BIGINT = NULL, 
    @intSampledAnimalsQty						INT = NULL,
	@intSamplesQty								INT = NULL, 
    @datCollectionDate							DATETIME = NULL,
	@intPositiveAnimalsQty						INT = NULL;

BEGIN    
	BEGIN TRY
		BEGIN TRANSACTION
			IF EXISTS (SELECT * FROM dbo.tlbMonitoringSession WHERE idfMonitoringSession = @idfMonitoringSession)
				BEGIN 
					UPDATE						dbo.tlbMonitoringSession   
					SET							idfsMonitoringSessionStatus = @idfsMonitoringSessionStatus,
												idfsCountry = @MonitoringSessionAddressidfsCountry,
												idfsRegion = @MonitoringSessionAddressidfsRegion,
												idfsRayon = @MonitoringSessionAddressidfsRayon,
												idfsSettlement = @MonitoringSessionAddressidfsSettlement,
												idfPersonEnteredBy = @idfPersonEnteredBy,
												idfCampaign = @idfCampaign,
												idfsSite = @idfsSite, 
												idfsDiagnosis = @idfsDiagnosis,
												datEnteredDate = @datEnteredDate,
												datStartDate = @datStartDate,
												datEndDate = @datEndDate,
												SessionCategoryID = @SessionCategoryID
					WHERE						idfMonitoringSession = @idfMonitoringSession;
					
					UPDATE						dbo.tlbCampaign
					SET							strCampaignName = @strCampaignName,
												idfsCampaignType = @idfsCampaignType,
												datCampaignDateStart = @datCampaignDateStart,
												datCampaignDateEnd = @datCampaignDateEnd
					WHERE						idfCampaign = @idfCampaign
				END    
			ELSE
				BEGIN    
					IF (ISNULL(@idfMonitoringSession, 0) <= 0)	
						EXEC					dbo.USP_GBL_NEXTKEYID_GET 'tlbMonitoringSession', @idfMonitoringSession OUTPUT;

					IF LEFT(ISNULL(@strMonitoringSessionID, '(new'), 4) = '(new'
						BEGIN
							EXEC				dbo.USP_GBL_NextNumber_GET 'Active Surveillance Session', @strMonitoringSessionID OUTPUT, NULL;
						END

					INSERT INTO					dbo.tlbMonitoringSession   
					(    
												idfMonitoringSession,
												idfsMonitoringSessionStatus,
												idfsCountry,
												idfsRegion,
												idfsRayon,
												idfsSettlement,
												idfPersonEnteredBy,
												idfCampaign,
												idfsSite, 
												idfsDiagnosis,
												datEnteredDate,
												strMonitoringSessionID,
												datStartDate,
												datEndDate,
												SessionCategoryID,
												LegacySessionID, 
												intRowStatus
					)    
					VALUES    
					(    
												@idfMonitoringSession,
												@idfsMonitoringSessionStatus,
												@MonitoringSessionAddressidfsCountry,
												@MonitoringSessionAddressidfsRegion,
												@MonitoringSessionAddressidfsRayon,
												@MonitoringSessionAddressidfsSettlement,
												@idfPersonEnteredBy,
												@idfCampaign,
												@idfsSite, 
												@idfsDiagnosis,
												@datEnteredDate,
												@strMonitoringSessionID,
												@datStartDate,
												@datEndDate,
												@SessionCategoryID,
												@AvianOrLivestock, 
												0
					);   
				END

			WHILE EXISTS						(SELECT * FROM @FarmsTemp)
			BEGIN
				SELECT TOP 1					@RecordID = RecordID, 
												@idfFarmTempID = idfFarmActual, 
												@idfFarm = idfFarm, 
												@idfFarmActual = idfFarmActual, 
												@strFarmCode = strFarmCode,
												@intSickAnimalQty = intSickAnimalQty,
												@intTotalAnimalQty = intTotalAnimalQty,
												@intDeadAnimalQty = intDeadAnimalQty,
												@intRowStatus = intRowStatus, 
												@RecordAction = RecordAction
				FROM							@FarmsTemp;
				
				IF								@RecordAction = 'D'
					BEGIN
					EXEC						dbo.USSP_GBL_FARM_DEL @idfFarm;
					END
				ELSE
					BEGIN
					IF							@RecordAction = 'I'
						BEGIN
						IF @AvianOrLivestock = 'Avian'
							BEGIN
							EXEC				dbo.USSP_GBL_FARM_COPY @idfFarmActual, @intTotalAnimalQty, @intSickAnimalQty, @intDeadAnimalQty, NULL, NULL, NULL, @idfMonitoringSession, @idfFarm OUTPUT;
							END
						ELSE
							BEGIN
							EXEC				dbo.USSP_GBL_FARM_COPY @idfFarmActual, NULL, NULL, NULL, @intTotalAnimalQty, @intSickAnimalQty, @intDeadAnimalQty, @idfMonitoringSession, @idfFarm OUTPUT;
							END
					
						UPDATE					@HerdsTemp SET idfFarm = @idfFarm WHERE idfFarmActual = @idfFarmTempID;
						UPDATE					@SummariesTemp SET idfFarm = @idfFarm WHERE idfFarm = @idfFarmTempID;
						END
					END

				DELETE FROM						@FarmsTemp WHERE RecordID = @RecordID;
			END;

			WHILE EXISTS						(SELECT * FROM @HerdsTemp)
			BEGIN
				SELECT TOP 1					@RecordID = RecordID, 
												@idfHerdTempID = idfHerd, 
												@idfHerd = idfHerd, 
												@idfHerdActual = idfHerdActual,
												@idfFarm = idfFarm, 
												@strHerdCode = strHerdCode,
												@intSickAnimalQty = intSickAnimalQty,
												@intTotalAnimalQty = intTotalAnimalQty,
												@intDeadAnimalQty = intDeadAnimalQty,
												@strNote = strNote, 
												@intRowStatus = intRowStatus, 
												@strMaintenanceFlag = strMaintenanceFlag, 
												@RecordAction = RecordAction
				FROM							@HerdsTemp;

				IF								@RecordAction = 'D'
				BEGIN
					EXEC						dbo.USSP_VET_HERD_DEL @idfHerd;
				END
				ELSE
				BEGIN
					--Suspicious place where "Herd" is getting prepended everytime a Vet Session is saved.
					--It appears to be coming from the application, but I can't track it down
					--For time sake, I'll have to perform this until I run accross where it is coming from
					--Doug Albanese 8-3-2018
					set @strHerdCode = Replace(@strHerdCode,'Herd ', '')
					EXEC						dbo.USSP_VET_HERD_SET 
												@LangID, 
												@idfHerd OUTPUT,
												@idfHerdActual,
												@idfFarm,
												@strHerdCode,
												@intSickAnimalQty,
												@intTotalAnimalQty,
												@intDeadAnimalQty,
												@strNote, 
												@intRowStatus, 
												@strMaintenanceFlag, 
												@RecordAction;

					UPDATE						@SpeciesTemp SET idfHerd = @idfHerd WHERE idfHerdActual = @idfHerdActual;
				END

				DELETE FROM						@HerdsTemp WHERE RecordID = @RecordID;
			END;

			WHILE EXISTS						(SELECT * FROM @SpeciesTemp)
			BEGIN
				SELECT TOP 1					@RecordID = RecordID, 
												@idfSpeciesTempID = idfSpecies, 
												@idfSpecies = idfSpecies, 
												@idfSpeciesActual = idfSpeciesActual,
												@idfsSpeciesType = idfsSpeciesType,
												@idfHerd = idfHerd,
												@idfObservation = idfObservation, 
												@datStartOfSignsDate = datStartOfSignsDate,
												@strAverageAge = strAverageAge,
												@intSickAnimalQty = intSickAnimalQty,
												@intTotalAnimalQty = intTotalAnimalQty,
												@intDeadAnimalQty = intDeadAnimalQty,
												@strNote = strNote, 
												@intRowStatus = intRowStatus, 
												@strMaintenanceFlag = strMaintenanceFlag, 
												@RecordAction = RecordAction
				FROM							@SpeciesTemp;

				IF								@RecordAction = 'D'
				BEGIN
					EXEC						dbo.USSP_VET_SPECIES_DEL @idfSpecies;
				END
				ELSE
				BEGIN
					EXEC						dbo.USSP_VET_SPECIES_SET 
												@LangID, 
												@idfSpecies OUTPUT, 
												@idfSpeciesActual,
												@idfsSpeciesType,
												@idfHerd, 
												@idfObservation, 
												@datStartOfSignsDate,
												@strAverageAge,
												@intSickAnimalQty,
												@intTotalAnimalQty,
												@intDeadAnimalQty,
												@strNote, 
												@intRowStatus, 
												@strMaintenanceFlag, 
												@RecordAction;
					
					IF @AvianOrLivestock = 'Livestock'
						BEGIN
						UPDATE					@AnimalsTemp SET idfSpecies = @idfSpecies WHERE idfSpecies = @idfSpeciesTempID;
						END

					UPDATE						@SamplesTemp SET idfSpecies = @idfSpecies WHERE idfSpecies = @idfSpeciesTempID;
					UPDATE						@SummariesTemp SET idfSpecies = @idfSpecies WHERE idfSpecies = @idfSpeciesTempID;
				END

				DELETE FROM						@SpeciesTemp WHERE RecordID = @RecordID;
			END;

			WHILE EXISTS						(SELECT * FROM @AnimalsTemp)
			BEGIN
				SELECT TOP 1					@idfAnimalTempID = idfAnimal,
												@idfAnimal = idfAnimal, 
												@idfsAnimalGender = idfsAnimalGender,
												@idfsAnimalAge = idfsAnimalAge, 
												@idfSpecies = idfSpecies, 
												@idfObservation = idfObservation, 
												@strDescription = strDescription,
												@strAnimalCode = strAnimalCode,
												@strName = strName, 
												@strColor = strColor,
												@intRowStatus = intRowStatus,
												@strMaintenanceFlag = strMaintenanceFlag, 
												@RecordAction = RecordAction
				FROM							@AnimalsTemp;

				IF								@RecordAction = 'D'
				BEGIN
					EXEC						dbo.USSP_VET_ANIMAL_DEL @idfAnimal;
				END
				ELSE
				BEGIN
					EXEC						dbo.USSP_VET_ANIMAL_SET 
												@LangID, 
												@idfAnimal OUTPUT,
												@idfsAnimalGender, 
												@idfsAnimalCondition,
												@idfsAnimalAge,
												@idfSpecies, 
												@idfObservation, 
												@strDescription, 
												@strAnimalCode, 
												@strName,
												@strColor,
												@intRowStatus, 
												@strMaintenanceFlag, 
												@RecordAction;

					UPDATE						@SamplesTemp SET idfAnimal = @idfAnimal WHERE idfAnimal = @idfAnimalTempID;
				END

				DELETE FROM						@AnimalsTemp WHERE idfAnimal = @idfAnimalTempID;
			END;

			WHILE EXISTS						(SELECT * FROM @SpeciesAndSamplesTemp)
			BEGIN
				SELECT TOP 1					@MonitoringSessionToSampleTypeTempID = MonitoringSessionToSampleType,
												@MonitoringSessionToSampleType = MonitoringSessionToSampleType,  
												@intOrder = intOrder, 
												@intRowStatus = intRowStatus, 
												@idfsSpeciesType = idfsSpeciesType, 
												@strMaintenanceFlag = strMaintenanceFlag, 
												@idfsSampleType = idfsSampleType, 
												@RecordAction = RecordAction
				FROM							@SpeciesAndSamplesTemp;

				IF								@RecordAction = 'D'
				BEGIN
					EXEC						dbo.USSP_VCT_MONITORINGSESSIONTOSAMPLETYPE_DEL @MonitoringSessionToSampleType;
				END
				ELSE
				BEGIN
					EXEC						dbo.USSP_VCT_MONITORINGSESSIONTOSAMPLETYPE_SET 
												@LangID, 
												@MonitoringSessionToSampleType OUTPUT, 
												@idfMonitoringSession, 
												@intOrder, 
												@intRowStatus, 
												@idfsSpeciesType, 
												@strMaintenanceFlag, 
												@idfsSampleType, 
												@RecordAction;
				END

				DELETE FROM						@SpeciesAndSamplesTemp WHERE MonitoringSessionToSampleType = @MonitoringSessionToSampleTypeTempID;
			END;

			WHILE EXISTS						(SELECT * FROM @SamplesTemp)
			BEGIN
				SELECT TOP 1					@idfMaterialTempID = idfMaterial, 
												@idfMaterial = idfMaterial, 
												@idfsSampleType = idfsSampleType, 
												@idfRootMaterial = idfRootMaterial, 
												@idfParentMaterial = idfParentMaterial, 
												@idfSpecies = idfSpecies, 
												@idfAnimal = idfAnimal, 
												@idfFieldCollectedByPerson = idfFieldCollectedByPerson, 
												@idfFieldCollectedByOffice = idfFieldCollectedByOffice, 
												@idfMainTest = idfMainTest, 
												@datFieldCollectionDate = datFieldCollectionDate, 
												@datFieldSentDate = datFieldSentDate, 
												@strFieldBarcode = strFieldBarcode, 
												@idfsSampleStatus = idfsSampleStatus, 
												@idfInDepartment = idfInDepartment, 
												@idfDestroyedByPerson = idfDestroyedByPerson, 
												@datEnteringDate = datEnteringDate, 
												@datDestructionDate = datDestructionDate, 
												@strBarcode = strBarcode, 
												@strNote = strNote, 
												@idfsSite = idfsSite, 
												@intRowStatus = intRowStatus, 
												@idfSendToOffice = idfSendToOffice, 
												@blnReadOnly = blnReadOnly, 
												@idfsBirdStatus = idfsBirdStatus, 
												@datAccession = datAccession, 
												@idfsAccessionCondition = idfsAccessionCondition, 
												@strCondition = strCondition, 
												@idfAccesionByPerson = idfAccesionByPerson, 
												@idfsDestructionMethod = idfsDestructionMethod, 
												@idfsCurrentSite = idfsCurrentSite, 
												@idfsSampleKind = idfsSampleKind, 
												@idfMarkedForDispositionByPerson = idfMarkedForDispositionByPerson, 
												@datOutOfRepositoryDate = datOutOfRepositoryDate, 
												@strMaintenanceFlag = strMaintenanceFlag, 
												@RecordAction = RecordAction
				FROM							@SamplesTemp;

				IF								@RecordAction = 'D'
				BEGIN
					EXEC						dbo.USSP_GBL_MATERIAL_DEL @idfMaterial;
				END
				ELSE
				BEGIN
					EXEC						dbo.USSP_GBL_MATERIAL_SET 
												@LangID, 
												@idfMaterial OUTPUT, 
												@idfsSampleType, 
												@idfRootMaterial, 
												@idfParentMaterial, 
												NULL, 
												@idfSpecies, 
												@idfAnimal, 
												@idfMonitoringSession, 
												@idfFieldCollectedByPerson, 
												@idfFieldCollectedByOffice, 
												@idfMainTest, 
												@datFieldCollectionDate, 
												@datFieldSentDate, 
												@strFieldBarcode, 
												NULL, 
												NULL, 
												NULL, 
												NULL, 
												NULL, 
												@idfsSampleStatus, 
												@idfInDepartment, 
												@idfDestroyedByPerson, 
												@datEnteringDate, 
												@datDestructionDate, 
												@strBarcode, 
												@strNote, 
												@idfsSite, 
												@intRowStatus, 
												@idfSendToOffice, 
												@blnReadOnly, 
												@idfsBirdStatus, 
												NULL, 
												@idfVetCase,
												@datAccession, 
												@idfsAccessionCondition, 
												@strCondition, 
												@idfAccesionByPerson, 
												@idfsDestructionMethod, 
												@idfsCurrentSite, 
												@idfsSampleKind, 
												@idfMarkedForDispositionByPerson, 
												@datOutOfRepositoryDate, 
												@strMaintenanceFlag, 
												@RecordAction;

						UPDATE					@LabTestsTemp SET idfMaterial = @idfMaterial WHERE idfMaterial = @idfMaterialTempID;
				END

				DELETE FROM						@SamplesTemp WHERE idfMaterial = @idfMaterialTempID;
			END;

			WHILE EXISTS						(SELECT * FROM @LabTestsTemp)
			BEGIN
				SELECT TOP 1					@idfTestingTempID = idfTesting,
												@idfTesting = idfTesting, 
												@idfsTestName = idfsTestName,
												@idfsTestCategory = idfsTestCategory, 
												@idfsTestResult = idfsTestResult, 
												@idfsTestStatus = intRowStatus, 
												@idfsDiagnosis = idfsDiagnosis,
												@idfMaterial = idfMaterial,
												@idfObservation = idfObservation, 
												@intTestNumber = intTestNumber,
												@strNote = strNote, 
												@intRowStatus = intRowStatus, 
												@datStartedDate = datStartedDate, 
												@datConcludedDate = datConcludedDate, 
												@idfTestedByOffice = idfTestedByOffice, 
												@idfTestedByPerson = idfTestedByPerson, 
												@idfResultEnteredByOffice = idfResultEnteredByOffice, 
												@idfResultEnteredByPerson = idfResultEnteredByPerson, 
												@idfValidatedByOffice = idfValidatedByOffice, 
												@idfValidatedByPerson = idfValidatedByPerson, 
												@blnReadOnly = blnReadOnly, 
												@blnNonLaboratoryTest = blnNonLaboratoryTest, 
												@blnExternalTest = blnExternalTest, 
												@idfPerformedByOffice = idfPerformedByOffice, 
												@datReceivedDate = datReceivedDate, 
												@strContactPerson = strContactPerson,
												@strMaintenanceFlag = strMaintenanceFlag, 
												@RecordAction = RecordAction
				FROM							@LabTestsTemp;

				IF								@RecordAction = 'D'
				BEGIN
					EXEC						dbo.USSP_GBL_TESTING_DEL @idfTesting;
				END
				ELSE
				BEGIN
					EXEC						dbo.USSP_GBL_TESTING_SET 
												@LangID, 
												@idfTesting OUTPUT, 
												@idfsTestName,
												@idfsTestCategory, 
												@idfsTestResult, 
												@idfsTestStatus, 
												@idfsDiagnosis,
												@idfMaterial,
												NULL, 
												@idfObservation, 
												@intTestNumber,
												@strNote, 
												@intRowStatus, 
												@datStartedDate, 
												@datConcludedDate, 
												@idfTestedByOffice, 
												@idfTestedByPerson, 
												@idfResultEnteredByOffice, 
												@idfResultEnteredByPerson, 
												@idfValidatedByOffice, 
												@idfValidatedByPerson, 
												@blnReadOnly, 
												@blnNonLaboratoryTest, 
												@blnExternalTest, 
												@idfPerformedByOffice, 
												@datReceivedDate, 
												@strContactPerson,
												@strMaintenanceFlag, 
												@RecordAction;
				END

				IF @RecordAction = 'I'
					BEGIN
					UPDATE						@InterpretationsTemp SET idfTesting = @idfTesting WHERE idfTesting = @idfTestingTempID;
					END

				DELETE FROM						@LabTestsTemp WHERE idfTesting = @idfTestingTempID;
			END;

			WHILE EXISTS						(SELECT * FROM @InterpretationsTemp)
			BEGIN
				SELECT TOP 1					@idfTestValidationTempID = idfTestValidation,
												@idfTestValidation = idfTestValidation, 
												@idfsDiagnosis = idfsDiagnosis,
												@idfsInterpretedStatus = idfsInterpretedStatus, 
												@idfValidatedByOffice = idfValidatedByOffice, 
												@idfValidatedByPerson = idfValidatedByPerson, 
												@idfInterpretedByOffice = idfInterpretedByOffice,
												@idfInterpretedByPerson = idfInterpretedByPerson,
												@idfTesting = idfTesting, 
												@blnValidateStatus = blnValidateStatus,
												@blnCaseCreated = blnCaseCreated, 
												@strValidateComment = strValidateComment, 
												@strInterpretedComment = strInterpretedComment, 
												@datValidationDate = datValidationDate, 
												@datInterpretationDate = datInterpretationDate, 
												@intRowStatus = intRowStatus, 
												@blnReadOnly = blnReadOnly, 
												@strMaintenanceFlag = strMaintenanceFlag, 
												@RecordAction = RecordAction
				FROM							@InterpretationsTemp;

				IF								@RecordAction = 'D'
				BEGIN
					EXEC						dbo.USSP_GBL_TEST_VALIDATION_DEL @idfTestValidation;
				END
				ELSE
				BEGIN
					EXEC						dbo.USSP_GBL_TEST_VALIDATION_SET 
												@LangID, 
												@idfTestValidation OUTPUT, 
												@idfsDiagnosis,
												@idfsInterpretedStatus, 
												@idfValidatedByOffice, 
												@idfValidatedByPerson, 
												@idfInterpretedByOffice,
												@idfInterpretedByPerson,
												@idfTesting, 
												@blnValidateStatus,
												@blnCaseCreated, 
												@strValidateComment, 
												@strInterpretedComment, 
												@datValidationDate, 
												@datInterpretationDate, 
												@intRowStatus, 
												@blnReadOnly, 
												@strMaintenanceFlag, 
												@RecordAction;
				END

				DELETE FROM						@InterpretationsTemp WHERE idfTestValidation = @idfTestValidationTempID;
			END;

			WHILE EXISTS						(SELECT * FROM @ActionsTemp)
			BEGIN
				SELECT TOP 1					@idfMonitoringSessionActionTempID = idfMonitoringSessionAction,
												@idfMonitoringSessionAction = idfMonitoringSessionAction, 
												@idfPersonEnteredBy = idfPersonEnteredBy,
												@idfsMonitoringSessionActionType = idfsMonitoringSessionActionType,
												@idfsMonitoringSessionActionStatus = idfsMonitoringSessionActionStatus,
												@datActionDate = datActionDate,
												@strComments = strComments,
												@intRowStatus = intRowStatus,
												@strMaintenanceFlag = strMaintenanceFlag,
												@RecordAction = RecordAction
				FROM							@ActionsTemp;

				IF								@RecordAction = 'D'
				BEGIN
					EXEC						dbo.USSP_VCT_MONITORINGSESSION_ACTION_DEL @idfMonitoringSessionAction;
				END
				ELSE
				BEGIN
					EXEC						dbo.USSP_VCT_MONITORINGSESSION_ACTION_SET 
												@LangID, 
												@idfMonitoringSessionAction OUTPUT,
												@idfMonitoringSession,
												@idfPersonEnteredBy,
												@idfsMonitoringSessionActionType,
												@idfsMonitoringSessionActionStatus,
												@datActionDate,
												@strComments,
												@intRowStatus,
												@strMaintenanceFlag,
												@RecordAction 
				END

				DELETE FROM						@ActionsTemp WHERE idfMonitoringSessionAction = @idfMonitoringSessionActionTempID;
			END;

			WHILE EXISTS						(SELECT * FROM @SummariesTemp)
			BEGIN
				SELECT TOP 1					@idfMonitoringSessionSummaryTempID = idfMonitoringSessionSummary,
												@idfMonitoringSessionSummary = idfMonitoringSessionSummary, 
												@idfFarm = idfFarm,
												@idfSpecies = idfSpecies,
												@idfsAnimalSex = idfsAnimalSex,
												@intSampledAnimalsQty = intSampledAnimalsQty,
												@intSamplesQty = intSamplesQty,
												@datCollectionDate = datCollectionDate,
												@intPositiveAnimalsQty = intPositiveAnimalsQty,
												@intRowStatus = intRowStatus,
												@strMaintenanceFlag = strMaintenanceFlag,
												@idfsDiagnosis = idfsDiagnosis,
												@idfsSampleType = idfsSampleType,
												@RecordAction = RecordAction
				FROM							@SummariesTemp;

				IF								@RecordAction = 'D'
				BEGIN
					EXEC						dbo.USSP_VCT_MONITORINGSESSION_SUMMARY_DEL @idfMonitoringSessionSummary;
					EXEC						dbo.USSP_VCT_MONITORINGSESSIONSUMMARY_DIAGNOSIS_DEL @idfMonitoringSessionSummary, @idfsDiagnosis;
					EXEC						dbo.USSP_VCT_MONITORINGSESSIONSUMMARY_SAMPLE_DEL @idfMonitoringSessionSummary, @idfsSampleType;
				END
				ELSE
				BEGIN
					EXEC						dbo.USSP_VCT_MONITORINGSESSION_SUMMARY_SET 
												@LangID, 
												@idfMonitoringSessionSummary OUTPUT,
												@idfMonitoringSession,
												@idfFarm,
												@idfSpecies,
												@idfsAnimalSex,
												@intSampledAnimalsQty,
												@intSamplesQty,
												@datCollectionDate,
												@intPositiveAnimalsQty,
												@intRowStatus,
												@strMaintenanceFlag,
												@idfsDiagnosis,
												@idfsSampleType,
												@RecordAction
				END

				DELETE FROM						@SummariesTemp WHERE idfMonitoringSessionSummary = @idfMonitoringSessionSummaryTempID;
			END;
    
		IF @@TRANCOUNT > 0 
			COMMIT;

		SELECT									@returnCode, @returnMsg;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT = 1 
			ROLLBACK;
		
		SET										@returnCode = ERROR_NUMBER();
		SET										@returnMsg = 
													'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
													+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
													+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
													+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
													+ ' ErrorLine: ' +  CONVERT(VARCHAR, ISNULL(ERROR_LINE(), ''))
													+ ' ErrorMessage: '+ ERROR_MESSAGE();

		SELECT									@returnCode, @returnMsg;
	END CATCH

END


