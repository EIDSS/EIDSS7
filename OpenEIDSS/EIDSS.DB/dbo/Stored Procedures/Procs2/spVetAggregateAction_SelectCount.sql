

create procedure	[dbo].[spVetAggregateAction_SelectCount]
as

select		COUNT(*) 
FROM		tlbAggrCase
WHERE		tlbAggrCase.intRowStatus = 0
			AND tlbAggrCase.idfsAggrCaseType = 10102003

