

--##SUMMARY Returns the count of human cases entered at the specified site.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 28.01.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Function returns the count of human cases entered at the specified site.


/*
--Example of a call of function:
declare @idfsSite	bigint
select dbo.fnHumanCaseCount (@idfsSite)

*/


CREATE	function	[dbo].[fnHumanCaseCount]
(
	@idfsSite as bigint --##PARAM @idfsSite Site Id
)
returns int
as
begin

declare @res int
set @res = 0

select			@res = count(*)
from			tlbHumanCase
JOIN tlbHuman ON
	tlbHuman.idfHuman = tlbHumanCase.idfHuman
	AND tlbHuman.intRowStatus = 0
where			tlbHumanCase.idfsSite = @idfsSite
	AND tlbHumanCase.intRowStatus = 0

return @res
end



