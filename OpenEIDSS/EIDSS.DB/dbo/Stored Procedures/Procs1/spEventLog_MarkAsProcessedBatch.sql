

--##SUMMARY Marks all event log record of specific Type as processed. Processed records are not selected during new client events selection.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 17.12.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
DECLARE @idfsEventTypeID BIGINT
EXEC spEventLog_MarkAsProcessedBatch @idfsEventTypeID
*/


CREATE         procedure dbo.spEventLog_MarkAsProcessedBatch( 
	@idfsEventTypeID as bigint --##PARAM @idfsEventTypeID - event record Type
)
as

update	tstEventActive
set		intProcessed = 1 
where	idfsEventTypeID = @idfsEventTypeID




