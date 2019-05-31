


--##SUMMARY Deletes atibiotic/antitrival therapy.

--##REMARKS Author: Mirnaya O.
--##REMARKS Update date: 25.01.2010

--##RETURNS Doesn't use



/*
--Example of a call of procedure:
declare	@ID bigint
exec	spAntimicrobialTherapy_Delete @ID
*/

create	procedure	spAntimicrobialTherapy_Delete
		@ID bigint --##PARAM  @ID - Atibiotic/antitrival therapy Id
as

delete
from	tlbAntimicrobialTherapy
where	tlbAntimicrobialTherapy.idfAntimicrobialTherapy = @ID



