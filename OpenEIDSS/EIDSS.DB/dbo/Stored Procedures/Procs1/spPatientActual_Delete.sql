


--##SUMMARY Deletes human case with its contacts, antimicrobial therapies, observations, and geographical location.

--##REMARKS Author: Mirnaya O.
--##REMARKS Update date: 22.01.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##RETURNS Doesn't use



/*
--Example of a call of procedure:
declare	@ID bigint
exec	spPatient_Delete @ID
*/

CREATE	procedure	[dbo].[spPatientActual_Delete]
		@ID bigint --##PARAM  @ID - Human Id
as


--TODO: Delete samples, tests here?
declare @idfHuman_del bigint
declare Human_Cursor Cursor local read_only forward_only for
	select		idfHuman
	from		tlbHuman
	where		idfHumanActual = @ID
open Human_Cursor
fetch next from Human_Cursor into @idfHuman_del
while @@FETCH_STATUS <>-1
begin
	exec spPatient_Delete @idfHuman_del
	fetch next from Human_Cursor into @idfHuman_del
end
close Human_Cursor
deallocate Human_Cursor

delete	
from		tlbHumanActual
where		tlbHumanActual.idfHumanActual = @ID
			AND tlbHumanActual.intRowStatus = 0
		

