

--##SUMMARY 

--##REMARKS Author: 
--##REMARKS Create date:

--##RETURNS Doesn't use



/*
--Example of procedure call:



*/


CREATE PROCEDURE [dbo].[spVsSessionSummary_Post](
	 @Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
     ,@idfsVSSessionSummary bigint output 
	 ,@idfVectorSurveillanceSession bigint 
     ,@strVSSessionSummaryID nvarchar(200) output 
	 ,@idfGeoLocation bigint
	 ,@datCollectionDateTime datetime = null
	 ,@idfsVectorSubType bigint
	 ,@idfsSex bigint = null
	 ,@intQuantity bigint = null
)
AS

IF @Action = 4
BEGIN
	IF ISNULL(@idfsVSSessionSummary,-1)<0
	BEGIN
		EXEC spsysGetNewID @idfsVSSessionSummary OUTPUT
	END
	IF LEFT(ISNULL(@strVSSessionSummaryID, '(new'),4) = '(new'
	BEGIN
		EXEC dbo.spGetNextNumber 10057031, @strVSSessionSummaryID OUTPUT , NULL --N'AS Session'
	END
	INSERT INTO [dbo].[tlbVectorSurveillanceSessionSummary]
			   ([idfsVSSessionSummary]
			   ,[idfVectorSurveillanceSession]
			   ,[strVSSessionSummaryID]
			   ,[idfGeoLocation]
			   ,[datCollectionDateTime]
			   ,[idfsVectorSubType]
			   ,[idfsSex]
			   ,[intQuantity]
			   )
		 VALUES
			   (@idfsVSSessionSummary
				,@idfVectorSurveillanceSession
				,@strVSSessionSummaryID
				,@idfGeoLocation
				,@datCollectionDateTime
				,@idfsVectorSubType
				,@idfsSex
				,@intQuantity
			   )

END
ELSE IF @Action=16
BEGIN
	UPDATE [dbo].[tlbVectorSurveillanceSessionSummary]
	   SET 
			[idfVectorSurveillanceSession] = @idfVectorSurveillanceSession
			,[strVSSessionSummaryID] = @strVSSessionSummaryID
			,[idfGeoLocation] = @idfGeoLocation
			,[datCollectionDateTime] = @datCollectionDateTime
			,[idfsVectorSubType] = @idfsVectorSubType
			,[idfsSex] = @idfsSex
			,[intQuantity] = @intQuantity      
	   WHERE 
			idfsVSSessionSummary = @idfsVSSessionSummary
end Else If @Action = 8 Begin
	Exec spVsSessionSummary_Delete @ID = @idfsVSSessionSummary
End
