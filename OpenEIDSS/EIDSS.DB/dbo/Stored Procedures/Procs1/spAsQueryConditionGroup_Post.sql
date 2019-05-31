


--##SUMMARY This procedure creates new query condition group with specified parameters.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 20.04.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 11.11.2011

--##RETURNS Don't use

/*
--Example of a call of procedure:

declare	@idfQueryConditionGroup			bigint
declare	@idfQuerySearchObject			bigint
declare	@intOrder						int
declare	@idfParentQueryConditionGroup	bigint
declare	@blnJoinByOr					bit
declare	@blnUseNot						bit
declare	@idfSubQuerySearchObject		bigint

execute	spAsQueryConditionGroup_Post
		 @idfQueryConditionGroup output
		,@idfQuerySearchObject
		,@intOrder,
		,@idfParentQueryConditionGroup
		,@blnJoinByOr
		,@blnUseNot
		,@idfSubQuerySearchObject

*/ 


CREATE procedure	[dbo].[spAsQueryConditionGroup_Post]
(
	@idfQueryConditionGroup			bigint output,
	@idfQuerySearchObject			bigint,
	@intOrder						int,
	@idfParentQueryConditionGroup	bigint = null,
	@blnJoinByOr					bit = null,
	@blnUseNot						bit = null,
	@idfSubQuerySearchObject		bigint = null
)
as

if	not exists	(
		select	*
		from	tasQuerySearchObject
		where	idfQuerySearchObject = @idfQuerySearchObject
				)
	or	(	@idfParentQueryConditionGroup is not null 
			and not exists	(
						select		*
						from		tasQueryConditionGroup
						where		idfQueryConditionGroup = @idfParentQueryConditionGroup
							)
		)
	or	@intOrder is null
begin
	set	@idfQueryConditionGroup = -1
end
else begin
	execute	spsysGetNewID	@idfQueryConditionGroup output

	insert into	tasQueryConditionGroup
	(	idfQueryConditionGroup,
		idfQuerySearchObject,
		idfParentQueryConditionGroup,
		intOrder,
		blnJoinByOr,
		blnUseNot,
		idfSubQuerySearchObject
	)
	values
	(	@idfQueryConditionGroup,
		@idfQuerySearchObject,
		@idfParentQueryConditionGroup,
		@intOrder,
		@blnJoinByOr,
		@blnUseNot,
		@idfSubQuerySearchObject
	)
end

return 0


