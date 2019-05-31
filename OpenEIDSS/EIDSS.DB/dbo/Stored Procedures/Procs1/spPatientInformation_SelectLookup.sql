



--##SUMMARY Returns a list of patients, contact persons and farm owners with additional information.

--##REMARKS Author: Mirnaya O.
--##REMARKS 
--##REMARKS Update date: 28.01.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##RETURNS Returns a list of patients, contact persons and farm owners with additional information.


/*
Example of a call of procedure:
declare @LangID			nvarchar(50)
declare @RootHumanID	bigint
declare @ID				bigint

set @LangID = 'en'
exec spPatientInformation_SelectLookup
		@LangID, 
		@RootHumanID, 
		@ID
*/


CREATE	procedure	[dbo].[spPatientInformation_SelectLookup]
(
	@LangID			as nvarchar(50),	--##PARAM Language Id
	@RootHumanID	as bigint = null,	--##PARAM @RootHumanID A unique identifier of the original human
	@ID				as bigint = null	--##PARAM @ID A unique identifier of the human
)
as

-- TO DO: Criterion for idfRootParty

select		tlbHuman.idfHuman, 
			tlbHuman.idfHumanActual as idfRootHuman,
			dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName, tlbHuman.strSecondName)
			as PatientName,
			(ISNULL([Address].name, [Address].strDefault) + IsNull(', ' + tlbHuman.strHomePhone, '')) AS PatientInformation
from		tlbHuman

LEFT JOIN dbo.fnGeoLocationTranslation(@LangID) [Address] ON
	[Address].idfGeoLocation = tlbHuman.idfCurrentResidenceAddress

where		(@RootHumanID is null or @RootHumanID = tlbHuman.idfHumanActual)
			and (@ID is null or @ID = tlbHuman.idfHuman)
			AND tlbHuman.intRowStatus = 0




