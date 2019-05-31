


--##SUMMARY Posts data for aggregate case matrix version
--##SUMMARY This method is called from posting procedures of specific aggregate case matrix Type

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 09.02.2010
--##REMARKS Update date: 22.05.2013 by Romasheva S.

--##RETURNS Doesn't use



/*
--Example of procedure call:

EXECUTE spAggregateMatrixVersionHeader_Post 

*/


create       procedure dbo.spAggregateMatrixVersionHeader_Post(
			 @Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
			,@idfVersion BIGINT --##PARAM @idfVersion - matrix version
			,@idfsAggrCaseSection BIGINT  --##PARAM @idfsAggrCaseSection  - aggregate section Type (i.e. Vet, Human, Prophilactic Measure, Diagnostic Action, Sanitary Action)
			,@MatrixName nvarchar(200)   --##PARAM @MatrixName - the name of the matrix
			,@datStartDate datetime --##PARAM @intNumRow - the date from which matrix should be used
			,@blnIsActive bit --##PARAM @blnIsActive - flag indicating that matrix was activated. Only activated matrixes can be used for agrregate case creation.
			,@blnIsDefault bit --##PARAM @blnIsDefault - flag indicating should matrix be used as default matrix or not
)
as
if (@Action <> 8 AND @blnIsDefault = 1 )
begin
	set @blnIsActive = 1
	
	update tlbAggrMatrixVersionHeader
	set blnIsDefault = 0 
	where idfsMatrixType = @idfsAggrCaseSection
		  and idfVersion <> @idfVersion
		  and blnIsDefault = 1
		  and intRowStatus = 0		
end

if @Action = 16
begin
	if not exists (select idfVersion from tlbAggrMatrixVersionHeader where	idfVersion = @idfVersion)
		set @Action=4
end

if @Action = 4
begin
	insert into tlbAggrMatrixVersionHeader
           (idfVersion
           ,idfsMatrixType
           ,MatrixName
           ,datStartDate
           ,blnIsActive
           ,blnIsDefault
			)
     values
           (@idfVersion
           ,@idfsAggrCaseSection
           ,@MatrixName
           ,@datStartDate
           ,@blnIsActive
           ,@blnIsDefault
			)
end

if @Action = 8
begin
	delete from tlbAggrMatrixVersionHeader 
	where idfVersion = @idfVersion
end	

if @Action = 16
	update	tlbAggrMatrixVersionHeader
	set 
			idfsMatrixType = @idfsAggrCaseSection
			,MatrixName = @MatrixName
			,datStartDate=@datStartDate
			,blnIsActive = @blnIsActive
			,blnIsDefault = @blnIsDefault
	where	idfVersion = @idfVersion

