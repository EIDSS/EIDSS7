

--##SUMMARY Checks if case is related with other outbreak already
--##SUMMARY We consider that case is related with other outbreak if it exists and refers to outbreak other then passed @OutbreakID


--##REMARKS Author: Zurin M.
--##REMARKS Create date: 24.11.2009

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS 1 if case is related with other outbreak, 0 in other case

/*
--Example of function call:
DECLARE @Result nvarchar
DECLARE @idfCase bigint
SET @Result = dbo.fnIsCaseInOutbreak(@idfCase)

*/

CREATE function [dbo].[fnIsCaseInOutbreak]	(
						@CaseID bigint,
						@OutbreakID bigint = null)
returns nvarchar(50)
as
begin

DECLARE @strOutbreakID nvarchar(50)

if	(@CaseID is not null)
begin
	select	distinct @strOutbreakID = o.strOutbreakID 
	from	tlbOutbreak o
	inner join tlbHumanCase h
	on		h.idfOutbreak = o.idfOutbreak
			and h.idfHumanCase = @CaseID
			and h.intRowStatus = 0
	where 
			@OutbreakID IS NULL or (o.idfOutbreak <> @OutbreakID and o.intRowStatus = 0)
	if ISNULL(@strOutbreakID,N'') <> N''
		return @strOutbreakID
	
	select	distinct @strOutbreakID = o.strOutbreakID 
	from	tlbOutbreak o
	inner join tlbVetCase v
	on		v.idfOutbreak = o.idfOutbreak
			and v.idfVetCase = @CaseID
			and v.intRowStatus = 0
	where 
			@OutbreakID IS NULL or (o.idfOutbreak <> @OutbreakID and o.intRowStatus = 0)

	if ISNULL(@strOutbreakID,N'') <> N''
		return @strOutbreakID

	select	distinct @strOutbreakID = o.strOutbreakID 
	from	tlbOutbreak o
	inner join tlbVectorSurveillanceSession vs
	on		vs.idfOutbreak = o.idfOutbreak
			and vs.idfVectorSurveillanceSession = @CaseID
			and vs.intRowStatus = 0
	where 
			@OutbreakID IS NULL or (o.idfOutbreak <> @OutbreakID and o.intRowStatus = 0)

	if ISNULL(@strOutbreakID,N'') <> N''
		return @strOutbreakID
end
return @strOutbreakID
--if	(@CaseID is not null)
--	and exists	(
--		select		idfHumanCase
--		from		tlbHumanCase
--		where		idfHumanCase = @CaseID
--					and (@OutbreakID IS NULL or (idfOutbreak IS NOT NULL AND idfOutbreak <> @OutbreakID))
--					and (intRowStatus = 0)
--		UNION ALL
--		select		idfVetCase
--		from		tlbVetCase
--		where		idfVetCase = @CaseID
--					and (@OutbreakID IS NULL or (idfOutbreak IS NOT NULL AND idfOutbreak <> @OutbreakID))
--					and (intRowStatus = 0)
--		UNION ALL
--		select		idfVectorSurveillanceSession
--		from		tlbVectorSurveillanceSession
--		where		idfVectorSurveillanceSession = @CaseID
--					and (@OutbreakID IS NULL or (idfOutbreak IS NOT NULL AND idfOutbreak <> @OutbreakID))
--					and (intRowStatus = 0)
--				)
--begin
--	set @res = 1
--end

--return @res

end




