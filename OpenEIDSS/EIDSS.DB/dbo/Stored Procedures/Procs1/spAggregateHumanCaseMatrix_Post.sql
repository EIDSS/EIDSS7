


--##SUMMARY Posts data from AggregateHumanCaseMTXDetail form
--##SUMMARY All matrix posting procedures work using next rules:
--##SUMMARY - the record is never deleted from matrix table itself, deletion is perfomed in the matrix version table only
--##SUMMARY - the record is never updated in the matrix table itself, update is performed in the matrix version table only
--##SUMMARY - before any operation on the posted row we check if matrix row with posted natural keys exists and reset matrix row key
--##SUMMARY - to existing value if needed. Thus matrix row key uniquely identifies the value of natural matrix primary key.
--##SUMMARY - New record is inserted to root matix table only if there is no record with such primary key.
--##SUMMARY - The names of generic primary key fields for specific matrix version parameters must end with "Row" suffix (this assumption is used in the client application).
--##SUMMARY - We consider tlbDiagnosis table as Human Case matrix table.
--##SUMMARY - Human Case matrix uses the next natural keys - Diagnosis.
--##SUMMARY - All diagnosis are exists already in matrix table, so we should just update matrix version table.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 11.02.2010
--##REMARKS Update date: 22.05.2013 by Romasheva S.
--##RETURNS Doesn't use



/*
--Example of procedure call:

DECLARE @Action int
DECLARE @idfsDiagnosis bigint
DECLARE @idfVersion bigint
DECLARE @intNumRow bigint


EXECUTE spAggregateHumanCaseMatrix_Post
   @Action
  ,@idfsDiagnosis
  ,@idfVersion
  ,@intNumRow

*/


create       procedure dbo.spAggregateHumanCaseMatrix_Post(
			 @Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
			,@idfHumanCaseMtx BIGINT OUTPUT--##PARAM @idfHumanCaseMtx - primary key
			,@idfVersion BIGINT --##PARAM @idfVersion - matrix version
			,@idfDiagnosisRow BIGINT OUTPUT -- don't use now !!!
			,@idfsDiagnosis BIGINT --##PARAM @idfsDiagnosis - diagnosis
			,@idfIDCCodeRow BIGINT OUTPUT -- don't use now !!!
			,@intNumRow BIGINT --##PARAM @intNumRow - row number inside matrix version
)
as
/*
				@idfsParameterDiagnosis0 = 226890000000
				,@idfsParameterICD10Code0 = 229630000000
*/
	
--Insert new record to matrix if it doesn't exist
if @Action = 4
begin
	if isnull(@idfHumanCaseMtx,-1)<0
		exec spsysGetNewID @idfHumanCaseMtx output
		
	if (not exists (select * from dbo.tlbAggrHumanCaseMTX where idfAggrHumanCaseMTX = @idfHumanCaseMtx))
		insert into tlbAggrHumanCaseMTX
			(
				idfAggrHumanCaseMTX
				,idfsDiagnosis
				,idfVersion
				,intNumRow
			)
		values
			(
				 @idfHumanCaseMtx
				,@idfsDiagnosis
				,@idfVersion
				,@intNumRow
			)
end

if @Action = 8
	delete from  dbo.tlbAggrHumanCaseMTX
	where idfAggrHumanCaseMTX = @idfHumanCaseMtx
	
	
if @Action = 16
update dbo.tlbAggrHumanCaseMTX
set 
	 idfsDiagnosis = @idfsDiagnosis
	,idfVersion = @idfVersion
	,intNumRow = @intNumRow
where  
	idfAggrHumanCaseMTX = @idfHumanCaseMtx






