



--##SUMMARY Returns a list of people registered in the system as a patient or the owners of farms.

--##REMARKS Author: Mirnaya O.
--##REMARKS 
--##REMARKS Update date: 28.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##RETURNS Returns a list of patients of the system (consisting of patients of human cases, and the owners of farms from veterinary cases).


/*
Example of a call of procedure:
declare @RootHumanID	bigint
declare @HumanID		bigint

exec spPatient_SelectLookup
		@RootHumanID, 
		@HumanID
*/


CREATE	procedure	[dbo].[spPatient_SelectLookup]
(
	@RootHumanID as bigint = null, --##PARAM @RootHumanID A unique identifier of the original human
	@HumanID	 as bigint = null --##PARAM @ID A unique identifier of the human
)
as

-- TO DO: Criterion for idfRootParty

select		tlbHuman.idfHuman, 
			tlbHuman.idfHumanActual as idfRootHuman,
			dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName, tlbHuman.strSecondName)
			as PatientName 
from		tlbHuman
where		(@RootHumanID is null or @RootHumanID = tlbHuman.idfHumanActual)
			and (@HumanID is null or @HumanID = tlbHuman.idfHuman)
			AND intRowStatus = 0




