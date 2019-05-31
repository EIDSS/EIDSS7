
--##SUMMARY Selects lookup list of human aggregate case parameters for avr module.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 14.02.2014

--##RETURNS Doesn't use


/*
--Example of procedure call:

EXEC spHumanAggregateCaseParameter_SelectLookup 'en'

*/

CREATE PROCEDURE [dbo].[spHumanAggregateCaseParameter_SelectLookup]
	@LangID nvarchar(50)
AS
select 
	p.idfsParameter 
	, r_p.[name]
from	ffParameter p
inner join fnReference('en', 19000034) ft -- Form Type
	on	ft.idfsReference = p.idfsFormType
		and ft.idfsReference = 10034012 -- Human Aggregate Case
inner join fnReference(@LangID, 19000066) r_p -- Flexible Form Parameter
	on	r_p.idfsReference = p.idfsParameter
where	p.intRowStatus = 0

RETURN 0

