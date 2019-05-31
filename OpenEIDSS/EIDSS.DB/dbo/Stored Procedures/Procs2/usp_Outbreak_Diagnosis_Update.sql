--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/20/2017
-- Last modified by:		Joan Li
-- Description:				06/20/2017: Created based on V6 spOutbreak_Diagnosis_Update :  V7 USP74
--                          Update one variable [idfsDiagnosisOrDiagnosisGroup] in table:tlbOutbreak
/*
----testing code:
EXECUTE usp_Outbreak_Diagnosis_Update   750650000000 ,NULL
----related fact data from
select * from tlbOutbreak
*/
--=====================================================================================================

CREATE PROCEDURE [dbo].[usp_Outbreak_Diagnosis_Update]
(
	@idfOutbreak bigint,
	@idfsDiagnosisGroup bigint
)
AS
BEGIN
	SET NOCOUNT ON;

	IF  @idfsDiagnosisGroup is null
		RAISERROR (15600,-1,-1, 'usp_Outbreak_Diagnosis_Update'); 
					--print 'doing nothing with wrong input'
	ELSE IF  @idfsDiagnosisGroup=''
		RAISERROR (15600,-1,-1, 'usp_Outbreak_Diagnosis_Updatet'); 
					--print 'doing nothing with wrong input'
	ELSE
		BEGIN
			update	tlbOutbreak
			set idfsDiagnosisOrDiagnosisGroup=@idfsDiagnosisGroup
			where	idfOutbreak=@idfOutbreak
		END
END



