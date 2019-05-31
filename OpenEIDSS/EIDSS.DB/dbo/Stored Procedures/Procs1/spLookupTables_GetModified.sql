


--##SUMMARY returns the list of changed tables for lookup cache.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 17.12.2009

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE spLookupTables_GetModified '1234'

*/



CREATE            procedure [dbo].[spLookupTables_GetModified](
	@ClientID as nvarchar(50)
)
as

begin tran T1

declare @LastEvent as bigint
--declare @LastEventStr as nvarchar(200)
declare @CurrLastEvent as bigint

set @CurrLastEvent = 0

select top 1 @CurrLastEvent = idfEventID 
from		tstEventActive
order by	idfEventID desc

select
	@LastEvent = idfLastReferenceChangeEvent
from tstEventClient
where strClient = @ClientID


if @@ROWCOUNT = 0
begin
	print 'insert new event num ' + @ClientID + ',' + convert(nvarchar(200), @CurrLastEvent)
	insert into tstEventClient (strClient, idfLastReferenceChangeEvent)
	values (@ClientID, @CurrLastEvent)
	commit tran T1
	return -1
end
else if @LastEvent is null
begin
	print 'update last event num ' + @ClientID + ',' + convert(nvarchar(200), @CurrLastEvent)
	update	tstEventClient
	set		idfLastReferenceChangeEvent = @CurrLastEvent
	where	strClient = @ClientID

	commit tran T1
	return -1
end

print 'update last event num 1' + @ClientID + ',' + convert(nvarchar(200), @CurrLastEvent)

update	tstEventClient
set		idfLastReferenceChangeEvent = @CurrLastEvent
where	strClient = @ClientID

if @@ERROR <> 0
begin
	print 'ERROR'
	if @@TRANCOUNT < 2
		rollback tran T1
	else
		commit tran T1
	return -1
end

print 'select all events after' + convert(nvarchar(200), @LastEvent)
select		DISTINCT
			strInformationString 

from		tstEventActive
where		
			idfsEventTypeID=10025124 --'RaiseReferenceCacheChange'
			and idfEventID > @LastEvent
			and idfEventID <= @CurrLastEvent
			and strClient <> @ClientID


commit tran T1




