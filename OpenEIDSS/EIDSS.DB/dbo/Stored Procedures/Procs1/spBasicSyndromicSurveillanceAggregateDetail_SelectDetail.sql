
Create  PROCEDURE [dbo].[spBasicSyndromicSurveillanceAggregateDetail_SelectDetail](
	@idfAggregateHeader AS bigint
	,@LangID AS nvarchar(50)
)
AS
Begin
	Select
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
	From [dbo].[tlbBasicSyndromicSurveillanceAggregateDetail]
	Where
	idfAggregateHeader = @idfAggregateHeader and intRowStatus = 0
end
