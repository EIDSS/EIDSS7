

--##SUMMARY Creates a new function for specified query.
--##SUMMARY  If a function with the same name already exists, it will be dropped and re-created.


--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 25.04.2010

--##REMARKS Updated by: Mirnaya O.
--##REMARKS Date: 05.12.2011

--##RETURNS Don't use

/*
--Example of a call of procedure:
declare	@QueryID	bigint

execute	spAsQueryFunction_Post	@QueryID

*/


create procedure	[dbo].[spAsQueryFunction_Post]
	 @QueryID	bigint	--##PARAM @QueryID Id of the query that corresponds result function
as
begin

exec dbo.spSetFirstDay
 
-- Define the name of the function associated with the query
declare	@functionName	nvarchar(200)
-- Define the name of the view associated with the query
declare	@viewName		nvarchar(200)

-- Select function name for the query
select	@functionName = q.strFunctionName
from	tasQuery q
where	q.idflQuery = @QueryID

if	@functionName is not null
begin

-- Generate view name
set	@viewName = @functionName
if @viewName like 'fn%'
	set	@viewName = 'vw' + right(@viewName, len(@viewName) - 2)

-- Generate SQL query for creating the function
declare @query	nvarchar(MAX)

-- Define separator
declare @s varchar(20)


-- Define @KeyFields table
declare	@KeyFields	table
(	strSearchFieldAlias	varchar(50) collate database_default not null primary key,
	intBinKey			int not null,
	blnExists			bit not null
)

insert into	@KeyFields	(strSearchFieldAlias, intBinKey, blnExists)
values	('sflHC_PatientCRRayon', 1, 0)

insert into	@KeyFields	(strSearchFieldAlias, intBinKey, blnExists)
values	('sflHC_PatientCRRegion', 2, 0)

insert into	@KeyFields	(strSearchFieldAlias, intBinKey, blnExists)
values	('sflHC_FinalDiagnosis', 4, 0)

--insert into	@KeyFields	(strSearchFieldAlias, intBinKey, blnExists)
--values	('sflHC_FinalDiagnosisCode', 8, 0)

insert into	@KeyFields	(strSearchFieldAlias, intBinKey, blnExists)
values	('sflVC_FarmAddressRayon', 16, 0)

insert into	@KeyFields	(strSearchFieldAlias, intBinKey, blnExists)
values	('sflVC_FarmAddressRegion', 32, 0)

insert into	@KeyFields	(strSearchFieldAlias, intBinKey, blnExists)
values	('sflVC_Diagnosis', 64, 0)

insert into	@KeyFields	(strSearchFieldAlias, intBinKey, blnExists)
values	('sflZD_Region', 128, 0)

insert into	@KeyFields	(strSearchFieldAlias, intBinKey, blnExists)
values	('sflZD_Rayon', 256, 0)

insert into	@KeyFields	(strSearchFieldAlias, intBinKey, blnExists)
values	('sflZD_Diagnosis', 512, 0)


update		kf
set			kf.blnExists = 1
from		@KeyFields kf
inner join	tasSearchField sf
on			sf.strSearchFieldAlias = kf.strSearchFieldAlias COLLATE DATABASE_DEFAULT
			and sf.idfsSearchFieldType <> 10081003			-- FF Field
inner join	(
	tasQuerySearchField qsf
	inner join	tasQuerySearchObject qso
	on			qso.idfQuerySearchObject = qsf.idfQuerySearchObject
	inner join	tasQuery q
	on			q.idflQuery = qso.idflQuery
			)
on			qsf.idfsSearchField = sf.idfsSearchField
where		qso.idflQuery = @QueryID
			and q.blnAddAllKeyFieldValues = 1

-- Define binary key of key reference field included in the query
declare	@BinKey	int
set	@BinKey = 0
select	@BinKey = sum(intBinKey * cast(blnExists as int))
from	@KeyFields

-- Exclude key reference fields if there are items of two groups simultaneously:
--	1) Group 1:
--		- Human Case Final Diagnosis
--		- Human Case Final Diagnosis Code
--		- Patient Current Residence Region
--		- Patient Current Residence Rayon 
--	2) Group 2:
--		- Vet Case Diagnosis
--		- Farm Address - Region
--		- Farm Address - Rayon

if	((@BinKey & 1 = 1) or (@BinKey & 2 = 2) or (@BinKey & 4 = 4)) -- Group 1
	and	((@BinKey & 16 = 16) or (@BinKey & 32 = 32) or (@BinKey & 64 = 64))	-- Group 2
begin
	set	@BinKey = 0
end


-- Generate "Select" and "From" parts (for "union") of the query
declare	@QueryParts	table
(	idfUnionSearchTable	bigint not null primary key,
	strSelect			nvarchar(MAX) collate database_default null,
	strFrom				nvarchar(MAX) collate database_default null,
	strRowStatusWhere	nvarchar(200) collate database_default null
)

-- Add "union" tables
insert into	@QueryParts	(idfUnionSearchTable)
select distinct
			mto.idfMainSearchTable
from		tasQuerySearchObject qso
inner join	tasSearchObject sob
on			sob.idfsSearchObject = qso.idfsSearchObject
			and sob.intRowStatus = 0
inner join	tasMainTableForObject mto
on			mto.idfsSearchObject = sob.idfsSearchObject
inner join	tasSearchTable st_main
on			st_main.idfSearchTable = mto.idfMainSearchTable
where		qso.idflQuery = @QueryID
			and	exists	(
					select		*
					from		tasMainTableForObject mto_union
					where		mto_union.idfsSearchObject = sob.idfsSearchObject
								and mto_union.idfMainSearchTable <> mto.idfMainSearchTable
						)

-- Add main table of the root object if "union" tables don't exist
if	not exists	(
		select	*
		from	@QueryParts
			)
begin

	insert into	@QueryParts	(idfUnionSearchTable)
	select		mto.idfMainSearchTable
	from		tasQuerySearchObject qso_root
	inner join	tasSearchObject sob
	on			sob.idfsSearchObject = qso_root.idfsSearchObject
				and sob.intRowStatus = 0
	inner join	tasMainTableForObject mto
	on			mto.idfsSearchObject = sob.idfsSearchObject
	inner join	tasSearchTable st_main
	on			st_main.idfSearchTable = mto.idfMainSearchTable
	where		qso_root.idflQuery = @QueryID
				and qso_root.idfParentQuerySearchObject is null

end

-- Create @AllSearchTable table of all search tables that should be included to the query
-- for every "union" part
declare	@AllSearchTable table
(	idfUnionSearchTable		bigint not null,
	idfMainSearchTable		bigint not null,
	idfSearchTable			bigint not null,
	idfParentSearchTable	bigint null,
	strJoinType				varchar(20) collate database_default not null,
	strFrom					nvarchar(MAX) collate database_default not null,
	strJoinCondition		nvarchar(2000) collate database_default not null,
	primary key nonclustered 
	(idfUnionSearchTable asc, idfSearchTable asc) on [PRIMARY]
)

-- Add main search table(-s) of the root object with the "from" join type
insert into	@AllSearchTable
(	idfUnionSearchTable,
	idfMainSearchTable,
	idfSearchTable,
	idfParentSearchTable,
	strJoinType,
	strFrom,
	strJoinCondition
)
select		
			qp.idfUnionSearchTable,
			st_main.idfSearchTable,
			st_main.idfSearchTable,
			null,
			'from 
',
			st_main.strFrom,
			''
from		tasQuerySearchObject qso_root
inner join	tasSearchObject sob
on			sob.idfsSearchObject = qso_root.idfsSearchObject
			and sob.intRowStatus = 0
inner join	tasMainTableForObject mto
on			mto.idfsSearchObject = sob.idfsSearchObject
inner join	tasSearchTable st_main
on			st_main.idfSearchTable = mto.idfMainSearchTable
inner join	@QueryParts qp
on			qp.idfUnionSearchTable = st_main.idfSearchTable
			or	not exists	(
						select		*
						from		tasMainTableForObject mto_union
						where		mto_union.idfsSearchObject = sob.idfsSearchObject
									and mto_union.idfMainSearchTable <> mto.idfMainSearchTable
							)
where		qso_root.idflQuery = @QueryID
			and qso_root.idfParentQuerySearchObject is null

-- Add search tables related to selected fields of root object with the correct join types
insert into	@AllSearchTable
(	idfUnionSearchTable,
	idfMainSearchTable,
	idfSearchTable,
	idfParentSearchTable,
	strJoinType,
	strFrom,
	strJoinCondition
)
select	distinct
			qp.idfUnionSearchTable,
			st_main.idfSearchTable,
			st.idfSearchTable,
			stjr.idfParentSearchTable,
			case
				when	st.blnPrimary = 1
					then	'inner join 
'
				else	'left join 
'
			end,
			st.strFrom,
			stjr.strJoinCondition

from		tasQuerySearchField qsf
inner join	tasSearchField sf
on			sf.idfsSearchField = qsf.idfsSearchField
			and sf.intRowStatus = 0

inner join	tasQuerySearchObject qso_root
on			qso_root.idfQuerySearchObject = qsf.idfQuerySearchObject
			and qso_root.idfParentQuerySearchObject is null
inner join	tasSearchObject sob
on			sob.idfsSearchObject = qso_root.idfsSearchObject
			and sob.intRowStatus = 0

inner join	tasMainTableForObject mto
on			mto.idfsSearchObject = sob.idfsSearchObject
inner join	tasSearchTable st_main
on			st_main.idfSearchTable = mto.idfMainSearchTable

inner join	@QueryParts qp
on			qp.idfUnionSearchTable = st_main.idfSearchTable
			or	not exists	(
						select		*
						from		tasMainTableForObject mto_union
						where		mto_union.idfsSearchObject = sob.idfsSearchObject
									and mto_union.idfMainSearchTable <> mto.idfMainSearchTable
							)

inner join	tasFieldSourceForTable fst
on			fst.idfsSearchField = sf.idfsSearchField
			and fst.idfUnionSearchTable = qp.idfUnionSearchTable
inner join	tasSearchTable st
on			st.idfSearchTable = fst.idfSearchTable

inner join	tasSearchTableJoinRule stjr
on			stjr.idfSearchTable = st.idfSearchTable
			and stjr.idfMainSearchTable = st_main.idfSearchTable
			and stjr.idfUnionSearchTable = qp.idfUnionSearchTable


left join	@AllSearchTable st_all_ex
on			st_all_ex.idfSearchTable = st.idfSearchTable
			and st_all_ex.idfUnionSearchTable = qp.idfUnionSearchTable

where		qso_root.idflQuery = @QueryID
			and st_all_ex.idfSearchTable is null


-- Mandatory Report Type filter
declare	@idfsReportType	bigint
declare	@ReportTypeFilter nvarchar(1000)
declare	@ReportTypeFieldAlias nvarchar(200)

select		@idfsReportType = qso_root.idfsReportType
from		tasQuery q
inner join	tasQuerySearchObject qso_root
on			qso_root.idflQuery = q.idflQuery
			and qso_root.idfParentQuerySearchObject is null
			and qso_root.idfsReportType in
				(	4578940000001,	-- Active
					4578940000002	-- Passive
				)
where		q.idflQuery = @QueryID

set	@ReportTypeFilter = N''

if	@idfsReportType is not null
begin
	select		@ReportTypeFieldAlias = sf.strSearchFieldAlias
	from		tasSearchField sf
	inner join	tasQuerySearchObject qso_root
	on			qso_root.idflQuery = @QueryID
				and qso_root.idfsSearchObject = sf.idfsSearchObject
				and qso_root.idfParentQuerySearchObject is null
	where		sf.intRowStatus = 0
				and sf.idfsReferenceType = 19000144	-- Case Report Type
				and exists	(
						select	*
						from	tasFieldSourceForTable fst
						where	fst.idfsSearchField = sf.idfsSearchField
								and (	fst.strFieldText like N'%idfsReportType%'
										or	fst.strFieldText like N'%idfsCaseReportType%'
									)
							)	

	if	@ReportTypeFieldAlias is not null
	begin
		set	@ReportTypeFilter = N'(v.[' + @ReportTypeFieldAlias + N'_ID] = ' + cast(@idfsReportType as nvarchar(20)) + N') '

		-- Add table of search field "Report Type"
		insert into	@AllSearchTable
		(	idfUnionSearchTable,
			idfMainSearchTable,
			idfSearchTable,
			idfParentSearchTable,
			strJoinType,
			strFrom,
			strJoinCondition
		)
		select	distinct
					qp.idfUnionSearchTable,
					st_main.idfSearchTable,
					st.idfSearchTable,
					stjr.idfParentSearchTable,
					case
						when	st.blnPrimary = 1
							then	'inner join 
		'
						else	'left join 
		'
					end,
					st.strFrom,
					stjr.strJoinCondition

		from		tasSearchField sf

		inner join	tasQuerySearchObject qso_root
		on			qso_root.idfsSearchObject = sf.idfsSearchObject
					and qso_root.idfParentQuerySearchObject is null
		inner join	tasSearchObject sob
		on			sob.idfsSearchObject = qso_root.idfsSearchObject
					and sob.intRowStatus = 0

		inner join	tasMainTableForObject mto
		on			mto.idfsSearchObject = sob.idfsSearchObject
		inner join	tasSearchTable st_main
		on			st_main.idfSearchTable = mto.idfMainSearchTable

		inner join	@QueryParts qp
		on			qp.idfUnionSearchTable = st_main.idfSearchTable
					or	not exists	(
								select		*
								from		tasMainTableForObject mto_union
								where		mto_union.idfsSearchObject = sob.idfsSearchObject
											and mto_union.idfMainSearchTable <> mto.idfMainSearchTable
									)

		inner join	tasFieldSourceForTable fst
		on			fst.idfsSearchField = sf.idfsSearchField
					and fst.idfUnionSearchTable = qp.idfUnionSearchTable
		inner join	tasSearchTable st
		on			st.idfSearchTable = fst.idfSearchTable

		inner join	tasSearchTableJoinRule stjr
		on			stjr.idfSearchTable = st.idfSearchTable
					and stjr.idfMainSearchTable = st_main.idfSearchTable
					and stjr.idfUnionSearchTable = qp.idfUnionSearchTable


		left join	@AllSearchTable st_all_ex
		on			st_all_ex.idfSearchTable = st.idfSearchTable
					and st_all_ex.idfUnionSearchTable = qp.idfUnionSearchTable

		where		qso_root.idflQuery = @QueryID
					and	sf.strSearchFieldAlias = @ReportTypeFieldAlias
					and sf.intRowStatus = 0
					and st_all_ex.idfSearchTable is null
	end

end


-- Add mandatory table of root object with the correct join types
insert into	@AllSearchTable
(	idfUnionSearchTable,
	idfMainSearchTable,
	idfSearchTable,
	idfParentSearchTable,
	strJoinType,
	strFrom,
	strJoinCondition
)
select	distinct
			qp.idfUnionSearchTable,
			st_main.idfSearchTable,
			st.idfSearchTable,
			stjr.idfParentSearchTable,
			case
				when	st.blnPrimary = 1
					then	'inner join 
'
				else	'left join 
'
			end,
			st.strFrom,
			stjr.strJoinCondition

from		tasQuerySearchObject qso_root
inner join	tasSearchObject sob
on			sob.idfsSearchObject = qso_root.idfsSearchObject
			and sob.intRowStatus = 0

inner join	tasMainTableForObject mto
on			mto.idfsSearchObject = sob.idfsSearchObject
inner join	tasSearchTable st_main
on			st_main.idfSearchTable = mto.idfMainSearchTable

inner join	@QueryParts qp
on			qp.idfUnionSearchTable = st_main.idfSearchTable
			or	not exists	(
						select		*
						from		tasMainTableForObject mto_union
						where		mto_union.idfsSearchObject = sob.idfsSearchObject
									and mto_union.idfMainSearchTable <> mto.idfMainSearchTable
							)

inner join	tasSearchTable st	-- Mandatory Search Table for root object
on			st.idfSearchTable = mto.idfMandatorySearchTable
			and st.idfSearchTable <> mto.idfMainSearchTable

inner join	tasSearchTableJoinRule stjr
on			stjr.idfSearchTable = st.idfSearchTable
			and stjr.idfMainSearchTable = st_main.idfSearchTable
			and stjr.idfUnionSearchTable = qp.idfUnionSearchTable


left join	@AllSearchTable st_all_ex
on			st_all_ex.idfSearchTable = st.idfSearchTable
			and st_all_ex.idfUnionSearchTable = qp.idfUnionSearchTable

where		qso_root.idflQuery = @QueryID
			and qso_root.idfParentQuerySearchObject is null
			and st_all_ex.idfSearchTable is null



-- Define a flag of the end of the cycle
declare @GoOn int
set @GoOn = 1

-- Add parent search tables of tables related to fields or mandatory table of root object with the correct join types
while	@GoOn > 0
begin
	insert into	@AllSearchTable
	(	idfUnionSearchTable,
		idfMainSearchTable,
		idfSearchTable,
		idfParentSearchTable,
		strJoinType,
		strFrom,
		strJoinCondition
	)
	select	distinct
				st_all.idfUnionSearchTable,
				st_all.idfMainSearchTable,
				st_parent.idfSearchTable,
				st_parent_parent.idfSearchTable,
				case
					when	st_parent.blnPrimary = 1
						then	'inner join 
'
					else	'left join 
'
				end,
				st_parent.strFrom,
				stjr_parent.strJoinCondition
	from		@AllSearchTable st_all
	inner join	tasSearchTableJoinRule stjr
	on			stjr.idfSearchTable = st_all.idfSearchTable
				and stjr.idfUnionSearchTable = st_all.idfUnionSearchTable
				and stjr.idfMainSearchTable = st_all.idfMainSearchTable
	inner join	tasSearchTable st_parent
	on			st_parent.idfSearchTable = stjr.idfParentSearchTable

	inner join	(
		tasSearchTableJoinRule stjr_parent
		inner join	tasSearchTable st_parent_parent
		on			st_parent_parent.idfSearchTable = stjr_parent.idfParentSearchTable
				)
	on			stjr_parent.idfUnionSearchTable = stjr.idfUnionSearchTable
				and stjr_parent.idfMainSearchTable = stjr.idfMainSearchTable
				and stjr_parent.idfSearchTable = st_parent.idfSearchTable

	left join	@AllSearchTable st_all_ex
	on			st_all_ex.idfSearchTable = st_parent.idfSearchTable
				and st_all_ex.idfUnionSearchTable = st_all.idfUnionSearchTable
	where		st_all_ex.idfSearchTable is null

	set	@GoOn = @@rowcount
end

-- Add search tables related to selected fields of child objects with the "left" join type
insert into	@AllSearchTable
(	idfUnionSearchTable,
	idfMainSearchTable,
	idfSearchTable,
	idfParentSearchTable,
	strJoinType,
	strFrom,
	strJoinCondition
)
select	distinct
			qp.idfUnionSearchTable,
			st_main.idfSearchTable,
			st.idfSearchTable,
			stjr.idfParentSearchTable,
			'left join 
',
			st.strFrom,
			stjr.strJoinCondition

from		tasQuerySearchField qsf
inner join	tasSearchField sf
on			sf.idfsSearchField = qsf.idfsSearchField
			and sf.intRowStatus = 0

inner join	tasQuerySearchObject qso_child
on			qso_child.idfQuerySearchObject = qsf.idfQuerySearchObject
			and qso_child.idfParentQuerySearchObject is not null

inner join	tasQuerySearchObject qso_root
on			qso_root.idfQuerySearchObject = qso_child.idfParentQuerySearchObject
			and qso_root.idfParentQuerySearchObject is null
inner join	tasSearchObject sob_root
on			sob_root.idfsSearchObject = qso_root.idfsSearchObject
			and sob_root.intRowStatus = 0

inner join	tasMainTableForObject mto_root
on			mto_root.idfsSearchObject = sob_root.idfsSearchObject
inner join	tasSearchTable st_main
on			st_main.idfSearchTable = mto_root.idfMainSearchTable

inner join	@QueryParts qp
on			qp.idfUnionSearchTable = st_main.idfSearchTable
			or	not exists	(
						select		*
						from		tasMainTableForObject mto_union
						where		mto_union.idfsSearchObject = sob_root.idfsSearchObject
									and mto_union.idfMainSearchTable <> mto_root.idfMainSearchTable
							)

inner join	tasFieldSourceForTable fst
on			fst.idfsSearchField = sf.idfsSearchField
			and fst.idfUnionSearchTable = qp.idfUnionSearchTable
inner join	tasSearchTable st
on			st.idfSearchTable = fst.idfSearchTable

inner join	tasSearchTableJoinRule stjr
on			stjr.idfSearchTable = st.idfSearchTable
			and stjr.idfMainSearchTable = st_main.idfSearchTable
			and stjr.idfUnionSearchTable = qp.idfUnionSearchTable

left join	@AllSearchTable st_all_ex
on			st_all_ex.idfSearchTable = st.idfSearchTable
			and st_all_ex.idfUnionSearchTable = qp.idfUnionSearchTable

where		qso_child.idflQuery = @QueryID
			and st_all_ex.idfSearchTable is null

-- Add mandatory tables of child objects with the "left" join type
insert into	@AllSearchTable
(	idfUnionSearchTable,
	idfMainSearchTable,
	idfSearchTable,
	idfParentSearchTable,
	strJoinType,
	strFrom,
	strJoinCondition
)
select	distinct
			qp.idfUnionSearchTable,
			st_main.idfSearchTable,
			st.idfSearchTable,
			stjr.idfParentSearchTable,
			'left join 
',
			st.strFrom,
			stjr.strJoinCondition

from		tasQuerySearchObject qso_child

inner join	tasSearchObject sob_child
on			sob_child.idfsSearchObject = qso_child.idfsSearchObject
			and sob_child.intRowStatus = 0

inner join	tasQuerySearchObject qso_root
on			qso_root.idfQuerySearchObject = qso_child.idfParentQuerySearchObject
			and qso_root.idfParentQuerySearchObject is null
inner join	tasSearchObject sob_root
on			sob_root.idfsSearchObject = qso_root.idfsSearchObject
			and sob_root.intRowStatus = 0

inner join	tasMainTableForObject mto_root
on			mto_root.idfsSearchObject = sob_root.idfsSearchObject
inner join	tasSearchTable st_main
on			st_main.idfSearchTable = mto_root.idfMainSearchTable

inner join	@QueryParts qp
on			qp.idfUnionSearchTable = st_main.idfSearchTable
			or	not exists	(
						select		*
						from		tasMainTableForObject mto_union
						where		mto_union.idfsSearchObject = sob_root.idfsSearchObject
									and mto_union.idfMainSearchTable <> mto_root.idfMainSearchTable
							)

inner join	tasMainTableForObject mto
on			mto.idfsSearchObject = sob_child.idfsSearchObject
			and mto.idfMainSearchTable = st_main.idfSearchTable
inner join	tasSearchTable st	-- Mandatory Search Table for child object
on			st.idfSearchTable = mto.idfMandatorySearchTable
			and st.idfSearchTable <> mto.idfMainSearchTable

inner join	tasSearchTableJoinRule stjr
on			stjr.idfSearchTable = st.idfSearchTable
			and stjr.idfMainSearchTable = st_main.idfSearchTable
			and stjr.idfUnionSearchTable = qp.idfUnionSearchTable

left join	@AllSearchTable st_all_ex
on			st_all_ex.idfSearchTable = st.idfSearchTable
			and st_all_ex.idfUnionSearchTable = qp.idfUnionSearchTable

where		qso_child.idflQuery = @QueryID
			and qso_child.idfParentQuerySearchObject is not null
			and st_all_ex.idfSearchTable is null



-- Reset a flag of the end of the cycle
set	@GoOn = 1

-- Add parent search tables of tables related to fields or mandatory tables of child objects with the "left" join type
while	@GoOn > 0
begin
	insert into	@AllSearchTable
	(	idfUnionSearchTable,
		idfMainSearchTable,
		idfSearchTable,
		idfParentSearchTable,
		strJoinType,
		strFrom,
		strJoinCondition
	)
	select	distinct
				st_all.idfUnionSearchTable,
				st_all.idfMainSearchTable,
				st_parent.idfSearchTable,
				st_parent_parent.idfSearchTable,
				'left join 
',
				st_parent.strFrom,
				stjr_parent.strJoinCondition

	from		@AllSearchTable st_all
	inner join	tasSearchTableJoinRule stjr
	on			stjr.idfSearchTable = st_all.idfSearchTable
				and stjr.idfUnionSearchTable = st_all.idfUnionSearchTable
				and stjr.idfMainSearchTable = st_all.idfMainSearchTable
	inner join	tasSearchTable st_parent
	on			st_parent.idfSearchTable = stjr.idfParentSearchTable

	inner join	(
		tasSearchTableJoinRule stjr_parent
		inner join	tasSearchTable st_parent_parent
		on			st_parent_parent.idfSearchTable = stjr_parent.idfParentSearchTable
				)
	on			stjr_parent.idfUnionSearchTable = stjr.idfUnionSearchTable
				and stjr_parent.idfMainSearchTable = stjr.idfMainSearchTable
				and stjr_parent.idfSearchTable = st_parent.idfSearchTable

	left join	@AllSearchTable st_all_ex
	on			st_all_ex.idfSearchTable = st_parent.idfSearchTable
				and st_all_ex.idfUnionSearchTable = st_all.idfUnionSearchTable
	where		st_all_ex.idfSearchTable is null

	set	@GoOn = @@rowcount
end

-- Create @fromTable table of all search tables that should be included to the query 
-- with updated from (including ordinary and GIS reference tables) condition and level
-- for every "union" part
declare	@fromTable table
(	idfUnionSearchTable		bigint not null,
	idfSearchTable			bigint not null,
	strFrom					nvarchar(MAX) collate database_default not null,
	fromLevel				int not null,
	primary key	(
		idfSearchTable asc, idfUnionSearchTable asc
				)
)

;
with	fromTable	(
			idfUnionSearchTable,
			idfSearchTable,
			strFrom,
			fromLevel
					)
as	(	select		st_main.idfUnionSearchTable,
					st_main.idfSearchTable,
					dbo.fnAsGetFrom	(
							@QueryID, 
							st_main.idfUnionSearchTable,
							st_main.idfSearchTable, 
							st_main.strJoinType, 
							st_main.strFrom,
							st_main.strJoinCondition,
							1	-- Default number of levels of joined sub-tables
									) as strFrom,
					0 as fromLevel
		from		@AllSearchTable st_main
		where		st_main.idfParentSearchTable is null
		union all
		select		st_all.idfUnionSearchTable,
					st_all.idfSearchTable,
					dbo.fnAsGetFrom	(
							@QueryID, 
							st_all.idfUnionSearchTable, 
							st_all.idfSearchTable, 
							st_all.strJoinType, 
							st_all.strFrom,
							st_all.strJoinCondition,
							1	-- Default number of levels of joined sub-tables
									) as strFrom,
					fromTable.fromLevel + 1 as fromLevel
		from		@AllSearchTable st_all
		inner join	fromTable
		on			fromTable.idfSearchTable = st_all.idfParentSearchTable
					and fromTable.idfUnionSearchTable = st_all.idfUnionSearchTable
	)

insert into	@fromTable
(	idfUnionSearchTable,
	idfSearchTable,
	strFrom,
	fromLevel
)
select	fTRec.idfUnionSearchTable,
		fTRec.idfSearchTable,
		fTRec.strFrom,
		fTRec.fromLevel
from	fromTable fTRec

-- Define the table with current levels of the table included to the from condition
-- for every "union" parts
declare	@Level	table
(	idfUnionSearchTable	bigint not null primary key,
	intLevel			int not null
)

insert into	@Level
(	idfUnionSearchTable,
	intLevel
)
select		ft.idfUnionSearchTable, max(ft.fromLevel) - 1
from		@fromTable ft
group by	ft.idfUnionSearchTable


-- Define the table with maximum levels of the table included to the from condition
-- for every "union" parts
declare	@MaxLevel	table
(	idfUnionSearchTable	bigint not null primary key,
	intMaxLevel			int not null
)

insert into	@MaxLevel
(	idfUnionSearchTable,
	intMaxLevel
)
select		l.idfUnionSearchTable,
			max(l.intLevel)
from		@Level l
group by	l.idfUnionSearchTable


-- Update From condition for "union" parts with maximum level of the table included to the from condition greater than 3
update		ft
set			ft.strFrom = 
				dbo.fnAsGetFrom	(
					@QueryID, 
					ft.idfUnionSearchTable, 
					ft.idfSearchTable, 
					st.strJoinType, 
					st.strFrom,
					st.strJoinCondition,
					ml.intMaxLevel
								)

from		@fromTable ft
inner join	@MaxLevel ml
on			ml.idfUnionSearchTable = ft.idfUnionSearchTable
			and ml.intMaxLevel > 2
inner join	@AllSearchTable st
on			st.idfSearchTable = ft.idfSearchTable
			and st.idfUnionSearchTable = ft.idfUnionSearchTable

-- Create @finalFromTable table of all search tables that should be included to the query 
-- with final from (including ordinary and GIS reference tables and child from conditions) conditions and levels
-- for every "union" part
declare	@finalFromTable table
(	idfUnionSearchTable		bigint not null,
	idfSearchTable			bigint not null,
	strFrom					nvarchar(MAX) collate database_default not null,
	fromLevel				int not null,
	primary key	(
		idfSearchTable asc,
		idfUnionSearchTable asc
				)
)

-- Add search tables with their from conditions of maximum levels
-- for every "union" part
insert into	@finalFromTable
(	idfUnionSearchTable,
	idfSearchTable,
	strFrom,
	fromLevel
)
select		ft.idfUnionSearchTable,
			ft.idfSearchTable,
			-- Remove brackets and internal join condition ({1}) 
			--		for single tables
			--		or for tables within "union" parts with maximum level of joined sub-tables greater than 3,
			-- or replace special brackets to ordinary ones for complex join condition
			case
				when	charindex('join', ft.strFrom, charindex('join', ft.strFrom) + 1) = 0
						or	ml.intMaxLevel > 2
					then	replace(replace(replace(ft.strFrom, '{1}', ''), '{(}', ''), '{)}', '')
				else	replace(replace(replace(ft.strFrom, '{1}', ''), '{(}', '('), '{)}', ')')
			end,
			ft.fromLevel
from		@fromTable ft
inner join	@Level l
on			l.idfUnionSearchTable = ft.idfUnionSearchTable
			and l.intLevel = ft.fromLevel - 1
inner join	@MaxLevel ml
on			ml.idfUnionSearchTable = ft.idfUnionSearchTable



-- Define current final from condition (including child from conditions)
declare	@strCurFinalFrom	nvarchar(MAX)
-- Define current from condition (without child from conditions)
declare	@strCurFrom			nvarchar(MAX)

-- Define current "union" part
declare	@idfCurUnionSearchTable	bigint
-- Define current search table
declare	@idfCurSearchTable	bigint
-- Define maximum level of joined sub-tables for current "union" part
declare	@intMaxLevel int

-- Set separator value
set @s = '
'

-- Add search tables with final from conditions of all levels ordered by their levels
-- for every "union" part
while exists	(
		select	*
		from	@Level l
		where	l.intLevel >= 0
				)
begin
	-- Define cursor for @fromTable table with current level
	declare	TableCursor	cursor local read_only forward_only for
		select		ft.idfUnionSearchTable,
					ft.idfSearchTable,
					ft.strFrom,
					ml.intMaxLevel
		from		@fromTable ft
		inner join	@Level l
		on			l.idfUnionSearchTable = ft.idfUnionSearchTable
					and l.intLevel = ft.fromLevel
					and l.intLevel >= 0
		inner join	@MaxLevel ml
		on			ml.idfUnionSearchTable = ft.idfUnionSearchTable
	open TableCursor
	fetch next from	TableCursor into	@idfCurUnionSearchTable, @idfCurSearchTable, @strCurFrom, @intMaxLevel

	while @@fetch_status <> -1
	begin
		set	@strCurFinalFrom = @strCurFrom

		-- Generate final from condition (@strCurFinalFrom) for current search table
		select		@strCurFinalFrom = replace(@strCurFinalFrom, '{1}', fTFin_child.strFrom + @s + '{1}')
		from		@AllSearchTable st_all
		inner join	@finalFromTable fTFin_child
		on			fTFin_child.idfSearchTable = st_all.idfSearchTable
					and fTFin_child.idfUnionSearchTable = st_all.idfUnionSearchTable
		where		st_all.idfParentSearchTable = @idfCurSearchTable
					and st_all.idfUnionSearchTable = @idfCurUnionSearchTable
		order by	fTFin_child.strFrom

		-- Remove internal join condition ({1})
		set	@strCurFinalFrom = replace(@strCurFinalFrom, '{1}', '')

		-- Remove brackets 
		--		for single tables
		--		or for tables within "union" parts with maximum level of joined sub-tables greater than 3,
		-- or replace special brackets to ordinary ones for complex join condition
		if (charindex('join', @strCurFinalFrom, charindex('join', @strCurFinalFrom) + 1) = 0)
			or	@intMaxLevel > 2
			set @strCurFinalFrom = replace(replace(@strCurFinalFrom, '{(}', ''), '{)}', '')
		else	set @strCurFinalFrom = replace(replace(@strCurFinalFrom, '{(}', '('), '{)}', ')')

		-- Add generated values to @finalFromTable
		insert into	@finalFromTable
		(	idfUnionSearchTable,
			idfSearchTable,
			strFrom, 
			fromLevel	
		)
		select	@idfCurUnionSearchTable,
				@idfCurSearchTable,
				@strCurFinalFrom,
				l.intLevel
		from	@Level l
		where	l.idfUnionSearchTable = @idfCurUnionSearchTable

		fetch next from	TableCursor into	@idfCurUnionSearchTable, @idfCurSearchTable, @strCurFrom, @intMaxLevel

	end
		
	close TableCursor
	deallocate TableCursor

	update	l
	set		l.intLevel = l.intLevel - 1
	from	@Level l

end

-- Generate final from text
-- for every "union" part
declare	TableCursor	cursor local read_only forward_only for
	select		fTFin.idfUnionSearchTable,
				fTFin.strFrom
	from		@finalFromTable fTFin
	where		fTFin.fromLevel = 0
	order by	fTFin.strFrom asc
open TableCursor
fetch next from	TableCursor into	@idfCurUnionSearchTable, @strCurFrom

while @@fetch_status <> -1
begin

	update		qp
	set			qp.strFrom = IsNull(qp.strFrom, N'') + @s + replace(@strCurFrom, '{1}', '')
	from		@QueryParts qp
	where		qp.idfUnionSearchTable = @idfCurUnionSearchTable

	fetch next from	TableCursor into	@idfCurUnionSearchTable, @strCurFrom

end

close TableCursor
deallocate TableCursor

-- Generate select text

-- Define table with "select" parts containing PKField of main tables and PKField of all tables included in the query
declare	@SelectPKFields	table
(	idfUnionSearchTable	bigint not null primary key,
	strSelect			nvarchar(MAX) collate database_default null
)

-- Add PK fields of main search tables to the "select" parts
insert into	@SelectPKFields
(	idfUnionSearchTable,
	strSelect
)
select		qp.idfUnionSearchTable,
			N'select		' + replace(st_main.strPKField, '{0}', '') + N' as [PKField]'
from		@QueryParts qp
inner join	@AllSearchTable st_all
on			st_all.idfUnionSearchTable = qp.idfUnionSearchTable
			and st_all.idfSearchTable = st_all.idfMainSearchTable
			and st_all.idfParentSearchTable is null
inner join	tasSearchTable st_main
on			st_main.idfSearchTable = st_all.idfMainSearchTable
inner join	tasQuery q
on			q.idflQuery = @QueryID

-- Define source for PK field of current search table
declare	@strCurPKField	nvarchar(500)

-- Set separator value
set	@s = ', 
			'

-- Add PK fields of all search tables inculded in the query to the "select" parts
declare	TableCursor	cursor local read_only forward_only for
	select		qp.idfUnionSearchTable,
				st.idfSearchTable,
				st.strPKField
	from		@QueryParts qp
	inner join	@fromTable ft
	on			ft.idfUnionSearchTable = qp.idfUnionSearchTable
	inner join	tasSearchTable st
	on			st.idfSearchTable = ft.idfSearchTable
	where		not exists	(
						select		*
						from		tasQuerySearchField qsf
						inner join	tasQuerySearchObject qso
						on			qso.idfQuerySearchObject = qsf.idfQuerySearchObject
									and qso.idflQuery = @QueryID
						inner join	tasSearchField sf
						on			sf.idfsSearchField = qsf.idfsSearchField
									and sf.idfsSearchObject = qso.idfsSearchObject
						inner join	tasFieldSourceForTable fst
						on			fst.idfsSearchField = sf.idfsSearchField
									and fst.idfUnionSearchTable = qp.idfUnionSearchTable
									and fst.idfSearchTable = ft.idfSearchTable
						where		qsf.idfsParameter is not null
							)
	union
	select distinct
				qp.idfUnionSearchTable,
				st_another.idfSearchTable,
				N'null'
	from		@QueryParts qp
	inner join	@fromTable ft_another
		inner join	@QueryParts qp_another
		on			qp_another.idfUnionSearchTable = ft_another.idfUnionSearchTable
	on			ft_another.idfUnionSearchTable <> qp.idfUnionSearchTable
	inner join	tasSearchTable st_another
	on			st_another.idfSearchTable = ft_another.idfSearchTable
	left join	@fromTable ft_ex
		inner join	tasSearchTable st_ex
		on			st_ex.idfSearchTable = ft_ex.idfSearchTable
	on			ft_ex.idfUnionSearchTable = qp.idfUnionSearchTable
				and ft_ex.idfSearchTable = ft_another.idfSearchTable
	where		ft_ex.idfSearchTable is null
				and not exists	(
							select		*
							from		tasQuerySearchField qsf
							inner join	tasQuerySearchObject qso
							on			qso.idfQuerySearchObject = qsf.idfQuerySearchObject
										and qso.idflQuery = @QueryID
							inner join	tasSearchField sf
							on			sf.idfsSearchField = qsf.idfsSearchField
										and sf.idfsSearchObject = qso.idfsSearchObject
							inner join	tasFieldSourceForTable fst
							on			fst.idfsSearchField = sf.idfsSearchField
										and fst.idfUnionSearchTable = ft_another.idfUnionSearchTable
										and fst.idfSearchTable = ft_another.idfSearchTable
							where		qsf.idfsParameter is not null
								)
	order by	qp.idfUnionSearchTable asc,
				st.idfSearchTable asc
open TableCursor
fetch next from	TableCursor into	@idfCurUnionSearchTable, @idfCurSearchTable, @strCurPKField

while @@fetch_status <> -1
begin

	update		sPK
	set			sPK.strSelect = sPK.strSelect + @s + replace(@strCurPKField, '{0}', '') +
								N' as [PKField_' + cast(@idfCurSearchTable as nvarchar(20)) + N']'

	from		@SelectPKFields sPK
	where		sPK.idfUnionSearchTable = @idfCurUnionSearchTable
	
	fetch next from	TableCursor into	@idfCurUnionSearchTable, @idfCurSearchTable, @strCurPKField

end

close TableCursor
deallocate TableCursor


-- Add PK fields to the "select" parts and existence condition to "where" parts
update		qp
set			qp.strSelect = sPK.strSelect,
			qp.strRowStatusWhere = 
				case
					when	len(rtrim(ltrim(st_main.strExistenceCondition))) > 0
						then	N'
where		' + replace(st_main.strExistenceCondition, '{0}', '') + N'
'
					else	N'
'
				end
from		@QueryParts qp
inner join	@AllSearchTable st_all
on			st_all.idfUnionSearchTable = qp.idfUnionSearchTable
			and st_all.idfSearchTable = st_all.idfMainSearchTable
			and st_all.idfParentSearchTable is null
inner join	tasSearchTable st_main
on			st_main.idfSearchTable = st_all.idfMainSearchTable
inner join	@SelectPKFields sPK
on			sPK.idfUnionSearchTable = qp.idfUnionSearchTable

-- Set separator value
set	@s = ', 
			'

-- Define current search field that should be added to the query
-- for every "union" parts
declare	@idfsCurSearchField	bigint

-- Add non FF fields to the "select" parts
-- for every "union" parts
declare	FieldCursor	cursor local read_only forward_only for
	select		sf.idfsSearchField
	from		tasQuerySearchField qsf
	inner join	tasQuerySearchObject qso
	on			qso.idfQuerySearchObject = qsf.idfQuerySearchObject
				and qso.idflQuery = @QueryID
	inner join	tasSearchField sf
	on			sf.idfsSearchField = qsf.idfsSearchField
				and sf.idfsSearchObject = qso.idfsSearchObject
				and sf.idfsSearchFieldType <> 10081003			-- FF Field
				and sf.intRowStatus = 0
	union
	-- Report Type Field
	select		sf.idfsSearchField
	from		tasQuerySearchObject qso_root
	inner join	tasSearchField sf
	on			sf.strSearchFieldAlias = @ReportTypeFieldAlias
				and sf.idfsSearchObject = qso_root.idfsSearchObject
				and sf.idfsSearchFieldType <> 10081003			-- FF Field
				and sf.intRowStatus = 0
	where		qso_root.idfParentQuerySearchObject is null
				and qso_root.idflQuery = @QueryID

	order by	sf.idfsSearchField asc
open FieldCursor
fetch next from	FieldCursor into	@idfsCurSearchField

while @@fetch_status <> -1
begin

	update		qp
	set			qp.strSelect = qp.strSelect + 
			case
				when	sf.idfsReferenceType is null and sf.idfsGISReferenceType is null
						and (sf.blnGeoLocationString is null or sf.blnGeoLocationString = 0)
						and (sf.blnShortAddressString is null or sf.blnShortAddressString = 0)
						and (sf.strLookupFunction is null or len(ltrim(rtrim(sf.strLookupFunction))) = 0)
					then
							IsNull(@s + replace(fst.strFieldText, N'{0}', N'') + N' as [' + sf.strSearchFieldAlias + N']', N'')
				when	sf.idfsReferenceType is not null and (sf.strLookupFunction is null or len(ltrim(rtrim(sf.strLookupFunction))) = 0)
					then
							IsNull(	@s + replace(fst.strFieldText, N'{0}', N'') + N' as [' + sf.strSearchFieldAlias + N'_ID]'
----							 + @s +
----							N'[ref_' + sf.strSearchFieldAlias + N'].[name] as [' + sf.strSearchFieldAlias + ']'
									, N'')
				when	(sf.strLookupFunction is not null and len(ltrim(rtrim(sf.strLookupFunction))) > 0)
					then
							IsNull(	@s + replace(fst.strFieldText, N'{0}', N'') + N' as [' + sf.strSearchFieldAlias + N'_ID]'
----							 + @s +
----							N'[ref_' + sf.strSearchFieldAlias + N'].[' + sf.strLookupFunctionNameField + N'] as [' + sf.strSearchFieldAlias + ']'
									, N'')
				when	sf.idfsGISReferenceType is not null
					then
							IsNull(	@s + replace(fst.strFieldText, N'{0}', N'') + N' as [' + sf.strSearchFieldAlias + N'_ID]'
----							 + @s +
----							N'[ref_GIS_' + sf.strSearchFieldAlias + N'].[ExtendedName] as [' + sf.strSearchFieldAlias + N']'
									, N'')
			when	(sf.blnGeoLocationString is not null and sf.blnGeoLocationString = 1)
					then
							IsNull(	@s + replace(fst.strFieldText, N'{0}', N'') + N' as [' + sf.strSearchFieldAlias + N'_ID]'
									, N'')
			when	(sf.blnShortAddressString is not null and sf.blnShortAddressString = 1)
					then
							IsNull(	@s + replace(fst.strFieldText, N'{0}', N'') + N' as [' + sf.strSearchFieldAlias + N'_ID]'
									, N'')
				else		N''
			end

	from		@QueryParts qp
	inner join	tasFieldSourceForTable fst
	on			fst.idfUnionSearchTable = qp.idfUnionSearchTable
				and fst.idfsSearchField = @idfsCurSearchField
	inner join	tasSearchTable st
	on			st.idfSearchTable = fst.idfSearchTable
	inner join	tasSearchField sf
	on			sf.idfsSearchField = @idfsCurSearchField

	fetch next from	FieldCursor into	@idfsCurSearchField

end

close FieldCursor
deallocate FieldCursor


-- Define current FF parameter that should be added to the query
-- for every "union" parts
declare	@idfsCurParameter	bigint

-- Add FF fields to the "select" parts
-- for every "union" parts
declare	FieldCursor	cursor local read_only forward_only for
	select		sf.idfsSearchField,
				p.idfsParameter
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
				and qso.idflQuery = @QueryID
	inner join	tasSearchField sf
	on			sf.idfsSearchField = qsf.idfsSearchField
				and sf.idfsSearchObject = sob.idfsSearchObject
				and sf.idfsSearchFieldType = 10081003			-- FF Field
				and sf.intRowStatus = 0
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
	order by	sf.idfsSearchField asc, p.idfsParameter asc
open FieldCursor
fetch next from	FieldCursor into	@idfsCurSearchField, @idfsCurParameter

while @@fetch_status <> -1
begin

	update		qp
	set			qp.strSelect = qp.strSelect + 
		case
			when	pt.idfsReferenceType is null
				then
						IsNull(@s + replace(fst.strFieldText, N'{0}', 
											N'_' + cast(@idfsCurParameter as varchar(20))) + 
							N' as [' + sf.strSearchFieldAlias + N'__' + 
										cast(sob.idfsFormType as varchar(20)) + N'__' + 
										cast(@idfsCurParameter as varchar(20)) + N']', N'')
			when	pt.idfsReferenceType is not null
				then	IsNull(	@s + replace(fst.strFieldText, N'{0}', 
											N'_' + cast(@idfsCurParameter as varchar(20))) + 
								N' as [' + sf.strSearchFieldAlias + N'__' + 
								cast(sob.idfsFormType as varchar(20)) + N'__' + 
								cast(@idfsCurParameter as varchar(20)) + N'_ID]' 
----						+ @s +
----						N'[ref_' + sf.strSearchFieldAlias + N'__' + 
----								cast(sob.idfsFormType as varchar(20)) + N'__' + 
----								cast(@idfsCurParameter as varchar(20)) + 
----								N'].[name] as [' + 
----							sf.strSearchFieldAlias + N'__' + 
----							cast(sob.idfsFormType as varchar(20)) + N'__' + 
----							cast(@idfsCurParameter as varchar(20)) + ']'
								, N'')
			else		N''
		end
	from		@QueryParts qp
	inner join	tasFieldSourceForTable fst
	on			fst.idfUnionSearchTable = qp.idfUnionSearchTable
				and fst.idfsSearchField = @idfsCurSearchField
	inner join	tasSearchTable st
	on			st.idfSearchTable = fst.idfSearchTable
	inner join	tasSearchField sf
	on			sf.idfsSearchField = @idfsCurSearchField
	inner join	tasSearchObject sob
	on			sob.idfsSearchObject = sf.idfsSearchObject
	inner join	(
		ffParameter p
		inner join	ffParameterType pt
		on			pt.idfsParameterType = p.idfsParameterType
				)
	on			p.idfsParameter = @idfsCurParameter

	fetch next from	FieldCursor into	@idfsCurSearchField, @idfsCurParameter

end

close FieldCursor
deallocate FieldCursor

-- Generate view text
set	@query = N''

-- Set separator value
set	@s = N'
'

declare	@unionText	nvarchar(20)
set	@unionText = N'
'

select		@query = @query + @unionText + qp.strSelect + @s + qp.strFrom + @s + qp.strRowStatusWhere,
			@unionText = N'
union
'
from		@QueryParts  qp

-- Drop and create query view

-- define additional SQL command
declare @sqlCmd nvarchar(MAX)
set @sqlCmd = N'
SET QUOTED_IDENTIFIER ON 
'
exec sp_executesql @sqlCmd

set @sqlCmd = N'
SET ANSI_NULLS ON 
'
exec sp_executesql @sqlCmd
set @sqlCmd = N'

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[' + @viewName + N']'') AND Type = N''V'')
DROP VIEW [dbo].[' + @viewName + N']
'
exec sp_executesql @sqlCmd

set @sqlCmd = N'

CREATE VIEW [dbo].[' + @viewName + N']
as
' + @query + N'

'
exec sp_executesql @sqlCmd 
--print substring(@sqlCmd, 0, 4000)
--print substring(@sqlCmd, 4000, 4000)
--print substring(@sqlCmd, 8000, 4000)
--print substring(@sqlCmd, 12000, 4000)
--print substring(@sqlCmd, 16000, 4000)
--print substring(@sqlCmd, 20000, 4000)
--print substring(@sqlCmd, 24000, 4000)
--print substring(@sqlCmd, 28000, 4000)
--print substring(@sqlCmd, 32000, 4000)
--print substring(@sqlCmd, 36000, 4000)
--print substring(@sqlCmd, 40000, 4000)
--print substring(@sqlCmd, 44000, 4000)
--print substring(@sqlCmd, 48000, 4000)
--print substring(@sqlCmd, 52000, 4000)
--print substring(@sqlCmd, 56000, 4000)
--print substring(@sqlCmd, 60000, 4000)
--print substring(@sqlCmd, 64000, 4000)
--print substring(@sqlCmd, 72000, 4000)
--print substring(@sqlCmd, 76000, 4000)


set @sqlCmd = N'
SET QUOTED_IDENTIFIER OFF 
'
exec sp_executesql @sqlCmd

set @sqlCmd = N'
SET ANSI_NULLS ON 
'
exec sp_executesql @sqlCmd

-- Generate function text for root queries
if	exists	(	
		select	*
		from	tasQuery
		where	idflQuery = @QueryID
				and IsNull(blnSubQuery, 0) = 0
			)
begin

-- Generate "select" and "from" parts of the query
declare @select nvarchar(MAX)
set @select = N'select		'

declare @from nvarchar(MAX)
set	@from = N'from		' + @viewName + N' v
'

-- Add non FF fields to the "select" part and related lookups to the "from" part
select	@select	= @select +
		case
			when	@BinKey & 4 > 0
					and sf.strSearchFieldAlias = 'sflHC_FinalDiagnosisCode'
					and sf.idfsReferenceType is null and sf.idfsGISReferenceType is null
					and (sf.strLookupFunction is null or len(ltrim(rtrim(sf.strLookupFunction))) = 0)
					and	(sf.blnGeoLocationString is null or sf.blnGeoLocationString = 0)
					and	(sf.blnShortAddressString is null or sf.blnShortAddressString = 0)
				then	IsNull(@s + N'AllDiagnoses.strIDC10 as [' + sf.strSearchFieldAlias + N']', N'')
			when	sf.idfsReferenceType is null and sf.idfsGISReferenceType is null
					and (sf.strLookupFunction is null or len(ltrim(rtrim(sf.strLookupFunction))) = 0)
					and	(sf.blnGeoLocationString is null or sf.blnGeoLocationString = 0)
					and	(	@BinKey & 4 = 0
							or sf.strSearchFieldAlias <> 'sflHC_FinalDiagnosisCode'
						)
					and	(sf.blnShortAddressString is null or sf.blnShortAddressString = 0)
				then	IsNull	(
							@s + 
							replace	(
								IsNull(	sf.strCalculatedFieldText, 
										N'v.[' + sf.strSearchFieldAlias + N']'),
								N'{5}', 
								N'v.[' + sf.strSearchFieldAlias + N']'
									),
							N''	)
			when	sf.idfsReferenceType is not null and (sf.strLookupFunction is null or len(ltrim(rtrim(sf.strLookupFunction))) = 0)
					and	(	(	@BinKey & 4 > 0
								and sf.strSearchFieldAlias = 'sflHC_FinalDiagnosisIsZoonotic'
							)
							or	(	@BinKey & 64 > 0
									and sf.strSearchFieldAlias = 'sflVC_DiagnosisIsZoonotic'
								)
							or	(	@BinKey & 512 > 0
									and sf.strSearchFieldAlias = 'sflZD_IsZoonotic'
								)
						)
					and sf.idfsGISReferenceType is null
					and	(sf.blnGeoLocationString is null or sf.blnGeoLocationString = 0)
					and	(sf.blnShortAddressString is null or sf.blnShortAddressString = 0)
				then	IsNull(@s + N'(IsNull(AllDiagnoses.blnZoonotic, 0) * 10100001 + (1 - IsNull(AllDiagnoses.blnZoonotic, 0)) * 10100002) as [' + sf.strSearchFieldAlias + N'_ID], 
			[ref_' + sf.strSearchFieldAlias + N'].[name] as [' + sf.strSearchFieldAlias + ']', N'')
			when	sf.idfsReferenceType is not null and (sf.strLookupFunction is null or len(ltrim(rtrim(sf.strLookupFunction))) = 0)
					and	(	@BinKey & 4 = 0
							or sf.strSearchFieldAlias <> 'sflHC_FinalDiagnosisIsZoonotic'
						)
					and	(	@BinKey & 64 = 0
							or sf.strSearchFieldAlias <> 'sflVC_DiagnosisIsZoonotic'
						)
					and	(	@BinKey & 512 = 0
							or sf.strSearchFieldAlias <> 'sflZD_IsZoonotic'
						)
					and sf.idfsGISReferenceType is null
					and	(sf.blnGeoLocationString is null or sf.blnGeoLocationString = 0)
					and	(sf.blnShortAddressString is null or sf.blnShortAddressString = 0)
				then	IsNull(@s + N'v.[' + sf.strSearchFieldAlias + N'_ID], 
			[ref_' + sf.strSearchFieldAlias + N'].[name] as [' + sf.strSearchFieldAlias + ']', N'')
			when	(sf.strLookupFunction is not null and len(ltrim(rtrim(sf.strLookupFunction))) > 0)
					and	(sf.blnGeoLocationString is null or sf.blnGeoLocationString = 0)
					and	(sf.blnShortAddressString is null or sf.blnShortAddressString = 0)
				then	IsNull(@s + N'v.[' + sf.strSearchFieldAlias + N'_ID], 
			[ref_' + sf.strSearchFieldAlias + N'].[' + sf.strLookupFunctionNameField + '] as [' + sf.strSearchFieldAlias + ']', N'')
			when	sf.idfsGISReferenceType is not null
					and sf.idfsReferenceType is null
					and (sf.strLookupFunction is null or len(ltrim(rtrim(sf.strLookupFunction))) = 0)
					and	(sf.blnGeoLocationString is null or sf.blnGeoLocationString = 0)
					and	(sf.blnShortAddressString is null or sf.blnShortAddressString = 0)
				then	IsNull(@s + N'v.[' + sf.strSearchFieldAlias + N'_ID], 
			[ref_GIS_' + sf.strSearchFieldAlias + N'].[ExtendedName] as [' + sf.strSearchFieldAlias + N'], 
			[ref_GIS_' + sf.strSearchFieldAlias + N'].[name] as [' + sf.strSearchFieldAlias + N'_ShortGISName]', N'')
			when	(sf.blnGeoLocationString is not null and sf.blnGeoLocationString = 1)
					and sf.idfsReferenceType is null
					and sf.idfsGISReferenceType is null
					and (sf.strLookupFunction is null or len(ltrim(rtrim(sf.strLookupFunction))) = 0)
					and	(sf.blnShortAddressString is null or sf.blnShortAddressString = 0)
				then	IsNull(@s + N'v.[' + sf.strSearchFieldAlias + N'_ID], 
			[ref_GL_' + sf.strSearchFieldAlias + N'].[name] as [' + sf.strSearchFieldAlias + N']', N'')
			when	(sf.blnShortAddressString is not null and sf.blnShortAddressString = 1)
					and sf.idfsReferenceType is null
					and sf.idfsGISReferenceType is null
					and (sf.strLookupFunction is null or len(ltrim(rtrim(sf.strLookupFunction))) = 0)
					and	(sf.blnGeoLocationString is null or sf.blnGeoLocationString = 0)
				then	IsNull(@s + N'v.[' + sf.strSearchFieldAlias + N'_ID], 
			[ref_GL_' + sf.strSearchFieldAlias + N'].[strDefaultShortAddressString] as [' + sf.strSearchFieldAlias + N']', N'')
			else		N''
		end,

		@from = @from +
		case
--			when	sf.idfsReferenceType is not null and (sf.strLookupFunction is null or len(ltrim(rtrim(sf.strLookupFunction))) = 0)
--					and	(	(	@BinKey & 4 > 0
--								and sf.strSearchFieldAlias = 'sflHC_FinalDiagnosisIsZoonotic'
--							)
--							or	(	@BinKey & 64 > 0
--									and sf.strSearchFieldAlias = 'sflVC_DiagnosisIsZoonotic'
--								)
--							or	(	@BinKey & 512 > 0
--									and sf.strSearchFieldAlias = 'sflZD_IsZoonotic'
--								)
--						)
--					and sf.idfsGISReferenceType is null
--					and	(sf.blnGeoLocationString is null or sf.blnGeoLocationString = 0)
--					and	(sf.blnShortAddressString is null or sf.blnShortAddressString = 0)
--				then	IsNull	(
---- Non GIS reference table from for fields "Is Zoonotic", check-box "Add all key values..." and key field "Diagnoses" added to the query
--						N'
--left join	fnReferenceRepair(@LangID, ' + cast(sf.idfsReferenceType as varchar(20)) + N') [ref_' + sf.strSearchFieldAlias + '] 
--on			[ref_' + sf.strSearchFieldAlias + '].idfsReference = (IsNull(AllDiagnoses.blnZoonotic, 0) * 10100001 + (1 - IsNull(AllDiagnoses.blnZoonotic, 0)) * 10100002) ', 
--							N''	)
			when	(	sf.idfsReferenceType is not null
						or	sf.idfsGISReferenceType is not null
					)
					and	(	@BinKey = 0
							or	(	@BinKey > 0
									and sf.strSearchFieldAlias not in
										(	'sflHC_PatientCRRayon',
											'sflHC_PatientCRRegion',
											'sflHC_FinalDiagnosis',
--											'sflHC_FinalDiagnosisCode',
											'sflVC_FarmAddressRayon',
											'sflVC_FarmAddressRegion',
											'sflVC_Diagnosis',
											'sflZD_Region',
											'sflZD_Rayon',
											'sflZD_Diagnosis'
										)
									and	(	@BinKey & 4 = 0
											or sf.strSearchFieldAlias <> 'sflHC_FinalDiagnosisIsZoonotic'
										)
									and	(	@BinKey & 64 = 0
											or sf.strSearchFieldAlias <> 'sflVC_DiagnosisIsZoonotic'
										)
									and	(	@BinKey & 512 = 0
											or sf.strSearchFieldAlias <> 'sflZD_IsZoonotic'
										)
								)
						)
					 and (sf.strLookupFunction is null or len(ltrim(rtrim(sf.strLookupFunction))) = 0)
				then	IsNull	(
-- Non GIS reference table from
						N'
left join	fnReferenceRepair(@LangID, ' + cast(sf.idfsReferenceType as varchar(20)) + N') [ref_' + sf.strSearchFieldAlias + '] 
on			[ref_' + sf.strSearchFieldAlias + '].idfsReference = v.[' + sf.strSearchFieldAlias + N'_ID] ', 
							N''	) +
						IsNull	(
-- GIS reference table from
						N'
left join	fnGisExtendedReferenceRepair(@LangID, ' + cast(sf.idfsGISReferenceType as varchar(20)) + N') ' +
						N'[ref_GIS_' + sf.strSearchFieldAlias + ']  
on			[ref_GIS_' + sf.strSearchFieldAlias + '].idfsReference = v.[' + sf.strSearchFieldAlias + N'_ID] ', 
							N''	)
			
			when	 (sf.strLookupFunction is not null and len(ltrim(rtrim(sf.strLookupFunction))) > 0)
				then	IsNull	(
-- Special lookup function from
						N'
left join	' + sf.strLookupFunction + N'(@LangID) [ref_' + sf.strSearchFieldAlias + '] 
on			[ref_' + sf.strSearchFieldAlias + '].' + sf.strLookupFunctionIdField + N' = v.[' + sf.strSearchFieldAlias + N'_ID] ', 
							N''	)
			when	(	(sf.blnGeoLocationString is not null and sf.blnGeoLocationString = 1)
						or	(sf.blnShortAddressString is not null and sf.blnShortAddressString = 1)
					)
					and	(	sf.idfsReferenceType is null
							and	sf.idfsGISReferenceType is null
							and (sf.strLookupFunction is null or len(ltrim(rtrim(sf.strLookupFunction))) = 0)
						)
					and	(	@BinKey = 0
							or	(	@BinKey > 0
									and sf.strSearchFieldAlias not in
										(	'sflHC_PatientCRRayon',
											'sflHC_PatientCRRegion',
											'sflHC_FinalDiagnosis',
--											'sflHC_FinalDiagnosisCode',
											'sflVC_FarmAddressRayon',
											'sflVC_FarmAddressRegion',
											'sflVC_Diagnosis',
											'sflZD_Region',
											'sflZD_Rayon',
											'sflZD_Diagnosis'
										)
								)
						)
					and exists	(
							select	*
							from	tasFieldSourceForTable fst
							where	fst.idfsSearchField = sf.idfsSearchField
									and fst.strFieldText like N'%idfGeoLocationShared%'
								)
				then	IsNull	(
-- Geo Location Shared translation table from
						N'
left join	fnGeoLocationSharedTranslation(@LangID) [ref_GL_' + sf.strSearchFieldAlias + ']  
on			[ref_GL_' + sf.strSearchFieldAlias + '].idfGeoLocationShared = v.[' + sf.strSearchFieldAlias + N'_ID] ', 
							N''	)
							
			when	(	(sf.blnGeoLocationString is not null and sf.blnGeoLocationString = 1)
						or	(sf.blnShortAddressString is not null and sf.blnShortAddressString = 1)
					)
					and	(	sf.idfsReferenceType is null
							and	sf.idfsGISReferenceType is null
							and (sf.strLookupFunction is null or len(ltrim(rtrim(sf.strLookupFunction))) = 0)
						)
					and	(	@BinKey = 0
							or	(	@BinKey > 0
									and sf.strSearchFieldAlias not in
										(	'sflHC_PatientCRRayon',
											'sflHC_PatientCRRegion',
											'sflHC_FinalDiagnosis',
--											'sflHC_FinalDiagnosisCode',
											'sflVC_FarmAddressRayon',
											'sflVC_FarmAddressRegion',
											'sflVC_Diagnosis',
											'sflZD_Region',
											'sflZD_Rayon',
											'sflZD_Diagnosis'
										)
								)
						)
					and not exists	(
							select	*
							from	tasFieldSourceForTable fst
							where	fst.idfsSearchField = sf.idfsSearchField
									and fst.strFieldText like N'%idfGeoLocationShared%'
								)
				then	IsNull	(
-- Geo Location translation table from
						N'
left join	fnGeoLocationTranslation(@LangID) [ref_GL_' + sf.strSearchFieldAlias + ']  
on			[ref_GL_' + sf.strSearchFieldAlias + '].idfGeoLocation = v.[' + sf.strSearchFieldAlias + N'_ID] ', 
							N''	)
							
			else		N''
		end,
			@s = N', 
			'
from		tasQuerySearchField qsf
inner join	tasQuerySearchObject qso
on			qso.idfQuerySearchObject = qsf.idfQuerySearchObject
			and qso.idflQuery = @QueryID
inner join	tasQuery q
on			q.idflQuery = qso.idflQuery
inner join	tasSearchField sf
on			sf.idfsSearchField = qsf.idfsSearchField
			and sf.idfsSearchObject = qso.idfsSearchObject
			and sf.idfsSearchFieldType <> 10081003			-- FF Field
			and sf.intRowStatus = 0


-- Add FF fields to the "select" part and related lookups to the "from" part
select		@select	= @select	+ 
		case
			when	pt.idfsReferenceType is null
				then	IsNull		(	
							@s + N'v.[' + sf.strSearchFieldAlias + N'__' + 
							cast(sob.idfsFormType as varchar(20)) + N'__' + 
							cast(p.idfsParameter as varchar(20)) + N']'
							, N''	)
			when	pt.idfsReferenceType is not null
				then	IsNull		(		
							@s + N'v.[' + sf.strSearchFieldAlias + N'__' + 
							cast(sob.idfsFormType as varchar(20)) + N'__' + 
							cast(p.idfsParameter as varchar(20)) + N'_ID], 
			[ref_' + sf.strSearchFieldAlias + N'__' + 
							cast(sob.idfsFormType as varchar(20)) + N'__' + 
							cast(p.idfsParameter as varchar(20)) + 
							N'].[name] as [' + 
							sf.strSearchFieldAlias + N'__' + 
							cast(sob.idfsFormType as varchar(20)) + N'__' + 
							cast(p.idfsParameter as varchar(20)) + ']'
							, N''	)
			else	N''
		end,
			@from = @from +
		case
			when	pt.idfsReferenceType is not null
				then
					IsNull	(
						N'
left join	fnReferenceRepair(@LangID, ' + cast(pt.idfsReferenceType as varchar(20)) + N') [ref_' + 
							sf.strSearchFieldAlias + N'__' + 
							cast(sob.idfsFormType as varchar(20)) + N'__' + 
							cast(p.idfsParameter as varchar(20)) + 
							N'] 
on			[ref_' + sf.strSearchFieldAlias + N'__' + 
							cast(sob.idfsFormType as varchar(20)) + N'__' + 
							cast(p.idfsParameter as varchar(20)) + 
							N'].idfsReference = v.[' + sf.strSearchFieldAlias + N'__' + 
							cast(sob.idfsFormType as varchar(20)) + N'__' + 
							cast(p.idfsParameter as varchar(20)) + N'_ID] ', 
						N''	)
			else	N''
		end,
			@s = N', 
			'
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
			and qso.idflQuery = @QueryID
inner join	tasSearchField sf
on			sf.idfsSearchField = qsf.idfsSearchField
			and sf.idfsSearchObject = sob.idfsSearchObject
			and sf.idfsSearchFieldType = 10081003			-- FF Field
			and sf.intRowStatus = 0
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

-- Question: Is it possible to use different reference types for one search field depending on "union" part?
-- Answer: No

-- Add full join for key references
-- Define Full Join from and where condition for key references
declare @FullJoinFrom	nvarchar(MAX)
declare @FullJoinWhere	nvarchar(MAX)

set	@FullJoinFrom = dbo.fnAsGetFullJoinFrom	(@BinKey)
set	@FullJoinWhere = dbo.fnAsGetFullJoinWhere (@BinKey)

-- Add correct full join for key references to final from text
if charindex('from', @from, 0) > 0
begin
	set @from = @from + N'

' + @FullJoinFrom
end

-- Add lookup table for (none) value to the "from" part
	if charindex('from', @from, 0) > 0
	begin
		set @from = @from + N'

--Not needed--left join	fnReference(@LangID, 19000044) ref_None	-- Information String
--Not needed--on			ref_None.idfsReference = 0		-- Workaround. We dont need (none) anymore

'
end

-- TODO: Add "where" condition
-- Generate the "where" part of the query
declare @where nvarchar(MAX)
set @where = N'
'
-- Set separator value
set	@s = N' 
			'

-- Create @whereTable table of all condition groups (conditions within one pair of brackets) 
-- that should be applied to the query with updated conditions and level
declare	@whereTable table
(				
	idfQueryConditionGroup	bigint not null primary key,
	strWhere				nvarchar(MAX) collate database_default not null,  
	strWhereInVersion5Mode	nvarchar(MAX) collate database_default not null,  
	strJoinOperator			varchar(20) collate database_default null,
	strChildJoinOperator	varchar(20) collate database_default null,
	idfSubQuery				bigint null,
	whereLevel				int not null
)

;
with	whereTable	(
			idfQueryConditionGroup,
			strWhere,
			strWhereInVersion5Mode,
			strJoinOperator,
			strChildJoinOperator,
			idfSubQuery,
			whereLevel
					)
as	(	select		qcg.idfQueryConditionGroup,
					case
						when	subquery.idflQuery is not null
								and subquery.strFunctionName like N'fn%'
								and exists	(
										select		*
										from		tasQuerySearchFieldCondition qsfc_subquery
										inner join	tasQuerySearchField qsfc_qsf_subquery
										on			qsfc_qsf_subquery.idfQuerySearchField = qsfc_subquery.idfQuerySearchField
										inner join	tasQuerySearchObject qsfc_qso_subquery 
										on			qsfc_qso_subquery.idfQuerySearchObject = qsfc_qsf_subquery.idfQuerySearchObject
													and qsfc_qso_subquery.idflQuery = subquery.idflQuery
											)
							then	'(exists (' + 
										N'select * ' +
										N'from vw' + right(subquery.strFunctionName, len(subquery.strFunctionName) - 2) + N' ' +
												N' as v_' + cast(subquery.idflQuery as nvarchar(20)) + N' ' +
										N'where (' + replace	(	so_to_so.strSubQueryJoinCondition, 
																	N'{6}', 
																	cast(subquery.idflQuery as nvarchar(20))
																) + 
												N') and ({3})))'
						when	subquery.idflQuery is not null
								and subquery.strFunctionName not like N'fn%'
								and exists	(
										select		*
										from		tasQuerySearchFieldCondition qsfc_subquery
										inner join	tasQuerySearchField qsfc_qsf_subquery
										on			qsfc_qsf_subquery.idfQuerySearchField = qsfc_subquery.idfQuerySearchField
										inner join	tasQuerySearchObject qsfc_qso_subquery 
										on			qsfc_qso_subquery.idfQuerySearchObject = qsfc_qsf_subquery.idfQuerySearchObject
													and qsfc_qso_subquery.idflQuery = subquery.idflQuery
											)
							then	'(exists (' + 
										N'select * ' +
										N'from ' + subquery.strFunctionName + N' ' +
												N' as v_' + cast(subquery.idflQuery as nvarchar(20)) + N' ' +
										N'where (' + replace	(	so_to_so.strSubQueryJoinCondition, 
																	N'{6}', 
																	cast(subquery.idflQuery as nvarchar(20))
																) + 
												N') and ({3})))'
						when	subquery.idflQuery is not null
								and subquery.strFunctionName like N'fn%'
								and not exists	(
											select		*
											from		tasQuerySearchFieldCondition qsfc_subquery
											inner join	tasQuerySearchField qsfc_qsf_subquery
											on			qsfc_qsf_subquery.idfQuerySearchField = qsfc_subquery.idfQuerySearchField
											inner join	tasQuerySearchObject qsfc_qso_subquery 
											on			qsfc_qso_subquery.idfQuerySearchObject = qsfc_qsf_subquery.idfQuerySearchObject
														and qsfc_qso_subquery.idflQuery = subquery.idflQuery
											)
							then	'(exists (' + 
										N'select * ' +
										N'from vw' + right(subquery.strFunctionName, len(subquery.strFunctionName) - 2) + N' ' +
												N' as v_' + cast(subquery.idflQuery as nvarchar(20)) + N' ' +
										N'where ' + replace	(	so_to_so.strSubQueryJoinCondition, 
																N'{6}', 
																cast(subquery.idflQuery as nvarchar(20))
															) + 
											N'))'
						when	subquery.idflQuery is not null
								and subquery.strFunctionName not like N'fn%'
								and not exists	(
											select		*
											from		tasQuerySearchFieldCondition qsfc_subquery
											inner join	tasQuerySearchField qsfc_qsf_subquery
											on			qsfc_qsf_subquery.idfQuerySearchField = qsfc_subquery.idfQuerySearchField
											inner join	tasQuerySearchObject qsfc_qso_subquery 
											on			qsfc_qso_subquery.idfQuerySearchObject = qsfc_qsf_subquery.idfQuerySearchObject
														and qsfc_qso_subquery.idflQuery = subquery.idflQuery
											)
							then	'(exists (' + 
										N'select * ' +
										N'from ' + subquery.strFunctionName + N' ' +
												N' as v_' + cast(subquery.idflQuery as nvarchar(20)) + N' ' +
										N'where ' + replace	(	so_to_so.strSubQueryJoinCondition, 
																N'{6}', 
																cast(subquery.idflQuery as nvarchar(20))
															) + 
											N'))'
						else	N'({3})'
					end	as strWhere,
					N'({3})' as strWhereInVersion5Mode,
					case
						when	qcg.blnUseNot = 1
							then	cast('and not ' as varchar(20))
						else	cast('and ' as varchar(20))
					end as strJoinOpearator,
					case	
						when	qcg.blnJoinByOr = 1
							then	'or '
						else	'and '
					end as strChildJoinOperator,
					subquery.idflQuery as idfSubQuery,
					0 as whereLevel
		from		(
			tasQueryConditionGroup qcg
			inner join	tasQuerySearchObject qso
			on			qso.idfQuerySearchObject = qcg.idfQuerySearchObject
						and qso.idflQuery = @QueryID
			left join	tasQuerySearchObject qso_subquery
				inner join	tasQuery subquery
				on			subquery.idflQuery = qso_subquery.idflQuery
				inner join	tasSearchObjectToSearchObject so_to_so
				on			so_to_so.idfsRelatedSearchObject = qso_subquery.idfsSearchObject
							and so_to_so.blnUseForSubQuery = 1
			on			qso_subquery.idfQuerySearchObject = qcg.idfSubQuerySearchObject
						and so_to_so.idfsParentSearchObject = qso.idfsSearchObject
					)
		left join	(
			tasQuerySearchFieldCondition qsfc
			left join	tasQuerySearchFieldCondition qsfc_min
			on			qsfc_min.idfQueryConditionGroup = qsfc.idfQueryConditionGroup
						and qsfc_min.idfQuerySearchFieldCondition < qsfc.idfQuerySearchFieldCondition
					)
		on			qsfc.idfQueryConditionGroup = qcg.idfQueryConditionGroup
					and qsfc_min.idfQuerySearchFieldCondition is null
		left join	(
			tasQueryConditionGroup qcg_child
			left join	tasQueryConditionGroup qcg_child_min
			on			qcg_child_min.idfParentQueryConditionGroup = qcg_child.idfParentQueryConditionGroup
						and qcg_child_min.idfQueryConditionGroup < qcg_child.idfQueryConditionGroup
					)
		on			qcg_child.idfParentQueryConditionGroup = qcg.idfQueryConditionGroup
					and qcg_child_min.idfQueryConditionGroup is null
		where		qcg.idfParentQueryConditionGroup is null
					and (	qsfc.idfQuerySearchFieldCondition is not null
							or qcg_child.idfQueryConditionGroup is not null
						)
		union all
		select		qcg.idfQueryConditionGroup,
					N'({3})' as strWhere,
					N'({3})' as strWhereInVersion5Mode,
					case
						when	qcg.blnUseNot = 1
							then	cast((whereTable.strChildJoinOperator + 'not ') as varchar(20))
						else	cast(whereTable.strChildJoinOperator as varchar(20))
					end as strJoinOpearator,
					case	
						when	qcg.blnJoinByOr = 1
							then	'or '
						else	'and '
					end as strChildJoinOperator,
					whereTable.idfSubQuery as idfSubQuery,
					whereTable.whereLevel + 1 as whereLevel
		from		(
			tasQueryConditionGroup qcg
			inner join	tasQuerySearchObject qso
			on			qso.idfQuerySearchObject = qcg.idfQuerySearchObject
----Remove for conditions of subqueries--						and qso.idflQuery = @QueryID
					)
		inner join	whereTable
		on			whereTable.idfQueryConditionGroup = qcg.idfParentQueryConditionGroup
		where		not exists	(
							select		*
							from		tasQuerySearchObject qso_subquery
							inner join	tasQuery subquery
							on			subquery.idflQuery = qso_subquery.idflQuery
							inner join	tasSearchObjectToSearchObject so_to_so
							on			so_to_so.idfsRelatedSearchObject = qso_subquery.idfsSearchObject
										and so_to_so.blnUseForSubQuery = 1
							where		qso_subquery.idfQuerySearchObject = qcg.idfSubQuerySearchObject
										and so_to_so.idfsParentSearchObject = qso.idfsSearchObject
								)
		union all
		select		qcg.idfQueryConditionGroup,
					case
						when	subquery.idflQuery is not null
								and subquery.strFunctionName like N'fn%'
								and exists	(
										select		*
										from		tasQuerySearchFieldCondition qsfc_subquery
										inner join	tasQuerySearchField qsfc_qsf_subquery
										on			qsfc_qsf_subquery.idfQuerySearchField = qsfc_subquery.idfQuerySearchField
										inner join	tasQuerySearchObject qsfc_qso_subquery 
										on			qsfc_qso_subquery.idfQuerySearchObject = qsfc_qsf_subquery.idfQuerySearchObject
													and qsfc_qso_subquery.idflQuery = subquery.idflQuery
											)
							then	'(exists (' + 
										N'select * ' +
										N'from vw' + right(subquery.strFunctionName, len(subquery.strFunctionName) - 2) + N' ' +
												N' as v_' + cast(subquery.idflQuery as nvarchar(20)) + N' ' +
										N'where (' + replace	(	so_to_so.strSubQueryJoinCondition, 
																	N'{6}', 
																	cast(subquery.idflQuery as nvarchar(20))
																) + 
												N') and ({3})))'
						when	subquery.idflQuery is not null
								and subquery.strFunctionName not like N'fn%'
								and exists	(
										select		*
										from		tasQuerySearchFieldCondition qsfc_subquery
										inner join	tasQuerySearchField qsfc_qsf_subquery
										on			qsfc_qsf_subquery.idfQuerySearchField = qsfc_subquery.idfQuerySearchField
										inner join	tasQuerySearchObject qsfc_qso_subquery 
										on			qsfc_qso_subquery.idfQuerySearchObject = qsfc_qsf_subquery.idfQuerySearchObject
													and qsfc_qso_subquery.idflQuery = subquery.idflQuery
											)
							then	'(exists (' + 
										N'select * ' +
										N'from ' + subquery.strFunctionName + N' ' +
												N' as v_' + cast(subquery.idflQuery as nvarchar(20)) + N' ' + 
										N'where (' + replace	(	so_to_so.strSubQueryJoinCondition, 
																	N'{6}', 
																	cast(subquery.idflQuery as nvarchar(20))
																) + 
												N') and ({3})))'
						when	subquery.idflQuery is not null
								and subquery.strFunctionName like N'fn%'
								and not exists	(
											select		*
											from		tasQuerySearchFieldCondition qsfc_subquery
											inner join	tasQuerySearchField qsfc_qsf_subquery
											on			qsfc_qsf_subquery.idfQuerySearchField = qsfc_subquery.idfQuerySearchField
											inner join	tasQuerySearchObject qsfc_qso_subquery 
											on			qsfc_qso_subquery.idfQuerySearchObject = qsfc_qsf_subquery.idfQuerySearchObject
														and qsfc_qso_subquery.idflQuery = subquery.idflQuery
											)
							then	'(exists (' + 
										N'select * ' +
										N'from vw' + right(subquery.strFunctionName, len(subquery.strFunctionName) - 2) + N' ' +
												N' as v_' + cast(subquery.idflQuery as nvarchar(20)) + N' ' +
										N'where ' + replace	(	so_to_so.strSubQueryJoinCondition, 
																N'{6}', 
																cast(subquery.idflQuery as nvarchar(20))
															) + 
											N'))'
						when	subquery.idflQuery is not null
								and subquery.strFunctionName not like N'fn%'
								and not exists	(
											select		*
											from		tasQuerySearchFieldCondition qsfc_subquery
											inner join	tasQuerySearchField qsfc_qsf_subquery
											on			qsfc_qsf_subquery.idfQuerySearchField = qsfc_subquery.idfQuerySearchField
											inner join	tasQuerySearchObject qsfc_qso_subquery 
											on			qsfc_qso_subquery.idfQuerySearchObject = qsfc_qsf_subquery.idfQuerySearchObject
														and qsfc_qso_subquery.idflQuery = subquery.idflQuery
											)
							then	'(exists (' + 
										N'select * ' +
										N'from ' + subquery.strFunctionName + N' ' +
												N' as v_' + cast(subquery.idflQuery as nvarchar(20)) + N' ' +
										N'where ' + replace	(	so_to_so.strSubQueryJoinCondition, 
																N'{6}', 
																cast(subquery.idflQuery as nvarchar(20))
															) + 
											N'))'
						else	N'({3})'
					end	as strWhere,
					N'({3})' as strWhereInVersion5Mode,
					case
						when	qcg.blnUseNot = 1
							then	cast((whereTable.strChildJoinOperator + 'not ') as varchar(20))
						else	cast(whereTable.strChildJoinOperator as varchar(20))
					end as strJoinOpearator,
					case	
						when	qcg.blnJoinByOr = 1
							then	'or '
						else	'and '
					end as strChildJoinOperator,
					IsNull(subquery.idflQuery, whereTable.idfSubQuery) as idfSubQuery,
					whereTable.whereLevel + 1 as whereLevel
		from		(
			tasQueryConditionGroup qcg
			inner join	tasQuerySearchObject qso
			on			qso.idfQuerySearchObject = qcg.idfQuerySearchObject
----Remove for conditions of subqueries--						and qso.idflQuery = @QueryID
			inner join	tasQuerySearchObject qso_subquery
				inner join	tasQuery subquery
				on			subquery.idflQuery = qso_subquery.idflQuery
				inner join	tasSearchObjectToSearchObject so_to_so
				on			so_to_so.idfsRelatedSearchObject = qso_subquery.idfsSearchObject
							and so_to_so.blnUseForSubQuery = 1
			on			qso_subquery.idfQuerySearchObject = qcg.idfSubQuerySearchObject
						and so_to_so.idfsParentSearchObject = qso.idfsSearchObject
					)
		inner join	whereTable
		on			whereTable.idfQueryConditionGroup = qcg.idfParentQueryConditionGroup
	)


insert into	@whereTable
(				
	idfQueryConditionGroup,
	strWhere,
	strWhereInVersion5Mode,
	strJoinOperator,
	strChildJoinOperator,
	idfSubQuery,
	whereLevel
)
select	wTRec.idfQueryConditionGroup,
		wTRec.strWhere,
		wTRec.strWhereInVersion5Mode,
		wTRec.strJoinOperator,
		wTRec.strChildJoinOperator,
		wTRec.idfSubQuery,
		wTRec.whereLevel
from	whereTable wTRec

-- Remove join operator before the first condition related to search object
update		wt
set			wt.strJoinOperator = 
			case
				when	(len(wt.strJoinOperator) >= 4)
						and (substring(wt.strJoinOperator, len(wt.strJoinOperator) - 4, 3) = 'not')
					then	'not '
				else	''
			end
from		@whereTable wt
left join	@whereTable wt_min
on			wt_min.whereLevel = wt.whereLevel
			and wt_min.idfQueryConditionGroup < wt.idfQueryConditionGroup
where		wt.whereLevel = 0
			and wt_min.idfQueryConditionGroup is null


-- Update where condititions for bracket groups

-- Define current bracket group
declare	@idfQueryConditionGroup bigint
-- Define join operator for child bracket groups and conditions of current bracket group 
declare	@strChildJoinOperator varchar(20)
-- Define correct join operator for child conditions of current bracket group 
-- (with removed join operator for the first child condition or bracket group in the current bracket group)
declare	@strJoin varchar(20)
-- Define where condition for current bracket group
declare	@strWhere nvarchar(MAX)
-- Define where condition in version 5 mode for current bracket group
declare	@strWhereInVersion5Mode nvarchar(MAX)
-- Define subquery Id for current bracket group
declare	@idfSubQuery nvarchar(MAX)

-- Define cursor for @whereTable table
declare	TableCursor Cursor local read_only forward_only for
	select		wt.idfQueryConditionGroup, wt.strChildJoinOperator, wt.idfSubQuery
	from		@whereTable wt
open TableCursor
fetch next from TableCursor into @idfQueryConditionGroup, @strChildJoinOperator, @idfSubQuery
while @@fetch_status <> -1
begin
	set	@strWhere = ''
	set	@strWhereInVersion5Mode = ''
	set	@strJoin = ''
	if	(len(@strChildJoinOperator) >= 4)
		and (substring(@strChildJoinOperator, len(@strChildJoinOperator) - 4, 3) = 'not')
		set @strJoin = 'not '

	select		@strWhere = @strWhere + @strJoin +
				dbo.fnAsGetSearchCondition
					(	IsNull(p.idfsParameterType, sf.idfsSearchFieldType),
						IsNull(pt.idfsReferenceType, sf.idfsReferenceType),
						sf.idfsGISReferenceType,
						sf.strLookupFunction,
						replace	(
							replace	(
								IsNull(	sf.strCalculatedFieldText, 
										N'v.[' + sf.strSearchFieldAlias +	
										IsNull	(	N'__' + cast(sob.idfsFormType as varchar(20)) + 
													N'__' + cast(p.idfsParameter as varchar(20)), 
													N''
												) + 
										N']'),
								N'{5}', 
								N'v' + IsNull(N'_' + cast(@idfSubQuery as nvarchar(20)), N'') + N'.[' + sf.strSearchFieldAlias + N']'
									),
							N'v.',
							N'v' + IsNull(N'_' + cast(@idfSubQuery as nvarchar(20)), N'') + N'.'
								),
						qsfc.strOperator,
						qsfc.intOperatorType,
						qsfc.blnUseNot,
						qsfc.varValue
					),
				@strWhereInVersion5Mode = @strWhereInVersion5Mode + @strJoin +
				dbo.fnAsGetSearchCondition
					(	IsNull(p.idfsParameterType, sf.idfsSearchFieldType),
						IsNull(pt.idfsReferenceType, sf.idfsReferenceType),
						sf.idfsGISReferenceType,
						sf.strLookupFunction,
						replace	(
							IsNull(	sf.strCalculatedFieldText, 
									N'v.[' + sf.strSearchFieldAlias +	
									IsNull	(	N'__' + cast(sob.idfsFormType as varchar(20)) + 
												N'__' + cast(p.idfsParameter as varchar(20)), 
												N''
											) + 
									N']'),
							N'{5}', 
							N'v.[' + sf.strSearchFieldAlias + N']'
								),
						qsfc.strOperator,
						qsfc.intOperatorType,
						qsfc.blnUseNot,
						qsfc.varValue
					),@strJoin = @strChildJoinOperator
	from		tasQuerySearchFieldCondition qsfc
	inner join	(
		tasQuerySearchField qsf
		inner join	tasSearchField sf
		on			sf.idfsSearchField = qsf.idfsSearchField
					and sf.intRowStatus = 0
				)
	on			qsf.idfQuerySearchField = qsfc.idfQuerySearchField
	inner join	(
		tasQuerySearchObject qso
		inner join	tasSearchObject sob
		on			sob.idfsSearchObject = qso.idfsSearchObject
					and sob.intRowStatus = 0
		left join	trtBaseReference br_ft
		on			br_ft.idfsBaseReference = sob.idfsFormType
					and br_ft.idfsReferenceType = 19000034		-- Form Type
					and br_ft.intRowStatus = 0
				)
	on			qso.idfQuerySearchObject = qsf.idfQuerySearchObject
	left join	(
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
	where		qsfc.idfQueryConditionGroup = @idfQueryConditionGroup

	update	wt
	set		wt.strWhere = replace(wt.strWhere, '{3}', @strWhere + '{3}'),
			wt.strWhereInVersion5Mode = replace(wt.strWhereInVersion5Mode, '{3}', @strWhereInVersion5Mode + '{3}')
	from	@whereTable wt
	where	wt.idfQueryConditionGroup = @idfQueryConditionGroup

	fetch next from TableCursor into @idfQueryConditionGroup, @strChildJoinOperator, @idfSubQuery
end
close TableCursor
deallocate TableCursor 


-- Remove join operator before the first child bracket group of current bracket group
-- TODO: check for first "exists" where condition group
update		wt
set			wt.strJoinOperator =
			case
				when	(len(wt.strJoinOperator) >= 4) 
						and (substring(wt.strJoinOperator, len(wt.strJoinOperator) - 4, 3) = 'not')
					then	'not '
				else		''
			end
from		tasQueryConditionGroup qcg
inner join	@whereTable wt
on			wt.idfQueryConditionGroup = qcg.idfQueryConditionGroup
left join	(
	tasQueryConditionGroup qcg_min
	inner join	@whereTable wt_min
	on			wt_min.idfQueryConditionGroup = qcg_min.idfQueryConditionGroup
			)
on			IsNull(qcg_min.idfParentQueryConditionGroup, -100) = IsNull(qcg.idfParentQueryConditionGroup, -100)
			and qcg_min.idfQueryConditionGroup < qcg.idfQueryConditionGroup
left join	tasQuerySearchFieldCondition qsfc
on			qsfc.idfQueryConditionGroup = IsNull(qcg.idfParentQueryConditionGroup, -100)
where		qcg_min.idfQueryConditionGroup is null
			and qsfc.idfQuerySearchFieldCondition is null



-- Create @finalWhereTable table of all bracket groups that should be included to the query 
-- with final where condition (including child bracket group conditions) and level
declare	@finalWhereTable table
(	idfQueryConditionGroup	bigint not null primary key,
	strWhere				nvarchar(MAX) collate database_default not null,
	strWhereInVersion5Mode	nvarchar(MAX) collate database_default not null,
	strJoinOperator			varchar(20) collate database_default not null,
	whereLevel				int not null
)

-- Select maximum level of from
declare	@whereLevel	int
set	@whereLevel = -2
select	@whereLevel = max(wt.whereLevel) - 1
from	@whereTable wt

-- Add group brackets with their where conditions of maximum level
insert into	@finalWhereTable
(	idfQueryConditionGroup,
	strWhere, 
	strWhereInVersion5Mode,
	strJoinOperator,
	whereLevel
)
select	wt.idfQueryConditionGroup,
		replace(wt.strWhere, '{3}', ''),
		replace(wt.strWhereInVersion5Mode, '{3}', ''),
		wt.strJoinOperator,
		wt.whereLevel
from	@whereTable wt
where	whereLevel = @whereLevel + 1

-- Define current final where condition (including child where conditions)
declare	@strCurFinalWhere	nvarchar(MAX)
-- Define current final where condition in version 5 mode (including child where conditions)
declare	@strCurFinalWhereInVersion5Mode	nvarchar(MAX)
-- Define join operator for current bracket group
declare	@strJoinOperator	nvarchar(20)

-- Add bracket groups with final where conditions of all levels ordered by their level
while @whereLevel >= 0
begin
	-- Define cursor for @whereTable table with current level
	declare	TableCursor	cursor local read_only forward_only for
		select	wt.idfQueryConditionGroup, 
				wt.strWhere,
				wt.strWhereInVersion5Mode,
				wt.strJoinOperator,
				wt.strChildJoinOperator
		from	@whereTable wt
		where	wt.whereLevel = @whereLevel
	open TableCursor
	fetch next from	TableCursor into
		@idfQueryConditionGroup, @strWhere, @strWhereInVersion5Mode, @strJoinOperator, @strChildJoinOperator

	while @@fetch_status <> -1
	begin
		set	@strCurFinalWhere = @strWhere
		set	@strCurFinalWhereInVersion5Mode = @strWhereInVersion5Mode

		-- TODO: Check if it is needed
		------ Remove join operator before the first child condition or bracket group of current bracket group
		------ TODO: check for first "exists" where condition
		----if @strWhereInVersion5Mode = '({3})'
		----begin
		----	if	(len(@strJoinOperator) >= 4) 
		----		and (substring(@strJoinOperator, len(@strJoinOperator) - 4, 3) = 'not')
		----		set	@strJoinOperator = 'not '
		----	else
		----		set	@strJoinOperator = ''
		
		
		----	update		wtFin_child
		----	set			wtFin_child.strJoinOperator =
		----				case
		----					when	(len(wtFin_child.strJoinOperator) >= 4) 
		----							and (substring(wtFin_child.strJoinOperator, len(wtFin_child.strJoinOperator) - 4, 3) = 'not')
		----						then	'not '
		----					else		''
		----				end
		----	from		tasQueryConditionGroup qcg
		----	inner join	@finalWhereTable wtFin_child
		----	on			wtFin_child.idfQueryConditionGroup = qcg.idfQueryConditionGroup
		----	left join	(
		----		tasQueryConditionGroup qcg_min
		----		inner join	@finalWhereTable wtFin_child_min
		----		on			wtFin_child_min.idfQueryConditionGroup = qcg_min.idfQueryConditionGroup
		----				)
		----	on			qcg_min.idfParentQueryConditionGroup = qcg.idfParentQueryConditionGroup
		----				and qcg_min.idfQueryConditionGroup < qcg.idfQueryConditionGroup
		----	where		qcg.idfParentQueryConditionGroup = @idfQueryConditionGroup
		----				and qcg_min.idfQueryConditionGroup is NULL
		----end

		-- Generate final where condition (@strCurFinalWhere) for current bracket group
		select		@strCurFinalWhere = replace(@strCurFinalWhere, '{3}', wtFin_child.strJoinOperator + wtFin_child.strWhere + '{3}')
					
		from		tasQueryConditionGroup qcg
		inner join	@finalWhereTable wtFin_child
		on			wtFin_child.idfQueryConditionGroup = qcg.idfQueryConditionGroup
		where		qcg.idfParentQueryConditionGroup = @idfQueryConditionGroup
		order by	qcg.idfQueryConditionGroup

		-- Generate final where condition in version 5 mode (@strCurFinalWhereInVersion5Mode) for current bracket group
		select		@strCurFinalWhereInVersion5Mode = 
						replace(@strCurFinalWhereInVersion5Mode, 
								'{3}', 
								wtFin_child.strJoinOperator + wtFin_child.strWhereInVersion5Mode + '{3}')
					
		from		tasQueryConditionGroup qcg
		inner join	@finalWhereTable wtFin_child
		on			wtFin_child.idfQueryConditionGroup = qcg.idfQueryConditionGroup
		where		qcg.idfParentQueryConditionGroup = @idfQueryConditionGroup
		order by	qcg.idfQueryConditionGroup


		-- Add generated values to @finalWhereTable
		insert into	@finalWhereTable
		(	idfQueryConditionGroup,
			strWhere,
			strWhereInVersion5Mode,
			strJoinOperator,
			whereLevel
		)
		values
		(
			@idfQueryConditionGroup,
			replace(@strCurFinalWhere, '{3}', ''),
			replace(@strCurFinalWhereInVersion5Mode, '{3}', ''),
			@strJoinOperator,
			@whereLevel
		)

		fetch next from TableCursor into 
			@idfQueryConditionGroup, @strWhere, @strWhereInVersion5Mode, @strJoinOperator, @strChildJoinOperator
	end
	close TableCursor
	deallocate TableCursor 

	set @whereLevel = @whereLevel - 1
end


-- Generate final where text
select		@where = @where + @s + wtFin.strJoinOperator + replace(wtFin.strWhere, '{3}', '')
from		@finalWhereTable wtFin
where		wtFin.whereLevel = 0
order by	wtFin.strJoinOperator, wtFin.strWhere



-- Add Mandatory Report Type filter to where condition if it is not empty
if (len(rtrim(ltrim(@where))) > 10) and (len(rtrim(ltrim(@ReportTypeFilter))) > 10)
	set @where =	@where + N' 
					and ' + @ReportTypeFilter


else	if (len(rtrim(ltrim(IsNull(@where, N'')))) <= 10)
	set @where = @ReportTypeFilter


-- Add where condition for key values using OR operator

-- Define additional condition in case the check-box "Add all reference values" is selected 
-- and key fields are included in the query. 
declare	@FullJoinCondition	nvarchar(500)
set	@FullJoinCondition = N''

if @BinKey > 0
begin

	set	@FullJoinCondition = N'(v.[PKField] is null) '

	if	(len(rtrim(ltrim(@FullJoinWhere))) > 10)
	begin
		if	(len(rtrim(ltrim(@where))) > 10)
		begin
			set	@FullJoinWhere = N'
				and	(	(v.[PKField] is not null)	
						or	(	(v.[PKField] is null)
								and	(
' + @FullJoinWhere + N'
									)
							)
					)' 
		end
		else begin
			set	@FullJoinWhere = N'
				(	(v.[PKField] is not null)	
					or	(	(v.[PKField] is null)
							and	(
' + @FullJoinWhere + N'
								)
						)
				)' 
		end
	end
	else	
		set	@FullJoinWhere = N''

	if	(len(rtrim(ltrim(@FullJoinCondition))) > 10)
	begin
		if	(len(rtrim(ltrim(@where))) > 10)
			set @where = N'
			(
			' + @where + N'
				)	or	' + @FullJoinCondition
	end
	

end

-- Add the word "where" to where condition if it is not empty
if (len(rtrim(ltrim(@where))) > 10)
	set @where = N'where		(
' + @where + N'
			) ' + @FullJoinWhere

else if (len(rtrim(ltrim(@FullJoinWhere))) > 10)
	set @where = N'where		
' + @FullJoinWhere + N'
			 ' 
else
	set	@where = N''

-- Drop and create views for sub-queries
declare	SubQueryCursor	cursor local read_only forward_only for
	select distinct
				wt.idfSubQuery
	from		@whereTable wt
	where		wt.idfSubQuery is not null
	order by	wt.idfSubQuery
open SubQueryCursor
fetch next from	SubQueryCursor into @idfSubQuery

while @@fetch_status <> -1
begin
	
	exec spAsQueryFunction_Post @idfSubQuery
	
	fetch next from SubQueryCursor into @idfSubQuery
end
close SubQueryCursor
deallocate SubQueryCursor 


-- Drop and create query function
-- set separator value
set	@s = N' 
'

set @sqlCmd = N'
SET QUOTED_IDENTIFIER ON 
'
exec sp_executesql @sqlCmd

set @sqlCmd = N'
SET ANSI_NULLS ON 
'
exec sp_executesql @sqlCmd
set @sqlCmd = N'

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[' + @functionName + N']'') AND Type in (N''FN'', N''IF'', N''TF'', N''FS'', N''FT''))
DROP FUNCTION [dbo].[' + @functionName + N']
'
exec sp_executesql @sqlCmd

set @sqlCmd = N'

CREATE FUNCTION [dbo].[' + @functionName + N']
(
@LangID	as nvarchar(50)
)
returns table
as
return
' + @select + @s + @from + @s + @where + N'

'
exec sp_executesql @sqlCmd
--print substring(@sqlCmd, 0, 4000)
--print substring(@sqlCmd, 4000, 4000)
--print substring(@sqlCmd, 8000, 4000)
--print substring(@sqlCmd, 12000, 4000)
--print substring(@sqlCmd, 16000, 4000)
--print substring(@sqlCmd, 20000, 4000)
--print substring(@sqlCmd, 24000, 4000)
--print substring(@sqlCmd, 28000, 4000)
--print substring(@sqlCmd, 32000, 4000)

set @sqlCmd = N'
SET QUOTED_IDENTIFIER OFF 
'
exec sp_executesql @sqlCmd

set @sqlCmd = N'
SET ANSI_NULLS ON 
'
exec sp_executesql @sqlCmd

end

end

end

