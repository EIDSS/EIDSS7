

--##SUMMARY Selects data for a specified human.

--##REMARKS Author: Mirnaya O.
--##REMARKS Update date: 22.01.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
declare	@idfHuman	bigint

execute	spPatient_SelectDetail
	@idfHuman
*/



CREATE procedure	[dbo].[spPatient_SelectDetail]
(		@idfHuman	bigint		--##PARAM @idfHuman Human Id
)
as
if exists (select idfHuman from	tlbHuman where	idfHuman = @idfHuman and intRowStatus = 0)
-- 0 tlbHuman
select		tlbHuman.idfHuman,
			tlbHuman.idfHumanActual AS idfRootHuman,
			thc.idfHumanCase AS idfCase,
			thc.intPatientAge as intPatientAgeFromCase,
			thc.idfsHumanAgeType as idfsHumanAgeTypeFromCase,
			tlbHuman.idfsOccupationType,
			tlbHuman.idfsNationality,
			tlbHuman.idfsHumanGender,
			tlbHuman.idfCurrentResidenceAddress,
			tlbHuman.idfEmployerAddress,
			tlbHuman.idfRegistrationAddress,
			tlbHuman.datDateofBirth,
			tlbHuman.datDateOfDeath,
			tlbHuman.strLastName,
			tlbHuman.strSecondName,
			tlbHuman.strFirstName,
			tlbHuman.strRegistrationPhone,
			tlbHuman.strEmployerName,
			tlbHuman.strHomePhone,
			tlbHuman.strWorkPhone,
			tlbHuman.idfsPersonIDType,
			tlbHuman.strPersonID,
			tlbHuman.datEnteredDate,
			tlbHuman.datModificationDate,
			tlbHuman.datModificationForArchiveDate
from		tlbHuman
LEFT OUTER JOIN tlbHumanCase thc ON
	thc.idfHuman = tlbHuman.idfHuman
where		tlbHuman.idfHuman = @idfHuman
	AND tlbHuman.intRowStatus = 0
else
begin
	select		tlbHumanActual.idfHumanActual as idfHuman,
			CAST(NULL AS BIGINT) AS idfRootHuman,
			CAST(NULL AS BIGINT) AS idfCase,
			CAST(NULL AS INT) as intPatientAgeFromCase,
			CAST(NULL AS BIGINT) as idfsHumanAgeTypeFromCase,
			tlbHumanActual.idfsOccupationType,
			tlbHumanActual.idfsNationality,
			tlbHumanActual.idfsHumanGender,
			tlbHumanActual.idfCurrentResidenceAddress,
			tlbHumanActual.idfEmployerAddress,
			tlbHumanActual.idfRegistrationAddress,
			tlbHumanActual.datDateofBirth,
			tlbHumanActual.datDateOfDeath,
			tlbHumanActual.strLastName,
			tlbHumanActual.strSecondName,
			tlbHumanActual.strFirstName,
			tlbHumanActual.strRegistrationPhone,
			tlbHumanActual.strEmployerName,
			tlbHumanActual.strHomePhone,
			tlbHumanActual.strWorkPhone,
			tlbHumanActual.idfsPersonIDType,
			tlbHumanActual.strPersonID,
			tlbHumanActual.datEnteredDate,
			tlbHumanActual.datModificationDate,
			CAST(NULL as datetime) as datModificationForArchiveDate
	from		tlbHumanActual
	where		tlbHumanActual.idfHumanActual = @idfHuman
		AND tlbHumanActual.intRowStatus = 0
end
