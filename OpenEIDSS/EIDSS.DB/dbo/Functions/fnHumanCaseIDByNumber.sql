

--##SUMMARY Returns id of the human case with the specified number in the list of human cases entered at the specified site.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 28.01.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Function returns id of the human case with the specified number in the list of human cases entered at the specified site.


/*
--Example of a call of function:
declare @number		bigint
declare @idfsSite	bigint
select dbo.fnHumanCaseIDByNumber (@number, @idfsSite)

*/


CREATE	function	[dbo].[fnHumanCaseIDByNumber]
(
	@number		as int,		--##PARAM @number  Number of the human case
	@idfsSite	as	bigint	--##PARAM @idfsSite  Site Id
)
returns bigint
as
begin

declare @res bigint
set @res = null

select			@res = tlbCurrentHumanCase.idfHumanCase
from			tlbHumanCase as tlbCurrentHumanCase
JOIN tlbHuman ON
	tlbHuman.idfHuman = tlbCurrentHumanCase.idfHuman
	AND tlbHuman.intRowStatus = 0
where			tlbCurrentHumanCase.idfsSite = @idfsSite
AND tlbCurrentHumanCase.intRowStatus = 0
and (	
	select	count(*)
	from tlbHumanCase as tlbMinHumanCase
	JOIN tlbHuman ON
		tlbHuman.idfHuman = tlbMinHumanCase.idfHuman
		AND tlbHuman.intRowStatus = 0
	where			tlbMinHumanCase.idfsSite = @idfsSite
					AND tlbMinHumanCase.intRowStatus = 0
					and	(	(tlbMinHumanCase.datEnteredDate < tlbCurrentHumanCase.datEnteredDate)
							or ((tlbMinHumanCase.datEnteredDate = tlbCurrentHumanCase.datEnteredDate)
								and (tlbMinHumanCase.strCaseID <= tlbCurrentHumanCase.strCaseID))
						)
) = @number



return @res
end



