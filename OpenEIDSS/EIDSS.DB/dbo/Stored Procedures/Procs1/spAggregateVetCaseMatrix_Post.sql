


--##SUMMARY Posts data from AggregateVetCaseMTXDetail form
--##SUMMARY All matrix posting procedures work using next rules:
--##SUMMARY - the record is never deleted from matrix table itself, deletion is perfomed in the matrix version table only
--##SUMMARY - the record is never updated in the matrix table itself, update is performed in the matrix version table only
--##SUMMARY - before any operation on the posted row we check if matrix row with posted natural keys exists and reset matrix row key
--##SUMMARY - to existing value if needed. Thus matrix row key uniquely identifies the value of natural matrix primary key.
--##SUMMARY - New record is inserted to root matix table only if there is no record with such primary key.
--##SUMMARY - The names of generic primary key fields for specific matrix version parameters must end with "Row" suffix (this assumption is used in the client application).
--##SUMMARY - Vet Case matrix uses the next natural keys - Diagnosis, SpeciesType.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 03.12.2009
--##REMARKS Update date: 22.05.2013 by Romasheva S.

--##RETURNS Doesn't use



/*
--Example of procedure call:

EXECUTE spAggregateVetCaseMatrix_Post 

*/


create       procedure dbo.spAggregateVetCaseMatrix_Post(
			 @Action int  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
			,@idfAggrVetCaseMTX bigint output --##PARAM @idfAggrVetCaseMTX  - record ID
			,@idfSpeciesRow bigint output   -- don't use now !!!
			,@idfsSpeciesType bigint   --##PARAM @idfsSpeciesType - species Type
			,@idfDiagnosisRow bigint output -- don't use now !!!
			,@idfOIECodeRow bigint output -- don't use now !!!
			,@idfsDiagnosis bigint --##PARAM @idfsDiagnosis - diagnosis
			,@idfVersion bigint --##PARAM @idfVersion - matrix version
			,@intNumRow bigint --##PARAM @intNumRow - row number inside matrix version
)
as


--Insert new record to matrix if it doesn't exist
if @Action = 4
begin
	if isnull(@idfAggrVetCaseMTX,-1)<0
		exec spsysGetNewID @idfAggrVetCaseMTX output
	if not exists (select * from tlbAggrVetCaseMTX where idfAggrVetCaseMTX = @idfAggrVetCaseMTX)
		insert into tlbAggrVetCaseMTX
			(
				idfAggrVetCaseMTX
				,idfsSpeciesType
				,idfsDiagnosis
				,idfVersion
				,intNumRow
			)
		values
			(
				@idfAggrVetCaseMTX
				,@idfsSpeciesType
				,@idfsDiagnosis
				,@idfVersion
				,@intNumRow
			)
end

-- Delete
if @Action = 8 
	delete from tlbAggrVetCaseMTX where idfAggrVetCaseMTX = @idfAggrVetCaseMTX	


-- update	
if @Action = 16
update dbo.tlbAggrVetCaseMTX
set 
	 idfsSpeciesType = @idfsSpeciesType
	,idfsDiagnosis = @idfsDiagnosis
	,idfVersion = @idfVersion
	,intNumRow = @intNumRow
where  
	idfAggrVetCaseMTX = @idfAggrVetCaseMTX	
