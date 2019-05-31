

--##SUMMARY Returns the list of patients, contact persons and farm owners.
--##SUMMARY Used by PatientList form.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 25.01.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##RETURNS Function returns the list of patients, contact persons and farm owners


/*
--Example of a call of function:
select * from fn_Patient_SelectList ('en')

*/


CREATE	function	[dbo].[fn_Patient_SelectList]
(
	@LangID as nvarchar(50) --##PARAM @LangID  - language ID
)
returns table
as
return
select			idfHumanActual,
				strFirstName,
				strSecondName,
				strLastName,
				datDateofBirth,
				idfCurrentResidenceAddress,
				ISNULL([Address].name, [Address].strDefault) AS AddressName,
				idfsPersonIDType,
				strPersonID,
				datEnteredDate,
				datModificationDate,
				PersonIDType.name AS strPersonIDType,
				idfsHumanGender
from		tlbHumanActual

LEFT JOIN dbo.fnGeoLocationSharedTranslation(@LangID) [Address] ON
	[Address].idfGeoLocationShared = tlbHumanActual.idfCurrentResidenceAddress
LEFT JOIN dbo.fnReferenceRepair(@LangID, 19000148) PersonIDType ON
	PersonIDType.idfsReference = idfsPersonIDType

WHERE	tlbHumanActual.intRowStatus = 0
		AND 
		(
		ISNULL(tlbHumanActual.strFirstName,N'')<>N'' 
		OR ISNULL(tlbHumanActual.strSecondName,N'')<>N'' 
		OR ISNULL(tlbHumanActual.strLastName,N'')<>N''
		)


