


--##SUMMARY Checks if diagnosis can be deleted.
--##SUMMARY This procedure is called from Clinical Diagnosis Editor.
--##SUMMARY We consider that Diagnosis can be deleted if there is no reference to this Diagnosis from next tables:
--##SUMMARY tlbHumanCase
--##SUMMARY tlbVetCase
--##SUMMARY tlbTesting
--##SUMMARY tlbVaccination
--##SUMMARY tlbTestValidation
--##SUMMARY tlbOutbreak
--##SUMMARY tlbAggrMatrixVersion
--##SUMMARY tlbAggrProphylacticActionMTX
--##SUMMARY tlbAggrDiagnosticActionMTX
--##SUMMARY tlbAggrVetCaseMTX
--##SUMMARY tdeDataExportDetail
--##SUMMARY tdeDataExportDiagnosis
--##SUMMARY trtTestForDisease



--##REMARKS Author: Zurin M.
--##REMARKS Create date: 07.06.2010
--##REMARKS Update date: 22.05.2013 by Romasheva S.

--##RETURNS 0 if Prophylactic Action can't be deleted 
--##RETURNS 1 if Prophylactic Action can be deleted 

/*
Example of procedure call:

DECLARE @ID bigint
DECLARE @Result BIT
EXEC spDiagnosis_CanDelete 1, @Result OUTPUT

Print @Result

*/


create   procedure dbo.spDiagnosis_CanDelete
	@ID as bigint --##PARAM @ID - farm ID
	,@Result AS BIT OUTPUT --##PARAM  @Result - 0 if case can't be deleted, 1 in other case
as

IF EXISTS(SELECT * from dbo.tlbHumanCase  where  idfsFinalDiagnosis= @ID or idfsTentativeDiagnosis = @ID )
	SET @Result = 0
ELSE IF EXISTS(SELECT * from dbo.tlbVetCase  where  idfsFinalDiagnosis= @ID or idfsTentativeDiagnosis = @ID  or idfsTentativeDiagnosis1 = @ID or idfsTentativeDiagnosis2 = @ID)
	SET @Result = 0
ELSE IF EXISTS(SELECT * from dbo.tlbTesting  where  idfsDiagnosis= @ID and intRowStatus = 0)
	SET @Result = 0
ELSE IF EXISTS(SELECT * from dbo.tlbVaccination  where  idfsDiagnosis= @ID and intRowStatus = 0)
	SET @Result = 0
ELSE IF EXISTS(SELECT * from dbo.tlbTestValidation  where  idfsDiagnosis= @ID and intRowStatus = 0)
	SET @Result = 0
ELSE IF EXISTS(SELECT * from dbo.tlbOutbreak  where  idfsDiagnosisOrDiagnosisGroup= @ID and intRowStatus = 0)
	SET @Result = 0
ELSE IF EXISTS(SELECT * from dbo.tlbAggrDiagnosticActionMTX  where  idfsDiagnosis= @ID and intRowStatus = 0)
	SET @Result = 0
ELSE IF EXISTS(SELECT * from dbo.tlbAggrProphylacticActionMTX  where  idfsDiagnosis= @ID and intRowStatus = 0)
	SET @Result = 0
ELSE IF EXISTS(SELECT * from dbo.tlbAggrVetCaseMTX  where  idfsDiagnosis= @ID and intRowStatus = 0)
	SET @Result = 0
ELSE IF EXISTS(SELECT * from dbo.tdeDataExportDetail  where  idfsDiagnosis= @ID)
	SET @Result = 0
ELSE IF EXISTS(SELECT * from dbo.tdeDataExportDiagnosis  where  idfsDiagnosis= @ID)
	SET @Result = 0
ELSE IF EXISTS(SELECT * from dbo.trtTestForDisease  where idfsTestCategory= @ID and intRowStatus = 0)
	SET @Result = 0
ELSE IF EXISTS(SELECT * from dbo.tlbAggrVetCaseMTX where idfsDiagnosis = @ID and intRowStatus = 0)
	SET @Result = 0
ELSE IF EXISTS(SELECT * from dbo.tlbAggrHumanCaseMTX where idfsDiagnosis = @ID and intRowStatus = 0)
	SET @Result = 0	
ELSE IF EXISTS(SELECT * from dbo.tlbAggrProphylacticActionMTX where idfsDiagnosis = @ID and intRowStatus = 0)
	SET @Result = 0		
ELSE
	SET @Result = 1

Return @Result


