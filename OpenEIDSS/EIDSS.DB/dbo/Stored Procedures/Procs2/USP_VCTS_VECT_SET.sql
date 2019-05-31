--*************************************************************
-- Name 				: USP_VCTS_VECT_SET
-- Description			: SET Vector details
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--  Harold Pryor  6/13/2018   Updated save geolocation using dbo.USP_GBL_ADDRESS_SET and also save idfsGeoLocationType
--
-- Testing code:
--EXECUTE [USP_VCTS_VECT_SET] 
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
--      @idfObservation 
--*************************************************************
CREATE PROCEDURE [dbo].[USP_VCTS_VECT_SET]
(
    @idfVector								BIGINT OUTPUT, 
    @idfsDetailedVectorSurveillanceSession	BIGINT, 
    @idfHostVector							BIGINT, 
    @strVectorID							NVARCHAR(50) OUTPUT, 
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
	@idfsEctoparASitesCollected				BIGINT
)
AS 
DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 

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
		IF @@TRANCOUNT > 0 AND @returnCode =0
			COMMIT

		SELECT @returnCode, @returnMsg
	END TRY

	BEGIN CATCH
			IF @@Trancount > 0
				ROLLBACK
				SET @returnCode = ERROR_NUMBER()
				SET @returnMsg = 
			   'ErrorNumber: ' + convert(varchar, ERROR_NUMBER() ) 
			   + ' ErrorSeverity: ' + convert(varchar, ERROR_SEVERITY() )
			   + ' ErrorState: ' + convert(varchar,ERROR_STATE())
			   + ' ErrorProcedure: ' + isnull(ERROR_PROCEDURE() ,'')
			   + ' ErrorLine: ' +  convert(varchar,isnull(ERROR_LINE() ,''))
			   + ' ErrorMessage: '+ ERROR_MESSAGE()
			   ----SELECT @LogErrMsg

			  SELECT @returnCode, @returnMsg

	END CATCH
END
