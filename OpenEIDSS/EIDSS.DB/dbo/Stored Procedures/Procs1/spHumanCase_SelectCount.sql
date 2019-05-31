
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

create procedure	[dbo].[spHumanCase_SelectCount]
as

select		COUNT(*) 
from		tlbHumanCase
inner JOIN	tlbHuman 
ON			tlbHuman.idfHuman = tlbHumanCase.idfHuman
		AND tlbHuman.intRowStatus = 0
WHERE tlbHuman.intRowStatus = 0

