
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

create procedure	[dbo].[spVsSession_SelectCount]
as

select		COUNT(*) 
from		tlbVectorSurveillanceSession
where		tlbVectorSurveillanceSession.intRowStatus = 0



