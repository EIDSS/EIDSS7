

create procedure	[dbo].[spHumanAggregateCase_SelectCount]
as

select		COUNT(*) 
FROM		tlbAggrCase
WHERE		tlbAggrCase.intRowStatus = 0
			AND tlbAggrCase.idfsAggrCaseType = 10102001

