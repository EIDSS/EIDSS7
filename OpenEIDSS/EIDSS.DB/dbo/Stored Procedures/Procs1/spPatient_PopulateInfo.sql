



--##SUMMARY Returns additional information about patient. Patient is searched in both tlbHuman and tlbHumanActual tables

--##REMARKS Author: Zurin M.
--##REMARKS 
--##REMARKS Update date: 21.09.2011


--##RETURNS Returns record additional information about patient. Patient is searched in both tlbHuman and tlbHumanActual tables


/*
Example of procedure call:
declare @LangID			nvarchar(50)
declare @ID				bigint

set @LangID = 'en'
exec spPatient_PopulateInfo
		@LangID, 
		@ID
*/


CREATE	procedure	[dbo].[spPatient_PopulateInfo]
(
	@LangID			as nvarchar(50),	--##PARAM Language Id
	@ID				as bigint	--##PARAM @ID A unique identifier of the human
)
as

select		tlbHuman.idfHuman, 
			tlbHuman.idfHumanActual as idfRootHuman,
			dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName, tlbHuman.strSecondName) as PatientName,
			(ISNULL([Address].name, [Address].strDefault) + IsNull(', ' + tlbHuman.strHomePhone, '')) as PatientInformation,
			geo.idfsRegion,
			geo.idfsRayon,
			geo.idfsSettlement,
			geo.idfsCountry,
			geo.strPostCode,
			geo.strStreetName,
			geo.strHouse,
			geo.strBuilding,
			geo.strApartment,
			tlbHuman.datDateofBirth,
			tlbHuman.idfsHumanGender,
			ISNULL([Address].name, [Address].strDefault) as strPatientAddressString,
			tlbHuman.idfsPersonIDType,
			tlbHuman.strPersonID


from		tlbHuman

LEFT JOIN dbo.fnGeoLocationTranslation(@LangID) [Address] ON
	[Address].idfGeoLocation = tlbHuman.idfCurrentResidenceAddress
LEFT JOIN dbo.tlbGeoLocation geo ON
	  tlbHuman.idfCurrentResidenceAddress = geo.idfGeoLocation

where		@ID = tlbHuman.idfHuman
			AND tlbHuman.intRowStatus = 0

union all 

select		tlbHumanActual.idfHumanActual as idfHuman, 
			NULL as  idfRootHuman,
			dbo.fnConcatFullName(tlbHumanActual.strLastName, tlbHumanActual.strFirstName, tlbHumanActual.strSecondName) as PatientName,
			(ISNULL([Address].name, [Address].strDefault) + IsNull(', ' + tlbHumanActual.strHomePhone, '')) as PatientInformation,
			geo.idfsRegion,
			geo.idfsRayon,
			geo.idfsSettlement,
			geo.idfsCountry,
			geo.strPostCode,
			geo.strStreetName,
			geo.strHouse,
			geo.strBuilding,
			geo.strApartment,
			tlbHumanActual.datDateofBirth,
			tlbHumanActual.idfsHumanGender,
			ISNULL([Address].name, [Address].strDefault) as strPatientAddressString,
			tlbHumanActual.idfsPersonIDType,
			tlbHumanActual.strPersonID

from		tlbHumanActual

LEFT JOIN dbo.fnGeoLocationSharedTranslation(@LangID) [Address] ON
	[Address].idfGeoLocationShared = tlbHumanActual.idfCurrentResidenceAddress
LEFT JOIN dbo.tlbGeoLocationShared geo ON
	  tlbHumanActual.idfCurrentResidenceAddress = geo.idfGeoLocationShared

where		@ID = tlbHumanActual.idfHumanActual
			AND tlbHumanActual.intRowStatus = 0




