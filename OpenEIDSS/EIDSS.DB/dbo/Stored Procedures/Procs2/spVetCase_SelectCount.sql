
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

create procedure	[dbo].[spVetCase_SelectCount]
as

select		COUNT(*) 
from		tlbVetCase
where		tlbVetCase.intRowStatus = 0



