

--##SUMMARY Checks if human case can be added to outbreak
--##SUMMARY We consider that case can be added to outbreak if it exists and doesn't marked as not related to outbreak by human case idfsYNRelatedToOutbreak field


--##REMARKS Author: Zurin M.
--##REMARKS Create date: 24.11.2009

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS 1 if case can be added to outbreak, 0 in other case

/*
--Example of function call:
DECLARE @Result bit
DECLARE @idfCase bigint
SET @idfCase = 91190000000
SET @Result = dbo.fnCanCaseBeAddedToOutbreak(@idfCase)
Print @Result
*/
CREATE function [dbo].[fnCanCaseBeAddedToOutbreak] (
	@CaseID BIGINT --##PARAM @CaseID - human case ID
)
returns bit
as
begin

declare @res bit
set @res = 0

if	(@CaseID is not null)
	and exists	(
		select		tlbHumanCase.*
		from		tlbHumanCase
		where		idfHumanCase = @CaseID
					and (idfsYNRelatedToOutbreak is null  or idfsYNRelatedToOutbreak <> 10100002/*ynvNo*/)
					and (tlbHumanCase.intRowStatus = 0)
				)
begin
	set @res = 1
end

return @res

end


