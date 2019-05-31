

-- =============================================
-- Author:		Vasilyev I.
-- Create date: 
-- Description:
-- =============================================


--##SUMMARY Select Query Search Fields for given layout.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 10.01.2012

--##RETURNS Doesn't use

/*
--Example of a call of function:
select * from tasLayout
select * from dbo.fnLayoutSearchFields (6660680000000)
*/



create Function dbo.fnLayoutSearchFields
(
	@idflLayout	as bigint
)
Returns Table
as
return
	
	SELECT 
			qsf.idfQuerySearchField,
			sf.strSearchFieldAlias + 
			IsNull(	'__' + cast(sob.idfsFormType as varchar(20)) + '__' + 
			cast(qsf.idfsParameter as varchar(20)), '') AS strSearchFieldAlias
	from	tasQuerySearchField qsf
	inner join	(
						tasQuerySearchObject qso
			inner join	tasLayout l
					on	l.idflQuery = qso.idflQuery
				   and	l.idflLayout = @idflLayout
			inner join	tasSearchObject sob
					on	sob.idfsSearchObject = qso.idfsSearchObject
			inner join	trtBaseReference br_sob
					on	br_sob.idfsBaseReference = sob.idfsSearchObject
				   and	br_sob.intRowStatus = 0
			)
		on	qso.idfQuerySearchObject = qsf.idfQuerySearchObject
inner join	(
						tasSearchField sf
			inner join	trtBaseReference br_sf
					on	br_sf.idfsBaseReference = sf.idfsSearchField
				   and	br_sf.intRowStatus = 0
			)
		on	sf.idfsSearchField = qsf.idfsSearchField
	   and	sf.idfsSearchObject = qso.idfsSearchObject
 left join	(
						ffParameter p
			inner join	trtBaseReference br_p
					on	br_p.idfsBaseReference = p.idfsParameter
				   and	br_p.intRowStatus = 0
			)
		on	p.idfsParameter = qsf.idfsParameter
			and p.idfsFormType = sob.idfsFormType
			and p.intRowStatus = 0


