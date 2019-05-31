


--##SUMMARY Posts data from AggregateProphylacticActionMTXDetail form
--##SUMMARY All matrix posting procedures work using next rules:
--##SUMMARY - the record is never deleted from matrix table itself, deletion is perfomed in the matrix version table only
--##SUMMARY - the record is never updated in the matrix table itself, update is performed in the matrix version table only
--##SUMMARY - before any operation on the posted row we check if matrix row with posted natural keys exists and reset matrix row key
--##SUMMARY - to existing value if needed. Thus matrix row key uniquely identifies the value of natural matrix primary key.
--##SUMMARY - New record is inserted to root matix table only if there is no record with such primary key.
--##SUMMARY - The names of generic primary key fields for specific matrix version parameters must end with "Row" suffix (this assumption is used in the client application).
--##SUMMARY - Prophylactic Action matrix uses the next natural keys - Diagnosis, SpeciesType, ProphilacticAction.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 05.12.2009
--##REMARKS Update date: 22.05.2013 by Romasheva S.

--##RETURNS Doesn't use



/*
--Example of procedure call:

EXECUTE spAggregateProphylacticActionMatrix_Post 

*/


create       procedure dbo.spAggregateProphylacticActionMatrix_Post(
			 @Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
			,@idfAggrProphylacticActionMTX BIGINT OUTPUT --##PARAM @idfAggrProphylacticActionMTX  - record ID
			,@idfSpeciesRow BIGINT OUTPUT   -- don't use now !!!
			,@idfsSpeciesType BIGINT   --##PARAM @idfsSpeciesType - species Type
			,@idfDiagnosisRow BIGINT OUTPUT -- don't use now !!!
			,@idfOIECodeRow BIGINT OUTPUT -- don't use now !!!
			,@idfsDiagnosis BIGINT --##PARAM @idfsDiagnosis - diagnosis
			,@idfActionTypeRow BIGINT OUTPUT -- don't use now !!!
			,@idfActionCodeRow BIGINT OUTPUT -- don't use now !!!
			,@idfsProphilacticAction BIGINT --##PARAM @idfsProphilacticAction - prophilactic action
			,@idfVersion BIGINT --##PARAM @idfVersion - matrix version
			,@intNumRow BIGINT --##PARAM @intNumRow - row number inside matrix version
)
as
-- insert new record to matrix if it doesn't exist
if @Action = 4
begin
	if isnull(@idfAggrProphylacticActionMTX,-1)<0
		exec spsysGetNewID @idfAggrProphylacticActionMTX output
	if (not exists (select * from tlbAggrProphylacticActionMTX where idfAggrProphylacticActionMTX = @idfAggrProphylacticActionMTX))
		insert into tlbAggrProphylacticActionMTX
			(
				idfAggrProphylacticActionMTX
				,idfsSpeciesType
				,idfsDiagnosis
				,idfsProphilacticAction
				,idfVersion
				,intNumRow
			)
		values
			(
				@idfAggrProphylacticActionMTX
				,@idfsSpeciesType
				,@idfsDiagnosis
				,@idfsProphilacticAction
				,@idfVersion
				,@intNumRow
			)
end

-- delete
if @Action = 8 -- Delete
	delete from tlbAggrProphylacticActionMTX where idfAggrProphylacticActionMTX = @idfAggrProphylacticActionMTX
	
-- update	
if @Action = 16
	update tlbAggrProphylacticActionMTX
	set 
		 idfsDiagnosis = @idfsDiagnosis
		,idfsSpeciesType = @idfsSpeciesType
		,idfsProphilacticAction = @idfsProphilacticAction
		,idfVersion = @idfVersion
		,intNumRow = @intNumRow
	where  idfAggrProphylacticActionMTX = @idfAggrProphylacticActionMTX
	


