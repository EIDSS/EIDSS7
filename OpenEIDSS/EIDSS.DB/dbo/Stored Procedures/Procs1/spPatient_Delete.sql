


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

CREATE	procedure	[dbo].[spPatient_Delete]
		@ID bigint --##PARAM  @ID - Human Id
as

DECLARE @idfHumanActual bigint
DECLARE @idfCurrentResidenceAddress bigint
DECLARE @idfEmployerAddress bigint
DECLARE @idfRegistrationAddress bigint
SELECT 
	@idfHumanActual = idfHumanActual 
	,@idfCurrentResidenceAddress = idfCurrentResidenceAddress 
	,@idfEmployerAddress = idfEmployerAddress 
	,@idfRegistrationAddress = idfRegistrationAddress 
FROM tlbHuman 
WHERE idfHuman = @ID

--TODO: Delete samples, tests here?

delete
from	tlbContactedCasePerson
where	tlbContactedCasePerson.idfHuman = @ID
		AND tlbContactedCasePerson.intRowStatus = 0

delete from tflHumanFiltered
where idfHuman = @ID

delete	
from	tlbHuman
where	tlbHuman.idfHuman = @ID
		AND tlbHuman.intRowStatus = 0

exec spGeoLocation_Delete @idfCurrentResidenceAddress
exec spGeoLocation_Delete @idfEmployerAddress
exec spGeoLocation_Delete @idfRegistrationAddress
		
--If last link to the root human was deleted	
--delete the root human record	
--IF NOT EXISTS(SELECT	idfHuman FROM tlbHuman 
--				WHERE	idfHumanActual=@idfHumanActual
--						AND intRowStatus = 0)
--BEGIN
--	SELECT 
--		@idfCurrentResidenceAddress = idfCurrentResidenceAddress 
--		,@idfEmployerAddress = idfEmployerAddress 
--		,@idfRegistrationAddress = idfRegistrationAddress 
--	FROM tlbHumanActual 
--	WHERE idfHumanActual = @idfHumanActual

--	delete	from tlbGeoLocationShared
--	where		idfGeoLocationShared = @idfCurrentResidenceAddress
--	delete	from tlbGeoLocationShared
--	where		idfGeoLocationShared = @idfEmployerAddress
--	delete	from tlbGeoLocationShared
--	where		idfGeoLocationShared = @idfRegistrationAddress


--	delete	
--	from	tlbHumanActual
--	where	tlbHumanActual.idfHumanActual = @idfHumanActual
--			AND tlbHumanActual.intRowStatus = 0

--	delete	from tlbGeoLocationShared
--	where		idfGeoLocationShared = @idfCurrentResidenceAddress
--	delete	from tlbGeoLocationShared
--	where		idfGeoLocationShared = @idfEmployerAddress
--	delete	from tlbGeoLocationShared
--	where		idfGeoLocationShared = @idfRegistrationAddress
		
--END
