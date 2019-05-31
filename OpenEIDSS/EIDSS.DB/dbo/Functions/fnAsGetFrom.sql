

--##SUMMARY Returns updated from condition for specified search table from specified "union" part of the query.


--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 27.04.2010

--##REMARKS UPDATED BY: Mirnaya O.
--##REMARKS Date: 05.12.2011

--##RETURNS Function returns updated from condition for specified search table from specified "union" part of the query.


/*
--Example of a call of function:
declare	@idflQuery				bigint
declare	@idfUnionSearchTable	bigint
declare	@idfSearchTable			bigint
declare	@strJoinType			varchar(15)
declare	@strFrom				nvarchar(MAX)
declare	@strJoinCondition		nvarchar(2000)


select	dbo.fnAsGetFrom
		(	@idflQuery,
			@idfUnionSearchTable,
			@idfSearchTable,
			@strJoinType,
			@strFrom,
			@strJoinCondition
		)

*/


CREATE	function	[dbo].[fnAsGetFrom]
(
	@idflQuery				bigint,			--##PARAM @idflQuery Id of specified query 
	@idfUnionSearchTable	bigint,			--##PARAM @idfUnionSearchTable Id of specified search table associated to the "union" part
	@idfSearchTable			bigint,			--##PARAM @idfSearchTable Id of specified search table included in the query
	@strJoinType			varchar(15),	--##PARAM @strJoinType Type of the join of specified table (from, inner join, or left join)
	@strFrom				nvarchar(MAX),	--##PARAM @strFrom Initial from condition of specified search table
	@strJoinCondition		nvarchar(2000),	--##PARAM @strJoinCondition Condition of join between specified search table and its parent search table
	@intMaxQueryJoinLevel	int = 2			--##PARAM @intMaxQueryJoinLevel Maximum level of sub-tables in the query
)
returns nvarchar(MAX)
as
begin

	-- Define result from condition
	declare @from		nvarchar(MAX)

	if	exists	(
			select	*
			from		tasSearchField sf
			inner join	tasFieldSourceForTable fst
			on			fst.idfsSearchField = sf.idfsSearchField
						and fst.idfUnionSearchTable = @idfUnionSearchTable
						and fst.idfSearchTable = @idfSearchTable
			where		sf.idfsSearchFieldType = 10081003		-- FF Field
						and sf.intRowStatus = 0
				)
	begin
		-- Create from condition for FF tables
		set @from = dbo.fnAsGetFFFrom	(
							@idflQuery, 
							@idfUnionSearchTable, 
							@idfSearchTable, 
							@strFrom,
							@strJoinCondition
										)
	end
	else begin
		-- Create from condition for non FF tables

		-- Define Separator
		declare	@s			varchar(20)
		set @s = '
'
		if	@intMaxQueryJoinLevel <= 2
			set	@from = replace(@strJoinType + @strFrom + @s + IsNull(@strJoinCondition, N''), N'{0}', N'')
		else
			set	@from = replace(@strJoinType + replace(@strFrom, N'{1}', N'') + @s + IsNull(@strJoinCondition, N''), N'{0}', N'') + @s + N'{1}'

	end

	return @from

end



