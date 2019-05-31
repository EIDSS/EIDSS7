

--##SUMMARY Posts data from Vector Surveillance Session form

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 18.07.2011

--##RETURNS Doesn't use



/*
--Example of procedure call:
declare @Action int
declare @idfVectorSurveillanceSession bigint 
declare @strSessionID nvarchar(50)
declare @strFieldSessionID  nvarchar(50)
declare @idfsVectorSurveillanceStatus bigint 
declare @datStartDate datetime
declare @datCloseDate datetime 
declare @idfLocation bigint
declare @idfOutbreak bigint
declare @strDescription nvarchar(500)
declare @idfsSite bigint

EXECUTE [spVsSession_Post] 
    @Action
   ,@idfVectorSurveillanceSession output
   ,@strSessionID output
   ,@strFieldSessionID
   ,@idfsVectorSurveillanceStatus
   ,@datStartDate
   ,@datCloseDate
   ,@idfLocation
   ,@idfOutbreak
   ,@strDescription
   ,@idfsSite


*/


CREATE         PROCEDURE [dbo].[spVsSession_Post](
			@Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
     ,@idfVectorSurveillanceSession bigint output 
     ,@strSessionID nvarchar(50) output 
     ,@strFieldSessionID nvarchar(50) 
     ,@idfsVectorSurveillanceStatus bigint 
     ,@datStartDate datetime
     ,@datCloseDate datetime
     ,@idfLocation bigint
     ,@idfOutbreak bigint
     ,@strDescription nvarchar(500)
	 ,@intCollectionEffort int
	 ,@datModificationForArchiveDate datetime = null
     --,@idfsSite bigint

)
AS

IF @Action = 4
BEGIN
	IF ISNULL(@idfVectorSurveillanceSession,-1)<0
	BEGIN
		EXEC spsysGetNewID @idfVectorSurveillanceSession OUTPUT
	END
	IF LEFT(ISNULL(@strSessionID, '(new'),4) = '(new'
	BEGIN
		EXEC dbo.spGetNextNumber 10057029, @strSessionID OUTPUT , NULL --N'AS Session'
	END
	INSERT INTO dbo.tlbVectorSurveillanceSession
			   (idfVectorSurveillanceSession, 
			   strSessionID, 
			   strFieldSessionID, 
			   idfsVectorSurveillanceStatus, 
			   datStartDate, 
			   datCloseDate, 
			   idfLocation, 
			   idfOutbreak, 
			   strDescription,
			   intCollectionEffort,
			   datModificationForArchiveDate
			   )
		 VALUES
			   (@idfVectorSurveillanceSession, 
			   @strSessionID, 
			   @strFieldSessionID, 
			   @idfsVectorSurveillanceStatus, 
			   @datStartDate, 
			   @datCloseDate, 
			   @idfLocation, 
			   @idfOutbreak, 
			   @strDescription,
			   @intCollectionEffort,
			   getdate()
			   )

END
ELSE IF @Action=16
BEGIN
	UPDATE dbo.tlbVectorSurveillanceSession
	   SET 
      idfVectorSurveillanceSession = @idfVectorSurveillanceSession, 
      --strSessionID = @strSessionID, 
      strFieldSessionID = @strFieldSessionID, 
      idfsVectorSurveillanceStatus = @idfsVectorSurveillanceStatus, 
      datStartDate = @datStartDate, 
      datCloseDate = @datCloseDate, 
      idfLocation = @idfLocation, 
      idfOutbreak = @idfOutbreak, 
      strDescription = @strDescription, 
      intCollectionEffort = @intCollectionEffort,
	  datModificationForArchiveDate = getdate()
      --idfsSite = @idfsSite
	 WHERE 
		idfVectorSurveillanceSession = @idfVectorSurveillanceSession
end Else If @Action = 8 Begin
	Exec spVsSession_Delete @ID = @idfVectorSurveillanceSession
End
