

--##SUMMARY Returns id of the last human case entered at the specified site.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 28.01.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Function returns id of the last human case entered at the specified site.


/*
--Example of a call of function:
declare @idfsSite	bigint
select dbo.fnLastHumanCase (@idfsSite)

*/


CREATE	function	[dbo].[fnLastHumanCase]
(
	@idfsSite as bigint --##PARAM @idfsSite Site Id
)
returns bigint
as
begin

declare @res bigint
set @res = null

select			@res = tlbFirstHumanCase.idfHumanCase
from			tlbHumanCase as tlbFirstHumanCase
JOIN tlbHuman as tlbFirstHuman ON
	tlbFirstHuman.idfHuman = tlbFirstHumanCase.idfHuman
	AND tlbFirstHuman.intRowStatus = 0
left join		(
	tlbHumanCase as tlbMaxHumanCase
	JOIN tlbHuman as tlbMaxHuman ON
		tlbMaxHuman.idfHuman = tlbMaxHumanCase.idfHuman
		AND tlbMaxHuman.intRowStatus = 0
				)
on				tlbMaxHumanCase.idfsSite = @idfsSite
				AND tlbMaxHumanCase.intRowStatus = 0
				and	(	(tlbMaxHumanCase.datEnteredDate > tlbFirstHumanCase.datEnteredDate)
						or ((tlbMaxHumanCase.datEnteredDate = tlbFirstHumanCase.datEnteredDate)
							and (tlbMaxHumanCase.strCaseID > tlbFirstHumanCase.strCaseID))
					)
where			tlbFirstHumanCase.idfsSite = @idfsSite
				AND tlbFirstHumanCase.intRowStatus = 0
				and tlbMaxHumanCase.idfHumanCase is null

return @res
end



