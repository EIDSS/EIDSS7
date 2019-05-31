
create PROCEDURE [dbo].[spBasicSyndromicSurveillanceAggregateDetail_Post](
	@Action Int,  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	@idfAggregateDetail BIGINT
    ,@idfAggregateHeader BIGINT
    ,@idfHospital BIGINT
    ,@intAge0_4 INT
    ,@intAge5_14 INT
    ,@intAge15_29 INT
    ,@intAge30_64 INT
    ,@intAge65 INT
    ,@inTotalILI INT
    ,@intTotalAdmissions INT
    ,@intILISamples INT		
)
As
Begin	
	
	IF @Action = 4
BEGIN
	IF ISNULL(@idfAggregateDetail,-1)<0
	BEGIN
		EXEC spsysGetNewID @idfAggregateDetail OUTPUT
	END	

	
	--IF LEFT(ISNULL(@strFormID, '(new'),4) = '(new'
	--BEGIN
	--	EXEC dbo.spGetNextNumber 10057030, @strFormID OUTPUT , NULL
	--END	
	

	INSERT INTO [dbo].[tlbBasicSyndromicSurveillanceAggregateDetail]
			   (
			   [idfAggregateDetail]
			  ,[idfAggregateHeader]
			  ,[idfHospital]
			  ,[intAge0_4]
			  ,[intAge5_14]
			  ,[intAge15_29]
			  ,[intAge30_64]
			  ,[intAge65]
			  ,[inTotalILI]
			  ,[intTotalAdmissions]
			  ,[intILISamples]           
			   )
		 VALUES
			   (
				@idfAggregateDetail
			    ,@idfAggregateHeader
				,@idfHospital
				,@intAge0_4
				,@intAge5_14
				,@intAge15_29
				,@intAge30_64
				,@intAge65
				,@inTotalILI
				,@intTotalAdmissions
				,@intILISamples
			   )
	
END
ELSE IF @Action=16
BEGIN
	UPDATE [dbo].[tlbBasicSyndromicSurveillanceAggregateDetail]
	   SET 
			[idfHospital] = @idfHospital
			,[intAge0_4] = @intAge0_4
			,[intAge5_14] = @intAge5_14
			,[intAge15_29] = @intAge15_29
			,[intAge30_64] = @intAge30_64
			,[intAge65] = @intAge65
			,[inTotalILI] = @inTotalILI
			,[intTotalAdmissions] = @intTotalAdmissions
			,[intILISamples] = @intILISamples    
		WHERE 
			idfAggregateDetail = @idfAggregateDetail
end Else If @Action = 8 Begin
	Exec [dbo].[spBasicSyndromicSurveillanceAggregateDetail_Delete] @ID = @idfAggregateDetail

END
	
End
