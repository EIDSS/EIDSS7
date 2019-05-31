

--##SUMMARY This procedure selects the list of query search fields 
--##SUMMARY related to specified query search object.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 20.04.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 11.11.2011

--##RETURNS Don't use

/*
--Example of a call of procedure:

declare	@ID	bigint
exec spAsQuerySearchObject_SelectFieldList @ID, 'en'
*/ 
 
CREATE procedure	[dbo].[spAsQuerySearchObject_SelectFieldList]
	@ID			bigint,
	@LangID		nvarchar(50)
as

-- tasQuerySearchField
select		qsf.idfQuerySearchField,
			qsf.idfQuerySearchObject,
			qsf.idfsSearchField,
			case
				when qsf.idfsParameter is not null
					then	sf.strSearchFieldAlias + '__' + 
							cast(p.idfsFormType as varchar(20)) + '__' + 
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
			qsf.blnShow,
			qsf.idfsParameter,
			case
				when	IsNull(sf.idfsSearchFieldType, -1) = 10081006	-- Integer
					then	1
				when	IsNull(sf.idfsSearchFieldType, -1) = 10081004	-- Float
					then	1
				when	IsNull(sf.idfsSearchFieldType, -1) = 10081002	-- Date
					then	7
				when	IsNull(sf.idfsSearchFieldType, -1) = 10081001	-- Bit
					then	8
				when	sf.idfsSearchFieldType is null
						and IsNull(p.idfsParameterType, -1) = 10071007	-- Numeric
					then	1
				when	sf.idfsSearchFieldType is null
						and IsNull(p.idfsParameterType, -1) = 10071061	-- Numeric Integer
					then	1
				when	sf.idfsSearchFieldType is null
						and IsNull(p.idfsParameterType, -1) = 10071059	-- Numeric Natural
					then	1
				when	sf.idfsSearchFieldType is null
						and IsNull(p.idfsParameterType, -1) = 10071060	-- Numeric Positive
					then	1
				when	sf.idfsSearchFieldType is null
						and IsNull(p.idfsParameterType, -1) = 10071029	-- Date
					then	7
				when	sf.idfsSearchFieldType is null
						and IsNull(p.idfsParameterType, -1) = 10071030	-- DateTime
					then	7
				when	sf.idfsSearchFieldType is null
						and IsNull(p.idfsParameterType, -1) = 10071025	-- Boolean
					then	8
				else		0											-- String
			end as TypeImageIndex,
			sf.idfsSearchFieldType


from		tasQuerySearchField qsf
inner join	tasSearchField sf
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
inner join	fnReference(@LangID, 19000080) sf_ref		-- 'rftSearchField'
on			sf_ref.idfsReference = qsf.idfsSearchField
left join	fnReference('en', 19000080) sf_ref_en			-- 'rftSearchField'
on			sf_ref_en.idfsReference = qsf.idfsSearchField
left join	(
	ffParameter p
	inner join	fnReference(@LangID, 19000066) p_ref	-- 'rftParameter'
	on			p_ref.idfsReference = p.idfsParameter
	left join	fnReference('en', 19000066) p_ref_en		-- 'rftParameter'
	on			p_ref_en.idfsReference = p.idfsParameter
			)
on			p.idfsParameter = qsf.idfsParameter
			and p.idfsFormType = sob.idfsFormType

where		qsf.idfQuerySearchObject = @ID





