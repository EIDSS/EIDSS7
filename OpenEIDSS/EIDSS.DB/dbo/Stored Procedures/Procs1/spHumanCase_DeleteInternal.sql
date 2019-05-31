


--##SUMMARY Deletes human case with its contacts, antimicrobial therapies, observations, and geographical location.
--##SUMMARY This procedure is used during human case deduplication with @ClearFiltration = 0
--##SUMMARY and internally by spHumanCase_Delete with @ClearFiltration = 1

--##REMARKS Author: Mirnaya O.
--##REMARKS Update date: 22.01.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 08.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##REMARKS UPDATED BY: Zurin M. --@ClearFiltration is added
--##REMARKS Date: 17.04.2013

--##RETURNS Doesn't use



/*
--Example of a call of procedure:
declare	@ID bigint
exec	spHumanCase_DeleteInternal @ID, 1
*/

CREATE	procedure	[dbo].[spHumanCase_DeleteInternal]
		@ID bigint, --##PARAM  @ID - Human case ID
		@ClearFiltration bit = 1
as

declare	@tlbHuman_del		table (idfHuman bigint not null primary key)
declare	@idfHuman_del		bigint

declare	@idfEpiObservation	bigint
declare	@idfCSObservation	bigint
declare	@idfGeoLocation	bigint

select	@idfEpiObservation		=	tlbHumanCase.idfEpiObservation,
		@idfCSObservation		=	tlbHumanCase.idfCSObservation,
		@idfGeoLocation			=	tlbHumanCase.idfPointGeoLocation
from	tlbHumanCase
where	tlbHumanCase.idfHumanCase = @ID

insert into	@tlbHuman_del (idfHuman)
select	tlbHumanCase.idfHuman
from	tlbHumanCase
where	tlbHumanCase.idfHumanCase = @ID

insert into		@tlbHuman_del (idfHuman)
select distinct	tlbContactedCasePerson.idfHuman
from			tlbContactedCasePerson
left join		@tlbHuman_del as tlbHuman_del
on				tlbHuman_del.idfHuman = tlbContactedCasePerson.idfHuman
where			tlbContactedCasePerson.idfHumanCase = @ID
				and tlbHuman_del.idfHuman is null


delete
from	tlbAntimicrobialTherapy
where	tlbAntimicrobialTherapy.idfHumanCase = @ID

delete
from	tlbChangeDiagnosisHistory
where	tlbChangeDiagnosisHistory.idfHumanCase = @ID

declare @sample_del bigint
declare Sample_Cursor Cursor local read_only forward_only for
	select		idfMaterial
	from		tlbMaterial
	where		tlbMaterial.idfHumanCase=@ID
				and tlbMaterial.intRowStatus = 0

open Sample_Cursor
fetch next from Sample_Cursor into @sample_del
while @@FETCH_STATUS <>-1
begin
	exec spLabSample_Delete @sample_del
	fetch next from Sample_Cursor into @sample_del
end
close Sample_Cursor
deallocate Sample_Cursor

if @ClearFiltration = 1
	delete from tflHumanCaseFiltered 
	where	idfHumanCase = @ID

delete
from	tlbHumanCase
where	tlbHumanCase.idfHumanCase = @ID

declare Human_Cursor Cursor local read_only forward_only for
	select		idfHuman
	from		@tlbHuman_del
	order by	idfHuman
open Human_Cursor
fetch next from Human_Cursor into @idfHuman_del
while @@FETCH_STATUS <>-1
begin
	exec spPatient_Delete @idfHuman_del
	fetch next from Human_Cursor into @idfHuman_del
end
close Human_Cursor
deallocate Human_Cursor

exec	spObservation_Delete	@idfEpiObservation
exec	spObservation_Delete	@idfCSObservation
exec	spGeoLocation_Delete	@idfGeoLocation


