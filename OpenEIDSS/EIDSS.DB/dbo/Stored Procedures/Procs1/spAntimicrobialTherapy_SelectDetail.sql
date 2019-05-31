

--##SUMMARY Selects antibiotics/antitrivial therapies data for a specified human case.

--##REMARKS Author: Mirnaya O.
--##REMARKS Update date: 25.01.2010

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
declare	@idfCase	bigint

execute	spAntimicrobialTherapy_SelectDetail
	@idfCase
*/



create procedure	spAntimicrobialTherapy_SelectDetail
(		@idfCase	bigint		--##PARAM @idfCase Case Id
)
as

-- 0 tlbAntimicrobialTherapy
select		tlbAntimicrobialTherapy.idfAntimicrobialTherapy,
			tlbAntimicrobialTherapy.idfHumanCase,
			tlbAntimicrobialTherapy.datFirstAdministeredDate,
			tlbAntimicrobialTherapy.strAntimicrobialTherapyName,
			tlbAntimicrobialTherapy.strDosage
from		tlbAntimicrobialTherapy
inner join	tlbHumanCase
on			tlbHumanCase.idfHumanCase = tlbAntimicrobialTherapy.idfHumanCase
			and tlbHumanCase.intRowStatus = 0
where		tlbAntimicrobialTherapy.idfHumanCase = @idfCase
			and tlbAntimicrobialTherapy.intRowStatus = 0

