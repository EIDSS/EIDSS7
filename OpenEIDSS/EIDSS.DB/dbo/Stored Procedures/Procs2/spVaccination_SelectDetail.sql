
--##SUMMARY Selects vaccination data related with specific case.
--##SUMMARY Called from VaccinationPanel.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
DECLARE @idfCase bigint

EXECUTE spVaccination_SelectDetail
  ,@idfCase
*/



CREATE              Proc	spVaccination_SelectDetail
		@idfCase	bigint  --##PARAM @idfCase - case ID
As

--0 Vaccination info
SELECT 
		idfVaccination
		,tlbVaccination.idfVetCase
		,idfSpecies
		,idfsVaccinationType
		,idfsVaccinationRoute
		,idfsDiagnosis
		,datVaccinationDate
		,strManufacturer
		,strLotNumber
		,intNumberVaccinated
		,strNote
		,tlbVetCase.idfsCaseType
  FROM tlbVaccination
  INNER JOIN tlbVetCase ON
	tlbVaccination.idfVetCase=tlbVetCase.idfVetCase
WHERE
		tlbVaccination.idfVetCase = @idfCase
		and tlbVaccination.intRowStatus = 0
