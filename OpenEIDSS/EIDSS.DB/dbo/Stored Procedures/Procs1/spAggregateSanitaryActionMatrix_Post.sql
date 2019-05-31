


--##SUMMARY Posts data from AggregateSanitaryActionMTXDetail form
--##SUMMARY All matrix posting procedures work using next rules:
--##SUMMARY - the record is never deleted from matrix table itself, deletion is perfomed in the matrix version table only
--##SUMMARY - the record is never updated in the matrix table itself, update is performed in the matrix version table only
--##SUMMARY - before any operation on the posted row we check if matrix row with posted natural keys exists and reset matrix row key
--##SUMMARY - to existing value if needed. Thus matrix row key uniquely identifies the value of natural matrix primary key.
--##SUMMARY - New record is inserted to root matix table only if there is no record with such primary key.
--##SUMMARY - The names of generic primary key fields for specific matrix version parameters must end with "Row" suffix (this assumption is used in the client application).
--##SUMMARY - Sanitary Action matrix uses the next natural keys - SanitryAction.


--##REMARKS Author: Zurin M.
--##REMARKS Create date: 15.02.2010
--##REMARKS Update date: 22.05.2013 by Romasheva S.


--##RETURNS Doesn't use



/*
--Example of procedure call:

DECLARE @Action int
DECLARE @idfsDiagnosis bigint
DECLARE @idfVersion bigint
DECLARE @intNumRow bigint


EXECUTE spAggregateSanitaryActionMatrix_Post
   @Action
  ,@idfsDiagnosis
  ,@idfVersion
  ,@intNumRow

*/


create       procedure dbo.spAggregateSanitaryActionMatrix_Post(
			 @Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
			,@idfSanitaryActionMTX BIGINT OUTPUT   --##PARAM @idfSanitaryActionMTX - original primary key  for matrix row
			,@idfVersion BIGINT --##PARAM @idfVersion - matrix version
			,@idfActionTypeRow BIGINT OUTPUT   -- don't use now !!!
			,@idfActionCodeRow BIGINT OUTPUT   -- don't use now !!!
			,@idfsSanitaryAction BIGINT --##PARAM idfsSanitaryAction - sanitary action ID
			,@intNumRow BIGINT --##PARAM @intNumRow - row number inside matrix version
)
as
/*
				,@idfsParameterMeasureType4 = 233190000000
				,@idfsParameterMeasureCode4 = 233150000000
*/

--Insert new record to matrix if it doesn't exist
if @Action = 4
begin
	if isnull(@idfSanitaryActionMTX,-1)<0
		exec spsysGetNewID @idfSanitaryActionMTX output
		
	if (not exists (select * from dbo.tlbAggrSanitaryActionMTX where idfAggrSanitaryActionMTX = @idfSanitaryActionMTX))
		insert into dbo.tlbAggrSanitaryActionMTX
			(
				idfAggrSanitaryActionMTX
				,idfsSanitaryAction
				,idfVersion
				,intNumRow
			)
		values
			(
				 @idfSanitaryActionMTX
				,@idfsSanitaryAction
				,@idfVersion
				,@intNumRow
			)
end

if @Action = 8 -- Delete
	delete from dbo.tlbAggrSanitaryActionMTX where idfAggrSanitaryActionMTX = @idfSanitaryActionMTX
	
	

if @Action = 16
update dbo.tlbAggrSanitaryActionMTX
set 
	idfsSanitaryAction  = @idfsSanitaryAction
	,idfVersion = @idfVersion
	,intNumRow = @intNumRow
where  
	idfAggrSanitaryActionMTX = @idfSanitaryActionMTX






