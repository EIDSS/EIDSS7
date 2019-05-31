
CREATE PROCEDURE [dbo].[spAsAvrSettings_SelectLookup]
	@LangID nvarchar(50)
AS
--0 aggregate functions precision
select 
			a.idfsAggregateFunction, 
			af.name as strAggregateFunction, 
			a.intDefaultPrecision 
from		dbo.fnReference(@LangID, 19000004 /*'rftAggregateFunction'*/) af
inner join	tasAggregateFunction a
on			a.idfsAggregateFunction = af.idfsReference
--where		a.blnPivotGridFunction = 1
	
--1 search fields
select		sf.idfsSearchField,
			sf_ref.[name] as strFieldCaption,
			sf.idfsDefaultAggregateFunction,
			sf.idfsSearchObject
from		tasSearchField sf
inner join	fnReference(@LangID, 19000080) sf_ref	-- 'rftSearchField'
on			sf_ref.idfsReference = sf.idfsSearchField
where		sf.intRowStatus = 0
order by	sf.idfsSearchObject, sf_ref.[name]

--2 dummy value for master search object
select CAST(0 as bigint) idfsSearchObject

RETURN 0

