

--##SUMMARY select queries for analytical module

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.01.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 11.11.2011

--##RETURNS Don't use

/*
--Example of a call of procedure:

exec spAsQuerySearchFieldSelectLookup 'en'
*/ 
 
CREATE PROCEDURE [dbo].[spAsQuerySearchFieldSelectLookup]
	@LangID	as nvarchar(50),
	@QueryID	as bigint = null,
	@ID			as bigint = null
AS

select		qsf.idfQuerySearchField,
			qsf.blnShow,
			q.idflQuery,
			case
				when qsf.idfsParameter is not null
					then	sf.strSearchFieldAlias + '__' + 
							cast(sob.idfsFormType as varchar(20)) + '__' + 
							cast(qsf.idfsParameter as varchar(20))
				else sf.strSearchFieldAlias
			end as FieldAlias,
			case
				when qsf.idfsParameter is not null
					then p_ref_en.[name]
				else sf_ref_en.[name]
			end as FieldENCaption,
			case
				when qsf.idfsParameter is not null
					then p_ref.[name]
				else sf_ref.[name]
			end as FieldCaption,
			sf.idfsGISReferenceType,
			sf.intMapDisplayOrder,
			sf.intIncidenceDisplayOrder,
			sf.idfsSearchFieldType,
			pt.idfsParameterType
from		tasQuerySearchField qsf
inner join	(
	tasSearchField sf
	inner join	fnReference(@LangID, 19000080) sf_ref		-- 'rftSearchField'
	on			sf_ref.idfsReference = sf.idfsSearchField
	left join	fnReference('en', 19000080) sf_ref_en			-- 'rftSearchField'
	on			sf_ref_en.idfsReference = sf.idfsSearchField
			)
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
left join	(
	ffParameter p
	inner join	(
		ffParameterType pt
		inner join	trtBaseReference br_pt
		on			br_pt.idfsBaseReference = pt.idfsParameterType
					and br_pt.intRowStatus = 0
				)
	on			pt.idfsParameterType = p.idfsParameterType
				and pt.intRowStatus = 0
	inner join	fnReference(@LangID, 19000066) p_ref	-- 'rftParameter'
	on			p_ref.idfsReference = p.idfsParameter
	left join	fnReference('en', 19000066) p_ref_en		-- 'rftParameter'
	on			p_ref_en.idfsReference = p.idfsParameter
			)
on			p.idfsParameter = qsf.idfsParameter
			and p.idfsFormType = sob.idfsFormType

where		(@QueryID is null or @QueryID = q.idflQuery)
			and (@ID is null or @ID = qsf.idfQuerySearchField)
order by	q.idflQuery, FieldCaption, qsf.idfQuerySearchField


