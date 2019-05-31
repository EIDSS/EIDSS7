
--##SUMMARY Selects contact data for a specified human case.

--##REMARKS Author: Mirnaya O.
--##REMARKS Update date: 23.01.2010

--##REMARKS UPDATED BY: Shatilova T.
--##REMARKS Date: 21.09.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
declare	@idfCase	bigint

execute	spContactedCasePerson_SelectDetail
	@idfCase,
	'en'
*/



CREATE procedure	[dbo].[spContactedCasePerson_SelectDetail]
(		
	@idfCase	bigint,		--##PARAM @idfCase Case Id
	@LangID		nvarchar(50)	--##PARAM Language Id
)
as

  
-- 0 tlbContactedCasePerson  
select  tlbContactedCasePerson.idfContactedCasePerson,  
   tlbContactedCasePerson.idfHumanCase,  
   tlbContactedCasePerson.idfHuman,  
   tlbContactedCasePerson.idfsPersonContactType,  
   tlbContactedCasePerson.datDateOfLastContact,  
   tlbContactedCasePerson.strPlaceInfo,  
   tlbContactedCasePerson.strComments,
   tlbHuman.idfHumanActual as idfRootHuman,  
   dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName, tlbHuman.strSecondName) as strName,     
   tlbHuman.datDateofBirth,  
   trtBaseReference.strDefault as strPersonContactType,  
   (ISNULL([Address].name, [Address].strDefault) + IsNull(', ' + tlbHuman.strHomePhone, '')) AS strPatientInformation,  
   cast(0 as tinyint) as bitIsRootMain,
   geo.idfsRegion,
   geo.idfsRayon,
   geo.idfsSettlement,
   geo.idfsCountry,
   geo.strPostCode,
   geo.strStreetName,
   geo.strHouse,
   geo.strBuilding,
   geo.strApartment,
   tlbHuman.idfsHumanGender,
   ISNULL([Address].name, [Address].strDefault) as strPatientAddressString
   
from  tlbContactedCasePerson  
inner join tlbHumanCase  
on   tlbHumanCase.idfHumanCase = tlbContactedCasePerson.idfHumanCase  
   and tlbHumanCase.intRowStatus = 0  
INNER JOIN tlbHuman  
ON   tlbHuman.idfHuman = tlbContactedCasePerson.idfHuman  
   and tlbHuman.intRowStatus = 0  
inner join trtBaseReference  
on   tlbContactedCasePerson.idfsPersonContactType = trtBaseReference.idfsBaseReference  
LEFT JOIN dbo.fnGeoLocationTranslation(@LangID) [Address] ON  
 [Address].idfGeoLocation = tlbHuman.idfCurrentResidenceAddress  
LEFT JOIN dbo.tlbGeoLocation geo ON
	  tlbHuman.idfCurrentResidenceAddress = geo.idfGeoLocation
where  tlbContactedCasePerson.idfHumanCase = @idfCase  
   and tlbContactedCasePerson.intRowStatus = 0  
