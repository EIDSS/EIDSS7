

--##SUMMARY select queries for analytical module

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.01.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 11.11.2011

--##RETURNS Don't use

/*
--Example of a call of procedure:

exec spAsQuerySearchFieldPersonalDataGroupSelectLookup 'en', 49539640000000
*/ 
 
create PROCEDURE [dbo].[spAsQuerySearchFieldPersonalDataGroupSelectLookup]
	@LangID	as nvarchar(50),
	@QueryID	as bigint = null
AS

declare  @result as table
(
		 rn						bigint not null primary key
		,idfQuerySearchField	bigint not null
		,idfsSearchField		bigint not null
		,idflQuery				bigint not null
		,idfPersonalDataGroup	bigint not null
		,FieldAlias				varchar(max)	not null
		,blnShow				bit
)
insert into @result
select		ROW_NUMBER() over (order by q.idflQuery, sftpg.idfPersonalDataGroup),
			qsf.idfQuerySearchField,
			qsf.idfsSearchField,
			q.idflQuery,
			sftpg.idfPersonalDataGroup,
			case
				when qsf.idfsParameter is not null
					then	sf.strSearchFieldAlias + '__' + 
							cast(sob.idfsFormType as varchar(20)) + '__' + 
							cast(qsf.idfsParameter as varchar(20))
				else sf.strSearchFieldAlias
			end,
			qsf.blnShow
						
from		tasQuerySearchField qsf
inner join	
			tasSearchField sf
on			sf.idfsSearchField = qsf.idfsSearchField
inner join	(
	tasQuerySearchObject qso
	inner join	tasSearchObject sob
	on			sob.idfsSearchObject = qso.idfsSearchObject
	inner join	trtBaseReference br_sob
	on			br_sob.idfsBaseReference = sob.idfsSearchObject
				and br_sob.intRowStatus = 0
			)
on			qso.idfQuerySearchObject = qsf.idfQuerySearchObject
inner join	tasQuery q
on			q.idflQuery = qso.idflQuery
inner join	dbo.tasSearchFieldToPersonalDataGroup sftpg
on			sf.idfsSearchField = sftpg.idfsSearchField

where		(@QueryID is null or @QueryID = q.idflQuery)

select * from @result
order by	idflQuery, idfPersonalDataGroup, FieldAlias


