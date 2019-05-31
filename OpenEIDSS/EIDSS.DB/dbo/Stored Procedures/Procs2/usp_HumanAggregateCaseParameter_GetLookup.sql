--=====================================================================================================
-- Created by:				Joan Li
-- Description:				06/21/2017: Created based on V6 spHumanAggregateCaseParameter_SelectLookup :  V7 USP76
--                          Selects lookup list of human aggregate case parameters for avr module 
--                          from these tables: ffParameter
/*
----testing code:
EXEC usp_HumanAggregateCaseParameter_GetLookup 'en'

----related fact data from
select * from tlbActivityParameters
select * from tflObservationFiltered
*/
--=====================================================================================================

CREATE PROCEDURE [dbo].[usp_HumanAggregateCaseParameter_GetLookup]
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


