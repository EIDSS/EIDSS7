

CREATE PROCEDURE dbo.spLogoffUser(
		@ClientID as varchar(100), 
		@idfUserID as bigint
)
AS

IF @idfUserID = null or @ClientID = null
	RETURN 0;
UPDATE tstLocalConnectionContext
SET 
  idfUserID = null
  ,idfDataAuditEvent = null
  ,idfEventID = null
  ,binChallenge = null
WHERE strConnectionContext = @ClientID
	

RETURN 0

