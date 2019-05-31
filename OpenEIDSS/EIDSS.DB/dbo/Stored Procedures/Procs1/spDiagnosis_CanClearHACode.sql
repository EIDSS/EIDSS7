


--##SUMMARY Checks if diagnosis HACode can be cleared.
--##SUMMARY This procedure is called from Clinical Diagnosis Editor.
--##SUMMARY We consider that HACode can be cleared if there is no reference to this 
--##SUMMARY Diagnosis from next tables:
--##SUMMARY tlbHumanCase
--##SUMMARY tlbVetCase
--##SUMMARY tlbAggrMatrixVersion
--##SUMMARY tlbAggrProphylacticActionMTX
--##SUMMARY tlbAggrDiagnosticActionMTX
--##SUMMARY tlbAggrVetCaseMTX



--##REMARKS Author: Zurin M.
--##REMARKS Create date: 29.10.2010

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013
--##REMARKS Update date: 22.05.2013 by Romasheva S.


--##RETURNS 0 if diagnosis HACode can't be cleared 
--##RETURNS 1 if diagnosis HACode can be cleared

/*
Example of procedure call:

DECLARE @ID bigint
DECLARE @Result BIT
EXEC spDiagnosis_CanClearHACode 1, 2, @Result OUTPUT

Print @Result

*/


create   procedure dbo.spDiagnosis_CanClearHACode
	@ID as bigint --##PARAM @ID - diagnosis ID
	,@HACodeFlag as int --##PARAM @HACodeFlag - HACode (representing single item in enumeration) that should be tested
	,@Result AS BIT OUTPUT --##PARAM  @Result - 0 if case can't be deleted, 1 in other case
as
IF @ID IS NULL 
BEGIN
		SET @Result = 1
		Return @Result
END
IF @HACodeFlag = 2 AND EXISTS(
		SELECT * from dbo.tlbHumanCase 
		WHERE tlbHumanCase.intRowStatus = 0 AND idfsFinalDiagnosis= @ID or idfsTentativeDiagnosis = @ID )
	SET @Result = 0
ELSE IF @HACodeFlag = 32 AND EXISTS(
		SELECT * from dbo.tlbVetCase 
		where  tlbVetCase.intRowStatus = 0 AND
			(idfsFinalDiagnosis= @ID 
			or idfsTentativeDiagnosis = @ID  
			or idfsTentativeDiagnosis1 = @ID 
			or idfsTentativeDiagnosis2 = @ID
			or tlbVetCase.idfsShowDiagnosis= @ID) 
			and tlbVetCase.idfsCaseType = 10012003)--LiveStock cases
	SET @Result = 0
ELSE IF @HACodeFlag = 64 AND EXISTS(
		SELECT * from dbo.tlbVetCase  
		where  tlbVetCase.intRowStatus = 0 AND
			(idfsFinalDiagnosis= @ID 
			or idfsTentativeDiagnosis = @ID  
			or idfsTentativeDiagnosis1 = @ID 
			or idfsTentativeDiagnosis2 = @ID
			or tlbVetCase.idfsShowDiagnosis= @ID) 
			and tlbVetCase.idfsCaseType = 10012004)--avian cases
	SET @Result = 0

ELSE IF  @HACodeFlag = 2 AND EXISTS(SELECT * from dbo.tlbHumanCase  where  ISNULL(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis) = @ID and intRowStatus = 0)
	SET @Result = 0
ELSE IF (@HACodeFlag & 96)<>0 AND EXISTS(SELECT * from dbo.tlbAggrDiagnosticActionMTX  where  idfsDiagnosis= @ID and intRowStatus = 0)
	SET @Result = 0
ELSE IF (@HACodeFlag & 96)<>0 AND EXISTS(SELECT * from dbo.tlbAggrProphylacticActionMTX  where  idfsDiagnosis= @ID and intRowStatus = 0)
	SET @Result = 0
ELSE IF (@HACodeFlag & 96)<>0 AND EXISTS(SELECT * from dbo.tlbAggrVetCaseMTX  where  idfsDiagnosis= @ID and intRowStatus = 0)
	SET @Result = 0
ELSE IF @HACodeFlag = 2 AND EXISTS(SELECT * from  dbo.tlbAggrHumanCaseMTX 
				INNER JOIN dbo.tlbAggrMatrixVersionHeader
				ON tlbAggrHumanCaseMTX.idfVersion = tlbAggrMatrixVersionHeader.idfVersion
				where  tlbAggrHumanCaseMTX.idfsDiagnosis = @ID
				AND tlbAggrMatrixVersionHeader.intRowStatus = 0
				AND  tlbAggrMatrixVersionHeader.idfsMatrixType = 71190000000 --human case 
			)
	SET @Result = 0
ELSE IF @HACodeFlag <> 2 AND 
			(
			EXISTS(SELECT * from dbo.tlbAggrVetCaseMTX
				INNER JOIN dbo.tlbAggrMatrixVersionHeader
				ON tlbAggrVetCaseMTX.idfVersion = tlbAggrMatrixVersionHeader.idfVersion
				where  tlbAggrVetCaseMTX.idfsDiagnosis = @ID
				AND tlbAggrMatrixVersionHeader.intRowStatus = 0
				AND  tlbAggrMatrixVersionHeader.idfsMatrixType = 71090000000 --vet case 
			) or
			EXISTS(SELECT * from dbo.tlbAggrDiagnosticActionMTX
				INNER JOIN dbo.tlbAggrMatrixVersionHeader
				ON tlbAggrDiagnosticActionMTX.idfVersion = tlbAggrMatrixVersionHeader.idfVersion
				where  tlbAggrDiagnosticActionMTX.idfsDiagnosis = @ID
				AND tlbAggrMatrixVersionHeader.intRowStatus = 0
				AND  tlbAggrMatrixVersionHeader.idfsMatrixType = 71460000000 -- diagnostic action
			) or
			EXISTS(SELECT * from dbo.tlbAggrProphylacticActionMTX
				INNER JOIN dbo.tlbAggrMatrixVersionHeader
				ON tlbAggrProphylacticActionMTX.idfVersion = tlbAggrMatrixVersionHeader.idfVersion
				where  tlbAggrProphylacticActionMTX.idfsDiagnosis = @ID
				AND tlbAggrMatrixVersionHeader.intRowStatus = 0
				AND  tlbAggrMatrixVersionHeader.idfsMatrixType = 71300000000 -- prophylactic action
			)
			
			)
	SET @Result = 0
ELSE
	SET @Result = 1

Return @Result


