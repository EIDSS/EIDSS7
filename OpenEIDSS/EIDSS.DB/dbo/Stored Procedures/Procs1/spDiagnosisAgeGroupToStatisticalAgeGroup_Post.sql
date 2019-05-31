
CREATE PROCEDURE [dbo].[spDiagnosisAgeGroupToStatisticalAgeGroup_Post]
(
	@Action int  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	,@idfDiagnosisAgeGroupToStatisticalAgeGroup bigint
    ,@idfsDiagnosisAgeGroup bigint
    ,@idfsStatisticalAgeGroup bigint
)
AS
Begin
IF @Action = 4
BEGIN
	IF (ISNULL(@idfDiagnosisAgeGroupToStatisticalAgeGroup, -1) < 0) EXEC spsysGetNewID @idfDiagnosisAgeGroupToStatisticalAgeGroup OUTPUT

	Insert into dbo.trtDiagnosisAgeGroupToStatisticalAgeGroup	
	(
		idfDiagnosisAgeGroupToStatisticalAgeGroup
		,idfsDiagnosisAgeGroup
		,idfsStatisticalAgeGroup
	)
	Values
	(
		@idfDiagnosisAgeGroupToStatisticalAgeGroup
		,@idfsDiagnosisAgeGroup
		,@idfsStatisticalAgeGroup
	)	
END

IF @Action = 8
BEGIN
	Delete from dbo.trtDiagnosisAgeGroupToStatisticalAgeGroup where idfDiagnosisAgeGroupToStatisticalAgeGroup = @idfDiagnosisAgeGroupToStatisticalAgeGroup
END

IF @Action = 16
BEGIN
	Update dbo.trtDiagnosisAgeGroupToStatisticalAgeGroup
	Set 
		idfsDiagnosisAgeGroup = @idfsDiagnosisAgeGroup
		,idfsStatisticalAgeGroup = @idfsDiagnosisAgeGroup
	Where 
		idfDiagnosisAgeGroupToStatisticalAgeGroup = @idfDiagnosisAgeGroupToStatisticalAgeGroup
END
	
End
