

--##SUMMARY Posts data from Vector form

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 18.07.2011

--##RETURNS Doesn't use



/*
--Example of procedure call:
declare 
@Action int,
@idfVector bigint, 
@idfVectorSurveillanceSession bigint, 
@idfHostVector bigint, 
@strVectorID nvarchar(50), 
@strFieldVectorID nvarchar(50), 
@idfLocation bigint, 
@intElevation int, 
@idfsSurrounding bigint, 
@strGEOReferenceSources nvarchar(500), 
@idfCollectedByOffice bigint, 
@idfCollectedByPerson bigint, 
@datCollectionDateTime datetime, 
@intCollectionEffort int, 
@idfsCollectionMethod bigint, 
@idfsBasisOfRecord bigint, 
@idfsVectorType bigint, 
@idfsVectorSubType bigint, 
@intQuantity int, 
@idfsSex bigint, 
@idfIdentifiedByOffice bigint, 
@idfIdentifiedByPerson bigint, 
@datIdentifiedDateTime datetime, 
@idfsIdentificationMethod bigint, 
@idfObservation bigint



EXECUTE [spVector_Post] 
      @Action,
      @idfVector, 
      @idfVectorSurveillanceSession, 
      @idfHostVector, 
      @strVectorID, 
      @strFieldVectorID, 
      @idfLocation , 
      @intElevation , 
      @idfsSurrounding , 
      @strGEOReferenceSources , 
      @idfCollectedByOffice , 
      @idfCollectedByPerson , 
      @datCollectionDateTime , 
      @intCollectionEffort , 
      @idfsCollectionMethod , 
      @idfsBasisOfRecord , 
      @idfsVectorType , 
      @idfsVectorSubType , 
      @intQuantity , 
      @idfsSex , 
      @idfIdentifiedByOffice , 
      @idfIdentifiedByPerson , 
      @datIdentifiedDateTime , 
      @idfsIdentificationMethod , 
      @idfObservation 

*/


create         PROCEDURE [dbo].[spVector_Post](
			@Action INT,  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
      @idfVector bigint, 
      @idfVectorSurveillanceSession bigint, 
      @idfHostVector bigint, 
      @strVectorID nvarchar(50), 
      @strFieldVectorID nvarchar(50), 
      @idfLocation bigint, 
      @intElevation int, 
      @idfsSurrounding bigint, 
      @strGEOReferenceSources nvarchar(500), 
      @idfCollectedByOffice bigint, 
      @idfCollectedByPerson bigint, 
      @datCollectionDateTime datetime, 
      --@intCollectionEffort int, 
      @idfsCollectionMethod bigint, 
      @idfsBasisOfRecord bigint, 
      @idfsVectorType bigint, 
      @idfsVectorSubType bigint, 
      @intQuantity int, 
      @idfsSex bigint, 
      @idfIdentifiedByOffice bigint, 
      @idfIdentifiedByPerson bigint, 
      @datIdentifiedDateTime datetime, 
      @idfsIdentificationMethod bigint, 
      @idfObservation bigint,
	  @idfsFormTemplate bigint,
	  @idfsDayPeriod Bigint,
	  @strComment nvarchar(500),
	  @idfsEctoparasitesCollected Bigint
)
AS Begin

Exec dbo.spObservation_Post @idfObservation, @idfsFormTemplate

IF @Action = 4
BEGIN
	IF ISNULL(@idfVector,-1)<0
	BEGIN
		EXEC spsysGetNewID @idfVector OUTPUT
	END
	IF LEFT(ISNULL(@strVectorID, '(new'),4) = '(new'
	BEGIN
		EXEC dbo.spGetNextNumber 10057030, @strVectorID OUTPUT , NULL --N'AS Session'
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
			    idfsBasisOfRecord, 
			    idfsVectorType, 
			    idfsVectorSubType, 
			    intQuantity, 
			    idfsSex, 
			    idfIdentifiedByOffice, 
			    idfIdentifiedByPerson, 
			    datIdentifiedDateTime, 
			    idfsIdentificationMethod, 
			    idfObservation
			    ,idfsDayPeriod
			    ,strComment
				,idfsEctoparasitesCollected
			   )
		 VALUES
			   (
			    @idfVector, 
			    @idfVectorSurveillanceSession, 
			    @idfHostVector, 
			    @strVectorID, 
			    @strFieldVectorID, 
			    @idfLocation, 
			    @intElevation, 
			    @idfsSurrounding, 
			    @strGEOReferenceSources, 
			    @idfCollectedByOffice, 
			    @idfCollectedByPerson, 
			    @datCollectionDateTime, 
			    --@intCollectionEffort, 
			    @idfsCollectionMethod, 
			    @idfsBasisOfRecord, 
			    @idfsVectorType, 
			    @idfsVectorSubType, 
			    @intQuantity, 
			    @idfsSex, 
			    @idfIdentifiedByOffice, 
			    @idfIdentifiedByPerson, 
			    @datIdentifiedDateTime, 
			    @idfsIdentificationMethod, 
			    @idfObservation,
			    @idfsDayPeriod,
			    @strComment,
				@idfsEctoparasitesCollected
			   )
	
END
ELSE IF @Action=16
BEGIN
	UPDATE dbo.tlbVector
	   SET 
			    idfVectorSurveillanceSession = @idfVectorSurveillanceSession, 
			    idfHostVector = @idfHostVector, 
			    strVectorID = @strVectorID, 
			    strFieldVectorID = @strFieldVectorID, 
			    idfLocation = @idfLocation, 
			    intElevation = @intElevation, 
			    idfsSurrounding = @idfsSurrounding, 
			    strGEOReferenceSources = @strGEOReferenceSources, 
			    idfCollectedByOffice = @idfCollectedByOffice, 
			    idfCollectedByPerson = @idfCollectedByPerson, 
			    datCollectionDateTime = @datCollectionDateTime, 
			    --intCollectionEffort = @intCollectionEffort, 
			    idfsCollectionMethod = @idfsCollectionMethod, 
			    idfsBasisOfRecord = @idfsBasisOfRecord, 
			    idfsVectorType = @idfsVectorType, 
			    idfsVectorSubType = @idfsVectorSubType, 
			    intQuantity = @intQuantity, 
			    idfsSex = @idfsSex, 
			    idfIdentifiedByOffice = @idfIdentifiedByOffice, 
			    idfIdentifiedByPerson = @idfIdentifiedByPerson, 
			    datIdentifiedDateTime = @datIdentifiedDateTime, 
			    idfsIdentificationMethod =@idfsIdentificationMethod , 
			    idfObservation = @idfObservation,
			    idfsDayPeriod = @idfsDayPeriod,
			    strComment = @strComment,
				idfsEctoparasitesCollected = @idfsEctoparasitesCollected
	 WHERE 
		idfVector = @idfVector
end Else If @Action = 8 Begin
	Exec dbo.spVector_Delete @ID = @idfVector

END

End
