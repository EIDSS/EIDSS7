

--##SUMMARY Deletes statistic record

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 26.11.2009

--##RETURNS Doesn't use

/*
--Example of procedure call:

DECLARE @idfStatistic BIGINT
EXECUTE spStatistic_Delete @idfStatistic

*/

CREATE                 PROCEDURE dbo.spStatistic_Delete(
	@ID AS BIGINT
)
AS

DELETE FROM tlbStatistic
WHERE idfStatistic = @ID


