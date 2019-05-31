


--##SUMMARY Posts data from AggregateDiagnosticActionMTXDetail form
--##SUMMARY All matrix posting procedures work using next rules:
--##SUMMARY - the record is never deleted from matrix table itself, deletion is perfomed in the matrix version table only
--##SUMMARY - the record is never updated in the matrix table itself, update is performed in the matrix version table only
--##SUMMARY - before any operation on the posted row we check if matrix row with posted natural keys exists and reset matrix row key
--##SUMMARY - to existing value if needed. Thus matrix row key uniquely identifies the value of natural matrix primary key.
--##SUMMARY - New record is inserted to root matix table only if there is no record with such primary key.
--##SUMMARY - The names of generic primary key fields for specific matrix version parameters must end with "Row" suffix (this assumption is used in the client application).
--##SUMMARY - Diagnostic Action matrix uses the next natural keys - Diagnosis, SpeciesType, DiagnosisAction.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 05.12.2009

--##RETURNS Doesn't use

--##REMARKS Update date: 21.05.2013 by Romasheva S.

/*
--Example of procedure call:

EXECUTE spAggregateDiagnosticActionMatrix_Post 

*/


create       procedure dbo.spAggregateDiagnosticActionMatrix_Post(
			 @Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
			,@idfAggrDiagnosticActionMTX BIGINT OUTPUT --##PARAM @idfAggrDiagnosticActionMTX  - record ID
			,@idfSpeciesRow BIGINT OUTPUT   -- don't use now !!!
			,@idfsSpeciesType BIGINT   --##PARAM @idfsSpeciesType - species Type
			,@idfDiagnosisRow BIGINT OUTPUT -- don't use now !!!
			,@idfsDiagnosis BIGINT --##PARAM @idfsDiagnosis - diagnosis
			,@idfOIECodeRow BIGINT OUTPUT -- don't use now !!!
			,@idfDiagnosticActionRow BIGINT OUTPUT -- don't use now !!!
			,@idfsDiagnosticAction BIGINT --##PARAM @idfsDiagnosticAction - diagnostic action
			,@idfVersion BIGINT --##PARAM @idfVersion - matrix version
			,@intNumRow BIGINT --##PARAM @intNumRow - row number inside matrix version
)
as
--Insert new record to matrix if it doesn't exist
IF @Action = 4
BEGIN
	if ISNULL(@idfAggrDiagnosticActionMTX,-1)<0
		EXEC spsysGetNewID @idfAggrDiagnosticActionMTX OUTPUT
		
	IF (NOT EXISTS (SELECT * FROM tlbAggrDiagnosticActionMTX WHERE idfAggrDiagnosticActionMTX = @idfAggrDiagnosticActionMTX))
		INSERT INTO tlbAggrDiagnosticActionMTX
			(
				 idfAggrDiagnosticActionMTX
				,idfsSpeciesType
				,idfsDiagnosis
				,idfsDiagnosticAction
				,idfVersion
				,intNumRow
			)
		VALUES
			(
			 	@idfAggrDiagnosticActionMTX
				,@idfsSpeciesType
				,@idfsDiagnosis
				,@idfsDiagnosticAction
				,@idfVersion
				,@intNumRow
			)
END

IF @Action = 8
	DELETE FROM tlbAggrDiagnosticActionMTX 
	WHERE idfAggrDiagnosticActionMTX = @idfAggrDiagnosticActionMTX
	
	
IF @Action = 16
UPDATE tlbAggrDiagnosticActionMTX
SET 
	idfsSpeciesType = @idfsSpeciesType
	,idfsDiagnosis = @idfsDiagnosis
	,idfsDiagnosticAction = @idfsDiagnosticAction
	,idfVersion = @idfVersion
	,intNumRow = @intNumRow
WHERE  
	idfAggrDiagnosticActionMTX = @idfAggrDiagnosticActionMTX




