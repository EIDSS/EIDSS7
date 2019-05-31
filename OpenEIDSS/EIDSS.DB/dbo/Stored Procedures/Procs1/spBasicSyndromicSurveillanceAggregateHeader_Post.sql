
create PROCEDURE [dbo].[spBasicSyndromicSurveillanceAggregateHeader_Post](
	@Action Int,  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	@idfAggregateHeader BIGINT
    ,@strFormID NVARCHAR(200) = NULL output
    ,@datDateEntered DATETIME    
    ,@idfEnteredBy BIGINT
    ,@idfsSite BIGINT
    ,@intYear INT
    ,@intWeek INT
    ,@datStartDate DATETIME
    ,@datFinishDate DATETIME
    ,@datModificationForArchiveDate DATETIME  = NULL	
)
As
Begin	
	
	Declare @datDateLastSaved Datetime
	If (@datDateLastSaved Is Null) Set @datDateLastSaved = Getdate()

	IF @Action = 4
BEGIN
	IF ISNULL(@idfAggregateHeader,-1)<0
	BEGIN
		EXEC spsysGetNewID @idfAggregateHeader OUTPUT
	END
	IF LEFT(ISNULL(@strFormID, '(new'),4) = '(new'
	BEGIN
		EXEC dbo.spGetNextNumber 10057033, @strFormID OUTPUT , NULL
	END	

	INSERT INTO [dbo].[tlbBasicSyndromicSurveillanceAggregateHeader]
			   ([idfAggregateHeader]
			   ,[strFormID]
			   ,[datDateEntered]
			   ,[datDateLastSaved]
			   ,[idfEnteredBy]
			   ,[idfsSite]
			   ,[intYear]
			   ,[intWeek]
			   ,[datStartDate]
			   ,[datFinishDate]
			   ,[datModificationForArchiveDate]           
			   )
		 VALUES
			   (
			    @idfAggregateHeader
				,@strFormID
				,@datDateEntered
				,@datDateLastSaved 
				,@idfEnteredBy
				,@idfsSite
				,@intYear
				,@intWeek
				,@datStartDate
				,@datFinishDate
				,getdate()
			   )
	
END
ELSE IF @Action=16
BEGIN
	UPDATE [dbo].[tlbBasicSyndromicSurveillanceAggregateHeader]
	   SET 
			    strFormID = @strFormID
				,datDateEntered = @datDateEntered
				,datDateLastSaved = @datDateLastSaved
				,idfEnteredBy = @idfEnteredBy
				,idfsSite = @idfsSite
				,[intYear] = @intYear
			    ,[intWeek] = @intWeek
			    ,[datStartDate] = @datStartDate
			    ,[datFinishDate] = @datFinishDate
			    ,[datModificationForArchiveDate] = getdate()           
		WHERE 
			idfAggregateHeader = @idfAggregateHeader
end Else If @Action = 8 Begin
	Exec dbo.[spBasicSyndromicSurveillanceAggregateHeader_Delete] @ID = @idfAggregateHeader

END
	
End
