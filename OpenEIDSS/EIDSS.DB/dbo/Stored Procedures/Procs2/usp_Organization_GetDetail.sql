
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		04/26/2017
-- Last modified by:		Joan Li
-- Description:				4/18/2017:Created based on V6 spOrganization_SelectDetail: rename for V7
--                          4/26/2017: changeV7  name:  usp_Organization_GetDetail
-- Testing code:
/*
----testing code:
DECLARE @idfOffice bigint
EXECUTE usp_Organization_GetDetail
	49860000000,
	'ru'
EXECUTE usp_Organization_GetDetail
	NULL,
	'en'
EXECUTE usp_Organization_GetDetail
	709230000000,
	'en'
	
*/

--=====================================================================================================
--##SUMMARY Selects data for OrganizationDetail form
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009
--##RETURNS Doesn't use

CREATE      PROCEDURE [dbo].[usp_Organization_GetDetail]

	@idfOffice AS BIGINT, --##PARAM @idfOffice - organization ID

	@LangID As nvarchar(50) --##PARAM @LangID - language ID

AS

	--0 Organization

	select 
	fn.idfOffice
	, fn.EnglishName
	, fn.EnglishFullName
	, fn.[name]
	, fn.FullName
	, fn.strContactPhone
	, fn.idfLocation
	, fn.intHACode
	, fn.strOrganizationID
	, fn.intOrder
	,tg.idfsCountry
	,tg.idfsRegion
	,tg.idfsRayon
	,tg.idfsSettlement
	,tg.idfsSite
	,tg.strPostCode
	,tg.strStreetName
	,tg.strHouse
	,tg.strBuilding
	,tg.blnForeignAddress
	,tg.strForeignAddress
	,tg.strAddressString
	,tg.[strShortAddressString]
	FROM 		dbo.fnInstitution(@LangID)  fn
	left outer join dbo.tlbGeoLocationShared tg
	on fn.idfLocation=tg.idfGeoLocationShared
	WHERE 		fn.idfOffice=@idfOffice



	--1 Departments

	SELECT  idfDepartment, @idfOffice as idfOrganization, DefaultName, [name] 
	FROM 			dbo.fnDepartment(@LangID) 
	WHERE 		idfInstitution=@idfOffice

	--2 Persons

	SELECT idfPerson
		  ,idfsStaffPosition
		  ,idfInstitution
		  ,idfDepartment
		  ,strFamilyName
		  ,strFirstName
		  ,strSecondName
		  ,strContactPhone
		  ,strBarcode
		  ,tlbEmployee.idfsSite
	  FROM tlbPerson
		INNER JOIN 
		tlbEmployee ON
		tlbPerson.idfPerson=tlbEmployee.idfEmployee
	WHERE 
		tlbPerson.idfInstitution=@idfOffice
		AND tlbEmployee.intRowStatus=0 
		AND tlbEmployee.idfsEmployeeType=10023002 --Person 






