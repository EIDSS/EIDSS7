

--##SUMMARY Returns id of the first human case entered at the specified site.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 28.01.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Function returns id of the first human case entered at the specified site.


/*
--Example of a call of function:
declare @idfsSite	bigint
select dbo.fnFirstHumanCase (@idfsSite)

*/


CREATE	function	[dbo].[fnFirstHumanCase]
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
INNER JOIN		tlbHuman as tlbFirstHuman
ON				tlbFirstHuman.idfHuman = tlbFirstHumanCase.idfHuman
				AND tlbFirstHuman.intRowStatus = 0
left join		(
	tlbHumanCase as tlbMinHumanCase
	JOIN tlbHuman as tlbMinHuman ON
		tlbMinHuman.idfHuman = tlbMinHumanCase.idfHuman
		AND tlbMinHuman.intRowStatus = 0
				)
on				tlbMinHumanCase.idfsSite = @idfsSite
				AND tlbMinHumanCase.intRowStatus = 0
				and	(	(tlbMinHumanCase.datEnteredDate < tlbFirstHumanCase.datEnteredDate)
						or ((tlbMinHumanCase.datEnteredDate = tlbFirstHumanCase.datEnteredDate)
							and (tlbMinHumanCase.strCaseID < tlbFirstHumanCase.strCaseID))
					)
where			tlbFirstHumanCase.idfsSite = @idfsSite
				and tlbMinHumanCase.idfHumanCase is NULL
				AND tlbFirstHumanCase.intRowStatus = 0
return @res
end



