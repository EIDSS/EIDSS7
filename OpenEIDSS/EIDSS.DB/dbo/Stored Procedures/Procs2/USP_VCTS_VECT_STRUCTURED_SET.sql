--*************************************************************
-- Name 				: USP_VCTS_VECT_STRUCTURED_SET
-- Description			: SET Vector details with Sample and FieldTest User Defined Table Types
--          
-- Author               : Harold Pryor
-- Revision History
--		Name       Date       Change Detail
--  Harold Pryor  05/11/2018   Initial Creation
--  Harold Pryor  05/16/2018 Removed @AccessionDate 
--  Harold Pryor  05/29/2018 Updated to pass @idfTestedByOffice, @idfTestedByPerson and @idfsTestResult values to dbo.USSP_GBL_TESTING_SET 
--  Harold Pryor  6/13/2018  Updated save geolocation using dbo.USP_GBL_ADDRESS_SET and also save idfsGeoLocationType
--  Harold Pryor  6/20/2018  Updated to properly save FieldTest with default idfMaterial when @idfMaterial parameter is null
--  Harold Pryor  6/20/2018  Updated to properly save Sample from dbo.tlbVectorSampleGetListSPType @strFieldBarcode to dbo.USSP_GBL_MATERIAL_SET  
--
-- Testing code:
--EXECUTE [USP_VCTS_VECT_STRUCTURED_SET] 
--      @idfVector, 
--      @idfVectorSurveillanceSession, 
--      @idfHostVector, 
--      @strVectorID, 
--      @strFieldVectorID, 
--      @idfLocation , 
--      @intElevation , 
--      @idfsSurrounding , 
--      @strGEOReferenceSources , 
--      @idfCollectedByOffice , 
--      @idfCollectedByPerson , 
--      @datCollectionDateTime , 
--      @intCollectionEffort , 
--      @idfsCollectionMethod , 
--      @idfsBASisOfRecord , 
--      @idfsVectorType , 
--      @idfsVectorSubType , 
--      @intQuantity , 
--      @idfsSex , 
--      @idfIdentIFiedByOffice , 
--      @idfIdentIFiedByPerson , 
--      @datIdentIFiedDateTime , 
--      @idfsIdentIFicationMethod , 
--      @idfObservation, 
--*************************************************************
CREATE PROCEDURE [dbo].[USP_VCTS_VECT_STRUCTURED_SET]
(
    @LangID									NVARCHAR(50) = NULL, 
    @idfVector								BIGINT, 
    @idfsDetailedVectorSurveillanceSession	BIGINT, 
    @idfHostVector							BIGINT, 
    @strVectorID							NVARCHAR(50), 
    @strFieldVectorID						NVARCHAR(50), 
    @idfDetailedLocation					BIGINT, 
	@lucDetailedCollectionidfsResidentType	BIGINT	= NULL,
	@lucDetailedCollectionidfsGroundType	BIGINT = NULL,
	@lucDetailedCollectionidfsGeolocationType	BIGINT = 10036001,
	@lucDetailedCollectionidfsCountry		BIGINT = NULL,
	@lucDetailedCollectionidfsRegion		BIGINT = NULL,
	@lucDetailedCollectionidfsRayon			BIGINT = NULL,
	@lucDetailedCollectionidfsSettlement	BIGINT = NULL,
	@lucDetailedCollectionstrApartment		NVARCHAR(200) = NULL,
	@lucDetailedCollectionstrBuilding		NVARCHAR(200) = NULL,
	@lucDetailedCollectionstrStreetName		NVARCHAR(200) = NULL,
	@lucDetailedCollectionstrHouse			NVARCHAR(200) = NULL,
	@lucDetailedCollectionstrPostCode		NVARCHAR(200) = NULL,
	@lucDetailedCollectionstrDescription	NVARCHAR(200) = NULL,
	@lucDetailedCollectiondblDistance		FLOAT = NULL,
    @lucDetailedCollectionstrLatitude		FLOAT = NULL,
    @lucDetailedCollectionstrLongitude		FLOAT = NULL,
	@lucDetailedCollectiondblAccuracy		FLOAT = NULL,
	@lucDetailedCollectiondblAlignment		FLOAT = NULL,
	@blnForeignAddress						BIT = 0,
	@strForeignAddress						NVARCHAR(200) = NULL,
	@blnGeoLocationShared					BIT = 0, 
    @intDetailedElevation					INT, 
	@DetailedSurroundings					BIGINT, 
    @strGEOReferenceSource					NVARCHAR(500), 
    @idfCollectedByOffice					BIGINT, 
    @idfCollectedByPerson					BIGINT, 
    @datCollectionDateTime					DATETIME, 
    --@intCollectionEffort int, 
    @idfsCollectionMethod					BIGINT, 
    @idfsBasisOfRecord						BIGINT, 
    @idfDetailedVectorType					BIGINT, 
    @idfsVectorSubType						BIGINT, 
    @intQuantity							INT, 
    @idfsSex								BIGINT, 
    @idfIdentIFiedByOffice					BIGINT, 
    @idfIdentIFiedByPerson					BIGINT, 
    @datIdentIFiedDateTime					DATETIME, 
    @idfsIdentIFicationMethod				BIGINT, 
    @idfObservation							BIGINT,
	@idfsFormTemplate						BIGINT,
	@idfsDayPeriod							BIGINT,
	@strComment								NVARCHAR(500),
	@idfsEctoparASitesCollected				BIGINT,        
	@Sample                                 tlbVectorSampleGetListSPType ReadOnly,
	@FieldTest                              tlbVectorFieldTestGetListSPType ReadOnly
)
AS 
DECLARE @returnCode							INT = 0 
DECLARE	@returnMsg							NVARCHAR(max) = 'SUCCESS' 

DECLARE @intRowStatus INT = 0,
		@datFieldCollectionDate datetime = GetDate(),
		@datFieldSentDate datetime  = GetDate(),
		@RecordAction NCHAR(1) = 'I',
		@idfsSite INT = 1	

DECLARE @datReceivedDate datetime = GetDate(),
		@datStartDate datetime = GetDate(),
		@idfsTestStatus INT = 10001005,	-- default set to Not Started 	
		@blnReadOnly    BIT = 0, 
		@blnNonLaboratory   BIT = 0

		
DECLARE @idfMaterial                    BIGINT
DECLARE	@idfsSampleType					BIGINT
DECLARE	@idfVectorSurveillanceSession	BIGINT
DECLARE	@idfSendToOffice				BIGINT = NULL
DECLARE	@idfFieldCollectedByOffice		BIGINT = NULL

DECLARE @idfTesting						BIGINT 
DECLARE @strFieldBarCode				varchar(50)
DECLARE	@idfsTestName					BIGINT = NULL
DECLARE	@idfsTestCategory				BIGINT = NULL
DECLARE	@idfTestedByOffice				BIGINT = NULL
DECLARE	@idfsTestResult					BIGINT = NULL
DECLARE @idfTestedByPerson				BIGINT = NULL
DECLARE @idfsDiagnosis					BIGINT = NULL

DECLARE	@SampleTemp							dbo.tlbVectorSampleGetListSPType;
INSERT INTO									@SampleTemp SELECT * FROM @Sample;

DECLARE	@SampleHold							dbo.tlbVectorSampleGetListSPType;
INSERT INTO									@SampleHold SELECT * FROM @Sample;

DECLARE	@FieldTestTemp						dbo.tlbVectorFieldTestGetListSPType;
INSERT INTO									@FieldTestTemp SELECT * FROM @FieldTest;

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		-- Create GeoLocation
			EXEC dbo.USP_GBL_ADDRESS_SET 	@idfDetailedLocation OUTPUT,
											@lucDetailedCollectionidfsResidentType,
											@lucDetailedCollectionidfsGroundType,
											@lucDetailedCollectionidfsGeolocationType,
											@lucDetailedCollectionidfsCountry,
											@lucDetailedCollectionidfsRegion,
											@lucDetailedCollectionidfsRayon,
											@lucDetailedCollectionidfsSettlement,
											@lucDetailedCollectionstrApartment,
											@lucDetailedCollectionstrBuilding,
											@lucDetailedCollectionstrStreetName,
											@lucDetailedCollectionstrHouse,
											@lucDetailedCollectionstrPostCode,
											@lucDetailedCollectionstrDescription,
											@lucDetailedCollectiondblDistance,
											@lucDetailedCollectionstrLatitude,
											@lucDetailedCollectionstrLongitude,
											@lucDetailedCollectiondblAccuracy,
											@lucDetailedCollectiondblAlignment,
											@blnForeignAddress,
											@strForeignAddress,
											@blnGeoLocationShared,
											@returnCode,
											@returnMsg

		IF NOT EXISTS( SELECT idfObservation from dbo.tlbObservation where idfObservation = 0 )
		BEGIN		 
			Insert into [dbo].[tlbObservation]
			(idfObservation, idfsFormTemplate, intRowStatus, rowguid, strMaintenanceFlag, strReservedAttribute, idfsSite) 
			values (0, null, 0, NEWID(), null, null, 1)
		END

		EXEC dbo.USP_FLEXFORMS_OBSERVATIONS_SET @idfObservation, @idfsFormTemplate

		IF NOT EXISTS( SELECT * FROM dbo.tlbVector WHERE idfVector = @idfVector)	
			BEGIN
				IF ISNULL(@idfVector,-1)<0
				BEGIN
					EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbVector', @idfVector OUTPUT
				END
				IF LEFT(ISNULL(@strVectorID, '(new'),4) = '(new'
				BEGIN
					EXEC dbo.USP_GBL_NextNumber_GET 10057030, @strVectorID OUTPUT , NULL --N'AS Session'
				END

				INSERT INTO dbo.tlbVector
						   (idfVector, 
							idfVectorSurveillanceSession, 
							idfHostVector, 
							strVectorID, 
							strFieldVectorID, 
							idfLocation, 
							intElevation, 
							idfsSurrounding, 
							strGEOReferenceSources, 
							idfCollectedByOffice, 
							idfCollectedByPerson, 
							datCollectionDateTime, 
							--intCollectionEffort, 
							idfsCollectionMethod, 
							idfsBASisOfRecord, 
							idfsVectorType, 
							idfsVectorSubType, 
							intQuantity, 
							idfsSex, 
							idfIdentIFiedByOffice, 
							idfIdentIFiedByPerson, 
							datIdentIFiedDateTime, 
							idfsIdentIFicationMethod, 
							idfObservation
							,idfsDayPeriod
							,strComment
							,idfsEctoparASitesCollected
						   )
					 VALUES
						   (
							@idfVector, 
							@idfsDetailedVectorSurveillanceSession, 
							@idfHostVector, 
							@strVectorID, 
							@strFieldVectorID, 
							@idfDetailedLocation, 
							@intDetailedElevation, 
							@DetailedSurroundings, 
							@strGEOReferenceSource, 
							@idfCollectedByOffice, 
							@idfCollectedByPerson, 
							@datCollectionDateTime, 
							--@intCollectionEffort, 
							@idfsCollectionMethod, 
							@idfsBASisOfRecord, 
							@idfDetailedVectorType, 
							@idfsVectorSubType, 
							@intQuantity, 
							@idfsSex, 
							@idfIdentifiedByOffice, 
							@idfIdentIFiedByPerson, 
							@datIdentIFiedDateTime, 
							@idfsIdentIFicationMethod, 
							@idfObservation,
							@idfsDayPeriod,
							@strComment,
							@idfsEctoparASitesCollected
						   )
			END
		ELSE 
			BEGIN
				UPDATE dbo.tlbVector
				   SET 
							idfVectorSurveillanceSession = @idfsDetailedVectorSurveillanceSession, 
							idfHostVector = @idfHostVector, 
							strVectorID = @strVectorID, 
							strFieldVectorID = @strFieldVectorID, 
							idfLocation = @idfDetailedLocation, 
							intElevation = @intDetailedElevation, 
							idfsSurrounding = @DetailedSurroundings, 
							strGEOReferenceSources = @strGEOReferenceSource, 
							idfCollectedByOffice = @idfCollectedByOffice, 
							idfCollectedByPerson = @idfCollectedByPerson, 
							datCollectionDateTime = @datCollectionDateTime, 
							--intCollectionEffort = @intCollectionEffort, 
							idfsCollectionMethod = @idfsCollectionMethod, 
							idfsBASisOfRecord = @idfsBASisOfRecord, 
							idfsVectorType = @idfDetailedVectorType, 
							idfsVectorSubType = @idfsVectorSubType, 
							intQuantity = @intQuantity, 
							idfsSex = @idfsSex, 
							idfIdentIFiedByOffice = @idfIdentifiedByOffice, 
							idfIdentIFiedByPerson = @idfIdentIFiedByPerson, 
							datIdentIFiedDateTime = @datIdentIFiedDateTime, 
							idfsIdentIFicationMethod =@idfsIdentIFicationMethod , 
							idfObservation = @idfObservation,
							idfsDayPeriod = @idfsDayPeriod,
							strComment = @strComment,
							idfsEctoparASitesCollected = @idfsEctoparASitesCollected
				 WHERE 		idfVector = @idfVector
			END

			WHILE EXISTS (SELECT * FROM @SampleTemp where RecordAction <> '')
				BEGIN
					SELECT TOP 1					@idfMaterial = idfMaterial,
													@strFieldBarcode = strFieldBarcode,
													@idfsSampleType = idfsSampleType,
												    @idfVectorSurveillanceSession = idfVectorSurveillanceSession,
													@idfSendToOffice = idfSendToOffice,				
													@idfFieldCollectedByOffice = idfSendToOffice,
													@RecordAction = RecordAction 

					FROM @SampleTemp where RecordAction <> '';	

						IF @RecordAction = 'I'	
						BEGIN
						   set @idfMaterial = null
						END
						
						 EXEC				dbo.USSP_GBL_MATERIAL_SET 
											@LangID, 
											@idfMaterial , 
											@idfsSampleType,
											null, 
											null,  
											NULL, 
											null,  
											null, 
											null, 
											null, 
											@idfFieldCollectedByOffice,
											null,  
											@datFieldCollectionDate, 
											@datFieldSentDate, 
											@strFieldBarcode, 
											NULL, 
											NULL, 
											@idfVectorSurveillanceSession, 
											@idfVector, 
											NULL, 
											null, 
											null, 
											null, 
											null, 
											null, 
											null, 
											null, 
											@idfsSite, 
											@intRowStatus, 
											@idfSendToOffice, 
											0, 
											null, 
											NULL, 
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
											@RecordAction;							
					
					DELETE TOP (1) FROM @SampleTemp
				END;

				set @strFieldBarcode = null
				WHILE EXISTS (SELECT * FROM @FieldTestTemp where RecordAction <> '')
				BEGIN
					SELECT TOP 1				@idfTesting = idfTesting,
					                            @strFieldBarCode = strFieldBarCode,
												@idfsTestName = idfsTestName,
												@idfsTestCategory = idfsTestCategory, 
												@idfTestedByOffice = @idfTestedByOffice,	
												@idfsTestResult = idfsTestResult,	
												@idfTestedByPerson = idfTestedByPerson,
												@idfsDiagnosis = idfsDiagnosis,
												@RecordAction = RecordAction 

					FROM @FieldTestTemp where RecordAction <> ''

					If @strFieldBarCode is  null
						   BEGIN
						     SELECT TOP 1 @idfMaterial = idfMaterial
								FROM [dbo].[tlbMaterial] where strFieldBarCode = @strFieldBarCode
						   END

					IF @RecordAction = 'I'	
						BEGIN
						   set @idfTesting = null						   				   

						   If @idfmaterial is null
							BEGIN
								SELECT TOP 1 @idfMaterial = idfMaterial
								FROM @SampleHold where idfMaterial is not null 
							END
						END

						set @idfObservation = 0

						EXEC				dbo.USSP_GBL_TESTING_SET 
											@LangID, 
											@idfTesting , 
											@idfsTestName,
											@idfsTestCategory, 
											@idfsTestResult, 
											@idfsTestStatus, 
											@idfsDiagnosis, 
											@idfmaterial, 
											null, 
											@idfObservation, 
											null,
											null,
											@intRowStatus, 
											@datStartDate,  
											null,  
											@idfTestedByOffice, 
											@idfTestedByPerson,  
											null, 
											null, 
											null,   
											null, 
											@blnReadOnly, 
											@blnNonLaboratory, 
											null, 
											null, 											
											@datReceivedDate, 											
											null, 
											null, 
											@RecordAction;	           

                DELETE TOP (1) FROM @FieldTestTemp
				END;

		IF @@TRANCOUNT > 0 AND @returnCode =0
			COMMIT

		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage' ,@idfVector 'idfVector' ,@strVectorID 'strVectorID'
	END TRY

	BEGIN CATCH
		Throw;

	END CATCH

END
