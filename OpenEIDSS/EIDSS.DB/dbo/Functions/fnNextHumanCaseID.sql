

--##SUMMARY Returns id of the next human case for the specified number in the list of human cases entered at the same site.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 28.01.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Function returns id of the next human case for the specified number in the list of human cases entered at the same site.


/*
--Example of a call of function:
declare @idfCase		bigint
select dbo.fnNextHumanCaseID (@idfCase)

*/


CREATE	function	[dbo].[fnNextHumanCaseID]
(
	@idfCase	as bigint	--##PARAM @number Id of the human case
)
returns bigint
as
begin

declare @res bigint
set @res = null

declare	@datEnteredDate	datetime
declare	@strCaseID		nvarchar(200)
declare	@idfsSite		bigint

select			@datEnteredDate	= tlbHumanCase.datEnteredDate,
				@strCaseID		= tlbHumanCase.strCaseID,
				@idfsSite		= tlbHumanCase.idfsSite
from			tlbHumanCase
JOIN tlbHuman ON
	tlbHuman.idfHuman = tlbHumanCase.idfHuman
	AND tlbHuman.intRowStatus = 0
where			tlbHumanCase.idfHumanCase = @idfCase
				AND tlbHumanCase.intRowStatus = 0

select top 1	@res = tlbHumanCase.idfHumanCase
from			tlbHumanCase
JOIN tlbHuman ON
	tlbHuman.idfHuman = tlbHumanCase.idfHuman
	AND tlbHuman.intRowStatus = 0
where			tlbHumanCase.idfsSite = @idfsSite
				AND tlbHumanCase.intRowStatus = 0
				and	(	(tlbHumanCase.datEnteredDate > @datEnteredDate)
						or ((tlbHumanCase.datEnteredDate = @datEnteredDate)
							and (tlbHumanCase.strCaseID > @strCaseID))
					)
order by		tlbHumanCase.datEnteredDate, tlbHumanCase.strCaseID

return @res
end



