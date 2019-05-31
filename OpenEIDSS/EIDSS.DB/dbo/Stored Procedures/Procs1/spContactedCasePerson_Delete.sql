


--##SUMMARY Deletes Contacted Person.

--##REMARKS Author: Shatilova T.
--##REMARKS Update date: 17.11.2011

--##RETURNS Doesn't use



/*
--Example of a call of procedure:
declare	@ID bigint
exec	spContactedCasePerson_Delete @ID
*/

CREATE	procedure	[dbo].[spContactedCasePerson_Delete]
		@ID bigint --##PARAM  @ID - ContactedCasePerson Id
as
DECLARE @patientID bigint
SELECT @patientID = idfHuman 
FROM tlbContactedCasePerson
WHERE idfContactedCasePerson = @ID

delete
from	tlbContactedCasePerson
where	tlbContactedCasePerson.idfContactedCasePerson = @ID

exec	spPatient_Delete @patientID

