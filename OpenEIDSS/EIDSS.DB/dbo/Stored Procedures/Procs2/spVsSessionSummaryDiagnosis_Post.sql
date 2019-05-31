

--##SUMMARY 

--##REMARKS Author: 
--##REMARKS Create date:

--##RETURNS Doesn't use



/*
--Example of procedure call:



*/


CREATE PROCEDURE [dbo].[spVsSessionSummaryDiagnosis_Post](
	 @Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
     ,@idfsVSSessionSummaryDiagnosis bigint output
	 ,@idfsVSSessionSummary bigint
	 ,@idfsDiagnosis bigint 
	 ,@intPositiveQuantity bigint 
)
AS

IF @Action = 4
BEGIN
	IF ISNULL(@idfsVSSessionSummaryDiagnosis,-1)<0
	BEGIN
		EXEC spsysGetNewID @idfsVSSessionSummaryDiagnosis OUTPUT
	END
	
	INSERT INTO [dbo].[tlbVectorSurveillanceSessionSummaryDiagnosis]
			   ([idfsVSSessionSummaryDiagnosis]
			   ,[idfsVSSessionSummary]
			   ,[idfsDiagnosis]
			   ,[intPositiveQuantity]
			   )
		 VALUES
			   (@idfsVSSessionSummaryDiagnosis
				,@idfsVSSessionSummary
				,@idfsDiagnosis 
				,@intPositiveQuantity
			   )

END
ELSE IF @Action=16
BEGIN
	UPDATE [dbo].[tlbVectorSurveillanceSessionSummaryDiagnosis]
	   SET 			
			[idfsVSSessionSummary] = @idfsVSSessionSummary
			,[idfsDiagnosis] = @idfsDiagnosis
			,[intPositiveQuantity] = @intPositiveQuantity    
	   WHERE 
			[idfsVSSessionSummaryDiagnosis] = @idfsVSSessionSummaryDiagnosis
end Else If @Action = 8 Begin
	Exec [spVsSessionSummaryDiagnosis_Delete] @ID = @idfsVSSessionSummaryDiagnosis
End
