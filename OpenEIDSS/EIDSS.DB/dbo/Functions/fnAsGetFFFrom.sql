

--##SUMMARY Returns updated from condition for specified search table related to FF fields
--##RETURNS from specified "union" part of the query.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 27.04.2010

--##REMARKS UPDATED BY: Mirnaya O.
--##REMARKS Date: 05.12.2011

--##RETURNS Function returns updated from condition for specified search table related to FF fields
--##RETURNS from specified "union" part of the query.


/*
--Example of a call of function:
declare	@idflQuery				bigint
declare	@idfUnionSearchTable	bigint
declare	@idfSearchTable			bigint
declare	@strFrom				nvarchar(MAX)
declare	@strJoinCondition		nvarchar(2000)


select	dbo.fnAsGetFFFrom
		(	@idflQuery,
			@idfUnionSearchTable,
			@idfSearchTable,
			@strFrom,
			@strJoinCondition
		)

*/


CREATE	function	[dbo].[fnAsGetFFFrom]
(
	@idflQuery				bigint,			--##PARAM @idflQuery Id of specified query 
	@idfUnionSearchTable	bigint,			--##PARAM @idfUnionSearchTable Id of specified search table associated to the "union" part
	@idfSearchTable			bigint,			--##PARAM @idfSearchTable Id of specified search table included in the query
	@strFrom				nvarchar(MAX),	--##PARAM @strFrom Initial from condition of specified search table
	@strJoinCondition		nvarchar(2000)	--##PARAM @strJoinCondition Condition of join between specified search table and its parent search table
)
returns nvarchar(MAX)
as
begin

	-- Define result from condition
	declare @from		nvarchar(MAX)
	set	@from = ''

		-- Create from condition for non FF table and related parameters

		-- Define separator
		declare	@s			varchar(20)
		set @s = '
'

		-- Generate from condition
	select		@from = @from + 
				IsNull	(
					replace	(	replace(
									N'
left join ' + @s + replace(replace(@strFrom, N'{(}', N''), N'{)}', N'') + @s + 
replace(@strJoinCondition, N'{2}', cast(p.idfsParameter as varchar(20))), 
									N'{1}', 
									N''), 
								N'{0}',
								N'_' + cast(p.idfsParameter as varchar(20))
							),
					N''	)

	from		tasQuerySearchField qsf
	inner join	(
		tasQuerySearchObject qso
		inner join	tasSearchObject sob
		on			sob.idfsSearchObject = qso.idfsSearchObject
					and sob.intRowStatus = 0
		inner join	trtBaseReference br_ft
		on			br_ft.idfsBaseReference = sob.idfsFormType
					and br_ft.idfsReferenceType = 19000034		-- Form Type
					and br_ft.intRowStatus = 0
				)
	on			qso.idfQuerySearchObject = qsf.idfQuerySearchObject
				and qso.idflQuery = @idflQuery
	inner join	tasSearchField sf
	on			sf.idfsSearchField = qsf.idfsSearchField
				and sf.idfsSearchObject = sob.idfsSearchObject
				and sf.idfsSearchFieldType = 10081003			-- FF Field
				and sf.intRowStatus = 0

	inner join	tasFieldSourceForTable fst
	on			fst.idfsSearchField = sf.idfsSearchField
				and fst.idfUnionSearchTable = @idfUnionSearchTable
				and fst.idfSearchTable = @idfSearchTable

	inner join	(
		ffParameter p
		inner join	trtBaseReference br_p
		on			br_p.idfsBaseReference = p.idfsParameter
					and br_p.intRowStatus = 0
		inner join	ffParameterType pt
		on			pt.idfsParameterType = p.idfsParameterType
					and pt.intRowStatus = 0
		inner join	trtBaseReference br_pt
		on			br_pt.idfsBaseReference = pt.idfsParameterType
					and br_pt.intRowStatus = 0
				)
	on			p.idfsParameter = qsf.idfsParameter
				and p.idfsFormType = sob.idfsFormType
				and p.intRowStatus = 0

	return @from

end


