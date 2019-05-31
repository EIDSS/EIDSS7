
--##SUMMARY Checks the uniqueness of Personal ID in the system.

--##REMARKS Author: Zurin M.
--##REMARKS Update date: 20.11.2013


--##RETURNS 1 if Personal ID is empty or unique
--			0 if exist other root patient with the same personal ID



/*
--Example of a call of procedure:
declare	@Ret int
exec	@Ret = spPatient_ValidatePersonID 1, N'aaa'
print @Ret
*/

CREATE PROCEDURE [spPatient_ValidatePersonID]
	@idfHumanActual bigint,
	@strPersonID nvarchar(100),
	@idfsPersonIDType bigint
AS
	if (LTRIM(RTRIM(ISNULL(@strPersonID,N''))) = N'' or ISNULL(@idfsPersonIDType, 51577280000000) = 51577280000000) --51577280000000 - unknown personal ID type
		return 1
	IF EXISTS (select * from tlbHumanActual where idfHumanActual<>@idfHumanActual AND intRowStatus=0 AND strPersonID = @strPersonID and idfsPersonIDType = @idfsPersonIDType)
		return 0
RETURN 1

