


--##SUMMARY This procedure creates new query search field condition with specified parameters.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 20.04.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 11.11.2011

--##RETURNS Don't use

/*
--Example of a call of procedure:

declare	@idfQuerySearchFieldCondition	bigint
declare	@idfQueryConditionGroup			bigint
declare	@idfQuerySearchField			bigint
declare	@intOrder						int
declare	@strOperator					nvarchar(200)
declare	@intOperatorType				int
declare	@blnUseNot						bit
declare	@varValue						sql_variant

execute	spAsQuerySearchFieldCondition_Post
		 @idfQuerySearchFieldCondition output
		,@idfQueryConditionGroup
		,@idfQuerySearchField,
		,@intOrder
		,@strOperator
		,@intOperatorType
		,@blnUseNot,
		,@varValue

*/ 


CREATE procedure	[dbo].[spAsQuerySearchFieldCondition_Post]
(
	@idfQuerySearchFieldCondition	bigint output,
	@idfQueryConditionGroup			bigint,
	@idfQuerySearchField			bigint,
	@intOrder						int,
	@strOperator					nvarchar(200),
	@intOperatorType				int,
	@blnUseNot						bit,
	@varValue						sql_variant
)
as

if	not exists	(
			select		*
			from		tasQueryConditionGroup
			where		idfQueryConditionGroup = @idfQueryConditionGroup
				)
	or not exists	(
			select		*
			from		tasQuerySearchField
			where		idfQuerySearchField = @idfQuerySearchField
					)
	or	@intOrder is null
	or	@strOperator is null
begin
	set	@idfQuerySearchFieldCondition = -1
end
else begin
	execute	spsysGetNewID	@idfQuerySearchFieldCondition output

	insert into	tasQuerySearchFieldCondition
	(	idfQuerySearchFieldCondition,
		idfQueryConditionGroup,
		idfQuerySearchField,
		intOrder,
		strOperator,
		intOperatorType,
		blnUseNot,
		varValue
	)
	values
	(	@idfQuerySearchFieldCondition,
		@idfQueryConditionGroup,
		@idfQuerySearchField,
		@intOrder,
		@strOperator,
		@intOperatorType,
		@blnUseNot,
		@varValue
	)
end

return 0


