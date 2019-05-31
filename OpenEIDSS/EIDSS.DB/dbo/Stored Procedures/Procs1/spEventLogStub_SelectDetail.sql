



--##SUMMARY Stub procedure for autogenerating EventLog datail object in model.

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 04.10.2011

/*
--Example of a call of procedure:
DECLARE @RC INT
DECLARE @idfsEventTypeID BIGINT
DECLARE @idfObject BIGINT

EXEC spEventLogStub_SelectDetail 6866830000000, 'en'


*/




CREATE          procedure dbo.spEventLogStub_SelectDetail( 
	 @idfEventID as bigint,--##PARAM @idfEventID - event record ID
	 @LangID AS nvarchar(50)--##PARAM @LangID - language ID
)
as
	select * 
	FROM fn_Event_SelectList(@LangID)
	WHERE @idfEventID = idfEventID





